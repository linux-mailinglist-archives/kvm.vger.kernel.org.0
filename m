Return-Path: <kvm+bounces-70131-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YBy1LSibgmlgWwMAu9opvQ
	(envelope-from <kvm+bounces-70131-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 02:04:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2170AE041F
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 02:04:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E5C92312E114
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 01:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23AE827B32B;
	Wed,  4 Feb 2026 01:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OYBShe2A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7156D267B05
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 01:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770166871; cv=none; b=ZJeNxQJfTFw7scRjznAnl6cVPAZah0uwM9p47DsGHtEaYqD+4CGzcUNSRsqK6MUUaK5YZI9oAKRfCnC5T8hiKT0ZmlhX35yqPr/JfwqD/q/9zjJrSaLZOUyUqmAvqtHOgdHbNiExmu9XHgQh8dGewHMzL424qGYFz9eevhnlO7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770166871; c=relaxed/simple;
	bh=7YkkwT8Ex1if3r5ZOMQl6e11dL3Xs5KyYdtiDRYnHq8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t3dfQ9lB2DL0l++8x48VF+F7LPh05iIxfDXLUlJodtoF/Q+4cq7B4Ul+UH7/kd1WYpI1uI/1GrjlL36Ixr3Y2CHcg5wM70tiKUuH/ceG+GJhlXdpXX7hfBDu3hhiFxLfzfvB59GLBcOCPXigE0Fj1gRLK27g0o4SnbDu4+VQHJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OYBShe2A; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-6630dd039ccso21881243eaf.3
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 17:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770166868; x=1770771668; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mnxn6qhPWGoTsS1DGhblGS2iCQnfBI1ygyGZY7nd+fI=;
        b=OYBShe2ACMi0I26CJlFrBOckyiXvlA/M+Tt75d/rnJRnUWJIf4anbinz4mm8t4NQvN
         bv5zeBH0lRKXyP+lfkkoT+4bGQ+Ka7QmSVdUqs+evFNFyKwi5fCp9mXopHuUX+NQxafN
         xbp82hxMPaA125SCviDsDoPRdWeh2I4Y0MD5HwK60H0Jd/adM90ReCiGZPwQSBs9EpJ3
         xNdvmROs8YXi6zH+/6WWkUzcOWxPU8cx436DBj3myWW8PpXFs/VvrQe/3/oQEQeX50Pm
         6D8m95vO+i64cQj4Ju3sdyv/k/iP7nX33ItLhUM/pn2aciM7jHVGnhe2lAIaN0b5CONx
         bH0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770166868; x=1770771668;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mnxn6qhPWGoTsS1DGhblGS2iCQnfBI1ygyGZY7nd+fI=;
        b=A87AgfVGF4AgUPe63Rk7lxFJDSC8mTjGh5eEzI/z4FrxSrvi35Pl2/dV9l6muRSTQF
         SvklR/af7pNcvJp199McSyQnXc53jR0bvnMiAmXPag5vQO8go3Xhzwn8rqfKhbSmh6ny
         k196+g0YkGjjD2ESuHcsUKAW0VcvCAjF5Kb5PaI+g9XE6dITKt/tEXaRBwFfJ2PP9a+v
         3Fdlxf8ykpWhF5GhU7KkMMvciz/1XewVOemt60EcT4n3yavhZCJtF+e6+99ONcAMNEvX
         yVM1lVdAI5Cp4DNiFt2jRJWEF03oW7Em8RS1+TToVpqKekISLg1nnPV+Vh3IFPc3Za6R
         gZMA==
X-Forwarded-Encrypted: i=1; AJvYcCWPeHFRSiS+GXMN4dcEkL2zDmF0GPCzGZAs8B/CN/z6PMkkiWe/j+R9QqZrMhf29AY6WIs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1K4cvvIEjlcw0JZoKaiEt5DNleYEUA20svdXvSO/2CbPyNi93
	qMPf6ywzfk0RpNlNVmRTzYGMZR80jex5pBUz3Y5f41Gp+lal0mpLZUyeWiM7HoNmvDUwmHpcR8H
	FpTAUYb+bow==
X-Received: from iohm24.prod.google.com ([2002:a6b:f318:0:b0:957:66a7:af96])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a4a:e844:0:b0:662:f763:c52b
 with SMTP id 006d021491bc7-66a20592891mr726381eaf.9.1770166868323; Tue, 03
 Feb 2026 17:01:08 -0800 (PST)
Date: Wed,  4 Feb 2026 01:00:55 +0000
In-Reply-To: <20260204010057.1079647-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260204010057.1079647-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260204010057.1079647-7-rananta@google.com>
Subject: [PATCH v3 6/8] vfio: selftests: Add helper to set/override a vf_token
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
	TAGGED_FROM(0.00)[bounces-70131-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 2170AE041F
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
index 898de032fed5..4ebdc00e20fc 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
@@ -129,4 +129,6 @@ void vfio_container_set_iommu(struct vfio_pci_device *device);
 void vfio_pci_cdev_open(struct vfio_pci_device *device, const char *bdf);
 int __vfio_device_bind_iommufd(int device_fd, int iommufd, const char *vf_token);
 
+void vfio_device_set_vf_token(int fd, const char *vf_token);
+
 #endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_VFIO_PCI_DEVICE_H */
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 142b13a77ab8..f15065f53156 100644
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
2.53.0.rc2.204.g2597b5adb4-goog


