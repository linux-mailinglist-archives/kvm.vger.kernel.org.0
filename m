Return-Path: <kvm+bounces-61928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5E4CC2EA1B
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 01:36:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2ABA1189A41C
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 00:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C6D1367;
	Tue,  4 Nov 2025 00:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SG34WTTJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1602042A82
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 00:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762216549; cv=none; b=orZKhadYTE1E34NMaPnKlAShS67y/R3oDdDb5MK3EcgpKcErLek3/kuWwKGnEE6GaXpvI0Nf5y4A57KeXQWjtJG8DABSdl3ysGEn571AeIdQp/g6da5NtnPtpXwbsAdc5cOhss4cD5JeYnhaLyP5jJ4WVuV/INfuHqNQz6ugSjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762216549; c=relaxed/simple;
	bh=EsjL424yl/2mQQzPUlHOMi1BpS3/fOWCDbDhW87QMBI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NRIzHQwQmvri1TtFk37i1epG2XrFC2yQ7RkC7Tlcs/7Rnh3afLPxZSLXjSwKHZos0qW4qcxGI0IEdmzApRvzc8KS9j/KHLeaSiJBvDpnWea2oWjJgV/uF1PvTEynRsVODKgvAXRmQsfWnKtNCPCrZvtzPEBH1Hczm46zFN8SNG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SG34WTTJ; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-940f5d522efso1496602539f.1
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 16:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762216547; x=1762821347; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qt+QHAfLbPatlStTXKKLv5FSCr8vyUEZTBvG9w134jY=;
        b=SG34WTTJH4UB5HN7Q3UDNSGEobWW0EpIcj5BAj5K/bxrPGtp54gTunTNg72RwZs6Ku
         7J4cAJ4NRAdUQdk9WylervxB3P9LBNc8fwTY5GvlbSaWkGNwfzFfJ8NGsrPp0gvnDV7o
         Ee3VsYctc6y9jEQIRkWRj5adXP9seDy6qc1uEiv67Co/gPUnmR1m7ALETjDWV5KXwAhW
         uTgMV8a+2WPqXT7ciAo1xAnR+jMdrAh2ZDASaO6UfeQr6mt7oYU3isQamHdbCS9QmJyM
         qEMsj174At1OP9VlcT8gfgkiiBngbBnl2CXD/HkB0fzapmgs7W6oaOWE9WFrDXydV9K0
         Jz8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762216547; x=1762821347;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qt+QHAfLbPatlStTXKKLv5FSCr8vyUEZTBvG9w134jY=;
        b=Skec1smNe9S9YDlhdusefmKAmXYxcpR9ERot8/CSYpz0jQg+AypaRHLF8HZftVEgr9
         ft4gEx+lIOu38tirDAycf6fv9rbGQU5Jgpqxi1js/IvHkby8iRgIF9hKah0NrRlMrueD
         ML03pBadLpx5G7zJuVNOw+q5OiY2axyAqqUNkIXZR6xv4xtfUeEAuKLc/8Gda6yrYlCU
         CQoBeh/LMEHWjrVxEmerJi03pKteeLLkuG+qgspyV2CRbXVYYoe7epE/S5euoBpQzZAW
         vM9+ugmAYX28mvDfwjZEu190Fi0OrQdrefDH447yb0ABNjLDj71FTvxMpKlobtJy5DXg
         Dqtg==
X-Forwarded-Encrypted: i=1; AJvYcCX8RzBlZa/spvFdtxj9oyBx7dxhi/+kwtW/Sf0BkampSWtj6+HbVmQltwFqCfqooegnWPk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx6NBWL6LlQwBb+BkDH33jUGi/waCcpf+oLP0yrAHyNijnEjjW
	OAi4N/EYCqIOwIweskudgo4SgCNolPm7zRbmDC5cbDynDVWQd/X/aie7ZLrTrgje8Xt7Noquh1z
	OAqGeU++JRQ==
X-Google-Smtp-Source: AGHT+IFsL8M8ofu1wJ4RYemIX5JD6RBGACdmIdCOCjJqf7kDlOem1JZxUysroUi/Wm40EuVMeq0t/DYIKeet
X-Received: from iobfb22.prod.google.com ([2002:a05:6602:3f96:b0:940:e982:abe1])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:1644:b0:93e:8c1e:cc5d
 with SMTP id ca18e2360f4ac-948229564ffmr2727620439f.5.1762216547388; Mon, 03
 Nov 2025 16:35:47 -0800 (PST)
Date: Tue,  4 Nov 2025 00:35:33 +0000
In-Reply-To: <20251104003536.3601931-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251104003536.3601931-1-rananta@google.com>
X-Mailer: git-send-email 2.51.2.997.g839fc31de9-goog
Message-ID: <20251104003536.3601931-2-rananta@google.com>
Subject: [PATCH 1/4] vfio: selftests: Add support for passing vf_token in
 device init
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>, 
	Alex Williamson <alex.williamson@redhat.com>
Cc: Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

A UUID is normally set as a vf_token to correspond the VFs with the
PFs, if they are both bound by the vfio-pci driver. This is true for
iommufd-based approach and container-based approach. The token can be
set either during device creation (VFIO_GROUP_GET_DEVICE_FD) in
container-based approach or during iommu bind (VFIO_DEVICE_BIND_IOMMUFD)
in the iommu-fd case. Hence, extend the vfio_pci_device_init() helper to
accept vf_token during device setup.

The tests depending on vfio_pci_device_init() are adjusted accordingly
and no functional changes are expected. A later patch will add tests
that passes actual token to test the UAPI.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/vfio/lib/include/vfio_util.h    |  4 +-
 tools/testing/selftests/vfio/lib/libvfio.mk   |  4 +-
 .../selftests/vfio/lib/vfio_pci_device.c      | 60 ++++++++++++++++---
 .../selftests/vfio/vfio_dma_mapping_test.c    |  2 +-
 .../selftests/vfio/vfio_pci_device_test.c     |  4 +-
 .../selftests/vfio/vfio_pci_driver_test.c     |  4 +-
 6 files changed, 62 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index ed31606e01b78..b01068d98fdab 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -202,7 +202,9 @@ const char *vfio_pci_get_cdev_path(const char *bdf);
 
 extern const char *default_iommu_mode;
 
-struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_mode);
+struct vfio_pci_device *vfio_pci_device_init(const char *bdf,
+					      const char *iommu_mode,
+					      const char *vf_token);
 void vfio_pci_device_cleanup(struct vfio_pci_device *device);
 void vfio_pci_device_reset(struct vfio_pci_device *device);
 
diff --git a/tools/testing/selftests/vfio/lib/libvfio.mk b/tools/testing/selftests/vfio/lib/libvfio.mk
index 5d11c3a89a28e..2dc85c41ffb4b 100644
--- a/tools/testing/selftests/vfio/lib/libvfio.mk
+++ b/tools/testing/selftests/vfio/lib/libvfio.mk
@@ -18,7 +18,9 @@ $(shell mkdir -p $(LIBVFIO_O_DIRS))
 
 CFLAGS += -I$(VFIO_DIR)/lib/include
 
+LDLIBS += -luuid
+
 $(LIBVFIO_O): $(OUTPUT)/%.o : $(VFIO_DIR)/%.c
-	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< $(LDLIBS) -o $@
 
 EXTRA_CLEAN += $(LIBVFIO_O)
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 0921b2451ba5c..3f7be8d371d06 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -11,6 +11,7 @@
 #include <sys/mman.h>
 
 #include <uapi/linux/types.h>
+#include <uuid/uuid.h>
 #include <linux/limits.h>
 #include <linux/mman.h>
 #include <linux/types.h>
@@ -22,6 +23,8 @@
 
 #define PCI_SYSFS_PATH	"/sys/bus/pci/devices"
 
+#define VF_TOKEN_ARG "vf_token="
+
 #define ioctl_assert(_fd, _op, _arg) do {						       \
 	void *__arg = (_arg);								       \
 	int __ret = ioctl((_fd), (_op), (__arg));					       \
@@ -328,7 +331,37 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
 	ioctl_assert(device->group_fd, VFIO_GROUP_SET_CONTAINER, &device->container_fd);
 }
 
-static void vfio_pci_container_setup(struct vfio_pci_device *device, const char *bdf)
+static void vfio_pci_container_get_device_fd(struct vfio_pci_device *device,
+					      const char *bdf,
+					      const char *vf_token)
+{
+	char *arg = (char *) bdf;
+
+	/*
+	 * If a vf_token exists, argument to VFIO_GROUP_GET_DEVICE_FD
+	 * will be in the form of the following example:
+	 * "0000:04:10.0 vf_token=bd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
+	 */
+	if (vf_token) {
+		size_t sz = strlen(bdf) + strlen(" "VF_TOKEN_ARG) +
+			    strlen(vf_token) + 1;
+
+		arg = calloc(1, sz);
+		VFIO_ASSERT_NOT_NULL(arg);
+
+		snprintf(arg, sz, "%s %s%s", bdf, VF_TOKEN_ARG, vf_token);
+	}
+
+	device->fd = ioctl(device->group_fd, VFIO_GROUP_GET_DEVICE_FD, arg);
+
+	if (vf_token)
+		free((void *) arg);
+
+	VFIO_ASSERT_GE(device->fd, 0);
+}
+
+static void vfio_pci_container_setup(struct vfio_pci_device *device,
+				      const char *bdf, const char *vf_token)
 {
 	unsigned long iommu_type = device->iommu_mode->iommu_type;
 	const char *path = device->iommu_mode->container_path;
@@ -348,8 +381,7 @@ static void vfio_pci_container_setup(struct vfio_pci_device *device, const char
 
 	ioctl_assert(device->container_fd, VFIO_SET_IOMMU, (void *)iommu_type);
 
-	device->fd = ioctl(device->group_fd, VFIO_GROUP_GET_DEVICE_FD, bdf);
-	VFIO_ASSERT_GE(device->fd, 0);
+	vfio_pci_container_get_device_fd(device, bdf, vf_token);
 }
 
 static void vfio_pci_device_setup(struct vfio_pci_device *device)
@@ -456,12 +488,19 @@ static const struct vfio_iommu_mode *lookup_iommu_mode(const char *iommu_mode)
 	VFIO_FAIL("Unrecognized IOMMU mode: %s\n", iommu_mode);
 }
 
-static void vfio_device_bind_iommufd(int device_fd, int iommufd)
+static void vfio_device_bind_iommufd(int device_fd, int iommufd, const char *vf_token)
 {
 	struct vfio_device_bind_iommufd args = {
 		.argsz = sizeof(args),
 		.iommufd = iommufd,
 	};
+	uuid_t token_uuid = {0};
+
+	if (vf_token) {
+		VFIO_ASSERT_EQ(uuid_parse(vf_token, token_uuid), 0);
+		args.flags = VFIO_DEVICE_BIND_FLAG_TOKEN;
+		args.token_uuid_ptr = (u64) token_uuid;
+	}
 
 	ioctl_assert(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &args);
 }
@@ -486,7 +525,8 @@ static void vfio_device_attach_iommufd_pt(int device_fd, u32 pt_id)
 	ioctl_assert(device_fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &args);
 }
 
-static void vfio_pci_iommufd_setup(struct vfio_pci_device *device, const char *bdf)
+static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
+				    const char *bdf, const char *vf_token)
 {
 	const char *cdev_path = vfio_pci_get_cdev_path(bdf);
 
@@ -502,12 +542,14 @@ static void vfio_pci_iommufd_setup(struct vfio_pci_device *device, const char *b
 	device->iommufd = open("/dev/iommu", O_RDWR);
 	VFIO_ASSERT_GT(device->iommufd, 0);
 
-	vfio_device_bind_iommufd(device->fd, device->iommufd);
+	vfio_device_bind_iommufd(device->fd, device->iommufd, vf_token);
 	device->ioas_id = iommufd_ioas_alloc(device->iommufd);
 	vfio_device_attach_iommufd_pt(device->fd, device->ioas_id);
 }
 
-struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_mode)
+struct vfio_pci_device *vfio_pci_device_init(const char *bdf,
+					      const char *iommu_mode,
+					      const char *vf_token)
 {
 	struct vfio_pci_device *device;
 
@@ -519,9 +561,9 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_
 	device->iommu_mode = lookup_iommu_mode(iommu_mode);
 
 	if (device->iommu_mode->container_path)
-		vfio_pci_container_setup(device, bdf);
+		vfio_pci_container_setup(device, bdf, vf_token);
 	else
-		vfio_pci_iommufd_setup(device, bdf);
+		vfio_pci_iommufd_setup(device, bdf, vf_token);
 
 	vfio_pci_device_setup(device);
 	vfio_pci_driver_probe(device);
diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
index ab19c54a774da..3c53b808f7f87 100644
--- a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
+++ b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
@@ -114,7 +114,7 @@ FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(anonymous_hugetlb_1gb, SZ_1G, MAP_HUGETLB |
 
 FIXTURE_SETUP(vfio_dma_mapping_test)
 {
-	self->device = vfio_pci_device_init(device_bdf, variant->iommu_mode);
+	self->device = vfio_pci_device_init(device_bdf, variant->iommu_mode, NULL);
 }
 
 FIXTURE_TEARDOWN(vfio_dma_mapping_test)
diff --git a/tools/testing/selftests/vfio/vfio_pci_device_test.c b/tools/testing/selftests/vfio/vfio_pci_device_test.c
index 7a270698e4d24..ebf7fd3d1cf70 100644
--- a/tools/testing/selftests/vfio/vfio_pci_device_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_device_test.c
@@ -28,7 +28,7 @@ FIXTURE(vfio_pci_device_test) {
 
 FIXTURE_SETUP(vfio_pci_device_test)
 {
-	self->device = vfio_pci_device_init(device_bdf, default_iommu_mode);
+	self->device = vfio_pci_device_init(device_bdf, default_iommu_mode, NULL);
 }
 
 FIXTURE_TEARDOWN(vfio_pci_device_test)
@@ -116,7 +116,7 @@ FIXTURE_VARIANT_ADD(vfio_pci_irq_test, msix) {
 
 FIXTURE_SETUP(vfio_pci_irq_test)
 {
-	self->device = vfio_pci_device_init(device_bdf, default_iommu_mode);
+	self->device = vfio_pci_device_init(device_bdf, default_iommu_mode, NULL);
 }
 
 FIXTURE_TEARDOWN(vfio_pci_irq_test)
diff --git a/tools/testing/selftests/vfio/vfio_pci_driver_test.c b/tools/testing/selftests/vfio/vfio_pci_driver_test.c
index 2dbd70b7db627..cfbaa05dda884 100644
--- a/tools/testing/selftests/vfio/vfio_pci_driver_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_driver_test.c
@@ -71,7 +71,7 @@ FIXTURE_SETUP(vfio_pci_driver_test)
 {
 	struct vfio_pci_driver *driver;
 
-	self->device = vfio_pci_device_init(device_bdf, variant->iommu_mode);
+	self->device = vfio_pci_device_init(device_bdf, variant->iommu_mode, NULL);
 
 	driver = &self->device->driver;
 
@@ -233,7 +233,7 @@ int main(int argc, char *argv[])
 
 	device_bdf = vfio_selftests_get_bdf(&argc, argv);
 
-	device = vfio_pci_device_init(device_bdf, default_iommu_mode);
+	device = vfio_pci_device_init(device_bdf, default_iommu_mode, NULL);
 	if (!device->driver.ops) {
 		fprintf(stderr, "No driver found for device %s\n", device_bdf);
 		return KSFT_SKIP;
-- 
2.51.2.997.g839fc31de9-goog


