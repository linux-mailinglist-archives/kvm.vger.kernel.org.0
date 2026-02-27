Return-Path: <kvm+bounces-72245-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IBFqMqIromk/0gQAu9opvQ
	(envelope-from <kvm+bounces-72245-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:41:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3683C1BF0E9
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:41:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C5E3E3163BD2
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0B7B47AF5E;
	Fri, 27 Feb 2026 23:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HQKzTAeN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFA34779B4
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 23:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772235577; cv=none; b=QAxrOq7IlB/fmpl7ebLxywUQTABG2N9hmuI06Ml+Nm6utFIEmrNbKyk40ZuoJ/5zTDp0b9QXrCvShSw/5+20N7X6/OCkBTTj4dvZIFbUSVp2kPZxJRqyOQt6Pb3fDw0srRhaMW/dUc9H5DWuP+kFRqgJFI4zBv3Q42VzOuDqXZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772235577; c=relaxed/simple;
	bh=gEp5dckqG5cP6r+qRr0XG/bWUuqISDwDcz3OMbSqQOA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nBTFfrKL4TZlpctNg6TxSNM471O4EtRaATaizeo1BnLE9cQCdI4MxNqkW0xacj8RLgtH2goM7B7h2gBl60UT3JrhWycdHTcaaLVdC7gc/OIfdDc8P6rHQYiORqLBbJLN5jucwwK4+AI/o9gKoj95blNa5DR3bOX7dKVsrKBwJV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HQKzTAeN; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-67995e1ecacso55212278eaf.0
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 15:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772235574; x=1772840374; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0LK6yP7R5CEoceLoxZTwdESH49A+lkP7zsPWLGIA5lg=;
        b=HQKzTAeNGyUdjFLrCE3hbvZFpzfJS3eAr3RQn1dKGNhop3vIWP/NFhGcn0cBYagQyD
         DXkv81e+wJLVxzRBW/CPTxqJve6j8ysFM6vn6fwzgwGBwnqMVHtOr8JWFZQY/aELCCgT
         ZlMSvD6COGKgFEuJ4aATC8n56/yokRiWDd0DuVHzzjhMfLF6y/OQ0K9O0+RUpdI7h0pA
         WAfOvV/3t2rURQw15z3yPE8xy58OQONczam1aO9KLOA2WqRXQ85ak9cYX0Wc7W0OOmcJ
         Cnvh8EVZTtiGWWHaC3Rbqm1TqcjMlLBZirJoAMztAAX6++VyktDM599wrWwJAJprTSFW
         koew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772235574; x=1772840374;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0LK6yP7R5CEoceLoxZTwdESH49A+lkP7zsPWLGIA5lg=;
        b=XcHy/TH6ALZa0tb4ws+9yHbUzxN1G9f3M6XcllWqcIb2z9v6gl+ynCK5AXfFzb9OZp
         SnDSRKUYut07rZliKijlxEDjG1gVMg4TAnR8o7Cq22Kfw30/KeSChji3LnewTA9Qunsn
         8ShIWjaosatw+XXdSiaoFqtk2BBz5fJwSXN2AHfvSUuexyn+25qTdGDQTe7vMoYtHrwV
         HLhu9EgpwM5h0zaK3NA/iQaIe96rFUPzMCY6+Sep6zwGxe3/8qV/DgvRSDDSa9EPc0JI
         7m0Es9oZyzN4gAbh1NfqL49QqQ0bw+ZNJHeq/bbawEgWfzAlZSZl94hbFiDKfFladcSX
         QMkg==
X-Forwarded-Encrypted: i=1; AJvYcCXKWNw1hcxy+XJiKgu5aGbnbHkL2N0qZlT84D97iXFj6yvRY5kS+EMZmRo9viCGvoL3Vbo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdmQGdIozKQ2ICJ9QGXERh5Dl2tQ/YZzgrPXu0bDEdegyXC647
	tGYUFkbkRWCNFnjmhfgztO+nw2U90fUanqPuwe+RIFTJ9ji4Pl/W6pJHqXRTRsUoKwEmGdjiC7/
	JNnf7G1IEYQ==
X-Received: from ilkg5.prod.google.com ([2002:a92:c7c5:0:b0:48b:c9f5:33ef])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:4a11:b0:679:a4bc:9f88
 with SMTP id 006d021491bc7-679faef89fbmr2252128eaf.47.1772235574326; Fri, 27
 Feb 2026 15:39:34 -0800 (PST)
Date: Fri, 27 Feb 2026 23:39:24 +0000
In-Reply-To: <20260227233928.84530-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260227233928.84530-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260227233928.84530-5-rananta@google.com>
Subject: [PATCH v5 4/8] vfio: selftests: Extend container/iommufd setup for
 passing vf_token
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72245-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3683C1BF0E9
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


