Return-Path: <kvm+bounces-21749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 565819335B5
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 05:41:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A4A01F223FF
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 03:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D8E78BF3;
	Wed, 17 Jul 2024 03:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N0QF5mPR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAABA18E11;
	Wed, 17 Jul 2024 03:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721187661; cv=none; b=rc8x6l6xjVKAtHPD5WxLYvWc5NgjVTOGKEYrqiKn5AllPdxuyKGYqkOHen4hGkyL+ykCcJEYg9YeF1/ZQ6WZjnPI50Ngl2SoBUYGgEHr8lU5rkdaEW/EkAzE+kHOi/g7vv1xASKprmT/ER3ASFYK4bqa7KdODZo4uwMWBCOd4bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721187661; c=relaxed/simple;
	bh=Ut9pLSIKiegISfQ+j0qPxLsFEctC+3z6lvxXveQnzk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imOl3F68OD6WnWjFKnezDMGjTuD/Jqj8UfvZn3SjC5VFYydV4TXMaBbV7dkUvbxvR1djXdEtImN2RIvLlLs8AgQSW35wJEbYvcv/j1FngQqT0SLfMX0CRYd2jHnJUhXzmG7QOZMSRAJXJAJggpSzfk+7qDTsi3OKeohqGzKr6A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N0QF5mPR; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721187660; x=1752723660;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ut9pLSIKiegISfQ+j0qPxLsFEctC+3z6lvxXveQnzk4=;
  b=N0QF5mPRAt8AGQD70HgBnrv5slwPkVbizYh6XGAMixAK2n7K7hlvZ//F
   Hltg3BB3H9w+UCjeg4OgfMIyx7dQZAtYiLXpVPmxetrOQlEf6jVVaKCJI
   LRdoD70RgKiw4qHabf4lyT/PzvHPwvVDqINcAt1HIDm6Hd2BBqlBQCiUt
   njl7pNas1Ep5d6Yr4ncKoYePCfTbpfaUjyXnzpKpf7p7/IqCEaBZNdRzD
   a0CAn873OnhA/Bbas9nU8XRn7e6GV/0eFEFix92bn2PLpztGtg7F4cmwq
   skHaIo1Rck+s9m0lCIOPO4ohHE2PkwZgfUPNQz/wHaz5jaofDzcWJ1yEM
   A==;
X-CSE-ConnectionGUID: 8Ol4otLhRjWM5XRTBjykcA==
X-CSE-MsgGUID: 8kA1doYbQemxhzxr5HwSOQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18512373"
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="18512373"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:40:47 -0700
X-CSE-ConnectionGUID: zmI4Ic3XQv2JIWkmvQV/DA==
X-CSE-MsgGUID: aJq1d8YeTaK0KQZhh69+EA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="54566710"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.184])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:40:43 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	dan.j.williams@intel.com
Cc: x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	chao.gao@intel.com,
	binbin.wu@linux.intel.com,
	kai.huang@intel.com
Subject: [PATCH v2 03/10] x86/virt/tdx: Support global metadata read for all element sizes
Date: Wed, 17 Jul 2024 15:40:10 +1200
Message-ID: <442637364b55c8a721f72a201e838eb5c271e0eb.1721186590.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1721186590.git.kai.huang@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The TDX module provides "global metadata fields" for software to query.
Each metadata field is accessible by a unique "metadata field ID".  TDX
supports 8/16/32/64 bits metadata element sizes.  The size of each
metadata field is encoded in its associated metadata field ID.

For now the kernel only reads "TD Memory Region" (TDMR) related global
metadata fields for module initialization.  All these metadata fields
are 16-bit, and the kernel only supports reading 16-bit fields.

Future changes will need to read more metadata fields with other element
sizes.  To resolve this once for all, extend the existing metadata
reading code to support reading all element sizes.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---

v1 -> v2 (Nikolay):
 - MD_FIELD_BYTES() -> MD_FIELD_ELE_SIZE().
 - 'bytes' -> 'size' in stbuf_read_sysmd_field().

---
 arch/x86/virt/vmx/tdx/tdx.c | 29 ++++++++++++++++-------------
 arch/x86/virt/vmx/tdx/tdx.h |  3 ++-
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 2ce03c3ea017..4644b324ff86 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -270,23 +270,25 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
 	return 0;
 }
 
-static int read_sys_metadata_field16(u64 field_id,
-				     int offset,
-				     void *stbuf)
+/*
+ * Read one global metadata field and store the data to a location of a
+ * given buffer specified by the offset and size (in bytes).
+ */
+static int stbuf_read_sysmd_field(u64 field_id, void *stbuf, int offset,
+				  int size)
 {
-	u16 *member = stbuf + offset;
+	void *member = stbuf + offset;
 	u64 tmp;
 	int ret;
 
-	if (WARN_ON_ONCE(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=
-			MD_FIELD_ID_ELE_SIZE_16BIT))
+	if (WARN_ON_ONCE(MD_FIELD_ELE_SIZE(field_id) != size))
 		return -EINVAL;
 
 	ret = read_sys_metadata_field(field_id, &tmp);
 	if (ret)
 		return ret;
 
-	*member = tmp;
+	memcpy(member, &tmp, size);
 
 	return 0;
 }
@@ -294,11 +296,13 @@ static int read_sys_metadata_field16(u64 field_id,
 struct field_mapping {
 	u64 field_id;
 	int offset;
+	int size;
 };
 
-#define TD_SYSINFO_MAP(_field_id, _struct, _member)	\
-	{ .field_id = MD_FIELD_ID_##_field_id,		\
-	  .offset   = offsetof(_struct, _member) }
+#define TD_SYSINFO_MAP(_field_id, _struct, _member)		\
+	{ .field_id = MD_FIELD_ID_##_field_id,			\
+	  .offset   = offsetof(_struct, _member),		\
+	  .size	    = sizeof(typeof(((_struct *)0)->_member)) }
 
 #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
 	TD_SYSINFO_MAP(_field_id, struct tdx_tdmr_sysinfo, _member)
@@ -319,9 +323,8 @@ static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
 
 	/* Populate 'tdmr_sysinfo' fields using the mapping structure above: */
 	for (i = 0; i < ARRAY_SIZE(fields); i++) {
-		ret = read_sys_metadata_field16(fields[i].field_id,
-						fields[i].offset,
-						tdmr_sysinfo);
+		ret = stbuf_read_sysmd_field(fields[i].field_id, tdmr_sysinfo,
+				fields[i].offset, fields[i].size);
 		if (ret)
 			return ret;
 	}
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index b701f69485d3..fdb879ef6c45 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -53,7 +53,8 @@
 #define MD_FIELD_ID_ELE_SIZE_CODE(_field_id)	\
 		(((_field_id) & GENMASK_ULL(33, 32)) >> 32)
 
-#define MD_FIELD_ID_ELE_SIZE_16BIT	1
+#define MD_FIELD_ELE_SIZE(_field_id)	\
+		(1 << MD_FIELD_ID_ELE_SIZE_CODE(_field_id))
 
 struct tdmr_reserved_area {
 	u64 offset;
-- 
2.45.2


