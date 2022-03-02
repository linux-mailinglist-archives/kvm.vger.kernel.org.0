Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF5D4CAEFC
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 20:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242054AbiCBTqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 14:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiCBTqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 14:46:45 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802C6D76C9
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 11:46:01 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id 9so2484009pll.6
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 11:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=9hoQOflL7uM4xfBgSnRuAr/fAj7IsoIbe4YLdOqGOIE=;
        b=Tn6GSfmSBgJBb5X41q36CFdKU/0C3jy0UYwj3XxvioDPZ3n3S/GjzLKU9D682eBqA8
         8hfcWx4BMlBs9or39CjegMw+dN2rl/LDib7yuxAPhESIDo/AvrAi8F3BKDRoDERml4U7
         hmcLjN8kCj7jU2Tnq+mVXoOBXrYGNhAUfpPSjBK0/BF3TXvdTxN+2DTwb3JMq5cPMLXx
         TM2mYng6iLCgwmHhQrHBfsDJ/EvDFX7LgesM3Lw7nuUjpMBBsRL69KFCASLsakdBp2X0
         B15MixNW06q6emtVoplnM9NpeMi0GQmbtlHhsvrtJAkCSvWk93V3QdC813C+ddtRb6dd
         mKLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9hoQOflL7uM4xfBgSnRuAr/fAj7IsoIbe4YLdOqGOIE=;
        b=wr32X4E3i6x0VgPS8hIUVlKv3zXzLJbusi2Rja24PZ5sfPjqzURmBDQvgV75AbrbZ+
         k23QwELagSAGL7HzDMqOvEVvEHBMBcoj5DD7QBa9lIw6L2Hz2/lojgFli9ckUFojw64t
         mDsrXMqlTUmEDXTJjudmErSziW4u074nN5g5dEqPZvosmb4hqZ5ejKY2IrJO2tXAuoGq
         3VV1LOmfIFH9NIb0TIKJpMUbJl2WehsQMoElC/WeofcTOA1HVd+SGnRwNXy5ldPlV5Nf
         D5/0Uexv9PUG5T6Q+8OSqyFIr/2WtgtzRYKPAVyr58yMq+2AI8XtaCvCEbSfEkHprDLm
         V7WQ==
X-Gm-Message-State: AOAM530IDQ4QmcNUCuHZJ8w/B3XD2pCJHDH5TOhGk09vaLtl87TazOus
        wCtgYXwnpjangBFzRllTADHTow==
X-Google-Smtp-Source: ABdhPJwRVw5B6+6EBXKXQuDzZAx3uY6c3J2/lvPWF3cDk112d15SdznYYDdhQOyv1j5ezJ9Bh3RUvg==
X-Received: by 2002:a17:903:2289:b0:151:64c6:20fd with SMTP id b9-20020a170903228900b0015164c620fdmr17880623plh.64.1646250360705;
        Wed, 02 Mar 2022 11:46:00 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l71-20020a63914a000000b0036c4233875dsm16295490pge.64.2022.03.02.11.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 11:46:00 -0800 (PST)
Date:   Wed, 2 Mar 2022 19:45:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH v2 4/7] KVM: x86/mmu: Zap only obsolete roots if a root
 shadow page is zapped
Message-ID: <Yh/JdHphCLOm4evG@google.com>
References: <20220225182248.3812651-1-seanjc@google.com>
 <20220225182248.3812651-5-seanjc@google.com>
 <40a22c39-9da4-6c37-8ad0-b33970e35a2b@redhat.com>
 <ee757515-4a0f-c5cb-cd57-04983f62f499@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ee757515-4a0f-c5cb-cd57-04983f62f499@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022, Paolo Bonzini wrote:
> On 3/1/22 18:55, Paolo Bonzini wrote:
> > On 2/25/22 19:22, Sean Christopherson wrote:
> > > @@ -5656,7 +5707,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
> > >        * Note: we need to do this under the protection of mmu_lock,
> > >        * otherwise, vcpu would purge shadow page but miss tlb flush.
> > >        */
> > > -    kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
> > > +    kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
> > 
> > I was going to squash in this:
> > 
> >        * invalidating TDP MMU roots must be done while holding mmu_lock for
> > -     * write and in the same critical section as making the reload
> > request,
> > +     * write and in the same critical section as making the free request,
> >        * e.g. before kvm_zap_obsolete_pages() could drop mmu_lock and
> > yield.
> > 
> > But then I realized that this needs better comments and that my
> > knowledge of
> > this has serious holes.  Regarding this comment, this is my proposal:
> > 
> >          /*
> >           * Invalidated TDP MMU roots are zapped within MMU read_lock to be
> >           * able to walk the list of roots, but with the expectation of no
> >           * concurrent change to the pages themselves.  There cannot be
> >           * any yield between kvm_tdp_mmu_invalidate_all_roots and the free
> >           * request, otherwise somebody could grab a reference to the root
> >       * and break that assumption.
> >           */
> >          if (is_tdp_mmu_enabled(kvm))
> >                  kvm_tdp_mmu_invalidate_all_roots(kvm);
> > 
> > However, for the second comment (the one in the context above), there's
> > much more.  From easier to harder:
> > 
> > 1) I'm basically clueless about the TLB flush "note" above.

I assume you're referring to this ancient thing?

	 * Note: we need to do this under the protection of mmu_lock,
	 * otherwise, vcpu would purge shadow page but miss tlb flush.

The "vcpu" part should be "KVM", or more precisely kvm_zap_obsolete_pages().
The fast zap (not a vCPU) will drop mmu_lock() if it yields when "preparing" the
zap, so the remote TLB flush via the kvm_mmu_commit_zap_page() is too late.

> > 2) It's not clear to me what needs to use for_each_tdp_mmu_root; for
> > example, why would anything but the MMU notifiers use
> > for_each_tdp_mmu_root?
> > It is used in kvm_tdp_mmu_write_protect_gfn,
> > kvm_tdp_mmu_try_split_huge_pages
> > and kvm_tdp_mmu_clear_dirty_pt_masked.
> > 
> > 3) Does it make sense that yielding users of for_each_tdp_mmu_root must
> > either look at valid roots only, or take MMU lock for write?  If so, can
> > this be enforced in tdp_mmu_next_root?
> 
> Ok, I could understand this a little better now, but please correct me
> if this is incorrect:
> 
> 2) if I'm not wrong, kvm_tdp_mmu_try_split_huge_pages indeed does not
> need to walk invalid  roots.

Correct, it doesn't need to walk invalid roots.  The only flows that need to walk
invalid roots are the mmu_notifiers (or kvm_arch_flush_shadow_all() if KVM x86 were
somehow able to survive without notifiers).

> The others do because the TDP MMU does not necessarily kick vCPUs after
> marking roots as invalid.

Fudge.  I'm pretty sure AMD/SVM TLB management is broken for the TDP MMU (though
I would argue that KVM's ASID management is broken regardless of the TDP MMU...).

The notifiers need to walk all roots because they need to guarantee any metadata
accounting, e.g. propagation of dirty bits, for the associated (host) pfn occurs
before the notifier returns.  It's not an issue of vCPUs having stale references,
or at least it shouldn't be, it's an issue of the "writeback" occurring after the
pfn is full released.

In the "fast zap", the KVM always kicks vCPUs after marking them invalid, before
dropping mmu_lock (which is held for write).  This is mandatory because the memslot
is being deleted/moved, so KVM must guarantee the old slot can't be accessed by
the guest.

In the put_root() path, there _shouldn't_ be a need to kick because the vCPU doesn't
have a reference to the root, and the last vCPU to drop a reference to the root
_should_ ensure it's unreachable.

Intel EPT is fine, because the EPT4A ensures a unique ASID, i.e. KVM can defer
any TLB flush until the same physical root page is reused.

Shadow paging is fine because kvm_mmu_free_roots()'s call to kvm_mmu_commit_zap_page()
will flush TLBs for all vCPUs when the last reference is put.

AMD NPT is hosed because KVM's awful ASID scheme doesn't assign an ASID per root
and doesn't force a new ASID.  IMO, this is an SVM mess and not a TDP MMU bug.
In the short term, I think something like the following would suffice.  Long term,
we really need to redo SVM ASID management so that ASIDs are tied to a KVM root.

diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 54bc8118c40a..2dbbf67dfd21 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -70,11 +70,8 @@ bool kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }

-static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
+static inline bool is_tdp_mmu_root(hpa_t hpa)
 {
-       struct kvm_mmu_page *sp;
-       hpa_t hpa = mmu->root.hpa;
-
        if (WARN_ON(!VALID_PAGE(hpa)))
                return false;

@@ -86,10 +83,16 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
        sp = to_shadow_page(hpa);
        return sp && is_tdp_mmu_page(sp) && sp->root_count;
 }
+
+static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
+{
+       return is_tdp_mmu_root(mmu->root.hpa);
+}
 #else
 static inline bool kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return false; }
 static inline void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm) {}
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
+static inline bool is_tdp_mmu_root(hpa_t hpa) { return false; }
 static inline bool is_tdp_mmu(struct kvm_mmu *mmu) { return false; }
 #endif

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c5e3f219803e..7899ca4748c7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3857,6 +3857,9 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
        unsigned long cr3;

        if (npt_enabled) {
+               if (is_tdp_mmu_root(root_hpa))
+                       svm->current_vmcb->asid_generation = 0;
+
                svm->vmcb->control.nested_cr3 = __sme_set(root_hpa);
                vmcb_mark_dirty(svm->vmcb, VMCB_NPT);



> But because TDP MMU roots are gone for good once their refcount hits 0, I
> wonder if we could do something like
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7e3d1f985811..a4a6dfee27f9 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -164,6 +164,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  	 */
>  	if (!kvm_tdp_root_mark_invalid(root)) {
>  		refcount_set(&root->tdp_mmu_root_count, 1);
> +		kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
>  		/*
>  		 * If the struct kvm is alive, we might as well zap the root
> @@ -1099,12 +1100,16 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>  void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
>  {
>  	struct kvm_mmu_page *root;
> +	bool invalidated_root = false
>  	lockdep_assert_held_write(&kvm->mmu_lock);
>  	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
>  		if (!WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root)))
> -			root->role.invalid = true;
> +			invalidated_root |= !kvm_tdp_root_mark_invalid(root);
>  	}
> +
> +	if (invalidated_root)
> +		kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
>  }

This won't work, see my other response about not being able to use a worker for
this path (my brain is finally getting up to speed today...).

> 
> 3) Yes, it makes sense that yielding users of for_each_tdp_mmu_root must
> either look at valid roots only, or take MMU lock for write.  The only
> exception is kvm_tdp_mmu_try_split_huge_pages, which does not need to
> walk invalid roots.  And kvm_tdp_mmu_zap_invalidated_pages(), but that
> one is basically an asynchronous worker [and this is where I had the
> inspiration to get rid of the function altogether]
> 
> Paolo
> 
