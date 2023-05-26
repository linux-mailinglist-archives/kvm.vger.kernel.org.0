Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301D6713079
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 01:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237957AbjEZXoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 19:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237094AbjEZXoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 19:44:46 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD561A2
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 16:44:44 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5618857518dso17693077b3.2
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 16:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685144683; x=1687736683;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=74b92Wk/fESh4Us3jjAt9ER/dw3pjjcYNf6aM3EASmw=;
        b=HaeURiP8Vv+S5DfSxjNudO8jlQJ3LkpTBadHgzP5bqFZBs2b3foI2By3BUQ7HvtvPw
         W7QXj6uSkaA/QUNh4WGZeI/+nH65GkUhIUrM4lyZvIxfASIS2yU+XXbU6dLJN4ghefvO
         HpvDwxabNs2VhwI1FmYErw8clASpd/3GLJz6qPYetihMIY0W6vexsuS/yVGVZpRWw3il
         an2SbsIcj+SL6k3rb4VmBY4XZ/nf3i0WPF6L2efKh0GQc6ZIGr6GiKv97NKXrU9K5c92
         qSgR2Y5nDu/cn+wzryf1LV/5CRQgKNqjczW+qgHgoPm+B6opAwXo+9yxImX5iYvtFZ8h
         Yz0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685144683; x=1687736683;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=74b92Wk/fESh4Us3jjAt9ER/dw3pjjcYNf6aM3EASmw=;
        b=QLydG7euNJEypAHG7LBstBh0s8Ou/RQnKDbj7U0qknx0SAW6bA9Mejq4M7RnVzL6sn
         zb/+9AR1qssLfEyG6mnznpeV9/GnmfhtUUtxjefSf+DdGO2eWd71+CaUODDJtomk5kmo
         HKAJp439TtCJoPehmKuFb6QRgeNAlzh+BQKDPWZTK1KASFexSccThgQ6/pX0KTqqc5Dd
         89h67J9fnmY41iGN+d+f/ZV62BGXjofXs/ux1EDj5mCFlDzNyFSizXRZXwA6p6ucwwMH
         qzNVvp7Prv6vlozYlkGOe62thEHxKoshp0gaHh4fLYaM6oub4JQxCz77Yh3L/dirRfdX
         gRAg==
X-Gm-Message-State: AC+VfDy49euxoAOr11gNTUca9QmcYYyumQjEpDPJ0/RRf2qf/dyXWsZt
        eLIXk+84Q+aToy2Hh+TlwabfaGzWUe0=
X-Google-Smtp-Source: ACHHUZ77t8VJ8lKvCLJIppCq4GXisPABEajtkBmVe9W7YGxSZPGguPwTv3qLn5OBBx4lDI9spcGEUr4VdcA=
X-Received: from yuzhao.bld.corp.google.com ([2620:15c:183:200:910f:8a15:592b:2087])
 (user=yuzhao job=sendgmr) by 2002:a81:e608:0:b0:561:c4ef:1def with SMTP id
 u8-20020a81e608000000b00561c4ef1defmr2027484ywl.0.1685144683190; Fri, 26 May
 2023 16:44:43 -0700 (PDT)
Date:   Fri, 26 May 2023 17:44:27 -0600
In-Reply-To: <20230526234435.662652-1-yuzhao@google.com>
Message-Id: <20230526234435.662652-3-yuzhao@google.com>
Mime-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Subject: [PATCH mm-unstable v2 02/10] mm/kvm: use mmu_notifier_ops->test_clear_young()
From:   Yu Zhao <yuzhao@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alistair Popple <apopple@nvidia.com>,
        Anup Patel <anup@brainfault.org>,
        Ben Gardon <bgardon@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Gaosheng Cui <cuigaosheng1@huawei.com>,
        Gavin Shan <gshan@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Larabel <michael@michaellarabel.com>,
        Mike Rapoport <rppt@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paul Mackerras <paulus@ozlabs.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-trace-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@google.com, Yu Zhao <yuzhao@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace test_young() and clear_young() with test_clear_young().

Signed-off-by: Yu Zhao <yuzhao@google.com>
---
 include/linux/mmu_notifier.h | 29 ++-----------------
 include/trace/events/kvm.h   | 15 ----------
 mm/mmu_notifier.c            | 42 ----------------------------
 virt/kvm/kvm_main.c          | 54 ------------------------------------
 4 files changed, 2 insertions(+), 138 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index dfdbb370682d..c8f35fc08703 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -104,26 +104,6 @@ struct mmu_notifier_ops {
 				 unsigned long start,
 				 unsigned long end);
 
-	/*
-	 * clear_young is a lightweight version of clear_flush_young. Like the
-	 * latter, it is supposed to test-and-clear the young/accessed bitflag
-	 * in the secondary pte, but it may omit flushing the secondary tlb.
-	 */
-	int (*clear_young)(struct mmu_notifier *subscription,
-			   struct mm_struct *mm,
-			   unsigned long start,
-			   unsigned long end);
-
-	/*
-	 * test_young is called to check the young/accessed bitflag in
-	 * the secondary pte. This is used to know if the page is
-	 * frequently used without actually clearing the flag or tearing
-	 * down the secondary mapping on the page.
-	 */
-	int (*test_young)(struct mmu_notifier *subscription,
-			  struct mm_struct *mm,
-			  unsigned long address);
-
 	int (*test_clear_young)(struct mmu_notifier *mn, struct mm_struct *mm,
 				unsigned long start, unsigned long end,
 				bool clear, unsigned long *bitmap);
@@ -393,11 +373,6 @@ extern void __mmu_notifier_release(struct mm_struct *mm);
 extern int __mmu_notifier_clear_flush_young(struct mm_struct *mm,
 					  unsigned long start,
 					  unsigned long end);
-extern int __mmu_notifier_clear_young(struct mm_struct *mm,
-				      unsigned long start,
-				      unsigned long end);
-extern int __mmu_notifier_test_young(struct mm_struct *mm,
-				     unsigned long address);
 extern int __mmu_notifier_test_clear_young(struct mm_struct *mm,
 					   unsigned long start, unsigned long end,
 					   bool clear, unsigned long *bitmap);
@@ -437,7 +412,7 @@ static inline int mmu_notifier_clear_young(struct mm_struct *mm,
 					   unsigned long end)
 {
 	if (mm_has_notifiers(mm))
-		return __mmu_notifier_clear_young(mm, start, end);
+		return __mmu_notifier_test_clear_young(mm, start, end, true, NULL);
 	return 0;
 }
 
@@ -445,7 +420,7 @@ static inline int mmu_notifier_test_young(struct mm_struct *mm,
 					  unsigned long address)
 {
 	if (mm_has_notifiers(mm))
-		return __mmu_notifier_test_young(mm, address);
+		return __mmu_notifier_test_clear_young(mm, address, address + 1, false, NULL);
 	return 0;
 }
 
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 3bd31ea23fee..46c347e56e60 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -489,21 +489,6 @@ TRACE_EVENT(kvm_age_hva,
 		  __entry->start, __entry->end)
 );
 
-TRACE_EVENT(kvm_test_age_hva,
-	TP_PROTO(unsigned long hva),
-	TP_ARGS(hva),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	hva		)
-	),
-
-	TP_fast_assign(
-		__entry->hva		= hva;
-	),
-
-	TP_printk("mmu notifier test age hva: %#016lx", __entry->hva)
-);
-
 #endif /* _TRACE_KVM_MAIN_H */
 
 /* This part must be outside protection */
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 7e6aba4bddcb..c7e9747c9920 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -382,48 +382,6 @@ int __mmu_notifier_clear_flush_young(struct mm_struct *mm,
 	return young;
 }
 
-int __mmu_notifier_clear_young(struct mm_struct *mm,
-			       unsigned long start,
-			       unsigned long end)
-{
-	struct mmu_notifier *subscription;
-	int young = 0, id;
-
-	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription,
-				 &mm->notifier_subscriptions->list, hlist,
-				 srcu_read_lock_held(&srcu)) {
-		if (subscription->ops->clear_young)
-			young |= subscription->ops->clear_young(subscription,
-								mm, start, end);
-	}
-	srcu_read_unlock(&srcu, id);
-
-	return young;
-}
-
-int __mmu_notifier_test_young(struct mm_struct *mm,
-			      unsigned long address)
-{
-	struct mmu_notifier *subscription;
-	int young = 0, id;
-
-	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription,
-				 &mm->notifier_subscriptions->list, hlist,
-				 srcu_read_lock_held(&srcu)) {
-		if (subscription->ops->test_young) {
-			young = subscription->ops->test_young(subscription, mm,
-							      address);
-			if (young)
-				break;
-		}
-	}
-	srcu_read_unlock(&srcu, id);
-
-	return young;
-}
-
 int __mmu_notifier_test_clear_young(struct mm_struct *mm,
 				    unsigned long start, unsigned long end,
 				    bool clear, unsigned long *bitmap)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 31ee58754b19..977baaf1b248 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -674,25 +674,6 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 	return __kvm_handle_hva_range(kvm, &range);
 }
 
-static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn,
-							 unsigned long start,
-							 unsigned long end,
-							 hva_handler_t handler)
-{
-	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	const struct kvm_hva_range range = {
-		.start		= start,
-		.end		= end,
-		.pte		= __pte(0),
-		.handler	= handler,
-		.on_lock	= (void *)kvm_null_fn,
-		.on_unlock	= (void *)kvm_null_fn,
-		.flush_on_ret	= false,
-		.may_block	= false,
-	};
-
-	return __kvm_handle_hva_range(kvm, &range);
-}
 static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 					struct mm_struct *mm,
 					unsigned long address,
@@ -854,39 +835,6 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 	return kvm_handle_hva_range(mn, start, end, __pte(0), kvm_age_gfn);
 }
 
-static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
-					struct mm_struct *mm,
-					unsigned long start,
-					unsigned long end)
-{
-	trace_kvm_age_hva(start, end);
-
-	/*
-	 * Even though we do not flush TLB, this will still adversely
-	 * affect performance on pre-Haswell Intel EPT, where there is
-	 * no EPT Access Bit to clear so that we have to tear down EPT
-	 * tables instead. If we find this unacceptable, we can always
-	 * add a parameter to kvm_age_hva so that it effectively doesn't
-	 * do anything on clear_young.
-	 *
-	 * Also note that currently we never issue secondary TLB flushes
-	 * from clear_young, leaving this job up to the regular system
-	 * cadence. If we find this inaccurate, we might come up with a
-	 * more sophisticated heuristic later.
-	 */
-	return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn);
-}
-
-static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
-				       struct mm_struct *mm,
-				       unsigned long address)
-{
-	trace_kvm_test_age_hva(address);
-
-	return kvm_handle_hva_range_no_flush(mn, address, address + 1,
-					     kvm_test_age_gfn);
-}
-
 struct test_clear_young_args {
 	unsigned long *bitmap;
 	unsigned long end;
@@ -969,8 +917,6 @@ static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
 	.invalidate_range_start	= kvm_mmu_notifier_invalidate_range_start,
 	.invalidate_range_end	= kvm_mmu_notifier_invalidate_range_end,
 	.clear_flush_young	= kvm_mmu_notifier_clear_flush_young,
-	.clear_young		= kvm_mmu_notifier_clear_young,
-	.test_young		= kvm_mmu_notifier_test_young,
 	.test_clear_young	= kvm_mmu_notifier_test_clear_young,
 	.change_pte		= kvm_mmu_notifier_change_pte,
 	.release		= kvm_mmu_notifier_release,
-- 
2.41.0.rc0.172.g3f132b7071-goog

