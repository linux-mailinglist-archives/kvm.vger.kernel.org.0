Return-Path: <kvm+bounces-47542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B40EAC203F
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:55:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AACA3BFC08
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77DB3234971;
	Fri, 23 May 2025 09:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UZ2SjnOc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039AA226D09;
	Fri, 23 May 2025 09:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994030; cv=none; b=SZZpPqq3UNRnxbNvYmlI5P4lfZFOLvr/+0v0n45yXLqIdupolLeZPoNi526TWnuEBvUOm3pMMjlLgJawc97z7ltTj8e5drsSWuzwoaFNPrDF5Y+VczlrfODGqRnJSPAtikyLuqviBNUAjATQB0jU5T73mCi/O9364lmoI8jkxcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994030; c=relaxed/simple;
	bh=NvUaccfrS6dx/m6gucgj+rwlO2P8Wn4egKozBJswo34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bkf4/GU7KKnqssdyncQHwui+4TfzMkEDhRntIdw5IOwGXglPa6FsBLeaHKMEbf+vAJ8NAmI19yPRjH08hWdFAj6yzpqEmIJVo7xmu4nOM8AHsxP8vjcDR9IejCjpQyh0Ukm8KslBd6ClMCfuCe2RcnOL7Gh76YE18txmfFcYOEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UZ2SjnOc; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747994029; x=1779530029;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NvUaccfrS6dx/m6gucgj+rwlO2P8Wn4egKozBJswo34=;
  b=UZ2SjnOcNJlf2iArFQr/NT7/tMCqsCCLWIL3PA4psfp3daiWv3uW33S6
   TIPZFB1q5Jf45WDi0M1WSkIxKMZ0fzyxjnXsf5nVA5IasrEMWCX8Fr/EX
   i6q235Fql2QBKwXtwpjbUaeRpln87lS2I8tThRl6jcXcFXmTWAUb/23QO
   0q5eQP2Jt1NlDL/d6vTzFNgrhFHbaGhpMbF7obQVnvTNm4dMex2MvaMVI
   QwQvbZCu9y6jnA6Y//DN/TjJjYqL+xZgPqxEmP+QbZLMzUSguPxlzh6Sv
   VVLu/n4XrmgNf+m3AEFKYbQ3ZDmKpoNQ2bw619h3O/kSqzgmN8oD3vCPg
   g==;
X-CSE-ConnectionGUID: NkAwxUP8TS+vqJNiIi63cQ==
X-CSE-MsgGUID: CZInTG8nSwucUXgeyhTpFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75444149"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="75444149"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:48 -0700
X-CSE-ConnectionGUID: bDhdZuShQu2zr4sJq9ODrw==
X-CSE-MsgGUID: dUuUCjkTQhK1afh/t5erkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="164315060"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:47 -0700
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
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 07/20] x86/virt/tdx: Expose SEAMLDR information via sysfs
Date: Fri, 23 May 2025 02:52:30 -0700
Message-ID: <20250523095322.88774-8-chao.gao@intel.com>
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

TD-Preserving updates depend on a userspace tool to select the appropriate
module to load. To facilitate this decision-making process, expose the
necessary information to userspace.

SEAMLDR version information can be used for compatibility check and
num_remaining_updates indicates how many updates can still be performed.

SEAMLDR serves as the foundation of TDX, as it is responsible for loading
the TDX module and, in other words, enabling the entire TDX system.
Therefore, attach its attributes to the root device of the new TDX virtual
subsystem.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
 Documentation/ABI/testing/sysfs-devices-tdx | 24 ++++++++++++++
 arch/x86/virt/vmx/tdx/seamldr.c             | 35 ++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/seamldr.h             | 14 +++++++++
 arch/x86/virt/vmx/tdx/tdx.c                 | 14 ++++++++-
 4 files changed, 85 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/virt/vmx/tdx/seamldr.h

diff --git a/Documentation/ABI/testing/sysfs-devices-tdx b/Documentation/ABI/testing/sysfs-devices-tdx
index ccbe6431241e..112f0738253b 100644
--- a/Documentation/ABI/testing/sysfs-devices-tdx
+++ b/Documentation/ABI/testing/sysfs-devices-tdx
@@ -6,3 +6,27 @@ Description:	(RO) Report the version of the loaded TDX module. The TDX module
 		version is formatted as x.y.z, where "x" is the major version,
 		"y" is the minor version and "z" is the update version. Versions
 		are used for bug reporting, TD-Preserving updates and etc.
+
+What:		/sys/devices/virtual/tdx/seamldr/version
+Date:		March 2025
+KernelVersion:	v6.15
+Contact:	linux-coco@lists.linux.dev
+Description:	(RO) Reports the version of the loaded SEAM loader. The SEAM
+		loader version is formatted as x.y.z, where "x" is the major
+		version, "y" is the minor version and "z" is the update version.
+		Versions are used for bug reporting and compatibility check.
+
+What:		/sys/devices/virtual/tdx/seamldr/num_remaining_updates
+Date:		March 2025
+KernelVersion:	v6.15
+Contact:	linux-coco@lists.linux.dev
+Description:	(RO) Reports the number of remaining updates that can be
+		performed via TD-Preserving updates. It is always zero if
+		SEAMLDR doesn't TD-Preserving updates. Otherwise, it is an
+		arch-specific value after bootup. This value decreases by one
+		after each successful TD-Preserving update. Once it reaches
+		zero, further TD-Preserving updates will fail until next reboot.
+
+		See Intel® Trust Domain Extensions - SEAM Loader (SEAMLDR)
+		Interface Specification Chapter 3.3 "SEAMLDR_INFO" and Chapter
+		4.2 "SEAMLDR.INSTALL" for more information.
diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index c2771323729c..b628555daf55 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -7,9 +7,13 @@
 #define pr_fmt(fmt)	"seamldr: " fmt
 
 #include <linux/cleanup.h>
+#include <linux/device.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
 
 #include "tdx.h"
 #include "../vmx.h"
+#include "seamldr.h"
 
  /* P-SEAMLDR SEAMCALL leaf function */
 #define P_SEAMLDR_INFO			0x8000000000000000
@@ -62,7 +66,36 @@ static inline int seamldr_call(u64 fn, struct tdx_module_args *args)
 	return ret;
 }
 
-static __maybe_unused int get_seamldr_info(void)
+static ssize_t version_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	return sysfs_emit(buf, "%u.%u.%u\n", seamldr_info.major_version,
+					     seamldr_info.minor_version,
+					     seamldr_info.update_version);
+}
+
+static ssize_t num_remaining_updates_show(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	return sysfs_emit(buf, "%u\n", seamldr_info.num_remaining_updates);
+}
+
+static DEVICE_ATTR_RO(version);
+static DEVICE_ATTR_RO(num_remaining_updates);
+
+static struct attribute *seamldr_attrs[] = {
+	&dev_attr_version.attr,
+	&dev_attr_num_remaining_updates.attr,
+	NULL,
+};
+
+struct attribute_group seamldr_group = {
+	.name = "seamldr",
+	.attrs = seamldr_attrs,
+};
+
+int get_seamldr_info(void)
 {
 	struct tdx_module_args args = { .rcx = __pa(&seamldr_info) };
 
diff --git a/arch/x86/virt/vmx/tdx/seamldr.h b/arch/x86/virt/vmx/tdx/seamldr.h
new file mode 100644
index 000000000000..15597cb5036d
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx/seamldr.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _X86_VIRT_VMX_TDX_SEAMLDR_H
+#define _X86_VIRT_VMX_TDX_SEAMLDR_H
+
+#ifdef CONFIG_INTEL_TDX_MODULE_UPDATE
+extern struct attribute_group seamldr_group;
+#define SEAMLDR_GROUP (&seamldr_group)
+int get_seamldr_info(void);
+#else
+#define SEAMLDR_GROUP NULL
+static inline int get_seamldr_info(void) { return 0; }
+#endif
+
+#endif
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 5f1f463ddfe1..aa6a23d46494 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -41,6 +41,7 @@
 #include <asm/processor.h>
 #include <asm/mce.h>
 #include "tdx.h"
+#include "seamldr.h"
 
 static u32 tdx_global_keyid __ro_after_init;
 static u32 tdx_guest_keyid_start __ro_after_init;
@@ -1147,13 +1148,24 @@ static struct tdx_tsm *init_tdx_tsm(void)
 	return no_free_ptr(tsm);
 }
 
+static const struct attribute_group *tdx_subsys_groups[] = {
+	SEAMLDR_GROUP,
+	NULL,
+};
+
 static void tdx_subsys_init(void)
 {
 	struct tdx_tsm *tdx_tsm;
 	int err;
 
+	err = get_seamldr_info();
+	if (err) {
+		pr_err("failed to get seamldr info %d\n", err);
+		return;
+	}
+
 	/* Establish subsystem for global TDX module attributes */
-	err = subsys_virtual_register(&tdx_subsys, NULL);
+	err = subsys_virtual_register(&tdx_subsys, tdx_subsys_groups);
 	if (err) {
 		pr_err("failed to register tdx_subsys %d\n", err);
 		return;
-- 
2.47.1


