Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C6655D40F
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241386AbiF0VzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241228AbiF0Vyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:54:50 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD8D62C7;
        Mon, 27 Jun 2022 14:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366889; x=1687902889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0dYmGScSKhYXKMx4oRdqx+V4rlOSAvkLGzhQ2z3VU6g=;
  b=I28mFy19/HXhEjjGrM7TDsl55EY+mNyjVIpr9nHIpwJ9wBtd3wBMEKVA
   AVyaouSJ4fAz4Z17gFEiqLRjltVx4QZ7ZO6ZF82s4TlstShfTGntkYtpd
   dpjcyjIpknBXEuD4gNbFEIeTpxEcr5+rG6abTiTL2tLcwp9dxXOyVFBDQ
   GscOHq1firnvqt/OwIqkifQ7DCzAc4wpCnh/dLn/gt9Xt6f9TnIYEWjYn
   KdrKU7u9DL7UIjdWgFsrr4IaC5XP5YRtZz5EECb8gGuP91oGTVDXZxFQD
   Vldjph10Eqb+1/umze6a0lRL7exLIcPhPLMXhCIJB9KDuALh8CRGcPnLu
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="261983017"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="261983017"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:48 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863446"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:48 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 006/102] KVM: TDX: Detect CPU feature on kernel module initialization
Date:   Mon, 27 Jun 2022 14:52:58 -0700
Message-Id: <85209122d5af1a3185ff58d13528284d91035100.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
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

TDX requires several initialization steps for KVM to create guest TDs.
Detect CPU feature, enable VMX (TDX is based on VMX), detect TDX module
availability, and initialize TDX module.  This patch implements the first
step to detect CPU feature.  Because VMX isn't enabled yet by VMXON
instruction on KVM kernel module initialization, defer further
initialization step until VMX is enabled by hardware_enable callback.

Introduce a module parameter, enable_tdx, to explicitly enable TDX KVM
support.  It's off by default to keep same behavior for those who don't use
TDX.  Implement CPU feature detection at KVM kernel module initialization
as hardware_setup callback to check if CPU feature is available and get
some CPU parameters.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Makefile      |  1 +
 arch/x86/kvm/vmx/main.c    | 18 ++++++++++++++++-
 arch/x86/kvm/vmx/tdx.c     | 40 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  6 ++++++
 4 files changed, 64 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/vmx/tdx.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index ee4d0999f20f..e2c05195cb95 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -24,6 +24,7 @@ kvm-$(CONFIG_KVM_XEN)	+= xen.o
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o vmx/main.o
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
+kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
 
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 636768f5b985..fabf5f22c94f 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -6,6 +6,22 @@
 #include "nested.h"
 #include "pmu.h"
 
+static bool __read_mostly enable_tdx = IS_ENABLED(CONFIG_INTEL_TDX_HOST);
+module_param_named(tdx, enable_tdx, bool, 0444);
+
+static __init int vt_hardware_setup(void)
+{
+	int ret;
+
+	ret = vmx_hardware_setup();
+	if (ret)
+		return ret;
+
+	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
+
+	return 0;
+}
+
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -147,7 +163,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 struct kvm_x86_init_ops vt_init_ops __initdata = {
 	.cpu_has_kvm_support = vmx_cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
-	.hardware_setup = vmx_hardware_setup,
+	.hardware_setup = vt_hardware_setup,
 	.handle_intel_pt_intr = NULL,
 
 	.runtime_ops = &vt_x86_ops,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
new file mode 100644
index 000000000000..c12e61cdddea
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/cpu.h>
+
+#include <asm/tdx.h>
+
+#include "capabilities.h"
+#include "x86_ops.h"
+
+#undef pr_fmt
+#define pr_fmt(fmt) "tdx: " fmt
+
+static u64 hkid_mask __ro_after_init;
+static u8 hkid_start_pos __ro_after_init;
+
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
+{
+	u32 max_pa;
+
+	if (!enable_ept) {
+		pr_warn("Cannot enable TDX with EPT disabled\n");
+		return -EINVAL;
+	}
+
+	if (!platform_tdx_enabled()) {
+		pr_warn("Cannot enable TDX on TDX disabled platform\n");
+		return -ENODEV;
+	}
+
+	/* Safe guard check because TDX overrides tlb_remote_flush callback. */
+	if (WARN_ON_ONCE(x86_ops->tlb_remote_flush))
+		return -EIO;
+
+	max_pa = cpuid_eax(0x80000008) & 0xff;
+	hkid_start_pos = boot_cpu_data.x86_phys_bits;
+	hkid_mask = GENMASK_ULL(max_pa - 1, hkid_start_pos);
+	pr_info("kvm: TDX is supported. hkid start pos %d mask 0x%llx\n",
+		hkid_start_pos, hkid_mask);
+
+	return 0;
+}
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 0f8a8547958f..0a5967a91e26 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -122,4 +122,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 #endif
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_INTEL_TDX_HOST
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
+#else
+static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
+#endif
+
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1

