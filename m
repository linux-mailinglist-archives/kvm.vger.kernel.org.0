Return-Path: <kvm+bounces-27359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EFF2984487
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 13:30:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31CA7283DE8
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 11:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EDF61A7258;
	Tue, 24 Sep 2024 11:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mb6JIPK2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CDA1A707D;
	Tue, 24 Sep 2024 11:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727177358; cv=none; b=QQTwxixsbFTV6tOsraSgnz6xvVcgk0PIL0nSwBnFqK6nnbqjc75Ph52EQrdWgsz57PUdxWnOZrLaAmhzgph7nEgMEOka980pWc9xwHhVqTKsUCrkhhvU22hRvdaIFHxhAtnQJ/zQuP4wGJ+uU1g3Mli+CdtG0wb0QrWtKDCIsjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727177358; c=relaxed/simple;
	bh=cL2uUbkxGHfoIn5hEEk5cOTINpoJa4CyuJmYcpnso8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFpvUuBNbfilMVw+wlaBnlrZfcW/JEwrTP3aUNtub+JAT1IJ275EmlFKvXWd5Qo7JEM6kAhS5S16+qVaZKCkwZixOtWgEjbweXXqk8LoNaAoWp3jz6nBw/HuMfIylRv//0LFKNmsSDyONNZqAq3hCf1/EaLWT4Yax0z8YUPjOz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mb6JIPK2; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727177357; x=1758713357;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cL2uUbkxGHfoIn5hEEk5cOTINpoJa4CyuJmYcpnso8w=;
  b=mb6JIPK2WYbAcdcVToEquv0oYgf4MQt0c6kyjaeXOY3FiHXdLVTmE7cA
   vBPmMjljn0mTWlgHnLREF80WYZxpGIS1Z0gA85EiMta7mX3xk7qqsbHJt
   kCIxMeiCEeFZi/XoD1bv7s482ddnUecVh4NrDtgDe8T8+WT7dGmIt2e9J
   UGjjumqDYoduNZUJ6FCisvhieYZ1cOm5KwzE/Ygt2D7SCXLBba0h/6qHa
   P1eOfZJd3rocbJ1A+ot/yxDlhEkxHTYLR7xSNoWWAXcDrlQ5MjZYQYbi6
   TIdhVv/Jdy/kBDJ4Qaye44n38Cf5jnodT5GFZ1jaxH2BAG6Yry2gbyttZ
   g==;
X-CSE-ConnectionGUID: OdlPLrRXSRq3ls5SSCJh7w==
X-CSE-MsgGUID: wraUJLQtTpCWoqqkjyuW8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="43686487"
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="43686487"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 04:29:17 -0700
X-CSE-ConnectionGUID: o309BYRiRqGMYYRvSXwaGA==
X-CSE-MsgGUID: p6ecXfQ4S9CJ56swDYnVOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="70994585"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.221.10])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 04:29:13 -0700
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
Subject: [PATCH v4 2/8] x86/virt/tdx: Rework TD_SYSINFO_MAP to support build-time verification
Date: Tue, 24 Sep 2024 23:28:29 +1200
Message-ID: <608ba48cfdffcbbd06c8505e3ba8dc623edf5b10.1727173372.git.kai.huang@intel.com>
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

Dan noticed [1] that read_sys_metadata_field16() has a runtime warning
to validate that the metadata field size matches the passed in buffer
size.  In turns out that all the information to perform that validation
is available at build time.  Rework TD_SYSINFO_MAP() to stop providing
runtime data to read_sys_metadata_field16() and instead just pass typed
fields to read_sys_metadata_field16() and let the compiler catch any
mismatches.  Rename TD_SYSINFO_MAP() to READ_SYS_INFO() since it no
longer stores the mapping of metadata field ID and the structure member
offset.

For now READ_SYS_INFO() is only used in get_tdx_sys_info_tdmr().  Future
changes will need to read other metadata fields that are organized in
different structures.  Do #undef READ_SYS_INFO() after use so the same
pattern can be used for reading other metadata fields.  To avoid needing
to duplicate build-time verification in each READ_SYS_INFO() in future
changes, add a wrapper macro to do build-time verification and call it
from READ_SYS_INFO().

The READ_SYS_INFO() has a couple quirks for readability.  It requires
the function that uses it to define a local variable @ret to carry the
error code and set the initial value to 0.  It also hard-codes the
variable name of the structure pointer used in the function, but it is
less code, build-time verifiable, and the same readability as the former
'struct field_mapping' approach.

Link: http://lore.kernel.org/66b16121c48f4_4fc729424@dwillia2-xfh.jf.intel.com.notmuch [1]
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v3 -> v4:
 - Rename TD_SYSINFO_MAP() to READ_SYS_INFO() - Ardian.
 - #undef READ_SYS_INFO() - Ardian.
 - Rewrite changelog based on text from Dan, with some clarification
   around using READ_SYS_INFO() and #undef it.
 - Move the BUILD_BUG_ON() out of read_sys_metadata_field16() - Dan.
 - Use permalink in changelog - Dan.

v2 -> v3:
 - Remove 'struct field_mapping' and reimplement TD_SYSINFO_MAP().

---
 arch/x86/virt/vmx/tdx/tdx.c | 58 ++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 37 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index e979bf442929..2f7e4abc1bb9 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -270,60 +270,44 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
 	return 0;
 }
 
-static int read_sys_metadata_field16(u64 field_id,
-				     int offset,
-				     struct tdx_sys_info_tdmr *ts)
+static int __read_sys_metadata_field16(u64 field_id, u16 *val)
 {
-	u16 *ts_member = ((void *)ts) + offset;
 	u64 tmp;
 	int ret;
 
-	if (WARN_ON_ONCE(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=
-			MD_FIELD_ID_ELE_SIZE_16BIT))
-		return -EINVAL;
-
 	ret = read_sys_metadata_field(field_id, &tmp);
 	if (ret)
 		return ret;
 
-	*ts_member = tmp;
+	*val = tmp;
 
 	return 0;
 }
 
-struct field_mapping {
-	u64 field_id;
-	int offset;
-};
-
-#define TD_SYSINFO_MAP(_field_id, _offset) \
-	{ .field_id = MD_FIELD_ID_##_field_id,	   \
-	  .offset   = offsetof(struct tdx_sys_info_tdmr, _offset) }
-
-/* Map TD_SYSINFO fields into 'struct tdx_sys_info_tdmr': */
-static const struct field_mapping fields[] = {
-	TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs),
-	TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
-	TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
-	TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
-	TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
-};
+#define read_sys_metadata_field16(_field_id, _val)		\
+({								\
+	BUILD_BUG_ON(MD_FIELD_ID_ELE_SIZE_CODE(_field_id) !=	\
+			MD_FIELD_ID_ELE_SIZE_16BIT);		\
+	__read_sys_metadata_field16(_field_id, _val);		\
+})
 
 static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
 {
-	int ret;
-	int i;
+	int ret = 0;
 
-	/* Populate 'sysinfo_tdmr' fields using the mapping structure above: */
-	for (i = 0; i < ARRAY_SIZE(fields); i++) {
-		ret = read_sys_metadata_field16(fields[i].field_id,
-						fields[i].offset,
-						sysinfo_tdmr);
-		if (ret)
-			return ret;
-	}
+#define READ_SYS_INFO(_field_id, _member)				\
+	ret = ret ?: read_sys_metadata_field16(MD_FIELD_ID_##_field_id,	\
+					&sysinfo_tdmr->_member)
 
-	return 0;
+	READ_SYS_INFO(MAX_TDMRS,	     max_tdmrs);
+	READ_SYS_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr);
+	READ_SYS_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]);
+	READ_SYS_INFO(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]);
+	READ_SYS_INFO(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]);
+
+#undef READ_SYS_INFO
+
+	return ret;
 }
 
 /* Calculate the actual TDMR size */
-- 
2.46.0


