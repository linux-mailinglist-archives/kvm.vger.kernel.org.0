Return-Path: <kvm+bounces-6697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA3BA837B8B
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 02:02:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7291928B333
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF1E14DB6A;
	Tue, 23 Jan 2024 00:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LWc5Xdor"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F1614D446;
	Tue, 23 Jan 2024 00:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969360; cv=none; b=YHzy4fRC1dbZBUszKlgglCCcraSXCwE1TQQd+CoJCShUnijRJKPSb/k1UHckfr7ptN7XaY56eJKMdPBOIfBv2Lqf9vPXvab2FJq581Q5CUtVH8dx+a3LVnCTGjYP6CvXZwFXyIO/CU1W53CLwk6bxhnWbzFmjcinoj6pG85CfYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969360; c=relaxed/simple;
	bh=OAbS5X7Ec6oK3BAEUtYbpsRqvWhxi59qTw2XYhyFAZg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z+/Rg+EaWT09U4y8UBWdepO1bL0nKV5CaWNSclmJDFvQdR5MHMoC24bb7/QKcbRkXKsoifdGIR1BNkZv27IWzk21YGvnmsvmBQS5ILkt6Odf6iiAfP/YA5qh8nQ6NQYiDKmnuW9crDSsGf+jnWgT7Ug//MYiR9bbt10Phwz44qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LWc5Xdor; arc=none smtp.client-ip=134.134.136.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705969358; x=1737505358;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OAbS5X7Ec6oK3BAEUtYbpsRqvWhxi59qTw2XYhyFAZg=;
  b=LWc5XdorqlsCD9iCENUkjUrX7B5h1bHW7JgysE7Kv7Ts6P+CSyt00zts
   5nju/VdPgmHG8dW3NL8Pljywd6wPmgPGSqMcf9FuvrkuCxTIIZnZGFzV2
   iHaLVJ4r6IjwbxqgMeRWe0bcWW38vWgOBJtq+CgZw77xLQGcF6Zr0cUa+
   HW1D9YFxV8Y4i54oeXbWXEZtOLOBKvNQGDl1RJ+T0IW7q0g1tH+8uYdNU
   SXxHQP7zwHH91Z+yIlz8SwXKHNE5ntH3r+mnX27HWd5b6YCTvLVgv8qdF
   lnrVDGc4XiudZSqxfyxp74F+1R+4KGbNjVyDLKaEQXdrPmzKEocBH6YEt
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="405125637"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="405125637"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27825619"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:36 -0800
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
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH v7 01/13] KVM: TDX: Flush cache based on page size before TDX SEAMCALL
Date: Mon, 22 Jan 2024 16:22:16 -0800
Message-Id: <0fc03e6439409b54e0477128c33e11438a46253f.1705965958.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965958.git.isaku.yamahata@intel.com>
References: <cover.1705965958.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiaoyao Li <xiaoyao.li@intel.com>

tdh_mem_page_aug() will support 2MB large page in the near future.  Cache
flush also needs to be 2MB instead of 4KB in such cases.  Introduce a
helper function to flush cache with page size info in preparation for large
pages.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
v6:
- catch up tdx_seamcall() change
---
 arch/x86/kvm/vmx/tdx_ops.h | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 3513d5df10ee..2afd927eaa45 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -6,6 +6,7 @@
 
 #include <linux/compiler.h>
 
+#include <asm/pgtable_types.h>
 #include <asm/archrandom.h>
 #include <asm/cacheflush.h>
 #include <asm/asm.h>
@@ -58,6 +59,11 @@ static inline int pg_level_to_tdx_sept_level(enum pg_level level)
 	return level - 1;
 }
 
+static inline void tdx_clflush_page(hpa_t addr, enum pg_level level)
+{
+	clflush_cache_range(__va(addr), KVM_HPAGE_SIZE(level));
+}
+
 /*
  * TDX module acquires its internal lock for resources.  It doesn't spin to get
  * locks because of its restrictions of allowed execution time.  Instead, it
@@ -95,7 +101,7 @@ static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 		.rdx = tdr,
 	};
 
-	clflush_cache_range(__va(addr), PAGE_SIZE);
+	tdx_clflush_page(addr, PG_LEVEL_4K);
 	return tdx_seamcall(TDH_MNG_ADDCX, &in, NULL);
 }
 
@@ -109,7 +115,7 @@ static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source
 		.r9 = source,
 	};
 
-	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	tdx_clflush_page(hpa, PG_LEVEL_4K);
 	return tdx_seamcall_sept(TDH_MEM_PAGE_ADD, &in, out);
 }
 
@@ -122,7 +128,7 @@ static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
 		.r8 = page,
 	};
 
-	clflush_cache_range(__va(page), PAGE_SIZE);
+	tdx_clflush_page(page, PG_LEVEL_4K);
 	return tdx_seamcall_sept(TDH_MEM_SEPT_ADD, &in, out);
 }
 
@@ -155,7 +161,7 @@ static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
 		.rdx = tdvpr,
 	};
 
-	clflush_cache_range(__va(addr), PAGE_SIZE);
+	tdx_clflush_page(addr, PG_LEVEL_4K);
 	return tdx_seamcall(TDH_VP_ADDCX, &in, NULL);
 }
 
@@ -168,7 +174,7 @@ static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 		.r8 = hpa,
 	};
 
-	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	tdx_clflush_page(hpa, PG_LEVEL_4K);
 	return tdx_seamcall_sept(TDH_MEM_PAGE_RELOCATE, &in, out);
 }
 
@@ -181,7 +187,7 @@ static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 		.r8 = hpa,
 	};
 
-	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	tdx_clflush_page(hpa, PG_LEVEL_4K);
 	return tdx_seamcall_sept(TDH_MEM_PAGE_AUG, &in, out);
 }
 
@@ -212,7 +218,7 @@ static inline u64 tdh_mng_create(hpa_t tdr, int hkid)
 		.rdx = hkid,
 	};
 
-	clflush_cache_range(__va(tdr), PAGE_SIZE);
+	tdx_clflush_page(tdr, PG_LEVEL_4K);
 	return tdx_seamcall(TDH_MNG_CREATE, &in, NULL);
 }
 
@@ -223,7 +229,7 @@ static inline u64 tdh_vp_create(hpa_t tdr, hpa_t tdvpr)
 		.rdx = tdr,
 	};
 
-	clflush_cache_range(__va(tdvpr), PAGE_SIZE);
+	tdx_clflush_page(tdvpr, PG_LEVEL_4K);
 	return tdx_seamcall(TDH_VP_CREATE, &in, NULL);
 }
 
-- 
2.25.1


