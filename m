Return-Path: <kvm+bounces-35261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C50B3A0AD51
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 03:13:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F3A43A6FEF
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 02:13:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD8546A8D2;
	Mon, 13 Jan 2025 02:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CH9WbmR2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505B74437C;
	Mon, 13 Jan 2025 02:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736734423; cv=none; b=UY8fOvAfGV9nESR1eOWg/uLbBLt9l62TeqaShuUk9ANruSInlwQtEH+BgcUfx4BwM6gxHMemPTDcjIA7Hqb0gENRoYG6qIEGILxCgwTLOvKGrrnlfwhsUEpe76ZOpVIddv/UHNpZ96HXuQgWq3wdaoxYs61AHEoEuS/X6yoA44o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736734423; c=relaxed/simple;
	bh=2CEeny/4sGUNO3WdsfyxDbXpCJRwX6qROzz0YdCjdYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6h3uVce2ywCgCfCXB80PYCrf9mgFmYXpzRGb0i+ZqPYKmRTMtHM/0icnFbOX74oQsiNNhsmoYgrBG8YLHFCg3HKhuhHS68jIzrvucXma41dtwxjuw8mtzMeetdurEejrfQFWPr+MwsO+PdHQKdwhNd2x3FbvjZ+K3Hoe3MAWN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CH9WbmR2; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736734421; x=1768270421;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2CEeny/4sGUNO3WdsfyxDbXpCJRwX6qROzz0YdCjdYg=;
  b=CH9WbmR25tKjvt4uGRjRCfHnCpScfP6kBKhG2GUMfPi/QhsdG8AAo3FU
   MHYAVGHhePuCSxX+KFClZ1zvvPQUuTrFfbjEV0Npzz6Np+MEL+vZzXJgL
   AjfX1/b0Qo1ssrbtuVjDRpKdm85ppN1DWk3BslC+kpxbGFvPzxJbIOS71
   gLNPCjArIEZ8TWY1RVWz66Ey0h+wnn1rbdj1BKskc1GMI/tKHSiwK/xF6
   pzcEVP0Jb4mxBomqKb6e9o3ciwW0H/Ns4XN1PpOpWw8C6mjBISjscJVwq
   acdfzGoMlh8o5mKhs52HnBtRFdN6kRua5LzDQNgDPGn2Zu26eFRfasXIE
   Q==;
X-CSE-ConnectionGUID: 6g0Af8TORjqc9X3RDs2+pg==
X-CSE-MsgGUID: L9Ffkj16QQOxtv7V4l6MmA==
X-IronPort-AV: E=McAfee;i="6700,10204,11313"; a="40742821"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="40742821"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 18:13:41 -0800
X-CSE-ConnectionGUID: cKpSbpHOT/CeCL+Sz1g+Ng==
X-CSE-MsgGUID: 3WK+ktr2R0ajxUvQCLUl8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="104843557"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 18:13:37 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com
Subject: [PATCH 4/7] KVM: TDX: Kick off vCPUs when SEAMCALL is busy during TD page removal
Date: Mon, 13 Jan 2025 10:12:50 +0800
Message-ID: <20250113021250.18948-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250113020925.18789-1-yan.y.zhao@intel.com>
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 arch/x86/kvm/vmx/tdx.c | 62 ++++++++++++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/tdx.h |  7 +++++
 2 files changed, 60 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index bb9d914765fc..09677a4cd605 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -312,6 +312,26 @@ static void tdx_clear_page(unsigned long page_pa)
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
 static int __tdx_reclaim_page(hpa_t pa)
 {
@@ -979,6 +999,14 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
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
 
 	if (pi_test_on(&tdx->pi_desc)) {
@@ -1647,15 +1675,23 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm))
 		return -EINVAL;
 
-	do {
+	/*
+	 * When zapping private page, write lock is held. So no race condition
+	 * with other vcpu sept operation.
+	 * Race with TDH.VP.ENTER due to (0-step mitigation) and Guest TDCALLs.
+	 */
+	err = tdh_mem_page_remove(kvm_tdx->tdr_pa, gpa, tdx_level, &entry,
+				  &level_state);
+	if ((err & TDX_OPERAND_BUSY)) {
 		/*
-		 * When zapping private page, write lock is held. So no race
-		 * condition with other vcpu sept operation.  Race only with
-		 * TDH.VP.ENTER.
+		 * The second retry is expected to succeed after kicking off all
+		 * other vCPUs and prevent them from invoking TDH.VP.ENTER.
 		 */
+		tdx_no_vcpus_enter_start(kvm);
 		err = tdh_mem_page_remove(kvm_tdx->tdr_pa, gpa, tdx_level, &entry,
 					  &level_state);
-	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
+		tdx_no_vcpus_enter_stop(kvm);
+	}
 
 	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE &&
 		     err == (TDX_EPT_WALK_FAILED | TDX_OPERAND_ID_RCX))) {
@@ -1726,8 +1762,12 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	WARN_ON_ONCE(level != PG_LEVEL_4K);
 
 	err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &entry, &level_state);
-	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
-		return -EAGAIN;
+	if (unlikely(err & TDX_OPERAND_BUSY)) {
+		/* After no vCPUs enter, the second retry is expected to succeed */
+		tdx_no_vcpus_enter_start(kvm);
+		err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &entry, &level_state);
+		tdx_no_vcpus_enter_stop(kvm);
+	}
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
 		return -EIO;
@@ -1770,9 +1810,13 @@ static void tdx_track(struct kvm *kvm)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	do {
+	err = tdh_mem_track(kvm_tdx->tdr_pa);
+	if ((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY) {
+		/* After no vCPUs enter, the second retry is expected to succeed */
+		tdx_no_vcpus_enter_start(kvm);
 		err = tdh_mem_track(kvm_tdx->tdr_pa);
-	} while (unlikely((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY));
+		tdx_no_vcpus_enter_stop(kvm);
+	}
 
 	if (KVM_BUG_ON(err, kvm))
 		pr_tdx_error(TDH_MEM_TRACK, err);
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 0833d1084331..e369a6f8721b 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -48,6 +48,13 @@ struct kvm_tdx {
 
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
2.43.2


