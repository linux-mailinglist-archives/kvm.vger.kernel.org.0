Return-Path: <kvm+bounces-29840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 661109B3090
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 13:42:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97B711C21AEB
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 12:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53B7D1DA614;
	Mon, 28 Oct 2024 12:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YIzCjgR1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE301DC739;
	Mon, 28 Oct 2024 12:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730119301; cv=none; b=c75UWSDebAxL0GTZCquWKmHQc2BD2C2HtvjstlGJt7tkYLbnl6lxMYlqgTxIMim/aUt09FllzX0lfOyyBBin1mQx2ljdJRklYXA4wIugrfdndPbcXIX8fgDjJ9Axnab21TGH4dD1w6YiTSWIERu/gzDKRy5G4iqYmPwOEO7wpNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730119301; c=relaxed/simple;
	bh=ca6gBoErvIwSnOkcvuqYsb31q9cZSpjDurgrrHmwuoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlGcArszdapeg/JO/dy7BOYwzPPuT6DYa7uxalN1r+cvTHoyF9BO1wtVPaUAmRXMiFxWDoXEgBjQoH8c5V52/DKU3udsoWTC64lP7cqG4AYP358BiiD+O7Jlb/9N/iRP8NttaSKpO0/KHugY9JoUFxMeSvpF1i7llnHbH4b354E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YIzCjgR1; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730119299; x=1761655299;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ca6gBoErvIwSnOkcvuqYsb31q9cZSpjDurgrrHmwuoU=;
  b=YIzCjgR1Kv+RUhfWeSkqnXdWcjbvxa8AxMH0EFIRLDdiib50FGHf+uum
   rz6d1zwGtjBgzXOyGNvOdFczGv79zd1EBDMPVojE9Vjl0Lq6LmB3XGs5b
   EnCfelLw8e08eFKTvkULkxkzVbVDXw71hXdBwivdiirxG9KzOb0ndq6Pc
   t2o1KckY7WiGVD+6kXA1YsyuvTLj7WKqKMCcv9h8jo+dW4lTs9EWSm83/
   wvn7ti+0FZzdGdv9FbiqGgOz68SMt22ya/o0MAT1wEPEsVw1fRWQv26jB
   IpX6GMQ8R/bYvSjTM3YrGUa57LBJHcl5TaGOHxwHMdJ52YE3OJd9abf4A
   w==;
X-CSE-ConnectionGUID: udoBBDT2SZynD9kwWHDjog==
X-CSE-MsgGUID: m+U1tYgMRISyS3AkB7VUsQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="32575259"
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="32575259"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:41:38 -0700
X-CSE-ConnectionGUID: FjU2ZWj/Qz+TiUQsWhfnCw==
X-CSE-MsgGUID: IoQREz8YQb+Aw7yz4rJJTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="82420899"
Received: from gargmani-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.169])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:41:34 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	dan.j.williams@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	adrian.hunter@intel.com,
	nik.borisov@suse.com,
	kai.huang@intel.com
Subject: [PATCH v6 03/10] x86/virt/tdx: Use auto-generated code to read global metadata
Date: Tue, 29 Oct 2024 01:41:05 +1300
Message-ID: <8955c0e6f0ae801a8166c920b669746da037bccd.1730118186.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1730118186.git.kai.huang@intel.com>
References: <cover.1730118186.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paolo Bonzini <pbonzini@redhat.com>

The TDX module provides a set of "Global Metadata Fields".  Currently
the kernel only reads "TD Memory Region" (TDMR) related fields for
module initialization.  There are needs to read more global metadata
fields including TDX module version [1], supported features [2] and
"Convertible Memory Regions" (CMRs) to fix a module initialization
failure [3].  Future changes to support KVM TDX and other features like
TDX Connect will need to read more.

The current global metadata reading code has limitations (e.g., it only
has a primitive helper to read metadata field with 16-bit element size,
while TDX supports 8/16/32/64 bits metadata element sizes).  It needs
tweaks in order to read more metadata fields.

But even with the tweaks, when new code is added to read a new field,
the reviewers will still need to review against the spec to make sure
the new code doesn't screw up things like using the wrong metadata
field ID (each metadata field is associated with a unique field ID,
which is a TDX-defined u64 constant) etc.

TDX documents all global metadata fields in a 'global_metadata.json'
file as part of TDX spec [4].  JSON format is machine readable.  Instead
of tweaking the metadata reading code, use a script [5] to generate the
code so that:

  1) Using the generated C is simple.
  2) Adding a field is dirty simple, e.g., the script just pulls the
     field ID out of the JSON for a given field thus no manual review is
     needed.

Specifically, to match the layout of the 'struct tdx_sys_info' and its
sub-structures, the script uses a table with each entry containing the
the name of the sub-structures (which reflects the "Class") and the
"Field Name" of all its fields, and auto-generate:

  1) The 'struct tdx_sys_info' and all 'struct tdx_sys_info_xx'
     sub-structures in 'tdx_global_metadata.h'

  2) The main function 'get_tdx_sys_info()' which reads all metadata to
     'struct tdx_sys_info' and the 'get_tdx_sys_info_xx()' functions
     which read 'struct tdx_sys_info_xx()' in 'tdx_global_metadata.c'.

Using the generated C is simple: 1) include "tdx_global_metadata.h" to
the local "tdx.h"; 2) explicitly include "tdx_global_metadata.c" to the
local "tdx.c" after the read_sys_metadata_field() primitive (which is a
wrapper of TDH.SYS.RD SEAMCALL to read global metadata).

Adding a field is also simple: 1) just add the new field to an existing
structure, or add it with a new structure; 2) re-run the script to
generate the new code; 3) update the existing tdx_global_metadata.{hc}
with the new ones.

For now, use the auto-generated code to read the aforesaid metadata
fields: 1) TDX module version; 2) supported features; 3) CMRs.

Reading CMRs is more complicated than reading a simple field, since
there are two arrays containing the "CMR_BASE" and "CMR_SIZE" for each
CMR respectively.

TDX spec [3] section "Metadata Access Interface", sub-section "Arrays of
Metadata Fields" defines the way to read metadata fields in an array.
There's a "Base field ID" (say, X) for the array and the field ID for
entry array[i] is X + i.

For CMRs, the field "NUM_CMRS" reports the number of CMR entries that
can be read, and the code needs to use the value reported via "NUM_CMRS"
to loop despite the JSON file says the "Num Fields" of both "CMR_BASE"
and "CMR_SIZE" are 32.

The tdx_global_metadata.{hc} can be generated by running below:

 #python tdx.py global_metadata.json tdx_global_metadata.h \
	tdx_global_metadata.c

.. where tdx.py can be found in [5] and global_metadata.json can be
fetched from [4].

Link: https://lore.kernel.org/lkml/4b3adb59-50ea-419e-ad02-e19e8ca20dee@intel.com/ [1]
Link: https://lore.kernel.org/all/fc0e8ab7-86d4-4428-be31-82e1ece6dd21@intel.com/ [2]
Link: https://github.com/canonical/tdx/issues/135 [3]
Link: https://cdrdv2.intel.com/v1/dl/getContent/795381 [4]
Link: https://lore.kernel.org/kvm/0853b155ec9aac09c594caa60914ed6ea4dc0a71.camel@intel.com/ [5]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 89 +++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx_global_metadata.h | 42 ++++++++++
 2 files changed, 131 insertions(+)
 create mode 100644 arch/x86/virt/vmx/tdx/tdx_global_metadata.c
 create mode 100644 arch/x86/virt/vmx/tdx/tdx_global_metadata.h

diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
new file mode 100644
index 000000000000..2fe57e084453
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Automatically generated functions to read TDX global metadata.
+ *
+ * This file doesn't compile on its own as it lacks of inclusion
+ * of SEAMCALL wrapper primitive which reads global metadata.
+ * Include this file to other C file instead.
+ */
+
+static int get_tdx_sys_info_version(struct tdx_sys_info_version *sysinfo_version)
+{
+	int ret = 0;
+	u64 val;
+
+	if (!ret && !(ret = read_sys_metadata_field(0x8800000200000001, &val)))
+		sysinfo_version->build_date = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x8800000100000002, &val)))
+		sysinfo_version->build_num = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x0800000100000003, &val)))
+		sysinfo_version->minor_version = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x0800000100000004, &val)))
+		sysinfo_version->major_version = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x0800000100000005, &val)))
+		sysinfo_version->update_version = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x0800000100000006, &val)))
+		sysinfo_version->internal_version = val;
+
+	return ret;
+}
+
+static int get_tdx_sys_info_features(struct tdx_sys_info_features *sysinfo_features)
+{
+	int ret = 0;
+	u64 val;
+
+	if (!ret && !(ret = read_sys_metadata_field(0x0A00000300000008, &val)))
+		sysinfo_features->tdx_features0 = val;
+
+	return ret;
+}
+
+static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
+{
+	int ret = 0;
+	u64 val;
+
+	if (!ret && !(ret = read_sys_metadata_field(0x9100000100000008, &val)))
+		sysinfo_tdmr->max_tdmrs = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x9100000100000009, &val)))
+		sysinfo_tdmr->max_reserved_per_tdmr = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x9100000100000010, &val)))
+		sysinfo_tdmr->pamt_4k_entry_size = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x9100000100000011, &val)))
+		sysinfo_tdmr->pamt_2m_entry_size = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x9100000100000012, &val)))
+		sysinfo_tdmr->pamt_1g_entry_size = val;
+
+	return ret;
+}
+
+static int get_tdx_sys_info_cmr(struct tdx_sys_info_cmr *sysinfo_cmr)
+{
+	int ret = 0;
+	u64 val;
+	int i;
+
+	if (!ret && !(ret = read_sys_metadata_field(0x9000000100000000, &val)))
+		sysinfo_cmr->num_cmrs = val;
+	for (i = 0; i < sysinfo_cmr->num_cmrs; i++)
+		if (!ret && !(ret = read_sys_metadata_field(0x9000000300000080 + i, &val)))
+			sysinfo_cmr->cmr_base[i] = val;
+	for (i = 0; i < sysinfo_cmr->num_cmrs; i++)
+		if (!ret && !(ret = read_sys_metadata_field(0x9000000300000100 + i, &val)))
+			sysinfo_cmr->cmr_size[i] = val;
+
+	return ret;
+}
+
+static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
+{
+	int ret = 0;
+
+	ret = ret ?: get_tdx_sys_info_version(&sysinfo->version);
+	ret = ret ?: get_tdx_sys_info_features(&sysinfo->features);
+	ret = ret ?: get_tdx_sys_info_tdmr(&sysinfo->tdmr);
+	ret = ret ?: get_tdx_sys_info_cmr(&sysinfo->cmr);
+
+	return ret;
+}
diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.h b/arch/x86/virt/vmx/tdx/tdx_global_metadata.h
new file mode 100644
index 000000000000..fde370b855f1
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Automatically generated TDX global metadata structures. */
+#ifndef _X86_VIRT_TDX_AUTO_GENERATED_TDX_GLOBAL_METADATA_H
+#define _X86_VIRT_TDX_AUTO_GENERATED_TDX_GLOBAL_METADATA_H
+
+#include <linux/types.h>
+
+struct tdx_sys_info_version {
+	u32 build_date;
+	u16 build_num;
+	u16 minor_version;
+	u16 major_version;
+	u16 update_version;
+	u16 internal_version;
+};
+
+struct tdx_sys_info_features {
+	u64 tdx_features0;
+};
+
+struct tdx_sys_info_tdmr {
+	u16 max_tdmrs;
+	u16 max_reserved_per_tdmr;
+	u16 pamt_4k_entry_size;
+	u16 pamt_2m_entry_size;
+	u16 pamt_1g_entry_size;
+};
+
+struct tdx_sys_info_cmr {
+	u16 num_cmrs;
+	u64 cmr_base[32];
+	u64 cmr_size[32];
+};
+
+struct tdx_sys_info {
+	struct tdx_sys_info_version version;
+	struct tdx_sys_info_features features;
+	struct tdx_sys_info_tdmr tdmr;
+	struct tdx_sys_info_cmr cmr;
+};
+
+#endif
-- 
2.46.2


