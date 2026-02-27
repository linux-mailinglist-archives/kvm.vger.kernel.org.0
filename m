Return-Path: <kvm+bounces-72248-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iFc2A/Yromk/0gQAu9opvQ
	(envelope-from <kvm+bounces-72248-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:42:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A5111BF188
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:42:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 80B9D30E9BE5
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:39:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78C7047B43E;
	Fri, 27 Feb 2026 23:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zqvNl+Ny"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DA147A0CA
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 23:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772235579; cv=none; b=XRF5pH8JSBNitChgE3hUR1GQhhXQhUDb5Ie9xumRD3KhLuwHqY6e3wJ2j6EFZO9EfU+amGFhV6Ba3lCFpzPL/VGfWPBYJ4FfzSXQ5orhMEkQ+oAxnbmgNAaCfHlM+hmXftXJpfbBjbcFqx4NcTXOaV7Rp2zVOXTJt3vYOcN1YRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772235579; c=relaxed/simple;
	bh=Zea1mJb1nV+2ZNc0sYa8z4jFdj6XxBzN4tc0WpNB6wM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k8P6w6ypwH2cytu4XiQ3qfA5iUREktZ2HmjIjWei0BWhDaic89aaW4A3H+6XdqHIQZDraar7OYlrmnxIUvTnkDkDPJ0zIUycYC+ByCMxVmf3NdiDh0tM/RQb2VHcBUXC/lttrKldjSyms4GH/dGYsJx/n8QjpC/CUz5dUkB1h5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zqvNl+Ny; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-663019e3e05so17157307eaf.3
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 15:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772235577; x=1772840377; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zp13jkTAk6bWujFIQ+dHCM/k/mA1jLnbVAVVBxM74mU=;
        b=zqvNl+NyQAD/YlVCOwmxb5RDUeG8vStVA4fDP4fvBov6Usfl9QaloA8E4D6GnP9pA2
         8ZUFPAmKbsLMursD4Z8j3Kcta6u7W42yR7cJ7Pj3IN9F4LejVa51mOcmgsTgT7+qH4qe
         vyPocKpgRPufWxhubvSTEEqkbpm1ute8gY7ENRmYuu/JHlY0PI99/kVInSLODQlCW2sG
         xlNnfOaZ/kmdZ2Pgrd2Pu2mU61BWbGRypChK8HFeuBKcMAUYiylU7aQIdQW5oT9pvCv/
         aP60NF1bBbvChSR4h7ZbafNpP0Hk3wWwrybmOK2o+nHH2CIZ92HnXrUL+bw6ErwBLYpQ
         TGOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772235577; x=1772840377;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zp13jkTAk6bWujFIQ+dHCM/k/mA1jLnbVAVVBxM74mU=;
        b=CLMgkzx72+n0mwqR/tJdupDUr8phIoHVDBY8lCp+89PVO02swz7XoX5En4CeM0C+7K
         9pjqO1MjFAwsLy1uGS0XtE8CgHhz63iOcxzJpW6TZcuJ9+QFlVSyDrCgYzbp6GRGPmC+
         MmYN4k/NFw/5Sta4dRq1iv5/ntBGbcKPkNmO++5JJHc1mqQ59Zfn3ObAiw+9Hh4W48ig
         sHKrWlIB9PaEwRGbwEnTGoxRcOG0urPqK7BScUokyL2xCuJRLWxBfvgVcfyUwBfzFW5u
         OmQILwuKapG5Zjg+cLxzokr7JfobhIRCsCynP7S140jAR3kRXaLqNOgoo71XJy58KkfG
         igCw==
X-Forwarded-Encrypted: i=1; AJvYcCWhSx5YNiUTeE11j4YZaugBjKWGTKIk2TtwJuqDK66e11DnYy6i3hslzWJDkCQLGDkvIzs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/3rELTERGCQYhzaAJchSXQH7MXb4WVs3ugrky3ayZ6wrURa4R
	S14/n/3DSUR/GV7VfKKBKqiPZi0Z7bge/GI9kKksDim+XHT2g7l+zhOtK+arE1nXtluMhBWcyg4
	v+7rl8hVUEg==
X-Received: from iols21.prod.google.com ([2002:a5d:9155:0:b0:957:7945:e822])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:828:b0:672:9d81:a765
 with SMTP id 006d021491bc7-679faf73307mr2755566eaf.65.1772235577276; Fri, 27
 Feb 2026 15:39:37 -0800 (PST)
Date: Fri, 27 Feb 2026 23:39:27 +0000
In-Reply-To: <20260227233928.84530-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260227233928.84530-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260227233928.84530-8-rananta@google.com>
Subject: [PATCH v5 7/8] vfio: selftests: Add helpers to alloc/free vfio_pci_device
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
	TAGGED_FROM(0.00)[bounces-72248-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 7A5111BF188
X-Rspamd-Action: no action

Add a helper, vfio_pci_device_alloc(), to allocate 'struct
vfio_pci_device'. The subsequent test patch will utilize this
to get the struct with very minimal initialization done.
Internally, let vfio_pci_device_init() also make use of this
function and later do the full initialization.

Symmetrically, add a free variant, vfio_pci_device_free(),
to be used in a similar fashion.

No functional change intended.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
 .../vfio/lib/include/libvfio/vfio_pci_device.h |  2 ++
 .../selftests/vfio/lib/vfio_pci_device.c       | 18 ++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
index 4ebdc00e20fca..3eabead717bbd 100644
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
index 4673b148f8c44..4ff76970e3791 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -419,7 +419,7 @@ static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
 	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
 }
 
-struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu)
+struct vfio_pci_device *vfio_pci_device_alloc(const char *bdf, struct iommu *iommu)
 {
 	struct vfio_pci_device *device;
 
@@ -430,6 +430,20 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iomm
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
@@ -462,5 +476,5 @@ void vfio_pci_device_cleanup(struct vfio_pci_device *device)
 	if (device->group_fd)
 		VFIO_ASSERT_EQ(close(device->group_fd), 0);
 
-	free(device);
+	vfio_pci_device_free(device);
 }
-- 
2.53.0.473.g4a7958ca14-goog


