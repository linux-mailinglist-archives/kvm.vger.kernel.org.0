Return-Path: <kvm+bounces-39442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66F50A470D5
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:20:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E75E8188DB7D
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6574315CD55;
	Thu, 27 Feb 2025 01:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nqGUi7QG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DA814B96E;
	Thu, 27 Feb 2025 01:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619144; cv=none; b=RbtHi03G3Tth7YhoSkJOSIXqj3qj65NNRqx9FuOjw22QzelD/87CAGHTJ2pHJgUeL5Beit0pbBWEjduOLSYJe6NBgSPWjUrE14PrdoLnhcBbOpoXeXbQ2hcAygCo2g9IT2DLl28HRLH171GowzfahO1zPUwPkl+m1x3Un+CohZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619144; c=relaxed/simple;
	bh=qXfVJSCufMdZGiMGONaIm/kQ0o1b85tXM8RtmwjYVvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ergCAsyJe4I/GOoMRypqPGi3QxsrxTCECP/djqMgvhMJhOC0OP+eCpywcQstz57nCqxG6fAVy2WuCXHetvtNEaaMVH/Bw5Y9od7kglE7WOub5R/dkeXZUDxLXLQepLfc47RT6w2xCvQALUhpmhn8NDmxkw3yBA7FaDdzWylbHKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nqGUi7QG; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619143; x=1772155143;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qXfVJSCufMdZGiMGONaIm/kQ0o1b85tXM8RtmwjYVvM=;
  b=nqGUi7QGIQWYpUx8zPOe8VZHbBAzUD70TEpaVKEEgS/tvCM2ymdI5bKT
   XNU4/R2Y8GRBjKosKNqbktbGmbqLYm7I6w4Q1j3fKeSbQLWZNB+2QfGxy
   YB5htETgeV7IvmgJhTteLTu7s++3eAFr5jQXWwXYHP2PfKaKPqW5tyXpp
   MfjE3JJKAPg7kIsNnu1z9k/94Gc+0sZuITEi+V7GRFnPMv3jog7nrdzX0
   7nTh4OqP6vhli4Bg2VgyQ3/L13ctZn9m0avA3z4XsD4ZBvY1xwtyqZluM
   rqV4/nt3oFETc8O65ieWjwIYVicwR4k3E2yOd1MlN6ZiQgybdbxif6Lox
   w==;
X-CSE-ConnectionGUID: zAaU9LMrReqQJ73hno7NzA==
X-CSE-MsgGUID: MmYIAqU/RvSMvE9ZPXdnSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959604"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959604"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:02 -0800
X-CSE-ConnectionGUID: xJftErw0Rr6ZlA/zdj9X9Q==
X-CSE-MsgGUID: 0yfIO+L4QOOCyhMvH6sjcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674858"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:18:59 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 04/20] KVM: TDX: Kick off vCPUs when SEAMCALL is busy during TD page removal
Date: Thu, 27 Feb 2025 09:20:05 +0800
Message-ID: <20250227012021.1778144-5-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
References: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yan Zhao <yan.y.zhao@intel.com>

Kick off all vCPUs and prevent tdh_vp_enter() from executing whenever
tdh_mem_range_block()/tdh_mem_track()/tdh_mem_page_remove() encounters
contention, since the page removal path does not expect error and is less
sensitive to the performance penalty caused by kicking off vCPUs.

Although KVM has protected SEPT zap-related SEAMCALLs with kvm->mmu_lock,
KVM may still encounter TDX_OPERAND_BUSY due to the contention in the TDX
module.
- tdh_mem_track() may contend with tdh_vp_enter().
- tdh_mem_range_block()/tdh_mem_page_remove() may contend with
  tdh_vp_enter() and TDCALLs.

Resources     SHARED users      EXCLUSIVE users
------------------------------------------------------------
TDCS epoch    tdh_vp_enter      tdh_mem_track
------------------------------------------------------------
SEPT tree  tdh_mem_page_remove  tdh_vp_enter (0-step mitigation)
                                tdh_mem_range_block
------------------------------------------------------------
SEPT entry                      tdh_mem_range_block (Host lock)
                                tdh_mem_page_remove (Host lock)
                                tdg_mem_page_accept (Guest lock)
                                tdg_mem_page_attr_rd (Guest lock)
                                tdg_mem_page_attr_wr (Guest lock)

Use a TDX specific per-VM flag wait_for_sept_zap along with
KVM_REQ_OUTSIDE_GUEST_MODE to kick off vCPUs and prevent them from entering
TD, thereby avoiding the potential contention. Apply the kick-off and no
vCPU entering only after each SEAMCALL busy error to minimize the window of
no TD entry, as the contention due to 0-step mitigation or TDCALLs is
expected to be rare.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
Rebased to use helper tdx_operand_busy().
---
 arch/x86/kvm/vmx/tdx.c | 63 ++++++++++++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/tdx.h |  7 +++++
 2 files changed, 61 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 6fa6f7e13e15..25ae2c2826d0 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -294,6 +294,26 @@ static void tdx_clear_page(struct page *page)
 	__mb();
 }
 
+static void tdx_no_vcpus_enter_start(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	WRITE_ONCE(kvm_tdx->wait_for_sept_zap, true);
+
+	kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
+}
+
+static void tdx_no_vcpus_enter_stop(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	WRITE_ONCE(kvm_tdx->wait_for_sept_zap, false);
+}
+
 /* TDH.PHYMEM.PAGE.RECLAIM is allowed only when destroying the TD. */
 static int __tdx_reclaim_page(struct page *page)
 {
@@ -953,6 +973,14 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 		return EXIT_FASTPATH_NONE;
 	}
 
+	/*
+	 * Wait until retry of SEPT-zap-related SEAMCALL completes before
+	 * allowing vCPU entry to avoid contention with tdh_vp_enter() and
+	 * TDCALLs.
+	 */
+	if (unlikely(READ_ONCE(to_kvm_tdx(vcpu->kvm)->wait_for_sept_zap)))
+		return EXIT_FASTPATH_EXIT_HANDLED;
+
 	trace_kvm_entry(vcpu, force_immediate_exit);
 
 	if (pi_test_on(&vt->pi_desc)) {
@@ -1467,15 +1495,24 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm))
 		return -EINVAL;
 
-	do {
+	/*
+	 * When zapping private page, write lock is held. So no race condition
+	 * with other vcpu sept operation.
+	 * Race with TDH.VP.ENTER due to (0-step mitigation) and Guest TDCALLs.
+	 */
+	err = tdh_mem_page_remove(&kvm_tdx->td, gpa, tdx_level, &entry,
+				  &level_state);
+
+	if (unlikely(tdx_operand_busy(err))) {
 		/*
-		 * When zapping private page, write lock is held. So no race
-		 * condition with other vcpu sept operation.  Race only with
-		 * TDH.VP.ENTER.
+		 * The second retry is expected to succeed after kicking off all
+		 * other vCPUs and prevent them from invoking TDH.VP.ENTER.
 		 */
+		tdx_no_vcpus_enter_start(kvm);
 		err = tdh_mem_page_remove(&kvm_tdx->td, gpa, tdx_level, &entry,
 					  &level_state);
-	} while (unlikely(tdx_operand_busy(err)));
+		tdx_no_vcpus_enter_stop(kvm);
+	}
 
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error_2(TDH_MEM_PAGE_REMOVE, err, entry, level_state);
@@ -1559,9 +1596,13 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	WARN_ON_ONCE(level != PG_LEVEL_4K);
 
 	err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
-	if (unlikely(tdx_operand_busy(err)))
-		return -EBUSY;
 
+	if (unlikely(tdx_operand_busy(err))) {
+		/* After no vCPUs enter, the second retry is expected to succeed */
+		tdx_no_vcpus_enter_start(kvm);
+		err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
+		tdx_no_vcpus_enter_stop(kvm);
+	}
 	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
 	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
 		atomic64_dec(&kvm_tdx->nr_premapped);
@@ -1611,9 +1652,13 @@ static void tdx_track(struct kvm *kvm)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	do {
+	err = tdh_mem_track(&kvm_tdx->td);
+	if (unlikely(tdx_operand_busy(err))) {
+		/* After no vCPUs enter, the second retry is expected to succeed */
+		tdx_no_vcpus_enter_start(kvm);
 		err = tdh_mem_track(&kvm_tdx->td);
-	} while (unlikely(tdx_operand_busy(err)));
+		tdx_no_vcpus_enter_stop(kvm);
+	}
 
 	if (KVM_BUG_ON(err, kvm))
 		pr_tdx_error(TDH_MEM_TRACK, err);
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 4e1e71d5d8e8..c6bafac31d4d 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -36,6 +36,13 @@ struct kvm_tdx {
 
 	/* For KVM_TDX_INIT_MEM_REGION. */
 	atomic64_t nr_premapped;
+
+	/*
+	 * Prevent vCPUs from TD entry to ensure SEPT zap related SEAMCALLs do
+	 * not contend with tdh_vp_enter() and TDCALLs.
+	 * Set/unset is protected with kvm->mmu_lock.
+	 */
+	bool wait_for_sept_zap;
 };
 
 /* TDX module vCPU states */
-- 
2.46.0


