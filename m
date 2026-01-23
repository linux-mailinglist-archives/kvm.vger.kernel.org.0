Return-Path: <kvm+bounces-68982-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mAyPIfSNc2l0xAAAu9opvQ
	(envelope-from <kvm+bounces-68982-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:04:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F3E8F77724
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:04:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4164D301AAAA
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBCC1346A14;
	Fri, 23 Jan 2026 15:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nMwm8/md"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9834337B8C;
	Fri, 23 Jan 2026 15:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180422; cv=none; b=WTQ1TuE45717hKRs4fMwZH3DJyeuNlw8UlPNbPNyGWpxhqTUPzDK+3SJ2A+2nep/rjrl4NqwmDFqHArMqil7EA/NJ2ZEn+Zv61uEH5997dTdwop9mkQffua5S/2JqfWSTnr4R0v2wbzFq4Gf7vTg/cIEPZb1+o3fF3zsO6EElhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180422; c=relaxed/simple;
	bh=l6gRODA9DOWaUAZIpnN8DaS/2uBMMYa5BOi5JNoTwvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QdLvTLLIhchH4J+dQYiWIB4q7PGWY7LotDvftQBiG3MP6MnieEjZyGoX/43Hjw+CtSaAYScDUkjwsKC8gF+cWdVU80J1pU0fEMvT3KqulONwus0Z036itk8AJrMMA6Bz2PtB2u5dfexPXYkDC//TkV7iN8ik++s8WICPOTPMOpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nMwm8/md; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769180418; x=1800716418;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l6gRODA9DOWaUAZIpnN8DaS/2uBMMYa5BOi5JNoTwvw=;
  b=nMwm8/mdkVelts5zPg+fKp1o04x533kZ0r/RVOg4E9SKlgpq8T4CMGcL
   QD7YMeffX4vn4+CEaMpHxcFUhR5R/R49N4agts0Kl7+1dO8DdxvCd5beH
   rpIZ/mShS8GYAYSHXdBcFdQ/Hb9kWELpcTtmivpnxfgYqfmiUfwg83VX/
   8qIkU02v2orNV7Zr2myD/wUzwo2bIQRZFwdg1uU8YijNM+dG/foYxC6C5
   t/qpSTPblV/VromZ8UqvcvP/0jEBh1ChHOslx1JeIrlLzhANMibrDk46Z
   FVtVBtpk11HAjNw6Y3sjPwstiBULBhJxrjMT1PvqfcM/Yyt7eiV2E/WRB
   w==;
X-CSE-ConnectionGUID: CnxQhNetThei/XY3NEMJAA==
X-CSE-MsgGUID: +SkDaSOjTeODolDAAz8tUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70334381"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70334381"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:12 -0800
X-CSE-ConnectionGUID: M96KETEJQAW17m2phGDAbg==
X-CSE-MsgGUID: dlx+zI7kT9udG9MJaOYtEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237697099"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:11 -0800
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org
Cc: reinette.chatre@intel.com,
	ira.weiny@intel.com,
	kai.huang@intel.com,
	dan.j.williams@intel.com,
	yilun.xu@linux.intel.com,
	sagis@google.com,
	vannapurve@google.com,
	paulmck@kernel.org,
	nik.borisov@suse.com,
	zhenzhong.duan@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	kas@kernel.org,
	dave.hansen@linux.intel.com,
	vishal.l.verma@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 07/26] x86/virt/seamldr: Introduce a wrapper for P-SEAMLDR SEAMCALLs
Date: Fri, 23 Jan 2026 06:55:15 -0800
Message-ID: <20260123145645.90444-8-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260123145645.90444-1-chao.gao@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	TAGGED_FROM(0.00)[bounces-68982-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:url,intel.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F3E8F77724
X-Rspamd-Action: no action

Software needs to talk with P-SEAMLDR via P-SEAMLDR SEAMCALLs. So, add a
wrapper for P-SEAMLDR SEAMCALLs.

Save and restore the current VMCS using VMPTRST and VMPTRLD instructions
to avoid breaking KVM. Doing so is because P-SEAMLDR SEAMCALLs would
invalidate the current VMCS as documented in Intel® Trust Domain CPU
Architectural Extensions (May 2021 edition) Chapter 2.3 [1]:

  SEAMRET from the P-SEAMLDR clears the current VMCS structure pointed
  to by the current-VMCS pointer. A VMM that invokes the P-SEAMLDR using
  SEAMCALL must reload the current-VMCS, if required, using the VMPTRLD
  instruction.

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
Link: https://cdrdv2.intel.com/v1/dl/getContent/733582 # [1]
---
v2:
 - don't create a new, inferior framework to save/restore VMCS
 - use human-friendly language, just "current VMCS" rather than
   SDM term "current-VMCS pointer"
 - don't mix guard() with goto
---
 arch/x86/virt/vmx/tdx/Makefile     |  1 +
 arch/x86/virt/vmx/tdx/seamldr.c    | 56 ++++++++++++++++++++++++++++++
 drivers/virt/coco/tdx-host/Kconfig | 10 ++++++
 3 files changed, 67 insertions(+)
 create mode 100644 arch/x86/virt/vmx/tdx/seamldr.c

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
index 000000000000..b99d73f7bb08
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright(c) 2025 Intel Corporation.
+ *
+ * Intel TDX module runtime update
+ */
+#define pr_fmt(fmt)	"seamldr: " fmt
+
+#include <linux/irqflags.h>
+#include <linux/types.h>
+
+#include "seamcall.h"
+
+static __maybe_unused int seamldr_call(u64 fn, struct tdx_module_args *args)
+{
+	unsigned long flags;
+	u64 vmcs;
+	int ret;
+
+	if (!is_seamldr_call(fn))
+		return -EINVAL;
+
+	/*
+	 * SEAMRET from P-SEAMLDR invalidates the current VMCS.  Save/restore
+	 * the VMCS across P-SEAMLDR SEAMCALLs to avoid clobbering KVM state.
+	 * Disable interrupts as KVM is allowed to do VMREAD/VMWRITE in IRQ
+	 * context (but not NMI context).
+	 */
+	local_irq_save(flags);
+
+	asm goto("1: vmptrst %0\n\t"
+		 _ASM_EXTABLE(1b, %l[error])
+		 : "=m" (vmcs) : : "cc" : error);
+
+	ret = seamldr_prerr(fn, args);
+
+	/*
+	 * Restore the current VMCS pointer.  VMPTSTR "returns" all ones if the
+	 * current VMCS is invalid.
+	 */
+	if (vmcs != -1ULL) {
+		asm goto("1: vmptrld %0\n\t"
+			 "jna %l[error]\n\t"
+			 _ASM_EXTABLE(1b, %l[error])
+			 : : "m" (vmcs) : "cc" : error);
+	}
+
+	local_irq_restore(flags);
+	return ret;
+
+error:
+	local_irq_restore(flags);
+
+	WARN_ONCE(1, "Failed to save/restore the current VMCS");
+	return -EIO;
+}
diff --git a/drivers/virt/coco/tdx-host/Kconfig b/drivers/virt/coco/tdx-host/Kconfig
index e58bad148a35..6a9199e6c2c6 100644
--- a/drivers/virt/coco/tdx-host/Kconfig
+++ b/drivers/virt/coco/tdx-host/Kconfig
@@ -8,3 +8,13 @@ config TDX_HOST_SERVICES
 
 	  Say y or m if enabling support for confidential virtual machine
 	  support (CONFIG_INTEL_TDX_HOST). The module is called tdx_host.ko
+
+config INTEL_TDX_MODULE_UPDATE
+	bool "Intel TDX module runtime update"
+	depends on TDX_HOST_SERVICES
+	help
+	  This enables the kernel to support TDX module runtime update. This
+	  allows the admin to update the TDX module to another compatible
+	  version without the need to terminate running TDX guests.
+
+	  If unsure, say N.
-- 
2.47.3


