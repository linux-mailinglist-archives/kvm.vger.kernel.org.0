Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE5E746269
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 20:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjGCScN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 14:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjGCScL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 14:32:11 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF14E67
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 11:32:08 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3fba8e2aa52so57229265e9.1
        for <kvm@vger.kernel.org>; Mon, 03 Jul 2023 11:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688409127; x=1691001127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MmplW2ex2rHzihVJ44uJ4xkpwEybdiXLv3F1bYg0V9o=;
        b=crGvpkCQQsqDzLIoUgcMsHdYqvWJOnGoIuQ/6q/mfvoIOHSvNImdJpaPo0q1U3jT2V
         mHkp9rOwRKSD+mdTIH7KH4BysB9MboC9TrJ3sbDDCs5rGZBiJHxrrDH0dY64YNJAOqoq
         tBXke0PJ5p30cVXtQeZZgY77oGV0GyibjGMvkj0PvyoB8DSLW7TwIqYh8G5qYWpn5IRD
         UL37SB8mV0rE4SA1d0peFobkwPBhrVCRQBSqVLPuaPzHAFuS7W9S9KvUQwtPmBB+qnFa
         ncO1oEu+0lkVzugu+6t+YcDF1GLWAFEmg3L/YyXbX9QVgBCnOh/DLQmOrumB6yodiLVi
         L7Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688409127; x=1691001127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MmplW2ex2rHzihVJ44uJ4xkpwEybdiXLv3F1bYg0V9o=;
        b=ehxr3qvELTe5xH8ueTqx6wwVBQBuKK0JBXJ9SMpuyG5pnWJkNCpPRAk522aR3SOjXt
         uRquAOzVdsJO00Mdbh3QKiLK82I9EVn7LqCDs6zHf3ko3nLdMlHp0Z/V7NzNT9xkTeZ+
         tE8PwGBkZPdwyLWgt329CFJX1s4pF5I1zvc75BhYKFvGPqa8bXedSIsISEtAb3E2DSpV
         69/y6sso8Sbmc0SmcoWjClJSZimdNG3AMFrlW3IHYKsEX0XSn2vhqBNz+WajJ4bL/9QT
         WB7+713DXfML1p2mDhBakvD6i+0DbW2V7nXb5wi5n8lP2UHVGsRFfFRYdYrvqNDI6sjx
         EFUA==
X-Gm-Message-State: AC+VfDw8FzCWzbnlSSy3mL4U31lTHEFpbLp/xWvsZ6MVlODft8gG48IM
        OLEHCFcThGawbHGl1yhIxkAgEg==
X-Google-Smtp-Source: ACHHUZ5P9NPaUY2M9plko56MMlY+LD4D0vX+GUYll+SWPHJdo6WhISnJstsVpBPOD24/pxFJoXi75Q==
X-Received: by 2002:a1c:790b:0:b0:3fb:b280:f551 with SMTP id l11-20020a1c790b000000b003fbb280f551mr9744606wme.41.1688409127036;
        Mon, 03 Jul 2023 11:32:07 -0700 (PDT)
Received: from localhost.localdomain ([176.176.178.91])
        by smtp.gmail.com with ESMTPSA id m21-20020a7bcb95000000b003faabd8fcb8sm21627386wmi.46.2023.07.03.11.32.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Jul 2023 11:32:06 -0700 (PDT)
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
Subject: [PATCH v2 03/16] target/riscv: Restrict sysemu specific header to user emulation
Date:   Mon,  3 Jul 2023 20:31:32 +0200
Message-Id: <20230703183145.24779-4-philmd@linaro.org>
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
Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Acked-by: Alistair Francis <alistair.francis@wdc.com>
---
 target/riscv/cpu.c        | 8 +++++---
 target/riscv/cpu_helper.c | 2 ++
 target/riscv/csr.c        | 2 ++
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index fd647534cf..174003348f 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -23,9 +23,13 @@
 #include "qemu/log.h"
 #include "cpu.h"
 #include "cpu_vendorid.h"
+#ifndef CONFIG_USER_ONLY
 #include "pmu.h"
-#include "internals.h"
 #include "time_helper.h"
+#include "sysemu/kvm.h"
+#include "kvm_riscv.h"
+#endif
+#include "internals.h"
 #include "exec/exec-all.h"
 #include "qapi/error.h"
 #include "qapi/visitor.h"
@@ -33,8 +37,6 @@
 #include "hw/qdev-properties.h"
 #include "migration/vmstate.h"
 #include "fpu/softfloat-helpers.h"
-#include "sysemu/kvm.h"
-#include "kvm_riscv.h"
 #include "tcg/tcg.h"
 
 /* RISC-V CPU definitions */
diff --git a/target/riscv/cpu_helper.c b/target/riscv/cpu_helper.c
index 9f611d89bb..e8b7f70be3 100644
--- a/target/riscv/cpu_helper.c
+++ b/target/riscv/cpu_helper.c
@@ -28,7 +28,9 @@
 #include "tcg/tcg-op.h"
 #include "trace.h"
 #include "semihosting/common-semi.h"
+#ifndef CONFIG_USER_ONLY
 #include "sysemu/cpu-timers.h"
+#endif
 #include "cpu_bits.h"
 #include "debug.h"
 #include "tcg/oversized-guest.h"
diff --git a/target/riscv/csr.c b/target/riscv/csr.c
index ea7585329e..e5737dcf58 100644
--- a/target/riscv/csr.c
+++ b/target/riscv/csr.c
@@ -21,8 +21,10 @@
 #include "qemu/log.h"
 #include "qemu/timer.h"
 #include "cpu.h"
+#ifndef CONFIG_USER_ONLY
 #include "pmu.h"
 #include "time_helper.h"
+#endif
 #include "qemu/main-loop.h"
 #include "exec/exec-all.h"
 #include "exec/tb-flush.h"
-- 
2.38.1

