Return-Path: <kvm+bounces-10631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B421E86E013
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 12:22:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D82FC1C21365
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 11:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC8296EB4C;
	Fri,  1 Mar 2024 11:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AgNqAzDq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0DD6EB40;
	Fri,  1 Mar 2024 11:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709292072; cv=none; b=ms9HWRWiCgGEE7E2nEqMn0tsX3vplI8AzlkvtjcyPcZZN9KInpgkDQyCI0HFwIo+dcBNVjgNugH7J0bjCeikYygXDMuPTqhXF9tq6ugkNyYIwjnH1pgTEdejNlvKoPDTpommYnbKgcj/r7n0kwMYWE5LteMnp7YHvM+w//rNhGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709292072; c=relaxed/simple;
	bh=0eBX029BCiLTue40MgYy0Z6NggPwsRuK/phCsbkLIbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c90jdFdMWrCa+m0DrDqN69O/N3joKWQMdIdiLnm6v9UKw3J1ub7zAIuRuuIRhQBDfcrJyPQE9aubLEqnZz3Mb7b0Wp/lYzlPR9RaurbomTcnugjwfum/n8m6JD3B1hf4Q6mTIhHSfGL8Z8fPXE999mCKl3i3KEiRjicyk6PPzoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AgNqAzDq; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709292070; x=1740828070;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0eBX029BCiLTue40MgYy0Z6NggPwsRuK/phCsbkLIbo=;
  b=AgNqAzDqs3QZEMq5EdT+05FsY5YFH3QQtU0TVG76OjTjxEKqEo5ha5cx
   /QTnJJ4HMAmo6eyzP5QzSimH2jK6YbQpD0Db+Cos5IReBO1SuTD/92jr/
   GcOaKrWz+rszEQxam6jtMY0RzSgZ9489kHKgZPqmnLmPBGxsp+lScKTY+
   AkxKNNdyJtrVbQczKumE1brCWfJuY68RY7dqO7HgCGdk/C78HQ7GRO6f4
   uFdgzuP3tV5YQ8DLNR1Os2DRx5nmQEg4TIsIxeE4tLXdNfJe0BwFnmJfJ
   40O0uuLUSubXErsW9iecrAJXoqOBwq3z9TLk9clzeVF+e3xg/vzBBRk/z
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="14465071"
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="14465071"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 03:21:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="31350707"
Received: from rcaudill-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.48.180])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 03:21:05 -0800
From: Kai Huang <kai.huang@intel.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: x86@kernel.org,
	dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	isaku.yamahata@intel.com,
	jgross@suse.com,
	kai.huang@intel.com
Subject: [PATCH 4/5] x86/virt/tdx: Support global metadata read for all element sizes
Date: Sat,  2 Mar 2024 00:20:36 +1300
Message-ID: <17f1c66ae6360b14f175c45aa486f4bdcf6e0a20.1709288433.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <cover.1709288433.git.kai.huang@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For now the kernel only reads TDMR related global metadata fields for
module initialization.  All these fields are 16-bits, and the kernel
only supports reading 16-bits fields.

KVM will need to read a bunch of non-TDMR related metadata to create and
run TDX guests.  It's essential to provide a generic metadata read
infrastructure which supports reading all 8/16/32/64 bits element sizes.

Extend the metadata read to support reading all these element sizes.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 59 +++++++++++++++++++++++++------------
 arch/x86/virt/vmx/tdx/tdx.h |  2 --
 2 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index eb208da4ff63..4ee4b8cf377c 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -271,23 +271,35 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
 	return 0;
 }
 
-static int read_sys_metadata_field16(u64 field_id,
-				     int offset,
-				     void *stbuf)
+/* Return the metadata field element size in bytes */
+static int get_metadata_field_bytes(u64 field_id)
 {
-	u16 *st_member = stbuf + offset;
+	/*
+	 * TDX supports 8/16/32/64 bits metadata field element sizes.
+	 * TDX module determines the metadata element size based on the
+	 * "element size code" encoded in the field ID (see the comment
+	 * of MD_FIELD_ID_ELE_SIZE_CODE macro for specific encodings).
+	 */
+	return 1 << MD_FIELD_ID_ELE_SIZE_CODE(field_id);
+}
+
+static int stbuf_read_sys_metadata_field(u64 field_id,
+					 int offset,
+					 int bytes,
+					 void *stbuf)
+{
+	void *st_member = stbuf + offset;
 	u64 tmp;
 	int ret;
 
-	if (WARN_ON_ONCE(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=
-			MD_FIELD_ID_ELE_SIZE_16BIT))
+	if (WARN_ON_ONCE(get_metadata_field_bytes(field_id) != bytes))
 		return -EINVAL;
 
 	ret = read_sys_metadata_field(field_id, &tmp);
 	if (ret)
 		return ret;
 
-	*st_member = tmp;
+	memcpy(st_member, &tmp, bytes);
 
 	return 0;
 }
@@ -295,11 +307,30 @@ static int read_sys_metadata_field16(u64 field_id,
 struct field_mapping {
 	u64 field_id;
 	int offset;
+	int size;
 };
 
 #define TD_SYSINFO_MAP(_field_id, _struct, _member)	\
 	{ .field_id = MD_FIELD_ID_##_field_id,		\
-	  .offset   = offsetof(_struct, _member) }
+	  .offset   = offsetof(_struct, _member),	\
+	  .size     = sizeof(typeof(((_struct *)0)->_member)) }
+
+static int read_sys_metadata(const struct field_mapping *fields, int nr_fields,
+			     void *stbuf)
+{
+	int i, ret;
+
+	for (i = 0; i < nr_fields; i++) {
+		ret = stbuf_read_sys_metadata_field(fields[i].field_id,
+				      fields[i].offset,
+				      fields[i].size,
+				      stbuf);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
 
 #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
 	TD_SYSINFO_MAP(_field_id, struct tdx_tdmr_sysinfo, _member)
@@ -314,19 +345,9 @@ static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
 		TD_SYSINFO_MAP_TDMR_INFO(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
 		TD_SYSINFO_MAP_TDMR_INFO(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
 	};
-	int ret;
-	int i;
 
 	/* Populate 'tdmr_sysinfo' fields using the mapping structure above: */
-	for (i = 0; i < ARRAY_SIZE(fields); i++) {
-		ret = read_sys_metadata_field16(fields[i].field_id,
-						fields[i].offset,
-						tdmr_sysinfo);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
+	return read_sys_metadata(fields, ARRAY_SIZE(fields), tdmr_sysinfo);
 }
 
 /* Calculate the actual TDMR size */
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index b701f69485d3..4c32c8bf156a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -53,8 +53,6 @@
 #define MD_FIELD_ID_ELE_SIZE_CODE(_field_id)	\
 		(((_field_id) & GENMASK_ULL(33, 32)) >> 32)
 
-#define MD_FIELD_ID_ELE_SIZE_16BIT	1
-
 struct tdmr_reserved_area {
 	u64 offset;
 	u64 size;
-- 
2.43.2


