Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF00D67DCF2
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 05:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjA0Ep3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 23:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjA0Ep1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 23:45:27 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2278E73770
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 20:45:23 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id x5so407099plr.2
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 20:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sm5+zxZ8TukkvdWRFsQQygkxSem3YXdv7EANNgiD4ZQ=;
        b=lmhxQ/XzVr8v0Ewn2LZYjsmdA6i4mZjwixkwAIMotR5Gtv3YFr4tO3ZjaZJ8bMry9l
         hxgTGJ8yBe4I3+syBMYMvaX/yDK6y0tLKulMdg+y4OI9xrTUjFO7gggkf/0uzn84Dd4y
         jZyjocPkL2pYx0+09r7Ska61Dxk6w4404VI7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sm5+zxZ8TukkvdWRFsQQygkxSem3YXdv7EANNgiD4ZQ=;
        b=eK/HWD9KeV4wcPEvIfrp1TSBgTomaNRUpSHpB0jY8tGXSwt8GUqTHKNyKP2JOXzghn
         /1ZdE4CryCrAoWds0RjR8KBGbcoS/xNml8tAv+eOcA5GkGl7sEjHcr1x1dd+pg5uCPBP
         DBeuX0PwRxEz1zgjFPAw+62NaQRahuNyQ0HdhUdwhb+fbiwwJ9GAh/s46EDO/6Kor5hP
         y0KwnEXFnNAP+BlXdSFjlqRqxivRYGKXB3eUamXpOSD8Yn0Xqc6xhZV30V1Q5VeKrvEJ
         RCABs1m5LxOoFN0rN/cXrXY0V/u68uj6NVyOpBP8egGCpKGDg32UxvQnDnAlTjbDr1Hu
         if2A==
X-Gm-Message-State: AFqh2kq2Q1EATrEa6QYMFtmjY4jt8hd6k1lKB9o+Chc0q89kTx+O2c15
        mNa2LDbRr/4cGaL+FvdGbiDvTg==
X-Google-Smtp-Source: AMrXdXu8snVhnzJTA5BW/CDMWl8OUgN5sAZ2Vn9jG46DmeEFp8me5umAYFjR/4sDLubVfvBFhSBbuA==
X-Received: by 2002:a05:6a20:d48f:b0:bb:84a1:68b0 with SMTP id im15-20020a056a20d48f00b000bb84a168b0mr14174687pzb.55.1674794722498;
        Thu, 26 Jan 2023 20:45:22 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:24fb:4159:9391:441d])
        by smtp.gmail.com with UTF8SMTPSA id f190-20020a636ac7000000b004a737a6e62fsm1465547pgc.14.2023.01.26.20.45.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 20:45:22 -0800 (PST)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH 1/3] KVM: Support sharing gpc locks
Date:   Fri, 27 Jan 2023 13:44:58 +0900
Message-Id: <20230127044500.680329-2-stevensd@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
In-Reply-To: <20230127044500.680329-1-stevensd@google.com>
References: <20230127044500.680329-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Support initializing a gfn_to_pfn_cache with an external lock instead of
its embedded lock. This allows groups of gpcs that are accessed together
to share a lock, which can greatly simplify locking.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/x86/kvm/x86.c        |  8 +++---
 arch/x86/kvm/xen.c        | 58 +++++++++++++++++++--------------------
 include/linux/kvm_host.h  | 12 ++++++++
 include/linux/kvm_types.h |  3 +-
 virt/kvm/pfncache.c       | 37 +++++++++++++++----------
 5 files changed, 70 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 508074e47bc0..ec0de9bc2eae 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3047,14 +3047,14 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	struct pvclock_vcpu_time_info *guest_hv_clock;
 	unsigned long flags;
 
-	read_lock_irqsave(&gpc->lock, flags);
+	read_lock_irqsave(gpc->lock, flags);
 	while (!kvm_gpc_check(gpc, offset + sizeof(*guest_hv_clock))) {
-		read_unlock_irqrestore(&gpc->lock, flags);
+		read_unlock_irqrestore(gpc->lock, flags);
 
 		if (kvm_gpc_refresh(gpc, offset + sizeof(*guest_hv_clock)))
 			return;
 
-		read_lock_irqsave(&gpc->lock, flags);
+		read_lock_irqsave(gpc->lock, flags);
 	}
 
 	guest_hv_clock = (void *)(gpc->khva + offset);
@@ -3083,7 +3083,7 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	guest_hv_clock->version = ++vcpu->hv_clock.version;
 
 	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
-	read_unlock_irqrestore(&gpc->lock, flags);
+	read_unlock_irqrestore(gpc->lock, flags);
 
 	trace_kvm_pvclock_update(v->vcpu_id, &vcpu->hv_clock);
 }
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 2681e2007e39..fa8ab23271d3 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -59,12 +59,12 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 		wall_nsec = ktime_get_real_ns() - get_kvmclock_ns(kvm);
 
 		/* It could be invalid again already, so we need to check */
-		read_lock_irq(&gpc->lock);
+		read_lock_irq(gpc->lock);
 
 		if (gpc->valid)
 			break;
 
-		read_unlock_irq(&gpc->lock);
+		read_unlock_irq(gpc->lock);
 	} while (1);
 
 	/* Paranoia checks on the 32-bit struct layout */
@@ -101,7 +101,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 	smp_wmb();
 
 	wc->version = wc_version + 1;
-	read_unlock_irq(&gpc->lock);
+	read_unlock_irq(gpc->lock);
 
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MASTERCLOCK_UPDATE);
 
@@ -274,15 +274,15 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 	 */
 	if (atomic) {
 		local_irq_save(flags);
-		if (!read_trylock(&gpc1->lock)) {
+		if (!read_trylock(gpc1->lock)) {
 			local_irq_restore(flags);
 			return;
 		}
 	} else {
-		read_lock_irqsave(&gpc1->lock, flags);
+		read_lock_irqsave(gpc1->lock, flags);
 	}
 	while (!kvm_gpc_check(gpc1, user_len1)) {
-		read_unlock_irqrestore(&gpc1->lock, flags);
+		read_unlock_irqrestore(gpc1->lock, flags);
 
 		/* When invoked from kvm_sched_out() we cannot sleep */
 		if (atomic)
@@ -291,7 +291,7 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 		if (kvm_gpc_refresh(gpc1, user_len1))
 			return;
 
-		read_lock_irqsave(&gpc1->lock, flags);
+		read_lock_irqsave(gpc1->lock, flags);
 	}
 
 	if (likely(!user_len2)) {
@@ -316,19 +316,19 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 		 * takes them more than one at a time. Set a subclass on the
 		 * gpc1 lock to make lockdep shut up about it.
 		 */
-		lock_set_subclass(&gpc1->lock.dep_map, 1, _THIS_IP_);
+		lock_set_subclass(gpc1->lock.dep_map, 1, _THIS_IP_);
 		if (atomic) {
-			if (!read_trylock(&gpc2->lock)) {
-				read_unlock_irqrestore(&gpc1->lock, flags);
+			if (!read_trylock(gpc2->lock)) {
+				read_unlock_irqrestore(gpc1->lock, flags);
 				return;
 			}
 		} else {
-			read_lock(&gpc2->lock);
+			read_lock(gpc2->lock);
 		}
 
 		if (!kvm_gpc_check(gpc2, user_len2)) {
-			read_unlock(&gpc2->lock);
-			read_unlock_irqrestore(&gpc1->lock, flags);
+			read_unlock(gpc2->lock);
+			read_unlock_irqrestore(gpc1->lock, flags);
 
 			/* When invoked from kvm_sched_out() we cannot sleep */
 			if (atomic)
@@ -428,9 +428,9 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 	}
 
 	if (user_len2)
-		read_unlock(&gpc2->lock);
+		read_unlock(gpc2->lock);
 
-	read_unlock_irqrestore(&gpc1->lock, flags);
+	read_unlock_irqrestore(gpc1->lock, flags);
 
 	mark_page_dirty_in_slot(v->kvm, gpc1->memslot, gpc1->gpa >> PAGE_SHIFT);
 	if (user_len2)
@@ -505,14 +505,14 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 	 * does anyway. Page it in and retry the instruction. We're just a
 	 * little more honest about it.
 	 */
-	read_lock_irqsave(&gpc->lock, flags);
+	read_lock_irqsave(gpc->lock, flags);
 	while (!kvm_gpc_check(gpc, sizeof(struct vcpu_info))) {
-		read_unlock_irqrestore(&gpc->lock, flags);
+		read_unlock_irqrestore(gpc->lock, flags);
 
 		if (kvm_gpc_refresh(gpc, sizeof(struct vcpu_info)))
 			return;
 
-		read_lock_irqsave(&gpc->lock, flags);
+		read_lock_irqsave(gpc->lock, flags);
 	}
 
 	/* Now gpc->khva is a valid kernel address for the vcpu_info */
@@ -540,7 +540,7 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 			     : "0" (evtchn_pending_sel32));
 		WRITE_ONCE(vi->evtchn_upcall_pending, 1);
 	}
-	read_unlock_irqrestore(&gpc->lock, flags);
+	read_unlock_irqrestore(gpc->lock, flags);
 
 	/* For the per-vCPU lapic vector, deliver it as MSI. */
 	if (v->arch.xen.upcall_vector)
@@ -568,9 +568,9 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 	BUILD_BUG_ON(sizeof(rc) !=
 		     sizeof_field(struct compat_vcpu_info, evtchn_upcall_pending));
 
-	read_lock_irqsave(&gpc->lock, flags);
+	read_lock_irqsave(gpc->lock, flags);
 	while (!kvm_gpc_check(gpc, sizeof(struct vcpu_info))) {
-		read_unlock_irqrestore(&gpc->lock, flags);
+		read_unlock_irqrestore(gpc->lock, flags);
 
 		/*
 		 * This function gets called from kvm_vcpu_block() after setting the
@@ -590,11 +590,11 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 			 */
 			return 0;
 		}
-		read_lock_irqsave(&gpc->lock, flags);
+		read_lock_irqsave(gpc->lock, flags);
 	}
 
 	rc = ((struct vcpu_info *)gpc->khva)->evtchn_upcall_pending;
-	read_unlock_irqrestore(&gpc->lock, flags);
+	read_unlock_irqrestore(gpc->lock, flags);
 	return rc;
 }
 
@@ -1172,7 +1172,7 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
 	int idx, i;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	read_lock_irqsave(&gpc->lock, flags);
+	read_lock_irqsave(gpc->lock, flags);
 	if (!kvm_gpc_check(gpc, PAGE_SIZE))
 		goto out_rcu;
 
@@ -1193,7 +1193,7 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
 	}
 
  out_rcu:
-	read_unlock_irqrestore(&gpc->lock, flags);
+	read_unlock_irqrestore(gpc->lock, flags);
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return ret;
@@ -1576,7 +1576,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 
 	idx = srcu_read_lock(&kvm->srcu);
 
-	read_lock_irqsave(&gpc->lock, flags);
+	read_lock_irqsave(gpc->lock, flags);
 	if (!kvm_gpc_check(gpc, PAGE_SIZE))
 		goto out_rcu;
 
@@ -1607,10 +1607,10 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 	} else {
 		rc = 1; /* Delivered to the bitmap in shared_info. */
 		/* Now switch to the vCPU's vcpu_info to set the index and pending_sel */
-		read_unlock_irqrestore(&gpc->lock, flags);
+		read_unlock_irqrestore(gpc->lock, flags);
 		gpc = &vcpu->arch.xen.vcpu_info_cache;
 
-		read_lock_irqsave(&gpc->lock, flags);
+		read_lock_irqsave(gpc->lock, flags);
 		if (!kvm_gpc_check(gpc, sizeof(struct vcpu_info))) {
 			/*
 			 * Could not access the vcpu_info. Set the bit in-kernel
@@ -1644,7 +1644,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 	}
 
  out_rcu:
-	read_unlock_irqrestore(&gpc->lock, flags);
+	read_unlock_irqrestore(gpc->lock, flags);
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	if (kick_vcpu) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 109b18e2789c..7d1f9c6561e3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1279,6 +1279,18 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
 void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
 		  struct kvm_vcpu *vcpu, enum pfn_cache_usage usage);
 
+/**
+ * kvm_gpc_init_with_lock - initialize gfn_to_pfn_cache with an external lock.
+ *
+ * @lock: an initialized rwlock
+ *
+ * See kvm_gpc_init. Allows multiple gfn_to_pfn_cache structs to share the
+ * same lock.
+ */
+void kvm_gpc_init_with_lock(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
+			    struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
+			    rwlock_t *lock);
+
 /**
  * kvm_gpc_activate - prepare a cached kernel mapping and HPA for a given guest
  *                    physical address.
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 76de36e56cdf..b6432c8cc19c 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -70,7 +70,8 @@ struct gfn_to_pfn_cache {
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
 	struct list_head list;
-	rwlock_t lock;
+	rwlock_t *lock;
+	rwlock_t _lock;
 	struct mutex refresh_lock;
 	void *khva;
 	kvm_pfn_t pfn;
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 2d6aba677830..2c6a2edaca9f 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -31,7 +31,7 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 
 	spin_lock(&kvm->gpc_lock);
 	list_for_each_entry(gpc, &kvm->gpc_list, list) {
-		write_lock_irq(&gpc->lock);
+		write_lock_irq(gpc->lock);
 
 		/* Only a single page so no need to care about length */
 		if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
@@ -50,7 +50,7 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 				__set_bit(gpc->vcpu->vcpu_idx, vcpu_bitmap);
 			}
 		}
-		write_unlock_irq(&gpc->lock);
+		write_unlock_irq(gpc->lock);
 	}
 	spin_unlock(&kvm->gpc_lock);
 
@@ -147,7 +147,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 
 	lockdep_assert_held(&gpc->refresh_lock);
 
-	lockdep_assert_held_write(&gpc->lock);
+	lockdep_assert_held_write(gpc->lock);
 
 	/*
 	 * Invalidate the cache prior to dropping gpc->lock, the gpa=>uhva
@@ -160,7 +160,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 		mmu_seq = gpc->kvm->mmu_invalidate_seq;
 		smp_rmb();
 
-		write_unlock_irq(&gpc->lock);
+		write_unlock_irq(gpc->lock);
 
 		/*
 		 * If the previous iteration "failed" due to an mmu_notifier
@@ -208,7 +208,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 			}
 		}
 
-		write_lock_irq(&gpc->lock);
+		write_lock_irq(gpc->lock);
 
 		/*
 		 * Other tasks must wait for _this_ refresh to complete before
@@ -231,7 +231,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	return 0;
 
 out_error:
-	write_lock_irq(&gpc->lock);
+	write_lock_irq(gpc->lock);
 
 	return -EFAULT;
 }
@@ -261,7 +261,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 	 */
 	mutex_lock(&gpc->refresh_lock);
 
-	write_lock_irq(&gpc->lock);
+	write_lock_irq(gpc->lock);
 
 	if (!gpc->active) {
 		ret = -EINVAL;
@@ -321,7 +321,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 	unmap_old = (old_pfn != gpc->pfn);
 
 out_unlock:
-	write_unlock_irq(&gpc->lock);
+	write_unlock_irq(gpc->lock);
 
 	mutex_unlock(&gpc->refresh_lock);
 
@@ -339,20 +339,29 @@ EXPORT_SYMBOL_GPL(kvm_gpc_refresh);
 
 void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
 		  struct kvm_vcpu *vcpu, enum pfn_cache_usage usage)
+{
+	rwlock_init(&gpc->_lock);
+	kvm_gpc_init_with_lock(gpc, kvm, vcpu, usage, &gpc->_lock);
+}
+EXPORT_SYMBOL_GPL(kvm_gpc_init);
+
+void kvm_gpc_init_with_lock(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
+			    struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
+			    rwlock_t *lock)
 {
 	WARN_ON_ONCE(!usage || (usage & KVM_GUEST_AND_HOST_USE_PFN) != usage);
 	WARN_ON_ONCE((usage & KVM_GUEST_USES_PFN) && !vcpu);
 
-	rwlock_init(&gpc->lock);
 	mutex_init(&gpc->refresh_lock);
 
 	gpc->kvm = kvm;
 	gpc->vcpu = vcpu;
+	gpc->lock = lock;
 	gpc->usage = usage;
 	gpc->pfn = KVM_PFN_ERR_FAULT;
 	gpc->uhva = KVM_HVA_ERR_BAD;
 }
-EXPORT_SYMBOL_GPL(kvm_gpc_init);
+EXPORT_SYMBOL_GPL(kvm_gpc_init_with_lock);
 
 int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
 {
@@ -371,9 +380,9 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
 		 * refresh must not establish a mapping until the cache is
 		 * reachable by mmu_notifier events.
 		 */
-		write_lock_irq(&gpc->lock);
+		write_lock_irq(gpc->lock);
 		gpc->active = true;
-		write_unlock_irq(&gpc->lock);
+		write_unlock_irq(gpc->lock);
 	}
 	return __kvm_gpc_refresh(gpc, gpa, len);
 }
@@ -391,7 +400,7 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 		 * must stall mmu_notifier events until all users go away, i.e.
 		 * until gpc->lock is dropped and refresh is guaranteed to fail.
 		 */
-		write_lock_irq(&gpc->lock);
+		write_lock_irq(gpc->lock);
 		gpc->active = false;
 		gpc->valid = false;
 
@@ -406,7 +415,7 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 
 		old_pfn = gpc->pfn;
 		gpc->pfn = KVM_PFN_ERR_FAULT;
-		write_unlock_irq(&gpc->lock);
+		write_unlock_irq(gpc->lock);
 
 		spin_lock(&kvm->gpc_lock);
 		list_del(&gpc->list);
-- 
2.39.1.456.gfc5497dd1b-goog

