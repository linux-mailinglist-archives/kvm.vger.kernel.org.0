Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90BA746267
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 20:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjGCSb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 14:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbjGCSb5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 14:31:57 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F772188
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 11:31:56 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-3143b88faebso731368f8f.3
        for <kvm@vger.kernel.org>; Mon, 03 Jul 2023 11:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688409115; x=1691001115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMsBShz4C7A1YrSDPbppIGD5ps17qyWqJYLBfgbzYNs=;
        b=BC+SB7mnKNlR4pjYmT6LyjDiL3lYJfs2d1mxokhx86DjKVqazk7dx5Xza9vPiq7mei
         o3TzBlYH9DwrvGlDD8qMMno0izkWU9Fio2scqV3u6aF+YaURAfNvYk8cglpAJXiukuOr
         br6xhOGLEQTSdMXjrTm4cYPDHfJxUkrCkDh5dW/ZiDnOA1Z3IkIpjJiIZt0ixl0sJKOH
         6e61kZud+2TeRQx5cC62d+i0iuoyJ8kZRO8plfMwtyYIU0S1MTg1OH0yKB0hW8kB3z1Y
         pJRIc20NBYxuhMgpdtdIoKrIzuFCjZe+UR96E/7sqZpFCv+Js6prCUgI1LB2h9sOUFzM
         EqzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688409115; x=1691001115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tMsBShz4C7A1YrSDPbppIGD5ps17qyWqJYLBfgbzYNs=;
        b=eqkU1qj/y1CB+Gp/NnS6z8lELVq9mshBFgxvOy2HD+o0lGU1gN3o5iczH8KUgZQypW
         towyuLUmRFmWzCJgCw4UfxWui+KtISpfZ4IOpi9L81ozg8fITmzjY5qTQgynHay8tP1r
         c21S0l07Hb84p7LyUggpro1xkO3AknXm76/2eoS+yVLz3z7vMl7rqpfcNcT9duLDAM02
         M/xUBirEzFeyflh7hN3yrK6EUFUusWYMUjEDqVYbmnJ8A7rW2dF3zmXQiUXoSap5jFUb
         +EQoF9c1IjK32iIanInNTJB0Y5E+LAhIGt/TyMF741ICSUyK04NUUoZ7NjQgSrim2pwi
         d1Ow==
X-Gm-Message-State: ABy/qLZfIxwG4yLu0YfYvYl7yBwPbHhGF6cfT1WuuVjr6cgK6lOcCNOO
        5t4SPEbkXiLUJnRFwZ4JJPni/Q==
X-Google-Smtp-Source: APBJJlE3GwiR2HJVCApX/Q+cUmnurOaqUoNuoEEtQvpP9gspwD3JEwNcbOB2bGBXU5ghTqVD07S7aw==
X-Received: by 2002:a05:6000:1152:b0:314:2b0a:dac6 with SMTP id d18-20020a056000115200b003142b0adac6mr6770036wrx.41.1688409114864;
        Mon, 03 Jul 2023 11:31:54 -0700 (PDT)
Received: from localhost.localdomain ([176.176.178.91])
        by smtp.gmail.com with ESMTPSA id u11-20020adfdd4b000000b003143765e207sm3323297wrm.49.2023.07.03.11.31.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Jul 2023 11:31:54 -0700 (PDT)
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
Subject: [PATCH v2 01/16] target/riscv: Remove unuseful KVM stubs
Date:   Mon,  3 Jul 2023 20:31:30 +0200
Message-Id: <20230703183145.24779-2-philmd@linaro.org>
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

Since we always check whether KVM is enabled before calling
kvm_riscv_reset_vcpu() and kvm_riscv_set_irq(), their call
is elided by the compiler when KVM is not available.
Therefore the stubs are not even linked. Remove them.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Tested-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
---
 target/riscv/kvm-stub.c  | 30 ------------------------------
 target/riscv/kvm.c       |  4 +---
 target/riscv/meson.build |  2 +-
 3 files changed, 2 insertions(+), 34 deletions(-)
 delete mode 100644 target/riscv/kvm-stub.c

diff --git a/target/riscv/kvm-stub.c b/target/riscv/kvm-stub.c
deleted file mode 100644
index 4e8fc31a21..0000000000
--- a/target/riscv/kvm-stub.c
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * QEMU KVM RISC-V specific function stubs
- *
- * Copyright (c) 2020 Huawei Technologies Co., Ltd
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2 or later, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-#include "qemu/osdep.h"
-#include "cpu.h"
-#include "kvm_riscv.h"
-
-void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
-{
-    abort();
-}
-
-void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level)
-{
-    abort();
-}
diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index 0f932a5b96..52884bbe15 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -503,9 +503,7 @@ void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
 {
     CPURISCVState *env = &cpu->env;
 
-    if (!kvm_enabled()) {
-        return;
-    }
+    assert(kvm_enabled());
     env->pc = cpu->env.kernel_addr;
     env->gpr[10] = kvm_arch_vcpu_id(CPU(cpu)); /* a0 */
     env->gpr[11] = cpu->env.fdt_addr;          /* a1 */
diff --git a/target/riscv/meson.build b/target/riscv/meson.build
index 7f56c5f88d..e3ab3df4e5 100644
--- a/target/riscv/meson.build
+++ b/target/riscv/meson.build
@@ -22,7 +22,7 @@ riscv_ss.add(files(
   'crypto_helper.c',
   'zce_helper.c'
 ))
-riscv_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'), if_false: files('kvm-stub.c'))
+riscv_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'))
 
 riscv_system_ss = ss.source_set()
 riscv_system_ss.add(files(
-- 
2.38.1

