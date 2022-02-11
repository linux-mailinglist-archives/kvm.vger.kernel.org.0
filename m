Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073C54B2D1C
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 19:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352842AbiBKSsm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 13:48:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351880AbiBKSsW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 13:48:22 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C29CB99
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 10:48:21 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id r19so17808071pfh.6
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 10:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0XmzL5RaQUZt/z3r7pFmLRNQ5yEmC34fzBg1mybU69c=;
        b=Jaw6GF/QPbVAzySpvc0CTHUkc+O0meQHjD5+Ng4b83Oz1c+i7A9NfsGnCaGE5Yaqxj
         hNWzl5mLpVjA19F/rkEt7gxrnefVW1MjKDUExKk3VYy2r1LNR1vD0+GgBEfDrX7yD+kh
         EVirqZcrXGNZftWckOT8nWnlf0uLlB8q0XnO3cEy7souEnWICJzb4X4pcmJKVy5GrWnW
         1S9+ePfDSDwBf36w2JSX2MvsKtPmjk4fVtBF3EnI6v8YJtZ2zvvNB20uI8B2PB3xnPpW
         xg8/2Ep0Grki+uNCmVH3R2sMeommdnOS5Wx6sgAxibTAhVsdkZgAImACBVzR+14mc/ug
         uuHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0XmzL5RaQUZt/z3r7pFmLRNQ5yEmC34fzBg1mybU69c=;
        b=LVG/q2EVE0u774N7XbAZXb8xnxvPgEFTVcaWIXjSftRFV8IJsWNfCJBkCzVr0kMm/h
         wfGDsdHe3vdkm4zKLaoFXQGJBARihNDVy41pB7ueryqFsz7XeBdr4aiVsC3ruNqWhlIh
         sv1z3qByZfKFlzrbQPJx6rJ+6S7cN+6lNRZEQ13vxJi3ozx946WSqg7V1+VJ0pBwSg66
         WSPQCoK3EPE3MOmY1IUwg+cwgjOB2J7y8uXlea6R8UY1EaPhidzN6USaarfl2pNXXskD
         9FmAqngAaF2wCdAUKik4WwjTc6/AX2RnvuXYiEUP5+T6964TmdlmlsK4vecuCzNyp/po
         92lw==
X-Gm-Message-State: AOAM533qR5bICXEoB7VtvaGMMXCI1Lsu+J2ePePRMrFR/swdwsfzp0sA
        P1Z+Lb7e2qbRRGxoSe80FS+CLA==
X-Google-Smtp-Source: ABdhPJxzv8KvXp0iNRLnAZCurRS8gxgMAz84WbGW9LLIQy08pgqXVFMpwxebW8BHbEmRSEpqNxgCRg==
X-Received: by 2002:a63:190d:: with SMTP id z13mr2458077pgl.430.1644605300373;
        Fri, 11 Feb 2022 10:48:20 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s17sm26783225pfk.156.2022.02.11.10.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 10:48:19 -0800 (PST)
Date:   Fri, 11 Feb 2022 18:48:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
Subject: Re: [PATCH 12/12] KVM: x86: do not unload MMU roots on all role
 changes
Message-ID: <YgavcP/jb5njjKKn@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-13-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209170020.1775368-13-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 09, 2022, Paolo Bonzini wrote:
> kvm_mmu_reset_context is called on all role changes and right now it
> calls kvm_mmu_unload.  With the legacy MMU this is a relatively cheap
> operation; the previous PGDs remains in the hash table and is picked
> up immediately on the next page fault.  With the TDP MMU, however, the
> roots are thrown away for good and a full rebuild of the page tables is
> necessary, which is many times more expensive.
> 
> Fortunately, throwing away the roots is not necessary except when
> the manual says a TLB flush is required:
> 
> - changing CR0.PG from 1 to 0 (because it flushes the TLB according to
>   the x86 architecture specification)
> 
> - changing CPUID (which changes the interpretation of page tables in
>   ways not reflected by the role).
> 
> - changing CR4.SMEP from 0 to 1 (not doing so actually breaks access.c!)
> 
> Except for these cases, once the MMU has updated the CPU/MMU roles
> and metadata it is enough to force-reload the current value of CR3.
> KVM will look up the cached roots for an entry with the right role and
> PGD, and only if the cache misses a new root will be created.
> 
> Measuring with vmexit.flat from kvm-unit-tests shows the following
> improvement:
> 
>              TDP         legacy       shadow
>    before    46754       5096         5150
>    after     4879        4875         5006
> 
> which is for very small page tables.  The impact is however much larger
> when running as an L1 hypervisor, because the new page tables cause
> extra work for L0 to shadow them.
> 
> Reported-by: Brad Spengler <spender@grsecurity.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c |  7 ++++---
>  arch/x86/kvm/x86.c     | 27 ++++++++++++++++++---------
>  2 files changed, 22 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 38b40ddcaad7..dbd4e98ba426 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5020,8 +5020,8 @@ EXPORT_SYMBOL_GPL(kvm_init_mmu);
>  void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	/*
> -	 * Invalidate all MMU roles to force them to reinitialize as CPUID
> -	 * information is factored into reserved bit calculations.
> +	 * Invalidate all MMU roles and roots to force them to reinitialize,
> +	 * as CPUID information is factored into reserved bit calculations.
>  	 *
>  	 * Correctly handling multiple vCPU models with respect to paging and
>  	 * physical address properties) in a single VM would require tracking
> @@ -5034,6 +5034,7 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	vcpu->arch.root_mmu.mmu_role.ext.valid = 0;
>  	vcpu->arch.guest_mmu.mmu_role.ext.valid = 0;
>  	vcpu->arch.nested_mmu.mmu_role.ext.valid = 0;
> +	kvm_mmu_unload(vcpu);
>  	kvm_mmu_reset_context(vcpu);
>  
>  	/*
> @@ -5045,8 +5046,8 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  
>  void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
>  {
> -	kvm_mmu_unload(vcpu);
>  	kvm_init_mmu(vcpu);
> +	kvm_mmu_new_pgd(vcpu, vcpu->arch.cr3);

This is too risky IMO, there are far more flows than just MOV CR0/CR4 that are
affected, e.g. SMM transitions, KVM_SET_SREG, etc...

Given that kvm_post_set_cr{0,4}() and kvm_vcpu_reset() explicitly handle CR0.PG
and CR4.SMEP toggling, I highly doubt the other flows are correct in all instances.
The call to kvm_mmu_new_pgd() is also 

To minimize risk, we should leave kvm_mmu_reset_context() as is (rename it if
necessary) and instead add a new helper to handle kvm_post_set_cr{0,4}().  In
the future we can/should work on avoiding unload in all paths, but again, future
problem.

>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_reset_context);
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0d3646535cc5..97c4f5fc291f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -873,8 +873,12 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
>  		kvm_async_pf_hash_reset(vcpu);
>  	}
>  
> -	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
> +	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS) {
> +		/* Flush the TLB if CR0 is changed 1 -> 0.  */
> +		if ((old_cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PG))
> +			kvm_mmu_unload(vcpu);

Calling kvm_mmu_unload() instead of requesting a flush isn't coherent with respect
to the comment, or with SMEP handling.  And the SMEP handling isn't coherent with
respect to the changelog.  Please elaborate :-)

>  		kvm_mmu_reset_context(vcpu);
> +	}
>  
>  	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
>  	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
> @@ -1067,15 +1071,18 @@ void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned lon
>  	 * free them all.  KVM_REQ_MMU_RELOAD is fit for the both cases; it
>  	 * is slow, but changing CR4.PCIDE is a rare case.
>  	 *
> -	 * If CR4.PGE is changed, the guest TLB must be flushed.
> +	 * Setting SMEP also needs to flush the TLB, in addition to resetting
> +	 * the MMU.
>  	 *
> -	 * Note: resetting MMU is a superset of KVM_REQ_MMU_RELOAD and
> -	 * KVM_REQ_MMU_RELOAD is a superset of KVM_REQ_TLB_FLUSH_GUEST, hence
> -	 * the usage of "else if".
> +	 * If CR4.PGE is changed, the guest TLB must be flushed.  Because
> +	 * the shadow MMU ignores global pages, this bit is not part of
> +	 * KVM_MMU_CR4_ROLE_BITS.
>  	 */
> -	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
> +	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS) {
>  		kvm_mmu_reset_context(vcpu);
> -	else if ((cr4 ^ old_cr4) & X86_CR4_PCIDE)
> +		if ((cr4 & X86_CR4_SMEP) && !(old_cr4 & X86_CR4_SMEP))
> +			kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);

This mishandles CR4.PGE.  Per the comment above, the if-elif-elif sequence relies
on kvm_mmu_reset_context being a superset of KVM_REQ_TLB_FLUSH_GUEST.

For both CR0 and CR4, I think we should disassociate the TLB flush logic from the
MMU role logic, e.g. CR4.PGE _could_ be part of the role, but it's not because KVM
doesn't emulate global pages.

This is what I'm thinking, assuming CR0.PG 1=>0 really only needs a flush.


---
 arch/x86/kvm/mmu/mmu.c |  4 ++--
 arch/x86/kvm/x86.c     | 42 +++++++++++++++++++++++++++++-------------
 2 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e41834748d52..c477c519c784 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5041,8 +5041,8 @@ EXPORT_SYMBOL_GPL(kvm_init_mmu);
 void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	/*
-	 * Invalidate all MMU roles to force them to reinitialize as CPUID
-	 * information is factored into reserved bit calculations.
+	 * Invalidate all MMU roles and roots to force them to reinitialize,
+	 * as CPUID information is factored into reserved bit calculations.
 	 *
 	 * Correctly handling multiple vCPU models with respect to paging and
 	 * physical address properties) in a single VM would require tracking
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 782dc9cd31d8..b8dad04301ee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -863,15 +863,28 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 }
 EXPORT_SYMBOL_GPL(load_pdptrs);

+static void kvm_post_set_cr_reinit_mmu(struct kvm_vcpu *vcpu)
+{
+	kvm_mmu_init(vcpu);
+	kvm_mmu_new_pgd(vcpu, vcpu->arch.cr3);
+}
+
 void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0)
 {
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
 		kvm_clear_async_pf_completion_queue(vcpu);
 		kvm_async_pf_hash_reset(vcpu);
+
+		/*
+		 * Clearing CR0.PG is architecturally defined as flushing the
+		 * TLB from the guest's perspective.
+		 */
+		if (!(cr0 & X86_CR0_PG))
+			kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 	}

 	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
-		kvm_mmu_reset_context(vcpu);
+		kvm_post_set_cr_reinit_mmu(vcpu);

 	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
 	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
@@ -1055,26 +1068,29 @@ EXPORT_SYMBOL_GPL(kvm_is_valid_cr4);
 void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
 {
 	/*
-	 * If any role bit is changed, the MMU needs to be reset.
-	 *
 	 * If CR4.PCIDE is changed 1 -> 0, the guest TLB must be flushed.
 	 * If CR4.PCIDE is changed 0 -> 1, there is no need to flush the TLB
 	 * according to the SDM; however, stale prev_roots could be reused
 	 * incorrectly in the future after a MOV to CR3 with NOFLUSH=1, so we
 	 * free them all.  KVM_REQ_MMU_RELOAD is fit for the both cases; it
 	 * is slow, but changing CR4.PCIDE is a rare case.
-	 *
-	 * If CR4.PGE is changed, the guest TLB must be flushed.
-	 *
-	 * Note: resetting MMU is a superset of KVM_REQ_MMU_RELOAD and
-	 * KVM_REQ_MMU_RELOAD is a superset of KVM_REQ_TLB_FLUSH_GUEST, hence
-	 * the usage of "else if".
 	 */
-	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
-		kvm_mmu_reset_context(vcpu);
-	else if ((cr4 ^ old_cr4) & X86_CR4_PCIDE)
+	if ((cr4 ^ old_cr4) & X86_CR4_PCIDE) {
 		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
-	else if ((cr4 ^ old_cr4) & X86_CR4_PGE)
+		return;
+	}
+
+	/* If any role bit is changed, the MMU needs to be reinitialized. */
+	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
+		kvm_post_set_cr_reinit_mmu(vcpu);
+
+	/*
+	 * Setting SMEP or toggling PGE is architecturally defined as flushing
+	 * the TLB from the guest's perspective.  Note, because the shadow MMU
+	 * ignores global pages, CR4.PGE is not part of KVM_MMU_CR4_ROLE_BITS.
+	 */
+	if (((cr4 ^ old_cr4) & X86_CR4_PGE) ||
+	    ((cr4 & X86_CR4_SMEP) && !(old_cr4 & X86_CR4_SMEP)))
 		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_post_set_cr4);

base-commit: a8c36d04d70d0b15e696561e1a2134fcbdd3a3bd
--

