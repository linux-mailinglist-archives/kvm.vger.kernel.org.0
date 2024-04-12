Return-Path: <kvm+bounces-14413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A5F58A292F
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:21:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6EFB1F21F03
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA8ED50A9D;
	Fri, 12 Apr 2024 08:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BkPV5YKg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8104350289
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 08:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712910088; cv=none; b=IO2ejyoYUWogA4vIawCTS9QYJxxxOBBILy3006j6chPmyV0uL1WVME3mC31cSfU8YUFNLzoESbHC8gaCZPMwcsFIj1Cqns+CBwbOhN2Ak01iamnbKkBXnAEiBScygX3xmeF0r2KTPp34bQy/fC4KmscaV6E+9/sn4pgvUqPBS6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712910088; c=relaxed/simple;
	bh=jLjMOyugTL5/+7lybaOBxd433Z4MIv3gSjYWbqITPXc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DzugRuxd5aseHVZ2RgLVYqVHTmuxXxLT+ySo2s3of/8bOcmcl7GuHZ9i84pQaH0VmNyExVhu60n5gSyv2jAwhMNNQD6styBPQgj1+6xtmlNS4peLLFvPSMpNxRGCQWsI2FFzha7ob2EkjOMYiEo9dYSvfnRi/pRXvqBlwpsfaTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BkPV5YKg; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712910088; x=1744446088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jLjMOyugTL5/+7lybaOBxd433Z4MIv3gSjYWbqITPXc=;
  b=BkPV5YKg1nbQoN3GnO8Hf+G87jTSCM+NmUkTI1yuCkmrZF26KngFvncY
   jyP0rb6ImbS7iCW+2TT1ju6jSvSJeUeaGiR1L6kHqM496tPU25zINioOu
   d9q58z1Aymx2RDix7kMyA8m0cg5sDE3CerULUDcgEU32Muh+Elj690xiB
   O/GWd4ZV9O8Im/fDAj04DWyj5a/D54o3yO70xjKZJzT2eUbi8gpHJEk3o
   MmequnoBPzWBZifqpPIEAyrenGAg1Q8PcNyOOGeJJFBUbjE914XD/+HQO
   F3WqSRNNCvNTlXA58GI1AW5Al5VT4QjQE78l1mUaO+Ylk6eFFKQxvQh5u
   A==;
X-CSE-ConnectionGUID: Drn/Do47Q32LqxeflAQvgQ==
X-CSE-MsgGUID: AbdkIltDTHuQ6pnCD5CBFw==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="19069428"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="19069428"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 01:21:26 -0700
X-CSE-ConnectionGUID: yqcSNUxURnmmSB3/gIz9Rg==
X-CSE-MsgGUID: eVhiK1TzQdakbtwlDeQTSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="25836280"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa003.jf.intel.com with ESMTP; 12 Apr 2024 01:21:26 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: alex.williamson@redhat.com,
	jgg@nvidia.com,
	kevin.tian@intel.com
Cc: joro@8bytes.org,
	robin.murphy@arm.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	jacob.jun.pan@intel.com
Subject: [PATCH v2 4/4] vfio: Report PASID capability via VFIO_DEVICE_FEATURE ioctl
Date: Fri, 12 Apr 2024 01:21:21 -0700
Message-Id: <20240412082121.33382-5-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412082121.33382-1-yi.l.liu@intel.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Today, vfio-pci hides the PASID capability of devices from userspace. Unlike
other PCI capabilities, PASID capability is going to be reported to user by
VFIO_DEVICE_FEATURE. Hence userspace could probe PASID capability by it.
This is a bit different from the other capabilities which are reported to
userspace when the user reads the device's PCI configuration space. There
are two reasons for this.

 - First, userspace like Qemu by default exposes all the available PCI
   capabilities in vfio-pci config space to the guest as read-only, so
   adding PASID capability in the vfio-pci config space will make it
   exposed to the guest automatically while an old Qemu doesn't really
   support it.

 - Second, the PASID capability does not exist on VFs (instead shares the
   cap of the PF). Creating a virtual PASID capability in vfio-pci config
   space needs to find a hole to place it, but doing so may require device
   specific knowledge to avoid potential conflict with device specific
   registers like hidden bits in VF's config space. It's simpler to move
   this burden to the VMM instead of maintaining a quirk system in the kernel.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 50 ++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h        | 14 +++++++++
 2 files changed, 64 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index d94d61b92c1a..ca64e461d435 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1495,6 +1495,54 @@ static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
 	return 0;
 }
 
+static int vfio_pci_core_feature_pasid(struct vfio_device *device, u32 flags,
+				       struct vfio_device_feature_pasid __user *arg,
+				       size_t argsz)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(device, struct vfio_pci_core_device, vdev);
+	struct vfio_device_feature_pasid pasid = { 0 };
+	struct pci_dev *pdev = vdev->pdev;
+	u32 capabilities = 0;
+	u16 ctrl = 0;
+	int ret;
+
+	/*
+	 * Due to no PASID capability per VF, to be consistent, we do not
+	 * support SET of the PASID capability for both PF and VF.
+	 */
+	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
+				 sizeof(pasid));
+	if (ret != 1)
+		return ret;
+
+	/* VF shares the PASID capability of its PF */
+	if (pdev->is_virtfn)
+		pdev = pci_physfn(pdev);
+
+	if (!pdev->pasid_enabled)
+		goto out;
+
+#ifdef CONFIG_PCI_PASID
+	pci_read_config_dword(pdev, pdev->pasid_cap + PCI_PASID_CAP,
+			      &capabilities);
+	pci_read_config_word(pdev, pdev->pasid_cap + PCI_PASID_CTRL,
+			     &ctrl);
+#endif
+
+	pasid.width = (capabilities >> 8) & 0x1f;
+
+	if (ctrl & PCI_PASID_CTRL_EXEC)
+		pasid.capabilities |= VFIO_DEVICE_PASID_CAP_EXEC;
+	if (ctrl & PCI_PASID_CTRL_PRIV)
+		pasid.capabilities |= VFIO_DEVICE_PASID_CAP_PRIV;
+
+out:
+	if (copy_to_user(arg, &pasid, sizeof(pasid)))
+		return -EFAULT;
+	return 0;
+}
+
 int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 				void __user *arg, size_t argsz)
 {
@@ -1508,6 +1556,8 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 		return vfio_pci_core_pm_exit(device, flags, arg, argsz);
 	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
 		return vfio_pci_core_feature_token(device, flags, arg, argsz);
+	case VFIO_DEVICE_FEATURE_PASID:
+		return vfio_pci_core_feature_pasid(device, flags, arg, argsz);
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9591dc24b75c..e50e55c67ab4 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1513,6 +1513,20 @@ struct vfio_device_feature_bus_master {
 };
 #define VFIO_DEVICE_FEATURE_BUS_MASTER 10
 
+/**
+ * Upon VFIO_DEVICE_FEATURE_GET, return the PASID capability for the device.
+ * Zero width means no support for PASID.
+ */
+struct vfio_device_feature_pasid {
+	__u16 capabilities;
+#define VFIO_DEVICE_PASID_CAP_EXEC	(1 << 0)
+#define VFIO_DEVICE_PASID_CAP_PRIV	(1 << 1)
+	__u8 width;
+	__u8 __reserved;
+};
+
+#define VFIO_DEVICE_FEATURE_PASID 11
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.34.1


