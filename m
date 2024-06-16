Return-Path: <kvm+bounces-19740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A5E9B909D33
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 14:02:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 505FB1F213A9
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 12:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 094D718C356;
	Sun, 16 Jun 2024 12:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AsGVBrZA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A647818C336;
	Sun, 16 Jun 2024 12:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718539315; cv=none; b=ZdJvaxBhm/V/WVRGoP0hj+im548XCDkuYL0ujGJ2xv1ODAthfOc3pgka3Fm/VGmbNqen0QofVlICGxB0A2af9eGpex3CMkSaKyhxvsY3/pa0I7+A5AagjFb1lz8B5GrVT+pkAmbeWrVQRsuGmRnuhHQrB8kfxOOn2ndC4a+gDYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718539315; c=relaxed/simple;
	bh=s8I8gURAQHYQFee7FboDTILPxJxSD3iizKPdO6AZT+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjnodHKL3ULAbw07JgzrYiFv83BGDIg7mhyfFB+/HwTDGT00y5C987HOzd22gwHfJFd+XwaGXWYy6bmtOSKMS2lX0Dpu+2o+5p9gGg3Gi3WYNOHaLG+hKCMlZ904b7X2zcb8d1F4i6rlTod3GhgR9Dk2Ou3Ssa1/gsxPfyFkpJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AsGVBrZA; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718539314; x=1750075314;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s8I8gURAQHYQFee7FboDTILPxJxSD3iizKPdO6AZT+w=;
  b=AsGVBrZA7XJ6V0Cq51daV9ulFhabIrwf5ekKlw2Dz4mRQDIbmfbXpLJl
   gYiJ4h/AoJEZI24iY66rtBNbnlCes/aI+RPGIAyEnYb0aMfNrZb9ri+Hl
   tBeKzwyteQBbJ7n4lYwfaSoQ0vSQDba9NCm+0xhaPmrR2x7u0INEVCeyG
   kHYk/daGRLYETv9n2ELFNvAhRx75xBDti6gDa2uPihnhTPBH6e2r33gZ6
   4p+LtQ5W4gPso0hR6/KJseOJe0+siOhiOGEzXqksQo4YgKMJXwjgAxXdp
   MrIba6M/xkG/9jqm0ulftQ0TtdHgdVNAXXyjovTDu0EG0jAT2jZukONhU
   Q==;
X-CSE-ConnectionGUID: qDomohBWRgCwv6vMwHqYfA==
X-CSE-MsgGUID: 616XbCT9QEKv/XOyYWmgVw==
X-IronPort-AV: E=McAfee;i="6700,10204,11104"; a="26800006"
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="26800006"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:01:53 -0700
X-CSE-ConnectionGUID: HlxInbRpQfuTPlsExV5htw==
X-CSE-MsgGUID: uDrVl7YPTTOdMsP5302M9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="46055832"
Received: from mgoodin-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.226])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:01:50 -0700
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
Subject: [PATCH 3/9] x86/virt/tdx: Support global metadata read for all element sizes
Date: Mon, 17 Jun 2024 00:01:13 +1200
Message-ID: <210f7747058e01c4d2ed683660a4cb18c5d88440.1718538552.git.kai.huang@intel.com>
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
 arch/x86/virt/vmx/tdx/tdx.c | 29 ++++++++++++++++-------------
 arch/x86/virt/vmx/tdx/tdx.h |  3 ++-
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 854312e97eff..4392e82a9bcb 100644
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
+				  int bytes)
 {
-	u16 *st_member = stbuf + offset;
+	void *st_member = stbuf + offset;
 	u64 tmp;
 	int ret;
 
-	if (WARN_ON_ONCE(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=
-			MD_FIELD_ID_ELE_SIZE_16BIT))
+	if (WARN_ON_ONCE(MD_FIELD_BYTES(field_id) != bytes))
 		return -EINVAL;
 
 	ret = read_sys_metadata_field(field_id, &tmp);
 	if (ret)
 		return ret;
 
-	*st_member = tmp;
+	memcpy(st_member, &tmp, bytes);
 
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
index b701f69485d3..812943516946 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -53,7 +53,8 @@
 #define MD_FIELD_ID_ELE_SIZE_CODE(_field_id)	\
 		(((_field_id) & GENMASK_ULL(33, 32)) >> 32)
 
-#define MD_FIELD_ID_ELE_SIZE_16BIT	1
+#define MD_FIELD_BYTES(_field_id)	\
+		(1 << MD_FIELD_ID_ELE_SIZE_CODE(_field_id))
 
 struct tdmr_reserved_area {
 	u64 offset;
-- 
2.43.2


