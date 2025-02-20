Return-Path: <kvm+bounces-38741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DDEFEA3E1EB
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:12:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A185188DCDE
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B264D2185B1;
	Thu, 20 Feb 2025 17:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YsMIij+t"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2518217707
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740071197; cv=none; b=daxZ3PPI7xCyOX6jFWwQ8ZAPHDGWWLSczEnGVmcKoLWzNlpeaoxrwnWhVZPnk04ahQ/CIkeRlCutm8nY48p4hyPqU4BW2G9oOhzFa25CFBNs5WleT3xS1ooIxW41OdIy++KDhd6elbyp8gg9fy7Yq5EGeeo4X1YFv+1iw/Jt7yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740071197; c=relaxed/simple;
	bh=GPXl415FM6J1pzh7uDDHxyS5XkBrQQGcgJ7b35KNxNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CTpWecv76PCOlaywxdqn+Ugwj0B07ZjOnhg27MWgDy5Jj2wf/eTjA+gmP01Y91ikhsYch7/zJyYcoYO2W3ar0IviG8PAh6kMwlhGuYOIzGoerDPT0uWpyP+HhU4CgSHuGe+4/kHciATzJZfrYfSwiokxSU/3Lmn0UR1D2j8xUKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YsMIij+t; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740071194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tycj0fO2fWePCC4bBBgnozZwpZn7IjOBveqRgM6PkYQ=;
	b=YsMIij+tddGU+jzNhz7C8UFKHLeazDwzyu5lNZc6yriAbu8cT0DAy7kL5ZUuIckFA4uB9p
	y+HXrm6Owb5bA+3azaVz0LHpJEb5N801PeZb82wnwLCzS6eRuciLM/jOw2J6wFxGw0B1Ra
	wdBNADk1cc2Nmg5JNW/JdBCCDCqUoHo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-5-94aRXSPPO_ulyQzndo38ng-1; Thu,
 20 Feb 2025 12:06:31 -0500
X-MC-Unique: 94aRXSPPO_ulyQzndo38ng-1
X-Mimecast-MFC-AGG-ID: 94aRXSPPO_ulyQzndo38ng_1740071185
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F46E1800983;
	Thu, 20 Feb 2025 17:06:25 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 79BDA1800359;
	Thu, 20 Feb 2025 17:06:24 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 12/30] KVM: VMX: Initialize TDX during KVM module load
Date: Thu, 20 Feb 2025 12:05:46 -0500
Message-ID: <20250220170604.2279312-13-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-1-pbonzini@redhat.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Kai Huang <kai.huang@intel.com>

Before KVM can use TDX to create and run TDX guests, TDX needs to be
initialized from two perspectives: 1) TDX module must be initialized
properly to a working state; 2) A per-cpu TDX initialization, a.k.a the
TDH.SYS.LP.INIT SEAMCALL must be done on any logical cpu before it can
run any other TDX SEAMCALLs.

The TDX host core-kernel provides two functions to do the above two
respectively: tdx_enable() and tdx_cpu_enable().

There are two options in terms of when to initialize TDX: initialize TDX
at KVM module loading time, or when creating the first TDX guest.

Choose to initialize TDX during KVM module loading time:

Initializing TDX module is both memory and CPU time consuming: 1) the
kernel needs to allocate a non-trivial size(~1/256) of system memory
as metadata used by TDX module to track each TDX-usable memory page's
status; 2) the TDX module needs to initialize this metadata, one entry
for each TDX-usable memory page.

Also, the kernel uses alloc_contig_pages() to allocate those metadata
chunks, because they are large and need to be physically contiguous.
alloc_contig_pages() can fail.  If initializing TDX when creating the
first TDX guest, then there's chance that KVM won't be able to run any
TDX guests albeit KVM _declares_ to be able to support TDX.

This isn't good for the user.

On the other hand, initializing TDX at KVM module loading time can make
sure KVM is providing a consistent view of whether KVM can support TDX
to the user.

Always only try to initialize TDX after VMX has been initialized.  TDX
is based on VMX, and if VMX fails to initialize then TDX is likely to be
broken anyway.  Also, in practice, supporting TDX will require part of
VMX and common x86 infrastructure in working order, so TDX cannot be
enabled alone w/o VMX support.

There are two cases that can result in failure to initialize TDX: 1) TDX
cannot be supported (e.g., because of TDX is not supported or enabled by
hardware, or module is not loaded, or missing some dependency in KVM's
configuration); 2) Any unexpected error during TDX bring-up.  For the
first case only mark TDX is disabled but still allow KVM module to be
loaded.  For the second case just fail to load the KVM module so that
the user can be aware.

Because TDX costs additional memory, don't enable TDX by default.  Add a
new module parameter 'enable_tdx' to allow the user to opt-in.

Note, the name tdx_init() has already been taken by the early boot code.
Use tdx_bringup() for initializing TDX (and tdx_cleanup() since KVM
doesn't actually teardown TDX).  They don't match vt_init()/vt_exit(),
vmx_init()/vmx_exit() etc but it's not end of the world.

Also, once initialized, the TDX module cannot be disabled and enabled
again w/o the TDX module runtime update, which isn't supported by the
kernel.  After TDX is enabled, nothing needs to be done when KVM
disables hardware virtualization, e.g., when offlining CPU, or during
suspend/resume.  TDX host core-kernel code internally tracks TDX status
and can handle "multiple enabling" scenario.

Similar to KVM_AMD_SEV, add a new KVM_INTEL_TDX Kconfig to guide KVM TDX
code.  Make it depend on INTEL_TDX_HOST but not replace INTEL_TDX_HOST
because in the longer term there's a use case that requires making
SEAMCALLs w/o KVM as mentioned by Dan [1].

Link: https://lore.kernel.org/6723fc2070a96_60c3294dc@dwillia2-mobl3.amr.corp.intel.com.notmuch/ [1]
Signed-off-by: Kai Huang <kai.huang@intel.com>
Message-ID: <162f9dee05c729203b9ad6688db1ca2960b4b502.1731664295.git.kai.huang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h                    |   3 +
 .../tdx => include/asm}/tdx_global_metadata.h |   0
 arch/x86/kvm/Kconfig                          |  10 ++
 arch/x86/kvm/Makefile                         |   1 +
 arch/x86/kvm/vmx/main.c                       |   9 +
 arch/x86/kvm/vmx/tdx.c                        | 160 ++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h                        |  13 ++
 arch/x86/virt/vmx/tdx/tdx.c                   |  14 ++
 arch/x86/virt/vmx/tdx/tdx.h                   |   1 -
 include/linux/kvm_host.h                      |   1 +
 virt/kvm/kvm_main.c                           |   3 +-
 11 files changed, 213 insertions(+), 2 deletions(-)
 rename arch/x86/{virt/vmx/tdx => include/asm}/tdx_global_metadata.h (100%)
 create mode 100644 arch/x86/kvm/vmx/tdx.c
 create mode 100644 arch/x86/kvm/vmx/tdx.h

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 26e29a7ba6f8..52a21075c0a6 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -33,6 +33,7 @@
 #ifndef __ASSEMBLY__
 
 #include <uapi/asm/mce.h>
+#include <asm/tdx_global_metadata.h>
 #include <linux/pgtable.h>
 
 /*
@@ -120,6 +121,7 @@ static inline u64 sc_retry(sc_func_t func, u64 fn,
 int tdx_cpu_enable(void);
 int tdx_enable(void);
 const char *tdx_dump_mce_info(struct mce *m);
+const struct tdx_sys_info *tdx_get_sysinfo(void);
 
 int tdx_guest_keyid_alloc(void);
 void tdx_guest_keyid_free(unsigned int keyid);
@@ -178,6 +180,7 @@ static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
 static inline int tdx_enable(void)  { return -ENODEV; }
 static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
+static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.h b/arch/x86/include/asm/tdx_global_metadata.h
similarity index 100%
rename from arch/x86/virt/vmx/tdx/tdx_global_metadata.h
rename to arch/x86/include/asm/tdx_global_metadata.h
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index ea2c4f21c1ca..fe8cbee6f614 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -128,6 +128,16 @@ config X86_SGX_KVM
 
 	  If unsure, say N.
 
+config KVM_INTEL_TDX
+	bool "Intel Trust Domain Extensions (TDX) support"
+	default y
+	depends on INTEL_TDX_HOST
+	help
+	  Provides support for launching Intel Trust Domain Extensions (TDX)
+	  confidential VMs on Intel processors.
+
+	  If unsure, say N.
+
 config KVM_AMD
 	tristate "KVM for AMD processors support"
 	depends on KVM && (CPU_SUP_AMD || CPU_SUP_HYGON)
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index f9dddb8cb466..a5d362c7b504 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -20,6 +20,7 @@ kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
 kvm-intel-$(CONFIG_KVM_HYPERV)	+= vmx/hyperv.o vmx/hyperv_evmcs.o
+kvm-intel-$(CONFIG_KVM_INTEL_TDX)	+= vmx/tdx.o
 
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 54cf95cb8d42..97c453187cc1 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -6,6 +6,7 @@
 #include "nested.h"
 #include "pmu.h"
 #include "posted_intr.h"
+#include "tdx.h"
 
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
@@ -172,6 +173,7 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
 static void __exit vt_exit(void)
 {
 	kvm_exit();
+	tdx_cleanup();
 	vmx_exit();
 }
 module_exit(vt_exit);
@@ -184,6 +186,11 @@ static int __init vt_init(void)
 	if (r)
 		return r;
 
+	/* tdx_init() has been taken */
+	r = tdx_bringup();
+	if (r)
+		goto err_tdx_bringup;
+
 	/*
 	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
 	 * exposed to userspace!
@@ -196,6 +203,8 @@ static int __init vt_init(void)
 	return 0;
 
 err_kvm_init:
+	tdx_cleanup();
+err_tdx_bringup:
 	vmx_exit();
 	return r;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
new file mode 100644
index 000000000000..0666dfbe0bc0
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/cpu.h>
+#include <asm/cpufeature.h>
+#include <asm/tdx.h>
+#include "capabilities.h"
+#include "tdx.h"
+
+#undef pr_fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+static bool enable_tdx __ro_after_init;
+module_param_named(tdx, enable_tdx, bool, 0444);
+
+static enum cpuhp_state tdx_cpuhp_state;
+
+static int tdx_online_cpu(unsigned int cpu)
+{
+	unsigned long flags;
+	int r;
+
+	/* Sanity check CPU is already in post-VMXON */
+	WARN_ON_ONCE(!(cr4_read_shadow() & X86_CR4_VMXE));
+
+	local_irq_save(flags);
+	r = tdx_cpu_enable();
+	local_irq_restore(flags);
+
+	return r;
+}
+
+static void __do_tdx_cleanup(void)
+{
+	/*
+	 * Once TDX module is initialized, it cannot be disabled and
+	 * re-initialized again w/o runtime update (which isn't
+	 * supported by kernel).  Only need to remove the cpuhp here.
+	 * The TDX host core code tracks TDX status and can handle
+	 * 'multiple enabling' scenario.
+	 */
+	WARN_ON_ONCE(!tdx_cpuhp_state);
+	cpuhp_remove_state_nocalls(tdx_cpuhp_state);
+	tdx_cpuhp_state = 0;
+}
+
+static int __init __do_tdx_bringup(void)
+{
+	int r;
+
+	/*
+	 * TDX-specific cpuhp callback to call tdx_cpu_enable() on all
+	 * online CPUs before calling tdx_enable(), and on any new
+	 * going-online CPU to make sure it is ready for TDX guest.
+	 */
+	r = cpuhp_setup_state_cpuslocked(CPUHP_AP_ONLINE_DYN,
+					 "kvm/cpu/tdx:online",
+					 tdx_online_cpu, NULL);
+	if (r < 0)
+		return r;
+
+	tdx_cpuhp_state = r;
+
+	r = tdx_enable();
+	if (r)
+		__do_tdx_cleanup();
+
+	return r;
+}
+
+static bool __init kvm_can_support_tdx(void)
+{
+	return cpu_feature_enabled(X86_FEATURE_TDX_HOST_PLATFORM);
+}
+
+static int __init __tdx_bringup(void)
+{
+	int r;
+
+	/*
+	 * Enabling TDX requires enabling hardware virtualization first,
+	 * as making SEAMCALLs requires CPU being in post-VMXON state.
+	 */
+	r = kvm_enable_virtualization();
+	if (r)
+		return r;
+
+	cpus_read_lock();
+	r = __do_tdx_bringup();
+	cpus_read_unlock();
+
+	if (r)
+		goto tdx_bringup_err;
+
+	/*
+	 * Leave hardware virtualization enabled after TDX is enabled
+	 * successfully.  TDX CPU hotplug depends on this.
+	 */
+	return 0;
+tdx_bringup_err:
+	kvm_disable_virtualization();
+	return r;
+}
+
+void tdx_cleanup(void)
+{
+	if (enable_tdx) {
+		__do_tdx_cleanup();
+		kvm_disable_virtualization();
+	}
+}
+
+int __init tdx_bringup(void)
+{
+	int r;
+
+	if (!enable_tdx)
+		return 0;
+
+	if (!kvm_can_support_tdx()) {
+		pr_err("tdx: no TDX private KeyIDs available\n");
+		goto success_disable_tdx;
+	}
+
+	if (!enable_virt_at_load) {
+		pr_err("tdx: tdx requires kvm.enable_virt_at_load=1\n");
+		goto success_disable_tdx;
+	}
+
+	/*
+	 * Ideally KVM should probe whether TDX module has been loaded
+	 * first and then try to bring it up.  But TDX needs to use SEAMCALL
+	 * to probe whether the module is loaded (there is no CPUID or MSR
+	 * for that), and making SEAMCALL requires enabling virtualization
+	 * first, just like the rest steps of bringing up TDX module.
+	 *
+	 * So, for simplicity do everything in __tdx_bringup(); the first
+	 * SEAMCALL will return -ENODEV when the module is not loaded.  The
+	 * only complication is having to make sure that initialization
+	 * SEAMCALLs don't return TDX_SEAMCALL_VMFAILINVALID in other
+	 * cases.
+	 */
+	r = __tdx_bringup();
+	if (r) {
+		/*
+		 * Disable TDX only but don't fail to load module if
+		 * the TDX module could not be loaded.  No need to print
+		 * message saying "module is not loaded" because it was
+		 * printed when the first SEAMCALL failed.
+		 */
+		if (r == -ENODEV)
+			goto success_disable_tdx;
+
+		enable_tdx = 0;
+	}
+
+	return r;
+
+success_disable_tdx:
+	enable_tdx = 0;
+	return 0;
+}
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
new file mode 100644
index 000000000000..8aee938a968f
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_VMX_TDX_H
+#define __KVM_X86_VMX_TDX_H
+
+#ifdef CONFIG_INTEL_TDX_HOST
+int tdx_bringup(void);
+void tdx_cleanup(void);
+#else
+static inline int tdx_bringup(void) { return 0; }
+static inline void tdx_cleanup(void) {}
+#endif
+
+#endif
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 0122051af6b3..9f0c482c1a03 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1462,6 +1462,20 @@ void __init tdx_init(void)
 	check_tdx_erratum();
 }
 
+const struct tdx_sys_info *tdx_get_sysinfo(void)
+{
+	const struct tdx_sys_info *p = NULL;
+
+	/* Make sure all fields in @tdx_sysinfo have been populated */
+	mutex_lock(&tdx_module_lock);
+	if (tdx_module_status == TDX_MODULE_INITIALIZED)
+		p = (const struct tdx_sys_info *)&tdx_sysinfo;
+	mutex_unlock(&tdx_module_lock);
+
+	return p;
+}
+EXPORT_SYMBOL_GPL(tdx_get_sysinfo);
+
 int tdx_guest_keyid_alloc(void)
 {
 	return ida_alloc_range(&tdx_guest_keyid_pool, tdx_guest_keyid_start,
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 62cb7832c42d..da384387d4eb 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -3,7 +3,6 @@
 #define _X86_VIRT_TDX_H
 
 #include <linux/bits.h>
-#include "tdx_global_metadata.h"
 
 /*
  * This file contains both macros and data structures defined by the TDX
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1e75fa114f34..3bfe3140f444 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2284,6 +2284,7 @@ static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
 }
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
+extern bool enable_virt_at_load;
 extern bool kvm_rebooting;
 #endif
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6e40383fbe47..622b5a99078a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5464,8 +5464,9 @@ static struct miscdevice kvm_dev = {
 };
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
-static bool enable_virt_at_load = true;
+bool enable_virt_at_load = true;
 module_param(enable_virt_at_load, bool, 0444);
+EXPORT_SYMBOL_GPL(enable_virt_at_load);
 
 __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
-- 
2.43.5



