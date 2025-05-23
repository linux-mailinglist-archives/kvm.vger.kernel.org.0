Return-Path: <kvm+bounces-47634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14139AC2C50
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 01:32:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 855E69E0F8E
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 23:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CCCC221DB2;
	Fri, 23 May 2025 23:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yYuE8N8s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41D422128A
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 23:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748043058; cv=none; b=U5dUJWvsKQSmqRg57g3Nr9amhKBp5MgBV+CN/4QEYK5o7GrSWo72QBCAs0EMMn4G1Te1RYhx9cd1CPaE219YR5ocNX8UHTHxAcaTrlaI7fPBIHwvrQWOJcTvKOEIe2mL4aLjl+JDYtmLCkS5KtZlk11P1YrdfXDJ/uMo+LozXj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748043058; c=relaxed/simple;
	bh=SSMuEvee9glbxWJ1IuEXsz9lNtpgfy/Qje+WHBxQiTo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nQdQ5EsoD4ifG9KocVldtRlT8Owp++S5Uy+HWcbAZYTgAtJI7ziiJhb6lPYNVZF/6nGNPfbBFbzv3dsdqQl+mZJ67RV6/38vBsUwuAQy9ebun7uovovkkjqA6Zw3wHEc5f+z/ImSEMvU3H9+x4t2dPm/Qdm2hZjKz+S0UYx+Vas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yYuE8N8s; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31107cc21feso404239a91.3
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 16:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748043056; x=1748647856; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9oOM80E7dSL7DoQjoSK1rLXfOpl897ERMRJpweaVyQ=;
        b=yYuE8N8sFOlR7exMNED/VG6TFmjwnC3KwkjmQqmZ4Smp5NAf0G1pNQlmlQaCCH4nNf
         rDRfprB+9pp7/hjVZvg+SUobQHhzom3ExCcZjPQXLr3UVkDLE5XTr45zjJ8FMtiVM8Nr
         dVJ4FKAKyGBE/i1qWyxDojE2m08uWKISlHGZBw4uJoXN/ac5Fw8cFiDsEtTQAfIVd5zN
         I96gaFxSZysHwLoJ4ZGfD/jMOc263Kpfhwzs9MViYxwP3ZcJyYDK1BgmNcayyWJeoUIL
         t46k7mJHeHGx4zGViX0zq5oLejrZc/1nFaH83HMPZX9fmEMsZ2rrTvV2tiLmRfYvf9iu
         dxOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748043056; x=1748647856;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9oOM80E7dSL7DoQjoSK1rLXfOpl897ERMRJpweaVyQ=;
        b=RxgcBTNATSpOwtt91esdy83wJ8NxzB9PK+tHfK+FfYtX4UjSoyTEErEwx0N/Dju+sx
         QZtnOys4qbGkQXOLCBaGssNyX9NgpO3vP/CLtZwctl1OJGIvGDzMOU3zqsGGFg1PfpzD
         M0sWAQCn9/F6/0u3HUd8Ca/x1UXh7u9zkhhPY9wgsuZDfQli5RcwwYvxUu1DwieM4ZmC
         8zLzIxpYlqPlaYrfACK2FO87W4qY1hhTNwt5CUOfBV1wMIqmhtSPiRfVJK7YoTnHA9YK
         mr93sSjaZ5rCbcTgy6vzdBxP6RPQjitPxnP039gVwOS5tc0nz3rSo5Ie2I7YmssQMNNC
         uOEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwmYt/+52+nvY1szS4j8hLyob1vr3uwFu06KwMiM0yiiLnWHWo5U/tb56ZSV/XgvwMJXE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg3MhDOR8cSmKijYQbmyRZcfKfsytFllEawFixCWlb5WUJBx31
	7r0bRNDk7E3jPw1oPM57qwx8dV9amOgsjuMzdbbkYyyfSQeffsSvmyu2EjgylJWXBWDC9gYMmBx
	G6T4ppF5+WzF0YQ==
X-Google-Smtp-Source: AGHT+IEvjEfYREZqgyxe4J0lsuUOIbK9FZAtCGeXevwKa9e5suGF9j5yRuL58XYl07/6LNvuzXzS7gfFhBANog==
X-Received: from pjf6.prod.google.com ([2002:a17:90b:3f06:b0:2ea:9d23:79a0])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:33cc:b0:2fe:8282:cb9d with SMTP id 98e67ed59e1d1-311100da6acmr1422059a91.28.1748043055927;
 Fri, 23 May 2025 16:30:55 -0700 (PDT)
Date: Fri, 23 May 2025 23:30:03 +0000
In-Reply-To: <20250523233018.1702151-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523233018.1702151-1-dmatlack@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523233018.1702151-19-dmatlack@google.com>
Subject: [RFC PATCH 18/33] vfio: selftests: Add a helper for matching
 vendor+device IDs
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, Vinod Koul <vkoul@kernel.org>, 
	Fenghua Yu <fenghua.yu@intel.com>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, Jiri Olsa <jolsa@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Takashi Iwai <tiwai@suse.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, WangYuli <wangyuli@uniontech.com>, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Eric Auger <eric.auger@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"

Add a helper function for matching a device against a given vendor and
device ID. This will be used in a subsequent commit to match devices
against drivers.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/lib/include/vfio_util.h | 7 +++++++
 tools/testing/selftests/vfio/vfio_pci_device_test.c  | 4 +---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index 2b96be07f182..df56c84273e8 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -153,4 +153,11 @@ static inline void vfio_pci_msix_disable(struct vfio_pci_device *device)
 iova_t __to_iova(struct vfio_pci_device *device, void *vaddr);
 iova_t to_iova(struct vfio_pci_device *device, void *vaddr);
 
+static inline bool vfio_pci_device_match(struct vfio_pci_device *device,
+					 u16 vendor_id, u16 device_id)
+{
+	return (vendor_id == vfio_pci_config_readw(device, PCI_VENDOR_ID)) &&
+		(device_id == vfio_pci_config_readw(device, PCI_DEVICE_ID));
+}
+
 #endif /* SELFTESTS_VFIO_LIB_INCLUDE_VFIO_UTIL_H */
diff --git a/tools/testing/selftests/vfio/vfio_pci_device_test.c b/tools/testing/selftests/vfio/vfio_pci_device_test.c
index 27f60cccd3a7..1a26df0f2280 100644
--- a/tools/testing/selftests/vfio/vfio_pci_device_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_device_test.c
@@ -54,9 +54,7 @@ TEST_F(vfio_pci_device_test, config_space_read_write)
 	/* Check that Vendor and Device match what the kernel reports. */
 	vendor = read_pci_id_from_sysfs("vendor");
 	device = read_pci_id_from_sysfs("device");
-
-	ASSERT_EQ(vendor, vfio_pci_config_readw(self->device, PCI_VENDOR_ID));
-	ASSERT_EQ(device, vfio_pci_config_readw(self->device, PCI_DEVICE_ID));
+	ASSERT_TRUE(vfio_pci_device_match(self->device, vendor, device));
 
 	printf("Vendor: %04x, Device: %04x\n", vendor, device);
 
-- 
2.49.0.1151.ga128411c76-goog


