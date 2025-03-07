Return-Path: <kvm+bounces-40379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0DBCA57006
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:04:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C643188E2FD
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 18:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1D6A2405E4;
	Fri,  7 Mar 2025 18:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kB5D2Pjv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3117421C16A
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 18:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370690; cv=none; b=hdNkuj+xcsQtTNrcRyObCPYKJLki5RTTp8VdpG3ZXSo1S4jI1CbKb+aCZinnPrjAKsUOVJsBPWv+8uzQ9kG1SSnEiInu4EQVJqws6AGFUYPLeVw/x+yMgDwXJBPmrq2XLHgWQjydxIZhxr+deU8RhEklydlOeP+0R/cvArWNWYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370690; c=relaxed/simple;
	bh=mfjbKx9AjdlJqKhst2ETEG2d/D5fFQVg0pba5es4eHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IKRpHfQ18o5urnQHbA55AjVklxFKk9zn9TfzxoDXMbCijGycxt7Y4wXStaYnrCaDWpgZgJ4CxJ2A1jKww/2va9Frtvv7BPX2VqDpLZVnOELbS6Fk9cgVau2hO6gQCL1ECFCJFJmUqqTJ3qZ0IYo0D9xjU5im4sIuAZB66AdykR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kB5D2Pjv; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-38a25d4b9d4so1126563f8f.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 10:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741370686; x=1741975486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g0+sj+5fZPDlRh8EKfyzOVB2Z+MoNxqNRQg5EoTr07c=;
        b=kB5D2PjvGIuKg4czJSP8DSNi6EOw0gVBLrQv5XuudlktZJY592ISPSZuDE3zHL0h4D
         enu1O16zX3WtdV4L2OBgHBVbRE+CcpapSHTC00D1UumguHt2sPLYk6kx21Sixxz0WiPz
         jnWJdgQ282bvbeXnYt+qG9GzQYUyymefDHpOJe6NV1d5fLrFnBueIYa9U0+5HWUpJSwE
         za1lQT25rhZ6n6Umm04eQzLir04DixoL9xIfUnnUNubLqQ34kQbijLRA4ZqZUUKC/prB
         h94jLnHKmkbOPRfwNwuAy7bywYNuhNSlQHZ7DHQjDmp1dOw3Zrx3G0L+PxUOE1TRgrPK
         w1bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741370686; x=1741975486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g0+sj+5fZPDlRh8EKfyzOVB2Z+MoNxqNRQg5EoTr07c=;
        b=wUkD8wCxsGnwo8SWEfUqJ1+WMnVcXfoFZNn5y6oj7HGCAHW1HaawnwXstLrj5FUNNy
         vvUC1WgQRlfA1EJdMrkp5BYbB3QXinQvY3XzX2+NXmmdwDn4n0M0MwfW5M2MZEvff9IA
         3MmqbaYSfumKTEfrckvQ9Kr9bxAoWWys5SM2SM0k5EDA1sP/6FDQQrw3IRabbxh+2N+l
         mXSaC5mgLp0h6HTBZcVREDlBKEeFJYKt4XxqcGECBklGCu0gY+HJ4wJFsoJ0QsPvXITK
         LxjETFfEF+zx/+OmjsIJfQDD4MPk/n13scedlVVJsPuCXqZSGdF3pC7LaHukT4NyaEM1
         ebRw==
X-Forwarded-Encrypted: i=1; AJvYcCUDYSkO7HSPCXis8wGTDe2XVLTxE7++SKGzJWz7Uzib8jU9QMBs/9eHveKRgtzM8kERl0g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdJBZGIjgMtfoNd1OiVDRXG7lnYaKcyJmhWwnf9ZW8lHdoZcKI
	rfHgzvDQjXR7zyWGUOzMdks/9wuR0JQfPXM63IRfbUUiIVTivoxYinuYVD7IbC8=
X-Gm-Gg: ASbGncu7BZK+qfavdtMjW3SuNiAv4RwFMSuPLBVDlHKLdGI2I+D+J4dyBGdVmLaeX6g
	QPsujvTqn8KeXWoocR+QI4Qh7IzbWmsh0jsZ1jc7ofRmoOLdfm77k+AiHkRM5+5s9MRj2MVx2iC
	S0+ipFY78o/XG834Rt98TioxkAXuGRXUsOd0Dnx0f7N8e05S2tmtDjnL43B09jJPDvuRH2UTrSJ
	eKrtqqraBUUDPkpm7dBoTJxuLbYEvsufG+NTTVAm4S4LtQtdx8kJ0074bPf+VUnpaR/cy1yMOYK
	RrSeTK5EZC2F6aoEAxcvj2QHpQG6LJyv5EPlAYM89toYz1GHlDf9EGPwoBxwb2PHZxyFb8dVTBo
	kc6NFnZlgYrr5IRnsGNE=
X-Google-Smtp-Source: AGHT+IF97fayJY/yW6R5BSvdDohNcmjJuG0p61HA9ekjFXsJOXr24N1zzjiAZ7Wbh8GXE9bLdxWyzw==
X-Received: by 2002:a05:6000:402b:b0:38d:e401:fd61 with SMTP id ffacd0b85a97d-39132db746amr2784656f8f.49.1741370686062;
        Fri, 07 Mar 2025 10:04:46 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd8b046dsm58414135e9.5.2025.03.07.10.04.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 07 Mar 2025 10:04:45 -0800 (PST)
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
Subject: [PATCH 12/14] hw/vfio/ap: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
Date: Fri,  7 Mar 2025 19:03:35 +0100
Message-ID: <20250307180337.14811-13-philmd@linaro.org>
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
 target/s390x/kvm/kvm_s390x.h |  2 +-
 hw/vfio/ap.c                 | 27 +++++++++++++--------------
 hw/vfio/meson.build          |  2 +-
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/target/s390x/kvm/kvm_s390x.h b/target/s390x/kvm/kvm_s390x.h
index 649dae5948a..7b1cce3e60d 100644
--- a/target/s390x/kvm/kvm_s390x.h
+++ b/target/s390x/kvm/kvm_s390x.h
@@ -10,7 +10,7 @@
 #ifndef KVM_S390X_H
 #define KVM_S390X_H
 
-#include "cpu-qom.h"
+#include "target/s390x/cpu-qom.h"
 
 struct kvm_s390_irq;
 
diff --git a/hw/vfio/ap.c b/hw/vfio/ap.c
index c7ab4ff57ad..832b98532ea 100644
--- a/hw/vfio/ap.c
+++ b/hw/vfio/ap.c
@@ -11,7 +11,6 @@
  */
 
 #include "qemu/osdep.h"
-#include CONFIG_DEVICES /* CONFIG_IOMMUFD */
 #include <linux/vfio.h>
 #include <sys/ioctl.h>
 #include "qapi/error.h"
@@ -24,7 +23,7 @@
 #include "qemu/module.h"
 #include "qemu/option.h"
 #include "qemu/config-file.h"
-#include "kvm/kvm_s390x.h"
+#include "target/s390x/kvm/kvm_s390x.h"
 #include "migration/vmstate.h"
 #include "hw/qdev-properties.h"
 #include "hw/s390x/ap-bridge.h"
@@ -193,10 +192,11 @@ static void vfio_ap_unrealize(DeviceState *dev)
 
 static const Property vfio_ap_properties[] = {
     DEFINE_PROP_STRING("sysfsdev", VFIOAPDevice, vdev.sysfsdev),
-#ifdef CONFIG_IOMMUFD
+};
+
+static const Property vfio_ap_iommufd_properties[] = {
     DEFINE_PROP_LINK("iommufd", VFIOAPDevice, vdev.iommufd,
                      TYPE_IOMMUFD_BACKEND, IOMMUFDBackend *),
-#endif
 };
 
 static void vfio_ap_reset(DeviceState *dev)
@@ -234,21 +234,20 @@ static void vfio_ap_instance_init(Object *obj)
     vbasedev->mdev = true;
 }
 
-#ifdef CONFIG_IOMMUFD
 static void vfio_ap_set_fd(Object *obj, const char *str, Error **errp)
 {
     vfio_device_set_fd(&VFIO_AP_DEVICE(obj)->vdev, str, errp);
 }
-#endif
 
 static void vfio_ap_class_init(ObjectClass *klass, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(klass);
 
     device_class_set_props(dc, vfio_ap_properties);
-#ifdef CONFIG_IOMMUFD
-    object_class_property_add_str(klass, "fd", NULL, vfio_ap_set_fd);
-#endif
+    if (iommufd_builtin()) {
+        device_class_set_props(dc, vfio_ap_iommufd_properties);
+        object_class_property_add_str(klass, "fd", NULL, vfio_ap_set_fd);
+    }
     dc->vmsd = &vfio_ap_vmstate;
     dc->desc = "VFIO-based AP device assignment";
     set_bit(DEVICE_CATEGORY_MISC, dc->categories);
@@ -261,11 +260,11 @@ static void vfio_ap_class_init(ObjectClass *klass, void *data)
     object_class_property_set_description(klass, /* 3.1 */
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
 
 static const TypeInfo vfio_ap_info = {
diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index 9a004992c11..510ebe6d720 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -9,7 +9,6 @@ vfio_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
 ))
 vfio_ss.add(when: 'CONFIG_VFIO_CCW', if_true: files('ccw.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_PLATFORM', if_true: files('platform.c'))
-vfio_ss.add(when: 'CONFIG_VFIO_AP', if_true: files('ap.c'))
 
 specific_ss.add_all(when: 'CONFIG_VFIO', if_true: vfio_ss)
 
@@ -26,6 +25,7 @@ system_ss.add(when: 'CONFIG_VFIO', if_true: files(
 system_ss.add(when: ['CONFIG_VFIO', 'CONFIG_IOMMUFD'], if_true: files(
   'iommufd.c',
 ))
+system_ss.add(when: 'CONFIG_VFIO_AP', if_true: files('ap.c'))
 system_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
   'display.c',
   'pci.c',
-- 
2.47.1


