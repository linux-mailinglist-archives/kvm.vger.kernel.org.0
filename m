Return-Path: <kvm+bounces-25127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66A559602CF
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 09:17:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E94A41F231A9
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 07:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CD5E19925D;
	Tue, 27 Aug 2024 07:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="StrAYr4j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C963E1946B5;
	Tue, 27 Aug 2024 07:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724742912; cv=none; b=CCdCggjrjitFFi6lflVAFiw4Z1PyK2JPkHfxGg/CRqYLcI2GGL3Uzxr9l9FFNhHI1an57d1N0QTf4OJW2Mhyo0WZI3e6ZnkzkQikDrrjyWXJI/0wvJskWQczThS4EMsIUB3Hzpijm3WHeH1qOntmgzGy4xVDrsywn+grCySov9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724742912; c=relaxed/simple;
	bh=naR7oyrXnYK4ZyaV9GWH6oxGFu/wW9QWZ6ymgdAFMBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3k/9wJzdiG+EbLKM3GmX1M+ryWJHxS5/Lz0amg3JbUsyKFie88NIDiWEkyxWyHf8y1JhnDKkurtqdmq/UkdZfkk/viwOYIEObnBc/+KC9QOpBKJWDsHQto6b8ZvLEAB8GI69H4N3By8slCJE0xzUH/28gW0Ne5tZBbPDyDAb7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=StrAYr4j; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724742911; x=1756278911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=naR7oyrXnYK4ZyaV9GWH6oxGFu/wW9QWZ6ymgdAFMBQ=;
  b=StrAYr4jRJjk1bKYZ3zNWf1i+wJKZ+3yJbgMRSMGtl7+XAtTSprLvwqt
   YZt4x3IWl26ylmNG/DhhoHgGUK8TjsxaHxuDKu7XOx6c7zd1M6+4gq+qG
   goB5UrUE6488tVdJeaIrtM/6ugbd5CvEc8Q1WHmNYYvesi4+M7siVPcvY
   IDMyjv6lV5Jo158AMlLmXWJQr4YYkhecS8WpH652qruCa0Jnuf0rn8YGc
   6xHQsRNncEYaf2UgHAiOdIHKr02GQnF79TOLc6TVIXQLarUW9DXMOC3m0
   yjhtFbaLqCMMF9MsTmkWvcWkYsnE5mgTpdj5PaBlWWlebm/HuG0shF6z0
   A==;
X-CSE-ConnectionGUID: KliIB/9FRmaUOmc6XMkF1w==
X-CSE-MsgGUID: sagE2R+RTBOrDk0Obn1cng==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="34575883"
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="34575883"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 00:15:11 -0700
X-CSE-ConnectionGUID: OHirEoQzTJCyZy0tjKgG6g==
X-CSE-MsgGUID: 99XRxLVQSsaX0OPzQf41hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="63092600"
Received: from apaszkie-mobl2.apaszkie-mobl2 (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.81])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 00:15:06 -0700
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
	chao.gao@intel.com,
	binbin.wu@linux.intel.com,
	adrian.hunter@intel.com,
	kai.huang@intel.com
Subject: [PATCH v3 6/8] x86/virt/tdx: Print TDX module basic information
Date: Tue, 27 Aug 2024 19:14:28 +1200
Message-ID: <ab8349fe13ad04e6680e898614055fed29a2931b.1724741926.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1724741926.git.kai.huang@intel.com>
References: <cover.1724741926.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the kernel doesn't print any information regarding the TDX
module itself, e.g. module version.  In practice such information is
useful, especially to the developers.

For instance, there are a couple of use cases for dumping module basic
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

 - TDX module version, and the build date.
 - TDX_FEATURES0: Supported TDX features.

And dump the information right after reading global metadata, so that
this information is printed no matter whether module initialization
fails or not.

The actual dmesg will look like:

  virt/tdx: Initializing TDX module: 1.5.00.00.0481 (build_date 20230323), TDX_FEATURES0 0xfbf

Link: https://lore.kernel.org/lkml/e2d844ad-182a-4fc0-a06a-d609c9cbef74@suse.com/T/#m352829aedf6680d4628c7e40dc40b332eda93355 [1]
Link: https://lore.kernel.org/lkml/e2d844ad-182a-4fc0-a06a-d609c9cbef74@suse.com/T/#m351ebcbc006d2e5bc3e7650206a087cb2708d451 [2]
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v2 -> v3:
 - 'struct tdx_sysinfo_module_info' -> 'struct tdx_sys_info_features'
 - 'struct tdx_sysinfo_module_version' -> 'struct tdx_sys_info_version'
 - Remove the 'sys_attributes' and the check of debug/production module.

 https://lore.kernel.org/kvm/cover.1721186590.git.kai.huang@intel.com/T/#md73dd9b02a492acf4a6facae63e8d030e320967d


---
 arch/x86/virt/vmx/tdx/tdx.c | 61 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 34 ++++++++++++++++++++-
 2 files changed, 94 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 24eb289c80e8..0fb673dd43ed 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -302,6 +302,55 @@ static int __read_sys_metadata_field(u64 field_id, void *val, int size)
 					&_stbuf->_member);			\
 	})
 
+static int get_tdx_sys_info_features(struct tdx_sys_info_features *sysinfo_features)
+{
+	int ret = 0;
+
+#define TD_SYSINFO_MAP_MOD_FEATURES(_field_id, _member)	\
+	TD_SYSINFO_MAP(_field_id, sysinfo_features, _member)
+
+	TD_SYSINFO_MAP_MOD_FEATURES(TDX_FEATURES0, tdx_features0);
+
+	return ret;
+}
+
+static int get_tdx_sys_info_version(struct tdx_sys_info_version *sysinfo_version)
+{
+	int ret = 0;
+
+#define TD_SYSINFO_MAP_MOD_VERSION(_field_id, _member)	\
+	TD_SYSINFO_MAP(_field_id, sysinfo_version, _member)
+
+	TD_SYSINFO_MAP_MOD_VERSION(MAJOR_VERSION,    major);
+	TD_SYSINFO_MAP_MOD_VERSION(MINOR_VERSION,    minor);
+	TD_SYSINFO_MAP_MOD_VERSION(UPDATE_VERSION,   update);
+	TD_SYSINFO_MAP_MOD_VERSION(INTERNAL_VERSION, internal);
+	TD_SYSINFO_MAP_MOD_VERSION(BUILD_NUM,	     build_num);
+	TD_SYSINFO_MAP_MOD_VERSION(BUILD_DATE,	     build_date);
+
+	return ret;
+}
+
+static void print_basic_sys_info(struct tdx_sys_info *sysinfo)
+{
+	struct tdx_sys_info_features *features = &sysinfo->features;
+	struct tdx_sys_info_version *version = &sysinfo->version;
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
+	pr_info("Initializing TDX module: %u.%u.%02u.%02u.%04u (build_date %u), TDX_FEATURES0 0x%llx\n",
+			version->major, version->minor,	version->update,
+			version->internal, version->build_num,
+			version->build_date, features->tdx_features0);
+}
+
 static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
 {
 	int ret = 0;
@@ -320,6 +369,16 @@ static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
 
 static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 {
+	int ret;
+
+	ret = get_tdx_sys_info_features(&sysinfo->features);
+	if (ret)
+		return ret;
+
+	ret = get_tdx_sys_info_version(&sysinfo->version);
+	if (ret)
+		return ret;
+
 	return get_tdx_sys_info_tdmr(&sysinfo->tdmr);
 }
 
@@ -1102,6 +1161,8 @@ static int init_tdx_module(void)
 	if (ret)
 		return ret;
 
+	print_basic_sys_info(&sysinfo);
+
 	/*
 	 * To keep things simple, assume that all TDX-protected memory
 	 * will come from the page allocator.  Make sure all pages in the
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 4cddbb035b9f..b422e8517e01 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -31,6 +31,15 @@
  *
  * See the "global_metadata.json" in the "TDX 1.5 ABI definitions".
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
@@ -130,6 +139,27 @@ struct tdmr_info_list {
  * those used by the kernel are.
  */
 
+/*
+ * Class "TDX Module Info".
+ *
+ * This class also contains other fields like SYS_ATTRIBUTES and the
+ * NUM_TDX_FEATURES.  For now only TDX_FEATURES0 is needed, but still
+ * keep the structure to follow the spec (and for future extension).
+ */
+struct tdx_sys_info_features {
+	u64 tdx_features0;
+};
+
+/* Class "TDX Module Version" */
+struct tdx_sys_info_version {
+	u16 major;
+	u16 minor;
+	u16 update;
+	u16 internal;
+	u16 build_num;
+	u32 build_date;
+};
+
 /* Class "TDMR info" */
 struct tdx_sys_info_tdmr {
 	u16 max_tdmrs;
@@ -138,7 +168,9 @@ struct tdx_sys_info_tdmr {
 };
 
 struct tdx_sys_info {
-	struct tdx_sys_info_tdmr tdmr;
+	struct tdx_sys_info_features	features;
+	struct tdx_sys_info_version	version;
+	struct tdx_sys_info_tdmr	tdmr;
 };
 
 #endif
-- 
2.46.0


