Return-Path: <kvm+bounces-70129-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MAD+DQCbgmkzWwMAu9opvQ
	(envelope-from <kvm+bounces-70129-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 02:04:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D1E45E03E1
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 02:03:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A383530817AF
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 01:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A54426B741;
	Wed,  4 Feb 2026 01:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S5w9sgOK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E9B24677A
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 01:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770166869; cv=none; b=rpBWRokpHY/xUuKwa4RifKcjolLUOwFq95sq30lSj22lylbDMyIFBw9kiRT4ZJPnDyjaoQGBnBcQTlsP/qkr/rVnlmWp8UaxphkKXQkohInvCZNXBIV8NBY73ZikIR0EiaOtBJiQpm1hY0MnMJnftsq5ifxlFfnAOToRY9TMVrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770166869; c=relaxed/simple;
	bh=meRWmIXrY31FrBFGb8YW9mRyiEhUcftdtXX5LNfWTdo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qpXrPXrPIXI7YgS942wBUNQ3YF5d7bNcFCNdXlBnSvCUTDr4WZTHhvwDApm1NraAduSdn0bQxaajmtKy6GLH0VA4gi7hTcaSDMoq2Ohg/3pSv3SMLzDJtzIE5OkEPo1evlCsehDeF8FjdaDBFSJjVTqGGgrHKRokVYvzAQwcChU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S5w9sgOK; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-66497f2cd6dso13844927eaf.2
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 17:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770166866; x=1770771666; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9PsrwmgPvoL3V2W1GGLMcJD/aNZYUylwYoW0T18FZqw=;
        b=S5w9sgOK3pJ5wEqsb3fsZ6i0+DUDF+s9aP8G8uEO+IKjeai2S8xuWjaBvv+nWjGozb
         AU2h8QVwJG77vuAepCor0bnBdFD9oiE3ZjGY3x8w23ywF9HSq1a5srxVj5slEqij6WxX
         ijnip9dthxZ6ldboDhLq+bES5urq/CkuB0ks0l22CqKvXYXiR9Q9TjRX36DeB4rYp1/3
         d4x14RNCl42H2Zqa6nW0quBCJ3aK3miSzwY3iHfrGuXmaO2S9AIdOXRWbWRb8AjQSJvt
         vMdkMVuOiJiKMmvsxtJDUyp701E9CwFlvrJdwyRl73M5AcMzkLYw0wzTi2XyTYVJaFJo
         dR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770166866; x=1770771666;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9PsrwmgPvoL3V2W1GGLMcJD/aNZYUylwYoW0T18FZqw=;
        b=VVUBy6JBdrRnBdNz2udFAxN9PbJc5U+GAtRbfKu6f3eFIQ/D6odh2mSfMG3y3iCIAb
         Jc4GfvgkP4NpUtprBfxmn/axEzzRlZjbFXLk2gZjYBUntzkglAY+kRFxipm/F7QS661k
         bCzXL9wqv5Tck71Pa2gnRBq5Dz0MLD6NznGsuAh70z81MXK1u2jBl7WS1Ew4hk7s/NEH
         mKdds3tFqX4HYDHbYK7hbvupEso9Moy0ss3aGsAD+oNZ7JKmoHYp9QVxoFHLHn4Szf3U
         rnL7pAjhlduEuYbxweSOBPet7LPH3HoESajkOIx4vlD4mn7kYvK5vwqBf1/xaa2xQUZH
         1Auw==
X-Forwarded-Encrypted: i=1; AJvYcCUy2ZpV1akhSmo27sizsAVSU26g4hxi65Yey97Oog3bpilZ5gHv81DPH3UeiP4c9cBGeDU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKYmscCtjrDX/SQBxjnXtOWczlU1th/pTE/SkX+EQVBeKtFuc1
	8IIvEVjc+dxC0JAcTAJMF1t6rX/EEfxImXjGihD9XAdnFl8YSg4EWme6xSq/H7sUtXQx98gFBAz
	AqZpBnVfoVw==
X-Received: from ioda14-n1.prod.google.com ([2002:a05:6602:204e:10b0:957:4ce0:f83c])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:4a10:b0:663:c86:e9de
 with SMTP id 006d021491bc7-66a203a4c11mr550864eaf.20.1770166866231; Tue, 03
 Feb 2026 17:01:06 -0800 (PST)
Date: Wed,  4 Feb 2026 01:00:53 +0000
In-Reply-To: <20260204010057.1079647-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260204010057.1079647-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260204010057.1079647-5-rananta@google.com>
Subject: [PATCH v3 4/8] vfio: selftests: Extend container/iommufd setup for
 passing vf_token
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70129-lists,kvm=lfdr.de];
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
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D1E45E03E1
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
---
 tools/testing/selftests/vfio/Makefile         |  2 +
 .../selftests/vfio/lib/vfio_pci_device.c      | 45 +++++++++++++++----
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index e8f9023cf247..120c9fdee5c0 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -20,6 +20,8 @@ CFLAGS += $(EXTRA_CFLAGS)
 
 LDFLAGS += -pthread
 
+LDLIBS += -luuid
+
 $(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< $(LIBVFIO_O) $(LDLIBS) -o $@
 
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index a7e00d017fc6..4c79557cc4e0 100644
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
+	uuid_t token_uuid;
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
2.53.0.rc2.204.g2597b5adb4-goog


