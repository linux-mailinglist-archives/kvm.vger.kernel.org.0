Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735B76FC3F6
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 12:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235325AbjEIKd1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 06:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235331AbjEIKdQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 06:33:16 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690C4E77
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 03:32:59 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-5144a9c11c7so5344566a12.2
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 03:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683628379; x=1686220379;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hWB54ZotS7Y2ZgKJV1SIpYTu+cs8XvC1qHz0MxJpXfU=;
        b=QkSGQgEeLO0u2CM+0ENpyxSPJrVs5RDZxlAodKF2CMos24WptSccSet4gExIwDxgKY
         J53EVXnz92lB7aO2d6gQHFtDbzXVUCM5MbFmhVWexLhy5xFqQhTKL1HCd6G6OrA62ayQ
         XSxva6pG1WoKVxi15tFy8H4EAjDnV+L4mxEjpCx43pdqaxP+/JYCPRb2nJmIzOHPJgf8
         vdo1u82T8B/b1ar1wFoUR43j0kvuKZHIslOperfivstB7OWv7yhuVMYdfXB/yHRo+GuN
         YBOa11pFpVlI7ZgSjhHcjzFku4nq6xcooejKrOPSRTmQgYpXps+BjhUzW5FOoCmDRwiV
         uTjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683628379; x=1686220379;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hWB54ZotS7Y2ZgKJV1SIpYTu+cs8XvC1qHz0MxJpXfU=;
        b=DrQjVtkC+LnfIRUAxqlg25EZn0pijwbAutKTLbuWqofEu7pvBKpzK2IzyIIbzyouVM
         Lo8G9T0b5hKYt30bBZj+CUYBd8x1IY+0cGWlr4Q3PXpdDcPzBTXaY3PXIifM8aIuh+IO
         3bX35YDW+TRWCcMjZanMo2Y78QBcp/nDo2q/VfDxwhfCtk8fdpBnpqpO9jRtkNnAs0EH
         SxTGdPcMeRU4GpkM/OVwGXopGDX5GJ8Vizf64BbV93AWoO7p0ykzg6DTW3W5jjoCEkt0
         SwEm5klvdLkvwINc+VKOLZ9Bu2OUlwRD4aSgFoxu4WP59FLy/rO251Vk7ECIjlcgVIWT
         b+uQ==
X-Gm-Message-State: AC+VfDwEAhGLzLgUV4G4onLN6cQXJLl1HH6zc+7S1CGdcuBNyxZsvELO
        +6+L6u5KgBwBgReD8ywMCRDXOw==
X-Google-Smtp-Source: ACHHUZ4XvQ8y8AUL5cpt7HXQnZP9qpclGxYr2ttP7vra/2g+xq2YwP3+ZiHmOQjumisSjZU4HbyLNA==
X-Received: by 2002:a17:90a:e60e:b0:24e:1ca3:7279 with SMTP id j14-20020a17090ae60e00b0024e1ca37279mr13290490pjy.38.1683628378813;
        Tue, 09 May 2023 03:32:58 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id o11-20020a170902d4cb00b001a076025715sm1195191plg.117.2023.05.09.03.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:32:58 -0700 (PDT)
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
        Alexandre Ghiti <alex@ghiti.fr>, Guo Ren <guoren@kernel.org>
Subject: [PATCH -next v19 17/24] riscv: prevent stack corruption by reserving task_pt_regs(p) early
Date:   Tue,  9 May 2023 10:30:26 +0000
Message-Id: <20230509103033.11285-18-andy.chiu@sifive.com>
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

