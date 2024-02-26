Return-Path: <kvm+bounces-9627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D401866C34
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:29:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65F82B23D73
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 643EC2263A;
	Mon, 26 Feb 2024 08:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FSWBBbRM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FA21EEEA;
	Mon, 26 Feb 2024 08:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936059; cv=none; b=RnY0MUTQ3ByxnOodU7zpqQgf2QiRp7QOEPudp1/oZw6J7nsIzwPRtz8vUOvBxCUT2UO0xQW2ZgAKNaAm1lN5bAwZSPTWDe4TmlrNnVRG7uBeuX+prxGbqz/+dODUOihq7r9LmPhD8wyubrudEn1gvWkEsdcL0lHLdLNlCbn9upo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936059; c=relaxed/simple;
	bh=CebvYlBsSGTBw3oWiiDipBdbdj7zNc7xmDvoSKzO9SY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JS9FcnuUvGyRZfwsPeXetmgvmiLlZga9L7jB8Cn6XIjuSQR1Kktro874CUiURDTbWSVvJnIe0prWENNiOT4KcUX3b3HiRjCnsUwsNUEblV4KT7xSmStMRpMkk9RrRTcZmT3q7sfjlwF07EPeJGbxqLhyArTaaSeTxATgWpwLRwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FSWBBbRM; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936058; x=1740472058;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CebvYlBsSGTBw3oWiiDipBdbdj7zNc7xmDvoSKzO9SY=;
  b=FSWBBbRMLitF5IqDCT7dvd9kY8U3cOk5mSm+KlP/+IBlD5S5/WA4Ufq2
   7IoeQmbplalzOzAGD9DNgaAIlWiEpzpazXmojkSyIOFrHvhPZq8Gb9cdB
   mf+cC7s3WUb5o5fKvAubsmFOodvkajGblTDp0+ylfnLGKKVj6SWH0z5KI
   BH0CJyx0FvCA01KdNqxe3a0Z6/4Wa3kUeACww5FiKmP92slxUE1M6cqog
   vN5sWFWMMjn+QSvytCTWFgWsjBG3RlvSO/Vbs8h2jBWesARNSR4cF0iOF
   HDpcYQGLKmKAx5rNgsdy+kriIEByvSmYNQfs9n+bbaI5Z052JrGHTPhy6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3340707"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3340707"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="7020066"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:36 -0800
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
	tina.zhang@intel.com
Subject: [PATCH v19 004/130] x86/virt/tdx: Support global metadata read for all element sizes
Date: Mon, 26 Feb 2024 00:25:06 -0800
Message-Id: <db0a8b2fb7138021fed7d740c84bd663025f4451.1708933498.git.isaku.yamahata@intel.com>
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
module initialization.  All these fields are 16-bits, and the kernel
only supports reading 16-bits fields.

KVM will need to read a bunch of non-TDMR related metadata to create and
run TDX guests.  It's essential to provide a generic metadata read
infrastructure which supports reading all 8/16/32/64 bits element sizes.

Extend the metadata read to support reading all these element sizes.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 59 +++++++++++++++++++++++++------------
 arch/x86/virt/vmx/tdx/tdx.h |  2 --
 2 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index eb208da4ff63..a19adc898df6 100644
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
+static int read_sys_metadata(struct field_mapping *fields, int nr_fields,
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
2.25.1


