Return-Path: <kvm+bounces-6591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABD6883792A
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:30:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24D27B25F2A
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 401C358AA8;
	Mon, 22 Jan 2024 23:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hY5mcFvT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CCD57316;
	Mon, 22 Jan 2024 23:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967708; cv=none; b=E1L0O4SYfNcaJ3tXc88+mgWvB67snUulhtZDr9oBhOplFg59qm1tpzbh97ylTFENVpHcoT7Yl6BF0GGKgxEnsIRHUeOAOV7Zwx2OuKzFTc3E8Ji11ZiIj5dwQjWK1EPXbYfAoNGLXrpTdcN7CPnXr2hvaGz4IDyiQk0gzUhYVZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967708; c=relaxed/simple;
	bh=ZF11mj6dOid+ewMs/d+5wakaEsG23KEAuAapce9+K/k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nTzrxzS32I8nMI91cKiVFDAH4TBxJ07dgWDkgZs56I6SxU9mzMZa3ZXqFWNgcW0OlNfP0aATDcq4+c4OZ459fhuLI7isr1hXtpL+w192rS6zNwo7/H1eC02uRPFhFyQXwEvgKpXKAaEUJ8yRL8iUkln6ubbADt4jcxocngsWIts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hY5mcFvT; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967707; x=1737503707;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZF11mj6dOid+ewMs/d+5wakaEsG23KEAuAapce9+K/k=;
  b=hY5mcFvTgVwcJiNb8lKNsk8o289uakYuexavwyOpk/U/EXTLJ3+xyOlA
   k3wH7syqTipHSSGmzXe0HMF0wewJvwdoYD08ViMqOYxDqFhZvf3Scznxd
   ITnEN6AUfoqFzuQTehTfp3+jGN8BebeQG0BOey14yPVkebkX4EeofVEPL
   1pQWU0F9LAoO0QRm1h1V1uBDOK1xMzLZBcnFfqUtt8tWrQGT9Tb61uTbZ
   tBjPW2Q17lq5y5oA42lR4DkKpi7Mtk7j3JJJYfrEO3cTS/cVZKXNeim9B
   tsgON9Ijd7XstkLZYQ+CJO9E+rAWroRhd1XPjI0DSxio84cDmtE78fX6h
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1243775"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1243775"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="819888459"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="819888459"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:05 -0800
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
Subject: [PATCH v18 019/121] KVM: TDX: Add helper function to read TDX metadata in array
Date: Mon, 22 Jan 2024 15:52:55 -0800
Message-Id: <b058a756a2679e7c570836a0fb6cef6cfd0a7663.1705965634.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
index ee9d6a687d93..1608bdf2381d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -6,6 +6,7 @@
 #include "capabilities.h"
 #include "x86_ops.h"
 #include "x86.h"
+#include "tdx_arch.h"
 #include "tdx.h"
 
 #undef pr_fmt
@@ -40,6 +41,50 @@ static void __used tdx_guest_keyid_free(int keyid)
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
+int tdx_md_read(struct tdx_md_map *maps, int nr_maps)
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


