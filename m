Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFBB6898BC
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 13:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbjBCMac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 07:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232931AbjBCMaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 07:30:30 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A50D59551
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 04:30:19 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id k16so3752412wms.2
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 04:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DFVM5yf3RC0F0r4hIUACjxl9Bc56AqSrY64YcziAOlI=;
        b=WkYp7AUY5S4qsaWdsL80LLFguqyrFFNyYUJps9BHyjFruiPGUpRMqJ7i4pnJavgPaU
         fK1ixoHm7vt0vpHuorrUEajuYGrIAJPpGAKHoT7jh4fer5F5xzIiMxrxZ/JhriIGj0mV
         TqgcW/dyNe2Ph2wikb27GHgLlVsowXFVlKaQX7nx3HuOCzH7p71pRi6UXvgIzqPdBqgS
         3ZFZitvrSX8KxNqRdkZaRMArfH2ovUidufbs4HXLqdIkLr67SGfo6CLAbaIygRWcPVHz
         ICT5jGueXn5bngKlH15zwSJyZRmcEID/QbuY4trdhOMiVSCm7Fn63ZpOud9ExM395ptl
         2MfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DFVM5yf3RC0F0r4hIUACjxl9Bc56AqSrY64YcziAOlI=;
        b=w5+gnxtnCxkZO1gyUTo8BJMNtFBh9UruMywzzPNIp0vb6vLKA5FfdCjFJDIFZqB8/j
         L4o2thWi6JyS7Mf7g2GADNss5VYqPbsA7CuJ4iKUvH17A6AMlR60HOYxHfAxWhGFFnkv
         O48lFQSeFtCWm1jaTm+T76DNP1TV2t/G+SfWwlnLWV2cVakgkK0d5xKmJuqm0rzF+0xM
         4mSMdAysbOkPMq0HW2tiD8o//s8GYamGGaqRYGC0SpPx381Pllpsz54mKlKI9f0BqvF/
         VosZ2yikeWYeMxZOdCn5zYpqa3ZSxpf0AnyGXl8mtnqwIHqeMd+0LsgzLScDVAQqvUGA
         1nmg==
X-Gm-Message-State: AO0yUKXWbkwYgraYql23l3X0HtKOksnGpdzhySUfTkYa8axQQTeRz+ZU
        QZxa9Gcyd4OnehXESLq222c3DA==
X-Google-Smtp-Source: AK7set+X/KzDT6kbBUF6aq2UjmpXxGdrSmJLjfxcCkoknSvyy+TiQ039+kpC0jGyv+DYxNreDck5qQ==
X-Received: by 2002:a05:600c:3491:b0:3dc:46f6:e5fd with SMTP id a17-20020a05600c349100b003dc46f6e5fdmr9076751wmq.7.1675427418677;
        Fri, 03 Feb 2023 04:30:18 -0800 (PST)
Received: from localhost.localdomain (cpc98982-watf12-2-0-cust57.15-2.cable.virginm.net. [82.26.13.58])
        by smtp.gmail.com with ESMTPSA id w14-20020a05600c474e00b003dfe57f6f61sm2163146wmo.33.2023.02.03.04.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 04:30:18 -0800 (PST)
From:   Rajnesh Kanwal <rkanwal@rivosinc.com>
To:     apatel@ventanamicro.com, atishp@rivosinc.com,
        andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org
Cc:     Rajnesh Kanwal <rkanwal@rivosinc.com>
Subject: [PATCH v4 kvmtool 1/1] riscv: Move serial and rtc from IO port space to MMIO area.
Date:   Fri,  3 Feb 2023 12:29:34 +0000
Message-Id: <20230203122934.18714-1-rkanwal@rivosinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The default serial and rtc IO region overlaps with PCI IO bar
region leading bar 0 activation to fail. Moving these devices
to MMIO region similar to ARM.

Given serial has been moved from 0x3f8 to 0x10000000, this
requires us to now pass earlycon=uart8250,mmio,0x10000000
from cmdline rather than earlycon=uart8250,mmio,0x3f8.

To avoid the need to change the address every time the tool
is updated, we can also just pass "earlycon" from cmdline
and guest then finds the type and base address by following
the Device Tree's stdout-path property.

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
Tested-by: Atish Patra <atishp@rivosinc.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
v4: Incorporated feedback from Alexandru Elisei. Mainly rebased the
    change on main with the IRQ changes which haven't landed yet. Also
    a fix in KVM_VIRTIO_MMIO_AREA macro.

v3: https://lore.kernel.org/all/20230202191301.588804-1-rkanwal@rivosinc.com/
    Incorporated feedback from Andre Przywara and Alexandru Elisei.
      Mainly updated the commit message to specify that we can simply pass
      just "earlycon" from cmdline and avoid the need to specify uart address.
    Also added Tested-by and Reviewed-by tags by Atish Patra.

v2: https://lore.kernel.org/all/20230201160137.486622-1-rkanwal@rivosinc.com/
    Added further details in the commit message regarding the
    UART address change required in kernel cmdline parameter.

v1: https://lore.kernel.org/all/20230124155251.1417682-1-rkanwal@rivosinc.com/

 hw/rtc.c                     | 3 +++
 hw/serial.c                  | 4 ++++
 riscv/include/kvm/kvm-arch.h | 8 +++++++-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/hw/rtc.c b/hw/rtc.c
index 9b8785a..da696e1 100644
--- a/hw/rtc.c
+++ b/hw/rtc.c
@@ -9,6 +9,9 @@
 #if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
 #define RTC_BUS_TYPE		DEVICE_BUS_MMIO
 #define RTC_BASE_ADDRESS	ARM_RTC_MMIO_BASE
+#elif defined(CONFIG_RISCV)
+#define RTC_BUS_TYPE		DEVICE_BUS_MMIO
+#define RTC_BASE_ADDRESS	RISCV_RTC_MMIO_BASE
 #else
 /* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
 #define RTC_BUS_TYPE		DEVICE_BUS_IOPORT
diff --git a/hw/serial.c b/hw/serial.c
index 3d53362..b6263a0 100644
--- a/hw/serial.c
+++ b/hw/serial.c
@@ -17,6 +17,10 @@
 #define serial_iobase(nr)	(ARM_UART_MMIO_BASE + (nr) * 0x1000)
 #define serial_irq(nr)		(32 + (nr))
 #define SERIAL8250_BUS_TYPE	DEVICE_BUS_MMIO
+#elif defined(CONFIG_RISCV)
+#define serial_iobase(nr)	(RISCV_UART_MMIO_BASE + (nr) * 0x1000)
+#define serial_irq(nr)		(1 + (nr))
+#define SERIAL8250_BUS_TYPE	DEVICE_BUS_MMIO
 #else
 #define serial_iobase_0		(KVM_IOPORT_AREA + 0x3f8)
 #define serial_iobase_1		(KVM_IOPORT_AREA + 0x2f8)
diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index 2cf41c5..3e7dd3e 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -35,10 +35,16 @@
 #define RISCV_MAX_MEMORY(kvm)	RISCV_LOMAP_MAX_MEMORY
 #endif
 
+#define RISCV_UART_MMIO_BASE	RISCV_MMIO
+#define RISCV_UART_MMIO_SIZE	0x10000
+
+#define RISCV_RTC_MMIO_BASE	(RISCV_UART_MMIO_BASE + RISCV_UART_MMIO_SIZE)
+#define RISCV_RTC_MMIO_SIZE	0x10000
+
 #define KVM_IOPORT_AREA		RISCV_IOPORT
 #define KVM_PCI_CFG_AREA	RISCV_PCI
 #define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + RISCV_PCI_CFG_SIZE)
-#define KVM_VIRTIO_MMIO_AREA	RISCV_MMIO
+#define KVM_VIRTIO_MMIO_AREA	(RISCV_RTC_MMIO_BASE + RISCV_RTC_MMIO_SIZE)
 
 #define KVM_IOEVENTFD_HAS_PIO	0
 
-- 
2.25.1

