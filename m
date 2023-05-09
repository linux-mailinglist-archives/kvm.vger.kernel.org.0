Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF76E6FC3F0
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 12:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbjEIKcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 06:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235281AbjEIKcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 06:32:45 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF05D07A
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 03:32:34 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1aaec6f189cso38977215ad.3
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 03:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683628354; x=1686220354;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wN7ZHBcxzp7ZsRkqqH3xjhadPlnuKqjQR/mkhzwbhmg=;
        b=ccuT5IOXOWZXEkVCczhFZQg1DR5ApUiwiB8G4HWAXcLvcWjy0n/7uX/tX0xWcCeAIp
         ygpMvtU3DicpYIZ1v3/Mz7ceykNagPLEo6d5v4G3lPVpmtLGwHsTIouFPuaRoUwKVydc
         3M4+QtgPyg+Typ3Jkoyl11WGaeV8vPEx7miGPoBIK2jKe3FQ7r9oz6rxVuyNG2tS9gpH
         zsAf/LzqkyE5ImJOqBkabJ4JW0Jc+Txd4saDBjw6QuwVgyJlHKwsHlnzNWlfMaunK/ZM
         lEkb45jlwXwoOn4oPAjO1uQ9HGVE296cqjsu4NzPq2Yiyb9kQVmq5zCgQ+m7R+RGVbGG
         BIYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683628354; x=1686220354;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wN7ZHBcxzp7ZsRkqqH3xjhadPlnuKqjQR/mkhzwbhmg=;
        b=RKnYpoFBnjsBEeP4l+BMzKZy9D1Q+nO07qUFaTzTuRS/HGuAPDYc7WaLYcd4t4The7
         S9VLrGnM5ko97liU1iUFy1Lobyd/fhk9QNv86AOu79DF/wGcXKheg3ZXvOnWGbeAC9nV
         evTWRNzVvI2az+NFayVcdUpdhybz+T39kR/z/S1Ze9OmEggznYkJyTXuXGgrrXFp0eL4
         NhlX6CjQLshVQnCuxwP+S9+E6lH0P8jn9zsMabrY4QfNHot7YZnNlEVww5cm2z1eRH9r
         Hwj0cdsKlokEnve7kSoR7Aej64PbR3AaNlZhLc6v2Z31U5jQSbWsCjRkdFrwiMwHt9NM
         Mn+g==
X-Gm-Message-State: AC+VfDx0ZOjTbzobjr3lDDysEV97d8sW+7ghqm6XVxvGeNf9ciSfCs92
        TWS38DnKlRlhcAZsI7I0Tv4erg==
X-Google-Smtp-Source: ACHHUZ5JVUtGHm+RvvF2AiQVn+ndz7H6SRxoKr9k5Gp1HsvibL5yeUcf5X09oziZZrqPYY/Z2Ayoaw==
X-Received: by 2002:a17:902:f54b:b0:1aa:fe52:a827 with SMTP id h11-20020a170902f54b00b001aafe52a827mr18554926plf.13.1683628354237;
        Tue, 09 May 2023 03:32:34 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id o11-20020a170902d4cb00b001a076025715sm1195191plg.117.2023.05.09.03.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:32:33 -0700 (PDT)
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
        Al Viro <viro@zeniv.linux.org.uk>,
        Mathis Salmen <mathis.salmen@matsal.de>,
        Vincent Chen <vincent.chen@sifive.com>,
        Andrew Bresticker <abrestic@rivosinc.com>
Subject: [PATCH -next v19 13/24] riscv: signal: check fp-reserved words unconditionally
Date:   Tue,  9 May 2023 10:30:22 +0000
Message-Id: <20230509103033.11285-14-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230509103033.11285-1-andy.chiu@sifive.com>
References: <20230509103033.11285-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index 9aff9d720590..6b4a5c90bd87 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -40,26 +40,13 @@ static long restore_fp_state(struct pt_regs *regs,
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
@@ -67,20 +54,9 @@ static long save_fp_state(struct pt_regs *regs,
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
@@ -92,11 +68,30 @@ static long restore_sigcontext(struct pt_regs *regs,
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
 
@@ -147,11 +142,17 @@ static long setup_sigcontext(struct rt_sigframe __user *frame,
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

