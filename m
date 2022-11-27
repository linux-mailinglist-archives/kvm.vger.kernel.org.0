Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37D3B639A69
	for <lists+kvm@lfdr.de>; Sun, 27 Nov 2022 13:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiK0MWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Nov 2022 07:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiK0MW3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Nov 2022 07:22:29 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B00310073
        for <kvm@vger.kernel.org>; Sun, 27 Nov 2022 04:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=yncstbod0h0kacVQbjiGU8R9J0QruvS62koeuejImxQ=; b=NRzG4kiaHC77cgFCeyDm0f7yft
        lLfuqq/rsR8c/utQHX4a4ygBTR5WTtUJj9TRosFW5RHwBYNfnfjQaG4qWVTrf0LK9vdj6BCgmWN5o
        G0l2UJcI9FN07JAzMMVTGe0cPxIMsRZKDJwhtu0643glJJlRusG8pBLDq6xekSfrN0MoFxeCunKqI
        U1lsWcFYhDn4UbutIqNlTr03MnjsAARBSVHtHFs1OQyMcu8LQWY0EFU0E/MdU65c0vLQt1E+sxtWR
        u1h8pSCkEfp61GLVBzfWq89aB9XKHAd9UebWcmTBJBoBv12TaMA/YF3cPFbcNszxZvRULXpfHxStg
        NAkBFjjQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ozGft-00BZsb-92; Sun, 27 Nov 2022 12:22:22 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ozGfl-0012dN-Ub; Sun, 27 Nov 2022 12:22:13 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Durrant <paul@xen.org>, Michal Luczaj <mhal@rbox.co>,
        kvm@vger.kernel.org
Subject: [PATCH v1 1/2] KVM: x86/xen: Reconcile fast and slow paths for runstate update
Date:   Sun, 27 Nov 2022 12:22:09 +0000
Message-Id: <20221127122210.248427-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221127122210.248427-1-dwmw2@infradead.org>
References: <20221127122210.248427-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Instead of having a completely separate fast path for the case where the
guest's runstate_info fits entirely in a page, recognise the similarity.

In both cases, the @update_bit pointer points to the byte containing the
XEN_RUNSTATE_UPDATE flag directly in the guest, via one of the GPCs.

In both cases, the actual guest structure (compat or not) is built up
from the fields in @vx, following preset pointers to the state and times
fields. The only difference is whether those pointers point to the kernel
stack (in the split case) or to guest memory directly via the GPC.

We can unify it by just setting the rs_state and rs_times pointers up
accordingly for each case. Then the only real difference is that dual
memcpy which can be made conditional, so the whole of that separate
fast path can go away, disappearing into the slow path without actually
doing the slow part.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c | 253 +++++++++++++++++++++++----------------------
 1 file changed, 127 insertions(+), 126 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index b246decb53a9..d1a506986a32 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -177,44 +177,78 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 	struct gfn_to_pfn_cache *gpc2 = &vx->runstate2_cache;
 	size_t user_len, user_len1, user_len2;
 	struct vcpu_runstate_info rs;
-	int *rs_state = &rs.state;
 	unsigned long flags;
 	size_t times_ofs;
-	u8 *update_bit;
+	uint8_t *update_bit;
+	uint64_t *rs_times;
+	int *rs_state;
 
 	/*
 	 * The only difference between 32-bit and 64-bit versions of the
 	 * runstate struct is the alignment of uint64_t in 32-bit, which
 	 * means that the 64-bit version has an additional 4 bytes of
-	 * padding after the first field 'state'.
+	 * padding after the first field 'state'. Let's be really really
+	 * paranoid about that, and matching it with our internal data
+	 * structures that we memcpy into it...
 	 */
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) != 0);
 	BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state) != 0);
 	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) != 0x2c);
 #ifdef CONFIG_X86_64
+	/*
+	 * The 64-bit structure has 4 bytes of padding before 'state_entry_time'
+	 * so each subsequent field is shifted by 4, and it's 4 bytes longer.
+	 */
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
 		     offsetof(struct compat_vcpu_runstate_info, state_entry_time) + 4);
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, time) !=
 		     offsetof(struct compat_vcpu_runstate_info, time) + 4);
+	BUILD_BUG_ON(sizeof(struct vcpu_runstate_info) != 0x2c + 4);
 #endif
+	/*
+	 * The state field is in the same place at the start of both structs,
+	 * and is the same size (int) as vx->current_runstate.
+	 */
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=
+		     offsetof(struct compat_vcpu_runstate_info, state));
+	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state) !=
+		     sizeof(vx->current_runstate));
+	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state) !=
+		     sizeof(vx->current_runstate));
+
+	/*
+	 * The state_entry_time field is 64 bits in both versions, and the
+	 * XEN_RUNSTATE_UPDATE flag is in the top bit, which given that x86
+	 * is little-endian means that it's in the last *byte* of the word.
+	 * That detail is important later.
+	 */
+	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state_entry_time) !=
+		     sizeof(uint64_t));
+	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state_entry_time) !=
+		     sizeof(uint64_t));
+	BUILD_BUG_ON((XEN_RUNSTATE_UPDATE >> 56) != 0x80);
+
+	/*
+	 * The time array is four 64-bit quantities in both versions, matching
+	 * the vx->runstate_times and immediately following state_entry_time.
+	 */
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
+		     offsetof(struct vcpu_runstate_info, time) - sizeof(uint64_t));
+	BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state_entry_time) !=
+		     offsetof(struct compat_vcpu_runstate_info, time) - sizeof(uint64_t));
+	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
+		     sizeof_field(struct compat_vcpu_runstate_info, time));
+	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
+		     sizeof(vx->runstate_times));
 
 	if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode) {
 		user_len = sizeof(struct vcpu_runstate_info);
 		times_ofs = offsetof(struct vcpu_runstate_info,
 				     state_entry_time);
-#ifdef CONFIG_X86_64
-		/*
-		 * Don't leak kernel memory through the padding in the 64-bit
-		 * struct if we take the split-page path.
-		 */
-		memset(&rs, 0, offsetof(struct vcpu_runstate_info, state_entry_time));
-#endif
 	} else {
 		user_len = sizeof(struct compat_vcpu_runstate_info);
 		times_ofs = offsetof(struct compat_vcpu_runstate_info,
 				     state_entry_time);
-		/* Start of struct for compat mode (qv). */
-		rs_state++;
 	}
 
 	/*
@@ -251,156 +285,123 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 		read_lock_irqsave(&gpc1->lock, flags);
 	}
 
-	/*
-	 * The common case is that it all fits on a page and we can
-	 * just do it the simple way.
-	 */
 	if (likely(!user_len2)) {
 		/*
-		 * We use 'int *user_state' to point to the state field, and
-		 * 'u64 *user_times' for runstate_entry_time. So the actual
-		 * array of time[] in each state starts at user_times[1].
+		 * Set up three pointers directly to the runstate_info
+		 * struct in the guest (via the GPC).
+		 *
+		 *  • @rs_state   → state field
+		 *  • @rs_times   → state_entry_time field.
+		 *  • @update_bit → last byte of state_entry_time, which
+		 *                  contains the XEN_RUNSTATE_UPDATE bit.
 		 */
-		int *user_state = gpc1->khva;
-		u64 *user_times = gpc1->khva + times_ofs;
-
+		rs_state = gpc1->khva;
+		rs_times = gpc1->khva + times_ofs;
+		update_bit = ((void *)(&rs_times[1])) - 1;
+	} else {
 		/*
-		 * The XEN_RUNSTATE_UPDATE bit is the top bit of the state_entry_time
-		 * field. We need to set it (and write-barrier) before writing to the
-		 * the rest of the structure, and clear it last. Just as Xen does, we
-		 * address the single *byte* in which it resides because it might be
-		 * in a different cache line to the rest of the 64-bit word, due to
-		 * the (lack of) alignment constraints.
+		 * The guest's runstate_info is split across two pages and we
+		 * need to hold and validate both GPCs simultaneously. We can
+		 * declare a lock ordering GPC1 > GPC2 because nothing else
+		 * takes them more than one at a time.
 		 */
-		BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state_entry_time) !=
-			     sizeof(uint64_t));
-		BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state_entry_time) !=
-			     sizeof(uint64_t));
-		BUILD_BUG_ON((XEN_RUNSTATE_UPDATE >> 56) != 0x80);
+		read_lock(&gpc2->lock);
 
-		update_bit = ((u8 *)(&user_times[1])) - 1;
-		*update_bit = (vx->runstate_entry_time | XEN_RUNSTATE_UPDATE) >> 56;
-		smp_wmb();
+		if (!kvm_gpc_check(v->kvm, gpc2, gpc2->gpa, user_len2)) {
+			read_unlock(&gpc2->lock);
+			read_unlock_irqrestore(&gpc1->lock, flags);
 
-		/*
-		 * Next, write the new runstate. This is in the *same* place
-		 * for 32-bit and 64-bit guests, asserted here for paranoia.
-		 */
-		BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=
-			     offsetof(struct compat_vcpu_runstate_info, state));
-		BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state) !=
-			     sizeof(vx->current_runstate));
-		BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state) !=
-			     sizeof(vx->current_runstate));
-		*user_state = vx->current_runstate;
+			/* When invoked from kvm_sched_out() we cannot sleep */
+			if (atomic)
+				return;
 
-		/*
-		 * Then the actual runstate_entry_time (with the UPDATE bit
-		 * still set).
-		 */
-		*user_times = vx->runstate_entry_time | XEN_RUNSTATE_UPDATE;
+			/*
+			 * Use kvm_gpc_activate() here because if the runstate
+			 * area was configured in 32-bit mode and only extends
+			 * to the second page now because the guest changed to
+			 * 64-bit mode, the second GPC won't have been set up.
+			 */
+			if (kvm_gpc_activate(v->kvm, gpc2, NULL, KVM_HOST_USES_PFN,
+					     gpc1->gpa + user_len1, user_len2))
+				return;
+
+			/*
+			 * We dropped the lock on GPC1 so we have to go all the
+			 * way back and revalidate that too.
+			 */
+			goto retry;
+		}
 
 		/*
-		 * Write the actual runstate times immediately after the
-		 * runstate_entry_time.
+		 * In this case, the runstate_info struct will be assembled on
+		 * the kernel stack (compat or not as appropriate) and will
+		 * be copied to GPC1/GPC2 with a dual memcpy. Set up the three
+		 * rs pointers accordingly.
 		 */
-		BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
-			     offsetof(struct vcpu_runstate_info, time) - sizeof(u64));
-		BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state_entry_time) !=
-			     offsetof(struct compat_vcpu_runstate_info, time) - sizeof(u64));
-		BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
-			     sizeof_field(struct compat_vcpu_runstate_info, time));
-		BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
-			     sizeof(vx->runstate_times));
-		memcpy(user_times + 1, vx->runstate_times, sizeof(vx->runstate_times));
-
-		smp_wmb();
+		rs_times = &rs.state_entry_time;
 
 		/*
-		 * Finally, clear the 'updating' bit. Don't use &= here because
-		 * the compiler may not realise that update_bit and user_times
-		 * point to the same place. That's a classic pointer-aliasing
-		 * problem.
+		 * The rs_state pointer points to the start of what we'll
+		 * copy to the guest, which in the case of a compat guest
+		 * is the 32-bit field that the compiler thinks is padding.
 		 */
-		*update_bit = vx->runstate_entry_time >> 56;
-		smp_wmb();
-
-		goto done_1;
-	}
-
-	/*
-	 * The painful code path. It's split across two pages and we need to
-	 * hold and validate both GPCs simultaneously. Thankfully we can get
-	 * away with declaring a lock ordering GPC1 > GPC2 because nothing
-	 * else takes them more than one at a time.
-	 */
-	read_lock(&gpc2->lock);
-
-	if (!kvm_gpc_check(v->kvm, gpc2, gpc2->gpa, user_len2)) {
-		read_unlock(&gpc2->lock);
-		read_unlock_irqrestore(&gpc1->lock, flags);
-
-		/* When invoked from kvm_sched_out() we cannot sleep */
-		if (atomic)
-			return;
+		rs_state = ((void *)rs_times) - times_ofs;
 
 		/*
-		 * Use kvm_gpc_activate() here because if the runstate
-		 * area was configured in 32-bit mode and only extends
-		 * to the second page now because the guest changed to
-		 * 64-bit mode, the second GPC won't have been set up.
+		 * The update_bit is still directly in the guest memory,
+		 * via one GPC or the other.
 		 */
-		if (kvm_gpc_activate(v->kvm, gpc2, NULL, KVM_HOST_USES_PFN,
-				     gpc1->gpa + user_len1, user_len2))
-			return;
+		if (user_len1 >= times_ofs + sizeof(uint64_t))
+			update_bit = gpc1->khva + times_ofs +
+				sizeof(uint64_t) - 1;
+		else
+			update_bit = gpc2->khva + times_ofs +
+				sizeof(uint64_t) - 1 - user_len1;
 
+#ifdef CONFIG_X86_64
 		/*
-		 * We dropped the lock on GPC1 so we have to go all the way
-		 * back and revalidate that too.
+		 * Don't leak kernel memory through the padding in the 64-bit
+		 * version of the struct.
 		 */
-		goto retry;
+		memset(&rs, 0, offsetof(struct vcpu_runstate_info, state_entry_time));
+#endif
 	}
 
 	/*
-	 * Work out where the byte containing the XEN_RUNSTATE_UPDATE bit is.
+	 * First, set the XEN_RUNSTATE_UPDATE bit in the top bit of the
+	 * state_entry_time field, directly in the guest. We need to set
+	 * that (and write-barrier) before writing to the rest of the
+	 * structure, and clear it last. Just as Xen does, we address the
+	 * single *byte* in which it resides because it might be in a
+	 * different cache line to the rest of the 64-bit word, due to
+	 * the (lack of) alignment constraints.
 	 */
-	if (user_len1 >= times_ofs + sizeof(uint64_t))
-		update_bit = ((u8 *)gpc1->khva) + times_ofs + sizeof(u64) - 1;
-	else
-		update_bit = ((u8 *)gpc2->khva) + times_ofs + sizeof(u64) - 1 -
-			user_len1;
+	*update_bit = (vx->runstate_entry_time | XEN_RUNSTATE_UPDATE) >> 56;
+	smp_wmb();
 
 	/*
-	 * Create a structure on our stack with everything in the right place.
-	 * The rs_state pointer points to the start of it, which in the case
-	 * of a compat guest on a 64-bit host is the 32 bit field that the
-	 * compiler thinks is padding.
+	 * Now assemble the actual structure, either on our kernel stack
+	 * or directly in the guest according to how the rs_state and
+	 * rs_times pointers were set up above.
 	 */
 	*rs_state = vx->current_runstate;
-	rs.state_entry_time = vx->runstate_entry_time | XEN_RUNSTATE_UPDATE;
-	memcpy(rs.time, vx->runstate_times, sizeof(vx->runstate_times));
-
-	*update_bit = rs.state_entry_time >> 56;
-	smp_wmb();
+	rs_times[0] = vx->runstate_entry_time | XEN_RUNSTATE_UPDATE;
+	memcpy(rs_times + 1, vx->runstate_times, sizeof(vx->runstate_times));
 
-	/*
-	 * Having constructed the structure starting at *rs_state, copy it
-	 * into the first and second pages as appropriate using user_len1
-	 * and user_len2.
-	 */
-	memcpy(gpc1->khva, rs_state, user_len1);
-	memcpy(gpc2->khva, ((u8 *)rs_state) + user_len1, user_len2);
+	/* For the split case, we have to then copy it to the guest. */
+	if (user_len2) {
+		memcpy(gpc1->khva, rs_state, user_len1);
+		memcpy(gpc2->khva, ((void *)rs_state) + user_len1, user_len2);
+	}
 	smp_wmb();
 
-	/*
-	 * Finally, clear the XEN_RUNSTATE_UPDATE bit.
-	 */
+	/* Finally, clear the XEN_RUNSTATE_UPDATE bit. */
 	*update_bit = vx->runstate_entry_time >> 56;
 	smp_wmb();
 
 	if (user_len2)
 		read_unlock(&gpc2->lock);
- done_1:
+
 	read_unlock_irqrestore(&gpc1->lock, flags);
 
 	mark_page_dirty_in_slot(v->kvm, gpc1->memslot, gpc1->gpa >> PAGE_SHIFT);
-- 
2.35.3

