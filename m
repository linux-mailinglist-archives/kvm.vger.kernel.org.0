Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071806BE851
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 12:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjCQLhX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 07:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjCQLhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 07:37:10 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4713EB1ED1
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:36:33 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id p3-20020a17090a74c300b0023f69bc7a68so396974pjl.4
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679052982;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xZD7AFVtobxh1FGjEKQD2QW8IDIT5bzbSx/S1GQl+8U=;
        b=nuINMdZIqeGnufeLAqBFc5m3Pm3eLy6GQeYLva8obPk7UOaAAoxapgFgyNTsAMiuhv
         q2J7aON1jaNVNNqnexC2481g5fm40FSOjPDrrQeU5+5yyj2FB1LrXPvdiVqbYO40eOJ2
         5vEPeBhEhOrtC9WcbNcdh2XZDJtDJo/g92t0Xq9WfGZuREmf2wgD+9SQjqzOyaEqyzal
         vPeCSslysSMR3UGT+M9K0eDYW79d1ne54HglWjcggktosfAcWIIH4GENGL/NdJ5ZubgY
         /wH33J7b80yaf359Ui2R3MWatTp63ak0M2Df/Y3MMHz0rHtZgiU2m0Kvg6QJfpSdH9ln
         UhrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679052982;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xZD7AFVtobxh1FGjEKQD2QW8IDIT5bzbSx/S1GQl+8U=;
        b=w4VRallCJCiSOr0Tv9BIRV+QvkAYEunOPkp0xH5sKwmdXabxJXwccovQ+Fd5/+X7Nk
         VNB5KeoM00/lg/79zRZaY4BVeE+nvDLma2EFSubNMoGrGBBpOUZqIHfLxB2RHrGwu7Ey
         05NhR5l+OX3N5YlQdHWuIglS5cFmX+csxntwNbABqItgONfWCl+oaa8uF0R1UtqeiuXc
         MCnVlcbGT6vqeYcSoaY5GtgLbyo2z6LTgNb9D/fQrarI2N/jHekOajDyFduSKVnemOLQ
         dga3D6NZcLFrMItOJmV1crsAR9Br0aT4a+1SdTUm3Z/vL9Y4d11MBZasVTDj1nKLxnax
         aQ7w==
X-Gm-Message-State: AO0yUKXD5wNMUipFYs5Avl/wieTmX5JtUifTgo7igGi/rV+X9+8jaL30
        7h7cEbsHhWsG2nXvW8ziHrX6SA==
X-Google-Smtp-Source: AK7set8YaJ+S5JO2EY47OaFzzWSX3SIXv/SMXhmlbmxhhblJd+uc6gZ2A2Il7sKzdv4mcpQLBOTUMw==
X-Received: by 2002:a17:903:120a:b0:1a0:4f24:cae0 with SMTP id l10-20020a170903120a00b001a04f24cae0mr3325825plh.12.1679052982646;
        Fri, 17 Mar 2023 04:36:22 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a2cc500b0023d3845b02bsm1188740pjd.45.2023.03.17.04.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:36:22 -0700 (PDT)
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
        Conor Dooley <conor.dooley@microchip.com>,
        Jisheng Zhang <jszhang@kernel.org>
Subject: [PATCH -next v15 01/19] riscv: Rename __switch_to_aux() -> fpu
Date:   Fri, 17 Mar 2023 11:35:20 +0000
Message-Id: <20230317113538.10878-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230317113538.10878-1-andy.chiu@sifive.com>
References: <20230317113538.10878-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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

