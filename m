Return-Path: <kvm+bounces-25124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B31B9602C7
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 09:16:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70F0F1C22223
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 07:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41BA4190075;
	Tue, 27 Aug 2024 07:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F1+Me+tR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0BF18BC0B;
	Tue, 27 Aug 2024 07:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724742899; cv=none; b=c9KmkoVK0bUMW4OcZHIJJAvYDv0e2Oao9hRjSWataSBDOH30evVwNscMDtWBctArQrcQoxburH/c0AI0e8kOQYREafr1ylo56YSL5lol6WyFjM0RinqgRhGyhqpkCe5hk97tGgZD3aWXhgzA0iS2E+v4RyDYyXTO2ocfNxAF4i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724742899; c=relaxed/simple;
	bh=4xKIYmHCB/2TOsHERqmzFIZbnqrMLQF47LCBJ+7nB9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9BdSrJmcV2xCuwwQYS0SJAiwUS04YNAuNPBna3lh1EAlm0cLQB9Qb8amx8ztkQNyA4DL21SxoCrkbIiPE5157AlwT/JHPLRVjj6XACBkMfwmB8NL1irNZ8vCk+TupHknzqzToynEHIFu/3xiIrTbC18v1Ub0chCzI68B7KpyUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F1+Me+tR; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724742898; x=1756278898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4xKIYmHCB/2TOsHERqmzFIZbnqrMLQF47LCBJ+7nB9Q=;
  b=F1+Me+tRddD6shRhq1cfHW2/XquedKNEGNkEDPMh2wQONEitzgVmgX7V
   eDxqGNNHtg3nrbuB5fKHAvSX3bv/xFXajUcrWSIV2LQGCuPyovYM6B/h5
   AYzUDOrHVfQHGgX+6/V+16gdYJ9ltEIJ/NdVBA3N2J91hzhuSDgO55cZ1
   1HemLoh4pKX8TMKvyvitUB1T4RHsz69y1KTFFwbFN0qMJXFl2DeC9bEBP
   EHSrzaXwkrfRODmRg62YXhNqzYG7FMMgEXS++0qUP5YygQUrOrjENlfv1
   pZkWALo/taz+VhfNiVVuwbaJvs6m2YNmhB0GCkZf2Kr6yk/GEMqFugXD+
   Q==;
X-CSE-ConnectionGUID: IMJ6tyrbRJKratnF9DAgNg==
X-CSE-MsgGUID: 9KNFgBQ6T2u7sW+kJORlNg==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="34575855"
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="34575855"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 00:14:57 -0700
X-CSE-ConnectionGUID: RpoSBTgSS7Gh1aKt4zBBFQ==
X-CSE-MsgGUID: /RnOVXIeQKKdH0VtiHqUSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="63092562"
Received: from apaszkie-mobl2.apaszkie-mobl2 (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.81])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 00:14:53 -0700
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
Subject: [PATCH v3 3/8] x86/virt/tdx: Prepare to support reading other global metadata fields
Date: Tue, 27 Aug 2024 19:14:25 +1200
Message-ID: <0403cdb142b40b9838feeb222eb75a4831f6b46d.1724741926.git.kai.huang@intel.com>
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

The TDX module provides a set of "global metadata fields".  They report
things like TDX module version, supported features, and fields related
to create/run TDX guests and so on.

For now the kernel only reads "TD Memory Region" (TDMR) related fields
for module initialization.  There are both immediate needs to read more
fields for module initialization and near-future needs for other kernel
components like KVM to run TDX guests.
will be organized in different structures depending on their meanings.

For now the kernel only reads TDMR related fields.  The TD_SYSINFO_MAP()
macro hard-codes the 'struct tdx_sys_info_tdmr' instance name.  To make
it work with different instances of different structures, extend it to
take the structure instance name as an argument.

This also means the current code which uses TD_SYSINFO_MAP() must type
'struct tdx_sys_info_tdmr' instance name explicitly for each use.  To
make the code easier to read, add a wrapper TD_SYSINFO_MAP_TDMR_INFO()
which hides the instance name.

TDX also support 8/16/32/64 bits metadata field element sizes.  For now
all TDMR related fields are 16-bit long thus the kernel only has one
helper:

  static int read_sys_metadata_field16(u64 field_id, u16 *val) {}

Future changes will need to read more metadata fields with different
element sizes.  To make the code short, extend the helper to take a
'void *' buffer and the buffer size so it can work with all element
sizes.

Note in this way the helper loses the type safety and the build-time
check inside the helper cannot work anymore because the compiler cannot
determine the exact value of the buffer size.

To resolve those, add a wrapper of the helper which only works with
u8/u16/u32/u64 directly and do build-time check, where the compiler
can easily know both the element size (from field ID) and the buffer
size(using sizeof()), before calling the helper.

An alternative option is to provide one helper for each element size:

  static int read_sys_metadata_field8(u64 field_id, u8 *val) {}
  static int read_sys_metadata_field16(u64 field_id, u16 *val) {}
  ...

But this will result in duplicated code given those helpers will look
exactly the same except for the type of buffer pointer.  It's feasible
to define a macro for the body of the helper and define one entry for
each element size to reduce the code, but it is a little bit
over-engineering.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v2 -> v3:
 - Rename read_sys_metadata_field() to tdh_sys_rd() so the former can be
   used as the high level wrapper.  Get rid of "stbuf_" prefix since
   people don't like it.
 
 - Rewrite after removing 'struct field_mapping' and reimplementing
   TD_SYSINFO_MAP().
 
---
 arch/x86/virt/vmx/tdx/tdx.c | 45 +++++++++++++++++++++----------------
 arch/x86/virt/vmx/tdx/tdx.h |  3 ++-
 2 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 7e75c1b10838..1cd9035c783f 100644
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
@@ -270,43 +270,50 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
 	return 0;
 }
 
-static int read_sys_metadata_field16(u64 field_id, u16 *val)
+static int __read_sys_metadata_field(u64 field_id, void *val, int size)
 {
 	u64 tmp;
 	int ret;
 
-	BUILD_BUG_ON(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=
-			MD_FIELD_ID_ELE_SIZE_16BIT);
-
-	ret = read_sys_metadata_field(field_id, &tmp);
+	ret = tdh_sys_rd(field_id, &tmp);
 	if (ret)
 		return ret;
 
-	*val = tmp;
+	memcpy(val, &tmp, size);
 
 	return 0;
 }
 
+/* Wrapper to read one global metadata to u8/u16/u32/u64 */
+#define read_sys_metadata_field(_field_id, _val)					\
+	({										\
+		BUILD_BUG_ON(MD_FIELD_ELE_SIZE(_field_id) != sizeof(typeof(*(_val))));	\
+		__read_sys_metadata_field(_field_id, _val, sizeof(typeof(*(_val))));	\
+	})
+
 /*
- * Assumes locally defined @ret and @sysinfo_tdmr to convey the error
- * code and the 'struct tdx_sys_info_tdmr' instance to fill out.
+ * Read one global metadata field to a member of a structure instance,
+ * assuming locally defined @ret to convey the error code.
  */
-#define TD_SYSINFO_MAP(_field_id, _member)						\
-	({										\
-		if (!ret)								\
-			ret = read_sys_metadata_field16(MD_FIELD_ID_##_field_id,	\
-					&sysinfo_tdmr->_member);			\
+#define TD_SYSINFO_MAP(_field_id, _stbuf, _member)				\
+	({									\
+		if (!ret)							\
+			ret = read_sys_metadata_field(MD_FIELD_ID_##_field_id,	\
+					&_stbuf->_member);			\
 	})
 
 static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
 {
 	int ret = 0;
 
-	TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs);
-	TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr);
-	TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]);
-	TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]);
-	TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]);
+#define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
+	TD_SYSINFO_MAP(_field_id, sysinfo_tdmr, _member)
+
+	TD_SYSINFO_MAP_TDMR_INFO(MAX_TDMRS,	        max_tdmrs);
+	TD_SYSINFO_MAP_TDMR_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr);
+	TD_SYSINFO_MAP_TDMR_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]);
+	TD_SYSINFO_MAP_TDMR_INFO(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]);
+	TD_SYSINFO_MAP_TDMR_INFO(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]);
 
 	return ret;
 }
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 148f9b4d1140..7458f6717873 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -53,7 +53,8 @@
 #define MD_FIELD_ID_ELE_SIZE_CODE(_field_id)	\
 		(((_field_id) & GENMASK_ULL(33, 32)) >> 32)
 
-#define MD_FIELD_ID_ELE_SIZE_16BIT	1
+#define MD_FIELD_ELE_SIZE(_field_id)	\
+	(1 << MD_FIELD_ID_ELE_SIZE_CODE(_field_id))
 
 struct tdmr_reserved_area {
 	u64 offset;
-- 
2.46.0


