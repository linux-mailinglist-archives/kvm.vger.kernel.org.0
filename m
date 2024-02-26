Return-Path: <kvm+bounces-9645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C530866C62
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:35:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FC6E1C21EAC
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2278155C32;
	Mon, 26 Feb 2024 08:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hRetNvSv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4F45467C;
	Mon, 26 Feb 2024 08:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936074; cv=none; b=Tv41SgtyLme1ztiU6fwVCvawETCR2a+9hjPSIaE9MsXTkcHskioRs/uZTGc1x1JbhM43hWOTRR1ehnNnHlaSdtF39fn7JTjaXpQyL1PRd0Du/pf87ED3knfHnnpiXB07C5jj6vpSBWFm9ZVv028g9GmkOk6TxjwMKQ/uOMM3E+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936074; c=relaxed/simple;
	bh=nSKv+OYoU4BrKki36nr1+daFvMh+aOLZupHMr2KpcIc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XpJOAJoLmSscFFipdAdCxSVIcfjfSXTzxfFaty8qUfAByfhOdNszauN5PaTb6lYI4A3i+Q1ZsCSYp4pnQ6feQVOfxNwEd0oISO6l7Z0NqPbckMUXmvKdPWNxmdWfeHwtf5kKCzjYJwvSrJ5wofOUzPx5n+wP3rOp+kc93hBSOV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hRetNvSv; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936072; x=1740472072;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nSKv+OYoU4BrKki36nr1+daFvMh+aOLZupHMr2KpcIc=;
  b=hRetNvSvntCrIuJCDrAC7oirED+4yw9HWMevKYLTtvBMJqgPjUpO+QjL
   WIllc7ChBI0loQUYWq98Onbh3LU/uQ2UwSqyqFZrz4iPSkK8bKQUyQtAy
   HeDi/DaLyBj6+W8YCZJs7FPmPsgUy5TNbYqFM+QROELJDNkjUXG0mqduk
   gsZgMjNLCLLcbibqxcezsI3CoF/fB+gLhJAHq1hVfYPxYnZzTsOHenzML
   bjNc76+HaGqxjl4P+LhLi90LKQ4ngOf5M/rVUR0ixQayHyOq2nZLF3rPW
   41npLHSUMoO+f4widNIov/kNN762jM8dxx8N1XK8QS4vaRHLyn3JKSCob
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="28631528"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="28631528"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6474397"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:50 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 022/130] KVM: x86/vmx: Refactor KVM VMX module init/exit functions
Date: Mon, 26 Feb 2024 00:25:24 -0800
Message-Id: <11d5ae6a1102a50b0e773fc7efd949bb0bd2b776.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Currently, KVM VMX module initialization/exit functions are a single
function each.  Refactor KVM VMX module initialization functions into KVM
common part and VMX part so that TDX specific part can be added cleanly.
Opportunistically refactor module exit function as well.

The current module initialization flow is,
0.) Check if VMX is supported,
1.) hyper-v specific initialization,
2.) system-wide x86 specific and vendor specific initialization,
3.) Final VMX specific system-wide initialization,
4.) calculate the sizes of VMX kvm structure and VMX vcpu structure,
5.) report those sizes to the KVM common layer and KVM common
    initialization

Refactor the KVM VMX module initialization function into functions with a
wrapper function to separate VMX logic in vmx.c from a file, main.c, common
among VMX and TDX.  Introduce a wrapper function for vmx_init().

The KVM architecture common layer allocates struct kvm with reported size
for architecture-specific code.  The KVM VMX module defines its structure
as struct vmx_kvm { struct kvm; VMX specific members;} and uses it as
struct vmx kvm.  Similar for vcpu structure. TDX KVM patches will define
TDX specific kvm and vcpu structures.

The current module exit function is also a single function, a combination
of VMX specific logic and common KVM logic.  Refactor it into VMX specific
logic and KVM common logic.  This is just refactoring to keep the VMX
specific logic in vmx.c from main.c.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v19:
- Eliminate the unnecessary churn with vmx_hardware_setup() by Xiaoyao

v18:
- Move loaded_vmcss_on_cpu initialization to vt_init() before
  kvm_x86_vendor_init().
- added __init to an empty stub fucntion, hv_init_evmcs().

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 54 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c     | 60 +++++---------------------------------
 arch/x86/kvm/vmx/x86_ops.h | 14 +++++++++
 3 files changed, 75 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index eeb7a43b271d..18cecf12c7c8 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -167,3 +167,57 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
 	.runtime_ops = &vt_x86_ops,
 	.pmu_ops = &intel_pmu_ops,
 };
+
+static int __init vt_init(void)
+{
+	unsigned int vcpu_size, vcpu_align;
+	int cpu, r;
+
+	if (!kvm_is_vmx_supported())
+		return -EOPNOTSUPP;
+
+	/*
+	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
+	 * to unwind if a later step fails.
+	 */
+	hv_init_evmcs();
+
+	/* vmx_hardware_disable() accesses loaded_vmcss_on_cpu. */
+	for_each_possible_cpu(cpu)
+		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
+
+	r = kvm_x86_vendor_init(&vt_init_ops);
+	if (r)
+		return r;
+
+	r = vmx_init();
+	if (r)
+		goto err_vmx_init;
+
+	/*
+	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
+	 * exposed to userspace!
+	 */
+	vcpu_size = sizeof(struct vcpu_vmx);
+	vcpu_align = __alignof__(struct vcpu_vmx);
+	r = kvm_init(vcpu_size, vcpu_align, THIS_MODULE);
+	if (r)
+		goto err_kvm_init;
+
+	return 0;
+
+err_kvm_init:
+	vmx_exit();
+err_vmx_init:
+	kvm_x86_vendor_exit();
+	return r;
+}
+module_init(vt_init);
+
+static void vt_exit(void)
+{
+	kvm_exit();
+	kvm_x86_vendor_exit();
+	vmx_exit();
+}
+module_exit(vt_exit);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8af0668e4dca..2fb1cd2e28a2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -477,7 +477,7 @@ DEFINE_PER_CPU(struct vmcs *, current_vmcs);
  * We maintain a per-CPU linked-list of VMCS loaded on that CPU. This is needed
  * when a CPU is brought down, and we need to VMCLEAR all VMCSs loaded on it.
  */
-static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
+DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
 
 static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
 static DEFINE_SPINLOCK(vmx_vpid_lock);
@@ -537,7 +537,7 @@ static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static __init void hv_init_evmcs(void)
+__init void hv_init_evmcs(void)
 {
 	int cpu;
 
@@ -573,7 +573,7 @@ static __init void hv_init_evmcs(void)
 	}
 }
 
-static void hv_reset_evmcs(void)
+void hv_reset_evmcs(void)
 {
 	struct hv_vp_assist_page *vp_ap;
 
@@ -597,10 +597,6 @@ static void hv_reset_evmcs(void)
 	vp_ap->current_nested_vmcs = 0;
 	vp_ap->enlighten_vmentry = 0;
 }
-
-#else /* IS_ENABLED(CONFIG_HYPERV) */
-static void hv_init_evmcs(void) {}
-static void hv_reset_evmcs(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 /*
@@ -2743,7 +2739,7 @@ static bool __kvm_is_vmx_supported(void)
 	return true;
 }
 
-static bool kvm_is_vmx_supported(void)
+bool kvm_is_vmx_supported(void)
 {
 	bool supported;
 
@@ -8508,7 +8504,7 @@ static void vmx_cleanup_l1d_flush(void)
 	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
 }
 
-static void __vmx_exit(void)
+void vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
@@ -8517,36 +8513,10 @@ static void __vmx_exit(void)
 	vmx_cleanup_l1d_flush();
 }
 
-static void vmx_exit(void)
-{
-	kvm_exit();
-	kvm_x86_vendor_exit();
-
-	__vmx_exit();
-}
-module_exit(vmx_exit);
-
-static int __init vmx_init(void)
+int __init vmx_init(void)
 {
 	int r, cpu;
 
-	if (!kvm_is_vmx_supported())
-		return -EOPNOTSUPP;
-
-	/*
-	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
-	 * to unwind if a later step fails.
-	 */
-	hv_init_evmcs();
-
-	/* vmx_hardware_disable() accesses loaded_vmcss_on_cpu. */
-	for_each_possible_cpu(cpu)
-		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
-
-	r = kvm_x86_vendor_init(&vt_init_ops);
-	if (r)
-		return r;
-
 	/*
 	 * Must be called after common x86 init so enable_ept is properly set
 	 * up. Hand the parameter mitigation value in which was stored in
@@ -8556,7 +8526,7 @@ static int __init vmx_init(void)
 	 */
 	r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
 	if (r)
-		goto err_l1d_flush;
+		return r;
 
 	for_each_possible_cpu(cpu)
 		pi_init_cpu(cpu);
@@ -8573,21 +8543,5 @@ static int __init vmx_init(void)
 	if (!enable_ept)
 		allow_smaller_maxphyaddr = true;
 
-	/*
-	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
-	 * exposed to userspace!
-	 */
-	r = kvm_init(sizeof(struct vcpu_vmx), __alignof__(struct vcpu_vmx),
-		     THIS_MODULE);
-	if (r)
-		goto err_kvm_init;
-
 	return 0;
-
-err_kvm_init:
-	__vmx_exit();
-err_l1d_flush:
-	kvm_x86_vendor_exit();
-	return r;
 }
-module_init(vmx_init);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 2f8b6c43fe0f..b936388853ab 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -6,6 +6,20 @@
 
 #include "x86.h"
 
+#if IS_ENABLED(CONFIG_HYPERV)
+__init void hv_init_evmcs(void);
+void hv_reset_evmcs(void);
+#else /* IS_ENABLED(CONFIG_HYPERV) */
+static inline __init void hv_init_evmcs(void) {}
+static inline void hv_reset_evmcs(void) {}
+#endif /* IS_ENABLED(CONFIG_HYPERV) */
+
+DECLARE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
+
+bool kvm_is_vmx_supported(void);
+int __init vmx_init(void);
+void vmx_exit(void);
+
 extern struct kvm_x86_ops vt_x86_ops __initdata;
 extern struct kvm_x86_init_ops vt_init_ops __initdata;
 
-- 
2.25.1


