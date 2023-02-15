Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9CC69827F
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjBORoP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjBORoO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:44:14 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB6237F15
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:44:13 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id l2so3343035wry.0
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vz35UX4luoMUaqbzTcDDIbvcjgeBkxbh135cUjhEHMo=;
        b=yowuVGL7oMXH61gQZvS6cQqkgZm8BocUdDiMLffKX5wVEPHygVvBzk8k0YGLyjZ0NI
         bQlOVBLDdtlQRPbUP5QQAT6ldo1lLIHrMbFA3uT5qVxOGCeLADLn/cxXLDqql2CVYdmJ
         FqVGuQLxjAbAKvb4wAKxWcTCv31Ivp+ASPsR3Z0HZTzUuF+OjeJbg66Gy79h8HSaYVKx
         wfQd/3YIxgXU6DMsp08+5QEJt5IWOgJLjS8+dFXzRMLwidPwif6Ax+A3QSC+6r8ejNxP
         RpoklAoNBnE4Lq3buUfJgPxJ9K4fB9XUfaEY9jqjb3lAo06ZFQ9gtaOvd3Qk/ryDqYdw
         5Fow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vz35UX4luoMUaqbzTcDDIbvcjgeBkxbh135cUjhEHMo=;
        b=NG1p1y4NTKzKAGMEakwdC3InE1oHD2jX+4e6VW8jTcr7GRgfg7ZoLuh1f+5LovtUFj
         JBfs5UcptilMDRfrg3P2qvoosCtfjDYj8FIjESkd9Idd/dvv7ik6hnEuWKuC7EFRNnwH
         gT6jg1T51NHF+5D9jHAIknZw2LMY5zsCBIzxnS8w9UlMePb022sMY7809IiulRXbWNtJ
         lWLOx3jVbNHLvUz1Ym3D39tzLaNVfxq7+HV7ufhbNENng2/JKyKzqCAxkYV7px0VSDoq
         fw31EmzrqKytNN6j6xaNS5a7loy2ClY6t4Yti3Ca/n6Qsah7s5SscFi5seTnzTNQqNpQ
         6etQ==
X-Gm-Message-State: AO0yUKV1zindZ4zXu5T0C4Mf5vqkbPILqYFLfC/iEs/QKTGNis+ngTV1
        QOHzYsQUwY8aibqPQLRHhAduVbW3f39K+pk2
X-Google-Smtp-Source: AK7set/xn5Ccsu5wveg0hA8LklsQ+9ymklxMsebESI86/qV1Z+xqiOKNeIuLLMvRjwl0dPZDKqPv8Q==
X-Received: by 2002:a5d:4b06:0:b0:2c5:4b93:ee44 with SMTP id v6-20020a5d4b06000000b002c54b93ee44mr2256030wrq.60.1676483052008;
        Wed, 15 Feb 2023 09:44:12 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id s9-20020a5d4ec9000000b002c567881dbcsm4363915wrv.48.2023.02.15.09.44.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Feb 2023 09:44:11 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 3/5] hw/i386/pc: Un-inline i8254_pit_init()
Date:   Wed, 15 Feb 2023 18:43:51 +0100
Message-Id: <20230215174353.37097-4-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230215174353.37097-1-philmd@linaro.org>
References: <20230215174353.37097-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pc_basic_device_init() is the single caller of i8254_pit_init()
with a non-NULL 'alt_irq' argument. Open-code i8254_pit_init()
by direclty calling i8254_pit_create().

To confirm all other callers pass a NULL 'alt_irq', add an
assertion in i8254_pit_init().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/i386/pc.c             | 10 +++++-----
 include/hw/timer/i8254.h |  5 ++---
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 79297a6ecd..fe95f6e9f2 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1258,8 +1258,7 @@ void pc_basic_device_init(struct PCMachineState *pcms,
 {
     int i;
     DeviceState *hpet = NULL;
-    int pit_isa_irq = 0;
-    qemu_irq pit_alt_irq = NULL;
+    qemu_irq pit_irq;
     qemu_irq rtc_irq = NULL;
     ISADevice *pit = NULL;
     MemoryRegion *ioport80_io = g_new(MemoryRegion, 1);
@@ -1301,9 +1300,10 @@ void pc_basic_device_init(struct PCMachineState *pcms,
         for (i = 0; i < GSI_NUM_PINS; i++) {
             sysbus_connect_irq(SYS_BUS_DEVICE(hpet), i, gsi[i]);
         }
-        pit_isa_irq = -1;
-        pit_alt_irq = qdev_get_gpio_in(hpet, HPET_LEGACY_PIT_INT);
+        pit_irq = qdev_get_gpio_in(hpet, HPET_LEGACY_PIT_INT);
         rtc_irq = qdev_get_gpio_in(hpet, HPET_LEGACY_RTC_INT);
+    } else {
+        pit_irq = isa_bus_get_irq(isa_bus, 0);
     }
     *rtc_state = mc146818_rtc_init(isa_bus, 2000, rtc_irq);
 
@@ -1314,7 +1314,7 @@ void pc_basic_device_init(struct PCMachineState *pcms,
         if (kvm_pit_in_kernel()) {
             pit = kvm_pit_init(isa_bus, 0x40);
         } else {
-            pit = i8254_pit_init(isa_bus, 0x40, pit_isa_irq, pit_alt_irq);
+            pit = i8254_pit_create(isa_bus, 0x40, pit_irq);
         }
         if (hpet) {
             /* connect PIT to output control line of the HPET */
diff --git a/include/hw/timer/i8254.h b/include/hw/timer/i8254.h
index a0843cae07..0d837f3f41 100644
--- a/include/hw/timer/i8254.h
+++ b/include/hw/timer/i8254.h
@@ -59,9 +59,8 @@ ISADevice *i8254_pit_create(ISABus *bus, int iobase, qemu_irq irq_in);
 static inline ISADevice *i8254_pit_init(ISABus *bus, int base, int isa_irq,
                                         qemu_irq alt_irq)
 {
-    return i8254_pit_create(bus, base, isa_irq >= 0
-                                       ? isa_bus_get_irq(bus, isa_irq)
-                                       : alt_irq);
+    assert(isa_irq == 0 && alt_irq == NULL);
+    return i8254_pit_create(bus, base, isa_bus_get_irq(bus, 0));
 }
 
 static inline ISADevice *kvm_pit_init(ISABus *bus, int base)
-- 
2.38.1

