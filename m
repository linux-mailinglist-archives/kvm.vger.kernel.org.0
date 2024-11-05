Return-Path: <kvm+bounces-30685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16BAF9BC5B9
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:41:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCEAF1F21059
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C5AD1FF5E3;
	Tue,  5 Nov 2024 06:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kaLww7oC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EC81FCF41
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788802; cv=none; b=W60YtSe1nl9+zBzNYsQVR9LHOLClymGqeekVMWeJ2U5pyB8GvGCzU42W4QZlNVhrcQW8NOVcr5LEyqh0y7Zvc6AEowF+/3e+whb3xNMznfHMCFYxoFiNn0CB9nWFpreQRpDdPbNZIrIoOFo5LA2Fl6L6h0Oi/vOTmGeqmo0vqj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788802; c=relaxed/simple;
	bh=+RyN2ozpNF9/qWmSSJyynxhc2IsEJ+Gu8thAMTAlGko=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gx5maBoL9EhMy43hA12Ykj+uQcz7Uf03n7+MyhoUYMeVUZCWGNclM6s3L3/bMVgAY803YCtcgA26XpQBBQDpVR/Xk9C6zyJT+IRkrxudnDmp0uKakekGDti3mdzO25MXDnQEZTxHEPoYoJ46GDCXgvgNcSwqUgcoNYYX8gK8XsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kaLww7oC; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788801; x=1762324801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+RyN2ozpNF9/qWmSSJyynxhc2IsEJ+Gu8thAMTAlGko=;
  b=kaLww7oCtsg03d03Wp5U+tIZ3V+opuu9Mwg/MwhrBqAopjWsIwQqowIu
   Pb9UsknU17peyW2nk+mjVSrbgBJ00GJlSzcRaVazBhfxNx9cxmqOp0h2h
   VorYgcFKG6WLA++OBnTJ9G7TyiqgZN2MMoKUMlUiaZh5kLe3X4QZ7ECuq
   RwmeGSefmY/+LfQwLwxdAXRclXkIwkGtBGao68tJ8KBKT27ci7jB2ImC7
   m0kgCf9NPSmp6mlonDFePplOQNg8/8dNIbJFvF5zZd5v++3GqJwgmc8ji
   w880bI4BgxE4/omHDzpDqeJZJKlcXvy5wcY0a1R08EBNETBAXmg9gY5be
   w==;
X-CSE-ConnectionGUID: Br5UUMXoTYKynU+8zphzmA==
X-CSE-MsgGUID: RywWLtQHTjS92dxeJbQGWw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689874"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689874"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:40:01 -0800
X-CSE-ConnectionGUID: 5jqpsLxmSO+hY5dQHtlrcg==
X-CSE-MsgGUID: fhbU8dw3QlKkdGhUX6WkBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989877"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:39:57 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 51/60] i386/tdx: Mask off CPUID bits by unsupported XFAM
Date: Tue,  5 Nov 2024 01:23:59 -0500
Message-Id: <20241105062408.3533704-52-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mask off the CPUID bits as unsupported if its matched XFAM bit is
not supported. Otherwise, it might fail the check in setup_td_xfam() as
unsupported XFAM being requested.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 5ac5f93907ca..e7e0f073dfc9 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -24,6 +24,7 @@
 #include <linux/kvm_para.h>
 
 #include "cpu.h"
+#include "cpu-internal.h"
 #include "host-cpu.h"
 #include "hw/i386/e820_memory_layout.h"
 #include "hw/i386/x86.h"
@@ -585,6 +586,42 @@ static void tdx_mask_cpuid_by_attrs(uint32_t feature, uint32_t index,
     }
 }
 
+static void tdx_mask_cpuid_by_xfam(uint32_t feature, uint32_t index,
+                                          int reg, uint32_t *value)
+{
+    const FeatureWordInfo *f;
+    const ExtSaveArea *esa;
+    uint64_t unavail = 0;
+    int i;
+
+    assert(tdx_caps);
+
+    for (i = 0; i < ARRAY_SIZE(x86_ext_save_areas); i++) {
+        if ((1ULL << i) & tdx_caps->supported_xfam) {
+            continue;
+        }
+
+        if (!((1ULL << i) & CPUID_XSTATE_MASK)) {
+            continue;
+        }
+
+        esa = &x86_ext_save_areas[i];
+        f = &feature_word_info[esa->feature];
+        assert(f->type == CPUID_FEATURE_WORD);
+        if (f->cpuid.eax != feature ||
+            (f->cpuid.needs_ecx && f->cpuid.ecx != index) ||
+            f->cpuid.reg != reg) {
+            continue;
+        }
+
+        unavail |= esa->bits;
+    }
+
+    if (unavail) {
+        *value &= ~unavail;
+    }
+}
+
 static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
                                           uint32_t feature, uint32_t index,
                                           int reg, uint32_t value)
@@ -619,6 +656,7 @@ static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
     }
 
     tdx_mask_cpuid_by_attrs(feature, index, reg, &value);
+    tdx_mask_cpuid_by_xfam(feature, index, reg, &value);
 
     e = cpuid_find_entry(&tdx_fixed0_bits.cpuid, feature, index);
     if (e) {
-- 
2.34.1


