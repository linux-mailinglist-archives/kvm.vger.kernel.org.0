Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E565A70CB77
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 22:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbjEVUqw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 16:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234777AbjEVUqr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 16:46:47 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA5EC1
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 13:46:43 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-64d2d0f5144so2356098b3a.1
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 13:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684788403; x=1687380403;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W87RELi464qEY+cS32xNBLxYHSfFpf8luRfYTadu71s=;
        b=3WmA7xxVaeZdUxvIGDEkmw0U5+8pgH6A4D/wP81nd2cIpTBEuldmrRCAoJtvSHDt+6
         I9pSuquhStkKBpVZrmMtQ3xrA17/B+SV1xa1VbUtnKWToy8Zgzx+eY9D7sGpeRT0Z4PH
         vXbk89Kj2KupVtXxdXiQ+wAYTvsJhsSbRPyrXOQQiRtiLU5DQ1qqmvUntdLZwcUx1+95
         /NCZaahGvA7mpeZwh/bHpumNFHPq8POy0pNIzNjC3APOTmR9FjZVqlczLxIlPHaxPAig
         xrik+Y/H3sklUwbX63lYmkbTEYn8384LPvyhb79CFufru4wemgylfV9yphU+pFQDLC1M
         ZIaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684788403; x=1687380403;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W87RELi464qEY+cS32xNBLxYHSfFpf8luRfYTadu71s=;
        b=lF0+P67kiBXyQDn2Aph7sJJVHXc4Wh/INw/oK17uBbwbUJrjyihxrLjktfOngZQ4bK
         89iBN6EtB+523Y+UquY8xx9vjM9C4hlYAkptldrpKFe80ZePZXEC2EiyuIYnXXEgib3J
         T0XxbtGUp7o0ZsgtsiYkRDPwRR80o1ma3t37zQE4Hk8HVzkpNNSeDTNGyYtSfg6kvouf
         jxxdVRSLRUlfeeBEHpHghkkIzbLKmTxJpFCiL5hyyQdw9Y0FfDpcrILABJgRHL7+8CAP
         BYjhpxa4xy9MktPohD6l4sGFD8h620I52hrmQZ29LYcrgfMcH4SAklpx+LMFU+sdtdvA
         r9Jg==
X-Gm-Message-State: AC+VfDzCE8LtShdaZiTTHowH8fO8m+pBBYntynyxWPDFRdmQsSUMEIl9
        gnI6Z0vFpLs7N5XMql/MewKZwLpCc/Y=
X-Google-Smtp-Source: ACHHUZ6NQ7aTOkvUTtDMEi0IDRSDH4TmeTu4tsYNNJ9QDi8IZHPcUOZMsPBzSPmHiwbofpkrZxUG52aqDCE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a1a:b0:624:5886:4b4b with SMTP id
 p26-20020a056a000a1a00b0062458864b4bmr5302538pfh.5.1684788403186; Mon, 22 May
 2023 13:46:43 -0700 (PDT)
Date:   Mon, 22 May 2023 13:46:41 -0700
In-Reply-To: <20230330085802.2414466-2-stevensd@google.com>
Mime-Version: 1.0
References: <20230330085802.2414466-1-stevensd@google.com> <20230330085802.2414466-2-stevensd@google.com>
Message-ID: <ZGvUsf7lMkrNDHuE@google.com>
Subject: Re: [PATCH v6 1/4] KVM: mmu: introduce new gfn_to_pfn_noref functions
From:   Sean Christopherson <seanjc@google.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Peter

On Thu, Mar 30, 2023, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Introduce new gfn_to_pfn_noref functions that parallel existing
> gfn_to_pfn functions. These functions can be used when the caller does
> not need to maintain a reference to the returned pfn (i.e. when usage is
> guarded by a mmu_notifier). The noref functions take an out parameter
> that is used to return the struct page if the hva was resolved via gup.
> The caller needs to drop its reference such a returned page.

I dislike the "noref" name and the approach itself (of providing an entirely
separate set of APIs).  Using "noref" is confusing because the callers do actually
get a reference to the page (if a refcounted page is found).

As for the approach, I really, really don't want to end up with yet more APIs
for getting PFNs from GFNs.  We already have far too many.  In the short term,
I think we'll need to carry multiple sets of APIs, as converting all architectures
to any new API will be too much for a single series.  But I want to have line of
sight to convering on a single, as-small-as-possible set of APIs, and I think/hope
it should be possible to make the old APIs, e.g. gfn_to_pfn(), to be shims around
the new APIs.

And since this series is essentially overhauling the gfn_to_pfn APIs, I think it's
the right series to take on refactoring the APIs to clean up the growing flag
problem.  There was a bit of discussion back when "interruptible" support was
added (https://lore.kernel.org/all/YrTbKaRe497n8M0o@xz-m1.loca), but it got punted
because it wasn't necessary, and because there wasn't immediate agreement on what
exactly the APIs should look like.

Overhauling the APIs would also let us clean up things like async #PF, specifically
replacing the unintuitive "*async = true" logic with something like this:

		if ((flags & FOLL_NOWAIT) && vma_is_valid(vma, flags & FOLL_WRITE))
			pfn = KVM_PFN_ERR_FAULT_MINOR;
		else
			pfn = KVM_PFN_ERR_FAULT;

Lastly, I think there's also an opportunity here to harden KVM's interaction with
mmu_notifiers, and to dedup arch code in KVM .  Specifically, even when the proposed
"allow_unsafe_kmap" is true, KVM should either (a) be "in" an mmu_notifier sequence
or (b) _want_ to grab a reference.  And when KVM does NOT want a reference, the core
API can/should immediately drop the reference even before returning.

My thought is it provide an "entirely" new API, named something like kvm_follow_pfn()
to somewhat mirror follow_{pfn,pte,phys}().  Ideally something to pair with gup()
would be nice, but having a dedicated KVM helper to get _only_ struct page memory
doesn't work well because KVM almost never wants only struct page memory.

As for the flags vs. bools debate (see link above), I think the best approach is
a mix of the two.  Specifically, reuse the FOLL_* flags as-is for inputs, and use
booleans for outputs.  I don't _think_ there are any input bools/flags that don't
map 1:1 with existing FOLL_* flags.

As a very, *very* rough sketch, provide APIs that look a bit like this.

  kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll)
  {
	kvm_pfn_t pfn;

	if (WARN_ON_ONCE(!(foll->flags & FOLL_GET) && !foll.mmu_seq))
		return KVM_PFN_ERR_FAULT;

	pfn = ???;

	if (foll->page && !(foll->flags & FOLL_GET))
		put_page(foll->page);

	return pfn;
  }

  kvm_pfn_t kvm_follow_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct page **page)
  {
	struct kvm_follow_pfn foll = {
		.flags = FOLL_GET | FOLL_WRITE,
	};

	<more stuff here?>

	foll.slot = ???;
	if (!foll.slot || foll.slot->flags & KVM_MEMSLOT_INVALID)
		return KVM_HVA_ERR_BAD;

	if (memslot_is_readonly(foll.slot))
		return KVM_HVA_ERR_RO_BAD;

	return __kvm_follow_pfn(&foll);
  }

and a few partially converted users

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 67e2ac799aa7..5eaf0395ed87 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -550,12 +550,14 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 
        if (is_accessed_spte(old_spte) && !is_accessed_spte(new_spte)) {
                flush = true;
-               kvm_set_pfn_accessed(spte_to_pfn(old_spte));
+               if (is_refcounted_page_pte(old_spte))
+                       kvm_set_page_accessed(pfn_to_page(spte_to_pfn));
        }
 
        if (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte)) {
                flush = true;
-               kvm_set_pfn_dirty(spte_to_pfn(old_spte));
+               if (is_refcounted_page_pte(old_spte))
+                       kvm_set_page_dirty(pfn_to_page(spte_to_pfn));
        }
 
        return flush;
@@ -4278,6 +4280,10 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 
 static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
+       struct kvm_follow_pfn foll = {
+               .mmu_seq = fault->mmu_seq,
+               .gfn = fault->gfn,
+       };
        struct kvm_memory_slot *slot = fault->slot;
        bool async;
 
@@ -4309,12 +4315,16 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
                        return RET_PF_EMULATE;
        }
 
-       async = false;
-       fault->pfn = __gfn_to_pfn_noref_memslot(slot, fault->gfn, false, false, &async,
-                                               fault->write, &fault->map_writable,
-                                               &fault->hva, &fault->page);
-       if (!async)
-               return RET_PF_CONTINUE; /* *pfn has correct page already */
+       foll.flags = FOLL_NOWAIT;
+       if (fault->write)
+               foll.flags |= FOLL_WRITE;
+
+       fault->pfn = __kvm_follow_pfn(&foll);
+       if (!is_error_noslot_pfn(fault->pfn))
+               goto success;
+
+       if (!is_fault_minor_pfn(fault->pfn))
+               return RET_PF_CONTINUE;
 
        if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
                trace_kvm_try_async_get_page(fault->addr, fault->gfn);
@@ -4332,9 +4342,18 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
         * to wait for IO.  Note, gup always bails if it is unable to quickly
         * get a page and a fatal signal, i.e. SIGKILL, is pending.
         */
-       fault->pfn = __gfn_to_pfn_noref_memslot(slot, fault->gfn, false, true, NULL,
-                                               fault->write, &fault->map_writable,
-                                               &fault->hva, &fault->page);
+       foll.flags |= FOLL_INTERRUPTIBLE;
+       foll.flags &= ~FOLL_NOWAIT;
+
+       fault->pfn = kvm_follow_pfn(&foll);
+       if (!is_error_noslot_pfn(fault->pfn))
+               goto success;
+
+       return RET_PF_CONTINUE;
+success:
+       fault->hva = foll.hva;
+       fault->page = foll.page;
+       fault->map_writable = foll.writable;
        return RET_PF_CONTINUE;
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 360eaa24456f..0bae253c88dd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2663,9 +2663,10 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
                if (r < 0)
                        pfn = KVM_PFN_ERR_FAULT;
        } else {
-               if (async && vma_is_valid(vma, write_fault))
-                       *async = true;
-               pfn = KVM_PFN_ERR_FAULT;
+               if ((flags & FOLL_NOWAIT) && vma_is_valid(vma, flags & FOLL_WRITE))
+                       pfn = KVM_PFN_ERR_FAULT_MINOR;
+               else
...skipping...
+       fault->pfn = kvm_follow_pfn(&foll);
+       if (!is_error_noslot_pfn(fault->pfn))
+               goto success;
+
+       return RET_PF_CONTINUE;
+success:
+       fault->hva = foll.hva;
+       fault->page = foll.page;
+       fault->map_writable = foll.writable;
        return RET_PF_CONTINUE;
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 360eaa24456f..0bae253c88dd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2663,9 +2663,10 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
                if (r < 0)
                        pfn = KVM_PFN_ERR_FAULT;
        } else {
-               if (async && vma_is_valid(vma, write_fault))
-                       *async = true;
-               pfn = KVM_PFN_ERR_FAULT;
+               if ((flags & FOLL_NOWAIT) && vma_is_valid(vma, flags & FOLL_WRITE))
+                       pfn = KVM_PFN_ERR_FAULT_MINOR;
+               else
+                       pfn = KVM_PFN_ERR_FAULT;
        }
 exit:
        mmap_read_unlock(current->mm);
@@ -2732,6 +2733,30 @@ kvm_pfn_t __gfn_to_pfn_noref_memslot(const struct kvm_memory_slot *slot, gfn_t g
 }
 EXPORT_SYMBOL_GPL(__gfn_to_pfn_noref_memslot);
 
+kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll)
+{
+       kvm_pfn_t pfn;
+
+       if (WARN_ON_ONCE(!(foll->flags & FOLL_GET) && !foll.mmu_seq))
+               return KVM_PFN_ERR_FAULT;
+
+       pfn = __gfn_to_pfn_noref_memslot(...);
+
+       if (foll->page && !(foll->flags & FOLL_GET))
+               put_page(foll->page);
+
+       return pfn;
+}
+
+kvm_pfn_t kvm_follow_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct page **page)
+{
+       struct kvm_follow_pfn foll = {
+               .flags = FOLL_GET | FOLL_WRITE,
+       };
+
+       return __kvm_follow_pfn(&foll);
+}
+
 kvm_pfn_t gfn_to_pfn_noref_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
                                bool *writable, struct page **page)
 {
@@ -2910,25 +2935,23 @@ void kvm_release_pfn(kvm_pfn_t pfn, bool dirty)
 
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 {
+       struct page *page;
        kvm_pfn_t pfn;
        void *hva = NULL;
-       struct page *page = KVM_UNMAPPED_PAGE;
 
        if (!map)
                return -EINVAL;
 
-       pfn = gfn_to_pfn(vcpu->kvm, gfn);
+       pfn = kvm_follow_pfn(vcpu->kvm, gfn, &page)
        if (is_error_noslot_pfn(pfn))
                return -EINVAL;
 
-       if (pfn_valid(pfn)) {
-               page = pfn_to_page(pfn);
+       if (page)
                hva = kmap(page);
 #ifdef CONFIG_HAS_IOMEM
-       } else {
+       else if (allow_unsafe_kmap)
                hva = memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
 #endif
-       }
 
        if (!hva)
                return -EFAULT;
