Return-Path: <kvm+bounces-40520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99001A57FC0
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:11:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C642E16ACBE
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:11:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9CCEC2FA;
	Sat,  8 Mar 2025 23:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SXwzliMa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0271B425C
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475480; cv=none; b=nAoPjHIDoohrh9NHVxUiAntmKyvntr2ZeRk8ywoxemR8BQNODWt3RyVLn8GTuRbPB9o5OCgPh4gds6bkmYsu+5gioGE7VSw/Rf6/DfCJGGG4mwEdiZnWproa4L47uXLZTgNbMA1lQGyGbvN8cXHFOgUtWoMbZl8L6UOlvd/JV5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475480; c=relaxed/simple;
	bh=kCDVBnaQXpr96aoyJNh6o7fs39YPEXMlsX+H5eJpYZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ddxtVoe7uZAzqcmzomntQyiJyNSfNYLFaJdFX1Wb52Dm3faY76o+zIQ1muU5VIz+YrtgcOO8YJR3heiV26hiZ/crUWaCRjUtYlnMEFi8vSOvemg9VddV3/Qy7LrPkHpOv1bhF1oESx5t10w2z4dNTX+Z+CPrm6BY6U1KF/6ca78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SXwzliMa; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3912d2c89ecso2476102f8f.2
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475476; x=1742080276; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Krkj4W9PXI2bbr9HKRBnaek4mFUNomZTUnghoZDAa+8=;
        b=SXwzliMauA9PyQc3dE6BWjuIePDikaELuOCrlHA+vVDE58x9q55PMFXXkwVwdZ7K2/
         16XL+/ioj4j23Cp3MesWFB2w+LrvtnekCzloPrMOCSEPpjM5G1ScCo5E4E1fh2Dwc+9j
         GYUuhizvGN/LS7i/euRgNP0C/Tj4yh5/cR3GdlQM1qQt7NaOAiJKTUiAcdY4wgQvl8lW
         b3ZgB5flbG9D4/vCXT9cacaaLcjcO+cTy//460GeJLK/rfRDGzJwEnaaye6Y18mXIIUJ
         DfZtNh045zfol+BM3O9FOhDlvS7FQ7KrmdtK+J4kG1yKWCm7/H8vbK6g+J/QrGbJjt4Q
         jpYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475476; x=1742080276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Krkj4W9PXI2bbr9HKRBnaek4mFUNomZTUnghoZDAa+8=;
        b=c3vpQ/AbIWhKiPyL97xmNDKlQJ5tZYQfmME0/mt3CTR8MbP5MRwnJYqbXRi79aCRzw
         j3jbCGc6el+TzaR8W5SCdN0Qks6/fY48BI9XYXzFIOcECVGXyw/0yzs1o4iOjrOY6WtK
         X7EYzqhlOi+Us4gARbUVHEAQVAFVERL20MZZ7gu/0Bx0SHskuIeIvP+Re4Yk07si5EYx
         c+v6mHUzxDLsYdtT0zMv4/o++UT7SLlUvhLf1TBChY+9eNbcl1XYrK4bOgwKfraJ0Byl
         6ofi37UwzzVMsjAwqedg/dUbEXOjUEwXS+0Grj4UinkDIGPUJ6q7Tq1hO4zWR0r3yIKd
         Qclw==
X-Forwarded-Encrypted: i=1; AJvYcCUGK6rUwEzln4sF5Aok+cph9QIkHJg5NVTMAgfqvhRg5kOLXmrzH3WR0PumO/tA6EpPMvg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCTtOoHAMNgqHI8bDo0vLJum0scpOP8R4nsjHCQ2BSh8gQQmif
	YwpC5WdivfEaGIcNvRAmnd1jo2ClsDw+kWLmErccsXjyiS1E5Z8HpFIpb7KnI5M=
X-Gm-Gg: ASbGncv0efaFaxdOi3B49Rv4R3VNX1QPQMuYG+e8LBlJWVhlp4T3zbeJ4W0G8/9EsKm
	yxICBu7oMWBGDjdnmqtKANKOVb4i/EhNn6dk96WzHXg+K9rNTpEwGyDzOsD5K+GK/HGzq8tgtq3
	NnsoRgkAwUH+F2iRktF5SZJWxHnNxYGRbxHAlEdMfKupbiWHf7m1JxEM3Zr+jZnSQdCtaWwZZAJ
	dIM0/ZEdKz7Dh6BtIhyzJuQzSWaaf8S/lX2FeQg4QDgFwxCW6pSB0DtoFti1FZwSNc6/qAfqUYW
	lw6ZjdH42kOq75owZrTcYr1gPxO/t44+o9vM8UC85J0+RmdKvelFNNfYOcH9SLSH1ltsoQj6Eio
	cbwvUDIeoQQLT7RFS9MQ=
X-Google-Smtp-Source: AGHT+IEi5WAhR9L6pJSrF/tDnKMBfesHPV2+gJAeMrFmEGRf8Nfb1OcWHH46hcW/pc42V1sIDxqOTg==
X-Received: by 2002:a5d:598f:0:b0:391:412b:e22b with SMTP id ffacd0b85a97d-391412be5e4mr1168437f8f.18.1741475476383;
        Sat, 08 Mar 2025 15:11:16 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c01de21sm10233750f8f.59.2025.03.08.15.11.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:11:15 -0800 (PST)
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
Subject: [PATCH v2 20/21] hw/vfio/platform: Check CONFIG_IOMMUFD at runtime using iommufd_builtin
Date: Sun,  9 Mar 2025 00:09:16 +0100
Message-ID: <20250308230917.18907-21-philmd@linaro.org>
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

Convert the compile time check on the CONFIG_IOMMUFD definition
by a runtime one by calling iommufd_builtin().

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/vfio/platform.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/hw/vfio/platform.c b/hw/vfio/platform.c
index 67bc57409c1..265c550b747 100644
--- a/hw/vfio/platform.c
+++ b/hw/vfio/platform.c
@@ -15,7 +15,6 @@
  */
 
 #include "qemu/osdep.h"
-#include CONFIG_DEVICES /* CONFIG_IOMMUFD */
 #include "qapi/error.h"
 #include <sys/ioctl.h>
 #include <linux/vfio.h>
@@ -637,10 +636,11 @@ static const Property vfio_platform_dev_properties[] = {
     DEFINE_PROP_UINT32("mmap-timeout-ms", VFIOPlatformDevice,
                        mmap_timeout, 1100),
     DEFINE_PROP_BOOL("x-irqfd", VFIOPlatformDevice, irqfd_allowed, true),
-#ifdef CONFIG_IOMMUFD
+};
+
+static const Property vfio_platform_dev_iommufd_properties[] = {
     DEFINE_PROP_LINK("iommufd", VFIOPlatformDevice, vbasedev.iommufd,
                      TYPE_IOMMUFD_BACKEND, IOMMUFDBackend *),
-#endif
 };
 
 static void vfio_platform_instance_init(Object *obj)
@@ -652,12 +652,10 @@ static void vfio_platform_instance_init(Object *obj)
                      DEVICE(vdev), false);
 }
 
-#ifdef CONFIG_IOMMUFD
 static void vfio_platform_set_fd(Object *obj, const char *str, Error **errp)
 {
     vfio_device_set_fd(&VFIO_PLATFORM_DEVICE(obj)->vbasedev, str, errp);
 }
-#endif
 
 static void vfio_platform_class_init(ObjectClass *klass, void *data)
 {
@@ -666,9 +664,10 @@ static void vfio_platform_class_init(ObjectClass *klass, void *data)
 
     dc->realize = vfio_platform_realize;
     device_class_set_props(dc, vfio_platform_dev_properties);
-#ifdef CONFIG_IOMMUFD
-    object_class_property_add_str(klass, "fd", NULL, vfio_platform_set_fd);
-#endif
+    if (iommufd_builtin()) {
+        device_class_set_props(dc, vfio_platform_dev_iommufd_properties);
+        object_class_property_add_str(klass, "fd", NULL, vfio_platform_set_fd);
+    }
     dc->vmsd = &vfio_platform_vmstate;
     dc->desc = "VFIO-based platform device assignment";
     sbc->connect_irq_notifier = vfio_start_irqfd_injection;
@@ -692,11 +691,11 @@ static void vfio_platform_class_init(ObjectClass *klass, void *data)
     object_class_property_set_description(klass, /* 2.6 */
                                           "sysfsdev",
                                           "Host sysfs path of assigned device");
-#ifdef CONFIG_IOMMUFD
-    object_class_property_set_description(klass, /* 9.0 */
-                                          "iommufd",
-                                          "Set host IOMMUFD backend device");
-#endif
+    if (iommufd_builtin()) {
+        object_class_property_set_description(klass, /* 9.0 */
+                                              "iommufd",
+                                              "Set host IOMMUFD backend device");
+    }
 }
 
 static const TypeInfo vfio_platform_dev_info = {
-- 
2.47.1


