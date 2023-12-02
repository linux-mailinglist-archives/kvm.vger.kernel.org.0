Return-Path: <kvm+bounces-3234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B4139801BE2
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:53:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4185B1F2116E
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 09:53:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 226A413AF3;
	Sat,  2 Dec 2023 09:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hoCjmwOM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA27119F;
	Sat,  2 Dec 2023 01:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701510799; x=1733046799;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=qE3X4Xn/o+H/su5ms6o1r+LMtnk1FlXs0DKcPdLLVE8=;
  b=hoCjmwOMlB3pI9t+pPyu6bdaEZLcQwe15iv9cn2brZ8I/zpPfgEA/QSx
   MXUZ66ZR/LqAY6FadBepxMoVjXDKrJSo3k9vSgOd9v2x0ne8CS/4FQ50e
   mkzlLOKjxeqZvSu9hJUHa61JUge47bYA0c7Wvf9LXHNjGBZif4/uBjMpP
   R8qDTiEv7KkLyUbhcy4He1Hffg3GNtJ7bt+A4gE3/ni7fftVkF65RM0Yp
   lQWixxLN47rgjUGLziqEjAWQDlvoFqm/ONBS5+kRHSPCECXP+nyXF3HnS
   wJk6RtIqCxBPcetFEJIFIMwzlqZfq3YoCkgMbun64I+y8dbQaLMKWmLH+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="397479511"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="397479511"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:53:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="913853413"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="913853413"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:53:15 -0800
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
Subject: [RFC PATCH 18/42] iommu/vt-d: Support of IOMMU_DOMAIN_KVM domain in Intel IOMMU
Date: Sat,  2 Dec 2023 17:24:21 +0800
Message-Id: <20231202092421.14524-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Add support of IOMMU_DOMAIN_KVM domain. Paging structures allocation/free,
page mapping and unmapping of this damain are managed by KVM rather than by
Intel IOMMU driver.

The meta data of paging structures of KVM domain is read from the
allocation "data" passed in from KVM through IOMMUFD. The format to parse
the meta data is defined in arch header "asm/kvm_exported_tdp.h".

KVM domain's gaw(guest witdh), agaw, pgd, max_add, max super page level are
all read from the paging structure meta data from KVM. Snoop and paging
structure coherency are forced to be true.

IOMMU hardware are checked against the requirement of KVM domain at domain
allocation phase and later device attachment phase (in a later patch).

CONFIG_INTEL_IOMMU_KVM is provided to turn on/off KVM domain support.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/iommu/intel/Kconfig  |   9 +++
 drivers/iommu/intel/Makefile |   1 +
 drivers/iommu/intel/iommu.c  |  18 ++++-
 drivers/iommu/intel/iommu.h  |   5 ++
 drivers/iommu/intel/kvm.c    | 128 +++++++++++++++++++++++++++++++++++
 5 files changed, 160 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iommu/intel/kvm.c

diff --git a/drivers/iommu/intel/Kconfig b/drivers/iommu/intel/Kconfig
index a4a125666293f..78078103d4280 100644
--- a/drivers/iommu/intel/Kconfig
+++ b/drivers/iommu/intel/Kconfig
@@ -108,4 +108,13 @@ config INTEL_IOMMU_PERF_EVENTS
 	  to aid performance tuning and debug. These are available on modern
 	  processors which support Intel VT-d 4.0 and later.
 
+config INTEL_IOMMU_KVM
+        bool "Support of stage 2 paging structures/mappings managed by KVM"
+        help
+          Selecting this option will enable Intel IOMMU to use paging
+          structures shared from KVM MMU as the stage 2 paging structures
+          in IOMMU hardware. The page mapping/unmapping, paging struture
+          allocation/free of this stage 2 paging structures are not managed
+          by Intel IOMMU driver, but by KVM MMU.
+
 endif # INTEL_IOMMU
diff --git a/drivers/iommu/intel/Makefile b/drivers/iommu/intel/Makefile
index 5dabf081a7793..c097bdd6ee13d 100644
--- a/drivers/iommu/intel/Makefile
+++ b/drivers/iommu/intel/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_INTEL_IOMMU_DEBUGFS) += debugfs.o
 obj-$(CONFIG_INTEL_IOMMU_SVM) += svm.o
 obj-$(CONFIG_IRQ_REMAP) += irq_remapping.o
 obj-$(CONFIG_INTEL_IOMMU_PERF_EVENTS) += perfmon.o
+obj-$(CONFIG_INTEL_IOMMU_KVM) += kvm.o
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 924006cda18c5..fcdee40f30ed1 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -375,6 +375,15 @@ static inline int domain_type_is_si(struct dmar_domain *domain)
 	return domain->domain.type == IOMMU_DOMAIN_IDENTITY;
 }
 
+static inline int domain_type_is_kvm(struct dmar_domain *domain)
+{
+#ifdef CONFIG_INTEL_IOMMU_KVM
+	return domain->domain.type == IOMMU_DOMAIN_KVM;
+#else
+	return false;
+#endif
+}
+
 static inline int domain_pfn_supported(struct dmar_domain *domain,
 				       unsigned long pfn)
 {
@@ -1735,6 +1744,9 @@ static bool first_level_by_default(unsigned int type)
 	if (intel_cap_flts_sanity() ^ intel_cap_slts_sanity())
 		return intel_cap_flts_sanity();
 
+	if (type == IOMMU_DOMAIN_KVM)
+		return false;
+
 	/* Both levels are available, decide it based on domain type */
 	return type != IOMMU_DOMAIN_UNMANAGED;
 }
@@ -1826,7 +1838,8 @@ void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
 
 static void domain_exit(struct dmar_domain *domain)
 {
-	if (domain->pgd) {
+	/* pgd of kvm domain is managed by KVM */
+	if (!domain_type_is_kvm(domain) && (domain->pgd)) {
 		LIST_HEAD(freelist);
 
 		domain_unmap(domain, 0, DOMAIN_MAX_PFN(domain->gaw), &freelist);
@@ -4892,6 +4905,9 @@ const struct iommu_ops intel_iommu_ops = {
 	.hw_info		= intel_iommu_hw_info,
 	.domain_alloc		= intel_iommu_domain_alloc,
 	.domain_alloc_user	= intel_iommu_domain_alloc_user,
+#ifdef CONFIG_INTEL_IOMMU_KVM
+	.domain_alloc_kvm	= intel_iommu_domain_alloc_kvm,
+#endif
 	.probe_device		= intel_iommu_probe_device,
 	.probe_finalize		= intel_iommu_probe_finalize,
 	.release_device		= intel_iommu_release_device,
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index c76f558ae6323..8826e9248f6ed 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1056,4 +1056,9 @@ static inline int width_to_agaw(int width)
 	return DIV_ROUND_UP(width - 30, LEVEL_STRIDE);
 }
 
+#ifdef CONFIG_INTEL_IOMMU_KVM
+struct iommu_domain *
+intel_iommu_domain_alloc_kvm(struct device *dev, u32 flags, const void *data);
+#endif
+
 #endif
diff --git a/drivers/iommu/intel/kvm.c b/drivers/iommu/intel/kvm.c
new file mode 100644
index 0000000000000..188ec90083051
--- /dev/null
+++ b/drivers/iommu/intel/kvm.c
@@ -0,0 +1,128 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/iommu.h>
+#include <asm/kvm_exported_tdp.h>
+#include "iommu.h"
+
+/**
+ * Check IOMMU hardware Snoop related caps
+ *
+ * - force_snooping:             Force snoop cpu caches per current KVM implementation.
+ * - scalable-mode:              To enable PGSNP bit in PASIDTE to overwrite SNP
+ *                               bit (bit 11) in stage 2 leaves.
+ * - paging structure coherency: As KVM will not call clflush_cache_range()
+ */
+static bool is_coherency(struct intel_iommu *iommu)
+{
+	return ecap_sc_support(iommu->ecap) && sm_supported(iommu) &&
+	       iommu_paging_structure_coherency(iommu);
+}
+
+static bool is_iommu_cap_compatible_to_kvm_domain(struct dmar_domain *domain,
+						  struct intel_iommu *iommu)
+{
+	if (!is_coherency(iommu))
+		return false;
+
+	if (domain->iommu_superpage > fls(cap_super_page_val(iommu->cap)))
+		return false;
+
+	if (domain->agaw > iommu->agaw || domain->agaw > cap_mgaw(iommu->cap))
+		return false;
+
+	return true;
+}
+
+/*
+ * Cache coherency is always enforced in KVM domain.
+ * IOMMU hardware caps will be checked to allow the cache coherency before
+ * device attachment to the KVM domain.
+ */
+static bool kvm_domain_enforce_cache_coherency(struct iommu_domain *domain)
+{
+	return true;
+}
+
+static const struct iommu_domain_ops intel_kvm_domain_ops = {
+	.free			= intel_iommu_domain_free,
+	.enforce_cache_coherency = kvm_domain_enforce_cache_coherency,
+};
+
+struct iommu_domain *
+intel_iommu_domain_alloc_kvm(struct device *dev, u32 flags, const void *data)
+{
+	bool request_nest_parent = flags & IOMMU_HWPT_ALLOC_NEST_PARENT;
+	const struct kvm_exported_tdp_meta_vmx *tdp = data;
+	struct dmar_domain *dmar_domain;
+	struct iommu_domain *domain;
+	struct intel_iommu *iommu;
+	int adjust_width;
+
+	iommu = device_to_iommu(dev, NULL, NULL);
+
+	if (!iommu)
+		return ERR_PTR(-ENODEV);
+	/*
+	 * In theroy, a KVM domain can be nested as a parent domain to a user
+	 * domain. Turn it off as we don't want to handle cases like IO page
+	 * fault on nested domain for now.
+	 */
+	if ((request_nest_parent)) {
+		pr_err("KVM domain does not work as nested parent currently\n");
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
+	if (!tdp || tdp->type != KVM_TDP_TYPE_EPT) {
+		pr_err("No meta data or wrong KVM TDP type\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (tdp->level != 4 && tdp->level != 5) {
+		pr_err("Unsupported KVM TDP level %d in IOMMU\n", tdp->level);
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
+	dmar_domain = alloc_domain(IOMMU_DOMAIN_KVM);
+	if (!dmar_domain)
+		return ERR_PTR(-ENOMEM);
+
+	if (dmar_domain->use_first_level)
+		WARN_ON("KVM domain is applying to IOMMU flpt\n");
+
+	domain = &dmar_domain->domain;
+	domain->ops = &intel_kvm_domain_ops;
+	domain->type = IOMMU_DOMAIN_KVM;
+
+	/* read dmar domain meta data from "tdp" */
+	dmar_domain->gaw = tdp->level == 4 ? ADDR_WIDTH_4LEVEL : ADDR_WIDTH_5LEVEL;
+	adjust_width = guestwidth_to_adjustwidth(dmar_domain->gaw);
+	dmar_domain->agaw = width_to_agaw(adjust_width);
+	dmar_domain->iommu_superpage = tdp->max_huge_page_level - 1;
+	dmar_domain->max_addr = (1 << dmar_domain->gaw);
+	dmar_domain->pgd = phys_to_virt(tdp->root_hpa);
+
+	dmar_domain->nested_parent = false;
+	dmar_domain->dirty_tracking = false;
+
+	/*
+	 * force_snooping and paging strucure coherency in KVM domain
+	 * IOMMU hareware cap will be checked before device attach
+	 */
+	dmar_domain->force_snooping = true;
+	dmar_domain->iommu_coherency = true;
+
+	/* no need to let iommu_map/unmap see pgsize_bitmap */
+	domain->pgsize_bitmap = 0;
+
+	/* force aperture */
+	domain->geometry.aperture_start = 0;
+	domain->geometry.aperture_end = __DOMAIN_MAX_ADDR(dmar_domain->gaw);
+	domain->geometry.force_aperture = true;
+
+	if (!is_iommu_cap_compatible_to_kvm_domain(dmar_domain, iommu)) {
+		pr_err("Unsupported KVM TDP\n");
+		kfree(dmar_domain);
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
+	return domain;
+}
-- 
2.17.1


