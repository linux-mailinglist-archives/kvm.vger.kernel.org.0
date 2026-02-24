Return-Path: <kvm+bounces-71650-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KJbSAJntnWn3SgQAu9opvQ
	(envelope-from <kvm+bounces-71650-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:27:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CEC5718B5E5
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:27:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 391D3305DD63
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:26:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3E123AE6ED;
	Tue, 24 Feb 2026 18:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V5QBS5Ab"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00E83A7F54
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 18:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771957545; cv=none; b=uYihSUhtJbgCXqhp2w0aId6OqApDTGzKwKWr+7BnrrobU2HXg+h/wCxFzCUd/5uTDo28sjQ0kQj22PdAY1ah8H1yjJuV61lAMw30nClrwbE1xcYMWJAhQ98rf4/1XX4+AYEXHMM83ILo/ZCSA12prQeqcQ9S29WINIxUfCpD4Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771957545; c=relaxed/simple;
	bh=D5cFtGr3FjZqUbVXZMPOo8EQG+SRoqsZOQDRNB7YSGs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ps98Ojkn2eGNctDANKiUpBdDqq/9uk3WdVajIOUbUwStwQczcyEi6njfajuu2sJ6EfCNBR9O/1lfAvkc4G7VqiLQodhueiB8se12Bv8DpUD+0jXp7ZoiCTRAS8H2+DFNItko/y4fmAd9AgYOFAe9yOFLxUttK2PkeoeV+SCNECg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V5QBS5Ab; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7d194b631d6so81180426a34.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 10:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771957543; x=1772562343; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=76o1BjsM23otY5E0m8PR5i+qHZGjPQ7/pAlHnOvU6/4=;
        b=V5QBS5AbtCx2PLzN/JCQwQ3qAKELMjp0IMKTUfsWBqcBiimlB/60UaGaDeF4T3eue4
         0gWasYsigQaO5HUjO5b5V4ZERjisJdleBhAjbnPuxM5cTD5B6LDko+1aSdNPtGGloJx8
         fqBKMGavbdJZCISKWUfN9rHkvGJnPnPs0mXN/RT2DNjPpXrBwMYu8P8HXOf5B5dQJRzJ
         HqaJiqfH2dm0pBZnVTXt5qmXHfjFIwKhZwlLhcUl1GOkaH7Nh3+W+AvskRFTFBoeycDb
         M1s1jX0ha9gOM7c+6vtEcIe/AFBnRjojdkeanWWODcGVLnjpsiSyL5D9LYr8GQ43LWej
         OGTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771957543; x=1772562343;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=76o1BjsM23otY5E0m8PR5i+qHZGjPQ7/pAlHnOvU6/4=;
        b=h5Trs2IBVbMuoZa8TxLRge5t0b3nZgcL9+BzRvPQtGXFfBBxFcW+D0LUcU32AwU02+
         NOgQvQQj+dz2svpdjDlczwwFrVDVDn6+kXtq/B5AryFajJ7XQxFduWZaRupetCDSmhLJ
         ulmIhqNzDfPHO1OUdAIwr5Tq13WuKe+8A7b+cjArIfxsQVAsvuNZnji7GGRTGxki97Da
         6J95kngjvQry1bCLj/RRh8sScU0Vud7PnfrxWyWlzsujrF9jN053L7uT76pLX64c64ze
         zM8aCQ1+sbA+2aiqx/cDvIKZhLiEYq9LJ7sJ3NdHh+8w+jB29vO63HJG+kQjxu1NClGC
         wstA==
X-Forwarded-Encrypted: i=1; AJvYcCUnsRAnAmwcWRXc2AZsO2YTk8THLvt4EAJhx/lAIVF7WVEqvOr/4Kh4ZNQG2BGE6qu+Izo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTmJAivfwvGskqafbDCTzBazgAzVi3aoGmawNyUMiucd8GTCFp
	7NamJQupN6s/cbiSebh4iayUGYYT0Ve9R1wAIA0bIpzoDP5LSsiz6DRtwRYI1GPhjnp/EdTpd6N
	En6p97PUJNg==
X-Received: from iluf4.prod.google.com ([2002:a05:6e02:b44:b0:4b4:b52c:62e])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a4a:e909:0:b0:679:8861:f58c
 with SMTP id 006d021491bc7-679c45080c7mr6970843eaf.39.1771957542675; Tue, 24
 Feb 2026 10:25:42 -0800 (PST)
Date: Tue, 24 Feb 2026 18:25:30 +0000
In-Reply-To: <20260224182532.3914470-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224182532.3914470-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260224182532.3914470-7-rananta@google.com>
Subject: [PATCH v4 6/8] vfio: selftests: Add helper to set/override a vf_token
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
	TAGGED_FROM(0.00)[bounces-71650-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: CEC5718B5E5
X-Rspamd-Action: no action

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
index 142b13a77ab83..f15065f531562 100644
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
2.53.0.414.gf7e9f6c205-goog


