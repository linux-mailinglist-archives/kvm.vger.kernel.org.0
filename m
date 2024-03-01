Return-Path: <kvm+bounces-10630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE51D86E011
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 12:22:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE38B1C21120
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 11:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF0BC6E5FA;
	Fri,  1 Mar 2024 11:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DwQQzOQO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFB86BFDA;
	Fri,  1 Mar 2024 11:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709292067; cv=none; b=t97KbDj1Ec2MHYELKCw0HK5k4GoD8SUESUrQAPogcsbDKKINfUeRZXd6KqLM1KnynoFJVSZsbYrcFvN8706tKLGNYMXCrMsMpFcHO6whOjUiKE9M7h8lJPcly/xD0NmhtwprP7sP3J9tI8F1+OxLaHAAqlcO6VeFuqe/6Ha8rHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709292067; c=relaxed/simple;
	bh=k3U4KpAsrlXajeTnJ0yhCURtBSDCFFQmd56PG+VaflI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQ5liugsoBM4eTHSXfHbNFR5gYwfoYFopTRzg0R32FUu0Z+xt/mC749QlFRnunKOI/AF3VhBT7l/OFwrF5YBDJ+Zrc/9VKmIT9wLfdKcwf+GNTiQkFXNxgUBiRVtWhoBtnskdCl/rx9YVqIWd16Lj79ysPwPanmKczo87xOmzio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DwQQzOQO; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709292065; x=1740828065;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k3U4KpAsrlXajeTnJ0yhCURtBSDCFFQmd56PG+VaflI=;
  b=DwQQzOQOJQBLy9XwfPVoFfHBHu8lT4ZTNNAnuTxBRPSfvUvgzX8eCElF
   RPUSMn8rzwumwxdZtAHHYHlLvXQcJ+jNhco+s3t62EKjnGftmgWkeCudZ
   SEdLeCDlXhPxEPCIs/8ZtN9H3fRLnMPlycMl9N9LR3CpuMvljblUL6pg0
   SNlyEQbc1scOuOfK3o+cnUtuTlHXjxjz63UFXi5UcmxEcg5IFN+kjH/Qf
   S/rTnryf46Bm31HkUtdabv5DgrMvHnwVL8JAX9DNCBX3DZovc0cXSp8/d
   26BmLtjMGEqU9k9EqqycIm+d6zaS0IgvAZj3kgAOm2ELTNfSsx8gCpKho
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="14465057"
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="14465057"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 03:21:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="31350694"
Received: from rcaudill-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.48.180])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 03:21:01 -0800
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
Subject: [PATCH 3/5] x86/virt/tdx: Unbind global metadata read with 'struct tdx_tdmr_sysinfo'
Date: Sat,  2 Mar 2024 00:20:35 +1300
Message-ID: <393931ee1d8f0dfb199b3e81aa660f2af0351129.1709288433.git.kai.huang@intel.com>
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
module initialization, and the metadata read code only works with the
'struct tdx_tdmr_sysinfo'.

KVM will need to read a bunch of non-TDMR related metadata to create and
run TDX guests.  It's essential to provide a generic metadata read
infrastructure which is not bound to any specific structure.

To start providing such infrastructure, unbound the metadata read with
the 'struct tdx_tdmr_sysinfo'.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index cdcb3332bc5d..eb208da4ff63 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -273,9 +273,9 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
 
 static int read_sys_metadata_field16(u64 field_id,
 				     int offset,
-				     struct tdx_tdmr_sysinfo *ts)
+				     void *stbuf)
 {
-	u16 *ts_member = ((void *)ts) + offset;
+	u16 *st_member = stbuf + offset;
 	u64 tmp;
 	int ret;
 
@@ -287,7 +287,7 @@ static int read_sys_metadata_field16(u64 field_id,
 	if (ret)
 		return ret;
 
-	*ts_member = tmp;
+	*st_member = tmp;
 
 	return 0;
 }
@@ -297,19 +297,22 @@ struct field_mapping {
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
 
 static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
 {
 	/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
 	const struct field_mapping fields[] = {
-		TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs),
-		TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
-		TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
-		TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
-		TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
+		TD_SYSINFO_MAP_TDMR_INFO(MAX_TDMRS,		max_tdmrs),
+		TD_SYSINFO_MAP_TDMR_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
+		TD_SYSINFO_MAP_TDMR_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
+		TD_SYSINFO_MAP_TDMR_INFO(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
+		TD_SYSINFO_MAP_TDMR_INFO(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
 	};
 	int ret;
 	int i;
-- 
2.43.2


