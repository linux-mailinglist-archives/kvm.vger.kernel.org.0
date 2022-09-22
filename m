Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F245E664D
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 16:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbiIVO67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 10:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbiIVO6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 10:58:50 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F84EEE8E
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 07:58:42 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id y5so16035864wrh.3
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 07:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=navtm+gH6yNeb7knk5E3m8UXvhR7UYY2qxKvdX6qN2Q=;
        b=Tb25KTfMeh3bfFfHp3LUZUNMKprBS5sCZIyYoGnd8YAikMNf4imAlWxzVNRNuk/dq1
         1mZrHpZkYPqsiaYWLtbSsIfnxJsTIj2W9g6Q1U58Ku5v9J+zSWBXcpt82qYHHEmpi4Vy
         ttyGNzzZh0KaKv26BME5b36VJRqK6kflEHtDzbaRcvJz7B/qRjZN3YRH8weL3yOx7lRm
         rb4d+CYSEsREdU0f+Y4GTUBURQ3fpJcnEdAlg2muLMuXoK55CV61l+LdIZyMiAJ1c03G
         6DgZIwGpIub3mJN6INs9aNaXNkqMr7b4ICA4eLLm2GayemgF3ChCjf/1/ovdM0JD1aTx
         o4IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=navtm+gH6yNeb7knk5E3m8UXvhR7UYY2qxKvdX6qN2Q=;
        b=IiEtopspvfGWYOMhuA9YcdNfZnGfDkQsMGDXzaTYT1QMGyH2Plnth+s/mpj9fuub/M
         uKlnC5UtsdeIF6yKw7Qc2t4C6mqkwODNUL5wQ6xoCIqB+aGjj+pH4ZGw8l4WHdX4v5YF
         i9twh4bjXMMFbfGhT+SSS8zcApAPH/EgavYYI0320DiVX1cgnVgHCXTOS01ybJ3OcLzG
         OMceGWxgcP724pYnT82bMndFdOI9joGWvR3uFgC8ToSlywRPMD/7cJpUAxn1kDrsyEQ8
         jQg/tMjinx1/qG9pqG82mj5ztzFoIWDnbw0TDZtaS2qOqiqrquXpLF5b3gcEX1ROx/dj
         IQjw==
X-Gm-Message-State: ACrzQf24s+R9MiAveWmL7B2n1L4uK8npbm2zfCCIt5JaSC4AYOKQBPHG
        P6eWRuibWY4wnZGQtyqXuFLr8Q==
X-Google-Smtp-Source: AMsMyM4QNCH6Uv/WHajoEKGnZ7/0Ppo9YqV/kbNBsuFSpXt9kgcAvUrlOgSzErLA1iBi2IVBgbiHlQ==
X-Received: by 2002:adf:f18d:0:b0:228:9f0a:f291 with SMTP id h13-20020adff18d000000b002289f0af291mr2482447wro.252.1663858720770;
        Thu, 22 Sep 2022 07:58:40 -0700 (PDT)
Received: from zen.linaroharston ([185.81.254.11])
        by smtp.gmail.com with ESMTPSA id r7-20020a5d52c7000000b0022acb7195aesm5424565wrv.33.2022.09.22.07.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 07:58:38 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 838C41FFB7;
        Thu, 22 Sep 2022 15:58:33 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     f4bug@amsat.org, mads@ynddal.dk,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH  v1 9/9] gdbstub: move guest debug support check to ops
Date:   Thu, 22 Sep 2022 15:58:32 +0100
Message-Id: <20220922145832.1934429-10-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922145832.1934429-1-alex.bennee@linaro.org>
References: <20220922145832.1934429-1-alex.bennee@linaro.org>
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

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Mads Ynddal <mads@ynddal.dk>
---
 accel/kvm/kvm-cpus.h       | 1 +
 gdbstub/internals.h        | 1 +
 include/sysemu/accel-ops.h | 1 +
 include/sysemu/kvm.h       | 7 -------
 accel/kvm/kvm-accel-ops.c  | 1 +
 accel/kvm/kvm-all.c        | 6 ++++++
 accel/tcg/tcg-accel-ops.c  | 6 ++++++
 gdbstub/gdbstub.c          | 5 ++---
 gdbstub/softmmu.c          | 9 +++++++++
 gdbstub/user.c             | 6 ++++++
 10 files changed, 33 insertions(+), 10 deletions(-)

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

