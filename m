Return-Path: <kvm+bounces-32584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 092A89DAE5A
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:11:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C76F016602E
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A36220409F;
	Wed, 27 Nov 2024 20:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nj9pXLfn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EF12036E6
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738229; cv=none; b=Qe7RQfWfl0x9N3wCUQcaeIf25c24AbubYHAYMz72FWz8Ruvd9ZCc3jEPNsmoUIhTmzbW7vDaziQF9JUpJpPSzzJ2tMlfs95H4U7w0ThYmMReQS6GaluHGNdHxLUCUDTB50RqWm25ZEQoQDbqEsamvj/K+oli8+dYuLiNFlWv2Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738229; c=relaxed/simple;
	bh=GjTTqn2whow5AQGXruMUfYhh0oUV4AeJJk0c33RICus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O74ntZLr0r0+wPpSIK2Y6xvLZfEwaI+P7tzV7X1ItxkD7io/4/srs+PN0es2xDI+zmjYLI2p6L0FaBNIxsXMTUle0t/kCzlKVDm2ZMNzdBfYH8ifRGIWeLC8s0aUlW6gDJ1+vX8X4e4B77gj6CdrHiWWi+o4D3qwgH9aMuSkOJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nj9pXLfn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732738225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vSsdGrzP8QTWyIieNbBesE4v5M+34faZuSvZl5ZTcvI=;
	b=Nj9pXLfne1K8jqK7dUZgON5r2NqvrA+YsuQpjMuRyWbd1+QYBsR0dSB7QRkqP1d27RnpYd
	RX4XJCnzugiTXA4oODXAnrFfiDJYeC3tQcnAdtfzc1+zfBcj2X8nzs48v7tFlG3UXQ0ut0
	SQf4XqDf1l2Bovk0TLRY1d0fVR+nHj0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-113-u85DGN12OKCSNcmV8A27Tw-1; Wed,
 27 Nov 2024 15:10:24 -0500
X-MC-Unique: u85DGN12OKCSNcmV8A27Tw-1
X-Mimecast-MFC-AGG-ID: u85DGN12OKCSNcmV8A27Tw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 412101955DC4;
	Wed, 27 Nov 2024 20:10:23 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A0D1C19560A3;
	Wed, 27 Nov 2024 20:10:22 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com
Subject: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
Date: Wed, 27 Nov 2024 15:10:19 -0500
Message-ID: <20241127201019.136086-4-pbonzini@redhat.com>
In-Reply-To: <20241127201019.136086-1-pbonzini@redhat.com>
References: <20241127201019.136086-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

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
 arch/x86/kvm/Kconfig     |  10 +++
 arch/x86/kvm/Makefile    |   1 +
 arch/x86/kvm/vmx/main.c  |   9 +++
 arch/x86/kvm/vmx/tdx.c   | 160 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h   |  13 ++++
 include/linux/kvm_host.h |   1 +
 virt/kvm/kvm_main.c      |   3 +-
 7 files changed, 196 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/vmx/tdx.c
 create mode 100644 arch/x86/kvm/vmx/tdx.h

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
index 6772e560ac7b..bc690c63e511 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -6,6 +6,7 @@
 #include "nested.h"
 #include "pmu.h"
 #include "posted_intr.h"
+#include "tdx.h"
 
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
@@ -171,6 +172,7 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
 static void vt_exit(void)
 {
 	kvm_exit();
+	tdx_cleanup();
 	vmx_exit();
 }
 module_exit(vt_exit);
@@ -183,6 +185,11 @@ static int __init vt_init(void)
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
@@ -195,6 +202,8 @@ static int __init vt_init(void)
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
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3fcee4209120..0a141685872d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2272,6 +2272,7 @@ static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
 }
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
+extern bool enable_virt_at_load;
 extern bool kvm_rebooting;
 #endif
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8214efa76a6f..265b687fc5d6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5440,8 +5440,9 @@ static struct miscdevice kvm_dev = {
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


