Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424636D794B
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 12:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237716AbjDEKJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 06:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237666AbjDEKJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 06:09:03 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186074ECB
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 03:09:01 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id m2so35618070wrh.6
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 03:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680689339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g7I8pgcW6ZwGjVMfJNjtnaXujAveSVqm+E8tHMTx8v0=;
        b=MhyujAomibFLPs5Z1r+fQrzzSvg9H4r2EBzSetnjfIovo0D4SOHWUwSeiRMNgPoh1o
         7h6hDoLWJdA8tHYvvh8HqzgvOpEgD8lMQv3Tz77QtPegzuQe5Qlye+HlBf3iI294ejVj
         dkyFO5ZwK+u+nCxKcob1h3I1Hua9GeSm3zg4LMwmxMpoq8AjbZ/7zeL7FuqCwP1PDlzR
         9AXgnwO44IVGF5Kt1cF5t91+2Spcqj4EPyL/GbCKZZQh9S2g/AvunFvUkRs9SV1l90g3
         DYNOhupV0YEvOrj5PGN49nkPggU8u37pDPwL8d0V/htEWC24jJi27Kzgqvu52RRWcVFG
         TJCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680689339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g7I8pgcW6ZwGjVMfJNjtnaXujAveSVqm+E8tHMTx8v0=;
        b=YrnfRpwGfO4wy9CWoopPKh7pvqkLCYxR+32O+RyignrNHLLkUTr/h17cfkR+qFhY4n
         tHqioyVqdoGawoCy5CO+/Mp0K8C4lTB2Js9KQPQZ57e6aj0LQsIdHyXnthHpIFeFsTrL
         yDfEgTMKtLFf3HuzG5tK3h4ooMRWdqg7Zah5NF/sq0sOUR5GbA4ZGl3N4i3amzIpWhm5
         2lpjWnABsxwftFd6OKKfFgUAT3Wq5ezDtUO+9OdCXMIQYmYU6E+LC74QsO/9YRTRggdS
         76l6uFzJogcZMW5XHheO9XbjukawgkexYd+ySDFOMYKd2yyhd5NASOVzjFrlVr32XyYb
         RAiw==
X-Gm-Message-State: AAQBX9fdYA1MtxlFz0JLO8ZG3jSDQaNjPt5kG+WKvwwNJjLof6flW+yT
        +jkrioZLOtXmexRbT8OSVHCtZ/a5n6fKkQVtXJM=
X-Google-Smtp-Source: AKy350ZZ4fgFqdvHAn3EadEjlpVz+1pRNjnGMd2Adfq6cwTKDA6rtjIPgVMQ19Y5BFSB/g3YNh95tw==
X-Received: by 2002:adf:f492:0:b0:2ce:a7df:c115 with SMTP id l18-20020adff492000000b002cea7dfc115mr3589528wro.41.1680689339485;
        Wed, 05 Apr 2023 03:08:59 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id f16-20020adffcd0000000b002d5a8d8442asm14561130wrs.37.2023.04.05.03.08.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 03:08:59 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-arm@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 1/2] target/arm: Remove KVM AArch32 CPU definitions
Date:   Wed,  5 Apr 2023 12:08:47 +0200
Message-Id: <20230405100848.76145-2-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405100848.76145-1-philmd@linaro.org>
References: <20230405100848.76145-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Missed in commit 80485d88f9 ("target/arm: Restrict
v7A TCG cpus to TCG accel").

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/kvm-consts.h | 9 +++------
 target/arm/cpu_tcg.c    | 2 --
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/target/arm/kvm-consts.h b/target/arm/kvm-consts.h
index 09967ec5e6..7c6adc14f6 100644
--- a/target/arm/kvm-consts.h
+++ b/target/arm/kvm-consts.h
@@ -124,13 +124,10 @@ MISMATCH_CHECK(QEMU_PSCI_RET_INTERNAL_FAILURE, PSCI_RET_INTERNAL_FAILURE);
 MISMATCH_CHECK(QEMU_PSCI_RET_NOT_PRESENT, PSCI_RET_NOT_PRESENT);
 MISMATCH_CHECK(QEMU_PSCI_RET_DISABLED, PSCI_RET_DISABLED);
 
-/* Note that KVM uses overlapping values for AArch32 and AArch64
- * target CPU numbers. AArch32 targets:
+/*
+ * Note that KVM uses overlapping values for AArch32 and AArch64
+ * target CPU numbers. AArch64 targets:
  */
-#define QEMU_KVM_ARM_TARGET_CORTEX_A15 0
-#define QEMU_KVM_ARM_TARGET_CORTEX_A7 1
-
-/* AArch64 targets: */
 #define QEMU_KVM_ARM_TARGET_AEM_V8 0
 #define QEMU_KVM_ARM_TARGET_FOUNDATION_V8 1
 #define QEMU_KVM_ARM_TARGET_CORTEX_A57 2
diff --git a/target/arm/cpu_tcg.c b/target/arm/cpu_tcg.c
index df0c45e523..1911d7ec47 100644
--- a/target/arm/cpu_tcg.c
+++ b/target/arm/cpu_tcg.c
@@ -546,7 +546,6 @@ static void cortex_a7_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_EL2);
     set_feature(&cpu->env, ARM_FEATURE_EL3);
     set_feature(&cpu->env, ARM_FEATURE_PMU);
-    cpu->kvm_target = QEMU_KVM_ARM_TARGET_CORTEX_A7;
     cpu->midr = 0x410fc075;
     cpu->reset_fpsid = 0x41023075;
     cpu->isar.mvfr0 = 0x10110222;
@@ -595,7 +594,6 @@ static void cortex_a15_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_EL2);
     set_feature(&cpu->env, ARM_FEATURE_EL3);
     set_feature(&cpu->env, ARM_FEATURE_PMU);
-    cpu->kvm_target = QEMU_KVM_ARM_TARGET_CORTEX_A15;
     /* r4p0 cpu, not requiring expensive tlb flush errata */
     cpu->midr = 0x414fc0f0;
     cpu->revidr = 0x0;
-- 
2.38.1

