Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C637746279
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 20:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjGCSd1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 14:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbjGCSdV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 14:33:21 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD6910CA
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 11:33:07 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3fbc59de0e2so45859945e9.3
        for <kvm@vger.kernel.org>; Mon, 03 Jul 2023 11:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688409186; x=1691001186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YxoVzJhi2n2dGTE2zLar6uJBuHBuoJDv5oC7y/6cp9w=;
        b=Y+XaAPfyeufkxXFOIiWfxi52RTughpAnKhc71LcwVPTCA8FTatE5LGefW/KS397BnL
         RJ47XP8hkOQdw2TCXmk+QLXZFQr4r1K7orTEIwOXqJhHrTqHvTeRVeW/v8tMeimxCh6A
         geBbqxpS6pdQ9hAr0XuCXxg3mruE02cogHRHgvpZ/lY19SCxT+sITiGAyVyEkN9d8ie+
         NyuPGWfjvqhJetpue9ah+vxb2REJx/Elb4jaYVpqNLwVsVQPzAB+FSyYxQxHfDk4V3IJ
         ZuwwoKX2ormZu4HpOZrol9Jkk16bsQp2Cr/4L+T7mFJxU8gZFDUK6u1oOXlzyWLwwF9z
         S8Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688409186; x=1691001186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YxoVzJhi2n2dGTE2zLar6uJBuHBuoJDv5oC7y/6cp9w=;
        b=GYg+Gw2/XJbBycNKXk86XhbjsRinyE9/1BIS+96v24+m2UI99cFhkIBikXO7cPYiuE
         67yvu1TAwYWp7+8Z24zSSK0O4j6VH7VxGIZJyuYekjEPEpm6POhBLChb3ENaaWesO/HS
         wo2tayjrnz9bNk/B4nkDqDFp0KZWiX4nu29E5G1WirnWmeLW92rSfGD2F7BwVvQjLovP
         kxH1DSvPvo/XreJJG2VHR8zkguWnNIu2SiGb7NtJ/TI5lSTJ0aKBmZFG1eWWAc6YDyyi
         5imyuaEh+nRIqnZvDucDbPwkqJEWqo/vJzeB3XgsYSlEe96nU+6/EU/s63jdz8D0SQTy
         CFFg==
X-Gm-Message-State: AC+VfDwRbKlrTyxXjnmVv+hyPJaeZ4V8ofLKTOnB56kMwQsgl5Sk+xcL
        Y3X8EpyJSwXNKoaTFaKQcko5lg==
X-Google-Smtp-Source: ACHHUZ4QDzgia0zEAhiOCSiouBOaTQZnM9Rs1nER5K4OlI3cDj8QoWd91vYOugKueaOEbjqHHeNugw==
X-Received: by 2002:a05:600c:ac8:b0:3f7:e65b:5252 with SMTP id c8-20020a05600c0ac800b003f7e65b5252mr9449372wmr.1.1688409185870;
        Mon, 03 Jul 2023 11:33:05 -0700 (PDT)
Received: from localhost.localdomain ([176.176.178.91])
        by smtp.gmail.com with ESMTPSA id l1-20020adff481000000b003113ed02080sm26043073wro.95.2023.07.03.11.33.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Jul 2023 11:33:05 -0700 (PDT)
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
Subject: [PATCH v2 12/16] target/riscv: Expose riscv_cpu_pending_to_irq() from cpu_helper.c
Date:   Mon,  3 Jul 2023 20:31:41 +0200
Message-Id: <20230703183145.24779-13-philmd@linaro.org>
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

We want to extract TCG/sysemu-specific code from cpu_helper.c,
but some functions call riscv_cpu_pending_to_irq(). Expose the
prototype in "internals.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/riscv/internals.h  | 4 ++++
 target/riscv/cpu_helper.c | 6 +++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/target/riscv/internals.h b/target/riscv/internals.h
index b5f823c7ec..b6881b4815 100644
--- a/target/riscv/internals.h
+++ b/target/riscv/internals.h
@@ -72,6 +72,10 @@ target_ulong fclass_d(uint64_t frs1);
 
 #ifndef CONFIG_USER_ONLY
 extern const VMStateDescription vmstate_riscv_cpu;
+
+int riscv_cpu_pending_to_irq(CPURISCVState *env,
+                             int extirq, unsigned int extirq_def_prio,
+                             uint64_t pending, uint8_t *iprio);
 #endif
 
 enum {
diff --git a/target/riscv/cpu_helper.c b/target/riscv/cpu_helper.c
index 6c773000a5..e73cf56e5c 100644
--- a/target/riscv/cpu_helper.c
+++ b/target/riscv/cpu_helper.c
@@ -256,9 +256,9 @@ uint8_t riscv_cpu_default_priority(int irq)
     return default_iprio[irq] ? default_iprio[irq] : IPRIO_MMAXIPRIO;
 };
 
-static int riscv_cpu_pending_to_irq(CPURISCVState *env,
-                                    int extirq, unsigned int extirq_def_prio,
-                                    uint64_t pending, uint8_t *iprio)
+int riscv_cpu_pending_to_irq(CPURISCVState *env,
+                             int extirq, unsigned int extirq_def_prio,
+                             uint64_t pending, uint8_t *iprio)
 {
     int irq, best_irq = RISCV_EXCP_NONE;
     unsigned int prio, best_prio = UINT_MAX;
-- 
2.38.1

