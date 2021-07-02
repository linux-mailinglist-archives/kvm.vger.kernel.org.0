Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04B73BA55D
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbhGBWH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:07:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:51166 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232991AbhGBWHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:07:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="195951886"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="195951886"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:20 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814689"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:20 -0700
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v2 07/69] KVM: TDX: define and export helper functions for KVM TDX support
Date:   Fri,  2 Jul 2021 15:04:13 -0700
Message-Id: <4fe4ce4faf5ad117f81d411deb00ef3b9657c842.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

NOTE: This is to make this patch series compile.  other patch series that
loads/initializes TDX module will replace this patch.

Define and export four helper functions commly used for for KVM TDX support
and SEAMLDR.  tdx_get_sysinfo(), tdx_seamcall_on_each_pkg(),
tdx_keyid_alloc() and tdx_keyid_free().  The SEAMLDR logic will initializes
at boot phase and KVM TDX will use those function to get system info,
operation of package wide resource and, alloc/free tdx private key ID.

Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/Kbuild                     |   1 +
 arch/x86/include/asm/cpufeatures.h  |   2 +
 arch/x86/include/asm/kvm_boot.h     |  30 +++++
 arch/x86/kvm/boot/Makefile          |   6 +
 arch/x86/kvm/boot/seam/tdx_common.c | 167 ++++++++++++++++++++++++++++
 arch/x86/kvm/boot/seam/tdx_common.h |  13 +++
 6 files changed, 219 insertions(+)
 create mode 100644 arch/x86/include/asm/kvm_boot.h
 create mode 100644 arch/x86/kvm/boot/Makefile
 create mode 100644 arch/x86/kvm/boot/seam/tdx_common.c
 create mode 100644 arch/x86/kvm/boot/seam/tdx_common.h

diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
index 30dec019756b..4f35eaad7468 100644
--- a/arch/x86/Kbuild
+++ b/arch/x86/Kbuild
@@ -4,6 +4,7 @@ obj-y += entry/
 obj-$(CONFIG_PERF_EVENTS) += events/
 
 obj-$(CONFIG_KVM) += kvm/
+obj-$(subst m,y,$(CONFIG_KVM)) += kvm/boot/
 
 # Xen paravirtualization support
 obj-$(CONFIG_XEN) += xen/
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index ac37830ae941..fe5cfc013444 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -230,6 +230,8 @@
 #define X86_FEATURE_FLEXPRIORITY	( 8*32+ 2) /* Intel FlexPriority */
 #define X86_FEATURE_EPT			( 8*32+ 3) /* Intel Extended Page Table */
 #define X86_FEATURE_VPID		( 8*32+ 4) /* Intel Virtual Processor ID */
+#define X86_FEATURE_SEAM		( 8*32+ 5) /* "" Secure Arbitration Mode */
+#define X86_FEATURE_TDX			( 8*32+ 6) /* Intel Trusted Domain eXtensions */
 
 #define X86_FEATURE_VMMCALL		( 8*32+15) /* Prefer VMMCALL to VMCALL */
 #define X86_FEATURE_XENPV		( 8*32+16) /* "" Xen paravirtual guest */
diff --git a/arch/x86/include/asm/kvm_boot.h b/arch/x86/include/asm/kvm_boot.h
new file mode 100644
index 000000000000..3d58d4109566
--- /dev/null
+++ b/arch/x86/include/asm/kvm_boot.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASM_X86_KVM_BOOT_H
+#define _ASM_X86_KVM_BOOT_H
+
+#include <linux/cpumask.h>
+#include <linux/mutex.h>
+#include <linux/smp.h>
+#include <linux/types.h>
+#include <asm/processor.h>
+
+#ifdef CONFIG_KVM_INTEL_TDX
+
+/*
+ * Return pointer to TDX system info (TDSYSINFO_STRUCT) if TDX has been
+ * successfully initialized, or NULL.
+ */
+struct tdsysinfo_struct;
+const struct tdsysinfo_struct *tdx_get_sysinfo(void);
+
+extern u32 tdx_seam_keyid __ro_after_init;
+
+int tdx_seamcall_on_each_pkg(int (*fn)(void *), void *param);
+
+/* TDX keyID allocation functions */
+extern int tdx_keyid_alloc(void);
+extern void tdx_keyid_free(int keyid);
+
+#endif
+
+#endif /* _ASM_X86_KVM_BOOT_H */
diff --git a/arch/x86/kvm/boot/Makefile b/arch/x86/kvm/boot/Makefile
new file mode 100644
index 000000000000..a85eb5af90d5
--- /dev/null
+++ b/arch/x86/kvm/boot/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+
+asflags-y += -I$(srctree)/arch/x86/kvm
+ccflags-y += -I$(srctree)/arch/x86/kvm
+
+obj-$(CONFIG_KVM_INTEL_TDX) += seam/tdx_common.o
diff --git a/arch/x86/kvm/boot/seam/tdx_common.c b/arch/x86/kvm/boot/seam/tdx_common.c
new file mode 100644
index 000000000000..d803dbd11693
--- /dev/null
+++ b/arch/x86/kvm/boot/seam/tdx_common.c
@@ -0,0 +1,167 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Common functions/symbols for SEAMLDR and KVM. */
+
+#include <linux/cpuhotplug.h>
+#include <linux/slab.h>
+#include <linux/cpu.h>
+#include <linux/idr.h>
+
+#include <asm/kvm_boot.h>
+
+#include "vmx/tdx_arch.h"
+
+/*
+ * TDX system information returned by TDSYSINFO.
+ */
+struct tdsysinfo_struct tdx_tdsysinfo;
+
+/* KeyID range reserved to TDX by BIOS */
+u32 tdx_keyids_start;
+u32 tdx_nr_keyids;
+
+u32 tdx_seam_keyid __ro_after_init;
+EXPORT_SYMBOL_GPL(tdx_seam_keyid);
+
+/* TDX keyID pool */
+static DEFINE_IDA(tdx_keyid_pool);
+
+static int *tdx_package_masters __ro_after_init;
+
+static int tdx_starting_cpu(unsigned int cpu)
+{
+	int pkg = topology_physical_package_id(cpu);
+
+	/*
+	 * If this package doesn't have a master CPU for IPI operation, use this
+	 * CPU as package master.
+	 */
+	if (tdx_package_masters && tdx_package_masters[pkg] == -1)
+		tdx_package_masters[pkg] = cpu;
+
+	return 0;
+}
+
+static int tdx_dying_cpu(unsigned int cpu)
+{
+	int pkg = topology_physical_package_id(cpu);
+	int other;
+
+	if (!tdx_package_masters || tdx_package_masters[pkg] != cpu)
+		return 0;
+
+	/*
+	 * If offlining cpu was used as package master, find other online cpu on
+	 * this package.
+	 */
+	tdx_package_masters[pkg] = -1;
+	for_each_online_cpu(other) {
+		if (other == cpu)
+			continue;
+		if (topology_physical_package_id(other) != pkg)
+			continue;
+
+		tdx_package_masters[pkg] = other;
+		break;
+	}
+
+	return 0;
+}
+
+/*
+ * Setup one-cpu-per-pkg array to do package-scoped SEAMCALLs. The array is
+ * only necessary if there are multiple packages.
+ */
+int __init init_package_masters(void)
+{
+	int cpu, pkg, nr_filled, nr_pkgs;
+
+	nr_pkgs = topology_max_packages();
+	if (nr_pkgs == 1)
+		return 0;
+
+	tdx_package_masters = kcalloc(nr_pkgs, sizeof(int), GFP_KERNEL);
+	if (!tdx_package_masters)
+		return -ENOMEM;
+
+	memset(tdx_package_masters, -1, nr_pkgs * sizeof(int));
+
+	nr_filled = 0;
+	for_each_online_cpu(cpu) {
+		pkg = topology_physical_package_id(cpu);
+		if (tdx_package_masters[pkg] >= 0)
+			continue;
+
+		tdx_package_masters[pkg] = cpu;
+		if (++nr_filled == topology_max_packages())
+			break;
+	}
+
+	if (WARN_ON(nr_filled != topology_max_packages())) {
+		kfree(tdx_package_masters);
+		return -EIO;
+	}
+
+	if (cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN, "tdx/cpu:starting",
+				      tdx_starting_cpu, tdx_dying_cpu) < 0) {
+		kfree(tdx_package_masters);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+int tdx_seamcall_on_each_pkg(int (*fn)(void *), void *param)
+{
+	int ret = 0;
+	int i;
+
+	cpus_read_lock();
+	if (!tdx_package_masters) {
+		ret = fn(param);
+		goto out;
+	}
+
+	for (i = 0; i < topology_max_packages(); i++) {
+		ret = smp_call_on_cpu(tdx_package_masters[i], fn, param, 1);
+		if (ret)
+			break;
+	}
+
+out:
+	cpus_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdx_seamcall_on_each_pkg);
+
+const struct tdsysinfo_struct *tdx_get_sysinfo(void)
+{
+	if (boot_cpu_has(X86_FEATURE_TDX))
+		return &tdx_tdsysinfo;
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(tdx_get_sysinfo);
+
+int tdx_keyid_alloc(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_TDX))
+		return -EINVAL;
+
+	if (WARN_ON_ONCE(!tdx_keyids_start || !tdx_nr_keyids))
+		return -EINVAL;
+
+	/* The first keyID is reserved for the global key. */
+	return ida_alloc_range(&tdx_keyid_pool, tdx_keyids_start + 1,
+			       tdx_keyids_start + tdx_nr_keyids - 1,
+			       GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(tdx_keyid_alloc);
+
+void tdx_keyid_free(int keyid)
+{
+	if (!keyid || keyid < 0)
+		return;
+
+	ida_free(&tdx_keyid_pool, keyid);
+}
+EXPORT_SYMBOL_GPL(tdx_keyid_free);
diff --git a/arch/x86/kvm/boot/seam/tdx_common.h b/arch/x86/kvm/boot/seam/tdx_common.h
new file mode 100644
index 000000000000..6f94ebb2b815
--- /dev/null
+++ b/arch/x86/kvm/boot/seam/tdx_common.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* common functions/symbols used by SEAMLDR and KVM */
+
+#ifndef __BOOT_SEAM_TDX_COMMON_H
+#define __BOOT_SEAM_TDX_COMMON_H
+
+extern struct tdsysinfo_struct tdx_tdsysinfo;
+extern u32 tdx_keyids_start;
+extern u32 tdx_nr_keyids;
+
+int __init init_package_masters(void);
+
+#endif /* __BOOT_SEAM_TDX_COMMON_H */
-- 
2.25.1

