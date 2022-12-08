Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD57647345
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 16:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiLHPg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 10:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiLHPgW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 10:36:22 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B4A75086
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 07:35:57 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id o15so997430wmr.4
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 07:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZuF4jChtlBjy8dKWVe0vYW0pjpjwZ/qKs1pftyTULhE=;
        b=dO1rVy8a1UmJNv0075+sKdleWJ0ZBR1e/UgGlysFXEGorO8mWuMdwXUEfXsAxNBZ7N
         qNsS71jo9driQdFOJfvuDDoM4z1PHZ8Oy1Jaa/rj+eCYaVzx71FwSeK1ISFeRL7U5KAA
         89Z988n/DMgUtsS5QrNmwOleyUXYykdhU6LzJ7/yXucBtt0FgLSG8R5FXi4EunqQTZRv
         FR/1/EYdxhbIRQU3fsC9yqne/3YvCIye5fAxc7srypsYFoDgrfrnuuB4xMGGf0CPwB/S
         hrw7s4KyxuvIWWGMmRzNxdcZMb+JQ8mMq/6Sy1gp68NQEExE5BHewvPSaX5MrozUllb0
         Lb3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZuF4jChtlBjy8dKWVe0vYW0pjpjwZ/qKs1pftyTULhE=;
        b=EVDTVy9fh4JMovodH9yUKPXeAOj5v70gh6ZD5hp+bbBVVTlwsyTo96as0OMNQadxmz
         sG1TqxSWGUppCxn7c5Qz8Nx9UVcA++0avcmPKyEhierBrEjx4GsjZ62L9yI1qmZflJ/7
         95OeZaoK+rnNKnZz9uE7CNNOJd+9xXCyjuSf8gEfajJVQhwc8aC4CEUj63Th7ZxJniVz
         B2kSCjED2I3D0DbV6m8ow3pCvFSYWZ5eiK/eMyAc2rQtxrvF1/iR4EmR7so+MUXif+MZ
         22Guvj1ibwKasTkVnv/F6ltwSefEIzHnpj93eONFlT/KiO9cd1vs9vsu7G7TauglmViL
         gjog==
X-Gm-Message-State: ANoB5plf8c4ay9pp9l+g9+7ts8KuDiZAabB89xkEBsWoTPeii7xvhlUU
        a7QJHEEGe0s4TtFQtfSiW0sb5Q==
X-Google-Smtp-Source: AA0mqf6jGRhAbZqyxAoGF7DGrOZx9DCszb4uJRAIqgZjMGG2psmKCgGKAp/AX0U3aU3Jo3ZwbUyGLA==
X-Received: by 2002:a1c:7c15:0:b0:3cf:7197:e67c with SMTP id x21-20020a1c7c15000000b003cf7197e67cmr2335687wmc.25.1670513756301;
        Thu, 08 Dec 2022 07:35:56 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id 16-20020a05600c021000b003d1e4f3ac8esm5089704wmi.33.2022.12.08.07.35.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Dec 2022 07:35:55 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Greg Kurz <groug@kaod.org>, Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Stafford Horne <shorne@gmail.com>,
        Anton Johansson <anjo@rev.ng>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        qemu-ppc@nongnu.org, Eduardo Habkost <eduardo@habkost.net>,
        Chris Wulff <crwulff@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Marek Vasut <marex@denx.de>, Max Filippov <jcmvbkbc@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Laurent Vivier <laurent@vivier.eu>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>
Subject: [PATCH-for-8.0 v2 4/4] target/sparc/sysemu: Remove pointless CONFIG_USER_ONLY guard
Date:   Thu,  8 Dec 2022 16:35:28 +0100
Message-Id: <20221208153528.27238-5-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221208153528.27238-1-philmd@linaro.org>
References: <20221208153528.27238-1-philmd@linaro.org>
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

