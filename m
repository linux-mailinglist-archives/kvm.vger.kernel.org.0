Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE61F30E488
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 22:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhBCVAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 16:00:55 -0500
Received: from mga07.intel.com ([134.134.136.100]:45277 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232604AbhBCU7G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 15:59:06 -0500
IronPort-SDR: 6NTX7Nzcyc2QiXy2esZJv4jLcBgvFIsx3TEw5L5b0EoFtZDh8j1ZWg5pdVttSN41T6Ihd4xKs/
 9ppsRWPIvcHw==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="245191311"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="245191311"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 12:57:32 -0800
IronPort-SDR: G3Slvai/j9HhtC7F3TgFBs5ouMaKBSpqdfeBf6+JEg0o30xilyMw1L8grccIH4csUS1oJnnYCn
 60kXa5ZMaZFA==
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="372510587"
Received: from megha-z97x-ud7-th.sc.intel.com ([143.183.85.154])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 03 Feb 2021 12:57:31 -0800
From:   Megha Dey <megha.dey@intel.com>
To:     tglx@linutronix.de
Cc:     linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        ashok.raj@intel.com, kevin.tian@intel.com, dwmw@amazon.co.uk,
        x86@kernel.org, tony.luck@intel.com, dan.j.williams@intel.com,
        megha.dey@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, maz@kernel.org, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com
Subject: [PATCH 10/12] iommu: Add capability IOMMU_CAP_VIOMMU_HINT
Date:   Wed,  3 Feb 2021 12:56:43 -0800
Message-Id: <1612385805-3412-11-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612385805-3412-1-git-send-email-megha.dey@intel.com>
References: <1612385805-3412-1-git-send-email-megha.dey@intel.com>
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

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Megha Dey <megha.dey@intel.com>
---
 drivers/iommu/amd/iommu.c    |  2 ++
 drivers/iommu/intel/iommu.c  | 20 ++++++++++++++++++++
 drivers/iommu/virtio-iommu.c |  9 +++++++++
 include/linux/iommu.h        |  2 ++
 4 files changed, 33 insertions(+)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index f0adbc4..a851f37 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2646,6 +2646,8 @@ static bool amd_iommu_capable(enum iommu_cap cap)
 		return (irq_remapping_enabled == 1);
 	case IOMMU_CAP_NOEXEC:
 		return false;
+	case IOMMU_CAP_VIOMMU_HINT:
+		return amd_iommu_np_cache;
 	default:
 		break;
 	}
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 06b00b5..905d6aa 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5094,12 +5094,32 @@ static inline bool nested_mode_support(void)
 	return ret;
 }
 
+static inline bool caching_mode_supported(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+	bool ret = false;
+
+	rcu_read_lock();
+	for_each_active_iommu(iommu, drhd) {
+		if (cap_caching_mode(iommu->cap)) {
+			ret = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static bool intel_iommu_capable(enum iommu_cap cap)
 {
 	if (cap == IOMMU_CAP_CACHE_COHERENCY)
 		return domain_update_iommu_snooping(NULL) == 1;
 	if (cap == IOMMU_CAP_INTR_REMAP)
 		return irq_remapping_enabled == 1;
+	if (cap == IOMMU_CAP_VIOMMU_HINT)
+		return caching_mode_supported();
 
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
index b3f0e20..5e62bcc 100644
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

