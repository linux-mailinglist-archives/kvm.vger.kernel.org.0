Return-Path: <kvm+bounces-40512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D2D6A57FB3
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:10:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D56A318886FF
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 286FE20D506;
	Sat,  8 Mar 2025 23:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ndGrVitr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F3E204C0E
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475434; cv=none; b=KXIAHLe3Spd632BGuGCBqgyA70q2/zyJKnuowF6kyVPHf/wKXjenBwQ4s7x3UN3vOQC9mffnjfK5Npai5mLu+Ue+5pJhKpXWENoyumo6DpjgdnmX6jZFEkytxcLr5tampExbQQrElzqUv5U35NY3uj4LpLGhPMMk8Fs00ryPvrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475434; c=relaxed/simple;
	bh=ZNMxDQGH/sVZUrTxysAVgzIDNumCJrah7sTuY1lpDAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NFYrwQzxgnYUoQjPS18BNsz6Yc25iV9MGXtX3xEivg0CVpjVJDw9CyyOAMe4cCbLa7qWcNTUA8bR0Y54Vj6CdKpxgbl4kWV71on6z4FKM+CGuje73yw8Q+7wvXzZf8GMyNocrs+PimF3kZnu936ShGVhqu6zOCEOr6jk+X6Jh2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ndGrVitr; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43ce71582e9so4078315e9.1
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475431; x=1742080231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kqJ8O34qNgm7bETvjKnBNqBiS0iJjz9k+q/OCgWJZ8A=;
        b=ndGrVitr4n2KZoqFYCOgZJNDoTNHUqQPQDZ0FQcSweb6Y8rYPSnAJMqE5H3869oJ6t
         4Qn981c6gMYHktNb7Ur6cLKnyQyskBvkHOYvq/7AxL0ZCVKQrCs2p48cSkrWA22qQcfQ
         95OpSOIFFKe/b6bj1ZDTXprbN4IeMEY6XcAp9WnRlrGqdsZbnqvCTJQw2PLJb8WoFevv
         7l9z6R48rEeJzBYeRmJgdpPegy8Avyj3vxQXi0uTxIUzSeXFkw3dXP1yFfWT5xnE1Qo4
         7qMDgGLx2nfQG/mqcDVsiC2qVw4HdbXSm0oiSahHypMvoJHLlETZusF9yOh+6PkpgkO7
         azbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475431; x=1742080231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kqJ8O34qNgm7bETvjKnBNqBiS0iJjz9k+q/OCgWJZ8A=;
        b=uaG5BWaDvzzLb33+NewEv+uo/mbiRdfkjpgjKggpGA1x30xcv4uKkfQmK27erB3cbp
         lU9gEDtBVAJHNX4uT3kv1JzXbBVTCVOsG9SIK0u7TiiuXcdIFDXc9QqcdXl+UaU6AZRR
         xLczappMyRR4pY2futZLNLDRXIPtPCPxuEruhLDeoMEcwkF0Dvgh+Gzv6VnbUUaOT8af
         I4tLEiyqQwa6v66j50cZIgD46QePbsttOUMXXVAumrhy0F5b4vbpSmZpjNFqEJvRNSA1
         1cu/siwy2mj6UZAFU8mWuyJdSWVwDBtj8Y/yomZIQTTMcMZ+Zkgg6tKaIqG3feVlxNzs
         PFTw==
X-Forwarded-Encrypted: i=1; AJvYcCWJfFFMvD4mizRfQC8hMb7XCFqTIVwwNBhNqJ+CiqWlOk4pj8wQDhAMWPU0Sj7wiHZM6jM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIs36q2wyo/UHWhq13DcfPY07eTWqDtrJ2cA1YD9X8yM5Swblt
	YRu1VcUfMkUk0gh6snW6Kv6PWmPi+NpNR9iJ6MzFLUNIak9CYlhYiuIS4jyORDY=
X-Gm-Gg: ASbGncuZC/PF6MeR6ao6fm7QeP2TrUr/zYqRbCbE2yk324eNK616774i8qzPX4GtEwa
	dmuH5xHj2OCw2yOMaaPp3vEEfFaxMJUu7m3XC0eW9i7wu3b/DE+8PDxhD0I/BltoS90dGT4ohf5
	lNc3znXe+MiwMGdxgkk+U06zOxM2yMfdJ8iASZMQsEqlKcquPSp1pM+ZeIw9llI1ewJOLtI8tjA
	vfnELQ7SxAVgGTDUT3Vx0nRql6tvYI5X7U9Bchlv4NTYmmBIHlyCRciFEsxublDh/I4pnXmSSt1
	gMu+onw6HjfOP/8AXL+FXBf/biWFcA8eJnlMpdTGiaXOQYHCXXVzQf1fQ+J3WJvBCS28Iuo0+Bb
	i8bxCTDwG6KcwTAmdcSc=
X-Google-Smtp-Source: AGHT+IFLHFN9rxCqoijA4uedrenofflj7luyFp9CUDQXWNq5DjV8ZWge9xhKDm/5wVHFLL1LrIgcAA==
X-Received: by 2002:a05:600c:35ca:b0:43b:ca8c:fca1 with SMTP id 5b1f17b1804b1-43c5a610dc3mr61655845e9.16.1741475430716;
        Sat, 08 Mar 2025 15:10:30 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c0e2f10sm10124731f8f.65.2025.03.08.15.10.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:10:30 -0800 (PST)
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
Subject: [PATCH v2 12/21] hw/vfio/igd: Check CONFIG_VFIO_IGD at runtime using vfio_igd_builtin()
Date: Sun,  9 Mar 2025 00:09:08 +0100
Message-ID: <20250308230917.18907-13-philmd@linaro.org>
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

Convert the compile time check on the CONFIG_VFIO_IGD definition
by a runtime one by calling vfio_igd_builtin(), which check
whether VFIO_IGD is built in a qemu-system binary.

Add stubs to avoid when VFIO_IGD is not built in:

  /usr/bin/ld: libqemu-x86_64-softmmu.a.p/hw_vfio_pci-quirks.c.o: in function `vfio_bar_quirk_setup':
  /usr/bin/ld: ../hw/vfio/pci-quirks.c:1216: undefined reference to `vfio_probe_igd_bar0_quirk'
  /usr/bin/ld: ../hw/vfio/pci-quirks.c:1217: undefined reference to `vfio_probe_igd_bar4_quirk'

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/vfio/pci-quirks.h |  6 ++++++
 hw/vfio/igd-stubs.c  | 20 ++++++++++++++++++++
 hw/vfio/pci-quirks.c |  9 ++++-----
 hw/vfio/meson.build  |  3 +++
 4 files changed, 33 insertions(+), 5 deletions(-)
 create mode 100644 hw/vfio/igd-stubs.c

diff --git a/hw/vfio/pci-quirks.h b/hw/vfio/pci-quirks.h
index fdaa81f00aa..dcdb1962600 100644
--- a/hw/vfio/pci-quirks.h
+++ b/hw/vfio/pci-quirks.h
@@ -13,6 +13,7 @@
 #define HW_VFIO_VFIO_PCI_QUIRKS_H
 
 #include "qemu/osdep.h"
+#include "qom/object.h"
 #include "exec/memop.h"
 
 /*
@@ -71,4 +72,9 @@ extern const MemoryRegionOps vfio_generic_mirror_quirk;
 
 #define TYPE_VFIO_PCI_IGD_LPC_BRIDGE "vfio-pci-igd-lpc-bridge"
 
+static inline bool vfio_igd_builtin(void)
+{
+    return type_is_registered(TYPE_VFIO_PCI_IGD_LPC_BRIDGE);
+}
+
 #endif /* HW_VFIO_VFIO_PCI_QUIRKS_H */
diff --git a/hw/vfio/igd-stubs.c b/hw/vfio/igd-stubs.c
new file mode 100644
index 00000000000..5d4e88aeb1b
--- /dev/null
+++ b/hw/vfio/igd-stubs.c
@@ -0,0 +1,20 @@
+/*
+ * IGD device quirk stubs
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ *
+ * Copyright (C) Linaro, Ltd.
+ */
+
+#include "qemu/osdep.h"
+#include "pci.h"
+
+void vfio_probe_igd_bar0_quirk(VFIOPCIDevice *vdev, int nr)
+{
+    g_assert_not_reached();
+}
+
+void vfio_probe_igd_bar4_quirk(VFIOPCIDevice *vdev, int nr)
+{
+    g_assert_not_reached();
+}
diff --git a/hw/vfio/pci-quirks.c b/hw/vfio/pci-quirks.c
index c53591fe2ba..22cb35af8cc 100644
--- a/hw/vfio/pci-quirks.c
+++ b/hw/vfio/pci-quirks.c
@@ -11,7 +11,6 @@
  */
 
 #include "qemu/osdep.h"
-#include CONFIG_DEVICES
 #include "exec/memop.h"
 #include "qemu/units.h"
 #include "qemu/log.h"
@@ -1213,10 +1212,10 @@ void vfio_bar_quirk_setup(VFIOPCIDevice *vdev, int nr)
     vfio_probe_nvidia_bar5_quirk(vdev, nr);
     vfio_probe_nvidia_bar0_quirk(vdev, nr);
     vfio_probe_rtl8168_bar2_quirk(vdev, nr);
-#ifdef CONFIG_VFIO_IGD
-    vfio_probe_igd_bar0_quirk(vdev, nr);
-    vfio_probe_igd_bar4_quirk(vdev, nr);
-#endif
+    if (vfio_igd_builtin()) {
+        vfio_probe_igd_bar0_quirk(vdev, nr);
+        vfio_probe_igd_bar4_quirk(vdev, nr);
+    }
 }
 
 void vfio_bar_quirk_exit(VFIOPCIDevice *vdev, int nr)
diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index a8939c83865..6ab711d0539 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -17,6 +17,9 @@ specific_ss.add_all(when: 'CONFIG_VFIO', if_true: vfio_ss)
 
 system_ss.add(when: 'CONFIG_VFIO_XGMAC', if_true: files('calxeda-xgmac.c'))
 system_ss.add(when: 'CONFIG_VFIO_AMD_XGBE', if_true: files('amd-xgbe.c'))
+system_ss.add(when: 'CONFIG_VFIO_IGD', if_false: files(
+  'igd-stubs.c',
+))
 system_ss.add(when: 'CONFIG_VFIO', if_true: files(
   'helpers.c',
   'container-base.c',
-- 
2.47.1


