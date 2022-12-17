Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1035F64FB46
	for <lists+kvm@lfdr.de>; Sat, 17 Dec 2022 18:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiLQRai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Dec 2022 12:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiLQRag (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Dec 2022 12:30:36 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D082E1114B
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:30:33 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id z92so7710959ede.1
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wk4kZcMMisFWgQ9gHzikpbBAxoBtm1ZzojbUpYahP3s=;
        b=FImUCwLooRkHMftIyWdZtUzg3r8gzuJWqATacIo/a2IHDL0VlPpzbNKh0Kqs9s//2A
         fiP77CgQeRNYTkHkiuW3xwUS+sUpvFx+7mh85VdTesGbMR4QkiZFv46f8Ks5zk4Q5F4d
         QPybhshBSKIJ+vFo3Nj3N1cRIfpicTXB0/4OTp+RomhSGV6mF2ixV80MOvF+IKEN/G+6
         4zGKPlBttrdio1Bc1yZoKEOoGwEuLXQ8updTxegKSJbLXP9tD4ULjvDEB1DwTysTttU2
         X5mJmPFqdxLwZE/XR0BdiSNAH6iH/Nk6gk/XXyCnRlUnFOnuffr0OhX8KGJpdb/sp1un
         wgGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wk4kZcMMisFWgQ9gHzikpbBAxoBtm1ZzojbUpYahP3s=;
        b=6BsfqA9aREKHytxLH9hyC2UqAP5/TfYyC8Y8WURlA2tcahWMpPkdBAKuA6RqbhKtNW
         zjrxQXjgvy5awk3qNtA7wuPz24q1MgIPBvQIVRzoB8/HOBfQVQnOQ3xKFfKng2xXuHFT
         x8MrHOHFg+x7OgC7/rtuMcPVfJUXXZJJD0QNDy6EWSpDbZ7fLnR77kYER3fgwTI/y9lO
         f1z6uq+g9gRLWUx7DJ2/v7Xxj8Egwdj1FBjVWne39ppMgnkbH9YRsHyUyXlnPTVlPWDE
         CtYuFUOsFhJa4cRb9Tjk2cA7Ppk81LMjrrytllypzLJSwn85UfJpLh89+SEAk02XtOnm
         BIWg==
X-Gm-Message-State: ANoB5pm3NHrsjCHZW5W6RGNjA+GlR8fTBN/kXJl+K3KpSCZ1wkMRZ0iC
        0wUdiQdBDOIK59ucX1F38Jg5Xw==
X-Google-Smtp-Source: AA0mqf45QvH8X+0lM3DBpfMGzi/ctagLAILTTUMSvXtML7RQSQ2VFLjDj82fDwwY5MebVnBd+5tA5g==
X-Received: by 2002:a05:6402:548c:b0:461:6f87:20be with SMTP id fg12-20020a056402548c00b004616f8720bemr27829816edb.41.1671298232467;
        Sat, 17 Dec 2022 09:30:32 -0800 (PST)
Received: from localhost.localdomain ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id z7-20020aa7d407000000b0046b531fcf9fsm2196443edq.59.2022.12.17.09.30.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 17 Dec 2022 09:30:31 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Bin Meng <bin.meng@windriver.com>, kvm@vger.kernel.org,
        qemu-ppc@nongnu.org, Greg Kurz <groug@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Bernhard Beschow <shentey@gmail.com>, qemu-riscv@nongnu.org,
        Song Gao <gaosong@loongson.cn>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Laurent Vivier <laurent@vivier.eu>,
        Alistair Francis <alistair.francis@wdc.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 8/9] target/sparc/sysemu: Remove pointless CONFIG_USER_ONLY guard
Date:   Sat, 17 Dec 2022 18:29:06 +0100
Message-Id: <20221217172907.8364-9-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221217172907.8364-1-philmd@linaro.org>
References: <20221217172907.8364-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit caac44a52a ("target/sparc: Make sparc_cpu_tlb_fill sysemu
only") restricted mmu_helper.c to system emulation. Checking
whether CONFIG_USER_ONLY is defined is now pointless.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/sparc/mmu_helper.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/target/sparc/mmu_helper.c b/target/sparc/mmu_helper.c
index 919448a494..a7e51e4b7d 100644
--- a/target/sparc/mmu_helper.c
+++ b/target/sparc/mmu_helper.c
@@ -924,7 +924,6 @@ hwaddr sparc_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
     return phys_addr;
 }
 
-#ifndef CONFIG_USER_ONLY
 G_NORETURN void sparc_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
                                               MMUAccessType access_type,
                                               int mmu_idx,
@@ -942,4 +941,3 @@ G_NORETURN void sparc_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
 
     cpu_raise_exception_ra(env, TT_UNALIGNED, retaddr);
 }
-#endif /* !CONFIG_USER_ONLY */
-- 
2.38.1

