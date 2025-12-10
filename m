Return-Path: <kvm+bounces-65675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 49A56CB3BB6
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 19:14:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 388B8301C08C
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 18:14:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D86329E4C;
	Wed, 10 Dec 2025 18:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WkuUMxXK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1559322B8C
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 18:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765390467; cv=none; b=KfD8/QctlTb+b2ynPjxzBeT0qQkDneTy/WRzYKesbsXk87MaywNJJem+55Gcr9XY/5FpGuwly7jQ3v1s31643/ekjDwvqA0c1HduUYV9MnP0LdYzFB0dG7mePt14bP6TpYlAT+Q0Bd/RgygVd3PB87thwn4uEKuAviORzlRRG7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765390467; c=relaxed/simple;
	bh=JW2tTbcIH9EEyXRToUoNxG+ERli4JmNx0hWIw6Yzw+A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pLem4X6GM7gYajrFCNdjPG+SInzmJAkmlxGaR1eYzaI9/gfqVGn7+gfD7zuuLd8UJFo4csxG971Ogte+Y91vGOfFhcuzBMMX+d3LiCT0MTmDXO5/frNJoqogNotsDamVtEmIQyOAhOR5VH7dUyU82Jg9WtRnjlhk6nlL3mISBD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WkuUMxXK; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-6574475208eso66790eaf.3
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 10:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765390465; x=1765995265; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=168r6GWEsV32677D69udXhu4G6miZjg9d8osoe8KIxQ=;
        b=WkuUMxXKdc5wQOjd4Fafv/PdpX6pFtowikGPfYMpBmFTUnYqbGyZVGMfj2fxOJm9A9
         3NYGGDOHO98f0GwqKLicHllqkcT4vw/kK2UVIxhi/G/Jh9FBjv/sxlYF7dE7D3oWfAzO
         E4g8ve5gumTKTIdiKHAfe8Cowo/JtaV+Ka2JzfDFmq/HkdOE4BxyGAN0tCQ8YpNz3BHk
         toqeLb1hgSPA6j1cHeMP2R0l2bUNt+zIlrYwv2t/MP6iasBO2ZHSrzwQcvz2Y4P2rGCI
         KP3bX30QReWqgxdTc9JxoQBF+8uQLQJ2DbMyXYaOlmESAxdOaUmLNOO0DtLN3ieJgHWb
         8yWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765390465; x=1765995265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=168r6GWEsV32677D69udXhu4G6miZjg9d8osoe8KIxQ=;
        b=ZVH1ztdQ0J3rcEmwxW/PgkTlm6gRB0m5GqtmwvhoKkCof863d7j/uP4ozS/WQWC0DM
         BVzUdoiGAkHKRN1m6eSn4eK8SPrwv+FIVg/kcQd1OqDbFb59b23Th1vsZkaIFQMUZFd1
         sbZBJvK3F9TXwKAJz0pbtgs9ZZtToivbJwhkJH6PkBvmi9eQyPqioYLi7qo6BtzTFnOr
         PFmvw/1H/fy/ERoGySxQjjqKkyMwd87hUk0NoTeVcFhXrDvR7F2aUG5NATdcp9rztoy9
         bFkHbPQ3FSJaU/rPzlzVArik8q6rDszSK6vb0TAR+jUbPs+PSSAxa8mqzTOQlaNaxpMB
         UFnA==
X-Forwarded-Encrypted: i=1; AJvYcCUks8Mtgsw7srTOf++KlYlw+hXhjVCYoYH4/hp4rBydSAwOv3LyNSnPWznvckn4dgc9YyU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8o3npAsG+/nvw25KxCV41Y7Djxi7v03tfRZA8DfkKSPEgdmBD
	i5gjINMAZoKvXVsOeq3MUW71VeuWgBBMnAFEZooqLz7ApExNCWHox37SvucDGuRvqJulbFPh0y8
	QkKpets+I6Q==
X-Google-Smtp-Source: AGHT+IF1iaf5yxFXv//JDSg0yT6uFqXirv+dwMapWnO8hIFHxEP4/ISw2Vf6RwskJbffES3r6mEXUh7ZUBhI
X-Received: from ilbbd1.prod.google.com ([2002:a05:6e02:3001:b0:438:1576:ce32])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:81d8:b0:659:9a49:908d
 with SMTP id 006d021491bc7-65b2ac06718mr1994513eaf.12.1765390464773; Wed, 10
 Dec 2025 10:14:24 -0800 (PST)
Date: Wed, 10 Dec 2025 18:14:15 +0000
In-Reply-To: <20251210181417.3677674-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251210181417.3677674-1-rananta@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251210181417.3677674-5-rananta@google.com>
Subject: [PATCH v2 4/6] vfio: selftests: Export more vfio_pci functions
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>, 
	Alex Williamson <alex.williamson@redhat.com>
Cc: Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Refactor and make the functions called under device initialization
public. A later patch adds a test that calls these functions to validate
the UAPI of SR-IOV devices. Opportunistically, to test the success
and failure cases of the UAPI, split the functions dealing with
VFIO_GROUP_GET_DEVICE_FD and VFIO_DEVICE_BIND_IOMMUFD into a core
function and another one that asserts the ioctl. The former will be
used for testing the SR-IOV UAPI, hence only export these.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../lib/include/libvfio/vfio_pci_device.h     |  7 +++
 .../selftests/vfio/lib/vfio_pci_device.c      | 44 ++++++++++++++-----
 2 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
index 2858885a89bbb..6186ca463ca6e 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
@@ -122,4 +122,11 @@ static inline bool vfio_pci_device_match(struct vfio_pci_device *device,
 
 const char *vfio_pci_get_cdev_path(const char *bdf);
 
+void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf);
+void __vfio_pci_group_get_device_fd(struct vfio_pci_device *device,
+				    const char *bdf, const char *vf_token);
+void vfio_container_set_iommu(struct vfio_pci_device *device);
+void vfio_pci_iommufd_cdev_open(struct vfio_pci_device *device, const char *bdf);
+int __vfio_device_bind_iommufd(int device_fd, int iommufd, const char *vf_token);
+
 #endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_VFIO_PCI_DEVICE_H */
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index ac9a5244ddc46..208da2704d9e2 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -180,7 +180,7 @@ void vfio_pci_device_reset(struct vfio_pci_device *device)
 	ioctl_assert(device->fd, VFIO_DEVICE_RESET, NULL);
 }
 
-static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf)
+void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf)
 {
 	struct vfio_group_status group_status = {
 		.argsz = sizeof(group_status),
@@ -200,8 +200,8 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
 	ioctl_assert(device->group_fd, VFIO_GROUP_SET_CONTAINER, &device->iommu->container_fd);
 }
 
-static void vfio_pci_group_get_device_fd(struct vfio_pci_device *device,
-					 const char *bdf, const char *vf_token)
+void __vfio_pci_group_get_device_fd(struct vfio_pci_device *device,
+				    const char *bdf, const char *vf_token)
 {
 	char arg[64] = {0};
 
@@ -216,18 +216,21 @@ static void vfio_pci_group_get_device_fd(struct vfio_pci_device *device,
 		snprintf(arg, ARRAY_SIZE(arg), "%s", bdf);
 
 	device->fd = ioctl(device->group_fd, VFIO_GROUP_GET_DEVICE_FD, arg);
+}
+
+static void vfio_pci_group_get_device_fd(struct vfio_pci_device *device,
+					 const char *bdf, const char *vf_token)
+{
+	__vfio_pci_group_get_device_fd(device, bdf, vf_token);
 	VFIO_ASSERT_GE(device->fd, 0);
 }
 
-static void vfio_pci_container_setup(struct vfio_pci_device *device,
-				     const char *bdf, const char *vf_token)
+void vfio_container_set_iommu(struct vfio_pci_device *device)
 {
 	struct iommu *iommu = device->iommu;
 	unsigned long iommu_type = iommu->mode->iommu_type;
 	int ret;
 
-	vfio_pci_group_setup(device, bdf);
-
 	ret = ioctl(iommu->container_fd, VFIO_CHECK_EXTENSION, iommu_type);
 	VFIO_ASSERT_GT(ret, 0, "VFIO IOMMU type %lu not supported\n", iommu_type);
 
@@ -237,7 +240,13 @@ static void vfio_pci_container_setup(struct vfio_pci_device *device,
 	 * because the IOMMU type is already set.
 	 */
 	(void)ioctl(iommu->container_fd, VFIO_SET_IOMMU, (void *)iommu_type);
+}
 
+static void vfio_pci_container_setup(struct vfio_pci_device *device,
+				     const char *bdf, const char *vf_token)
+{
+	vfio_pci_group_setup(device, bdf);
+	vfio_container_set_iommu(device);
 	vfio_pci_group_get_device_fd(device, bdf, vf_token);
 }
 
@@ -299,8 +308,7 @@ const char *vfio_pci_get_cdev_path(const char *bdf)
 	return cdev_path;
 }
 
-static void vfio_device_bind_iommufd(int device_fd, int iommufd,
-				     const char *vf_token)
+int __vfio_device_bind_iommufd(int device_fd, int iommufd, const char *vf_token)
 {
 	struct vfio_device_bind_iommufd args = {
 		.argsz = sizeof(args),
@@ -314,7 +322,15 @@ static void vfio_device_bind_iommufd(int device_fd, int iommufd,
 		args.token_uuid_ptr = (u64)token_uuid;
 	}
 
-	ioctl_assert(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &args);
+	return ioctl(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &args);
+}
+
+static void vfio_device_bind_iommufd(int device_fd, int iommufd,
+				     const char *vf_token)
+{
+	int ret = __vfio_device_bind_iommufd(device_fd, iommufd, vf_token);
+
+	VFIO_ASSERT_EQ(ret, 0, "Failed VFIO_DEVICE_BIND_IOMMUFD ioctl\n");
 }
 
 static void vfio_device_attach_iommufd_pt(int device_fd, u32 pt_id)
@@ -327,15 +343,19 @@ static void vfio_device_attach_iommufd_pt(int device_fd, u32 pt_id)
 	ioctl_assert(device_fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &args);
 }
 
-static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
-				   const char *bdf, const char *vf_token)
+void vfio_pci_iommufd_cdev_open(struct vfio_pci_device *device, const char *bdf)
 {
 	const char *cdev_path = vfio_pci_get_cdev_path(bdf);
 
 	device->fd = open(cdev_path, O_RDWR);
 	VFIO_ASSERT_GE(device->fd, 0);
 	free((void *)cdev_path);
+}
 
+static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
+				   const char *bdf, const char *vf_token)
+{
+	vfio_pci_iommufd_cdev_open(device, bdf);
 	vfio_device_bind_iommufd(device->fd, device->iommu->iommufd, vf_token);
 	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
 }
-- 
2.52.0.239.gd5f0c6e74e-goog


