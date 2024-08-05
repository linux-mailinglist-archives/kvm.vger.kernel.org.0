Return-Path: <kvm+bounces-23281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 215E8948616
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 01:33:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A239A1F21275
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 23:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B5B416F8E7;
	Mon,  5 Aug 2024 23:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mfk3PVau"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEB416F0D8
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 23:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722900685; cv=none; b=bew32UF6/bDY/yeaqmdZqyE2i+k1V5gv0Gd3vPvqBcYuVDPE4rnFJhZq7gm3x84DK9+kemB+OUvb1WHwm2UhCrxu/u2wRHRAbL2u4Lllg+cnoK2Uy2GHCrM2w7xRSBnni4qEMkiy2E3B4uj1/+RY+w7cnGd9Joox9vpkSDyvic4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722900685; c=relaxed/simple;
	bh=G6tpH0+cUa+eTiVlcsNAusIGfbblRYTeHtSvmVB5AHc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sXMwgcEAJ5pH6iSEdY4XvZ6c6867yBBzRJeIm+U7PHfzvZS2euo3cnomPzQlcx3N9dARkKz441o6bxae/yapz5KtRyBwIvcQfr3DEj7jjcllOerIM26Ynp0MpV+qBMid/VovQK45SB7YiSHyhUFSUfLkQak2/H1Hgv1l+lX0oow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mfk3PVau; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0353b731b8so124221276.2
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 16:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722900683; x=1723505483; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oGjvAvR4aTZnDEXjHKFS7ecNhScflJ06geRDwp6AlsU=;
        b=mfk3PVaumjsThJ6vlTfoSGCnZMdUG6PZIwb2mVnosYcZ5UPF2t5QEjlSopK8wyxrIf
         WO51fgFZLcKLYY3C0iMPDldkHA1BuSjOxcr7pTTYJwK6lOtU9eCVEn+S69VfFqHB0o1M
         JngLTcOy9yiXDV1pRJZJOpOVvvvahd8ACE3xPtf5463jb2/1IH5Y7N0CaKb6YhUvMZ8V
         utBCweWFxNZhtcosfdcFy1ZPXmrT2wrl19XG/QPOGT340+uPCTikLWBrVfaItb9Bryyy
         FjDCP/DSHsZZ/jpcqY54Q/QVmdnzBbMIQpc9IVbqS3hS/DPwGx9KS6bmFpUFt9iIuvbW
         889A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722900683; x=1723505483;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oGjvAvR4aTZnDEXjHKFS7ecNhScflJ06geRDwp6AlsU=;
        b=ZlWefwrlYK0Frvv2KbnQgpD57jE26KYS3/YFnPCHFiRWvSmsWZjC+XDPV/EbGpkHaI
         bOifVRRy8EOprqdtY5NUSZJe6vKugm9Mm2zPuJf4D5NBK9QdgL/JlybGc8i1jzs4AgRJ
         I/tdy/rPVY6u457kRwrmxwgInhfPHENDvAVUOTCe8CIRgICMMfZNhWadsMi7MPO5o4Wt
         4VQ4Tm6x/o6kvlkUzRh9OhSaK0GyYYcfAedvKgBMKt289mZpoueTi5E9Ed/xtU2tsbwZ
         V7+IeLvBN46ZviYsGXPswlKY976Bsp1D4xQ0MltREM+BaTVRz+YkaUDBa2VVTQL4KfdM
         TLWg==
X-Gm-Message-State: AOJu0YyMR2mUsesFFOV6XnG6VB7Taxlp645XyZnBnCFwrVh4fzDzPtl8
	S2t2rkpWS72VzGeo/fgYo6gEbAGN2keBLmm7DzyBKVdI9NolOOSdcG5JT3eYEH2xx/EIFzTarL4
	9ZlpiVEfTIg==
X-Google-Smtp-Source: AGHT+IEdsLOY9gj0leB4a+Fht5C1DlaSoGKM0TX0qGe4w0rEaXaL+5oVgOGs6kwLcWdJbm7TqTewoGK5JCEo5w==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:c02:b0:e0b:d229:af01 with SMTP
 id 3f1490d57ef6-e0bde2925d2mr23960276.6.1722900682885; Mon, 05 Aug 2024
 16:31:22 -0700 (PDT)
Date: Mon,  5 Aug 2024 16:31:10 -0700
In-Reply-To: <20240805233114.4060019-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240805233114.4060019-1-dmatlack@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240805233114.4060019-4-dmatlack@google.com>
Subject: [PATCH 3/7] KVM: x86/mmu: Batch TLB flushes when zapping collapsible
 TDP MMU SPTEs
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Set SPTEs directly to SHADOW_NONPRESENT_VALUE and batch up TLB flushes
when zapping collapsible SPTEs, rather than freezing them first.

Freezing the SPTE first is not required. It is fine for another thread
holding mmu_lock for read to immediately install a present entry before
TLBs are flushed because the underlying mapping is not changing. vCPUs
that translate through the stale 4K mappings or a new huge page mapping
will still observe the same GPA->HPA translations.

KVM must only flush TLBs before dropping RCU (to avoid use-after-free of
the zapped page tables) and before dropping mmu_lock (to synchronize
with mmu_notifiers invalidating mappings).

In VMs backed with 2MiB pages, batching TLB flushes improves the time it
takes to zap collapsible SPTEs to disable dirty logging:

 $ ./dirty_log_perf_test -s anonymous_hugetlb_2mb -v 64 -e -b 4g

 Before: Disabling dirty logging time: 14.334453428s (131072 flushes)
 After:  Disabling dirty logging time: 4.794969689s  (76 flushes)

Skipping freezing SPTEs also avoids stalling vCPU threads on the frozen
SPTE for the time it takes to perform a remote TLB flush. vCPUs faulting
on the zapped mapping can now immediately install a new huge mapping and
proceed with guest execution.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 54 +++++++-------------------------------
 1 file changed, 9 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f881e79243b3..fad2912d3d4c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -591,48 +591,6 @@ static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	return 0;
 }
 
-static inline int __must_check tdp_mmu_zap_spte_atomic(struct kvm *kvm,
-						       struct tdp_iter *iter)
-{
-	int ret;
-
-	lockdep_assert_held_read(&kvm->mmu_lock);
-
-	/*
-	 * Freeze the SPTE by setting it to a special, non-present value. This
-	 * will stop other threads from immediately installing a present entry
-	 * in its place before the TLBs are flushed.
-	 *
-	 * Delay processing of the zapped SPTE until after TLBs are flushed and
-	 * the FROZEN_SPTE is replaced (see below).
-	 */
-	ret = __tdp_mmu_set_spte_atomic(iter, FROZEN_SPTE);
-	if (ret)
-		return ret;
-
-	kvm_flush_remote_tlbs_gfn(kvm, iter->gfn, iter->level);
-
-	/*
-	 * No other thread can overwrite the frozen SPTE as they must either
-	 * wait on the MMU lock or use tdp_mmu_set_spte_atomic() which will not
-	 * overwrite the special frozen SPTE value. Use the raw write helper to
-	 * avoid an unnecessary check on volatile bits.
-	 */
-	__kvm_tdp_mmu_write_spte(iter->sptep, SHADOW_NONPRESENT_VALUE);
-
-	/*
-	 * Process the zapped SPTE after flushing TLBs, and after replacing
-	 * FROZEN_SPTE with 0. This minimizes the amount of time vCPUs are
-	 * blocked by the FROZEN_SPTE and reduces contention on the child
-	 * SPTEs.
-	 */
-	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			    SHADOW_NONPRESENT_VALUE, iter->level, true);
-
-	return 0;
-}
-
-
 /*
  * tdp_mmu_set_spte - Set a TDP MMU SPTE and handle the associated bookkeeping
  * @kvm:	      KVM instance
@@ -1625,12 +1583,15 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 	gfn_t end = start + slot->npages;
 	struct tdp_iter iter;
 	int max_mapping_level;
+	bool flush = false;
 
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, flush, true)) {
+			flush = false;
 			continue;
+		}
 
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
@@ -1653,8 +1614,8 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 		while (max_mapping_level > iter.level)
 			tdp_iter_step_up(&iter);
 
-		/* Note, a successful atomic zap also does a remote TLB flush. */
-		(void)tdp_mmu_zap_spte_atomic(kvm, &iter);
+		if (!tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
+			flush = true;
 
 		/*
 		 * If the atomic zap fails, the iter will recurse back into
@@ -1662,6 +1623,9 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 		 */
 	}
 
+	if (flush)
+		kvm_flush_remote_tlbs_memslot(kvm, slot);
+
 	rcu_read_unlock();
 }
 
-- 
2.46.0.rc2.264.g509ed76dc8-goog


