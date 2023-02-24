Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F536A2029
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 18:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjBXRBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 12:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjBXRBh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 12:01:37 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2D86B16B
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:01:36 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id m3-20020a17090ade0300b00229eec90a7fso6897859pjv.0
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vZvIhYFmeKjhMfSClOcNvYFcw+7eVoiwutwql0vi/jk=;
        b=ZeNg+0N8YaWAFggGX5OHDLm4z7gM8lBbNQqDT+/4n7T2dBGC6mrVfc66/MOw9KdHtw
         WTEL4n9NgznWy+PyzdWpsV+ZjchPt6HC+pJPzJOjVb/v3JzSKUE1SZvhOFdnX/yYpwEv
         CGlzMk/GRJF3q1ePaAifGhFZjra5Mj5w8Riow0xB1E5gzgIUk+XD6RxJ26pTQnhfgMGr
         2r8UiPdyuB9LYPqB/PsJJ4T0shfI5eOAuL9kZslksj28fTWziVfyFLcrdHD1w9Sd5dAV
         Q/EdnOxx8QEERVmqrr4JWlCLwzbw86dDzff2voTFkdWcHIdoAiZ4RlVw924LIkQb+UEb
         3RIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vZvIhYFmeKjhMfSClOcNvYFcw+7eVoiwutwql0vi/jk=;
        b=kP6CXV33U2opPcmm8A/Qse/0BSFAXeYcXBHA+MoDr/UbhsTJllSMh9IK3kngaYLL8L
         NMFU52qJPui2NLb5ZzGsMQh4HsIrjfxGLpBAsv2JGOWH1uoc/gr9NnrxkHvgPhKmVT+V
         TMo2PBrWij84f1SZQGiS34I8u45VC4xdzGaASpXXP/4uvaWT9RfFPonkU6tQlwHp2Q58
         3i/FlHAC9JeI81HQXgD+kwRT1vN40RaxhWr8Wxe0omtTcv2INpkV3E/J8aRmiVcPCUqe
         usQFstwqFdirNSwAPOT2ZLT7SE+9hsq/tGvjm3hkbubkUHlQqON4bss0butgNA5W7Cx8
         RA1w==
X-Gm-Message-State: AO0yUKU2MNgCDcpSGEQD+GJjJyt7XkkWe+kordJ9BDpnLm+RNOMinl6Z
        Go63fYOHOVtrIvzK8ek/FGK1gQ==
X-Google-Smtp-Source: AK7set93R37VeqYtz2Q7nwYYxsKvvHYRwi1MVAY3nHlm44LAzi8Mx7/WrgqwZadC+nBgZvMUyvCxDA==
X-Received: by 2002:a17:902:f94e:b0:19b:e73:809c with SMTP id kx14-20020a170902f94e00b0019b0e73809cmr15771534plb.1.1677258096226;
        Fri, 24 Feb 2023 09:01:36 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902b60c00b0019472226769sm9234731pls.251.2023.02.24.09.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 09:01:34 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Guo Ren <ren_guo@c-sky.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Nick Knight <nick.knight@sifive.com>,
        Jisheng Zhang <jszhang@kernel.org>
Subject: [PATCH -next v14 01/19] riscv: Rename __switch_to_aux -> fpu
Date:   Fri, 24 Feb 2023 17:01:00 +0000
Message-Id: <20230224170118.16766-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230224170118.16766-1-andy.chiu@sifive.com>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Guo Ren <ren_guo@c-sky.com>

The name of __switch_to_aux is not clear and rename it with the
determine function: __switch_to_fpu. Next we could add other regs'
switch.

Signed-off-by: Guo Ren <ren_guo@c-sky.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
 arch/riscv/include/asm/switch_to.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/switch_to.h b/arch/riscv/include/asm/switch_to.h
index 60f8ca01d36e..4b96b13dee27 100644
--- a/arch/riscv/include/asm/switch_to.h
+++ b/arch/riscv/include/asm/switch_to.h
@@ -46,7 +46,7 @@ static inline void fstate_restore(struct task_struct *task,
 	}
 }
 
-static inline void __switch_to_aux(struct task_struct *prev,
+static inline void __switch_to_fpu(struct task_struct *prev,
 				   struct task_struct *next)
 {
 	struct pt_regs *regs;
@@ -66,7 +66,7 @@ static __always_inline bool has_fpu(void)
 static __always_inline bool has_fpu(void) { return false; }
 #define fstate_save(task, regs) do { } while (0)
 #define fstate_restore(task, regs) do { } while (0)
-#define __switch_to_aux(__prev, __next) do { } while (0)
+#define __switch_to_fpu(__prev, __next) do { } while (0)
 #endif
 
 extern struct task_struct *__switch_to(struct task_struct *,
@@ -77,7 +77,7 @@ do {							\
 	struct task_struct *__prev = (prev);		\
 	struct task_struct *__next = (next);		\
 	if (has_fpu())					\
-		__switch_to_aux(__prev, __next);	\
+		__switch_to_fpu(__prev, __next);	\
 	((last) = __switch_to(__prev, __next));		\
 } while (0)
 
-- 
2.17.1

