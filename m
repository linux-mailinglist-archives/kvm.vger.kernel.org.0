Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850D0746270
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 20:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjGCScv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 14:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjGCScu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 14:32:50 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E39C1A7
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 11:32:48 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3fbc5d5746cso51206885e9.2
        for <kvm@vger.kernel.org>; Mon, 03 Jul 2023 11:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688409166; x=1691001166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y5G3GZnisObOugerwvl7UVGEu2t0avWriP2R6IveebM=;
        b=gArLSy6UVnwhbUvId2CPKgLMDrnRG+LSn8P3Y9zKm3qKRdS8QwkfZVJZ2207HtTRgB
         iihho0KTaU6KcfKiFae/vh7wpkYSQt//pGXBnvf0O3XxYtaIO13Gl3kuKEB12IG4tmw6
         SyDE6qCSpfhIa0+vXELSpH82eB9hXBIAVopshElO1yZ6x2CGPD5+ZRr1Q+VXJh5QESdE
         x3YL3CGEkwkhaCjWiHE+1qNv/RKN4E3iw1hgRI1WPJiw70KP9TGRGRWXj7rYFpHcCmGt
         DOYtf2FbPXTocF4UFbURftbvhe2tNEvJ4PKx/kPER44ur8W2yajlLHWWu7so/JZMzRee
         CnWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688409166; x=1691001166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y5G3GZnisObOugerwvl7UVGEu2t0avWriP2R6IveebM=;
        b=KkMqB1kRZ6zJoYCCFfKUoX0a7vNWN9YjalLPlSYzZAwo7XYvFaEy1hSZRyCmeNS9Ps
         WruFJ6V6IKa04/Np12QR10hRVqIlxKTr45083nLKIZ3zZAmp8+/7vr1JvNBodpy8K22N
         zBWyNNbZfD0wRZzsgd3wGB7KeTtNQ5YkUCdVFSpe1B3Dkx0xBH+GELA6Cz3GouSTE2no
         KpyYfmGpud/ovSal1HCsJnFKh44fz8yCeF7prV/nVs79evCPNfRJsnYczkKlARxCg0PS
         GcZ2Yj8WM4f1+Co/HOPY6SodSbaVN0ZieOOvgIFVQ8+EeKW2svO4oveNjARMlT/FvwXb
         3vVQ==
X-Gm-Message-State: AC+VfDyrWJtfjkN4VCOzkSDY0ksmXI+lYdDyeRE+olYMIufol/0uYnVd
        sWPmFSMn9J8i2Hw1RQXhhiIWzQ==
X-Google-Smtp-Source: ACHHUZ7h8rLAhEb2ZvzJiN8tqunRElre+99fEUHX6oHEQbMkqj/bM3Myyd2PKQNyWBN1KrL64zWX3Q==
X-Received: by 2002:a7b:c858:0:b0:3fa:98f8:225f with SMTP id c24-20020a7bc858000000b003fa98f8225fmr10164667wml.26.1688409166721;
        Mon, 03 Jul 2023 11:32:46 -0700 (PDT)
Received: from localhost.localdomain ([176.176.178.91])
        by smtp.gmail.com with ESMTPSA id m21-20020a7bcb95000000b003faabd8fcb8sm21628765wmi.46.2023.07.03.11.32.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Jul 2023 11:32:46 -0700 (PDT)
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
Subject: [PATCH v2 09/16] target/riscv: Expose some 'trigger' prototypes from debug.c
Date:   Mon,  3 Jul 2023 20:31:38 +0200
Message-Id: <20230703183145.24779-10-philmd@linaro.org>
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

We want to extract TCG-specific code from debug.c, but some
functions call get_trigger_type() / do_trigger_action().
Expose these prototypes in "debug.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/riscv/debug.h | 4 ++++
 target/riscv/debug.c | 5 ++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/target/riscv/debug.h b/target/riscv/debug.h
index c471748d5a..65cd45b8f3 100644
--- a/target/riscv/debug.h
+++ b/target/riscv/debug.h
@@ -147,4 +147,8 @@ void riscv_trigger_init(CPURISCVState *env);
 
 bool riscv_itrigger_enabled(CPURISCVState *env);
 void riscv_itrigger_update_priv(CPURISCVState *env);
+
+target_ulong get_trigger_type(CPURISCVState *env, target_ulong trigger_index);
+void do_trigger_action(CPURISCVState *env, target_ulong trigger_index);
+
 #endif /* RISCV_DEBUG_H */
diff --git a/target/riscv/debug.c b/target/riscv/debug.c
index 75ee1c4971..5676f2c57e 100644
--- a/target/riscv/debug.c
+++ b/target/riscv/debug.c
@@ -88,8 +88,7 @@ static inline target_ulong extract_trigger_type(CPURISCVState *env,
     }
 }
 
-static inline target_ulong get_trigger_type(CPURISCVState *env,
-                                            target_ulong trigger_index)
+target_ulong get_trigger_type(CPURISCVState *env, target_ulong trigger_index)
 {
     return extract_trigger_type(env, env->tdata1[trigger_index]);
 }
@@ -217,7 +216,7 @@ static inline void warn_always_zero_bit(target_ulong val, target_ulong mask,
     }
 }
 
-static void do_trigger_action(CPURISCVState *env, target_ulong trigger_index)
+void do_trigger_action(CPURISCVState *env, target_ulong trigger_index)
 {
     trigger_action_t action = get_trigger_action(env, trigger_index);
 
-- 
2.38.1

