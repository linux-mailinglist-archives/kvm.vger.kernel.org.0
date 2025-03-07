Return-Path: <kvm+bounces-40380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BBE0A57008
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:05:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67E07165C82
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 18:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB19418FC92;
	Fri,  7 Mar 2025 18:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VcTqM9Bm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3408621C16A
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 18:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370696; cv=none; b=NK0zccWc1kWCcfzxoKJOggG1XDlgbkCVpbpyg/Js1KkxIJF9Sqao3I2itS3VA8fNHPEAFBy1g3ZswZv4bbT6hHAfSfupmqcN8AXDjX7fuR7rWruVIEUR0DsBbi/kNGQwudpExvr55ejKRMu52/7wSJP/y5mlj7GQhnA5Q/c8ju0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370696; c=relaxed/simple;
	bh=PRENhG8Qgi+x3e0hUqFmPUauD6MCuNXlKrO670tBoWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aKNiBP4PuJW5i0CbmcuT5e+DziiGoiXQnZQdUaKx7ZnJ966oDQWqsEr5dCYzZwTXFU4qTYbX/t61CwiZewls1HUkLrKEscAlRIsgJCMTc/d05OI371S2xXuGB+fVhWfLp3TFACB/ybTi977/ffMS7/a2YX4G/lBPQ0q3vEdzjpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VcTqM9Bm; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4393dc02b78so13617245e9.3
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 10:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741370692; x=1741975492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9PjjtPvH9M8tF9GLUHgsFKP3TRPxe4Etbg8NvJxAgPo=;
        b=VcTqM9BmyIeMn/FmsgHNIcy+yeyH4sHnZScuKT7HG+eo/OJl3Z/70KusLZYaX3/I2f
         9GntPYlxZjCjyQ3SfCuBYqzkaEB79jbgESJPVDD24nusp9q/if7x4smkQ84AJUwtwEYb
         JIVWEQh52owdD8Y+jTmuaj/lHUiI43eJ0nhhukFY89t++RHgA9Fz7g1fRngr0m5V1Ix6
         6pjT5qhtnhEGL/vH08GfoTBuk/7LUYWnt7V64QGr/FX1if0+6prBW7zxJ1LXpbMQrOT3
         4KyCgDnkOYR2m7uELr5sd/q8UyB93xhP2Sg5eF4diXK2mdv0Y/1qCDjNcC0L7fOW6Hvp
         dQYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741370692; x=1741975492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9PjjtPvH9M8tF9GLUHgsFKP3TRPxe4Etbg8NvJxAgPo=;
        b=Dm0TcFK51DahOo+iqIle6fKj+d5JZxYUY4q1XBJEpH1LX+v2pyYts5Fgljyzfh8b4N
         rPeIlnPXnMG9ko/05v4F4LfKYURk4n91M9QkvmImp30c3sbSyLiuIwiIV5Fyef0DeN2X
         Na9iEoB8/Y/YEC20huhtxb7dqEwBaHMWz7VzfoKqrtv3zjl0L6V2NvUiPICbHeDGSMN6
         RhDWlS3xGX9k+ABV+Ur3KuCC/gpDiR1Vuui76qIn/2gYN8eO4mk4GipRoxk3n1s92hIz
         1nsBqnCJA8LB1jEuY4Qwvkca9TGuW1J6IFWMAUX+ORWKXw+uzEBzjtjRUBpFlXtwPrjm
         EMpg==
X-Forwarded-Encrypted: i=1; AJvYcCW4DVfCjQk2rZlKXli1CpaMwiIjRZj0Dnscq9SWo+FeEr073tV3S8ayi01M4E9Y8T4gzXk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc9KOmQrcUq8OfGa8FR1hdDqnSdY9Iean6X6uny0Uk/0zXP7mv
	Z/h0QI7Ov9CbxRmJhQeRQB0vhNCHtXmf2E8BOcV+pAqTdhkD69BQ4F1Qtfh8mWs=
X-Gm-Gg: ASbGncvOc31CO+xkn4QCoe4QC/Ekqk3+EWxr3Z9e3hBxeLocCl9UrIjf4koCkJTK0Tr
	QKPZ+rBRPzz3p9AUdykR3Czv/hmC9hNhXq+cZpG1bLvFDRNkIg7id/8pjNsl/fW+uszxx+lFZoJ
	U0xt89aO0dtVKyahcvtZ7b5n6SRl8EW869SlI3wZwcdPpiK0XQ2vftyfb7+GASzQJh/m7c3+9wn
	K93deSXM5dh0Rw8J4z9qrNbL/WmTiOSbuONTYPLKkbc/al0GFQGKScIOko7UbFI2WmHg+9otcoq
	JW3Xyxe22VXWhjYvCS9MAznznx2kStN7WmaaB1lLbCEIuRPalGwKmXRBtgody86d6R0Z1VJR1Ew
	/Rp7cW7hNbKqp4DdzleM=
X-Google-Smtp-Source: AGHT+IH9V77Jk8RO698QbiKv+F+gtIcqVl1iG13X0gUKZUfwL0hC3/rmYcr31Z4Epankft7r7WAhHw==
X-Received: by 2002:a05:600c:5108:b0:43b:c0fa:f9dd with SMTP id 5b1f17b1804b1-43c5c6a4137mr27636815e9.25.1741370692182;
        Fri, 07 Mar 2025 10:04:52 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd435c9c7sm86670675e9.38.2025.03.07.10.04.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 07 Mar 2025 10:04:50 -0800 (PST)
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
Subject: [PATCH 13/14] hw/vfio/ccw: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
Date: Fri,  7 Mar 2025 19:03:36 +0100
Message-ID: <20250307180337.14811-14-philmd@linaro.org>
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

Convert the compile time check on the CONFIG_IOMMUFD definition
by a runtime one by calling iommufd_builtin().

Since the file doesn't use any target-specific knowledge anymore,
move it to system_ss[] to build it once.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/vfio/ccw.c       | 27 +++++++++++++--------------
 hw/vfio/meson.build |  2 +-
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/hw/vfio/ccw.c b/hw/vfio/ccw.c
index e5e0d9e3e7e..84d1437a568 100644
--- a/hw/vfio/ccw.c
+++ b/hw/vfio/ccw.c
@@ -15,7 +15,6 @@
  */
 
 #include "qemu/osdep.h"
-#include CONFIG_DEVICES /* CONFIG_IOMMUFD */
 #include <linux/vfio.h>
 #include <linux/vfio_ccw.h>
 #include <sys/ioctl.h>
@@ -650,11 +649,12 @@ static void vfio_ccw_unrealize(DeviceState *dev)
 static const Property vfio_ccw_properties[] = {
     DEFINE_PROP_STRING("sysfsdev", VFIOCCWDevice, vdev.sysfsdev),
     DEFINE_PROP_BOOL("force-orb-pfch", VFIOCCWDevice, force_orb_pfch, false),
-#ifdef CONFIG_IOMMUFD
+    DEFINE_PROP_CCW_LOADPARM("loadparm", CcwDevice, loadparm),
+};
+
+static const Property vfio_ccw_iommufd_properties[] = {
     DEFINE_PROP_LINK("iommufd", VFIOCCWDevice, vdev.iommufd,
                      TYPE_IOMMUFD_BACKEND, IOMMUFDBackend *),
-#endif
-    DEFINE_PROP_CCW_LOADPARM("loadparm", CcwDevice, loadparm),
 };
 
 static const VMStateDescription vfio_ccw_vmstate = {
@@ -682,12 +682,10 @@ static void vfio_ccw_instance_init(Object *obj)
                      DEVICE(vcdev), true);
 }
 
-#ifdef CONFIG_IOMMUFD
 static void vfio_ccw_set_fd(Object *obj, const char *str, Error **errp)
 {
     vfio_device_set_fd(&VFIO_CCW(obj)->vdev, str, errp);
 }
-#endif
 
 static void vfio_ccw_class_init(ObjectClass *klass, void *data)
 {
@@ -695,9 +693,10 @@ static void vfio_ccw_class_init(ObjectClass *klass, void *data)
     S390CCWDeviceClass *cdc = S390_CCW_DEVICE_CLASS(klass);
 
     device_class_set_props(dc, vfio_ccw_properties);
-#ifdef CONFIG_IOMMUFD
-    object_class_property_add_str(klass, "fd", NULL, vfio_ccw_set_fd);
-#endif
+    if (iommufd_builtin()) {
+        device_class_set_props(dc, vfio_ccw_iommufd_properties);
+        object_class_property_add_str(klass, "fd", NULL, vfio_ccw_set_fd);
+    }
     dc->vmsd = &vfio_ccw_vmstate;
     dc->desc = "VFIO-based subchannel assignment";
     set_bit(DEVICE_CATEGORY_MISC, dc->categories);
@@ -716,11 +715,11 @@ static void vfio_ccw_class_init(ObjectClass *klass, void *data)
     object_class_property_set_description(klass, /* 3.0 */
                                           "force-orb-pfch",
                                           "Force unlimited prefetch");
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
     object_class_property_set_description(klass, /* 9.2 */
                                           "loadparm",
                                           "Define which devices that can be used for booting");
diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index 510ebe6d720..bd6e1d999e4 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -7,7 +7,6 @@ vfio_ss.add(when: 'CONFIG_PSERIES', if_true: files('spapr.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
   'pci-quirks.c',
 ))
-vfio_ss.add(when: 'CONFIG_VFIO_CCW', if_true: files('ccw.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_PLATFORM', if_true: files('platform.c'))
 
 specific_ss.add_all(when: 'CONFIG_VFIO', if_true: vfio_ss)
@@ -26,6 +25,7 @@ system_ss.add(when: ['CONFIG_VFIO', 'CONFIG_IOMMUFD'], if_true: files(
   'iommufd.c',
 ))
 system_ss.add(when: 'CONFIG_VFIO_AP', if_true: files('ap.c'))
+system_ss.add(when: 'CONFIG_VFIO_CCW', if_true: files('ccw.c'))
 system_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
   'display.c',
   'pci.c',
-- 
2.47.1


