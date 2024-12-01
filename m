Return-Path: <kvm+bounces-32794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AE179DF497
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 04:53:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E25D2B21FD4
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 03:53:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8F564206E;
	Sun,  1 Dec 2024 03:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cwA0Q6/A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121054087C;
	Sun,  1 Dec 2024 03:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733025134; cv=none; b=NVU008PK7JQs8ncjRlpSZd+a7eK4sU1zxw9sgmMCxIVAQuYOqzNmmiNQwmFhelpt6Jgn6Sa1uHeXiHizUyF7FWfx9GDhsZoFC973ZaoCH0uwuRtAiSsIaV9hf0garyI0PCCHpd4AxU7g1uPqd4OuVVfaJfkEH9Qh6I/6DJ9q8BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733025134; c=relaxed/simple;
	bh=Gf6BH1HUK/lEL6B847jZ14V/yl231PpyymHcfCxR5Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhSx8HGUkQmnOfwa0thKyCcjUvn0hOWldpagM6cojT0CVA9z+VohP9w9jVU9wL/bOxTSii/VpLOMUsUad6V6yXLe29hfmOWhzxd/jXXwtSBZPu+KZkgCFQZtKAdeULLYqqMwEb+kPw3z/j3zjeuYTnFoG04rvePof/SvgxwxhcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cwA0Q6/A; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733025132; x=1764561132;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gf6BH1HUK/lEL6B847jZ14V/yl231PpyymHcfCxR5Uw=;
  b=cwA0Q6/AXJ0jYlcU7O1bjrTveoniO19SExngIWWX3g+hxexZuz7E2rWs
   E8ju56WeNHQypR7u7NN4DLHybb2Hq9w5aio9090tTwAe1BQtbAUrtHpeA
   IsWNhUoyUkOwYVxLekaOToPw7ZhfpuWQliiN8fUFPtDVcjR34R8ruVOZw
   NTh2KZ4+GUTeKHTDHUUKhfSvhERer8QQu0dgOCM0n+mdVn7FU4/J4SsZg
   hKfotDL3ogvXFsEwTKtsTstswnzQ4mdvUxtTFzyoiREv5lgJbIgvYXmj9
   cbcCqyII1FZ7QNLCehaF8nEUez7ytKl1b+MwVNLpvVsH9zsT24UDL2Ye6
   A==;
X-CSE-ConnectionGUID: jkaxPWb4TQ+8t039JAui5g==
X-CSE-MsgGUID: moxZhxNWRDuPeL969DO1bg==
X-IronPort-AV: E=McAfee;i="6700,10204,11272"; a="50725109"
X-IronPort-AV: E=Sophos;i="6.12,199,1728975600"; 
   d="scan'208";a="50725109"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2024 19:52:12 -0800
X-CSE-ConnectionGUID: rFv0I07ESQCItJsNNOSguA==
X-CSE-MsgGUID: tShM6OwGQwCmeWq4tIT46A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,199,1728975600"; 
   d="scan'208";a="93257494"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2024 19:52:08 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	michael.roth@amd.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 4/7] KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
Date: Sun,  1 Dec 2024 11:53:53 +0800
Message-ID: <20241201035358.2193078-5-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
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
Hypercalls exit to userspace breakout:
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
 arch/x86/kvm/vmx/tdx.c            | 110 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h            |   3 +
 3 files changed, 114 insertions(+)

diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index 620327f0161f..a602d081cf1c 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -32,6 +32,7 @@
 #define TDVMCALL_STATUS_SUCCESS		0x0000000000000000ULL
 #define TDVMCALL_STATUS_RETRY		0x0000000000000001ULL
 #define TDVMCALL_STATUS_INVALID_OPERAND	0x8000000000000000ULL
+#define TDVMCALL_STATUS_ALIGN_ERROR	0x8000000000000002ULL
 
 /*
  * Bitmasks of exposed registers (with VMM).
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4cc55b120ab0..553f4cbe0693 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -985,12 +985,122 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
 	return r > 0;
 }
 
+/*
+ * Split into chunks and check interrupt pending between chunks.  This allows
+ * for timely injection of interrupts to prevent issues with guest lockup
+ * detection.
+ */
+#define TDX_MAP_GPA_MAX_LEN (2 * 1024 * 1024)
+static void __tdx_map_gpa(struct vcpu_tdx * tdx);
+
+static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx * tdx = to_tdx(vcpu);
+
+	if(vcpu->run->hypercall.ret) {
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+		kvm_r11_write(vcpu, tdx->map_gpa_next);
+		return 1;
+	}
+
+	tdx->map_gpa_next += TDX_MAP_GPA_MAX_LEN;
+	if (tdx->map_gpa_next >= tdx->map_gpa_end) {
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
+		return 1;
+	}
+
+	/*
+	 * Stop processing the remaining part if there is pending interrupt.
+	 * Skip checking pending virtual interrupt (reflected by
+	 * TDX_VCPU_STATE_DETAILS_INTR_PENDING bit) to save a seamcall because
+	 * if guest disabled interrupt, it's OK not returning back to guest
+	 * due to non-NMI interrupt. Also it's rare to TDVMCALL_MAP_GPA
+	 * immediately after STI or MOV/POP SS.
+	 */
+	if (pi_has_pending_interrupt(vcpu) ||
+	    kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending) {
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
+		kvm_r11_write(vcpu, tdx->map_gpa_next);
+		return 1;
+	}
+
+	__tdx_map_gpa(tdx);
+	/* Forward request to userspace. */
+	return 0;
+}
+
+static void __tdx_map_gpa(struct vcpu_tdx * tdx)
+{
+	u64 gpa = tdx->map_gpa_next;
+	u64 size = tdx->map_gpa_end - tdx->map_gpa_next;
+
+	if(size > TDX_MAP_GPA_MAX_LEN)
+		size = TDX_MAP_GPA_MAX_LEN;
+
+	tdx->vcpu.run->exit_reason       = KVM_EXIT_HYPERCALL;
+	tdx->vcpu.run->hypercall.nr      = KVM_HC_MAP_GPA_RANGE;
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
+	struct vcpu_tdx * tdx = to_tdx(vcpu);
+	u64 gpa = tdvmcall_a0_read(vcpu);
+	u64 size = tdvmcall_a1_read(vcpu);
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
+	    !kvm_vcpu_is_legal_gpa(vcpu, gpa + size -1) ||
+	    (vt_is_tdx_private_gpa(vcpu->kvm, gpa) !=
+	     vt_is_tdx_private_gpa(vcpu->kvm, gpa + size -1))) {
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
+	/* Forward request to userspace. */
+	return 0;
+
+error:
+	tdvmcall_set_return_code(vcpu, ret);
+	kvm_r11_write(vcpu, gpa);
+	return 1;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	if (tdvmcall_exit_type(vcpu))
 		return tdx_emulate_vmcall(vcpu);
 
 	switch (tdvmcall_leaf(vcpu)) {
+	case TDVMCALL_MAP_GPA:
+		return tdx_map_gpa(vcpu);
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 1abc94b046a0..bfae70887695 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -71,6 +71,9 @@ struct vcpu_tdx {
 
 	enum tdx_prepare_switch_state prep_switch_state;
 	u64 msr_host_kernel_gs_base;
+
+	u64 map_gpa_next;
+	u64 map_gpa_end;
 };
 
 void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err);
-- 
2.46.0


