Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3476E27DC
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 18:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjDNQAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 12:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjDNQAn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 12:00:43 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7A7B77F
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 09:00:29 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id pm7-20020a17090b3c4700b00246f00dace2so11181893pjb.2
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 09:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1681488029; x=1684080029;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KUlZU4jbXrvVX0wjIPVLaSJmpFs1THD4w3JnPj0HJFk=;
        b=Mlgms75yqWeLTkYqHiJjvSel58ySvtkQoXkycao5QCuLMS7lVEiaDjiq/jUSmK5Um5
         3DrLR+J8vdOtRDmHsrdXtcyucKdJSduoDf2lxFq8pS6ceLqQ4xqpVXoauqY/x6ktIxiX
         HSFUtLZc8iEI5ObhFHkkvcMwLCr4hletTwaolJ0SuFZWiSq9cs7t3oc9/S3640t77Vgw
         yq8um2CLbE1exAnuCTrMjfNE12JtDNuT7kfvM6+CVPA1xovkv27HfXBEyiWPNuKLrMiP
         maFKu5j02IU4mL8vbTb6Du5BAIyyax+Ita/6KJmnARGhLQn31qWxVWKB3B0HCzijeESv
         mahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681488029; x=1684080029;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KUlZU4jbXrvVX0wjIPVLaSJmpFs1THD4w3JnPj0HJFk=;
        b=Z/V55BPZTOZ+sErM1y9/MkK+bHtXPpme4EqOIWwcv+mr7A9TT8rK+kFL2Praem4rzE
         +Wtyjkp0Cm/IclA5ufVf+cCiDB/ojGwOI2VE2a8urfNWFV4gb7o15W6S0zzH4kMpcLhS
         1Fl+M4C2WxDhNGfipQb4KzLFjjm5YGeQR08xoLPOv72qM6bp2uI1bPrIrCU8vIjaNgl0
         NoXabb090ptctm8E39BlPtnPerAhpspwdQmt5C6UDpW416k5a2Y5SngOQlefsHap0oO/
         6j9K6Hkg8Mz7YIAzxAJOdG4aW3fgNDD3sRZqoZKGbQohyGlAcnKgjRr83KUdkw1FNLvA
         6gnA==
X-Gm-Message-State: AAQBX9exYcZRh/pJthKld3oZ4vigYnaz9Kv0sarntmo2gOTNqZUJrX08
        LmdYzV+9qGRIAGGFZWMe+0ElpQ==
X-Google-Smtp-Source: AKy350b2yRGqmXSmp577Bu3JFR1YRggH+c5zBk/D9yeWIB98+DOaaoUYfX8QFTu7txBaCsMvgcnr6Q==
X-Received: by 2002:a17:90a:4ec2:b0:23c:fef0:d441 with SMTP id v2-20020a17090a4ec200b0023cfef0d441mr5835665pjl.33.1681488028800;
        Fri, 14 Apr 2023 09:00:28 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id br8-20020a17090b0f0800b00240d4521958sm3083584pjb.18.2023.04.14.09.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 09:00:28 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Vincent Chen <vincent.chen@sifive.com>
Subject: [PATCH -next v18 15/20] riscv: signal: validate altstack to reflect Vector
Date:   Fri, 14 Apr 2023 15:58:38 +0000
Message-Id: <20230414155843.12963-16-andy.chiu@sifive.com>
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

Some extensions, such as Vector, dynamically change footprint on a
signal frame, so MINSIGSTKSZ is no longer accurate. For example, an
RV64V implementation with vlen = 512 may occupy 2K + 40 + 12 Bytes of a
signal frame with the upcoming support. And processes that do not
execute any vector instructions do not need to reserve the extra
sigframe. So we need a way to guard the allocation size of the sigframe
at process runtime according to current status of V.

Thus, provide the function sigaltstack_size_valid() to validate its size
based on current allocation status of supported extensions.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
 arch/riscv/kernel/signal.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index 40f740183768..11411e113f0e 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -469,3 +469,10 @@ void __init init_rt_signal_env(void)
 	 */
 	signal_minsigstksz = get_rt_frame_size(true);
 }
+
+#ifdef CONFIG_DYNAMIC_SIGFRAME
+bool sigaltstack_size_valid(size_t ss_size)
+{
+	return ss_size > get_rt_frame_size(false);
+}
+#endif /* CONFIG_DYNAMIC_SIGFRAME */
-- 
2.17.1

