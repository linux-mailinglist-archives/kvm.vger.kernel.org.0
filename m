Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E9967B429
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 15:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbjAYOV1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 09:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235400AbjAYOVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 09:21:25 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720EE3D908
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:21:23 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id b24-20020a17090a551800b0022beefa7a23so2159760pji.5
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZztKbPQsLzt8BkZToULMHP7RLL5DOETtnFda6rXDBW4=;
        b=M7PSBAfL8lCg3IRJvriABmVXzdDB71pqt9wWeH2ealTRhCqcrIQAxsf7UmVzo7B1af
         FJKBZy0vdojJZAhG0yBCMreHoLAiZ5ATs3aF3gfHL7OuhKKti9eOobO171tUV2iT8Xq7
         SpdnikTCRhcz8qpTFVRkSylA/1gC4hqn6SRsRFDVs+GOc211gEGE5jOhmt4U3Fic9f6P
         GpffgRhKmX+zqhMnrGIQuXTGR6F5oteCVDqHj9I4Austv0BxLJAE5/94FherJmmz4adN
         K98oLTMvnmxwPhBPSCeikuo/gTvVUiOYr+VIkRRoyic8AODJrozfVIXtRqTTHisJ/ayY
         4NBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZztKbPQsLzt8BkZToULMHP7RLL5DOETtnFda6rXDBW4=;
        b=YUUFxRgw9ARYWgafj6poAhkrfCqLT7st78qF8V8Jrr26n5tq2eY3oRa7QP8cO7mF7y
         BZLoB+3LenPM0/p8iLSk/S/VKq+Bpf6/Vaeu+3DGIq04ZJsBae3rRIaTgEO5jqSEYTJG
         c8xCRQik8GwSP/HB30+mNNEr6xESrk4/tdJIP8UnrhSEmZTGKMft1JOwCo5WQqv014f+
         cbb0nJ5tLw3v+kAz2qLbtcfilDJkB6VVhJv4OdzKT1h7jRawB37qCy3tNKICo05ISzXw
         3xEVDR63ukSpuCDdClDH3GcBq3dgww9MQB33aPmfroHtpPNclzRMY9IZ0bfU07UxdVjm
         nbAg==
X-Gm-Message-State: AO0yUKUskVFSxZur1w54foD9SpBcISupdML/Fr3MfU5RL7LPYR0BCG5l
        ryXVDgbfWMdbS1tl2BIeBEgzUQ==
X-Google-Smtp-Source: AK7set9tpkQRtlrOMLyRqnjIVr9Ee7HeqGlPTKuGN9mYVi5OySYyrzx7sPHwHNVKlDUUqSuRhWtJ3A==
X-Received: by 2002:a17:90b:4b05:b0:22b:e0f7:5aaf with SMTP id lx5-20020a17090b4b0500b0022be0f75aafmr8610060pjb.34.1674656482940;
        Wed, 25 Jan 2023 06:21:22 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id bu11-20020a63294b000000b004a3510effa5sm3203520pgb.65.2023.01.25.06.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:21:22 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Myrtle Shah <gatecat@ds0.me>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>
Subject: [PATCH -next v13 04/19] riscv: Clear vector regfile on bootup
Date:   Wed, 25 Jan 2023 14:20:41 +0000
Message-Id: <20230125142056.18356-5-andy.chiu@sifive.com>
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

clear vector registers on boot if kernel supports V.

Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
[vineetg: broke this out to a seperate patch]
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 arch/riscv/kernel/head.S | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index b865046e4dbb..ea803c96eeff 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -431,6 +431,29 @@ ENTRY(reset_regs)
 	csrw	fcsr, 0
 	/* note that the caller must clear SR_FS */
 #endif /* CONFIG_FPU */
+
+#ifdef CONFIG_RISCV_ISA_V
+	csrr	t0, CSR_MISA
+	li	t1, COMPAT_HWCAP_ISA_V
+	and	t0, t0, t1
+	beqz	t0, .Lreset_regs_done
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
+#endif /* CONFIG_RISCV_ISA_V */
+
 .Lreset_regs_done:
 	ret
 END(reset_regs)
-- 
2.17.1

