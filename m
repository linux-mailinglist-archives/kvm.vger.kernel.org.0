Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F727085DB
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 18:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjERQU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 12:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjERQUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 12:20:19 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE28FE5F
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:20:13 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-64d2467d63fso468189b3a.0
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684426813; x=1687018813;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xZD7AFVtobxh1FGjEKQD2QW8IDIT5bzbSx/S1GQl+8U=;
        b=gEhgqju2wKcCZblFZ8N5g54ria8NkU2Jrsgh2HBQGp1B76OifXlhO1uLHApY5O5kRL
         JgXeGtEK+yBT3f196jJibssDuX0BZNoMdmDYyzKG57miQI76MrZYtHf/Hdej1odY0EQF
         H+gt+Wp63F/cMyYkBpPWKNs5G8/uhRWkmPKiabu33P+e00RvvF4lUnd2MRunJYWkLbRr
         Hj7VtF7r5cdTKk0Hbe7hnlU02gQ7WZv3EoJUJfNOxfgvMD1M5+Ww54ZODZbVJ+nyos7D
         +rHJgLWHxZcNpuL8QHIu5pL7EH9QCKNiXxUYpKxXIRFKJbD1zXGZw0ggmfrcbxdzAnz7
         sLvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684426813; x=1687018813;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xZD7AFVtobxh1FGjEKQD2QW8IDIT5bzbSx/S1GQl+8U=;
        b=jpBGhc34jE8YRE/sVuLDamJgV3bJCWu/9gpZ2/4jfnHC0SwoK2DL5bCg7dujQFENAO
         5dYjOnkkswStWeltG7XjJkJON/sh2M2cLoO2TRazSRpY3/gigX0d0V9HH8P1WDYA6h12
         EDq2QcD78zqtxt/qv9dwywcsJEqBrwmEv0XkJ5719kXHABxAb6+yMk038Woa78yb5lpD
         yNAOXFjBoBiGFb8HHXguhIChYbyWjCAHQC4jkTf+hgwBdVbj0xsH8MOncewR/8MFKzWq
         yuvc4oSNAJL66w+4wSw3DkTnEyDV2vEbUUVMuyc1UKqRmHvRvmY2ROT6N6k0T9Co/bwL
         iZUQ==
X-Gm-Message-State: AC+VfDzwHjdfWw8uHvCzGnabFXcUFfxB3z+z5hbmX/89y/YjtcQmfy9B
        L4l+Tygfa4/GrTQFRDjnl26pCw==
X-Google-Smtp-Source: ACHHUZ5WSoRIzD52+jf7cC9k7jLjwXrMwTQkVVpxACYNriXgtThbxraiZXQUJAzcqiQXme89jFje+w==
X-Received: by 2002:a05:6a20:9d92:b0:100:49d1:6fc7 with SMTP id mu18-20020a056a209d9200b0010049d16fc7mr208625pzb.34.1684426813385;
        Thu, 18 May 2023 09:20:13 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id x23-20020a62fb17000000b006414b2c9efasm1515862pfm.123.2023.05.18.09.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 09:20:12 -0700 (PDT)
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
        Jisheng Zhang <jszhang@kernel.org>
Subject: [PATCH -next v20 01/26] riscv: Rename __switch_to_aux() -> fpu
Date:   Thu, 18 May 2023 16:19:24 +0000
Message-Id: <20230518161949.11203-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230518161949.11203-1-andy.chiu@sifive.com>
References: <20230518161949.11203-1-andy.chiu@sifive.com>
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

