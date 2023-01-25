Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D59967B424
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 15:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbjAYOVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 09:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235053AbjAYOVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 09:21:09 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E673D93E
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:21:07 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id e10-20020a17090a630a00b0022bedd66e6dso2192404pjj.1
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KWPmdzL4KDI+P9FBRLObkkbD4XUM8Bx5n5J13K5PnOs=;
        b=hQuUO/eo6k4eleNUG2ld9HYEpLREF+8/F/IBdxy8iFtmwvco51oOCCsBrvWqOQcvCW
         UkWEJ+Jrtx2Yxp7WpQVSXEvB2kPxcduH1wd1UXgfqsEOQAQ2O6F+ZoUcMoyFYiZI8k6K
         rnGlQ0YhTvNhfQN4NFD4WDTMKvRvHDIToHFKdIG51uyShesnebUdMRnMu+xr+iBAspPl
         fFgoZ99EQ7CjXoD7mDz48PE407ybNXBraAFzBjx1X4JIj8MzrOkWBVbgxwyf0s6kUxl0
         +BYb1qUs5iyeKjLZyiyqB3iBkkjH6FvCMCqA7cCms4s3yRP0L8174EsQH55P9OxxQhYq
         GvYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KWPmdzL4KDI+P9FBRLObkkbD4XUM8Bx5n5J13K5PnOs=;
        b=Nj7+C23C1p7CvSVMZTGHfBPRjTR/sAzXvhJzcX/RxAwk7v2SBeS5R7rkS6yg0msB0Q
         7h69ZlYsW/cD+j5qiF9DO8x2b/4tLxSJdcWGmOgP+a3EUeRsXucxERTq4RfIJpnd972s
         +ziuYR/xhAQmfp7owNjEgHxn12yKOikT946UL4Ib1SB60SpXAYRvhQ5R2koKdLCN7+fm
         M3+Od61NuPfGr2Pfacff/Euhv7qIMbez7WtAzaaUwQpZpro8XKNymWmHACM0Hv3nw1XS
         8KR6vn2k24cwQAdlKde43fbPp8JrnzBpKlpZ22FOmaGJCgHZIQD4Iy6d/Lq0RrL64MM7
         MQDg==
X-Gm-Message-State: AFqh2krO8E4ufisuIGFMqWwETLsckkDnAp2+NVT3SClKmpiGem6He5Bi
        49UBQj2lNFXA2lJO66lLIbKZTw==
X-Google-Smtp-Source: AMrXdXsl7rV8DsXkMHGVa7+IIwGPdkE61rCL6eL0mrsIe4bJEIjl2yD2X8Uap2oWLC5MpweONerK/w==
X-Received: by 2002:a05:6a20:394a:b0:b0:5600:f2b7 with SMTP id r10-20020a056a20394a00b000b05600f2b7mr41499161pzg.54.1674656466655;
        Wed, 25 Jan 2023 06:21:06 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id bu11-20020a63294b000000b004a3510effa5sm3203520pgb.65.2023.01.25.06.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:21:06 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Guo Ren <ren_guo@c-sky.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Jisheng Zhang <jszhang@kernel.org>
Subject: [PATCH -next v13 01/19] riscv: Rename __switch_to_aux -> fpu
Date:   Wed, 25 Jan 2023 14:20:38 +0000
Message-Id: <20230125142056.18356-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230125142056.18356-1-andy.chiu@sifive.com>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
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
---
 arch/riscv/include/asm/switch_to.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/switch_to.h b/arch/riscv/include/asm/switch_to.h
index 11463489fec6..df1aa589b7fd 100644
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
@@ -65,7 +65,7 @@ static __always_inline bool has_fpu(void)
 static __always_inline bool has_fpu(void) { return false; }
 #define fstate_save(task, regs) do { } while (0)
 #define fstate_restore(task, regs) do { } while (0)
-#define __switch_to_aux(__prev, __next) do { } while (0)
+#define __switch_to_fpu(__prev, __next) do { } while (0)
 #endif
 
 extern struct task_struct *__switch_to(struct task_struct *,
@@ -76,7 +76,7 @@ do {							\
 	struct task_struct *__prev = (prev);		\
 	struct task_struct *__next = (next);		\
 	if (has_fpu())					\
-		__switch_to_aux(__prev, __next);	\
+		__switch_to_fpu(__prev, __next);	\
 	((last) = __switch_to(__prev, __next));		\
 } while (0)
 
-- 
2.17.1

