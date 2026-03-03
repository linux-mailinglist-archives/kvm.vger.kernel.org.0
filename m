Return-Path: <kvm+bounces-72588-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uDE0Gdw4p2mofwAAu9opvQ
	(envelope-from <kvm+bounces-72588-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:39:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 062291F6323
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:39:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9A236300D0EB
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71D653976B3;
	Tue,  3 Mar 2026 19:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fM25oWYW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73EB384222
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 19:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772566717; cv=none; b=ol7bqkYRSJE1hJVsfFS9SPtWVpFwb/VA1A/O9L0AtpRHs+G6+aXFvHL9p9Pl2C8neienBeJA7szT6vbn4u6FGiCq6o8YBCMqzWt44ko9/5PA6ersFGv0+iKduByv/aRmmFyJGsnaWkwGoucWSjJnVlw1CXpWHwnjCwJWI4c02DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772566717; c=relaxed/simple;
	bh=oxhmS7APbnCUHGUofsuGlwO+hnUqBHnMlenmB97s6rM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iZVT0j3TBs6swJ0QLZWrI/o4shIJuptW/BnzVfsxK6sx6PPyxwcpeaJglsU2ZQUEP570cNN+iCQKKUvwnflbV/KmpayeNtu+vxpTzCrk4RyeYjV69a0orUaAIP2knGR7LEK1w+r4J2sIJKBDELwHAImm1o9yb06pbzkG3/YCs6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fM25oWYW; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-679dcf1f680so133875728eaf.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 11:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772566713; x=1773171513; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UbzD3tYuZ5OwHztPK3YrRtp3AOj3URoZ8XrfGPi4048=;
        b=fM25oWYWWwNF/p+Mh58CuzNtB4ykFGyYkQZuj63ioCnYuZUoq0QKGIwFCysm2nWDxR
         KN5RyCAI7JsV6pZ3K2x6B5iGEy9Falj/wuOhmRdmqnBP4bdDDAUUn/44mCdLSs2WaMlO
         QHVRzlN5xjYN9RmZZwJcy80yuRnuVmv7qD4EW9oyp5bJWC25txWB30AQ2JLOgHdAqet5
         3qm1wW7xpTmVQkuvoIfs7sXda6cCOEneKT5G/1ALfi3+pkW3927IgKXN+aP633gK6NqC
         mdn835Dnlpz55+0AWun/pan/DFSu9++qsV3h8erJuovvZy0z8pZz9iPrZMfnPntp6ujG
         KoCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772566713; x=1773171513;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UbzD3tYuZ5OwHztPK3YrRtp3AOj3URoZ8XrfGPi4048=;
        b=rKKX21rthj4clkfXfBqUvcfN5SYcNByeC7VlWy5hM+tFIbcyYBAiV5uwgBg3qn3PSY
         Q8HB8tsamP8evoS8VnrwO8V8EMimZYkKGuHHhjXCggn6PEOrKujj6Gz0X30QQr9HEpyg
         Zh1mAO0pSTtr94MnVmaIBd5gLYphVvkjiGr4i4jLt6AnBJoIQa15Tl7oLBtqSUZw3wOq
         vEInxSzItit2sqvWdGuVrYAJPCb1S/eL6AE5Ku+njX0tsjyXkw5HyMC0Vn8ICj6DVj4J
         BIBDV937bb0bnJI6+KeEgBXKrC7MgDwmBmQKbuROWU7YQ0bdIKWtMSO0tTn1Yvy8AYpP
         ixxQ==
X-Forwarded-Encrypted: i=1; AJvYcCWeNaoqvYp9VFZX4z1nPnIEFI5CIx50+21/MR6/kPswFNK2uLm6WGvm/wyOvlP8UG3Z7FM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxt7mgnwTcqmPeFAErSpNZ4rlw53tlfdtvxPFIWpXAYXXUJpVnQ
	/DbZB3ZbaW8tKXaJtctkTA1FIwWPjGOxtZq8mhpq7aFcB9dtWfvka03D1J57U0y0Ysz+phkbpip
	RNlkU5+UpKw==
X-Received: from iols5.prod.google.com ([2002:a5d:9145:0:b0:95f:753b:ff52])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:1b10:b0:678:f8f3:d6cb
 with SMTP id 006d021491bc7-679fadc2b58mr11868852eaf.6.1772566712613; Tue, 03
 Mar 2026 11:38:32 -0800 (PST)
Date: Tue,  3 Mar 2026 19:38:19 +0000
In-Reply-To: <20260303193822.2526335-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260303193822.2526335-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260303193822.2526335-6-rananta@google.com>
Subject: [PATCH v6 5/8] vfio: selftests: Expose more vfio_pci_device functions
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>
Cc: Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 062291F6323
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
	TAGGED_FROM(0.00)[bounces-72588-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

Refactor and make the functions called under device initialization
public. A later patch adds a test that calls these functions to validate
the UAPI of SR-IOV devices. Opportunistically, to test the success
and failure cases of the UAPI, split the functions dealing with
VFIO_GROUP_GET_DEVICE_FD and VFIO_DEVICE_BIND_IOMMUFD into a core
function and another one that asserts the ioctl. The former will be
used for testing the SR-IOV UAPI, hence only export these.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
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
index dc8b37df8d1f1..3123ba591f088 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -202,7 +202,7 @@ void vfio_pci_device_reset(struct vfio_pci_device *device)
 	ioctl_assert(device->fd, VFIO_DEVICE_RESET, NULL);
 }
 
-static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf)
+void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf)
 {
 	struct vfio_group_status group_status = {
 		.argsz = sizeof(group_status),
@@ -222,8 +222,8 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
 	ioctl_assert(device->group_fd, VFIO_GROUP_SET_CONTAINER, &device->iommu->container_fd);
 }
 
-static void vfio_pci_group_get_device_fd(struct vfio_pci_device *device,
-					 const char *bdf, const char *vf_token)
+void __vfio_pci_group_get_device_fd(struct vfio_pci_device *device,
+				    const char *bdf, const char *vf_token)
 {
 	char arg[64];
 
@@ -238,18 +238,21 @@ static void vfio_pci_group_get_device_fd(struct vfio_pci_device *device,
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
 
@@ -259,7 +262,13 @@ static void vfio_pci_container_setup(struct vfio_pci_device *device,
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
 
@@ -321,8 +330,7 @@ const char *vfio_pci_get_cdev_path(const char *bdf)
 	return cdev_path;
 }
 
-static void vfio_device_bind_iommufd(int device_fd, int iommufd,
-				     const char *vf_token)
+int __vfio_device_bind_iommufd(int device_fd, int iommufd, const char *vf_token)
 {
 	struct vfio_device_bind_iommufd args = {
 		.argsz = sizeof(args),
@@ -336,7 +344,18 @@ static void vfio_device_bind_iommufd(int device_fd, int iommufd,
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
@@ -349,15 +368,19 @@ static void vfio_device_attach_iommufd_pt(int device_fd, u32 pt_id)
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
2.53.0.473.g4a7958ca14-goog


