Return-Path: <kvm+bounces-6450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE9E583203C
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 21:09:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F2551C24E90
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 20:09:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C572E831;
	Thu, 18 Jan 2024 20:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fYsvK+a+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D34D2E829
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 20:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705608519; cv=none; b=I3JwtgAboRIlLXbVVCcsJnG0JX+yR7N0Rfhf+lcatvW8OiAIwHxRa4R7v0hX+IRIv9AtM1qSAf/zukYWoYOp2lwsRLSsKMkf3B49E75lBI3ro7gEywQqne3DEVMzboNz4cpJxRPs16+puuZNPdLnnXY2XHWwrQJ4ZD+77yB0oRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705608519; c=relaxed/simple;
	bh=2EdEVlsmM1XvKPumUL/+1JsEhlPAaEBk30m3ru3yaFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rYn/Ec+wtExES6CwMQyK1YyTRsb0eAmWSt8VDRx3KPkpzplxl0/kV4Apyl7DWd5f0j2rBbdOb8cE3a+IIUo76dZjVp4wkdwWautHE3I7xwWT7Mdfylds0TAx1JcpyeXOLA79bH2ww9E93LZ+sdfV2ySh2PSM6xSp1tkEX2MVsZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fYsvK+a+; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3376555b756so49947f8f.0
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 12:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705608516; x=1706213316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MFamDoDB+NPTBY+FXQ/CqwTtVqrO47PjF46IOrgJo58=;
        b=fYsvK+a+xIQ2+uCm7n5QE4i8PILRlC4y2fr4MpLW1zJnu64oYLAZEGfjdHPc/17d6T
         4c4SURVElcmpaLjlb8B6Pny5q04YmQEecb6KOaUhdCRE+Vp1Qs4EInumsuv5Im34l0F6
         HvmZEzs4PkpQnr+khsdj3HxJGZSJ9juiUnwezDfeN+rZaAcBp28CQWjS1mrukW1jnk9O
         G3SGRIdkLv2H3n64GqG27dAeGTdpV+JT9/Cqr/JFzJHsgt2YhC/uJPJ3a3V+jq1rHmja
         slsC4jKGwUiKKSpifoAAbm+eUThpLx77nv9n49KtQkdc+nFWhcefnxWXhg+wzuHrabH6
         l89A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705608516; x=1706213316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MFamDoDB+NPTBY+FXQ/CqwTtVqrO47PjF46IOrgJo58=;
        b=lxzIHsKiWQyxRl061nsOpfquQf+Cu3T641MgFK6sk3jfQ/XgH2gBDTRu4WEQODIrrU
         dUhEdMxeeFPej/kkLkbgTTGZBZhOf2GVfGW+BfGeDwZFYH7/2fAt0JGkoRyznX7EIkds
         BB+rSv9XfeESXZoyS3kOCU6I5n2kjYXm5CDPYkwFZ8EEtj14MDsWz9XY3PGn3af/jb2l
         RKFQhedOuuo6m2s1aKzsdpWM7Mrp/GF323NujntU59/spuB0zHQz7zzVcVpYn0khLLAF
         GRWboXCC0JO9sCNF+RPywOiHoWxlvQ9VetStD6lAnJU5mVSAzVAua6Yg+VQv9H+N703I
         P18Q==
X-Gm-Message-State: AOJu0YzscHhBLTzttRV5t+GvCatsw4xdgRO9I83wP9LZH0ggMiOFUbPP
	97iH5YjB+b33aV8N4Dlv/4ENhd3URWbGJVSEMh9QIE6UyKY/gEjrmZjDuvC87o8=
X-Google-Smtp-Source: AGHT+IHYOiJSym2D2yYrltSEDp/Akd8MvzHd3DpgP3oiybk3/olKKAnKTXjU/wbLiQn1O5KNopUAhQ==
X-Received: by 2002:adf:8b9e:0:b0:337:bea4:49a9 with SMTP id o30-20020adf8b9e000000b00337bea449a9mr1473271wra.11.1705608515800;
        Thu, 18 Jan 2024 12:08:35 -0800 (PST)
Received: from localhost.localdomain ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id p13-20020adf9d8d000000b00337bcae5eb1sm4765640wre.72.2024.01.18.12.08.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jan 2024 12:08:35 -0800 (PST)
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
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH 19/20] target/arm: Move GTimer definitions to new 'gtimer.h' header
Date: Thu, 18 Jan 2024 21:06:40 +0100
Message-ID: <20240118200643.29037-20-philmd@linaro.org>
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

Move Arm A-class Generic Timer definitions to the new
"target/arm/gtimer.h" header so units in hw/ which don't
need access to ARMCPU internals can use them without
having to include the huge "cpu.h".

Suggested-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/cpu.h       |  8 +-------
 target/arm/gtimer.h    | 21 +++++++++++++++++++++
 hw/arm/allwinner-h3.c  |  1 +
 hw/arm/allwinner-r40.c |  1 +
 hw/arm/bcm2836.c       |  1 +
 hw/arm/sbsa-ref.c      |  1 +
 hw/arm/virt.c          |  1 +
 hw/arm/xlnx-versal.c   |  1 +
 hw/arm/xlnx-zynqmp.c   |  1 +
 hw/cpu/a15mpcore.c     |  1 +
 target/arm/cpu.c       |  1 +
 target/arm/helper.c    |  1 +
 target/arm/hvf/hvf.c   |  1 +
 target/arm/kvm.c       |  1 +
 target/arm/machine.c   |  1 +
 15 files changed, 35 insertions(+), 7 deletions(-)
 create mode 100644 target/arm/gtimer.h

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index e8df41d642..d3477b1601 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -27,6 +27,7 @@
 #include "exec/cpu-defs.h"
 #include "qapi/qapi-types-common.h"
 #include "target/arm/multiprocessing.h"
+#include "target/arm/gtimer.h"
 
 /* ARM processors have a weak memory model */
 #define TCG_GUEST_DEFAULT_MO      (0)
@@ -140,13 +141,6 @@ typedef struct ARMGenericTimer {
     uint64_t ctl; /* Timer Control register */
 } ARMGenericTimer;
 
-#define GTIMER_PHYS     0
-#define GTIMER_VIRT     1
-#define GTIMER_HYP      2
-#define GTIMER_SEC      3
-#define GTIMER_HYPVIRT  4
-#define NUM_GTIMERS     5
-
 #define VTCR_NSW (1u << 29)
 #define VTCR_NSA (1u << 30)
 #define VSTCR_SW VTCR_NSW
diff --git a/target/arm/gtimer.h b/target/arm/gtimer.h
new file mode 100644
index 0000000000..b992941bef
--- /dev/null
+++ b/target/arm/gtimer.h
@@ -0,0 +1,21 @@
+/*
+ * ARM generic timer definitions for Arm A-class CPU
+ *
+ *  Copyright (c) 2003 Fabrice Bellard
+ *
+ * SPDX-License-Identifier: LGPL-2.1-or-later
+ */
+
+#ifndef TARGET_ARM_GTIMER_H
+#define TARGET_ARM_GTIMER_H
+
+enum {
+    GTIMER_PHYS     = 0,
+    GTIMER_VIRT     = 1,
+    GTIMER_HYP      = 2,
+    GTIMER_SEC      = 3,
+    GTIMER_HYPVIRT  = 4,
+#define NUM_GTIMERS   5
+};
+
+#endif
diff --git a/hw/arm/allwinner-h3.c b/hw/arm/allwinner-h3.c
index 2d684b5287..380e0ec11d 100644
--- a/hw/arm/allwinner-h3.c
+++ b/hw/arm/allwinner-h3.c
@@ -31,6 +31,7 @@
 #include "sysemu/sysemu.h"
 #include "hw/arm/allwinner-h3.h"
 #include "target/arm/cpu-qom.h"
+#include "target/arm/gtimer.h"
 
 /* Memory map */
 const hwaddr allwinner_h3_memmap[] = {
diff --git a/hw/arm/allwinner-r40.c b/hw/arm/allwinner-r40.c
index 65392dbc23..898bef9d93 100644
--- a/hw/arm/allwinner-r40.c
+++ b/hw/arm/allwinner-r40.c
@@ -33,6 +33,7 @@
 #include "hw/arm/allwinner-r40.h"
 #include "hw/misc/allwinner-r40-dramc.h"
 #include "target/arm/cpu-qom.h"
+#include "target/arm/gtimer.h"
 
 /* Memory map */
 const hwaddr allwinner_r40_memmap[] = {
diff --git a/hw/arm/bcm2836.c b/hw/arm/bcm2836.c
index 58a78780d2..e3ba18a8ec 100644
--- a/hw/arm/bcm2836.c
+++ b/hw/arm/bcm2836.c
@@ -16,6 +16,7 @@
 #include "hw/arm/raspi_platform.h"
 #include "hw/sysbus.h"
 #include "target/arm/cpu-qom.h"
+#include "target/arm/gtimer.h"
 
 struct BCM283XClass {
     /*< private >*/
diff --git a/hw/arm/sbsa-ref.c b/hw/arm/sbsa-ref.c
index d6081bfc41..85cb68d546 100644
--- a/hw/arm/sbsa-ref.c
+++ b/hw/arm/sbsa-ref.c
@@ -51,6 +51,7 @@
 #include "qapi/qmp/qlist.h"
 #include "qom/object.h"
 #include "target/arm/cpu-qom.h"
+#include "target/arm/gtimer.h"
 
 #define RAMLIMIT_GB 8192
 #define RAMLIMIT_BYTES (RAMLIMIT_GB * GiB)
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 0ab5fd9477..bdfcf028a0 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -76,6 +76,7 @@
 #include "target/arm/cpu-qom.h"
 #include "target/arm/internals.h"
 #include "target/arm/multiprocessing.h"
+#include "target/arm/gtimer.h"
 #include "hw/mem/pc-dimm.h"
 #include "hw/mem/nvdimm.h"
 #include "hw/acpi/generic_event_device.h"
diff --git a/hw/arm/xlnx-versal.c b/hw/arm/xlnx-versal.c
index 87fdb39d43..2798df3730 100644
--- a/hw/arm/xlnx-versal.c
+++ b/hw/arm/xlnx-versal.c
@@ -24,6 +24,7 @@
 #include "hw/arm/xlnx-versal.h"
 #include "qemu/log.h"
 #include "target/arm/cpu-qom.h"
+#include "target/arm/gtimer.h"
 
 #define XLNX_VERSAL_ACPU_TYPE ARM_CPU_TYPE_NAME("cortex-a72")
 #define XLNX_VERSAL_RCPU_TYPE ARM_CPU_TYPE_NAME("cortex-r5f")
diff --git a/hw/arm/xlnx-zynqmp.c b/hw/arm/xlnx-zynqmp.c
index 38cb34942f..65901c6e74 100644
--- a/hw/arm/xlnx-zynqmp.c
+++ b/hw/arm/xlnx-zynqmp.c
@@ -26,6 +26,7 @@
 #include "sysemu/sysemu.h"
 #include "kvm_arm.h"
 #include "target/arm/cpu-qom.h"
+#include "target/arm/gtimer.h"
 
 #define GIC_NUM_SPI_INTR 160
 
diff --git a/hw/cpu/a15mpcore.c b/hw/cpu/a15mpcore.c
index bfd8aa5644..967d8d3dd5 100644
--- a/hw/cpu/a15mpcore.c
+++ b/hw/cpu/a15mpcore.c
@@ -26,6 +26,7 @@
 #include "hw/qdev-properties.h"
 #include "sysemu/kvm.h"
 #include "kvm_arm.h"
+#include "target/arm/gtimer.h"
 
 static void a15mp_priv_set_irq(void *opaque, int irq, int level)
 {
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 07357daabe..4c57b9c3b8 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -49,6 +49,7 @@
 #include "fpu/softfloat.h"
 #include "cpregs.h"
 #include "target/arm/cpu-qom.h"
+#include "target/arm/gtimer.h"
 
 static void arm_cpu_set_pc(CPUState *cs, vaddr value)
 {
diff --git a/target/arm/helper.c b/target/arm/helper.c
index 1ef00e50e4..39e2ba25c8 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -30,6 +30,7 @@
 #include "semihosting/common-semi.h"
 #endif
 #include "cpregs.h"
+#include "target/arm/gtimer.h"
 
 #define ARM_CPU_FREQ 1000000000 /* FIXME: 1 GHz, should be configurable */
 
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 71a26db188..e5f0f60093 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -29,6 +29,7 @@
 #include "target/arm/cpu.h"
 #include "target/arm/internals.h"
 #include "target/arm/multiprocessing.h"
+#include "target/arm/gtimer.h"
 #include "trace/trace-target_arm_hvf.h"
 #include "migration/vmstate.h"
 
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 8f52b211f9..81813030a5 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -38,6 +38,7 @@
 #include "qemu/log.h"
 #include "hw/acpi/acpi.h"
 #include "hw/acpi/ghes.h"
+#include "target/arm/gtimer.h"
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_LAST_INFO
diff --git a/target/arm/machine.c b/target/arm/machine.c
index 542be14bec..9d7dbaea54 100644
--- a/target/arm/machine.c
+++ b/target/arm/machine.c
@@ -7,6 +7,7 @@
 #include "internals.h"
 #include "cpu-features.h"
 #include "migration/cpu.h"
+#include "target/arm/gtimer.h"
 
 static bool vfp_needed(void *opaque)
 {
-- 
2.41.0


