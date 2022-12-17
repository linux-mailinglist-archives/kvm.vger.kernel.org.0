Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6557664FB45
	for <lists+kvm@lfdr.de>; Sat, 17 Dec 2022 18:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiLQRaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Dec 2022 12:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLQRaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Dec 2022 12:30:17 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5928110B79
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:30:16 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id ud5so12971238ejc.4
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xTDBNSZT6+fFieDTVKKGY2cR9GIfCF8Bd1zuisc6hQg=;
        b=WQPkSwxp9OggpYWVLQormmZ7UTdFovnPXafayr/1UFYULzpXfpp1Y9FUF1iDz3rLag
         37Mb/Sm2Jlp+oVEG3jkHrJDpDttvpR5q3XcuX+vUCAL1OuHp8Hew88tOO7NwqfmpsVEV
         lbM7XOdCq4GFnjK/VMR4KpDtpIOqSt+Ig6AIUfaKZjuOSMsjBlOprX+NmkqXcZhKkNle
         TXq3/8qPoF8TRWZq/LzxGml7WFyJ2ErnRLfH4i5xH1Gl+Gm/J6uapYVji5b71JCeXLZQ
         7LM7v8OIhLa7+9WkQYU+0F0rBTOn0PCYxFXX1XPKxV1wSmRXjOy9H1ZrrV6vHKfmm2xc
         iMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xTDBNSZT6+fFieDTVKKGY2cR9GIfCF8Bd1zuisc6hQg=;
        b=lyrsU3Hyz+K1BxV9GFN4zygVTjkCyljHKHquvtHwXYEFnPqF9vOA7RbV1gQhldr5p6
         PdTQilhUQJ97EDM3P+LF4RTTmg8kFQ8btyxWulKF1rg+ISSE+/xGlVWmPGe0HLfwdg18
         es/mUpofTKV+8E1Pzg4Qd7TujE8GfflkS7nvA+0WWOecE1vDA9xl/tGflea5a4xD1FkE
         PgC7LaXq5Is7HCwAsdwN6nhYm37wHSb8hh63p3iJH4v0PkUpfhNjzdv9/i9oYT7KQiWO
         ZkkFrwnrE+vkx9r1cc14KKLAMP8ehpxNqqwNZGjMYUD7ZUpH+1vThpKN7ZxjXm1UQHlD
         b5FA==
X-Gm-Message-State: ANoB5pkdqbly5IsrRd57MgdcKIFK0DpDPRf4art9vIC+UnVXRv5GsgKX
        aEFVZVCDRhdwZfcYP6HOy6iv2g==
X-Google-Smtp-Source: AA0mqf5uffLuz/RlOfjx3LfW2nOvJMq6renGCJgwWAJXO0ybGJQODl54a+q3RLQhkF3i6mqFdWu7PQ==
X-Received: by 2002:a17:906:4998:b0:7b6:62c:dd58 with SMTP id p24-20020a170906499800b007b6062cdd58mr31761091eju.57.1671298214979;
        Sat, 17 Dec 2022 09:30:14 -0800 (PST)
Received: from localhost.localdomain ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id e10-20020a170906504a00b007b29d292852sm2219059ejk.148.2022.12.17.09.30.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 17 Dec 2022 09:30:14 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Bin Meng <bin.meng@windriver.com>, kvm@vger.kernel.org,
        qemu-ppc@nongnu.org, Greg Kurz <groug@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Bernhard Beschow <shentey@gmail.com>, qemu-riscv@nongnu.org,
        Song Gao <gaosong@loongson.cn>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Laurent Vivier <laurent@vivier.eu>,
        Alistair Francis <alistair.francis@wdc.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 7/9] target/riscv/cpu: Restrict some sysemu-specific fields from CPUArchState
Date:   Sat, 17 Dec 2022 18:29:05 +0100
Message-Id: <20221217172907.8364-8-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221217172907.8364-1-philmd@linaro.org>
References: <20221217172907.8364-1-philmd@linaro.org>
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

The 'hwaddr' type is only available / meaningful on system emulation.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/riscv/cpu.h | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index 05fafebff7..71ea1bb411 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -370,7 +370,7 @@ struct CPUArchState {
     uint64_t menvcfg;
     target_ulong senvcfg;
     uint64_t henvcfg;
-#endif
+
     target_ulong cur_pmmask;
     target_ulong cur_pmbase;
 
@@ -388,6 +388,7 @@ struct CPUArchState {
     uint64_t kvm_timer_compare;
     uint64_t kvm_timer_state;
     uint64_t kvm_timer_frequency;
+#endif
 };
 
 OBJECT_DECLARE_CPU_TYPE(RISCVCPU, RISCVCPUClass, RISCV_CPU)
@@ -553,12 +554,20 @@ bool riscv_cpu_virt_enabled(CPURISCVState *env);
 void riscv_cpu_set_virt_enabled(CPURISCVState *env, bool enable);
 bool riscv_cpu_two_stage_lookup(int mmu_idx);
 int riscv_cpu_mmu_index(CPURISCVState *env, bool ifetch);
+#ifndef CONFIG_USER_ONLY
+hwaddr riscv_cpu_get_phys_page_debug(CPUState *cpu, vaddr addr);
 G_NORETURN void  riscv_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
                                                MMUAccessType access_type, int mmu_idx,
                                                uintptr_t retaddr);
 bool riscv_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                         MMUAccessType access_type, int mmu_idx,
                         bool probe, uintptr_t retaddr);
+void riscv_cpu_do_transaction_failed(CPUState *cs, hwaddr physaddr,
+                                     vaddr addr, unsigned size,
+                                     MMUAccessType access_type,
+                                     int mmu_idx, MemTxAttrs attrs,
+                                     MemTxResult response, uintptr_t retaddr);
+#endif
 char *riscv_isa_string(RISCVCPU *cpu);
 void riscv_cpu_list(void);
 
@@ -566,12 +575,6 @@ void riscv_cpu_list(void);
 #define cpu_mmu_index riscv_cpu_mmu_index
 
 #ifndef CONFIG_USER_ONLY
-void riscv_cpu_do_transaction_failed(CPUState *cs, hwaddr physaddr,
-                                     vaddr addr, unsigned size,
-                                     MMUAccessType access_type,
-                                     int mmu_idx, MemTxAttrs attrs,
-                                     MemTxResult response, uintptr_t retaddr);
-hwaddr riscv_cpu_get_phys_page_debug(CPUState *cpu, vaddr addr);
 bool riscv_cpu_exec_interrupt(CPUState *cs, int interrupt_request);
 void riscv_cpu_swap_hypervisor_regs(CPURISCVState *env);
 int riscv_cpu_claim_interrupts(RISCVCPU *cpu, uint64_t interrupts);
-- 
2.38.1

