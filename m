Return-Path: <kvm+bounces-3246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C8BAC801BFE
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:59:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 800711F211DC
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 09:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1B2E15496;
	Sat,  2 Dec 2023 09:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O1YzupEp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998CFCC;
	Sat,  2 Dec 2023 01:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701511160; x=1733047160;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=wAzhYUH58e3QaRHxpmVeodzpQMpT0HkCfncirII7TQo=;
  b=O1YzupEpSEyeQiZfgQr5dumCrIRT7Crl2oGy5iIHdBPHtRQto/iYQd8t
   F00XLSUgnjZojfkHhq9lVGVmNkvkIMvpqhsNMXyZcYELKJ2M2ptPgC6fz
   fSQXHDVmsQiLi62rUIxdaUPDvMoNW+sfzaRHkwPh/I606wovvNBwuuTR3
   0hY3VGVOtWR2fHuxpnziPKZuA3C7hrnrQjkofme7zWRtvsvxJt0LwsTL2
   ko1kMFegXVtISNNmhL7IenEEmQHeHs6Z+NWsdHlO9kYlwoSTAk6JQrXXN
   9/nXjoYqh3FWUMnbjS7JbT2yYGtQmAQ1WSQdsv6PUV2d5pYxw7i0zJryb
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="606859"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="606859"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:59:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="18038610"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:59:15 -0800
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
Subject: [RFC PATCH 30/42] KVM: x86/mmu: remove param "vcpu" from kvm_calc_tdp_mmu_root_page_role()
Date: Sat,  2 Dec 2023 17:30:21 +0800
Message-Id: <20231202093021.15281-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

kvm_calc_tdp_mmu_root_page_role() only requires "vcpu" to get maxphyaddr
for kvm_mmu_get_tdp_level(). So, just pass in the value of maxphyaddr from
the caller to get rid of param "vcpu".

This is a preparation patch for later KVM MMU to export TDP.

No functional changes expected.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index abdf49b5cdd79..bcf17aef29119 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5200,7 +5200,7 @@ static inline int kvm_mmu_get_tdp_level(int maxphyaddr)
 }
 
 static union kvm_mmu_page_role
-kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
+kvm_calc_tdp_mmu_root_page_role(int maxphyaddr,
 				union kvm_cpu_role cpu_role)
 {
 	union kvm_mmu_page_role role = {0};
@@ -5211,7 +5211,7 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	role.smm = cpu_role.base.smm;
 	role.guest_mode = cpu_role.base.guest_mode;
 	role.ad_disabled = !kvm_ad_enabled();
-	role.level = kvm_mmu_get_tdp_level(cpuid_maxphyaddr(vcpu));
+	role.level = kvm_mmu_get_tdp_level(maxphyaddr);
 	role.direct = true;
 	role.has_4_byte_gpte = false;
 
@@ -5222,7 +5222,9 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 			     union kvm_cpu_role cpu_role)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	union kvm_mmu_page_role root_role = kvm_calc_tdp_mmu_root_page_role(vcpu, cpu_role);
+	union kvm_mmu_page_role root_role;
+
+	root_role = kvm_calc_tdp_mmu_root_page_role(cpuid_maxphyaddr(vcpu), cpu_role);
 
 	if (cpu_role.as_u64 == context->cpu_role.as_u64 &&
 	    root_role.word == context->common.root_role.word)
-- 
2.17.1


