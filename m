Return-Path: <kvm+bounces-40509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BED52A57FB0
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:10:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22B25188DD96
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5072D204C0E;
	Sat,  8 Mar 2025 23:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mifcYFkb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B702C1B425C
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475418; cv=none; b=YI9NcQtRTNn2Dl/023Q9/TOf/agEZ5UYED+xrr6kaVd4/L1pse3iug7SY/Ru2plbUJLPQmrzUwLgzGVJYdFCeLJ7X4oYZUBWONcFAMt/mguo8p3sWP58O/h67XN7uEMY4wyFm18c7IBYzmpgMbi0L8DDZShLHYLkoDj9XJsoDN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475418; c=relaxed/simple;
	bh=fufiwJtrmYk9kZrf6Nj6EkRNSLGh1JbTuh9JKdzh+0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HB4g+10OAH7SsTm6xV7HJ/W4cjPz/7InsKSgv5+GXVRInX3EZ/+Pm2n+cdiuoKw+dh5HgA8YQCOjybzLkmOCWqwKSijKKVGvw4KwcQ1r3c66KAXQcXi9PqYKdZXXPPaFkIp768ZMpyikcywfBa5JMtk/XJHWETCjn7SxipWMDK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mifcYFkb; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43bd03ed604so26020785e9.2
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475414; x=1742080214; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UEvdVMyvXjdezRQS+46yXb37w36/326vMxQlDhu7A50=;
        b=mifcYFkb2grITwgII/fzuA7CSXjQD14LJX1bwc2hgTLSJAzmiIcOuZlPlkB60mdJH/
         ljnWs1x+BnhNX2S4ZPBM23JswFMolWaVv8KG9wbEj+V8kqlaGCfvqZSBEkRgssKblrjt
         RQ9JGeGlfOhMJy68aOuO/Xu2jM6mZmktH3tAVyqlY83xQk2OinCgLRTX7FBUO/eHn5RJ
         7YSTSA1zHLV15GscJHFWxKD2hPxor0g9E1f/zyr3eVOMeNVMsEm/aZk4g7sW3lfRyxDY
         liB6xOmDs0tWe4QMM4xzEYtgXuE3m2uuLf2++qtuImRK+Z7EqL/PtZnJBG3MDZyWm93f
         1a5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475414; x=1742080214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UEvdVMyvXjdezRQS+46yXb37w36/326vMxQlDhu7A50=;
        b=YtebOn17gA2I+euSGpftCyJ64dxgmAHc7Y8H8/9292a0swphWU9rtFMxeUPFpH2L6g
         k4eQWHkAFpe+siJrrgW/NDC/v9FkJLRP2wrvwFy/STscnWY5ovlMD3TWjaEWyDV6Pbg2
         IP7ioFE1BVVpKbOSVIue3qpMempJ7IUNCnfE3unt79yaE1tcqrar2D6gjDVEfjBO0KAm
         GDQ1IsCvBNpNAeC2d0q0Xc0F3HyMV7CkeLk+9LMlfANhfUbswQJoB/I6Xl/l2YmCMOAX
         dWv7Cr5Cr1TOx8+AGkYOl8NGIA2Gj5wllxEX9oHsl//X9b6fZ2D+w8E8d0xQdtNaXJqD
         cGTw==
X-Forwarded-Encrypted: i=1; AJvYcCXMmtFUOgDPgcyXBmV23pFw6xhQH0iW6RQOC3teGlod8kjKEErt5OfKWtyuEKGf3pa1dRE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNtqk1BcmhtlES9D/OZlnFvTjHf5RgZV2HfyC5ZYxMBMYtCvFj
	5nOvOMYL5Co6WjqpOhQe0tWlCKdO6dfYYpxuR0jioOZuV9r+iCZHZKy6A/DwDPI=
X-Gm-Gg: ASbGncsQu1TZTucUNcz/SLLCJJTKqumbo5vJpLIU3R7tk85iyta59HMQuxe5PTJ+7oO
	ZW1dcZSrEOCD2HjgU20nT/oVsSk97+x7UzjwQwVhB5Lim1s1orIUqkH4u85bMbOd0twTyDZZroG
	B/R22z1+N/pojbZx+uqZakNOtN/LQUp3hrrKq8GjVPVJFMjFJM8Ac8m+aHgHtHoyglwaarAv3wT
	jD+9ye4HlMq6vSYOpdMwBsrgcVRFW/taZKhO8vbaQxRynosghh+ZVp7928tuPRr3BV8IQjC46C0
	vMEzWK35uvHX2B2VwwOXpohIF9M2/la94zmPt0OG0BsTn6Hbi/3WPZS32SjRjibHDVppterF34r
	6ZMHTq6ZpgCFZuCbXTPc=
X-Google-Smtp-Source: AGHT+IHU+xQMgt3dsdiNnJgEOhNSs6YqxwcUDocahOsxR/CmDr32kZwcNq5kvICgYKsd1qnYF/NWOQ==
X-Received: by 2002:a05:600c:35d1:b0:439:967b:46fc with SMTP id 5b1f17b1804b1-43c601d9167mr53509045e9.8.1741475414122;
        Sat, 08 Mar 2025 15:10:14 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ceef2fb8dsm14915575e9.18.2025.03.08.15.10.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:10:13 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Yi Liu <yi.l.liu@intel.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Eric Farman <farman@linux.ibm.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Peter Xu <peterx@redhat.com>,
	kvm@vger.kernel.org,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	qemu-s390x@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 09/21] hw/vfio/pci: Convert CONFIG_KVM check to runtime one
Date: Sun,  9 Mar 2025 00:09:05 +0100
Message-ID: <20250308230917.18907-10-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250308230917.18907-1-philmd@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Use the runtime kvm_enabled() helper to check whether
KVM is available or not.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Cédric Le Goater <clg@redhat.com>
---
 hw/vfio/pci.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index fdbc15885d4..9872884ff8a 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -118,8 +118,13 @@ static void vfio_intx_eoi(VFIODevice *vbasedev)
 
 static bool vfio_intx_enable_kvm(VFIOPCIDevice *vdev, Error **errp)
 {
-#ifdef CONFIG_KVM
-    int irq_fd = event_notifier_get_fd(&vdev->intx.interrupt);
+    int irq_fd;
+
+    if (!kvm_enabled()) {
+        return true;
+    }
+
+    irq_fd = event_notifier_get_fd(&vdev->intx.interrupt);
 
     if (vdev->no_kvm_intx || !kvm_irqfds_enabled() ||
         vdev->intx.route.mode != PCI_INTX_ENABLED ||
@@ -171,16 +176,13 @@ fail_irqfd:
 fail:
     qemu_set_fd_handler(irq_fd, vfio_intx_interrupt, NULL, vdev);
     vfio_unmask_single_irqindex(&vdev->vbasedev, VFIO_PCI_INTX_IRQ_INDEX);
+
     return false;
-#else
-    return true;
-#endif
 }
 
 static void vfio_intx_disable_kvm(VFIOPCIDevice *vdev)
 {
-#ifdef CONFIG_KVM
-    if (!vdev->intx.kvm_accel) {
+    if (!kvm_enabled() || !vdev->intx.kvm_accel) {
         return;
     }
 
@@ -211,7 +213,6 @@ static void vfio_intx_disable_kvm(VFIOPCIDevice *vdev)
     vfio_unmask_single_irqindex(&vdev->vbasedev, VFIO_PCI_INTX_IRQ_INDEX);
 
     trace_vfio_intx_disable_kvm(vdev->vbasedev.name);
-#endif
 }
 
 static void vfio_intx_update(VFIOPCIDevice *vdev, PCIINTxRoute *route)
@@ -278,7 +279,6 @@ static bool vfio_intx_enable(VFIOPCIDevice *vdev, Error **errp)
     vdev->intx.pin = pin - 1; /* Pin A (1) -> irq[0] */
     pci_config_set_interrupt_pin(vdev->pdev.config, pin);
 
-#ifdef CONFIG_KVM
     /*
      * Only conditional to avoid generating error messages on platforms
      * where we won't actually use the result anyway.
@@ -287,7 +287,6 @@ static bool vfio_intx_enable(VFIOPCIDevice *vdev, Error **errp)
         vdev->intx.route = pci_device_route_intx_to_irq(&vdev->pdev,
                                                         vdev->intx.pin);
     }
-#endif
 
     ret = event_notifier_init(&vdev->intx.interrupt, 0);
     if (ret) {
-- 
2.47.1


