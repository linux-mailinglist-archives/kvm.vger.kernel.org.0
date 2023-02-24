Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781156A203B
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 18:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjBXRD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 12:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjBXRD1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 12:03:27 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27383CE3F
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:03:17 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id y2so12820150pjg.3
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=W4ANpghfk7OqklmmNR8esM/3NMZ7VY2gRTQHqD92eU4=;
        b=dMohg4moPmm6cCczEKC8E/zvUDd4dGMuiAb9JR5LsDjbQ6sjcvvNPACcDJS+vQZreH
         s1+d5ZzZVMsBHsXtMphSfqrS6HHGLzYJYVZ6x4DSGXsf8s6LrvXzG3WEo5vzjXnkelql
         Qo1DKU7Xcws0HahmUhV3tZbIqK/0sWTJ2mLv802azlhr34ksVsnDm608sLmrN+P5XmQI
         Hkcva7btRprCmaHI42qzeH/Ixq9t+pwcJH9D9tViYyfO+jsOivEIDYzDNVGs+csjc+AG
         5pBUCCRL6x7J9QzPvgASmSj31o6IFS/IEifv9+pcvHsuyvoaaJd9JfQqPzNTc5Qk/G/o
         IUIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W4ANpghfk7OqklmmNR8esM/3NMZ7VY2gRTQHqD92eU4=;
        b=xOdNO1uXxmTEIOUqnPPB/X2dwDZVysHFMc8WFYIFNNDY55bmQAIZLj5FhkPPE3PSTJ
         KZoGIRNPXbG23x+6t0E8FqtlOyELHz60FXdHKTKPM8TijoaC26xvMDjkQaRg1V1zX63g
         fH6/G/ZbtZsLVxN2CScC8Rf8qecAc/7pYOqQoNw6GEsvkCE/8Ol23yxpF0G7zutVyT6b
         zVWwqs2/OaIn/6QVHCBYJZHi4fjg9/8tzSaGwZUPbcq5toXrb6B3TFo1DxJvnmT/Cz/7
         2UcMJu1soZT+iH0d2mCTGkj7r2TllJKZY2eFjBGITknHyQ8U1WhfHwzZPSFPb9p+fyLU
         pJkw==
X-Gm-Message-State: AO0yUKWY/yhmrBEizLOEUiDsWYVsE6CGXlx0yODLIXy5+pc8AKGRGwJx
        6Q7ei6Cne+T9O9DsKRbVBvzCaw==
X-Google-Smtp-Source: AK7set84M3dR0yl25NPofcni6EwMg6Eo19N35Lc/dXah3YwoY7M9ZpumK8/yDiYHactEzCMuxhMa0Q==
X-Received: by 2002:a17:90b:1b10:b0:237:9896:3989 with SMTP id nu16-20020a17090b1b1000b0023798963989mr2425819pjb.34.1677258197522;
        Fri, 24 Feb 2023 09:03:17 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902b60c00b0019472226769sm9234731pls.251.2023.02.24.09.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 09:03:16 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, ShihPo Hung <shihpo.hung@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH -next v14 16/19] riscv: prevent stack corruption by reserving task_pt_regs(p) early
Date:   Fri, 24 Feb 2023 17:01:15 +0000
Message-Id: <20230224170118.16766-17-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230224170118.16766-1-andy.chiu@sifive.com>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

Early function calls, such as setup_vm, relocate_enable_mmu,
soc_early_init etc, are free to operate on stack. However,
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

