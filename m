Return-Path: <kvm+bounces-9629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B5A2866C37
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:29:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75FCE1F2429D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 203892E641;
	Mon, 26 Feb 2024 08:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CKXMFwPT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE17E200D5;
	Mon, 26 Feb 2024 08:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936061; cv=none; b=bI4h32bjIgFic4tDx1KVV61iBhjj02hS9gziswhSyUm3wwwjFTQ+Qaxcqmvn5Bhlsyj5O2LN2hsffaH6mEiqLJw2lE2fSXDIwJpVLWUXOIj42PwI5oHPx/hzFVwyq8GEiLN25nSy602fUJUF58X3JuDT1ESbASxfL/Pi89rj/ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936061; c=relaxed/simple;
	bh=WwPAQVyS6ydkrI/ZnLxTBH2KaaNIW1B/7NwF7C9kOnA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ejQDQOvzpC71nXy5fgQ4sykAI+OJz71tt6WJBrguC3AfD6hEhIYwXw936ZBf/EIBLVrC/3ODdjxE30/ANoFfHE306L6XDKaEWxBM3ZqnscFKBIcT9hEUSAEU8vIrnr6oKsj7B3Vb72X/D+zKudUnvmY7PAPID4tU7S09XSWq0U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CKXMFwPT; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936059; x=1740472059;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WwPAQVyS6ydkrI/ZnLxTBH2KaaNIW1B/7NwF7C9kOnA=;
  b=CKXMFwPTaQE5LrCyCQ+FoTc1WCsogcaL0w592cJI5tB8J3YHi2BOgBdl
   sDlsZW3gdXvh0uOPAgPhjqpPXcNoLau6iFSUWgkn2G1CfuKdC8Byy+/Q0
   08tk/kTRx34+R46XAyoRb4DREEs3KRW3j+gK3cVwvqoHF+1MB2LHZ5OMS
   iRavtE2IIEAM2Cj/53NU0SKXXV0fNYgERdi94UXVnzqtEKP3lczsDkqmE
   WCunFC5uQFweQQ2BAHvegdEM3d8eHhygY1TcKofwbYUkRCDVjhjM/5lLo
   v2COmKXTsPf/nnAxEwecCTnpMtpt21T8+wYg3FTYzQn3/2AUhj+coy6wt
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3340712"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3340712"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="7020075"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:37 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v19 005/130] x86/virt/tdx: Export global metadata read infrastructure
Date: Mon, 26 Feb 2024 00:25:07 -0800
Message-Id: <eec524e07ee17961a4deb1cc7a1390c91d8708ff.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kai Huang <kai.huang@intel.com>

KVM will need to read a bunch of non-TDMR related metadata to create and
run TDX guests.  Export the metadata read infrastructure for KVM to use.

Specifically, export two helpers:

1) The helper which reads multiple metadata fields to a buffer of a
   structure based on the "field ID -> structure member" mapping table.

2) The low level helper which just reads a given field ID.

The two helpers cover cases when the user wants to cache a bunch of
metadata fields to a certain structure and when the user just wants to
query a specific metadata field on demand.  They are enough for KVM to
use (and also should be enough for other potential users).

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/tdx.h  | 22 ++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 25 ++++++++-----------------
 2 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index eba178996d84..709b9483f9e4 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -116,6 +116,28 @@ static inline u64 sc_retry(sc_func_t func, u64 fn,
 int tdx_cpu_enable(void);
 int tdx_enable(void);
 const char *tdx_dump_mce_info(struct mce *m);
+
+struct tdx_metadata_field_mapping {
+	u64 field_id;
+	int offset;
+	int size;
+};
+
+#define TD_SYSINFO_MAP(_field_id, _struct, _member)	\
+	{ .field_id = MD_FIELD_ID_##_field_id,		\
+	  .offset   = offsetof(_struct, _member),	\
+	  .size     = sizeof(typeof(((_struct *)0)->_member)) }
+
+/*
+ * Read multiple global metadata fields to a buffer of a structure
+ * based on the "field ID -> structure member" mapping table.
+ */
+int tdx_sys_metadata_read(const struct tdx_metadata_field_mapping *fields,
+			  int nr_fields, void *stbuf);
+
+/* Read a single global metadata field */
+int tdx_sys_metadata_field_read(u64 field_id, u64 *data);
+
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index a19adc898df6..dc21310776ab 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -251,7 +251,7 @@ static int build_tdx_memlist(struct list_head *tmb_list)
 	return ret;
 }
 
-static int read_sys_metadata_field(u64 field_id, u64 *data)
+int tdx_sys_metadata_field_read(u64 field_id, u64 *data)
 {
 	struct tdx_module_args args = {};
 	int ret;
@@ -270,6 +270,7 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(tdx_sys_metadata_field_read);
 
 /* Return the metadata field element size in bytes */
 static int get_metadata_field_bytes(u64 field_id)
@@ -295,7 +296,7 @@ static int stbuf_read_sys_metadata_field(u64 field_id,
 	if (WARN_ON_ONCE(get_metadata_field_bytes(field_id) != bytes))
 		return -EINVAL;
 
-	ret = read_sys_metadata_field(field_id, &tmp);
+	ret = tdx_sys_metadata_field_read(field_id, &tmp);
 	if (ret)
 		return ret;
 
@@ -304,19 +305,8 @@ static int stbuf_read_sys_metadata_field(u64 field_id,
 	return 0;
 }
 
-struct field_mapping {
-	u64 field_id;
-	int offset;
-	int size;
-};
-
-#define TD_SYSINFO_MAP(_field_id, _struct, _member)	\
-	{ .field_id = MD_FIELD_ID_##_field_id,		\
-	  .offset   = offsetof(_struct, _member),	\
-	  .size     = sizeof(typeof(((_struct *)0)->_member)) }
-
-static int read_sys_metadata(struct field_mapping *fields, int nr_fields,
-			     void *stbuf)
+int tdx_sys_metadata_read(const struct tdx_metadata_field_mapping *fields,
+			  int nr_fields, void *stbuf)
 {
 	int i, ret;
 
@@ -331,6 +321,7 @@ static int read_sys_metadata(struct field_mapping *fields, int nr_fields,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(tdx_sys_metadata_read);
 
 #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
 	TD_SYSINFO_MAP(_field_id, struct tdx_tdmr_sysinfo, _member)
@@ -338,7 +329,7 @@ static int read_sys_metadata(struct field_mapping *fields, int nr_fields,
 static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
 {
 	/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
-	const struct field_mapping fields[] = {
+	const struct tdx_metadata_field_mapping fields[] = {
 		TD_SYSINFO_MAP_TDMR_INFO(MAX_TDMRS,		max_tdmrs),
 		TD_SYSINFO_MAP_TDMR_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
 		TD_SYSINFO_MAP_TDMR_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
@@ -347,7 +338,7 @@ static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
 	};
 
 	/* Populate 'tdmr_sysinfo' fields using the mapping structure above: */
-	return read_sys_metadata(fields, ARRAY_SIZE(fields), tdmr_sysinfo);
+	return tdx_sys_metadata_read(fields, ARRAY_SIZE(fields), tdmr_sysinfo);
 }
 
 /* Calculate the actual TDMR size */
-- 
2.25.1


