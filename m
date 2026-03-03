Return-Path: <kvm+bounces-72589-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OO1SFEQ5p2mofwAAu9opvQ
	(envelope-from <kvm+bounces-72589-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:40:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CD37D1F638D
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:40:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 283B130C16A6
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3F2A3A874A;
	Tue,  3 Mar 2026 19:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lRVi6F+h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D7638423E
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 19:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772566719; cv=none; b=gDyxqsO/RSr/1cVoAaVe1iQRf6hQAXEEYkmS2AeFJjsClS7jtJQXMnspPrbML1V6/MV0E0DlKByoeSYVl62kogtPx4lgbmCLZxgE+MYlgnvAO8L4557kFGwdv+o/ITozUFVNzjG3hWZcN9udWz1kQlqFt7xe5mpes16dzEn/A9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772566719; c=relaxed/simple;
	bh=4t42tWvrlKcV4lvYfuVx3UTtWZAafmp91JTe6pU7yS0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=feVWuN5enp9wxz+PNDcUcltx5HeCtcmM5cTM6w32BmnXT0W4OKHFVY3J6xdvrPGIsHLXnweu9LUr5wsmxsTyCiyP9g5SCNkLvaXfrafCC2pEEz6FDanM8TI37LuO74t+vFD8yvOpD5q48i1lvtc8RM+PuZf1Pkdni4y5ZlcKLxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lRVi6F+h; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-679c51b2d6cso86421228eaf.2
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 11:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772566714; x=1773171514; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QW1ukqnI7vV/78Yh9+DpzQAxrAq0/IU7SQ5b40XVy3Q=;
        b=lRVi6F+hv4Kit+qb4VJ3dHeScNaBtQyrZ9zKky51FChRotle0RzR298wGXyFGvPSnl
         UJb+v+xF0Fyh4N/wVmA63vPF+cnknQ0VHpZkKe7LGY7cvtrsa6ynsUsV5gKMzAItN1fU
         QE8VQT3siWrqyRVQsJx8nwKV9OubME7uG7+gWOxNPNPD4crziIP/aFPc/mTELRmVG68q
         AviO5nxh1Wk48Xzd6THesT4GEFZmwepD4pqxSuNj1eso3xYvd/FAeCWF6G5JEW7sEGxc
         CZ7Xi59cQPvCljSkAFzdHCfk+FqXZluyby1tx5FMnIMXfRwJrDQkT7+gYDZrwNTso4DL
         Ridw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772566714; x=1773171514;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QW1ukqnI7vV/78Yh9+DpzQAxrAq0/IU7SQ5b40XVy3Q=;
        b=rbksE0OJw6yEe3sfJnZgGj5ptWaVcoihrLI0Zmd8z5W9+hUIVqstKzq6tQxl3t3flO
         075UI39/8I/aw0MsVeu4qxzviyiztFo1r9lE7qU5l7/XFUTfm75/eplLEiQb1Z0TDhVO
         2WUyjVKA2FUlFRWVDKBhFC3bZj4qQZUXRU91CjgQZu2h6SMed3BHErBlG2FXyL6KJU7t
         x2F+OkjcN66F0W+WXs2VW8IgWFkXM9eJjLqfgaQZ1sNpbgjbnuKtUG4skBlI0kMRXCNJ
         KwffjWO50CJoG7qIZfGxNoDuKpoQIU9gd//bTy99h8aCIx9OjFXwRHi6DBdjEt/wVhMG
         MT6A==
X-Forwarded-Encrypted: i=1; AJvYcCUoMDeC+w5F3cQSoB2/PKQFg2QjMb2S2+Tf8EAhQ2wGHwbwxhWFhonyi7WF+yzd5wTx9W0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlVmmTzoN3s880aPe13UlEk99CLjU7D/YTJN6xelqBoaxuBuFd
	8/z0ZsfSiCPx11I8VAVK40+Li5wwR3WB3ZJKyoNAaqCXaxGEhqNkV/6FycwmuxTyi3yrpbZFCfJ
	XZHO9MQ6q1w==
X-Received: from ilbby5.prod.google.com ([2002:a05:6e02:2605:b0:4d4:4196:1ade])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:4de9:b0:679:e85c:10e7
 with SMTP id 006d021491bc7-679fadc2b88mr9666644eaf.9.1772566714118; Tue, 03
 Mar 2026 11:38:34 -0800 (PST)
Date: Tue,  3 Mar 2026 19:38:20 +0000
In-Reply-To: <20260303193822.2526335-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260303193822.2526335-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260303193822.2526335-7-rananta@google.com>
Subject: [PATCH v6 6/8] vfio: selftests: Add helper to set/override a vf_token
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>
Cc: Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: CD37D1F638D
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
	TAGGED_FROM(0.00)[bounces-72589-lists,kvm=lfdr.de];
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

Add a helper function, vfio_device_set_vf_token(), to set or override a
vf_token. Not only at init, but a vf_token can also be set via the
VFIO_DEVICE_FEATURE ioctl, by setting the
VFIO_DEVICE_FEATURE_PCI_VF_TOKEN flag. Hence, add an API to utilize this
functionality from the test code. The subsequent commit will use this to
test the functionality of this method to set the vf_token.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
 .../lib/include/libvfio/vfio_pci_device.h     |  2 ++
 .../selftests/vfio/lib/vfio_pci_device.c      | 34 +++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
index 898de032fed5a..4ebdc00e20fca 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
@@ -129,4 +129,6 @@ void vfio_container_set_iommu(struct vfio_pci_device *device);
 void vfio_pci_cdev_open(struct vfio_pci_device *device, const char *bdf);
 int __vfio_device_bind_iommufd(int device_fd, int iommufd, const char *vf_token);
 
+void vfio_device_set_vf_token(int fd, const char *vf_token);
+
 #endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_VFIO_PCI_DEVICE_H */
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 3123ba591f088..4673b148f8c44 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -113,6 +113,40 @@ static void vfio_pci_irq_get(struct vfio_pci_device *device, u32 index,
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
2.53.0.473.g4a7958ca14-goog


