Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05A65F43EC
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 15:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiJDNKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 09:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJDNJ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 09:09:57 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C7ACE0A
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 06:09:55 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id bq9so21256206wrb.4
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 06:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=C1NyWOfmsPZQD10r7UbPdctd03es5mAxTm6eeJpepGU=;
        b=gPYP2PphyxFCnruzFlPldrHhv49mwao1pKlrmzA4ShnYKCDnoGKF0kI1xvj6FxGc80
         +5Cnu0OToTBkSLvLa3sqPA71ybvfAuAPekFostEJf9mnuklUYwBB6HbTap6FnjCCijb2
         V97qAHtZXwfQZqy/Euf65bPN6dN2P1K/Mabx+UxTsat/1Fzo/BNQT2qzw6X+kn/hV7N8
         vIwfyXCnjAkrzc37ZPNl1N+VXZUAxcCrO8Tz6yhSRk/FpU4EHCZc7xhomsLO/qc24L7d
         hjMArAAXTs5HOWfM6QojHvtfABWSPmH/rHogfmTRKvH0Hi8jq2b4A/0rtSaX/qVK5aTu
         st7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=C1NyWOfmsPZQD10r7UbPdctd03es5mAxTm6eeJpepGU=;
        b=0a6LgmteEbH4ZC3iETKqNtMBri2eD4IaT5NsQvu29y6Hjh5pH0+bFOeEpFwSJrPg1t
         Kky1+tmBjekpmt9qtWQ8c7kHfHrIK9w0qZjJXeZph5ATyloI6z4T4+rHrqDWT4edoM7r
         ra/wIsR43o+P7Jq8PsBa2ZAVLmUScAYH4Fy9g1GkTUUfVF5u+Is1usOc7N0/gJXL01nh
         zbxWzoffmXpeajMjYB7fLvOe1h3RYOhOnJ/qWeu6Z4o35g14DkOxJF6G5yfBDS0ElCyT
         oD/rVGKL+ICX1QchFI4LcxU3EqT6qwqRCVZk4UD5pd3+Q4DZpqI0d8DfdA1zskNjmrg+
         kMPg==
X-Gm-Message-State: ACrzQf1XymtS2rk5Q8ujC2CuQyqmB5TT8QKg/wnbASENKhDiPH6t9Js6
        XZ9tolv/Wp8o9sCRHCzAL2tApg==
X-Google-Smtp-Source: AMsMyM5Z+SAkd4jHc/d4kr28R784QoD9d786ZImdgYqdtFvAUTFsqAQyFa4eMpZzyIV7XtlWLdF2sQ==
X-Received: by 2002:a5d:6d8e:0:b0:22a:4831:e0e with SMTP id l14-20020a5d6d8e000000b0022a48310e0emr15296668wrs.442.1664888993995;
        Tue, 04 Oct 2022 06:09:53 -0700 (PDT)
Received: from zen.linaroharston ([185.81.254.11])
        by smtp.gmail.com with ESMTPSA id l4-20020a7bc444000000b003b339438733sm14273999wmi.19.2022.10.04.06.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 06:09:51 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 958DF1FFE0;
        Tue,  4 Oct 2022 14:01:43 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     stefanha@redhat.com,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Mads Ynddal <mads@ynddal.dk>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PULL 45/54] gdbstub: move guest debug support check to ops
Date:   Tue,  4 Oct 2022 14:01:29 +0100
Message-Id: <20221004130138.2299307-46-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221004130138.2299307-1-alex.bennee@linaro.org>
References: <20221004130138.2299307-1-alex.bennee@linaro.org>
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

This removes the final hard coding of kvm_enabled() in gdbstub and
moves the check to an AccelOps.

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Mads Ynddal <mads@ynddal.dk>
Message-Id: <20220929114231.583801-46-alex.bennee@linaro.org>

diff --git a/accel/kvm/kvm-cpus.h b/accel/kvm/kvm-cpus.h
index 33e435d62b..fd63fe6a59 100644
--- a/accel/kvm/kvm-cpus.h
+++ b/accel/kvm/kvm-cpus.h
@@ -18,6 +18,7 @@ void kvm_destroy_vcpu(CPUState *cpu);
 void kvm_cpu_synchronize_post_reset(CPUState *cpu);
 void kvm_cpu_synchronize_post_init(CPUState *cpu);
 void kvm_cpu_synchronize_pre_loadvm(CPUState *cpu);
+bool kvm_supports_guest_debug(void);
 int kvm_insert_breakpoint(CPUState *cpu, int type, hwaddr addr, hwaddr len);
 int kvm_remove_breakpoint(CPUState *cpu, int type, hwaddr addr, hwaddr len);
 void kvm_remove_all_breakpoints(CPUState *cpu);
diff --git a/gdbstub/internals.h b/gdbstub/internals.h
index 41e2e72dbf..eabb0341d1 100644
--- a/gdbstub/internals.h
+++ b/gdbstub/internals.h
@@ -9,6 +9,7 @@
 #ifndef _INTERNALS_H_
 #define _INTERNALS_H_
 
+bool gdb_supports_guest_debug(void);
 int gdb_breakpoint_insert(CPUState *cs, int type, hwaddr addr, hwaddr len);
 int gdb_breakpoint_remove(CPUState *cs, int type, hwaddr addr, hwaddr len);
 void gdb_breakpoint_remove_all(CPUState *cs);
diff --git a/include/sysemu/accel-ops.h b/include/sysemu/accel-ops.h
index 86794ac273..8cc7996def 100644
--- a/include/sysemu/accel-ops.h
+++ b/include/sysemu/accel-ops.h
@@ -47,6 +47,7 @@ struct AccelOpsClass {
     int64_t (*get_elapsed_ticks)(void);
 
     /* gdbstub hooks */
+    bool (*supports_guest_debug)(void);
     int (*insert_breakpoint)(CPUState *cpu, int type, hwaddr addr, hwaddr len);
     int (*remove_breakpoint)(CPUState *cpu, int type, hwaddr addr, hwaddr len);
     void (*remove_all_breakpoints)(CPUState *cpu);
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 21d3f1d01e..6e1bd01725 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -46,7 +46,6 @@ extern bool kvm_readonly_mem_allowed;
 extern bool kvm_direct_msi_allowed;
 extern bool kvm_ioeventfd_any_length_allowed;
 extern bool kvm_msi_use_devid;
-extern bool kvm_has_guest_debug;
 
 #define kvm_enabled()           (kvm_allowed)
 /**
@@ -168,11 +167,6 @@ extern bool kvm_has_guest_debug;
  */
 #define kvm_msi_devid_required() (kvm_msi_use_devid)
 
-/*
- * Does KVM support guest debugging
- */
-#define kvm_supports_guest_debug() (kvm_has_guest_debug)
-
 #else
 
 #define kvm_enabled()           (0)
@@ -190,7 +184,6 @@ extern bool kvm_has_guest_debug;
 #define kvm_direct_msi_enabled() (false)
 #define kvm_ioeventfd_any_length_enabled() (false)
 #define kvm_msi_devid_required() (false)
-#define kvm_supports_guest_debug() (false)
 
 #endif  /* CONFIG_KVM_IS_POSSIBLE */
 
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index 5c0e37514c..fbf4fe3497 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -99,6 +99,7 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, void *data)
     ops->synchronize_pre_loadvm = kvm_cpu_synchronize_pre_loadvm;
 
 #ifdef KVM_CAP_SET_GUEST_DEBUG
+    ops->supports_guest_debug = kvm_supports_guest_debug;
     ops->insert_breakpoint = kvm_insert_breakpoint;
     ops->remove_breakpoint = kvm_remove_breakpoint;
     ops->remove_all_breakpoints = kvm_remove_all_breakpoints;
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index b8c734fe3a..6ebff6e5a6 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3287,6 +3287,12 @@ int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap)
     return data.err;
 }
 
+bool kvm_supports_guest_debug(void)
+{
+    /* probed during kvm_init() */
+    return kvm_has_guest_debug;
+}
+
 int kvm_insert_breakpoint(CPUState *cpu, int type, hwaddr addr, hwaddr len)
 {
     struct kvm_sw_breakpoint *bp;
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 965c2ad581..19cbf1db3a 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -93,6 +93,11 @@ void tcg_handle_interrupt(CPUState *cpu, int mask)
     }
 }
 
+static bool tcg_supports_guest_debug(void)
+{
+    return true;
+}
+
 /* Translate GDB watchpoint type to a flags value for cpu_watchpoint_* */
 static inline int xlat_gdb_type(CPUState *cpu, int gdbtype)
 {
@@ -198,6 +203,7 @@ static void tcg_accel_ops_init(AccelOpsClass *ops)
         }
     }
 
+    ops->supports_guest_debug = tcg_supports_guest_debug;
     ops->insert_breakpoint = tcg_insert_breakpoint;
     ops->remove_breakpoint = tcg_remove_breakpoint;
     ops->remove_all_breakpoints = tcg_remove_all_breakpoints;
diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index ff9f3f9586..be88ca0d71 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -45,7 +45,6 @@
 
 #include "qemu/sockets.h"
 #include "sysemu/hw_accel.h"
-#include "sysemu/kvm.h"
 #include "sysemu/runstate.h"
 #include "semihosting/semihost.h"
 #include "exec/exec-all.h"
@@ -3447,8 +3446,8 @@ int gdbserver_start(const char *device)
         return -1;
     }
 
-    if (kvm_enabled() && !kvm_supports_guest_debug()) {
-        error_report("gdbstub: KVM doesn't support guest debugging");
+    if (!gdb_supports_guest_debug()) {
+        error_report("gdbstub: current accelerator doesn't support guest debugging");
         return -1;
     }
 
diff --git a/gdbstub/softmmu.c b/gdbstub/softmmu.c
index 4e73890379..f208c6cf15 100644
--- a/gdbstub/softmmu.c
+++ b/gdbstub/softmmu.c
@@ -15,6 +15,15 @@
 #include "sysemu/cpus.h"
 #include "internals.h"
 
+bool gdb_supports_guest_debug(void)
+{
+    const AccelOpsClass *ops = cpus_get_accel();
+    if (ops->supports_guest_debug) {
+        return ops->supports_guest_debug();
+    }
+    return false;
+}
+
 int gdb_breakpoint_insert(CPUState *cs, int type, hwaddr addr, hwaddr len)
 {
     const AccelOpsClass *ops = cpus_get_accel();
diff --git a/gdbstub/user.c b/gdbstub/user.c
index 42652b28a7..033e5fdd71 100644
--- a/gdbstub/user.c
+++ b/gdbstub/user.c
@@ -14,6 +14,12 @@
 #include "hw/core/cpu.h"
 #include "internals.h"
 
+bool gdb_supports_guest_debug(void)
+{
+    /* user-mode == TCG == supported */
+    return true;
+}
+
 int gdb_breakpoint_insert(CPUState *cs, int type, hwaddr addr, hwaddr len)
 {
     CPUState *cpu;
-- 
2.34.1

