Return-Path: <kvm+bounces-63317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A77B2C621E2
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:40:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6F37C4E2F15
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C9CA262808;
	Mon, 17 Nov 2025 02:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O7Fw7DL9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07E5274641;
	Mon, 17 Nov 2025 02:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763347138; cv=none; b=i1ZTjUnm7IQphbaNSe41wOHKcYRbF5ElmnEcXXg8DC9uQUSy6KfBE2wz/MBT/YifsWtY8jXYXG0+90jmrc14u5RlQXpbjgpAbWSq0nPeob4pmE2s8XATsTE4x6jIj2neVDyi5RVNa6UDnJgpzKF8Qxz6jwXpeSHWIrMtAMI3rGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763347138; c=relaxed/simple;
	bh=73+nRWUM+Rgye+xOs+zVweVrhH13DDlroeavR86QP7Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XmO8VL7+JUQsYpfjR/jXNF/GveEFkg1FpqU7o+x8K4ndO20EZFtem0f4Ah3lZ59TBue54t9rEhjg3MRL07+LMg823LnpzET8xDfniGNho2lZZ7Tccts3S185B79C5FW+hw1V/5JWe7kVctuvClGFGm04DoqMq8TC4h2OYyY2pN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O7Fw7DL9; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347137; x=1794883137;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=73+nRWUM+Rgye+xOs+zVweVrhH13DDlroeavR86QP7Q=;
  b=O7Fw7DL9ohLPO1b2WubG8DDyx3UY1Fs7r52Mv6lz2fr5vOHFMi7x+WX8
   kR/wcNE/0uFP6L4Dk9d0RXjGp2J1e8njBRH9HkC8jWLaGE0E6tBYHzyNT
   XkOgBNFTGrHp+WPA6iIMrRYPvcwjcbmvdDUrf0wyT8XhUVAj/40Hq/CYC
   bka8VfqL21GNt6YQxUFj+lUR9v5YOWmZ3O4kvyvCj6J932pqZevDy9XSa
   jqlW4FJLflGODgrpzRLTWV0W2nIHKQ2qfg5m8NSE8+hpVCDB5k4tLVg/R
   8VFYODO5SZOiOzyAaPBn3Xtu13sFOGJgzBqnMdAWJmiJ0t74cbb+0j3zD
   Q==;
X-CSE-ConnectionGUID: 0A3jxlGfS1OtR3NS2lt6lQ==
X-CSE-MsgGUID: r6N98/4rQRW2GlD5ZlX9+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82729582"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="82729582"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:38:57 -0800
X-CSE-ConnectionGUID: YxbvgQb0TKSBpDiEBZQT/Q==
X-CSE-MsgGUID: PcHJ8OgMTaaCpGrk6hDomw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="227658387"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Nov 2025 18:38:53 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org
Cc: chao.gao@intel.com,
	dave.jiang@intel.com,
	baolu.lu@linux.intel.com,
	yilun.xu@linux.intel.com,
	yilun.xu@intel.com,
	zhenzhong.duan@intel.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	dan.j.williams@intel.com,
	kas@kernel.org,
	x86@kernel.org
Subject: [PATCH v1 17/26] x86/virt/tdx: Add SEAMCALL wrappers for trusted IOMMU setup and clear
Date: Mon, 17 Nov 2025 10:23:01 +0800
Message-Id: <20251117022311.2443900-18-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

Add SEAMCALLs to setup/clear trusted IOMMU for TDX Connect.

Enable TEE I/O support for a target device requires to setup trusted IOMMU
for the related IOMMU device first, even only for enabling physical secure
links like SPDM/IDE.

TDH.IOMMU.SETUP takes the register base address (VTBAR) to position an
IOMMU device, and outputs an IOMMU_ID as the trusted IOMMU identifier.
TDH.IOMMU.CLEAR takes the IOMMU_ID to reverse the setup.

More information see Intel TDX Connect ABI Specification [1]
Section 3.2 TDX Connect Host-Side (SEAMCALL) Interface Functions.

[1]: https://cdrdv2.intel.com/v1/dl/getContent/858625

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Co-developed-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c | 32 ++++++++++++++++++++++++++++++--
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 4078fc497779..efc4200b9931 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -225,6 +225,8 @@ u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *ext_err1, u6
 u64 tdh_phymem_cache_wb(bool resume);
 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
 u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
+u64 tdh_iommu_setup(u64 vtbar, struct tdx_page_array *iommu_mt, u64 *iommu_id);
+u64 tdh_iommu_clear(u64 iommu_id, struct tdx_page_array *iommu_mt);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_enable_ext(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index b84678165d00..7c653604271b 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -48,6 +48,8 @@
 #define TDH_SYS_CONFIG			45
 #define TDH_EXT_INIT			60
 #define TDH_EXT_MEM_ADD			61
+#define TDH_IOMMU_SETUP			128
+#define TDH_IOMMU_CLEAR			129
 
 /*
  * SEAMCALL leaf:
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 7bc2c900a8a8..fe3b43c86314 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2003,8 +2003,8 @@ static inline u64 tdx_tdr_pa(struct tdx_td *td)
 	return page_to_phys(td->tdr_page);
 }
 
-static u64 __maybe_unused __seamcall_ir_resched(sc_func_t sc_func, u64 fn,
-						struct tdx_module_args *args)
+static u64 __seamcall_ir_resched(sc_func_t sc_func, u64 fn,
+				 struct tdx_module_args *args)
 {
 	struct tdx_module_args _args;
 	u64 r;
@@ -2397,3 +2397,31 @@ void tdx_cpu_flush_cache_for_kexec(void)
 }
 EXPORT_SYMBOL_GPL(tdx_cpu_flush_cache_for_kexec);
 #endif
+
+u64 tdh_iommu_setup(u64 vtbar, struct tdx_page_array *iommu_mt, u64 *iommu_id)
+{
+	struct tdx_module_args args = {
+		.rcx = vtbar,
+		.rdx = page_to_phys(iommu_mt->root),
+	};
+	u64 r;
+
+	tdx_clflush_page_array(iommu_mt);
+
+	r = seamcall_ret_ir_resched(TDH_IOMMU_SETUP, &args);
+
+	*iommu_id = args.rcx;
+	return r;
+}
+EXPORT_SYMBOL_FOR_MODULES(tdh_iommu_setup, "tdx-host");
+
+u64 tdh_iommu_clear(u64 iommu_id, struct tdx_page_array *iommu_mt)
+{
+	struct tdx_module_args args = {
+		.rcx = iommu_id,
+		.rdx = page_to_phys(iommu_mt->root),
+	};
+
+	return seamcall_ret_ir_resched(TDH_IOMMU_CLEAR, &args);
+}
+EXPORT_SYMBOL_FOR_MODULES(tdh_iommu_clear, "tdx-host");
-- 
2.25.1


