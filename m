Return-Path: <kvm+bounces-65676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E2C6CB3BDB
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 19:17:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 310C73195A85
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 18:14:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3797329375;
	Wed, 10 Dec 2025 18:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xXi10Tcp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907E7328B42
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 18:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765390468; cv=none; b=Tk++4LOhPR5XPSjnqwLI5LXAbL4AocPI4aMz5LTilzhOwJrYaZ3btQ5DUpYtikOv1sXc2S5HYJH8T5oz3dey3YLafDof/+6OyOwANHoj4NwULif1TKIBqU7X55/bQrWmBcLVhFlw7MDr9XnP/SdPzo98DtQCTdxYErgBBxE/lys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765390468; c=relaxed/simple;
	bh=pwlFgeh1zV9BNL0tvm8yEEyE54pw7ioKi1EzIbT/3Hk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MI3MKYUoNa0pt8cz8+EJ9hPG+d2xME6g+LPTPJivXVtEU1NuR1KWrpv2mDqlLHwOJ8xmkVqjV3EFhVPmUJK/DsaFK5Wnc9Oqf4I7xeIMBXGiuMTjJAgesMZZG3f6zM5FMfb2ObYZH53gzfvmwIDWGcW60wLh4E/4kpvnNKvjh3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xXi10Tcp; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-657490e060dso92776eaf.3
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 10:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765390466; x=1765995266; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4gUwEMI4CPC8nG6DpXhg5Tl6v8j6U1PzBCdzq7Inos8=;
        b=xXi10TcpFHB83Uay3V25poivP7UPmNooomxicHJjAhe2BuMMNRc1vjRKVtXGbVoScU
         HQTJvEj9hd4+T9toWvOi3EBM7gpP6toIIe5N0YDEL3mu0AKcP+oQF1Ot3nH0JA06zbcR
         7ZPzlGJU0otoqDgYSfLu8tEqrSPK6Nrkr4UjZjaqs8ReBZjYUaVHutQqYxz7TJgaSnJf
         wP8zAZzcIlwaoVpmyUqlcxRS3ZFmjaBKAcqPs9nA8Vf7VA9e9LsYcHmbIxzEomYYEDpA
         OBgmj01JC25kfBskcmXdnOef8OoOPFajBy4Ra+W8nq5+Z9CMnkxxis926DH6NbwFYjzt
         6EZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765390466; x=1765995266;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4gUwEMI4CPC8nG6DpXhg5Tl6v8j6U1PzBCdzq7Inos8=;
        b=Iw72I3I5qXeohGgCybCmYX8P5dagHNzXppYGiO1KMoDLTp9weopZqMKQSREUFtHFXX
         rsuFhutcmQxz6dQqXu4sUCbz8padB2CKu+eeRYRFQny1GbiBfuFg9meqf61qmJ+toAhg
         frAZqprvuBOKLeEEHetdVWClaXUSuKxclgSeJj5I2b2RIGaJYomJfPyFhC6MeDZGmufL
         HexXqTe5CnBQst4IgorEeGF+0WSwfYi73rsV1SGOclyhJTjIMGkcY+YNLDDpCB6TR7t8
         P38X88OAv18/PDPbNk7dOySQH3EvLneCBOyfgnk967ACc7DywsoZr2AftBt6tPj+Hpub
         efOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWH2/pjNF4LtSa7NsB3WKN7sPsSVtVvn0E+6rUWjKBCG9KOR66UE1B4QO+Tp6bYkOj7w9o=@vger.kernel.org
X-Gm-Message-State: AOJu0YyE8eYv4NxsU2zJpZ6xf49YwL3FN9S9hoQ83NWy64W2NlchApcL
	OgwARj0iU9qFWUJG9BRh1LM3U62DqAgH0JNoK7CStnXzSLXcHp8fgPRuJhw/Y9JobIh4NYX7478
	JskojUgmVvg==
X-Google-Smtp-Source: AGHT+IHG44j9+i0T0oJH5qztj8QDLXfbSZEMuigfmk9lH3MjDr9iEI8CBWmAD9bZ6oOzQ/GYCPP3dTlLaWN7
X-Received: from iomw16.prod.google.com ([2002:a5e:d610:0:b0:949:68d:8b40])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:f008:b0:65b:257b:a885
 with SMTP id 006d021491bc7-65b2ac3ec9fmr2171394eaf.25.1765390465579; Wed, 10
 Dec 2025 10:14:25 -0800 (PST)
Date: Wed, 10 Dec 2025 18:14:16 +0000
In-Reply-To: <20251210181417.3677674-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251210181417.3677674-1-rananta@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251210181417.3677674-6-rananta@google.com>
Subject: [PATCH v2 5/6] vfio: selftests: Add helper to set/override a vf_token
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>, 
	Alex Williamson <alex.williamson@redhat.com>
Cc: Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a helper function, vfio_device_set_vf_token(), to set or override a
vf_token. Not only at init, but a vf_token can also be set via the
VFIO_DEVICE_FEATURE ioctl, by setting the
VFIO_DEVICE_FEATURE_PCI_VF_TOKEN flag. Hence, add an API to utilize this
functionality from the test code. The subsequent commit will use this to
test the functionality of this method to set the vf_token.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../lib/include/libvfio/vfio_pci_device.h     |  2 ++
 .../selftests/vfio/lib/vfio_pci_device.c      | 34 +++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
index 6186ca463ca6e..b370aa6a74d0b 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
@@ -129,4 +129,6 @@ void vfio_container_set_iommu(struct vfio_pci_device *device);
 void vfio_pci_iommufd_cdev_open(struct vfio_pci_device *device, const char *bdf);
 int __vfio_device_bind_iommufd(int device_fd, int iommufd, const char *vf_token);
 
+void vfio_device_set_vf_token(int fd, const char *vf_token);
+
 #endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_VFIO_PCI_DEVICE_H */
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 208da2704d9e2..7725ecc62b024 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -109,6 +109,40 @@ static void vfio_pci_irq_get(struct vfio_pci_device *device, u32 index,
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
 static void vfio_pci_region_get(struct vfio_pci_device *device, int index,
 				struct vfio_region_info *info)
 {
-- 
2.52.0.239.gd5f0c6e74e-goog


