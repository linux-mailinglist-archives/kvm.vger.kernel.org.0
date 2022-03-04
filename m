Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA384CDDEC
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiCDUGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiCDUGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:06:03 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58087673E7;
        Fri,  4 Mar 2022 12:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424062; x=1677960062;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5JNuowlQDCbpp0wHYAqtnMb6w2fOXVXxSPQJpPL0icg=;
  b=AI/551OfF6XPrQu3TDcYsiCd4eXdJUtgKirO0MWRV/XBrITeTi/GbB8o
   cKnQOJJlAI/pRQwhewXi7u9kpan2RgZzy0WqZgc22NTX9xZN8ifMoRGEG
   9OTiRyazODLEiVBiYoV6IZMmMtHV7Ni8himi3L+5P+k4Icpbw8CyjLD+U
   DZEvHr5ZQQQ2XX1otH0tGhmHuSJXLb12MWs3K5yU1PVFhnI72UB5hjbYv
   OFzB9CdcTBYHyHYtvlfHbUfeVQ623Q0D9/948UDi9sUwI2OijBxy7jkD2
   /cct48hrvgwLezhEPSvO91KmJA7XqFGS/hTwr2NP5jsIm2DhaugmSccit
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983317"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983317"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:06 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344123"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:05 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 010/104] KVM: TDX: Make TDX VM type supported
Date:   Fri,  4 Mar 2022 11:48:26 -0800
Message-Id: <0596db2913da40660e87d5005167c623cee14765.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

As first step TDX VM support, return that TDX VM type supported to device
model, e.g. qemu.  The callback to create guest TD is vm_init callback for
KVM_CREATE_VM.  Add a place holder function and call a function to
initialize TDX module on demand because in that callback VMX is enabled by
hardware_enable callback (vmx_hardware_enable).

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 24 ++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c     |  5 +++++
 arch/x86/kvm/vmx/vmx.c     |  5 -----
 arch/x86/kvm/vmx/x86_ops.h |  3 ++-
 4 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 77da926ee505..8103d1c32cc9 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -5,6 +5,12 @@
 #include "vmx.h"
 #include "nested.h"
 #include "pmu.h"
+#include "tdx.h"
+
+static bool vt_is_vm_type_supported(unsigned long type)
+{
+	return type == KVM_X86_DEFAULT_VM || tdx_is_vm_type_supported(type);
+}
 
 static __init int vt_hardware_setup(void)
 {
@@ -19,6 +25,20 @@ static __init int vt_hardware_setup(void)
 	return 0;
 }
 
+static int vt_vm_init(struct kvm *kvm)
+{
+	int ret;
+
+	if (is_td(kvm)) {
+		ret = tdx_module_setup();
+		if (ret)
+			return ret;
+		return -EOPNOTSUPP;	/* Not ready to create guest TD yet. */
+	}
+
+	return vmx_vm_init(kvm);
+}
+
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -29,9 +49,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.cpu_has_accelerated_tpr = report_flexpriority,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
-	.is_vm_type_supported = vmx_is_vm_type_supported,
+	.is_vm_type_supported = vt_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_vmx),
-	.vm_init = vmx_vm_init,
+	.vm_init = vt_vm_init,
 
 	.vcpu_create = vmx_vcpu_create,
 	.vcpu_free = vmx_vcpu_free,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8adc87ad1807..e8d293a3c11c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -105,6 +105,11 @@ int tdx_module_setup(void)
 	return ret;
 }
 
+bool tdx_is_vm_type_supported(unsigned long type)
+{
+	return type == KVM_X86_TDX_VM && READ_ONCE(enable_tdx);
+}
+
 static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 {
 	u32 max_pa;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3c7b3f245fee..7838cd177f0e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7079,11 +7079,6 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	return err;
 }
 
-bool vmx_is_vm_type_supported(unsigned long type)
-{
-	return type == KVM_X86_DEFAULT_VM;
-}
-
 #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index f7327bc73be0..78331dbc29f7 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -25,7 +25,6 @@ void vmx_hardware_unsetup(void);
 int vmx_hardware_enable(void);
 void vmx_hardware_disable(void);
 bool report_flexpriority(void);
-bool vmx_is_vm_type_supported(unsigned long type);
 int vmx_vm_init(struct kvm *kvm);
 int vmx_vcpu_create(struct kvm_vcpu *vcpu);
 int vmx_vcpu_pre_run(struct kvm_vcpu *vcpu);
@@ -130,10 +129,12 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_INTEL_TDX_HOST
 void __init tdx_pre_kvm_init(unsigned int *vcpu_size,
 			unsigned int *vcpu_align, unsigned int *vm_size);
+bool tdx_is_vm_type_supported(unsigned long type);
 void __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 #else
 static inline void tdx_pre_kvm_init(
 	unsigned int *vcpu_size, unsigned int *vcpu_align, unsigned int *vm_size) {}
+static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 static inline void tdx_hardware_setup(struct kvm_x86_ops *x86_ops) {}
 #endif
 
-- 
2.25.1

