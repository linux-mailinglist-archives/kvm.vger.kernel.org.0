Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181BB746278
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 20:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjGCSdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 14:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjGCSdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 14:33:10 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6F910EA
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 11:33:01 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3fba8e2aa52so57239835e9.1
        for <kvm@vger.kernel.org>; Mon, 03 Jul 2023 11:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688409179; x=1691001179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PGOxLTBm2WIEW81QoAtA8oraa0bxm4E+o2gYovN2EAE=;
        b=VNo9SdtBUYHnEI/XuIaX3KaxgLQ5BLqTELDREhTWy2r50ZwI+LXJufLwOgXG/V2xvr
         +29KOAwHerGfSAJtKZ+FRjL8//LawCJOnecs7SBZ7WusEt2wyMZPA7k3IgI5G24Usszl
         oDQsT/8s+vUzfU3uxCyJd9VMt8mC2XUxDX/X1lq4Xiq6VtblkDSnwSQ+UrtcJoEoohmM
         KuJxCaPmDnmFygm378PYEK0l2gyoWWPdAppwJxvzY+KTKfnpL8Qy0L3gmdJcGshqZTrK
         q/rEyKXM2hjHwZMlDF/vCgxgi0JSq8arvAa7ur2Ctci+UBh4P2BYnB/w2fLPQ85bpDYY
         Xcxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688409179; x=1691001179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PGOxLTBm2WIEW81QoAtA8oraa0bxm4E+o2gYovN2EAE=;
        b=WOHRIZ+t3NYBG6cbZMP471lgezCFor/1gZ+H3GKEHgMqc+UZhroSe+gleuq42O8uvv
         Rj/kW2k5RXBAwsjczJ82bPjTCt7sJ4LBCOym/Cfrdc/s8IUefdyl4aW7KkjkBHC/TDs6
         p5FqqTwUriGCl3UJRvfYg8y61UJ6Hi+mLHVPV6k+C50SEHRIDSiJkvzbETsOLWGCyIch
         NWHfv3kRhgHLTlSinQb4uspWG9w5AHsD6iCcqYSrADTQWM1X+gcVk8XcjNEjNc1uEnZd
         EMvAj9WnQJIRh0GS9HkGy9NlmFNWckwNB7T5fmpDZHKQU5933wQNfJ30cNSLylNSMctx
         u/IQ==
X-Gm-Message-State: AC+VfDzKY/WlIGXqmc+TnbqK7OY8IiBpIXErj+US3dKjomRbmktn4+lL
        g8fbbV6JT6U+5CppVBFHhC6Vrg==
X-Google-Smtp-Source: ACHHUZ6SDoc7ppBecA7Qb3Oa5klBjtl2z+XuKyTAqa5pn7Y1jx6lzuVygq2QFLVROUK00It6xG3+lA==
X-Received: by 2002:a05:600c:224c:b0:3fb:a5a0:6199 with SMTP id a12-20020a05600c224c00b003fba5a06199mr9904974wmm.14.1688409179803;
        Mon, 03 Jul 2023 11:32:59 -0700 (PDT)
Received: from localhost.localdomain ([176.176.178.91])
        by smtp.gmail.com with ESMTPSA id t17-20020a5d42d1000000b003143867d2ebsm2688281wrr.63.2023.07.03.11.32.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Jul 2023 11:32:59 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Beraldo Leal <bleal@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        kvm@vger.kernel.org, qemu-riscv@nongnu.org,
        Bin Meng <bin.meng@windriver.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>
Subject: [PATCH v2 11/16] target/riscv: Move sysemu-specific debug files to target/riscv/sysemu/
Date:   Mon,  3 Jul 2023 20:31:40 +0200
Message-Id: <20230703183145.24779-12-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230703183145.24779-1-philmd@linaro.org>
References: <20230703183145.24779-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/riscv/cpu.h                | 2 +-
 target/riscv/{ => sysemu}/debug.h | 0
 target/riscv/cpu_helper.c         | 2 +-
 target/riscv/{ => sysemu}/debug.c | 0
 target/riscv/meson.build          | 4 ----
 target/riscv/sysemu/meson.build   | 1 +
 6 files changed, 3 insertions(+), 6 deletions(-)
 rename target/riscv/{ => sysemu}/debug.h (100%)
 rename target/riscv/{ => sysemu}/debug.c (100%)

diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index e6a8087022..f9754013a8 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -89,7 +89,7 @@ typedef enum {
 
 #if !defined(CONFIG_USER_ONLY)
 #include "sysemu/pmp.h"
-#include "debug.h"
+#include "sysemu/debug.h"
 #endif
 
 #define RV_VLEN_MAX 1024
diff --git a/target/riscv/debug.h b/target/riscv/sysemu/debug.h
similarity index 100%
rename from target/riscv/debug.h
rename to target/riscv/sysemu/debug.h
diff --git a/target/riscv/cpu_helper.c b/target/riscv/cpu_helper.c
index 6f8778c6d3..6c773000a5 100644
--- a/target/riscv/cpu_helper.c
+++ b/target/riscv/cpu_helper.c
@@ -32,7 +32,7 @@
 #include "sysemu/cpu-timers.h"
 #endif
 #include "cpu_bits.h"
-#include "debug.h"
+#include "sysemu/debug.h"
 #include "tcg/oversized-guest.h"
 
 int riscv_cpu_mmu_index(CPURISCVState *env, bool ifetch)
diff --git a/target/riscv/debug.c b/target/riscv/sysemu/debug.c
similarity index 100%
rename from target/riscv/debug.c
rename to target/riscv/sysemu/debug.c
diff --git a/target/riscv/meson.build b/target/riscv/meson.build
index 8ef47f43f9..49cdcde679 100644
--- a/target/riscv/meson.build
+++ b/target/riscv/meson.build
@@ -8,10 +8,6 @@ riscv_ss.add(files(
   'gdbstub.c',
 ))
 
-riscv_system_ss.add(files(
-  'debug.c',
-))
-
 subdir('tcg')
 subdir('sysemu')
 
diff --git a/target/riscv/sysemu/meson.build b/target/riscv/sysemu/meson.build
index 64de0256a5..e902ba2dad 100644
--- a/target/riscv/sysemu/meson.build
+++ b/target/riscv/sysemu/meson.build
@@ -1,5 +1,6 @@
 riscv_system_ss.add(files(
   'arch_dump.c',
+  'debug.c',
   'machine.c',
   'monitor.c',
   'pmp.c',
-- 
2.38.1

