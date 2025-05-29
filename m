Return-Path: <kvm+bounces-47949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE29EAC783B
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 07:50:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E08E53B4392
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 05:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56A26267B13;
	Thu, 29 May 2025 05:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ETqfRkVh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0325F259CB0;
	Thu, 29 May 2025 05:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748497417; cv=none; b=O9t6qt3DxaNqNzHIO0wG/N/GpDQx9CM2JHFByblIUGWTZAL7C3q76U5zYWHBV36F7UnFslmjYWj/Naj0n/eRrC/nGg09lZEYnCyp+xIoKtgHpRor8WKQXYgdSstFLF9sB59wrLgq6/XaOG6HcN8cjuVaLj/F7AaxCvxYSBjoBag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748497417; c=relaxed/simple;
	bh=H5T1oQeKOf7EV6IY5wLyfFhALN/V22r5lDzPWKVIEGY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t/EyYcpP/lAv/qNfBG6uN3T+5Xx3WiMzt9+b9a/hnWYzKeEIXnICT8B9vrKjgItfdfh/oX3I5HSUX+Kkwsou0TKdS7CPS/k/92InReH6mKspgtwXbKI2xvFZGOu/Yp+D1ffI7NYJNy90WdkIExMy1lLyHOcc4kqbE8YHfGfswGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ETqfRkVh; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748497416; x=1780033416;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H5T1oQeKOf7EV6IY5wLyfFhALN/V22r5lDzPWKVIEGY=;
  b=ETqfRkVhU/Q0B3WHVQ4gUzibVeFh/cd71McziYgIk7gVsjFP7MXkks6C
   37ojluJNg1NYrOjv+JbKRoM3t6Ik7t3OrOvfvVI6BScAfZ41mvmuKn2xz
   k+mfuezI1K0pCzJIwmSbhN8LBy/zE87AF/AgzzbGTwB4thg872bF0we5V
   xYH9w2FnWJyCp/X7Q/uyMPd7dsZ/5Gv6sTKKkcSMOJgxAjp82PcJ64cof
   xTqMVb6E17P45PMOFM0oV68FntgvMntLlIQvWbVn7jaTuHBeDQIQJCwp2
   EdWbTAkrQ0bCESZo77nnHGndNvotr98geV75enoj0SwXGRJow7Hvc7H0E
   g==;
X-CSE-ConnectionGUID: e9ODA3kpRLy/jN9KHVVdCA==
X-CSE-MsgGUID: 1+aqVZwTQASo4S4eQ7E/NA==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="67963245"
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="67963245"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 22:43:35 -0700
X-CSE-ConnectionGUID: uP6OUWujSrKq+yVSnWdvuw==
X-CSE-MsgGUID: smGeTrTaTj6FUFOgx2fVKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="144443460"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 28 May 2025 22:43:27 -0700
From: Xu Yilun <yilun.xu@linux.intel.com>
To: kvm@vger.kernel.org,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	dan.j.williams@intel.com,
	aik@amd.com,
	linux-coco@lists.linux.dev
Cc: dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	vivek.kasireddy@intel.com,
	yilun.xu@intel.com,
	yilun.xu@linux.intel.com,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch,
	leon@kernel.org,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	tao1.su@intel.com,
	linux-pci@vger.kernel.org,
	zhiw@nvidia.com,
	simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com,
	aneesh.kumar@kernel.org,
	iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: [RFC PATCH 18/30] iommufd/viommu: Add trusted IOMMU configuration handlers for vdev
Date: Thu, 29 May 2025 13:35:01 +0800
Message-Id: <20250529053513.1592088-19-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add handlers for setting up/removing trusted IOMMU configurations
against vdevice. IOMMUFD calls these handlers on TSM bind/unbind. Most
vendors extend the trusted IOMMU engine for private device assignment,
thus require extra IOMMU configuration for TSM bind. E.g. Intel TDX
Connect requires host to build extra trusted Device Conext Table
entries (but not present), while AMD requires to clear Domain-ID on
non-secure DTE.

Existing DMA setup flow against IOMMUFD are driven by userspace, usually
start with allocating a domain, then attach the domain to the device.
While trusted DMA setup is embedded in TSM bind/unbind() IOCTLs. This is
because platform secure firmwares have various configuration
enforcements for trusted. E.g. Intel TDX Connect enforces trusted IOPT
detach after TDI STOP but before TDI metadata free. Using coarser uAPIs
like TSM bind/unbind that wrap all trusted configurations prevent these
low level complexities propagating to userspace.

Coarser uAPI means userspace lose the flexibility to attach different
domains to trusted part of the device. Also it cannot operate on the
trusted domain. That seems not a problem cause VMM is out of the TCB so
secure firmware either disallows VMM touching the trusted domain or only
allows a fixed configuration set. E.g. TDX Connect enforces all assigned
devices in the same VM must share the same trusted domain. It also
specifies every value of the trusted Context Table entries. So just
setup everything for trusted DMA in IOMMU driver is a reasonable choice.

OPEN: Should these handlers be viommu ops or vdevice ops?

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 drivers/iommu/iommufd/iommufd_private.h |  1 +
 drivers/iommu/iommufd/viommu.c          | 41 ++++++++++++++++++++++++-
 include/linux/iommufd.h                 |  2 ++
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 29af8616e4aa..0db9a0e53a77 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -618,6 +618,7 @@ struct iommufd_vdevice {
 	u64 id; /* per-vIOMMU virtual ID */
 	struct mutex tsm_lock;
 	bool tsm_bound;
+	bool trusted_dma_enabled;
 };
 
 int iommufd_vdevice_tsm_bind(struct iommufd_vdevice *vdev);
diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
index 296143e21368..8437e936c278 100644
--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -224,6 +224,37 @@ int iommufd_vdevice_alloc_ioctl(struct iommufd_ucmd *ucmd)
 	return rc;
 }
 
+static int iommufd_vdevice_enable_trusted_dma(struct iommufd_vdevice *vdev)
+{
+	struct iommufd_viommu *viommu = vdev->viommu;
+	int rc;
+
+	if (vdev->trusted_dma_enabled)
+		return 0;
+
+	if (viommu->ops->setup_trusted_vdev) {
+		rc = viommu->ops->setup_trusted_vdev(viommu, vdev->id);
+		if (rc)
+			return rc;
+	}
+
+	vdev->trusted_dma_enabled = true;
+	return 0;
+}
+
+static void iommufd_vdevice_disable_trusted_dma(struct iommufd_vdevice *vdev)
+{
+	struct iommufd_viommu *viommu = vdev->viommu;
+
+	if (!vdev->trusted_dma_enabled)
+		return;
+
+	if (viommu->ops->remove_trusted_vdev)
+		viommu->ops->remove_trusted_vdev(viommu, vdev->id);
+
+	vdev->trusted_dma_enabled = false;
+}
+
 int iommufd_vdevice_tsm_bind(struct iommufd_vdevice *vdev)
 {
 	struct kvm *kvm;
@@ -241,12 +272,19 @@ int iommufd_vdevice_tsm_bind(struct iommufd_vdevice *vdev)
 		goto out_unlock;
 	}
 
-	rc = pci_tsm_bind(to_pci_dev(vdev->dev), kvm, vdev->id);
+	rc = iommufd_vdevice_enable_trusted_dma(vdev);
 	if (rc)
 		goto out_unlock;
 
+	rc = pci_tsm_bind(to_pci_dev(vdev->dev), kvm, vdev->id);
+	if (rc)
+		goto out_disable_trusted_dma;
+
 	vdev->tsm_bound = true;
+	goto out_unlock;
 
+out_disable_trusted_dma:
+	iommufd_vdevice_disable_trusted_dma(vdev);
 out_unlock:
 	mutex_unlock(&vdev->tsm_lock);
 	return rc;
@@ -259,6 +297,7 @@ void iommufd_vdevice_tsm_unbind(struct iommufd_vdevice *vdev)
 		goto out_unlock;
 
 	pci_tsm_unbind(to_pci_dev(vdev->dev));
+	iommufd_vdevice_disable_trusted_dma(vdev);
 	vdev->tsm_bound = false;
 
 out_unlock:
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 5f9a286232ac..d73e8d3b9b95 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -136,6 +136,8 @@ struct iommufd_viommu_ops {
 		const struct iommu_user_data *user_data);
 	int (*cache_invalidate)(struct iommufd_viommu *viommu,
 				struct iommu_user_data_array *array);
+	int (*setup_trusted_vdev)(struct iommufd_viommu *viommu, u64 vdev_id);
+	void (*remove_trusted_vdev)(struct iommufd_viommu *viommu, u64 vdev_id);
 };
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
-- 
2.25.1


