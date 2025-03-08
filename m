Return-Path: <kvm+bounces-40518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8752BA57FBA
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:11:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABDCD16ADB3
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A79EC20D50D;
	Sat,  8 Mar 2025 23:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LUR2pbxp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147E41B425C
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475467; cv=none; b=XpphMQ9YDra/TSMFEZLcTszxVxI7sjsQWgpRd+p1JsuDZjHeb3rVLBdhV40VlwAD0zpyply4wsQQwvoGCzkm1CWLXM27qb2kImXBONkvCiWUk6LbWjufBCBFwWUy+5A8tuBbDRqH4h2HzaSPv2J5ozLH3Wtj0XlVA69VKuea1ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475467; c=relaxed/simple;
	bh=/xJoMUA1bbz7x7HDB3B/t2WxKBtWlxcELzk39ZA2w6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fmV2hYa2EpdTKM3dXuHWjrxy1L/aXp4YVVMZQ1ugRQNuy9hQL5oXMxiraGuNEKj8NW27Ie7tmpOLtQzX4ePSPOkPffprqOc+xfQ3be9chVLsJrzimvSzVnwO2ynZgX1QxCQ2Zx1kXoFjYuX1G6dFK9IlWCVQMxARGHpLobQtBe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LUR2pbxp; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4394a0c65fcso32737825e9.1
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475464; x=1742080264; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xZOLi7hVFZ5LkXmaV+OYfUEhNf7zzYjD6/tmTvULQjs=;
        b=LUR2pbxpjLSwbQZyo9xHninBP69u3yh5HI8ojYtWbqDwRtUeAWKqN1yBATKNWnDSI2
         zmebExxQUTp/3I7AFqNyo3tgG5jbDBRKBUSYSQhSYKXzaL6PG8HM+niJA8b/Gw2lSLCS
         r3nCh85pMjX/w56ua3BorVLtvovh3fVlk0s0r+HSoQCW3PH8rKdTH0F9cAIl6zSIoQc2
         3akNpRLhVT4pPBbFlJYdhy0PPs1krjqjJ3HP5MvgT5XwNnhEabSdBREQJfXv6BD/cwEw
         YOpKZyTbxFqK3a2OQ49WOMLhyZrpbZ8v00F2L3zD/1/hFsq31EGpvlMXBGhy2vsXQ4eo
         HkHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475464; x=1742080264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xZOLi7hVFZ5LkXmaV+OYfUEhNf7zzYjD6/tmTvULQjs=;
        b=KU0IFSV3/MJ7wdbqgAHRffEA4Th6HuEObPRTUeLky+PbsnzEmTR3/Ta5S44wOpx3pN
         iSjiM2f62prbeGr3jiy3/uSVTokt+SGVnQ555Oxi7zICPwgHtvVcnQdBMrrHif1DfUeE
         VyCb2DBsFbv92J2hUTG+jpDoLKvuJM+wcVJqgVdK75wVtyFsJUqFbqHPxYuM/NBGPwor
         +aH7inMay1/kjnoB6SN3mfxTv7+4Glm/AHX+tJgVTRdAHIytitTv5qK11X9mYyq7cHaV
         cDOdmFqWdwmYPMiceN5GYMY7w97gSH+Pt2WNJCyHwwDsFlKvsDRKNR5FUMvoGeky+AkT
         6ECA==
X-Forwarded-Encrypted: i=1; AJvYcCXssBHwCU+Jd35eBw0K+SG8v3ubuGBwIglQUZ8LZn9oaNnGcNUU4K67FPfKtJQNoRA1fVY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzV/PHYCkkFxYNJ/GHADdS+FSkWbeOB5nU+QRNIP/7R9bXwavI5
	SH5rbo2Sw9ps8ZL4Eg1cjZbY72MWuibiM8pYYXXKib6cHoyizoIfUxROM+hW2Xk=
X-Gm-Gg: ASbGncsZ0Y95SyNjRsCq3FN6fOncdHl2MKPm49kFMwrTtuq6uZeABSJhCJCCxKS9PBk
	s64JpSorFur83JK4RFEuiUAzYnpqYu5SH4uJfnuSKmBfEavQxjbUaDgT91GscfStMFBHQP5jrgD
	+rtLMLId1RgogNrMYp3y5E3FkDeoh/HTE2tkU+75lWIj9lAANRBQrJ8ibhi58SjfIIPQU7X1ebr
	sQJ2ddCLUdWvUcuWQwUkmWAVApWWeInnKc+KJaaEBvYMMLTo85Rsc2pzKuBJZM18Y+/9es7+z0b
	huOTYKgJ3dEpkxOcXrP4T0aKjQ6trShOSlALT85tZOu917nZH4I//ry8XfhhVT6dAuQfkprz4QQ
	x/YduFMnkskuc3NhE4TM=
X-Google-Smtp-Source: AGHT+IGWy1gJ5oJ0bHv2ZZjJsgicnzsIu9r/rWofhhX1E8f5N83B9uErX1SevbWarzZRQU5Rb4Xxww==
X-Received: by 2002:a05:600c:1c03:b0:439:9106:c09 with SMTP id 5b1f17b1804b1-43c6021f124mr55430515e9.26.1741475464444;
        Sat, 08 Mar 2025 15:11:04 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd4352eccsm126209355e9.27.2025.03.08.15.11.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:11:04 -0800 (PST)
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
Subject: [PATCH v2 18/21] hw/vfio/ccw: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
Date: Sun,  9 Mar 2025 00:09:14 +0100
Message-ID: <20250308230917.18907-19-philmd@linaro.org>
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
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/vfio/ccw.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

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
-- 
2.47.1


