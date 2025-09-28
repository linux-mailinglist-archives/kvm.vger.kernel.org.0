Return-Path: <kvm+bounces-58945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 602ECBA72A1
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 16:54:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C95D217B6E7
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 14:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24AF02E0411;
	Sun, 28 Sep 2025 14:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q1BG/dW3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4D822FE0E;
	Sun, 28 Sep 2025 14:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759071099; cv=none; b=EWI+gicqhTWv6lZSapPXzLUGtmjdI6t2amIYzUK+QgXUS6RX4+qmjPmJLSEnsMuTcncRbOqs2EUn+OZb0j0TiH9xQHVQvLBIibsPWj6qcHxA4Q8v3pk6dHIKhdLj03jCjjRqrjZ+jEVisRsQjzrryrubh/vMOqI8Xda0CempWUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759071099; c=relaxed/simple;
	bh=isdw6kZ8FFhWQVC3bDpjETrpal4zAOBPlSaTyAj5wzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4pnwu9R4UsXCmBHidCPUb1zv0Bx/r2ULTt9E3hE4ehej6RLqMix8maQxMOp4cNqT/fMHNpnleYDWfXc3ro8JBChmrKu6VSIkDcqoXcL34GoVb3SzLNJun1I0THSKXhW6F1z3wKBwTRSHPv3xZ6VaNdxaQnp3MIO4op9mLMlaYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q1BG/dW3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118CEC4CEF0;
	Sun, 28 Sep 2025 14:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759071097;
	bh=isdw6kZ8FFhWQVC3bDpjETrpal4zAOBPlSaTyAj5wzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1BG/dW3MMEpKiBoxWpHfJqeMARlzNFZH44gJGE3WyaIqYUkpbkLrHOlNjgBk8l3B
	 K79RMwWDzKY9rwjxPRcXy+IWOatSDlm0WNCw9SnR+YljlPfMOgczoa5nlI7oUgi7Sj
	 UQAoXR3lLhNAd0YivYU3cm4zqXVUpMn2Y5wPoKBwqj8Pvyo9MmIssqLjzYZbl2Wzp4
	 DMImFauKBxnBz2yeyVgCUoUHvRQWeQqZ5Mfg1IpzBlT0lABuFhG+ttMofLklUfjaoB
	 mOqn1C7RPLvoON1fae2FqTHSG3ZYzdIqtmvqYciR2Ym3gUFFXWQQfLhFTObif1nKU/
	 kgGPoeD+32EDg==
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
Subject: [PATCH v4 06/10] vfio: Export vfio device get and put registration helpers
Date: Sun, 28 Sep 2025 17:50:16 +0300
Message-ID: <40c2a8507c5314f5008e07f4632a7dce3faf69e4.1759070796.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1759070796.git.leon@kernel.org>
References: <cover.1759070796.git.leon@kernel.org>
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
index 5046cae05222..2f0dcec67ffe 100644
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
index eb563f538dee..217ba4ef1752 100644
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


