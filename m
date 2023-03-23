Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13406C6BAF
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 15:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbjCWO7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 10:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjCWO7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 10:59:39 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3F31D93C
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 07:59:38 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id u10so844254plz.7
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 07:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679583578;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xZD7AFVtobxh1FGjEKQD2QW8IDIT5bzbSx/S1GQl+8U=;
        b=EE4iyZ9ZIYFKB5FMvRNeYHxXk8u+i1yhDt4omFH12gjYyHwTnUUiC13hv+Il1HyF6s
         rDXdUWb0h4Ie637VWRym/g/GXTm3eWY062jeeytZnqOgRxRu5dAhzahW6W4wRgoh0Jjh
         ZEfTkXrLECW3ihGU8STm1NE6hOWmG7EzPpqt1Pyd3QbkBLvFgZ41nH7kZ2mEcb91ebJH
         GEDqMHY53zS6Czn5N5+Bfr+Fx5vAlzIMcgn1Sv9Gq08CJJrPQ8I9p8F+7MScW4hMcSqE
         1I7bS048M166lupwCQ8xyRVPoWr8gV/rb1IH9lvyAJTs2q+B4Mqgfemdugx3j7vzqbvE
         paOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679583578;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xZD7AFVtobxh1FGjEKQD2QW8IDIT5bzbSx/S1GQl+8U=;
        b=qmiMevUKP22duAeKp4uLaZIXzF43X8Cne+0+TuqydbZvjGt7CG5nG/JTdtw0BZKmZ2
         fKx5UxDiQDkHmtkQHk67mK6Opt5U5wFrgu78R8tGcSwI34FMgjInqEy49Lr/DmRmryBh
         VNtDOfH5A9ssyoldoTRtRNt83+yyH6TQuiq7/YFz9D9sggBzWiUAdKo5KjDsezf1kdjv
         BUt99ku/sQHOJm8jWJCWThhIgpL1o67Ru/aJT4d0RvjhoJV/cbpJrWdNoNJQBsPdT53L
         kvtZYdyg55RPDjBXCJBOFZaXh7HU5ZZr62AtlPylRsgDf6oqZ7kl5QKYu0dPVYCNeblF
         P5AA==
X-Gm-Message-State: AO0yUKVdwMRWUgKEgdFGJP7nJSDJnTqJqO3xSnedZLMpN6D+qMrFV9g/
        4T8nrT6sO2NJJpJqxq5izPGFNg==
X-Google-Smtp-Source: AK7set+/B5nEPkQgpgS7TZzUH0y5Y+FUfRpzPltL0G5GjJIHTjTPQSYBW3inr/Q72qMdyce5IYxZZQ==
X-Received: by 2002:a17:903:24f:b0:1a0:7508:daf2 with SMTP id j15-20020a170903024f00b001a07508daf2mr7393444plh.2.1679583578342;
        Thu, 23 Mar 2023 07:59:38 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902854900b0019f53e0f136sm12503965plo.232.2023.03.23.07.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 07:59:37 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Guo Ren <ren_guo@c-sky.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Jisheng Zhang <jszhang@kernel.org>
Subject: [PATCH -next v16 01/20] riscv: Rename __switch_to_aux() -> fpu
Date:   Thu, 23 Mar 2023 14:59:05 +0000
Message-Id: <20230323145924.4194-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230323145924.4194-1-andy.chiu@sifive.com>
References: <20230323145924.4194-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

