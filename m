Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB2B6AF79A
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 22:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbjCGV32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 16:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCGV31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 16:29:27 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306CC9B2F8
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 13:29:25 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id l7-20020a05600c1d0700b003eb5e6d906bso11567wms.5
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 13:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678224563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=az0WJvPDNNwX+FS1YDgiZdT4GlD39LjQSPuXXv/AFss=;
        b=X8/+OESFJ/59vp1KnCfhSQMVc4y9MfHJ1PtgU66865g0nHK5+V1HlHQWYRwvlAdvcE
         CP3sl3WusiFeZY3OxBbRItGbi6k3Q0AskfAQfRPe3QqAvorGatbKxLHuM1RIiCuINrt9
         FPCAJexAAuIlWTIf0mCZea+BZVx89Z07Suc5PxUAdC/6kw/a6bZJwqMe9v7VD042ITif
         atC4tOTXbLf5D8To5/EB3/guJ7AioWcw7XgLwP8Pffx4dUjKe4U2T4C3i/Le850+fwJq
         wvLYP3/qbHBzZwAF4QZd4WWz2y2kcFjn+p2M6Y5Zgw8VoZHFCIAMDPPz/NGPny8QSN+x
         iT/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678224563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=az0WJvPDNNwX+FS1YDgiZdT4GlD39LjQSPuXXv/AFss=;
        b=SCrZAaHUTDABqlFRbb7TQhMPQvzDKKYCURUuPUoSJclRodSwqLg8PKcbVCcqPpnDv5
         cbLblRHi3oviT6CtWnDop+KLF4QdJhD9Z6oTR/AIblG1h7fkjRgk3D6TuyHvirNk9I7E
         yoGz5ttInFvJl9X22IFpPuThr/z9Mba/B8/q6lQAiC4uiBon/Qhfmyu9JdMqkcfyQzCJ
         GEOonawTbj30bXlVcH4MyfKpu7LS4Ims+zgdUWZT7G37UkcAk7ex4Lp0yxTshy502TfB
         Y2NAEDxXazDKVuqK9czvgZkK074TQLpMjvCM0Lm0oJ+8A+2hC0P8bqi7OKl35Nk80cK0
         OS4A==
X-Gm-Message-State: AO0yUKXf5CaGTcrF4csgeltodspYbhsN6TtC5ZBOxd2krcuuxkQnbbSS
        pQLnrFrc+A0LUOTYm3/BTeRiXQ==
X-Google-Smtp-Source: AK7set9QpGb6yzdMSpwYT/XsB7GsKcFjLK2kPKxVD0+k/OnaR1peINeXBezOS2vxvW0y/wHw2Y5H3Q==
X-Received: by 2002:a05:600c:470b:b0:3e0:98c:dd93 with SMTP id v11-20020a05600c470b00b003e0098cdd93mr14730509wmo.29.1678224563728;
        Tue, 07 Mar 2023 13:29:23 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id h19-20020a05600c30d300b003db06224953sm13475987wmn.41.2023.03.07.13.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 13:29:22 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 75A4D1FFDA;
        Tue,  7 Mar 2023 21:21:43 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     peter.maydell@linaro.org, Mads Ynddal <m.ynddal@samsung.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PULL 30/30] gdbstub: move update guest debug to accel ops
Date:   Tue,  7 Mar 2023 21:21:39 +0000
Message-Id: <20230307212139.883112-31-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307212139.883112-1-alex.bennee@linaro.org>
References: <20230307212139.883112-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mads Ynddal <m.ynddal@samsung.com>

Continuing the refactor of a48e7d9e52 (gdbstub: move guest debug support
check to ops) by removing hardcoded kvm_enabled() from generic cpu.c
code, and replace it with a property of AccelOpsClass.

Signed-off-by: Mads Ynddal <m.ynddal@samsung.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <20230207131721.49233-1-mads@ynddal.dk>
[AJB: add ifdef around update_guest_debug_ops, fix brace]
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20230302190846.2593720-27-alex.bennee@linaro.org>
Message-Id: <20230303025805.625589-30-richard.henderson@linaro.org>

diff --git a/include/sysemu/accel-ops.h b/include/sysemu/accel-ops.h
index 30690c71bd..3c1fab4b1e 100644
--- a/include/sysemu/accel-ops.h
+++ b/include/sysemu/accel-ops.h
@@ -48,6 +48,7 @@ struct AccelOpsClass {
 
     /* gdbstub hooks */
     bool (*supports_guest_debug)(void);
+    int (*update_guest_debug)(CPUState *cpu);
     int (*insert_breakpoint)(CPUState *cpu, int type, vaddr addr, vaddr len);
     int (*remove_breakpoint)(CPUState *cpu, int type, vaddr addr, vaddr len);
     void (*remove_all_breakpoints)(CPUState *cpu);
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index fbf4fe3497..457eafa380 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -86,6 +86,13 @@ static bool kvm_cpus_are_resettable(void)
     return !kvm_enabled() || kvm_cpu_check_are_resettable();
 }
 
+#ifdef KVM_CAP_SET_GUEST_DEBUG
+static int kvm_update_guest_debug_ops(CPUState *cpu)
+{
+    return kvm_update_guest_debug(cpu, 0);
+}
+#endif
+
 static void kvm_accel_ops_class_init(ObjectClass *oc, void *data)
 {
     AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
@@ -99,6 +106,7 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, void *data)
     ops->synchronize_pre_loadvm = kvm_cpu_synchronize_pre_loadvm;
 
 #ifdef KVM_CAP_SET_GUEST_DEBUG
+    ops->update_guest_debug = kvm_update_guest_debug_ops;
     ops->supports_guest_debug = kvm_supports_guest_debug;
     ops->insert_breakpoint = kvm_insert_breakpoint;
     ops->remove_breakpoint = kvm_remove_breakpoint;
diff --git a/cpu.c b/cpu.c
index e6abc6c76c..567b23af46 100644
--- a/cpu.c
+++ b/cpu.c
@@ -31,8 +31,8 @@
 #include "hw/core/sysemu-cpu-ops.h"
 #include "exec/address-spaces.h"
 #endif
+#include "sysemu/cpus.h"
 #include "sysemu/tcg.h"
-#include "sysemu/kvm.h"
 #include "exec/replay-core.h"
 #include "exec/cpu-common.h"
 #include "exec/exec-all.h"
@@ -326,9 +326,14 @@ void cpu_single_step(CPUState *cpu, int enabled)
 {
     if (cpu->singlestep_enabled != enabled) {
         cpu->singlestep_enabled = enabled;
-        if (kvm_enabled()) {
-            kvm_update_guest_debug(cpu, 0);
+
+#if !defined(CONFIG_USER_ONLY)
+        const AccelOpsClass *ops = cpus_get_accel();
+        if (ops->update_guest_debug) {
+            ops->update_guest_debug(cpu);
         }
+#endif
+
         trace_breakpoint_singlestep(cpu->cpu_index, enabled);
     }
 }
-- 
2.39.2

