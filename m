Return-Path: <kvm+bounces-21748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79C699335B3
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 05:41:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35B48281868
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 03:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E01A814F98;
	Wed, 17 Jul 2024 03:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RAsOETya"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904C4125AC;
	Wed, 17 Jul 2024 03:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721187645; cv=none; b=d6Qus/uAGx2uZhXEqmGls6H01AQW2UU29zgbHFNJ+g+bex1dk8i5mmCU3ESpg4I15JB9oAjW12EMeR0C7BUrTYDTkJRty+5FmVq6HDS+J19S/0ndSqhVmfT2XcunlY5aJf1i4Uw5D+NYpz28/mBMAJT2+ehkp6C8TBZOKzOvZ50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721187645; c=relaxed/simple;
	bh=aXjCxwWAWxkPZeuSGjcrZZHRngrEEyvMgErSCYqnP/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUOGUlBqiRQJF7JkIOrN5QUeVvWZvdCFT/wMrXcTB84RotFcr2aOMRMfQGyfhsUpZdm62ACLjRjv0vAcLqbEcmugn9Mjr4XzIt3JZwk4jXsTyLpdFpn24JiSmZaWXATGtUkjj4B4/FDqCa/+FFEwYDixV2nfIjPS8fqfqfgzwgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RAsOETya; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721187643; x=1752723643;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aXjCxwWAWxkPZeuSGjcrZZHRngrEEyvMgErSCYqnP/Y=;
  b=RAsOETya8nDWCSCzeJnkT/1Btoqe9sXs6Yd17ChrH32FTSj4+M+rNt85
   GaYYcoWsLYX1a5ebKutsYdGjE/XrG7Sc8hwCrYYNKY18AHcJSqhgx1xXh
   Qf8UgX+boeMv/1T1NMY9B02bg9EH196qaCIBpTaxk7vQImlYFo2ntqRgU
   k1fvEr3fWPdoSt4VgJmoagSvFxiecqEZlVnmUNG0kvTb+uBIa7+06bS1z
   bxFzWVlDs97aC5bEEz7qcRVjzmg+t02Ady/Etd+GzZxl3KwBhmw6iyGNu
   8oz9axCAmcRqdCezHx/RzflRLDH0YexuiXkP3EY6PYUpgu7h86Yv6zVqO
   g==;
X-CSE-ConnectionGUID: 08+/jOMvTmK7lp4d+Wlxwg==
X-CSE-MsgGUID: rrDG3P92TCGIVUZcnsNVeA==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18512352"
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="18512352"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:40:43 -0700
X-CSE-ConnectionGUID: 1cvbUM8KQOmGpOdjSHM4CQ==
X-CSE-MsgGUID: n1x8nad1QBeFFAUkzDDVwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="54566698"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.184])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:40:39 -0700
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
Subject: [PATCH v2 02/10] x86/virt/tdx: Unbind global metadata read with 'struct tdx_tdmr_sysinfo'
Date: Wed, 17 Jul 2024 15:40:09 +1200
Message-ID: <7af2b06ec26e2964d8d5da21e2e9fa412e4ed6f8.1721186590.git.kai.huang@intel.com>
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

v1 -> v2:
 - 'st_member' -> 'member'. (Nikolay)

---
 arch/x86/virt/vmx/tdx/tdx.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index d8fa9325bf5e..2ce03c3ea017 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -272,9 +272,9 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
 
 static int read_sys_metadata_field16(u64 field_id,
 				     int offset,
-				     struct tdx_tdmr_sysinfo *ts)
+				     void *stbuf)
 {
-	u16 *ts_member = ((void *)ts) + offset;
+	u16 *member = stbuf + offset;
 	u64 tmp;
 	int ret;
 
@@ -286,7 +286,7 @@ static int read_sys_metadata_field16(u64 field_id,
 	if (ret)
 		return ret;
 
-	*ts_member = tmp;
+	*member = tmp;
 
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
2.45.2


