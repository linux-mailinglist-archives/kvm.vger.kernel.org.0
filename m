Return-Path: <kvm+bounces-28753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 41CFF99C901
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 13:34:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6A301F23225
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 11:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6BF31AA7A4;
	Mon, 14 Oct 2024 11:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UWhoGFDw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888F31AA786;
	Mon, 14 Oct 2024 11:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728905558; cv=none; b=FpG98h57mJqOa5gL9JrGb5PWQupGI7LOJijinZQbIG2VLg+iQmuRKOrmI4lzmKIyz97skBEYd5FM2oH2MKwiOp5bvlTTA3l8zu6JF4EyWbLIJuYVzOVebHIVgi6xwtjNchgZonsjR9h0225dgbNFsh+27UAHhCvZtkwjhHq2nRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728905558; c=relaxed/simple;
	bh=G8yBT7WdIx28fuQzQTlC+Q/DNMdS5bKfXBVXPUHC2XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKdBpxWKiLUj7lZLITJBOOgmxupFDmqV+5Y9vzi/A1nqRvi/+X5fKaJIM+o1pPtXs/L0OHsGwcWBM4eKgFzjJiycvF7oD4XOv4K87pDolh+mVzkInt91yY7vJGH2eyj0lGZbummWBaHsM3/JVwuD+pZvxvq9lirwGvkjiGvrf7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UWhoGFDw; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728905556; x=1760441556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G8yBT7WdIx28fuQzQTlC+Q/DNMdS5bKfXBVXPUHC2XI=;
  b=UWhoGFDwGzTEfAZtvPbKO4XltwxVTytJwy+Z+tDPrWkGh9gMVDLSBfxb
   ExzFvDGuV5gbaGUwwvmdIXNhDaxPDX93jrY/tnY//YCcDnBoTXqmPLxC4
   M9/I9mwpWOoQ+3gI0JAXpqRxSr24MGvl4hwdjvzyWsbCV4ivCj7l8ShHJ
   4og1YBhK9yNv+5qP40J8FdLGbUyezNPF6L41o1hBGduj89SwGEZx/DXMB
   TqkYz/Lzkzm5469NU9g2v8pyuhyktO5YfAT/+VhubyCy8MAOodQHOdvbE
   LAE4qUStGmBGA8ShrKfok4MjUdcy42Qsgh5sG+eMAhRSWcfBcL5ehB12p
   w==;
X-CSE-ConnectionGUID: 7T+v/586Rp2QN8V3Gt3kCw==
X-CSE-MsgGUID: 6Ox25bb5TC2hSZPNRllIUA==
X-IronPort-AV: E=McAfee;i="6700,10204,11224"; a="32166555"
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="32166555"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 04:32:36 -0700
X-CSE-ConnectionGUID: Lw2pRwCKTwmon6nN5nQtPw==
X-CSE-MsgGUID: 7e3kRGAsQUWN8WsOcpIo9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="82117498"
Received: from jdoman-desk1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.220.204])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 04:32:33 -0700
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
Subject: [PATCH v5 7/8] x86/virt/tdx: Require the module to assert it has the NO_RBP_MOD mitigation
Date: Tue, 15 Oct 2024 00:31:54 +1300
Message-ID: <d9d67a66709ed3aad162f8ba3c5bf0078cdb9529.1728903647.git.kai.huang@intel.com>
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

v4 -> v5:
 - Rebase due to patch 3 change.

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
 arch/x86/virt/vmx/tdx/tdx.c | 36 ++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 16 ++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 130ddac47f64..c877d02ca057 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -292,6 +292,21 @@ static int __read_sys_metadata_field(u64 field_id, void *val, int size)
 	__read_sys_metadata_field(_field_id, _val, sizeof(*(_val)));	\
 })
 
+static int get_tdx_sys_info_features(struct tdx_sys_info_features *sysinfo_features)
+{
+	int ret = 0;
+
+#define READ_SYS_INFO(_field_id, _member)				\
+	ret = ret ?: read_sys_metadata_field(MD_FIELD_ID_##_field_id,	\
+					&sysinfo_features->_member)
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
@@ -335,6 +350,10 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 {
 	int ret;
 
+	ret = get_tdx_sys_info_features(&sysinfo->features);
+	if (ret)
+		return ret;
+
 	ret = get_tdx_sys_info_version(&sysinfo->version);
 	if (ret)
 		return ret;
@@ -364,6 +383,18 @@ static void print_basic_sys_info(struct tdx_sys_info *sysinfo)
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
@@ -1145,6 +1176,11 @@ static int init_tdx_module(void)
 
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
index 0203528da024..18c54e1e3a4a 100644
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
@@ -105,6 +106,20 @@ struct tdmr_info {
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
@@ -123,6 +138,7 @@ struct tdx_sys_info_tdmr {
 };
 
 struct tdx_sys_info {
+	struct tdx_sys_info_features	features;
 	struct tdx_sys_info_version	version;
 	struct tdx_sys_info_tdmr	tdmr;
 };
-- 
2.46.2


