Return-Path: <kvm+bounces-33274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 661869E88E9
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 02:09:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18EE9284455
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 01:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A2B874068;
	Mon,  9 Dec 2024 01:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E5dnv8x1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32D9194A7C;
	Mon,  9 Dec 2024 01:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733706389; cv=none; b=FhuMPQR+K1jqTJy4UqKLtHr2uQ0u6A6keD1tjCVu/xrm2cK/MEQH7KvthseLl0cbyh8+/Hk/33cNtu6cyQTdJ+68jCy7nqSvq5vUT95Tuex2o1vCGQytS/NIX2L15r2WGwO05FKHvNiWyLk12WR3/V5Oq9Lp5MD36RJmMizvhKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733706389; c=relaxed/simple;
	bh=r3F/a12IpVC0WaI7fqZY+oFbT3p4DUvdz1fYnDi39JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBi0lOOaxwsS0g9tpvxqudkhhzN4mKCIG7/hK60UpPl4ED/2DDjT3TkfSsqhAbSb5Q5QaKfZdC2NcT44LhPPGgEY7APO6IXu9OT3qhZ/5n3Ix3RWVL5WBf1E2Yv0UirBFUPShxTP86ucrlnsrsoYBKXGqlM1XcHDwG0V984wXWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E5dnv8x1; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733706388; x=1765242388;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r3F/a12IpVC0WaI7fqZY+oFbT3p4DUvdz1fYnDi39JE=;
  b=E5dnv8x14eJEAyP5FsZ+SKDqXWg/N/iVuLUzlHuJHF10hZ7gk1okGyrm
   b/m3uPBc3wxPeLdEnH8DyoUlKNjkF4DE97XN4r3FOadSllfuBuNk7cDax
   21z4zmR8XQZfvk9Xi+vp0KlsXJLCZb6KHap0dBHV1TBVydE/Z/mo84/HS
   ubl6rAW8LYEOQyEFSyKMLJnC0w4KlEwkD5/ncVGc/s0Nb1SIeGWxVXv0c
   /PgeHKm+bj7Czozw4SM4YZfSScsHbBN9kqj+erplvudufXNtTGTT0tPIw
   4o3WRJD+V4cC0C0ossLFynu5jGB/HQYdDyVp4KMGEINVOhiKxufyKNfbT
   g==;
X-CSE-ConnectionGUID: vrVWpRdXQ8yCBQtDo6btkA==
X-CSE-MsgGUID: Lr/o+n+zTBqfy1KCssWr/Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11280"; a="36833753"
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="36833753"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:06:28 -0800
X-CSE-ConnectionGUID: I1yvEdz8R/KlndQenATCUQ==
X-CSE-MsgGUID: frm/QJlrTG6Ppd3/MNSt1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="95402574"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:06:24 -0800
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
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 15/16] KVM: TDX: Handle EXCEPTION_NMI and EXTERNAL_INTERRUPT
Date: Mon,  9 Dec 2024 09:07:29 +0800
Message-ID: <20241209010734.3543481-16-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Handle EXCEPTION_NMI and EXTERNAL_INTERRUPT exits for TDX.

NMI Handling: Based on current TDX module, NMI is unblocked after
SEAMRET from SEAM root mode to VMX root mode due to NMI VM-EXit, which
could lead to NMI handling order issue. Put the NMI VM-Exit handling
in noinstr section, it can't completely prevent the order issue from
happening, but it minimizes the window.

Interrupt and Exception Handling: Similar to the VMX case, external
interrupts and exceptions (machine check is the only exception type
KVM handles for TDX guests) are handled in the .handle_exit_irqoff()
callback.

For other exceptions, because TDX guest state is protected, exceptions in
TDX guests can't be intercepted.  TDX VMM isn't supposed to handle these
exceptions.  If unexpected exception occurs, exit to userspace with
KVM_EXIT_EXCEPTION.

For external interrupt, increase the statistics, same as the VMX case.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TDX interrupts breakout:
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
 arch/x86/kvm/vmx/main.c    | 12 +++++++++-
 arch/x86/kvm/vmx/tdx.c     | 46 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  2 ++
 3 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 6dcc9ebf6d6e..305425b19cb5 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -181,6 +181,16 @@ static int vt_handle_exit(struct kvm_vcpu *vcpu,
 	return vmx_handle_exit(vcpu, fastpath);
 }
 
+static void vt_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_handle_exit_irqoff(vcpu);
+		return;
+	}
+
+	vmx_handle_exit_irqoff(vcpu);
+}
+
 #ifdef CONFIG_KVM_SMM
 static int vt_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
@@ -599,7 +609,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.load_mmu_pgd = vt_load_mmu_pgd,
 
 	.check_intercept = vmx_check_intercept,
-	.handle_exit_irqoff = vmx_handle_exit_irqoff,
+	.handle_exit_irqoff = vt_handle_exit_irqoff,
 
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
 	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b51d2416acfb..fb7f825ed1ed 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -961,6 +961,10 @@ static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	REG(rsi, RSI);
 #undef REG
 
+	if (tdx_check_exit_reason(vcpu, EXIT_REASON_EXCEPTION_NMI) &&
+	    is_nmi(tdexit_intr_info(vcpu)))
+		__vmx_handle_nmi(vcpu);
+
 	guest_state_exit_irqoff();
 }
 
@@ -1040,6 +1044,44 @@ void tdx_inject_nmi(struct kvm_vcpu *vcpu)
 	vcpu->arch.nmi_pending = 0;
 }
 
+void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+{
+	if (tdx_check_exit_reason(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT))
+		vmx_handle_external_interrupt_irqoff(vcpu,
+						     tdexit_intr_info(vcpu));
+	else if (tdx_check_exit_reason(vcpu, EXIT_REASON_EXCEPTION_NMI))
+		vmx_handle_exception_irqoff(vcpu, tdexit_intr_info(vcpu));
+}
+
+static int tdx_handle_exception_nmi(struct kvm_vcpu *vcpu)
+{
+	u32 intr_info = tdexit_intr_info(vcpu);
+
+	/*
+	 * Machine checks are handled by vmx_handle_exception_irqoff(), or by
+	 * tdx_handle_exit() with TDX_NON_RECOVERABLE set if a #MC occurs on
+	 * VM-Entry.  NMIs are handled by tdx_vcpu_enter_exit().
+	 */
+	if (is_nmi(intr_info) || is_machine_check(intr_info))
+		return 1;
+
+	kvm_pr_unimpl("unexpected exception 0x%x(exit_reason 0x%llx qual 0x%lx)\n",
+		intr_info,
+		to_tdx(vcpu)->vp_enter_ret, tdexit_exit_qual(vcpu));
+
+	vcpu->run->exit_reason = KVM_EXIT_EXCEPTION;
+	vcpu->run->ex.exception = intr_info & INTR_INFO_VECTOR_MASK;
+	vcpu->run->ex.error_code = 0;
+
+	return 0;
+}
+
+static int tdx_handle_external_interrupt(struct kvm_vcpu *vcpu)
+{
+	++vcpu->stat.irq_exits;
+	return 1;
+}
+
 static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
 {
 	vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
@@ -1765,6 +1807,10 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	exit_reason = tdexit_exit_reason(vcpu);
 
 	switch (exit_reason.basic) {
+	case EXIT_REASON_EXCEPTION_NMI:
+		return tdx_handle_exception_nmi(vcpu);
+	case EXIT_REASON_EXTERNAL_INTERRUPT:
+		return tdx_handle_external_interrupt(vcpu);
 	case EXIT_REASON_TDCALL:
 		return handle_tdvmcall(vcpu);
 	default:
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 1d2bf6972ea9..28dbef77700c 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -133,6 +133,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void tdx_vcpu_put(struct kvm_vcpu *vcpu);
 bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu);
+void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu);
 int tdx_handle_exit(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion fastpath);
 
@@ -176,6 +177,7 @@ static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediat
 static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
 static inline bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu) { return false; }
+static inline void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu) {}
 static inline int tdx_handle_exit(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion fastpath) { return 0; }
 
-- 
2.46.0


