Return-Path: <kvm+bounces-31442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 448FA9C3C3A
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 11:43:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A3531F22293
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 10:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18D8619D08A;
	Mon, 11 Nov 2024 10:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FlQUtqjB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0501990A8;
	Mon, 11 Nov 2024 10:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731321626; cv=none; b=ptleNrCbEL0T5ykmE23c0+ydvRrc0HOiiuT1sg1gJhP2ZTc7nnVu17MQ+k9E8Ge/GI4rz2/BwA2ZYpSwlr+IBs9djQiDBMUc8l/Pz3kZrOY4gAkIfMfHbA1Nw99qhius8AnBIZnAgZaKcHX4Ex/BHtZdgBXN2uAd6qxkJwOVWjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731321626; c=relaxed/simple;
	bh=VAWncTV2X6H27WsHuc8Fo/M3JkMorsbuajvOQNvQgZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tq9mRiBCYyvxXe0rwwCoTT0b1v9KO4VN+FZKd7f2GnK02mCd6Tz2kjULHy2y2i3qwB0M2kVoQx70wCfrsVJ3DTaTUb01qdOHC4tNVcZMMJSUBni9+EqCU+dkNdQHPH5qhD2Z1tlCRlScWk9xjRg4/BX7Kvsm0iK65NbkaEPBjcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FlQUtqjB; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731321625; x=1762857625;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VAWncTV2X6H27WsHuc8Fo/M3JkMorsbuajvOQNvQgZk=;
  b=FlQUtqjBi2UoyjgJm7B3G+YvHVmf0xTxZsgBM520OSJox38EncTAK9Vg
   nrieoaqeRgPKdkBLTdXgwYni1YokqRmihTwhX+cNIQBsgXidUJarwMQcQ
   b8eNjoZvDxF2mnXnNwhEuJRblrnmDZZObWrigkqatldl/3CDmog2+LH1j
   kmBYYKx1Px2suD3X09WCZ5ztVemqmYhmRePMLegYYcz7LEbsWvAXwXztI
   1hQQ90AwAiL6iosfGYKGprw6HlxkwvjP6fpl6SjoMh7fHR2V4YLmioHVX
   7vbmS2j0ZHLW6uZxlg0WbGOqi1YQUl053f0UpD2+3+D+/7DvWliP/HsRk
   g==;
X-CSE-ConnectionGUID: kzrE/yuJTXODgyThe8Dtnw==
X-CSE-MsgGUID: bRrDOZ/XTjSXmqZLK8+vmA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41682659"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41682659"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:25 -0800
X-CSE-ConnectionGUID: 3yZmEvwhRbiI0xHv3hrsYw==
X-CSE-MsgGUID: Trz9OY0nQwetOmZw8vVDFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,144,1728975600"; 
   d="scan'208";a="117667131"
Received: from uaeoff-desk2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.207])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:20 -0800
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
Subject: [PATCH v7 03/10] x86/virt/tdx: Use auto-generated code to read global metadata
Date: Mon, 11 Nov 2024 23:39:39 +1300
Message-ID: <695235e85bb990d8fe055acd21b6247dc0254ec0.1731318868.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1731318868.git.kai.huang@intel.com>
References: <cover.1731318868.git.kai.huang@intel.com>
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
  2) Adding a field is simple, e.g., the script just pulls the field ID
     out of the JSON for a given field thus no manual review is needed.

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

 #python tdx_global_metadata.py global_metadata.json \
	tdx_global_metadata.h tdx_global_metadata.c

.. where the tdx_global_metadata.py can be found in [5] and the
global_metadata.json can be fetched from [4].

Link: https://lore.kernel.org/4b3adb59-50ea-419e-ad02-e19e8ca20dee@intel.com/ [1]
Link: https://lore.kernel.org/fc0e8ab7-86d4-4428-be31-82e1ece6dd21@intel.com/ [2]
Link: https://github.com/canonical/tdx/issues/135 [3]
Link: https://cdrdv2.intel.com/v1/dl/getContent/795381 [4]
Link: https://lore.kernel.org/20241031104433.855336-1-kai.huang@intel.com/ [5]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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


