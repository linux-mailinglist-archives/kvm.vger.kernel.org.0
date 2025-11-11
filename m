Return-Path: <kvm+bounces-62751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38F95C4CE98
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 11:11:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B1733A7D06
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 10:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08D1033891B;
	Tue, 11 Nov 2025 09:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BSGkFCpi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFB9335BC1;
	Tue, 11 Nov 2025 09:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762855109; cv=none; b=AObAYudy5yVJiA36svJxZ1WX5BYsFF6i2dj0mrcD24+Nvn3qhpxXIS/wTLWR2buxiSCLtEXIsEb4sYIz8alxGIzNBHSO5Qs36Hn5wsPg9T0/sFaTtkzq3O4JNF3HDVJCzIpSETV1//uIZPwFCjD8RIiGn0pPo7kuiI03VpSmrIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762855109; c=relaxed/simple;
	bh=lS6T58DHt9wPHQS8Kvm1FHiA6t+nNSAifcX8vWpYDwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EdvUz8c47GLk8/PZDBMGzGsBSwlgBgfF/gaJDhlfLDf8l7H60x3YKciRF13cJbwQmRlnjAvcoAW2kw/uiQe/od1WkkNDtNSIrkQEPrRcWyNdSM3zy0FgOBG/FyDNdmwteOQtVCKDLD4ZMDncikhnQwmjI38s2HnksRd4GGR+rIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BSGkFCpi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7531C116D0;
	Tue, 11 Nov 2025 09:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762855108;
	bh=lS6T58DHt9wPHQS8Kvm1FHiA6t+nNSAifcX8vWpYDwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSGkFCpicG96X7vFHZ5HW4Mj4KH+4wNi8vv62J2wwznZbavZISMCBFYMiLkxE8Qog
	 p5+D5op+BLuvmHVeA5srt6cx6kBCmCWG5wPGnbpF+s+OAeWTWHcdKqhqXmOnXupF/Z
	 zZkWyEtZ4m78eIBLUOCYHfT45soSCLSjLPWME7VcYi2qrCugpb+mJOGRhMFRhZSVUP
	 nLGy6c7uz2y4sbDJjZf1D6fVh5t0FVp2YUBrnBHxyQkR4azdQUrQet3SSYzjJhhsfQ
	 lWELuAq0eowmi5gpESSKJX7udUguoqXdF+AkhwPUFixtr5vAQP6y0hVSMLTfElscDl
	 SLLFX+cN0GU4A==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
Cc: Krishnakant Jaju <kjaju@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH v8 08/11] vfio/pci: Share the core device pointer while invoking feature functions
Date: Tue, 11 Nov 2025 11:57:50 +0200
Message-ID: <20251111-dmabuf-vfio-v8-8-fd9aa5df478f@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-3ae27
Content-Transfer-Encoding: 8bit

From: Vivek Kasireddy <vivek.kasireddy@intel.com>

There is no need to share the main device pointer (struct vfio_device *)
with all the feature functions as they only need the core device
pointer. Therefore, extract the core device pointer once in the
caller (vfio_pci_core_ioctl_feature) and share it instead.

Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Tested-by: Alex Mastro <amastro@fb.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc..ca9a95716a85 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -299,11 +299,9 @@ static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev,
 	return 0;
 }
 
-static int vfio_pci_core_pm_entry(struct vfio_device *device, u32 flags,
+static int vfio_pci_core_pm_entry(struct vfio_pci_core_device *vdev, u32 flags,
 				  void __user *arg, size_t argsz)
 {
-	struct vfio_pci_core_device *vdev =
-		container_of(device, struct vfio_pci_core_device, vdev);
 	int ret;
 
 	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET, 0);
@@ -320,12 +318,10 @@ static int vfio_pci_core_pm_entry(struct vfio_device *device, u32 flags,
 }
 
 static int vfio_pci_core_pm_entry_with_wakeup(
-	struct vfio_device *device, u32 flags,
+	struct vfio_pci_core_device *vdev, u32 flags,
 	struct vfio_device_low_power_entry_with_wakeup __user *arg,
 	size_t argsz)
 {
-	struct vfio_pci_core_device *vdev =
-		container_of(device, struct vfio_pci_core_device, vdev);
 	struct vfio_device_low_power_entry_with_wakeup entry;
 	struct eventfd_ctx *efdctx;
 	int ret;
@@ -376,11 +372,9 @@ static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
 	up_write(&vdev->memory_lock);
 }
 
-static int vfio_pci_core_pm_exit(struct vfio_device *device, u32 flags,
+static int vfio_pci_core_pm_exit(struct vfio_pci_core_device *vdev, u32 flags,
 				 void __user *arg, size_t argsz)
 {
-	struct vfio_pci_core_device *vdev =
-		container_of(device, struct vfio_pci_core_device, vdev);
 	int ret;
 
 	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET, 0);
@@ -1473,11 +1467,10 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
 
-static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
-				       uuid_t __user *arg, size_t argsz)
+static int vfio_pci_core_feature_token(struct vfio_pci_core_device *vdev,
+				       u32 flags, uuid_t __user *arg,
+				       size_t argsz)
 {
-	struct vfio_pci_core_device *vdev =
-		container_of(device, struct vfio_pci_core_device, vdev);
 	uuid_t uuid;
 	int ret;
 
@@ -1504,16 +1497,19 @@ static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
 int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 				void __user *arg, size_t argsz)
 {
+	struct vfio_pci_core_device *vdev =
+		container_of(device, struct vfio_pci_core_device, vdev);
+
 	switch (flags & VFIO_DEVICE_FEATURE_MASK) {
 	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY:
-		return vfio_pci_core_pm_entry(device, flags, arg, argsz);
+		return vfio_pci_core_pm_entry(vdev, flags, arg, argsz);
 	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP:
-		return vfio_pci_core_pm_entry_with_wakeup(device, flags,
+		return vfio_pci_core_pm_entry_with_wakeup(vdev, flags,
 							  arg, argsz);
 	case VFIO_DEVICE_FEATURE_LOW_POWER_EXIT:
-		return vfio_pci_core_pm_exit(device, flags, arg, argsz);
+		return vfio_pci_core_pm_exit(vdev, flags, arg, argsz);
 	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
-		return vfio_pci_core_feature_token(device, flags, arg, argsz);
+		return vfio_pci_core_feature_token(vdev, flags, arg, argsz);
 	default:
 		return -ENOTTY;
 	}

-- 
2.51.1


