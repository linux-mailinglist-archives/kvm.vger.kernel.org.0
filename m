Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239186B6450
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjCLJyt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCLJyq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:46 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE0A37F16
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614871; x=1710150871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cNoWFx8TrJ7UmiR4hV7ITAW/NdzHQpC5Xe8CbDv91tM=;
  b=kzzDilIYy3RnEr07uy+x5YKhUJax477MGoxSpdFr2OCNWsRTvQ9F30QM
   N1RLtmVk5V1swZTY9qafQ7TX13LHstSgjC+69wxSYvmzbX1uOAI8TZX78
   VXGvoHvrdCdDCicrQYhciJTV6Pyrip7umuwac+6UUMHyMpmSUARvi9P4x
   Ed795TzJjw4DuykrcK4OR050eDGhzjWBGV6g6wmfKbof/MeYb4JIN/puq
   1HmMvZ8i8VgOA1UVFcPhqE27KlBbOKYvyRFhiGNtjIeZTjeUr+jwaChTb
   9c7KBDO12zpxbPcP+R6JojBfJ5sHmBmaImhoZehAWjRP8uGkumTyV7xEU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622886"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622886"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852408947"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852408947"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:18 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-2 01/17] pkvm: x86: Introduce CONFIG_PKVM_INTEL
Date:   Mon, 13 Mar 2023 02:00:56 +0800
Message-Id: <20230312180112.1778254-2-jason.cj.chen@intel.com>
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

Add CONFIG_PKVM_INTEL configuration to enable or disable pKVM feature on
x86 platform (starting from Intel platform), and do pkvm_init as
an extension of KVM. Now pkvm_init only reserves memory for pkvm data
structure and does a quick setup for num_cpus.

New pKVM on Intel platform files are placed under arch/x86/kvm/vmx/pkvm.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/include/asm/kvm_host.h      |  1 +
 arch/x86/kvm/Kconfig                 | 13 +++++++++++
 arch/x86/kvm/Makefile                |  1 +
 arch/x86/kvm/vmx/pkvm/Makefile       |  7 ++++++
 arch/x86/kvm/vmx/pkvm/include/pkvm.h | 15 ++++++++++++
 arch/x86/kvm/vmx/pkvm/pkvm_host.c    | 34 ++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c               |  3 +++
 arch/x86/kvm/vmx/vmx.h               |  4 ++++
 arch/x86/kvm/x86.c                   |  5 ++++
 9 files changed, 83 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6aaae18f1854..c3cf849a1370 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1731,6 +1731,7 @@ struct kvm_x86_nested_ops {
 };
 
 struct kvm_x86_init_ops {
+	int (*pkvm_init)(void);
 	int (*cpu_has_kvm_support)(void);
 	int (*disabled_by_bios)(void);
 	int (*check_processor_compatibility)(void);
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index fbeaa9ddef59..5a8ae5f80849 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -87,6 +87,19 @@ config KVM_INTEL
 	  To compile this as a module, choose M here: the module
 	  will be called kvm-intel.
 
+config PKVM_INTEL
+	bool "pKVM for Intel processors support"
+	depends on KVM_INTEL=y
+	depends on X86_64
+	help
+	  Provides support for pKVM on Intel processors.
+
+	  This will deprivilege the host as a VM running in non-root VMX
+	  operation mode, and pKVM hypervisor will run in root VMX
+	  operation mode.
+
+	  If unsure, say N.
+
 config X86_SGX_KVM
 	bool "Software Guard eXtensions (SGX) Virtualization"
 	depends on X86_SGX && KVM_INTEL
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 80e3fe184d17..7fbca5cc7c1d 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -35,6 +35,7 @@ endif
 
 obj-$(CONFIG_KVM)	+= kvm.o
 obj-$(CONFIG_KVM_INTEL)	+= kvm-intel.o
+obj-$(CONFIG_PKVM_INTEL) += vmx/pkvm/
 obj-$(CONFIG_KVM_AMD)	+= kvm-amd.o
 
 AFLAGS_svm/vmenter.o    := -iquote $(obj)
diff --git a/arch/x86/kvm/vmx/pkvm/Makefile b/arch/x86/kvm/vmx/pkvm/Makefile
new file mode 100644
index 000000000000..493bec8501c9
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+
+ccflags-y += -I $(srctree)/arch/x86/kvm/vmx/pkvm/include
+
+pkvm-obj		:= pkvm_host.o
+
+obj-$(CONFIG_PKVM_INTEL)	+= $(pkvm-obj)
diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
new file mode 100644
index 000000000000..3fb76665e785
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+
+#ifndef _PKVM_H_
+#define _PKVM_H_
+
+struct pkvm_hyp {
+	int num_cpus;
+};
+
+#define PKVM_PAGES (ALIGN(sizeof(struct pkvm_hyp), PAGE_SIZE) >> PAGE_SHIFT)
+
+#endif
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
new file mode 100644
index 000000000000..7677df6a2b34
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <pkvm.h>
+
+MODULE_LICENSE("GPL");
+
+static struct pkvm_hyp *pkvm;
+
+static void *pkvm_early_alloc_contig(int pages)
+{
+	return alloc_pages_exact(pages << PAGE_SHIFT, GFP_KERNEL | __GFP_ZERO);
+}
+
+__init int pkvm_init(void)
+{
+	int ret = 0;
+
+	pkvm = pkvm_early_alloc_contig(PKVM_PAGES);
+	if (!pkvm) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	pkvm->num_cpus = num_possible_cpus();
+
+out:
+	return ret;
+}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7eec0226d56a..1e55bde497f8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8467,6 +8467,9 @@ static __init int hardware_setup(void)
 }
 
 static struct kvm_x86_init_ops vmx_init_ops __initdata = {
+#ifdef CONFIG_PKVM_INTEL
+	.pkvm_init = pkvm_init,
+#endif
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
 	.check_processor_compatibility = vmx_check_processor_compat,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a3da84f4ea45..8b2c4f1f4c8e 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -752,4 +752,8 @@ static inline bool guest_cpuid_has_evmcs(struct kvm_vcpu *vcpu)
 	       to_vmx(vcpu)->nested.enlightened_vmcs_enabled;
 }
 
+#ifdef CONFIG_PKVM_INTEL
+int __init pkvm_init(void);
+#endif
+
 #endif /* __KVM_X86_VMX_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a2c299d47e69..84ddeabbf94b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9312,6 +9312,11 @@ int kvm_arch_init(void *opaque)
 		return -EOPNOTSUPP;
 	}
 
+	if (ops->pkvm_init && ops->pkvm_init()) {
+		pr_err_ratelimited("kvm: pkvm init fail\n");
+		return -EOPNOTSUPP;
+	}
+
 	/*
 	 * KVM explicitly assumes that the guest has an FPU and
 	 * FXSAVE/FXRSTOR. For example, the KVM_GET_FPU explicitly casts the
-- 
2.25.1

