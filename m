Return-Path: <kvm+bounces-28749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5630899C8F9
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 13:33:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16A2C291580
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 11:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C13EA1957F9;
	Mon, 14 Oct 2024 11:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OnkvDVYe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFAA1A3BA1;
	Mon, 14 Oct 2024 11:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728905544; cv=none; b=dzzxVqAYLuIBRncQNI3TDBCCD1IpWsNjHJjYEFMDATfMjwF/xL/9vdyAag8xGeEvgPOfxu5MaGzdESBPXh1fWSGQTX4V3jiuv7mc2Gh5J8MhShkSEecX7sdXBnmtB4bViQHTdoYEFA+fHZJnTr/UB4tbFOGtJ83ofrMbS2t/0cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728905544; c=relaxed/simple;
	bh=GVy0J6oqeO5Tjm5jFsozOB8vjW3stLXFbkNZMEBBxtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOp6VoDOLrnERZ6a6wOtgjvES5gPpGGTs9N89XQyuWno0f0iL4FhJL7EUPZCpBB6186t+y+ShmXithf+b1HNf2ObCgMLmuLeQ6YUK/pIV4KhoKSRe8/LyLD0W/qkj4qBicLuWWqFVrsEwco4UAwohda3HcIQ1FzuE4AYxf9CspQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OnkvDVYe; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728905542; x=1760441542;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GVy0J6oqeO5Tjm5jFsozOB8vjW3stLXFbkNZMEBBxtE=;
  b=OnkvDVYe24ohi97OImdVxLXldBZamZD9xCwX4nRYRyxSx/jQsh5JA1A8
   aNUJktClkqAW699Xu3S3T1pYEGUnNogWN2gFhaNiTgJywYCCTlpX8YGhM
   fUV3MMUbpppIzyewR0E3xGw1a3NMKyv8nThz76Imqv/4sfgbIrDVoswdj
   dOJ7uku5gq9VwtKnvzf+Qgnj8NrpOlk3fCpc9po3HuajzxsPdLxsVz71Y
   iFU7zkdjyFH+TokDQbdCVGG3jBFP5Yg06RZ5MXbTtdsRZbUaBx1WoHq0j
   MdbtyvY9xoAwcy+opV0qGHHwfmXb+U2bGe+NFIfIXhzHimN5nzp+aC1RT
   A==;
X-CSE-ConnectionGUID: UuNnM5UUTuSzSFAFakvW1w==
X-CSE-MsgGUID: YsOGs7+OReWIeoPGOGeDNA==
X-IronPort-AV: E=McAfee;i="6700,10204,11224"; a="32166488"
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="32166488"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 04:32:22 -0700
X-CSE-ConnectionGUID: MBCaP5UcQDWpBd4I4eCClA==
X-CSE-MsgGUID: nFv1Ihp7QgO2i1dbwP53EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="82117474"
Received: from jdoman-desk1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.220.204])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 04:32:19 -0700
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
Subject: [PATCH v5 3/8] x86/virt/tdx: Prepare to support reading other global metadata fields
Date: Tue, 15 Oct 2024 00:31:50 +1300
Message-ID: <ecc9a68216a982452be4586d4160eeab6d7e27dd.1728903647.git.kai.huang@intel.com>
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

The TDX module provides a set of "Global Metadata Fields".  They report
things like TDX module version, supported features, and fields related
to create/run TDX guests and so on.  TDX supports 8/16/32/64 bits
metadata field element sizes.  For a given metadata field, the element
size is encoded in the metadata field ID.

For now the kernel only reads "TD Memory Region" (TDMR) related metadata
fields and they are all 16-bit.  Thus the kernel only has one primitive
__read_sys_metadata_field16() to read 16-bit metadata field and the
macro, read_sys_metadata_field16(), which does additional build-time
check of the field ID makes sure the field is indeed 16-bit.

Future changes will need to read more metadata fields with different
element sizes.  Rework the {__}read_sys_metadata_field16() primitives to
work with all 8/16/32/64 element sizes.

Note the new primitive __read_sys_metadata_field() takes 'void *buf' and
'int size' and explicitly uses memcpy() to copy the SEAMCALL returned
data (u64) to a pointer of u8/u16/u32/u64, instead of depending on the
compiler to know the size and copy.  But this is fine since the wrapper
read_sys_metadata_field(), which works with a pointer to u8/u16/32/u64,
passes the sizeof() to the __read_sys_metadata_field() internally.  And
it has BUILD_BUG_ON() to verify the metadata element size encoded in the
field ID indeed matches the size passed to __read_sys_metadata_field().

This ensures the users of read_sys_metadata_field() will never screw up.
Also add a comment to point out __read_sys_metadata_field() should not
be used directly.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v4 -> v5:
 - Change back to what Dave suggested and update changelog:

   https://lore.kernel.org/lkml/408dee3f-a466-4746-92d3-adf54d35ec7c@intel.com/
   
v3 -> v4:
 - Change to use one primitive for each element size, similar to
   build_mmio_read() macro - Dan.
 - Rewrite changelog based on the new code.
 - "global metadata fields" -> "Global Metadata Fields" - Ardian.

v2 -> v3:
 - Rename read_sys_metadata_field() to tdh_sys_rd() so the former can be
   used as the high level wrapper.  Get rid of "stbuf_" prefix since
   people don't like it.
 
 - Rewrite after removing 'struct field_mapping' and reimplementing
   TD_SYSINFO_MAP().
 
---
 arch/x86/virt/vmx/tdx/tdx.c | 21 +++++++++++----------
 arch/x86/virt/vmx/tdx/tdx.h |  3 ++-
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 2f7e4abc1bb9..d63efb2d50d1 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -250,7 +250,7 @@ static int build_tdx_memlist(struct list_head *tmb_list)
 	return ret;
 }
 
-static int read_sys_metadata_field(u64 field_id, u64 *data)
+static int tdh_sys_rd(u64 field_id, u64 *data)
 {
 	struct tdx_module_args args = {};
 	int ret;
@@ -270,25 +270,26 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
 	return 0;
 }
 
-static int __read_sys_metadata_field16(u64 field_id, u16 *val)
+/* Don't use this directly, but use read_sys_metadata_field() instead. */
+static int __read_sys_metadata_field(u64 field_id, void *val, int size)
 {
 	u64 tmp;
 	int ret;
 
-	ret = read_sys_metadata_field(field_id, &tmp);
+	ret = tdh_sys_rd(field_id, &tmp);
 	if (ret)
 		return ret;
 
-	*val = tmp;
+	memcpy(val, &tmp, size);
 
 	return 0;
 }
 
-#define read_sys_metadata_field16(_field_id, _val)		\
-({								\
-	BUILD_BUG_ON(MD_FIELD_ID_ELE_SIZE_CODE(_field_id) !=	\
-			MD_FIELD_ID_ELE_SIZE_16BIT);		\
-	__read_sys_metadata_field16(_field_id, _val);		\
+/* @_val must be a pointer to u8/u16/u32/u64 */
+#define read_sys_metadata_field(_field_id, _val)			\
+({									\
+	BUILD_BUG_ON(MD_FIELD_ELE_SIZE(_field_id) != sizeof(*(_val)));	\
+	__read_sys_metadata_field(_field_id, _val, sizeof(*(_val)));	\
 })
 
 static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
@@ -296,7 +297,7 @@ static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
 	int ret = 0;
 
 #define READ_SYS_INFO(_field_id, _member)				\
-	ret = ret ?: read_sys_metadata_field16(MD_FIELD_ID_##_field_id,	\
+	ret = ret ?: read_sys_metadata_field(MD_FIELD_ID_##_field_id,	\
 					&sysinfo_tdmr->_member)
 
 	READ_SYS_INFO(MAX_TDMRS,	     max_tdmrs);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 148f9b4d1140..7a8204a05bf7 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -53,7 +53,8 @@
 #define MD_FIELD_ID_ELE_SIZE_CODE(_field_id)	\
 		(((_field_id) & GENMASK_ULL(33, 32)) >> 32)
 
-#define MD_FIELD_ID_ELE_SIZE_16BIT	1
+#define MD_FIELD_ELE_SIZE(_field_id)   \
+	(1 << MD_FIELD_ID_ELE_SIZE_CODE(_field_id))
 
 struct tdmr_reserved_area {
 	u64 offset;
-- 
2.46.2


