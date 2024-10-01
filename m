Return-Path: <kvm+bounces-27741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC59F98B36E
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:05:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 350BDB24139
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5703A1BFDFE;
	Tue,  1 Oct 2024 05:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="SLmvSL2K"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84637192B9E;
	Tue,  1 Oct 2024 05:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758940; cv=none; b=T5XwA8wkl9xNC+J6GJHPKAqeCrO5pjztkQSXJ9j7O6f+wXjsjmnJxYifbJsHuIehZ17jweRYZKZ587ZIKmrKz19CgEDiDuvtgWngwyGsZzS5vMfk7mQAPhWOtBwCvXxixLce9ZdYzA2c5hoEgcnUh/SPYrRcDlKlpWrweBIiQCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758940; c=relaxed/simple;
	bh=UGRh/zMAZwnrInVXQfPkIMpEYtSSI/3hMa6vZ6FHZDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIh849HQhRQeVtrLmtEtc+Nz64jiOjKPY9PUqraPe6KacUeyaKLvNkYocVkH1zHK8vkPwpnMYZGNtB52Xn6ibVJ8PuQWYlD2fJ3yJ/YJhGI1mL2Ryvt2BMgHxb/rTbH59uu4RrTcfHRRbPWTQGcvwVEI6bYlt0BBqUV/VkC+glU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=SLmvSL2K; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7S3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:18 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7S3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758879;
	bh=xDcBS4DfGuxq9tK1emBB+qc1AMtWqUc6cdoiAVHl0vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLmvSL2KpJvzhQUf/fpvdsRePyUzbZX2wP5ShBFqp579ca5u11x+KGhbphoMRxqmN
	 jqPtzhuXWcf4JGnwZtdDHYErcUGrX4vHJzusFxq6Ie8VKIQ6sTXj8BpJU6VR6WvirI
	 sbUAlSH+z82mKyuEwdARUIyPaZlesKJqf82kqyK6e96uHZW237nMD45u5RyI+DNNXD
	 XEwG3irPoAI49mFfC0h7u+Igoj5+guu8T2r6QZ4h1NPtUbukworIl9I3u+Zz0HGkig
	 UsDSit9mhkZg/70OQADvnzlmHjyg1IG2S/iMFD+EuXbNbT9IUS0hJ+RcHOnDl0syib
	 GefpZh8K+FsxQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 03/27] KVM: VMX: Add support for the secondary VM exit controls
Date: Mon, 30 Sep 2024 22:00:46 -0700
Message-ID: <20241001050110.3643764-4-xin@zytor.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001050110.3643764-1-xin@zytor.com>
References: <20241001050110.3643764-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Always load the secondary VM exit controls to prepare for FRED enabling.

Extend the VM exit/entry consistency check framework to accommodate this
newly added secondary VM exit controls.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---

Change since v2:
* Do FRED controls consistency checks in the VM exit/entry consistency
  check framework (Sean Christopherson).

Change since v1:
* Always load the secondary VM exit controls (Sean Christopherson).
---
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/include/asm/vmx.h       |  3 ++
 arch/x86/kvm/vmx/capabilities.h  |  9 +++++-
 arch/x86/kvm/vmx/vmcs.h          |  1 +
 arch/x86/kvm/vmx/vmx.c           | 51 ++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.h           |  7 ++++-
 6 files changed, 61 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3ae84c3b8e6d..95b6e2749256 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1178,6 +1178,7 @@
 #define MSR_IA32_VMX_TRUE_ENTRY_CTLS     0x00000490
 #define MSR_IA32_VMX_VMFUNC             0x00000491
 #define MSR_IA32_VMX_PROCBASED_CTLS3	0x00000492
+#define MSR_IA32_VMX_EXIT_CTLS2		0x00000493
 
 /* Resctrl MSRs: */
 /* - Intel: */
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index f7fd4369b821..57a37ea06a17 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -106,6 +106,7 @@
 #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+#define VM_EXIT_ACTIVATE_SECONDARY_CONTROLS	0x80000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -258,6 +259,8 @@ enum vmcs_field {
 	TERTIARY_VM_EXEC_CONTROL_HIGH	= 0x00002035,
 	PID_POINTER_TABLE		= 0x00002042,
 	PID_POINTER_TABLE_HIGH		= 0x00002043,
+	SECONDARY_VM_EXIT_CONTROLS	= 0x00002044,
+	SECONDARY_VM_EXIT_CONTROLS_HIGH	= 0x00002045,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
 	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
 	VMCS_LINK_POINTER               = 0x00002800,
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index cb6588238f46..e8f3ad0f79ee 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -59,8 +59,9 @@ struct vmcs_config {
 	u32 cpu_based_exec_ctrl;
 	u32 cpu_based_2nd_exec_ctrl;
 	u64 cpu_based_3rd_exec_ctrl;
-	u32 vmexit_ctrl;
 	u32 vmentry_ctrl;
+	u32 vmexit_ctrl;
+	u64 secondary_vmexit_ctrl;
 	u64 misc;
 	struct nested_vmx_msrs nested;
 };
@@ -136,6 +137,12 @@ static inline bool cpu_has_tertiary_exec_ctrls(void)
 		CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
 }
 
+static inline bool cpu_has_secondary_vmexit_ctrls(void)
+{
+	return vmcs_config.vmexit_ctrl &
+		VM_EXIT_ACTIVATE_SECONDARY_CONTROLS;
+}
+
 static inline bool cpu_has_vmx_virtualize_apic_accesses(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index b25625314658..ae152a9d1963 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -47,6 +47,7 @@ struct vmcs_host_state {
 struct vmcs_controls_shadow {
 	u32 vm_entry;
 	u32 vm_exit;
+	u64 secondary_vm_exit;
 	u32 pin;
 	u32 exec;
 	u32 secondary_exec;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3f6257d88ded..ec548c75c3ef 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2606,6 +2606,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	u32 _cpu_based_2nd_exec_control = 0;
 	u64 _cpu_based_3rd_exec_control = 0;
 	u32 _vmexit_control = 0;
+	u64 _secondary_vmexit_control = 0;
 	u32 _vmentry_control = 0;
 	u64 basic_msr;
 	u64 misc_msr;
@@ -2619,7 +2620,8 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	struct {
 		u32 entry_control;
 		u32 exit_control;
-	} const vmcs_entry_exit_pairs[] = {
+		u64 exit_2nd_control;
+	} const vmcs_entry_exit_triplets[] = {
 		{ VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,	VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL },
 		{ VM_ENTRY_LOAD_IA32_PAT,		VM_EXIT_LOAD_IA32_PAT },
 		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
@@ -2713,21 +2715,43 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 				&_vmentry_control))
 		return -EIO;
 
-	for (i = 0; i < ARRAY_SIZE(vmcs_entry_exit_pairs); i++) {
-		u32 n_ctrl = vmcs_entry_exit_pairs[i].entry_control;
-		u32 x_ctrl = vmcs_entry_exit_pairs[i].exit_control;
-
-		if (!(_vmentry_control & n_ctrl) == !(_vmexit_control & x_ctrl))
+	if (_vmexit_control & VM_EXIT_ACTIVATE_SECONDARY_CONTROLS)
+		_secondary_vmexit_control =
+			adjust_vmx_controls64(KVM_OPTIONAL_VMX_SECONDARY_VM_EXIT_CONTROLS,
+					      MSR_IA32_VMX_EXIT_CTLS2);
+
+	for (i = 0; i < ARRAY_SIZE(vmcs_entry_exit_triplets); i++) {
+		u32 n_ctrl = vmcs_entry_exit_triplets[i].entry_control;
+		u32 x_ctrl = vmcs_entry_exit_triplets[i].exit_control;
+		u64 x_ctrl_2 = vmcs_entry_exit_triplets[i].exit_2nd_control;
+		bool has_n = n_ctrl && ((_vmentry_control & n_ctrl) == n_ctrl);
+		bool has_x = x_ctrl && ((_vmexit_control & x_ctrl) == x_ctrl);
+		bool has_x_2 = x_ctrl_2 && ((_secondary_vmexit_control & x_ctrl_2) == x_ctrl_2);
+
+		if (x_ctrl_2) {
+			/* Only activate secondary VM exit control bit should be set */
+			if ((_vmexit_control & x_ctrl) == VM_EXIT_ACTIVATE_SECONDARY_CONTROLS) {
+				if (has_n == has_x_2)
+					continue;
+			} else {
+				/* The feature should not be supported in any control */
+				if (!has_n && !has_x && !has_x_2)
+					continue;
+			}
+		} else if (has_n == has_x) {
 			continue;
+		}
 
-		pr_warn_once("Inconsistent VM-Entry/VM-Exit pair, entry = %x, exit = %x\n",
-			     _vmentry_control & n_ctrl, _vmexit_control & x_ctrl);
+		pr_warn_once("Inconsistent VM-Entry/VM-Exit triplet, entry = %x, exit = %x, secondary_exit = %llx\n",
+			     _vmentry_control & n_ctrl, _vmexit_control & x_ctrl,
+			     _secondary_vmexit_control & x_ctrl_2);
 
 		if (error_on_inconsistent_vmcs_config)
 			return -EIO;
 
 		_vmentry_control &= ~n_ctrl;
 		_vmexit_control &= ~x_ctrl;
+		_secondary_vmexit_control &= ~x_ctrl_2;
 	}
 
 	rdmsrl(MSR_IA32_VMX_BASIC, basic_msr);
@@ -2757,8 +2781,9 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	vmcs_conf->cpu_based_exec_ctrl = _cpu_based_exec_control;
 	vmcs_conf->cpu_based_2nd_exec_ctrl = _cpu_based_2nd_exec_control;
 	vmcs_conf->cpu_based_3rd_exec_ctrl = _cpu_based_3rd_exec_control;
-	vmcs_conf->vmexit_ctrl         = _vmexit_control;
 	vmcs_conf->vmentry_ctrl        = _vmentry_control;
+	vmcs_conf->vmexit_ctrl         = _vmexit_control;
+	vmcs_conf->secondary_vmexit_ctrl   = _secondary_vmexit_control;
 	vmcs_conf->misc	= misc_msr;
 
 #if IS_ENABLED(CONFIG_HYPERV)
@@ -4449,6 +4474,11 @@ static u32 vmx_vmexit_ctrl(void)
 		~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER);
 }
 
+static u64 vmx_secondary_vmexit_ctrl(void)
+{
+	return vmcs_config.secondary_vmexit_ctrl;
+}
+
 void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -4799,6 +4829,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 
 	vm_exit_controls_set(vmx, vmx_vmexit_ctrl());
 
+	if (cpu_has_secondary_vmexit_ctrls())
+		secondary_vm_exit_controls_set(vmx, vmx_secondary_vmexit_ctrl());
+
 	/* 22.2.1, 20.8.1 */
 	vm_entry_controls_set(vmx, vmx_vmentry_ctrl());
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 2325f773a20b..cf3a6c116634 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -507,7 +507,11 @@ static inline u8 vmx_get_rvi(void)
 	       VM_EXIT_LOAD_IA32_EFER |					\
 	       VM_EXIT_CLEAR_BNDCFGS |					\
 	       VM_EXIT_PT_CONCEAL_PIP |					\
-	       VM_EXIT_CLEAR_IA32_RTIT_CTL)
+	       VM_EXIT_CLEAR_IA32_RTIT_CTL |				\
+	       VM_EXIT_ACTIVATE_SECONDARY_CONTROLS)
+
+#define KVM_REQUIRED_VMX_SECONDARY_VM_EXIT_CONTROLS (0)
+#define KVM_OPTIONAL_VMX_SECONDARY_VM_EXIT_CONTROLS (0)
 
 #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
 	(PIN_BASED_EXT_INTR_MASK |					\
@@ -612,6 +616,7 @@ static __always_inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##b
 }
 BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS, 32)
 BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS, 32)
+BUILD_CONTROLS_SHADOW(secondary_vm_exit, SECONDARY_VM_EXIT_CONTROLS, 64)
 BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL, 32)
 BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL, 32)
 BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL, 32)
-- 
2.46.2


