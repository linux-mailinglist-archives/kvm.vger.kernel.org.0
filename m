Return-Path: <kvm+bounces-51707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F6FDAFBE5C
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 00:49:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA6724809AF
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 22:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 060F2293C5E;
	Mon,  7 Jul 2025 22:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M6C4oZzp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BFE23505E
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 22:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751928511; cv=none; b=B7eBkF9pYCNPVMP+1m+6lltZI60qlS9Oh0sfV19MwpoYXd+ZFtUOK/FuYIppv2w1W31Sws9eO+fE1vcU63uyVM5NaqlmbE8yfyJn4oMm/Wvx4A5woXiWe1F+RUHtLPL1pVDwTUIAOmJFRwBJvfpi55RNPgKdDfoxKMQ+NLjS+jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751928511; c=relaxed/simple;
	bh=lShPP1U+Rvs/6QXtnOxlJLyiJhHAoVh5TqKhsf9YoY4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aBUEoA5i/0UThLnh1/VLI9NlPUTLxcZG/xKpyzZ3/9afRqviCTxQgynxDFOt4G2qhQnT4QEB9/3+nuMTozsurCKQ4EKv7a4RolMuPE3IUjqGm51UC5hWz4/b8FBtW6dfck/5CxsVvs0JEwdWkzoUfx3VKfPBdmy9ogTcCIwf9G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M6C4oZzp; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313f702d37fso3288882a91.3
        for <kvm@vger.kernel.org>; Mon, 07 Jul 2025 15:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751928508; x=1752533308; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=myy8tIt6s7QEOEcD9IVw1QFE5C/VIXZH6WBInZX0UO4=;
        b=M6C4oZzp0TYzTd5KBwewHUyJ4GI9mHY+VNsO0NcAGOD6CTm05Anf5HPLFKtwdrGyZK
         Cp9Zz32MLfS+ZgftXnywGU1kWYVdOTIw5YacPqYknB8O3KFTanfm0HTA8eLbnv/uNOmJ
         GpneI3wxb2hxMuMjRgPpASL8xJRFKLvIEvgEisHk7EdoDKUE9HPFSFtj40vGJhFurgmd
         du9HAWPCm+0Yz7KA+bIxB9AOgPxkAHsg6xYuYG1VcnQZ5kJCRe2tjzpRyoYK/Jm9Ebkw
         hfDq70HIm5VSZX9tIpBvPyAzCVTL9nUccJyF6an3pgsejJKSg4xDUqbIyfpNhogl7GlQ
         nBdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751928508; x=1752533308;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=myy8tIt6s7QEOEcD9IVw1QFE5C/VIXZH6WBInZX0UO4=;
        b=FAMpdrMbdj2ZOC+/GMHVjsM4dLGps/9gVBXJ/K0UgMDWTurXzz1r/m2XmVFzRKHFNR
         RufWBNvF7dn36UjLgrpSq5ZKPtE18r54Q2HC4JzieYf64BdfM0scc1RiPn58Mv/SKXhw
         FSGKTMOUFaS4N8qDBQzg0P+8M1/KTdXcg5RxfZ8rby1WUDMG3xVeFZTrnotGZE7adyHY
         7hNoCEMW6Pe8A6oqDv64MtTANkCM4gMxX/Cld9oymoYYH4o6oUPTtFIRxavGY9EH3Ul2
         c/nXuzecn05+WJgIXVRohuoqoTAm3m5eUUiA4C9Q2mnpPr6LjV3MvPMHhx5d/uwkP8kr
         00Qw==
X-Forwarded-Encrypted: i=1; AJvYcCU0d4pbP1et1uW6pgRDCjjlkfNL+pcB9LPPo+6DlhKADjATdAqbMvMNpe2aiWvkWb9ye/8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNj9Ix+iTd711HUAcNcu1GeQgc7djiesAsU/t7mTubN8pV4bR4
	/8BpWVKzhdDZ4eWYiWtcqqXNPut1acy8atic193Hhe/nmmrhdFbghuagH2MpBD3yKB9YdzvaCab
	TgQ7UFIY3p92lAcoioRcyFA==
X-Google-Smtp-Source: AGHT+IEbREDdYASXzsI+uvlmXkGmB94vjUol5eWXSOoRnjAIRrc+JDMF8Cp21CM6bmYDYZ6sxjfYq3wtaTickWM7
X-Received: from pjbrr16.prod.google.com ([2002:a17:90b:2b50:b0:308:6685:55e6])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4990:b0:311:e4ff:1810 with SMTP id 98e67ed59e1d1-31aadcaba26mr18720925a91.3.1751928507538;
 Mon, 07 Jul 2025 15:48:27 -0700 (PDT)
Date: Mon,  7 Jul 2025 22:47:14 +0000
In-Reply-To: <20250707224720.4016504-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250707224720.4016504-2-jthoughton@google.com>
Subject: [PATCH v5 1/7] KVM: x86/mmu: Track TDP MMU NX huge pages separately
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
 arch/x86/include/asm/kvm_host.h | 43 ++++++++++++++++--------
 arch/x86/kvm/mmu/mmu.c          | 58 +++++++++++++++++++++------------
 arch/x86/kvm/mmu/mmu_internal.h |  7 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  4 +--
 4 files changed, 75 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b4a391929cdba..d544a269c1920 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1334,6 +1334,34 @@ enum kvm_apicv_inhibit {
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
+#ifndef CONFIG_X86_64
+#define KVM_TDP_MMU -1
+#endif
+
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
 	unsigned long n_requested_mmu_pages;
@@ -1346,18 +1374,7 @@ struct kvm_arch {
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
@@ -1516,7 +1533,7 @@ struct kvm_arch {
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
2.50.0.727.gbf7dc18ff4-goog


