Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB2569827E
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjBORoL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjBORoK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:44:10 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846D83C297
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:44:08 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id hg24-20020a05600c539800b003e1f5f2a29cso2154806wmb.4
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4xWeqx5C/Xjzaw1eQA4/F7uZTIcR+NwJk/0kJcEYTAY=;
        b=IUZDYPUxoTz64E5CsADb59dPUZIMb31X/tgySvrGmDuEdvmFEsEv6OOqEoawQhASpG
         Y0xqT/osOWB55zfb8IVlEB3g1aB1GWTupU2lQyzgeNtSNKaamuxhw3iYy0SkzEe+R46g
         LprJCLeEklZ/81t+bixRziYVDcy8+TFCsuLS68X/58n36lUeUl4xu/x2G4XKQUl8fqVY
         yNKqf6iZbq4hyHOBsdePvt3k/ANFx5oTSnBcPRL/EC69r53YA1fJkxV7+LKweyPxFsGg
         WeiA/cxycScza3jopc7RZxjZuDuqUm4iRm95y714NBpoKGuOhQM+TjlWakSBXG9WHd9x
         P6Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4xWeqx5C/Xjzaw1eQA4/F7uZTIcR+NwJk/0kJcEYTAY=;
        b=QQY7CnW5TjQfmcTZtPP1lfZmP3Ldx7BaxuFha6MB//Uf97peWP/PdDWSjpw4pgXkXw
         UxjQEbBwmDjxaiYSBsgeetKOsCnRx0mXPSZGU3kaRm7MvNDtQfI1l2iBZ66mpSC9cwc0
         VI/J/gTx1vyaJ7ct+ric2whpKael+3lkR3Xw9DvlIt9YrJqgOHcnV9H3DPa2TMpp3sfE
         y14D0GKQxzH8Hi4+y42TvPbbYSn+TZS0aWvNM2UT4LZH6avYxzPDsZ3IZE2yMfOR8eKZ
         u13IMWVBy6klvMV2KLy3PgdniV1zsZAlS1enYP2jyH+8YCC1AUohC33oOph9QKXk9f+i
         ca9Q==
X-Gm-Message-State: AO0yUKX0sNncl/F6vD+iTESoyIPOAjZ5muD6pv+KqPyAtv8UAC4VTUhT
        vGdJ3GuNu/Qs5YQvJRa7d5YisQ==
X-Google-Smtp-Source: AK7set/7lvshecTiyDKvaOH/yA+UWKADLvy67Z5P7A4WG491XE/W3jOetrh7ZzUU8Z/Vc4P2Um29/A==
X-Received: by 2002:a05:600c:46c6:b0:3e0:14a:697a with SMTP id q6-20020a05600c46c600b003e0014a697amr2921374wmo.6.1676483046880;
        Wed, 15 Feb 2023 09:44:06 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id p17-20020a05600c469100b003dd1b00bd9asm3004147wmo.32.2023.02.15.09.44.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Feb 2023 09:44:06 -0800 (PST)
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
Subject: [PATCH 2/5] hw/timer/i8254: Factor i8254_pit_create() out and document
Date:   Wed, 15 Feb 2023 18:43:50 +0100
Message-Id: <20230215174353.37097-3-philmd@linaro.org>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/timer/i8254.c         | 16 ++++++++++++++++
 include/hw/timer/i8254.h | 24 +++++++++++++-----------
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/hw/timer/i8254.c b/hw/timer/i8254.c
index c8388ea432..9b6932ab08 100644
--- a/hw/timer/i8254.c
+++ b/hw/timer/i8254.c
@@ -26,9 +26,11 @@
 #include "hw/irq.h"
 #include "qemu/module.h"
 #include "qemu/timer.h"
+#include "hw/qdev-properties.h"
 #include "hw/timer/i8254.h"
 #include "hw/timer/i8254_internal.h"
 #include "qom/object.h"
+#include "qapi/error.h"
 
 //#define DEBUG_PIT
 
@@ -47,6 +49,20 @@ struct PITClass {
     DeviceRealize parent_realize;
 };
 
+ISADevice *i8254_pit_create(ISABus *bus, int iobase, qemu_irq irq_in)
+{
+    DeviceState *dev;
+    ISADevice *d;
+
+    d = isa_new(TYPE_I8254);
+    dev = DEVICE(d);
+    qdev_prop_set_uint32(dev, "iobase", iobase);
+    isa_realize_and_unref(d, bus, &error_fatal);
+    qdev_connect_gpio_out(dev, 0, irq_in);
+
+    return d;
+}
+
 static void pit_irq_timer_update(PITChannelState *s, int64_t current_time);
 
 static int pit_get_count(PITChannelState *s)
diff --git a/include/hw/timer/i8254.h b/include/hw/timer/i8254.h
index 8402caad30..a0843cae07 100644
--- a/include/hw/timer/i8254.h
+++ b/include/hw/timer/i8254.h
@@ -45,21 +45,23 @@ OBJECT_DECLARE_TYPE(PITCommonState, PITCommonClass, PIT_COMMON)
 #define TYPE_I8254 "isa-pit"
 #define TYPE_KVM_I8254 "kvm-pit"
 
+/**
+ * Create and realize a I8254 PIT device on the heap.
+ * @bus: the #ISABus to put it on.
+ * @iobase: the base I/O port.
+ * @irq_in: qemu_irq to connect the PIT output IRQ to.
+ *
+ * Create the device state structure, initialize it, put it on the
+ * specified ISA @bus, and drop the reference to it (the device is realized).
+ */
+ISADevice *i8254_pit_create(ISABus *bus, int iobase, qemu_irq irq_in);
+
 static inline ISADevice *i8254_pit_init(ISABus *bus, int base, int isa_irq,
                                         qemu_irq alt_irq)
 {
-    DeviceState *dev;
-    ISADevice *d;
-
-    d = isa_new(TYPE_I8254);
-    dev = DEVICE(d);
-    qdev_prop_set_uint32(dev, "iobase", base);
-    isa_realize_and_unref(d, bus, &error_fatal);
-    qdev_connect_gpio_out(dev, 0,
-                          isa_irq >= 0 ? isa_bus_get_irq(bus, isa_irq)
+    return i8254_pit_create(bus, base, isa_irq >= 0
+                                       ? isa_bus_get_irq(bus, isa_irq)
                                        : alt_irq);
-
-    return d;
 }
 
 static inline ISADevice *kvm_pit_init(ISABus *bus, int base)
-- 
2.38.1

