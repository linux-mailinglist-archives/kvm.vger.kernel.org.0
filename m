Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD4764FB40
	for <lists+kvm@lfdr.de>; Sat, 17 Dec 2022 18:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiLQR35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Dec 2022 12:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiLQR3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Dec 2022 12:29:51 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C0E10FEA
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:29:50 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id vv4so13002387ejc.2
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZJBMjUuWi5LDeqCkrRIBhFSAN2qMGyBc5fH/hW07Wew=;
        b=Ce3aVdizpJjs3ywka/oZyIGX96iCyGdZ0PTh+5EV+KuosLgV+76u2Rj8tAWqH613JD
         Wy871aO87+6usyV36L9I5EO6nTmKOEv70NRgpMr2W53yqYgjK+bHsqe2AmNCki3JU3GQ
         h5bzXGd3AMRlIRwaKaPz/t0jPRVFqAvLdGKpPJll83EGbn2NWCtGFScFWlXFiWsN5x5b
         Yr3utM1/w9WTcWse2NFhi5Fn6ZHYSxO8W5tS65QBKWQw7ton4dKiPmF90D9LG9xCf9D5
         lxvvXbtrm+9wjVZas9PwqvJ1ggX1iUfYayTHUkkNRMFutCMsTC/VrjJfr/fG0rM+FeS4
         peqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZJBMjUuWi5LDeqCkrRIBhFSAN2qMGyBc5fH/hW07Wew=;
        b=i+RBdYZYI8qFd/JgwTfoWaUnxq5qg7hQFUn1atNMJP0u5UR7RchYAz+WSXxE9SaE6a
         bb3xNof5yV5H+McCG8TmTYctKJhNHWwOMqndb+YkGlJtKHTgLC4wb78BiFdYPrP9fAKG
         HUep9S56P0y0V5nZCFgGDhGANdW8fhvXVj4FOvyRC5hn/4+qXXvxAqpEgWvrvJJHgwR0
         5v+xGUhwR1p6vd1r0oGrLGxQ4IMd5eXPmWgoadxHrhjXke4WznHtNAihX8kBqcexEPoT
         oA24pvp9kgGFAg8b4aNs7pF2DcViqTSza5UCCFpS//2klZ4OrGmQOKY5hWeV1iRFdRMf
         NS/Q==
X-Gm-Message-State: AFqh2krdbI59WIRD2ee3x8hJJQx/asYRk4xkud4t9vQgNySPAhknpt1E
        lUUg2Snqn7llGgV2LeYc65omYg==
X-Google-Smtp-Source: AMrXdXujsqEG4u9fTuNgJiBiJD+KD1h++fJ35JztdqeJ9EpX2ZGquGN4RZ/riwO3nHDjMsMYoxpMWg==
X-Received: by 2002:a17:906:c0d3:b0:7fc:4242:fa1d with SMTP id bn19-20020a170906c0d300b007fc4242fa1dmr2754845ejb.54.1671298188829;
        Sat, 17 Dec 2022 09:29:48 -0800 (PST)
Received: from localhost.localdomain ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id op1-20020a170906bce100b007bfacaea851sm2171205ejb.88.2022.12.17.09.29.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 17 Dec 2022 09:29:48 -0800 (PST)
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
Subject: [PATCH v2 4/9] target/ppc/internal: Restrict MMU declarations to sysemu
Date:   Sat, 17 Dec 2022 18:29:02 +0100
Message-Id: <20221217172907.8364-5-philmd@linaro.org>
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

The 'hwaddr' type is only available / meaningful on system emulation.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/ppc/internal.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/ppc/internal.h b/target/ppc/internal.h
index 337a362205..901bae6d39 100644
--- a/target/ppc/internal.h
+++ b/target/ppc/internal.h
@@ -242,9 +242,12 @@ static inline int prot_for_access_type(MMUAccessType access_type)
     g_assert_not_reached();
 }
 
+#ifndef CONFIG_USER_ONLY
+
 /* PowerPC MMU emulation */
 
 typedef struct mmu_ctx_t mmu_ctx_t;
+
 bool ppc_xlate(PowerPCCPU *cpu, vaddr eaddr, MMUAccessType access_type,
                       hwaddr *raddrp, int *psizep, int *protp,
                       int mmu_idx, bool guest_visible);
@@ -266,6 +269,8 @@ struct mmu_ctx_t {
     int nx;                        /* Non-execute area          */
 };
 
+#endif /* !CONFIG_USER_ONLY */
+
 /* Common routines used by software and hardware TLBs emulation */
 static inline int pte_is_valid(target_ulong pte0)
 {
-- 
2.38.1

