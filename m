Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8031514FDD
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 17:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378638AbiD2Put (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 11:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344098AbiD2Puq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 11:50:46 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2685B338AD
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 08:47:28 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id h12so7462090plf.12
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 08:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iCUK1LSV6JY2TxjqIMT13v0Q2njg8arsbOECVMPDTe8=;
        b=UU82lj+UDf3qE2hjsMeMpKWFqqpXknjI+WYABj/bid9QZ/GbKsy82cu9h/dFkn/rvL
         idTcJ7d8LDH5pGhKpfk8LbO487lCUHd1bMIOf+mt1qnk+5P0U/Wfpd+Sr4a67SnKTnmY
         NT/IxSoUNkB8PdYv42YFHUHr3q/IbWVWhlwVWYBBhBH39uCtpPuZLCTxJrJ0idnMK3FV
         AN8AMUmWZTSXhM8AHjmx7I4CbuhMNV0H3SM/N+XgLPvB0Q9JnLFwJIsxOGfTHdJFIzbY
         y4+4yf7rYeT9jOi9UyuJXLrCYLzYvZ9HbQmWAzN+ZEkjCJreccTHnwwFX4a6b21jpOe7
         HG2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iCUK1LSV6JY2TxjqIMT13v0Q2njg8arsbOECVMPDTe8=;
        b=FExTDoF/clioFfJrPBZd/vhsuaPSAFdm7FrvJB91kgRSVzVLlH3xQBFA4wugsNPGNX
         1JtDaav43ijN5HxOBM0Jt9tQZ3M9bolXaIJtydOww+H2ArWCV3gVprmyTcK0p6zm1bkD
         L3kvc8BYyKTGTylrJNjwOqbok1sWDX3PIPaTXZiVs18jIlSlAJgUo0oPNYGRz5nPn3TI
         DGPb+xKxKw1nzLRfBKQV4d/0cGXrhOmMwokLTKD2OJ0wNZ0P8RiYpZ8l3nm1jncDS3US
         oVJAJpfYZ7UWtyoIipg57ihEE5f/fVs97GQe1au2WXOkqIUzwzzLZ9sj/MZ4tN+Ntse8
         BxJQ==
X-Gm-Message-State: AOAM530zzl5h6iNe3zu42TonsXWMbkmIDEAsh/tA0eRUQYJJ73GAXu0B
        EuSJUkL7EWteiV/b7O5mm4szow==
X-Google-Smtp-Source: ABdhPJySzMqDgCWEhR8/Z3PgM+ZbPAcAgWTYdET9X7J7eBJiw4ujFZg7aoJDE8vi0ylFucOhVZ/ltQ==
X-Received: by 2002:a17:902:8a95:b0:156:a40a:71e5 with SMTP id p21-20020a1709028a9500b00156a40a71e5mr37552plo.144.1651247247467;
        Fri, 29 Apr 2022 08:47:27 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g15-20020aa7818f000000b00505ce2e4640sm3414578pfi.100.2022.04.29.08.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 08:47:26 -0700 (PDT)
Date:   Fri, 29 Apr 2022 15:47:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: fix potential races when walking host page
 table
Message-ID: <YmwIi3bXr/1yhYV/@google.com>
References: <20220429031757.2042406-1-mizhang@google.com>
 <4b0936bf-fd3e-950a-81af-fd393475553f@redhat.com>
 <Ymv3vwBEgCH0CMPH@google.com>
 <67222fe0-7bf0-ec7a-0791-a4d48391a15e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67222fe0-7bf0-ec7a-0791-a4d48391a15e@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022, Paolo Bonzini wrote:
> On 4/29/22 16:35, Sean Christopherson wrote:
> > On Fri, Apr 29, 2022, Paolo Bonzini wrote:
> > > > +out:
> > > > +	local_irq_restore(flags);
> > > > +	return level;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(kvm_lookup_address_level_in_mm);
> > > 
> > > Exporting is not needed.
> > > 
> > > Thanks for writing the walk code though.  I'll adapt it and integrate the
> > > patch.
> > 
> > But why are we fixing this only in KVM?  I liked the idea of stealing perf's
> > implementation because it was a seemlingly perfect fit and wouldn't introduce
> > new code (ignoring wrappers, etc...).
> > 
> > We _know_ that at least one subsystem is misusing lookup_address_in_pgd() and
> > given that its wrappers are exported, I highly doubt KVM is the only offender.
> > It really feels like we're passing the buck here by burying the fix in KVM.
> 
> There are two ways to do it:
> 
> * having a generic function in mm/.  The main issue there is the lack of a
> PG_LEVEL_{P4D,PUD,PMD,PTE} enum at the mm/ level.  We could use (ctz(x) -
> 12) / 9 to go from size to level, but it's ugly and there could be
> architectures with heterogeneous page table sizes.
> 
> * having a generic function in arch/x86/.  In this case KVM seems to be the
> odd one that doesn't need the PTE.  For example vc_slow_virt_to_phys needs
> the PTE, and needs the size rather than the "level" per se.
> 
> So for now I punted, while keeping open the door for moving code from
> arch/x86/kvm/ to mm/ if anyone else (even other KVM ports) need the same
> logic.

Ugh.  I was going to say that KVM is the only in-tree user that's subtly broken,
but then I saw vc_slow_virt_to_phys()...  So there's at least one other use case
for walking user addresses and being able to tolerate a not-present mapping.

There are no other users of lookup_address_in_mm(), and other than SEV-ES's
dastardly use of lookup_address_in_pgd(), pgd can only ever come from init_mm or
efi_mm, i.e. can't work with user address anyways.

If we go the KVM-only route, can send the below revert along with it?  The least
we can do is not give others an easy way to screw up.

Until I saw the #VC crud, I was hoping we could also explicitly prevent using
lookup_address_in_pgd() with user addresses.  If/when #VC is fixed, we can/should
add this:

@@ -592,6 +592,15 @@ pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,

 	*level = PG_LEVEL_NONE;

+	/*
+	 * The below walk does not guard against user page tables being torn
+	 * down, attempting to walk a user address is dangerous and likely to
+	 * explode sooner or later.  This helper is intended only for use with
+	 * kernel-only mm_structs, e.g. init_mm and efi_mm.
+	 */
+	if (WARN_ON_ONCE(address < TASK_SIZE_MAX))
+		return NULL;
+


From: Sean Christopherson <seanjc@google.com>
Date: Fri, 29 Apr 2022 07:57:53 -0700
Subject: [PATCH] Revert "x86/mm: Introduce lookup_address_in_mm()"

Drop lookup_address_in_mm() now that KVM is providing it's own variant
of lookup_address_in_pgd() that is safe for use with user addresses, e.g.
guards against page tables being torn down.  A variant that provides a
non-init mm is inherently dangerous and flawed, as the only reason to use
an mm other than init_mm is to walk a userspace mapping, and
lookup_address_in_pgd() does not play nice with userspace mappings, e.g.
doesn't disable IRQs to block TLB shootdowns and doesn't use READ_ONCE()
to ensure an upper level entry isn't converted to a huge page between
checking the PAGE_SIZE bit and grabbing the address of the next level
down.

This reverts commit 13c72c060f1ba6f4eddd7b1c4f52a8aded43d6d9.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/pgtable_types.h |  4 ----
 arch/x86/mm/pat/set_memory.c         | 11 -----------
 2 files changed, 15 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 40497a9020c6..407084d9fd99 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -559,10 +559,6 @@ static inline void update_page_count(int level, unsigned long pages) { }
 extern pte_t *lookup_address(unsigned long address, unsigned int *level);
 extern pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
 				    unsigned int *level);
-
-struct mm_struct;
-extern pte_t *lookup_address_in_mm(struct mm_struct *mm, unsigned long address,
-				   unsigned int *level);
 extern pmd_t *lookup_pmd_address(unsigned long address);
 extern phys_addr_t slow_virt_to_phys(void *__address);
 extern int __init kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn,
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index abf5ed76e4b7..0656db33574d 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -638,17 +638,6 @@ pte_t *lookup_address(unsigned long address, unsigned int *level)
 }
 EXPORT_SYMBOL_GPL(lookup_address);

-/*
- * Lookup the page table entry for a virtual address in a given mm. Return a
- * pointer to the entry and the level of the mapping.
- */
-pte_t *lookup_address_in_mm(struct mm_struct *mm, unsigned long address,
-			    unsigned int *level)
-{
-	return lookup_address_in_pgd(pgd_offset(mm, address), address, level);
-}
-EXPORT_SYMBOL_GPL(lookup_address_in_mm);
-
 static pte_t *_lookup_address_cpa(struct cpa_data *cpa, unsigned long address,
 				  unsigned int *level)
 {

base-commit: 6f363ed2fa4c24c400acc29b659c96e4dc7930e8
--



