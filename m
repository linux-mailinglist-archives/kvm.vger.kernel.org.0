Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A99A6E27C9
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 17:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjDNP7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 11:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjDNP7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 11:59:00 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E00172D
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 08:58:59 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id h24-20020a17090a9c1800b002404be7920aso19093111pjp.5
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 08:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1681487939; x=1684079939;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xZD7AFVtobxh1FGjEKQD2QW8IDIT5bzbSx/S1GQl+8U=;
        b=SXvhgGoWdY4+v0js6UamSIbUsdNlillnh5BR2/gI3mr5VGZ/aiO0T+5K999+nOdAm1
         FV53MybCKnLYnRlS/OUx5MFd1lPXPvysty5xly8BD2hDihMEmSv9d5HhyA2cj42zmrP4
         HZs78S+Onq1MBO7YsEZm6NxRdFd2b4CdXnzSwIAs2tfvmTc/DHp9APpNxEkpOQYBw+Xu
         UVSOcRKjEtMwCau7ZxxA/CvP/NJCTMXlKadL8tIvXYK6togfuSgjaPmDr0KVcf/UzN9u
         3fNUWk9rdP3D/0SmwF9P5R5LPJkHfADah2vIlFTDAkCc8JWoQxG/N1boAa9qIPMqunGE
         KCEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681487939; x=1684079939;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xZD7AFVtobxh1FGjEKQD2QW8IDIT5bzbSx/S1GQl+8U=;
        b=bDgxWb+n+4pU4FgEv0VCiiJs+1RAE1dPo9vcM4QU3vsWsgbITrBXJFz4SDPMN01Cc+
         d8IlefJ4IB5nEK702K3qU7YC/ZfUjqcq7f/D9bM1w2/36NyGnQq6x9V6d+qYjeEQZGlk
         WULnSy1eAIa9S6RI+VVpwvw3/HjE9hL86NsNLnxSyCLjw7ThEOSO91Ox+/o2+N8pBUP5
         zZNUSqP5vB7piq1jlUqZQMSuOl3Zizpj7VoDG0Ef5ZbbKrL5uDbpDhjJitQti6v92rYW
         VfGx2E1qdjxl5QGDVTyq3XibXzxsl6JzVLow8Ja78XY93gY7qtvNnjjy97TAlIsZXwG9
         8Dvw==
X-Gm-Message-State: AAQBX9d+zmE1cQgCPTpHaPRaXXLIaaF/p3n0mRbRZ07OrFs/4rQsPrP8
        Q6OUv3zvxyTMhRCCWcQcspzVRw==
X-Google-Smtp-Source: AKy350ZxguafjbuTJCtXZ0UwMA3Y+whb6ag2ldUxCKWrmYydILPzUyXVfqAAPNk2N+lqD0cJXe0veA==
X-Received: by 2002:a17:90a:bf02:b0:246:57ba:ab25 with SMTP id c2-20020a17090abf0200b0024657baab25mr5991322pjs.11.1681487938804;
        Fri, 14 Apr 2023 08:58:58 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id br8-20020a17090b0f0800b00240d4521958sm3083584pjb.18.2023.04.14.08.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 08:58:58 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Guo Ren <ren_guo@c-sky.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Guo Ren <guoren@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Ruinland Tsai <ruinland.tsai@sifive.com>,
        Jisheng Zhang <jszhang@kernel.org>
Subject: [PATCH -next v18 01/20] riscv: Rename __switch_to_aux() -> fpu
Date:   Fri, 14 Apr 2023 15:58:24 +0000
Message-Id: <20230414155843.12963-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230414155843.12963-1-andy.chiu@sifive.com>
References: <20230414155843.12963-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Guo Ren <ren_guo@c-sky.com>

The name of __switch_to_aux() is not clear and rename it with the
determine function: __switch_to_fpu(). Next we could add other regs'
switch.

Signed-off-by: Guo Ren <ren_guo@c-sky.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
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

