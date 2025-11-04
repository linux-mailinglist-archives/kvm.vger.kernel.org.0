Return-Path: <kvm+bounces-61930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BCB2C2EA2A
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 01:36:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C99118833C9
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 00:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B75921FF48;
	Tue,  4 Nov 2025 00:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xjHusNKA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3604F207A09
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 00:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762216551; cv=none; b=WyAGjOzKWO7WMQcpVCyLcPzZf95nlBfEXiuA32krkk7QKU86T1yG7+VgR6EBQRUYYoYMzIjCBvmQoqIsDJVXyYASLxE1FCjdOEKO7mJVKGuOM2urTLw7FubuF8AbQHOmHS8kcnQgZKFIfKS0Gvca3NA9sc7x0OZsrEGG+dEwluM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762216551; c=relaxed/simple;
	bh=uGK2yal742+L5uk1T2yEsKAxi7zImwe71HR1cOhVFBc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=szoF5/u6FFZV0fg0uJwCneY7ntwX/daSAKTFfwW3V2qABZup7hpbJzozz4Tgxa0Gh7IKOA757QgCyT6Lked2/B33jqWmT+BH/sZZr1V8SsvVPuuKEQ4ulyDzXFBIZR61fz6oKsE8lUU0UuNABgibF2bB7N0QIX+g25D4+48t3m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xjHusNKA; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-4333035774fso16319585ab.2
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 16:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762216549; x=1762821349; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GF5TG07a1gbc3wTybx+JCwQT1BRdxgUx9VY9r9yva38=;
        b=xjHusNKAIfVIhZD/DssHhJSQVqiDOTWam9KmB9mcqNmASN7ur28mxDFAayeeeWa8Vi
         Sx/LQt89sDi7X2GN5ik7cfwGMC94K81jxPuVQXgqPMEnqWRPEzPOW42Orgc4VryLbXnD
         bJFND3bzZiBbcGdBMypi2gJtGyfaJcWTgGdO9FUC8hDjvVl7XzgvC13Z02+tTw2yoCtz
         Qj7ezDVL0nSKArtTDh3qXWP2kuoLCPvUeHpMaJiXzhaOLw4IDFMvBv4W9CTYcZlzjgPo
         kR+Q7acHsVwRoEZbJuVLBLzqPs8+Vp6qiAH5LBe+5TioLllR0XSK+6lgbK9zu+an5wg1
         incw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762216549; x=1762821349;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GF5TG07a1gbc3wTybx+JCwQT1BRdxgUx9VY9r9yva38=;
        b=RwCCvWDFy/0aje1a5c0LWmLOr2Db/a8ZUOHVypsk9qgJi5k6dteoesE92xtHf6D8Yv
         gsj1sFih4uMJ6gFotJflTACojSTAKCZV4zSqPmNn0IqMUWxDbMejOIXzpVgKbtCTY4oF
         oZqL838EdVQ7ndEUsp2kNH+YDmCYimWXoXadGNFXjOpe53g7GW7R6mtH+FHJKXfBtsJh
         ZVH8Uz00M1EU6kD7DJYe452Os60I/BZe+L/lAIjDlOkrsBNhpGdb+sXN/GK+Zhighge7
         81fa6VsKnBXOxtB0CQM1NO//UVnhY9RyyQ76OsOYa4qz3NMwaE41JHZ8bLCTikJs5PRy
         oGyQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlSWwM0Z3/fCLa1K71iT5Kwkkz8YPS03sTACTBA0oPI9hsC9DvGukNayLBLQ+VX/Kbtss=@vger.kernel.org
X-Gm-Message-State: AOJu0YwX8qBK1kqhCFLJWvLUcRfpW1GfMKIVG+4oDlnALuSBedA3uCx4
	amKugGtAF1K95m1i32P0oDmKHSzsktSEsG5UPREFnb799kAaIaw9TmiH1vsEsbs4xRYCMx1AKLt
	q4Ggyuq1WvQ==
X-Google-Smtp-Source: AGHT+IF8Q031DG4uDTX0YteuJO/98OOb+2PRRF1bW+brFBXJOSsraipfCPKDFyV4JvE0wkGPqNgytRHV3VGn
X-Received: from ill17.prod.google.com ([2002:a92:c651:0:b0:433:1d1f:6919])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6e02:1543:b0:433:2fa2:a55d
 with SMTP id e9e14a558f8ab-4332fa2a76emr79592985ab.12.1762216549069; Mon, 03
 Nov 2025 16:35:49 -0800 (PST)
Date: Tue,  4 Nov 2025 00:35:35 +0000
In-Reply-To: <20251104003536.3601931-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251104003536.3601931-1-rananta@google.com>
X-Mailer: git-send-email 2.51.2.997.g839fc31de9-goog
Message-ID: <20251104003536.3601931-4-rananta@google.com>
Subject: [PATCH 3/4] vfio: selftests: Add helper to set/override a vf_token
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>, 
	Alex Williamson <alex.williamson@redhat.com>
Cc: Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Not only at init, but a vf_token can also be set via the
VFIO_DEVICE_FEATURE ioctl, by setting the
VFIO_DEVICE_FEATURE_PCI_VF_TOKEN flag. Add an API to utilize this
functionality from the test code.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/vfio/lib/include/vfio_util.h    |  2 ++
 .../selftests/vfio/lib/vfio_pci_device.c      | 34 +++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index 2baf12a888e67..f0a12646456a9 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -307,4 +307,6 @@ void vfio_pci_iommufd_cdev_open(struct vfio_pci_device *device, const char *bdf)
 void vfio_pci_iommufd_iommudev_open(struct vfio_pci_device *device);
 int __vfio_device_bind_iommufd(int device_fd, int iommufd, const char *vf_token);
 
+void vfio_device_set_vf_token(int fd, const char *vf_token);
+
 #endif /* SELFTESTS_VFIO_LIB_INCLUDE_VFIO_UTIL_H */
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 7a1547e365870..c0fa4e27a96ef 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -144,6 +144,40 @@ static void vfio_pci_irq_get(struct vfio_pci_device *device, u32 index,
 	ioctl_assert(device->fd, VFIO_DEVICE_GET_IRQ_INFO, irq_info);
 }
 
+static int vfio_device_feature_ioctl(int fd, u32 flags, void *data,
+				     size_t data_size)
+{
+	u8 buffer[sizeof(struct vfio_device_feature) + data_size] = {};
+	struct vfio_device_feature *feature = (void *)buffer;
+
+	memcpy(feature->data, data, data_size);
+
+	feature->argsz = sizeof(buffer);
+	feature->flags = flags;
+
+	return ioctl(fd, VFIO_DEVICE_FEATURE, feature);
+}
+
+static void vfio_device_feature_set(int fd, u16 feature, void *data, size_t data_size)
+{
+	u32 flags = VFIO_DEVICE_FEATURE_SET | feature;
+	int ret;
+
+	ret = vfio_device_feature_ioctl(fd, flags, data, data_size);
+	VFIO_ASSERT_EQ(ret, 0, "Failed to set feature %u\n", feature);
+}
+
+void vfio_device_set_vf_token(int fd, const char *vf_token)
+{
+	uuid_t token_uuid = {0};
+
+	VFIO_ASSERT_NOT_NULL(vf_token, "vf_token is NULL");
+	VFIO_ASSERT_EQ(uuid_parse(vf_token, token_uuid), 0);
+
+	vfio_device_feature_set(fd, VFIO_DEVICE_FEATURE_PCI_VF_TOKEN,
+				token_uuid, sizeof(uuid_t));
+}
+
 static void vfio_iommu_dma_map(struct vfio_pci_device *device,
 			       struct vfio_dma_region *region)
 {
-- 
2.51.2.997.g839fc31de9-goog


