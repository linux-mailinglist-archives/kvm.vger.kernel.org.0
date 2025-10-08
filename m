Return-Path: <kvm+bounces-59666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DF38BC6DB0
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 01:26:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6DB73A78C0
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 23:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA2532C235B;
	Wed,  8 Oct 2025 23:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vmZOM5Mf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601862C327A
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 23:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759965968; cv=none; b=DAkFeAx0YV/y3AuW2iYxUz3h5Nte+MWIIkmUKy0LAeVv4Q5wAqa/17O3cMyu4eH4c6u1buk0RD/f6kdzbilRXwk1axUTvPC9trZH4Ty7njOt9OzEYumpxtRFSIRfMvFY7ZwcTL3Nhqq2Wdy9HSDqZLpDrXvTTPPhTSKtuWkdAyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759965968; c=relaxed/simple;
	bh=l8ZlXzYAPgtNYm8b2mDRahLOB96+az9iB+aZEXe1TBQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ujQmbmT29pTKIFrcUEbJz8TojhMWI/4Zi7nmICjx/gXy87LcDh6lVmmHTh2gW79kRLNEOxAzAGAzRg2t+f5dVP+YQhx7sIoTBdT0SYYYgKi7VdDHMxU9HOTtBLYLu7Vkpp8EvqEKzMlqCZJJen4bjf+FDbgJHRzOh5OS2fJ800E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vmZOM5Mf; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77b73bddbdcso456447b3a.1
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 16:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759965964; x=1760570764; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V8Wzcz2wND8Cb+BUVzyfV49JjenzCPFxz33ZOJyT8/o=;
        b=vmZOM5MfBYdLsBdkRAc0cCdfpn2o55RuGxJL5RZ5Y/pMAQojVc1HsI30iYr0OMoT5N
         +qEbN/z33QLht2pj4ZgFswWrwy2cIFDMvAJwguzgaTJqUUoce9C4W3o78WpDKc2SQ6fM
         oNq5d+FVWqytogx3Ab8mDbGAOvfSDkI3LNkM8BN9AXufNNDVlTJOuPY3XTT/UTwfk5mh
         8ve0ADwbzRmRTAX6RGFhIuOC462X8rZUYJxOaK73g7DZHVBEQ4HGVevqkC5r+fnsd0d+
         S9kuEj0+xvteu10rpi0NIBx0FE0xHLpswryyVWhyOWrk2aMUrw3pAJDxUFvWBSoml2sx
         CDzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759965964; x=1760570764;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V8Wzcz2wND8Cb+BUVzyfV49JjenzCPFxz33ZOJyT8/o=;
        b=BrmGNuC0InRlxtZdRo2jjn10Fxy5CKQr9bwuo2nEOUU+2QNjWPeat0dk0K6F09UNQF
         sDFtvg4VDq8gK3vV4b6wQwL4Xh3RgkCQFeWMoqbQVKiO7aTgXn4WYJ4jIwbQOnKCmoUh
         p815VzPl+AIncuVrkf7LSmBCsitGEP89GVBgy07yWKYixQCKxKRa1yFrYioTPdR8RyQg
         RFL+HStZIzHSfdK/dIG41xxoT5u6Dc2LYvAEu4u7Za118N39Gt74HVt4mVqt2dKqXW1U
         KnzZk38GyZd7YCSpa1lYEsY9PllrvRMKDD3rpuSgRZmxH7ZDsrCz9UyLKZTK/GZnH+Vm
         v71A==
X-Forwarded-Encrypted: i=1; AJvYcCXTtHIjq64mqrHzwckyDkQX5TlIKwJeVXcDJbhHzE8l1f2oTSEd3lH9q+zsL8yWbAdxQb8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yytexqa/bsGZ/IkGjeBXPtbiVtUYfZUX0MVfRfIDoVxlxGwM/oE
	B1ktkp/kpSfCAeE9c1mKAtPw02D2X7VInvcOp5al0W0KjFL8j79NF62lgQQv60Eh1ibmmla3hsG
	XfwjE4b4H921MWA==
X-Google-Smtp-Source: AGHT+IH36YUv9susxq6bE2KSGr6oy0aLVTn3w0kQ13SBV1wkVyreyr0uv/bCrfL3WZ3yxZma/uLM0B18uMAMWQ==
X-Received: from pfoi18.prod.google.com ([2002:aa7:87d2:0:b0:781:1d87:4584])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:aa7:90d3:0:b0:784:27cb:a2c6 with SMTP id d2e1a72fcca58-7922fab2444mr8679143b3a.2.1759965964220;
 Wed, 08 Oct 2025 16:26:04 -0700 (PDT)
Date: Wed,  8 Oct 2025 23:25:24 +0000
In-Reply-To: <20251008232531.1152035-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008232531.1152035-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008232531.1152035-6-dmatlack@google.com>
Subject: [PATCH 05/12] vfio: selftests: Support multiple devices in the same container/iommufd
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, 
	kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Support tests that want to add multiple devices to the same
container/iommufd by decoupling struct vfio_pci_device from
struct iommu.

For backwards compatibility with existing tests, and to keep
single-device tests simple, vfio_pci_device_init() and
vfio_pci_device_cleanup() remain unchanged.

Multi-devices tests can now put multiple devices in the same
container/iommufd like so:

  iommu = iommu_init(iommu_mode);

  device1 = __vfio_pci_device_init(bdf1, iommu);
  device2 = __vfio_pci_device_init(bdf2, iommu);
  device3 = __vfio_pci_device_init(bdf3, iommu);

  ...

  __vfio_pci_device_cleanup(device3);
  __vfio_pci_device_cleanup(device2);
  __vfio_pci_device_cleanup(device1);

  iommu_cleanup(iommu);

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/vfio/lib/include/vfio_util.h    |   7 ++
 .../selftests/vfio/lib/vfio_pci_device.c      | 107 ++++++++++++------
 2 files changed, 80 insertions(+), 34 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index 14cd0bec45c0..8a01bcaa3ee8 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -206,8 +206,15 @@ const char *vfio_pci_get_cdev_path(const char *bdf);
 
 extern const char *default_iommu_mode;
 
+struct iommu *iommu_init(const char *iommu_mode);
+void iommu_cleanup(struct iommu *iommu);
+
+struct vfio_pci_device *__vfio_pci_device_init(const char *bdf, struct iommu *iommu);
 struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_mode);
+
+void __vfio_pci_device_cleanup(struct vfio_pci_device *device);
 void vfio_pci_device_cleanup(struct vfio_pci_device *device);
+
 void vfio_pci_device_reset(struct vfio_pci_device *device);
 
 void vfio_pci_dma_map(struct vfio_pci_device *device,
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index e4596a570422..de3a8d4d74f0 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -330,23 +330,21 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
 
 static void vfio_pci_container_setup(struct vfio_pci_device *device, const char *bdf)
 {
-	unsigned long iommu_type = device->iommu->mode->iommu_type;
-	const char *path = device->iommu->mode->container_path;
-	int version;
+	struct iommu *iommu = device->iommu;
+	unsigned long iommu_type = iommu->mode->iommu_type;
 	int ret;
 
-	device->iommu->container_fd = open(path, O_RDWR);
-	VFIO_ASSERT_GE(device->iommu->container_fd, 0, "open(%s) failed\n", path);
-
-	version = ioctl(device->iommu->container_fd, VFIO_GET_API_VERSION);
-	VFIO_ASSERT_EQ(version, VFIO_API_VERSION, "Unsupported version: %d\n", version);
-
 	vfio_pci_group_setup(device, bdf);
 
-	ret = ioctl(device->iommu->container_fd, VFIO_CHECK_EXTENSION, iommu_type);
+	ret = ioctl(iommu->container_fd, VFIO_CHECK_EXTENSION, iommu_type);
 	VFIO_ASSERT_GT(ret, 0, "VFIO IOMMU type %lu not supported\n", iommu_type);
 
-	ioctl_assert(device->iommu->container_fd, VFIO_SET_IOMMU, (void *)iommu_type);
+	/*
+	 * Allow multiple threads to race to set the IOMMU type on the
+	 * container. The first will succeed and the rest should fail
+	 * because the IOMMU type is already set.
+	 */
+	(void)ioctl(iommu->container_fd, VFIO_SET_IOMMU, (void *)iommu_type);
 
 	device->fd = ioctl(device->group_fd, VFIO_GROUP_GET_DEVICE_FD, bdf);
 	VFIO_ASSERT_GE(device->fd, 0);
@@ -494,32 +492,53 @@ static void vfio_pci_iommufd_setup(struct vfio_pci_device *device, const char *b
 	VFIO_ASSERT_GE(device->fd, 0);
 	free((void *)cdev_path);
 
-	/*
-	 * Require device->iommufd to be >0 so that a simple non-0 check can be
-	 * used to check if iommufd is enabled. In practice open() will never
-	 * return 0 unless stdin is closed.
-	 */
-	device->iommu->iommufd = open("/dev/iommu", O_RDWR);
-	VFIO_ASSERT_GT(device->iommu->iommufd, 0);
-
 	vfio_device_bind_iommufd(device->fd, device->iommu->iommufd);
-	device->iommu->ioas_id = iommufd_ioas_alloc(device->iommu->iommufd);
 	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
 }
 
-struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_mode)
+struct iommu *iommu_init(const char *iommu_mode)
+{
+	const char *container_path;
+	struct iommu *iommu;
+	int version;
+
+	iommu = calloc(1, sizeof(*iommu));
+	VFIO_ASSERT_NOT_NULL(iommu);
+
+	INIT_LIST_HEAD(&iommu->dma_regions);
+
+	iommu->mode = lookup_iommu_mode(iommu_mode);
+
+	container_path = iommu->mode->container_path;
+	if (container_path) {
+		iommu->container_fd = open(container_path, O_RDWR);
+		VFIO_ASSERT_GE(iommu->container_fd, 0, "open(%s) failed\n", container_path);
+
+		version = ioctl(iommu->container_fd, VFIO_GET_API_VERSION);
+		VFIO_ASSERT_EQ(version, VFIO_API_VERSION, "Unsupported version: %d\n", version);
+	} else {
+		/*
+		 * Require device->iommufd to be >0 so that a simple non-0 check can be
+		 * used to check if iommufd is enabled. In practice open() will never
+		 * return 0 unless stdin is closed.
+		 */
+		iommu->iommufd = open("/dev/iommu", O_RDWR);
+		VFIO_ASSERT_GT(iommu->iommufd, 0);
+
+		iommu->ioas_id = iommufd_ioas_alloc(iommu->iommufd);
+	}
+
+	return iommu;
+}
+
+struct vfio_pci_device *__vfio_pci_device_init(const char *bdf, struct iommu *iommu)
 {
 	struct vfio_pci_device *device;
 
 	device = calloc(1, sizeof(*device));
 	VFIO_ASSERT_NOT_NULL(device);
 
-	device->iommu = calloc(1, sizeof(*device->iommu));
-	VFIO_ASSERT_NOT_NULL(device->iommu);
-
-	INIT_LIST_HEAD(&device->iommu->dma_regions);
-
-	device->iommu->mode = lookup_iommu_mode(iommu_mode);
+	device->iommu = iommu;
 
 	if (device->iommu->mode->container_path)
 		vfio_pci_container_setup(device, bdf);
@@ -532,7 +551,14 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_
 	return device;
 }
 
-void vfio_pci_device_cleanup(struct vfio_pci_device *device)
+struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_mode)
+{
+	struct iommu *iommu = iommu_init(iommu_mode);
+
+	return __vfio_pci_device_init(bdf, iommu);
+}
+
+void __vfio_pci_device_cleanup(struct vfio_pci_device *device)
 {
 	int i;
 
@@ -550,17 +576,30 @@ void vfio_pci_device_cleanup(struct vfio_pci_device *device)
 		VFIO_ASSERT_EQ(close(device->msi_eventfds[i]), 0);
 	}
 
-	if (device->iommu->iommufd) {
-		VFIO_ASSERT_EQ(close(device->iommu->iommufd), 0);
-	} else {
+	if (device->group_fd)
 		VFIO_ASSERT_EQ(close(device->group_fd), 0);
-		VFIO_ASSERT_EQ(close(device->iommu->container_fd), 0);
-	}
 
-	free(device->iommu);
 	free(device);
 }
 
+void iommu_cleanup(struct iommu *iommu)
+{
+	if (iommu->iommufd)
+		VFIO_ASSERT_EQ(close(iommu->iommufd), 0);
+	else
+		VFIO_ASSERT_EQ(close(iommu->container_fd), 0);
+
+	free(iommu);
+}
+
+void vfio_pci_device_cleanup(struct vfio_pci_device *device)
+{
+	struct iommu *iommu = device->iommu;
+
+	__vfio_pci_device_cleanup(device);
+	iommu_cleanup(iommu);
+}
+
 static bool is_bdf(const char *str)
 {
 	unsigned int s, b, d, f;
-- 
2.51.0.710.ga91ca5db03-goog


