Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE987085F2
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 18:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjERQWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 12:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjERQWO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 12:22:14 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EFB10E5
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:21:58 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-64cfb8d33a5so1250256b3a.2
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684426917; x=1687018917;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hWB54ZotS7Y2ZgKJV1SIpYTu+cs8XvC1qHz0MxJpXfU=;
        b=DGKjO8NcwUk0/DKRrmFQ6DSpuKniTiKp3Pz+trn/r0hRfga8Uj0enswejcZ5c4uzHJ
         vdwhENPpTx1lmdqW+QiYAe3EkLKg9J/bUHnpIJsEYAvrom6+tKIsU/6mfuCiYUqoxO98
         sbit6himBJBuaC9Y/STpCvGDLiDNxaF73eRGhC3kirczHR+ov7NEbXcE+xLPhz6G/p1J
         MhliflBDkN9Muh0gMHNPw6kaEu0CxiXKLyJWlJcGx5vtAqFnMck9LTJG3+slQZIKK0ue
         UmpzGf1TynAaGkgU7JuuxnBp6mamvQVwqayPHeoA/viy+gznzvccBoP/fESJPCdffwR3
         Q0jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684426917; x=1687018917;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hWB54ZotS7Y2ZgKJV1SIpYTu+cs8XvC1qHz0MxJpXfU=;
        b=ZwkstOugtW+E7EvwNlF8Hc4S11iXBS0tp0QIzm8Ot3+8EIGgUlmkifGXMCF/zjogro
         wPyNbKe2XtqfZWQUgnQXk8kskNotb2xHYfoy2xMzdMh1Ml95kf6di21KEALE+Uxh1iKi
         /DTji5zIW5CBERB7m3wI8UI2bwOsedoLwcxpyb0uL5lfTptrnSedciv3WPy3EOCacUzC
         kxg8q8SjbSZ57yOUdfOC8BfetNZoEF+OxTei3qwaHur7pl9bHn1Q1iWIH9m682dwXpqb
         0xI+JL/Fx4+A28f7L1VolSAOxsBDG0r/71bkIhDg9AIHre1n1jjHQkI4sHUCW6lszPvl
         rF5g==
X-Gm-Message-State: AC+VfDz8qj77ganxp8DRFA3pXanKwEzdHbLuSevIF89+ppFMchBx1AvH
        fsQR6qDUfIuWmrM8wsy8oZtoDQ==
X-Google-Smtp-Source: ACHHUZ7DzGc8mbcm6gyG1FaCHM1UkX6ZTTMNq1vqBYdrEFA512Vhot+N0Bt1uC5VXAF+cM6Xb4Xpjw==
X-Received: by 2002:a05:6a20:7489:b0:102:3f67:dbe1 with SMTP id p9-20020a056a20748900b001023f67dbe1mr422644pzd.4.1684426917627;
        Thu, 18 May 2023 09:21:57 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id x23-20020a62fb17000000b006414b2c9efasm1515862pfm.123.2023.05.18.09.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 09:21:57 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, ShihPo Hung <shihpo.hung@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexandre Ghiti <alex@ghiti.fr>, Guo Ren <guoren@kernel.org>
Subject: [PATCH -next v20 17/26] riscv: prevent stack corruption by reserving task_pt_regs(p) early
Date:   Thu, 18 May 2023 16:19:40 +0000
Message-Id: <20230518161949.11203-18-andy.chiu@sifive.com>
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

From: Greentime Hu <greentime.hu@sifive.com>

Early function calls, such as setup_vm(), relocate_enable_mmu(),
soc_early_init() etc, are free to operate on stack. However,
PT_SIZE_ON_STACK bytes at the head of the kernel stack are purposedly
reserved for the placement of per-task register context pointed by
task_pt_regs(p). Those functions may corrupt task_pt_regs if we overlap
the $sp with it. In fact, we had accidentally corrupted sstatus.VS in some
tests, treating the kernel to save V context before V was actually
allocated, resulting in a kernel panic.

Thus, we should skip PT_SIZE_ON_STACK for $sp before making C function
calls from the top-level assembly.

Co-developed-by: ShihPo Hung <shihpo.hung@sifive.com>
Signed-off-by: ShihPo Hung <shihpo.hung@sifive.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
 arch/riscv/kernel/head.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index e16bb2185d55..11c3b94c4534 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -301,6 +301,7 @@ clear_bss_done:
 	la tp, init_task
 	la sp, init_thread_union + THREAD_SIZE
 	XIP_FIXUP_OFFSET sp
+	addi sp, sp, -PT_SIZE_ON_STACK
 #ifdef CONFIG_BUILTIN_DTB
 	la a0, __dtb_start
 	XIP_FIXUP_OFFSET a0
@@ -318,6 +319,7 @@ clear_bss_done:
 	/* Restore C environment */
 	la tp, init_task
 	la sp, init_thread_union + THREAD_SIZE
+	addi sp, sp, -PT_SIZE_ON_STACK
 
 #ifdef CONFIG_KASAN
 	call kasan_early_init
-- 
2.17.1

