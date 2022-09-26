Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED7E5EA9AC
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 17:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235730AbiIZPIF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 11:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbiIZPHZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 11:07:25 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA5E58DD2
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 06:39:15 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id n12so10259777wrx.9
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 06:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=uPWI1zT5RA3MTBLfOSsbd8UM7dwx7REeUZ6YlYd0oe4=;
        b=hIQ/3ftczCI0GBfvYERTE3hSvszZAAz68CjitXhOoHUWZKjSoGByygyoLPAoUzQT8J
         BtbsyjFrHXoZgK8S32cYB2k42YogtinGj9fNy+kIYt+Qc3FCcCd/OB2OvNXw0/DPMIVz
         HM6O9bjwyLmoGmdfBgoefwxb1quxbiRr8OGiEmwStkD2EQ3ReJzI4o8gwDEWbgV+tKEI
         EWHCD4GMoF5ghzmTWBqZpSr9TyZmV1Ad0QrnyLZH1gf9DUTTbTnGVuFK6C+FB3W3+vNd
         oXbYXRqT/bIaICFcvoNj3b80iT/PTjEvE51mcqHTXoG+L87V3+jaupR15zJPLHkHCA/o
         kmTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=uPWI1zT5RA3MTBLfOSsbd8UM7dwx7REeUZ6YlYd0oe4=;
        b=ZqU4K4EaUwB7bG2dVA+I539qCXde7tgQNeZo8h50kC1KDl9wOS3NiqCCEBTyq5SL5M
         RhwdH2MBbGcI7mBOLqJIqucmNRifTKY21XbVN/mQ3x2g9VTRh/+R97SNHQdEvvqgzjW2
         wvNOndZ80ftAV5M9ecGbPi3xdOzHoYp9hws7fxeOabIvYAqupkAl3vsZpD+VXgR9emjP
         cbBnopf4vrVm8kmqlWIyA/FVp8v/Mq3sCE6jWWpXHadH1Tmu/MqiUrFTJMj6oKbyEtIW
         f8v/F+ccVOpuQ07080R3zOmbtjnP7M/2KQ9q1BoPvtMcaeDm8kRzL5yl16+WEI4Opady
         cp5Q==
X-Gm-Message-State: ACrzQf29kGfcYUDCBaE39og/TERI38caHan94i4dbAfcrZ/gO09ZHvrJ
        YeO2C0JXOHuDaGyG5lvQgHQ2ug==
X-Google-Smtp-Source: AMsMyM5h6FxMJUWvPqtN1hKqidI9x7/J613y5T+ilWUI8GGuXvYm9az89itCN7tGLyugLkV71NgYyw==
X-Received: by 2002:adf:e186:0:b0:22a:3329:540f with SMTP id az6-20020adfe186000000b0022a3329540fmr13417102wrb.278.1664199553616;
        Mon, 26 Sep 2022 06:39:13 -0700 (PDT)
Received: from zen.linaroharston ([185.81.254.11])
        by smtp.gmail.com with ESMTPSA id t16-20020a05600c199000b003a1980d55c4sm12080553wmq.47.2022.09.26.06.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 06:39:09 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id A6E8C1FFC1;
        Mon, 26 Sep 2022 14:39:05 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     f4bug@amsat.org, mads@ynddal.dk, qemu-arm@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH  v2 09/11] gdbstub: move sstep flags probing into AccelClass
Date:   Mon, 26 Sep 2022 14:39:02 +0100
Message-Id: <20220926133904.3297263-10-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926133904.3297263-1-alex.bennee@linaro.org>
References: <20220926133904.3297263-1-alex.bennee@linaro.org>
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

The support of single-stepping is very much dependent on support from
the accelerator we are using. To avoid special casing in gdbstub move
the probing out to an AccelClass function so future accelerators can
put their code there.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Mads Ynddal <mads@ynddal.dk>
---
 include/qemu/accel.h | 12 ++++++++++++
 include/sysemu/kvm.h |  8 --------
 accel/accel-common.c | 10 ++++++++++
 accel/kvm/kvm-all.c  | 14 +++++++++++++-
 accel/tcg/tcg-all.c  | 17 +++++++++++++++++
 gdbstub/gdbstub.c    | 22 ++++------------------
 6 files changed, 56 insertions(+), 27 deletions(-)

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index be56da1b99..ce4747634a 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -43,6 +43,10 @@ typedef struct AccelClass {
     bool (*has_memory)(MachineState *ms, AddressSpace *as,
                        hwaddr start_addr, hwaddr size);
 #endif
+
+    /* gdbstub related hooks */
+    int (*gdbstub_supported_sstep_flags)(void);
+
     bool *allowed;
     /*
      * Array of global properties that would be applied when specific
@@ -92,4 +96,12 @@ void accel_cpu_instance_init(CPUState *cpu);
  */
 bool accel_cpu_realizefn(CPUState *cpu, Error **errp);
 
+/**
+ * accel_supported_gdbstub_sstep_flags:
+ *
+ * Returns the supported single step modes for the configured
+ * accelerator.
+ */
+int accel_supported_gdbstub_sstep_flags(void);
+
 #endif /* QEMU_ACCEL_H */
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index efd6dee818..a20ad51aad 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -47,7 +47,6 @@ extern bool kvm_direct_msi_allowed;
 extern bool kvm_ioeventfd_any_length_allowed;
 extern bool kvm_msi_use_devid;
 extern bool kvm_has_guest_debug;
-extern int kvm_sstep_flags;
 
 #define kvm_enabled()           (kvm_allowed)
 /**
@@ -174,12 +173,6 @@ extern int kvm_sstep_flags;
  */
 #define kvm_supports_guest_debug() (kvm_has_guest_debug)
 
-/*
- * kvm_supported_sstep_flags
- * Returns: SSTEP_* flags that KVM supports for guest debug
- */
-#define kvm_get_supported_sstep_flags() (kvm_sstep_flags)
-
 #else
 
 #define kvm_enabled()           (0)
@@ -198,7 +191,6 @@ extern int kvm_sstep_flags;
 #define kvm_ioeventfd_any_length_enabled() (false)
 #define kvm_msi_devid_required() (false)
 #define kvm_supports_guest_debug() (false)
-#define kvm_get_supported_sstep_flags() (0)
 
 #endif  /* CONFIG_KVM_IS_POSSIBLE */
 
diff --git a/accel/accel-common.c b/accel/accel-common.c
index 50035bda55..df72cc989a 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -129,6 +129,16 @@ bool accel_cpu_realizefn(CPUState *cpu, Error **errp)
     return true;
 }
 
+int accel_supported_gdbstub_sstep_flags(void)
+{
+    AccelState *accel = current_accel();
+    AccelClass *acc = ACCEL_GET_CLASS(accel);
+    if (acc->gdbstub_supported_sstep_flags) {
+        return acc->gdbstub_supported_sstep_flags();
+    }
+    return 0;
+}
+
 static const TypeInfo accel_cpu_type = {
     .name = TYPE_ACCEL_CPU,
     .parent = TYPE_OBJECT,
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 5acab1767f..c55938453a 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -175,7 +175,7 @@ bool kvm_direct_msi_allowed;
 bool kvm_ioeventfd_any_length_allowed;
 bool kvm_msi_use_devid;
 bool kvm_has_guest_debug;
-int kvm_sstep_flags;
+static int kvm_sstep_flags;
 static bool kvm_immediate_exit;
 static hwaddr kvm_max_slot_size = ~0;
 
@@ -3712,6 +3712,17 @@ static void kvm_accel_instance_init(Object *obj)
     s->kvm_dirty_ring_size = 0;
 }
 
+/**
+ * kvm_gdbstub_sstep_flags():
+ *
+ * Returns: SSTEP_* flags that KVM supports for guest debug. The
+ * support is probed during kvm_init()
+ */
+static int kvm_gdbstub_sstep_flags(void)
+{
+    return kvm_sstep_flags;
+}
+
 static void kvm_accel_class_init(ObjectClass *oc, void *data)
 {
     AccelClass *ac = ACCEL_CLASS(oc);
@@ -3719,6 +3730,7 @@ static void kvm_accel_class_init(ObjectClass *oc, void *data)
     ac->init_machine = kvm_init;
     ac->has_memory = kvm_accel_has_memory;
     ac->allowed = &kvm_allowed;
+    ac->gdbstub_supported_sstep_flags = kvm_gdbstub_sstep_flags;
 
     object_class_property_add(oc, "kernel-irqchip", "on|off|split",
         NULL, kvm_set_kernel_irqchip,
diff --git a/accel/tcg/tcg-all.c b/accel/tcg/tcg-all.c
index 47952eecd7..30b503fb22 100644
--- a/accel/tcg/tcg-all.c
+++ b/accel/tcg/tcg-all.c
@@ -25,6 +25,7 @@
 
 #include "qemu/osdep.h"
 #include "sysemu/tcg.h"
+#include "sysemu/replay.h"
 #include "sysemu/cpu-timers.h"
 #include "tcg/tcg.h"
 #include "qapi/error.h"
@@ -207,12 +208,28 @@ static void tcg_set_splitwx(Object *obj, bool value, Error **errp)
     s->splitwx_enabled = value;
 }
 
+static int tcg_gdbstub_supported_sstep_flags(void)
+{
+    /*
+     * In replay mode all events will come from the log and can't be
+     * suppressed otherwise we would break determinism. However as those
+     * events are tied to the number of executed instructions we won't see
+     * them occurring every time we single step.
+     */
+    if (replay_mode != REPLAY_MODE_NONE) {
+        return SSTEP_ENABLE;
+    } else {
+        return SSTEP_ENABLE | SSTEP_NOIRQ | SSTEP_NOTIMER;
+    }
+}
+
 static void tcg_accel_class_init(ObjectClass *oc, void *data)
 {
     AccelClass *ac = ACCEL_CLASS(oc);
     ac->name = "tcg";
     ac->init_machine = tcg_init_machine;
     ac->allowed = &tcg_allowed;
+    ac->gdbstub_supported_sstep_flags = tcg_gdbstub_supported_sstep_flags;
 
     object_class_property_add_str(oc, "thread",
                                   tcg_get_thread,
diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index 7d8fe475b3..a0755e6505 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -383,27 +383,13 @@ static void init_gdbserver_state(void)
     gdbserver_state.last_packet = g_byte_array_sized_new(MAX_PACKET_LENGTH + 4);
 
     /*
-     * In replay mode all events will come from the log and can't be
-     * suppressed otherwise we would break determinism. However as those
-     * events are tied to the number of executed instructions we won't see
-     * them occurring every time we single step.
-     */
-    if (replay_mode != REPLAY_MODE_NONE) {
-        gdbserver_state.supported_sstep_flags = SSTEP_ENABLE;
-    } else if (kvm_enabled()) {
-        gdbserver_state.supported_sstep_flags = kvm_get_supported_sstep_flags();
-    } else {
-        gdbserver_state.supported_sstep_flags =
-            SSTEP_ENABLE | SSTEP_NOIRQ | SSTEP_NOTIMER;
-    }
-
-    /*
-     * By default use no IRQs and no timers while single stepping so as to
-     * make single stepping like an ICE HW step.
+     * What single-step modes are supported is accelerator dependent.
+     * By default try to use no IRQs and no timers while single
+     * stepping so as to make single stepping like a typical ICE HW step.
      */
+    gdbserver_state.supported_sstep_flags = accel_supported_gdbstub_sstep_flags();
     gdbserver_state.sstep_flags = SSTEP_ENABLE | SSTEP_NOIRQ | SSTEP_NOTIMER;
     gdbserver_state.sstep_flags &= gdbserver_state.supported_sstep_flags;
-
 }
 
 #ifndef CONFIG_USER_ONLY
-- 
2.34.1

