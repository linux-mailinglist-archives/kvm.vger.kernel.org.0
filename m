Return-Path: <kvm+bounces-6448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FC9883203A
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 21:09:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACCDB1F24BC9
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 20:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59B832E64E;
	Thu, 18 Jan 2024 20:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XG3WB6nT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2A12E62A
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 20:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705608507; cv=none; b=CM7tBguEQoY288j9avwtP3i/zgRk48rE81e1RDlwVo3EF3y78HF9k4xXnZ3CFhH3mw37tE5uKQWEVuuWMz1AENFguJOVwd/Jd5Mww8e8EsqLbFa+vOhLfq2lzPCUAxWikSQG1Fmt2jUqJGi5gnRStlQ6F5eP+txcs2MwCUFzrxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705608507; c=relaxed/simple;
	bh=cyWEmKbASDp+MwizWdI58Vap+SzTTNFnMx8FE0e5XVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IIwiCWbBZJPDoeHWFb0GpnFAdVMiQkjVK9T20kiphikEiI78yXmelafm4mF2bnTeOMpL7H+WFYmdpXuL649kPmvmCWdkN0f6oIrnM0DD8IvpswqerBVq0ffc5J1326wb2QYmunSRUS6G2zwjIpWaR0mU6a6v9c9zkSuKQNBxD/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XG3WB6nT; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3376555b756so49865f8f.0
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 12:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705608504; x=1706213304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bhQHZsizpE+F9viHPJU7AjTKXKVu3rWT2XlrMgKdqws=;
        b=XG3WB6nTQHYNzEaUM7JqhXsDWz5zIsfeOACWyLptn7AJ84xio3MYDPMECGb4RXo+hG
         b/pBIo1jyXR/B9mvfZSxmk/OPnjM8TfotlfX8/tQBVyrC+L8mofy+EzKMmlhofpMIdcb
         Th1327B8JJK7t80rhFwTUCVmskFk/ki0NfoK8HKylbSKaIQcHQdzR4kAmayDgYiu40ap
         F0gFGm1xJqmguCP1UxfqtEbkK5YX8xfxAoxEdl/i4qRY0qqWYUfTWcsSstfU0pYo0O7A
         +0TgQ1/PY127pkHSAkhXvAPD1lRxWHhDAwuKaq1qqSrcIlh+b9HlefG9BiXE4TD3ic5K
         daIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705608504; x=1706213304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bhQHZsizpE+F9viHPJU7AjTKXKVu3rWT2XlrMgKdqws=;
        b=n7EypLnU/dw33l7RA80joU9UKahDg1j3IBmAZ6LFR4aBKV3NT21qUyKZDVQhDYI/LF
         F0VBsDTfP64T+w3y6VFBbNYZS3s0X9RKc0x8C71mTtMYaFbK0tMsdjrAY2N7OgsKEbPS
         ejgcdgNy3t8tepCp8MzK++0i7UBGsTKm46P8W9T1OWrC4c4ImPSNjYKktShqD0L+iWDX
         kAwq4FtilG4QkGYdM3cbJGkaf8q8i01q1AEFntZQXOjqvR+PDIXvzGJbP+AA9yiB1Ias
         29JxS7eTWLYuC594zkRXWEfvz5gIbkDYWuPDegn9CXd3vBHUzw4Vj80t1Ui6bKVAH73x
         lGbg==
X-Gm-Message-State: AOJu0Yw9UEjzk5CWcEH2tMnLralehji3wCAeSWZSmMz3x9PY/VkyZpHj
	DRrbn7tw92+Rc7ShbisnL9F8Dqg/4Td6RX+D/hdsm7FknXbJpPuEBHMKXYJ+oCs=
X-Google-Smtp-Source: AGHT+IGpA9ZCMV/amKfFf38wgEX4OHehoawCJv7bFOGtRQLi1xA35HufESPeb7/9CEh1UJLFc22mKw==
X-Received: by 2002:adf:fc8a:0:b0:337:d989:151b with SMTP id g10-20020adffc8a000000b00337d989151bmr187779wrr.23.1705608503940;
        Thu, 18 Jan 2024 12:08:23 -0800 (PST)
Received: from localhost.localdomain ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id g28-20020adfa49c000000b00336cbbf2e0fsm4779699wrb.27.2024.01.18.12.08.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jan 2024 12:08:23 -0800 (PST)
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
Subject: [PATCH 17/20] target/arm: Move ARM_CPU_IRQ/FIQ definitions to 'cpu-qom.h' header
Date: Thu, 18 Jan 2024 21:06:38 +0100
Message-ID: <20240118200643.29037-18-philmd@linaro.org>
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

The ARM_CPU_IRQ/FIQ definitions are used to index the GPIO
IRQ created calling qdev_init_gpio_in() in ARMCPU instance_init()
handler. To allow non-ARM code to raise interrupt on ARM cores,
move they to 'target/arm/cpu-qom.h' which is non-ARM specific and
can be included by any hw/ file.

File list to include the new header generated using:

  $ git grep -wEl 'ARM_CPU_(\w*IRQ|FIQ)'

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/cpu-qom.h    | 6 ++++++
 target/arm/cpu.h        | 6 ------
 hw/arm/allwinner-a10.c  | 1 +
 hw/arm/allwinner-h3.c   | 1 +
 hw/arm/allwinner-r40.c  | 1 +
 hw/arm/armv7m.c         | 1 +
 hw/arm/aspeed_ast2400.c | 1 +
 hw/arm/aspeed_ast2600.c | 1 +
 hw/arm/bcm2836.c        | 1 +
 hw/arm/exynos4210.c     | 1 +
 hw/arm/fsl-imx25.c      | 1 +
 hw/arm/fsl-imx31.c      | 1 +
 hw/arm/fsl-imx6.c       | 1 +
 hw/arm/fsl-imx6ul.c     | 1 +
 hw/arm/fsl-imx7.c       | 1 +
 hw/arm/highbank.c       | 1 +
 hw/arm/integratorcp.c   | 1 +
 hw/arm/musicpal.c       | 1 +
 hw/arm/npcm7xx.c        | 1 +
 hw/arm/omap1.c          | 1 +
 hw/arm/omap2.c          | 1 +
 hw/arm/realview.c       | 1 +
 hw/arm/sbsa-ref.c       | 1 +
 hw/arm/strongarm.c      | 1 +
 hw/arm/versatilepb.c    | 1 +
 hw/arm/vexpress.c       | 1 +
 hw/arm/virt.c           | 1 +
 hw/arm/xilinx_zynq.c    | 1 +
 hw/arm/xlnx-versal.c    | 1 +
 hw/arm/xlnx-zynqmp.c    | 1 +
 target/arm/cpu.c        | 1 +
 31 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/target/arm/cpu-qom.h b/target/arm/cpu-qom.h
index 77bbc1f13c..8e032691db 100644
--- a/target/arm/cpu-qom.h
+++ b/target/arm/cpu-qom.h
@@ -36,6 +36,12 @@ DECLARE_CLASS_CHECKERS(AArch64CPUClass, AARCH64_CPU,
 #define ARM_CPU_TYPE_SUFFIX "-" TYPE_ARM_CPU
 #define ARM_CPU_TYPE_NAME(name) (name ARM_CPU_TYPE_SUFFIX)
 
+/* Meanings of the ARMCPU object's four inbound GPIO lines */
+#define ARM_CPU_IRQ 0
+#define ARM_CPU_FIQ 1
+#define ARM_CPU_VIRQ 2
+#define ARM_CPU_VFIQ 3
+
 /* For M profile, some registers are banked secure vs non-secure;
  * these are represented as a 2-element array where the first element
  * is the non-secure copy and the second is the secure copy.
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index d6a79482ad..e8df41d642 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -93,12 +93,6 @@
 #define offsetofhigh32(S, M) (offsetof(S, M) + sizeof(uint32_t))
 #endif
 
-/* Meanings of the ARMCPU object's four inbound GPIO lines */
-#define ARM_CPU_IRQ 0
-#define ARM_CPU_FIQ 1
-#define ARM_CPU_VIRQ 2
-#define ARM_CPU_VFIQ 3
-
 /* ARM-specific extra insn start words:
  * 1: Conditional execution bits
  * 2: Partial exception syndrome for data aborts
diff --git a/hw/arm/allwinner-a10.c b/hw/arm/allwinner-a10.c
index b0ea3f7f66..7e2ae7a15f 100644
--- a/hw/arm/allwinner-a10.c
+++ b/hw/arm/allwinner-a10.c
@@ -26,6 +26,7 @@
 #include "hw/boards.h"
 #include "hw/usb/hcd-ohci.h"
 #include "hw/loader.h"
+#include "target/arm/cpu-qom.h"
 
 #define AW_A10_SRAM_A_BASE      0x00000000
 #define AW_A10_DRAMC_BASE       0x01c01000
diff --git a/hw/arm/allwinner-h3.c b/hw/arm/allwinner-h3.c
index f05afddf7e..2d684b5287 100644
--- a/hw/arm/allwinner-h3.c
+++ b/hw/arm/allwinner-h3.c
@@ -30,6 +30,7 @@
 #include "hw/loader.h"
 #include "sysemu/sysemu.h"
 #include "hw/arm/allwinner-h3.h"
+#include "target/arm/cpu-qom.h"
 
 /* Memory map */
 const hwaddr allwinner_h3_memmap[] = {
diff --git a/hw/arm/allwinner-r40.c b/hw/arm/allwinner-r40.c
index a0d367c60d..65392dbc23 100644
--- a/hw/arm/allwinner-r40.c
+++ b/hw/arm/allwinner-r40.c
@@ -32,6 +32,7 @@
 #include "sysemu/sysemu.h"
 #include "hw/arm/allwinner-r40.h"
 #include "hw/misc/allwinner-r40-dramc.h"
+#include "target/arm/cpu-qom.h"
 
 /* Memory map */
 const hwaddr allwinner_r40_memmap[] = {
diff --git a/hw/arm/armv7m.c b/hw/arm/armv7m.c
index edcd8adc74..7c68525a9e 100644
--- a/hw/arm/armv7m.c
+++ b/hw/arm/armv7m.c
@@ -23,6 +23,7 @@
 #include "target/arm/idau.h"
 #include "target/arm/cpu.h"
 #include "target/arm/cpu-features.h"
+#include "target/arm/cpu-qom.h"
 #include "migration/vmstate.h"
 
 /* Bitbanded IO.  Each word corresponds to a single bit.  */
diff --git a/hw/arm/aspeed_ast2400.c b/hw/arm/aspeed_ast2400.c
index 0baa2ff96e..ad76035528 100644
--- a/hw/arm/aspeed_ast2400.c
+++ b/hw/arm/aspeed_ast2400.c
@@ -21,6 +21,7 @@
 #include "hw/i2c/aspeed_i2c.h"
 #include "net/net.h"
 #include "sysemu/sysemu.h"
+#include "target/arm/cpu-qom.h"
 
 #define ASPEED_SOC_IOMEM_SIZE       0x00200000
 
diff --git a/hw/arm/aspeed_ast2600.c b/hw/arm/aspeed_ast2600.c
index 3a9a303ab8..386a88d4e0 100644
--- a/hw/arm/aspeed_ast2600.c
+++ b/hw/arm/aspeed_ast2600.c
@@ -16,6 +16,7 @@
 #include "hw/i2c/aspeed_i2c.h"
 #include "net/net.h"
 #include "sysemu/sysemu.h"
+#include "target/arm/cpu-qom.h"
 
 #define ASPEED_SOC_IOMEM_SIZE       0x00200000
 #define ASPEED_SOC_DPMCU_SIZE       0x00040000
diff --git a/hw/arm/bcm2836.c b/hw/arm/bcm2836.c
index b0674a22a6..58a78780d2 100644
--- a/hw/arm/bcm2836.c
+++ b/hw/arm/bcm2836.c
@@ -15,6 +15,7 @@
 #include "hw/arm/bcm2836.h"
 #include "hw/arm/raspi_platform.h"
 #include "hw/sysbus.h"
+#include "target/arm/cpu-qom.h"
 
 struct BCM283XClass {
     /*< private >*/
diff --git a/hw/arm/exynos4210.c b/hw/arm/exynos4210.c
index af511a153d..6c428d8eeb 100644
--- a/hw/arm/exynos4210.c
+++ b/hw/arm/exynos4210.c
@@ -36,6 +36,7 @@
 #include "hw/arm/exynos4210.h"
 #include "hw/sd/sdhci.h"
 #include "hw/usb/hcd-ehci.h"
+#include "target/arm/cpu-qom.h"
 
 #define EXYNOS4210_CHIPID_ADDR         0x10000000
 
diff --git a/hw/arm/fsl-imx25.c b/hw/arm/fsl-imx25.c
index 9d2fb75a68..4a49507ef1 100644
--- a/hw/arm/fsl-imx25.c
+++ b/hw/arm/fsl-imx25.c
@@ -28,6 +28,7 @@
 #include "sysemu/sysemu.h"
 #include "hw/qdev-properties.h"
 #include "chardev/char.h"
+#include "target/arm/cpu-qom.h"
 
 #define IMX25_ESDHC_CAPABILITIES     0x07e20000
 
diff --git a/hw/arm/fsl-imx31.c b/hw/arm/fsl-imx31.c
index c0584e4dfc..4b8d9b8e4f 100644
--- a/hw/arm/fsl-imx31.c
+++ b/hw/arm/fsl-imx31.c
@@ -26,6 +26,7 @@
 #include "exec/address-spaces.h"
 #include "hw/qdev-properties.h"
 #include "chardev/char.h"
+#include "target/arm/cpu-qom.h"
 
 static void fsl_imx31_init(Object *obj)
 {
diff --git a/hw/arm/fsl-imx6.c b/hw/arm/fsl-imx6.c
index af2e982b05..42f9058825 100644
--- a/hw/arm/fsl-imx6.c
+++ b/hw/arm/fsl-imx6.c
@@ -29,6 +29,7 @@
 #include "chardev/char.h"
 #include "qemu/error-report.h"
 #include "qemu/module.h"
+#include "target/arm/cpu-qom.h"
 
 #define IMX6_ESDHC_CAPABILITIES     0x057834b4
 
diff --git a/hw/arm/fsl-imx6ul.c b/hw/arm/fsl-imx6ul.c
index e37b69a5e1..486a009deb 100644
--- a/hw/arm/fsl-imx6ul.c
+++ b/hw/arm/fsl-imx6ul.c
@@ -25,6 +25,7 @@
 #include "sysemu/sysemu.h"
 #include "qemu/error-report.h"
 #include "qemu/module.h"
+#include "target/arm/cpu-qom.h"
 
 #define NAME_SIZE 20
 
diff --git a/hw/arm/fsl-imx7.c b/hw/arm/fsl-imx7.c
index 474cfdc87c..5728109491 100644
--- a/hw/arm/fsl-imx7.c
+++ b/hw/arm/fsl-imx7.c
@@ -26,6 +26,7 @@
 #include "sysemu/sysemu.h"
 #include "qemu/error-report.h"
 #include "qemu/module.h"
+#include "target/arm/cpu-qom.h"
 
 #define NAME_SIZE 20
 
diff --git a/hw/arm/highbank.c b/hw/arm/highbank.c
index c21e18d08f..e6e27d69af 100644
--- a/hw/arm/highbank.c
+++ b/hw/arm/highbank.c
@@ -36,6 +36,7 @@
 #include "qemu/log.h"
 #include "qom/object.h"
 #include "cpu.h"
+#include "target/arm/cpu-qom.h"
 
 #define SMP_BOOT_ADDR           0x100
 #define SMP_BOOT_REG            0x40
diff --git a/hw/arm/integratorcp.c b/hw/arm/integratorcp.c
index 1830e1d785..5600616a4d 100644
--- a/hw/arm/integratorcp.c
+++ b/hw/arm/integratorcp.c
@@ -28,6 +28,7 @@
 #include "hw/sd/sd.h"
 #include "qom/object.h"
 #include "audio/audio.h"
+#include "target/arm/cpu-qom.h"
 
 #define TYPE_INTEGRATOR_CM "integrator_core"
 OBJECT_DECLARE_SIMPLE_TYPE(IntegratorCMState, INTEGRATOR_CM)
diff --git a/hw/arm/musicpal.c b/hw/arm/musicpal.c
index 3200c9f68a..d89824f600 100644
--- a/hw/arm/musicpal.c
+++ b/hw/arm/musicpal.c
@@ -39,6 +39,7 @@
 #include "hw/net/mv88w8618_eth.h"
 #include "audio/audio.h"
 #include "qemu/error-report.h"
+#include "target/arm/cpu-qom.h"
 
 #define MP_MISC_BASE            0x80002000
 #define MP_MISC_SIZE            0x00001000
diff --git a/hw/arm/npcm7xx.c b/hw/arm/npcm7xx.c
index 7fb0a233b2..e3243a520d 100644
--- a/hw/arm/npcm7xx.c
+++ b/hw/arm/npcm7xx.c
@@ -26,6 +26,7 @@
 #include "qapi/error.h"
 #include "qemu/units.h"
 #include "sysemu/sysemu.h"
+#include "target/arm/cpu-qom.h"
 
 /*
  * This covers the whole MMIO space. We'll use this to catch any MMIO accesses
diff --git a/hw/arm/omap1.c b/hw/arm/omap1.c
index d5438156ee..86ee336e59 100644
--- a/hw/arm/omap1.c
+++ b/hw/arm/omap1.c
@@ -40,6 +40,7 @@
 #include "hw/sysbus.h"
 #include "qemu/cutils.h"
 #include "qemu/bcd.h"
+#include "target/arm/cpu-qom.h"
 
 static inline void omap_log_badwidth(const char *funcname, hwaddr addr, int sz)
 {
diff --git a/hw/arm/omap2.c b/hw/arm/omap2.c
index f170728e7e..f159fb73ea 100644
--- a/hw/arm/omap2.c
+++ b/hw/arm/omap2.c
@@ -39,6 +39,7 @@
 #include "hw/sysbus.h"
 #include "hw/boards.h"
 #include "audio/audio.h"
+#include "target/arm/cpu-qom.h"
 
 /* Enhanced Audio Controller (CODEC only) */
 struct omap_eac_s {
diff --git a/hw/arm/realview.c b/hw/arm/realview.c
index 132217b2ed..566deff9ce 100644
--- a/hw/arm/realview.c
+++ b/hw/arm/realview.c
@@ -30,6 +30,7 @@
 #include "hw/i2c/arm_sbcon_i2c.h"
 #include "hw/sd/sd.h"
 #include "audio/audio.h"
+#include "target/arm/cpu-qom.h"
 
 #define SMP_BOOT_ADDR 0xe0000000
 #define SMP_BOOTREG_ADDR 0x10000030
diff --git a/hw/arm/sbsa-ref.c b/hw/arm/sbsa-ref.c
index b8857d1e9e..d6081bfc41 100644
--- a/hw/arm/sbsa-ref.c
+++ b/hw/arm/sbsa-ref.c
@@ -50,6 +50,7 @@
 #include "net/net.h"
 #include "qapi/qmp/qlist.h"
 #include "qom/object.h"
+#include "target/arm/cpu-qom.h"
 
 #define RAMLIMIT_GB 8192
 #define RAMLIMIT_BYTES (RAMLIMIT_GB * GiB)
diff --git a/hw/arm/strongarm.c b/hw/arm/strongarm.c
index fef3638aca..75637869cb 100644
--- a/hw/arm/strongarm.c
+++ b/hw/arm/strongarm.c
@@ -46,6 +46,7 @@
 #include "qemu/cutils.h"
 #include "qemu/log.h"
 #include "qom/object.h"
+#include "target/arm/cpu-qom.h"
 
 //#define DEBUG
 
diff --git a/hw/arm/versatilepb.c b/hw/arm/versatilepb.c
index 4b2257787b..15b5ed0ced 100644
--- a/hw/arm/versatilepb.c
+++ b/hw/arm/versatilepb.c
@@ -27,6 +27,7 @@
 #include "hw/sd/sd.h"
 #include "qom/object.h"
 #include "audio/audio.h"
+#include "target/arm/cpu-qom.h"
 
 #define VERSATILE_FLASH_ADDR 0x34000000
 #define VERSATILE_FLASH_SIZE (64 * 1024 * 1024)
diff --git a/hw/arm/vexpress.c b/hw/arm/vexpress.c
index fd981f4c33..49dbcdcbf0 100644
--- a/hw/arm/vexpress.c
+++ b/hw/arm/vexpress.c
@@ -46,6 +46,7 @@
 #include "qapi/qmp/qlist.h"
 #include "qom/object.h"
 #include "audio/audio.h"
+#include "target/arm/cpu-qom.h"
 
 #define VEXPRESS_BOARD_ID 0x8e0
 #define VEXPRESS_FLASH_SIZE (64 * 1024 * 1024)
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index beba151620..0ab5fd9477 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -73,6 +73,7 @@
 #include "standard-headers/linux/input.h"
 #include "hw/arm/smmuv3.h"
 #include "hw/acpi/acpi.h"
+#include "target/arm/cpu-qom.h"
 #include "target/arm/internals.h"
 #include "target/arm/multiprocessing.h"
 #include "hw/mem/pc-dimm.h"
diff --git a/hw/arm/xilinx_zynq.c b/hw/arm/xilinx_zynq.c
index d4c817ecdc..5809fc32af 100644
--- a/hw/arm/xilinx_zynq.c
+++ b/hw/arm/xilinx_zynq.c
@@ -38,6 +38,7 @@
 #include "sysemu/reset.h"
 #include "qom/object.h"
 #include "exec/tswap.h"
+#include "target/arm/cpu-qom.h"
 
 #define TYPE_ZYNQ_MACHINE MACHINE_TYPE_NAME("xilinx-zynq-a9")
 OBJECT_DECLARE_SIMPLE_TYPE(ZynqMachineState, ZYNQ_MACHINE)
diff --git a/hw/arm/xlnx-versal.c b/hw/arm/xlnx-versal.c
index 9600551c44..87fdb39d43 100644
--- a/hw/arm/xlnx-versal.c
+++ b/hw/arm/xlnx-versal.c
@@ -23,6 +23,7 @@
 #include "hw/misc/unimp.h"
 #include "hw/arm/xlnx-versal.h"
 #include "qemu/log.h"
+#include "target/arm/cpu-qom.h"
 
 #define XLNX_VERSAL_ACPU_TYPE ARM_CPU_TYPE_NAME("cortex-a72")
 #define XLNX_VERSAL_RCPU_TYPE ARM_CPU_TYPE_NAME("cortex-r5f")
diff --git a/hw/arm/xlnx-zynqmp.c b/hw/arm/xlnx-zynqmp.c
index 5905a33015..38cb34942f 100644
--- a/hw/arm/xlnx-zynqmp.c
+++ b/hw/arm/xlnx-zynqmp.c
@@ -25,6 +25,7 @@
 #include "sysemu/kvm.h"
 #include "sysemu/sysemu.h"
 #include "kvm_arm.h"
+#include "target/arm/cpu-qom.h"
 
 #define GIC_NUM_SPI_INTR 160
 
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 89e44a31fd..07357daabe 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -48,6 +48,7 @@
 #include "disas/capstone.h"
 #include "fpu/softfloat.h"
 #include "cpregs.h"
+#include "target/arm/cpu-qom.h"
 
 static void arm_cpu_set_pc(CPUState *cs, vaddr value)
 {
-- 
2.41.0


