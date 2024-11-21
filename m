Return-Path: <kvm+bounces-32256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 282E49D4C6E
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 12:59:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF8BB282917
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 11:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4805D1D61B9;
	Thu, 21 Nov 2024 11:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JeBwvqpV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D91B1CB9E1;
	Thu, 21 Nov 2024 11:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732190339; cv=none; b=iv3XWPD/A5PcRoFY17/d0mR/3JQF3bW1Z5n7trLWyLWGY6oGK/KHVUKyFQc0BTYFbA8xpog0uvpCgHX1TLqq022P80sR1zDLCL2egDZkRQ/Vy6Q/g3sXZ5tsJSPTz+3PWgBf2LLKHA0LLj1RrwDdk3+ZA5iCMUFK9fdhXsQx0fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732190339; c=relaxed/simple;
	bh=fWQidp6Vy8EzY8Z5MLIsw88ehF7LX69udiEoGr/XbgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8HF0dqKq2tu00MOp+Tr/gRhxkNuPuESJWU3RLesYvsLH+hv5U2ITBI/HJv+t4gNLd9AHiV3O5ft7vph49it0t6HP/uIU8KPHFjD7HZEpcmLL1J3jSLBk7IBKZgfnTbDRzG0IofBRaf/KrjxWBUYQs8xWAG+T+bf6qWVWPBUYcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JeBwvqpV; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732190337; x=1763726337;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fWQidp6Vy8EzY8Z5MLIsw88ehF7LX69udiEoGr/XbgE=;
  b=JeBwvqpVWZkuJUqgU35FkPwxBtonaC+FJ/8T1AZTSSnLPK9TDSMsgfdX
   fJ1oPbkLB0IT8UUo0iw7AJwjjrr1tAh2XTDyBV9aIRq6DvhLU5WKjBtNW
   mJeGFzu8oX1AZ5Cr1U4jFyxtbdf3/H2QDXXg4BAK8vg+P7LbdzuFKP5x/
   1CvUUHjykAWWr7c7TUEcvoKbXz+UuKw+wbQHItu1G4JcIlbT0LECPWm2o
   1V7TIEL7jSIGOoANCz4kOJLL1Gf+XAMRL3575DrmzZIm2tKK6q2vYNYvq
   8NQLTgGNUecMy0ulUyYlXV0+FWgDr60NQzeCFZzshzuh9bThTpFBNvmj9
   g==;
X-CSE-ConnectionGUID: hnq9tm+4SUK02618TbDbww==
X-CSE-MsgGUID: X9wV/npATiGTWudzG5zqEw==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="35964894"
X-IronPort-AV: E=Sophos;i="6.12,172,1728975600"; 
   d="scan'208";a="35964894"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 03:58:57 -0800
X-CSE-ConnectionGUID: PgXNuszwTUmZbQ8uobpqqQ==
X-CSE-MsgGUID: GdACVskXS76RhVcF7oPuow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,172,1728975600"; 
   d="scan'208";a="90354955"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 03:58:53 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: dave.hansen@linux.intel.com,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 1/2] KVM: TDX: Retry in TDX when installing TD private/sept pages
Date: Thu, 21 Nov 2024 19:56:14 +0800
Message-ID: <20241121115614.26363-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241121115139.26338-1-yan.y.zhao@intel.com>
References: <20241121115139.26338-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For tdh_mem_page_add, Just return error when TDX_OPERAND_BUSY is found.

For tdh_mem_sept_add(), tdh_mem_page_aug(),
- Return -EBUSY in KVM for TDX_OPERAND_BUSY to cause RET_PF_RETRY
  to be returned in kvm_mmu_do_page_fault()/kvm_mmu_page_fault().
- Inside TDX's EPT violation handler, retry on RET_PF_RETRY as
  long as there are no pending signals/interrupts.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c |  2 +-
 arch/x86/kvm/vmx/tdx.c | 53 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bd2eaa1dbebb..f16c0e7248eb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6179,7 +6179,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 		vcpu->stat.pf_spurious++;
 
 	if (r != RET_PF_EMULATE)
-		return 1;
+		return r;
 
 emulate:
 	return x86_emulate_instruction(vcpu, cr2_or_gpa, emulation_type, insn,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 23e6f25dd837..60d9e9d050ad 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1705,8 +1705,9 @@ int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 
 	err = tdh_mem_sept_add(to_kvm_tdx(kvm)->tdr_pa, gpa, tdx_level, hpa, &entry,
 			       &level_state);
-	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
-		return -EAGAIN;
+	if (unlikely(err & TDX_OPERAND_BUSY))
+		return -EBUSY;
+
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error_2(TDH_MEM_SEPT_ADD, err, entry, level_state);
 		return -EIO;
@@ -1855,6 +1856,8 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 {
 	gpa_t gpa = tdexit_gpa(vcpu);
 	unsigned long exit_qual;
+	bool local_retry = false;
+	int ret;
 
 	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa)) {
 		if (tdx_is_sept_violation_unexpected_pending(vcpu)) {
@@ -1873,6 +1876,23 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 		 * due to aliasing a single HPA to multiple GPAs.
 		 */
 		exit_qual = EPT_VIOLATION_ACC_WRITE;
+
+		/*
+		 * Mapping of private memory may meet RET_PF_RETRY due to
+		 * SEAMCALL contentions, e.g.
+		 * - TDH.MEM.PAGE.AUG/TDH.MEM.SEPT.ADD on local vCPU vs
+		 *   TDH.VP.ENTER with 0-step mitigation on a remote vCPU.
+		 * - TDH.MEM.PAGE.AUG/TDH.MEM.SEPT.ADD on local vCPU vs
+		 *   TDG.MEM.PAGE.ACCEPT on a remote vCPU.
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
@@ -1885,7 +1905,24 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
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
@@ -3028,13 +3065,11 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	}
 
 	ret = 0;
-	do {
-		err = tdh_mem_page_add(kvm_tdx->tdr_pa, gpa, pfn_to_hpa(pfn),
-				       pfn_to_hpa(page_to_pfn(page)),
-				       &entry, &level_state);
-	} while (err == TDX_ERROR_SEPT_BUSY);
+	err = tdh_mem_page_add(kvm_tdx->tdr_pa, gpa, pfn_to_hpa(pfn),
+			       pfn_to_hpa(page_to_pfn(page)),
+			       &entry, &level_state);
 	if (err) {
-		ret = -EIO;
+		ret = unlikely(err & TDX_OPERAND_BUSY) ? -EBUSY : -EIO;
 		goto out;
 	}
 
-- 
2.43.2


