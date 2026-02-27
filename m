Return-Path: <kvm+bounces-72247-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +PvqKtAromk/0gQAu9opvQ
	(envelope-from <kvm+bounces-72247-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:42:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 58ECD1BF163
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:42:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E37CB3193AFB
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BD2547B421;
	Fri, 27 Feb 2026 23:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ELvyygpm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D2247AF51
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 23:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772235578; cv=none; b=NSjLOxQOMIR3K6DewtX8lR3j98GwCSmEOAO9M/ywAcgG6oP4JGIlyZo3/eZW319jjrznmxfiYZmF03dyD6Cr0zFbqpCh37sIbP2vrH9wdUCbhjllp7tZY/7zzJ7rgyQwfCPY1HYRJKN3rzZZRTV4yBzOz5waXdAiWROu05Z6jVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772235578; c=relaxed/simple;
	bh=4t42tWvrlKcV4lvYfuVx3UTtWZAafmp91JTe6pU7yS0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kJMaHQn/Nh2bSn3z+9N7XVYdbX7SWudcjhmYMJk5ksIjMmp5H/RRfoHgyQsON/mCVKboik9yLVrdNVV/Sqx6hgBATtGlqilxwePKr0J/2Av87y4i6Kb3nguVlYpncDg4Te/Cx3qBYtIAMKx3zY5A/5bautbuE4NjrYcq9oS4ius=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ELvyygpm; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-679a47a1febso55621587eaf.3
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 15:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772235576; x=1772840376; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QW1ukqnI7vV/78Yh9+DpzQAxrAq0/IU7SQ5b40XVy3Q=;
        b=ELvyygpmLKdiZO1WekzAOmvG4gXieEnByFL2Nxnri7I39lwgHObdzP+HzPteYLMafF
         aZB2hukNtC2xN0oP5FCj661ORCp4Dwyara797gqrWpfVqD3fy7pBWxREJPfeXh9RqQ3U
         V4xF9ybUSeixVpDUgHYStoERE/i5UiB5Sk2ZwejMAPuVKX5AsMvxa35JjYalMf4JSa83
         /nFGzt6G6GnrXSB7yCmz0w4+pRlyyoRAAxsWtPOHbUmSO1kc+eYfVVsDBDjQKTLuV+qr
         oTSsdppgLU0w8kKEcNjKmz5SExJG/peFvcxk74HpGSSRFAfh0vJEurS5IF7hvv+B4eG3
         v1zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772235576; x=1772840376;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QW1ukqnI7vV/78Yh9+DpzQAxrAq0/IU7SQ5b40XVy3Q=;
        b=AXeLZXtt2+17u9noA0twm/llvMNWtbbc1NzmJ/Yiy7mLCTi8Nuk+ZeN1MHCmLaOt8b
         dMYgCnVw3dD/oPzP44CAj33HpsyQ3/f3zvkqhr2yv+SKkJjGF/FKUfrHnsK+vUneNWhK
         dST98kKAiCvvuL2yc3WVdgT1QOD/6kxctDtkd0C31q5/A77qqYMIh4XIgZi6mDPSMOZM
         icWmmrJX+vCSSEs2/WiXAyTZpRo1j81FeBp4jCmNPniX15RkkSiabIfC51o8RMv37FLu
         InSbZQVoK1hG6OpgWgTTcPBIy3ONswpYkGbggNOgu9xazad1pB2HbANu0pVaOD73p+9B
         Vt6w==
X-Forwarded-Encrypted: i=1; AJvYcCUhY1psX+HbGIalveTxQfQIJnvwfWyXr7Mve5sIuhEef5wU5Tp/AcoT3yC3jb1lY1eLD20=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9YNElENcTwSaVBSNWbM3E1tQpzMdBuQ6F0mKwY3qAAA3v7/dX
	1W9d8ZLzHC0zxCkaUQNBGNjnhVuCpJBMcoL49jbo4o+9sOk21jTQTK8sxd3s+ShRFSh9xFB46Kd
	jjRCK8JnPnw==
X-Received: from jabgl48.prod.google.com ([2002:a05:6638:6af0:b0:5b7:2497:50be])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:81d0:b0:679:be5f:afcc
 with SMTP id 006d021491bc7-679fae0a965mr2888759eaf.19.1772235576140; Fri, 27
 Feb 2026 15:39:36 -0800 (PST)
Date: Fri, 27 Feb 2026 23:39:26 +0000
In-Reply-To: <20260227233928.84530-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260227233928.84530-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260227233928.84530-7-rananta@google.com>
Subject: [PATCH v5 6/8] vfio: selftests: Add helper to set/override a vf_token
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
	TAGGED_FROM(0.00)[bounces-72247-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 58ECD1BF163
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


