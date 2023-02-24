Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9A96A202E
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 18:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjBXRCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 12:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjBXRCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 12:02:09 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7176C1AA
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:01:56 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id h14so107648plf.10
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Tr4IaNHJV/yxI3LzfdUHpHdNHRqmUrR0SAE9fALA7gA=;
        b=X53N55kzCDwGxM9gSR6D8s5MXnNjsLx2+RUlkJVVBzk/V6dMb3r0KJppvVhw26wVPU
         L78d/fw+nkpxWlEmjRU/BJIeKiyDiGmx1NCAuv4cO1ME8iBNadGmWyTkWdxSWKiDufvH
         xvL9sKASZJFov+erCKEqqs/RsdbhdVvJqczJEYLwXQlheOA4sqEN9vpANkdfOU7zffZf
         rLHX+d2iPWPwwmExzo/fXrBgbUNzdABXZGquLl4gKl3F4uvqAYTNS8TF/bq1M+VNiHs/
         Af0/y6LCGtlX7758PWKW3He8yEpTsCFMt1tQilv0SMyR/Eulu4uywRYkQ+JFysGs6ECD
         VUBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tr4IaNHJV/yxI3LzfdUHpHdNHRqmUrR0SAE9fALA7gA=;
        b=qtpZQiOLcJEg0vGiReesDDHinKVi2We+dSi1MCT4czDhtuvWr/fEChsI0q+crIwgmo
         HPkkUPVvjxPAiw+yEy/4RodamyNU6XwkdYw4ByMOgsXRcNeThQtfikZH7+B3BHQUPDAD
         G+6KTjQe9O+IYllzuJp43+vnRZ77xFu5PZbOPbNukipzAbg87BSQDuYJpx8D2h9Gr6oa
         giT5EX/rRjjGIM9vrQ1F5+kEcRmN/vbx2fsPabATiwtyS9Oe8mEeP4+zM67+kKbzQ0Qc
         3shwyjAG6LZ+vAldoPNJY4o0uffR7tCZ3fkXaCl3ISeZil7PcG6TAge+ozzjcP6Yaekw
         kWrw==
X-Gm-Message-State: AO0yUKUOODOWcrqBhaRaXmbXPsDEGSbGPIm7tA8Y5PUcrCXAzM3zdb6+
        c29C2fb/PJ5NPiCiYHTufCzrHA==
X-Google-Smtp-Source: AK7set+8aW8jIXiwNWQYy8PDbH2Lpbn0VJvyhHm3YPV4EoNE/73HyNmBg8yX59BdCxrIImwbAxeIjA==
X-Received: by 2002:a17:903:11d0:b0:19c:b7da:fc44 with SMTP id q16-20020a17090311d000b0019cb7dafc44mr8203309plh.34.1677258115602;
        Fri, 24 Feb 2023 09:01:55 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902b60c00b0019472226769sm9234731pls.251.2023.02.24.09.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 09:01:54 -0800 (PST)
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
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>
Subject: [PATCH -next v14 04/19] riscv: Clear vector regfile on bootup
Date:   Fri, 24 Feb 2023 17:01:03 +0000
Message-Id: <20230224170118.16766-5-andy.chiu@sifive.com>
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

From: Greentime Hu <greentime.hu@sifive.com>

clear vector registers on boot if kernel supports V.

Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
[vineetg: broke this out to a seperate patch]
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 arch/riscv/kernel/head.S | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 4bf6c449d78b..3fd6a4bd9c3e 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -392,7 +392,7 @@ ENTRY(reset_regs)
 #ifdef CONFIG_FPU
 	csrr	t0, CSR_MISA
 	andi	t0, t0, (COMPAT_HWCAP_ISA_F | COMPAT_HWCAP_ISA_D)
-	beqz	t0, .Lreset_regs_done
+	beqz	t0, .Lreset_regs_done_fpu
 
 	li	t1, SR_FS
 	csrs	CSR_STATUS, t1
@@ -430,8 +430,31 @@ ENTRY(reset_regs)
 	fmv.s.x	f31, zero
 	csrw	fcsr, 0
 	/* note that the caller must clear SR_FS */
+.Lreset_regs_done_fpu:
 #endif /* CONFIG_FPU */
-.Lreset_regs_done:
+
+#ifdef CONFIG_RISCV_ISA_V
+	csrr	t0, CSR_MISA
+	li	t1, COMPAT_HWCAP_ISA_V
+	and	t0, t0, t1
+	beqz	t0, .Lreset_regs_done_vector
+
+	/*
+	 * Clear vector registers and reset vcsr
+	 * VLMAX has a defined value, VLEN is a constant,
+	 * and this form of vsetvli is defined to set vl to VLMAX.
+	 */
+	li	t1, SR_VS
+	csrs	CSR_STATUS, t1
+	csrs	CSR_VCSR, x0
+	vsetvli t1, x0, e8, m8, ta, ma
+	vmv.v.i v0, 0
+	vmv.v.i v8, 0
+	vmv.v.i v16, 0
+	vmv.v.i v24, 0
+	/* note that the caller must clear SR_VS */
+.Lreset_regs_done_vector:
+#endif /* CONFIG_RISCV_ISA_V */
 	ret
 END(reset_regs)
 #endif /* CONFIG_RISCV_M_MODE */
-- 
2.17.1

