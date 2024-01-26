Return-Path: <kvm+bounces-7102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64ED783D670
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:35:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BBDE28E9EB
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBA4613E21B;
	Fri, 26 Jan 2024 08:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LPcO/LdJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DB525633;
	Fri, 26 Jan 2024 08:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259414; cv=none; b=lDIVPjWnaHxAWSuBC8zqgACZwPLdIeGkDzbg4mLgc/ofpcAEjs1crOVKC5wSi+2YtaCaKg7RFMjjIR/gM/A4aX8GOqXq+VRZubhXBGDHNpqflGLkeyHryVQUmcxrl2KacbxRjrTzDgWWgz4ARZsJN9T1xo1xELbTjaDOyPibZlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259414; c=relaxed/simple;
	bh=YPU3LPyNSnF5QA2pVbK/JlE2xn3RFRw6LyKXbEinvVg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L0BFcdQuqPPtrsSoZIQ02ySbN3jP2TslOPXKOT9vEqKm3JmZUSFdA9q1tXFx9dLs61NCNzbIJpb7zCzafG2tLEE9sH8rlPN9hQYd1BdMOqaohDtTfpXcECCcLbNie67I1n/3RCgwGboTd9ZxeBSgGaStpzXp06gu2f6vkWiCoeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LPcO/LdJ; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259413; x=1737795413;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YPU3LPyNSnF5QA2pVbK/JlE2xn3RFRw6LyKXbEinvVg=;
  b=LPcO/LdJGpThcdAzxByCcXsZ62krkvuG/YssfgoDSwSuOg2Q4Lk6ZSjf
   GQ53LgsLGYrQ9fLbVSTBpVWaJUwlZlexLDqNLwLUZArpcsIGgtvAy7DHq
   sVSczI8JPVDm78kZxKJqhuXDuUEeurlOusfct5sAfr6t3QhBu/SyKU88U
   lCh6AzFH1WB5c6Xj6y2IeZZVBAwAHwY7hUAfD4o3zAz2aji7+f0Zpw5jo
   KtNunFJEKUDz52OTRct14OnqOLRs5HVPSzkUMHshKZKvWXRSm0T6WRy8q
   bczNMp5WYGAG8sbjXAjBDtSwN2Bl+WaBuGw+50SzGqZJCQrZkivIAeL8q
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792346"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792346"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310057"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310057"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:47 -0800
From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mizhang@google.com,
	kan.liang@intel.com,
	zhenyuw@linux.intel.com,
	dapeng1.mi@linux.intel.com,
	jmattson@google.com
Cc: kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiyuan.lv@intel.com,
	eranian@google.com,
	irogers@google.com,
	samantha.alt@intel.com,
	like.xu.linux@gmail.com,
	chao.gao@intel.com,
	xiong.y.zhang@linux.intel.com,
	Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [RFC PATCH 15/41] KVM: x86/pmu: Manage MSR interception for IA32_PERF_GLOBAL_CTRL
Date: Fri, 26 Jan 2024 16:54:18 +0800
Message-Id: <20240126085444.324918-16-xiong.y.zhang@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiong Zhang <xiong.y.zhang@intel.com>

In PMU passthrough mode, there are three requirements to manage
IA32_PERF_GLOBAL_CTRL:
 - guest IA32_PERF_GLOBAL_CTRL MSR must be saved at vm exit.
 - IA32_PERF_GLOBAL_CTRL MSR must be cleared at vm exit to avoid any
   counter of running within KVM runloop.
 - guest IA32_PERF_GLOBAL_CTRL MSR must be restored at vm entry.

Introduce vmx_set_perf_global_ctrl() function to auto switching
IA32_PERF_GLOBAL_CTR and invoke it after the VMM finishes setting up the
CPUID bits.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/vmx.h |  1 +
 arch/x86/kvm/vmx/vmx.c     | 89 ++++++++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.h     |  3 +-
 3 files changed, 78 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0e73616b82f3..f574e7b429a3 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -104,6 +104,7 @@
 #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+#define VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL      0x40000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 33cb69ff0804..8ab266e1e2a7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4387,6 +4387,74 @@ static u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
 	return pin_based_exec_ctrl;
 }
 
+static void vmx_set_perf_global_ctrl(struct vcpu_vmx *vmx)
+{
+	u32 vmentry_ctrl = vm_entry_controls_get(vmx);
+	u32 vmexit_ctrl = vm_exit_controls_get(vmx);
+	int i;
+
+       /*
+	* PERF_GLOBAL_CTRL is toggled dynamically in emulated vPMU.
+	*/
+	if (cpu_has_perf_global_ctrl_bug() ||
+	    !is_passthrough_pmu_enabled(&vmx->vcpu)) {
+		vmentry_ctrl &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		vmexit_ctrl &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		vmexit_ctrl &= ~VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL;
+	}
+
+	if (is_passthrough_pmu_enabled(&vmx->vcpu)) {
+		/*
+		 * Setup auto restore guest PERF_GLOBAL_CTRL MSR at vm entry.
+		 */
+		if (vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
+			vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, 0);
+		else {
+			i = vmx_find_loadstore_msr_slot(&vmx->msr_autoload.guest,
+						       MSR_CORE_PERF_GLOBAL_CTRL);
+			if (i < 0) {
+				i = vmx->msr_autoload.guest.nr++;
+				vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT,
+					     vmx->msr_autoload.guest.nr);
+			}
+			vmx->msr_autoload.guest.val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
+			vmx->msr_autoload.guest.val[i].value = 0;
+		}
+		/*
+		 * Setup auto clear host PERF_GLOBAL_CTRL msr at vm exit.
+		 */
+		if (vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
+			vmcs_write64(HOST_IA32_PERF_GLOBAL_CTRL, 0);
+		else {
+			i = vmx_find_loadstore_msr_slot(&vmx->msr_autoload.host,
+							MSR_CORE_PERF_GLOBAL_CTRL);
+			if (i < 0) {
+				i = vmx->msr_autoload.host.nr++;
+				vmcs_write32(VM_EXIT_MSR_LOAD_COUNT,
+					     vmx->msr_autoload.host.nr);
+			}
+			vmx->msr_autoload.host.val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
+			vmx->msr_autoload.host.val[i].value = 0;
+		}
+		/*
+		 * Setup auto save guest PERF_GLOBAL_CTRL msr at vm exit
+		 */
+		if (!(vmexit_ctrl & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL)) {
+			i = vmx_find_loadstore_msr_slot(&vmx->msr_autostore.guest,
+							MSR_CORE_PERF_GLOBAL_CTRL);
+			if (i < 0) {
+				i = vmx->msr_autostore.guest.nr++;
+				vmcs_write32(VM_EXIT_MSR_STORE_COUNT,
+					     vmx->msr_autostore.guest.nr);
+			}
+			vmx->msr_autostore.guest.val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
+		}
+	}
+
+	vm_entry_controls_set(vmx, vmentry_ctrl);
+	vm_exit_controls_set(vmx, vmexit_ctrl);
+}
+
 static u32 vmx_vmentry_ctrl(void)
 {
 	u32 vmentry_ctrl = vmcs_config.vmentry_ctrl;
@@ -4394,15 +4462,9 @@ static u32 vmx_vmentry_ctrl(void)
 	if (vmx_pt_mode_is_system())
 		vmentry_ctrl &= ~(VM_ENTRY_PT_CONCEAL_PIP |
 				  VM_ENTRY_LOAD_IA32_RTIT_CTL);
-	/*
-	 * IA32e mode, and loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically.
-	 */
-	vmentry_ctrl &= ~(VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
-			  VM_ENTRY_LOAD_IA32_EFER |
-			  VM_ENTRY_IA32E_MODE);
 
-	if (cpu_has_perf_global_ctrl_bug())
-		vmentry_ctrl &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+	/* IA32e mode, and loading of EFER is toggled dynamically. */
+	vmentry_ctrl &= ~(VM_ENTRY_LOAD_IA32_EFER | VM_ENTRY_IA32E_MODE);
 
 	return vmentry_ctrl;
 }
@@ -4422,12 +4484,8 @@ static u32 vmx_vmexit_ctrl(void)
 		vmexit_ctrl &= ~(VM_EXIT_PT_CONCEAL_PIP |
 				 VM_EXIT_CLEAR_IA32_RTIT_CTL);
 
-	if (cpu_has_perf_global_ctrl_bug())
-		vmexit_ctrl &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
-
-	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
-	return vmexit_ctrl &
-		~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER);
+       /* Loading of EFER is toggled dynamically */
+       return vmexit_ctrl & ~VM_EXIT_LOAD_IA32_EFER;
 }
 
 static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
@@ -4765,6 +4823,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write64(VM_FUNCTION_CONTROL, 0);
 
 	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
+	vmcs_write64(VM_EXIT_MSR_STORE_ADDR, __pa(vmx->msr_autostore.guest.val));
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, 0);
 	vmcs_write64(VM_EXIT_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.host.val));
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, 0);
@@ -7822,6 +7881,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	if (is_passthrough_pmu_enabled(&vmx->vcpu))
 		exec_controls_clearbit(vmx, CPU_BASED_RDPMC_EXITING);
 
+	vmx_set_perf_global_ctrl(vmx);
+
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
 }
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c2130d2c8e24..c89db35e1de8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -502,7 +502,8 @@ static inline u8 vmx_get_rvi(void)
 	       VM_EXIT_LOAD_IA32_EFER |					\
 	       VM_EXIT_CLEAR_BNDCFGS |					\
 	       VM_EXIT_PT_CONCEAL_PIP |					\
-	       VM_EXIT_CLEAR_IA32_RTIT_CTL)
+	       VM_EXIT_CLEAR_IA32_RTIT_CTL |                            \
+	       VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL)
 
 #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
 	(PIN_BASED_EXT_INTR_MASK |					\
-- 
2.34.1


