Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856112B4FD9
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388701AbgKPSeM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:34:12 -0500
Received: from mga06.intel.com ([134.134.136.31]:20622 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731805AbgKPS1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:27:54 -0500
IronPort-SDR: NkFAJYqJGm38hFnXsObiDFbYd7Tw1K4f+sq9p1SDxAEJuf83TqtTnrJionPb/0Vmx4KZpoD4+k
 QLK03CYW7IWA==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232409994"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232409994"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:53 -0800
IronPort-SDR: f+6zgaVr9G/MU7uVLgqDXVGz7an/x68J1UTSSZgpO0RIkMhsoYir7xeN4vxwo2Oh/H+4RcWMQ5
 /qDKMWlek9xg==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400527752"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:53 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Zhang Chen <chen.zhang@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 03/67] x86/cpu: Move get_builtin_firmware() common code (from microcode only)
Date:   Mon, 16 Nov 2020 10:25:48 -0800
Message-Id: <46d35ce06d84c55ff02a05610ca3fb6d51ee1a71.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhang Chen <chen.zhang@intel.com>

Move get_builtin_firmware() to common.c so that it can be used to get
non-ucode firmware, e.g. Intel's SEAM modules, even if MICROCODE=n.

Require the consumers to select FW_LOADER, which is already true for
MICROCODE, instead of having dead code that returns false at runtime.

Signed-off-by: Zhang Chen <chen.zhang@intel.com>
Co-developed-by: Kai Huang <kai.huang@linux.intel.com>
Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/cpu.h            |  5 +++++
 arch/x86/include/asm/microcode.h      |  3 ---
 arch/x86/kernel/cpu/common.c          | 20 ++++++++++++++++++++
 arch/x86/kernel/cpu/microcode/core.c  | 18 ------------------
 arch/x86/kernel/cpu/microcode/intel.c |  1 +
 5 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index da78ccbd493b..0096ac7cad0a 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -7,6 +7,7 @@
 #include <linux/topology.h>
 #include <linux/nodemask.h>
 #include <linux/percpu.h>
+#include <linux/earlycpio.h>
 
 #ifdef CONFIG_SMP
 
@@ -37,6 +38,10 @@ extern int _debug_hotplug_cpu(int cpu, int action);
 
 int mwait_usable(const struct cpuinfo_x86 *);
 
+#if defined(CONFIG_MICROCODE) || defined(CONFIG_KVM_INTEL_TDX)
+bool get_builtin_firmware(struct cpio_data *cd, const char *name);
+#endif
+
 unsigned int x86_family(unsigned int sig);
 unsigned int x86_model(unsigned int sig);
 unsigned int x86_stepping(unsigned int sig);
diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 2b7cc5397f80..4f10089f30de 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -131,15 +131,12 @@ int __init microcode_init(void);
 extern void __init load_ucode_bsp(void);
 extern void load_ucode_ap(void);
 void reload_early_microcode(void);
-extern bool get_builtin_firmware(struct cpio_data *cd, const char *name);
 extern bool initrd_gone;
 #else
 static inline int __init microcode_init(void)			{ return 0; };
 static inline void __init load_ucode_bsp(void)			{ }
 static inline void load_ucode_ap(void)				{ }
 static inline void reload_early_microcode(void)			{ }
-static inline bool
-get_builtin_firmware(struct cpio_data *cd, const char *name)	{ return false; }
 #endif
 
 #endif /* _ASM_X86_MICROCODE_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 35ad8480c464..87512c5854bb 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -22,6 +22,7 @@
 #include <linux/io.h>
 #include <linux/syscore_ops.h>
 #include <linux/pgtable.h>
+#include <linux/firmware.h>
 
 #include <asm/cmdline.h>
 #include <asm/stackprotector.h>
@@ -87,6 +88,25 @@ void __init setup_cpu_local_masks(void)
 	alloc_bootmem_cpumask_var(&cpu_sibling_setup_mask);
 }
 
+#if defined(CONFIG_MICROCODE) || defined(CONFIG_KVM_INTEL_TDX)
+extern struct builtin_fw __start_builtin_fw[];
+extern struct builtin_fw __end_builtin_fw[];
+
+bool get_builtin_firmware(struct cpio_data *cd, const char *name)
+{
+	struct builtin_fw *b_fw;
+
+	for (b_fw = __start_builtin_fw; b_fw != __end_builtin_fw; b_fw++) {
+		if (!strcmp(name, b_fw->name)) {
+			cd->size = b_fw->size;
+			cd->data = b_fw->data;
+			return true;
+		}
+	}
+	return false;
+}
+#endif
+
 static void default_init(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index ec6f0415bc6d..f877a9c19f42 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -22,7 +22,6 @@
 #include <linux/syscore_ops.h>
 #include <linux/miscdevice.h>
 #include <linux/capability.h>
-#include <linux/firmware.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
@@ -140,23 +139,6 @@ static bool __init check_loader_disabled_bsp(void)
 	return *res;
 }
 
-extern struct builtin_fw __start_builtin_fw[];
-extern struct builtin_fw __end_builtin_fw[];
-
-bool get_builtin_firmware(struct cpio_data *cd, const char *name)
-{
-	struct builtin_fw *b_fw;
-
-	for (b_fw = __start_builtin_fw; b_fw != __end_builtin_fw; b_fw++) {
-		if (!strcmp(name, b_fw->name)) {
-			cd->size = b_fw->size;
-			cd->data = b_fw->data;
-			return true;
-		}
-	}
-	return false;
-}
-
 void __init load_ucode_bsp(void)
 {
 	unsigned int cpuid_1_eax;
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 6a99535d7f37..50e69d6cb3d9 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -36,6 +36,7 @@
 #include <asm/tlbflush.h>
 #include <asm/setup.h>
 #include <asm/msr.h>
+#include <asm/cpu.h>
 
 static const char ucode_path[] = "kernel/x86/microcode/GenuineIntel.bin";
 
-- 
2.17.1

