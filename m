Return-Path: <kvm+bounces-9756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43BB2866DC8
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:12:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4CF41F21ED8
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:12:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AB48132C1D;
	Mon, 26 Feb 2024 08:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WajuvFCv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC445131E51;
	Mon, 26 Feb 2024 08:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936175; cv=none; b=akmfCz3wh3Ej8NN3FSVWZobWTh01UYiIt4r2oIhNZu72qdXdhjVLIM4SnqwZyE4pU0AVtUiI+AGsn2abbQA/zfNaR8fJWcL10L9lscV+vrfwnIFM0u4sd52OPSYA/SfMcubCpcEHeLH5C/idIIGUM93GKKj5SLnxxhQ2hoAMeCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936175; c=relaxed/simple;
	bh=387eYe1pemVIbH7FAN1xXCSFRyhOU3BS2G0RgG8bpFg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CXVCwzmpwyzSuV30d4PBSez/kuC+GX6c9HGjWS1GiWUt0s/slffC5Lz3t3wFgl2EcWLBkFOHODqMP/5QLJNDnslJvZY+2s/XhUHkKtXUS8beWJg5id4gPBjl9peOTkd60+yt+9DxaQXDMUpwqkaf39XPbFpurUudO4sitiLTuIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WajuvFCv; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936174; x=1740472174;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=387eYe1pemVIbH7FAN1xXCSFRyhOU3BS2G0RgG8bpFg=;
  b=WajuvFCv5NyIEkw5RJmCQCg1UhNQWNv27+MePc79bJ+yOfDOaDSYaUaY
   Y/bYOo6fA0JnQO3hzUQyudFuheCDYLgeWw6btjrvJhbP3pftGfAPCMQnJ
   Ym/xJZF1Pl4XalJZpn5lh3O8h1glyo7QJNX6yJ/TPYQIXXgFLgfsmXF6i
   MDJ4RX5rirpOl/9QQiKn+VLvkyu1WOWUPY5BpVP/fOqLK1oWu6nh2jcB3
   +mxdtGWP0YOQxyFJniH+MpDaw2Sf8JhJEmXC2HBGAb62P9FIEsbsyxHJN
   JmWaLwLQse6CMAVUPSllUr1iAI1BqeUE6ibd/ggbnd9uVb/zEPaAebwGO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="20751501"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="20751501"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6735287"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:31 -0800
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
Subject: [PATCH v8 02/14] KVM: TDX: Flush cache based on page size before TDX SEAMCALL
Date: Mon, 26 Feb 2024 00:29:16 -0800
Message-Id: <544c18765a2778afc4d3964629f116985554d1ee.1708933624.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933624.git.isaku.yamahata@intel.com>
References: <cover.1708933624.git.isaku.yamahata@intel.com>
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
index d27f281152cb..3af124711e98 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -6,6 +6,7 @@
 
 #include <linux/compiler.h>
 
+#include <asm/pgtable_types.h>
 #include <asm/cacheflush.h>
 #include <asm/asm.h>
 #include <asm/kvm_host.h>
@@ -50,6 +51,11 @@ static inline int pg_level_to_tdx_sept_level(enum pg_level level)
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
@@ -87,7 +93,7 @@ static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 		.rdx = tdr,
 	};
 
-	clflush_cache_range(__va(addr), PAGE_SIZE);
+	tdx_clflush_page(addr, PG_LEVEL_4K);
 	return tdx_seamcall(TDH_MNG_ADDCX, &in, NULL);
 }
 
@@ -101,7 +107,7 @@ static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source
 		.r9 = source,
 	};
 
-	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	tdx_clflush_page(hpa, PG_LEVEL_4K);
 	return tdx_seamcall_sept(TDH_MEM_PAGE_ADD, &in, out);
 }
 
@@ -114,7 +120,7 @@ static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
 		.r8 = page,
 	};
 
-	clflush_cache_range(__va(page), PAGE_SIZE);
+	tdx_clflush_page(page, PG_LEVEL_4K);
 	return tdx_seamcall_sept(TDH_MEM_SEPT_ADD, &in, out);
 }
 
@@ -147,7 +153,7 @@ static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
 		.rdx = tdvpr,
 	};
 
-	clflush_cache_range(__va(addr), PAGE_SIZE);
+	tdx_clflush_page(addr, PG_LEVEL_4K);
 	return tdx_seamcall(TDH_VP_ADDCX, &in, NULL);
 }
 
@@ -160,7 +166,7 @@ static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 		.r8 = hpa,
 	};
 
-	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	tdx_clflush_page(hpa, PG_LEVEL_4K);
 	return tdx_seamcall_sept(TDH_MEM_PAGE_RELOCATE, &in, out);
 }
 
@@ -173,7 +179,7 @@ static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 		.r8 = hpa,
 	};
 
-	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	tdx_clflush_page(hpa, PG_LEVEL_4K);
 	return tdx_seamcall_sept(TDH_MEM_PAGE_AUG, &in, out);
 }
 
@@ -204,7 +210,7 @@ static inline u64 tdh_mng_create(hpa_t tdr, int hkid)
 		.rdx = hkid,
 	};
 
-	clflush_cache_range(__va(tdr), PAGE_SIZE);
+	tdx_clflush_page(tdr, PG_LEVEL_4K);
 	return tdx_seamcall(TDH_MNG_CREATE, &in, NULL);
 }
 
@@ -215,7 +221,7 @@ static inline u64 tdh_vp_create(hpa_t tdr, hpa_t tdvpr)
 		.rdx = tdr,
 	};
 
-	clflush_cache_range(__va(tdvpr), PAGE_SIZE);
+	tdx_clflush_page(tdvpr, PG_LEVEL_4K);
 	return tdx_seamcall(TDH_VP_CREATE, &in, NULL);
 }
 
-- 
2.25.1


