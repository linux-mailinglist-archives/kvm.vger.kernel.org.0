Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D60366D39
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 15:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242958AbhDUNwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 09:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242941AbhDUNwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 09:52:42 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040FDC06174A;
        Wed, 21 Apr 2021 06:52:08 -0700 (PDT)
Received: from zn.tnic (p200300ec2f10df00c08862b6cef04697.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:df00:c088:62b6:cef0:4697])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4A8541EC04E2;
        Wed, 21 Apr 2021 15:52:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1619013127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=HqxE5N3sP/txCrahPGWJxhvchsMgTH3wZVgCwlxfs2M=;
        b=JuI+6d+rle5ZhHn3SatO6CuwvO9MEMRVGn0FOUNktKYcNfPfu5jVUL36Ib8EM7y93zs60k
        E18/9m/WNiyAfv0onzVNe6u1yOHwWoHf8kGdzptVINA1dYCVGh6YrOt+0jha2sabxoZQH9
        CLQHHCAk8zdx820wCzRUpLGBMyPt5tA=
Date:   Wed, 21 Apr 2021 15:52:10 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH v13 09/12] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <20210421134924.GB11234@zn.tnic>
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <f2340642c5b8d597a099285194fca8d05c9843bd.1618498113.git.ashish.kalra@amd.com>
 <20210421100508.GA11234@zn.tnic>
 <20210421121213.GA14004@ashkalra_ubuntu_server>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210421121213.GA14004@ashkalra_ubuntu_server>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021 at 12:12:13PM +0000, Ashish Kalra wrote:
> Yes, both have some common code, but it is only this page level/size
> ...

See below for what I mean. Diff ontop of yours.

> I see that early_set_memory_enc_dec() is also using a for loop, so which
> patches are you referring to ?

The SNP guest set has this pattern:

https://lkml.kernel.org/r/20210408114049.GI10192@zn.tnic

---

diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index b1d59d2b3bf6..e823645101ee 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -232,6 +232,37 @@ void __init sev_setup_arch(void)
 	swiotlb_adjust_size(size);
 }
 
+static unsigned long pg_level_to_pfn(int level, pte_t *kpte, pgprot_t *ret_prot)
+{
+	unsigned long pfn = 0;
+	pgprot_t prot;
+
+	switch (level) {
+	case PG_LEVEL_4K:
+		pfn = pte_pfn(*kpte);
+		prot = pte_pgprot(*kpte);
+		break;
+
+	case PG_LEVEL_2M:
+		pfn = pmd_pfn(*(pmd_t *)kpte);
+		prot = pmd_pgprot(*(pmd_t *)kpte);
+		break;
+
+	case PG_LEVEL_1G:
+		pfn = pud_pfn(*(pud_t *)kpte);
+		prot = pud_pgprot(*(pud_t *)kpte);
+		break;
+
+	default:
+		return 0;
+	}
+
+	if (ret_prot)
+		*ret_prot = prot;
+
+	return pfn;
+}
+
 static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,
 					bool enc)
 {
@@ -249,19 +280,9 @@ static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,
 		if (!kpte || pte_none(*kpte))
 			return;
 
-		switch (level) {
-		case PG_LEVEL_4K:
-			pfn = pte_pfn(*kpte);
-			break;
-		case PG_LEVEL_2M:
-			pfn = pmd_pfn(*(pmd_t *)kpte);
-			break;
-		case PG_LEVEL_1G:
-			pfn = pud_pfn(*(pud_t *)kpte);
-			break;
-		default:
-			return;
-		}
+		pfn = pg_level_to_pfn(level, kpte, NULL);
+		if (!pfn)
+			continue;
 
 		psize = page_level_size(level);
 		pmask = page_level_mask(level);
@@ -279,22 +300,9 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
 	unsigned long pfn, pa, size;
 	pte_t new_pte;
 
-	switch (level) {
-	case PG_LEVEL_4K:
-		pfn = pte_pfn(*kpte);
-		old_prot = pte_pgprot(*kpte);
-		break;
-	case PG_LEVEL_2M:
-		pfn = pmd_pfn(*(pmd_t *)kpte);
-		old_prot = pmd_pgprot(*(pmd_t *)kpte);
-		break;
-	case PG_LEVEL_1G:
-		pfn = pud_pfn(*(pud_t *)kpte);
-		old_prot = pud_pgprot(*(pud_t *)kpte);
-		break;
-	default:
+	pfn = pg_level_to_pfn(level, kpte, &old_prot);
+	if (!pfn)
 		return;
-	}
 
 	new_prot = old_prot;
 	if (enc)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
