Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435CC64FB3C
	for <lists+kvm@lfdr.de>; Sat, 17 Dec 2022 18:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiLQR3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Dec 2022 12:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLQR3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Dec 2022 12:29:16 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CAA910B71
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:29:15 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id jo4so4013434ejb.7
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RkESMP3x1FE047sZUBJV3WOGl5f5HviWYbiyNe/Ty0w=;
        b=r8t7gfWG44OuIBDPgERWEIrmMq+3xtXx9TsAgBg6NPydgamW7MqFqdBo7Jl1ks3/rG
         KV/ongsim603ZgWgNeXUty+30Rg6f5WNKH8mgCUAB80pm4Qk8R+oRHWnHrZNLjK/AU5B
         X2zXWUy+93dK+lVfodvv2yowe9gHbVXkusvEhapVHa3SaagySt+0mhesOVBZVf3ojZRl
         Kt8cRBe5Ut7uWUQGVFDei6cQBklOm++BxivHyAdU2tJza900PwNNMwnwX0NzBexC2egR
         fxY9YBHGrbsSrxgme+RI9N11kr2YZj+U/imVxJUFO5mLWn+c/b2/JvyZlz+Igs8ZsxFZ
         nz3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RkESMP3x1FE047sZUBJV3WOGl5f5HviWYbiyNe/Ty0w=;
        b=PRwYtSaHn0J98UDYgCH4/ItlByLkmGdNgwT/uRc73ZL2vEnW7MqJWtp7a/8PfxM6hK
         49WKMMpWnVWpO3DJ9/x1A+/kHZVa2BmhPRFbGu9xYDNdRcKiSeB2tvbAV1rZEMhxSOIG
         nAqh3kPhCfqKxPo4BDmd6fw4FP7u8U3x+B9DdN9TAKFdiVA1BRL5XKBJkvum92xBre6a
         Ex3UyjeosATKIvHUrvdetZSayZzSm0Ibmq8Tg7l+RHZyIqbBUQnsVR+xxJ7tfA1MMcDD
         Z3clmH5z+iQ/a/EPbNg3D9q+5IyiT70VvW6nSsjObpPGGXFTp+fLgMkkTtn3PZOdfN0u
         3tPQ==
X-Gm-Message-State: ANoB5pnSRGUb069yKsrZKzt5Z9OC7tQwX6xvANLdSSnkiq6dr6I6OTgw
        cmqq0IA/TZDmaiksJyFVxJO8rw==
X-Google-Smtp-Source: AA0mqf7bplq0MI9y3hQD8R/dtV9v7/hoZBZEQfuXG3+aSQszzX9lCXgjToXydjQ+IJPgTfteUVcFnw==
X-Received: by 2002:a17:906:4c4b:b0:7c1:1ada:5e1e with SMTP id d11-20020a1709064c4b00b007c11ada5e1emr29928529ejw.26.1671298153883;
        Sat, 17 Dec 2022 09:29:13 -0800 (PST)
Received: from localhost.localdomain ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id o17-20020a17090637d100b007c0efbaa724sm2185713ejc.49.2022.12.17.09.29.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 17 Dec 2022 09:29:13 -0800 (PST)
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
Subject: [PATCH v2 0/9] target/misc: Header cleanups around "cpu.h"
Date:   Sat, 17 Dec 2022 18:28:58 +0100
Message-Id: <20221217172907.8364-1-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These patches are part of a big refactor cleanup
around "cpu.h". Most changes should be trivial IMHO.

Since v1:
- dropped patches including "cpu.h" in multiply included 'helper.h'
- dropped Hexagon patch
- better split sysemu fields in RISC-V's CPUArchState

Bernhard Beschow (1):
  target/loongarch/cpu: Remove unused "sysbus.h" header

Philippe Mathieu-Daudé (8):
  target/alpha: Remove obsolete STATUS document
  target/loongarch/cpu: Restrict "memory.h" header to sysemu
  target/ppc/internal: Restrict MMU declarations to sysemu
  target/ppc/kvm: Remove unused "sysbus.h" header
  target/riscv/cpu: Move Floating-Point fields closer
  target/riscv/cpu: Restrict some sysemu-specific fields from
    CPUArchState
  target/sparc/sysemu: Remove pointless CONFIG_USER_ONLY guard
  target/xtensa/cpu: Include missing "memory.h" header

 target/alpha/STATUS       | 28 ----------------------------
 target/loongarch/cpu.h    |  3 ++-
 target/ppc/internal.h     |  5 +++++
 target/ppc/kvm.c          |  1 -
 target/riscv/cpu.h        | 23 +++++++++++++----------
 target/sparc/mmu_helper.c |  2 --
 target/xtensa/cpu.c       |  3 +++
 7 files changed, 23 insertions(+), 42 deletions(-)
 delete mode 100644 target/alpha/STATUS

-- 
2.38.1

