Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09ABD7365E5
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 10:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbjFTIQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 04:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbjFTIQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 04:16:17 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B413112C
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 01:16:15 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-988e6fc41ccso170589066b.3
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 01:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687248974; x=1689840974;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GmJDGJJlkA2GivjH5EJMWL239y4z1jUH4kX5hcFkTlI=;
        b=CNjrjnDsBq+ZtWF/mCUovMcnTU+fu15kXKvnK0hR57qOJHgEJmYNKtrsRlaQQHqcBc
         Tsc+Lp2tr3Z+Ng2zQNQtiJTFV1iclwb+Ku5sjy8LIWdRjCVL5+Z7ywuN+6DPdQneeNIX
         H7JyTFPdJfxduHXR33UfPi+o8NMH2uj9ZBv2/ErWgiDqBNQEaAZmEj17lF62pq1BkPyw
         r1YBtRGBvAVi6pPD/gG4ZpR7K+9igTBfdLDUpimFLisJAm/+ZMMaZHO9zodLUoSkLp1m
         ey1te+A4DHBKo4XlNMkDpMQbzhwSHPwJ6wSNUDzW5db2CAfJkkGYLYCzc5U+xPoa+d41
         2f9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687248974; x=1689840974;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GmJDGJJlkA2GivjH5EJMWL239y4z1jUH4kX5hcFkTlI=;
        b=N02TJaiBt7Dys+bMBFglLBiCmnX9q5khTtVEDxqN4zVs8Uj0q37cSsAHOTChTmPmDh
         jRY5zYzOgnalMsJ45FGXn4LCgMrLGsZqztCYRJNPLub/rZYjhE9N7jgPt4NeoFf8Tuqw
         VGX1SF7HgxCKNjkmkn1XmE3HqMr+Ov9IXDivPvbXnCIdHdj6umkCdlSloZiHuvJLa+UD
         MJfzyU2QSDhrVS2wk0j9/9hn2mEaWuR87lMNCzmBe6aA8tiU5rT02AKfr4ya3dFjrDGa
         zAReJsI0HNCVHOtGBCmOTgbOSrJVzc32tilLYL0j8ENYo8ZfNcJIi6VkOptHyXOBywNU
         jTmQ==
X-Gm-Message-State: AC+VfDySdkcV6dBRNH8AyK2QtPy5aMi/+qzYiNbxx6NN94ksOTLCGL8j
        Qc+PWGCTnRoJGvOq26DDc4GNDQ==
X-Google-Smtp-Source: ACHHUZ7ETb8h8N9D0eWOS21wHebIZRZxpgXhgJYbRk2e7VTE35fj/rfWgZdfSPA4j1v6j8qOMFvo0g==
X-Received: by 2002:a17:907:9692:b0:988:71c8:9f44 with SMTP id hd18-20020a170907969200b0098871c89f44mr4801788ejc.2.1687248974119;
        Tue, 20 Jun 2023 01:16:14 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.183.29])
        by smtp.gmail.com with ESMTPSA id u9-20020a17090617c900b0098768661505sm935598eje.117.2023.06.20.01.16.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 Jun 2023 01:16:13 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Bin Meng <bin.meng@windriver.com>, qemu-riscv@nongnu.org,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, kvm@vger.kernel.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Alistair Francis <alistair.francis@wdc.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH] target/riscv: Remove unuseful KVM stubs
Date:   Tue, 20 Jun 2023 10:16:11 +0200
Message-Id: <20230620081611.88158-1-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index e1ff6d9b95..37fc2cf487 100644
--- a/target/riscv/meson.build
+++ b/target/riscv/meson.build
@@ -22,7 +22,7 @@ riscv_ss.add(files(
   'crypto_helper.c',
   'zce_helper.c'
 ))
-riscv_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'), if_false: files('kvm-stub.c'))
+riscv_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'))
 
 riscv_softmmu_ss = ss.source_set()
 riscv_softmmu_ss.add(files(
-- 
2.38.1

