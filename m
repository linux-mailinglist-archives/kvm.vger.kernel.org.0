Return-Path: <kvm+bounces-9657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A461C866C83
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:38:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C38C1F2176D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7A6D5A7BC;
	Mon, 26 Feb 2024 08:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U2Ckyu5G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B2E5823B;
	Mon, 26 Feb 2024 08:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936082; cv=none; b=Q3ECGF1qNiyBdqTZRZ8XL/eMMtmzfrR7gtUKJeUdaa+M5D1wWB9+mUEezw8mTxbycMD/xeJi6+S4+JpzCJJKyjMl4/qmxwb2p7vEDqFrUe2m4nnoV4T8p1CjIQMA6DUlrmB50JcaSsnNVICKiaTCul89/im0lQ6j4lvQL/q/t+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936082; c=relaxed/simple;
	bh=T4VOISizeXwQxFildPjoTKkuyQeaeUMNwtucQCo8zKs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dORc3HGsvNYUlieNYgotMfZrMjXhA9w66M+xcReGlPzbUrm/csDQlSkyx+u9stqCQI/dp8aMuQaPshlK2l3aMEwQnI2huKiMDDfAMavIyhk85jHGNfH0fO9EN+wZboIkAMpq1W//mVnNmiYDvHWyEXcmDy85gmZHF/bt/IJ2Uis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U2Ckyu5G; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936080; x=1740472080;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T4VOISizeXwQxFildPjoTKkuyQeaeUMNwtucQCo8zKs=;
  b=U2Ckyu5GY2k4Z826Sc2Di6nwSqajyLLpHUL8tkcoIO0sfMKlveZCRb4t
   zHuKT1/fHWxbwyytxdcJp54rUp6I4tApOJUhfnSMM3FqnJCmM4g6kw0fH
   plTq2Brq79QrFr/SBBs30/KrxYqqsZ7KwkYyNj0VR0Lr8mTi7FzAwqYZq
   pnngbTDe1i9FshY55oWX7z8q+4NpFWg17t9LhEnOH15DBnCmlnduFNBwY
   W0MlVY4VwY1hNUnLPAb6rrPDMWlsVbnml1Ek8EWts8xj8TENJrMY5WndC
   f/8kg09TkfT3izG7GCa8BVVS62MNe0ELPR7dQdLCPGrIO87+WsK/n9xfw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155287"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155287"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615573"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:58 -0800
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
Subject: [PATCH v19 033/130] KVM: TDX: Add helper function to read TDX metadata in array
Date: Mon, 26 Feb 2024 00:25:35 -0800
Message-Id: <72b528863d14b322df553efa285ef4637ee67581.1708933498.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

To read meta data in series, use table.
Instead of metadata_read(fid0, &data0); metadata_read(...); ...
table = { {fid0, &data0}, ...}; metadata-read(tables).
TODO: Once the TDX host code introduces its framework to read TDX metadata,
drop this patch and convert the code that uses this.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v18:
- newly added
---
 arch/x86/kvm/vmx/tdx.c | 45 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index cde971122c1e..dce21f675155 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -6,6 +6,7 @@
 #include "capabilities.h"
 #include "x86_ops.h"
 #include "x86.h"
+#include "tdx_arch.h"
 #include "tdx.h"
 
 #undef pr_fmt
@@ -39,6 +40,50 @@ static void __used tdx_guest_keyid_free(int keyid)
 	ida_free(&tdx_guest_keyid_pool, keyid);
 }
 
+#define TDX_MD_MAP(_fid, _ptr)			\
+	{ .fid = MD_FIELD_ID_##_fid,		\
+	  .ptr = (_ptr), }
+
+struct tdx_md_map {
+	u64 fid;
+	void *ptr;
+};
+
+static size_t tdx_md_element_size(u64 fid)
+{
+	switch (TDX_MD_ELEMENT_SIZE_CODE(fid)) {
+	case TDX_MD_ELEMENT_SIZE_8BITS:
+		return 1;
+	case TDX_MD_ELEMENT_SIZE_16BITS:
+		return 2;
+	case TDX_MD_ELEMENT_SIZE_32BITS:
+		return 4;
+	case TDX_MD_ELEMENT_SIZE_64BITS:
+		return 8;
+	default:
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+}
+
+static int __used tdx_md_read(struct tdx_md_map *maps, int nr_maps)
+{
+	struct tdx_md_map *m;
+	int ret, i;
+	u64 tmp;
+
+	for (i = 0; i < nr_maps; i++) {
+		m = &maps[i];
+		ret = tdx_sys_metadata_field_read(m->fid, &tmp);
+		if (ret)
+			return ret;
+
+		memcpy(m->ptr, &tmp, tdx_md_element_size(m->fid));
+	}
+
+	return 0;
+}
+
 static int __init tdx_module_setup(void)
 {
 	int ret;
-- 
2.25.1


