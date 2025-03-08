Return-Path: <kvm+bounces-40517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF779A57FB9
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:11:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 35B11188DEFB
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59B8620C468;
	Sat,  8 Mar 2025 23:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VmuZ/rZX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B27C2FA
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475462; cv=none; b=FxhDeTtF51bQdN4BPg/dAzw8cHVRtXwr2+8U/ciP/zyZRx6AI/p7fEQUPn9Uph2wlpEME9S7p8oupjYeV6xtEfls9xbcOEftQV2iCl7x5cujekpyFJE/t1MDhxksJCwp4t1UsBBnuzvRQJtfvlHhhf5xBnTDuELdrngwXCam2iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475462; c=relaxed/simple;
	bh=I5mIKYcrbyUHvfM9+OPuCpKvUF94WRLAFqLK6WZJsXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZrmJLZDj8TDOuK8780UC1bUYCvkq4yab6KXVJbqvn/ImdpORijGqkgE5IRmh/DP9zhvMg6DTmh/pSMiKEnRJZfbXDOI++IfNk9DFh68XWZLYmaTn38iCZCSvYH0Mn7yAKeLLpk7Z33daimVqJitOitXu9K9htSV0N02Y863a3S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VmuZ/rZX; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3913d129c1aso403084f8f.0
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475459; x=1742080259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9qGswFlRD0j2khHR7PT2I53zcxF8+u37OT/9BiqIPFA=;
        b=VmuZ/rZX9XfuAsir3hp1sIddHGPIxh902gi2HIEwj44sWnVWjHNxMnm7ON6q7M3DtV
         Oa8f37biC/wf74rWdpAK0knGgzZR1QzNXJk12Xqep9KG7DkK0evpYqdYPcMgbqpqZjOr
         rs2tuS2I3rDPhdz8ZtEKp9PpqlotdUDP5G0eRi78yXpnKO48qA+il3b4icctXDC1o1lP
         d7R9ePGzLIDJPOYH9F2LrGTRbPqhMcUDjwKn+TyVSFpOzjB2FLw4OYd5FcDs/GIYfzYg
         3h2Md9hywyGsxsXCz1WycJjJ2cTLIWbz7olAoBcC2/rZcZayxZjdQWfh//VnMqiUcuRL
         nC+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475459; x=1742080259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9qGswFlRD0j2khHR7PT2I53zcxF8+u37OT/9BiqIPFA=;
        b=Qy8SsBprNXfh6gxjofpC8CqsK+5SLMAsaFpR4vpU0kyS9ldu5CgWGzwh+89Owfi/34
         I16Bu7EWnQaRgSGxB48TZqYfLTcSrduRIi9DtOjS1EwHODchPMaKPfFciZnYQZn8T9Rm
         iKZNHfDFLPHarX5TnuHvZNEpTq3q7XklROW578YT5VANvu6d0HaEJeF5GgSoJ6p5u6YK
         mfVU4vhSLScY8uZhwslgTSDbFh9OJs7hlibaqbnlsBJ3u41eX3N5oH3RqBtxlGH0VSie
         3lGpIH9jSMVbf4kRwQVabetAqlbsM3NS0RMInoBGkx5lwdiqnCEqyih3L07IoH4vWcqc
         i8tA==
X-Forwarded-Encrypted: i=1; AJvYcCXmSitCoOB1Vrv8KNiZbtxOn3l9Yr/uhl5DqGfgf+ylvRbipZMIjAPVowPH4qN/sAJpp5A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDGS+8/5J7HVuBDyRhNj60cxNLvSPY24VqrgRnP/l2rtvxd35o
	2jdy66x2UTLRCC+gK1jWmiYIrhCdkEmf8dqvpJStlbntOlsXNdECWvWqR6HdeEo=
X-Gm-Gg: ASbGncsAYrt/VK2kUp5Jkbdxea5dQknnNnTT+UToQX2yXRufSBuLYbw4Pb5sfz4enKf
	uveNkOfQkAoNvrifPwU0GW/Yn8wzMhd37927Iy74eIeLcTLHK/ad8Pfy2EFdP8Kwkk1pkZEn4py
	MhPhTPWKuZSMKp4y/8FxgRo8d0XaqXU/UPmDuISEXb3RKuGGBvGdk4LgwHgrBz8O5eyAbIaBPgU
	vBQ9G0zSXRzPFnHgzLI/mR1tmZ8INE0cZDuzyWdflj/x4JkzxCF1+pbEeRI+XWNSQD/0KGN/Dmo
	4flCWaSo0ckRbpFE01lrHdZO2A+zpUitGtTiQuCVGWTqBm5SOkBe2z5CJ4JQ3jRZoJjZAgS1gBT
	vg7T5cRV6eEKUrln3XTU=
X-Google-Smtp-Source: AGHT+IEbpDTd0sPomjcJ6hoJScZQbmBmzr2wv56KE84rBFKzKYjSy1/YKGyelEMd+2MRWVmS4KkUgA==
X-Received: by 2002:a5d:584f:0:b0:391:1218:d5f4 with SMTP id ffacd0b85a97d-3913af39bccmr2283871f8f.23.1741475459232;
        Sat, 08 Mar 2025 15:10:59 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfdff72sm10254923f8f.36.2025.03.08.15.10.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:10:58 -0800 (PST)
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
Subject: [PATCH v2 17/21] hw/vfio/ap: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
Date: Sun,  9 Mar 2025 00:09:13 +0100
Message-ID: <20250308230917.18907-18-philmd@linaro.org>
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
 hw/vfio/ap.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/hw/vfio/ap.c b/hw/vfio/ap.c
index c7ab4ff57ad..a4ec2b5f9ac 100644
--- a/hw/vfio/ap.c
+++ b/hw/vfio/ap.c
@@ -11,7 +11,6 @@
  */
 
 #include "qemu/osdep.h"
-#include CONFIG_DEVICES /* CONFIG_IOMMUFD */
 #include <linux/vfio.h>
 #include <sys/ioctl.h>
 #include "qapi/error.h"
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
-- 
2.47.1


