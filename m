Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5086B6451
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjCLJyu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjCLJyq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:46 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC8F37B77
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614871; x=1710150871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zQzkGqhqPCMmYvziBTiQi/JzM7MyMiSiknMYl8MJe74=;
  b=JkRpH7TtabYjb1pzVZWGw9C3OkqqmavRBAJWFbuQ52QKa1HMIHn9XEEL
   EQ5vAwpYAZfXP3dE6b2FbwJpIIekMakM2KJPKLHcDjVd/4beuahirgNgE
   qJo1clALGpYn1kgxrLcnsAHY34pW1/KF0zXE/YVZdFkCe8n/3oNc6nE6F
   dBqYnyPc41e45D/BuD4I7NdLPYC8CAm3Muhvi8hQd8Bo7lRa3gQNIMzbO
   sxcuj1lQtofFu7UkRIq0VnPUlVoOGARAUbv7IKALzh74sHK28TnMcsd7d
   N7vD2y9v7Kr7aKLBEu3WscIvDo43/DSzW0hbgygc8NUMwascfR8jwO3bL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622892"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622892"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852408954"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852408954"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:20 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-2 02/17] KVM: VMX: Refactor for setup_vmcs_config
Date:   Mon, 13 Mar 2023 02:00:57 +0800
Message-Id: <20230312180112.1778254-3-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180112.1778254-1-jason.cj.chen@intel.com>
References: <20230312180112.1778254-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do refactoring for setup_vmcs_config, leave its major part as
setup_vmcs_config_common, which can be used by both KVM and pKVM on
Intel platform.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 119 +++++++++++++++++++++++++----------------
 arch/x86/kvm/vmx/vmx.h |  18 +++++++
 2 files changed, 90 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1e55bde497f8..6e9723306992 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2593,8 +2593,9 @@ static __init u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
 	return  ctl_opt & allowed;
 }
 
-static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
-				    struct vmx_capability *vmx_cap)
+__init int setup_vmcs_config_common(struct vmcs_config *vmcs_conf,
+				struct vmx_capability *vmx_cap,
+				struct vmcs_config_setting *setting)
 {
 	u32 vmx_msr_low, vmx_msr_high;
 	u32 _pin_based_exec_control = 0;
@@ -2604,34 +2605,17 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	u32 _vmexit_control = 0;
 	u32 _vmentry_control = 0;
 	u64 misc_msr;
-	int i;
-
-	/*
-	 * LOAD/SAVE_DEBUG_CONTROLS are absent because both are mandatory.
-	 * SAVE_IA32_PAT and SAVE_IA32_EFER are absent because KVM always
-	 * intercepts writes to PAT and EFER, i.e. never enables those controls.
-	 */
-	struct {
-		u32 entry_control;
-		u32 exit_control;
-	} const vmcs_entry_exit_pairs[] = {
-		{ VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,	VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL },
-		{ VM_ENTRY_LOAD_IA32_PAT,		VM_EXIT_LOAD_IA32_PAT },
-		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
-		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
-		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
-	};
 
 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
 
-	if (adjust_vmx_controls(KVM_REQUIRED_VMX_CPU_BASED_VM_EXEC_CONTROL,
-				KVM_OPTIONAL_VMX_CPU_BASED_VM_EXEC_CONTROL,
+	if (adjust_vmx_controls(setting->cpu_based_vm_exec_ctrl_req,
+				setting->cpu_based_vm_exec_ctrl_opt,
 				MSR_IA32_VMX_PROCBASED_CTLS,
 				&_cpu_based_exec_control))
 		return -EIO;
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) {
-		if (adjust_vmx_controls(KVM_REQUIRED_VMX_SECONDARY_VM_EXEC_CONTROL,
-					KVM_OPTIONAL_VMX_SECONDARY_VM_EXEC_CONTROL,
+		if (adjust_vmx_controls(setting->secondary_vm_exec_ctrl_req,
+					setting->secondary_vm_exec_ctrl_opt,
 					MSR_IA32_VMX_PROCBASED_CTLS2,
 					&_cpu_based_2nd_exec_control))
 			return -EIO;
@@ -2677,17 +2661,17 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
 		_cpu_based_3rd_exec_control =
-			adjust_vmx_controls64(KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL,
+			adjust_vmx_controls64(setting->tertiary_vm_exec_ctrl_opt,
 					      MSR_IA32_VMX_PROCBASED_CTLS3);
 
-	if (adjust_vmx_controls(KVM_REQUIRED_VMX_VM_EXIT_CONTROLS,
-				KVM_OPTIONAL_VMX_VM_EXIT_CONTROLS,
+	if (adjust_vmx_controls(setting->vmexit_ctrl_req,
+				setting->vmexit_ctrl_opt,
 				MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control))
 		return -EIO;
 
-	if (adjust_vmx_controls(KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL,
-				KVM_OPTIONAL_VMX_PIN_BASED_VM_EXEC_CONTROL,
+	if (adjust_vmx_controls(setting->pin_based_vm_exec_ctrl_req,
+				setting->pin_based_vm_exec_ctrl_opt,
 				MSR_IA32_VMX_PINBASED_CTLS,
 				&_pin_based_exec_control))
 		return -EIO;
@@ -2698,29 +2682,12 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY))
 		_pin_based_exec_control &= ~PIN_BASED_POSTED_INTR;
 
-	if (adjust_vmx_controls(KVM_REQUIRED_VMX_VM_ENTRY_CONTROLS,
-				KVM_OPTIONAL_VMX_VM_ENTRY_CONTROLS,
+	if (adjust_vmx_controls(setting->vmentry_ctrl_req,
+				setting->vmentry_ctrl_opt,
 				MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control))
 		return -EIO;
 
-	for (i = 0; i < ARRAY_SIZE(vmcs_entry_exit_pairs); i++) {
-		u32 n_ctrl = vmcs_entry_exit_pairs[i].entry_control;
-		u32 x_ctrl = vmcs_entry_exit_pairs[i].exit_control;
-
-		if (!(_vmentry_control & n_ctrl) == !(_vmexit_control & x_ctrl))
-			continue;
-
-		pr_warn_once("Inconsistent VM-Entry/VM-Exit pair, entry = %x, exit = %x\n",
-			     _vmentry_control & n_ctrl, _vmexit_control & x_ctrl);
-
-		if (error_on_inconsistent_vmcs_config)
-			return -EIO;
-
-		_vmentry_control &= ~n_ctrl;
-		_vmexit_control &= ~x_ctrl;
-	}
-
 	rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
 
 	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
@@ -2755,6 +2722,64 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	return 0;
 }
 
+static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
+				    struct vmx_capability *vmx_cap)
+{
+	int i, ret;
+	struct vmcs_config_setting setting = {
+		.cpu_based_vm_exec_ctrl_req = KVM_REQUIRED_VMX_CPU_BASED_VM_EXEC_CONTROL,
+		.cpu_based_vm_exec_ctrl_opt = KVM_OPTIONAL_VMX_CPU_BASED_VM_EXEC_CONTROL,
+		.secondary_vm_exec_ctrl_req = KVM_REQUIRED_VMX_SECONDARY_VM_EXEC_CONTROL,
+		.secondary_vm_exec_ctrl_opt = KVM_OPTIONAL_VMX_SECONDARY_VM_EXEC_CONTROL,
+		.tertiary_vm_exec_ctrl_opt = KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL,
+		.pin_based_vm_exec_ctrl_req = KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL,
+		.pin_based_vm_exec_ctrl_opt = KVM_OPTIONAL_VMX_PIN_BASED_VM_EXEC_CONTROL,
+		.vmexit_ctrl_req = KVM_REQUIRED_VMX_VM_EXIT_CONTROLS,
+		.vmexit_ctrl_opt = KVM_OPTIONAL_VMX_VM_EXIT_CONTROLS,
+		.vmentry_ctrl_req = KVM_REQUIRED_VMX_VM_ENTRY_CONTROLS,
+		.vmentry_ctrl_opt = KVM_OPTIONAL_VMX_VM_ENTRY_CONTROLS,
+	};
+
+	/*
+	 * LOAD/SAVE_DEBUG_CONTROLS are absent because both are mandatory.
+	 * SAVE_IA32_PAT and SAVE_IA32_EFER are absent because KVM always
+	 * intercepts writes to PAT and EFER, i.e. never enables those controls.
+	 */
+	struct {
+		u32 entry_control;
+		u32 exit_control;
+	} const vmcs_entry_exit_pairs[] = {
+		{ VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,	VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL },
+		{ VM_ENTRY_LOAD_IA32_PAT,		VM_EXIT_LOAD_IA32_PAT },
+		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
+		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
+		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
+	};
+
+	ret =  setup_vmcs_config_common(vmcs_conf, vmx_cap, &setting);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(vmcs_entry_exit_pairs); i++) {
+		u32 n_ctrl = vmcs_entry_exit_pairs[i].entry_control;
+		u32 x_ctrl = vmcs_entry_exit_pairs[i].exit_control;
+
+		if (!(vmcs_conf->vmentry_ctrl & n_ctrl) == !(vmcs_conf->vmexit_ctrl & x_ctrl))
+			continue;
+
+		pr_warn_once("Inconsistent VM-Entry/VM-Exit pair, entry = %x, exit = %x\n",
+				vmcs_conf->vmentry_ctrl & n_ctrl, vmcs_conf->vmexit_ctrl & x_ctrl);
+
+		if (error_on_inconsistent_vmcs_config)
+			return -EIO;
+
+		vmcs_conf->vmentry_ctrl &= ~n_ctrl;
+		vmcs_conf->vmexit_ctrl &= ~x_ctrl;
+	}
+
+	return ret;
+}
+
 struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
 {
 	int node = cpu_to_node(cpu);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 8b2c4f1f4c8e..e43a833ab1e4 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -591,6 +591,24 @@ static inline u8 vmx_get_rvi(void)
 #define KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL			\
 	(TERTIARY_EXEC_IPI_VIRT)
 
+struct vmcs_config_setting {
+	u32 cpu_based_vm_exec_ctrl_req;
+	u32 cpu_based_vm_exec_ctrl_opt;
+	u32 secondary_vm_exec_ctrl_req;
+	u32 secondary_vm_exec_ctrl_opt;
+	u64 tertiary_vm_exec_ctrl_opt;
+	u32 pin_based_vm_exec_ctrl_req;
+	u32 pin_based_vm_exec_ctrl_opt;
+	u32 vmexit_ctrl_req;
+	u32 vmexit_ctrl_opt;
+	u32 vmentry_ctrl_req;
+	u32 vmentry_ctrl_opt;
+};
+
+int setup_vmcs_config_common(struct vmcs_config *vmcs_conf,
+				struct vmx_capability *vmx_cap,
+				struct vmcs_config_setting *setting);
+
 #define BUILD_CONTROLS_SHADOW(lname, uname, bits)						\
 static inline void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)			\
 {												\
-- 
2.25.1

