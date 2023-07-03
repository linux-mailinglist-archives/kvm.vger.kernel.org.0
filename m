Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5675874626C
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 20:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjGCScn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 14:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjGCScl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 14:32:41 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A312E66
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 11:32:29 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3fbc59de009so47286645e9.3
        for <kvm@vger.kernel.org>; Mon, 03 Jul 2023 11:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688409147; x=1691001147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mBPwvcRHmcNt4ZOYPtGduaaDj2uEPcahpe0nALIk+GY=;
        b=CTbvpAfs7T0B1iUPQTNfMiYVAvEwYF6IQ/GamTfEZRldAteEYIJPiIuMRrwKaF+b1S
         U6ljCBOAL/uk9Ok0zZlChdgbWCp66Y3R8wWpbjXuzjREhmpxJsxcgkN7ajkqsWlNz24F
         12sl1otb2sG4yRYO/6GT1Im7X62XfLaQrFWWkmhINjB7HTguvDqxlwDHeIGv77r+2TOz
         B/eXRnSmYWdA8+TFqdjiSSC+mMNSK2xKqPDUDklV5fUwuT32kOmATielucX6/lM2RzhK
         LY7mqeznxJ4vc1oXE6mnadvuk6tjABwgiofyMUBhw4+rdSIS+0tY+InzLEYv4ksg1sKV
         W+iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688409147; x=1691001147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mBPwvcRHmcNt4ZOYPtGduaaDj2uEPcahpe0nALIk+GY=;
        b=lnzHwGrzfSGuTlxg1X9D6ob5VlGHhe+RdLligbUI473hHKIyqFzk1S8wI2H3LQOWmO
         AzVbG0Lw3+cJpNaujCh421LLjg6ovcYFWnfQzLo1bJlm/OnU6sFg+iMo5EvaERs+3MXy
         f9XW5jCFaalwa1gaMAS2CsvXDMHJ9nVy05C/t+1sGpTx7mBHQWtY8RzpErqe5RNlqm59
         y6x41RNzBeRLKam3Xe4/TfTJ6x6ZoBEWDRL7jbZYK+/w0pOghc6lhJ5WXO2QfgL7wHs8
         rHml8Xw1uSHVEkY4UIDEDHaq22EDvYtQHDrYw5d5L46h3w84wWdP4aEHdwSaHDiGkwv7
         twrQ==
X-Gm-Message-State: AC+VfDzLlijuUfjVfEoaBxqoRiaENFglA6/GU2s7oYcWwXDOzWrKqS8a
        fF4r//LIJotOZmnl/tDS2vkQMQ==
X-Google-Smtp-Source: ACHHUZ7TITM5DPVN0GyzIpU50pY8ycnkaLx+WOyvPXMEFFaUgCSHgjYISfll4U7OmxKQljw1aGA1dA==
X-Received: by 2002:a1c:7219:0:b0:3fa:d160:fc6d with SMTP id n25-20020a1c7219000000b003fad160fc6dmr8809224wmc.30.1688409147704;
        Mon, 03 Jul 2023 11:32:27 -0700 (PDT)
Received: from localhost.localdomain ([176.176.178.91])
        by smtp.gmail.com with ESMTPSA id a20-20020a05600c225400b003fbb06af219sm15928744wmm.32.2023.07.03.11.32.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Jul 2023 11:32:27 -0700 (PDT)
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
Subject: [PATCH v2 06/16] target/riscv: Restrict riscv_cpu_do_interrupt() to sysemu
Date:   Mon,  3 Jul 2023 20:31:35 +0200
Message-Id: <20230703183145.24779-7-philmd@linaro.org>
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

riscv_cpu_do_interrupt() is not reachable on user emulation.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/riscv/cpu.h        | 5 +++--
 target/riscv/cpu_helper.c | 7 ++-----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index 00a4842d84..e6a8087022 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -411,7 +411,6 @@ extern const char * const riscv_int_regnamesh[];
 extern const char * const riscv_fpr_regnames[];
 
 const char *riscv_cpu_get_trap_name(target_ulong cause, bool async);
-void riscv_cpu_do_interrupt(CPUState *cpu);
 int riscv_cpu_write_elf64_note(WriteCoreDumpFunction f, CPUState *cs,
                                int cpuid, DumpState *s);
 int riscv_cpu_write_elf32_note(WriteCoreDumpFunction f, CPUState *cs,
@@ -444,6 +443,7 @@ void riscv_cpu_validate_set_extensions(RISCVCPU *cpu, Error **errp);
 #define cpu_mmu_index riscv_cpu_mmu_index
 
 #ifndef CONFIG_USER_ONLY
+void riscv_cpu_do_interrupt(CPUState *cpu);
 void riscv_cpu_do_transaction_failed(CPUState *cs, hwaddr physaddr,
                                      vaddr addr, unsigned size,
                                      MMUAccessType access_type,
@@ -467,7 +467,8 @@ void riscv_cpu_set_aia_ireg_rmw_fn(CPURISCVState *env, uint32_t priv,
                                    void *rmw_fn_arg);
 
 RISCVException smstateen_acc_ok(CPURISCVState *env, int index, uint64_t bit);
-#endif
+#endif /* !CONFIG_USER_ONLY */
+
 void riscv_cpu_set_mode(CPURISCVState *env, target_ulong newpriv);
 
 void riscv_translate_init(void);
diff --git a/target/riscv/cpu_helper.c b/target/riscv/cpu_helper.c
index 0adde26321..597c47bc56 100644
--- a/target/riscv/cpu_helper.c
+++ b/target/riscv/cpu_helper.c
@@ -1579,7 +1579,6 @@ static target_ulong riscv_transformed_insn(CPURISCVState *env,
 
     return xinsn;
 }
-#endif /* !CONFIG_USER_ONLY */
 
 /*
  * Handle Traps
@@ -1589,8 +1588,6 @@ static target_ulong riscv_transformed_insn(CPURISCVState *env,
  */
 void riscv_cpu_do_interrupt(CPUState *cs)
 {
-#if !defined(CONFIG_USER_ONLY)
-
     RISCVCPU *cpu = RISCV_CPU(cs);
     CPURISCVState *env = &cpu->env;
     bool write_gva = false;
@@ -1783,6 +1780,6 @@ void riscv_cpu_do_interrupt(CPUState *cs)
 
     env->two_stage_lookup = false;
     env->two_stage_indirect_lookup = false;
-#endif
-    cs->exception_index = RISCV_EXCP_NONE; /* mark handled to qemu */
 }
+
+#endif /* !CONFIG_USER_ONLY */
-- 
2.38.1

