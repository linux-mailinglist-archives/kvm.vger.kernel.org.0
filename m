Return-Path: <kvm+bounces-71649-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4MCCCXrtnWncSgQAu9opvQ
	(envelope-from <kvm+bounces-71649-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:27:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 036E718B5A9
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:27:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 29E463059AF8
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09AFF3ACF13;
	Tue, 24 Feb 2026 18:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h5GhGTp9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D333AA1BA
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 18:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771957545; cv=none; b=IfJS/svVRp9NxO8o87Te8gpn05QSdoB8V4jm/rgCHD8YSY/koMYvFQTKCOvptzcRyjGrcEq3VKxn3R44Cwul95kp42btHHWyfM66swnBIEvcYxzsU5LZ9HBmuQwnASavX6hlEJyei/YAtW+rzZ2F8ZBqACpH9cyG/5Bf0i2K5xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771957545; c=relaxed/simple;
	bh=vGdV3ktht32WblZs3LsiIfE3xzMkY/XL4LUK0CaWYe4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kw3/3BEBDDU3DaE7AWRY8EonWaWLj81tbrjRHxz7BZRLP1FBahjWms5zBRFmM4aGFP3JYjXS6NVzw//X50r7DJCgvsPhNrNzfLeIQJZqFEzuGTAp+xZWotgP4l4QNEoAibemVPJY1aDr4B9PvNtY2fNFX0iKSV3mO5JL8cIl9T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h5GhGTp9; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-679c6ef156dso17899543eaf.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 10:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771957542; x=1772562342; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W5wQFF+d0vZbX1lJAkgEnS9lDKccfjOQiCEdtZxbCbg=;
        b=h5GhGTp9g3+N4nqB9Xm1HO41HlAK+7iEhZSUF8FwcGZbbpF9/sbmECw3W70xvHLS76
         o+Ux60Lu0vq809XSQBQQsm9uRhN/hhHX3DUEgtw2aKd8FAg5ukJNxVxNfSYByNP1xvRh
         Ut0yl3FV68pn0A9VfaVewGJnzwtLlYQABnLXeVB5EICGdJ6KOo7zX8qpOrfkI/kdyEu/
         2jk39nK+PLi0c4KQ5letBI4XTNv8R1FHJ4FashDaZgiXYa0LA6elnE9kUD3oF7R82CoP
         e9u4gw34YvqvkfRlahMj8m56Ztehdr71qkxAXg/tR1nd0L22KVWIu1J4rJpY71jYu5sR
         L/oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771957542; x=1772562342;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W5wQFF+d0vZbX1lJAkgEnS9lDKccfjOQiCEdtZxbCbg=;
        b=JytrJlLqoaKsL0lAZRA8AWLXI6gEasvC+KLeTtg0jWETm81PUHMOf62wh208rNIbHy
         2SoTN5DJLdwN97ANjYyx4Mvarp9Bbw4clt9YWBf/DZS+z4o9SrjGCkXBx03VZMjxLKsi
         10lfLHuT01QO0UnRrYQDSc3S3n2gtnrBA/WmsCCSbfK1RMSDX+m7zckrVBpaLyqnZvu+
         RSPFeRqpotdsrLUX501ak/VBY3r7o3qrniv11k/Ie62zQZ8HYyT/yFsTpcIqY96OWypZ
         A3lM07b0h2rIqqygAHtQVoRauqT928BsVMCd7SfdXCDJk759VpNGKZchJi2RPcEub95h
         eiqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQ2UwtZq/OFIdpbS7tmSksH2nWL/7LH4wpF2QTxlnxrezRGT63B4KYIAyevKGFiaAGtoQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/SoO/geTsf5lNJNsR1nyJGpzmzLd56nO8s+Pki5cWEh4Uw3vT
	RTE/CrQ8g1eLUpg5nRbBmGaQJWxDhxUhg/A1TApyzJpR3UN+tN56g7Yb4aZu3C6De4DOQhC2Cqc
	3af+HDAKWvg==
X-Received: from ilst5.prod.google.com ([2002:a05:6e02:605:b0:4b4:27a0:c01e])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:d0e:b0:66a:9d34:6cc0
 with SMTP id 006d021491bc7-679c4280f47mr7318572eaf.27.1771957541683; Tue, 24
 Feb 2026 10:25:41 -0800 (PST)
Date: Tue, 24 Feb 2026 18:25:29 +0000
In-Reply-To: <20260224182532.3914470-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224182532.3914470-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260224182532.3914470-6-rananta@google.com>
Subject: [PATCH v4 5/8] vfio: selftests: Expose more vfio_pci_device functions
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>
Cc: Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71649-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 036E718B5A9
X-Rspamd-Action: no action

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
 .../selftests/vfio/lib/vfio_pci_device.c      | 47 ++++++++++++++-----
 2 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
index 2858885a89bbb..898de032fed5a 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
@@ -122,4 +122,11 @@ static inline bool vfio_pci_device_match(struct vfio_pci_device *device,
 
 const char *vfio_pci_get_cdev_path(const char *bdf);
 
+void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf);
+void __vfio_pci_group_get_device_fd(struct vfio_pci_device *device,
+				    const char *bdf, const char *vf_token);
+void vfio_container_set_iommu(struct vfio_pci_device *device);
+void vfio_pci_cdev_open(struct vfio_pci_device *device, const char *bdf);
+int __vfio_device_bind_iommufd(int device_fd, int iommufd, const char *vf_token);
+
 #endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_VFIO_PCI_DEVICE_H */
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 4c79557cc4e09..142b13a77ab83 100644
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
 	char arg[64];
 
@@ -216,18 +216,21 @@ static void vfio_pci_group_get_device_fd(struct vfio_pci_device *device,
 		snprintf_assert(arg, ARRAY_SIZE(arg), "%s", bdf);
 
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
@@ -314,7 +322,18 @@ static void vfio_device_bind_iommufd(int device_fd, int iommufd,
 		args.token_uuid_ptr = (u64)token_uuid;
 	}
 
-	ioctl_assert(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &args);
+	if (ioctl(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &args))
+		return -errno;
+
+	return 0;
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
@@ -327,15 +346,19 @@ static void vfio_device_attach_iommufd_pt(int device_fd, u32 pt_id)
 	ioctl_assert(device_fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &args);
 }
 
-static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
-				   const char *bdf, const char *vf_token)
+void vfio_pci_cdev_open(struct vfio_pci_device *device, const char *bdf)
 {
 	const char *cdev_path = vfio_pci_get_cdev_path(bdf);
 
 	device->fd = open(cdev_path, O_RDWR);
 	VFIO_ASSERT_GE(device->fd, 0);
 	free((void *)cdev_path);
+}
 
+static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
+				   const char *bdf, const char *vf_token)
+{
+	vfio_pci_cdev_open(device, bdf);
 	vfio_device_bind_iommufd(device->fd, device->iommu->iommufd, vf_token);
 	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
 }
-- 
2.53.0.414.gf7e9f6c205-goog


