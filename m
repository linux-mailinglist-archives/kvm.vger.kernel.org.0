Return-Path: <kvm+bounces-40381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 042E5A5700A
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:05:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F93416A2D7
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 18:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBCBB23F40D;
	Fri,  7 Mar 2025 18:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yE+Kd8r5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442EA21C16A
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 18:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370701; cv=none; b=cd2Av7ZqPeBDYe+vKvKddKGCy9X+r5to4OFsjDKBmklg4OESfiSatvaSZICqdFZCqql2O4fopcQe7QYM6bJ9EJD9PKN52t9wfDdq07QHmevviIgng14vqwu/84AFwL9b+TDlFOLmp9+0ov8feRCBO5kyinD7NwxWepauvMsgZT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370701; c=relaxed/simple;
	bh=FLHCLIM0b/6kSuMtYeSVqyvlLRhLbxGSard/uvGGcU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CCqwJHd/1g9K0soDBy8lEnWe3OCw6iUZzc9MftZg8bqikUwlSZm4oyVC1r2lBovQ0Q2itrTZr5Xe/PipSwNdc9T7j9V0U4PZSffb5fIu47PfqojSWTn49dGlKNNWkEIPetqyQ+VhG9NHwu/2nyv6HecQwMvRSECcgcnMSdnx2bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yE+Kd8r5; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43bcb1a9890so21414555e9.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 10:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741370697; x=1741975497; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=agcsT+LijTsdk7Aq19MciJhNx25N7TH6CXZbFxHQbqw=;
        b=yE+Kd8r58HbL+hicnfIoWppBM3KlrIzHhjXrEnwvxRfOuoho9RI2wDurc0QMgLS28Q
         GuN+gKdeeQNTHifGhYS2RoDMFLZu2sHfeFWkc1a6WqSAGpsnWzzn7tUFnCewBmJiF7xI
         OUgDDLKh+hX6eMvlnkarQ/pY9SVjx9Js6qUFbIoXqzbWz9h/JMBb5f/H1KfFt5TSH+DB
         aQYWTNMfOZa4oZ2czQjbcM3dOGqR226EPFDNapMmzMQGwdxBHXar40eSE0IYmd9t+uX8
         wPQWL3B323m0XCOqEgxVOrO+S4v/ivTCapsRwGxb0cXRNzdJTfQo1zaiKXM7Os1eJTLQ
         Wg+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741370697; x=1741975497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=agcsT+LijTsdk7Aq19MciJhNx25N7TH6CXZbFxHQbqw=;
        b=W7Uke9450x0QhWQ2Se+y+5TCcGD0jJJmxEFSW153HoZpASsCQgZOqu7WWVLzU6EAat
         Ji/d6EIyEu+8VlrKDmkBMj/twtzYQE23U03EOVzm+qIItza7VC+YpuDNHbqfSnhtqUAd
         lmPBc6hMx8oc4VVR+PCsCTl3PR6b7m6D7avtCZ/xhlbdLG3bKHrxM3uLoXCOo0M1MLUX
         ibEcr9fQjlK1O4iBgR99aBgFcnw6upJnk2hsVw26lKt9lANsWH3EbN6yMHJ2nnk18cep
         H1JBzj0WeBHeFrMtJ4BtPScIgBTAsQ1FKqp5E+hS6a5oM5RvmmrQ7Fc2v225zUObVRLd
         7jVg==
X-Forwarded-Encrypted: i=1; AJvYcCWH04FVQNmrvzuWfZJJrVy+m/30HWx73X0lgMiWt1EU8hw+Us46wyWqdl98gQuf+5m1nsQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywml+69Gi40OsaP5x+FDwAXtkLKEaPl0oXg6EkPLOxGzcuF1wnH
	NGS14dDoGpDPwD5V4TIGeFJ7iX5rZKSOFGbWwVxIhfJAinE5KXB9g5fLLuffOnk=
X-Gm-Gg: ASbGncvsoU1rtoWr/2WvRvXhSPxZQB2MN63503EChOiozJJvPP+nKRsuWZ9D6UOyGUA
	wb/hCQ8n5Q77rXAN6jQ7N6FoXszKwyAzToeRqddp6RpRX985Gowq2lbg8N/4pew6ciQi450RjJr
	9/lfo0sKavlFaATkcUtXD37/8q2K/u8kQfnz6RAFjvdOAIngLJTRrSDzepd2ZgMQBYG8CTm5wes
	iHgibUi729jonSUgNNLOYZFVC1p+CHCnUxrPZq2ILDNKKYQ4437MS60jNKi0EpC6j3uOVDLOM3a
	dWtu7uXFJienkeYmeFnbtH6DGTw5YoJjrh+Vq5RMuboRqW6d+MFcOVjM8+w5yB3uhPXa9jq3IaZ
	teXrcDYu/vXKPMmI27ZI=
X-Google-Smtp-Source: AGHT+IE+YfUTsyezmJk1O/V7rJmU3VYke7MWbvI0vhhGZxFwIjiesECECfkOBaEgpCq1WPQAC5PfkA==
X-Received: by 2002:a05:6000:1f8f:b0:391:952:c74a with SMTP id ffacd0b85a97d-3913aeee2d7mr346949f8f.8.1741370697461;
        Fri, 07 Mar 2025 10:04:57 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd4352eb1sm86964935e9.31.2025.03.07.10.04.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 07 Mar 2025 10:04:57 -0800 (PST)
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
Subject: [PATCH 14/14] hw/vfio/platform: Check CONFIG_IOMMUFD at runtime using iommufd_builtin
Date: Fri,  7 Mar 2025 19:03:37 +0100
Message-ID: <20250307180337.14811-15-philmd@linaro.org>
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
 hw/vfio/platform.c  | 25 ++++++++++++-------------
 hw/vfio/meson.build |  2 +-
 2 files changed, 13 insertions(+), 14 deletions(-)

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
diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index bd6e1d999e4..e5010db2c71 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -7,7 +7,6 @@ vfio_ss.add(when: 'CONFIG_PSERIES', if_true: files('spapr.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
   'pci-quirks.c',
 ))
-vfio_ss.add(when: 'CONFIG_VFIO_PLATFORM', if_true: files('platform.c'))
 
 specific_ss.add_all(when: 'CONFIG_VFIO', if_true: vfio_ss)
 
@@ -26,6 +25,7 @@ system_ss.add(when: ['CONFIG_VFIO', 'CONFIG_IOMMUFD'], if_true: files(
 ))
 system_ss.add(when: 'CONFIG_VFIO_AP', if_true: files('ap.c'))
 system_ss.add(when: 'CONFIG_VFIO_CCW', if_true: files('ccw.c'))
+system_ss.add(when: 'CONFIG_VFIO_PLATFORM', if_true: files('platform.c'))
 system_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
   'display.c',
   'pci.c',
-- 
2.47.1


