Return-Path: <kvm+bounces-26033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4188196FCDC
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 22:46:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EDAB1C21C74
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 20:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B5EB1D88B9;
	Fri,  6 Sep 2024 20:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JQ1m04CY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651311D7E39
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 20:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725655525; cv=none; b=hTQjtzVtRATeRGuejsDsWtvZSChPQhxHri5I6rA/lFgQyovLUoNc3sPXN3ZUsyABJw6wiJFVMr7+ZrGJ1CMw7PozxjORMCyOAqT7WCR9L9hnPUMlT3GEyZco9v7UUe4eGYoPfPoYnuTSsPekoczRV+Ljy5Mhl1jm5RUAzebwV24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725655525; c=relaxed/simple;
	bh=sMoZ6zXACMl/k6sr6RMk0twcIsgikQ36WnjB+a6b3TI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aL7j2V0V/42LsQhEHXYZFrVQWorHAalPPrvNRk4AWMPF3LEEyLxjoeyHrMWv3jIh37GOgMxpdGEy/HRqrmxUiX/G0c187YxXE6lokvsiA9O6fq/3NC7QLER7HXi0Xy+YutF7S5r9gPJ4JK0cHDZxMv62u75p1XMRWW3mZ3DPwaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JQ1m04CY; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-205428e6facso29485445ad.2
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 13:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725655522; x=1726260322; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XX1S537jtVISqBJxzm6B+4ZHvpDhxy7xsVVvCabn7cw=;
        b=JQ1m04CYJQZbiy/21X0srae7TS2vXpgjaRZieuq25mCachACR2kUFlZPhEdQrJC1Np
         K+3M16KEgJtnnXdQk5hCI4noo1IJL4jNYR4uLKpVE23RZusJTU+HM1nFfzlSVjS35u4x
         eCLjNC53IhAMVgyR3Fjqxco2BKhOfl6IhC9a8N8EWy6r2zbCWi3lxOzFcab+PF6NsRNj
         pSK1oIwxs2xtAUCsc7iqTBkpZUNxT1qw/WyX1zge3XdLC8b6xkjY1LEIu5ut8RxhVocS
         9AgxVnh8CsvU/fFXMFgBwExNe9Vlgfwf8ZqrdO2Hv/6ThvAOWkfeg3JYm0PNZj2i5WHF
         I+6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725655522; x=1726260322;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XX1S537jtVISqBJxzm6B+4ZHvpDhxy7xsVVvCabn7cw=;
        b=ENd23oy1iP6oza4wQy8jaGCT4UWnUoNTpVIA/Ju2yvskPI/3mElbxPbI7viRzXwHAf
         9+Y0Ri0Y/Bu8Y9v173hH3ofqBNRWPMJkAjvxNEF3cmNj5ZrI/bo2C/Jg/3oENnlu+oBM
         5fpWQhqH658MTNq3C1hrn6UvYyq/aK8ytBVG9FCwMWv0Bi5Qb6hUB6hGX1JLK+9aJ96F
         389B2q9bvy9/ZuE+Bdm4oV/lQS3NsNvfWeMAb/7pm8Z/YlZjawbhOuMRj9iEgklhXLxE
         sZdeLZko17JX/Pt2E1qOW6jt4k4nhTXbricKpSAp/jLkD18470TWLXWODYUkdov3L2Ef
         c+mQ==
X-Gm-Message-State: AOJu0YwQadOkdRsUkEmV5pUalAL3mv+PqDBkdWM7FtogOHrNI00w0gm0
	QigCqzmER63ZjAcFPQ3gwpWlTcpjNERdCtDzIUaQwFMTHw7O2Wd+sj4zRjXLOt5nxC7NukIKKb8
	spATz7w==
X-Google-Smtp-Source: AGHT+IEB3I4S81gLMcFJ/JuG6s6suhuCxS7h6lZ0rtdEXrDyRVVSF/9n67cIAzpvMDwHHDqZKmG1CnVQMCL+
X-Received: from vipin.c.googlers.com ([34.105.13.176]) (user=vipinsh
 job=sendgmr) by 2002:a17:902:fa10:b0:205:5f42:4191 with SMTP id
 d9443c01a7336-206f04d5649mr554085ad.4.1725655521528; Fri, 06 Sep 2024
 13:45:21 -0700 (PDT)
Date: Fri,  6 Sep 2024 13:45:15 -0700
In-Reply-To: <20240906204515.3276696-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240906204515.3276696-1-vipinsh@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240906204515.3276696-3-vipinsh@google.com>
Subject: [PATCH v3 2/2] KVM: x86/mmu: Recover TDP MMU NX huge pages using MMU
 read lock
From: Vipin Sharma <vipinsh@google.com>
To: seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Use MMU read lock to recover TDP MMU NX huge pages. Iterate
huge pages list under tdp_mmu_pages_lock protection and unaccount the
page before dropping the lock.

Modify kvm_tdp_mmu_zap_sp() to kvm_tdp_mmu_zap_possible_nx_huge_page()
as there are no other user of it. Ignore the zap if any of the following
condition is true:
- It is a root page.
- Parent is pointing to:
  - A different page table.
  - A huge page.
  - Not present

Warn if zapping SPTE fails and current SPTE is still pointing to same
page table. This should never happen.

There is always a race between dirty logging, vCPU faults, and NX huge
page recovery for backing a gfn by an NX huge page or an execute small
page. Unaccounting sooner during the list traversal is increasing the
window of that race. Functionally, it is okay, because accounting
doesn't protect against iTLB multi-hit bug, it is there purely to
prevent KVM from bouncing a gfn between two page sizes. The only
downside is that a vCPU will end up doing more work in tearing down all
the child SPTEs. This should be a very rare race.

Zapping under MMU read lock unblock vCPUs which are waiting for MMU read
lock. This optimizaion is done to solve a guest jitter issue on Windows
VM which was observing an increase in network latency. The test workload
sets up two Windows VM and use latte.exe[1] binary to run network
latency benchmark. Running NX huge page recovery under MMU lock was
causing latency to increase up to 30 ms because vCPUs were waiting for
MMU lock.

Running the tool on VMs using MMU read lock NX huge page recovery
removed the jitter issue completely and MMU lock wait time by vCPUs was
also reduced.

Command used for testing:

Server:
latte.exe -udp -a 192.168.100.1:9000 -i 10000000

Client:
latte.exe -c -udp -a 192.168.100.1:9000 -i 10000000 -hist -hl 1000 -hc 30

Output from the latency tool on client:

Before
------

Protocol      UDP
SendMethod    Blocking
ReceiveMethod Blocking
SO_SNDBUF     Default
SO_RCVBUF     Default
MsgSize(byte) 4
Iterations    10000000
Latency(usec) 69.98
CPU(%)        2.8
CtxSwitch/sec 32783     (2.29/iteration)
SysCall/sec   99948     (6.99/iteration)
Interrupt/sec 55164     (3.86/iteration)

Interval(usec)   Frequency
      0          9999967
   1000          14
   2000          0
   3000          5
   4000          1
   5000          0
   6000          0
   7000          0
   8000          0
   9000          0
  10000          0
  11000          0
  12000          2
  13000          2
  14000          4
  15000          2
  16000          2
  17000          0
  18000          1

After
-----

Protocol      UDP
SendMethod    Blocking
ReceiveMethod Blocking
SO_SNDBUF     Default
SO_RCVBUF     Default
MsgSize(byte) 4
Iterations    10000000
Latency(usec) 67.66
CPU(%)        1.6
CtxSwitch/sec 32869     (2.22/iteration)
SysCall/sec   69366     (4.69/iteration)
Interrupt/sec 50693     (3.43/iteration)

Interval(usec)   Frequency
      0          9999972
   1000          27
   2000          1

[1] https://github.com/microsoft/latte

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 85 ++++++++++++++++++++++-----------
 arch/x86/kvm/mmu/mmu_internal.h |  4 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 56 ++++++++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h      |  5 +-
 4 files changed, 110 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 455caaaa04f5..fc597f66aa11 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7317,8 +7317,8 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
 	return err;
 }
 
-void kvm_recover_nx_huge_pages(struct kvm *kvm, struct list_head *pages,
-			       unsigned long nr_pages)
+void kvm_recover_nx_huge_pages(struct kvm *kvm, bool shared,
+			       struct list_head *pages, unsigned long nr_pages)
 {
 	struct kvm_memory_slot *slot;
 	int rcu_idx;
@@ -7329,7 +7329,10 @@ void kvm_recover_nx_huge_pages(struct kvm *kvm, struct list_head *pages,
 	ulong to_zap;
 
 	rcu_idx = srcu_read_lock(&kvm->srcu);
-	write_lock(&kvm->mmu_lock);
+	if (shared)
+		read_lock(&kvm->mmu_lock);
+	else
+		write_lock(&kvm->mmu_lock);
 
 	/*
 	 * Zapping TDP MMU shadow pages, including the remote TLB flush, must
@@ -7341,8 +7344,13 @@ void kvm_recover_nx_huge_pages(struct kvm *kvm, struct list_head *pages,
 	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
 	to_zap = ratio ? DIV_ROUND_UP(nr_pages, ratio) : 0;
 	for ( ; to_zap; --to_zap) {
-		if (list_empty(pages))
+		if (tdp_mmu_enabled)
+			kvm_tdp_mmu_pages_lock(kvm);
+		if (list_empty(pages)) {
+			if (tdp_mmu_enabled)
+				kvm_tdp_mmu_pages_unlock(kvm);
 			break;
+		}
 
 		/*
 		 * We use a separate list instead of just using active_mmu_pages
@@ -7358,24 +7366,41 @@ void kvm_recover_nx_huge_pages(struct kvm *kvm, struct list_head *pages,
 		WARN_ON_ONCE(!sp->role.direct);
 
 		/*
-		 * Unaccount and do not attempt to recover any NX Huge Pages
-		 * that are being dirty tracked, as they would just be faulted
-		 * back in as 4KiB pages. The NX Huge Pages in this slot will be
-		 * recovered, along with all the other huge pages in the slot,
-		 * when dirty logging is disabled.
+		 * Unaccount the shadow page before zapping its SPTE so as to
+		 * avoid bouncing tdp_mmu_pages_lock more than is necessary.
+		 * Clearing nx_huge_page_disallowed before zapping is safe, as
+		 * the flag doesn't protect against iTLB multi-hit, it's there
+		 * purely to prevent bouncing the gfn between an NX huge page
+		 * and an X small spage. A vCPU could get stuck tearing down
+		 * the shadow page, e.g. if it happens to fault on the region
+		 * before the SPTE is zapped and replaces the shadow page with
+		 * an NX huge page and get stuck tearing down the child SPTEs,
+		 * but that is a rare race, i.e. shouldn't impact performance.
+		 */
+		unaccount_nx_huge_page(kvm, sp);
+		if (tdp_mmu_enabled)
+			kvm_tdp_mmu_pages_unlock(kvm);
+
+		/*
+		 * Do not attempt to recover any NX Huge Pages that are being
+		 * dirty tracked, as they would just be faulted back in as 4KiB
+		 * pages. The NX Huge Pages in this slot will be recovered,
+		 * along with all the other huge pages in the slot, when dirty
+		 * logging is disabled.
 		 *
 		 * Since gfn_to_memslot() is relatively expensive, it helps to
 		 * skip it if it the test cannot possibly return true.  On the
 		 * other hand, if any memslot has logging enabled, chances are
-		 * good that all of them do, in which case unaccount_nx_huge_page()
-		 * is much cheaper than zapping the page.
+		 * good that all of them do, in which case
+		 * unaccount_nx_huge_page() is much cheaper than zapping the
+		 * page.
 		 *
-		 * If a memslot update is in progress, reading an incorrect value
-		 * of kvm->nr_memslots_dirty_logging is not a problem: if it is
-		 * becoming zero, gfn_to_memslot() will be done unnecessarily; if
-		 * it is becoming nonzero, the page will be zapped unnecessarily.
-		 * Either way, this only affects efficiency in racy situations,
-		 * and not correctness.
+		 * If a memslot update is in progress, reading an incorrect
+		 * value of kvm->nr_memslots_dirty_logging is not a problem: if
+		 * it is becoming zero, gfn_to_memslot() will be done
+		 * unnecessarily; if it is becoming nonzero, the page will be
+		 * zapped unnecessarily.  Either way, this only affects
+		 * efficiency in racy situations, and not correctness.
 		 */
 		slot = NULL;
 		if (atomic_read(&kvm->nr_memslots_dirty_logging)) {
@@ -7385,20 +7410,21 @@ void kvm_recover_nx_huge_pages(struct kvm *kvm, struct list_head *pages,
 			slot = __gfn_to_memslot(slots, sp->gfn);
 			WARN_ON_ONCE(!slot);
 		}
-
-		if (slot && kvm_slot_dirty_track_enabled(slot))
-			unaccount_nx_huge_page(kvm, sp);
-		else if (is_tdp_mmu_page(sp))
-			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
-		else
-			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+		if (!slot || !kvm_slot_dirty_track_enabled(slot)) {
+			if (shared)
+				flush |= kvm_tdp_mmu_zap_possible_nx_huge_page(kvm, sp);
+			else
+				kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+		}
 		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
 			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
 			rcu_read_unlock();
-
-			cond_resched_rwlock_write(&kvm->mmu_lock);
+			if (shared)
+				cond_resched_rwlock_read(&kvm->mmu_lock);
+			else
+				cond_resched_rwlock_write(&kvm->mmu_lock);
 			flush = false;
 
 			rcu_read_lock();
@@ -7408,7 +7434,10 @@ void kvm_recover_nx_huge_pages(struct kvm *kvm, struct list_head *pages,
 
 	rcu_read_unlock();
 
-	write_unlock(&kvm->mmu_lock);
+	if (shared)
+		read_unlock(&kvm->mmu_lock);
+	else
+		write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
 }
 
@@ -7425,7 +7454,7 @@ static long get_nx_huge_page_recovery_timeout(u64 start_time)
 
 static void kvm_mmu_recover_nx_huge_pages(struct kvm *kvm)
 {
-	kvm_recover_nx_huge_pages(kvm, &kvm->arch.possible_nx_huge_pages,
+	kvm_recover_nx_huge_pages(kvm, false, &kvm->arch.possible_nx_huge_pages,
 				  kvm->arch.nr_possible_nx_huge_pages);
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 2d2e1231996a..e6b757c59ccc 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -355,7 +355,7 @@ void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 				 struct list_head *pages, u64 *nr_pages);
 void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 				   u64 *nr_pages);
-void kvm_recover_nx_huge_pages(struct kvm *kvm, struct list_head *pages,
-			       unsigned long nr_pages);
+void kvm_recover_nx_huge_pages(struct kvm *kvm, bool shared,
+			       struct list_head *pages, unsigned long nr_pages);
 
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9a6c26d20210..8a6ffc150c99 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -74,9 +74,19 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
 	tdp_mmu_free_sp(sp);
 }
 
+void kvm_tdp_mmu_pages_lock(struct kvm *kvm)
+{
+	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+}
+
+void kvm_tdp_mmu_pages_unlock(struct kvm *kvm)
+{
+	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+}
+
 void kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm)
 {
-	kvm_recover_nx_huge_pages(kvm,
+	kvm_recover_nx_huge_pages(kvm, true,
 				  &kvm->arch.tdp_mmu_possible_nx_huge_pages,
 				  kvm->arch.tdp_mmu_nr_possible_nx_huge_pages);
 }
@@ -825,23 +835,51 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	rcu_read_unlock();
 }
 
-bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
+bool kvm_tdp_mmu_zap_possible_nx_huge_page(struct kvm *kvm,
+					   struct kvm_mmu_page *sp)
 {
-	u64 old_spte;
+	struct tdp_iter iter = {
+		.old_spte = sp->ptep ? kvm_tdp_mmu_read_spte(sp->ptep) : 0,
+		.sptep = sp->ptep,
+		.level = sp->role.level + 1,
+		.gfn = sp->gfn,
+		.as_id = kvm_mmu_page_as_id(sp),
+	};
+
+	lockdep_assert_held_read(&kvm->mmu_lock);
+	if (WARN_ON_ONCE(!is_tdp_mmu_page(sp)))
+		return false;
 
 	/*
-	 * This helper intentionally doesn't allow zapping a root shadow page,
-	 * which doesn't have a parent page table and thus no associated entry.
+	 * Root shadow pages don't a parent page table and thus no associated
+	 * entry, but they can never be possible NX huge pages.
 	 */
 	if (WARN_ON_ONCE(!sp->ptep))
 		return false;
 
-	old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
-	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
+	/*
+	 * Since mmu_lock is held in read mode, it's possible another task has
+	 * already modified the SPTE. Zap the SPTE if and only if the SPTE
+	 * points at the SP's page table, as checking  shadow-present isn't
+	 * sufficient, e.g. the SPTE could be replaced by a leaf SPTE, or even
+	 * another SP. Note, spte_to_child_pt() also checks that the SPTE is
+	 * shadow-present, i.e. guards against zapping a frozen SPTE.
+	 */
+	if ((tdp_ptep_t)sp->spt != spte_to_child_pt(iter.old_spte, iter.level))
 		return false;
 
-	tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte,
-			 SHADOW_NONPRESENT_VALUE, sp->gfn, sp->role.level + 1);
+	/*
+	 * If a different task modified the SPTE, then it should be impossible
+	 * for the SPTE to still be used for the to-be-zapped SP. Non-leaf
+	 * SPTEs don't have Dirty bits, KVM always sets the Accessed bit when
+	 * creating non-leaf SPTEs, and all other bits are immutable for non-
+	 * leaf SPTEs, i.e. the only legal operations for non-leaf SPTEs are
+	 * zapping and replacement.
+	 */
+	if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE)) {
+		WARN_ON_ONCE((tdp_ptep_t)sp->spt == spte_to_child_pt(iter.old_spte, iter.level));
+		return false;
+	}
 
 	return true;
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 510baf3eb3f1..ed4bdceb9aec 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -20,7 +20,8 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
-bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
+bool kvm_tdp_mmu_zap_possible_nx_huge_page(struct kvm *kvm,
+					   struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
@@ -66,6 +67,8 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 			 int *root_level);
 u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gfn_t gfn,
 					u64 *spte);
+void kvm_tdp_mmu_pages_lock(struct kvm *kvm);
+void kvm_tdp_mmu_pages_unlock(struct kvm *kvm);
 void kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm);
 
 #ifdef CONFIG_X86_64
-- 
2.46.0.469.g59c65b2a67-goog


