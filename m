Return-Path: <kvm+bounces-38932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E7D4A404CA
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:43:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E823E16780F
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1DAC203719;
	Sat, 22 Feb 2025 01:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UHd3C8gG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF272036F0;
	Sat, 22 Feb 2025 01:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188476; cv=none; b=L0hYB8tXjSN8PIBTXSx/lKAWPO3JCtbR7wZFMvPJ5eE6xLv/DHUs3+iP7tdVYY/HjksJKTRzlhLm59iLB1kNf2bDge6ej+MULIJTpUjm3bo5YaozBPf29eZqZ6cVPwqPUUo5VqvVNh0+zL1e44sCoO9v2FxkAt+6j5GA8mdWy7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188476; c=relaxed/simple;
	bh=sJSadycwUGmpWEJ2a38Clddht63dvw6WzhYR8Ge6ZQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7L6N3SmTQh5+ftqvP7FWViRq3RA6Sk1YOU9qUtLDV0yghXqfKDZwymQ49+eK3hRn/WrAD5dCk5QDvHKNZEnanDgNU+ZPUNW8Ir9Rvf025ooF+VenswLeJRRSNLGyl/MZP5yTNnwLe4ZDZqcwKGS1M6UEgM+cisstFKkAQjS4KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UHd3C8gG; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188474; x=1771724474;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sJSadycwUGmpWEJ2a38Clddht63dvw6WzhYR8Ge6ZQY=;
  b=UHd3C8gGVjZwJonYqKSeOPcTyEbd/Ms145ySLaeM3KNc6yZw21Uyiej4
   xr3Oj5FCBM6AJTicsRYyc+0MGl/E+t7GWdVyFaOHH67xKhWOpuTwdDzUu
   pR4Ud+hZIzS3I3SEExxJvPEiiBXR7oWzR5zQDMEwW8HqGWX+QOpxXZni3
   eCSorn44AXmrNkIChSWWhLOziFCrGpBLIykRWmqPJekNXEjKxh0Kb3KaE
   LiEc9sMlPCJfIAgHlpplMP+YSuoQR8yHq8vfkdlzfJ2gcl6qgMacQYc/0
   CQ0tbpVLceWTzIARAdmWuEuSSq6SJxrbHSypKb25rucwHTiDQ5LdQsIxI
   g==;
X-CSE-ConnectionGUID: ipDtoUIFT8+eU8XAF1TMxg==
X-CSE-MsgGUID: yicOxNnwT06+Irn0UjpkUQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11352"; a="40893292"
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="40893292"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:41:14 -0800
X-CSE-ConnectionGUID: lw6sw9LSSbuid4ifAK1WrQ==
X-CSE-MsgGUID: VDkaFwo1SVqV/ZniQ9uAgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="146370264"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:41:11 -0800
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
Subject: [PATCH v3 6/9] KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
Date: Sat, 22 Feb 2025 09:42:22 +0800
Message-ID: <20250222014225.897298-7-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250222014225.897298-1-binbin.wu@linux.intel.com>
References: <20250222014225.897298-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert TDG.VP.VMCALL<MapGPA> to KVM_EXIT_HYPERCALL with
KVM_HC_MAP_GPA_RANGE and forward it to userspace for handling.

MapGPA is used by TDX guest to request to map a GPA range as private
or shared memory.  It needs to exit to userspace for handling.  KVM has
already implemented a similar hypercall KVM_HC_MAP_GPA_RANGE, which will
exit to userspace with exit reason KVM_EXIT_HYPERCALL.  Do sanity checks,
convert TDVMCALL_MAP_GPA to KVM_HC_MAP_GPA_RANGE and forward the request
to userspace.

To prevent a TDG.VP.VMCALL<MapGPA> call from taking too long, the MapGPA
range is split into 2MB chunks and check interrupt pending between chunks.
This allows for timely injection of interrupts and prevents issues with
guest lockup detection.  TDX guest should retry the operation for the
GPA starting at the address specified in R11 when the TDVMCALL return
TDVMCALL_RETRY as status code.

Note userspace needs to enable KVM_CAP_EXIT_HYPERCALL with
KVM_HC_MAP_GPA_RANGE bit set for TD VM.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
Hypercalls exit to userspace v3:
- Use kvm_vcpu_has_events() to replace the open code of NMI/interrupt
  checks. (Sean)
  The check of pending RVI, i.e., bit 0 of
  TDX_VCPU_STATE_DETAILS_INTR_PENDING is skipped for non halted cases
  in tdx_protected_apic_has_interrupt() in later section.

Hypercalls exit to userspace v2:
- Skip setting of return code as TDVMCALL_STATUS_SUCCESS.
- Use vp_enter_args instead of x86 registers.
- Remove unnecessary comments.
- Zero run->hypercall.ret in __tdx_map_gpa() following the pattern of Paolo's
  patch, the feedback of adding a helper is still pending. (Rick)
  https://lore.kernel.org/kvm/20241213194137.315304-1-pbonzini@redhat.com

Hypercalls exit to userspace v1:
- New added.
  Implement one of the hypercalls need to exit to userspace for handling after
  dropping "KVM: TDX: Add KVM Exit for TDX TDG.VP.VMCALL", which tries to resolve
  Sean's comment.
  https://lore.kernel.org/kvm/Zg18ul8Q4PGQMWam@google.com/
- Check interrupt pending between chunks suggested by Sean.
  https://lore.kernel.org/kvm/ZleJvmCawKqmpFIa@google.com/
- Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)
- Use vt_is_tdx_private_gpa()
---
 arch/x86/include/asm/shared/tdx.h |   1 +
 arch/x86/kvm/vmx/tdx.c            | 111 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h            |   3 +
 3 files changed, 115 insertions(+)

diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index 4aedab1f2a1a..f23657350d28 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -77,6 +77,7 @@
 #define TDVMCALL_STATUS_SUCCESS		0x0000000000000000ULL
 #define TDVMCALL_STATUS_RETRY		0x0000000000000001ULL
 #define TDVMCALL_STATUS_INVALID_OPERAND	0x8000000000000000ULL
+#define TDVMCALL_STATUS_ALIGN_ERROR	0x8000000000000002ULL
 
 /*
  * Bitmasks of exposed registers (with VMM).
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4f659ca50469..7b2f4c32f01b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -984,9 +984,120 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
 	return __kvm_emulate_hypercall(vcpu, 0, complete_hypercall_exit);
 }
 
+/*
+ * Split into chunks and check interrupt pending between chunks.  This allows
+ * for timely injection of interrupts to prevent issues with guest lockup
+ * detection.
+ */
+#define TDX_MAP_GPA_MAX_LEN (2 * 1024 * 1024)
+static void __tdx_map_gpa(struct vcpu_tdx *tdx);
+
+static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	if (vcpu->run->hypercall.ret) {
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+		tdx->vp_enter_args.r11 = tdx->map_gpa_next;
+		return 1;
+	}
+
+	tdx->map_gpa_next += TDX_MAP_GPA_MAX_LEN;
+	if (tdx->map_gpa_next >= tdx->map_gpa_end)
+		return 1;
+
+	/*
+	 * Stop processing the remaining part if there is a pending interrupt,
+	 * which could be qualified to deliver.  Skip checking pending RVI for
+	 * TDVMCALL_MAP_GPA.
+	 * TODO: Add a comment to link the reason when the target function is
+	 * implemented.
+	 */
+	if (kvm_vcpu_has_events(vcpu)) {
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
+		tdx->vp_enter_args.r11 = tdx->map_gpa_next;
+		return 1;
+	}
+
+	__tdx_map_gpa(tdx);
+	return 0;
+}
+
+static void __tdx_map_gpa(struct vcpu_tdx *tdx)
+{
+	u64 gpa = tdx->map_gpa_next;
+	u64 size = tdx->map_gpa_end - tdx->map_gpa_next;
+
+	if (size > TDX_MAP_GPA_MAX_LEN)
+		size = TDX_MAP_GPA_MAX_LEN;
+
+	tdx->vcpu.run->exit_reason       = KVM_EXIT_HYPERCALL;
+	tdx->vcpu.run->hypercall.nr      = KVM_HC_MAP_GPA_RANGE;
+	/*
+	 * In principle this should have been -KVM_ENOSYS, but userspace (QEMU <=9.2)
+	 * assumed that vcpu->run->hypercall.ret is never changed by KVM and thus that
+	 * it was always zero on KVM_EXIT_HYPERCALL.  Since KVM is now overwriting
+	 * vcpu->run->hypercall.ret, ensuring that it is zero to not break QEMU.
+	 */
+	tdx->vcpu.run->hypercall.ret = 0;
+	tdx->vcpu.run->hypercall.args[0] = gpa & ~gfn_to_gpa(kvm_gfn_direct_bits(tdx->vcpu.kvm));
+	tdx->vcpu.run->hypercall.args[1] = size / PAGE_SIZE;
+	tdx->vcpu.run->hypercall.args[2] = vt_is_tdx_private_gpa(tdx->vcpu.kvm, gpa) ?
+					   KVM_MAP_GPA_RANGE_ENCRYPTED :
+					   KVM_MAP_GPA_RANGE_DECRYPTED;
+	tdx->vcpu.run->hypercall.flags   = KVM_EXIT_HYPERCALL_LONG_MODE;
+
+	tdx->vcpu.arch.complete_userspace_io = tdx_complete_vmcall_map_gpa;
+}
+
+static int tdx_map_gpa(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	u64 gpa = tdx->vp_enter_args.r12;
+	u64 size = tdx->vp_enter_args.r13;
+	u64 ret;
+
+	/*
+	 * Converting TDVMCALL_MAP_GPA to KVM_HC_MAP_GPA_RANGE requires
+	 * userspace to enable KVM_CAP_EXIT_HYPERCALL with KVM_HC_MAP_GPA_RANGE
+	 * bit set.  If not, the error code is not defined in GHCI for TDX, use
+	 * TDVMCALL_STATUS_INVALID_OPERAND for this case.
+	 */
+	if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
+		ret = TDVMCALL_STATUS_INVALID_OPERAND;
+		goto error;
+	}
+
+	if (gpa + size <= gpa || !kvm_vcpu_is_legal_gpa(vcpu, gpa) ||
+	    !kvm_vcpu_is_legal_gpa(vcpu, gpa + size - 1) ||
+	    (vt_is_tdx_private_gpa(vcpu->kvm, gpa) !=
+	     vt_is_tdx_private_gpa(vcpu->kvm, gpa + size - 1))) {
+		ret = TDVMCALL_STATUS_INVALID_OPERAND;
+		goto error;
+	}
+
+	if (!PAGE_ALIGNED(gpa) || !PAGE_ALIGNED(size)) {
+		ret = TDVMCALL_STATUS_ALIGN_ERROR;
+		goto error;
+	}
+
+	tdx->map_gpa_end = gpa + size;
+	tdx->map_gpa_next = gpa;
+
+	__tdx_map_gpa(tdx);
+	return 0;
+
+error:
+	tdvmcall_set_return_code(vcpu, ret);
+	tdx->vp_enter_args.r11 = gpa;
+	return 1;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	switch (tdvmcall_leaf(vcpu)) {
+	case TDVMCALL_MAP_GPA:
+		return tdx_map_gpa(vcpu);
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 3b1cfa737b70..70da4e6a93e8 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -58,6 +58,9 @@ struct vcpu_tdx {
 	u64 vp_enter_ret;
 
 	enum vcpu_tdx_state state;
+
+	u64 map_gpa_next;
+	u64 map_gpa_end;
 };
 
 void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err);
-- 
2.46.0


