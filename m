Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C132D081C
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 00:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbgLFXlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 18:41:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728559AbgLFXla (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 18:41:30 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661D3C061A56
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 15:41:15 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id h21so12090271wmb.2
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 15:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rwJkcz0lXzb5vYIm5eeEUAMRTcJm9OyTFdsDcyLncdA=;
        b=laKKK4RHTXy8RCtw8YQNsRI6lS8XnVTBs+k0U5wnfrp96iRrU7cYGLqtfaO7/imgqa
         AiUBjkAOSesZfYzma0jBgAy5zgRZot01FKcYILx6sFBv6NPtQvBZ7Ux5vPyjxsmhQn+A
         qhJp82N5XKYSBvrAfAKZr+zZ23+v+JWzlnCJtUc8WJdYbmDS9F97ztnSDflsxjTx0YMK
         7k3UADxCZn2OBBt9rVwM2IxFykAXJ4PkMYrBG6h1odWUSVeFZP70NWDZ8N21EanXXPnr
         aZWc2fsPyknluRq+qH+x/dhJGo2c6/LHoUq6ejkxmO5vGu1kVZpzk8vEl3yz2rZnJkfc
         sf8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=rwJkcz0lXzb5vYIm5eeEUAMRTcJm9OyTFdsDcyLncdA=;
        b=O8B0PGhWE+Pe/toP0lWNFGm3xOZkxpjMsu5RTZtWkgWt+Oq+NUfrkvSZVl9oNe9lR5
         BY3l1dZoXz7ST1EHqNQLxei4BLnzV6S0PZWA/sGVMB5PRaPRKQLibv8J/8rLfRCwjA2f
         Z/KlQrPUkIJXWn6dd9Xl7oQNHw3GhZYvhz4EYS7Rnd+2AZfaUVy4ahMP1wsE3y0RY0en
         KfzmOrLhi0BjjV7Bp0IUFzHndQWevRI/Sup9mzwaNMGIvGY6KpeB/r7nQIbCGBrzzu9e
         jLjhWtv2U/jwIdIwJ/5zuXyBCVuQ11ZbN6j/MQb1yOV/QVr8hVc1V7CFyeR24cQNNR7m
         He/w==
X-Gm-Message-State: AOAM5326ctdF1sR4uPbhj5tUVDvoOV6PwVOkUIUB022Arjv71JWZ/sjr
        kNLIBBjfCqhLkeCY2IGB7uQ=
X-Google-Smtp-Source: ABdhPJzhZk3PMkFWuwgqgm+vSByS3t56zMO6H60iDu1eNSR/tUHRY2Ir5MnTTAjNiAl+UrHL28WeTA==
X-Received: by 2002:a1c:3c09:: with SMTP id j9mr15542997wma.180.1607298074148;
        Sun, 06 Dec 2020 15:41:14 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id y2sm12424711wrn.31.2020.12.06.15.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 15:41:13 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 16/19] target/mips: Inline cpu_mips_realize_env() in mips_cpu_realizefn()
Date:   Mon,  7 Dec 2020 00:39:46 +0100
Message-Id: <20201206233949.3783184-17-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206233949.3783184-1-f4bug@amsat.org>
References: <20201206233949.3783184-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/cpu.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 1073db7f257..899a746c3e5 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -104,17 +104,6 @@ static bool mips_cpu_has_work(CPUState *cs)
 
 #include "translate_init.c.inc"
 
-static void cpu_mips_realize_env(CPUMIPSState *env)
-{
-    env->exception_base = (int32_t)0xBFC00000;
-
-#ifndef CONFIG_USER_ONLY
-    mmu_init(env, env->cpu_model);
-#endif
-    fpu_init(env, env->cpu_model);
-    mvp_init(env, env->cpu_model);
-}
-
 /* TODO QOM'ify CPU reset and remove */
 static void cpu_state_reset(CPUMIPSState *env)
 {
@@ -400,6 +389,7 @@ static void mips_cpu_realizefn(DeviceState *dev, Error **errp)
 {
     CPUState *cs = CPU(dev);
     MIPSCPU *cpu = MIPS_CPU(dev);
+    CPUMIPSState *env = &cpu->env;
     MIPSCPUClass *mcc = MIPS_CPU_GET_CLASS(dev);
     Error *local_err = NULL;
 
@@ -423,7 +413,13 @@ static void mips_cpu_realizefn(DeviceState *dev, Error **errp)
         return;
     }
 
-    cpu_mips_realize_env(&cpu->env);
+    env->exception_base = (int32_t)0xBFC00000;
+
+#ifndef CONFIG_USER_ONLY
+    mmu_init(env, env->cpu_model);
+#endif
+    fpu_init(env, env->cpu_model);
+    mvp_init(env, env->cpu_model);
 
     cpu_reset(cs);
     qemu_init_vcpu(cs);
-- 
2.26.2

