Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27BB66E27D9
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 18:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjDNQAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 12:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjDNQAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 12:00:19 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63787B453
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 09:00:10 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id i8so9743559plt.10
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 09:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1681488009; x=1684080009;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SfhrBat26HES/W09UQouwTRtDc+oS9f+/Y0OrbpnIB4=;
        b=Cpc1OLK80fp2Vk+OfTwfWFJ4rIIchbHxVG6VTTA1i4wM2eSwwih69m47Wd70PAWx/U
         a8zAvqbq2RX1aJfOnf5djGXLd3AzOQLrZT3zb9Lf/3ANEt3kAKEdE9NeDTWBB6nFgafQ
         c9a2/kJgqJQzdUD/M6JxhRaQcpg5mu6CPLus3DLvoxci6hkBpUDkISuBc/+wc2DStVS3
         /hqmC3Bn3fx52+IRJVCY5bMSBElmXP5n15OQbAxKuYtunyLzSi2ALgaXk3KN8h/q1kze
         1O/nRtElqeoIqFPrc/slRxWD7zq9HK2wD7avGatrm40cxojJ+C7dlkDZ7xNjj6HdESMu
         tVWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681488009; x=1684080009;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SfhrBat26HES/W09UQouwTRtDc+oS9f+/Y0OrbpnIB4=;
        b=Zr3dAVclXYnSvhEYMcd8gvkwgdDl2SkNeOf99O3kT07xPSZbbhGMNPMRstRAASAZ9Z
         PRImi3rCw+nj7VMNRU+aTOH37ROgZ6I0eboEJYT48RycoRgWfx0ssySnvI5RTlg/bR9Q
         2lWI0iHuE+TSuOYpVXXxONKFgeMLNnP7aSyozLBg3INgEsAvVDSLJcNKTbmLY/wNq6nJ
         dHLMrWFRPcMt1zW0RoD960Gbz/kApOjTSdB0ijmQsG7yf7fSJIRt+ve5ASgdvmBClG9J
         phdRpsbvhpf8aIQgEcuJLZmzRpt4JuWKJNrEI2FddlKsDa5SCEgy9fmZ/hTxL1ozHk0u
         vorA==
X-Gm-Message-State: AAQBX9f8ewuEp+ux/qIlGtDLlJ0zYt6HtZc8vI8PXGWzYGXKQexGyMXW
        bz+5u4lpw8kez3shftZZuaRNRA==
X-Google-Smtp-Source: AKy350Yq5buuwKWHBAdXVXOcSMxtp/KzN9zluNkwjw+6poJKRVXRiimJGmkkVRZRiR95aWSKrJKWow==
X-Received: by 2002:a17:90a:7b8c:b0:23a:66:1d3a with SMTP id z12-20020a17090a7b8c00b0023a00661d3amr6095897pjc.45.1681488009342;
        Fri, 14 Apr 2023 09:00:09 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id br8-20020a17090b0f0800b00240d4521958sm3083584pjb.18.2023.04.14.09.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 09:00:08 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Guo Ren <guoren@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Vincent Chen <vincent.chen@sifive.com>
Subject: [PATCH -next v18 12/20] riscv: signal: check fp-reserved words unconditionally
Date:   Fri, 14 Apr 2023 15:58:35 +0000
Message-Id: <20230414155843.12963-13-andy.chiu@sifive.com>
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

In order to let kernel/user locate and identify an extension context on
the existing sigframe, we are going to utilize reserved space of fp and
encode the information there. And since the sigcontext has already
preserved a space for fp context w or w/o CONFIG_FPU, we move those
reserved words checking/setting routine back into generic code.

This commit also undone an additional logical change carried by the
refactor commit 007f5c3589578
("Refactor FPU code in signal setup/return procedures"). Originally we
did not restore fp context if restoring of gpr have failed. And it was
fine on the other side. In such way the kernel could keep the regfiles
intact, and potentially react at the failing point of restore.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
 arch/riscv/kernel/signal.c | 55 +++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index 2e365084417e..4d2f41078f46 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -39,26 +39,13 @@ static long restore_fp_state(struct pt_regs *regs,
 {
 	long err;
 	struct __riscv_d_ext_state __user *state = &sc_fpregs->d;
-	size_t i;
 
 	err = __copy_from_user(&current->thread.fstate, state, sizeof(*state));
 	if (unlikely(err))
 		return err;
 
 	fstate_restore(current, regs);
-
-	/* We support no other extension state at this time. */
-	for (i = 0; i < ARRAY_SIZE(sc_fpregs->q.reserved); i++) {
-		u32 value;
-
-		err = __get_user(value, &sc_fpregs->q.reserved[i]);
-		if (unlikely(err))
-			break;
-		if (value != 0)
-			return -EINVAL;
-	}
-
-	return err;
+	return 0;
 }
 
 static long save_fp_state(struct pt_regs *regs,
@@ -66,20 +53,9 @@ static long save_fp_state(struct pt_regs *regs,
 {
 	long err;
 	struct __riscv_d_ext_state __user *state = &sc_fpregs->d;
-	size_t i;
 
 	fstate_save(current, regs);
 	err = __copy_to_user(state, &current->thread.fstate, sizeof(*state));
-	if (unlikely(err))
-		return err;
-
-	/* We support no other extension state at this time. */
-	for (i = 0; i < ARRAY_SIZE(sc_fpregs->q.reserved); i++) {
-		err = __put_user(0, &sc_fpregs->q.reserved[i]);
-		if (unlikely(err))
-			break;
-	}
-
 	return err;
 }
 #else
@@ -91,11 +67,30 @@ static long restore_sigcontext(struct pt_regs *regs,
 	struct sigcontext __user *sc)
 {
 	long err;
+	size_t i;
+
 	/* sc_regs is structured the same as the start of pt_regs */
 	err = __copy_from_user(regs, &sc->sc_regs, sizeof(sc->sc_regs));
+	if (unlikely(err))
+		return err;
+
 	/* Restore the floating-point state. */
-	if (has_fpu())
-		err |= restore_fp_state(regs, &sc->sc_fpregs);
+	if (has_fpu()) {
+		err = restore_fp_state(regs, &sc->sc_fpregs);
+		if (unlikely(err))
+			return err;
+	}
+
+	/* We support no other extension state at this time. */
+	for (i = 0; i < ARRAY_SIZE(sc->sc_fpregs.q.reserved); i++) {
+		u32 value;
+
+		err = __get_user(value, &sc->sc_fpregs.q.reserved[i]);
+		if (unlikely(err))
+			break;
+		if (value != 0)
+			return -EINVAL;
+	}
 	return err;
 }
 
@@ -146,11 +141,17 @@ static long setup_sigcontext(struct rt_sigframe __user *frame,
 {
 	struct sigcontext __user *sc = &frame->uc.uc_mcontext;
 	long err;
+	size_t i;
+
 	/* sc_regs is structured the same as the start of pt_regs */
 	err = __copy_to_user(&sc->sc_regs, regs, sizeof(sc->sc_regs));
 	/* Save the floating-point state. */
 	if (has_fpu())
 		err |= save_fp_state(regs, &sc->sc_fpregs);
+	/* We support no other extension state at this time. */
+	for (i = 0; i < ARRAY_SIZE(sc->sc_fpregs.q.reserved); i++)
+		err |= __put_user(0, &sc->sc_fpregs.q.reserved[i]);
+
 	return err;
 }
 
-- 
2.17.1

