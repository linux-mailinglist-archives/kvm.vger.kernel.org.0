Return-Path: <kvm+bounces-29853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA5859B3190
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 14:21:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77AAA282CEB
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 13:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 736CE1DDC01;
	Mon, 28 Oct 2024 13:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZM9Guy5t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D501DD872;
	Mon, 28 Oct 2024 13:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730121639; cv=none; b=PEzGGIaBVPpZ/5Mf0UALwp3h606MqL8zlbFWgwpV+sylD7K7K1uQmStNNNlMNAK7vglZTo9HMtqLBJxBSi9K5ZcxgAdK6JPTRtX3zlVtkteXZUscI8V5RoECN+awAg76rvkIsKflTITOOqc8zHTOmI024qMIFEZgWGyLwTf5RBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730121639; c=relaxed/simple;
	bh=yjSEcZCTd05Yt7ubS1sHvNhzEiGxhRqRhxD7zM4nrxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsFAHMujrU+hD+QAXXnYN/kHbZuQJ0ObgI/4WGifpNepkeUNkzgdTDZdtmeFZEdc8pvqhLiUB8LQSCOeEnUibd5cI6W4u6DnCumKBEMpD619sSH0QqcRDP96GkJUHTyaIIo+icQ5JxOkAm9Kt0H9563E10cqaA5cSlXm75Sn50Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZM9Guy5t; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730121637; x=1761657637;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yjSEcZCTd05Yt7ubS1sHvNhzEiGxhRqRhxD7zM4nrxo=;
  b=ZM9Guy5tFjaQPiRaGzxgHoBF/TEugJu2NRCXwDzrCb1jA/ngrUDm34Nl
   qgQFlqysrBFFUrnH58eKrkA0Gkxzj/YoTAyqsk3BSyRqbTvrzHqCtBYK2
   abw+jO2+QKX9/qwB83QBv41YrrrQ/GfpEfmcQxFrcbc1KxCfpIP0D6riq
   k5NyE9dBk/5/UxZ9xFmYbXX/SCBgkZ6fyCUZCSPX4xWeIXPQebeso+R2P
   JOskGxD/EppS938x/8094/m/rLlAUpvf1oqz6pRDdfYwUjv2xjtcqg7Ig
   3aTSJAK7Wn3d+iMZPtD8a51hI04TbZPF0JXygZh33awtsjZLjr3KRsHvc
   Q==;
X-CSE-ConnectionGUID: M7T0UVHgTIGx6Can7avk1g==
X-CSE-MsgGUID: 5xoCxHObT7eC30oVwiQAFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="29820983"
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="29820983"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 06:20:37 -0700
X-CSE-ConnectionGUID: qiJkstXASuSMyxbV2DxLPw==
X-CSE-MsgGUID: N+xiRrQtRkqOLzEOyl+Mng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="86397267"
Received: from gargmani-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.169])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 06:20:35 -0700
From: Kai Huang <kai.huang@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com
Cc: isaku.yamahata@intel.com,
	reinette.chatre@intel.com,
	binbin.wu@linux.intel.com,
	xiaoyao.li@intel.com,
	yan.y.zhao@intel.com,
	adrian.hunter@intel.com,
	tony.lindgren@intel.com,
	kristen@linux.intel.com,
	linux-kernel@vger.kernel.org,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
Date: Tue, 29 Oct 2024 02:20:16 +1300
Message-ID: <f7394b88a22e52774f23854950d45c1bfeafe42c.1730120881.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1730120881.git.kai.huang@intel.com>
References: <cover.1730120881.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before KVM can use TDX to create and run TDX guests, TDX needs to be
initialized from two perspectives: 1) TDX module must be initialized
properly to a working state; 2) A per-cpu TDX initialization, a.k.a the
TDH.SYS.LP.INIT SEAMCALL must be done on any logical cpu before it can
run any other TDX SEAMCALLs.

The TDX host core-kernel provides two functions to do above two
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

This isn't good to the user.  On the other hand, initializing TDX at KVM
module loading time can make sure KVM is providing a consistent view of
whether KVM can support TDX to the user.

Always only try to initialize TDX after VMX has been initialized.  TDX
is based on VMX, and if VMX fails to initialize then TDX is likely to be
broken anyway.  Also, in practice, supporting TDX will require part of
VMX and common x86 infrastructure in working order, so TDX cannot be
sololy w/o VMX support.

Specifically, initialize TDX after VMX has been initialized and before
kvm_init() in vt_init().  Don't fail the whole vt_init() if TDX fails to
initialize, since in this case KVM can still support normal VMX guests.

Because TDX costs additional memory, don't enable TDX by default.  Add a
new module parameter 'enable_tdx' to allow the user to opt-in.

Register a new TDX-specific cpuhp callback to run tdx_cpu_enable(), and
call tdx_enable() after that to ensure tdx_cpu_enable() has been done
for all online CPUs before making the tdx_enable().  Use a dynamic cpuhp
state for TDX so that KVM's cpuhp callback to enable VMX on new online
CPU can happen before tdx_cpu_enable().

Note, the name tdx_init() has already been taken by the early boot code.
Use tdx_bringup() for initializing TDX (and tdx_cleanup() since KVM
doesn't actually teardown TDX).  They don't match vt_init()/vt_exit(),
vmx_init()/vmx_exit() etc but it's not end of the world.

Also, once initialized, the TDX module cannot be disabled and enabled
again w/o the TDX module runtime update, which isn't supported by the
kernel.  After TDX is enabled, nothing needs to be done when KVM
disables hardware virtualization, e.g., when offlining CPU, or during
suspend/resume.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/Makefile   |   1 +
 arch/x86/kvm/vmx/main.c |   6 +++
 arch/x86/kvm/vmx/tdx.c  | 115 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h  |  12 +++++
 4 files changed, 134 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx.c
 create mode 100644 arch/x86/kvm/vmx/tdx.h

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index f9dddb8cb466..fec803aff7ad 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -20,6 +20,7 @@ kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
 kvm-intel-$(CONFIG_KVM_HYPERV)	+= vmx/hyperv.o vmx/hyperv_evmcs.o
+kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
 
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 433ecbd90905..053294939eb1 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -6,6 +6,7 @@
 #include "nested.h"
 #include "pmu.h"
 #include "posted_intr.h"
+#include "tdx.h"
 
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
@@ -170,6 +171,7 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
 static void vt_exit(void)
 {
 	kvm_exit();
+	tdx_cleanup();
 	vmx_exit();
 }
 module_exit(vt_exit);
@@ -182,6 +184,9 @@ static int __init vt_init(void)
 	if (r)
 		return r;
 
+	/* tdx_init() has been taken */
+	tdx_bringup();
+
 	/*
 	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
 	 * exposed to userspace!
@@ -194,6 +199,7 @@ static int __init vt_init(void)
 	return 0;
 
 err_kvm_init:
+	tdx_cleanup();
 	vmx_exit();
 	return r;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
new file mode 100644
index 000000000000..8651599822d5
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/cpu.h>
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
+	/* tdx_cpu_enable() must be called with IRQ disabled */
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
+	 * supported by kernel).  In fact the kernel doesn't support
+	 * disable (shut down) TDX module, so only need to remove the
+	 * cpuhp state.
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
+	/* tdx_enable() must be called with cpus_read_lock() */
+	r = tdx_enable();
+	if (r)
+		__do_tdx_cleanup();
+
+	return r;
+}
+
+static int __init __tdx_bringup(void)
+{
+	int r;
+
+	if (!enable_ept) {
+		pr_err("Cannot enable TDX with EPT disabled.\n");
+		return -EINVAL;
+	}
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
+void __init tdx_bringup(void)
+{
+	enable_tdx = enable_tdx && !__tdx_bringup();
+}
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
new file mode 100644
index 000000000000..766a6121f670
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -0,0 +1,12 @@
+#ifndef  __KVM_X86_VMX_TDX_H
+#define __KVM_X86_VMX_TDX_H
+
+#ifdef CONFIG_INTEL_TDX_HOST
+void tdx_bringup(void);
+void tdx_cleanup(void);
+#else
+static inline void tdx_bringup(void) {}
+static inline void tdx_cleanup(void) {}
+#endif
+
+#endif
-- 
2.46.2


