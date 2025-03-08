Return-Path: <kvm+bounces-40515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B0D1A57FB7
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:10:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8C4316B0E3
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:10:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55AC3212B3C;
	Sat,  8 Mar 2025 23:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pcWZxKfQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE66520F083
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475451; cv=none; b=gp/H5S76p2SvfP4U5ieOYmRYMYaslAo0v7VE5VOtB9ZV68G6qgohy/izak17NHhg+pyAZVOqngpNWcdxkt/bVoy1PnQ+SAQFFrDeAgs0L1xvZN6J68jEDeNtxbRJ/I9qDTrFXu4Osqa1wZkB8MKmGni/I09iMmdsPX8byOF3X8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475451; c=relaxed/simple;
	bh=Thj+uJzLgQ7BqnoA+PwoNvSZQYPTABL7cPmxH1Gg5NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RiggTxq8m/eIttTWF0+2S0tLYZ9X4FVH42AZKQlU/aah4reOxGd2S2e4Nc4ddaaWbhVb7ketvR6FW9wyqOnIqxd7D0J87CHAelFgcfQ3zzBC9QiC1l+jw+Ev7zWYGhtPKdLABsrz1SzCktF6Psmwh7F66joZ7oGlJk0rmQTeHDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pcWZxKfQ; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3913fdd0120so217392f8f.0
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475448; x=1742080248; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rb5Gq5gjoqNir/3li58uEI51RqNLZd7aJ8wRwb3WrW0=;
        b=pcWZxKfQ1rYSFopE9uNUEEak91WmVdiXEogtOIhLLhacIjG4PCyM+DkYviGJtJ2eKY
         OVgERrPS+Dyp6n1bczJ88aACxsfufm4wbbasF+JehyiA5WPOHFWioyO03bfW/8YpcobT
         p3Pk/St12eSCJsOjJteTxq/HEPFUyDkR1kCfvy6Q11wQLQ/ZBjMiG4u9pmjuhIZNGDo5
         k23mYyIYx00ncJxw7FB5W8dxZYu85ZSafzToTcME6yMhebdzxIWWvgqGYCZGJvq6FX0E
         tJzmABU4HTHK/dT2oN4Uzq4HLkcVDH5k7tHrrp4qxaZdxvre8sSDbZmrYghFko363v2O
         EHSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475448; x=1742080248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rb5Gq5gjoqNir/3li58uEI51RqNLZd7aJ8wRwb3WrW0=;
        b=fbMVfjne6vxlknXRDWlfqycu9dq+R7U968r14TznHEPeN4D8JZKTUWTyObTAjIdu67
         W+8XZXmicSbwr76DhWGVd0x+t4t3UHdXdhJsJsaw3to+RHKkimQHreI1xunrdgOYLrwW
         qiVkwkRldtHiGqXA7GjJGDiOKTos1hEYxSIjnVfcrrK+KENhl61YMNUPGs5h+hPI8/o/
         OQoKkbiueCgOtU3cO6nFTfO1NFQoyEQUJ/cg5wsRPa7rW3DhXLLFzDpPZfzaQSHnpLo6
         GEfz9aqnlxg0xpxHgyVv1hANUUpewt6913AHH/z2ti3dhXBXGIl809AUZn3KsKvfSmlM
         cGVA==
X-Forwarded-Encrypted: i=1; AJvYcCVTsIxzEixNyqIv0oxZjAOmKFrzo4Mo/uGaLZeFlAfmBzm4v+rE9gbqXPhOx8BXH3+EryI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyETuQBSi6lffeuX8B8F1nWqfaUBdmQWX8Q7nPVee69wCuTpOPI
	eoyEkOj3/owzWbg0D84tD/iV7c3xhWP35JUZiN15SS121gVcoC7GO+/lvK4c/OY=
X-Gm-Gg: ASbGnctnucVS2/uB2IKOuhu6qwQDeLyEXQ3E/1QUIGn025iwKHAiRZPE1JNx9MCJIKa
	jYN7/kghVGrUKzkLuzvQ3xYalQgpy1DwIU3GqYfafEwHzdGuSylw18lcOcMotvlpdE/WU3J9GhD
	CUYqsAjVDbSmFqaU6F8BN8nGCIZ1/9o6ebuUW1nLlg4t4KsC8HV3TAL2JHYtW6lS3FJcltfU2+R
	QLZEF0uwhnjZh58EPfP620KYNer0f3mBvcxclIpXgwQYojOpSXsjFTF0hKIc925yt0LEogv0wi7
	EYTl+EmBOodXAPxa9PBoe+pzDlgUBrA/jJPFQ1Mr/omCiiHAAIqyK+w05WhETVzIqOFt4S4VCfm
	4SSVxesVr57q7XdEU19g=
X-Google-Smtp-Source: AGHT+IFpyPZ8OHsunTdPUAhz3+hHZqpRzqB+uc+3KU0WeLI4qJr+CM3YEWcq/yPMOmAPEzlWQ4DAbw==
X-Received: by 2002:a5d:588f:0:b0:390:f394:6274 with SMTP id ffacd0b85a97d-39132da9214mr5345868f8f.52.1741475448065;
        Sat, 08 Mar 2025 15:10:48 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfb79fbsm10297840f8f.13.2025.03.08.15.10.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:10:46 -0800 (PST)
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
Subject: [PATCH v2 15/21] hw/vfio/pci: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
Date: Sun,  9 Mar 2025 00:09:11 +0100
Message-ID: <20250308230917.18907-16-philmd@linaro.org>
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
 hw/vfio/pci.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 9872884ff8a..e83252766d1 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -19,7 +19,6 @@
  */
 
 #include "qemu/osdep.h"
-#include CONFIG_DEVICES /* CONFIG_IOMMUFD */
 #include <linux/vfio.h>
 #include <sys/ioctl.h>
 
@@ -2973,11 +2972,10 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
         if (!(~vdev->host.domain || ~vdev->host.bus ||
               ~vdev->host.slot || ~vdev->host.function)) {
             error_setg(errp, "No provided host device");
-            error_append_hint(errp, "Use -device vfio-pci,host=DDDD:BB:DD.F "
-#ifdef CONFIG_IOMMUFD
-                              "or -device vfio-pci,fd=DEVICE_FD "
-#endif
-                              "or -device vfio-pci,sysfsdev=PATH_TO_DEVICE\n");
+            error_append_hint(errp, "Use -device vfio-pci,host=DDDD:BB:DD.F %s"
+                              "or -device vfio-pci,sysfsdev=PATH_TO_DEVICE\n",
+                              iommufd_builtin()
+                              ? "or -device vfio-pci,fd=DEVICE_FD " : "");
             return;
         }
         vbasedev->sysfsdev =
@@ -3412,19 +3410,18 @@ static const Property vfio_pci_dev_properties[] = {
                                    qdev_prop_nv_gpudirect_clique, uint8_t),
     DEFINE_PROP_OFF_AUTO_PCIBAR("x-msix-relocation", VFIOPCIDevice, msix_relo,
                                 OFF_AUTO_PCIBAR_OFF),
-#ifdef CONFIG_IOMMUFD
-    DEFINE_PROP_LINK("iommufd", VFIOPCIDevice, vbasedev.iommufd,
-                     TYPE_IOMMUFD_BACKEND, IOMMUFDBackend *),
-#endif
     DEFINE_PROP_BOOL("skip-vsc-check", VFIOPCIDevice, skip_vsc_check, true),
 };
 
-#ifdef CONFIG_IOMMUFD
+static const Property vfio_pci_dev_iommufd_properties[] = {
+    DEFINE_PROP_LINK("iommufd", VFIOPCIDevice, vbasedev.iommufd,
+                     TYPE_IOMMUFD_BACKEND, IOMMUFDBackend *),
+};
+
 static void vfio_pci_set_fd(Object *obj, const char *str, Error **errp)
 {
     vfio_device_set_fd(&VFIO_PCI(obj)->vbasedev, str, errp);
 }
-#endif
 
 static void vfio_pci_dev_class_init(ObjectClass *klass, void *data)
 {
@@ -3433,9 +3430,10 @@ static void vfio_pci_dev_class_init(ObjectClass *klass, void *data)
 
     device_class_set_legacy_reset(dc, vfio_pci_reset);
     device_class_set_props(dc, vfio_pci_dev_properties);
-#ifdef CONFIG_IOMMUFD
-    object_class_property_add_str(klass, "fd", NULL, vfio_pci_set_fd);
-#endif
+    if (iommufd_builtin()) {
+        device_class_set_props(dc, vfio_pci_dev_iommufd_properties);
+        object_class_property_add_str(klass, "fd", NULL, vfio_pci_set_fd);
+    }
     dc->desc = "VFIO-based PCI device assignment";
     set_bit(DEVICE_CATEGORY_MISC, dc->categories);
     pdc->realize = vfio_realize;
@@ -3540,11 +3538,11 @@ static void vfio_pci_dev_class_init(ObjectClass *klass, void *data)
                                           "vf-token",
                                           "Specify UUID VF token. Required for VF when PF is owned "
                                           "by another VFIO driver");
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
     object_class_property_set_description(klass, /* 9.1 */
                                           "x-device-dirty-page-tracking",
                                           "Disable device dirty page tracking and use "
-- 
2.47.1


