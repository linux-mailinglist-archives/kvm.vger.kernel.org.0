Return-Path: <kvm+bounces-6579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60E9C8377E8
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:56:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85CCB1C2359F
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 23:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AB7750267;
	Mon, 22 Jan 2024 23:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="STMv2u9v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79994F213;
	Mon, 22 Jan 2024 23:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967697; cv=none; b=EZM5sTU3rBBy9h0IZXUU5+EIpu0OGPdqdrjFhJF2OItZ/AqZYWiIMJeMYDGy9+327fC98MDCOjgZSsJ0mm1l9a1ZKh+AsZGWzqeBlD3kcz9H6jpjQyYuoF82lH6kqcvTyPDle0KT0HOhTfNlD13cIQRltqJw3OzBwzdbAE6WDbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967697; c=relaxed/simple;
	bh=zNBcvMZTe+nGx93x4rakWvAJeVopZOX6ddf47T0bK9Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lLjxPEj6Om1eKsSD2nKYYfmF+yVTw15rTGBYkMsP/uI/vbc29m060hKhjKZuLj13AUirr0D4j93225rL0Q49xTJYsc3ElY5X+ivhrkMNdcU17hq7GwGa1eJLh7W2QcIogy1u7GJjZhwXriyV3C37iWKL9HqDSUY+rD3mf15C7zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=STMv2u9v; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967696; x=1737503696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zNBcvMZTe+nGx93x4rakWvAJeVopZOX6ddf47T0bK9Y=;
  b=STMv2u9v50SitdEkiw+yU0WSqxx2JvTPZSXBdCEr01dR//MjgqDReZyE
   w528nTqiDjz9uzmNhvGeMOHpU2qHDmCsmg77/3+NM6sqRH6LrQWkNve4/
   uC96R9ErdcItGaE/lee1BL1G9/PvYKrAPLJnlU1H+ax4xUevVO2uGcEjF
   G3yIbBaQwK/eYhU/5z4zLHiECDeKMbifD9x0jr7+NfYB4ral22dqFviWq
   t7RhsaHypD0H6SbNsvPX3LI7ksEj4zNxvg8F32fYOXbBRdPG4X1+BDOBK
   d3RH7pZjQT9nJc/ykB40RNo/6bEgI/T3x2NhIcqRiPHi0oSyjydRDjkht
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1217821"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1217821"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:54:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1350126"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:54:54 -0800
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
Subject: [PATCH v18 006/121] KVM: x86/vmx: Refactor KVM VMX module init/exit functions
Date: Mon, 22 Jan 2024 15:52:42 -0800
Message-Id: <f6c59ec1b4822263fc946b7d53a83f3b5ba59261.1705965634.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
v18:
- Move loaded_vmcss_on_cpu initialization to vt_init() before
  kvm_x86_vendor_init().
- added __init to an empty stub fucntion, hv_init_evmcs().
---
 arch/x86/kvm/vmx/main.c    | 54 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c     | 60 +++++---------------------------------
 arch/x86/kvm/vmx/x86_ops.h | 15 +++++++++-
 3 files changed, 75 insertions(+), 54 deletions(-)

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
index 77011799b1f4..8efb956591d5 100644
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
index b6836bedc4d3..b936388853ab 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -6,11 +6,24 @@
 
 #include "x86.h"
 
-__init int vmx_hardware_setup(void);
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
 
 extern struct kvm_x86_ops vt_x86_ops __initdata;
 extern struct kvm_x86_init_ops vt_init_ops __initdata;
 
+__init int vmx_hardware_setup(void);
 void vmx_hardware_unsetup(void);
 int vmx_check_processor_compat(void);
 int vmx_hardware_enable(void);
-- 
2.25.1


