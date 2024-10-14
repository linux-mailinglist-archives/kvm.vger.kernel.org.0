Return-Path: <kvm+bounces-28752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A7F999C8FF
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 13:34:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A760A1F22C33
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 11:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6454019DFAC;
	Mon, 14 Oct 2024 11:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gcDzNFap"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0367B1A76AF;
	Mon, 14 Oct 2024 11:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728905554; cv=none; b=sxGVVtrXM11qh3jfzd4xvZQP3KL2V4MmLW/m5NgurRw3xz6JUf4hBbEwVyR323e3NoG+/mGUeE3ZFe9+o6jTWcstgIzQL4PDMd1UVScmGsPjRiPXqpeaI+SOwz1cbdoGG2BarpOKPIWjcE8BXLNBzTXmY31wS/y65cQWsk7yJdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728905554; c=relaxed/simple;
	bh=4Fm73YRK8btjeCJoC8b2q7zZE+d4ai5nfnHJTIpJLpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuqmkEPySj0yFtKdr5n7FVlXa5aJ8q5HqTfwEqii3r8zBm/YQUNSt15IQ+qdD2CatcuyHuFQRoXTXZsaBdH5JlgL6WUft+cq5UahWf886ikSjkaej7YlrKSe6wcg7/iFvtZMM2GGbiodA5FpGr9mGczyLvNXCoOrXWIMYyU13jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gcDzNFap; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728905553; x=1760441553;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4Fm73YRK8btjeCJoC8b2q7zZE+d4ai5nfnHJTIpJLpk=;
  b=gcDzNFapyU+cLvHXL+VhveuRlOWoomWrpXdpD2ohhIfmhJXJT9dwSITY
   W4MCTwQlKjAu0ffW9J6O8rKZxEQSCffLn3QvidIn0WwgduwYQqz7j2vgg
   TvsDZb+KUuUFXYFMqW+Xr1H7+CCo93KhYd9nPQpFgIBtmHrscMPgcciO5
   jLN7IREsVXvgSrsCoGK3B96Alsm7iBFG//M81PbHY4gcpi3/3H6wWwIHz
   exWPQXvZjUwCHzlRn2XhW8S+oC4fAqBHvgDYpNP119Mej2JwWn+rK2TM1
   ASTTO6aSl72lJd8m8SfQrpqxPTHR17VFuGj7Pz+mCNIIWx689QDnSDwwD
   Q==;
X-CSE-ConnectionGUID: Suz+dMYaSxSfmDoMzhqZRA==
X-CSE-MsgGUID: a/i3yukxRw6HFnBG6elevg==
X-IronPort-AV: E=McAfee;i="6700,10204,11224"; a="32166538"
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="32166538"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 04:32:32 -0700
X-CSE-ConnectionGUID: aHVh/2d/SG6km5sXbeFbAg==
X-CSE-MsgGUID: aqDDsD71Rq6s9urIDjEyzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="82117491"
Received: from jdoman-desk1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.220.204])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 04:32:29 -0700
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
Subject: [PATCH v5 6/8] x86/virt/tdx: Print TDX module version
Date: Tue, 15 Oct 2024 00:31:53 +1300
Message-ID: <08ed3b23b24b81089b02276c55d71aaa7d2a4bd5.1728903647.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1728903647.git.kai.huang@intel.com>
References: <cover.1728903647.git.kai.huang@intel.com>
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

v4 -> v5:
 - Rebase due to patch 3 change.

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
 arch/x86/virt/vmx/tdx/tdx.c | 50 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 19 +++++++++++++-
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index a4496c4c765f..130ddac47f64 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -292,6 +292,26 @@ static int __read_sys_metadata_field(u64 field_id, void *val, int size)
 	__read_sys_metadata_field(_field_id, _val, sizeof(*(_val)));	\
 })
 
+static int get_tdx_sys_info_version(struct tdx_sys_info_version *sysinfo_version)
+{
+	int ret = 0;
+
+#define READ_SYS_INFO(_field_id, _member)				\
+	ret = ret ?: read_sys_metadata_field(MD_FIELD_ID_##_field_id,	\
+					&sysinfo_version->_member)
+
+	READ_SYS_INFO(MAJOR_VERSION,    major);
+	READ_SYS_INFO(MINOR_VERSION,    minor);
+	READ_SYS_INFO(UPDATE_VERSION,   update);
+	READ_SYS_INFO(INTERNAL_VERSION, internal);
+	READ_SYS_INFO(BUILD_NUM,	build_num);
+	READ_SYS_INFO(BUILD_DATE,	build_date);
+
+#undef READ_SYS_INFO
+
+	return ret;
+}
+
 static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
 {
 	int ret = 0;
@@ -313,9 +333,37 @@ static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
 
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
@@ -1095,6 +1143,8 @@ static int init_tdx_module(void)
 	if (ret)
 		return ret;
 
+	print_basic_sys_info(&sysinfo);
+
 	/*
 	 * To keep things simple, assume that all TDX-protected memory
 	 * will come from the page allocator.  Make sure all pages in the
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 4c924124347c..0203528da024 100644
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
@@ -99,6 +105,16 @@ struct tdmr_info {
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
@@ -107,7 +123,8 @@ struct tdx_sys_info_tdmr {
 };
 
 struct tdx_sys_info {
-	struct tdx_sys_info_tdmr tdmr;
+	struct tdx_sys_info_version	version;
+	struct tdx_sys_info_tdmr	tdmr;
 };
 
 /*
-- 
2.46.2


