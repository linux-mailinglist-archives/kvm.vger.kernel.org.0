Return-Path: <kvm+bounces-53913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50C1DB1A2A0
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 15:03:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E26AF7A987D
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 13:02:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 775A326FA67;
	Mon,  4 Aug 2025 13:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uPXz+dDM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5B42701D0;
	Mon,  4 Aug 2025 13:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754312483; cv=none; b=TR5gJMMaesAJ0cIWJGKrqX+C6VMhbJWadAjwlViCBS060A8xDHrBKeDkCqCQOjbFUSQNOQ7VY/PEs61MdthZ5w5NLFZEPEtBVV6iFi0/NnvMM/T7Klu38NSYonvr6Ji6TifPk88A5/bjOB7abLZBiMADucx5Wz+bjrNMD7VGP1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754312483; c=relaxed/simple;
	bh=SvWpwCR2Wh2zkNow/WohcCYMP4E/fUfFI3S/vqkvZcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lECKcQx8jEOb5HshL7WM5HxWL5mR51onpU7zJyrooJryLn6dO+cqhh41wSlSCSjlAsBnB34KSI/rRDgEDNy+6mMALCOHUFHNQGB730eVfm/fM3GxbqrH5l3uez3GzNaK8xdvvOhmr8waM9of6rmq83SilFC0V7NuvbyywX12qs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uPXz+dDM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999CDC4CEF0;
	Mon,  4 Aug 2025 13:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754312483;
	bh=SvWpwCR2Wh2zkNow/WohcCYMP4E/fUfFI3S/vqkvZcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uPXz+dDMAvSwAXGZh2jpBdnIGjP5/4P1Bi7fU4KjhDdrrUhmuS+1iwLBL5/Ch7nk2
	 yoSNA9Nqk0pwb6Qm8dTt9S7pGFBR7xRykO/XC8Uiyvhy+ynoAVH44BcG/ZX1xrgjRr
	 f7S5ch72l2xHSj/6lT+whhxF9B5bG6KmjYJAO73Fmp1/WoQ2Hb4aL4bB9D78/irFGp
	 JphMh1g0mUZplgv7y2OWfetRViBhbKCFDEAjIP7BKLkCY6NDnd1IpcspTkDAVZgS2T
	 un44QqqeeEqeR3lnRp4qaCLGlduD6sBnDTc2o9YBKANnMf+gPZLqYcG7UViKXRPDgK
	 quBdiV2/cmkoA==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>,
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
Subject: [PATCH v1 07/10] vfio: Export vfio device get and put registration helpers
Date: Mon,  4 Aug 2025 16:00:42 +0300
Message-ID: <c511efff1d080b1ec97fcb2b095571a89e8d8996.1754311439.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754311439.git.leon@kernel.org>
References: <cover.1754311439.git.leon@kernel.org>
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
index 1fd261efc582d..620a3ee5d04db 100644
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
index 707b00772ce1f..ba65bbdffd0b2 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -293,6 +293,8 @@ static inline void vfio_put_device(struct vfio_device *device)
 int vfio_register_group_dev(struct vfio_device *device);
 int vfio_register_emulated_iommu_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
+bool vfio_device_try_get_registration(struct vfio_device *device);
+void vfio_device_put_registration(struct vfio_device *device);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id);
 unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set);
-- 
2.50.1


