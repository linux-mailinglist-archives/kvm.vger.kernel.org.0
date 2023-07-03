Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200C174626A
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 20:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjGCScU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 14:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbjGCScS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 14:32:18 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C36EE6A
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 11:32:15 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-314319c0d3eso2261111f8f.0
        for <kvm@vger.kernel.org>; Mon, 03 Jul 2023 11:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688409133; x=1691001133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KNXX9yjMUQcBLaEX0n22oT0yHELrjRtAMDfsIdBaNkY=;
        b=KIK5m6ETMi3E+DS0NOoaPhJTIaeZWsAbFYOV6Zl7AOmoiTcn8qvuL0HF+pnuVFScFG
         dagK5jUXqbUkBh/CoHtVTNrK5Zw8YVfRszT6X3I7J2y+JgZ7ak1OIwTX5AxRLKfZJse1
         EWs66tgk92rQ1CnP1vltH6gmx+vFVYlZuNXlRl5sTfE4nzmSeOJWqW/OhoiCeX1XP91e
         BCsyxZ1YR/EQynYeZ2xomyJXpZH9A1VE4rtdD3TNFlPkZpEPJBc5M9kJQfg5mAU8DMah
         0KQKxqwC1+GiTfkqYbXnA/CHoUHbKyS75aZMGaU1oIVMOthqNpFIYYkf5PAr+iOHlBKF
         Wjcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688409133; x=1691001133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KNXX9yjMUQcBLaEX0n22oT0yHELrjRtAMDfsIdBaNkY=;
        b=Fs6OdWpS4ZZ9AK+imadMsgTmF5kFT89TVoosSEFlGY1/g9epmS2KYrB29pRCAHrhaO
         jAGMt5bPNcCtmVx3BAxLVjgkBrxgRnrfprSxvwb+KdvfilZFRWHb8nar6UXn95l1XIlj
         xg9xqgjwZaPMB0D4zeadqheLEXROPyWdfmGo5PkDWGVhXHgDz+J47HvpqbIe+JXkNTtF
         VQx5Fc1f0G0zw/YMwmoe5UJ0DwaDeGxZSb+hU82kpKpcUJT4W8O6SVhRJLGAJBtXza5E
         bHmdSqApgNjKgXwJJQmvy4FtpJp9UcdhP3k61J5RBNOMUlvRBn0MJIgFaW2VO+UQkvBh
         RQhg==
X-Gm-Message-State: ABy/qLYaH0nrBfdJKqwhe3BYj0VX+eXnp2JTvyTInre/DVEWTETu/ta8
        X8ROYDcOG1xq2hqBnKt4goZHvw==
X-Google-Smtp-Source: APBJJlHatMbhgx8arqDUSOAALOI8iktiuHwcIb3VHA/qra9oYQt49PQ0pLFIYvPi0+AxjH5Xon74jA==
X-Received: by 2002:a05:6000:924:b0:314:2c17:d921 with SMTP id cx4-20020a056000092400b003142c17d921mr6336643wrb.38.1688409133603;
        Mon, 03 Jul 2023 11:32:13 -0700 (PDT)
Received: from localhost.localdomain ([176.176.178.91])
        by smtp.gmail.com with ESMTPSA id w10-20020adfec4a000000b00314172ba213sm11770980wrn.108.2023.07.03.11.32.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Jul 2023 11:32:13 -0700 (PDT)
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
Subject: [PATCH v2 04/16] target/riscv: Restrict 'rv128' machine to TCG accelerator
Date:   Mon,  3 Jul 2023 20:31:33 +0200
Message-Id: <20230703183145.24779-5-philmd@linaro.org>
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

We only build for 32/64-bit hosts, so TCG is required for
128-bit targets.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Acked-by: Alistair Francis <alistair.francis@wdc.com>
---
 target/riscv/cpu.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index 174003348f..78ab61c274 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -498,6 +498,7 @@ static void rv64_veyron_v1_cpu_init(Object *obj)
 #endif
 }
 
+#ifdef CONFIG_TCG
 static void rv128_base_cpu_init(Object *obj)
 {
     if (qemu_tcg_mttcg_enabled()) {
@@ -516,7 +517,10 @@ static void rv128_base_cpu_init(Object *obj)
     set_satp_mode_max_supported(RISCV_CPU(obj), VM_1_10_SV57);
 #endif
 }
-#else
+#endif
+
+#else /* !TARGET_RISCV64 */
+
 static void rv32_base_cpu_init(Object *obj)
 {
     CPURISCVState *env = &RISCV_CPU(obj)->env;
@@ -598,7 +602,7 @@ static void rv32_imafcu_nommu_cpu_init(Object *obj)
     cpu->cfg.ext_icsr = true;
     cpu->cfg.pmp = true;
 }
-#endif
+#endif /* !TARGET_RISCV64 */
 
 #if defined(CONFIG_KVM)
 static void riscv_host_cpu_init(Object *obj)
@@ -2033,8 +2037,10 @@ static const TypeInfo riscv_cpu_type_infos[] = {
     DEFINE_CPU(TYPE_RISCV_CPU_SHAKTI_C,         rv64_sifive_u_cpu_init),
     DEFINE_CPU(TYPE_RISCV_CPU_THEAD_C906,       rv64_thead_c906_cpu_init),
     DEFINE_CPU(TYPE_RISCV_CPU_VEYRON_V1,        rv64_veyron_v1_cpu_init),
+#ifdef CONFIG_TCG
     DEFINE_DYNAMIC_CPU(TYPE_RISCV_CPU_BASE128,  rv128_base_cpu_init),
-#endif
+#endif /* CONFIG_TCG */
+#endif /* TARGET_RISCV64 */
 };
 
 DEFINE_TYPES(riscv_cpu_type_infos)
-- 
2.38.1

