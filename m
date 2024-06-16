Return-Path: <kvm+bounces-19744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D01C7909D3A
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 14:04:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDF2F1F21367
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 12:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8364418FDD3;
	Sun, 16 Jun 2024 12:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I6xWRNnw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2125918FDB8;
	Sun, 16 Jun 2024 12:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718539330; cv=none; b=CEYq0VG9WF60W4VGTTf1SFDI4TRrBbh7k6kDCMcNmcTQi2yhGQa4C/myQ6Zr13iep8Rds7JBrElyjDDBVgL93P5Td3sBNG+TXw7tNhIA8ipHfWDqE208zVVVUsB0+jDJ3kRIOxLu8H4F8jFdB5Q/bj47TGQ17AlCo4uA8RmDOac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718539330; c=relaxed/simple;
	bh=NPmj8dFgrE18hffcZbQUkVcIJfWHNVXzEZiodSQgNNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiNJLgSd3N8mibu25/lx2fBNa9zsZG+jrliLldyHc7qY90KZEW4UO1uZpcr0is6uMZorhYlxfftCcT2BPI31IvvX+KuYk7Obc3hi3+iDgLbC+Y8KkYv/3uUw4rCtvw0f1kNni8o1lPJ+hzoqvPVmpv5TeRv+ALDLJdtW7sE+KoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I6xWRNnw; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718539329; x=1750075329;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NPmj8dFgrE18hffcZbQUkVcIJfWHNVXzEZiodSQgNNI=;
  b=I6xWRNnw1r1qUc3oIVjPohXxf6jM8CecxVK7maHjwoi3lTLDeoJ6gl8Q
   7nPrfDCW8lMafntY4eQD7wYKEyNx81ge/H4buLahV8ELfC7HkVkZH6mqa
   NfF5gJhWiJseNQKuz7Ol/3/Hnz6o4ULmzwHJVQdK5qSWA0AyIY/qqQPEF
   Zlq1O4yHukF/jCwAh4IMd1F/cS+qB8rPO9b4UNsT23cnbFj5fqHnXwkTE
   GgYUJ5Fv0tWWHZZquxojQxQMEboZ1bDBDICKYaVHaAO27okL/JTbcyctf
   /5U6YMvPpkDKaf5E+vnKxoPgFpjYEFw/hE8k3ZgPMCGEayyPtGEbS9OMZ
   w==;
X-CSE-ConnectionGUID: ZA4MHHRKSN+qHVBvhEZrEQ==
X-CSE-MsgGUID: vCXrHuxSQ/Wy6BidYnKpvA==
X-IronPort-AV: E=McAfee;i="6700,10204,11104"; a="26800052"
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="26800052"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:02:09 -0700
X-CSE-ConnectionGUID: gfJxBBPCTx+aGLps5pVu5w==
X-CSE-MsgGUID: jx0452ZCTV2I4mLjBDQG5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="46055906"
Received: from mgoodin-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.226])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:02:05 -0700
From: Kai Huang <kai.huang@intel.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org,
	dave.hansen@intel.com,
	dan.j.williams@intel.com,
	kirill.shutemov@linux.intel.com,
	rick.p.edgecombe@intel.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	kai.huang@intel.com
Subject: [PATCH 7/9] x86/virt/tdx: Print TDX module basic information
Date: Mon, 17 Jun 2024 00:01:17 +1200
Message-ID: <f81ed362dcb88bdb60859b998d5b9a4ee258a5f3.1718538552.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <cover.1718538552.git.kai.huang@intel.com>
References: <cover.1718538552.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the kernel doesn't print any information regarding the TDX
module itself, e.g. module version.  Printing such information is not
mandatory for initializing the TDX module, but in practice such
information is useful, especially to the developers.

For instance, there are couple of use cases for dumping module basic
information:

1) When something goes wrong around using TDX, the information like TDX
   module version, supported features etc could be helpful [1][2].

2) For Linux, when the user wants to update the TDX module, one needs to
   replace the old module in a specific location in the EFI partition
   with the new one so that after reboot the BIOS can load it.  However,
   after kernel boots, currently the user has no way to verify it is
   indeed the new module that gets loaded and initialized (e.g., error
   could happen when replacing the old module).  With the module version
   dumped the user can verify this easily.

So dump the basic TDX module information:

 - TDX module type: Debug or Production.
 - TDX_FEATURES0: Supported TDX features.
 - TDX module version, and the build date.

And dump the information right after reading global metadata, so that
this information is printed no matter whether module initialization
fails or not.

The actual dmesg will look like:

  virt/tdx: Production module.
  virt/tdx: TDX_FEATURES0: 0xfbf
  virt/tdx: Module version: 1.5.00.00.0481, build_date: 20230323

Link: https://lore.kernel.org/lkml/e2d844ad-182a-4fc0-a06a-d609c9cbef74@suse.com/T/#m352829aedf6680d4628c7e40dc40b332eda93355 [1]
Link: https://lore.kernel.org/lkml/e2d844ad-182a-4fc0-a06a-d609c9cbef74@suse.com/T/#m351ebcbc006d2e5bc3e7650206a087cb2708d451 [2]
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 67 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 33 +++++++++++++++++-
 2 files changed, 99 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 4683884efcc6..ced40e3b516e 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -319,6 +319,61 @@ static int stbuf_read_sysmd_multi(const struct field_mapping *fields,
 	return 0;
 }
 
+#define TD_SYSINFO_MAP_MOD_INFO(_field_id, _member)	\
+	TD_SYSINFO_MAP(_field_id, struct tdx_sysinfo_module_info, _member)
+
+static int get_tdx_module_info(struct tdx_sysinfo_module_info *modinfo)
+{
+	static const struct field_mapping fields[] = {
+		TD_SYSINFO_MAP_MOD_INFO(SYS_ATTRIBUTES, sys_attributes),
+		TD_SYSINFO_MAP_MOD_INFO(TDX_FEATURES0,  tdx_features0),
+	};
+
+	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), modinfo);
+}
+
+#define TD_SYSINFO_MAP_MOD_VERSION(_field_id, _member)	\
+	TD_SYSINFO_MAP(_field_id, struct tdx_sysinfo_module_version, _member)
+
+static int get_tdx_module_version(struct tdx_sysinfo_module_version *modver)
+{
+	static const struct field_mapping fields[] = {
+		TD_SYSINFO_MAP_MOD_VERSION(MAJOR_VERSION,    major),
+		TD_SYSINFO_MAP_MOD_VERSION(MINOR_VERSION,    minor),
+		TD_SYSINFO_MAP_MOD_VERSION(UPDATE_VERSION,   update),
+		TD_SYSINFO_MAP_MOD_VERSION(INTERNAL_VERSION, internal),
+		TD_SYSINFO_MAP_MOD_VERSION(BUILD_NUM,	     build_num),
+		TD_SYSINFO_MAP_MOD_VERSION(BUILD_DATE,	     build_date),
+	};
+
+	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), modver);
+}
+
+static void print_basic_sysinfo(struct tdx_sysinfo *sysinfo)
+{
+	struct tdx_sysinfo_module_version *modver = &sysinfo->module_version;
+	struct tdx_sysinfo_module_info *modinfo = &sysinfo->module_info;
+	bool debug = modinfo->sys_attributes & TDX_SYS_ATTR_DEBUG_MODULE;
+
+	pr_info("%s module.\n", debug ? "Debug" : "Production");
+
+	pr_info("TDX_FEATURES0: 0x%llx\n", modinfo->tdx_features0);
+
+	/*
+	 * TDX module version encoding:
+	 *
+	 *   <major>.<minor>.<update>.<internal>.<build_num>
+	 *
+	 * When printed as text, <major> and <minor> are 1-digit,
+	 * <update> and <internal> are 2-digits and <build_num>
+	 * is 4-digits.
+	 */
+	pr_info("Module version: %u.%u.%02u.%02u.%04u, build_date: %u\n",
+			modver->major,		modver->minor,
+			modver->update,		modver->internal,
+			modver->build_num,	modver->build_date);
+}
+
 #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
 	TD_SYSINFO_MAP(_field_id, struct tdx_sysinfo_tdmr_info, _member)
 
@@ -339,6 +394,16 @@ static int get_tdx_tdmr_sysinfo(struct tdx_sysinfo_tdmr_info *tdmr_sysinfo)
 
 static int get_tdx_sysinfo(struct tdx_sysinfo *sysinfo)
 {
+	int ret;
+
+	ret = get_tdx_module_info(&sysinfo->module_info);
+	if (ret)
+		return ret;
+
+	ret = get_tdx_module_version(&sysinfo->module_version);
+	if (ret)
+		return ret;
+
 	return get_tdx_tdmr_sysinfo(&sysinfo->tdmr_info);
 }
 
@@ -1121,6 +1186,8 @@ static int init_tdx_module(void)
 	if (ret)
 		return ret;
 
+	print_basic_sysinfo(&sysinfo);
+
 	/*
 	 * To keep things simple, assume that all TDX-protected memory
 	 * will come from the page allocator.  Make sure all pages in the
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 6b61dc67b0af..d80ec797fbf1 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -31,6 +31,15 @@
  *
  * See Table "Global Scope Metadata", TDX module 1.5 ABI spec.
  */
+#define MD_FIELD_ID_SYS_ATTRIBUTES		0x0A00000200000000ULL
+#define MD_FIELD_ID_TDX_FEATURES0		0x0A00000300000008ULL
+#define MD_FIELD_ID_BUILD_DATE			0x8800000200000001ULL
+#define MD_FIELD_ID_BUILD_NUM			0x8800000100000002ULL
+#define MD_FIELD_ID_MINOR_VERSION		0x0800000100000003ULL
+#define MD_FIELD_ID_MAJOR_VERSION		0x0800000100000004ULL
+#define MD_FIELD_ID_UPDATE_VERSION		0x0800000100000005ULL
+#define MD_FIELD_ID_INTERNAL_VERSION		0x0800000100000006ULL
+
 #define MD_FIELD_ID_MAX_TDMRS			0x9100000100000008ULL
 #define MD_FIELD_ID_MAX_RESERVED_PER_TDMR	0x9100000100000009ULL
 #define MD_FIELD_ID_PAMT_4K_ENTRY_SIZE		0x9100000100000010ULL
@@ -124,8 +133,28 @@ struct tdmr_info_list {
  *
  * Note not all metadata fields in each class are defined, only those
  * used by the kernel are.
+ *
+ * Also note the "bit definitions" are architectural.
  */
 
+/* Class "TDX Module Info" */
+struct tdx_sysinfo_module_info {
+	u32 sys_attributes;
+	u64 tdx_features0;
+};
+
+#define TDX_SYS_ATTR_DEBUG_MODULE	0x1
+
+/* Class "TDX Module Version" */
+struct tdx_sysinfo_module_version {
+	u16 major;
+	u16 minor;
+	u16 update;
+	u16 internal;
+	u16 build_num;
+	u32 build_date;
+};
+
 /* Class "TDMR Info" */
 struct tdx_sysinfo_tdmr_info {
 	u16 max_tdmrs;
@@ -134,7 +163,9 @@ struct tdx_sysinfo_tdmr_info {
 };
 
 struct tdx_sysinfo {
-	struct tdx_sysinfo_tdmr_info tdmr_info;
+	struct tdx_sysinfo_module_info		module_info;
+	struct tdx_sysinfo_module_version	module_version;
+	struct tdx_sysinfo_tdmr_info		tdmr_info;
 };
 
 #endif
-- 
2.43.2


