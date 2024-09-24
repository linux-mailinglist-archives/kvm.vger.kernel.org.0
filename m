Return-Path: <kvm+bounces-27360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 883FC984489
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 13:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E3E03B241E2
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 11:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A96761A727D;
	Tue, 24 Sep 2024 11:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FXMVESHW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467481A7264;
	Tue, 24 Sep 2024 11:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727177361; cv=none; b=TADjCRTrUd0YJHaBukxd8/0DVzcdHEPlKNaWvaTQKcCOgFgrE+b9wuXm86K/IRkM4VsgDvcM80thIjyY5SICVjTnSi3tnmJevZkYJ/mDTKjU6R6phCqNsds97o9LLDCCsj6M5jS1dvzWF2QFg/hcy6KiR3xyIg4+iph0+6Gofd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727177361; c=relaxed/simple;
	bh=jmm7W4ZtQRVxYWAMuq40hCi8DgUyQBrn8bapXyCz6BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tn3yVPVgkXwd8ai2gtRq6oztGqPzhM7zXNq4UWd7d3ch9wm2se1kCoQU00wA73tv0IjH/nwzhn2oKlMx2G765NW/UmrGCHgzF6OoyfOtFmkSnZcKK7EiCBhrArrZXMLkzQpFSEo2MHv64te12BeEB6rTFpAPlkbrryan2nA7ZXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FXMVESHW; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727177360; x=1758713360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jmm7W4ZtQRVxYWAMuq40hCi8DgUyQBrn8bapXyCz6BE=;
  b=FXMVESHWldeY3ty9vJH+r+pMDXf1DGZETzAd5rkMq6KUZHH92YpU0nZW
   nU2KRazEjbvpz2HtyDnh1FL0e9Ps13hT5UEbU76z9oZCec7pSw6RHhVPe
   qkZkfaRdey0EjqJb2wewFv2I+5/tueKgswc2jPIqs8glplcP6QnuN+i6w
   P8n/kgcFRYNafQfCE9kF4pq0IL5EvXERFlEJpppa1+4WUciI9hdVeurgN
   uCljbdlaHqHGI+xzQ9TPCryevRSJXMMn4OG8ReIO9r/porktmLtTgunRt
   G21Esl0+ZD4Z4wkwrPpNEza18S37ZoSf/XHBt2ZUvkkNRerl6OgybvDOQ
   A==;
X-CSE-ConnectionGUID: yuyQNojBTgqKq2sCimSBoA==
X-CSE-MsgGUID: RXKVSxMBQ1WBosxcf+mD3g==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="43686503"
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="43686503"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 04:29:20 -0700
X-CSE-ConnectionGUID: kv/9LVWITnOcZBB0Uii5Cg==
X-CSE-MsgGUID: LYDTA/H+TeOrRYronycUew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="70994603"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.221.10])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 04:29:17 -0700
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
Subject: [PATCH v4 3/8] x86/virt/tdx: Prepare to support reading other global metadata fields
Date: Tue, 24 Sep 2024 23:28:30 +1200
Message-ID: <101f6f252db860ad7a7433596006da0d210dd5cb.1727173372.git.kai.huang@intel.com>
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
element sizes.  Choose to provide one primitive for each element size to
support that.  Similar to the build_mmio_read() macro, reimplement the
body of __read_sys_metadata_field16() as a macro build_sysmd_read(_size)
in size-agnostic way, so it can be used to generate one primitive for
each element size:

  build_sysmd_read(8)
  build_sysmd_read(16)
  ..

Also extend read_sys_metadata_field16() take the '_size' as argument
(and rename it to read_sys_metadata_field() to make it size-agnostic) to
allow the READ_SYS_INFO() macro to choose which primitive to use.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

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
 arch/x86/virt/vmx/tdx/tdx.c | 40 ++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 2f7e4abc1bb9..b5c8dde9caf0 100644
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
@@ -270,25 +270,29 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
 	return 0;
 }
 
-static int __read_sys_metadata_field16(u64 field_id, u16 *val)
-{
-	u64 tmp;
-	int ret;
-
-	ret = read_sys_metadata_field(field_id, &tmp);
-	if (ret)
-		return ret;
-
-	*val = tmp;
-
-	return 0;
+#define build_sysmd_read(_size)							\
+static int __read_sys_metadata_field##_size(u64 field_id, u##_size *val)	\
+{										\
+	u64 tmp;								\
+	int ret;								\
+										\
+	ret = tdh_sys_rd(field_id, &tmp);					\
+	if (ret)								\
+		return ret;							\
+										\
+	*val = tmp;								\
+										\
+	return 0;								\
 }
 
-#define read_sys_metadata_field16(_field_id, _val)		\
+build_sysmd_read(16)
+
+#define read_sys_metadata_field(_field_id, _val, _size)		\
 ({								\
 	BUILD_BUG_ON(MD_FIELD_ID_ELE_SIZE_CODE(_field_id) !=	\
-			MD_FIELD_ID_ELE_SIZE_16BIT);		\
-	__read_sys_metadata_field16(_field_id, _val);		\
+			MD_FIELD_ID_ELE_SIZE_##_size##BIT);	\
+	BUILD_BUG_ON(_size != sizeof(*_val) * 8);		\
+	__read_sys_metadata_field##_size(_field_id, _val);	\
 })
 
 static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
@@ -296,8 +300,8 @@ static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
 	int ret = 0;
 
 #define READ_SYS_INFO(_field_id, _member)				\
-	ret = ret ?: read_sys_metadata_field16(MD_FIELD_ID_##_field_id,	\
-					&sysinfo_tdmr->_member)
+	ret = ret ?: read_sys_metadata_field(MD_FIELD_ID_##_field_id,	\
+					&sysinfo_tdmr->_member, 16)
 
 	READ_SYS_INFO(MAX_TDMRS,	     max_tdmrs);
 	READ_SYS_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr);
-- 
2.46.0


