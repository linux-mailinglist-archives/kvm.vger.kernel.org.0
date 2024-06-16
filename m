Return-Path: <kvm+bounces-19739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7FE7909D31
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 14:02:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00C121C2097C
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 12:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39E4418C322;
	Sun, 16 Jun 2024 12:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H8IO3eAj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11E8188CCA;
	Sun, 16 Jun 2024 12:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718539311; cv=none; b=pzy87pn66yYMHjekT6f2A3kjMfte2Aln6of5xXXaKwJoqSNgB8wMHwGoZONAtJ+pMc0mzO63OwZqRDRljwMcL/Iy24gsxjBUTxZwJsNzS5Nc3lNZiYPPBiLiMM0K/p3xyIJK7r7pgwDK7bO2vwl2UzoMg3SwIVeo4dv/aqrAEiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718539311; c=relaxed/simple;
	bh=FYdM0vd/yZti1cw7i+TA3IGlNMrYUsiVBS/rW4QPNeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0ee2HIGQu2tJwLLZqjpLju24JZOaeRCzQcMSqvC5fI6YuBcPwMviLMyuFFRwwkQu8ia6G3abRrRBHqaSlzi+ujNqq6YrwBhq0V9XkNkB6eP7wSXwyYKDde8XdV4GsA0cmOADG4eGX/oh7G3z0RY9ysQPUSFBW8A3G6RnRoZdu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H8IO3eAj; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718539310; x=1750075310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FYdM0vd/yZti1cw7i+TA3IGlNMrYUsiVBS/rW4QPNeE=;
  b=H8IO3eAjl0OZ12RqfqRKiQf5850LwiL8Q7iBetb/d8EwyXvSFanDfdpX
   iN+ThogMJkkYecLTGFwf+r9LwC4j57v8tdf8J5b5Vihhln43rIopXPHuq
   yudSvToMsH/ONKMFGQo6QRGEV9crdcRvDlLlnzG65gqpNPgC6GYFyG1i1
   /aid52Z/ga04DV+UL59diujcMfi7Iy2fDYu0lsk0MD8pBSL2f7/1bnI2v
   tYgEkdvV0axL0CGvDIa3N3MDX6o6Q602j7iLFGZsrUPpOL4OijLOqwOVb
   sBWvU7LAM1hO4vI7K837QCMb2rOXXc7889ixEyEpNV46g5gznJZWc23uY
   Q==;
X-CSE-ConnectionGUID: vZsXo6QCQY+3G38vj4Ifbw==
X-CSE-MsgGUID: qvGrlvrHQqu/P0eJVheoiQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11104"; a="26799997"
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="26799997"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:01:49 -0700
X-CSE-ConnectionGUID: wnDCm0NFSFCF6R1etM+Gtw==
X-CSE-MsgGUID: UykEkbVgQ06B/8x2lLREUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="46055813"
Received: from mgoodin-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.226])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:01:46 -0700
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
Subject: [PATCH 2/9] x86/virt/tdx: Unbind global metadata read with 'struct tdx_tdmr_sysinfo'
Date: Mon, 17 Jun 2024 00:01:12 +1200
Message-ID: <43c646d35088a0bada9fbbf8b731a7e4a44b22c0.1718538552.git.kai.huang@intel.com>
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

The TDX module provides a set of "global metadata fields".  They report
things like TDX module version, supported features, and fields related
to create/run TDX guests and so on.

For now the kernel only reads "TD Memory Region" (TDMR) related global
metadata fields to a 'struct tdx_tdmr_sysinfo' for initializing the TDX
module, and the metadata reading code can only work with that structure.

Future changes will need to read other metadata fields that don't make
sense to populate to the "struct tdx_tdmr_sysinfo".  It's essential to
provide a generic metadata read infrastructure which is not bound to any
specific structure.

To start providing such infrastructure, unbind the metadata reading code
with the 'struct tdx_tdmr_sysinfo'.

Note the kernel has a helper macro, TD_SYSINFO_MAP(), for marshaling the
metadata into the 'struct tdx_tdmr_sysinfo', and currently the macro
hardcodes the structure name.  As part of unbinding the metadata reading
code with 'struct tdx_tdmr_sysinfo', it is extended to accept different
structures.

Unfortunately, this will result in the usage of TD_SYSINFO_MAP() for
populating 'struct tdx_tdmr_sysinfo' to be changed to use the structure
name explicitly for each structure member and make the code longer.  Add
a wrapper macro which hides the 'struct tdx_tdmr_sysinfo' internally to
make the code shorter thus better readability.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index fbde24ea3b3e..854312e97eff 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -272,9 +272,9 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
 
 static int read_sys_metadata_field16(u64 field_id,
 				     int offset,
-				     struct tdx_tdmr_sysinfo *ts)
+				     void *stbuf)
 {
-	u16 *ts_member = ((void *)ts) + offset;
+	u16 *st_member = stbuf + offset;
 	u64 tmp;
 	int ret;
 
@@ -286,7 +286,7 @@ static int read_sys_metadata_field16(u64 field_id,
 	if (ret)
 		return ret;
 
-	*ts_member = tmp;
+	*st_member = tmp;
 
 	return 0;
 }
@@ -296,17 +296,20 @@ struct field_mapping {
 	int offset;
 };
 
-#define TD_SYSINFO_MAP(_field_id, _member) \
-	{ .field_id = MD_FIELD_ID_##_field_id,	   \
-	  .offset   = offsetof(struct tdx_tdmr_sysinfo, _member) }
+#define TD_SYSINFO_MAP(_field_id, _struct, _member)	\
+	{ .field_id = MD_FIELD_ID_##_field_id,		\
+	  .offset   = offsetof(_struct, _member) }
+
+#define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
+	TD_SYSINFO_MAP(_field_id, struct tdx_tdmr_sysinfo, _member)
 
 /* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
 static const struct field_mapping fields[] = {
-	TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs),
-	TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
-	TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
-	TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
-	TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
+	TD_SYSINFO_MAP_TDMR_INFO(MAX_TDMRS,		max_tdmrs),
+	TD_SYSINFO_MAP_TDMR_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
+	TD_SYSINFO_MAP_TDMR_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
+	TD_SYSINFO_MAP_TDMR_INFO(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
+	TD_SYSINFO_MAP_TDMR_INFO(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
 };
 
 static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
-- 
2.43.2


