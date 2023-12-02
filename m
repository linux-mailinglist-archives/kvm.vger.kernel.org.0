Return-Path: <kvm+bounces-3245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8689801BFC
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:58:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 631BD1F21178
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 09:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E80815496;
	Sat,  2 Dec 2023 09:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QNgizjN+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1933D48;
	Sat,  2 Dec 2023 01:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701511127; x=1733047127;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=9hhVkoMnDMz5pGlI3lvmW362r0q8LSuE7t4ADMue25I=;
  b=QNgizjN+13FOvANliVFwV8k6h+zGqT7x0n8BKu5LWYxPTOuGTbt+KP+k
   X8pbvr14EsJrFHXcPOB+W/giYeGEAwVg89NXE61TU9tLldWNLM8f0DioU
   g+KEKK5eCkbv56ngVkfBY0DJR2jPeTgOoMY2MfK8F+sbj5Y+SkuSTKZWi
   UgmSq3qdc6EtXEOtUFHOHmSg5sVT/LWWgnpXlScsqz3DVHH47ooJtl8zG
   Rg/nedfxtMw5FZu2E6m7MD2xCWV26qTrQBEylrIC/9PJdDHrBmZkHGa7Q
   ixNNBO3nM2ETttdu9C8HD4dqrEsWxV1kIYDtPpPHZK8on7WEJ97SWjCuc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="393322340"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="393322340"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:58:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="804337647"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="804337647"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:58:43 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	dwmw2@infradead.org,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 29/42] KVM: x86/mmu: remove param "vcpu" from kvm_mmu_get_tdp_level()
Date: Sat,  2 Dec 2023 17:29:48 +0800
Message-Id: <20231202092948.15224-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

kvm_mmu_get_tdp_level() only requires param "vcpu" for cpuid_maxphyaddr().
So, pass in the value of cpuid_maxphyaddr() directly to avoid param "vcpu".

This is a preparation patch for later KVM MMU to export TDP.

No functional changes expected.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 73437c1b1943e..abdf49b5cdd79 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5186,14 +5186,14 @@ void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
 	reset_guest_paging_metadata(vcpu, mmu);
 }
 
-static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
+static inline int kvm_mmu_get_tdp_level(int maxphyaddr)
 {
 	/* tdp_root_level is architecture forced level, use it if nonzero */
 	if (tdp_root_level)
 		return tdp_root_level;
 
 	/* Use 5-level TDP if and only if it's useful/necessary. */
-	if (max_tdp_level == 5 && cpuid_maxphyaddr(vcpu) <= 48)
+	if (max_tdp_level == 5 && maxphyaddr <= 48)
 		return 4;
 
 	return max_tdp_level;
@@ -5211,7 +5211,7 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	role.smm = cpu_role.base.smm;
 	role.guest_mode = cpu_role.base.guest_mode;
 	role.ad_disabled = !kvm_ad_enabled();
-	role.level = kvm_mmu_get_tdp_level(vcpu);
+	role.level = kvm_mmu_get_tdp_level(cpuid_maxphyaddr(vcpu));
 	role.direct = true;
 	role.has_4_byte_gpte = false;
 
@@ -5310,7 +5310,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 	WARN_ON_ONCE(cpu_role.base.direct);
 
 	root_role = cpu_role.base;
-	root_role.level = kvm_mmu_get_tdp_level(vcpu);
+	root_role.level = kvm_mmu_get_tdp_level(cpuid_maxphyaddr(vcpu));
 	if (root_role.level == PT64_ROOT_5LEVEL &&
 	    cpu_role.base.level == PT64_ROOT_4LEVEL)
 		root_role.passthrough = 1;
@@ -6012,7 +6012,8 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 	 * other exception is for shadowing L1's 32-bit or PAE NPT on 64-bit
 	 * KVM; that horror is handled on-demand by mmu_alloc_special_roots().
 	 */
-	if (tdp_enabled && kvm_mmu_get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
+	if (tdp_enabled &&
+	    kvm_mmu_get_tdp_level(cpuid_maxphyaddr(vcpu)) > PT32E_ROOT_LEVEL)
 		return 0;
 
 	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_DMA32);
-- 
2.17.1


