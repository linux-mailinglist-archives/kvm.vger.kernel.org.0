Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF966BE86A
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 12:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjCQLi7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 07:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjCQLi4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 07:38:56 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA4115880
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:38:18 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so8790713pjt.2
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679053077;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2/srIeqtOeL8WlVYBrDSAnb/WyWsrKaiEJtMn58iONk=;
        b=JTsUG/K5QtL0DcwnamfsJrMzXDQ7zOkJtx0wegxPmA18XsJ4/5yCCu6YfqY0KmiSpe
         l+kvxhhrIt/CfokY+rUkAy/f7XFtL3ZpP61hyC3y87rLTamoQEN6XPFHCgWAnuhnmVm4
         6nctYI1xK5eC/YCCg6k70XgE4+QACVApaoizHMjKDOc/UmEk0RJt3OnGtsTPtysVdANL
         +J9hQdU0YZgYFcDtrkRDyz8Kh1dv4Wf5GqHG1QxfH9+ML5NsIlyAieagxROEUTkbtrig
         jY+ZcQOfkxfEBF/DahZxkKABEyC5RKjYpiQwh5f9xthiFP+sfdMFhdkExxhpnm2voInl
         LI9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679053077;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2/srIeqtOeL8WlVYBrDSAnb/WyWsrKaiEJtMn58iONk=;
        b=WEx+cWFhW+E1GYtH8gO3QMgVfESrgSK2mMJoY3s9lSrVlKgDqEd/ibgwMFZWgtsVsO
         /MwWIfK1O1gzqUgQJXMsmxcOD+l5MWe99oZaNmmK8owK0eS/P8s9l912/9H5z2keE37K
         wCmDDPqvt+h4FJ+IZprn4cPB0Hqya4zOIp9zpB8YEu0raiieMtwrMabftvozcEgAAfhA
         85Qcz06pZ4itLp7+VHuykAqbhsmIgfiYJKBAlQh+i2V2kt/0bk9oyZ0jgOURMTTfuXjZ
         AtDwkMqBy0rzfxu/0xYPzMv4MWEVN7vZAKIitcfEicYNYqFGy9powmKzzywV3gbFQG5U
         PyHw==
X-Gm-Message-State: AO0yUKXqwoimSp7P9l31kgBJWoGarpyRbkot2oJWVM7uVy7TbgQu8Vbe
        o3HeYSGcHjpGyjU4oHiqjl0ILw==
X-Google-Smtp-Source: AK7set+SvLkgLD55k9exmeaGWXbyv8B92DP3AAq3POzq7CvetackAp4FKOja4aWavUybfyNLCQhgMA==
X-Received: by 2002:a17:90a:51:b0:23d:4b01:b27 with SMTP id 17-20020a17090a005100b0023d4b010b27mr8210678pjb.10.1679053077169;
        Fri, 17 Mar 2023 04:37:57 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a2cc500b0023d3845b02bsm1188740pjd.45.2023.03.17.04.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:37:56 -0700 (PDT)
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
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Guo Ren <guoren@kernel.org>
Subject: [PATCH -next v15 16/19] riscv: prevent stack corruption by reserving task_pt_regs(p) early
Date:   Fri, 17 Mar 2023 11:35:35 +0000
Message-Id: <20230317113538.10878-17-andy.chiu@sifive.com>
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

