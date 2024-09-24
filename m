Return-Path: <kvm+bounces-27364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BAC39844AA
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 13:31:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0C1D2818AE
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 11:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C43AC1A705E;
	Tue, 24 Sep 2024 11:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BpoSq3v6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592AC1AAE1A;
	Tue, 24 Sep 2024 11:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727177376; cv=none; b=LLDfUV1S7NvSsQU4iQ8NR0RC1wc5sLYIF6trJrcusXmoi1lLxuxUjzmedt1AYF6edKkIvyq/BtUd7IEpLcgG0mnaiwYa1/6kdxJUm09eDue3ZF23bRTYSvRQ+853qFqGL8g23477zIRcGdM3iIEtk9qkAV9tlGHckEJg4cilNtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727177376; c=relaxed/simple;
	bh=miacDnO3dASnNLUlekjw9N6dNiCFGROLIjOydUPXs1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThWrre1sXRmdaFvobxLI29fYgVwyEm97uWKC29oULqVA/eKR3h0VgS5xdfEKwvdAtbViqThAMLaV2Md9fFu/CnV61p6KRQg5pNCm40KlYGC3ulr8UabH0XgUbk/TS0RH4Iaj9uEDaqGoD4VubSiFX5nDCSuPlMeiMQpMXjsOpvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BpoSq3v6; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727177374; x=1758713374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=miacDnO3dASnNLUlekjw9N6dNiCFGROLIjOydUPXs1A=;
  b=BpoSq3v6nEFEPAIqVbeTWjzluUdR4/kS1gELpPu2b4jbY3r0vJ34UYT0
   K0TQmP3BvXjg1nnWH6PxC0Pilr5jx4LzT9IB/JEPUBe457Ql2VB5Zw2O0
   XPTjphB8Ycp2yR3r6+4flSaOdxjzfmvlpySej19/vKSinDbZq5x3x4pQc
   0djIR415XQyHUzVz37GT0o9/fNRWE7zImZTDdf9wXXWpUnc/q3zW/DYmR
   oAMC5UVE6qWVBtcdTZO4k66QGdbO2X5yXtru40Nb199A04Rwg67gmEc3H
   OlMHciLAbA17RAwNGluClLbA2T6NpuscmTxpMnVmJKQElHtUi4tkQN61f
   A==;
X-CSE-ConnectionGUID: Y6uxfwi5RlajKUo5Ila6AA==
X-CSE-MsgGUID: g/xCK50fQW6fkyEIKerICw==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="43686569"
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="43686569"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 04:29:34 -0700
X-CSE-ConnectionGUID: GP5L4izHSf+gm6NFUzQvIw==
X-CSE-MsgGUID: ap6P5OIdRs6ZbdyTG2aNrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="70994669"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.221.10])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 04:29:31 -0700
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
Subject: [PATCH v4 7/8] x86/virt/tdx: Require the module to assert it has the NO_RBP_MOD mitigation
Date: Tue, 24 Sep 2024 23:28:34 +1200
Message-ID: <a691b273b3f2440ea53b1e13e1584d7521c52e39.1727173372.git.kai.huang@intel.com>
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

Old TDX modules can clobber RBP in the TDH.VP.ENTER SEAMCALL.  However
RBP is used as frame pointer in the x86_64 calling convention, and
clobbering RBP could result in bad things like being unable to unwind
the stack if any non-maskable exceptions (NMI, #MC etc) happens in that
gap.

A new "NO_RBP_MOD" feature was introduced to more recent TDX modules to
not clobber RBP.  This feature is reported in the TDX_FEATURES0 global
metadata field via bit 18.

Don't initialize the TDX module if this feature is not supported [1].

Link: https://lore.kernel.org/all/fc0e8ab7-86d4-4428-be31-82e1ece6dd21@intel.com/ [1]
Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---

v3 -> v4:
 - Move reading TDX_FEATURES0 code to this patch.
 - Change patch title and use permalink - Dan.

 Hi Dan, Ardian, Nikolay,

 The code to read TDX_FEATURES0 was not included in this patch when you
 gave your tag.  I didn't remove them.  Please let me know if you want
 me to remove your tag.  Thanks!

v2 -> v3:
 - check_module_compatibility() -> check_features().
 - Improve error message.

 https://lore.kernel.org/kvm/cover.1721186590.git.kai.huang@intel.com/T/#md9e2eeef927838cbf20d7b361cdbea518b8aec50


---
 arch/x86/virt/vmx/tdx/tdx.c | 37 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 17 +++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index d599aaaa2730..cd8cca5139ac 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -287,6 +287,7 @@ static int __read_sys_metadata_field##_size(u64 field_id, u##_size *val)	\
 
 build_sysmd_read(16)
 build_sysmd_read(32)
+build_sysmd_read(64)
 
 #define read_sys_metadata_field(_field_id, _val, _size)		\
 ({								\
@@ -296,6 +297,21 @@ build_sysmd_read(32)
 	__read_sys_metadata_field##_size(_field_id, _val);	\
 })
 
+static int get_tdx_sys_info_features(struct tdx_sys_info_features *sysinfo_features)
+{
+	int ret = 0;
+
+#define READ_SYS_INFO(_field_id, _member)				\
+	ret = ret ?: read_sys_metadata_field(MD_FIELD_ID_##_field_id,	\
+					&sysinfo_features->_member, 64)
+
+	READ_SYS_INFO(TDX_FEATURES0, tdx_features0);
+
+#undef READ_SYS_INFO
+
+	return ret;
+}
+
 static int get_tdx_sys_info_version(struct tdx_sys_info_version *sysinfo_version)
 {
 	int ret = 0;
@@ -339,6 +355,10 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 {
 	int ret;
 
+	ret = get_tdx_sys_info_features(&sysinfo->features);
+	if (ret)
+		return ret;
+
 	ret = get_tdx_sys_info_version(&sysinfo->version);
 	if (ret)
 		return ret;
@@ -368,6 +388,18 @@ static void print_basic_sys_info(struct tdx_sys_info *sysinfo)
 	print_sys_info_version(&sysinfo->version);
 }
 
+static int check_features(struct tdx_sys_info *sysinfo)
+{
+	u64 tdx_features0 = sysinfo->features.tdx_features0;
+
+	if (!(tdx_features0 & TDX_FEATURES0_NO_RBP_MOD)) {
+		pr_err("frame pointer (RBP) clobber bug present, upgrade TDX module\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /* Calculate the actual TDMR size */
 static int tdmr_size_single(u16 max_reserved_per_tdmr)
 {
@@ -1149,6 +1181,11 @@ static int init_tdx_module(void)
 
 	print_basic_sys_info(&sysinfo);
 
+	/* Check whether the kernel can support this module */
+	ret = check_features(&sysinfo);
+	if (ret)
+		return ret;
+
 	/*
 	 * To keep things simple, assume that all TDX-protected memory
 	 * will come from the page allocator.  Make sure all pages in the
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index a8d0ab3e5acd..9314f6ecbcb5 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -31,6 +31,7 @@
  *
  * See the "global_metadata.json" in the "TDX 1.5 ABI definitions".
  */
+#define MD_FIELD_ID_TDX_FEATURES0		0x0A00000300000008ULL
 #define MD_FIELD_ID_BUILD_DATE			0x8800000200000001ULL
 #define MD_FIELD_ID_BUILD_NUM			0x8800000100000002ULL
 #define MD_FIELD_ID_MINOR_VERSION		0x0800000100000003ULL
@@ -61,6 +62,7 @@
 
 #define MD_FIELD_ID_ELE_SIZE_16BIT	1
 #define MD_FIELD_ID_ELE_SIZE_32BIT	2
+#define MD_FIELD_ID_ELE_SIZE_64BIT	3
 
 struct tdmr_reserved_area {
 	u64 offset;
@@ -105,6 +107,20 @@ struct tdmr_info {
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
+/* Bit definitions of TDX_FEATURES0 metadata field */
+#define TDX_FEATURES0_NO_RBP_MOD	_BITULL(18)
+
 /* Class "TDX Module Version" */
 struct tdx_sys_info_version {
 	u16 major;
@@ -123,6 +139,7 @@ struct tdx_sys_info_tdmr {
 };
 
 struct tdx_sys_info {
+	struct tdx_sys_info_features	features;
 	struct tdx_sys_info_version	version;
 	struct tdx_sys_info_tdmr	tdmr;
 };
-- 
2.46.0


