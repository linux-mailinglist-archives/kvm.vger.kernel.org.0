Return-Path: <kvm+bounces-38953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C11EA404FE
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:52:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00EC919E3762
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD86A207653;
	Sat, 22 Feb 2025 01:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g2cQMhCr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64773206F38;
	Sat, 22 Feb 2025 01:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188835; cv=none; b=LcT/mQRC01auRXGFb8KHyigH16IoGYti8C0Bysfr6BSvFlPfD5GZXeQgOOVU2K/qvDNvxmkxz+T6QY5RyhHHPQNpH4WunojuICaMcUEF/fUrEfQhOxRu9KN++pA2Wl5nJWKNpTU3uhNsCz9hYYs6RnyEPM1bNwjlgi9Sw1ma3u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188835; c=relaxed/simple;
	bh=EkBgGxrkvF0Lmifejs8w0hReg99N3w5FozZhXN+nFzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dECrcQDtlrwbKad8BRlbMvj/Mm1eeD17ev1JdW1CMfdsgm2+tiY+AcOSXYUq7dlpUTpsIohgkY56TOeMDzh5biWDfgydnM+MPhWhKqQO40LqNWJrlmHRZ4BUWOwRM5MCVLNm2FyhnCPddUnZGG+u+VBzZ8GYiaVo/4QmbO0SkJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g2cQMhCr; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188833; x=1771724833;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EkBgGxrkvF0Lmifejs8w0hReg99N3w5FozZhXN+nFzg=;
  b=g2cQMhCrYBdjCll1SPALuetvQ+Q4n99Da5SDOaOhgPd7ShxDzKsiEI2f
   5KRFJf0pA8/e3zOiZpWmyjsokKrzMcrqODHVbu5daCYAd/i6i2pw54ZXl
   6ivn/1WfmcbqpQSvqPp8oGEl0Bw32efZbdu71y8xlR07yCwP09dAA3DUg
   R62N5k1rVPPtkzhzDIzW6hkZbRP38sq8vk9CosW6Tf6JWwrXGfq6aArWv
   k3YY8NmuvoHnLL/aAbwJarUdMsH5XXJuqwnr+eoO5T6R6ztsDtctVYlgV
   dA/HEJ6GczSV3sp9zECzRFXfhUp9AogNUixvl838RluAaMYBBWBLkI74l
   A==;
X-CSE-ConnectionGUID: ktLasY+ZQZ2yXb1q0FBRoQ==
X-CSE-MsgGUID: xvVTVtD5SJutI/oHTAn/xw==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="52449076"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="52449076"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:47:13 -0800
X-CSE-ConnectionGUID: KAQr/NnMTmy3Rl0XmAD6QA==
X-CSE-MsgGUID: Mj4FDzpoRhOpPkP04D2tJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="120621742"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:47:09 -0800
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
Subject: [PATCH v3 15/16] KVM: TDX: Handle EXCEPTION_NMI and EXTERNAL_INTERRUPT
Date: Sat, 22 Feb 2025 09:47:56 +0800
Message-ID: <20250222014757.897978-16-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250222014757.897978-1-binbin.wu@linux.intel.com>
References: <20250222014757.897978-1-binbin.wu@linux.intel.com>
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
TDX interrupts v3:
- Drop kvm_pr_unimpl() usage in tdx_handle_exception_nmi() (Sean)

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
 arch/x86/kvm/vmx/tdx.c | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c |  4 +---
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 532c2557ca0d..2eed02dec17b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -898,6 +898,8 @@ static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	tdx->exit_gpa = tdx->vp_enter_args.r8;
 	vt->exit_intr_info = tdx->vp_enter_args.r9;
 
+	vmx_handle_nmi(vcpu);
+
 	guest_state_exit_irqoff();
 }
 
@@ -1017,6 +1019,25 @@ void tdx_inject_nmi(struct kvm_vcpu *vcpu)
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
@@ -1713,6 +1734,11 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
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
index 8152560f519a..3d95bc80099a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6965,9 +6965,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
 
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


