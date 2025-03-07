Return-Path: <kvm+bounces-40376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE49FA57003
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:04:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3D263B5580
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 18:04:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CCEC23F40D;
	Fri,  7 Mar 2025 18:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nt/RTd7X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8533718FC92
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 18:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370676; cv=none; b=Pz0Gn3MjN4RniNrcXPK06G/Ol4JijOS7iDayPWyUZvB9pxTsUvs5HzmaWwnF5JDOQpZDlThQHkGTTJbp1LKU/pFLD9LWVQDNu4LyYYEsu0UP+IDj2+qqS7Ktn/v49cVJBitJsJPmJwsD31kAYBNruL/V7b775ZQ5WWFT8b7NoPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370676; c=relaxed/simple;
	bh=kGe1bKgwmPQLXCk4SnXQubZT98PZZLS9cooDopgi2XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uKqZORX6OZ6DNtU0wUmsdit5KAYV0rjgrGOBixzj6bc6k/n9K03XHCwkj+/iQm+bGOPd/Bjz2xx+3QtZ2DIFx/lHmlXZfHBbkFg8oLF6kWL9DA/sgZ4Px77hYl/v5SBpi5owxdE9Qb8+w5xqvDd250RxAxu1maPKl1iAv03qkAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nt/RTd7X; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-390f69f8083so1829244f8f.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 10:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741370670; x=1741975470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qgqJlQXPaNCurtKb37o64LFzMpOza3vmaLhco3Sgch0=;
        b=nt/RTd7XKm4DDQwqcDTQu7/2a05dlz2N8NiEszGY9yTnvvECpOlgmZsUKypOV3Me+v
         1pOUoVINzcuK08yWhreGdogZAEMAgnHI610wr9xsTjSxB1EnNB9qU5kWEAquI274RvVr
         xa4TgL3HBzar7+Z+tfwhcZwSGR9OGA5vXRZm30YcomPMfuMtJ/qnM+yDr9dDKSBYHWj3
         zo0wVxWlbEI16h/SyafH89oiWGRYa7/xyxfEE8E73jIn/M5z1soJaXLDobJyvukwiMxu
         T0zTwwD5GSrhmT/4TAINyxGeoN1MnWPOv1OOaOtJas6UJ7/NO7ttaipDjG/TLrNhupFV
         rZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741370670; x=1741975470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qgqJlQXPaNCurtKb37o64LFzMpOza3vmaLhco3Sgch0=;
        b=NVlQJ4+ihyjKPkQ+DBEshH9azBBgSwrBdkke4PHsiklHgeFiC1bMHg5548HtZmIWem
         u1alpRJlKz56dhAIMUSAz3D0KYB57FJ2yS9c6dF3n0ETxy/iHxPVQuHQlRtm7O/pVLbh
         J9NkClsHMQQwoqXJJ/PpZjOsNxiPiWWjUGQSm6Exvb4mvXWd+8XU11CLF9qDpvaDqN3W
         7j/WDUOsrFf0Cg/9KyZF1xolJCD8iAU0CD9zBkcfduLs1iXqTvmi7E+QpCpKLBLmaL5i
         LOpyeIKIGJVq7KIfhVxjxugmNXGRrIQt766LPgzKua29zklv8xd32rY4OT0L5Sns9Ept
         hTAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUugOsF1L8WICUpPNvLyHNqJnJTrX8Gbnsz6FkCH0h9GRq37RRkfAvVvHq/B4R3/6qS59Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXknfwn3dnLiOq7yZAyWNX++wIO0EjovbfJTK1FaikIVdYB+c9
	e4dT7UH8qbu7pD0xWklMPqtrFiq/vBbO8CbBl2nlKY6ODBpGQsZP3DKyOVRkOrw=
X-Gm-Gg: ASbGnctHUt9f+zlpitfctEWCfvm4gt/yad84X2CVmMZLRZaVYd0ijBficq+SiMACV97
	1jsJ2dBODWi5u1A+AS8Xxn6/S5bDQuvPAfTOjGm8HdjLVvcArv3vkk5lk84ifPDObPsmBMky4Jf
	xPIAzCYT6EvXTyf0NaJus13EMXvsHTcxctrkYFJly1gL2vvP3zAJFmiW23YCbI+wJjBJu+nm6C0
	o252g0gpGos+ZQMNH5fZWmpPEJkBG+ZFIFkKtkIt106ZbY26solxvSI+bUkF9Hm3aLdn4ju1Hl2
	otBXRchzkFTaFL8VAw2NAQQbin/01hAiKg207sflHSW2O+QiKKo88V6GWpMLt2SrbOvEq3qQJr0
	ModQjfz9oKOjfKbVe/YE=
X-Google-Smtp-Source: AGHT+IG86wo6VjNTiB+dsP2CrUpAEcNOBKsuaBqrTPoI1r5vkBrwnV0jTDl16znAZrCu0SDGfxgSlA==
X-Received: by 2002:a5d:64a4:0:b0:390:fbdd:994d with SMTP id ffacd0b85a97d-39132d45d52mr2858940f8f.27.1741370669687;
        Fri, 07 Mar 2025 10:04:29 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c015a29sm5961965f8f.42.2025.03.07.10.04.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 07 Mar 2025 10:04:29 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	qemu-ppc@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Yi Liu <yi.l.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Eric Auger <eric.auger@redhat.com>,
	qemu-s390x@nongnu.org,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 09/14] hw/vfio/pci: Convert CONFIG_KVM check to runtime one
Date: Fri,  7 Mar 2025 19:03:32 +0100
Message-ID: <20250307180337.14811-10-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250307180337.14811-1-philmd@linaro.org>
References: <20250307180337.14811-1-philmd@linaro.org>
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


