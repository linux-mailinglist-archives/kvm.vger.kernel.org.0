Return-Path: <kvm+bounces-59960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BFDE8BD6EA1
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 03:11:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4C0D64EC025
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 01:10:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F5C255F28;
	Tue, 14 Oct 2025 01:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="cQXpD+/k"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A74211460;
	Tue, 14 Oct 2025 01:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760404238; cv=none; b=Ut/0DtQ3J+0wxnIFdAqWKKjlVzpqobRs3WkhaW2EiC5TtzANwvobE+WrC8+JErYBcWTuMNgpUulNNUjFRrZrElBbrmBQJVTioJKWGbFamAytlwTrW5RhWujuKIfSLZMxgIxBrcAtjaRyxlPOj5dt7ZuajxCBdx9QkhHklwl529Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760404238; c=relaxed/simple;
	bh=BUzBUHX/x6reDK7bsfDZ981DHxprAsBiwshFv88/fTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=annZGOkqZa0I7Bk36akFH4x1G+M5O70e7L7ny8tYzQcBUz3zzgeoKMYlAklR7/Sr2Gjzg8BYHJLX8KBUEWu90vfATcyFHo+kIrbgnO68UYAuWmgloZniPud0O/Q1t+fYCE0zkgv7+k3y15+vMpapseoC5qjCCVBuGG1SrEqpLM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=cQXpD+/k; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59E19p1e1568441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 13 Oct 2025 18:10:11 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59E19p1e1568441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025092201; t=1760404211;
	bh=SyDRW13Sh0Fj0IGMQ1Z/mnD/rmunrZLADNkA6trI0cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQXpD+/kURnl1dfbg6lyjbYhn/GCxik7BS93oPpxfzyhkWKRtzIcEeT4O+KffuFSu
	 odw300DnfqGC2A0Sofhyy2HqldJOTbPRf2cXXr50HNU335QAB6BpNvZ4kxE0NRfIIr
	 fgdxG4r9kzprdsizYMD6+IfuyVMgU07D4cEnEaEKLszaWWwKqfR7Y+cGzrnVXyID70
	 9bd60eriMGkWV5HUd4Cbci6B4G40lneod8jesb5a6xKvNSdkCtEapOKGuq2aO+pb9l
	 jKJThqMamZVbPPpLw4ZViSyuO0PS4G93tWZo8tX/eAsSlc2aju2VIyM/IZv8sF8Wgw
	 +L68peJAKF1iQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v8 17/21] KVM: nVMX: Add support for the secondary VM exit controls
Date: Mon, 13 Oct 2025 18:09:46 -0700
Message-ID: <20251014010950.1568389-18-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251014010950.1568389-1-xin@zytor.com>
References: <20251014010950.1568389-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Enable the secondary VM exit controls to prepare for nested FRED.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Changes in v8:
* Relocate secondary_vm_exit_controls to the last u64 padding field.
* Remove the change to Documentation/virt/kvm/x86/nested-vmx.rst.

Changes in v5:
* Allow writing MSR_IA32_VMX_EXIT_CTLS2 (Sean).
* Add TB from Xuelian Guo.

Change in v3:
* Read secondary VM exit controls from vmcs_conf insteasd of the hardware
  MSR MSR_IA32_VMX_EXIT_CTLS2 to avoid advertising features to L1 that KVM
  itself doesn't support, e.g. because the expected entry+exit pairs aren't
  supported. (Sean Christopherson)
---
 arch/x86/kvm/vmx/capabilities.h |  1 +
 arch/x86/kvm/vmx/nested.c       | 26 +++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmcs12.c       |  1 +
 arch/x86/kvm/vmx/vmcs12.h       |  3 ++-
 arch/x86/kvm/x86.h              |  2 +-
 5 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 651507627ef3..f390f9f883c3 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -34,6 +34,7 @@ struct nested_vmx_msrs {
 	u32 pinbased_ctls_high;
 	u32 exit_ctls_low;
 	u32 exit_ctls_high;
+	u64 secondary_exit_ctls;
 	u32 entry_ctls_low;
 	u32 entry_ctls_high;
 	u32 misc_low;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 76271962cb70..332c1ac12eb6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1531,6 +1531,11 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 			return -EINVAL;
 		vmx->nested.msrs.vmfunc_controls = data;
 		return 0;
+	case MSR_IA32_VMX_EXIT_CTLS2:
+		if (data & ~vmcs_config.nested.secondary_exit_ctls)
+			return -EINVAL;
+		vmx->nested.msrs.secondary_exit_ctls = data;
+		return 0;
 	default:
 		/*
 		 * The rest of the VMX capability MSRs do not support restore.
@@ -1570,6 +1575,9 @@ int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata)
 		if (msr_index == MSR_IA32_VMX_EXIT_CTLS)
 			*pdata |= VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR;
 		break;
+	case MSR_IA32_VMX_EXIT_CTLS2:
+		*pdata = msrs->secondary_exit_ctls;
+		break;
 	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
 	case MSR_IA32_VMX_ENTRY_CTLS:
 		*pdata = vmx_control_msr(
@@ -2520,6 +2528,11 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 		exec_control &= ~VM_EXIT_LOAD_IA32_EFER;
 	vm_exit_controls_set(vmx, exec_control);
 
+	if (exec_control & VM_EXIT_ACTIVATE_SECONDARY_CONTROLS) {
+		exec_control = __secondary_vm_exit_controls_get(vmcs01);
+		secondary_vm_exit_controls_set(vmx, exec_control);
+	}
+
 	/*
 	 * Interrupt/Exception Fields
 	 */
@@ -7179,7 +7192,8 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
-		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE;
+		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE |
+		VM_EXIT_ACTIVATE_SECONDARY_CONTROLS;
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
@@ -7192,6 +7206,16 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
 
 	/* We support free control of debug control saving. */
 	msrs->exit_ctls_low &= ~VM_EXIT_SAVE_DEBUG_CONTROLS;
+
+	if (msrs->exit_ctls_high & VM_EXIT_ACTIVATE_SECONDARY_CONTROLS) {
+		msrs->secondary_exit_ctls = vmcs_conf->vmexit_2nd_ctrl;
+		/*
+		 * As the secondary VM exit control is always loaded, do not
+		 * advertise any feature in it to nVMX until its nVMX support
+		 * is ready.
+		 */
+		msrs->secondary_exit_ctls &= 0;
+	}
 }
 
 static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 4233b5ca9461..3b01175f392a 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -66,6 +66,7 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD64(HOST_IA32_PAT, host_ia32_pat),
 	FIELD64(HOST_IA32_EFER, host_ia32_efer),
 	FIELD64(HOST_IA32_PERF_GLOBAL_CTRL, host_ia32_perf_global_ctrl),
+	FIELD64(SECONDARY_VM_EXIT_CONTROLS, secondary_vm_exit_controls),
 	FIELD(PIN_BASED_VM_EXEC_CONTROL, pin_based_vm_exec_control),
 	FIELD(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control),
 	FIELD(EXCEPTION_BITMAP, exception_bitmap),
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 4ad6b16525b9..fa5306dc0311 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -71,7 +71,7 @@ struct __packed vmcs12 {
 	u64 pml_address;
 	u64 encls_exiting_bitmap;
 	u64 tsc_multiplier;
-	u64 padding64[1]; /* room for future expansion */
+	u64 secondary_vm_exit_controls;
 	/*
 	 * To allow migration of L1 (complete with its L2 guests) between
 	 * machines of different natural widths (32 or 64 bit), we cannot have
@@ -261,6 +261,7 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(pml_address, 312);
 	CHECK_OFFSET(encls_exiting_bitmap, 320);
 	CHECK_OFFSET(tsc_multiplier, 328);
+	CHECK_OFFSET(secondary_vm_exit_controls, 336);
 	CHECK_OFFSET(cr0_guest_host_mask, 344);
 	CHECK_OFFSET(cr4_guest_host_mask, 352);
 	CHECK_OFFSET(cr0_read_shadow, 360);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index e9c6f304b02e..1576f192a647 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -95,7 +95,7 @@ do {											\
  * associated feature that KVM supports for nested virtualization.
  */
 #define KVM_FIRST_EMULATED_VMX_MSR	MSR_IA32_VMX_BASIC
-#define KVM_LAST_EMULATED_VMX_MSR	MSR_IA32_VMX_VMFUNC
+#define KVM_LAST_EMULATED_VMX_MSR	MSR_IA32_VMX_EXIT_CTLS2
 
 #define KVM_DEFAULT_PLE_GAP		128
 #define KVM_VMX_DEFAULT_PLE_WINDOW	4096
-- 
2.51.0


