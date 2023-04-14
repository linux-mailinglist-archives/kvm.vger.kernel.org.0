Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C8D6E27DD
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 18:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjDNQAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 12:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjDNQAt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 12:00:49 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526E1BB80
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 09:00:34 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id y6so17638807plp.2
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 09:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1681488034; x=1684080034;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hWB54ZotS7Y2ZgKJV1SIpYTu+cs8XvC1qHz0MxJpXfU=;
        b=KmNeQFGssjzK0xQ018T4SlGSmqFwJkBPec76ZOBY4rleHRUhzy2MMot645T/KeOxTy
         oCUzwlMXTlgUhoQ2v/rnI/1nwPbARVDCBxETuqvmwYWIRGAEKZrfCo/iztYx6JyMhV5g
         O+uRyS2XqxLUA9A2EqVkmDcKftggvVg/dsNE+MsWdowrLBiDFI9/WYMvk5bD4fSOT/xC
         FXhbKspwDSOieEFexzugK5oDC5yGNjFwNTmfgG/PP2YFGoMJGq3iCMX/8OPkOd/KD9h8
         85Ymzshlsn6z0qRvDtlK0U7vbXaDnK3OjPzWfGqXH1wh0EWCZW+8yhpIAOLa670BS84k
         KT1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681488034; x=1684080034;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hWB54ZotS7Y2ZgKJV1SIpYTu+cs8XvC1qHz0MxJpXfU=;
        b=Pygi/mTmy7ehrECQutLzxJlm0cZ35XfhmDmX0Z8GtdkIyw3vvUAzZ7ac2SEIp/5R4D
         V2xbu1oX8qb90g5LfQOaXffGejwVRPzyI2y7HhG6XNz9D8/S1CO6jOTW9vUOqA0xsdLw
         h5Al+6LGScObGHru1UCXiZnhMucm0DQwMiJBUkmNI0pRPonz/cJ0idVAYFB36VYb3+0M
         55wZnHJNoAeh00+H73WmW57baIsBWswkenS+xkNqosxOohoN7fLiyxCX7OocytlNkv/N
         mkomPNEV40o1mN/8RkHVBr1ZWcJaCWj2tH8Fsy73FPjMl5vzE6a8aENHzv074OvS/xSK
         naxA==
X-Gm-Message-State: AAQBX9fhH1GC0mNnj4b5yHte6IpXrR4ohfenbiKjBPQ6fuSsrEP0hZoZ
        B5UW68iYSLW8GAR1Q/TBWYJoGA==
X-Google-Smtp-Source: AKy350bLWel/6yEV1JmbLZwHUbnX6eF24BdOzl+/i67z9xt7yAYwzmd+UIUx2N8+rcDKw8RpGj4wSg==
X-Received: by 2002:a17:90a:be08:b0:233:f786:35ca with SMTP id a8-20020a17090abe0800b00233f78635camr5818524pjs.35.1681488033705;
        Fri, 14 Apr 2023 09:00:33 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id br8-20020a17090b0f0800b00240d4521958sm3083584pjb.18.2023.04.14.09.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 09:00:32 -0700 (PDT)
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
        Conor Dooley <conor.dooley@microchip.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Guo Ren <guoren@kernel.org>
Subject: [PATCH -next v18 16/20] riscv: prevent stack corruption by reserving task_pt_regs(p) early
Date:   Fri, 14 Apr 2023 15:58:39 +0000
Message-Id: <20230414155843.12963-17-andy.chiu@sifive.com>
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

