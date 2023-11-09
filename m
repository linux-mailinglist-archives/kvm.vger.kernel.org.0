Return-Path: <kvm+bounces-1328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC4047E6A09
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 12:57:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DFFA2816F2
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 11:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A1361DDCD;
	Thu,  9 Nov 2023 11:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uau8eGnj"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D2A1DDC3
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 11:57:13 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE86C2D7D;
	Thu,  9 Nov 2023 03:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699531033; x=1731067033;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iRw/7o3GBH3rgTuNU/jnAifT9CuYYfdUdyZ07EP/mh0=;
  b=Uau8eGnj6m8VFCETzSxOHFIa3+CRGt+mpFXTtIMW5Np3V413fAgEkj+P
   LNizOipm6bm3L3qoEYKq3+qxhZavMrrKPTDoJqgqj1uGRFL2nNJ7KXVYT
   cw50sjjoq7ND7myo9yUsuYdFragOCG3lsqttY1nPTKZF/MIfbGuiuNFio
   WNQMBAT2N30bPmU/HSrWMDuYtTk+6wT/7cnbA5Ixdy72PFoHw7IjTpszn
   JbwHgZCSAh1K0Et3e30w44FUsmm7Hsj6ZmnP/2xd6dT2/8kJ9DdXHq/ys
   bs6C2s+T83l5Gn3FYNvcC5OYlBbKCSIQgS3hObdDzh/HOPP6ZqBhR8BH1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="2936497"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="2936497"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:57:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="766976731"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="766976731"
Received: from shadphix-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.83.35])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:57:06 -0800
From: Kai Huang <kai.huang@intel.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: x86@kernel.org,
	dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	peterz@infradead.org,
	tony.luck@intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	rafael@kernel.org,
	david@redhat.com,
	dan.j.williams@intel.com,
	len.brown@intel.com,
	ak@linux.intel.com,
	isaku.yamahata@intel.com,
	ying.huang@intel.com,
	chao.gao@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com,
	nik.borisov@suse.com,
	bagasdotme@gmail.com,
	sagis@google.com,
	imammedo@redhat.com,
	kai.huang@intel.com
Subject: [PATCH v15 09/23] x86/virt/tdx: Get module global metadata for module initialization
Date: Fri, 10 Nov 2023 00:55:46 +1300
Message-ID: <30906e3cf94fe48d713de21a04ffd260bd1a7268.1699527082.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1699527082.git.kai.huang@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The TDX module global metadata provides system-wide information about
the module.  The TDX module provides SEAMCALls to allow the kernel to
query one specific global metadata field (entry) or all fields.

TL;DR:

Use the TDH.SYS.RD SEAMCALL to read the essential global metadata for
module initialization, and at the same time, to only initialize TDX
module with version 1.5 and later.

Long Version:

1) Only initialize TDX module with version 1.5 and later

TDX module 1.0 has some compatibility issues with the later versions of
module, as documented in the "Intel TDX module ABI incompatibilities
between TDX1.0 and TDX1.5" spec.  Basically there's no value to use TDX
module 1.0 when TDX module 1.5 and later versions are already available.
To keep things simple, just support initializing the TDX module 1.5 and
later.

2) Get the essential global metadata for module initialization

TDX reports a list of "Convertible Memory Region" (CMR) to tell the
kernel which memory is TDX compatible.  The kernel needs to build a list
of memory regions (out of CMRs) as "TDX-usable" memory and pass them to
the TDX module.  The kernel does this by constructing a list of "TD
Memory Regions" (TDMRs) to cover all these memory regions and passing
them to the TDX module.

Each TDMR is a TDX architectural data structure containing the memory
region that the TDMR covers, plus the information to track (within this
TDMR): a) the "Physical Address Metadata Table" (PAMT) to track each TDX
memory page's status (such as which TDX guest "owns" a given page, and
b) the "reserved areas" to tell memory holes that cannot be used as TDX
memory.

The kernel needs to get below metadata from the TDX module to build the
list of TDMRs: a) the maximum number of supported TDMRs, b) the maximum
number of supported reserved areas per TDMR and, c) the PAMT entry size
for each TDX-supported page size.

Note the TDX module internally checks whether the "TDX-usable" memory
regions passed via TDMRs are truly convertible.  Just skipping reading
the CMRs and manually checking memory regions against them, but let the
TDX module do the check.

== Implementation ==

TDX module 1.0 uses TDH.SYS.INFO SEAMCALL to report the global metadata
in a fixed-size (1024-bytes) structure 'TDSYSINFO_STRUCT'.  TDX module
1.5 adds more metadata fields, and introduces the new TDH.SYS.{RD|RDALL}
SEAMCALLs for reading the metadata.  The new metadata mechanism removes
the fixed-size limitation of the structure 'TDSYSINFO_STRUCT' and allows
the TDX module to support unlimited number of metadata fields.

TDX module 1.5 and later versions still support the TDH.SYS.INFO for
compatibility to the TDX module 1.0, but it may only report part of
metadata via the 'TDSYSINFO_STRUCT'.  For any new metadata the kernel
must use TDH.SYS.{RD|RDALL} to read.

To achieve the above two goals mentioned in 1) and 2), just use the
TDH.SYS.RD to read the essential metadata fields related to the TDMRs.

TDH.SYS.RD returns *one* metadata field at a given "Metadata Field ID".
It is enough for getting these few fields for module initialization.
On the other hand, TDH.SYS.RDALL reports all metadata fields to a 4KB
buffer provided by the kernel which is a little bit overkill here.

It may be beneficial to get all metadata fields at once here so they can
also be used by KVM (some are essential for creating basic TDX guests),
but technically it's unknown how many 4K pages are needed to fill all
the metadata.  Thus it's better to read metadata when needed.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v14 -> v15:
 - New patch to use TDH.SYS.RD to read TDX module global metadata for
   module initialization and stop initializing 1.0 module.

---
 arch/x86/include/asm/shared/tdx.h |  1 +
 arch/x86/virt/vmx/tdx/tdx.c       | 75 ++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h       | 39 ++++++++++++++++
 3 files changed, 114 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index a4036149c484..fdfd41511b02 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -59,6 +59,7 @@
 #define TDX_PS_4K	0
 #define TDX_PS_2M	1
 #define TDX_PS_1G	2
+#define TDX_PS_NR	(TDX_PS_1G + 1)
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index d1affb30f74d..d24027993983 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -235,8 +235,75 @@ static int build_tdx_memlist(struct list_head *tmb_list)
 	return ret;
 }
 
+static int read_sys_metadata_field(u64 field_id, u64 *data)
+{
+	struct tdx_module_args args = {};
+	int ret;
+
+	/*
+	 * TDH.SYS.RD -- reads one global metadata field
+	 *  - RDX (in): the field to read
+	 *  - R8 (out): the field data
+	 */
+	args.rdx = field_id;
+	ret = seamcall_prerr_ret(TDH_SYS_RD, &args);
+	if (ret)
+		return ret;
+
+	*data = args.r8;
+
+	return 0;
+}
+
+static int read_sys_metadata_field16(u64 field_id, u16 *data)
+{
+	u64 _data;
+	int ret;
+
+	if (WARN_ON_ONCE(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=
+			MD_FIELD_ID_ELE_SIZE_16BIT))
+		return -EINVAL;
+
+	ret = read_sys_metadata_field(field_id, &_data);
+	if (ret)
+		return ret;
+
+	*data = (u16)_data;
+
+	return 0;
+}
+
+static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
+{
+	int ret;
+
+	ret = read_sys_metadata_field16(MD_FIELD_ID_MAX_TDMRS,
+			&tdmr_sysinfo->max_tdmrs);
+	if (ret)
+		return ret;
+
+	ret = read_sys_metadata_field16(MD_FIELD_ID_MAX_RESERVED_PER_TDMR,
+			&tdmr_sysinfo->max_reserved_per_tdmr);
+	if (ret)
+		return ret;
+
+	ret = read_sys_metadata_field16(MD_FIELD_ID_PAMT_4K_ENTRY_SIZE,
+			&tdmr_sysinfo->pamt_entry_size[TDX_PS_4K]);
+	if (ret)
+		return ret;
+
+	ret = read_sys_metadata_field16(MD_FIELD_ID_PAMT_2M_ENTRY_SIZE,
+			&tdmr_sysinfo->pamt_entry_size[TDX_PS_2M]);
+	if (ret)
+		return ret;
+
+	return read_sys_metadata_field16(MD_FIELD_ID_PAMT_1G_ENTRY_SIZE,
+			&tdmr_sysinfo->pamt_entry_size[TDX_PS_1G]);
+}
+
 static int init_tdx_module(void)
 {
+	struct tdx_tdmr_sysinfo tdmr_sysinfo;
 	int ret;
 
 	/*
@@ -255,10 +322,13 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_put_tdxmem;
 
+	ret = get_tdx_tdmr_sysinfo(&tdmr_sysinfo);
+	if (ret)
+		goto out_free_tdxmem;
+
 	/*
 	 * TODO:
 	 *
-	 *  - Get TDX module "TD Memory Region" (TDMR) global metadata.
 	 *  - Construct a list of TDMRs to cover all TDX-usable memory
 	 *    regions.
 	 *  - Configure the TDMRs and the global KeyID to the TDX module.
@@ -268,6 +338,9 @@ static int init_tdx_module(void)
 	 *  Return error before all steps are done.
 	 */
 	ret = -EINVAL;
+out_free_tdxmem:
+	if (ret)
+		free_tdx_memlist(&tdx_memlist);
 out_put_tdxmem:
 	/*
 	 * @tdx_memlist is written here and read at memory hotplug time.
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index c11e0a7ca664..29cdf5ea5544 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -2,6 +2,8 @@
 #ifndef _X86_VIRT_TDX_H
 #define _X86_VIRT_TDX_H
 
+#include <linux/bits.h>
+
 /*
  * This file contains both macros and data structures defined by the TDX
  * architecture and Linux defined software data structures and functions.
@@ -13,8 +15,38 @@
  * TDX module SEAMCALL leaf functions
  */
 #define TDH_SYS_INIT		33
+#define TDH_SYS_RD		34
 #define TDH_SYS_LP_INIT		35
 
+/*
+ * Global scope metadata field ID.
+ *
+ * See Table "Global Scope Metadata", TDX module 1.5 ABI spec.
+ */
+#define MD_FIELD_ID_MAX_TDMRS			0x9100000100000008ULL
+#define MD_FIELD_ID_MAX_RESERVED_PER_TDMR	0x9100000100000009ULL
+#define MD_FIELD_ID_PAMT_4K_ENTRY_SIZE		0x9100000100000010ULL
+#define MD_FIELD_ID_PAMT_2M_ENTRY_SIZE		0x9100000100000011ULL
+#define MD_FIELD_ID_PAMT_1G_ENTRY_SIZE		0x9100000100000012ULL
+
+/*
+ * Sub-field definition of metadata field ID.
+ *
+ * See Table "MD_FIELD_ID (Metadata Field Identifier / Sequence Header)
+ * Definition", TDX module 1.5 ABI spec.
+ *
+ *  - Bit 33:32: ELEMENT_SIZE_CODE -- size of a single element of metadata
+ *
+ *	0: 8 bits
+ *	1: 16 bits
+ *	2: 32 bits
+ *	3: 64 bits
+ */
+#define MD_FIELD_ID_ELE_SIZE_CODE(_field_id)	\
+		(((_field_id) & GENMASK_ULL(33, 32)) >> 32)
+
+#define MD_FIELD_ID_ELE_SIZE_16BIT	1
+
 /*
  * Do not put any hardware-defined TDX structure representations below
  * this comment!
@@ -33,4 +65,11 @@ struct tdx_memblock {
 	unsigned long end_pfn;
 };
 
+/* "TDMR info" part of "Global Scope Metadata" for constructing TDMRs */
+struct tdx_tdmr_sysinfo {
+	u16 max_tdmrs;
+	u16 max_reserved_per_tdmr;
+	u16 pamt_entry_size[TDX_PS_NR];
+};
+
 #endif
-- 
2.41.0


