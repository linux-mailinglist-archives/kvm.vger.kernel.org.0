Return-Path: <kvm+bounces-57307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C83EB530C3
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 13:37:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 512B61BC200B
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 11:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E743A3277A9;
	Thu, 11 Sep 2025 11:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FcCIpgx1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EE3324B3C;
	Thu, 11 Sep 2025 11:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757590461; cv=none; b=SyV8VJv1IQA6u7jF2FJpXTLnPxMekPuV+rlGidesH2xOkukyr8Qq3w/OB6+Qqt2iChrsvnZy43p3LFcvVKJQValtKNyMD5o7Gvb5WnZ3lamrG1gNCutiKauX9Ezj6trgIIB2AM3P5PImjtxbTn1rowC+G4dSEZG9yGF8tlP4g94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757590461; c=relaxed/simple;
	bh=XSq9qJYMvX5x9A0SGQeu7EMmnMC35VY7+EoC77mNcp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDuhs0oY+AkII2rOaTBMsQFN2BMUoR8eBnTIqkzW8Kr103CMQsc5WQfd1GO4hXDXR4di1pd69YSgbDBbuFGGGNCOKgJoVHgaAnG8tXuMEdXOOVsIjuwl2cyq1rV1uMOxbm+OmnuQe4E1nIRXggMOF1QgT2Ult7BozhGtj6MrvTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FcCIpgx1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDADC4CEF1;
	Thu, 11 Sep 2025 11:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757590460;
	bh=XSq9qJYMvX5x9A0SGQeu7EMmnMC35VY7+EoC77mNcp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcCIpgx1TGJzgCnTTyX04qdN3KJuBsYXSa7nx1A97dM6JDTKSa7vSOTcrlywPw/RK
	 j6Q2+da3LkTc0JLLFN7RXuuddjf/pO748HsIAGrYtGTaSWwXDUfkuMFkUpEC1GyoUE
	 KAzfYSvAugjo33qgsLYU+olcxZ2CC/wK2vhXE100SDMKeY3fuP4/DIf4p7Sfenvrsf
	 S1zK5DHFSU9rAKdaQmrsguSZa9YX1MSt5vEm3aekow7rKQYhZisWrtcyh2/S3QcXE2
	 EI/UNKaITwMMvqy4rQTsUooBHxHVPZCCm9NogXe3bIjrzIz42RCjLe9etIoffJodGs
	 sWAeOerEN0Jmg==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2 06/10] vfio: Export vfio device get and put registration helpers
Date: Thu, 11 Sep 2025 14:33:10 +0300
Message-ID: <7b1739e21959ccc56c86658ea3516bd0d989ab86.1757589589.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757589589.git.leon@kernel.org>
References: <cover.1757589589.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vivek Kasireddy <vivek.kasireddy@intel.com>

These helpers are useful for managing additional references taken
on the device from other associated VFIO modules.

Original-patch-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/vfio_main.c | 2 ++
 include/linux/vfio.h     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 5046cae052224..2f0dcec67ffe3 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -171,11 +171,13 @@ void vfio_device_put_registration(struct vfio_device *device)
 	if (refcount_dec_and_test(&device->refcount))
 		complete(&device->comp);
 }
+EXPORT_SYMBOL_GPL(vfio_device_put_registration);
 
 bool vfio_device_try_get_registration(struct vfio_device *device)
 {
 	return refcount_inc_not_zero(&device->refcount);
 }
+EXPORT_SYMBOL_GPL(vfio_device_try_get_registration);
 
 /*
  * VFIO driver API
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index eb563f538dee5..217ba4ef17522 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -297,6 +297,8 @@ static inline void vfio_put_device(struct vfio_device *device)
 int vfio_register_group_dev(struct vfio_device *device);
 int vfio_register_emulated_iommu_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
+bool vfio_device_try_get_registration(struct vfio_device *device);
+void vfio_device_put_registration(struct vfio_device *device);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id);
 unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set);
-- 
2.51.0


