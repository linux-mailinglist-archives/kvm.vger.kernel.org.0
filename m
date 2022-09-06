Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5545AE552
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 12:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239562AbiIFK07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 06:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239224AbiIFK0V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 06:26:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009EA627B;
        Tue,  6 Sep 2022 03:25:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C2F461483;
        Tue,  6 Sep 2022 10:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475E7C433D6;
        Tue,  6 Sep 2022 10:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662459910;
        bh=fwdWXxkOf6zObdpX0HJXuD+AM10SlVrcgsu8arlimOY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I4vqn6fRvpLmiK+9XggeElm/6brM7RrBg3cG40WM+1bkNPPcmJfhVUAb49TkfniC0
         XPzBWsHGEiciIt7g+d28/sqf5bVQ2095mLIy4OxV+Q+1oQCpcwiyvfuhJORifZrGHk
         QSHUhJsmFGoQkukjOeDA77hAuz2UbnXWTAaY6c0OIk+ja24XqYmi2fuWb7t3Rz47wy
         DqbaWdTioguMGY4a+uJt/EuGsCkYiOA7+33IKVxqzZUL7dMsCRagbbswpjyONxz/MA
         zS+97k8SHoaLObL7HkjBbB3ogxOAQhiHPXET4r0h4OvwCWiwpH4CQTRRZZAZS0/Hli
         6lNOSxYpCQHgg==
Date:   Tue, 6 Sep 2022 13:25:06 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com
Subject: Re: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Message-ID: <YxcgAk7AHWZVnSCJ@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
 <YvKRjxgipxLSNCLe@zn.tnic>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="R9s2JRGVgaAiidpN"
Content-Disposition: inline
In-Reply-To: <YvKRjxgipxLSNCLe@zn.tnic>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--R9s2JRGVgaAiidpN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 09, 2022 at 06:55:43PM +0200, Borislav Petkov wrote:
> On Mon, Jun 20, 2022 at 11:03:43PM +0000, Ashish Kalra wrote:
> > +	pfn = pte_pfn(*pte);
> > +
> > +	/* If its large page then calculte the fault pfn */
> > +	if (level > PG_LEVEL_4K) {
> > +		unsigned long mask;
> > +
> > +		mask = pages_per_hpage(level) - pages_per_hpage(level - 1);
> > +		pfn |= (address >> PAGE_SHIFT) & mask;
> 
> Oh boy, this is unnecessarily complicated. Isn't this
> 
> 	pfn |= pud_index(address);
> 
> or
> 	pfn |= pmd_index(address);

I played with this a bit and ended up with

        pfn = pte_pfn(*pte) | PFN_DOWN(address & page_level_mask(level - 1));

Unless I got something terribly wrong, this should do the
same (see the attached patch) as the existing calculations.

BR, Jarkko

--R9s2JRGVgaAiidpN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-x86-fault-Simplify-PFN-calculation-in-handle_user_rm.patch"

From c92522f6199055cd609ddd785dc9d8e85153e3b4 Mon Sep 17 00:00:00 2001
From: Jarkko Sakkinen <jarkko@profian.com>
Date: Tue, 6 Sep 2022 09:51:59 +0300
Subject: [PATCH] x86/fault: Simplify PFN calculation in
 handle_user_rmp_fault()

Use functions in asm/pgtable.h to calculate the PFN for the address inside
PTE's page directory. PG_LEVEL_4K PTE's obviously do not have a page
directory but it is not an issue as:

	page_level_mask(PG_LEVEL_4K - 1) ==
	page_level_mask(PG_LEVEL_NONE) ==
	0

Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
---
 arch/x86/mm/fault.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 6404ef73eb56..28b3f80611a3 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1219,11 +1219,6 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
 }
 NOKPROBE_SYMBOL(do_kern_addr_fault);
 
-static inline size_t pages_per_hpage(int level)
-{
-	return page_level_size(level) / PAGE_SIZE;
-}
-
 /*
  * Return 1 if the caller need to retry, 0 if it the address need to be split
  * in order to resolve the fault.
@@ -1248,15 +1243,8 @@ static int handle_user_rmp_page_fault(struct pt_regs *regs, unsigned long error_
 	if (!pte || !pte_present(*pte))
 		return 1;
 
-	pfn = pte_pfn(*pte);
-
-	/* If its large page then calculte the fault pfn */
-	if (level > PG_LEVEL_4K) {
-		unsigned long mask;
-
-		mask = pages_per_hpage(level) - pages_per_hpage(level - 1);
-		pfn |= (address >> PAGE_SHIFT) & mask;
-	}
+	/*  Calculate PFN inside the page directory: */
+	pfn = pte_pfn(*pte) | PFN_DOWN(address & page_level_mask(level - 1));
 
 	/*
 	 * If its a guest private page, then the fault cannot be resolved.
-- 
2.37.2


--R9s2JRGVgaAiidpN--
