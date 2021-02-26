Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491B1326865
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 21:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhBZUQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 15:16:21 -0500
Received: from mga17.intel.com ([192.55.52.151]:35662 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229863AbhBZUNT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 15:13:19 -0500
IronPort-SDR: bFPsn6MOfJDzXrYOw43slIlSpC4pgQwiPmU8vaW84Q6BQeJATL+ItpmKv5Hq7CwNAlP8116G35
 g/y9rpHI3/aA==
X-IronPort-AV: E=McAfee;i="6000,8403,9907"; a="165846907"
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="165846907"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 12:11:14 -0800
IronPort-SDR: Yo/KNtvXneOxHD6NG7HH8FE9wVW+KzGpM+KyH432qTshqa1T8Sq2664sNn9RpZibK33r8a5KZX
 ELNvHeW965Rw==
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="405109452"
Received: from megha-z97x-ud7-th.sc.intel.com ([143.183.85.154])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 26 Feb 2021 12:11:14 -0800
From:   Megha Dey <megha.dey@intel.com>
To:     tglx@linutronix.de
Cc:     linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        ashok.raj@intel.com, kevin.tian@intel.com, dwmw@amazon.co.uk,
        x86@kernel.org, tony.luck@intel.com, dan.j.williams@intel.com,
        megha.dey@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, maz@kernel.org, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com,
        Joerg Roedel <joro@8bytes.org>
Subject: [Patch V2 10/13] iommu: Add capability IOMMU_CAP_VIOMMU_HINT
Date:   Fri, 26 Feb 2021 12:11:14 -0800
Message-Id: <1614370277-23235-11-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
References: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

Some IOMMU specification defines some kind of hint mechanism, through
which BIOS can imply that OS runs in a virtualized environment. For
example, the caching mode defined in VT-d spec and NpCache capability
defined in the AMD IOMMU specification. This hint could also be used
outside of the IOMMU subsystem, where it could be used with other known
means (CPUID, smbios) to sense whether Linux is running in a virtualized
environment. Add a capability bit so that it could be used there.

Cc: Joerg Roedel <joro@8bytes.org>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Megha Dey <megha.dey@intel.com>
---
 drivers/iommu/amd/iommu.c    | 2 ++
 drivers/iommu/intel/iommu.c  | 5 +++++
 drivers/iommu/virtio-iommu.c | 9 +++++++++
 include/linux/iommu.h        | 2 ++
 4 files changed, 18 insertions(+)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index a69a8b5..a912318 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2140,6 +2140,8 @@ static bool amd_iommu_capable(enum iommu_cap cap)
 		return (irq_remapping_enabled == 1);
 	case IOMMU_CAP_NOEXEC:
 		return false;
+	case IOMMU_CAP_VIOMMU_HINT:
+		return amd_iommu_np_cache;
 	default:
 		break;
 	}
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index ee09323..55fa198 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -294,6 +294,7 @@ static inline void context_clear_entry(struct context_entry *context)
  */
 static struct dmar_domain *si_domain;
 static int hw_pass_through = 1;
+static int intel_caching_mode;
 
 #define for_each_domain_iommu(idx, domain)			\
 	for (idx = 0; idx < g_num_of_iommus; idx++)		\
@@ -3253,6 +3254,8 @@ static int __init init_dmars(void)
 
 		if (!ecap_pass_through(iommu->ecap))
 			hw_pass_through = 0;
+		if (cap_caching_mode(iommu->cap))
+			intel_caching_mode = 1;
 		intel_svm_check(iommu);
 	}
 
@@ -5113,6 +5116,8 @@ static bool intel_iommu_capable(enum iommu_cap cap)
 		return domain_update_iommu_snooping(NULL) == 1;
 	if (cap == IOMMU_CAP_INTR_REMAP)
 		return irq_remapping_enabled == 1;
+	if (cap == IOMMU_CAP_VIOMMU_HINT)
+		return intel_caching_mode;
 
 	return false;
 }
diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index 2bfdd57..e4941ca 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -931,7 +931,16 @@ static int viommu_of_xlate(struct device *dev, struct of_phandle_args *args)
 	return iommu_fwspec_add_ids(dev, args->args, 1);
 }
 
+static bool viommu_capable(enum iommu_cap cap)
+{
+	if (cap == IOMMU_CAP_VIOMMU_HINT)
+		return true;
+
+	return false;
+}
+
 static struct iommu_ops viommu_ops = {
+	.capable		= viommu_capable,
 	.domain_alloc		= viommu_domain_alloc,
 	.domain_free		= viommu_domain_free,
 	.attach_dev		= viommu_attach_dev,
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 5e7fe51..9d0ade4 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -94,6 +94,8 @@ enum iommu_cap {
 					   transactions */
 	IOMMU_CAP_INTR_REMAP,		/* IOMMU supports interrupt isolation */
 	IOMMU_CAP_NOEXEC,		/* IOMMU_NOEXEC flag */
+	IOMMU_CAP_VIOMMU_HINT,		/* IOMMU can detect a hit for running in
+					   VM */
 };
 
 /*
-- 
2.7.4

