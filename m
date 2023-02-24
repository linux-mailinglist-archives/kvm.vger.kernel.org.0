Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43AC6A2036
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 18:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjBXRDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 12:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjBXRDB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 12:03:01 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392CE5FF4
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:02:53 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id s5so198230plg.0
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4OIOt+i2FPUUG761vxHsPnTGTmnqKlqPflyjCyvck2Q=;
        b=OU8AF9tNo8cvjdesztUh7J2bMGT7DF8pw6VT470S4w3FkgPvmNzP7WoNrTFpalVkqx
         R08fYG2J6ka7bROxWlaNqMoUVxQse5knzCBUBxM4b+O2FyZXY0xDt8pVOr7i0KTygF56
         cvczdiCMZuXqv9lSNqgcb2aktfsAiMaawArq37VH/fYK/NYMuuQXAtWNsXzNkiTTqIoH
         kDaEY7y8skSSSz/x3WvmexLxsHYa0TOaqZ1vnkQWnRIhD4tZuGRJo3oLf1awCzhLT+om
         XeDv3bJZEHmRXG1PE3asgUkA6FyC1sDTlpiDEQ6lPTM7hUL3wNSaPn/GbkuMzYsZTby0
         cgHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4OIOt+i2FPUUG761vxHsPnTGTmnqKlqPflyjCyvck2Q=;
        b=8R8KmpOP7lXdOXhWIMzFIuRquhjTuzzD9WoZ9g7IWWDAGy4cHkZqI7IkkkOIyJHE0a
         bGfTgwheClC7wxpxb7d2JNswfsnoFEf7hiAEwmxWmsWoOQqRUDczf+ZlL/4bdO0aZ07c
         SuMDWSnIsTODhxJ6uZKY3RyPEloI0QreJqlX2ag9za6FpBzDNKjJrMqVcPyNDJPUM6kS
         D9XyyGGnm8bxLciVoucRjpZkxRHm/Cp6ofZ4vT/FCfKbsCIn7G6Zm9BunN3mfRyi5SAL
         AyuwijQOUPhGXzxxb2EfWYfSc9NfkSsqApPVSpMoj0Vg9VuJ+UqSQ5nQT8pMweaN2V6v
         IIyg==
X-Gm-Message-State: AO0yUKWIkQkTaNMmauWkq05h7O+cZxOgMYTK56ftihvmQmFeejXgGDrX
        IyEGo6aOBM/Y+D/BAwT/2XkWKw==
X-Google-Smtp-Source: AK7set/8c1sk0d5VHRUyvH1XHmF4lUGcCLfNDTtBkpMV8VbJNSL04MQoKY19udSmkzrwEBAnlypk/A==
X-Received: by 2002:a17:902:cece:b0:19a:973b:b615 with SMTP id d14-20020a170902cece00b0019a973bb615mr21981971plg.36.1677258172670;
        Fri, 24 Feb 2023 09:02:52 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902b60c00b0019472226769sm9234731pls.251.2023.02.24.09.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 09:02:52 -0800 (PST)
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
        Andrew Bresticker <abrestic@rivosinc.com>
Subject: [PATCH -next v14 12/19] riscv: signal: check fp-reserved words unconditionally
Date:   Fri, 24 Feb 2023 17:01:11 +0000
Message-Id: <20230224170118.16766-13-andy.chiu@sifive.com>
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

