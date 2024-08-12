Return-Path: <kvm+bounces-23873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BE9994F5B3
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 19:14:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FF5E1C211C9
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 17:14:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9EA7189911;
	Mon, 12 Aug 2024 17:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Om3gT0yP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DB8189516
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 17:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723482844; cv=none; b=nOAiYTxZDaR7y8c0XVXVAroNZfiN2UtR+yjqIKJSJYSWvW/VRRH7Gl2RfvLBXFufv6zhkXq/FDhiS8TlHjkIfhfvnGNivEZOBkwoPz0NM28biQgVCfPw7ksQGUTBjJp6lg4d36DvUm2M+w7kBCiO0427nXkNdUw3GKZE1hEoRQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723482844; c=relaxed/simple;
	bh=HUFlbBYJsG/TxP0oZ1oi0NPTwEgycmU5FKY6RLrmddk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dFwAz1GA8g8aM6qXa5Vxp9J7fp9WJ/bZJ0ZkgRzFhZnJ8tueWdnxr4gXCmF3Bw/J0HL080IPpaBNHCU57YpAbC2Nzc0o1P85I207ghMDq/CKUnbFPkxhA4HTJd70MEbE0TdDepyZHfSBC10WcrOyNyyT+CkOQWfL5XSt+lK6KIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Om3gT0yP; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb653cb5e6so4500644a91.2
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 10:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723482840; x=1724087640; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p4NJAgKlbw85VGhLhNdojlEwswzL9kA37p7Y/F/p20k=;
        b=Om3gT0yPNl+YJWFd75gIONovOoW7EJWDHmY07CQAqYYUNGxzKSasTpgUe2MaU5QHqW
         SYcZpAuBZ2X5DdS6/yTKoBRCmkveZGDaPFxIP6MDje4lOeIMWMs6ONPgCaE1XYm83van
         DOguWCmWn4U1/BQtoiHcDb2HZzMqhSG+Gi56GHQA0wZ5Nz3i2GwUamGsawIP+oJxycDe
         yOMciW4VaFqowW0Z34O7n52a8LqBBiyRg0vekTMJilVeeRYg9QymI63PueGUkSbLFbsY
         ZKrzY86JNaoNjs7mOxpEcGESkV5/ZrZaBc7d6QmYj+uPwzxp70L2Vu83OjMWQk6FYKOq
         Oo2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723482840; x=1724087640;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p4NJAgKlbw85VGhLhNdojlEwswzL9kA37p7Y/F/p20k=;
        b=b+M65J5zWN0g0KTN2qP+l9j+MQBmqWbwlVN19P9DB6r8azv0h0gL6gsVMgF58AuK74
         +M65XF9pkQCz839uDSFVxgH/AR24YCTp8ScbmoCiKgZ0CdARIYCObic6rnfQwx+m4oCh
         csjnYEPLbcG2xs9xXfQOWWpBN0lkDEC0llEEKKsk959vCdk1oEQOIYMmiZWZUOozpLg3
         glU730RZ5lHjRXVrDd7JuS4C32VtJmnf8naOR02wM/FhNDHn3f46XGd/S+9j362qoxiE
         Ub86g4A49RGzfUHX4q1Ff0PwyNMrno1E+aihvG41mEuf8RVw6PsZEUYbJA+nvDu5C3zJ
         dMZw==
X-Forwarded-Encrypted: i=1; AJvYcCXhkbLuy+6mzG8Ax0NFARwybhWrddQbZkeNgOW5peyF+ElkR6ITueH8a0+Uxnvuw06v1U0/dC+3HfdN3VBb4KlW041A
X-Gm-Message-State: AOJu0YwO6TZ39rGLzOGS6nLovYNwOsEyPkOSTA/S3OoCNVCJMjh2QUox
	97Q49fhOqpsxZfBnYn9tQlsTcjhXNUHxU82PQioqGBdHsBtX165VQPjJ92f17WUsa3IsNts5Vs+
	+d4coZg==
X-Google-Smtp-Source: AGHT+IGsq0NXeVnh711FpZcONc4neA3zJpPkfgfQhyPMtDae/Qu8IfPY6qEEKtzfAXthdm5Ar0YttKZvPO2O
X-Received: from vipin.c.googlers.com ([34.105.13.176]) (user=vipinsh
 job=sendgmr) by 2002:a17:90a:8585:b0:2c9:61e2:ce26 with SMTP id
 98e67ed59e1d1-2d3924b8d05mr46537a91.2.1723482840468; Mon, 12 Aug 2024
 10:14:00 -0700 (PDT)
Date: Mon, 12 Aug 2024 10:13:41 -0700
In-Reply-To: <20240812171341.1763297-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240812171341.1763297-1-vipinsh@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240812171341.1763297-3-vipinsh@google.com>
Subject: [PATCH 2/2] KVM: x86/mmu: Recover NX Huge pages belonging to TDP MMU
 under MMU read lock
From: Vipin Sharma <vipinsh@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: dmatlack@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Use MMU read lock to recover NX huge pages belonging to TDP MMU. Iterate
through kvm->arch.possible_nx_huge_pages while holding
kvm->arch.tdp_mmu_pages_lock. Rename kvm_tdp_mmu_zap_sp() to
tdp_mmu_zap_sp() and make it static as there are no callers outside of
TDP MMU.

Ignore the zapping if any of the following is true for parent pte:

 - Pointing to some other page table.
 - Pointing to a huge page.
 - Not present.

These scenarios can happen as recovering is running under MMU read lock.

Zapping under MMU read lock unblock vCPUs which are waiting for MMU read
lock too.

This optimizaion was created to solve a guest jitter issue on Windows VM
which was observing an increase in network latency. The test workload sets
up two Windows VM and use latte.exe[1] binary to run network latency
benchmark. Running NX huge page recovery under MMU lock was causing
latency to increase up to 30 ms because vCPUs were waiting for MMU lock.

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
Latency(usec) 70.41
CPU(%)        1.7
CtxSwitch/sec 31125     (2.19/iteration)
SysCall/sec   62184     (4.38/iteration)
Interrupt/sec 48319     (3.40/iteration)

Interval(usec)   Frequency
      0          9999964
   1000          12
   2000          3
   3000          0
   4000          0
   5000          0
   6000          0
   7000          1
   8000          1
   9000          1
  10000          2
  11000          1
  12000          0
  13000          4
  14000          1
  15000          1
  16000          4
  17000          1
  18000          2
  19000          0
  20000          0
  21000          1
  22000          0
  23000          0
  24000          1

After
-----

Protocol      UDP
SendMethod    Blocking
ReceiveMethod Blocking
SO_SNDBUF     Default
SO_RCVBUF     Default
MsgSize(byte) 4
Iterations    10000000
Latency(usec) 70.98
CPU(%)        1.3
CtxSwitch/sec 28967     (2.06/iteration)
SysCall/sec   48988     (3.48/iteration)
Interrupt/sec 47280     (3.36/iteration)

Interval(usec)   Frequency
      0          9999996
   1000          4

[1] https://github.com/microsoft/latte

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 10 +++++---
 arch/x86/kvm/mmu/tdp_mmu.c | 48 ++++++++++++++++++++++++++------------
 arch/x86/kvm/mmu/tdp_mmu.h |  1 -
 3 files changed, 40 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5534fcc9d1b5..d95770d5303a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7321,6 +7321,7 @@ struct kvm_mmu_page *kvm_mmu_possible_nx_huge_page(struct kvm *kvm, bool tdp_mmu
 	struct kvm_mmu_page *sp = NULL;
 	ulong i = 0;
 
+	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	/*
 	 * We use a separate list instead of just using active_mmu_pages because
 	 * the number of shadow pages that be replaced with an NX huge page is
@@ -7330,10 +7331,13 @@ struct kvm_mmu_page *kvm_mmu_possible_nx_huge_page(struct kvm *kvm, bool tdp_mmu
 	list_for_each_entry(sp, &kvm->arch.possible_nx_huge_pages, possible_nx_huge_page_link) {
 		if (i++ >= max)
 			break;
-		if (is_tdp_mmu_page(sp) == tdp_mmu)
+		if (is_tdp_mmu_page(sp) == tdp_mmu) {
+			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 			return sp;
+		}
 	}
 
+	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 	return NULL;
 }
 
@@ -7422,9 +7426,9 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 	rcu_idx = srcu_read_lock(&kvm->srcu);
 
 	if (to_zap && tdp_mmu_enabled) {
-		write_lock(&kvm->mmu_lock);
+		read_lock(&kvm->mmu_lock);
 		to_zap = kvm_tdp_mmu_recover_nx_huge_pages(kvm, to_zap);
-		write_unlock(&kvm->mmu_lock);
+		read_unlock(&kvm->mmu_lock);
 	}
 
 	if (to_zap && kvm_memslots_have_rmaps(kvm)) {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 933bb8b11c9f..7c7d207ee590 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -817,9 +817,11 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	rcu_read_unlock();
 }
 
-bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
+static bool tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	u64 old_spte;
+	struct tdp_iter iter = {};
+
+	lockdep_assert_held_read(&kvm->mmu_lock);
 
 	/*
 	 * This helper intentionally doesn't allow zapping a root shadow page,
@@ -828,12 +830,25 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	if (WARN_ON_ONCE(!sp->ptep))
 		return false;
 
-	old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
-	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
+	iter.old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
+	iter.sptep = sp->ptep;
+	iter.level = sp->role.level + 1;
+	iter.gfn = sp->gfn;
+	iter.as_id = kvm_mmu_page_as_id(sp);
+
+retry:
+	/*
+	 * Since mmu_lock is held in read mode, it's possible to race with
+	 * another CPU which can remove sp from the page table hierarchy.
+	 *
+	 * No need to re-read iter.old_spte as tdp_mmu_set_spte_atomic() will
+	 * update it in the case of failure.
+	 */
+	if (sp->spt != spte_to_child_pt(iter.old_spte, iter.level))
 		return false;
 
-	tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte,
-			 SHADOW_NONPRESENT_VALUE, sp->gfn, sp->role.level + 1);
+	if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
+		goto retry;
 
 	return true;
 }
@@ -1807,7 +1822,7 @@ ulong kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm, ulong to_zap)
 	struct kvm_mmu_page *sp;
 	bool flush = false;
 
-	lockdep_assert_held_write(&kvm->mmu_lock);
+	lockdep_assert_held_read(&kvm->mmu_lock);
 	/*
 	 * Zapping TDP MMU shadow pages, including the remote TLB flush, must
 	 * be done under RCU protection, because the pages are freed via RCU
@@ -1821,7 +1836,6 @@ ulong kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm, ulong to_zap)
 		if (!sp)
 			break;
 
-		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
 		WARN_ON_ONCE(!sp->role.direct);
 
 		/*
@@ -1831,12 +1845,17 @@ ulong kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm, ulong to_zap)
 		 * recovered, along with all the other huge pages in the slot,
 		 * when dirty logging is disabled.
 		 */
-		if (kvm_mmu_sp_dirty_logging_enabled(kvm, sp))
+		if (kvm_mmu_sp_dirty_logging_enabled(kvm, sp)) {
+			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 			unaccount_nx_huge_page(kvm, sp);
-		else
-			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
-
-		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
+			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+			to_zap--;
+			WARN_ON_ONCE(sp->nx_huge_page_disallowed);
+		} else if (tdp_mmu_zap_sp(kvm, sp)) {
+			flush = true;
+			to_zap--;
+			WARN_ON_ONCE(sp->nx_huge_page_disallowed);
+		}
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
 			if (flush) {
@@ -1844,10 +1863,9 @@ ulong kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm, ulong to_zap)
 				flush = false;
 			}
 			rcu_read_unlock();
-			cond_resched_rwlock_write(&kvm->mmu_lock);
+			cond_resched_rwlock_read(&kvm->mmu_lock);
 			rcu_read_lock();
 		}
-		to_zap--;
 	}
 
 	if (flush)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 7d68c2ddf78c..e0315cce6798 100644
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
2.46.0.76.ge559c4bf1a-goog


