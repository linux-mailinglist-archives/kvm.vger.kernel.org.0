Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E9C6FC3E2
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 12:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235138AbjEIKbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 06:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjEIKbO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 06:31:14 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4187EDC62
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 03:31:13 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-51b603bb360so5179635a12.2
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 03:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683628273; x=1686220273;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xZD7AFVtobxh1FGjEKQD2QW8IDIT5bzbSx/S1GQl+8U=;
        b=du0Io6LpcTYopchyJqH+rRocOYaZGCdablSccjAYQc49Ba6S0Rrmyl+ci/Z+nxxPQw
         YaGBoKgHS8g3Qaggx+BYSu+hG+hAq80EgnZUR8Ct3LhmNYq4RlRrKbL4AwRUdiHmIlkD
         OcFpHCYfFBsM0b1GAsqbvXLC/uMZqsaurfdT4Zi4oZieblml1tYf+lAmm06k2j/ghmRA
         nZJfoSzceS6dk8Uj9dFuPVrcmHIow3ct78SnSgotzluof0dvxdUaahq1BZuj286W1pZO
         XxyuRuSDnvPxZj5Nc+Egn1JuGzOsL+9sOHwXxobILy/DT2BmJPKbef9R6okXZQ478eGF
         TGmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683628273; x=1686220273;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xZD7AFVtobxh1FGjEKQD2QW8IDIT5bzbSx/S1GQl+8U=;
        b=Ok41Jb8EcU3jBbhV9MlV/7bmquhEQ0+PB5zOR02ldvEp95rXRC5JEaHFZbz4+qpP9H
         3eRYLBLeIGoUSUFvFPmQ5/LIQWMAzjc+a3tRUh2MbEYeavHdIkPnM1WE7I8ihSa6ELTt
         MHg3qrfGe43XuuvJZ+0BjrErak50fx7Tg+PQ/2brniEsspDomH5ToYsWi7FocBDvryPT
         JXlNj245tcwARwMPjYhExZ0M5684qACZArJvoVl02TzZSRFOf1DHvZ5UxE/5n37pQup1
         x7ZBnSMue/90DaaMYHRPWm4dIeDDZHefGLrG0zQfXo9Srfk0t2nIHe/YvVhaVADUVcND
         DiKg==
X-Gm-Message-State: AC+VfDyBm25mN2QXTYUzwFIa0mnsyCfPUfszYcj4bif6aKvz6KRX29wE
        6HvuP4ofeda7ueSJEhl5ttzrTw==
X-Google-Smtp-Source: ACHHUZ7IV6OdLi4xQaDu/P5gI9gcveGZ+FpKBQDsjRAPmDvKXG6DubfHPMgSkhsF+HAPAzAZIy4G8A==
X-Received: by 2002:a17:903:18f:b0:1ac:8717:d436 with SMTP id z15-20020a170903018f00b001ac8717d436mr5304921plg.60.1683628272702;
        Tue, 09 May 2023 03:31:12 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id o11-20020a170902d4cb00b001a076025715sm1195191plg.117.2023.05.09.03.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:31:12 -0700 (PDT)
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
Subject: [PATCH -next v19 01/24] riscv: Rename __switch_to_aux() -> fpu
Date:   Tue,  9 May 2023 10:30:10 +0000
Message-Id: <20230509103033.11285-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230509103033.11285-1-andy.chiu@sifive.com>
References: <20230509103033.11285-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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

