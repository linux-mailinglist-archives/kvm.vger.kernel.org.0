Return-Path: <kvm+bounces-70130-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aGiHIMKbgmlgWwMAu9opvQ
	(envelope-from <kvm+bounces-70130-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 02:07:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 09ABDE04BD
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 02:07:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 075483103BD3
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 01:02:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EF1327587D;
	Wed,  4 Feb 2026 01:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2CSZt8Ch"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AC625A33F
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 01:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770166870; cv=none; b=TxJFqKicVBDkWVNa+GB6qnnbwhPcWD+RfZ4kAzIsiJyRaugxDS8xN8GFHoBWDeYNOdeonPaCsmpVlgPqa5F4ArMoHQPoGnp6CYMduizRdnkNd/8sjfT/QBkuCiD7uxWl1zaViD977glDIK8eCvArJLBIrmd46onJAjH1waDqTbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770166870; c=relaxed/simple;
	bh=+vdQEGyCwSDq42HprLYyZAxVP9gA4Sg0HO4ld5kKHfs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PC297I2Fvv2LIy2Px6uB2v9Vn5XVGRgoOTdTmfwUQA/0TIGko/tZskMDnnwPNLuozuBTsY7BIKN8hppewthD+JwtbJnqCBR0SUidRxiBfLWkzIJoLCgVuyiI4Z8UOj5+lQOJlCp3KmDQPnQv6DZRHgni9G4NiwP+Uhrlw2ET6KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2CSZt8Ch; arc=none smtp.client-ip=209.85.160.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-40951019a1dso24892152fac.1
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 17:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770166867; x=1770771667; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0udRq4j88lomrvASezCNuuV2zCz1GvvKR3IJOID3phM=;
        b=2CSZt8ChnE/IHXY0bUrS8EYfOV6q4VE7+DjNT4CB889byXiEud5g4MjRrqPS1leYaL
         P3p/tIgeUYPI945pm55E6YRHKI2K19wKp4T5cHJaIt4RcBHH69rG9w/RdnYb+x4FyeVq
         e6deu44qT1l9vBMoDT/MoEyjFVpZAOwtdp+vkRLTbWF4SKdveTPqD098ceLwu1XNQ8Ul
         qgV0/C4DG88mgFCra4G4L9C6HtqjI0jX2rAk7UA/VXA1MMwyFJpb9cf1C3kUcBzAfeDZ
         C9Uty/xKkHiSF54uo8H/BwPR1MlkpvxG4CM29vqlOhOzSG5+qKpriGNp/cIHrkeJroCw
         IR6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770166867; x=1770771667;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0udRq4j88lomrvASezCNuuV2zCz1GvvKR3IJOID3phM=;
        b=MgTZ3d1ALud2I/iWprcb6pT7xWrr6WEPuRmDtJQAnwWVsDr+CwckfPu/Jcg3RavYqS
         VMGS3LE9EGgx5P+YkpFWx2pYfdIkzaHcGzro64WJM5GZt9/z8/HAidVX438h4Keh2aRp
         t0BLKB8/j/i+c8pNTo7ykqa3P+2mhV4nkKA6mJtYmQXp01TxfB5p7nqGRCkNFMhEbxJ6
         UUZMoTJzDLA2e+56WH2lY9pTmO63ko0BSsBwlkqf00cKBsRWwKnz84hE1ysrD+UK8YCZ
         U11tR8lTnU0elQbD5HZaPUOhL0NL/JSR1voHRFN+1GYc99Xct4o5c52UnGC1Q1ay56EW
         bTnA==
X-Forwarded-Encrypted: i=1; AJvYcCV0CKKNtHF9aVWIKKyzKLycIsXwc1HuDRukFn1LAizMnzgpoTPUvNybIot1GXwEWMtV1MY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQAaOvDUWPBPl7YZmHfhmD3Xow4lMAd0N1yOHYyXGOQ1Fuwvqe
	uizETe9/WjqRLCEuNJEuB98wUK3nQGha5VuIec605ZsF/i3W+ji3DLceEWvPUkhe1YI/6lIJUFZ
	SLqFIw7QMpg==
X-Received: from iock2.prod.google.com ([2002:a6b:6f02:0:b0:957:7451:a858])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:602:b0:659:9a49:8fd9
 with SMTP id 006d021491bc7-66a23df34aemr676968eaf.82.1770166867191; Tue, 03
 Feb 2026 17:01:07 -0800 (PST)
Date: Wed,  4 Feb 2026 01:00:54 +0000
In-Reply-To: <20260204010057.1079647-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260204010057.1079647-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260204010057.1079647-6-rananta@google.com>
Subject: [PATCH v3 5/8] vfio: selftests: Expose more vfio_pci_device functions
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>, 
	Alex Williamson <alex.williamson@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70130-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 09ABDE04BD
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
index 2858885a89bb..898de032fed5 100644
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
index 4c79557cc4e0..142b13a77ab8 100644
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
2.53.0.rc2.204.g2597b5adb4-goog


