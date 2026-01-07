Return-Path: <kvm+bounces-67267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A5E4DCFFF5A
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 21:18:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 616D03009210
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 20:18:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F43833A6FE;
	Wed,  7 Jan 2026 20:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fEI3bV+h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802AE3396F8
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 20:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817091; cv=none; b=hLfrRq++nMCLBA+t6tNqSuEQmNMn3vLIog7Viuf+nHTalmIQKtTTQnUFZnhqBUlACFAfRE0ZE6nKLzM+G7iALNsKFTPJe9YYZxVs4CsMPgRReBiDDlRWWtr/ApY8cAo5JypHFOs8e4C2K3R9Ox9wtLu4zngJeQBB4v4o3H55ZZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817091; c=relaxed/simple;
	bh=hUn7TlBmNUdymtQg3Kq9wRTksnPrB1glAZZeGAPR86s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mx2CiC26OPu4YmVK+gAiHf1kcQkl82QYXl9bY6kPqzELRA/OdshpmIrs54jdPvGZvkKABtDEiLU9Kz0/mpGixeSiWmCIOa6kaov/ZiPR4GNNRTD9r3DQ9+akH29KtQuNXswTsYeZvFiufJIJxwAAcyPP2LGkL8u+4QrN9i01F8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fEI3bV+h; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c387d3eb6so2156148a91.2
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 12:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767817087; x=1768421887; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6zK+/AslzkBPlSJC8UvJQiRH9fqye6KU8Yh2AdIhmFE=;
        b=fEI3bV+hXrU7ePKTI4LcQQozaMA6JOZr6r/H7QyUz7TuPHk0M+wHIDNkq1+xqBE8pM
         q8XcF3LVV4rLtaH8FurPuaKcO5rK6qMGXkWdPFiTX74a/UudA3GxG25FA0ViCUC8MEuw
         tAzI2zWY0LIL6UjW+YL0tBIrkP7GoArngvEdHpJ/CoQXwZjD2nSgohd8bdQ8lxH2dkGg
         EGRiBw60udedDyOGzjeB7FfKPxIKtnK8XPhIi22fhCaktuozv6hsyxN73TjQGltncZle
         V3SPrRslTGhoIPlPNRowUR8tnvkCCEu1PAOvb85iqPDM39Bwng7N7S1Ww+uX9DC73kNg
         4wDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817087; x=1768421887;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6zK+/AslzkBPlSJC8UvJQiRH9fqye6KU8Yh2AdIhmFE=;
        b=O1XFt/YjsLo8v9jdrCnwcxIrJgsdVZl9U1fvj1Fu1QgFn6FLWU0cDxznBJ9tAPxbST
         mw9HM9oOs7q4dfu/GsAPSBLDikW0mIyplZOYASdwUZtAxGzH398B9KRsbWatIUf/NJwm
         GMuEonHqbwISI+6Egy1UavxIwgThs+auG/3uPNOzHOUGXh1uZIWe2Wnbr9Ma4XzwpmVn
         E6JgQXAV0mZK0IzS3KaaWzNFDnUOYhuKF5VdawXWvyyCrhW1PgBj80Jm48kM97w/w/9W
         1zHShvBTuW985XHa7AK0CuX2TFC8UO29AVUWtFAbSzNxqgtlGvKfeOmrlJ2yZ0W/JjCp
         f1QQ==
X-Forwarded-Encrypted: i=1; AJvYcCURLD9ZU0FpZWviE4rCL82M5Oni++fKt0RqhURH1q85DLVJbqcydX9Hro3b8nzNAI6YJLI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnAoDDO+KOLPANShoPUSlAFbwQ3XTkv1ucaRMcSDFbh31s87Oi
	zVQRKWIYybyquRAK37z4YGaYp4JvgER491xIbiuyKJUyjPGt1PAKz9whzL/epmyYuxuDg9GaIBH
	gw16wqZObbMpuyA==
X-Google-Smtp-Source: AGHT+IHThLlbeg0Bz0L6XHahvlrl4KT7b217LsvR54vbtTKdYnIle66+HnkOhYRBZx9jZcBHpKpDIq/Pi3rfmQ==
X-Received: from pjbhl15.prod.google.com ([2002:a17:90b:134f:b0:34c:2778:11c5])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2642:b0:32b:9774:d340 with SMTP id 98e67ed59e1d1-34f68c47f38mr2755853a91.33.1767817086729;
 Wed, 07 Jan 2026 12:18:06 -0800 (PST)
Date: Wed,  7 Jan 2026 20:17:59 +0000
In-Reply-To: <20260107201800.2486137-1-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260107201800.2486137-1-skhawaja@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260107201800.2486137-3-skhawaja@google.com>
Subject: [PATCH 2/3] vfio: selftests: Add support of creating iommus from iommufd
From: Samiullah Khawaja <skhawaja@google.com>
To: David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	David Matlack <dmatlack@google.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, Robin Murphy <robin.murphy@arm.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

Add API to init a struct iommu using an already opened iommufd instance
and attach devices to it.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 .../vfio/lib/include/libvfio/iommu.h          |  2 +
 .../lib/include/libvfio/vfio_pci_device.h     |  2 +
 tools/testing/selftests/vfio/lib/iommu.c      | 60 +++++++++++++++++--
 .../selftests/vfio/lib/vfio_pci_device.c      | 16 ++++-
 4 files changed, 74 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h b/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
index 5c9b9dc6d993..9e96da1e6fd3 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
@@ -29,10 +29,12 @@ struct iommu {
 	int container_fd;
 	int iommufd;
 	u32 ioas_id;
+	u32 hwpt_id;
 	struct list_head dma_regions;
 };
 
 struct iommu *iommu_init(const char *iommu_mode);
+struct iommu *iommufd_iommu_init(int iommufd, u32 dev_id);
 void iommu_cleanup(struct iommu *iommu);
 
 int __iommu_map(struct iommu *iommu, struct dma_region *region);
diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
index 2858885a89bb..1143ceb6a9b8 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
@@ -19,6 +19,7 @@ struct vfio_pci_device {
 	const char *bdf;
 	int fd;
 	int group_fd;
+	u32 dev_id;
 
 	struct iommu *iommu;
 
@@ -65,6 +66,7 @@ void vfio_pci_config_access(struct vfio_pci_device *device, bool write,
 #define vfio_pci_config_writew(_d, _o, _v) vfio_pci_config_write(_d, _o, _v, u16)
 #define vfio_pci_config_writel(_d, _o, _v) vfio_pci_config_write(_d, _o, _v, u32)
 
+void vfio_pci_device_attach_iommu(struct vfio_pci_device *device, struct iommu *iommu);
 void vfio_pci_irq_enable(struct vfio_pci_device *device, u32 index,
 			 u32 vector, int count);
 void vfio_pci_irq_disable(struct vfio_pci_device *device, u32 index);
diff --git a/tools/testing/selftests/vfio/lib/iommu.c b/tools/testing/selftests/vfio/lib/iommu.c
index 58b7fb7430d4..2c67d7e24d0c 100644
--- a/tools/testing/selftests/vfio/lib/iommu.c
+++ b/tools/testing/selftests/vfio/lib/iommu.c
@@ -408,6 +408,18 @@ struct iommu_iova_range *iommu_iova_ranges(struct iommu *iommu, u32 *nranges)
 	return ranges;
 }
 
+static u32 iommufd_hwpt_alloc(struct iommu *iommu, u32 dev_id)
+{
+	struct iommu_hwpt_alloc args = {
+		.size = sizeof(args),
+		.pt_id = iommu->ioas_id,
+		.dev_id = dev_id,
+	};
+
+	ioctl_assert(iommu->iommufd, IOMMU_HWPT_ALLOC, &args);
+	return args.out_hwpt_id;
+}
+
 static u32 iommufd_ioas_alloc(int iommufd)
 {
 	struct iommu_ioas_alloc args = {
@@ -418,11 +430,9 @@ static u32 iommufd_ioas_alloc(int iommufd)
 	return args.out_ioas_id;
 }
 
-struct iommu *iommu_init(const char *iommu_mode)
+static struct iommu *iommu_alloc(const char *iommu_mode)
 {
-	const char *container_path;
 	struct iommu *iommu;
-	int version;
 
 	iommu = calloc(1, sizeof(*iommu));
 	VFIO_ASSERT_NOT_NULL(iommu);
@@ -430,6 +440,16 @@ struct iommu *iommu_init(const char *iommu_mode)
 	INIT_LIST_HEAD(&iommu->dma_regions);
 
 	iommu->mode = lookup_iommu_mode(iommu_mode);
+	return iommu;
+}
+
+struct iommu *iommu_init(const char *iommu_mode)
+{
+	const char *container_path;
+	struct iommu *iommu;
+	int version;
+
+	iommu = iommu_alloc(iommu_mode);
 
 	container_path = iommu->mode->container_path;
 	if (container_path) {
@@ -453,10 +473,42 @@ struct iommu *iommu_init(const char *iommu_mode)
 	return iommu;
 }
 
+struct iommu *iommufd_iommu_init(int iommufd, u32 dev_id)
+{
+	struct iommu *iommu;
+
+	iommu = iommu_alloc("iommufd");
+
+	iommu->iommufd = dup(iommufd);
+	VFIO_ASSERT_GT(iommu->iommufd, 0);
+
+	iommu->ioas_id = iommufd_ioas_alloc(iommu->iommufd);
+	iommu->hwpt_id = iommufd_hwpt_alloc(iommu, dev_id);
+
+	return iommu;
+}
+
+static void iommufd_iommu_cleanup(struct iommu *iommu)
+{
+	struct iommu_destroy args = {
+		.size = sizeof(args),
+	};
+
+	if (iommu->hwpt_id) {
+		args.id = iommu->hwpt_id;
+		ioctl_assert(iommu->iommufd, IOMMU_DESTROY, &args);
+	}
+
+	args.id = iommu->ioas_id;
+	ioctl_assert(iommu->iommufd, IOMMU_DESTROY, &args);
+
+	VFIO_ASSERT_EQ(close(iommu->iommufd), 0);
+}
+
 void iommu_cleanup(struct iommu *iommu)
 {
 	if (iommu->iommufd)
-		VFIO_ASSERT_EQ(close(iommu->iommufd), 0);
+		iommufd_iommu_cleanup(iommu);
 	else
 		VFIO_ASSERT_EQ(close(iommu->container_fd), 0);
 
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index fac4c0ecadef..9bc1f5ade5c4 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -298,7 +298,7 @@ const char *vfio_pci_get_cdev_path(const char *bdf)
 	return cdev_path;
 }
 
-static void vfio_device_bind_iommufd(int device_fd, int iommufd)
+static int vfio_device_bind_iommufd(int device_fd, int iommufd)
 {
 	struct vfio_device_bind_iommufd args = {
 		.argsz = sizeof(args),
@@ -306,6 +306,7 @@ static void vfio_device_bind_iommufd(int device_fd, int iommufd)
 	};
 
 	ioctl_assert(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &args);
+	return args.out_devid;
 }
 
 static void vfio_device_attach_iommufd_pt(int device_fd, u32 pt_id)
@@ -326,10 +327,21 @@ static void vfio_pci_iommufd_setup(struct vfio_pci_device *device, const char *b
 	VFIO_ASSERT_GE(device->fd, 0);
 	free((void *)cdev_path);
 
-	vfio_device_bind_iommufd(device->fd, device->iommu->iommufd);
+	device->dev_id = vfio_device_bind_iommufd(device->fd, device->iommu->iommufd);
 	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
 }
 
+void vfio_pci_device_attach_iommu(struct vfio_pci_device *device, struct iommu *iommu)
+{
+	u32 pt_id = iommu->ioas_id;
+
+	if (iommu->hwpt_id)
+		pt_id = iommu->hwpt_id;
+
+	VFIO_ASSERT_NE(pt_id, 0);
+	vfio_device_attach_iommufd_pt(device->fd, pt_id);
+}
+
 struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu)
 {
 	struct vfio_pci_device *device;
-- 
2.52.0.351.gbe84eed79e-goog


