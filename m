Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8132B6CAB0B
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 18:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbjC0Qvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 12:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbjC0Qvx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 12:51:53 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FE04EE5
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:51:30 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id p3-20020a17090a74c300b0023f69bc7a68so9529470pjl.4
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679935886;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2/srIeqtOeL8WlVYBrDSAnb/WyWsrKaiEJtMn58iONk=;
        b=S+G5hxMa8FHZQrhqGijYCKM1PpoYhvafBo0pzksNyKA+t6YemdQur99OZV3pOYk4t9
         TQEmxHqKFD4uaUhEZfgpn01wEJKZOOxVzyYiwnSJNkoOEOAwDPHYxytOOoz01L2RTfJt
         y7RxDDofYQIkmOhKctmZm0rV+XcZGvFcGp69FwZcHwJfVVyaAlV/UnF+g0gOPQkpNK/z
         AmxjQ9jnGhLn2G2CdZT01UAJsbZ1ay+clF+ffSyNkZwtL0usANVzVNS7HXSi7oaqSPIp
         FH7BsAQ2ag+dJ1wcxgg2AS65TTDDOqER0T+Azh9QyCAjNBMRMubeMyCtA+87dF0Lq7+w
         cbhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679935886;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2/srIeqtOeL8WlVYBrDSAnb/WyWsrKaiEJtMn58iONk=;
        b=YPq4cuWfCtJhWqYq4Ye3rmeFCe2oFL0vTwhwXAfboSdzIjP8Y8s+MRPftTbHDosEbl
         txxILYNbKhAI/vD15Ha5ygr3HwAmrKzzFo6tnN8x+Yh3OaLNyZv/uTfiD4BO9nNVa9oN
         Zg7AUs1LgE1HMs6mrPPV5LH1xuvUFze3Ry9k8/ogfd0mYEAz6ZbzNPKHSGMeUbAozygU
         a0/thnz1nJ0RjRhNPw5uU7WIZAWU9nNfSRI7PKXHRdKKTUz8B+pWbR/p2cc/B3hO2d4q
         EXEMlthah59DUoFtDBYUdZyK77Qs4xMf3GkrJDC3MBQX2Pnf2TsIEkxnHBKB37W9luxg
         JUcg==
X-Gm-Message-State: AO0yUKV4vOA6f8A8sWayhgyWpzyYgV2nnAZDx+N2stsfTkmQdv3phUB2
        WRJQu+2jsOlVE+izliTMVL/dug==
X-Google-Smtp-Source: AK7set8rHNPlr4/8uNjyfhGHjyZcDtmPKfd69HF5oEKXIuGh5URqxNlGnm/bBodnJdQD3PzNYK1FZg==
X-Received: by 2002:a05:6a20:b806:b0:cc:f7ad:eb79 with SMTP id fi6-20020a056a20b80600b000ccf7adeb79mr10767038pzb.52.1679935886062;
        Mon, 27 Mar 2023 09:51:26 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id q20-20020a62e114000000b0061949fe3beasm19310550pfh.22.2023.03.27.09.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 09:51:25 -0700 (PDT)
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
        Conor Dooley <conor.dooley@microchip.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Guo Ren <guoren@kernel.org>
Subject: [PATCH -next v17 16/20] riscv: prevent stack corruption by reserving task_pt_regs(p) early
Date:   Mon, 27 Mar 2023 16:49:36 +0000
Message-Id: <20230327164941.20491-17-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230327164941.20491-1-andy.chiu@sifive.com>
References: <20230327164941.20491-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

