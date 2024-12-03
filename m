Return-Path: <kvm+bounces-32946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3523C9E2B53
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 19:48:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF171282F4F
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 18:48:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4128A1FF60C;
	Tue,  3 Dec 2024 18:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IB40EH78"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9782D1FA251;
	Tue,  3 Dec 2024 18:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733251679; cv=none; b=YgEB7uhEZEDcFRfCqkLVdtKkJ/kFCE4L4ATqlX7iomBel3Bthch8JqbXfGpav7Hfl/yZwNY0F6L9+XvYt6UG427zhqwrnskNgudfdRTFVrCP47NHxVCO3qXVBjM5u0UjwFAnMMftUZsmE9YENYR5BRCM7o1FDRUHobh84YUTZ2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733251679; c=relaxed/simple;
	bh=MpXlci4bxso5/v7WqNwNowlxVwMFOzqPts08hgEvzbI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ox6qukI9HABMGaay0O047XqcYrMgvhYjMZ2MTxw3Sms3WvoaM9Yesqb3DiBKHqVloLIvp2VP8kP0O3BEdKskERdo/Kl/XhIQQIgiOgOfhsEIkG+mTNBYvLuu1GcegFwl/gcPKR7Ov9vcWXsF4BkeGlqkBYz1mKuqfts0FlYOBqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IB40EH78; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733251678; x=1764787678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MpXlci4bxso5/v7WqNwNowlxVwMFOzqPts08hgEvzbI=;
  b=IB40EH78AepaGHOmLB3bRJ+UUYcAevtUf+MU6WqYIAfnppH32MvrqSlq
   YcLR0BoJPMuW8IEoqizyktUhAWQ/ihs4dW68F8dIfzHFMUPkaEKWCKWbO
   iP4yX0SXqGbOLR6UwykIJsdX/HAgB3kbDUbGU/JhiY1zOLyf9D6CiWXeG
   QBeTGlZpZTSF8/7sVWsHkWoDJVqr8VwbuMI4Fv9XqOP4Mm+t/hKgMoEiB
   3B3ritwFuXVm6rJ7CjexuS6thiuXNViQyDzp1iBbJxc/Zk6C1vFWKBOJ2
   NRpFthNc58UWAYhFZ1yUpcfuVZkfqNac7kBnie8y8KMVM2JAgw+BIuz71
   w==;
X-CSE-ConnectionGUID: f8X28IaeTaK2nRZGyajUPw==
X-CSE-MsgGUID: xNKtpk+JRgyLDfFViJO9iw==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="37143174"
X-IronPort-AV: E=Sophos;i="6.12,205,1728975600"; 
   d="scan'208";a="37143174"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 10:47:56 -0800
X-CSE-ConnectionGUID: 8K9XQrofRBaJ5Ud55CXlfQ==
X-CSE-MsgGUID: IgyH0VlyRbuCbtv4WyhDqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,205,1728975600"; 
   d="scan'208";a="93420018"
Received: from rthomas.sc.intel.com ([172.25.112.51])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 10:47:54 -0800
From: Ramesh Thomas <ramesh.thomas@intel.com>
To: alex.williamson@redhat.com,
	jgg@ziepe.ca,
	schnelle@linux.ibm.com,
	gbayer@linux.ibm.com
Cc: kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	ankita@nvidia.com,
	yishaih@nvidia.com,
	pasic@linux.ibm.com,
	julianr@linux.ibm.com,
	bpsegal@us.ibm.com,
	ramesh.thomas@intel.com,
	kevin.tian@intel.com,
	cho@microsoft.com
Subject: [PATCH v2 2/2] vfio/pci: Remove #ifdef iowrite64 and #ifdef ioread64
Date: Tue,  3 Dec 2024 10:41:58 -0800
Message-Id: <20241203184158.172492-3-ramesh.thomas@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241203184158.172492-1-ramesh.thomas@intel.com>
References: <20241203184158.172492-1-ramesh.thomas@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the #ifdef iowrite64 and #ifdef ioread64 checks around calls to
64 bit IO access. Since default implementations have been enabled, the
checks are not required. Such checks can hide potential bugs as well.
Instead check for CONFIG_64BIT to make the 64 bit IO calls only when 64
bit support is enabled.

Signed-off-by: Ramesh Thomas <ramesh.thomas@intel.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index a0595c745732..02a3f1cb8f77 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -62,7 +62,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_iowrite##size);
 VFIO_IOWRITE(8)
 VFIO_IOWRITE(16)
 VFIO_IOWRITE(32)
-#ifdef iowrite64
+#ifdef CONFIG_64BIT
 VFIO_IOWRITE(64)
 #endif
 
@@ -90,7 +90,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_ioread##size);
 VFIO_IOREAD(8)
 VFIO_IOREAD(16)
 VFIO_IOREAD(32)
-#ifdef ioread64
+#ifdef CONFIG_64BIT
 VFIO_IOREAD(64)
 #endif
 
@@ -128,7 +128,7 @@ static int vfio_pci_iordwr##size(struct vfio_pci_core_device *vdev,\
 VFIO_IORDWR(8)
 VFIO_IORDWR(16)
 VFIO_IORDWR(32)
-#if defined(ioread64) && defined(iowrite64)
+#ifdef CONFIG_64BIT
 VFIO_IORDWR(64)
 #endif
 
@@ -156,7 +156,7 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 		else
 			fillable = 0;
 
-#if defined(ioread64) && defined(iowrite64)
+#ifdef CONFIG_64BIT
 		if (fillable >= 8 && !(off % 8)) {
 			ret = vfio_pci_iordwr64(vdev, iswrite, test_mem,
 						io, buf, off, &filled);
@@ -382,7 +382,7 @@ static void vfio_pci_ioeventfd_do_write(struct vfio_pci_ioeventfd *ioeventfd,
 		vfio_pci_core_iowrite32(ioeventfd->vdev, test_mem,
 					ioeventfd->data, ioeventfd->addr);
 		break;
-#ifdef iowrite64
+#ifdef CONFIG_64BIT
 	case 8:
 		vfio_pci_core_iowrite64(ioeventfd->vdev, test_mem,
 					ioeventfd->data, ioeventfd->addr);
@@ -441,7 +441,7 @@ int vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 	      pos >= vdev->msix_offset + vdev->msix_size))
 		return -EINVAL;
 
-#ifndef iowrite64
+#ifndef CONFIG_64BIT
 	if (count == 8)
 		return -EINVAL;
 #endif
-- 
2.34.1


