Return-Path: <kvm+bounces-9628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6422A866C35
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:29:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C38A3B21CF0
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7ED71CD3E;
	Mon, 26 Feb 2024 08:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BYFQ0Z3s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529801EB5B;
	Mon, 26 Feb 2024 08:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936060; cv=none; b=tfLTV6l7Pxt3gb9+dWhzIYuniN0f2+V+Sl2fUD8i6j4LQnXU0vmRPxTeK8Rdim88dX3Uku/hG6N801R7ejZmYP27KTpKwxnTGkaQBSaZnOoWAcncq4ZjUrWxwBgQkc3wAKQfz6wsxGr+l+jWvAvf1gE8o1bwtE8aK4VIT3gIGOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936060; c=relaxed/simple;
	bh=Ipwvsm7XmA6ghvLHLEgf7+RqG0jtiV2UhCk6lJOoMpU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QRHUuKBmxinpY3egpJ8uNXmwoe7bWr3RuzCFDN2GHlaHvjrDy4lXm+bnhGrfXXtmj3x/29JgRKt1lgf4p9cv3g0s4mmdnxktwhxelA1C7FbxLY/9EZsKp4MDOCl2GYWqfp/hs8J79wIq8D4bU6mEX5H6dLEF3l1TYaFgeJmxYxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BYFQ0Z3s; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936058; x=1740472058;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ipwvsm7XmA6ghvLHLEgf7+RqG0jtiV2UhCk6lJOoMpU=;
  b=BYFQ0Z3stVG43PiQHxUs2lAS3NHq02vxRFzADqa1Fk92Sq25HoWKOwIO
   pTiSqKjwch9jzABzydlFcQMHZPLwslA1bFm3jl/ovKvQfb0yOcKErqtoC
   25PEtDECxF0pYdCZQ9OqllCaVuRaFnheEVMGxQJE/HNzKMSjPdvL7AqZ2
   j7Ko1gqTWG/HHwgh0qX5Hjjrbt3shxcWkLG0ebhtbDfPdfbcfoehBtkp0
   OGOVvO3t39wfMXjg+/xQoqWoZ0kbjHNkQTkHEpStTSHuPSRFXVOXvYiQz
   3g5JIPURH0MHinG5kZlFKH+OzDdhsDD4xNEIr7giQc+NZY/epLcsF58zx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3340702"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3340702"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="7020055"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:35 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v19 003/130] x86/virt/tdx: Unbind global metadata read with 'struct tdx_tdmr_sysinfo'
Date: Mon, 26 Feb 2024 00:25:05 -0800
Message-Id: <96c21cc1d283cf59ecba003cd5a19bfbce83675d.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kai Huang <kai.huang@intel.com>

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
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
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
2.25.1


