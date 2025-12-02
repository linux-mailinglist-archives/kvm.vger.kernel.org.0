Return-Path: <kvm+bounces-65068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C9E8C9A140
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 06:25:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1D4A64E365C
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 05:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C84C2F549E;
	Tue,  2 Dec 2025 05:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TMCUk9cc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEE32F7477;
	Tue,  2 Dec 2025 05:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764653067; cv=none; b=fxF2VwTn9vkuTPPghXoqZJjVL/Zp9BHSSsNKnFXNA2t8q1DBNVIFMJhwvENfK9XmLmDpsDafTZASgNG3DsY1itgQswm+Gfa1YiwEwPOaLSD16vgwcOCiMyuZbon9VIwbYFApBmlMboSd0UiEuP/MzrPn2O7Y3RTAGGHK/tvuBL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764653067; c=relaxed/simple;
	bh=qlg3FbLlgqbN7UJZOFxubehF4BgZA2rJ6kpicjSvhPo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GnagE8rv3AhicXEruQta2uLRrf+xFi0JrUPrR9dqti1PramgNq5O9ORzY45xko4uyBXZk8L3BVzDG7M7clGEzOzv1/IiftsRFIgDEUHU8DdYNF4GKj5cGkR8LVuorsSkl80M3/yq/VGPczSxlqk09Ynsrw9Wi6J/tp0i8atErb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TMCUk9cc; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764653065; x=1796189065;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qlg3FbLlgqbN7UJZOFxubehF4BgZA2rJ6kpicjSvhPo=;
  b=TMCUk9cccN3csf+8uPwRJxP/O3ug+bXXSRoj6DLZOr/ENhaGPFgYZENi
   mBb5V9N9KBsw4oODuGN7DFuelscTvPWAYeg2sg++4T1gb8UaowD4cmay8
   ShzmXKKd9LRY56nRdNa+30z50vMiMvtTBS7mDulftXXgQ/rByVU8Nq4wJ
   r6zW8AgUkYRuOdrhaTqFto0wySfggJgS7U6PccngdZXpXQkJ0/lK2yNxx
   yMxMXDqEtue/e598tk0MEH7j7TwbhOff3lNGTnshRFYdD1qGAjzgxDSJz
   TfBi0HeD0co46kx4Hq6D1QqMUMiktInbDAbxzb2WRtQhDnJbvtv2/AzK7
   Q==;
X-CSE-ConnectionGUID: iMXzl2iVS3+gojit7hp3HQ==
X-CSE-MsgGUID: oezalKjuT42z9lG6jfSatA==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="76929824"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="76929824"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 21:24:25 -0800
X-CSE-ConnectionGUID: Xii8LqLNQXKZB1v5EdSang==
X-CSE-MsgGUID: Ql1SO3kpS1GoKdODd36/vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="199399263"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa005.jf.intel.com with ESMTP; 01 Dec 2025 21:24:23 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: x86@kernel.org,
	dave.hansen@linux.intel.com,
	kas@kernel.org,
	linux-kernel@vger.kernel.org
Cc: chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	dan.j.williams@intel.com,
	baolu.lu@linux.intel.com,
	yilun.xu@linux.intel.com,
	yilun.xu@intel.com,
	zhenzhong.duan@intel.com,
	kvm@vger.kernel.org,
	adrian.hunter@intel.com
Subject: [PATCH 4/6] x86/virt/tdx: Sanity check the size of each metadata field
Date: Tue,  2 Dec 2025 13:08:42 +0800
Message-Id: <20251202050844.2520762-5-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251202050844.2520762-1-yilun.xu@linux.intel.com>
References: <20251202050844.2520762-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the build-time check to ensure the manually input field mappings
have consistent size definitions. I.e. for each mapping entry, the size
code in field_id should match the corresponding struct member type. This
type safe check prevents wrong interpretation of the readout value.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 24 ++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index 3db87c4accd6..836d97166a7a 100644
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
@@ -13,10 +13,32 @@ struct field_mapping {
 	int size;
 };
 
+/*
+ * Size of field abstracted from field ID.
+ *
+ * See Table "MD_FIELD_ID (Metadata Field Identifier / Sequence Header)
+ * Definition", TDX module 1.5 ABI spec.
+ *
+ *  - Bit 33:32: ELEMENT_SIZE_CODE -- size of a single element of metadata
+ *
+ *	0: 8 bits
+ *	1: 16 bits
+ *	2: 32 bits
+ *	3: 64 bits
+ */
+#define MD_FIELD_SIZE_CODE(_field_id)	\
+	(((_field_id) & GENMASK_ULL(33, 32)) >> 32)
+
+#define MD_FIELD_SIZE(_field_id) (1 << MD_FIELD_SIZE_CODE(_field_id))
+
+#define TD_SYSINFO_CHECK_SIZE(_field_id, _size)		\
+	__builtin_choose_expr(MD_FIELD_SIZE(_field_id) == (_size), _size, (void)0)
+
 #define TD_SYSINFO_MAP(_field_id, _member)				\
 	{ .field_id = _field_id,					\
 	  .offset = offsetof(struct tdx_sys_info, _member),		\
-	  .size = sizeof_field(struct tdx_sys_info, _member) }
+	  .size = TD_SYSINFO_CHECK_SIZE(_field_id,			\
+					sizeof_field(struct tdx_sys_info, _member)) }
 
 /* Map TD_SYSINFO fields into 'struct tdx_sys_info': */
 static const struct field_mapping mappings[] = {
-- 
2.25.1


