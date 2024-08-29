Return-Path: <kvm+bounces-25399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 534AB964E79
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 21:13:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7795D1C2118E
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 19:13:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 171081BA890;
	Thu, 29 Aug 2024 19:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pWY6N87T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B261BA268
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 19:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724958711; cv=none; b=iw6whex2yLaZuNtNxpSDCq15CaqM7SSPindqo5cocTg/8rvBCP55BDH5JxOWVmyRXlvohWqxUNZemR/IuufkU4dbnrdgx54fNvvDWHtnYfvhamlTX+v/HxQof5CchRIgT2PA0OHZK1cKrg5JGDc/2KvtI3ZMPrytq1vpUyJD/zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724958711; c=relaxed/simple;
	bh=zll6c5CUF/h98F5nNJpdFephBj+sdNsC47XY2M2pANo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MqaFQapk4UDeUuBAUMarZkPNbeMP1J/ubZrlmQ8cVuxQint12NSc4N52HN552OA13gISlDnsgEsKRfE0RYWt9Iy5nn2fGfBFGimqZQeU385boufVxYheNlhHPB812fKrtdyNQ9OYtNB1CoO3aLVc6b8eTZA1m13NwsV3F5tjIEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pWY6N87T; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-201e318ac63so9359395ad.1
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 12:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724958707; x=1725563507; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UWn/R6jmGvzbPhOlWXh5KeXbWVap9lx0Vq9PBd9EnIo=;
        b=pWY6N87TtznfR036JArSwEEEaFdlxJa3osANaRiZF4ECqkcxwFTWzaGPiha2xXj7Z9
         Umkv6OTnQH4Xbj5zc5HbavN556zn/K/+Bof+6j0rydHSHiw15CDH+RSUbwQzfkrI9NcU
         iBAxIiM3VBO3xjI7aEEJC96eyvdzsu3/8+HksZA59FvWZPXXykUGs2MK1Kc26S5CuQ+h
         TN5MOCzaKrrjOiS1TitAxEv3SuOvJvwy3EGFxODMkFyB8qWe/Z7ZMDM0EZxmADFxf77c
         YNzp+ZzKBOKyeMkFHsHv4OQKc6WveSRytV1eaa14ojEuJfK/WDNTZwiueMlDblTe/SCf
         VRlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724958707; x=1725563507;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UWn/R6jmGvzbPhOlWXh5KeXbWVap9lx0Vq9PBd9EnIo=;
        b=C9sPWi7niWsnNJfZdIyxy3hKfgzoVWE/opQT/HLrxuSfZxZ8QrWMhMCzETLy+lTsNc
         I/4klDwH5Q/82hhD613Ibdzuln0iWPvNDTZEaqSuMLLp5j5EflEPr6cEkvzXNSziao++
         6DKmlVfZCVftTSCMqimx6F8Q0TX3UeOvDEaMDDqIX58wTO37Mdj1CIxh6fGXiXD50llA
         QtnEnUW68xPf01aF0BEnOAv4VDCNVTcFlXoV83yO0SyQavfOKud6/0SPhsZR5+ZNJ+nx
         MUibe+S46r7yS28MAOEVDHb7N6QcQf6YJqTiwKWXSpZ422FZnEABUsW6XK+VLspGbTJ6
         1OzQ==
X-Gm-Message-State: AOJu0YxBMoS4lw6aXGwztmuyoP3JBOTJrNsX3vzMkLyy/Oxq0UT8J+RK
	/Y1JyUkCPFjRAFKMwT7mtJJWdL2QSF0O8ikN3YSLpUAByUEth1knGPfwa9izUXRenq/21YuImMY
	MTfgqPg==
X-Google-Smtp-Source: AGHT+IHwc2IUON2bO/J9k0AEj/j5fYnXO9LK1uhF1t9DhOWeoUoGRLjUOzrIy+7thLdFvwUMgVoUpyX+qKdS
X-Received: from vipin.c.googlers.com ([35.247.89.60]) (user=vipinsh
 job=sendgmr) by 2002:a17:903:2452:b0:1fb:72b4:8772 with SMTP id
 d9443c01a7336-2050c441911mr1207015ad.10.1724958707325; Thu, 29 Aug 2024
 12:11:47 -0700 (PDT)
Date: Thu, 29 Aug 2024 12:11:35 -0700
In-Reply-To: <20240829191135.2041489-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240829191135.2041489-1-vipinsh@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240829191135.2041489-5-vipinsh@google.com>
Subject: [PATCH v2 4/4] KVM: x86/mmu: Recover TDP MMU NX huge pages using MMU
 read lock
From: Vipin Sharma <vipinsh@google.com>
To: seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Use MMU read lock to recover TDP MMU NX huge pages. Iterate
huge pages list under tdp_mmu_pages_lock protection and unaccount the
page before dropping the lock.

Modify kvm_tdp_mmu_zap_sp() to tdp_mmu_zap_possible_nx_huge_page() as
there are no other user of it. Ignore the zap if any of the following
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
 arch/x86/kvm/mmu/mmu.c     | 11 ++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 76 +++++++++++++++++++++++++++++---------
 arch/x86/kvm/mmu/tdp_mmu.h |  1 -
 3 files changed, 67 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d636850c6929..cda6b07d4cda 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7436,14 +7436,19 @@ static int kvm_nx_huge_page_recovery_worker(struct kvm *kvm, uintptr_t data)
 			return 0;
 
 		rcu_idx = srcu_read_lock(&kvm->srcu);
-		write_lock(&kvm->mmu_lock);
 
-		kvm_mmu_recover_nx_huge_pages(kvm);
+		if (kvm_memslots_have_rmaps(kvm)) {
+			write_lock(&kvm->mmu_lock);
+			kvm_mmu_recover_nx_huge_pages(kvm);
+			write_unlock(&kvm->mmu_lock);
+		}
+
 		if (tdp_mmu_enabled) {
+			read_lock(&kvm->mmu_lock);
 			kvm_tdp_mmu_recover_nx_huge_pages(kvm);
+			read_unlock(&kvm->mmu_lock);
 		}
 
-		write_unlock(&kvm->mmu_lock);
 		srcu_read_unlock(&kvm->srcu, rcu_idx);
 	}
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 179cfd67609a..95aa829b856f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -818,23 +818,49 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	rcu_read_unlock();
 }
 
-bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
+static bool tdp_mmu_zap_possible_nx_huge_page(struct kvm *kvm,
+					      struct kvm_mmu_page *sp)
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
@@ -1806,7 +1832,7 @@ void kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm)
 	struct kvm_mmu_page *sp;
 	bool flush = false;
 
-	lockdep_assert_held_write(&kvm->mmu_lock);
+	lockdep_assert_held_read(&kvm->mmu_lock);
 	/*
 	 * Zapping TDP MMU shadow pages, including the remote TLB flush, must
 	 * be done under RCU protection, because the pages are freed via RCU
@@ -1815,8 +1841,11 @@ void kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm)
 	rcu_read_lock();
 
 	for ( ; to_zap; --to_zap) {
-		if (list_empty(&kvm->arch.tdp_mmu_possible_nx_huge_pages))
+		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+		if (list_empty(&kvm->arch.tdp_mmu_possible_nx_huge_pages)) {
+			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 			break;
+		}
 
 		/*
 		 * We use a separate list instead of just using active_mmu_pages
@@ -1832,16 +1861,29 @@ void kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm)
 		WARN_ON_ONCE(!sp->role.direct);
 
 		/*
-		 * Unaccount and do not attempt to recover any NX Huge Pages
-		 * that are being dirty tracked, as they would just be faulted
-		 * back in as 4KiB pages. The NX Huge Pages in this slot will be
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
+		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+
+		/*
+		 * Don't bother zapping shadow pages if the memslot is being
+		 * dirty logged, as the relevant pages would just be faulted back
+		 * in as 4KiB pages. Potential NX Huge Pages in this slot will be
 		 * recovered, along with all the other huge pages in the slot,
 		 * when dirty logging is disabled.
 		 */
-		if (kvm_mmu_sp_dirty_logging_enabled(kvm, sp))
-			unaccount_nx_huge_page(kvm, sp);
-		else
-			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
+		if (!kvm_mmu_sp_dirty_logging_enabled(kvm, sp))
+			flush |= tdp_mmu_zap_possible_nx_huge_page(kvm, sp);
 		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 86c1065a672d..57683b5dca9d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -20,7 +20,6 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
-bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
-- 
2.46.0.469.g59c65b2a67-goog


