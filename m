Return-Path: <kvm+bounces-33267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 164679E88E5
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 02:09:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0DC118865E9
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 01:07:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C52F14B956;
	Mon,  9 Dec 2024 01:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YXNendar"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96FE4594D;
	Mon,  9 Dec 2024 01:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733706365; cv=none; b=F5aTXSnPGTY3w2pskh82TDdtOxzpErbSs+BnXX6V6CAbgfne6JkqkkaX7ykTsuUtpeWgG7xhDmfd6NJAUk39Ig4rwzb/+5zwHMFPyESk7Uikkl1BQG7XPoZEmZ+QsIqTp0Ksko/bL/ezliDTB6fs6tXCfqu5STIzmrtSueA0ylQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733706365; c=relaxed/simple;
	bh=1y+M/KxC3Qfow65wbouJQ+Z83kdxUI85xaQvXUsqNjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9wpbcHqFPldUGLHHulav7yzaClmxv4fm1KM3JjOy3o3az9V4hHRahAqSnKhW4XezyGfoj8AKqbZOES0FZKlFL8js7OQakOFBccx6bukgwSbqUP+lglpv9umL3Ns8nkW21VbcVXeRcB/VnWIZWgvAuP8M1ocG6Vkz+ohQKXFahU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YXNendar; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733706364; x=1765242364;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1y+M/KxC3Qfow65wbouJQ+Z83kdxUI85xaQvXUsqNjw=;
  b=YXNendarHC/1pkXoSDUAOeVzSwmaxuUQvOJhx+R1bpmBuOaY53I2rUD0
   OqM3pqQNZWtKmfmdLZSWN6qiQZsNrmeUv089hbm0IViGtOWaIDlZA1mnQ
   Od8vQmK/IhkXHmHKk/SNZm2Vc3HpXe7+b/4w5IrZYXJ7ZZEJBq6PmCr7Q
   05rRWkBIMYg7lrtskos1QwMwUuw4yYkUz2ZFnjfaRZ2ftRx1iEpZzJqRi
   aPAmivi/71bxv2mlAQAbuyNjdjzfFNtj95QENe6yLescOZnAwK/65Ye6A
   GypYaI1qJZi5AeqJWZhZe/wcbK2Ali7w+ezHKhI8MhBkflhx6M2+xqtcs
   g==;
X-CSE-ConnectionGUID: yzVgQhjeTU6crU0K3Z/o3w==
X-CSE-MsgGUID: o24fDuGcT++azqQfTKmhTA==
X-IronPort-AV: E=McAfee;i="6700,10204,11280"; a="36833711"
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="36833711"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:06:04 -0800
X-CSE-ConnectionGUID: 5o9jGP/TQXCq6Lvh+sN+qg==
X-CSE-MsgGUID: qC3EmLBuS+Chm9eD5vj8ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="95402494"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:06:00 -0800
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
Subject: [PATCH 08/16] KVM: TDX: Implement methods to inject NMI
Date: Mon,  9 Dec 2024 09:07:22 +0800
Message-ID: <20241209010734.3543481-9-binbin.wu@linux.intel.com>
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

Inject NMI to TDX guest by setting the PEND_NMI TDVPS field to 1, i.e. make
the NMI pending in the TDX module.  If there is a further pending NMI in KVM,
collapse it to the one pending in the TDX module.

VMM can request the TDX module to inject a NMI into a TDX vCPU by setting
the PEND_NMI TDVPS field to 1.  Following that, VMM can call TDH.VP.ENTER to
run the vCPU and the TDX module will attempt to inject the NMI as soon as
possible.

KVM has the following 3 cases to inject two NMIs when handling simultaneous
NMIs and they need to be injected in a back-to-back way.  Otherwise, OS
kernel may fire a warning about the unknown NMI [1]:
K1. One NMI is being handled in the guest and one NMI pending in KVM.
    KVM requests NMI window exit to inject the pending NMI.
K2. Two NMIs are pending in KVM.
    KVM injects the first NMI and requests NMI window exit to inject the
    second NMI.
K3. A previous NMI needs to be rejected and one NMI pending in KVM.
    KVM first requests force immediate exit followed by a VM entry to complete
    the NMI rejection.  Then, during the force immediate exit, KVM requests
    NMI window exit to inject the pending NMI.

For TDX, PEND_NMI TDVPS field is a 1-bit filed, i.e. KVM can only pend one
NMI in the TDX module.  Also, the vCPU state is protected, KVM doesn't know
the NMI blocking states of TDX vCPU, KVM has to assume NMI is always unmasked
and allowed.  When KVM sees PEND_NMI is 1 after a TD exit, it means the
previous NMI needs to be re-injected.

Based on KVM's NMI handling flow, there are following 6 cases:
    In NMI handler    TDX module    KVM
T1. No                PEND_NMI=0    1 pending NMI
T2. No                PEND_NMI=0    2 pending NMIs
T3. No                PEND_NMI=1    1 pending NMI
T4. Yes               PEND_NMI=0    1 pending NMI
T5. Yes               PEND_NMI=0    2 pending NMIs
T6. Yes               PEND_NMI=1    1 pending NMI
K1 is mapped to T4.
K2 is mapped to T2 or T5.
K3 is mapped to T3 or T6.
Note: KVM doesn't know whether NMI is blocked by a NMI or not, case T5 and
T6 can happen.

When handling pending NMI in KVM for TDX guest, what KVM can do is to add a
pending NMI in TDX module when PEND_NMI is 0.  T1 and T4 can be handled by
this way.  However, TDX doesn't allow KVM to request NMI window exit directly,
if PEND_NMI is already set and there is still pending NMI in KVM, the only way
KVM could try is to request a force immediate exit.  But for case T5 and T6,
force immediate exit will result in infinite loop because force immediate exit
makes it no progress in the NMI handler, so that the pending NMI in the TDX
module can never be injected.

Considering on X86 bare metal, multiple NMIs could collapse into one NMI,
e.g. when NMI is blocked by SMI.  It's OS's responsibility to poll all NMI
sources in the NMI handler to avoid missing handling of some NMI events.

Based on that, for the above 3 cases (K1-K3), only case K1 must inject the
second NMI because the guest NMI handler may have already polled some of the
NMI sources, which could include the source of the pending NMI, the pending
NMI must be injected to avoid the lost of NMI.  For case K2 and K3, the guest
OS will poll all NMI sources (including the sources caused by the second NMI
and further NMI collapsed) when the delivery of the first NMI, KVM doesn't
have the necessity to inject the second NMI.

To handle the NMI injection properly for TDX, there are two options:
- Option 1: Modify the KVM's NMI handling common code, to collapse the second
  pending NMI for K2 and K3.
- Option 2: Do it in TDX specific way. When the previous NMI is still pending
  in the TDX module, i.e. it has not been delivered to TDX guest yet, collapse
  the pending NMI in KVM into the previous one.

This patch goes with option 2 because it is simple and doesn't impact other
VM types.  Option 1 may need more discussions.

This is the first need to access vCPU scope metadata in the "management"
class. Make needed accessors available.

[1] https://lore.kernel.org/all/1317409584-23662-5-git-send-email-dzickus@redhat.com/

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Singed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TDX interrupts breakout:
- Collapse the pending NMI in KVM if there is already one pending in the
  TDX module.
---
 arch/x86/kvm/vmx/main.c    | 61 ++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/tdx.c     | 16 ++++++++++
 arch/x86/kvm/vmx/tdx.h     |  5 ++++
 arch/x86/kvm/vmx/x86_ops.h |  2 ++
 4 files changed, 79 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d59a6a783ead..4b42d14cc62e 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -240,6 +240,57 @@ static void vt_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	vmx_flush_tlb_guest(vcpu);
 }
 
+static void vt_inject_nmi(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_inject_nmi(vcpu);
+		return;
+	}
+
+	vmx_inject_nmi(vcpu);
+}
+
+static int vt_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	/*
+	 * The TDX module manages NMI windows and NMI reinjection, and hides NMI
+	 * blocking, all KVM can do is throw an NMI over the wall.
+	 */
+	if (is_td_vcpu(vcpu))
+		return true;
+
+	return vmx_nmi_allowed(vcpu, for_injection);
+}
+
+static bool vt_get_nmi_mask(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * KVM can't get NMI blocking status for TDX guest, assume NMIs are
+	 * always unmasked.
+	 */
+	if (is_td_vcpu(vcpu))
+		return false;
+
+	return vmx_get_nmi_mask(vcpu);
+}
+
+static void vt_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_set_nmi_mask(vcpu, masked);
+}
+
+static void vt_enable_nmi_window(struct kvm_vcpu *vcpu)
+{
+	/* Refer to the comments in tdx_inject_nmi(). */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_enable_nmi_window(vcpu);
+}
+
 static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			    int pgd_level)
 {
@@ -411,14 +462,14 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.get_interrupt_shadow = vt_get_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
 	.inject_irq = vt_inject_irq,
-	.inject_nmi = vmx_inject_nmi,
+	.inject_nmi = vt_inject_nmi,
 	.inject_exception = vmx_inject_exception,
 	.cancel_injection = vt_cancel_injection,
 	.interrupt_allowed = vt_interrupt_allowed,
-	.nmi_allowed = vmx_nmi_allowed,
-	.get_nmi_mask = vmx_get_nmi_mask,
-	.set_nmi_mask = vmx_set_nmi_mask,
-	.enable_nmi_window = vmx_enable_nmi_window,
+	.nmi_allowed = vt_nmi_allowed,
+	.get_nmi_mask = vt_get_nmi_mask,
+	.set_nmi_mask = vt_set_nmi_mask,
+	.enable_nmi_window = vt_enable_nmi_window,
 	.enable_irq_window = vt_enable_irq_window,
 	.update_cr8_intercept = vmx_update_cr8_intercept,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index dcbe25695d85..65fe7ba8a6c6 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1007,6 +1007,22 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	return tdx_exit_handlers_fastpath(vcpu);
 }
 
+void tdx_inject_nmi(struct kvm_vcpu *vcpu)
+{
+	++vcpu->stat.nmi_injections;
+	td_management_write8(to_tdx(vcpu), TD_VCPU_PEND_NMI, 1);
+	/*
+	 * TDX doesn't support KVM to request NMI window exit.  If there is
+	 * still a pending vNMI, KVM is not able to inject it along with the
+	 * one pending in TDX module in a back-to-back way.  Since the previous
+	 * vNMI is still pending in TDX module, i.e. it has not been delivered
+	 * to TDX guest yet, it's OK to collapse the pending vNMI into the
+	 * previous one.  The guest is expected to handle all the NMI sources
+	 * when handling the first vNMI.
+	 */
+	vcpu->arch.nmi_pending = 0;
+}
+
 static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
 {
 	vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index d6a0fc20ecaa..b553dd9b0b06 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -151,6 +151,8 @@ static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
 			 "Invalid TD VMCS access for 16-bit field");
 }
 
+static __always_inline void tdvps_management_check(u64 field, u8 bits) {}
+
 #define TDX_BUILD_TDVPS_ACCESSORS(bits, uclass, lclass)				\
 static __always_inline u##bits td_##lclass##_read##bits(struct vcpu_tdx *tdx,	\
 							u32 field)		\
@@ -200,6 +202,9 @@ static __always_inline void td_##lclass##_clearbit##bits(struct vcpu_tdx *tdx,	\
 TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
 TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
 TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
+
+TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
+
 #else
 static inline void tdx_bringup(void) {}
 static inline void tdx_cleanup(void) {}
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 1ddb7600f162..1d2bf6972ea9 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -138,6 +138,7 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu,
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 			   int trig_mode, int vector);
+void tdx_inject_nmi(struct kvm_vcpu *vcpu);
 void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
 
@@ -180,6 +181,7 @@ static inline int tdx_handle_exit(struct kvm_vcpu *vcpu,
 
 static inline void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 					 int trig_mode, int vector) {}
+static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
 static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
 				     u64 *info2, u32 *intr_info, u32 *error_code) {}
 
-- 
2.46.0


