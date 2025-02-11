Return-Path: <kvm+bounces-37784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A1A57A301BF
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:54:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB766188A737
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79FB11D5161;
	Tue, 11 Feb 2025 02:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PYo3keyw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5DF1D61A5;
	Tue, 11 Feb 2025 02:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242408; cv=none; b=C08JkLbbjyh1Ln9wpky8PtpGqE1HWatza6NA/eDQhmUqSsXShLmF58dyFkTuGyIhzrS4R5l8txn9z+9HfKq/xflBM/1L+KgMQLpQPAuGCZzwDsfjsAlpfb2zQKZIxeBafkwTn92OAnpQYn1PMPIaLQPUBw8nxm9EKF+Xp6ejZOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242408; c=relaxed/simple;
	bh=YMWpCMl+AIpwqEPlHAIvt12kPvItzQgcwNKb/CTy/5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkqCpOlEizvMIpBnCL9tyEOzE7vxsIcn7x/Z9WVNggfuQWs1Jc0ZHKWsgyIRB8Nujy6LV6nvVejjxda/RNWuR0G89CINIP1UUyjDPVynKuAGvmDeTKqS/v1eIy1OZzvxWL3Q3lWASXVzkt6h63PT/jBSqPSkIj9dYqW7+uHyi/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PYo3keyw; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242408; x=1770778408;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YMWpCMl+AIpwqEPlHAIvt12kPvItzQgcwNKb/CTy/5I=;
  b=PYo3keywFZuHhtyfJjaOAbRxhhZLvvS+ej9vwCj4gN3r/1Pur2GfJDxu
   8B31hETTN5YfshOraIzHmxAfN7fff7nOhNK7PmxR7n4FwUd+dEzERzCpy
   yT+VNnKFGnZpL9Xu8bOfMUYl00AEM32f+xSOhHzgo6i88sxxOYl60eNMq
   j42rpPu/NzE9AmdYkKTz1vNgcMEcj+QATO09Pxau4Igl4ZtS/dEEDthNP
   ou194tgKXP/AqDTzOkQlrEK3RotA6wIB8Hif8Ntf1vVzemgrkXFUTLUeB
   ULxqtewngai1yKBpRjJH+20i0p0QTBWsLM8G5aA4OzDwnXCMjlu8eVDal
   Q==;
X-CSE-ConnectionGUID: 7xrK4v4KQFykzmtR29uI/w==
X-CSE-MsgGUID: X9WEOIB0SN6w/MpnO7dwJg==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43506625"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43506625"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:53:28 -0800
X-CSE-ConnectionGUID: pKk/uTvFQQmRDSQX+ZEBuw==
X-CSE-MsgGUID: tVbpFlurSnmVyd1gc+sG6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112236456"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:53:23 -0800
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
Subject: [PATCH v2 6/8] KVM: TDX: Handle TDG.VP.VMCALL<ReportFatalError>
Date: Tue, 11 Feb 2025 10:54:40 +0800
Message-ID: <20250211025442.3071607-7-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert TDG.VP.VMCALL<ReportFatalError> to KVM_EXIT_SYSTEM_EVENT with
a new type KVM_SYSTEM_EVENT_TDX_FATAL and forward it to userspace for
handling.

TD guest can use TDG.VP.VMCALL<ReportFatalError> to report the fatal
error it has experienced.  This hypercall is special because TD guest
is requesting a termination with the error information, KVM needs to
forward the hypercall to userspace anyway, KVM doesn't do sanity checks
and let userspace decide what to do.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
Hypercalls exit to userspace v2:
- Use vp_enter_args instead of x86 registers.
- vcpu->run->system_event.ndata is not hardcoded to 10. (Xiaoyao)
- Undefine COPY_REG after use. (Yilun)
- Updated the document about KVM_SYSTEM_EVENT_TDX_FATAL. (Chao)

Hypercalls exit to userspace v1:
- New added.
  Implement one of the hypercalls need to exit to userspace for handling after
  reverting "KVM: TDX: Add KVM Exit for TDX TDG.VP.VMCALL", which tries to resolve
  Sean's comment.
  https://lore.kernel.org/kvm/Zg18ul8Q4PGQMWam@google.com/
- Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)
---
 Documentation/virt/kvm/api.rst |  9 +++++++
 arch/x86/kvm/vmx/tdx.c         | 45 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       |  1 +
 3 files changed, 55 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2ba70c1fad51..5e415b312ab0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6823,6 +6823,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
   #define KVM_SYSTEM_EVENT_WAKEUP         4
   #define KVM_SYSTEM_EVENT_SUSPEND        5
   #define KVM_SYSTEM_EVENT_SEV_TERM       6
+  #define KVM_SYSTEM_EVENT_TDX_FATAL      7
 			__u32 type;
                         __u32 ndata;
                         __u64 data[16];
@@ -6849,6 +6850,14 @@ Valid values for 'type' are:
    reset/shutdown of the VM.
  - KVM_SYSTEM_EVENT_SEV_TERM -- an AMD SEV guest requested termination.
    The guest physical address of the guest's GHCB is stored in `data[0]`.
+ - KVM_SYSTEM_EVENT_TDX_FATAL -- a TDX guest reported a fatal error state.
+   The error code reported by the TDX guest is stored in `data[0]`, the error
+   code format is defined in TDX GHCI specification.
+   If the bit 63 of `data[0]` is set, it indicates there is TD specified
+   additional information provided in a page, which is shared memory. The
+   guest physical address of the information page is stored in `data[1]`.
+   An optional error message is provided by `data[2]` ~ `data[9]`, which is
+   byte sequence, LSB filled first. Typically, ASCII code(0x20-0x7e) is filled.
  - KVM_SYSTEM_EVENT_WAKEUP -- the exiting vCPU is in a suspended state and
    KVM has recognized a wakeup event. Userspace may honor this event by
    marking the exiting vCPU as runnable, or deny it and call KVM_RUN again.
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8b51b4c937e9..85956768c515 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1092,11 +1092,56 @@ static int tdx_map_gpa(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	u64 reg_mask = tdx->vp_enter_args.rcx;
+	u64 *opt_regs;
+
+	/*
+	 * Skip sanity checks and let userspace decide what to do if sanity
+	 * checks fail.
+	 */
+	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_TDX_FATAL;
+	/* Error codes. */
+	vcpu->run->system_event.data[0] = tdx->vp_enter_args.r12;
+	/* GPA of additional information page. */
+	vcpu->run->system_event.data[1] = tdx->vp_enter_args.r13;
+	/* Information passed via registers (up to 64 bytes). */
+	opt_regs = &vcpu->run->system_event.data[2];
+
+#define COPY_REG(REG, MASK)						\
+	do {								\
+		if (reg_mask & MASK) {					\
+			*opt_regs = tdx->vp_enter_args.REG;		\
+			opt_regs++;					\
+		}							\
+	} while (0)
+
+	/* The order is defined in GHCI. */
+	COPY_REG(r14, BIT_ULL(14));
+	COPY_REG(r15, BIT_ULL(15));
+	COPY_REG(rbx, BIT_ULL(3));
+	COPY_REG(rdi, BIT_ULL(7));
+	COPY_REG(rsi, BIT_ULL(6));
+	COPY_REG(r8, BIT_ULL(8));
+	COPY_REG(r9, BIT_ULL(9));
+	COPY_REG(rdx, BIT_ULL(2));
+#undef COPY_REG
+
+	vcpu->run->system_event.ndata = opt_regs - vcpu->run->system_event.data;
+
+	return 0;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	switch (tdvmcall_leaf(vcpu)) {
 	case TDVMCALL_MAP_GPA:
 		return tdx_map_gpa(vcpu);
+	case TDVMCALL_REPORT_FATAL_ERROR:
+		return tdx_report_fatal_error(vcpu);
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 45e6d8fca9b9..937400350317 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -375,6 +375,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_WAKEUP         4
 #define KVM_SYSTEM_EVENT_SUSPEND        5
 #define KVM_SYSTEM_EVENT_SEV_TERM       6
+#define KVM_SYSTEM_EVENT_TDX_FATAL      7
 			__u32 type;
 			__u32 ndata;
 			union {
-- 
2.46.0


