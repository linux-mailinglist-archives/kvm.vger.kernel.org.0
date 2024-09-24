Return-Path: <kvm+bounces-27363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8747C9844A8
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 13:31:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA41A1C23C19
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 11:31:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 398E81AAE0B;
	Tue, 24 Sep 2024 11:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OHatFZSv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4D51A7AEC;
	Tue, 24 Sep 2024 11:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727177372; cv=none; b=TqiAqc+buSzCCSWm2uOos/y6kw9R//sUsPQMYyJVqAchejVJr0G8vSAztgMSQ3JtuPE5QK/5MB+ufbdc3MPb4K19DuVmx2aljnc7/OJ2HJSHXEryqjeVbo1CA4t64JRpLPJmL9FMK6STxx0PPxYuPfJ7rX4z79wP3E8uE+AiSGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727177372; c=relaxed/simple;
	bh=4GVkD78Ie9ZCNqSljs6LuDQbODZP2xkjWndNf2q63os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjvGtERoHVVJMKt8IyPTxNBGGuNMZwnWQMkd/n1W9Kq51JAK6IaCL61AzyXzHBl2CSqAGu9iU4uT9x+gq3z1KslTJEH8ETD3GLPLH2vJWNWLaNs0Dqp69scl3hgv1O60b5S4E8ETZl7g73h9G8sAFlhAmpVgOlFWd79nWctbI+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OHatFZSv; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727177371; x=1758713371;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4GVkD78Ie9ZCNqSljs6LuDQbODZP2xkjWndNf2q63os=;
  b=OHatFZSvoqL8LLlgMB2nrayBko9MZXbh6+5gW5uoY1EHBs44CAg7TRVv
   K6WsbcrZCHVbcZEbTAO7kSzqu1lIQJtUggbY6Tm51SbDJHcu7PGp279bs
   u90GY8M8aFkni/+kT9kdUNZ5ltOfMTxuOg8frJCToEr0x72FN7GLRSkK+
   yitNqMkTRmKhwYB/u79NbOgQa0aw54X4hikThKNrPXO0T6BIy0O2moXXl
   +mOBfxlgsSrFjRDi+f4hl0D1B+84C76umpj9isA64idM8fFFe79fmGFw9
   irgK8Au0Q3GxLOOKDMTJlRSLEV4WNyMhK8CW3c6+SjoEc4PvWvXAf4bv0
   w==;
X-CSE-ConnectionGUID: PKxkR8GnT9C0Q5etet7q4Q==
X-CSE-MsgGUID: GeTmGPGvRcuQTvB56U51mQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="43686547"
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="43686547"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 04:29:31 -0700
X-CSE-ConnectionGUID: QfnM4YNGSTyl/gjfiEvaIg==
X-CSE-MsgGUID: SbyT1zdSRmy3cqvE/7wIRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="70994647"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.221.10])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 04:29:27 -0700
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
Subject: [PATCH v4 6/8] x86/virt/tdx: Print TDX module version
Date: Tue, 24 Sep 2024 23:28:33 +1200
Message-ID: <79c256b8978310803bb4de48cd81dd373330cbc2.1727173372.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1727173372.git.kai.huang@intel.com>
References: <cover.1727173372.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the kernel doesn't print any TDX module version information.
In practice such information is useful, especially to the developers.

For instance:

1) When something goes wrong around using TDX, the module version is
   normally the first information the users want to know [1].

2) After initializing TDX module, the users want to quickly know module
   version to see whether the loaded module is the expected one.

Dump TDX module version.  The actual dmesg will look like:

  virt/tdx: Initializing TDX module: 1.5.00.00.0481 (build_date 20230323).

And dump right after reading global metadata, so that this information is
printed no matter whether module initialization fails or not.

Link: https://lore.kernel.org/lkml/4b3adb59-50ea-419e-ad02-e19e8ca20dee@intel.com/ [1]
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v3 -> v4:
 - Omit dumping TDX_FEATURES0 - Dan.
 - As a result, move TDX_FEATURES0 related code out to NO_MOD_RBP patch.
 - Update changelog accordingly.
 - Simplify changelog for the use case 2).
 - Use permalink - Dan.

v2 -> v3:
 - 'struct tdx_sysinfo_module_info' -> 'struct tdx_sys_info_features'
 - 'struct tdx_sysinfo_module_version' -> 'struct tdx_sys_info_version'
 - Remove the 'sys_attributes' and the check of debug/production module.

 https://lore.kernel.org/kvm/cover.1721186590.git.kai.huang@intel.com/T/#md73dd9b02a492acf4a6facae63e8d030e320967d



---
 arch/x86/virt/vmx/tdx/tdx.c | 51 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 20 ++++++++++++++-
 2 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 44ef74d1fafb..d599aaaa2730 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -286,6 +286,7 @@ static int __read_sys_metadata_field##_size(u64 field_id, u##_size *val)	\
 }
 
 build_sysmd_read(16)
+build_sysmd_read(32)
 
 #define read_sys_metadata_field(_field_id, _val, _size)		\
 ({								\
@@ -295,6 +296,26 @@ build_sysmd_read(16)
 	__read_sys_metadata_field##_size(_field_id, _val);	\
 })
 
+static int get_tdx_sys_info_version(struct tdx_sys_info_version *sysinfo_version)
+{
+	int ret = 0;
+
+#define READ_SYS_INFO(_field_id, _member, _size)			\
+	ret = ret ?: read_sys_metadata_field(MD_FIELD_ID_##_field_id,	\
+					&sysinfo_version->_member, _size)
+
+	READ_SYS_INFO(MAJOR_VERSION,    major,      16);
+	READ_SYS_INFO(MINOR_VERSION,    minor,      16);
+	READ_SYS_INFO(UPDATE_VERSION,   update,     16);
+	READ_SYS_INFO(INTERNAL_VERSION, internal,   16);
+	READ_SYS_INFO(BUILD_NUM,	build_num,  16);
+	READ_SYS_INFO(BUILD_DATE,	build_date, 32);
+
+#undef READ_SYS_INFO
+
+	return ret;
+}
+
 static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
 {
 	int ret = 0;
@@ -316,9 +337,37 @@ static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
 
 static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 {
+	int ret;
+
+	ret = get_tdx_sys_info_version(&sysinfo->version);
+	if (ret)
+		return ret;
+
 	return get_tdx_sys_info_tdmr(&sysinfo->tdmr);
 }
 
+static void print_sys_info_version(struct tdx_sys_info_version *version)
+{
+	/*
+	 * TDX module version encoding:
+	 *
+	 *   <major>.<minor>.<update>.<internal>.<build_num>
+	 *
+	 * When printed as text, <major> and <minor> are 1-digit,
+	 * <update> and <internal> are 2-digits and <build_num>
+	 * is 4-digits.
+	 */
+	pr_info("Initializing TDX module: %u.%u.%02u.%02u.%04u (build_date %u).\n",
+			version->major, version->minor,	version->update,
+			version->internal, version->build_num,
+			version->build_date);
+}
+
+static void print_basic_sys_info(struct tdx_sys_info *sysinfo)
+{
+	print_sys_info_version(&sysinfo->version);
+}
+
 /* Calculate the actual TDMR size */
 static int tdmr_size_single(u16 max_reserved_per_tdmr)
 {
@@ -1098,6 +1147,8 @@ static int init_tdx_module(void)
 	if (ret)
 		return ret;
 
+	print_basic_sys_info(&sysinfo);
+
 	/*
 	 * To keep things simple, assume that all TDX-protected memory
 	 * will come from the page allocator.  Make sure all pages in the
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index b9a89da39e1e..a8d0ab3e5acd 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -31,6 +31,12 @@
  *
  * See the "global_metadata.json" in the "TDX 1.5 ABI definitions".
  */
+#define MD_FIELD_ID_BUILD_DATE			0x8800000200000001ULL
+#define MD_FIELD_ID_BUILD_NUM			0x8800000100000002ULL
+#define MD_FIELD_ID_MINOR_VERSION		0x0800000100000003ULL
+#define MD_FIELD_ID_MAJOR_VERSION		0x0800000100000004ULL
+#define MD_FIELD_ID_UPDATE_VERSION		0x0800000100000005ULL
+#define MD_FIELD_ID_INTERNAL_VERSION		0x0800000100000006ULL
 #define MD_FIELD_ID_MAX_TDMRS			0x9100000100000008ULL
 #define MD_FIELD_ID_MAX_RESERVED_PER_TDMR	0x9100000100000009ULL
 #define MD_FIELD_ID_PAMT_4K_ENTRY_SIZE		0x9100000100000010ULL
@@ -54,6 +60,7 @@
 		(((_field_id) & GENMASK_ULL(33, 32)) >> 32)
 
 #define MD_FIELD_ID_ELE_SIZE_16BIT	1
+#define MD_FIELD_ID_ELE_SIZE_32BIT	2
 
 struct tdmr_reserved_area {
 	u64 offset;
@@ -98,6 +105,16 @@ struct tdmr_info {
  * those used by the kernel are.
  */
 
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
@@ -106,7 +123,8 @@ struct tdx_sys_info_tdmr {
 };
 
 struct tdx_sys_info {
-	struct tdx_sys_info_tdmr tdmr;
+	struct tdx_sys_info_version	version;
+	struct tdx_sys_info_tdmr	tdmr;
 };
 
 /*
-- 
2.46.0


