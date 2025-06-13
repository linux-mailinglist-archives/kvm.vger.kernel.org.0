Return-Path: <kvm+bounces-49518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61B3FAD9632
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 22:24:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28FEA188837B
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 267B925A645;
	Fri, 13 Jun 2025 20:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I9WjuFOg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f202.google.com (mail-vk1-f202.google.com [209.85.221.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB9C24C664
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 20:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749846203; cv=none; b=SmHPfxlb2b1D/nvOT8bR3ZqnLeJAXTm1P6nQerLluHX28tt0CbTVeMT8suUXtxwwXAXrhKGnFl140KYV+m4Myo896CCBsW1QvPnjWUm9FRv4N04oruHQNQhk61Xmbd/SiEhw9njNFVbdilY+fALToo5eiYmJA4qbMbhNj6WcABk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749846203; c=relaxed/simple;
	bh=dzUbjKgwtVKifHVSIfV4NKEz1SFTqBl8iVQ77HHuxHk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LVz1qCKkfO68l7iTe46JQ677r/tSsjxDP+UaKCxh1sGoXCkNKXAC6osUwRmKeUaihqGVMivf/nXGeYT6MW2rilzboDDQr5wM+3c87YnaIwNgHsLiG6bCYW7bRAdAdmvYXhKo02EQuM+4DoW8mRQ/kxe91iONs/l6TF35CTkwDbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I9WjuFOg; arc=none smtp.client-ip=209.85.221.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vk1-f202.google.com with SMTP id 71dfb90a1353d-531201dea3aso676861e0c.0
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 13:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749846198; x=1750450998; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p4I6JAiiAdLYyuLIsXchDTnm/kISbhPBrTMUxi/etDo=;
        b=I9WjuFOgu1IKIYKErR7IH7UWAGFHVcaOeA9y85t3EKnomfYBZBbb+markzZep/U99E
         sA/4JimN9bWTxBKElub8U3DWr3iV/HD2kTfS5EmDA5aRiRmYojLppbv/qKtet4a15nNp
         sI6te3ZoIy5bVuZtxi8aDvWRa32CMxRVOxaZqjP6ZXdBRZqGLB4PHaQJMhYpjERb72+g
         H292yfwbJRHIA3//64tPV0j9003in1fWD56cPC2xlCuoiAGvFuQ2wy4XXOB73wuzQXrF
         lSzfG8ZKUouc566vU4WpSTWOCytkssIEFkUXcvLKs9ozhXqCM6gDYfUUlN8Q64uAAGzb
         k30A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749846198; x=1750450998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p4I6JAiiAdLYyuLIsXchDTnm/kISbhPBrTMUxi/etDo=;
        b=YlGBUECRyWGDdf1htNArmInP+uB/pPqdd4jWHqqU5u5R6ZpbqAZtYwDJaArEGiA3fc
         zRiGhsQOySDb1B1i69XAbthg94rDunJs3hHBDBcP3zt41JrCNTKEbFbI818TILboYCV6
         0OVQ1IHgZWHdxmkVBfGsE0Z2uc5bZmCCDltcChVU0a0AUoMadDv8Uj4frgo3lTgqLezw
         acHmQOPiFYjYyyLS2OSTGOGBv6YGEaw/zGtXP01orq4a3Qyj08Pj2mNe9bboN75J8lMJ
         nQpQ1AeXAL0adKBBccv6SVBtaXXTfhXRlW8s9SFGDstlwUCGC/RnGXPgb3aDiJksuHBo
         b4jA==
X-Forwarded-Encrypted: i=1; AJvYcCX7vaGvm/2lCG+vbvn41AJkQtjWhZcPyxlr2LIwGlDPqzUD7r6Y/Tl56bIXE0jE9nJ2JGc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiSv9/e3mzA5DILaTE8LWmBtU1CANJ2tmhTk7/9gfP3cbY26FP
	q3ykA7JHYsdD0/MghPNbQM76CpiWk7zg4pk1ouKn07MA4BEEXwWooukq4ghjQkqYfUvhfA7rau2
	XC7m6mqecebPAWI8qeI0xGw==
X-Google-Smtp-Source: AGHT+IHhONEr1zOualJxy8/f69Cy1OwYRI339G/lRZT/rjyJDC/zUL1JqiObAu0L4/WY7ED5S+TF93serVMgpBoZ
X-Received: from vkbee14.prod.google.com ([2002:a05:6122:478e:b0:530:ee8e:a5ef])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6122:31a9:b0:531:19f4:ec19 with SMTP id 71dfb90a1353d-53149cc4357mr1253142e0c.9.1749846198191;
 Fri, 13 Jun 2025 13:23:18 -0700 (PDT)
Date: Fri, 13 Jun 2025 20:23:08 +0000
In-Reply-To: <20250613202315.2790592-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613202315.2790592-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613202315.2790592-2-jthoughton@google.com>
Subject: [PATCH v4 1/7] KVM: x86/mmu: Track TDP MMU NX huge pages separately
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Vipin Sharma <vipinsh@google.com>

Introduce struct kvm_possible_nx_huge_pages to track the list of
possible NX huge pages and the number of pages on the list.

When calculating how many pages to zap, we use the new counts we have
(instead of kvm->stat.nx_lpage_splits, which would be the sum of the two
new counts).

Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
Co-developed-by: James Houghton <jthoughton@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/include/asm/kvm_host.h | 39 ++++++++++++++--------
 arch/x86/kvm/mmu/mmu.c          | 58 +++++++++++++++++++++------------
 arch/x86/kvm/mmu/mmu_internal.h |  7 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  4 +--
 4 files changed, 71 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b4a391929cdba..9df15c9717771 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1334,6 +1334,30 @@ enum kvm_apicv_inhibit {
 	__APICV_INHIBIT_REASON(SEV),			\
 	__APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED)
 
+struct kvm_possible_nx_huge_pages {
+	/*
+	 * A list of kvm_mmu_page structs that, if zapped, could possibly be
+	 * replaced by an NX huge page.  A shadow page is on this list if its
+	 * existence disallows an NX huge page (nx_huge_page_disallowed is set)
+	 * and there are no other conditions that prevent a huge page, e.g.
+	 * the backing host page is huge, dirtly logging is not enabled for its
+	 * memslot, etc...  Note, zapping shadow pages on this list doesn't
+	 * guarantee an NX huge page will be created in its stead, e.g. if the
+	 * guest attempts to execute from the region then KVM obviously can't
+	 * create an NX huge page (without hanging the guest).
+	 */
+	struct list_head pages;
+	u64 nr_pages;
+};
+
+enum kvm_mmu_type {
+	KVM_SHADOW_MMU,
+#ifdef CONFIG_X86_64
+	KVM_TDP_MMU,
+#endif
+	KVM_NR_MMU_TYPES,
+};
+
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
 	unsigned long n_requested_mmu_pages;
@@ -1346,18 +1370,7 @@ struct kvm_arch {
 	bool pre_fault_allowed;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct list_head active_mmu_pages;
-	/*
-	 * A list of kvm_mmu_page structs that, if zapped, could possibly be
-	 * replaced by an NX huge page.  A shadow page is on this list if its
-	 * existence disallows an NX huge page (nx_huge_page_disallowed is set)
-	 * and there are no other conditions that prevent a huge page, e.g.
-	 * the backing host page is huge, dirtly logging is not enabled for its
-	 * memslot, etc...  Note, zapping shadow pages on this list doesn't
-	 * guarantee an NX huge page will be created in its stead, e.g. if the
-	 * guest attempts to execute from the region then KVM obviously can't
-	 * create an NX huge page (without hanging the guest).
-	 */
-	struct list_head possible_nx_huge_pages;
+	struct kvm_possible_nx_huge_pages possible_nx_huge_pages[KVM_NR_MMU_TYPES];
 #ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
 	struct kvm_page_track_notifier_head track_notifier_head;
 #endif
@@ -1516,7 +1529,7 @@ struct kvm_arch {
 	 * is held in read mode:
 	 *  - tdp_mmu_roots (above)
 	 *  - the link field of kvm_mmu_page structs used by the TDP MMU
-	 *  - possible_nx_huge_pages;
+	 *  - possible_nx_huge_pages[KVM_TDP_MMU];
 	 *  - the possible_nx_huge_page_link field of kvm_mmu_page structs used
 	 *    by the TDP MMU
 	 * Because the lock is only taken within the MMU lock, strictly
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4e06e2e89a8fa..f44d7f3acc179 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -65,9 +65,9 @@ int __read_mostly nx_huge_pages = -1;
 static uint __read_mostly nx_huge_pages_recovery_period_ms;
 #ifdef CONFIG_PREEMPT_RT
 /* Recovery can cause latency spikes, disable it for PREEMPT_RT.  */
-static uint __read_mostly nx_huge_pages_recovery_ratio = 0;
+unsigned int __read_mostly nx_huge_pages_recovery_ratio;
 #else
-static uint __read_mostly nx_huge_pages_recovery_ratio = 60;
+unsigned int __read_mostly nx_huge_pages_recovery_ratio = 60;
 #endif
 
 static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp);
@@ -776,7 +776,8 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 		kvm_flush_remote_tlbs_gfn(kvm, gfn, PG_LEVEL_4K);
 }
 
-void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				 enum kvm_mmu_type mmu_type)
 {
 	/*
 	 * If it's possible to replace the shadow page with an NX huge page,
@@ -790,8 +791,9 @@ void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 		return;
 
 	++kvm->stat.nx_lpage_splits;
+	++kvm->arch.possible_nx_huge_pages[mmu_type].nr_pages;
 	list_add_tail(&sp->possible_nx_huge_page_link,
-		      &kvm->arch.possible_nx_huge_pages);
+		      &kvm->arch.possible_nx_huge_pages[mmu_type].pages);
 }
 
 static void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
@@ -800,7 +802,7 @@ static void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 	sp->nx_huge_page_disallowed = true;
 
 	if (nx_huge_page_possible)
-		track_possible_nx_huge_page(kvm, sp);
+		track_possible_nx_huge_page(kvm, sp, KVM_SHADOW_MMU);
 }
 
 static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -819,12 +821,14 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
 
-void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				   enum kvm_mmu_type mmu_type)
 {
 	if (list_empty(&sp->possible_nx_huge_page_link))
 		return;
 
 	--kvm->stat.nx_lpage_splits;
+	--kvm->arch.possible_nx_huge_pages[mmu_type].nr_pages;
 	list_del_init(&sp->possible_nx_huge_page_link);
 }
 
@@ -832,7 +836,7 @@ static void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	sp->nx_huge_page_disallowed = false;
 
-	untrack_possible_nx_huge_page(kvm, sp);
+	untrack_possible_nx_huge_page(kvm, sp, KVM_SHADOW_MMU);
 }
 
 static struct kvm_memory_slot *gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu,
@@ -6684,9 +6688,12 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 
 void kvm_mmu_init_vm(struct kvm *kvm)
 {
+	int i;
+
 	kvm->arch.shadow_mmio_value = shadow_mmio_value;
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
-	INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
+	for (i = 0; i < KVM_NR_MMU_TYPES; ++i)
+		INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages[i].pages);
 	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
 
 	if (tdp_mmu_enabled)
@@ -7519,16 +7526,27 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
 	return err;
 }
 
-static void kvm_recover_nx_huge_pages(struct kvm *kvm)
+static unsigned long nx_huge_pages_to_zap(struct kvm *kvm,
+					  enum kvm_mmu_type mmu_type)
+{
+	unsigned long pages = READ_ONCE(kvm->arch.possible_nx_huge_pages[mmu_type].nr_pages);
+	unsigned int ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
+
+	return ratio ? DIV_ROUND_UP(pages, ratio) : 0;
+}
+
+static void kvm_recover_nx_huge_pages(struct kvm *kvm,
+				      enum kvm_mmu_type mmu_type)
 {
-	unsigned long nx_lpage_splits = kvm->stat.nx_lpage_splits;
+	unsigned long to_zap = nx_huge_pages_to_zap(kvm, mmu_type);
+	struct list_head *nx_huge_pages;
 	struct kvm_memory_slot *slot;
-	int rcu_idx;
 	struct kvm_mmu_page *sp;
-	unsigned int ratio;
 	LIST_HEAD(invalid_list);
 	bool flush = false;
-	ulong to_zap;
+	int rcu_idx;
+
+	nx_huge_pages = &kvm->arch.possible_nx_huge_pages[mmu_type].pages;
 
 	rcu_idx = srcu_read_lock(&kvm->srcu);
 	write_lock(&kvm->mmu_lock);
@@ -7540,10 +7558,8 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 	 */
 	rcu_read_lock();
 
-	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
-	to_zap = ratio ? DIV_ROUND_UP(nx_lpage_splits, ratio) : 0;
 	for ( ; to_zap; --to_zap) {
-		if (list_empty(&kvm->arch.possible_nx_huge_pages))
+		if (list_empty(nx_huge_pages))
 			break;
 
 		/*
@@ -7553,7 +7569,7 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 		 * the total number of shadow pages.  And because the TDP MMU
 		 * doesn't use active_mmu_pages.
 		 */
-		sp = list_first_entry(&kvm->arch.possible_nx_huge_pages,
+		sp = list_first_entry(nx_huge_pages,
 				      struct kvm_mmu_page,
 				      possible_nx_huge_page_link);
 		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
@@ -7590,7 +7606,7 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 
 		if (slot && kvm_slot_dirty_track_enabled(slot))
 			unaccount_nx_huge_page(kvm, sp);
-		else if (is_tdp_mmu_page(sp))
+		else if (mmu_type == KVM_TDP_MMU)
 			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
 		else
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
@@ -7621,9 +7637,10 @@ static void kvm_nx_huge_page_recovery_worker_kill(void *data)
 static bool kvm_nx_huge_page_recovery_worker(void *data)
 {
 	struct kvm *kvm = data;
+	long remaining_time;
 	bool enabled;
 	uint period;
-	long remaining_time;
+	int i;
 
 	enabled = calc_nx_huge_pages_recovery_period(&period);
 	if (!enabled)
@@ -7638,7 +7655,8 @@ static bool kvm_nx_huge_page_recovery_worker(void *data)
 	}
 
 	__set_current_state(TASK_RUNNING);
-	kvm_recover_nx_huge_pages(kvm);
+	for (i = 0; i < KVM_NR_MMU_TYPES; ++i)
+		kvm_recover_nx_huge_pages(kvm, i);
 	kvm->arch.nx_huge_page_last = get_jiffies_64();
 	return true;
 }
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index db8f33e4de624..a8fd2de13f707 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -413,7 +413,10 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
 
-void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
-void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				 enum kvm_mmu_type mmu_type);
+void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				   enum kvm_mmu_type mmu_type);
 
+extern unsigned int nx_huge_pages_recovery_ratio;
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7f3d7229b2c1f..48b070f9f4e13 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -355,7 +355,7 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	sp->nx_huge_page_disallowed = false;
-	untrack_possible_nx_huge_page(kvm, sp);
+	untrack_possible_nx_huge_page(kvm, sp, KVM_TDP_MMU);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 }
 
@@ -1303,7 +1303,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		    fault->req_level >= iter.level) {
 			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 			if (sp->nx_huge_page_disallowed)
-				track_possible_nx_huge_page(kvm, sp);
+				track_possible_nx_huge_page(kvm, sp, KVM_TDP_MMU);
 			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 		}
 	}
-- 
2.50.0.rc2.692.g299adb8693-goog


