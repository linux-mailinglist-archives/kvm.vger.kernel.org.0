Return-Path: <kvm+bounces-47538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94312AC2037
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:54:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D44A61B64697
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83D1722A4E8;
	Fri, 23 May 2025 09:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iiWpNMS7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDD1227EA7;
	Fri, 23 May 2025 09:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994009; cv=none; b=gD5A2uXkcgEfgpwYvnvqA7xUJA+qPWieexM4qDCxXZuKDKqPV9Q8Gepy4IhzoqML3uXgTwmNTVBGLHzHfibcQ6+PvJVU+WRvaf5Qws/2eNA6J6Y8qG2UAX4MtDmeAgxlu9t6tFiqcyKGDt07mZ+/lvSlIZLDawm0KUeJoZaBWvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994009; c=relaxed/simple;
	bh=E8Dj8QvY/mQqCZ11f0OqSrNtR2Ru7HYcMeZzbwXrfKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FQWxXsaJfBLU9ut9sh57ALUC4hzuelnGxIskVairfJi3KxdlX4ZAHaLK4Chhh4Mgw7xr3APFQmQDsYSdD/f3JkCj8YROb7/SQ8/mf/lqm624pPLgx9gPvLtW/fohyb19bjwQK12OFQRh3fvfdYGldrE8dQcJ2QQ9zL0qvi7wckk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iiWpNMS7; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747994008; x=1779530008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E8Dj8QvY/mQqCZ11f0OqSrNtR2Ru7HYcMeZzbwXrfKo=;
  b=iiWpNMS7EBWeteLqvu6TfCvJZP0DL0P1+afuqPQygKlrY74FIU9VZMXB
   KAJAoTCyiwazm4ch/zoa/1TQJO6fSRr8HyZVZ7Gk9JtMPCvoH0FWIT9M6
   Wt0e+kk4ISD4208YdL2lfwpcId6p99l9JDauGbej+FNVAtCnWmktAijHw
   gROroIe0hmEmUnZcsqXoHIytd/nSvyhIk72VDGkGJ9wdoLR7V7gWO+pBk
   /WUfLN5FLEhpdPl1JoQdWtIpU8ji1KcoEpQ1xAH58203ZMX7lu12q3yJM
   ChX7pHY3HE1QEYt9uX+quwIqZhBTxcclhais/jkfT0k5hRDY1bR+cW+cK
   g==;
X-CSE-ConnectionGUID: NtqWYq77QfOvvcLCvw94rA==
X-CSE-MsgGUID: SMDxq3EAQli6RWe28DQE+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75444108"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="75444108"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:27 -0700
X-CSE-ConnectionGUID: lJEL/6V4TKy7qsLSCmkjqw==
X-CSE-MsgGUID: edaiM/tORZi0rW7Sou53HA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="164315041"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:27 -0700
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	x86@kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	eddie.dong@intel.com,
	kirill.shutemov@intel.com,
	dave.hansen@intel.com,
	dan.j.williams@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	elena.reshetova@intel.com,
	rick.p.edgecombe@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 03/20] x86/virt/seamldr: Introduce a wrapper for P-SEAMLDR SEAMCALLs
Date: Fri, 23 May 2025 02:52:26 -0700
Message-ID: <20250523095322.88774-4-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250523095322.88774-1-chao.gao@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

P-SEAMLDR is another component alongside the TDX module within the
protected SEAM range. Software can invoke its functions by executing the
SEAMCALL instruction with the 63 bit of RAX set to 1. P-SEAMLDR SEAMCALLs
differ from those of the TDX module in terms of error codes and the
handling of the current VMCS.

Add a wrapper for P-SEAMLDR SEAMCALLs based on the SEAMCALL infrastructure.

Intel® Trust Domain CPU Architectural Extensions (May 2021 edition)
Chapter 2.3 states:

SEAMRET from the P-SEAMLDR clears the current VMCS structure pointed to by
the current-VMCS pointer. A VMM that invokes the P-SEAMLDR using SEAMCALL
must reload the current-VMCS, if required, using the VMPTRLD instruction.

So, save and restore the current-VMCS pointer using VMPTRST and VMPTRLD
instructions to avoid breaking KVM, which manages the current-VMCS.

Disable interrupts to prevent KVM code from interfering with P-SEAMLDR
SEAMCALLs. For example, if a vCPU is scheduled before the current VMCS is
restored, it may encounter an invalid current VMCS, causing its VMX
instruction to fail. Additionally, if KVM sends IPIs to invalidate a
current VMCS and the invalidation occurs right after the current VMCS is
saved, that VMCS will be reloaded after P-SEAMLDR SEAMCALLs, leading to
unexpected behavior.

NMIs are not a problem, as the only scenario where instructions relying on
the current-VMCS are used is during guest PMI handling in KVM. This occurs
immediately after VM exits with IRQ and NMI disabled, ensuring no
interference with P-SEAMLDR SEAMCALLs.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
 arch/x86/Kconfig                | 10 ++++++++
 arch/x86/virt/vmx/tdx/Makefile  |  1 +
 arch/x86/virt/vmx/tdx/seamldr.c | 44 +++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/vmx.h         | 40 ++++++++++++++++++++++++++++++
 4 files changed, 95 insertions(+)
 create mode 100644 arch/x86/virt/vmx/tdx/seamldr.c
 create mode 100644 arch/x86/virt/vmx/vmx.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4b9f378e05f6..8b1e0986b7f8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1932,6 +1932,16 @@ config INTEL_TDX_HOST
 
 	  If unsure, say N.
 
+config INTEL_TDX_MODULE_UPDATE
+	bool "Intel TDX module runtime update"
+	depends on INTEL_TDX_HOST
+	help
+	  This enables the kernel to support TDX module runtime update. This allows
+	  the admin to upgrade the TDX module to a newer one without the need to
+	  terminate running TDX guests.
+
+	  If unsure, say N.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/virt/vmx/tdx/Makefile b/arch/x86/virt/vmx/tdx/Makefile
index 90da47eb85ee..26aea3531c36 100644
--- a/arch/x86/virt/vmx/tdx/Makefile
+++ b/arch/x86/virt/vmx/tdx/Makefile
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-y += seamcall.o tdx.o
+obj-$(CONFIG_INTEL_TDX_MODULE_UPDATE) += seamldr.o
diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
new file mode 100644
index 000000000000..a252f1ae3483
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright(c) 2025 Intel Corporation.
+ *
+ * Intel TDX module runtime update
+ */
+#define pr_fmt(fmt)	"seamldr: " fmt
+
+#include <linux/cleanup.h>
+
+#include "tdx.h"
+#include "../vmx.h"
+
+static __maybe_unused int seamldr_call(u64 fn, struct tdx_module_args *args)
+{
+	u64 vmcs;
+	int ret;
+
+	if (!is_seamldr_call(fn))
+		return -EINVAL;
+
+	/*
+	 * SEAMRET from P-SEAMLDR invalidates the current-VMCS pointer.
+	 * Save/restore current-VMCS pointer across P-SEAMLDR SEAMCALLs so
+	 * that VMX instructions won't fail due to an invalid current-VMCS.
+	 *
+	 * Disable interrupt to prevent SMP call functions from seeing the
+	 * invalid current-VMCS.
+	 */
+	guard(irqsave)();
+
+	ret = cpu_vmcs_store(&vmcs);
+	if (ret)
+		return ret;
+
+	ret = seamldr_prerr(fn, args);
+
+	/* Restore current-VMCS pointer */
+#define INVALID_VMCS   -1ULL
+	if (vmcs != INVALID_VMCS)
+	       WARN_ON_ONCE(cpu_vmcs_load(vmcs));
+
+	return ret;
+}
diff --git a/arch/x86/virt/vmx/vmx.h b/arch/x86/virt/vmx/vmx.h
new file mode 100644
index 000000000000..51e6460fd1fd
--- /dev/null
+++ b/arch/x86/virt/vmx/vmx.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef ARCH_X86_VIRT_VMX_H
+#define ARCH_X86_VIRT_VMX_H
+
+#include <linux/printk.h>
+
+static inline int cpu_vmcs_load(u64 vmcs_pa)
+{
+	asm goto("1: vmptrld %0\n\t"
+			  ".byte 0x2e\n\t" /* branch not taken hint */
+			  "jna %l[error]\n\t"
+			  _ASM_EXTABLE(1b, %l[fault])
+			  : : "m" (vmcs_pa) : "cc" : error, fault);
+	return 0;
+
+error:
+	pr_err_once("vmptrld failed: %llx\n", vmcs_pa);
+	return -EIO;
+fault:
+	pr_err_once("vmptrld faulted\n");
+	return -EIO;
+}
+
+static inline int cpu_vmcs_store(u64 *vmcs_pa)
+{
+	int ret = -EIO;
+
+	asm volatile("1: vmptrst %0\n\t"
+		     "mov $0, %1\n\t"
+		     "2:\n\t"
+		     _ASM_EXTABLE(1b, 2b)
+		     : "=m" (*vmcs_pa), "+r" (ret) : :);
+
+	if (ret)
+		pr_err_once("vmptrst faulted\n");
+
+	return ret;
+}
+
+#endif
-- 
2.47.1


