Return-Path: <kvm+bounces-61307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DB927C15BE4
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 17:20:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 709944F0D77
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 16:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1CB7283C9E;
	Tue, 28 Oct 2025 16:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="HLiwrOcF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE33B3446C5
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 16:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761668118; cv=none; b=Cg+rny9d1zh+UVR+yDBx4FXmKQr43SOuO83xmyJuf+2amDF2cXk8+gVqljYZNTsyhoPOe5cOvRy9Dyo3pfiWqPhKSHkyNdmPVtXLRGUaOOyT0PlvrZEVR5A10aYKD/3gF7ljO17T2ajyXucZ9v5kQi5LMowYA8dY2NWFuBa2DKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761668118; c=relaxed/simple;
	bh=58UJV8Jomnww3/4xmMaH1WPBBt+aEgJfVLp6+UgTH8U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=pFgzIHBLQmT6ys+G/KMrciSvHZXr+ItRnuaf+rBMwH5tmzem6EduY73R/zJAaCfTuTHwWAE4GTSChQ7fqUS3MXgXL5xTuDD2WFf8ifwaTI/6x/e1ifk6Kqb6jc3coSGQMeuyA3oygUdp2uEeDbLEfyLPhqjFwVY4QFCWZYuitGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=HLiwrOcF; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59SDI1Qj471239
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 09:15:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=GrjI71Ph4wCt61whNKp0lSntFbHA1PCFmc6ms15PM/s=; b=HLiwrOcFib4g
	mGGEgH2K3x9bZbBu3jeuYEtd/Z1Li290yvlTVi0/6qiiyoZDttQfC+SPA2jqv6EV
	H9Rjz7ow4dkPDuqVQxAE5vhi/8qQSfdmtQ+0U+/PJW6TdILI8AuvAd4ykcbJ7eL/
	Wt7WDEDaj4Gn5iXhttx5lK+HaNm9SjaLQeeNpNYOafvOOcO61XtGrlv/6y1SO0gu
	Vcm07LrBXh9GFYsYxkVKR2e8sZxuZiiz+KZ1mS1Gg5JZW1OcVMkXAQFZFzmy4E2X
	NYGTizxmH2l19E6FKq32yqZx89AcnkUsqILjIJHcFz1ThX8wzCemJiHUCwg8NbZ2
	2cF2YiCCug==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a2xkhhq1h-14
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 09:15:15 -0700 (PDT)
Received: from twshared15465.32.frc3.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Tue, 28 Oct 2025 16:15:09 +0000
Received: by devgpu012.nha5.facebook.com (Postfix, from userid 28580)
	id 05ACF51293B; Tue, 28 Oct 2025 09:15:05 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
Date: Tue, 28 Oct 2025 09:15:03 -0700
Subject: [PATCH v6 4/5] vfio: selftests: update DMA map/unmap helpers to
 support more test kinds
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20251028-fix-unmap-v6-4-2542b96bcc8e@fb.com>
References: <20251028-fix-unmap-v6-0-2542b96bcc8e@fb.com>
In-Reply-To: <20251028-fix-unmap-v6-0-2542b96bcc8e@fb.com>
To: Alex Williamson <alex@shazbot.org>
CC: Jason Gunthorpe <jgg@ziepe.ca>,
        Alejandro Jimenez
	<alejandro.j.jimenez@oracle.com>,
        David Matlack <dmatlack@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Alex Mastro
	<amastro@fb.com>
X-Mailer: b4 0.13.0
X-FB-Internal: Safe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDEzNyBTYWx0ZWRfXxGg4seHry2/B
 UVavUkmxDe0YXKqJyIP021x3/TQKS0+hACUljRWF4OwSANbtWZcjQG5VX43TJh3uTY9QaQ/1mHN
 FJRor8VPVZ5llFzucyTbqMBjcI0gLy7uJGAIZwYualww9wvMGLz4GatuI+XWIo69u79gng+Ilua
 Mz4a1+48AspB9DMzE87f3/rytsHRLHTilWzzAGYgiguGOOQq7UOCNW+4zuKtdtGqrQJdEi2PssB
 RtSGxiHaUCuALpxCxtPDgjh2uR+RSny78NFZSEl4eDhUXq/3GHnOu8JmPCT+7W748d4iBlZlUm9
 1MAdDEcGnsJ8riF9Oqj/mMNbbknmnDlaZHx9Kur9H+GtYppshlbaZ+zrUPcpG3BoDoKQb8ERJ3b
 9E+XOUccryoK175/UN59xVqx1fXcAA==
X-Proofpoint-GUID: MeZ5aEWrzAy2RVm4rG1SoVYp1z1Y-Tn9
X-Authority-Analysis: v=2.4 cv=Uspu9uwB c=1 sm=1 tr=0 ts=6900ec13 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=FOH2dFAWAAAA:8 a=QPJBnxU05y6f-KHllaYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: MeZ5aEWrzAy2RVm4rG1SoVYp1z1Y-Tn9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_06,2025-10-22_01,2025-03-28_01

Add __vfio_pci_dma_*() helpers which return -errno from the underlying
ioctls.

Add __vfio_pci_dma_unmap_all() to test more unmapping code paths. Add an
out unmapped arg to report the unmapped byte size.

The existing vfio_pci_dma_*() functions, which are intended for
happy-path usage (assert on failure) are now thin wrappers on top of the
double-underscore helpers.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Alex Mastro <amastro@fb.com>
---
 .../testing/selftests/vfio/lib/include/vfio_util.h |  27 +++++-
 tools/testing/selftests/vfio/lib/vfio_pci_device.c | 104 ++++++++++++++++-----
 .../testing/selftests/vfio/vfio_dma_mapping_test.c |   5 +-
 3 files changed, 108 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index ed31606e01b7..240409bf5f8a 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -206,10 +206,29 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_
 void vfio_pci_device_cleanup(struct vfio_pci_device *device);
 void vfio_pci_device_reset(struct vfio_pci_device *device);
 
-void vfio_pci_dma_map(struct vfio_pci_device *device,
-		      struct vfio_dma_region *region);
-void vfio_pci_dma_unmap(struct vfio_pci_device *device,
-			struct vfio_dma_region *region);
+int __vfio_pci_dma_map(struct vfio_pci_device *device,
+		       struct vfio_dma_region *region);
+int __vfio_pci_dma_unmap(struct vfio_pci_device *device,
+			 struct vfio_dma_region *region,
+			 u64 *unmapped);
+int __vfio_pci_dma_unmap_all(struct vfio_pci_device *device, u64 *unmapped);
+
+static inline void vfio_pci_dma_map(struct vfio_pci_device *device,
+				    struct vfio_dma_region *region)
+{
+	VFIO_ASSERT_EQ(__vfio_pci_dma_map(device, region), 0);
+}
+
+static inline void vfio_pci_dma_unmap(struct vfio_pci_device *device,
+				      struct vfio_dma_region *region)
+{
+	VFIO_ASSERT_EQ(__vfio_pci_dma_unmap(device, region, NULL), 0);
+}
+
+static inline void vfio_pci_dma_unmap_all(struct vfio_pci_device *device)
+{
+	VFIO_ASSERT_EQ(__vfio_pci_dma_unmap_all(device, NULL), 0);
+}
 
 void vfio_pci_config_access(struct vfio_pci_device *device, bool write,
 			    size_t config, size_t size, void *data);
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 0921b2451ba5..a381fd253aa7 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -2,6 +2,7 @@
 #include <dirent.h>
 #include <fcntl.h>
 #include <libgen.h>
+#include <stdint.h>
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
@@ -141,7 +142,7 @@ static void vfio_pci_irq_get(struct vfio_pci_device *device, u32 index,
 	ioctl_assert(device->fd, VFIO_DEVICE_GET_IRQ_INFO, irq_info);
 }
 
-static void vfio_iommu_dma_map(struct vfio_pci_device *device,
+static int vfio_iommu_dma_map(struct vfio_pci_device *device,
 			       struct vfio_dma_region *region)
 {
 	struct vfio_iommu_type1_dma_map args = {
@@ -152,10 +153,13 @@ static void vfio_iommu_dma_map(struct vfio_pci_device *device,
 		.size = region->size,
 	};
 
-	ioctl_assert(device->container_fd, VFIO_IOMMU_MAP_DMA, &args);
+	if (ioctl(device->container_fd, VFIO_IOMMU_MAP_DMA, &args))
+		return -errno;
+
+	return 0;
 }
 
-static void iommufd_dma_map(struct vfio_pci_device *device,
+static int iommufd_dma_map(struct vfio_pci_device *device,
 			    struct vfio_dma_region *region)
 {
 	struct iommu_ioas_map args = {
@@ -169,54 +173,108 @@ static void iommufd_dma_map(struct vfio_pci_device *device,
 		.ioas_id = device->ioas_id,
 	};
 
-	ioctl_assert(device->iommufd, IOMMU_IOAS_MAP, &args);
+	if (ioctl(device->iommufd, IOMMU_IOAS_MAP, &args))
+		return -errno;
+
+	return 0;
 }
 
-void vfio_pci_dma_map(struct vfio_pci_device *device,
+int __vfio_pci_dma_map(struct vfio_pci_device *device,
 		      struct vfio_dma_region *region)
 {
+	int ret;
+
 	if (device->iommufd)
-		iommufd_dma_map(device, region);
+		ret = iommufd_dma_map(device, region);
 	else
-		vfio_iommu_dma_map(device, region);
+		ret = vfio_iommu_dma_map(device, region);
+
+	if (ret)
+		return ret;
 
 	list_add(&region->link, &device->dma_regions);
+
+	return 0;
 }
 
-static void vfio_iommu_dma_unmap(struct vfio_pci_device *device,
-				 struct vfio_dma_region *region)
+static int vfio_iommu_dma_unmap(int fd, u64 iova, u64 size, u32 flags,
+				u64 *unmapped)
 {
 	struct vfio_iommu_type1_dma_unmap args = {
 		.argsz = sizeof(args),
-		.iova = region->iova,
-		.size = region->size,
+		.iova = iova,
+		.size = size,
+		.flags = flags,
 	};
 
-	ioctl_assert(device->container_fd, VFIO_IOMMU_UNMAP_DMA, &args);
+	if (ioctl(fd, VFIO_IOMMU_UNMAP_DMA, &args))
+		return -errno;
+
+	if (unmapped)
+		*unmapped = args.size;
+
+	return 0;
 }
 
-static void iommufd_dma_unmap(struct vfio_pci_device *device,
-			      struct vfio_dma_region *region)
+static int iommufd_dma_unmap(int fd, u64 iova, u64 length, u32 ioas_id,
+			     u64 *unmapped)
 {
 	struct iommu_ioas_unmap args = {
 		.size = sizeof(args),
-		.iova = region->iova,
-		.length = region->size,
-		.ioas_id = device->ioas_id,
+		.iova = iova,
+		.length = length,
+		.ioas_id = ioas_id,
 	};
 
-	ioctl_assert(device->iommufd, IOMMU_IOAS_UNMAP, &args);
+	if (ioctl(fd, IOMMU_IOAS_UNMAP, &args))
+		return -errno;
+
+	if (unmapped)
+		*unmapped = args.length;
+
+	return 0;
 }
 
-void vfio_pci_dma_unmap(struct vfio_pci_device *device,
-			struct vfio_dma_region *region)
+int __vfio_pci_dma_unmap(struct vfio_pci_device *device,
+			 struct vfio_dma_region *region, u64 *unmapped)
 {
+	int ret;
+
+	if (device->iommufd)
+		ret = iommufd_dma_unmap(device->iommufd, region->iova,
+					region->size, device->ioas_id,
+					unmapped);
+	else
+		ret = vfio_iommu_dma_unmap(device->container_fd, region->iova,
+					   region->size, 0, unmapped);
+
+	if (ret)
+		return ret;
+
+	list_del_init(&region->link);
+
+	return 0;
+}
+
+int __vfio_pci_dma_unmap_all(struct vfio_pci_device *device, u64 *unmapped)
+{
+	int ret;
+	struct vfio_dma_region *curr, *next;
+
 	if (device->iommufd)
-		iommufd_dma_unmap(device, region);
+		ret = iommufd_dma_unmap(device->iommufd, 0, UINT64_MAX,
+					device->ioas_id, unmapped);
 	else
-		vfio_iommu_dma_unmap(device, region);
+		ret = vfio_iommu_dma_unmap(device->container_fd, 0, 0,
+					   VFIO_DMA_UNMAP_FLAG_ALL, unmapped);
+
+	if (ret)
+		return ret;
+
+	list_for_each_entry_safe(curr, next, &device->dma_regions, link)
+		list_del_init(&curr->link);
 
-	list_del(&region->link);
+	return 0;
 }
 
 static void vfio_pci_region_get(struct vfio_pci_device *device, int index,
diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
index ab19c54a774d..a38966e8e5a6 100644
--- a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
+++ b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
@@ -129,6 +129,7 @@ TEST_F(vfio_dma_mapping_test, dma_map_unmap)
 	struct vfio_dma_region region;
 	struct iommu_mapping mapping;
 	u64 mapping_size = size;
+	u64 unmapped;
 	int rc;
 
 	region.vaddr = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, -1, 0);
@@ -184,7 +185,9 @@ TEST_F(vfio_dma_mapping_test, dma_map_unmap)
 	}
 
 unmap:
-	vfio_pci_dma_unmap(self->device, &region);
+	rc = __vfio_pci_dma_unmap(self->device, &region, &unmapped);
+	ASSERT_EQ(rc, 0);
+	ASSERT_EQ(unmapped, region.size);
 	printf("Unmapped IOVA 0x%lx\n", region.iova);
 	ASSERT_EQ(INVALID_IOVA, __to_iova(self->device, region.vaddr));
 	ASSERT_NE(0, iommu_mapping_get(device_bdf, region.iova, &mapping));

-- 
2.47.3


