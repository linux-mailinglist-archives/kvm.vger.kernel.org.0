Return-Path: <kvm+bounces-70132-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QMdmFDKbgmkzWwMAu9opvQ
	(envelope-from <kvm+bounces-70132-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 02:04:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E320AE0426
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 02:04:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B8E373139192
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 01:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 253C8283FDC;
	Wed,  4 Feb 2026 01:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mB2jinRy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C81726ED5C
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 01:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770166872; cv=none; b=RW1Rx9N3U80vQrElyyrd1QW8AuIqg9V+flePxZaylmqBNsrMv+eOi59kZq3diqgGrrlCKQKgdItQShcSLJwarYBWWpAJi9XIzhVuE10u+N+GGmAn41gc/vpkk2YIogiXnjA5pbmid3OEoHqqKHb9XfTciqHK8DTQvavyocD0IPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770166872; c=relaxed/simple;
	bh=0xtJ+pqCo/uE1p9MpFM/9m9xzVYuLjsVR39VzqvKZ/c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XQa2NlAlvTNqsJ2ziRrHbsrIekl1gzVqUVOQWSnNNlzZ0geOI/d41MdX+me7S8/jP6/N7yr4NNp6fZqkQB59NwbJE1ZM+zdyYanvFWfVuJOLKX7a0lZkiBziipQlst7h9LKRoqXUQzmsVnVOP7KQbicS6Vu+QhvF+9k+3toPacs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mB2jinRy; arc=none smtp.client-ip=209.85.160.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-40948b7e832so23483599fac.0
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 17:01:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770166869; x=1770771669; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A3FiC1IXjLa+0JqDoxdMPEgWbheV2hH/CBO7B1cQRs0=;
        b=mB2jinRyCejaTJu333RBfbMRNG5YUZ/QHtE26tp4VH28gJRxDf5hCZez80dFO49PwQ
         FtYISwNOsgZ8bRko+IzcJ7xOE+BrYwzvuF5JXoYNyzKspKzVcO3zHE2OPJ9ijRU4kPtK
         lFeuycyjChm3dRgtsb9NaaDf4B4d4BrLGIv1QHFaZsyb42tmvCi25O7v083u8oFOom3z
         YT2pok9NwjvOms/6tT2cZ+v86MO9wZk7wt/TOa5YqIPn6d96VVquHxHprbejkbQKyr7G
         dW4z4wGL5v5VHz4AX69kmAxGJ5NBfDnbXHyvWFgStlGNMtV4V9zOh3V2I3Advbnl31g/
         9l+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770166869; x=1770771669;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A3FiC1IXjLa+0JqDoxdMPEgWbheV2hH/CBO7B1cQRs0=;
        b=wn1Rqq1obpFqV94DK7xbqNX0VGv4ZUWdj92QnmQHniEHj12V9I1ckDi/tcvgU8ppPV
         p/BNJGaRn9wJQw2IRS807Dm+bj6t01URkvgqRy8Jn8D9zchelcD4edrW/rajIxZ0ga77
         D3ly7zDfvKdIia6x12wR2SSaF7dwy3LtAQ2rG7jgaVKE/kdf3ebRyacCQy4Bv+KJuSzq
         EV16aBsVHiWlFDr+BSPDHIPMi929yyztgAvVMbWc/5HgBtvNhVLorh38eMGZJdCule9F
         Bsst/Q1ctjQ1x/165VWiBaee2OsPHQCXdX4AQ8PX5730aK0rU4upokw8Fqx3774PMkab
         yw3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVTtlB4oGXzInBBEA1fvcQJV1oOgmGNEgxVmMhtYWfS6jV1eAyn+iiyHB3ddNJs1iGoQbk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoLs8KPiFupmWMxI63+UwTQ6vnVTDsGfl5hzNzGba3xlpSVYKZ
	XKFlWDTaeDG9e+Sl1fZFl7mMrltZfDz/DrrJmaO2h+2i0WaW7kliz79Hc2Spr98L8gB5UkPtO6H
	8gwvQ+wQ0Gw==
X-Received: from oagg5-n2.prod.google.com ([2002:a05:6871:5:20b0:404:63d0:3ed2])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6870:400d:b0:40a:5f51:c9e5
 with SMTP id 586e51a60fabf-40a5f522243mr32311fac.42.1770166869395; Tue, 03
 Feb 2026 17:01:09 -0800 (PST)
Date: Wed,  4 Feb 2026 01:00:56 +0000
In-Reply-To: <20260204010057.1079647-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260204010057.1079647-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260204010057.1079647-8-rananta@google.com>
Subject: [PATCH v3 7/8] vfio: selftests: Add helpers to alloc/free vfio_pci_device
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70132-lists,kvm=lfdr.de];
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
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E320AE0426
X-Rspamd-Action: no action

Add a helper, vfio_pci_device_alloc(), to allocate 'struct
vfio_pci_device'. The subsequent test patch will utilize this
to get the struct with very minimal initialization done.
Internally, let vfio_pci_device_init() also make use of this
function and later do the full initialization.

Symmetrically, add a free variant, vfio_pci_device_free(),
to be used in a similar fashion.

No functional change intended.

---
 .../vfio/lib/include/libvfio/vfio_pci_device.h |  2 ++
 .../selftests/vfio/lib/vfio_pci_device.c       | 18 ++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
index 4ebdc00e20fc..3eabead717bb 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
@@ -38,6 +38,8 @@ struct vfio_pci_device {
 #define dev_info(_dev, _fmt, ...) printf("%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
 #define dev_err(_dev, _fmt, ...) fprintf(stderr, "%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
 
+struct vfio_pci_device *vfio_pci_device_alloc(const char *bdf, struct iommu *iommu);
+void vfio_pci_device_free(struct vfio_pci_device *device);
 struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu);
 void vfio_pci_device_cleanup(struct vfio_pci_device *device);
 
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index f15065f53156..6f3f65021bd6 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -397,7 +397,7 @@ static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
 	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
 }
 
-struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu)
+struct vfio_pci_device *vfio_pci_device_alloc(const char *bdf, struct iommu *iommu)
 {
 	struct vfio_pci_device *device;
 
@@ -408,6 +408,20 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iomm
 	device->iommu = iommu;
 	device->bdf = bdf;
 
+	return device;
+}
+
+void vfio_pci_device_free(struct vfio_pci_device *device)
+{
+	free(device);
+}
+
+struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu)
+{
+	struct vfio_pci_device *device;
+
+	device = vfio_pci_device_alloc(bdf, iommu);
+
 	if (iommu->mode->container_path)
 		vfio_pci_container_setup(device, bdf, NULL);
 	else
@@ -440,5 +454,5 @@ void vfio_pci_device_cleanup(struct vfio_pci_device *device)
 	if (device->group_fd)
 		VFIO_ASSERT_EQ(close(device->group_fd), 0);
 
-	free(device);
+	vfio_pci_device_free(device);
 }
-- 
2.53.0.rc2.204.g2597b5adb4-goog


