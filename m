Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F1F769580
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 14:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbjGaMEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 08:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbjGaMEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 08:04:40 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D37510DF
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 05:04:39 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id 5614622812f47-3a44cccbd96so3006491b6e.3
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 05:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690805079; x=1691409879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fgDQfKgZT9Ai5Y6MxDXe+dFoAViK+yC0G5UtB2DQuPI=;
        b=g4gInOMTxn59VtKRdWRuCB+Fh+tnWH+7LdkxQpWmTylm7nz17XQSSKvmEY5WRaWl8H
         I4GSHiXpC4fy3IBYqPSf43xr0NNUoYm6s47jI5hBYpTCzHQb7WZofiBBo/ehpMOPtRaX
         gw8JqpC5PAy35MOXYZsXG7Mqh0Mc/y1rKu0X1779bCw86L57Oxw+mmL+UhYRavs0CPW6
         nqTGsDt5gPWj/l31RS0Hauweum49LharASB0dmKGX9xp578CTTnzw5gogNOQfQHxsO8L
         /xNDfaUpLKdVvKFkAjZLKcHdTnytpg+iCCq6wy2nlVVaFDBoDP4h+X65gXmukM39k5wW
         1zog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690805079; x=1691409879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fgDQfKgZT9Ai5Y6MxDXe+dFoAViK+yC0G5UtB2DQuPI=;
        b=GbtZ0XuobscBTQ1p5ea+ZrsPQc6uRJIMyUGk3pIbscBVKGG0SclZnOrXEkhBZiooLJ
         xNyPCCEmRM8fu6eXf77zTr3z5kmKeISkBdS7GejZb+o0Yx/PAuaAkfWkAJjKiAqhVbNz
         sfFNjr7TZLhg738jw56ca5/WY6Je1UYrwn5F/0uCg8F+3rRyRZy1mlp2Cg8349dosjEz
         doN7ErOt0Bw3lxnO+/EzKKfzbD/yA4bcDpyTS/tpwd6FcZ+ejG9eWQQ0jFurwojdfonx
         2UZyv/ge7qu+13EQ1VVrmnKqalrjf6CKoxchA7u0Hi1UIv+tn5UOZMMclBMI9QPNrynU
         mNZw==
X-Gm-Message-State: ABy/qLb3bY3Hnbr9tRt1XIuEPgypemTtaShGXmAXWoCxEoRyO7PVUygT
        3Ghk3nr0smPnjS1pXhoTNJZqzQ==
X-Google-Smtp-Source: APBJJlEQkjl0l6suCrkTFYT7TTJL9N41YjLsPcoLRfAZ7n+fD7jS7ThVU6PP2ELRqXqEQrDWGzNkdA==
X-Received: by 2002:a05:6808:428c:b0:3a3:6364:2b73 with SMTP id dq12-20020a056808428c00b003a363642b73mr9202732oib.52.1690805078937;
        Mon, 31 Jul 2023 05:04:38 -0700 (PDT)
Received: from grind.. (201-69-66-110.dial-up.telesp.net.br. [201.69.66.110])
        by smtp.gmail.com with ESMTPSA id a12-20020aca1a0c000000b003a41484b23dsm3959316oia.46.2023.07.31.05.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 05:04:38 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH 4/6] RISC-V: KVM: do not EOPNOTSUPP in set KVM_REG_RISCV_TIMER_REG
Date:   Mon, 31 Jul 2023 09:04:18 -0300
Message-ID: <20230731120420.91007-5-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230731120420.91007-1-dbarboza@ventanamicro.com>
References: <20230731120420.91007-1-dbarboza@ventanamicro.com>
MIME-Version: 1.0
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

The KVM_REG_RISCV_TIMER_REG can be read via get_one_reg(). But trying to
write anything in this reg via set_one_reg() results in an EOPNOTSUPP.

Change the API to behave like cbom_block_size: instead of always
erroring out with EOPNOTSUPP, allow userspace to write the same value
(riscv_timebase) back, throwing an EINVAL if a different value is
attempted.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_timer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
index 527d269cafff..75486b25ac45 100644
--- a/arch/riscv/kvm/vcpu_timer.c
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -218,7 +218,8 @@ int kvm_riscv_vcpu_set_reg_timer(struct kvm_vcpu *vcpu,
 
 	switch (reg_num) {
 	case KVM_REG_RISCV_TIMER_REG(frequency):
-		ret = -EOPNOTSUPP;
+		if (reg_val != riscv_timebase)
+			return -EINVAL;
 		break;
 	case KVM_REG_RISCV_TIMER_REG(time):
 		gt->time_delta = reg_val - get_cycles64();
-- 
2.41.0

