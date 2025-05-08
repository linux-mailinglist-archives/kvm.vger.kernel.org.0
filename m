Return-Path: <kvm+bounces-45886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80BAEAAFBE3
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:46:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8B7650275C
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:45:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE88B2236E1;
	Thu,  8 May 2025 13:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EMJ11IVR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9056A153BD9
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711927; cv=none; b=ssE0INfQLWQLDsEfs4SNMTkETCaTXR516VHKsA0tq5Fi6J0OYfPxwDsK806hNpd0tXL1Vp6jxvHHApMKQrRUc/JaxdFG3rctUhTncyd5f6HPFcYsmVMt7124KJpo4RH7sixS81PrSUdNyHV5g88QzXmEkGIS9hfjLCtSpdrSjLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711927; c=relaxed/simple;
	bh=gRoOIfSYF0DKIMd+ZgaQslOdaN8g+9NZYOa0XVwbxcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e46eg+wfE71AGYwbUrTOIZhTXS1rs78ERV7BXkXUp66YiUs7p/L/rOfsrU5lOCUx2Vue9eJn0TIbd1fh3ozuCmnOUsA5C6ZPjpk5TwO6dpctTpzESaQPJfHVOhJW6w8QWQ+W5GGJBLuMe7i1q7svC0kfd/q03HGIP7v5V+zl4Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EMJ11IVR; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-306bf444ba2so1010620a91.1
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711925; x=1747316725; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OvirrR3TiqgBPme4BwNGSV4VqzG47GBw5DwB3TzFavY=;
        b=EMJ11IVRDg21yW9Tr+6nyxQdwdHZQa9yicBXLgh8gzH1Wd8V15VFjX3wB6AAlzNdm3
         2YSqJBJf6RKS0DhnZ5XfCKNxZ0ISTFCKs8nYcLfod63h/y4Gs2iffzMtFrPJZKD4il83
         O4dkUhhaMauujdCEuvPTL6I62aO45AJ8ZEuQQrHqxPzJ2XQ8rQ9ngFAcaFDXlvhd6qBY
         Ni7DVh6Gnrd2NDWvnaRruOZvH6s5ZLxVvpfJKB/IpKFiwZ3e8gIkh4R67btUTkfAqevz
         XLGJvjN+vJZwcPlvVatSp8CnSpSXOANjDlCvJvnNp6AAGlkKJWeiSWN1gkaI/jP/PKka
         7rxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711925; x=1747316725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OvirrR3TiqgBPme4BwNGSV4VqzG47GBw5DwB3TzFavY=;
        b=FU1scHk7N0AUvQXLvN64a/+otl4l9a2CsUvaZvbTbY0aGtruYWjh9xnjahdK1uFzLH
         eXHcUfeNXdAyEtVu2LHTkxpe+RrR9z8r8y7MaKnct4Tun9BzNT3eAoa0N1cye6nZvMWd
         /HlaW34gt8qSLB8ri3slW9GSkh42SSUt4nNo0FMKy+2ZnLuoy2sKrS/LMHwXENK1I1fp
         v0f2CjKUj0oIQ3EuWjhrQeuByeVnclwKUkj7VAhDa3M/akKtwQv2ZlXnx8Iq9tVqA/2H
         nk68wPNt260xDNW3nFRQ15fzaW1ZWBWcubW2CB8EWp3TX3gn321uD7TSGafSF6WgNDrl
         8A9w==
X-Forwarded-Encrypted: i=1; AJvYcCXvAtm0Cgnj7SH7lhVmiG7GHn1bZgr6MzDCZ0/IyCRzcx+6Gh1IcIQLNwcip8bwJlso10g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9WLgdNe44591Cit7e6LS9odY8X4KgRqnSpAxRqzMBmQdHybuM
	v888dacqLzemCDar0o9QRTu5bTFSA3VrqEK9MXdo1a2sBs6gPntBxnHVMlil7cI=
X-Gm-Gg: ASbGncuL7i4GdbPTuujrCaDT0LRq93R1AgJMjfkraY+uMvTnp7Ds31vQJylOdxUUY0f
	GhbodN/29BuaTD8RMgG3swkFG6JVfoYSvyTUevckgdm694a6kkV8pbtJBFn+spm89QR5LI4lQiK
	3KSl58tOWEOFBjRIQ+JQzEZqZ9KOA/Qf8emrI3xc+GgvGs3he/j+wQIRu8fVcfWj6XpExKl8SS4
	n4gZUkMr8TQZKG8b74g+rax/9lUpZX5AyWvtlPUrrT8+z5490FyHit13YN3X/bDzfXJJHJYa3z9
	tx2iNdScQem+RT3xfDNKmroHDJ4p3TPz5AZDrRGrtAfRmTEBb9bvu4cMF0sFAAOpFNsd+Mfd2Aw
	+wY7GSA1XAFd+kVoqF4aDMH9mHQ==
X-Google-Smtp-Source: AGHT+IE3OguPxCt5UaaCz+npDDqEKcstgRYbru0eZkno/K2CabjL/K8uImloD5ic4QFfbuKjUmzxXw==
X-Received: by 2002:a17:90b:1a91:b0:2ee:ab29:1a63 with SMTP id 98e67ed59e1d1-30b28cea048mr5022708a91.3.1746711924724;
        Thu, 08 May 2025 06:45:24 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522f0c3sm112275035ad.209.2025.05.08.06.45.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:45:24 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>
Subject: [PATCH v4 25/27] hw/virtio/virtio-pci: Remove VirtIOPCIProxy::ignore_backend_features field
Date: Thu,  8 May 2025 15:35:48 +0200
Message-ID: <20250508133550.81391-26-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250508133550.81391-1-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The VirtIOPCIProxy::ignore_backend_features boolean was only set
in the hw_compat_2_7[] array, via the 'x-ignore-backend-features=on'
property. We removed all machines using that array, lets remove
that property, simplify by only using the default version.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
---
 include/hw/virtio/virtio-pci.h | 1 -
 hw/virtio/virtio-pci.c         | 5 +----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/hw/virtio/virtio-pci.h b/include/hw/virtio/virtio-pci.h
index f962c9116c1..9838e8650a6 100644
--- a/include/hw/virtio/virtio-pci.h
+++ b/include/hw/virtio/virtio-pci.h
@@ -149,7 +149,6 @@ struct VirtIOPCIProxy {
     int config_cap;
     uint32_t flags;
     bool disable_modern;
-    bool ignore_backend_features;
     OnOffAuto disable_legacy;
     /* Transitional device id */
     uint16_t trans_devid;
diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
index 8d68e56641a..7c965771907 100644
--- a/hw/virtio/virtio-pci.c
+++ b/hw/virtio/virtio-pci.c
@@ -1965,8 +1965,7 @@ static void virtio_pci_device_plugged(DeviceState *d, Error **errp)
      * Virtio capabilities present without
      * VIRTIO_F_VERSION_1 confuses guests
      */
-    if (!proxy->ignore_backend_features &&
-            !virtio_has_feature(vdev->host_features, VIRTIO_F_VERSION_1)) {
+    if (!virtio_has_feature(vdev->host_features, VIRTIO_F_VERSION_1)) {
         virtio_pci_disable_modern(proxy);
 
         if (!legacy) {
@@ -2351,8 +2350,6 @@ static const Property virtio_pci_properties[] = {
                     VIRTIO_PCI_FLAG_MODERN_PIO_NOTIFY_BIT, false),
     DEFINE_PROP_BIT("page-per-vq", VirtIOPCIProxy, flags,
                     VIRTIO_PCI_FLAG_PAGE_PER_VQ_BIT, false),
-    DEFINE_PROP_BOOL("x-ignore-backend-features", VirtIOPCIProxy,
-                     ignore_backend_features, false),
     DEFINE_PROP_BIT("ats", VirtIOPCIProxy, flags,
                     VIRTIO_PCI_FLAG_ATS_BIT, false),
     DEFINE_PROP_BIT("x-ats-page-aligned", VirtIOPCIProxy, flags,
-- 
2.47.1


