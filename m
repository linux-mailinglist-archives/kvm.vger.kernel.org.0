Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540E5698282
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjBORoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjBORo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:44:29 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE9B3C2B9
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:44:25 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id bk16so19956131wrb.11
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IWNxqquWLNXTTocLvUxsoGH+JCmIcd1Q1kcJ09WY8/Y=;
        b=sFTIywSyT5+Gm4JtVTiPy8pocwC8NLizi+OnGXa0F8gxS+pw88AJbAHk8HZ7sMb/FI
         96175WS+payrqFe8IfpT4VJY+oPZRbvrGyBnOF8Uqmsn6iQhZzPnmM8IIAY9peP0Rvb3
         KmGaMCMDxADFPMYBVs414xcyLurQUmdISGtc2hXzlzGGjaWuKPBxBCbVpt1qA1Ey6/7d
         GrXiarGGH9FGWJ+Z/diMir38jMpVosC8m/8Bc1owB+ohPRD7/4E6z6f8dQ3O7wGgPp7J
         wmJ2lUOCWMb98RpgxN+xQiLQl2T/CmNOhPQrbsRtwqGuL+pmikV9vmZVVYh/tKAU8uc+
         u1Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IWNxqquWLNXTTocLvUxsoGH+JCmIcd1Q1kcJ09WY8/Y=;
        b=oZD/L+RcD3Grk9uBozkXCmlqB8bg0iEgLdRjftd00EYN7mxxOEYLZ1mGN7+O3fT/bn
         L/CmvFNtEmAedNOqnPP4UMDUslTbMfcXvVLkLXYZ0aAAjq7GHbv8ngfX60I/NOELGCz7
         o/D6aBMNp8d53lJOoYuC9oMX2ALxkJwvMWArywXFp+/FedvnhPDJBMVtw9krmyrv0R72
         z8ENoKUZZp+UkudNJniw8bSOT6NJRUpAsYGWZ3GYr/BqKVsiA5Zr9r+hXVpRCbTCEgS8
         rkr5DWRD/4iCFq8wHidNtQab4fPi+RV+SSncbFRJz63/nVt7T5e59Du5ncBtry9vxDUi
         jg3w==
X-Gm-Message-State: AO0yUKWdRqnMKSzx+K9JlvmEpFVJTZhRWPhxqZLkwPh0RvFBjpsbRld4
        cN8TMjcSE/920uanTqAW6m/BoA==
X-Google-Smtp-Source: AK7set/dBoQ8bwhtu/KAQyOrlfuHEmIHSM2Ph1ygizmQiCsBZ4rAct1OR5ti0L9UZGbe4LmrE3eiEQ==
X-Received: by 2002:a05:6000:3c7:b0:2c5:4c07:9593 with SMTP id b7-20020a05600003c700b002c54c079593mr135627wrg.16.1676483063919;
        Wed, 15 Feb 2023 09:44:23 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id f15-20020adff98f000000b002c5583ab017sm8580863wrr.15.2023.02.15.09.44.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Feb 2023 09:44:23 -0800 (PST)
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
Subject: [PATCH 5/5] hw/i386/kvm: Factor i8254_pit_create_try_kvm() out
Date:   Wed, 15 Feb 2023 18:43:53 +0100
Message-Id: <20230215174353.37097-6-philmd@linaro.org>
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

Factor a new i8254_pit_create_try_kvm() helper out of the
following patter:

  if (kvm_pit_in_kernel()) {
      kvm_pit_init(...);
  } else }
    i8254_pit_create(...);
  }

(adding a stub for non-KVM builds).

Since kvm_pit_init() is only used once, un-inline it and
remove the now unused headers from "hw/timer/i8254.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/i386/kvm/i8254.c        | 18 ++++++++++++++++++
 hw/i386/microvm.c          |  6 +-----
 hw/i386/pc.c               |  7 ++-----
 include/hw/timer/i8254.h   | 22 ++++++----------------
 target/i386/kvm/kvm-stub.c |  6 ++++++
 5 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/hw/i386/kvm/i8254.c b/hw/i386/kvm/i8254.c
index 191a26fa57..9520c98c76 100644
--- a/hw/i386/kvm/i8254.c
+++ b/hw/i386/kvm/i8254.c
@@ -35,6 +35,7 @@
 #include "hw/qdev-properties-system.h"
 #include "sysemu/kvm.h"
 #include "qom/object.h"
+#include "kvm/kvm_i386.h"
 
 #define KVM_PIT_REINJECT_BIT 0
 
@@ -59,6 +60,23 @@ struct KVMPITClass {
     DeviceRealize parent_realize;
 };
 
+ISADevice *i8254_pit_create_try_kvm(ISABus *bus, int iobase, qemu_irq irq_in)
+{
+    DeviceState *dev;
+    ISADevice *d;
+
+    if (!kvm_pit_in_kernel()) {
+        return i8254_pit_create(bus, iobase, irq_in);
+    }
+
+    d = isa_new(TYPE_KVM_I8254);
+    dev = DEVICE(d);
+    qdev_prop_set_uint32(dev, "iobase", iobase);
+    isa_realize_and_unref(d, bus, &error_fatal);
+
+    return d;
+}
+
 static void kvm_pit_update_clock_offset(KVMPITState *s)
 {
     int64_t offset, clock_offset;
diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
index 9204bb4ff2..d93dc8a263 100644
--- a/hw/i386/microvm.c
+++ b/hw/i386/microvm.c
@@ -258,11 +258,7 @@ static void microvm_devices_init(MicrovmMachineState *mms)
     }
 
     if (x86ms->pit == ON_OFF_AUTO_ON || x86ms->pit == ON_OFF_AUTO_AUTO) {
-        if (kvm_pit_in_kernel()) {
-            kvm_pit_init(isa_bus, 0x40);
-        } else {
-            i8254_pit_create(isa_bus, 0x40, isa_bus_get_irq(isa_bus, 0));
-        }
+        i8254_pit_create_try_kvm(isa_bus, 0x40, isa_bus_get_irq(isa_bus, 0));
     }
 
     if (mms->rtc == ON_OFF_AUTO_ON ||
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index fe95f6e9f2..7d9f57c695 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1311,11 +1311,8 @@ void pc_basic_device_init(struct PCMachineState *pcms,
 
     if (!xen_enabled() &&
         (x86ms->pit == ON_OFF_AUTO_AUTO || x86ms->pit == ON_OFF_AUTO_ON)) {
-        if (kvm_pit_in_kernel()) {
-            pit = kvm_pit_init(isa_bus, 0x40);
-        } else {
-            pit = i8254_pit_create(isa_bus, 0x40, pit_irq);
-        }
+        pit = i8254_pit_create_try_kvm(isa_bus, 0x40, pit_irq);
+
         if (hpet) {
             /* connect PIT to output control line of the HPET */
             qdev_connect_gpio_out(hpet, 0, qdev_get_gpio_in(DEVICE(pit), 0));
diff --git a/include/hw/timer/i8254.h b/include/hw/timer/i8254.h
index aa48c44d39..9fb18c4ff4 100644
--- a/include/hw/timer/i8254.h
+++ b/include/hw/timer/i8254.h
@@ -25,9 +25,6 @@
 #ifndef HW_I8254_H
 #define HW_I8254_H
 
-#include "hw/qdev-properties.h"
-#include "hw/isa/isa.h"
-#include "qapi/error.h"
 #include "qom/object.h"
 
 #define PIT_FREQ 1193182
@@ -55,19 +52,12 @@ OBJECT_DECLARE_TYPE(PITCommonState, PITCommonClass, PIT_COMMON)
  * specified ISA @bus, and drop the reference to it (the device is realized).
  */
 ISADevice *i8254_pit_create(ISABus *bus, int iobase, qemu_irq irq_in);
-
-static inline ISADevice *kvm_pit_init(ISABus *bus, int base)
-{
-    DeviceState *dev;
-    ISADevice *d;
-
-    d = isa_new(TYPE_KVM_I8254);
-    dev = DEVICE(d);
-    qdev_prop_set_uint32(dev, "iobase", base);
-    isa_realize_and_unref(d, bus, &error_fatal);
-
-    return d;
-}
+/**
+ * Try to create and realize a in-kernel I8254 PIT device on the heap.
+ * If KVM is not available or doesn't have in-kernel PIT support, a
+ * emulated PIT is used. See i8254_pit_create.
+ */
+ISADevice *i8254_pit_create_try_kvm(ISABus *bus, int iobase, qemu_irq irq_in);
 
 void pit_set_gate(ISADevice *dev, int channel, int val);
 void pit_get_channel_info(ISADevice *dev, int channel, PITChannelInfo *info);
diff --git a/target/i386/kvm/kvm-stub.c b/target/i386/kvm/kvm-stub.c
index e052f1c7b0..396da89f55 100644
--- a/target/i386/kvm/kvm-stub.c
+++ b/target/i386/kvm/kvm-stub.c
@@ -10,6 +10,7 @@
  *
  */
 #include "qemu/osdep.h"
+#include "hw/timer/i8254.h"
 #include "cpu.h"
 #include "kvm_i386.h"
 
@@ -49,3 +50,8 @@ void kvm_set_max_apic_id(uint32_t max_apic_id)
 {
     return;
 }
+
+ISADevice *i8254_pit_create_try_kvm(ISABus *bus, int iobase, qemu_irq irq_in)
+{
+    return i8254_pit_create(bus, iobase, irq_in);
+}
-- 
2.38.1

