Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE0D5E664C
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 16:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiIVO65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 10:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbiIVO6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 10:58:47 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66ECDED5F6
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 07:58:41 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l8so6969087wmi.2
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 07:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=PUsqmIg3cIcSF+Cp7vaRpt/1dPSTTn7gEPcc2Xary6E=;
        b=padMy8k014wFPOsIMOv0cR8v0FD3UGKFeHIMyYPKwa3Qo5SytvC9UgtnDQ9zSOMGnZ
         zzM5hOC1x4a21ARMH7LCQTIPgp8g4Q9qO8V9l1C2kk3oIHA4xzjDojJjJTwXiNM0c6oQ
         pSCoKp1RBm0A0iNh+bhgtFI7y8E/aWhYgNZ3R3Jb13G2WXj95bBqCU3yAs0h6Gy60WoZ
         +sKm6kOCoup3ACYWkD0xYhPxkCeYomS122uy6vxy3pDhnERneb3gkx5xHhQYzREx3SyY
         OAxaJ8MUUr5GmgtEt8WIADxtWBprziLsw0Dryips7RqL6od23BMrOQZi+6pdAPbeQqdW
         UM5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=PUsqmIg3cIcSF+Cp7vaRpt/1dPSTTn7gEPcc2Xary6E=;
        b=1GNm3Ks6QP2lWhpm0njGQM3th3QGSuZG9Mlr+ce0mDHM/RCBTZSpFsiW4+oZ86oB6a
         u/rxY4Gl72iI6JjH0ZDzhSPl1docVKIEQfiRM2fIzBX2q/1GOo2xUGq36F9HWwG7fVkm
         VOB3gHYs3Ulwd60TB1SOCgfkviTfgCFhnaCG5b5Rkv1Bx3BaTBf4nkWeRE+uZM8rKRh6
         C61ZqeVRnc6H4JaaOCzEW5GSc/xpWv45lIjwqM52QAgGzioMH9R/SaI9Wg8NkITrfvlU
         zaS1XZtX4NuO7A+rlFFMDCdihki8ax3wDab/TXExzRHWNn9taqRmKxpdx3qvKXnBIhYc
         erZQ==
X-Gm-Message-State: ACrzQf06gxAbLhLCwZ2tc5YNOqny2Uy/eQOrDyvF5lri9CWgyzIvxrFD
        XfEvNFTpuRvRNRMzRHHM3nfoFQ==
X-Google-Smtp-Source: AMsMyM6uPHirnxklzk6x2FpMaZTWeW0uAexukVAmvQnnMk34Js6rpYqs+vys+ZjZmaK137I9mL6/ww==
X-Received: by 2002:a05:600c:1910:b0:3b4:bb80:c951 with SMTP id j16-20020a05600c191000b003b4bb80c951mr10039175wmq.81.1663858719300;
        Thu, 22 Sep 2022 07:58:39 -0700 (PDT)
Received: from zen.linaroharston ([185.81.254.11])
        by smtp.gmail.com with ESMTPSA id u10-20020a05600c210a00b003b50428cf66sm1894688wml.33.2022.09.22.07.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 07:58:36 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 53D961FFC0;
        Thu, 22 Sep 2022 15:58:33 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     f4bug@amsat.org, mads@ynddal.dk,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH  v1 8/9] gdbstub: move breakpoint logic to accel ops
Date:   Thu, 22 Sep 2022 15:58:31 +0100
Message-Id: <20220922145832.1934429-9-alex.bennee@linaro.org>
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

As HW virtualization requires specific support to handle breakpoints
lets push out special casing out of the core gdbstub code and into
AccelOpsClass. This will make it easier to add other accelerator
support and reduces some of the stub shenanigans.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Mads Ynddal <mads@ynddal.dk>
---
 accel/kvm/kvm-cpus.h       |   3 +
 gdbstub/internals.h        |  16 +++++
 include/sysemu/accel-ops.h |   6 ++
 include/sysemu/cpus.h      |   3 +
 include/sysemu/kvm.h       |   5 --
 accel/kvm/kvm-accel-ops.c  |   8 +++
 accel/kvm/kvm-all.c        |  24 +------
 accel/stubs/kvm-stub.c     |  16 -----
 accel/tcg/tcg-accel-ops.c  |  92 +++++++++++++++++++++++++++
 gdbstub/gdbstub.c          | 127 +++----------------------------------
 gdbstub/softmmu.c          |  42 ++++++++++++
 gdbstub/user.c             |  62 ++++++++++++++++++
 softmmu/cpus.c             |   7 ++
 gdbstub/meson.build        |   8 +++
 14 files changed, 259 insertions(+), 160 deletions(-)
 create mode 100644 gdbstub/internals.h
 create mode 100644 gdbstub/softmmu.c
 create mode 100644 gdbstub/user.c

diff --git a/accel/kvm/kvm-cpus.h b/accel/kvm/kvm-cpus.h
index bf0bd1bee4..33e435d62b 100644
--- a/accel/kvm/kvm-cpus.h
+++ b/accel/kvm/kvm-cpus.h
@@ -18,5 +18,8 @@ void kvm_destroy_vcpu(CPUState *cpu);
 void kvm_cpu_synchronize_post_reset(CPUState *cpu);
 void kvm_cpu_synchronize_post_init(CPUState *cpu);
 void kvm_cpu_synchronize_pre_loadvm(CPUState *cpu);
+int kvm_insert_breakpoint(CPUState *cpu, int type, hwaddr addr, hwaddr len);
+int kvm_remove_breakpoint(CPUState *cpu, int type, hwaddr addr, hwaddr len);
+void kvm_remove_all_breakpoints(CPUState *cpu);
 
 #endif /* KVM_CPUS_H */
diff --git a/gdbstub/internals.h b/gdbstub/internals.h
new file mode 100644
index 0000000000..41e2e72dbf
--- /dev/null
+++ b/gdbstub/internals.h
@@ -0,0 +1,16 @@
+/*
+ * gdbstub internals
+ *
+ * Copyright (c) 2022 Linaro Ltd
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#ifndef _INTERNALS_H_
+#define _INTERNALS_H_
+
+int gdb_breakpoint_insert(CPUState *cs, int type, hwaddr addr, hwaddr len);
+int gdb_breakpoint_remove(CPUState *cs, int type, hwaddr addr, hwaddr len);
+void gdb_breakpoint_remove_all(CPUState *cs);
+
+#endif /* _INTERNALS_H_ */
diff --git a/include/sysemu/accel-ops.h b/include/sysemu/accel-ops.h
index a0572ea87a..86794ac273 100644
--- a/include/sysemu/accel-ops.h
+++ b/include/sysemu/accel-ops.h
@@ -10,6 +10,7 @@
 #ifndef ACCEL_OPS_H
 #define ACCEL_OPS_H
 
+#include "exec/hwaddr.h"
 #include "qom/object.h"
 
 #define ACCEL_OPS_SUFFIX "-ops"
@@ -44,6 +45,11 @@ struct AccelOpsClass {
 
     int64_t (*get_virtual_clock)(void);
     int64_t (*get_elapsed_ticks)(void);
+
+    /* gdbstub hooks */
+    int (*insert_breakpoint)(CPUState *cpu, int type, hwaddr addr, hwaddr len);
+    int (*remove_breakpoint)(CPUState *cpu, int type, hwaddr addr, hwaddr len);
+    void (*remove_all_breakpoints)(CPUState *cpu);
 };
 
 #endif /* ACCEL_OPS_H */
diff --git a/include/sysemu/cpus.h b/include/sysemu/cpus.h
index b5c87d48b3..1bace3379b 100644
--- a/include/sysemu/cpus.h
+++ b/include/sysemu/cpus.h
@@ -7,6 +7,9 @@
 /* register accel-specific operations */
 void cpus_register_accel(const AccelOpsClass *i);
 
+/* return registers ops */
+const AccelOpsClass *cpus_get_accel(void);
+
 /* accel/dummy-cpus.c */
 
 /* Create a dummy vcpu for AccelOpsClass->create_vcpu_thread */
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index a20ad51aad..21d3f1d01e 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -254,11 +254,6 @@ int kvm_on_sigbus(int code, void *addr);
 
 void kvm_flush_coalesced_mmio_buffer(void);
 
-int kvm_insert_breakpoint(CPUState *cpu, target_ulong addr,
-                          target_ulong len, int type);
-int kvm_remove_breakpoint(CPUState *cpu, target_ulong addr,
-                          target_ulong len, int type);
-void kvm_remove_all_breakpoints(CPUState *cpu);
 int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap);
 
 /* internal API */
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index c4244a23c6..5c0e37514c 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -16,12 +16,14 @@
 #include "qemu/osdep.h"
 #include "qemu/error-report.h"
 #include "qemu/main-loop.h"
+#include "sysemu/kvm.h"
 #include "sysemu/kvm_int.h"
 #include "sysemu/runstate.h"
 #include "sysemu/cpus.h"
 #include "qemu/guest-random.h"
 #include "qapi/error.h"
 
+#include <linux/kvm.h>
 #include "kvm-cpus.h"
 
 static void *kvm_vcpu_thread_fn(void *arg)
@@ -95,6 +97,12 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, void *data)
     ops->synchronize_post_init = kvm_cpu_synchronize_post_init;
     ops->synchronize_state = kvm_cpu_synchronize_state;
     ops->synchronize_pre_loadvm = kvm_cpu_synchronize_pre_loadvm;
+
+#ifdef KVM_CAP_SET_GUEST_DEBUG
+    ops->insert_breakpoint = kvm_insert_breakpoint;
+    ops->remove_breakpoint = kvm_remove_breakpoint;
+    ops->remove_all_breakpoints = kvm_remove_all_breakpoints;
+#endif
 }
 
 static const TypeInfo kvm_accel_ops_type = {
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index c55938453a..b8c734fe3a 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3287,8 +3287,7 @@ int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap)
     return data.err;
 }
 
-int kvm_insert_breakpoint(CPUState *cpu, target_ulong addr,
-                          target_ulong len, int type)
+int kvm_insert_breakpoint(CPUState *cpu, int type, hwaddr addr, hwaddr len)
 {
     struct kvm_sw_breakpoint *bp;
     int err;
@@ -3326,8 +3325,7 @@ int kvm_insert_breakpoint(CPUState *cpu, target_ulong addr,
     return 0;
 }
 
-int kvm_remove_breakpoint(CPUState *cpu, target_ulong addr,
-                          target_ulong len, int type)
+int kvm_remove_breakpoint(CPUState *cpu, int type, hwaddr addr, hwaddr len)
 {
     struct kvm_sw_breakpoint *bp;
     int err;
@@ -3393,26 +3391,10 @@ void kvm_remove_all_breakpoints(CPUState *cpu)
 
 #else /* !KVM_CAP_SET_GUEST_DEBUG */
 
-int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap)
+static int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap)
 {
     return -EINVAL;
 }
-
-int kvm_insert_breakpoint(CPUState *cpu, target_ulong addr,
-                          target_ulong len, int type)
-{
-    return -EINVAL;
-}
-
-int kvm_remove_breakpoint(CPUState *cpu, target_ulong addr,
-                          target_ulong len, int type)
-{
-    return -EINVAL;
-}
-
-void kvm_remove_all_breakpoints(CPUState *cpu)
-{
-}
 #endif /* !KVM_CAP_SET_GUEST_DEBUG */
 
 static int kvm_set_signal_mask(CPUState *cpu, const sigset_t *sigset)
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 2ac5f9c036..2d79333143 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -51,22 +51,6 @@ int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap)
     return -ENOSYS;
 }
 
-int kvm_insert_breakpoint(CPUState *cpu, target_ulong addr,
-                          target_ulong len, int type)
-{
-    return -EINVAL;
-}
-
-int kvm_remove_breakpoint(CPUState *cpu, target_ulong addr,
-                          target_ulong len, int type)
-{
-    return -EINVAL;
-}
-
-void kvm_remove_all_breakpoints(CPUState *cpu)
-{
-}
-
 int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr)
 {
     return 1;
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 786d90c08f..965c2ad581 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -32,6 +32,8 @@
 #include "qemu/main-loop.h"
 #include "qemu/guest-random.h"
 #include "exec/exec-all.h"
+#include "exec/hwaddr.h"
+#include "exec/gdbstub.h"
 
 #include "tcg-accel-ops.h"
 #include "tcg-accel-ops-mttcg.h"
@@ -91,6 +93,92 @@ void tcg_handle_interrupt(CPUState *cpu, int mask)
     }
 }
 
+/* Translate GDB watchpoint type to a flags value for cpu_watchpoint_* */
+static inline int xlat_gdb_type(CPUState *cpu, int gdbtype)
+{
+    static const int xlat[] = {
+        [GDB_WATCHPOINT_WRITE]  = BP_GDB | BP_MEM_WRITE,
+        [GDB_WATCHPOINT_READ]   = BP_GDB | BP_MEM_READ,
+        [GDB_WATCHPOINT_ACCESS] = BP_GDB | BP_MEM_ACCESS,
+    };
+
+    CPUClass *cc = CPU_GET_CLASS(cpu);
+    int cputype = xlat[gdbtype];
+
+    if (cc->gdb_stop_before_watchpoint) {
+        cputype |= BP_STOP_BEFORE_ACCESS;
+    }
+    return cputype;
+}
+
+static int tcg_insert_breakpoint(CPUState *cs, int type, hwaddr addr, hwaddr len)
+{
+    CPUState *cpu;
+    int err = 0;
+
+    switch (type) {
+    case GDB_BREAKPOINT_SW:
+    case GDB_BREAKPOINT_HW:
+        CPU_FOREACH(cpu) {
+            err = cpu_breakpoint_insert(cpu, addr, BP_GDB, NULL);
+            if (err) {
+                break;
+            }
+        }
+        return err;
+    case GDB_WATCHPOINT_WRITE:
+    case GDB_WATCHPOINT_READ:
+    case GDB_WATCHPOINT_ACCESS:
+        CPU_FOREACH(cpu) {
+            err = cpu_watchpoint_insert(cpu, addr, len,
+                                        xlat_gdb_type(cpu, type), NULL);
+            if (err) {
+                break;
+            }
+        }
+        return err;
+    default:
+        return -ENOSYS;
+    }
+}
+
+static int tcg_remove_breakpoint(CPUState *cs, int type, hwaddr addr, hwaddr len)
+{
+    CPUState *cpu;
+    int err = 0;
+
+    switch (type) {
+    case GDB_BREAKPOINT_SW:
+    case GDB_BREAKPOINT_HW:
+        CPU_FOREACH(cpu) {
+            err = cpu_breakpoint_remove(cpu, addr, BP_GDB);
+            if (err) {
+                break;
+            }
+        }
+        return err;
+    case GDB_WATCHPOINT_WRITE:
+    case GDB_WATCHPOINT_READ:
+    case GDB_WATCHPOINT_ACCESS:
+        CPU_FOREACH(cpu) {
+            err = cpu_watchpoint_remove(cpu, addr, len,
+                                        xlat_gdb_type(cpu, type));
+            if (err) {
+                break;
+            }
+        }
+        return err;
+    default:
+        return -ENOSYS;
+    }
+}
+
+static inline void tcg_remove_all_breakpoints(CPUState *cpu)
+{
+    cpu_breakpoint_remove_all(cpu, BP_GDB);
+    cpu_watchpoint_remove_all(cpu, BP_GDB);
+}
+
 static void tcg_accel_ops_init(AccelOpsClass *ops)
 {
     if (qemu_tcg_mttcg_enabled()) {
@@ -109,6 +197,10 @@ static void tcg_accel_ops_init(AccelOpsClass *ops)
             ops->handle_interrupt = tcg_handle_interrupt;
         }
     }
+
+    ops->insert_breakpoint = tcg_insert_breakpoint;
+    ops->remove_breakpoint = tcg_remove_breakpoint;
+    ops->remove_all_breakpoints = tcg_remove_all_breakpoints;
 }
 
 static void tcg_accel_ops_class_init(ObjectClass *oc, void *data)
diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index a0755e6505..ff9f3f9586 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -49,8 +49,11 @@
 #include "sysemu/runstate.h"
 #include "semihosting/semihost.h"
 #include "exec/exec-all.h"
+#include "exec/hwaddr.h"
 #include "sysemu/replay.h"
 
+#include "internals.h"
+
 #ifdef CONFIG_USER_ONLY
 #define GDB_ATTACHED "0"
 #else
@@ -1012,130 +1015,16 @@ void gdb_register_coprocessor(CPUState *cpu,
     }
 }
 
-#ifndef CONFIG_USER_ONLY
-/* Translate GDB watchpoint type to a flags value for cpu_watchpoint_* */
-static inline int xlat_gdb_type(CPUState *cpu, int gdbtype)
-{
-    static const int xlat[] = {
-        [GDB_WATCHPOINT_WRITE]  = BP_GDB | BP_MEM_WRITE,
-        [GDB_WATCHPOINT_READ]   = BP_GDB | BP_MEM_READ,
-        [GDB_WATCHPOINT_ACCESS] = BP_GDB | BP_MEM_ACCESS,
-    };
-
-    CPUClass *cc = CPU_GET_CLASS(cpu);
-    int cputype = xlat[gdbtype];
-
-    if (cc->gdb_stop_before_watchpoint) {
-        cputype |= BP_STOP_BEFORE_ACCESS;
-    }
-    return cputype;
-}
-#endif
-
-static int gdb_breakpoint_insert(int type, target_ulong addr, target_ulong len)
-{
-    CPUState *cpu;
-    int err = 0;
-
-    if (kvm_enabled()) {
-        return kvm_insert_breakpoint(gdbserver_state.c_cpu, addr, len, type);
-    }
-
-    switch (type) {
-    case GDB_BREAKPOINT_SW:
-    case GDB_BREAKPOINT_HW:
-        CPU_FOREACH(cpu) {
-            err = cpu_breakpoint_insert(cpu, addr, BP_GDB, NULL);
-            if (err) {
-                break;
-            }
-        }
-        return err;
-#ifndef CONFIG_USER_ONLY
-    case GDB_WATCHPOINT_WRITE:
-    case GDB_WATCHPOINT_READ:
-    case GDB_WATCHPOINT_ACCESS:
-        CPU_FOREACH(cpu) {
-            err = cpu_watchpoint_insert(cpu, addr, len,
-                                        xlat_gdb_type(cpu, type), NULL);
-            if (err) {
-                break;
-            }
-        }
-        return err;
-#endif
-    default:
-        return -ENOSYS;
-    }
-}
-
-static int gdb_breakpoint_remove(int type, target_ulong addr, target_ulong len)
-{
-    CPUState *cpu;
-    int err = 0;
-
-    if (kvm_enabled()) {
-        return kvm_remove_breakpoint(gdbserver_state.c_cpu, addr, len, type);
-    }
-
-    switch (type) {
-    case GDB_BREAKPOINT_SW:
-    case GDB_BREAKPOINT_HW:
-        CPU_FOREACH(cpu) {
-            err = cpu_breakpoint_remove(cpu, addr, BP_GDB);
-            if (err) {
-                break;
-            }
-        }
-        return err;
-#ifndef CONFIG_USER_ONLY
-    case GDB_WATCHPOINT_WRITE:
-    case GDB_WATCHPOINT_READ:
-    case GDB_WATCHPOINT_ACCESS:
-        CPU_FOREACH(cpu) {
-            err = cpu_watchpoint_remove(cpu, addr, len,
-                                        xlat_gdb_type(cpu, type));
-            if (err)
-                break;
-        }
-        return err;
-#endif
-    default:
-        return -ENOSYS;
-    }
-}
-
-static inline void gdb_cpu_breakpoint_remove_all(CPUState *cpu)
-{
-    cpu_breakpoint_remove_all(cpu, BP_GDB);
-#ifndef CONFIG_USER_ONLY
-    cpu_watchpoint_remove_all(cpu, BP_GDB);
-#endif
-}
-
 static void gdb_process_breakpoint_remove_all(GDBProcess *p)
 {
     CPUState *cpu = get_first_cpu_in_process(p);
 
     while (cpu) {
-        gdb_cpu_breakpoint_remove_all(cpu);
+        gdb_breakpoint_remove_all(cpu);
         cpu = gdb_next_cpu_in_process(cpu);
     }
 }
 
-static void gdb_breakpoint_remove_all(void)
-{
-    CPUState *cpu;
-
-    if (kvm_enabled()) {
-        kvm_remove_all_breakpoints(gdbserver_state.c_cpu);
-        return;
-    }
-
-    CPU_FOREACH(cpu) {
-        gdb_cpu_breakpoint_remove_all(cpu);
-    }
-}
 
 static void gdb_set_cpu_pc(target_ulong pc)
 {
@@ -1667,7 +1556,8 @@ static void handle_insert_bp(GArray *params, void *user_ctx)
         return;
     }
 
-    res = gdb_breakpoint_insert(get_param(params, 0)->val_ul,
+    res = gdb_breakpoint_insert(gdbserver_state.c_cpu,
+                                get_param(params, 0)->val_ul,
                                 get_param(params, 1)->val_ull,
                                 get_param(params, 2)->val_ull);
     if (res >= 0) {
@@ -1690,7 +1580,8 @@ static void handle_remove_bp(GArray *params, void *user_ctx)
         return;
     }
 
-    res = gdb_breakpoint_remove(get_param(params, 0)->val_ul,
+    res = gdb_breakpoint_remove(gdbserver_state.c_cpu,
+                                get_param(params, 0)->val_ul,
                                 get_param(params, 1)->val_ull,
                                 get_param(params, 2)->val_ull);
     if (res >= 0) {
@@ -2541,7 +2432,7 @@ static void handle_target_halt(GArray *params, void *user_ctx)
      * because gdb is doing an initial connect and the state
      * should be cleaned up.
      */
-    gdb_breakpoint_remove_all();
+    gdb_breakpoint_remove_all(gdbserver_state.c_cpu);
 }
 
 static int gdb_handle_packet(const char *line_buf)
diff --git a/gdbstub/softmmu.c b/gdbstub/softmmu.c
new file mode 100644
index 0000000000..4e73890379
--- /dev/null
+++ b/gdbstub/softmmu.c
@@ -0,0 +1,42 @@
+/*
+ * gdb server stub - softmmu specific bits
+ *
+ * Debug integration depends on support from the individual
+ * accelerators so most of this involves calling the ops helpers.
+ *
+ * Copyright (c) 2022 Linaro Ltd
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "exec/gdbstub.h"
+#include "exec/hwaddr.h"
+#include "sysemu/cpus.h"
+#include "internals.h"
+
+int gdb_breakpoint_insert(CPUState *cs, int type, hwaddr addr, hwaddr len)
+{
+    const AccelOpsClass *ops = cpus_get_accel();
+    if (ops->insert_breakpoint) {
+        return ops->insert_breakpoint(cs, type, addr, len);
+    }
+    return -ENOSYS;
+}
+
+int gdb_breakpoint_remove(CPUState *cs, int type, hwaddr addr, hwaddr len)
+{
+    const AccelOpsClass *ops = cpus_get_accel();
+    if (ops->remove_breakpoint) {
+        return ops->remove_breakpoint(cs, type, addr, len);
+    }
+    return -ENOSYS;
+}
+
+void gdb_breakpoint_remove_all(CPUState *cs)
+{
+    const AccelOpsClass *ops = cpus_get_accel();
+    if (ops->remove_all_breakpoints) {
+        ops->remove_all_breakpoints(cs);
+    }
+}
diff --git a/gdbstub/user.c b/gdbstub/user.c
new file mode 100644
index 0000000000..42652b28a7
--- /dev/null
+++ b/gdbstub/user.c
@@ -0,0 +1,62 @@
+/*
+ * gdbstub user-mode helper routines.
+ *
+ * We know for user-mode we are using TCG so we can call stuff directly.
+ *
+ * Copyright (c) 2022 Linaro Ltd
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "exec/hwaddr.h"
+#include "exec/gdbstub.h"
+#include "hw/core/cpu.h"
+#include "internals.h"
+
+int gdb_breakpoint_insert(CPUState *cs, int type, hwaddr addr, hwaddr len)
+{
+    CPUState *cpu;
+    int err = 0;
+
+    switch (type) {
+    case GDB_BREAKPOINT_SW:
+    case GDB_BREAKPOINT_HW:
+        CPU_FOREACH(cpu) {
+            err = cpu_breakpoint_insert(cpu, addr, BP_GDB, NULL);
+            if (err) {
+                break;
+            }
+        }
+        return err;
+    default:
+        /* user-mode doesn't support watchpoints */
+        return -ENOSYS;
+    }
+}
+
+int gdb_breakpoint_remove(CPUState *cs, int type, hwaddr addr, hwaddr len)
+{
+    CPUState *cpu;
+    int err = 0;
+
+    switch (type) {
+    case GDB_BREAKPOINT_SW:
+    case GDB_BREAKPOINT_HW:
+        CPU_FOREACH(cpu) {
+            err = cpu_breakpoint_remove(cpu, addr, BP_GDB);
+            if (err) {
+                break;
+            }
+        }
+        return err;
+    default:
+        /* user-mode doesn't support watchpoints */
+        return -ENOSYS;
+    }
+}
+
+void gdb_breakpoint_remove_all(CPUState *cs)
+{
+    cpu_breakpoint_remove_all(cs, BP_GDB);
+}
diff --git a/softmmu/cpus.c b/softmmu/cpus.c
index 23b30484b2..61b27ff59d 100644
--- a/softmmu/cpus.c
+++ b/softmmu/cpus.c
@@ -617,6 +617,13 @@ void cpus_register_accel(const AccelOpsClass *ops)
     cpus_accel = ops;
 }
 
+const AccelOpsClass *cpus_get_accel(void)
+{
+    /* broken if we call this early */
+    assert(cpus_accel);
+    return cpus_accel;
+}
+
 void qemu_init_vcpu(CPUState *cpu)
 {
     MachineState *ms = MACHINE(qdev_get_machine());
diff --git a/gdbstub/meson.build b/gdbstub/meson.build
index 6d4ae2d03c..fc895a2c39 100644
--- a/gdbstub/meson.build
+++ b/gdbstub/meson.build
@@ -1 +1,9 @@
+#
+# The main gdbstub still relies on per-build definitions of various
+# types. The bits pushed to softmmu/user.c try to use guest agnostic
+# types such as hwaddr.
+#
+
 specific_ss.add(files('gdbstub.c'))
+softmmu_ss.add(files('softmmu.c'))
+user_ss.add(files('user.c'))
-- 
2.34.1

