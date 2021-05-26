Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAFD391435
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 11:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbhEZJ73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 05:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbhEZJ72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 05:59:28 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FA0C061574;
        Wed, 26 May 2021 02:57:57 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0d49009660c40ecb662901.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:4900:9660:c40e:cb66:2901])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 24D731EC00F8;
        Wed, 26 May 2021 11:57:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1622023076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ZYec1RD/pAYHWEfyt3NxEqaQmOs6KRO4H8TlOe6OKwU=;
        b=qMRf+0ia2MF62yECVGrkUp8oRx+DLq3UpYfSEZKePqrHhSEwYGZBHCnEAxbdBAlzCMdwBR
        OdTbM3ld8Zm+utIu3IWe6eUAp/RwzRRBu4ToGhjlNrBB7W2Qh3ZYwePXxeCWka0RdBxE1I
        rhGg7P/KRRtAC5HS39qmIRuwQKOzx94=
Date:   Wed, 26 May 2021 11:57:49 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 13/20] x86/sev: Register GHCB memory when
 SEV-SNP is active
Message-ID: <YK4bnQiJ6cVzCCE9@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-14-brijesh.singh@amd.com>
 <YKzbfwD6nHL7ChcJ@zn.tnic>
 <b15cd25b-ee69-237d-9044-84fba2cf4bb2@amd.com>
 <YK0LFk3xMjfirG9E@zn.tnic>
 <9e7b7406-ec24-2991-3577-ce7da61a61ca@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9e7b7406-ec24-2991-3577-ce7da61a61ca@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021 at 09:47:24AM -0500, Brijesh Singh wrote:
> Maybe I should have said, its not applicable in the decompressed path.

Aha, ok. How's that, ontop of yours:

---
diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 07b9529d7d95..c9dd98b9dcdf 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -208,7 +208,7 @@ static bool early_setup_sev_es(void)
 
 	/* SEV-SNP guest requires the GHCB GPA must be registered */
 	if (sev_snp_enabled())
-		snp_register_ghcb(__pa(&boot_ghcb_page));
+		snp_register_ghcb_early(__pa(&boot_ghcb_page));
 
 	return true;
 }
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 37a23c524f8c..7200f44d6b6b 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -81,7 +81,7 @@ static bool ghcb_get_hv_features(void)
 	return true;
 }
 
-static void snp_register_ghcb(unsigned long paddr)
+static void snp_register_ghcb_early(unsigned long paddr)
 {
 	unsigned long pfn = paddr >> PAGE_SHIFT;
 	u64 val;
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 5544557d9fb6..144c20479cae 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -108,7 +108,18 @@ DEFINE_STATIC_KEY_FALSE(sev_es_enable_key);
 void do_early_exception(struct pt_regs *regs, int trapnr);
 
 /* Defined in sev-shared.c */
-static void snp_register_ghcb(unsigned long paddr);
+static void snp_register_ghcb_early(unsigned long paddr);
+
+static void snp_register_ghcb(struct sev_es_runtime_data *data,
+			      unsigned long paddr)
+{
+	if (data->snp_ghcb_registered)
+		return;
+
+	snp_register_ghcb_early(paddr);
+
+	data->snp_ghcb_registered = true;
+}
 
 static void __init setup_vc_stacks(int cpu)
 {
@@ -239,10 +250,8 @@ static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
 	}
 
 	/* SEV-SNP guest requires that GHCB must be registered before using it. */
-	if (sev_snp_active() && !data->snp_ghcb_registered) {
-		snp_register_ghcb(__pa(ghcb));
-		data->snp_ghcb_registered = true;
-	}
+	if (sev_snp_active())
+		snp_register_ghcb(data, __pa(ghcb));
 
 	return ghcb;
 }
@@ -681,7 +690,7 @@ static bool __init sev_es_setup_ghcb(void)
 
 	/* SEV-SNP guest requires that GHCB GPA must be registered */
 	if (sev_snp_active())
-		snp_register_ghcb(__pa(&boot_ghcb_page));
+		snp_register_ghcb_early(__pa(&boot_ghcb_page));
 
 	return true;
 }

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
