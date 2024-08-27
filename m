Return-Path: <kvm+bounces-25123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C4979602C5
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 09:15:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DA161C2221E
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 07:15:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9A28187870;
	Tue, 27 Aug 2024 07:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TKU95QZX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9B2176AD8;
	Tue, 27 Aug 2024 07:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724742895; cv=none; b=W73A4qUdVi6EZAAabuw2X6C1EIxrd4IoKEIHqGBS8Y6NKV22UVtD07is/IeZAL1J55EG6pYJpit/UMTKoACDugXYLwUTykN91xlGddCbVfUVNyyvKq8+JTxwW3GnfIsvc+ncKWdQXiO3d2Pe9YyAk3HbTmnSmHYXOdvTvytt+To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724742895; c=relaxed/simple;
	bh=iFLI9opUKCsmP49NeCvv84rUP9mlus1wfcrUWKWlI3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBEYIg4+p9VVxvAxJ4AYzX4AR9Tzfb7entUaMZDQJ3JCRAl1mAJbNWcv9LbQ13aL39P2mTMdFS4bF7JczwXuLMh05qLHmrlGgP51WumncE+jkgGj7b11j2CfEGUdWcT2/pJP/yqBtLTiEfVBt9zx9WsAaTM97jBAIvV7k4CfcmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TKU95QZX; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724742893; x=1756278893;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iFLI9opUKCsmP49NeCvv84rUP9mlus1wfcrUWKWlI3k=;
  b=TKU95QZXB1eMW4Fn4RBCX3FyLYE79amH9uZYYYhFEgW+veQfuTCfszDu
   XKX1zX2en49hd+cx6Di0yUhTJ4241OX7YWqmsf0Kon2UFTpu5WuYiD9f/
   P4eQlyzjS9j7CCwIAgJfAuF9iNxNZ5141hR+oVlL/FsZaat83W9YCt+Rx
   WLeDzMrep1VDb84AMIw+vWj3u1x9VAu51nTD+OS7UVNQ4f7WkIKGoUIFH
   CpW5nh4E6442U9kXQjRCNbirOSMbzYP7XpfUpkiI2fU76tFhHF3oAmZ6i
   X2e6Bgc9rvjfQA07csjSxxRlrC8m0b4CPU0lNiJIsDNQYmcuf23bVD8Lq
   Q==;
X-CSE-ConnectionGUID: ParDVjRVS06E8jMVRKltCA==
X-CSE-MsgGUID: G1WC0tuOS8KWX8xwgi0Vfw==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="34575845"
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="34575845"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 00:14:53 -0700
X-CSE-ConnectionGUID: 9BBXF/xcQ9+ch2c5QL7FaQ==
X-CSE-MsgGUID: qpKaiLsLSEemSRikRiTTpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="63092554"
Received: from apaszkie-mobl2.apaszkie-mobl2 (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.81])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 00:14:48 -0700
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
Subject: [PATCH v3 2/8] x86/virt/tdx: Remove 'struct field_mapping' and implement TD_SYSINFO_MAP() macro
Date: Tue, 27 Aug 2024 19:14:24 +1200
Message-ID: <9eb6b2e3577be66ea2f711e37141ca021bf0159b.1724741926.git.kai.huang@intel.com>
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

TL;DR: Remove the 'struct field_mapping' structure and use another way
to implement the TD_SYSINFO_MAP() macro to improve the current metadata
reading code, e.g., switching to use build-time check for metadata field
size over the existing runtime check.

The TDX module provides a set of "global metadata fields".  They report
things like TDX module version, supported features, and fields related
to create/run TDX guests and so on.

For now the kernel only reads "TD Memory Region" (TDMR) related global
metadata fields, and all of those fields are organized in one structure.

The kernel currently uses 'struct field_mapping' to facilitate reading
multiple metadata fields into one structure.  The 'struct field_mapping'
records the mapping between the field ID and the offset of the structure
to fill out.  The kernel initializes an array of 'struct field_mapping'
for each structure member (using the TD_SYSINFO_MAP() macro) and then
reads all metadata fields in a loop using that array.

Currently the kernel only reads TDMR related metadata fields into one
structure, and the function to read one metadata field takes the pointer
of that structure and the offset:

  static int read_sys_metadata_field16(u64 field_id,
                                       int offset,
                                       struct tdx_sys_info_tdmr *ts)
  {...}

Future changes will need to read more metadata fields into different
structures.  To support this the above function will need to be changed
to take 'void *':

  static int read_sys_metadata_field16(u64 field_id,
                                       int offset,
                                       void *stbuf)
  {...}

This approach loses type-safety, as Dan suggested.  A better way is to
make it be ..

  static int read_sys_metadata_field16(u64 field_id, u16 *val) {...}

.. and let the caller calculate the buffer in a type-safe way [1].

Also, the using of the 'struct field_mapping' loses the ability to be
able to do build-time check about the metadata field size (encoded in
the field ID) due to the field ID is "indirectly" initialized to the
'struct field_mapping' and passed to the function to read.  Thus the
current code uses runtime check instead.

Dan suggested to remove the 'struct field_mapping', unroll the loop,
skip the array, and call the read_sys_metadata_field16() directly with
build-time check [1][2].  And to improve the readability, reimplement
the TD_SYSINFO_MAP() [3].

The new TD_SYSINFO_MAP() isn't perfect.  It requires the function that
uses it to define a local variable @ret to carry the error code and set
the initial value to 0.  It also hard-codes the variable name of the
structure pointer used in the function.  But overall the pros of this
approach beat the cons.

Link: https://lore.kernel.org/kvm/a107b067-861d-43f4-86b5-29271cb93dad@intel.com/T/#m7cfb3c146214d94b24e978eeb8708d92c0b14ac6 [1]
Link: https://lore.kernel.org/kvm/a107b067-861d-43f4-86b5-29271cb93dad@intel.com/T/#mbe65f0903ff7835bc418a907f0d02d7a9e0b78be [2]
Link: https://lore.kernel.org/kvm/a107b067-861d-43f4-86b5-29271cb93dad@intel.com/T/#m80cde5e6504b3af74d933ea0cbfc3ca9d24697d3 [3]
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v2 -> v3:
 - Remove 'struct field_mapping' and reimplement TD_SYSINFO_MAP().

---
 arch/x86/virt/vmx/tdx/tdx.c | 57 ++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 36 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index e979bf442929..7e75c1b10838 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -270,60 +270,45 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
 	return 0;
 }
 
-static int read_sys_metadata_field16(u64 field_id,
-				     int offset,
-				     struct tdx_sys_info_tdmr *ts)
+static int read_sys_metadata_field16(u64 field_id, u16 *val)
 {
-	u16 *ts_member = ((void *)ts) + offset;
 	u64 tmp;
 	int ret;
 
-	if (WARN_ON_ONCE(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=
-			MD_FIELD_ID_ELE_SIZE_16BIT))
-		return -EINVAL;
+	BUILD_BUG_ON(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=
+			MD_FIELD_ID_ELE_SIZE_16BIT);
 
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
+/*
+ * Assumes locally defined @ret and @sysinfo_tdmr to convey the error
+ * code and the 'struct tdx_sys_info_tdmr' instance to fill out.
+ */
+#define TD_SYSINFO_MAP(_field_id, _member)						\
+	({										\
+		if (!ret)								\
+			ret = read_sys_metadata_field16(MD_FIELD_ID_##_field_id,	\
+					&sysinfo_tdmr->_member);			\
+	})
 
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
+	TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs);
+	TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr);
+	TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]);
+	TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]);
+	TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]);
 
-	return 0;
+	return ret;
 }
 
 /* Calculate the actual TDMR size */
-- 
2.46.0


