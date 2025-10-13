Return-Path: <kvm+bounces-59914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D79F5BD483E
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 17:49:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EFCE454784B
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 15:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EB41313E37;
	Mon, 13 Oct 2025 15:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hU07OA84"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EB0312823;
	Mon, 13 Oct 2025 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369207; cv=none; b=AQmTy1Drlp0H2dBj/emuYRGU3WAfyh9FjQnYBp4ligozijtuYzJq2B0kZHoPTJojhbELn/jF05PwnwAcJafVFMPsOaeU7cSDuDpI2TQTi6RNHpop4Qabi5oVNs4zxS6soMmmHaCg8YA6eQpqesml5oB766eHTlOxEWF4n+wEqmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369207; c=relaxed/simple;
	bh=OVKSxkqNx5xaHu4z7h221RNhnqfR95e6/sS/QJ/Ow+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3rpjfsguHhzSfkYX5VDYXT6IFbuTfzsZPFwToNHxiudh9khJyOXQ+cMFqBzGZAYrFF/YS/z8D8DaTPxV6jPDLwfhp73Ll4HCKd2fP1BUXeWa3npmJ7zA+nqjcrQc42bQXU2OJdMwonjHZoRNIT6RsiLLNLi66uBQV0ise9G1rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hU07OA84; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B086DC16AAE;
	Mon, 13 Oct 2025 15:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760369207;
	bh=OVKSxkqNx5xaHu4z7h221RNhnqfR95e6/sS/QJ/Ow+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hU07OA840mPC8nIqDvgUkFrQK1ylpRq/rsqQrQaGDWaU03D7b8rgS3C97iQw/udUl
	 3NSnEHDvngRAdFmBJfNS7DNAnurv0IHuFVBDZLtMSBtETwHHX8BXIUoAhPWaKPHSc0
	 xM8SfkIqhTuNdMCdYE+VTrovdZdQcGFBwT/w5wBViNdvqRNCNA7CdasIYxwsWBiM7m
	 UfQ+BnlGr0iCYXnIupzJo8tqWsZqvYSRQPl/qKkl6/9Wc5hIUYS2PypcMAqHoBzSGr
	 QIgMeIeDDVN+ZjQL8jPW4Jne8q0FQEzaiy5qqboSnOQBau+WHNsuw1rLos6pADSeBY
	 Zywx646Qcxvmw==
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
Subject: [PATCH v5 6/9] vfio: Export vfio device get and put registration helpers
Date: Mon, 13 Oct 2025 18:26:08 +0300
Message-ID: <67fc8a91a1a047c83455721d28058a1cc86b003f.1760368250.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1760368250.git.leon@kernel.org>
References: <cover.1760368250.git.leon@kernel.org>
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
index 38c8e9350a60..9aa4a5d081e8 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -172,11 +172,13 @@ void vfio_device_put_registration(struct vfio_device *device)
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


