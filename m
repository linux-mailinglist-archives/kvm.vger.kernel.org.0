Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A6A39BE3D
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhFDRO3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhFDRO2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:14:28 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDB2C061766
        for <kvm@vger.kernel.org>; Fri,  4 Jun 2021 10:12:42 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id a11so8145854wrt.13
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 10:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0qK3PtK1ZJ0cptr2WVdMdlRn0V00pOzTguQ/XpJv0Nw=;
        b=WOjKAbtaYFNBmEFh1M3XN+TY7WR2aqCgcVLpDVHxXUhaCzd27M2HH848aV1XyL/XDW
         AmHZMagjIFUZuz0nT9LTUVm5OLZDWiUV4m/qDk2ReDfP6yFVsPqypVLIZmjfTKOSbnvC
         2+Rl7ubJHcfF1U34Ess78woUEKrPogtxwFHAhd3kX8/BMJdE+qilgxav1+lcYWRs84db
         vRUYg3+oHhotH3p5gvle/B7MhlVYtupYPliOVC4zrydyHGnBO11QRYR3cXPYXnYarYQN
         N2bNXmGWbLXnquDq1TsG61jB08krHwffBEH4w4NJLmz15bWihIXTU4+IefOa1q/OlTQe
         4cVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0qK3PtK1ZJ0cptr2WVdMdlRn0V00pOzTguQ/XpJv0Nw=;
        b=kTiR/lDQN27rNz3NSIPC+4Yp3U7qsU0GCmy9JhQs0TabVMwHdT94cKmIhOP+/JsE5W
         Etxrl2aOk+qH8MtrylpfXtkdXbXD4sA58MazahG5xH1cPWDaCKtOlwQLgBB0W5Z5YqK9
         OWB51k11gJ6lp1VAYMLU2JCKN00erDZ7DijTjhLT5/9oCFJ09M314r5qUkfDUvAr37fz
         H/9A0P0TbDtUzTApnTn9znFLKpuH46csA45dY1H8/tiGCGXTwAKUFmVDnx6sAutLE/J3
         3q0O7ZlkfMoqhyJRSy3zkLOgLNWJbV45PBdNgHded1fw8l6kMbMVeQAMIhYrm2Zu+2tf
         71ZQ==
X-Gm-Message-State: AOAM5320WAjynF4CbPblOiKlg4WL+YOEg5YRJmAx5+1hYc5ZHO5Pgoy/
        qvXDcpeR/JKOuavtQ/soFFmleA==
X-Google-Smtp-Source: ABdhPJzSOvopO0cd+MEhvR1zsEEWKzvT9HTOJinmq+Ys5Nkqor5ZEJ8qjUqDXMhSsQjnv8zbDmSbRA==
X-Received: by 2002:adf:f78d:: with SMTP id q13mr4878148wrp.191.1622826760625;
        Fri, 04 Jun 2021 10:12:40 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id q3sm7211868wrr.43.2021.06.04.10.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 10:12:38 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id C96491FF9D;
        Fri,  4 Jun 2021 16:53:13 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     qemu-arm@nongnu.org, Claudio Fontana <cfontana@suse.de>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org (open list:X86 KVM CPUs)
Subject: [PATCH  v16 14/99] accel: add cpu_reset
Date:   Fri,  4 Jun 2021 16:51:47 +0100
Message-Id: <20210604155312.15902-15-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210604155312.15902-1-alex.bennee@linaro.org>
References: <20210604155312.15902-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Fontana <cfontana@suse.de>

in cpu_reset(), implemented in the common cpu.c,
add a call to a new accel_cpu_reset(), which ensures that the CPU accel
interface is also reset when the CPU is reset.

Use this first for x86/kvm, simply moving the kvm_arch_reset_vcpu() call.

Signed-off-by: Claudio Fontana <cfontana@suse.de>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/hw/core/accel-cpu.h | 2 ++
 include/qemu/accel.h        | 6 ++++++
 accel/accel-common.c        | 9 +++++++++
 hw/core/cpu-common.c        | 3 ++-
 target/i386/cpu.c           | 4 ----
 target/i386/kvm/kvm-cpu.c   | 6 ++++++
 6 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/include/hw/core/accel-cpu.h b/include/hw/core/accel-cpu.h
index 5dbfd79955..700a5bd266 100644
--- a/include/hw/core/accel-cpu.h
+++ b/include/hw/core/accel-cpu.h
@@ -33,6 +33,8 @@ typedef struct AccelCPUClass {
     void (*cpu_class_init)(CPUClass *cc);
     void (*cpu_instance_init)(CPUState *cpu);
     bool (*cpu_realizefn)(CPUState *cpu, Error **errp);
+    void (*cpu_reset)(CPUState *cpu);
+
 } AccelCPUClass;
 
 #endif /* ACCEL_CPU_H */
diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index 4f4c283f6f..8d3a15b916 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -91,4 +91,10 @@ void accel_cpu_instance_init(CPUState *cpu);
  */
 bool accel_cpu_realizefn(CPUState *cpu, Error **errp);
 
+/**
+ * accel_cpu_reset:
+ * @cpu: The CPU that needs to call accel-specific reset.
+ */
+void accel_cpu_reset(CPUState *cpu);
+
 #endif /* QEMU_ACCEL_H */
diff --git a/accel/accel-common.c b/accel/accel-common.c
index cf07f78421..3331a9dcfd 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -121,6 +121,15 @@ bool accel_cpu_realizefn(CPUState *cpu, Error **errp)
     return true;
 }
 
+void accel_cpu_reset(CPUState *cpu)
+{
+    CPUClass *cc = CPU_GET_CLASS(cpu);
+
+    if (cc->accel_cpu && cc->accel_cpu->cpu_reset) {
+        cc->accel_cpu->cpu_reset(cpu);
+    }
+}
+
 static const TypeInfo accel_cpu_type = {
     .name = TYPE_ACCEL_CPU,
     .parent = TYPE_OBJECT,
diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index e2f5a64604..ab258ad4f2 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -34,6 +34,7 @@
 #include "hw/qdev-properties.h"
 #include "trace/trace-root.h"
 #include "qemu/plugin.h"
+#include "qemu/accel.h"
 
 CPUState *cpu_by_arch_id(int64_t id)
 {
@@ -112,7 +113,7 @@ void cpu_dump_state(CPUState *cpu, FILE *f, int flags)
 void cpu_reset(CPUState *cpu)
 {
     device_cold_reset(DEVICE(cpu));
-
+    accel_cpu_reset(cpu);
     trace_guest_cpu_reset(cpu);
 }
 
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index e0ba36cc23..0c22324daf 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5749,10 +5749,6 @@ static void x86_cpu_reset(DeviceState *dev)
     apic_designate_bsp(cpu->apic_state, s->cpu_index == 0);
 
     s->halted = !cpu_is_bsp(cpu);
-
-    if (kvm_enabled()) {
-        kvm_arch_reset_vcpu(cpu);
-    }
 #endif
 }
 
diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index 5235bce8dc..63410d3f18 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -135,12 +135,18 @@ static void kvm_cpu_instance_init(CPUState *cs)
     }
 }
 
+static void kvm_cpu_reset(CPUState *cpu)
+{
+    kvm_arch_reset_vcpu(X86_CPU(cpu));
+}
+
 static void kvm_cpu_accel_class_init(ObjectClass *oc, void *data)
 {
     AccelCPUClass *acc = ACCEL_CPU_CLASS(oc);
 
     acc->cpu_realizefn = kvm_cpu_realizefn;
     acc->cpu_instance_init = kvm_cpu_instance_init;
+    acc->cpu_reset = kvm_cpu_reset;
 }
 static const TypeInfo kvm_cpu_accel_type_info = {
     .name = ACCEL_CPU_NAME("kvm"),
-- 
2.20.1

