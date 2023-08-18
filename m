Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3AB5781268
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 19:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379082AbjHRRzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 13:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379343AbjHRRz3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 13:55:29 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277CB2D79
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 10:55:28 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58daaa2ba65so15203837b3.1
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 10:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692381327; x=1692986127;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OK+8NViLbT4e2HS8SDOPbE3/nK16UAbIxztB0Ra0oFI=;
        b=xyLB0r66tKK3HtIeMxOjj0iYxeV+b+BNXB0K/YYiuUNB71cFFURuqz7r0bcobYxbCW
         qQIajCbcKciT2aGVInJCi/p6NZw86Td2er7Fcy+DVknKJXkJ+EpP/Cpg5Yn8arwU8bH0
         Cu0ZqYHcQZrdmbZcPm9wwwymJcPbkwEstHzy4HGkXIZO84sZKh5JZZNF+ObyUqzpoxgv
         vWUYWYvo+I53kiS3tOJt0nXhcD3OLPIl5QtniE9iLFqZt1qrZRLmOiADv+0kzNPj39Cx
         R4FtCUrNPUyBulnHL287SvEbkdRP8SstrXV1WtF0MyciwJ4GK27SLa+RhmxzCmd4HjVo
         WdWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692381327; x=1692986127;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OK+8NViLbT4e2HS8SDOPbE3/nK16UAbIxztB0Ra0oFI=;
        b=YGU7N6718lOcSX/fn9o0MK0+Mq2l+6T0tc7uc8t5xQbNTm0o24szZvKT6Bngkk+3UV
         s2YfM2/hJhVblybKKlLVCoEpBHKMdrzY4e8HPX/RuGUgw3+F5vngBXWJxJgmrlIKbXi7
         c95Fv0Eldj2wMza3iycgsxitskuCNAQVSObzF+lm4Yjo4/4wRrCbZQtSu/0eR4/rdNhJ
         jObI8ERcA8ulr9ZRIF3Qu88csEuXH7CgJcpnEQ2H4uhkJcvF1ubKI9YQj0Un32jUAmO0
         BOtKMVZ+c//L72j8y/zYCoqBSEO8nBLb/GUSJRudgOC7X15Kgwtb/FBlux5KqsI5+CNb
         i0BA==
X-Gm-Message-State: AOJu0Yy4WIDge/bN5BXzmYGoj7zsbrPS3F2VbpnekUDsW7C7HRzhp+FO
        oF/awIwUypA/J5t5m/72gXneeIfuTiE=
X-Google-Smtp-Source: AGHT+IHFRrhsMBCKFdXjoa9UkoXzEXomb1zbD0I89gNgveRrIuz09gSEhLJGX/SlQ2funcPLA9QxcxpHUcQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:760f:0:b0:589:9d51:c8c0 with SMTP id
 r15-20020a81760f000000b005899d51c8c0mr53502ywc.2.1692381327444; Fri, 18 Aug
 2023 10:55:27 -0700 (PDT)
Date:   Fri, 18 Aug 2023 10:55:17 -0700
In-Reply-To: <b37fb13a9aeb8683d5fdd5351cdc5034639eb2bb.1692119201.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <cover.1692119201.git.isaku.yamahata@intel.com> <b37fb13a9aeb8683d5fdd5351cdc5034639eb2bb.1692119201.git.isaku.yamahata@intel.com>
Message-ID: <ZN+whX3/lSBcZKUj@google.com>
Subject: Re: [PATCH 4/8] KVM: gmem: protect kvm_mmu_invalidate_end()
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> kvm_mmu_invalidate_end() updates struct kvm::mmu_invalidate_in_progress
> and it's protected by kvm::mmu_lock.  call kvm_mmu_invalidate_end() before
> unlocking it. Not after the unlock.
> 
> Fixes: 8e9009ca6d14 ("KVM: Introduce per-page memory attributes")

This fixes is wrong.  It won't matter in the long run, but it makes my life that
much harder.

> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  virt/kvm/kvm_main.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 8bfeb615fc4d..49380cd62367 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -535,6 +535,7 @@ struct kvm_mmu_notifier_range {
>  	} arg;
>  	gfn_handler_t handler;
>  	on_lock_fn_t on_lock;
> +	on_unlock_fn_t before_unlock;
>  	on_unlock_fn_t on_unlock;

Ugh, shame on my past me.  Having on_lock and on_unlock be asymmetrical with respect
to the lock is nasty.

I would much rather we either (a) be explicit, e.g. before_(un)lock and after_(un)lock,
or (b) have just on_(un)lock, make them symetrical, and handle the SEV mess a
different way.

The SEV hook doesn't actually care about running immediately after unlock, it just
wants to know if there was an overlapping memslot.  It can run after SRCU is dropped,
because even if we make the behavior more precise (right now it blasts WBINVD),
just having a reference to memslots isn't sufficient, the code needs to guarantee
memslots are *stable*.  And that is already guaranteed by the notifier code, i.e.
the SEV code could just reacquire SRCU.

And that will hold true for any possible stuff that wants to do something *after*
dropping mmu_lock.

One idea would be to use a struct to return a tuple of the actual return value
along with whether or not mmu_lock was acquired, i.e. if there was overlap.  The
only really gross part is squeezing in meaningful name.  Absusing a #define is
one way to make the code somewhat readable...

I think this has my vote, especially if we can figure out a way to keep the
line lengths reasonable without a gnarly #define hack (I really don't want to
split the return onto a separate line).

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 95c621e05b5a..ec45510549bf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -541,6 +541,11 @@ struct kvm_mmu_notifier_range {
        bool may_block;
 };
 
+struct kvm_mmu_notifier_return {
+       bool ret;
+       bool locked;
+};
+
 /*
  * Use a dedicated stub instead of NULL to indicate that there is no callback
  * function/handler.  The compiler technically can't guarantee that a real
@@ -560,10 +565,15 @@ static void kvm_null_fn(void)
             node;                                                           \
             node = interval_tree_iter_next(node, start, last))      \
 
-static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
-                                                 const struct kvm_mmu_notifier_range *range)
+#define kvm_mn_ret_t __always_inline struct kvm_mmu_notifier_return
+
+static kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
+                                          const struct kvm_mmu_notifier_range *range)
 {
-       bool ret = false, locked = false;
+       struct kvm_mmu_notifier_return r = {
+               .ret = false,
+               .locked = false,
+       };
        struct kvm_gfn_range gfn_range;
        struct kvm_memory_slot *slot;
        struct kvm_memslots *slots;
@@ -574,12 +584,12 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
        BUILD_BUG_ON(sizeof(gfn_range.arg) != sizeof(range->arg));
 
        if (WARN_ON_ONCE(range->end <= range->start))
-               return 0;
+               return r;
 
        /* A null handler is allowed if and only if on_lock() is provided. */
        if (WARN_ON_ONCE(IS_KVM_NULL_FN(range->on_lock) &&
                         IS_KVM_NULL_FN(range->handler)))
-               return 0;
+               return r;
 
        idx = srcu_read_lock(&kvm->srcu);
 
@@ -613,8 +623,8 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
                        gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
                        gfn_range.slot = slot;
 
-                       if (!locked) {
-                               locked = true;
+                       if (!r.locked) {
+                               r.locked = true;
                                KVM_MMU_LOCK(kvm);
                                if (!IS_KVM_NULL_FN(range->on_lock))
                                        range->on_lock(kvm);
@@ -622,33 +632,28 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
                                if (IS_KVM_NULL_FN(range->handler))
                                        break;
                        }
-                       ret |= range->handler(kvm, &gfn_range);
+                       r.ret |= range->handler(kvm, &gfn_range);
                }
        }
 
-       if (range->flush_on_ret && ret)
+       if (range->flush_on_ret && r.ret)
                kvm_flush_remote_tlbs(kvm);
 
-       if (locked) {
+       if (r.locked) {
                KVM_MMU_UNLOCK(kvm);
                if (!IS_KVM_NULL_FN(range->on_unlock))
                        range->on_unlock(kvm);
        }
 
-       if (range->reclaim_on_ret && ret)
-               kvm_arch_guest_memory_reclaimed(kvm);
-
        srcu_read_unlock(&kvm->srcu, idx);
 
-       /* The notifiers are averse to booleans. :-( */
-       return (int)ret;
+       return r;
 }
 
...skipping...
        const struct kvm_mmu_notifier_range range = {
@@ -780,7 +785,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
                .end            = range->end,
                .handler        = kvm_mmu_unmap_gfn_range,
                .on_lock        = kvm_mmu_invalidate_begin,
-               .on_unlock      = kvm_null_fn,
+               .on_unlock      = (void *)kvm_null_fn,
                .flush_on_ret   = true,
                .reclaim_on_ret = true,
                .may_block      = mmu_notifier_range_blockable(range),
@@ -813,7 +818,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
        gfn_to_pfn_cache_invalidate_start(kvm, range->start, range->end,
                                          hva_range.may_block);
 
-       __kvm_handle_hva_range(kvm, &hva_range);
+       if (__kvm_handle_hva_range(kvm, &hva_range).locked)
+               kvm_arch_guest_memory_reclaimed(kvm);
 
        return 0;
 }
@@ -881,7 +887,7 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 {
        trace_kvm_age_hva(start, end);
 
-       return kvm_handle_hva_range(mn, start, end, __pte(0), kvm_age_gfn);
+       return kvm_handle_hva_range(mn, start, end, __pte(0), kvm_age_gfn).ret;
 }
 
 static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
@@ -904,7 +910,7 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
         * cadence. If we find this inaccurate, we might come up with a
         * more sophisticated heuristic later.
         */
-       return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn);
+       return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn).ret;
 }
 
 static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
@@ -914,7 +920,7 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
        trace_kvm_test_age_hva(address);
 
        return kvm_handle_hva_range_no_flush(mn, address, address + 1,
-                                            kvm_test_age_gfn);
+                                            kvm_test_age_gfn).ret;
 }
 
 static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
@@ -2400,12 +2406,14 @@ static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
                                                 struct kvm_mmu_notifier_range *range)
 {
+       struct kvm_mmu_notifier_return r = {
+               .ret = false,
+               .locked = false,
+       };
        struct kvm_gfn_range gfn_range;
        struct kvm_memory_slot *slot;
        struct kvm_memslots *slots;
        struct kvm_memslot_iter iter;
-       bool locked = false;
-       bool ret = false;
        int i;
 
        gfn_range.arg.raw = range->arg.raw;
@@ -2423,21 +2431,21 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
                        if (gfn_range.start >= gfn_range.end)
                                continue;
 
-                       if (!locked) {
-                               locked = true;
+                       if (!r.locked) {
+                               r.locked = true;
                                KVM_MMU_LOCK(kvm);
                                if (!IS_KVM_NULL_FN(range->on_lock))
                                        range->on_lock(kvm);
                        }
 
-                       ret |= range->handler(kvm, &gfn_range);
+                       r.ret |= range->handler(kvm, &gfn_range);
                }
        }
 
-       if (range->flush_on_ret && ret)
+       if (range->flush_on_ret && r.ret)
                kvm_flush_remote_tlbs(kvm);
 
-       if (locked) {
+       if (r.locked) {
                KVM_MMU_UNLOCK(kvm);
                if (!IS_KVM_NULL_FN(range->on_unlock))
                        range->on_unlock(kvm);

