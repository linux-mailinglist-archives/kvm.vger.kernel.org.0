Return-Path: <kvm+bounces-35260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 24054A0AD4F
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 03:13:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CA9216615B
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 02:13:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCCE554648;
	Mon, 13 Jan 2025 02:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OBYwjLPC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4710C82488;
	Mon, 13 Jan 2025 02:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736734391; cv=none; b=C07ZBY66DZNhkxbO/9Qt5PIrUxj/aAyLhNTVfiXMGd3AWn/HnH9qO+v0Ir1lZtCFoqZX2FiEY3+mZpFgT4vobz5ZjAWCx4ulpvj46ab/P2hBjZQFL5bfQPN1Vrz951YO0O38Xf0NyygNO39VSNSMZa0X1cRb7wwkIsMMvgAsu+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736734391; c=relaxed/simple;
	bh=1qPxw2H6pIb2tKB9Z4otmErPdYyk8jXouhWmf3AO078=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIT2BzGSVPR4H+GJ+A29fOP2+iBZ67YfYMVwoRjmk2q7bT+OreNHeDD94p+UiS6lsMhwuYfts3kOvDUAP5ckJ+9bMZVDbDGCObrn8tvRPGB015Ftmt/gKhX8ZFpx6xaf+5+24my5t3iWtGYHvBeSzFlzV1FEVxSK3J4yDZbA2aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OBYwjLPC; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736734390; x=1768270390;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1qPxw2H6pIb2tKB9Z4otmErPdYyk8jXouhWmf3AO078=;
  b=OBYwjLPCad+0zyrwUBZzKVD44epZx05xbetyARGnKw2p+UzaI+0jiOPA
   OpNMz399PhGD3JIYGdrbgcVcEuqg8KHmoe0AdCLE21ynsVW2AsEwwUmvo
   aRfJkFqCoGPaV6TU4uwzIpvqzb4Fm+Wn0hS4nP+O8CaHRBhdiLWLN8jcr
   qPrjhy5KSDC1n2HZBg6N++amtqjXt79TOUW0auXIac4KsS99ksepib82H
   IuaizfJR6DkPgVwr2/40sTaxlsuDEDnH+2gL1Gokunr6oLs5Ly8Cd7+9i
   B+nN7Aav5pZPZoQ/f6b4RS5qnIdw8+puIiQDR+Sl+K/PfSb1hNBjmsjEp
   A==;
X-CSE-ConnectionGUID: Qld9p0hLRjmfmqVVlYhLIA==
X-CSE-MsgGUID: ENUNiLySRSmv04V6kMZk1g==
X-IronPort-AV: E=McAfee;i="6700,10204,11313"; a="59461297"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="59461297"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 18:13:09 -0800
X-CSE-ConnectionGUID: ITu88GoCSPeXFWtHwX4Gng==
X-CSE-MsgGUID: qo8freTQRlu8hgxGXZWDsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="108951033"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 18:13:05 -0800
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
Subject: [PATCH 3/7] KVM: TDX: Retry locally in TDX EPT violation handler on RET_PF_RETRY
Date: Mon, 13 Jan 2025 10:12:18 +0800
Message-ID: <20250113021218.18922-1-yan.y.zhao@intel.com>
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

Retry locally in the TDX EPT violation handler for private memory to reduce
the chances for tdh_mem_sept_add()/tdh_mem_page_aug() to contend with
tdh_vp_enter().

TDX EPT violation installs private pages via tdh_mem_sept_add() and
tdh_mem_page_aug(). The two may have contention with tdh_vp_enter() or
TDCALLs.

Resources    SHARED  users      EXCLUSIVE users
------------------------------------------------------------
SEPT tree  tdh_mem_sept_add     tdh_vp_enter(0-step mitigation)
           tdh_mem_page_aug
------------------------------------------------------------
SEPT entry                      tdh_mem_sept_add (Host lock)
                                tdh_mem_page_aug (Host lock)
                                tdg_mem_page_accept (Guest lock)
                                tdg_mem_page_attr_rd (Guest lock)
                                tdg_mem_page_attr_wr (Guest lock)

Though the contention between tdh_mem_sept_add()/tdh_mem_page_aug() and
TDCALLs may be removed in future TDX module, their contention with
tdh_vp_enter() due to 0-step mitigation still persists.

The TDX module may trigger 0-step mitigation in SEAMCALL TDH.VP.ENTER,
which works as follows:
0. Each TDH.VP.ENTER records the guest RIP on TD entry.
1. When the TDX module encounters a VM exit with reason EPT_VIOLATION, it
   checks if the guest RIP is the same as last guest RIP on TD entry.
   -if yes, it means the EPT violation is caused by the same instruction
            that caused the last VM exit.
            Then, the TDX module increases the guest RIP no-progress count.
            When the count increases from 0 to the threshold (currently 6),
            the TDX module records the faulting GPA into a
            last_epf_gpa_list.
   -if no,  it means the guest RIP has made progress.
            So, the TDX module resets the RIP no-progress count and the
            last_epf_gpa_list.
2. On the next TDH.VP.ENTER, the TDX module (after saving the guest RIP on
   TD entry) checks if the last_epf_gpa_list is empty.
   -if yes, TD entry continues without acquiring the lock on the SEPT tree.
   -if no,  it triggers the 0-step mitigation by acquiring the exclusive
            lock on SEPT tree, walking the EPT tree to check if all page
            faults caused by the GPAs in the last_epf_gpa_list have been
            resolved before continuing TD entry.

Since KVM TDP MMU usually re-enters guest whenever it exits to userspace
(e.g. for KVM_EXIT_MEMORY_FAULT) or encounters a BUSY, it is possible for a
tdh_vp_enter() to be called more than the threshold count before a page
fault is addressed, triggering contention when tdh_vp_enter() attempts to
acquire exclusive lock on SEPT tree.

Retry locally in TDX EPT violation handler to reduce the count of invoking
tdh_vp_enter(), hence reducing the possibility of its contention with
tdh_mem_sept_add()/tdh_mem_page_aug(). However, the 0-step mitigation and
the contention are still not eliminated due to KVM_EXIT_MEMORY_FAULT,
signals/interrupts, and cases when one instruction faults more GFNs than
the threshold count.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 1cf3ef0faff7..bb9d914765fc 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1854,6 +1854,8 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 {
 	gpa_t gpa = tdexit_gpa(vcpu);
 	unsigned long exit_qual;
+	bool local_retry = false;
+	int ret;
 
 	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa)) {
 		if (tdx_is_sept_violation_unexpected_pending(vcpu)) {
@@ -1872,6 +1874,24 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 		 * due to aliasing a single HPA to multiple GPAs.
 		 */
 		exit_qual = EPT_VIOLATION_ACC_WRITE;
+
+		/*
+		 * Mapping of private memory may return RET_PF_RETRY due to
+		 * SEAMCALL contention, e.g.
+		 * - TDH.MEM.PAGE.AUG/TDH.MEM.SEPT.ADD on local vCPU may
+		 *   contend with TDH.VP.ENTER (due to 0-step mitigation)
+		 *   on a remote vCPU.
+		 * - TDH.MEM.PAGE.AUG/TDH.MEM.SEPT.ADD on local vCPU may
+		 *   contend with TDG.MEM.PAGE.ACCEPT on a remote vCPU.
+		 *
+		 * Retry internally in TDX to prevent exacerbating the
+		 * activation of 0-step mitigation on local vCPU.
+		 * However, despite these retries, the 0-step mitigation on the
+		 * local vCPU may still be triggered due to:
+		 * - Exiting on signals, interrupts.
+		 * - KVM_EXIT_MEMORY_FAULT.
+		 */
+		local_retry = true;
 	} else {
 		exit_qual = tdexit_exit_qual(vcpu);
 		/*
@@ -1884,7 +1904,24 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 	}
 
 	trace_kvm_page_fault(vcpu, tdexit_gpa(vcpu), exit_qual);
-	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual);
+
+	while (1) {
+		ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
+
+		if (ret != RET_PF_RETRY || !local_retry)
+			break;
+
+		/*
+		 * Break and keep the orig return value.
+		 * Signal & irq handling will be done later in vcpu_run()
+		 */
+		if (signal_pending(current) || pi_has_pending_interrupt(vcpu) ||
+		    kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending)
+			break;
+
+		cond_resched();
+	}
+	return ret;
 }
 
 int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
-- 
2.43.2


