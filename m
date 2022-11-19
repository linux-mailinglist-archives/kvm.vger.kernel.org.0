Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C5B630DEA
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 10:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbiKSJrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Nov 2022 04:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbiKSJrK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Nov 2022 04:47:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD77A8C1A
        for <kvm@vger.kernel.org>; Sat, 19 Nov 2022 01:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=9F69WLXkDxwT35uS3G7xHdywsUygeoca9EmQX5pB8ZQ=; b=aCH230tw9v7IQx+rFEdsrjEekc
        q2YfGjFU1k6HyWMPF+yKZb6GvjhGWeku6U7VCR30uQB1Sywh5lmUV9QK+xbELEMEZhI5Qtm5CFWpj
        9rbugisk9avkZ4WFqnYRuJHXacODS/hAYCPZQstzq2z4S2TYIx2sDdHKek0ZsVvlfJYyp4sVujqZj
        aYhcj4l0BBKWNiHQ4sFOrcdVrVcDOYmbxmpq7tkCLqMTfJ1Z7xZabxGtf6CuGHQBPUNvN4QTZpsJ8
        fT6Zw4zBvibCWuwMhzGfOVSmF1g/9oNQrMcQONiU1q3F/eAX18refP07yVsV0w5oJtd64uqAxq6Q8
        S0gCHR3Q==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1owKRG-0038Mb-Iq; Sat, 19 Nov 2022 09:47:06 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1owKR9-00035i-Ln; Sat, 19 Nov 2022 09:46:59 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, mhal@rbox.co
Subject: [PATCH 2/4] KVM: x86/xen: Compatibility fixes for shared runstate area
Date:   Sat, 19 Nov 2022 09:46:57 +0000
Message-Id: <20221119094659.11868-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221119094659.11868-1-dwmw2@infradead.org>
References: <20221119094659.11868-1-dwmw2@infradead.org>
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

The guest runstate area can be arbitrarily byte-aligned. In fact, even
when a sane 32-bit guest aligns the overall structure nicely, the 64-bit
fields in the structure end up being unaligned due to the fact that the
32-bit ABI only aligns them to 32 bits.

So setting the ->state_entry_time field to something|XEN_RUNSTATE_UPDATE
is buggy, because if it's unaligned then we can't update the whole field
atomically; the low bytes might be observable before the _UPDATE bit is.
Xen actually updates the *byte* containing that top bit, on its own. KVM
should do the same.

In addition, we cannot assume that the runstate area fits within a single
page. One option might be to make the gfn_to_pfn cache cope with regions
that cross a page — but getting a contiguous virtual kernel mapping of a
discontiguous set of IOMEM pages is a distinctly non-trivial exercise,
and it seems this is the *only* current use case for the GPC which would
benefit from it.

An earlier version of the runstate code did use a gfn_to_hva cache for
this purpose, but it still had the single-page restriction because it
used the uhva directly — because it needs to be able to do so atomically
when the vCPU is being scheduled out, so it used pagefault_disable()
around the accesses and didn't just use kvm_write_guest_cached() which
has a fallback path.

So... use a pair of GPCs for the first and potential second page covering
the runstate area. We can get away with locking both at once because
nothing else takes more than one GPC lock at a time so we can invent
a trivial ordering rule.

Keep the trivial fast path for the common case where it's all in the
same page, but fixed to use a byte access for the XEN_RUNSTATE_UPDATE
bit. And in the cross-page case, build the structure locally on the
stack and then copy it over with two memcpy() calls, again handling
the XEN_RUNSTATE_UPDATE bit through a single byte access.

Finally, Xen also does write the runstate area immediately when it's
configured. Flip the kvm_xen_update_runstate() and …_guest() functions
and call the latter directly when the runstate area is set. This means
that other ioctls which modify the runstate also write it immediately
to the guest when they do so, which is also intended.

Update the xen_shinfo_test to exercise the pathological case where the
XEN_RUNSTATE_UPDATE flag in the top byte of the state_entry_time is
actually in a different page to the rest of the 64-bit word.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kvm/xen.c                            | 367 +++++++++++++-----
 arch/x86/kvm/xen.h                            |   6 +-
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |  12 +-
 4 files changed, 272 insertions(+), 114 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d1013c4f673c..70af7240a1d5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -686,6 +686,7 @@ struct kvm_vcpu_xen {
 	struct gfn_to_pfn_cache vcpu_info_cache;
 	struct gfn_to_pfn_cache vcpu_time_info_cache;
 	struct gfn_to_pfn_cache runstate_cache;
+	struct gfn_to_pfn_cache runstate2_cache;
 	u64 last_steal;
 	u64 runstate_entry_time;
 	u64 runstate_times[4];
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 4b8e9628fbf5..8aa953b1f0e0 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -170,148 +170,269 @@ static void kvm_xen_init_timer(struct kvm_vcpu *vcpu)
 	vcpu->arch.xen.timer.function = xen_timer_callback;
 }
 
-static void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
+static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 {
 	struct kvm_vcpu_xen *vx = &v->arch.xen;
-	u64 now = get_kvmclock_ns(v->kvm);
-	u64 delta_ns = now - vx->runstate_entry_time;
-	u64 run_delay = current->sched_info.run_delay;
+	struct gfn_to_pfn_cache *gpc1 = &vx->runstate_cache;
+	struct gfn_to_pfn_cache *gpc2 = &vx->runstate2_cache;
+	size_t user_len, user_len1, user_len2;
+	struct vcpu_runstate_info rs;
+	int *rs_state = &rs.state;
+	unsigned long flags;
+	size_t times_ofs;
+	u8 *update_bit;
 
-	if (unlikely(!vx->runstate_entry_time))
-		vx->current_runstate = RUNSTATE_offline;
+	/*
+	 * The only difference between 32-bit and 64-bit versions of the
+	 * runstate struct us the alignment of uint64_t in 32-bit, which
+	 * means that the 64-bit version has an additional 4 bytes of
+	 * padding after the first field 'state'.
+	 */
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) != 0);
+	BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state) != 0);
+	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) != 0x2c);
+#ifdef CONFIG_X86_64
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
+		     offsetof(struct compat_vcpu_runstate_info, state_entry_time) + 4);
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, time) !=
+		     offsetof(struct compat_vcpu_runstate_info, time) + 4);
+#endif
+
+	if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode) {
+		user_len = sizeof(struct vcpu_runstate_info);
+		times_ofs = offsetof(struct vcpu_runstate_info,
+				     state_entry_time);
+	} else {
+		user_len = sizeof(struct compat_vcpu_runstate_info);
+		times_ofs = offsetof(struct compat_vcpu_runstate_info,
+				     state_entry_time);
+		rs_state++;
+	}
 
 	/*
-	 * Time waiting for the scheduler isn't "stolen" if the
-	 * vCPU wasn't running anyway.
+	 * There are basically no alignment constraints. The guest can set it
+	 * up so it crosses from one page to the next, and at arbitrary byte
+	 * alignment (and the 32-bit ABI doesn't align the 64-bit integers
+	 * anyway, even if the overall struct had been 64-bit aligned).
 	 */
-	if (vx->current_runstate == RUNSTATE_running) {
-		u64 steal_ns = run_delay - vx->last_steal;
+	if ((gpc1->gpa & ~PAGE_MASK) + user_len >= PAGE_SIZE) {
+		user_len1 = PAGE_SIZE - (gpc1->gpa & ~PAGE_MASK);
+		user_len2 = user_len - user_len1;
+	} else {
+		user_len1 = user_len;
+		user_len2 = 0;
+	}
+	BUG_ON(user_len1 + user_len2 != user_len);
 
-		delta_ns -= steal_ns;
+ retry:
+	/*
+	 * Attempt to obtain the GPC lock on *both* (if there are two)
+	 * gfn_to_pfn caches that cover the region.
+	 */
+	read_lock_irqsave(&gpc1->lock, flags);
+	while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc1, gpc1->gpa, user_len1)) {
+		read_unlock_irqrestore(&gpc1->lock, flags);
 
-		vx->runstate_times[RUNSTATE_runnable] += steal_ns;
+		/* When invoked from kvm_sched_out() we cannot sleep */
+		if (atomic)
+			return;
+
+		if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc1, gpc1->gpa, user_len1))
+			return;
+
+		read_lock_irqsave(&gpc1->lock, flags);
 	}
-	vx->last_steal = run_delay;
 
-	vx->runstate_times[vx->current_runstate] += delta_ns;
-	vx->current_runstate = state;
-	vx->runstate_entry_time = now;
-}
+	/*
+	 * The common case is that it all fits on a page and we can
+	 * just do it the simple way.
+	 */
+	if (likely(!user_len2)) {
+		/*
+		 * We use 'int *user_state' to point to the state field, and
+		 * 'u64 *user_times' for runstate_entry_time. So the actual
+		 * array of time[] in each state starts at user_times[1].
+		 */
+		int *user_state = gpc1->khva;
+		u64 *user_times = gpc1->khva + times_ofs;
 
-void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
-{
-	struct kvm_vcpu_xen *vx = &v->arch.xen;
-	struct gfn_to_pfn_cache *gpc = &vx->runstate_cache;
-	uint64_t *user_times;
-	unsigned long flags;
-	size_t user_len;
-	int *user_state;
+		/*
+		 * The XEN_RUNSTATE_UPDATE bit is the top bit of the state_entry_time
+		 * field. We need to set it (and write-barrier) before writing to the
+		 * the rest of the structure, and clear it last. Just as Xen does, we
+		 * address the single *byte* in which it resides because it might be
+		 * in a different cache line to the rest of the 64-bit word, due to
+		 * the (lack of) alignment constraints.
+		 */
+		BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state_entry_time) !=
+			     sizeof(uint64_t));
+		BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state_entry_time) !=
+			     sizeof(uint64_t));
+		BUILD_BUG_ON((XEN_RUNSTATE_UPDATE >> 56) != 0x80);
 
-	kvm_xen_update_runstate(v, state);
+		update_bit = ((u8 *)(&user_times[1])) - 1;
+		*update_bit = (vx->runstate_entry_time | XEN_RUNSTATE_UPDATE) >> 56;
+		smp_wmb();
 
-	if (!vx->runstate_cache.active)
-		return;
+		/*
+		 * Next, write the new runstate. This is in the *same* place
+		 * for 32-bit and 64-bit guests, asserted here for paranoia.
+		 */
+		BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=
+			     offsetof(struct compat_vcpu_runstate_info, state));
+		BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state) !=
+			     sizeof(vx->current_runstate));
+		BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state) !=
+			     sizeof(vx->current_runstate));
+		*user_state = vx->current_runstate;
 
-	if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode)
-		user_len = sizeof(struct vcpu_runstate_info);
-	else
-		user_len = sizeof(struct compat_vcpu_runstate_info);
+		/*
+		 * Then the actual runstate_entry_time (with the UPDATE bit
+		 * still set).
+		 */
+		*user_times = vx->runstate_entry_time | XEN_RUNSTATE_UPDATE;
 
-	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc, gpc->gpa,
-					   user_len)) {
-		read_unlock_irqrestore(&gpc->lock, flags);
+		/*
+		 * Write the actual runstate times immediately after the
+		 * runstate_entry_time.
+		 */
+		BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
+			     offsetof(struct vcpu_runstate_info, time) - sizeof(u64));
+		BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state_entry_time) !=
+			     offsetof(struct compat_vcpu_runstate_info, time) - sizeof(u64));
+		BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
+			     sizeof_field(struct compat_vcpu_runstate_info, time));
+		BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
+			     sizeof(vx->runstate_times));
+		memcpy(user_times + 1, vx->runstate_times, sizeof(vx->runstate_times));
+
+		smp_wmb();
+
+		/*
+		 * Finally, clear the 'updating' bit. Don't use &= here because
+		 * the compiler may not realise that update_bit and user_times
+		 * point to the same place. That's a classic pointer-aliasing
+		 * problem.
+		 */
+		*update_bit = vx->runstate_entry_time >> 56;
+		smp_wmb();
+
+		goto done_1;
+	}
+
+	/*
+	 * The painful code path. It's split across two pages and we need to
+	 * hold and validate both GPCs simultaneously. Thankfully we can get
+	 * away with declaring a lock ordering GPC1 > GPC2 because nothing
+	 * else takes them more than one at a time.
+	 */
+	read_lock(&gpc2->lock);
+
+	if (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc2, gpc2->gpa, user_len2)) {
+		read_unlock(&gpc2->lock);
+		read_unlock_irqrestore(&gpc1->lock, flags);
 
 		/* When invoked from kvm_sched_out() we cannot sleep */
-		if (state == RUNSTATE_runnable)
+		if (atomic)
 			return;
 
-		if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc, gpc->gpa, user_len))
+		/*
+		 * Use kvm_gpc_activate() here because if the runstate
+		 * area was configured in 32-bit mode and only extends
+		 * to the second page now because the guest changed to
+		 * 64-bit mode, the second GPC won't have been set up.
+		 */
+		if (kvm_gpc_activate(v->kvm, gpc2, NULL, KVM_HOST_USES_PFN,
+				     gpc1->gpa + user_len1, user_len2))
 			return;
 
-		read_lock_irqsave(&gpc->lock, flags);
+		/*
+		 * We dropped the lock on GPC1 so we have to go all the way
+		 * back and revalidate that too.
+		 */
+		goto retry;
 	}
 
 	/*
-	 * The only difference between 32-bit and 64-bit versions of the
-	 * runstate struct us the alignment of uint64_t in 32-bit, which
-	 * means that the 64-bit version has an additional 4 bytes of
-	 * padding after the first field 'state'.
-	 *
-	 * So we use 'int __user *user_state' to point to the state field,
-	 * and 'uint64_t __user *user_times' for runstate_entry_time. So
-	 * the actual array of time[] in each state starts at user_times[1].
+	 * Work out where the byte containing the XEN_RUNSTATE_UPDATE bit is.
 	 */
-	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) != 0);
-	BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state) != 0);
-	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) != 0x2c);
-#ifdef CONFIG_X86_64
-	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
-		     offsetof(struct compat_vcpu_runstate_info, state_entry_time) + 4);
-	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, time) !=
-		     offsetof(struct compat_vcpu_runstate_info, time) + 4);
-#endif
-
-	user_state = gpc->khva;
-
-	if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode)
-		user_times = gpc->khva + offsetof(struct vcpu_runstate_info,
-						  state_entry_time);
+	if (user_len1 >= times_ofs + sizeof(uint64_t))
+		update_bit = ((u8 *)gpc1->khva) + times_ofs + sizeof(u64) - 1;
 	else
-		user_times = gpc->khva + offsetof(struct compat_vcpu_runstate_info,
-						  state_entry_time);
+		update_bit = ((u8 *)gpc2->khva) + times_ofs + sizeof(u64) - 1 -
+			user_len1;
 
-	/*
-	 * First write the updated state_entry_time at the appropriate
-	 * location determined by 'offset'.
+
+	/* Create a structure on our stack with everything in the right place.
+	 * The rs_state pointer points to the start of it, which in the case
+	 * of a compat guest on a 64-bit host is the 32 bit field that the
+	 * compiler thinks is padding.
 	 */
-	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state_entry_time) !=
-		     sizeof(user_times[0]));
-	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state_entry_time) !=
-		     sizeof(user_times[0]));
+	*rs_state = vx->current_runstate;
+#ifdef CONFIG_X86_64
+	/* Don't leak kernel memory through the padding in the 64-bit struct */
+	if (rs_state == &rs.state)
+		rs_state[1] = 0;
+#endif
+	rs.state_entry_time = vx->runstate_entry_time | XEN_RUNSTATE_UPDATE;
+	memcpy(rs.time, vx->runstate_times, sizeof(vx->runstate_times));
 
-	user_times[0] = vx->runstate_entry_time | XEN_RUNSTATE_UPDATE;
+	*update_bit = rs.state_entry_time >> 56;
 	smp_wmb();
 
 	/*
-	 * Next, write the new runstate. This is in the *same* place
-	 * for 32-bit and 64-bit guests, asserted here for paranoia.
+	 * Having constructed the structure, copy it into the first and
+	 * second pages as appropriate using user_len1 and user_len2.
 	 */
-	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=
-		     offsetof(struct compat_vcpu_runstate_info, state));
-	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state) !=
-		     sizeof(vx->current_runstate));
-	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state) !=
-		     sizeof(vx->current_runstate));
-
-	*user_state = vx->current_runstate;
+	memcpy(gpc1->khva, rs_state, user_len1);
+	memcpy(gpc2->khva, ((u8 *)rs_state) + user_len1, user_len2);
+	smp_wmb();
 
 	/*
-	 * Write the actual runstate times immediately after the
-	 * runstate_entry_time.
+	 * Finally, clear the XEN_RUNSTATE_UPDATE bit.
 	 */
-	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
-		     offsetof(struct vcpu_runstate_info, time) - sizeof(u64));
-	BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state_entry_time) !=
-		     offsetof(struct compat_vcpu_runstate_info, time) - sizeof(u64));
-	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
-		     sizeof_field(struct compat_vcpu_runstate_info, time));
-	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
-		     sizeof(vx->runstate_times));
-
-	memcpy(user_times + 1, vx->runstate_times, sizeof(vx->runstate_times));
+	*update_bit = vx->runstate_entry_time >> 56;
 	smp_wmb();
 
+	if (user_len2)
+		read_unlock(&gpc2->lock);
+ done_1:
+	read_unlock_irqrestore(&gpc1->lock, flags);
+
+	mark_page_dirty_in_slot(v->kvm, gpc1->memslot, gpc1->gpa >> PAGE_SHIFT);
+	if (user_len2)
+		mark_page_dirty_in_slot(v->kvm, gpc2->memslot, gpc2->gpa >> PAGE_SHIFT);
+}
+
+void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
+{
+	struct kvm_vcpu_xen *vx = &v->arch.xen;
+	u64 now = get_kvmclock_ns(v->kvm);
+	u64 delta_ns = now - vx->runstate_entry_time;
+	u64 run_delay = current->sched_info.run_delay;
+
+	if (unlikely(!vx->runstate_entry_time))
+		vx->current_runstate = RUNSTATE_offline;
+
 	/*
-	 * Finally, clear the XEN_RUNSTATE_UPDATE bit in the guest's
-	 * runstate_entry_time field.
+	 * Time waiting for the scheduler isn't "stolen" if the
+	 * vCPU wasn't running anyway.
 	 */
-	user_times[0] &= ~XEN_RUNSTATE_UPDATE;
-	smp_wmb();
+	if (vx->current_runstate == RUNSTATE_running) {
+		u64 steal_ns = run_delay - vx->last_steal;
 
-	read_unlock_irqrestore(&gpc->lock, flags);
+		delta_ns -= steal_ns;
 
-	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
+		vx->runstate_times[RUNSTATE_runnable] += steal_ns;
+	}
+	vx->last_steal = run_delay;
+
+	vx->runstate_times[vx->current_runstate] += delta_ns;
+	vx->current_runstate = state;
+	vx->runstate_entry_time = now;
+
+	if (vx->runstate_cache.active)
+		kvm_xen_update_runstate_guest(v, state == RUNSTATE_runnable);
 }
 
 static void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *v)
@@ -584,23 +705,57 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 		break;
 
-	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR:
+	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR: {
+		size_t sz, sz1, sz2;
+
 		if (!sched_info_on()) {
 			r = -EOPNOTSUPP;
 			break;
 		}
 		if (data->u.gpa == GPA_INVALID) {
+			r = 0;
+		deactivate_out:
 			kvm_gpc_deactivate(vcpu->kvm,
 					   &vcpu->arch.xen.runstate_cache);
-			r = 0;
+			kvm_gpc_deactivate(vcpu->kvm,
+					   &vcpu->arch.xen.runstate2_cache);
 			break;
 		}
 
+		/*
+		 * If the guest switches to 64-bit mode after setting the runstate
+		 * address, that's actually OK. kvm_xen_update_runstate_guest()
+		 * will cope.
+		 */
+		if (IS_ENABLED(CONFIG_64BIT) && vcpu->kvm->arch.xen.long_mode)
+			sz = sizeof(struct vcpu_runstate_info);
+		else
+			sz = sizeof(struct compat_vcpu_runstate_info);
+
+		/* How much fits in the (first) page? */
+		sz1 = PAGE_SIZE - (data->u.gpa & ~PAGE_MASK);
 		r = kvm_gpc_activate(vcpu->kvm, &vcpu->arch.xen.runstate_cache,
-				     NULL, KVM_HOST_USES_PFN, data->u.gpa,
-				     sizeof(struct vcpu_runstate_info));
-		break;
+				     NULL, KVM_HOST_USES_PFN, data->u.gpa, sz1);
+		if (r)
+			goto deactivate_out;
 
+		/* Either map the second page, or deactivate the second GPC */
+		if (sz1 > sz) {
+			kvm_gpc_deactivate(vcpu->kvm,
+					   &vcpu->arch.xen.runstate2_cache);
+		} else {
+			sz2 = sz - sz1;
+			BUG_ON((data->u.gpa + sz1) & ~PAGE_MASK);
+			r = kvm_gpc_activate(vcpu->kvm, &vcpu->arch.xen.runstate2_cache,
+					     NULL, KVM_HOST_USES_PFN,
+					     data->u.gpa + sz1, sz2);
+			if (r)
+				goto deactivate_out;
+		}
+
+		kvm_xen_update_runstate_guest(vcpu, false);
+		break;
+	}
 	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT:
 		if (!sched_info_on()) {
 			r = -EOPNOTSUPP;
@@ -1834,6 +1989,7 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
 	timer_setup(&vcpu->arch.xen.poll_timer, cancel_evtchn_poll, 0);
 
 	kvm_gpc_init(&vcpu->arch.xen.runstate_cache);
+	kvm_gpc_init(&vcpu->arch.xen.runstate2_cache);
 	kvm_gpc_init(&vcpu->arch.xen.vcpu_info_cache);
 	kvm_gpc_init(&vcpu->arch.xen.vcpu_time_info_cache);
 }
@@ -1844,6 +2000,7 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 		kvm_xen_stop_timer(vcpu);
 
 	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.runstate_cache);
+	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.runstate2_cache);
 	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.vcpu_info_cache);
 	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.vcpu_time_info_cache);
 
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 532a535a9e99..8503d2c6891e 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -143,11 +143,11 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
 #include <asm/xen/interface.h>
 #include <xen/interface/vcpu.h>
 
-void kvm_xen_update_runstate_guest(struct kvm_vcpu *vcpu, int state);
+void kvm_xen_update_runstate(struct kvm_vcpu *vcpu, int state);
 
 static inline void kvm_xen_runstate_set_running(struct kvm_vcpu *vcpu)
 {
-	kvm_xen_update_runstate_guest(vcpu, RUNSTATE_running);
+	kvm_xen_update_runstate(vcpu, RUNSTATE_running);
 }
 
 static inline void kvm_xen_runstate_set_preempted(struct kvm_vcpu *vcpu)
@@ -162,7 +162,7 @@ static inline void kvm_xen_runstate_set_preempted(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(!vcpu->preempted))
 		return;
 
-	kvm_xen_update_runstate_guest(vcpu, RUNSTATE_runnable);
+	kvm_xen_update_runstate(vcpu, RUNSTATE_runnable);
 }
 
 /* 32-bit compatibility definitions, also used natively in 32-bit build */
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 2a5727188c8d..7f39815f1772 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -26,17 +26,17 @@
 #define SHINFO_REGION_GPA	0xc0000000ULL
 #define SHINFO_REGION_SLOT	10
 
-#define DUMMY_REGION_GPA	(SHINFO_REGION_GPA + (2 * PAGE_SIZE))
+#define DUMMY_REGION_GPA	(SHINFO_REGION_GPA + (3 * PAGE_SIZE))
 #define DUMMY_REGION_SLOT	11
 
 #define SHINFO_ADDR	(SHINFO_REGION_GPA)
-#define PVTIME_ADDR	(SHINFO_REGION_GPA + PAGE_SIZE)
-#define RUNSTATE_ADDR	(SHINFO_REGION_GPA + PAGE_SIZE + 0x20)
 #define VCPU_INFO_ADDR	(SHINFO_REGION_GPA + 0x40)
+#define PVTIME_ADDR	(SHINFO_REGION_GPA + PAGE_SIZE)
+#define RUNSTATE_ADDR	(SHINFO_REGION_GPA + PAGE_SIZE + PAGE_SIZE - 15)
 
 #define SHINFO_VADDR	(SHINFO_REGION_GVA)
-#define RUNSTATE_VADDR	(SHINFO_REGION_GVA + PAGE_SIZE + 0x20)
 #define VCPU_INFO_VADDR	(SHINFO_REGION_GVA + 0x40)
+#define RUNSTATE_VADDR	(SHINFO_REGION_GVA + PAGE_SIZE + PAGE_SIZE - 15)
 
 #define EVTCHN_VECTOR	0x10
 
@@ -449,8 +449,8 @@ int main(int argc, char *argv[])
 
 	/* Map a region for the shared_info page */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-				    SHINFO_REGION_GPA, SHINFO_REGION_SLOT, 2, 0);
-	virt_map(vm, SHINFO_REGION_GVA, SHINFO_REGION_GPA, 2);
+				    SHINFO_REGION_GPA, SHINFO_REGION_SLOT, 3, 0);
+	virt_map(vm, SHINFO_REGION_GVA, SHINFO_REGION_GPA, 3);
 
 	struct shared_info *shinfo = addr_gpa2hva(vm, SHINFO_VADDR);
 
-- 
2.35.3

