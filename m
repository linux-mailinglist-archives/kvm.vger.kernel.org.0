Return-Path: <kvm+bounces-37803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4684A301F0
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 04:01:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA2653ACC03
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94CC11EE7A8;
	Tue, 11 Feb 2025 02:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NOAeLJLI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DCB1EE017;
	Tue, 11 Feb 2025 02:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242666; cv=none; b=lmEk3FEmd7zgJcqh2Wh8KMnsi3eGY+rNXNERKoii3IzeZQ+vw64NlVwGkus3ywWtlmp4UhBn0OT/GF2JqvI8gPN5K+FehxT3XOP9LpnIgRKwRg6jwEWMyC3CvUsamiI6FdkP+ZYEJm0Ul0jhCRs3nvcloYYGpqYOcMu13DsdX7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242666; c=relaxed/simple;
	bh=LYDGjCJQjtOTWKT79byJpQN6NCyZ3G02nkjkS1/wc68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSGJsRVsA0VOEXiVwEfyGq5epzXeSDM0QrfvJa5z3shWj1vhLRsbNirM9NCKfwE1R9LZKOl6XrTKq0zG80ndwA6h2tW9TQztxR75kgOZ24FLg/YUj9ShWB0OC9KvevyNedEHzMj3/OTH+N38Nhd9id/NnvTo8kmf/qNhipsbs50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NOAeLJLI; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242666; x=1770778666;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LYDGjCJQjtOTWKT79byJpQN6NCyZ3G02nkjkS1/wc68=;
  b=NOAeLJLI4oiqEn2tAYGwj12SR+vRUmZFPfoPjEjlvLTata3aRgmuZ3Za
   glpG7ApMedaGkGHzZR9vfJ6+5DwBvL3B6M0zRMG9ocYIo5qO0ZWUf8IHX
   OGOsliFWiU4hBumVDRzQcSy1C8CvyIPeSCIZSxigH6zwey+QNiZ44IqGN
   /ApOyhIW4co7yB2XdnyaB06/dQevmon/MucqyIGMy3Zi+kdfekHgTuY5g
   RtGjloUmM9M8t88L+dCKHsnIybQ48BtJdg5Min73LRwWLAVajWwLIUE3/
   todTZ7InrP6pvzkw2spnkiHhqITbCIaBd08aqRb6ZgxcLxHlze5ylnbJo
   Q==;
X-CSE-ConnectionGUID: LjNLSB5fSrimH02ZyR6P7Q==
X-CSE-MsgGUID: Hh7NaCZcRT6yCr3cDp6QWA==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43612498"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43612498"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:45 -0800
X-CSE-ConnectionGUID: AMwLED53SrCwtV0TANlt8g==
X-CSE-MsgGUID: GwrJV7xfSw+BIOUzpfAyVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112355386"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:41 -0800
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
Subject: [PATCH v2 16/17] KVM: TDX: Handle EXCEPTION_NMI and EXTERNAL_INTERRUPT
Date: Tue, 11 Feb 2025 10:58:27 +0800
Message-ID: <20250211025828.3072076-17-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Handle EXCEPTION_NMI and EXTERNAL_INTERRUPT exits for TDX.

NMI Handling: Just like the VMX case, NMI remains blocked after exiting
from TDX guest for NMI-induced exits [*].  Handle NMI-induced exits for
TDX guests in the same way as they are handled for VMX guests, i.e.,
handle NMI in tdx_vcpu_enter_exit() by calling the vmx_handle_nmi()
helper.

Interrupt and Exception Handling: Similar to the VMX case, external
interrupts and exceptions (machine check is the only exception type
KVM handles for TDX guests) are handled in the .handle_exit_irqoff()
callback.

For other exceptions, because TDX guest state is protected, exceptions in
TDX guests can't be intercepted.  TDX VMM isn't supposed to handle these
exceptions.  If unexpected exception occurs, exit to userspace with
KVM_EXIT_EXCEPTION.

For external interrupt, increase the statistics, same as the VMX case.

[*]: Some old TDX modules have a bug which makes NMI unblocked after
exiting from TDX guest for NMI-induced exits.  This could potentially
lead to nested NMIs: a new NMI arrives when KVM is manually calling the
host NMI handler.  This is an architectural violation, but it doesn't
have real harm until FRED is enabled together with TDX (for non-FRED,
the host NMI handler can handle nested NMIs).  Given this is rare to
happen and has no real harm, ignore this for the initial TDX support.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TDX interrupts v2:
- Drop tdx_handle_exit_irqoff(), make vmx_handle_exit_irqoff()  the common
  handle_exit_irqoff() callback for both VMX/TDX.
- Open code tdx_handle_external_interrupt(). (Sean)
- Use helper vmx_handle_nmi() to handle NMI for TDX.
- Update the changelog to reflect the latest TDX NMI arch update.

TDX interrupts v1:
- Renamed from "KVM: TDX: handle EXCEPTION_NMI and EXTERNAL_INTERRUPT"
  to "KVM: TDX: Handle EXCEPTION_NMI and EXTERNAL_INTERRUPT".
- Update changelog.
- Rename tdx_handle_exception() to tdx_handle_exception_nmi() to reflect
  that NMI is also checked. (Binbin)
- Add comments in tdx_handle_exception_nmi() about why NMI and machine
  checks are ignored. (Chao)
- Exit to userspace with KVM_EXIT_EXCEPTION when unexpected exception
  occurs instead of returning -EFAULT. (Chao, Isaku)
- Switch to vp_enter_ret.
- Move the handling of NMI, exception and external interrupt from
  "KVM: TDX: Add a place holder to handle TDX VM exit" to this patch.
- Use helper __vmx_handle_nmi() to handle NMI, which including the
  support for FRED.
---
 arch/x86/kvm/vmx/tdx.c | 29 +++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c |  4 +---
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4a29b3998cde..2fa7ba465d10 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -911,6 +911,8 @@ static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	tdx->exit_gpa = tdx->vp_enter_args.r8;
 	vt->exit_intr_info = tdx->vp_enter_args.r9;
 
+	vmx_handle_nmi(vcpu);
+
 	guest_state_exit_irqoff();
 }
 
@@ -1026,6 +1028,28 @@ void tdx_inject_nmi(struct kvm_vcpu *vcpu)
 	vcpu->arch.nmi_pending = 0;
 }
 
+static int tdx_handle_exception_nmi(struct kvm_vcpu *vcpu)
+{
+	u32 intr_info = vmx_get_intr_info(vcpu);
+
+	/*
+	 * Machine checks are handled by handle_exception_irqoff(), or by
+	 * tdx_handle_exit() with TDX_NON_RECOVERABLE set if a #MC occurs on
+	 * VM-Entry.  NMIs are handled by tdx_vcpu_enter_exit().
+	 */
+	if (is_nmi(intr_info) || is_machine_check(intr_info))
+		return 1;
+
+	kvm_pr_unimpl("unexpected exception 0x%x(exit_reason 0x%x qual 0x%lx)\n",
+		intr_info, vmx_get_exit_reason(vcpu).full, vmx_get_exit_qual(vcpu));
+
+	vcpu->run->exit_reason = KVM_EXIT_EXCEPTION;
+	vcpu->run->ex.exception = intr_info & INTR_INFO_VECTOR_MASK;
+	vcpu->run->ex.error_code = 0;
+
+	return 0;
+}
+
 static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
 {
 	tdvmcall_set_return_code(vcpu, vcpu->run->hypercall.ret);
@@ -1713,6 +1737,11 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
 		vcpu->mmio_needed = 0;
 		return 0;
+	case EXIT_REASON_EXCEPTION_NMI:
+		return tdx_handle_exception_nmi(vcpu);
+	case EXIT_REASON_EXTERNAL_INTERRUPT:
+		++vcpu->stat.irq_exits;
+		return 1;
 	case EXIT_REASON_TDCALL:
 		return handle_tdvmcall(vcpu);
 	case EXIT_REASON_VMCALL:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 228a7e51b6a5..caf4b2da8b67 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6959,9 +6959,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
 
 void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
-	if (vmx->vt.emulation_required)
+	if (to_vt(vcpu)->emulation_required)
 		return;
 
 	if (vmx_get_exit_reason(vcpu).basic == EXIT_REASON_EXTERNAL_INTERRUPT)
-- 
2.46.0


