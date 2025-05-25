Return-Path: <kvm+bounces-47668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 48995AC32CC
	for <lists+kvm@lfdr.de>; Sun, 25 May 2025 09:50:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 228313B76F4
	for <lists+kvm@lfdr.de>; Sun, 25 May 2025 07:49:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B12A1A2632;
	Sun, 25 May 2025 07:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mzr6QEFm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65ACF136E37
	for <kvm@vger.kernel.org>; Sun, 25 May 2025 07:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748159398; cv=none; b=EJSoynvvCKiNY3cZ+WwDPfD53xl9Cn32mlcawDLYbYb9aTjABhY/Mue6B4yInAHZK53OONWbrq57RfiCl7nFH9sVzCK0/X3lkMqkCA4Hek27myeJSwnC7ivSderZkvYZM/cK5lIHe0yg/ENGlQXVgyB438qfemBls8v6j0SvjvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748159398; c=relaxed/simple;
	bh=1ug/0QmZuIF7HM5keJUFPz74h060eSieSGlO4xUik9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPLTVOgolvOqtn2FFd062caUWgZPV9xmfKDRSRTEwF371TKEtlfz1uhU+aLfWQok6pI58o+kv7Wuo5woCoNwzQ6PnLR7QYDQIEAsN4+zusjKn85Z++cexHGsfVf/7hBOAXOzvvquXKQb34f+9Cb60ic/sJWCl1Eb6U3s1HZIClA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mzr6QEFm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0DBC4CEED;
	Sun, 25 May 2025 07:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748159398;
	bh=1ug/0QmZuIF7HM5keJUFPz74h060eSieSGlO4xUik9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzr6QEFmVol4n3wH1vniRH3dwwBNS97eic13ea+rgWzJ3FyAMFRzIMp/FHDv7Dcye
	 CyYnUrmRiSKjJQodbCkHU6YP2gfsfv7lScG4tdcWGgSMXjOX89FDLaalDagE3yv9j6
	 nDZ1BpLf7Zsue3VdV65TgRzVKRagXsVttjPU/woKjQHd007WRQbmLgMlrmbwlEk29/
	 bdmWdsWZN9KHeps1sE2E5Id1k4EbDjxPnu2xynfg2/vX80wbErYNy+JCHV2/0b/+L9
	 X+V8IZaG0QAzrJBoAMg99KhqVWULQoxSsb+Ry1/ebjiZmISIMkeGxuaiJ4LVJynVQg
	 2MmAPZ9JufvyQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: kvm@vger.kernel.org
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [RFC PATCH kvmtool 08/10] vfio/iommufd: Move the hwpt allocation to helper
Date: Sun, 25 May 2025 13:19:14 +0530
Message-ID: <20250525074917.150332-8-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250525074917.150332-1-aneesh.kumar@kernel.org>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

alloc_hwpt.flags = 0; implies we prefer stage1 translation. Hence name
the helper iommufd_alloc_s2bypass_hwpt().

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 vfio/iommufd.c | 86 +++++++++++++++++++++++++++++---------------------
 1 file changed, 50 insertions(+), 36 deletions(-)

diff --git a/vfio/iommufd.c b/vfio/iommufd.c
index 3728a06cb318..742550705746 100644
--- a/vfio/iommufd.c
+++ b/vfio/iommufd.c
@@ -60,6 +60,54 @@ err_close_device:
 	return ret;
 }
 
+static int iommufd_alloc_s2bypass_hwpt(struct vfio_device *vdev)
+{
+	int ret;
+	struct iommu_hwpt_alloc alloc_hwpt;
+	struct vfio_device_bind_iommufd bind;
+	struct vfio_device_attach_iommufd_pt attach_data;
+
+	bind.argsz = sizeof(bind);
+	bind.flags = 0;
+	bind.iommufd = iommu_fd;
+
+	/* now bind the iommufd */
+	if (ioctl(vdev->fd, VFIO_DEVICE_BIND_IOMMUFD, &bind)) {
+		ret = -errno;
+		vfio_dev_err(vdev, "failed to get info");
+		goto err_out;
+	}
+
+	alloc_hwpt.size = sizeof(struct iommu_hwpt_alloc);
+	/* stage1 translate stage 2 bypass table if stage1 is supported */
+	alloc_hwpt.flags = 0;
+	alloc_hwpt.dev_id = bind.out_devid;
+	alloc_hwpt.pt_id = ioas_id;
+	alloc_hwpt.data_type = IOMMU_HWPT_DATA_NONE;
+	alloc_hwpt.data_len = 0;
+	alloc_hwpt.data_uptr = 0;
+
+	if (ioctl(iommu_fd, IOMMU_HWPT_ALLOC, &alloc_hwpt)) {
+		ret = -errno;
+		pr_err("Failed to allocate HWPT");
+		goto err_out;
+	}
+
+	attach_data.argsz = sizeof(attach_data);
+	attach_data.flags = 0;
+	attach_data.pt_id = alloc_hwpt.out_hwpt_id;
+
+	if (ioctl(vdev->fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_data)) {
+		ret = -errno;
+		vfio_dev_err(vdev, "failed to attach to IOAS ");
+		goto err_out;
+	}
+	return 0;
+
+err_out:
+	return ret;
+}
+
 static int iommufd_configure_device(struct kvm *kvm, struct vfio_device *vdev)
 {
 	int ret;
@@ -68,9 +116,6 @@ static int iommufd_configure_device(struct kvm *kvm, struct vfio_device *vdev)
 	bool found_dev = false;
 	char pci_dev_path[PATH_MAX];
 	char vfio_dev_path[PATH_MAX];
-	struct iommu_hwpt_alloc alloc_hwpt;
-	struct vfio_device_bind_iommufd bind;
-	struct vfio_device_attach_iommufd_pt attach_data;
 
 	ret = snprintf(pci_dev_path, PATH_MAX, "%s/vfio-dev/", vdev->sysfs_path);
 	if (ret < 0 || ret == PATH_MAX)
@@ -115,40 +160,9 @@ static int iommufd_configure_device(struct kvm *kvm, struct vfio_device *vdev)
 		goto err_close_device;
 	}
 
-	bind.argsz = sizeof(bind);
-	bind.flags = 0;
-	bind.iommufd = iommu_fd;
-
-	/* now bind the iommufd */
-	if (ioctl(vdev->fd, VFIO_DEVICE_BIND_IOMMUFD, &bind)) {
-		ret = -errno;
-		vfio_dev_err(vdev, "failed to get info");
-		goto err_close_device;
-	}
-
-	alloc_hwpt.size = sizeof(struct iommu_hwpt_alloc);
-	alloc_hwpt.flags = 0;
-	alloc_hwpt.dev_id = bind.out_devid;
-	alloc_hwpt.pt_id = ioas_id;
-	alloc_hwpt.data_type = IOMMU_HWPT_DATA_NONE;
-	alloc_hwpt.data_len = 0;
-	alloc_hwpt.data_uptr = 0;
-
-	if (ioctl(iommu_fd, IOMMU_HWPT_ALLOC, &alloc_hwpt)) {
-		ret = -errno;
-		pr_err("Failed to allocate HWPT");
-		goto err_close_device;
-	}
-
-	attach_data.argsz = sizeof(attach_data);
-	attach_data.flags = 0;
-	attach_data.pt_id = alloc_hwpt.out_hwpt_id;
-
-	if (ioctl(vdev->fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_data)) {
-		ret = -errno;
-		vfio_dev_err(vdev, "failed to attach to IOAS ");
+	ret = iommufd_alloc_s2bypass_hwpt(vdev);
+	if (ret)
 		goto err_close_device;
-	}
 
 	closedir(dir);
 	return __iommufd_configure_device(kvm, vdev);
-- 
2.43.0


