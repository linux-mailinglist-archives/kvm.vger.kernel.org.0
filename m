Return-Path: <kvm+bounces-39443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8E9DA470D7
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:20:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D93B3B1C2B
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29E0517A2E1;
	Thu, 27 Feb 2025 01:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bQALva22"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE8015F41F;
	Thu, 27 Feb 2025 01:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619147; cv=none; b=ncRqSh9DPjuVrcqnuWSJ10kYqItLrSHM4xf5JQwFOiYPMPi90nEnA9a//Oo3LxyHMX/iaPokhnImjBMv25fLKo0/gP7/JUid9Yw10TZgr9GMRLXeNpoR8cBz4efZ8h/P3q44V+O5lQtjOrtFRtsLtMk4MtL0WycDFZtiwB66k2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619147; c=relaxed/simple;
	bh=gUJ+Ih2J/jHcolFrLhOfb5sHgVPqwuVe3UgbkZb0DwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgIh+AVdMQxjNiKYlGTdbXNL0vbvkgFJw8lK8G+V2FzsSFNxDhOyW4aPi7m8sdYRCDMXRqp1Tm7nhxou1rWDnQOWSNpJBvsz08sdEJYPL1DF21ixkPscvyGsjNmRGv+iGJGgWdGyxm7kU45UZx8+yF7BD5wycmlStVe8QL59PIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bQALva22; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619146; x=1772155146;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gUJ+Ih2J/jHcolFrLhOfb5sHgVPqwuVe3UgbkZb0DwQ=;
  b=bQALva225N/ljgHVGTKwAY7uQwL57DaWz19qmuCL/h5+7Ic1TxN/jqBl
   JNR2OGQUBUwOuiUS4mAYnby3nmaLvZw9CbfVCZEGWcQk5qIjAMlDhuUmZ
   YJMTgVCTguZQdfeF3+U78j280SCxFtdlFrYPt6h7l7y/jlKwnKxoI8BeZ
   Hek00kIuiWGv15mtzVP3k2i1d058y5Mm+S8rmaoZmSNyOV2yxzhxWfTWa
   F2XfXzhE1W1ePtRQz0yCYZvocFoXyCMJoo7zKpdWqk5eWAPtW53kVw2hj
   nI7R0KEHf0jl8aGVq7hW56+MyWFz0aywEo+dPnesOErvoxHRfw1hm36Pc
   w==;
X-CSE-ConnectionGUID: eWHlxOoPS1SZhblRBWIvLQ==
X-CSE-MsgGUID: pAm4npjrRPSvcWkwZbwEzg==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959608"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959608"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:06 -0800
X-CSE-ConnectionGUID: c8OPJmhqSJ6Qi8Zub0CWIw==
X-CSE-MsgGUID: 4NIe5vdFSriBgLX4zYdJ2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674876"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:02 -0800
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
Subject: [PATCH v2 05/20] KVM: TDX: Handle TDX PV CPUID hypercall
Date: Thu, 27 Feb 2025 09:20:06 +0800
Message-ID: <20250227012021.1778144-6-binbin.wu@linux.intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Handle TDX PV CPUID hypercall for the CPUIDs virtualized by VMM
according to TDX Guest Host Communication Interface (GHCI).

For TDX, most CPUID leaf/sub-leaf combinations are virtualized by
the TDX module while some trigger #VE.  On #VE, TDX guest can issue
TDG.VP.VMCALL<INSTRUCTION.CPUID> (same value as EXIT_REASON_CPUID)
to request VMM to emulate CPUID operation.

Morph PV CPUID hypercall to EXIT_REASON_CPUID and wire up  to the KVM
backend function.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[binbin: rewrite changelog]
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" v2:
- Morph PV CPUID hypercall to EXIT_REASON_CPUID. (Sean)
- Rebased to use tdcall_to_vmx_exit_reason().
- Use vp_enter_args directly instead of helpers.
- Skip setting return code as TDVMCALL_STATUS_SUCCESS.

TDX "the rest" v1:
- Rewrite changelog.
- Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)
---
 arch/x86/kvm/vmx/tdx.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 25ae2c2826d0..8019bf553ca5 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -845,6 +845,7 @@ static bool tdx_guest_state_is_invalid(struct kvm_vcpu *vcpu)
 static __always_inline u32 tdcall_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
 {
 	switch (tdvmcall_leaf(vcpu)) {
+	case EXIT_REASON_CPUID:
 	case EXIT_REASON_IO_INSTRUCTION:
 		return tdvmcall_leaf(vcpu);
 	case EXIT_REASON_EPT_VIOLATION:
@@ -1212,6 +1213,25 @@ static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
+{
+	u32 eax, ebx, ecx, edx;
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	/* EAX and ECX for cpuid is stored in R12 and R13. */
+	eax = tdx->vp_enter_args.r12;
+	ecx = tdx->vp_enter_args.r13;
+
+	kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, false);
+
+	tdx->vp_enter_args.r12 = eax;
+	tdx->vp_enter_args.r13 = ebx;
+	tdx->vp_enter_args.r14 = ecx;
+	tdx->vp_enter_args.r15 = edx;
+
+	return 1;
+}
+
 static int tdx_complete_pio_out(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.pio.count = 0;
@@ -1886,6 +1906,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	case EXIT_REASON_EXTERNAL_INTERRUPT:
 		++vcpu->stat.irq_exits;
 		return 1;
+	case EXIT_REASON_CPUID:
+		return tdx_emulate_cpuid(vcpu);
 	case EXIT_REASON_TDCALL:
 		return handle_tdvmcall(vcpu);
 	case EXIT_REASON_VMCALL:
-- 
2.46.0


