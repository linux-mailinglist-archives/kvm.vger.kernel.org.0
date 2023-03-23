Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECDC6C6BB5
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 16:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbjCWPAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 11:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjCWPAA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 11:00:00 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452B62312B
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 07:59:56 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id p3-20020a17090a74c300b0023f69bc7a68so2330072pjl.4
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 07:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679583595;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CteMDAzkrOKUdcbIvPON419eHbnDZdFOKMS6mt0sWZE=;
        b=YZmF4D5+ASu+0FbybKdp/QQW9kNTxyCx5YsT6ZvM2DG/OesJXHQ+aDXBJlPpA/hNuc
         6Ok2Cqe/0ncNLp8Mo6vJqHdPzwEjZZW2E/qTUILb1ds/11rWsZLPg1ULU9sRZNlJtX0e
         RLywUoQ2+Gk3ZsR0AtYjUYnMExlwFt7XFe5sx0VlC7XSB2iQuY7iwCXW4DcTDzLUXj8H
         4VHAMluEY0zmLjuaXhhHMQqnsGuRw6fV7o5U6rpZZj8nBGQB7ctBlVTA5KmDh6fVFxec
         rMpDpvayB6Y69AQ542RP4xGTxSXcMT1SghG8eEJIBMo5uCkewwP1Dk8B8xUg3VgHwOnc
         L5mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679583595;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CteMDAzkrOKUdcbIvPON419eHbnDZdFOKMS6mt0sWZE=;
        b=4vETwyK8gupQ98vOf6RRNeb36QAz7Y6S/p7q7tRMjUXAHoCOCteGP1cvrjVkwEsIfk
         Pvii7f5FV/hVR0916xG+APn8NIp/8hdsRPz2WyFwCARyiMw4Fod57xVdnl9ns4rWWhPy
         tHis/pzL2Om8P0+4KKQxKyIXRfaewKdJh+e92eges02SbmYB6Sz8kxIbR+U3jD243Ogd
         pUQ5wt/PiciPUjGrRVjpbyX6GtxVhgsCMVHqwit6DTeYv+KiVbE25X/BlL0iRv4go0l6
         QVtcJ3vhD3aXG3gOoXbOv+/DucPvAroaH23kMxCGg8gj5Vp/wjeN3AF9t7iduG6Jilo9
         D8bg==
X-Gm-Message-State: AO0yUKUUctxk+rTsE48GvAivFlxG75yacJr6nxRfTd9ZoyQNu/oVnP5J
        Kbqq4DEemPsvigAijj47z7GtHA==
X-Google-Smtp-Source: AK7set8A+aZ2M7mxzfToXXBNFwaoRnGD4RaT2KdE16M9huLbT1x0LNbyAUn8zoOUaP8wkbeGiMTSjw==
X-Received: by 2002:a17:90b:38c4:b0:234:67ef:304b with SMTP id nn4-20020a17090b38c400b0023467ef304bmr8717993pjb.37.1679583595508;
        Thu, 23 Mar 2023 07:59:55 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902854900b0019f53e0f136sm12503965plo.232.2023.03.23.07.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 07:59:54 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>
Subject: [PATCH -next v16 04/20] riscv: Clear vector regfile on bootup
Date:   Thu, 23 Mar 2023 14:59:08 +0000
Message-Id: <20230323145924.4194-5-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230323145924.4194-1-andy.chiu@sifive.com>
References: <20230323145924.4194-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

clear vector registers on boot if kernel supports V.

Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
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

