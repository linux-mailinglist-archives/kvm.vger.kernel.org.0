Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D0E722B62
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbjFEPj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234824AbjFEPjo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:39:44 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A21F103
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 08:39:42 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-53482b44007so2510655a12.2
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 08:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685979582; x=1688571582;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xZD7AFVtobxh1FGjEKQD2QW8IDIT5bzbSx/S1GQl+8U=;
        b=ThHvOBpo59by52p4+jOSX8l8hNtU/M+FRtpBWS5wO9S1Ftj+KDeHvoi4qxb6y5lLlA
         klRc1tpT6wmq9fEsliWnmRX6vlH8Kc+bCJRFfGkoRHshaIALNsYdCc2xbs2FlgkuVE+a
         9NtsfsFMHlAHzOxpaytXXVIKMf5ZnmvEqVZr3WNtAXnIt8o5kGu12PeWcnv4ioXbSMuf
         jN/C83ZeDQ0qQxTYfKWRRByNKh5d0S+3cEsHH8UKRVCG5lbq8T8G22yixHNLydlJssXu
         xa6hUsw3HQ2NufRvFPAxAU702WJccbvy4Ho1ymVAmBN/78Xpr0SiOoVA+8OmGWfUUcX3
         cS8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979582; x=1688571582;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xZD7AFVtobxh1FGjEKQD2QW8IDIT5bzbSx/S1GQl+8U=;
        b=Li5M6f9Ty2Nmu+7y6/gtbppJgk4COLtf3T/J6iFFW3Az15zmvnlnigMmoMpInivIHG
         44zvJw7qZrdS4tzhX2hKN13nJ2hK/OcvzZ+9uVHULibrVOQdDajhUlfDZyYNK6ZbslRp
         itjKmbRgTtI+Wku2cvogMtG799tb2ZvBG8/jDx7ms02Vt2OKkiR6fJMCXmUYx3BF9ZO4
         qbmQrOoI0jYnWdoPLiS+FrRO5S7MK8Of2IdmjKxp4IAZZLrSyiy4hBStpl29IMpYzJK/
         LZZYUJS19J7i7DHC+NFL3Qupzem9ZNVlrGdplLm0Ag1vdvq9z4N0CqkRY1D2UQP/SfIG
         dZhA==
X-Gm-Message-State: AC+VfDzI4KevJ5zgQaClwcNyrc63ygDq9CgYoLvNraoXhvKpf3g84SOl
        +N917VwsjYqzJ4582TCEM+225Q==
X-Google-Smtp-Source: ACHHUZ72dieQPrM1WO2qg0OnZlgNQI7fj+3mSJL13ptwQ3koIpZJKneVebsItPgSW3CMo5AGhAYPcg==
X-Received: by 2002:a17:902:f68a:b0:1ae:626b:4771 with SMTP id l10-20020a170902f68a00b001ae626b4771mr4573871plg.36.1685979581841;
        Mon, 05 Jun 2023 08:39:41 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jk19-20020a170903331300b001b0aec3ed59sm6725962plb.256.2023.06.05.08.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:39:41 -0700 (PDT)
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
Subject: [PATCH -next v21 01/27] riscv: Rename __switch_to_aux() -> fpu
Date:   Mon,  5 Jun 2023 11:06:58 +0000
Message-Id: <20230605110724.21391-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230605110724.21391-1-andy.chiu@sifive.com>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
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

