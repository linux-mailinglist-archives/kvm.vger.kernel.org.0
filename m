Return-Path: <kvm+bounces-40378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C241A57005
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:04:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5F6A16812D
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 18:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 453FA23ED6E;
	Fri,  7 Mar 2025 18:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="v3+0hoY5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8115223E242
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 18:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370684; cv=none; b=cWi+mBmgiZG7niOfR9NwQK/3DGn2seyOxWwSO/k3tNZFJlPDhM2rERrEtbHvT+HKceHQ8MWsYZ7TKga0/YSLEDGEnHJoxSpMkKk8tKIMN9ROTnOTDfSgrqj8KSVH9IqAns7DI8HWRMiHDkpY9zEAZFnDTqd7Ug0a3sXUTenINiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370684; c=relaxed/simple;
	bh=IgvrL0x3pBRxvbI5eiXPj1cGFAic9oG9Jxjne+aCAmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n6HHKVWWeQsxYU1ty8AUawCO3TkkF1oViBaBB9ykHmeZYme6EWQoPw/GuLDuua0a4SQ2rxFzld15+dJSlKDlQ8FYosU5UARFx/G8IIoYUV7YMarMT/sX5ZZo0P4fvEb+BOdLpm3LJcxFPzbSa2F9cqXjeLWXdwIBI+nB2xT3cuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=v3+0hoY5; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-390e702d481so1168652f8f.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 10:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741370681; x=1741975481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=otdB0Dz5nRAMnlnyGAk6/GxyQibbHb9x6DFoSBTI7l0=;
        b=v3+0hoY58BeKLtWAiHrGtiXrsYAT/BbcS4HfQ0DY8gRBKZqZP7WQ0h2h2ExlHgYXAD
         a8k1/773eDdkI5JTDrep34WXdIByDp8H/V9RrSZyTeUSDrwMjF577WYtl1sgFfUwVVwK
         gNUEX0W4Qi31sQWu3s2cQrGFFLbcz1xT4kdfsYgclo6J8tAEj1xpaSgALPdRn28mhEkY
         6DNeA2xgXYq5Uj5ziSsXeS18AyJfWAQV7tXXDkj4ciWBhCfRVxaXX5Q9uxU9j7SXw/QY
         ZbIbutyEroSrTuhWlgRrAldl0YQEiSgFjiI1fx9JwSmUKAQ8K61457vbLtedi7anTpOG
         xJrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741370681; x=1741975481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=otdB0Dz5nRAMnlnyGAk6/GxyQibbHb9x6DFoSBTI7l0=;
        b=Q4m8JcBMRNg9fO3Wh3fkf6SDigUXzoDsclm4L+KEYmlVBFtMykq97qtjucom9VEAz9
         fm/a+twrlK0dszNRNi/1Jroa84YQYx8/x78cOU2lQmZPxNPxHL5KfFcyCxpeqbU2lMh2
         Od2RgY/3ZpNoRO3kgrOl21Q+3bx1IKXWarPw8yyy1+KjbN209l2WOAtdP8QSAWnMPoX6
         UTlyY40VX7JG1ZTtF2SMYf8NJYvscvDJEsEDgV/v0noRhhefGbvKxz+gW6FwbfyXPEy+
         qb1TWcxjw3h7Cl717DuDk5o+uHS/eXTOvdBmwEndLIjw8ypWf2EijkC4LZEOtx3s7PF7
         IGYw==
X-Forwarded-Encrypted: i=1; AJvYcCU+rx68VdptHMOqeRPNvpGk4Cn1h5pePq+INt4nwauyx5xOArBpkAQEEN0/VXHn2A4EXxk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNm/AQ2ogIDpLvAtSIA8OqSYbaL1rps3ap6DoHq9YPhpHcVrIA
	xKIDTv6oFeBU403ijC0oD0CN7bVOs8qlbVulCkzsfTLyX+GwrglDsRU0/7gDY4U=
X-Gm-Gg: ASbGncupsmuhuROW59M5NMH8Nw/qpyvVEYlWtwDQ3M5gyS05bYuez7HAFhq1jdXf769
	omM1kOUfXNq+5jVngmI5cU153abpHsWj9Si1fXbA0P9IbEx8XAouUaNEyEA+xH/PLLS8gc/UYQZ
	xIQIRLdbnoilxAoKKRjjW6grajEqILnJDGdURd5jbLomZEoJjAn9CnGUSVMtzzKbuSxofZ2Vc+e
	pEZ7nBnmU9L2VOQ7wGFiLJKTpnN/VEaDJyNZNA+GLymAOetehj8URv7M6bYosfpjPLhtuFsLRuz
	3Xv5MB3l65OT0HKU+dG1+svSPJPKjPsE5wTFPZlurcz9agEW1LgeC+jkfYx4CFLL8z1dn0Mekg4
	78rJ9D2f+kef+UqTVx0k=
X-Google-Smtp-Source: AGHT+IGoXSQiYR+Znceq9QhV/DA24dcXDFRGzeqHnWry6oSbt2EZw73v5ZrTBEMEOa+RqbZY3pfWWQ==
X-Received: by 2002:a05:6000:4112:b0:391:d52:d042 with SMTP id ffacd0b85a97d-39132d883f3mr2410120f8f.32.1741370680523;
        Fri, 07 Mar 2025 10:04:40 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd8b0425sm58830765e9.3.2025.03.07.10.04.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 07 Mar 2025 10:04:39 -0800 (PST)
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
Subject: [PATCH 11/14] hw/vfio/pci: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
Date: Fri,  7 Mar 2025 19:03:34 +0100
Message-ID: <20250307180337.14811-12-philmd@linaro.org>
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
 hw/vfio/pci.c       | 38 ++++++++++++++++++--------------------
 hw/vfio/meson.build |  2 +-
 2 files changed, 19 insertions(+), 21 deletions(-)

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
diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index 96e342aa8cb..9a004992c11 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -6,7 +6,6 @@ vfio_ss.add(files(
 vfio_ss.add(when: 'CONFIG_PSERIES', if_true: files('spapr.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
   'pci-quirks.c',
-  'pci.c',
 ))
 vfio_ss.add(when: 'CONFIG_VFIO_CCW', if_true: files('ccw.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_PLATFORM', if_true: files('platform.c'))
@@ -29,4 +28,5 @@ system_ss.add(when: ['CONFIG_VFIO', 'CONFIG_IOMMUFD'], if_true: files(
 ))
 system_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
   'display.c',
+  'pci.c',
 ))
-- 
2.47.1


