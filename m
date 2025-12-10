Return-Path: <kvm+bounces-65674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B795CB3BD4
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 19:16:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 414333154DA9
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 18:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78F5532937A;
	Wed, 10 Dec 2025 18:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sSiUGNC1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6B8328273
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 18:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765390466; cv=none; b=oquOzCHjJJ4ghEYNfLwMVHm3UWpQcGhxHGFNzjjiV5XEcy0p0rBUydclQ63c+6dhum4YBO+p01iUiT3fgnXzo6h04h1jl0bj1PRfrRXsIbywllhPL3IJb8GlPmUaNlrcR4HzUle9OikmfEkmWWfRBXBQRlVxiqYuD4dIFsC0CDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765390466; c=relaxed/simple;
	bh=l+cCwjio5EPRmT49D2SJmoZp0TKezhIl5PRxRDOzXLU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gZncHGhY3Aop7pwoEoEjj72goic5UAMJKkjB51u1gf6k7CYVzgNFKo6LEse5mbBtMmfpTncj6H3++qVEo/QYjlHLMmn0q9xD/FeHgnDFt6DUw3/zQ59fShGuh4jxNaL5dy1H9V1KkSPPy2cUWuxPGq9qmwtgIOCHpcUPO/eq9bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sSiUGNC1; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-65b342ac488so106979eaf.0
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 10:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765390463; x=1765995263; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cc3yaQBIDdGsG6IwnoL+tF4JZwHQKMPcuou0OF8CLFo=;
        b=sSiUGNC1Qsk0W10Jex8S4XnzEazpiJWXiFQwQ1YY3wWmce5iP8unMHjWTioI0WAU9s
         KoWWo3itwZle9mGNvCXQA4Zd2Mlq6vRJsvPEDM9jOVW6wxNepX3flAN1GIh1Ec4Cbb+t
         aTHiQNEy3V1y9kDUyHDTztHeVfBbemsw8tpuqhNervwic2DvUr94mMepn8uKKzu5VZj8
         BOnLwaq8CnnQGgHGp8F5GpxZ/ujCfUknmhR6M/YuIlHJKhJD6TzVi63UxgWRUCEAT5D4
         XPqZdo9lrA/CAnTyMuT3ANMRM2PFnCSX7q0tJmZ7mt0GRAJ1dNE7rhbtblx3isi7F+Nm
         6R8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765390463; x=1765995263;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cc3yaQBIDdGsG6IwnoL+tF4JZwHQKMPcuou0OF8CLFo=;
        b=kxjMHgpjVDuEs5tfrAhJCvpz4ODdvnD2ODfwNHt2RVhiu+KFPn41D63kVIhsaxSWti
         1qxtNrY27yjS4HLtUhyOQRMKXNV3V2AokjaYOYTK5TUKau9nPTzAo/K3inGj7J/QPgpM
         TFFvvNcHdGun/W2mRna65Bax9+AnjmwwoYxpIGXk4jKSQjBWkpb1SN7PHYenZqRt2FfU
         j2gBOEh1QWaoHWQJGe8EXpidxle167mc39KsHdvDsiD3XAPjeK9q/3CCmHIuKF5KG8X7
         oayDXoJ0YDVw/yBeQ1QOmNYLvmauDA02CljWKrXJOksHOcyfuAD9NOy0yKsk19zOmOEN
         rZqg==
X-Forwarded-Encrypted: i=1; AJvYcCXZUbNRPNc4hZFBgKv3jdwNTPeqFR2YI4benFENKyueqD5XK3H7VCVBdtA8AhL+GyUrv7Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUEECWVcJLKXFA3mGFBE+zaUJ5zFR1Vw10fj1PBxX2075KldRA
	Qr3s14oqC2ieOZ0h/9OsSZO2wj7RzL0nwmX3/UnUenq8ntLshfxPiPb8z0EnTovBElvSaZ9VbCJ
	QmZNSDbXg4g==
X-Google-Smtp-Source: AGHT+IH7asKz8/hYJaH0fCIkSFlYh1Npe7OXIQ50oexIrSsl3V8oTPQzBwYi5e+FIdrmm5DKQ0bUjKgBpNRR
X-Received: from ilbcb14.prod.google.com ([2002:a05:6e02:318e:b0:433:78dd:2882])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:1849:b0:659:9a49:8e4b
 with SMTP id 006d021491bc7-65b2ac11e38mr2143163eaf.27.1765390463721; Wed, 10
 Dec 2025 10:14:23 -0800 (PST)
Date: Wed, 10 Dec 2025 18:14:14 +0000
In-Reply-To: <20251210181417.3677674-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251210181417.3677674-1-rananta@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251210181417.3677674-4-rananta@google.com>
Subject: [PATCH v2 3/6] vfio: selftests: Extend container/iommufd setup for
 passing vf_token
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
in the iommu-fd case. Hence extend the functions,
vfio_pci_iommufd_setup() and vfio_pci_container_setup(), to accept
vf_token as an (optional) argument and handle the necessary setup.

No functional changes are expected.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/vfio/lib/libvfio.mk   |  4 +-
 .../selftests/vfio/lib/vfio_pci_device.c      | 45 +++++++++++++++----
 2 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/libvfio.mk b/tools/testing/selftests/vfio/lib/libvfio.mk
index b7857319c3f1f..459b14c6885a8 100644
--- a/tools/testing/selftests/vfio/lib/libvfio.mk
+++ b/tools/testing/selftests/vfio/lib/libvfio.mk
@@ -15,6 +15,8 @@ LIBVFIO_C += drivers/ioat/ioat.c
 LIBVFIO_C += drivers/dsa/dsa.c
 endif
 
+LDLIBS += -luuid
+
 LIBVFIO_OUTPUT := $(OUTPUT)/libvfio
 
 LIBVFIO_O := $(patsubst %.c, $(LIBVFIO_OUTPUT)/%.o, $(LIBVFIO_C))
@@ -25,6 +27,6 @@ $(shell mkdir -p $(LIBVFIO_O_DIRS))
 CFLAGS += -I$(LIBVFIO_SRCDIR)/include
 
 $(LIBVFIO_O): $(LIBVFIO_OUTPUT)/%.o : $(LIBVFIO_SRCDIR)/%.c
-	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< $(LDLIBS) -o $@
 
 EXTRA_CLEAN += $(LIBVFIO_OUTPUT)
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 9b2a123cee5fc..ac9a5244ddc46 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -12,6 +12,7 @@
 #include <sys/mman.h>
 
 #include <uapi/linux/types.h>
+#include <uuid/uuid.h>
 #include <linux/iommufd.h>
 #include <linux/limits.h>
 #include <linux/mman.h>
@@ -199,7 +200,27 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
 	ioctl_assert(device->group_fd, VFIO_GROUP_SET_CONTAINER, &device->iommu->container_fd);
 }
 
-static void vfio_pci_container_setup(struct vfio_pci_device *device, const char *bdf)
+static void vfio_pci_group_get_device_fd(struct vfio_pci_device *device,
+					 const char *bdf, const char *vf_token)
+{
+	char arg[64] = {0};
+
+	/*
+	 * If a vf_token exists, argument to VFIO_GROUP_GET_DEVICE_FD
+	 * will be in the form of the following example:
+	 * "0000:04:10.0 vf_token=bd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
+	 */
+	if (vf_token)
+		snprintf(arg, ARRAY_SIZE(arg), "%s vf_token=%s", bdf, vf_token);
+	else
+		snprintf(arg, ARRAY_SIZE(arg), "%s", bdf);
+
+	device->fd = ioctl(device->group_fd, VFIO_GROUP_GET_DEVICE_FD, arg);
+	VFIO_ASSERT_GE(device->fd, 0);
+}
+
+static void vfio_pci_container_setup(struct vfio_pci_device *device,
+				     const char *bdf, const char *vf_token)
 {
 	struct iommu *iommu = device->iommu;
 	unsigned long iommu_type = iommu->mode->iommu_type;
@@ -217,8 +238,7 @@ static void vfio_pci_container_setup(struct vfio_pci_device *device, const char
 	 */
 	(void)ioctl(iommu->container_fd, VFIO_SET_IOMMU, (void *)iommu_type);
 
-	device->fd = ioctl(device->group_fd, VFIO_GROUP_GET_DEVICE_FD, bdf);
-	VFIO_ASSERT_GE(device->fd, 0);
+	vfio_pci_group_get_device_fd(device, bdf, vf_token);
 }
 
 static void vfio_pci_device_setup(struct vfio_pci_device *device)
@@ -279,12 +299,20 @@ const char *vfio_pci_get_cdev_path(const char *bdf)
 	return cdev_path;
 }
 
-static void vfio_device_bind_iommufd(int device_fd, int iommufd)
+static void vfio_device_bind_iommufd(int device_fd, int iommufd,
+				     const char *vf_token)
 {
 	struct vfio_device_bind_iommufd args = {
 		.argsz = sizeof(args),
 		.iommufd = iommufd,
 	};
+	uuid_t token_uuid = {0};
+
+	if (vf_token) {
+		VFIO_ASSERT_EQ(uuid_parse(vf_token, token_uuid), 0);
+		args.flags |= VFIO_DEVICE_BIND_FLAG_TOKEN;
+		args.token_uuid_ptr = (u64)token_uuid;
+	}
 
 	ioctl_assert(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &args);
 }
@@ -299,7 +327,8 @@ static void vfio_device_attach_iommufd_pt(int device_fd, u32 pt_id)
 	ioctl_assert(device_fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &args);
 }
 
-static void vfio_pci_iommufd_setup(struct vfio_pci_device *device, const char *bdf)
+static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
+				   const char *bdf, const char *vf_token)
 {
 	const char *cdev_path = vfio_pci_get_cdev_path(bdf);
 
@@ -307,7 +336,7 @@ static void vfio_pci_iommufd_setup(struct vfio_pci_device *device, const char *b
 	VFIO_ASSERT_GE(device->fd, 0);
 	free((void *)cdev_path);
 
-	vfio_device_bind_iommufd(device->fd, device->iommu->iommufd);
+	vfio_device_bind_iommufd(device->fd, device->iommu->iommufd, vf_token);
 	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
 }
 
@@ -323,9 +352,9 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iomm
 	device->bdf = bdf;
 
 	if (iommu->mode->container_path)
-		vfio_pci_container_setup(device, bdf);
+		vfio_pci_container_setup(device, bdf, NULL);
 	else
-		vfio_pci_iommufd_setup(device, bdf);
+		vfio_pci_iommufd_setup(device, bdf, NULL);
 
 	vfio_pci_device_setup(device);
 	vfio_pci_driver_probe(device);
-- 
2.52.0.239.gd5f0c6e74e-goog


