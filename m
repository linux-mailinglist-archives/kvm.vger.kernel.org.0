Return-Path: <kvm+bounces-41705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DBA81A6C201
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 19:02:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 518B1464086
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 18:02:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E055522FF37;
	Fri, 21 Mar 2025 18:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FNqIaGVK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD0122F381
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 18:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742580111; cv=none; b=RemydEMkjqc6ZByHyHrdDpodn98GpJn9X7LLmF/qT25zt3obbdHE9ebr7UxyTBGyKvZkOP/XDGKn2Di28fxm52afN50xhDsA+ihwbQrjtejrM2rdteG5bnVwvp2s9YDXZjcHG4C8MHiWWHyKOKfVNCb9j5Uq1bAaeRwxODdeU9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742580111; c=relaxed/simple;
	bh=YdQ2xBrSwfuHBE32UxKgm+8F1yUUgyT/KV7IOSsV8HQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hDFeznAa+3xK8aoKk64u08xjrWjd3EvzCcQxyIdB9M+UEezQDsSQff45hY5A7kjM/hyZtdQvJbzTTviDq9rIffmzwgzSmUmaV/t+5CFKiGuZLezTvuy/ZM1D84WgkoHNVPOSAxJzWP3FufIV7QnvlDgpW8KKyGYygrSuKLPCVzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FNqIaGVK; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742580109; x=1774116109;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YdQ2xBrSwfuHBE32UxKgm+8F1yUUgyT/KV7IOSsV8HQ=;
  b=FNqIaGVKbNJlFfRheTYFFX4SquejaBX2DNCXRpo6/2wexmLz1IPBZx50
   yw0oYL9yUc2gW/JL6DJaWeR9kec4Ya7X5ufanqwdfBrklVR7lazXIP9Yx
   zYi/4x+8w9qPywZI8A4bevsf/vmx/Wjdq9eWUvUgwR25DgRVmZTMW2R7/
   2jt2Ml7W3XHOqtB2M5nNnt5X96ufwCLo4oWd7+ArbKdNUUjdqlvd+u3nQ
   as02je1dHTXUWFpGLmTwFMLrlZ1HjzhAwASouE+9B8BvRNER02nm0O+ZG
   tIllwVG81rNcq+JOuSwVViE1s9ckdNHqSxF4HawHfTGkV6e0NjfqA6Lq8
   g==;
X-CSE-ConnectionGUID: sPEzGwlbRWO1KXW4A5rVrg==
X-CSE-MsgGUID: pzdeYLIDRGarhA0sdFTyrQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="55234680"
X-IronPort-AV: E=Sophos;i="6.14,265,1736841600"; 
   d="scan'208";a="55234680"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 11:01:47 -0700
X-CSE-ConnectionGUID: uU/e6TnlSIem9Uu3w0X68w==
X-CSE-MsgGUID: jvB3kdjuTNmBESt3C0/WAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,265,1736841600"; 
   d="scan'208";a="160694120"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa001.jf.intel.com with ESMTP; 21 Mar 2025 11:01:47 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: alex.williamson@redhat.com
Cc: jgg@nvidia.com,
	yi.l.liu@intel.com,
	kevin.tian@intel.com,
	eric.auger@redhat.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	zhenzhong.duan@intel.com,
	willy@infradead.org,
	zhangfei.gao@linaro.org,
	vasant.hegde@amd.com,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v9 4/5] iommufd: Extend IOMMU_GET_HW_INFO to report PASID capability
Date: Fri, 21 Mar 2025 11:01:42 -0700
Message-Id: <20250321180143.8468-5-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250321180143.8468-1-yi.l.liu@intel.com>
References: <20250321180143.8468-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PASID usage requires PASID support in both device and IOMMU. Since the
iommu drivers always enable the PASID capability for the device if it
is supported, this extends the IOMMU_GET_HW_INFO to report the PASID
capability to userspace. Also, enhances the selftest accordingly.

Cc:  Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Zhangfei Gao <zhangfei.gao@linaro.org> #aarch64 platform
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/device.c | 34 +++++++++++++++++++++++++++++++++-
 drivers/pci/ats.c              | 33 +++++++++++++++++++++++++++++++++
 include/linux/pci-ats.h        |  3 +++
 include/uapi/linux/iommufd.h   | 14 +++++++++++++-
 4 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 1605f6c0e1ee..2307daad65c0 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -3,6 +3,7 @@
  */
 #include <linux/iommu.h>
 #include <linux/iommufd.h>
+#include <linux/pci-ats.h>
 #include <linux/slab.h>
 #include <uapi/linux/iommufd.h>
 
@@ -1455,7 +1456,8 @@ int iommufd_get_hw_info(struct iommufd_ucmd *ucmd)
 	void *data;
 	int rc;
 
-	if (cmd->flags || cmd->__reserved)
+	if (cmd->flags || cmd->__reserved[0] || cmd->__reserved[1] ||
+	    cmd->__reserved[2])
 		return -EOPNOTSUPP;
 
 	idev = iommufd_get_device(ucmd, cmd->dev_id);
@@ -1512,6 +1514,36 @@ int iommufd_get_hw_info(struct iommufd_ucmd *ucmd)
 	if (device_iommu_capable(idev->dev, IOMMU_CAP_DIRTY_TRACKING))
 		cmd->out_capabilities |= IOMMU_HW_CAP_DIRTY_TRACKING;
 
+	cmd->out_max_pasid_log2 = 0;
+	/*
+	 * Currently, all iommu drivers enable PASID in the probe_device()
+	 * op if iommu and device supports it. So the max_pasids stored in
+	 * dev->iommu indicates both PASID support and enable status. A
+	 * non-zero dev->iommu->max_pasids means PASID is supported and
+	 * enabled. The iommufd only reports PASID capability to userspace
+	 * if it's enabled.
+	 */
+	if (idev->dev->iommu->max_pasids) {
+		cmd->out_max_pasid_log2 = ilog2(idev->dev->iommu->max_pasids);
+
+		if (dev_is_pci(idev->dev)) {
+			struct pci_dev *pdev = to_pci_dev(idev->dev);
+			int ctrl;
+
+			ctrl = pci_pasid_status(pdev);
+
+			WARN_ON_ONCE(ctrl < 0 ||
+				     !(ctrl & PCI_PASID_CTRL_ENABLE));
+
+			if (ctrl & PCI_PASID_CTRL_EXEC)
+				cmd->out_capabilities |=
+						IOMMU_HW_CAP_PCI_PASID_EXEC;
+			if (ctrl & PCI_PASID_CTRL_PRIV)
+				cmd->out_capabilities |=
+						IOMMU_HW_CAP_PCI_PASID_PRIV;
+		}
+	}
+
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 out_free:
 	kfree(data);
diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
index c6b266c772c8..ec6c8dbdc5e9 100644
--- a/drivers/pci/ats.c
+++ b/drivers/pci/ats.c
@@ -538,4 +538,37 @@ int pci_max_pasids(struct pci_dev *pdev)
 	return (1 << FIELD_GET(PCI_PASID_CAP_WIDTH, supported));
 }
 EXPORT_SYMBOL_GPL(pci_max_pasids);
+
+/**
+ * pci_pasid_status - Check the PASID status
+ * @pdev: PCI device structure
+ *
+ * Returns a negative value when no PASID capability is present.
+ * Otherwise the value of the control register is returned.
+ * Status reported are:
+ *
+ * PCI_PASID_CTRL_ENABLE - PASID enabled
+ * PCI_PASID_CTRL_EXEC - Execute permission enabled
+ * PCI_PASID_CTRL_PRIV - Privileged mode enabled
+ */
+int pci_pasid_status(struct pci_dev *pdev)
+{
+	int pasid;
+	u16 ctrl;
+
+	if (pdev->is_virtfn)
+		pdev = pci_physfn(pdev);
+
+	pasid = pdev->pasid_cap;
+	if (!pasid)
+		return -EINVAL;
+
+	pci_read_config_word(pdev, pasid + PCI_PASID_CTRL, &ctrl);
+
+	ctrl &= PCI_PASID_CTRL_ENABLE | PCI_PASID_CTRL_EXEC |
+		PCI_PASID_CTRL_PRIV;
+
+	return ctrl;
+}
+EXPORT_SYMBOL_GPL(pci_pasid_status);
 #endif /* CONFIG_PCI_PASID */
diff --git a/include/linux/pci-ats.h b/include/linux/pci-ats.h
index 0e8b74e63767..75c6c86cf09d 100644
--- a/include/linux/pci-ats.h
+++ b/include/linux/pci-ats.h
@@ -42,6 +42,7 @@ int pci_enable_pasid(struct pci_dev *pdev, int features);
 void pci_disable_pasid(struct pci_dev *pdev);
 int pci_pasid_features(struct pci_dev *pdev);
 int pci_max_pasids(struct pci_dev *pdev);
+int pci_pasid_status(struct pci_dev *pdev);
 #else /* CONFIG_PCI_PASID */
 static inline int pci_enable_pasid(struct pci_dev *pdev, int features)
 { return -EINVAL; }
@@ -50,6 +51,8 @@ static inline int pci_pasid_features(struct pci_dev *pdev)
 { return -EINVAL; }
 static inline int pci_max_pasids(struct pci_dev *pdev)
 { return -EINVAL; }
+static inline int pci_pasid_status(struct pci_dev *pdev)
+{ return -EINVAL; }
 #endif /* CONFIG_PCI_PASID */
 
 #endif /* LINUX_PCI_ATS_H */
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 6901804ec736..81c31a36e14a 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -612,9 +612,17 @@ enum iommu_hw_info_type {
  *                                   IOMMU_HWPT_GET_DIRTY_BITMAP
  *                                   IOMMU_HWPT_SET_DIRTY_TRACKING
  *
+ * @IOMMU_HW_CAP_PASID_EXEC: Execute Permission Supported, user ignores it
+ *                           when the struct iommu_hw_info::out_max_pasid_log2
+ *                           is zero.
+ * @IOMMU_HW_CAP_PASID_PRIV: Privileged Mode Supported, user ignores it
+ *                           when the struct iommu_hw_info::out_max_pasid_log2
+ *                           is zero.
  */
 enum iommufd_hw_capabilities {
 	IOMMU_HW_CAP_DIRTY_TRACKING = 1 << 0,
+	IOMMU_HW_CAP_PCI_PASID_EXEC = 1 << 1,
+	IOMMU_HW_CAP_PCI_PASID_PRIV = 1 << 2,
 };
 
 /**
@@ -630,6 +638,9 @@ enum iommufd_hw_capabilities {
  *                 iommu_hw_info_type.
  * @out_capabilities: Output the generic iommu capability info type as defined
  *                    in the enum iommu_hw_capabilities.
+ * @out_max_pasid_log2: Output the width of PASIDs. 0 means no PASID support.
+ *                      PCI devices turn to out_capabilities to check if the
+ *                      specific capabilities is supported or not.
  * @__reserved: Must be 0
  *
  * Query an iommu type specific hardware information data from an iommu behind
@@ -653,7 +664,8 @@ struct iommu_hw_info {
 	__u32 data_len;
 	__aligned_u64 data_uptr;
 	__u32 out_data_type;
-	__u32 __reserved;
+	__u8 out_max_pasid_log2;
+	__u8 __reserved[3];
 	__aligned_u64 out_capabilities;
 };
 #define IOMMU_GET_HW_INFO _IO(IOMMUFD_TYPE, IOMMUFD_CMD_GET_HW_INFO)
-- 
2.34.1


