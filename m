Return-Path: <kvm+bounces-72587-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YBWRDRY5p2mofwAAu9opvQ
	(envelope-from <kvm+bounces-72587-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:40:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A8B091F637E
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:40:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EBCA930B4779
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C03DB3976B6;
	Tue,  3 Mar 2026 19:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rpBT5V0Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001B021771B
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 19:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772566716; cv=none; b=hN5Qdoi4p4fD6nMx6iw5spODbA9AmIUYqPVzTyTv9kxZTV4MDjRlYZEzZUP5/EqiPIDS+JE59vwdTJjoNFZlOh7nAK9m7wibm4dtMnWofN7uBMeZH+x5teDX9dznYVCOYpQ6isjDzb/Jf6Cu5HvzjfX/aAq4arjXF9w380CFnyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772566716; c=relaxed/simple;
	bh=gEp5dckqG5cP6r+qRr0XG/bWUuqISDwDcz3OMbSqQOA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h2ZPsr2WFMZXxzQO+n8VMec/dDlG8yuZlkc7I8uHJ8cobFEJaB3Y00NGWGOpBKm6WjsZKeoEkvV3E8YCARQ3SXcEhrZJpgo4FoGpW+1Mk8d0yNQZv3+0tMjtZeiURmjEHBhpBD41OU67gxDR6V5LcL33C9IOeCI+nRJjX7wAIa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rpBT5V0Z; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7d4c3d9dd70so100945333a34.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 11:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772566712; x=1773171512; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0LK6yP7R5CEoceLoxZTwdESH49A+lkP7zsPWLGIA5lg=;
        b=rpBT5V0Z1z/OcdY0pbGbqBVmaueYLpV7VKZ7yrGYIbdzsbelIKqU1Nl4cVFq/1znXQ
         XpA1AaDCUUucVUQh8ZxPlAPehe2mE08pRth54L76H2GRLoDNm3tLKzI2sI7dUC5OfhiF
         teQXDaEHWIfS5PJb23BW2aHHCf3BRuvHCY4+A71ZbtFnSrqImQIy+GvghsM2D3jp5Yoo
         fybNMkgRN9vBCKF19OFksabTHi+I6W3FlX5s3OBmz+qEAYsRLigLUX1Y7l7yGKxJQVE8
         THz6S/b9eg3HWk9X0zK6YYTkrATdMQcJJvMOqvcOkHX+HrBuTqRE8mQYb+TSr8oFrIGW
         GWOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772566712; x=1773171512;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0LK6yP7R5CEoceLoxZTwdESH49A+lkP7zsPWLGIA5lg=;
        b=ry1+K3X8v6wVtzYIiRtu7SlwyAUkaRtVk7NQBW6BvFkgowCQpRSybtb1mXrO9N6+LU
         +WpsmwEzt/7eSwGay1d2F2xusSClU7Q+VFYSay1GdGvaek3f4zEyGl60Ks5xno25VaTj
         Eav7JGg7n5thr9T+ee5BUw8X5BQZv+1HgVtiWZ/5NMmVDfd01nAfv19wTwFEgvkg0dDs
         XCpdVGz++29NKKT9mmXbhKC4lyKWAwpUOVea913crbkJDOCIbA7XWrALP8CHGiB7lHIr
         TAAQYCaGqUr4w7aV180cEy/QykDNOfEF6GmhXe2FS7x6Y0LCQdW7guIPWTiT0mmXEvRG
         d3Pw==
X-Forwarded-Encrypted: i=1; AJvYcCWIepRaubDX6QSPCV50pfp2E/Dq5uy70kiPEzdWwOyyf9GvaNTfi49DWLwKyWGWi6EU/vs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVY/J0fMc78RoRfajm9S1GzATDmW8ImNWXhFaID14JBvKbRr/s
	h1IsPWNvgUbisaURuQK6L4SV2MSP4zfo2ceh4dGalqZb3qWiM4/G7BfhXTb2F6JUEMS4GcP8bH1
	xWsb8pltwxQ==
X-Received: from jaad15-n1.prod.google.com ([2002:a05:6638:c78f:10b0:5d1:5fa2:71ef])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:2214:b0:67a:2256:e70b
 with SMTP id 006d021491bc7-67a2256ed3amr763619eaf.41.1772566711689; Tue, 03
 Mar 2026 11:38:31 -0800 (PST)
Date: Tue,  3 Mar 2026 19:38:18 +0000
In-Reply-To: <20260303193822.2526335-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260303193822.2526335-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260303193822.2526335-5-rananta@google.com>
Subject: [PATCH v6 4/8] vfio: selftests: Extend container/iommufd setup for
 passing vf_token
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>
Cc: Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A8B091F637E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72587-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

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
Reviewed-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/Makefile         |  2 +
 .../selftests/vfio/lib/vfio_pci_device.c      | 46 +++++++++++++++----
 2 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 6a9ac6dd32cb6..f27ed18070f14 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -28,6 +28,8 @@ CFLAGS += $(EXTRA_CFLAGS)
 
 LDFLAGS += -pthread
 
+LDLIBS += -luuid
+
 $(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< $(LIBVFIO_O) $(LDLIBS) -o $@
 
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 82f255f0486dc..dc8b37df8d1f1 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -22,6 +22,8 @@
 #include <linux/types.h>
 #include <linux/vfio.h>
 
+#include <uuid/uuid.h>
+
 #include "kselftest.h"
 #include <libvfio.h>
 
@@ -220,7 +222,27 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
 	ioctl_assert(device->group_fd, VFIO_GROUP_SET_CONTAINER, &device->iommu->container_fd);
 }
 
-static void vfio_pci_container_setup(struct vfio_pci_device *device, const char *bdf)
+static void vfio_pci_group_get_device_fd(struct vfio_pci_device *device,
+					 const char *bdf, const char *vf_token)
+{
+	char arg[64];
+
+	/*
+	 * If a vf_token exists, argument to VFIO_GROUP_GET_DEVICE_FD
+	 * will be in the form of the following example:
+	 * "0000:04:10.0 vf_token=bd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
+	 */
+	if (vf_token)
+		snprintf_assert(arg, ARRAY_SIZE(arg), "%s vf_token=%s", bdf, vf_token);
+	else
+		snprintf_assert(arg, ARRAY_SIZE(arg), "%s", bdf);
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
@@ -238,8 +260,7 @@ static void vfio_pci_container_setup(struct vfio_pci_device *device, const char
 	 */
 	(void)ioctl(iommu->container_fd, VFIO_SET_IOMMU, (void *)iommu_type);
 
-	device->fd = ioctl(device->group_fd, VFIO_GROUP_GET_DEVICE_FD, bdf);
-	VFIO_ASSERT_GE(device->fd, 0);
+	vfio_pci_group_get_device_fd(device, bdf, vf_token);
 }
 
 static void vfio_pci_device_setup(struct vfio_pci_device *device)
@@ -300,12 +321,20 @@ const char *vfio_pci_get_cdev_path(const char *bdf)
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
+	uuid_t token_uuid;
+
+	if (vf_token) {
+		VFIO_ASSERT_EQ(uuid_parse(vf_token, token_uuid), 0);
+		args.flags |= VFIO_DEVICE_BIND_FLAG_TOKEN;
+		args.token_uuid_ptr = (u64)token_uuid;
+	}
 
 	ioctl_assert(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &args);
 }
@@ -320,7 +349,8 @@ static void vfio_device_attach_iommufd_pt(int device_fd, u32 pt_id)
 	ioctl_assert(device_fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &args);
 }
 
-static void vfio_pci_iommufd_setup(struct vfio_pci_device *device, const char *bdf)
+static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
+				   const char *bdf, const char *vf_token)
 {
 	const char *cdev_path = vfio_pci_get_cdev_path(bdf);
 
@@ -328,7 +358,7 @@ static void vfio_pci_iommufd_setup(struct vfio_pci_device *device, const char *b
 	VFIO_ASSERT_GE(device->fd, 0);
 	free((void *)cdev_path);
 
-	vfio_device_bind_iommufd(device->fd, device->iommu->iommufd);
+	vfio_device_bind_iommufd(device->fd, device->iommu->iommufd, vf_token);
 	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
 }
 
@@ -344,9 +374,9 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iomm
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
2.53.0.473.g4a7958ca14-goog


