Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11FD8686B0A
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 17:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbjBAQBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 11:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjBAQBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 11:01:43 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9538A172A
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 08:01:41 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id k16so13049539wms.2
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 08:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UZGXYo6Hb//GlofZ6WFKHrH1J3nsT5CMzcUtMxhbcks=;
        b=YzI4LcCrAUlFI2WVLkfAAO3w0cqC/JnAUk6ZHp5TWxIMO7NOQJA2DxJieK90q0VxMx
         TtrYGN8nlKI+MlMEQakzQsykNjTa2DaAXJenrE/jTIDfnO22p3hiCIST8FckKnyd3pMy
         95gqDj193CG0DCwPQ09jerTa7pRiOd67qci+p/vknTC6I8xA90mhFwjFdDdJVVLsflwP
         bH+bhq7UfhaCXG7M0XqoXxZavBSgWxgn3wvKt3xBQsV41w1LCpILebpntXFm3KT4VAoC
         RbGRGhfEZFecG9WZsw/ZE9QkRdoQmvIPpa/Z6gpCiSY2ctHf5eIc+uf3DLocSXYe6KhG
         KOPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UZGXYo6Hb//GlofZ6WFKHrH1J3nsT5CMzcUtMxhbcks=;
        b=lClxoPe1YM+Fu5ZSLQczOaLGgYmjqmY3dX5ZTwcm+KrRjb9lzXQ9D4YlCKYNAdpcIF
         33WhRP1Fgk9nI5Q8Yo0clxnGXgkRamFd0OkK5mTe6m2NYvhXNh+TPfT2SHFr6C6AuiSp
         hEM+lQAwunU6HHgzNLQnJHfKyA2AiLzNL7NpvCjGp0SrmsYeEmVhQHX0TXXhX3jNrgZA
         V9ZR4R9GEwRhDrwQQiMzU3rjaPeSNI2HRzx3DRth2RxknLZpy1/saamPRZ1ZiVpKMIbv
         XbEEgXxkPCOrEunmyvsSpanxMDJ1B7iyv673CZgHGoM/6NVg4GAMei0hU+CIRxdkrZQX
         QNaw==
X-Gm-Message-State: AO0yUKVWXVrLgURmN3AF7YVdk1GOCz2/X5zZIbH4g28bGK1Cfbo+t8Ks
        U6MzIgqWlj4Vw/Jv3eULfnbNLw==
X-Google-Smtp-Source: AK7set8kMo7u0BHXjGxH/opLPRj8xtEoXfT5jmxgsZycs9MI4m3MWBo+fcmjgov+sffM5RzdEwS65w==
X-Received: by 2002:a05:600c:4e4e:b0:3dd:e621:d328 with SMTP id e14-20020a05600c4e4e00b003dde621d328mr2889757wmq.8.1675267300215;
        Wed, 01 Feb 2023 08:01:40 -0800 (PST)
Received: from localhost.localdomain (cpc98982-watf12-2-0-cust57.15-2.cable.virginm.net. [82.26.13.58])
        by smtp.gmail.com with ESMTPSA id l41-20020a05600c08a900b003df245cd853sm1088278wmp.44.2023.02.01.08.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 08:01:39 -0800 (PST)
From:   Rajnesh Kanwal <rkanwal@rivosinc.com>
To:     apatel@ventanamicro.com, atishp@rivosinc.com,
        andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org
Cc:     Rajnesh Kanwal <rkanwal@rivosinc.com>
Subject: [PATCH v2 kvmtool] riscv: Move serial and rtc from IO port space to MMIO area.
Date:   Wed,  1 Feb 2023 16:01:37 +0000
Message-Id: <20230201160137.486622-1-rkanwal@rivosinc.com>
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

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
---
v2: Added further details in the commit message regarding the
    UART address change required in kernel cmdline parameter.

v1: https://www.spinics.net/lists/kvm/msg301835.html

 hw/rtc.c                     |  3 +++
 hw/serial.c                  |  4 ++++
 riscv/include/kvm/kvm-arch.h | 10 ++++++++--
 3 files changed, 15 insertions(+), 2 deletions(-)

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
index 3f96d00..620c796 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -11,7 +11,7 @@
 #define RISCV_IOPORT		0x00000000ULL
 #define RISCV_IOPORT_SIZE	SZ_64K
 #define RISCV_IRQCHIP		0x08000000ULL
-#define RISCV_IRQCHIP_SIZE		SZ_128M
+#define RISCV_IRQCHIP_SIZE	SZ_128M
 #define RISCV_MMIO		0x10000000ULL
 #define RISCV_MMIO_SIZE		SZ_512M
 #define RISCV_PCI		0x30000000ULL
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
+#define KVM_VIRTIO_MMIO_AREA	(RISCV_RTC_MMIO_BASE + RISCV_UART_MMIO_SIZE)
 
 #define KVM_IOEVENTFD_HAS_PIO	0
 
-- 
2.25.1

