Return-Path: <kvm+bounces-6441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B153983202C
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 21:08:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60F5C28B769
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 20:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E7CB2E843;
	Thu, 18 Jan 2024 20:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ag0mp1nK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB99F2E826
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 20:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705608466; cv=none; b=NZBZS/ektaA8QXfFJ5SfNxJBswLZ0TM4Ic8e+zHjB/jHo6U7FzbGZ/yhIXeBXkw4ehsXV8QXNhgYkIZxqFC2BL7A7EARNpfWZtxiMtrbK1rJD+z9VOEhlNWjiX/XTcQNw2Gne0ZYv59sl7waJ7cCohPjOW5exdHjZ/7ppceeVZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705608466; c=relaxed/simple;
	bh=P35Szeh3Xj8gBxBeWbYbnrY26jukSIkzUJx/t1uU2Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jJ0NEsqYOZ4iLku4UeEzRZi/0bhxPwXDxGxUBmB9f+Y4uibL0/MlTYmC9nvTcsfuueqnnAE1/seVD5XxIjgfpML6fjdgFLfE7DjN7t0bc+3tC+fUJN511p8FuePaoPcSP4wUPYyFvwQSVABx097YMSe+DIAN/p+OrXDu+At+cC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ag0mp1nK; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-40e884ac5c8so247475e9.2
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 12:07:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705608463; x=1706213263; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6w1iFT2RaAu4CDh7Rs92padfv2CQrVGTqWTSowRX6NU=;
        b=ag0mp1nK4ggc3TSuZo/4qxhE10GI2x+hA4Y7ABgDq8+t+jLYRHOkVhYy4UMAeofF2G
         DQ8wu9j87eQ6AwHS+73zksmJf4UI4p0dDkY/lgArz/+/9kA3+8KUfFGassyERCmEAEhK
         jCDvzJLfI8ioEcqVMZer21k/J+h5lyv7eGd5yQlPt8WU2VN93hdeuOBdxIGE/mOGBIdF
         /IjYtwti3Fhb2LyA3KJCTyrEV7FWHOIh7Ir041vTviEJEUbVhbN1SUl0Cs0wfEr+FW/0
         awEogWWB/uaJf6e4y+pB1wv+xOt1QF4SsWUH1cxbKy0yCD/HHYtP9xxgj9C7cfdJlsJL
         ekVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705608463; x=1706213263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6w1iFT2RaAu4CDh7Rs92padfv2CQrVGTqWTSowRX6NU=;
        b=V3OXf+MeVLDeZebPQ3MBA1DBQDb+lpPWIofhKoCzNuKRmeAyqXB8GrMCJVLO7O6jqA
         hozPTXBLeGyXvG5+duWMMn4/JXgNtHisi3Hag7juheWcOWl9qYdGmpLh2Z+v+Y3S86T/
         +CERClloUVpAzmUTkDRoI4nmCbUaQNf7IyePmqE90URN06OgCob6BUJOD4wMesjHGd6i
         mOuKoyVtgI3Tj3iAU+IjdzGLkgyp96HVmJ8VDMLT+aKPbbXdmaz/21kRCy7M1jvr2JIe
         GU6nsUj/A5SyyxZbID3vORuVcDgcHvDa+EhXKxIYGzM56+8Vfc4vQgGIYxvCxfI0WcIj
         zyjw==
X-Gm-Message-State: AOJu0YwH0DwpVmKlFerhjNgWoxy9wdRyu9GG0NwlQhSOuGfk5//Ya6/+
	nB7EqP7N2kKTvT0SjsoIttyUkf/tEhWIcspB3JJPshFy/vpYFSJwzRzhX9XwShI=
X-Google-Smtp-Source: AGHT+IGQufmtnUbC5TaYe/skrc2byrkECD8RNfnBzhK5eV/iYB6W5CLJ7ZFQRf8tXYUyzihV/oaQjw==
X-Received: by 2002:a05:600c:331b:b0:40e:5f01:6209 with SMTP id q27-20020a05600c331b00b0040e5f016209mr464662wmp.37.1705608463223;
        Thu, 18 Jan 2024 12:07:43 -0800 (PST)
Received: from localhost.localdomain ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id je14-20020a05600c1f8e00b0040e3635ca65sm30698740wmb.2.2024.01.18.12.07.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jan 2024 12:07:42 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Igor Mitsyanko <i.mitsyanko@gmail.com>,
	qemu-arm@nongnu.org,
	Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Eric Auger <eric.auger@redhat.com>,
	Niek Linnenbank <nieklinnenbank@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jan Kiszka <jan.kiszka@web.de>,
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
	Alistair Francis <alistair@alistair23.me>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Andrey Smirnov <andrew.smirnov@gmail.com>,
	Rob Herring <robh@kernel.org>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Tyrone Ting <kfting@nuvoton.com>,
	Beniamino Galvani <b.galvani@gmail.com>,
	Alexander Graf <agraf@csgraf.de>,
	Leif Lindholm <quic_llindhol@quicinc.com>,
	Ani Sinha <anisinha@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Joel Stanley <joel@jms.id.au>,
	Hao Wu <wuhaotsh@google.com>,
	kvm@vger.kernel.org
Subject: [PATCH 10/20] target/arm: Expose arm_cpu_mp_affinity() in 'multiprocessing.h' header
Date: Thu, 18 Jan 2024 21:06:31 +0100
Message-ID: <20240118200643.29037-11-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240118200643.29037-1-philmd@linaro.org>
References: <20240118200643.29037-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Declare arm_cpu_mp_affinity() prototype in the new
 "target/arm/multiprocessing.h" header so units in
hw/arm/ can use it without having to include the huge
target-specific "cpu.h".

File list to include the new header generated using:

  $ git grep -lw arm_cpu_mp_affinity

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/cpu.h             |  6 +-----
 target/arm/multiprocessing.h | 16 ++++++++++++++++
 hw/arm/virt-acpi-build.c     |  1 +
 hw/arm/virt.c                |  1 +
 hw/arm/xlnx-versal-virt.c    |  1 +
 hw/misc/xlnx-versal-crl.c    |  1 +
 target/arm/arm-powerctl.c    |  1 +
 target/arm/cpu.c             |  5 +++++
 target/arm/hvf/hvf.c         |  1 +
 target/arm/tcg/psci.c        |  1 +
 10 files changed, 29 insertions(+), 5 deletions(-)
 create mode 100644 target/arm/multiprocessing.h

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index d1584bdb3b..cecac4c0a1 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -26,6 +26,7 @@
 #include "cpu-qom.h"
 #include "exec/cpu-defs.h"
 #include "qapi/qapi-types-common.h"
+#include "target/arm/multiprocessing.h"
 
 /* ARM processors have a weak memory model */
 #define TCG_GUEST_DEFAULT_MO      (0)
@@ -1173,11 +1174,6 @@ void arm_cpu_post_init(Object *obj);
 
 uint64_t arm_build_mp_affinity(int idx, uint8_t clustersz);
 
-static inline uint64_t arm_cpu_mp_affinity(ARMCPU *cpu)
-{
-    return cpu->mp_affinity;
-}
-
 #ifndef CONFIG_USER_ONLY
 extern const VMStateDescription vmstate_arm_cpu;
 
diff --git a/target/arm/multiprocessing.h b/target/arm/multiprocessing.h
new file mode 100644
index 0000000000..81715d345c
--- /dev/null
+++ b/target/arm/multiprocessing.h
@@ -0,0 +1,16 @@
+/*
+ * ARM multiprocessor CPU helpers
+ *
+ *  Copyright (c) 2003 Fabrice Bellard
+ *
+ * SPDX-License-Identifier: LGPL-2.1-or-later
+ */
+
+#ifndef TARGET_ARM_MULTIPROCESSING_H
+#define TARGET_ARM_MULTIPROCESSING_H
+
+#include "target/arm/cpu-qom.h"
+
+uint64_t arm_cpu_mp_affinity(ARMCPU *cpu);
+
+#endif
diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index 2127778c1e..43ccc60f43 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -59,6 +59,7 @@
 #include "hw/acpi/ghes.h"
 #include "hw/acpi/viot.h"
 #include "hw/virtio/virtio-acpi.h"
+#include "target/arm/multiprocessing.h"
 
 #define ARM_SPI_BASE 32
 
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 34cba9ebd8..beba151620 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -74,6 +74,7 @@
 #include "hw/arm/smmuv3.h"
 #include "hw/acpi/acpi.h"
 #include "target/arm/internals.h"
+#include "target/arm/multiprocessing.h"
 #include "hw/mem/pc-dimm.h"
 #include "hw/mem/nvdimm.h"
 #include "hw/acpi/generic_event_device.h"
diff --git a/hw/arm/xlnx-versal-virt.c b/hw/arm/xlnx-versal-virt.c
index 841ef69df6..29f4d2c2dc 100644
--- a/hw/arm/xlnx-versal-virt.c
+++ b/hw/arm/xlnx-versal-virt.c
@@ -20,6 +20,7 @@
 #include "hw/qdev-properties.h"
 #include "hw/arm/xlnx-versal.h"
 #include "hw/arm/boot.h"
+#include "target/arm/multiprocessing.h"
 #include "qom/object.h"
 
 #define TYPE_XLNX_VERSAL_VIRT_MACHINE MACHINE_TYPE_NAME("xlnx-versal-virt")
diff --git a/hw/misc/xlnx-versal-crl.c b/hw/misc/xlnx-versal-crl.c
index 9bfa9baa15..1f1762ef16 100644
--- a/hw/misc/xlnx-versal-crl.c
+++ b/hw/misc/xlnx-versal-crl.c
@@ -19,6 +19,7 @@
 #include "hw/resettable.h"
 
 #include "target/arm/arm-powerctl.h"
+#include "target/arm/multiprocessing.h"
 #include "hw/misc/xlnx-versal-crl.h"
 
 #ifndef XLNX_VERSAL_CRL_ERR_DEBUG
diff --git a/target/arm/arm-powerctl.c b/target/arm/arm-powerctl.c
index 6c86e90102..2b2055c6ac 100644
--- a/target/arm/arm-powerctl.c
+++ b/target/arm/arm-powerctl.c
@@ -16,6 +16,7 @@
 #include "qemu/log.h"
 #include "qemu/main-loop.h"
 #include "sysemu/tcg.h"
+#include "target/arm/multiprocessing.h"
 
 #ifndef DEBUG_ARM_POWERCTL
 #define DEBUG_ARM_POWERCTL 0
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 0bbba48faa..89e44a31fd 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1314,6 +1314,11 @@ uint64_t arm_build_mp_affinity(int idx, uint8_t clustersz)
     return (Aff1 << ARM_AFF1_SHIFT) | Aff0;
 }
 
+uint64_t arm_cpu_mp_affinity(ARMCPU *cpu)
+{
+    return cpu->mp_affinity;
+}
+
 static void arm_cpu_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 659401e12c..71a26db188 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -28,6 +28,7 @@
 #include "arm-powerctl.h"
 #include "target/arm/cpu.h"
 #include "target/arm/internals.h"
+#include "target/arm/multiprocessing.h"
 #include "trace/trace-target_arm_hvf.h"
 #include "migration/vmstate.h"
 
diff --git a/target/arm/tcg/psci.c b/target/arm/tcg/psci.c
index 50d4b23d26..51d2ca3d30 100644
--- a/target/arm/tcg/psci.c
+++ b/target/arm/tcg/psci.c
@@ -24,6 +24,7 @@
 #include "sysemu/runstate.h"
 #include "internals.h"
 #include "arm-powerctl.h"
+#include "target/arm/multiprocessing.h"
 
 bool arm_is_psci_call(ARMCPU *cpu, int excp_type)
 {
-- 
2.41.0


