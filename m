Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018A06A41CE
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 13:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjB0Mj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 07:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjB0MjX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 07:39:23 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DD71DBB8
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 04:39:17 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id h14so6055751wru.4
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 04:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KrHnIRC2jYaBC2e4yjaTMbWngYwHrNBQLzk9oe0LwQ8=;
        b=ipqan8Z/X8py+cun9tPrIy3YkCXeKQIQMGe0gQw5Ir28CoJv9qGxi0cSXXmcbFNf5x
         T7rs48cYcBcDaCa5/8oauPUl0Y4M9rTU/jZ57CJr/DHvVAohNe4svkw5ZQ/b9F9+L7IW
         4APqQnjinQhs+4yjXjjs5y4l27jUiGNo36CrTZGohJsahtX8XeAX7Zsp97D0KwLtnNZF
         l9XP/213uMwrchnQ7XixIrL86wDy0ukjlImqNLkyRukNELDBF2aT1DvHGb2a5iktnF2x
         5PRJjRGnQJi1cMURPKUT/fcDpxAzwTK+Vnlv+sYHYTA4EQ0S9FwevzcyZPm7EC/sxPUB
         Wvlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KrHnIRC2jYaBC2e4yjaTMbWngYwHrNBQLzk9oe0LwQ8=;
        b=oDFaCAJibH3WqFrBRynWM5wA3Yl2fTeQUYJ2p6UHkTi/nqITdveZqqs+feV8cm5xhl
         Mm7fXP7WqpcZN4WQ0r6VpL/k8DLjTzr6zjmTRfyJdq9+UxiUzPKE+ZFFWy9TkJHg6Sz6
         2fRl56i8r8bMzajZYPKcBNVT8V3tAD1AmV9O4BlrqvQd8q1V41H4ujfau2G2RF9vBvkk
         5hx8yPEkLcv3faRH5dzYP/m3AWPo346Hx8br5SWQaspHXH7fRvP6T2BrmsI4CZkTWWwm
         c9Ajnn5np5WdlQcmNGWKhjvCDq6JVxwpWeSGFQaQpPsjzbndjTcESCeNQsqjJz17T3dl
         dAlg==
X-Gm-Message-State: AO0yUKVV6ELJ3ELqczYZzmKJZIVto1I44ZqYy2XfPdS0HnUOjvhS03pc
        7Ofaq3asICgs6YMfigVA8NnUVA==
X-Google-Smtp-Source: AK7set+3uQ6qbyBkMLLFYEu8tvEwP6ogs6g4tYqcG8r3AVgVfN6mlbg6ABxOYVG37prkgmc5cTRGeg==
X-Received: by 2002:a05:6000:1205:b0:2c7:454:cee3 with SMTP id e5-20020a056000120500b002c70454cee3mr19747497wrx.7.1677501556499;
        Mon, 27 Feb 2023 04:39:16 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id l7-20020a5d5267000000b002c8ed82c56csm7001894wrc.116.2023.02.27.04.39.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 27 Feb 2023 04:39:15 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Fabiano Rosas <farosas@suse.de>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org
Subject: [PULL 004/123] gdbstub: Use vaddr type for generic insert/remove_breakpoint() API
Date:   Mon, 27 Feb 2023 13:36:48 +0100
Message-Id: <20230227123847.27110-5-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230227123847.27110-1-philmd@linaro.org>
References: <20230227123847.27110-1-philmd@linaro.org>
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

Both insert/remove_breakpoint() handlers are used in system and
user emulation. We can not use the 'hwaddr' type on user emulation,
we have to use 'vaddr' which is defined as "wide enough to contain
any #target_ulong virtual address".

gdbstub.c doesn't require to include "exec/hwaddr.h" anymore.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Fabiano Rosas <farosas@suse.de>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <20221216215519.5522-4-philmd@linaro.org>
---
 accel/kvm/kvm-all.c        | 4 ++--
 accel/kvm/kvm-cpus.h       | 4 ++--
 accel/tcg/tcg-accel-ops.c  | 4 ++--
 gdbstub/gdbstub.c          | 1 -
 gdbstub/internals.h        | 6 ++++--
 gdbstub/softmmu.c          | 5 ++---
 gdbstub/user.c             | 5 ++---
 include/sysemu/accel-ops.h | 6 +++---
 8 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 9b26582655..79b3d58a9c 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3305,7 +3305,7 @@ bool kvm_supports_guest_debug(void)
     return kvm_has_guest_debug;
 }
 
-int kvm_insert_breakpoint(CPUState *cpu, int type, hwaddr addr, hwaddr len)
+int kvm_insert_breakpoint(CPUState *cpu, int type, vaddr addr, vaddr len)
 {
     struct kvm_sw_breakpoint *bp;
     int err;
@@ -3343,7 +3343,7 @@ int kvm_insert_breakpoint(CPUState *cpu, int type, hwaddr addr, hwaddr len)
     return 0;
 }
 
-int kvm_remove_breakpoint(CPUState *cpu, int type, hwaddr addr, hwaddr len)
+int kvm_remove_breakpoint(CPUState *cpu, int type, vaddr addr, vaddr len)
 {
     struct kvm_sw_breakpoint *bp;
     int err;
diff --git a/accel/kvm/kvm-cpus.h b/accel/kvm/kvm-cpus.h
index fd63fe6a59..ca40add32c 100644
--- a/accel/kvm/kvm-cpus.h
+++ b/accel/kvm/kvm-cpus.h
@@ -19,8 +19,8 @@ void kvm_cpu_synchronize_post_reset(CPUState *cpu);
 void kvm_cpu_synchronize_post_init(CPUState *cpu);
 void kvm_cpu_synchronize_pre_loadvm(CPUState *cpu);
 bool kvm_supports_guest_debug(void);
-int kvm_insert_breakpoint(CPUState *cpu, int type, hwaddr addr, hwaddr len);
-int kvm_remove_breakpoint(CPUState *cpu, int type, hwaddr addr, hwaddr len);
+int kvm_insert_breakpoint(CPUState *cpu, int type, vaddr addr, vaddr len);
+int kvm_remove_breakpoint(CPUState *cpu, int type, vaddr addr, vaddr len);
 void kvm_remove_all_breakpoints(CPUState *cpu);
 
 #endif /* KVM_CPUS_H */
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 19cbf1db3a..d9228fd403 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -116,7 +116,7 @@ static inline int xlat_gdb_type(CPUState *cpu, int gdbtype)
     return cputype;
 }
 
-static int tcg_insert_breakpoint(CPUState *cs, int type, hwaddr addr, hwaddr len)
+static int tcg_insert_breakpoint(CPUState *cs, int type, vaddr addr, vaddr len)
 {
     CPUState *cpu;
     int err = 0;
@@ -147,7 +147,7 @@ static int tcg_insert_breakpoint(CPUState *cs, int type, hwaddr addr, hwaddr len
     }
 }
 
-static int tcg_remove_breakpoint(CPUState *cs, int type, hwaddr addr, hwaddr len)
+static int tcg_remove_breakpoint(CPUState *cs, int type, vaddr addr, vaddr len)
 {
     CPUState *cpu;
     int err = 0;
diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index be88ca0d71..c3fbc31123 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -48,7 +48,6 @@
 #include "sysemu/runstate.h"
 #include "semihosting/semihost.h"
 #include "exec/exec-all.h"
-#include "exec/hwaddr.h"
 #include "sysemu/replay.h"
 
 #include "internals.h"
diff --git a/gdbstub/internals.h b/gdbstub/internals.h
index eabb0341d1..b23999f951 100644
--- a/gdbstub/internals.h
+++ b/gdbstub/internals.h
@@ -9,9 +9,11 @@
 #ifndef _INTERNALS_H_
 #define _INTERNALS_H_
 
+#include "exec/cpu-common.h"
+
 bool gdb_supports_guest_debug(void);
-int gdb_breakpoint_insert(CPUState *cs, int type, hwaddr addr, hwaddr len);
-int gdb_breakpoint_remove(CPUState *cs, int type, hwaddr addr, hwaddr len);
+int gdb_breakpoint_insert(CPUState *cs, int type, vaddr addr, vaddr len);
+int gdb_breakpoint_remove(CPUState *cs, int type, vaddr addr, vaddr len);
 void gdb_breakpoint_remove_all(CPUState *cs);
 
 #endif /* _INTERNALS_H_ */
diff --git a/gdbstub/softmmu.c b/gdbstub/softmmu.c
index f208c6cf15..129575e510 100644
--- a/gdbstub/softmmu.c
+++ b/gdbstub/softmmu.c
@@ -11,7 +11,6 @@
 
 #include "qemu/osdep.h"
 #include "exec/gdbstub.h"
-#include "exec/hwaddr.h"
 #include "sysemu/cpus.h"
 #include "internals.h"
 
@@ -24,7 +23,7 @@ bool gdb_supports_guest_debug(void)
     return false;
 }
 
-int gdb_breakpoint_insert(CPUState *cs, int type, hwaddr addr, hwaddr len)
+int gdb_breakpoint_insert(CPUState *cs, int type, vaddr addr, vaddr len)
 {
     const AccelOpsClass *ops = cpus_get_accel();
     if (ops->insert_breakpoint) {
@@ -33,7 +32,7 @@ int gdb_breakpoint_insert(CPUState *cs, int type, hwaddr addr, hwaddr len)
     return -ENOSYS;
 }
 
-int gdb_breakpoint_remove(CPUState *cs, int type, hwaddr addr, hwaddr len)
+int gdb_breakpoint_remove(CPUState *cs, int type, vaddr addr, vaddr len)
 {
     const AccelOpsClass *ops = cpus_get_accel();
     if (ops->remove_breakpoint) {
diff --git a/gdbstub/user.c b/gdbstub/user.c
index 033e5fdd71..484bd8f461 100644
--- a/gdbstub/user.c
+++ b/gdbstub/user.c
@@ -9,7 +9,6 @@
  */
 
 #include "qemu/osdep.h"
-#include "exec/hwaddr.h"
 #include "exec/gdbstub.h"
 #include "hw/core/cpu.h"
 #include "internals.h"
@@ -20,7 +19,7 @@ bool gdb_supports_guest_debug(void)
     return true;
 }
 
-int gdb_breakpoint_insert(CPUState *cs, int type, hwaddr addr, hwaddr len)
+int gdb_breakpoint_insert(CPUState *cs, int type, vaddr addr, vaddr len)
 {
     CPUState *cpu;
     int err = 0;
@@ -41,7 +40,7 @@ int gdb_breakpoint_insert(CPUState *cs, int type, hwaddr addr, hwaddr len)
     }
 }
 
-int gdb_breakpoint_remove(CPUState *cs, int type, hwaddr addr, hwaddr len)
+int gdb_breakpoint_remove(CPUState *cs, int type, vaddr addr, vaddr len)
 {
     CPUState *cpu;
     int err = 0;
diff --git a/include/sysemu/accel-ops.h b/include/sysemu/accel-ops.h
index 8cc7996def..30690c71bd 100644
--- a/include/sysemu/accel-ops.h
+++ b/include/sysemu/accel-ops.h
@@ -10,7 +10,7 @@
 #ifndef ACCEL_OPS_H
 #define ACCEL_OPS_H
 
-#include "exec/hwaddr.h"
+#include "exec/cpu-common.h"
 #include "qom/object.h"
 
 #define ACCEL_OPS_SUFFIX "-ops"
@@ -48,8 +48,8 @@ struct AccelOpsClass {
 
     /* gdbstub hooks */
     bool (*supports_guest_debug)(void);
-    int (*insert_breakpoint)(CPUState *cpu, int type, hwaddr addr, hwaddr len);
-    int (*remove_breakpoint)(CPUState *cpu, int type, hwaddr addr, hwaddr len);
+    int (*insert_breakpoint)(CPUState *cpu, int type, vaddr addr, vaddr len);
+    int (*remove_breakpoint)(CPUState *cpu, int type, vaddr addr, vaddr len);
     void (*remove_all_breakpoints)(CPUState *cpu);
 };
 
-- 
2.38.1

