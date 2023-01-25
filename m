Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDDF67B435
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 15:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbjAYOWm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 09:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbjAYOWX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 09:22:23 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1427058945
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:22:12 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id h5-20020a17090a9c0500b0022bb85eb35dso2139404pjp.3
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4OIOt+i2FPUUG761vxHsPnTGTmnqKlqPflyjCyvck2Q=;
        b=ZV8MKZOy4sb0ku1/f/TqJU9KmD93byQb5Ot/0Y6hc61ljcAU/8agY9/Efq/ze+IsxM
         E9NvWCbcahXrXBxsljBEbVoI21st626A5vkZAyaVEH+X/5DTDRX+AtmfI9aYAnXDTu45
         2GsjYYrHzOxRGiFM5u+N/x9aJ8Tgq3I4Jnj7T8Yb6sOZqdzO/wx2KRTWQZQ2ftUfikDJ
         CqGP+x34sXFD+TYKZVr+rhxbVbdRtSE8vJtEaRacFzCaWGeIz1mrmWpIHx0HJifGzR9h
         eXUzqn6NQPzAsC4gEA4e1PD/GKr9aZLYFSwGbGj0u8b24CwIjPvFgFpKAGwtER2knSam
         wCKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4OIOt+i2FPUUG761vxHsPnTGTmnqKlqPflyjCyvck2Q=;
        b=KptNz5hzImhuhgJzoucoRfx3++h5Wtzt8GMQNHXonNtcV+aFvBcV5lp5PHRr31eR6X
         AiXoCZ1Y47oHzz+kYocirCYMAIi1GyrR6HGfid9VK8kAizp0Dyz0K2wRMtPhU5bzBdlr
         fm1Snxdc79md3qa6TzHspCjsUVMGBOlQVy71VN/+l8uHBIcomfLUV4LFNHLY4XdHDbtp
         DlLBe0NWvM9dpxaGbO6CEoQPZlUiLB8KXgAkiS1YDpmbfZNTfXD2uJq8FuuNNHFNIDHn
         Ma3wIUKEO98FOATBimSQVYY4DYdsxNBEI4pckuNG3R319RGgLYdAbMyvDI+GIVV3Ibk7
         +OXw==
X-Gm-Message-State: AFqh2kq2PG6i5cWPwAGMTiUIb5LE607Ea67JRxgjfcKJYwyzCLbTm8mZ
        zVw3c5liOr+ppHpBhTTEDIeQSA==
X-Google-Smtp-Source: AMrXdXsqFhOqquIFWQq1CzqOLz9/j6G0/mvseOpOluzhStTcIcNAliiT37t5sluCLqafrxlSRuIVAQ==
X-Received: by 2002:a17:90a:1696:b0:228:cda9:f608 with SMTP id o22-20020a17090a169600b00228cda9f608mr32739423pja.15.1674656531414;
        Wed, 25 Jan 2023 06:22:11 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id bu11-20020a63294b000000b004a3510effa5sm3203520pgb.65.2023.01.25.06.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:22:11 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Bresticker <abrestic@rivosinc.com>
Subject: [PATCH -next v13 12/19] riscv: signal: check fp-reserved words unconditionally
Date:   Wed, 25 Jan 2023 14:20:49 +0000
Message-Id: <20230125142056.18356-13-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230125142056.18356-1-andy.chiu@sifive.com>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
---
 arch/riscv/kernel/signal.c | 53 +++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index bfb2afa4135f..0c8be5404a73 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -38,26 +38,13 @@ static long restore_fp_state(struct pt_regs *regs,
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
@@ -65,20 +52,9 @@ static long save_fp_state(struct pt_regs *regs,
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
@@ -90,11 +66,29 @@ static long restore_sigcontext(struct pt_regs *regs,
 	struct sigcontext __user *sc)
 {
 	long err;
+	size_t i;
+
 	/* sc_regs is structured the same as the start of pt_regs */
 	err = __copy_from_user(regs, &sc->sc_regs, sizeof(sc->sc_regs));
+	if (unlikely(err))
+		return err;
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
 
@@ -145,11 +139,16 @@ static long setup_sigcontext(struct rt_sigframe __user *frame,
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
 	return err;
 }
 
-- 
2.17.1

