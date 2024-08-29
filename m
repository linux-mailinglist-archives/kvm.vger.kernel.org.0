Return-Path: <kvm+bounces-25396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 37E57964E72
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 21:12:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD2701F2300E
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 19:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57FD81B9B3A;
	Thu, 29 Aug 2024 19:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mYYzF+b7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAADD1B8E9C
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 19:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724958704; cv=none; b=tk3mjXfZvbTPYg18vyi1bZ3Em4FyLYg/S6gIjAdCl2oaYuLYD9pJRH4HLtEwvFUWetkdW1AL5BlRgt0WyTIa+jzcLOVA62Aj/G+ao4pKi0jVMhLluxPXyrGGaojB3Vw4a9KIb9wez2XsNrudwLel/T8kIEeeRMSSWM6vuY/UfFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724958704; c=relaxed/simple;
	bh=fiZayKA6SsO0JXjYtK8CFwxzN8zOS6xGaQ0N61svpio=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hZB1JGU5owTDbLXvdA35tlMlcxsirLcwKLJAY1eEDbfT1hd4MpGTkJ5RE2vonbP4trGcFss2q/6XlPJAf9CSKY+x3MyjZxJpp1o3A/KQRCahauvYM69dbqx0HxCwdU3iFWxP/YBzq3ABdMva5Tu/hWviJT8FneSNry/MRCmWfHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mYYzF+b7; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7cd849a6077so895615a12.0
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 12:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724958702; x=1725563502; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ko4ob+ViJSbLqyaIB4a+SKn30GCHnoVZzbsVDR3Bww=;
        b=mYYzF+b7WEmnDuXLapzi/G1t0Yi/1sgMhzjUYzlpIar/1VgivqXDjJkfPnEq6OAIfZ
         Lg3EPhbvj0Q9G+kq1jtm8BWI/fTWkOq0Q29RgLvSBocBRLDWwAQl7J+SQHiOsATmzr9H
         o+TR3bauMUk2Dz1e585pA6sCnC1q2ADqceNaFSFGmVqo8HVuY1oswtIqwcmoFLqaKUlX
         rp4MHdfVnvomMr5EBjH2it97ch/eicbGTIQqTGMuTd8k9HCGMjmRZ4YSXmfisrxSl2w0
         Qs+jbnzB+VSwbviVKO15VqEA4My/MvpYZa3x0zxx9rVihNtHhKqZjaajQLkWVmMalja5
         PnJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724958702; x=1725563502;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ko4ob+ViJSbLqyaIB4a+SKn30GCHnoVZzbsVDR3Bww=;
        b=iMlNrpQdBo+tPUrpqU/0bijPcptbfclfWHMeMsJwa6KRgRZzKlaCFfOasSM7sYBL9A
         gYmdPKVeeWSqKQlNrfd20pYrWmn9bWQqm5/vpHmNq/XWzGLgKb8Goxs0HPT0BmS/J4tx
         4ur3/nKbnfzW/BmKujtx1Wf14n5QGSDdjp3vPE3ihWIebSXcoKAN5VcWvwVsiMSqdsxU
         AIfkPwlfA8nJ1prCq0P1ckk7G9rTb60K2VvFdkWTvDNz7jO93HEfjp0pTO6AUxSJ0yvo
         anZrZRDkkTuE0ndJCtLTpuHlFWztALtVzb50K2uAIEOSy/qXWQuAaKy4eSAG7eGUqtaM
         AoHA==
X-Gm-Message-State: AOJu0YwBuMkCe+Fm76+CVwstVKXoppC3qGC/Izq5kDPLwA4YPfgvCKc5
	SUmm+il3VqjnEQxTtBjIuK6vQKBhFjqOIt9oz6bdu61om1w9E2bk41WIQew//ASWpzpaBe+VSuK
	WV05fNQ==
X-Google-Smtp-Source: AGHT+IFtQm6SOImi/GBCeUp1CgED7o6t8UN6ormVIiNZKFA5OfBLYTJZt5tyRGWIdzLcadhZhe92KAw78s6c
X-Received: from vipin.c.googlers.com ([34.105.13.176]) (user=vipinsh
 job=sendgmr) by 2002:a17:902:e54c:b0:1f8:44f4:efd9 with SMTP id
 d9443c01a7336-2050c22c5bamr1788125ad.2.1724958701130; Thu, 29 Aug 2024
 12:11:41 -0700 (PDT)
Date: Thu, 29 Aug 2024 12:11:32 -0700
In-Reply-To: <20240829191135.2041489-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240829191135.2041489-1-vipinsh@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240829191135.2041489-2-vipinsh@google.com>
Subject: [PATCH v2 1/4] KVM: x86/mmu: Track TDP MMU NX huge pages separately
From: Vipin Sharma <vipinsh@google.com>
To: seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Create separate list for storing TDP MMU NX huge pages and provide
counter for it. Use this list in NX huge page recovery worker along with
the existing NX huge pages list. Use old NX huge pages list for storing
only non-TDP MMU pages and provide separate counter for it.

Separate list will allow to optimize TDP MMU NX huge page recovery in
future patches by using MMU read lock.

Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/include/asm/kvm_host.h | 13 ++++++-
 arch/x86/kvm/mmu/mmu.c          | 62 +++++++++++++++++++++++++--------
 arch/x86/kvm/mmu/mmu_internal.h |  1 +
 arch/x86/kvm/mmu/tdp_mmu.c      |  9 +++++
 arch/x86/kvm/mmu/tdp_mmu.h      |  2 ++
 5 files changed, 72 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 950a03e0181e..e6e7026bb8e4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1318,8 +1318,12 @@ struct kvm_arch {
 	 * guarantee an NX huge page will be created in its stead, e.g. if the
 	 * guest attempts to execute from the region then KVM obviously can't
 	 * create an NX huge page (without hanging the guest).
+	 *
+	 * This list only contains shadow and legacy MMU pages. TDP MMU pages
+	 * are stored separately in tdp_mmu_possible_nx_huge_pages.
 	 */
 	struct list_head possible_nx_huge_pages;
+	u64 possible_nx_huge_pages_count;
 #ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
 	struct kvm_page_track_notifier_head track_notifier_head;
 #endif
@@ -1474,7 +1478,7 @@ struct kvm_arch {
 	 * is held in read mode:
 	 *  - tdp_mmu_roots (above)
 	 *  - the link field of kvm_mmu_page structs used by the TDP MMU
-	 *  - possible_nx_huge_pages;
+	 *  - tdp_mmu_possible_nx_huge_pages;
 	 *  - the possible_nx_huge_page_link field of kvm_mmu_page structs used
 	 *    by the TDP MMU
 	 * Because the lock is only taken within the MMU lock, strictly
@@ -1483,6 +1487,13 @@ struct kvm_arch {
 	 * the code to do so.
 	 */
 	spinlock_t tdp_mmu_pages_lock;
+
+	/*
+	 * Similar to possible_nx_huge_pages list but this one stores only TDP
+	 * MMU pages.
+	 */
+	struct list_head tdp_mmu_possible_nx_huge_pages;
+	u64 tdp_mmu_possible_nx_huge_pages_count;
 #endif /* CONFIG_X86_64 */
 
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 901be9e420a4..0bda372b13a5 100644
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
@@ -871,8 +871,17 @@ void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 		return;
 
 	++kvm->stat.nx_lpage_splits;
-	list_add_tail(&sp->possible_nx_huge_page_link,
-		      &kvm->arch.possible_nx_huge_pages);
+	if (is_tdp_mmu_page(sp)) {
+#ifdef CONFIG_X86_64
+		++kvm->arch.tdp_mmu_possible_nx_huge_pages_count;
+		list_add_tail(&sp->possible_nx_huge_page_link,
+			      &kvm->arch.tdp_mmu_possible_nx_huge_pages);
+#endif
+	} else {
+		++kvm->arch.possible_nx_huge_pages_count;
+		list_add_tail(&sp->possible_nx_huge_page_link,
+			      &kvm->arch.possible_nx_huge_pages);
+	}
 }
 
 static void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
@@ -906,6 +915,13 @@ void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 		return;
 
 	--kvm->stat.nx_lpage_splits;
+	if (is_tdp_mmu_page(sp)) {
+#ifdef CONFIG_X86_64
+		--kvm->arch.tdp_mmu_possible_nx_huge_pages_count;
+#endif
+	} else {
+		--kvm->arch.possible_nx_huge_pages_count;
+	}
 	list_del_init(&sp->possible_nx_huge_page_link);
 }
 
@@ -7311,16 +7327,15 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
 	return err;
 }
 
-static void kvm_recover_nx_huge_pages(struct kvm *kvm)
+static void kvm_recover_nx_huge_pages(struct kvm *kvm,
+				      struct list_head *nx_huge_pages,
+				      unsigned long to_zap)
 {
-	unsigned long nx_lpage_splits = kvm->stat.nx_lpage_splits;
 	struct kvm_memory_slot *slot;
 	int rcu_idx;
 	struct kvm_mmu_page *sp;
-	unsigned int ratio;
 	LIST_HEAD(invalid_list);
 	bool flush = false;
-	ulong to_zap;
 
 	rcu_idx = srcu_read_lock(&kvm->srcu);
 	write_lock(&kvm->mmu_lock);
@@ -7332,10 +7347,8 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 	 */
 	rcu_read_lock();
 
-	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
-	to_zap = ratio ? DIV_ROUND_UP(nx_lpage_splits, ratio) : 0;
 	for ( ; to_zap; --to_zap) {
-		if (list_empty(&kvm->arch.possible_nx_huge_pages))
+		if (list_empty(nx_huge_pages))
 			break;
 
 		/*
@@ -7345,7 +7358,7 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 		 * the total number of shadow pages.  And because the TDP MMU
 		 * doesn't use active_mmu_pages.
 		 */
-		sp = list_first_entry(&kvm->arch.possible_nx_huge_pages,
+		sp = list_first_entry(nx_huge_pages,
 				      struct kvm_mmu_page,
 				      possible_nx_huge_page_link);
 		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
@@ -7417,10 +7430,19 @@ static long get_nx_huge_page_recovery_timeout(u64 start_time)
 		       : MAX_SCHEDULE_TIMEOUT;
 }
 
+static unsigned long nx_huge_pages_to_zap(struct kvm *kvm)
+{
+	unsigned long pages = READ_ONCE(kvm->arch.possible_nx_huge_pages_count);
+	unsigned int ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
+
+	return ratio ? DIV_ROUND_UP(pages, ratio) : 0;
+}
+
 static int kvm_nx_huge_page_recovery_worker(struct kvm *kvm, uintptr_t data)
 {
-	u64 start_time;
+	unsigned long to_zap;
 	long remaining_time;
+	u64 start_time;
 
 	while (true) {
 		start_time = get_jiffies_64();
@@ -7438,7 +7460,19 @@ static int kvm_nx_huge_page_recovery_worker(struct kvm *kvm, uintptr_t data)
 		if (kthread_should_stop())
 			return 0;
 
-		kvm_recover_nx_huge_pages(kvm);
+		to_zap = nx_huge_pages_to_zap(kvm);
+		kvm_recover_nx_huge_pages(kvm,
+					  &kvm->arch.possible_nx_huge_pages,
+					  to_zap);
+
+		if (tdp_mmu_enabled) {
+#ifdef CONFIG_X86_64
+			to_zap = kvm_tdp_mmu_nx_huge_pages_to_zap(kvm);
+			kvm_recover_nx_huge_pages(kvm,
+						  &kvm->arch.tdp_mmu_possible_nx_huge_pages,
+						  to_zap);
+#endif
+		}
 	}
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1721d97743e9..8deed808592b 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -354,4 +354,5 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+extern unsigned int nx_huge_pages_recovery_ratio;
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c7dc49ee7388..6415c2c7e936 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -15,6 +15,7 @@
 void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 {
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
+	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_possible_nx_huge_pages);
 	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
 }
 
@@ -1796,3 +1797,11 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gfn_t gfn,
 	 */
 	return rcu_dereference(sptep);
 }
+
+unsigned long kvm_tdp_mmu_nx_huge_pages_to_zap(struct kvm *kvm)
+{
+	unsigned long pages = READ_ONCE(kvm->arch.tdp_mmu_possible_nx_huge_pages_count);
+	unsigned int ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
+
+	return ratio ? DIV_ROUND_UP(pages, ratio) : 0;
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 1b74e058a81c..95290fd6154e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -67,6 +67,8 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gfn_t gfn,
 					u64 *spte);
 
+unsigned long kvm_tdp_mmu_nx_huge_pages_to_zap(struct kvm *kvm);
+
 #ifdef CONFIG_X86_64
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
 #else
-- 
2.46.0.469.g59c65b2a67-goog


