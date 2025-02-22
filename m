Return-Path: <kvm+bounces-38934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 34A13A404CD
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:43:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 816511895AF2
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:43:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4410A204C22;
	Sat, 22 Feb 2025 01:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MGNTf/UP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE16B2045B1;
	Sat, 22 Feb 2025 01:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188483; cv=none; b=tl+6NSrnI+ubeqhztZETeJaEdpxQo0GVugrpaJM+fpopK7YlbbI4aHMPM2iJe1MXiOxIgIG+HamY+1AscnzU5Smehjks+YdoQkkkdxH1jgmTJqmv+nVBKOfjnbpN4L59YIpn36SHrBzoMDVwQdYiXiv2lhqmmoL7jg5hIL0Px70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188483; c=relaxed/simple;
	bh=3AGn768TJORBzQ6jY1KUaQ4pguOi9rpUjt4CBaaIank=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6iAg6ML6kFqPbfveAO52cwHrF+Bo5rIJ9FJcU1l/5zRT6KvIflUfc9LSQ5zucasod6KDNVAcoznougX69jxQ01Q779sGcCJVarCpEsVdr8TTU8d7H3XegMtSVfoTvoYLgClyLvIQPwlU/khDVq0xouOePsDJW71Dw0lTl3XSvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MGNTf/UP; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188482; x=1771724482;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3AGn768TJORBzQ6jY1KUaQ4pguOi9rpUjt4CBaaIank=;
  b=MGNTf/UPwt64wxos6xKgQETlBrRIgHRuHSorW8RYlYNDfu/qmkpXs7g9
   g9/NdIMo6eJsN3HyeaeESZP91xxYuNnwmOzpVo0+GTL1iPqo3bV+AWPi9
   nRHVpqo3csSENo1t92YGUVPG5TjM20jKBAk2UvZSpjYFpKO5lJeUMdJmZ
   6Dn+i0n1pt0PVUi6c6V0/0yViEHrBlWQdihrXKf3ebpPNT2p71Lek6hIV
   PO1Lcg6XPGwblAsDnw1tb/Fl+Ymwjklvnzi2InEplbZqdTcdv2kkOq0yO
   R9YWpDgfn21Dqqf8B9nVRrItr2wEe0R+K1atwWrzQBhdC7ub+16+5ClRu
   w==;
X-CSE-ConnectionGUID: MQfPE/MYRQCOJSV0wSQMgg==
X-CSE-MsgGUID: 4GmnKcxRQLC7rqEai3H4tg==
X-IronPort-AV: E=McAfee;i="6700,10204,11352"; a="40893307"
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="40893307"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:41:21 -0800
X-CSE-ConnectionGUID: fShLCHfAQkOrtnH3M5HvHA==
X-CSE-MsgGUID: E/YlF498SAKdKdGuosHT3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="146370273"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:41:18 -0800
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
Subject: [PATCH v3 8/9] KVM: TDX: Handle TDX PV port I/O hypercall
Date: Sat, 22 Feb 2025 09:42:24 +0800
Message-ID: <20250222014225.897298-9-binbin.wu@linux.intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Emulate port I/O requested by TDX guest via TDVMCALL with leaf
Instruction.IO (same value as EXIT_REASON_IO_INSTRUCTION) according to
TDX Guest Host Communication Interface (GHCI).

All port I/O instructions inside the TDX guest trigger the #VE exception.
On #VE triggered by I/O instructions, TDX guest can call TDVMCALL with
leaf Instruction.IO to request VMM to emulate I/O instructions.

Similar to normal port I/O emulation, try to handle the port I/O in kernel
first, if kernel can't support it, forward the request to userspace.

Note string I/O operations are not supported in TDX.  Guest should unroll
them before calling the TDVMCALL.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
Hypercalls exit to userspace v3:
- Rebased to use tdcall_to_vmx_exit_reason().

Hypercalls exit to userspace v2:
- Morph PV port I/O hypercall to EXIT_REASON_IO_INSTRUCTION. (Sean)
- Use vp_enter_args instead of x86 registers.
- Check write is either 0 or 1. (Chao)
- Skip setting return code as TDVMCALL_STATUS_SUCCESS. (Sean)

Hypercalls exit to userspace v1:
- Renamed from "KVM: TDX: Handle TDX PV port io hypercall" to
  "KVM: TDX: Handle TDX PV port I/O hypercall".
- Update changelog.
- Add missing curly brackets.
- Move reset of pio.count to tdx_complete_pio_out() and remove the stale
  comment. (binbin)
- Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)
- Set status code to TDVMCALL_STATUS_SUCCESS when PIO is handled in kernel.
- Don't write to R11 when it is a write operation for output.

v18:
- Fix out case to set R10 and R11 correctly when user space handled port
  out.
---
 arch/x86/kvm/vmx/tdx.c | 62 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 7c8356299a25..3a4437520868 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -824,6 +824,8 @@ static bool tdx_guest_state_is_invalid(struct kvm_vcpu *vcpu)
 static __always_inline u32 tdcall_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
 {
 	switch (tdvmcall_leaf(vcpu)) {
+	case EXIT_REASON_IO_INSTRUCTION:
+		return tdvmcall_leaf(vcpu);
 	default:
 		break;
 	}
@@ -1119,6 +1121,64 @@ static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int tdx_complete_pio_out(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.pio.count = 0;
+	return 1;
+}
+
+static int tdx_complete_pio_in(struct kvm_vcpu *vcpu)
+{
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+	unsigned long val = 0;
+	int ret;
+
+	ret = ctxt->ops->pio_in_emulated(ctxt, vcpu->arch.pio.size,
+					 vcpu->arch.pio.port, &val, 1);
+
+	WARN_ON_ONCE(!ret);
+
+	tdvmcall_set_return_val(vcpu, val);
+
+	return 1;
+}
+
+static int tdx_emulate_io(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+	unsigned long val = 0;
+	unsigned int port;
+	u64 size, write;
+	int ret;
+
+	++vcpu->stat.io_exits;
+
+	size = tdx->vp_enter_args.r12;
+	write = tdx->vp_enter_args.r13;
+	port = tdx->vp_enter_args.r14;
+
+	if ((write != 0 && write != 1) || (size != 1 && size != 2 && size != 4)) {
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+		return 1;
+	}
+
+	if (write) {
+		val = tdx->vp_enter_args.r15;
+		ret = ctxt->ops->pio_out_emulated(ctxt, size, port, &val, 1);
+	} else {
+		ret = ctxt->ops->pio_in_emulated(ctxt, size, port, &val, 1);
+	}
+
+	if (!ret)
+		vcpu->arch.complete_userspace_io = write ? tdx_complete_pio_out :
+							   tdx_complete_pio_in;
+	else if (!write)
+		tdvmcall_set_return_val(vcpu, val);
+
+	return ret;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	switch (tdvmcall_leaf(vcpu)) {
@@ -1496,6 +1556,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		return handle_tdvmcall(vcpu);
 	case EXIT_REASON_VMCALL:
 		return tdx_emulate_vmcall(vcpu);
+	case EXIT_REASON_IO_INSTRUCTION:
+		return tdx_emulate_io(vcpu);
 	default:
 		break;
 	}
-- 
2.46.0


