Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149006CAAFB
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 18:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbjC0QuU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 12:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbjC0QuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 12:50:17 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6617E30DE
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:50:15 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id g7so6126242pfu.2
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679935815;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PRENwq6Q5h6bJkuLEU9y2ZlvRnSbbBagGQhAGvyqbY8=;
        b=Im2pA+xjTJP1P/7egZqhj7wkh9qONRyQrUqtdz7kdGU6/vnyYyA3/IT4SZ/uJsFTVu
         VWMFANP6w7WezQw3jXfiusIanyzEoBNI7oiUGLghiqVc7+TWpzO4xUt+PcIA1IAyTWeY
         pnhXC0LjwfO79zrt64ZGJ0+iFsjG3xUHog792DyiW6TQucAA8dW6dabCNdCrM2C1JEah
         SkdDLNInlQ8X9+1bxDO4QiFvUKU+eYBKvTTVtiBIUaAqkTfJmC7rRSlfCusQNKIOmacS
         AS0DjilPT7oHtUKN+189FM5WbpRrtL/2ufvhPs+sjv1kUc/nBZFGbDemb2g1fJagMlsB
         R9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679935815;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PRENwq6Q5h6bJkuLEU9y2ZlvRnSbbBagGQhAGvyqbY8=;
        b=nUMeXkos6VhwzNptFIMY5MsTIakWqmy3mp2qkzqwI++xAkdlKW6vE32ImF5O4hABIS
         Rq1eK4onRF8NmoJt5RiHEOLQWveZEuq3ZHQEEGM1Y21IdeGgk9wN3Zhj/LArtSZC8UEb
         zdwO6w7d/A+uCYxiJf86mzDOoDZHU+YF+c+v/Md2EV/faMAUgpnhq+8azEcGr89IrJc9
         Z5y9F6O5k1qsbg9wT/OpbvLRuf0Buro2H91WNHknUnzuSqLbU/vlKtfvxCyDButPQrN5
         iw0zeLJ02B6hYqIVGM6qJmjpks27vajZ2kfywGSQNKnHFMR4Oe2QCA56owf1PEwTdL8e
         NCiQ==
X-Gm-Message-State: AAQBX9ei+2T8OSeSAC3+Ql+skIghAvnEO+JZqcwzQVhenkVvsOZliPNd
        wnFTC9cUU1nZUhhfBikvFD2kLA==
X-Google-Smtp-Source: AKy350YgIDNmaFkFmOyTXNpYJWHviuDbzam9Pt544m/wq3Qo5T1ceNLABvH+KviZQi73xRGSDtn+uQ==
X-Received: by 2002:aa7:981c:0:b0:625:e3c0:8a58 with SMTP id e28-20020aa7981c000000b00625e3c08a58mr12825490pfl.4.1679935814799;
        Mon, 27 Mar 2023 09:50:14 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id q20-20020a62e114000000b0061949fe3beasm19310550pfh.22.2023.03.27.09.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 09:50:14 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Han-Kuan Chen <hankuan.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>
Subject: [PATCH -next v17 05/20] riscv: Disable Vector Instructions for kernel itself
Date:   Mon, 27 Mar 2023 16:49:25 +0000
Message-Id: <20230327164941.20491-6-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230327164941.20491-1-andy.chiu@sifive.com>
References: <20230327164941.20491-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

Disable vector instructions execution for kernel mode at its entrances.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Co-developed-by: Han-Kuan Chen <hankuan.chen@sifive.com>
Signed-off-by: Han-Kuan Chen <hankuan.chen@sifive.com>
Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/kernel/entry.S |  6 +++---
 arch/riscv/kernel/head.S  | 12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 3fbb100bc9e4..e9ae284a55c1 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -48,10 +48,10 @@ _save_context:
 	 * Disable user-mode memory access as it should only be set in the
 	 * actual user copy routines.
 	 *
-	 * Disable the FPU to detect illegal usage of floating point in kernel
-	 * space.
+	 * Disable the FPU/Vector to detect illegal usage of floating point
+	 * or vector in kernel space.
 	 */
-	li t0, SR_SUM | SR_FS
+	li t0, SR_SUM | SR_FS_VS
 
 	REG_L s0, TASK_TI_USER_SP(tp)
 	csrrc s1, CSR_STATUS, t0
diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 3fd6a4bd9c3e..e16bb2185d55 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -140,10 +140,10 @@ secondary_start_sbi:
 	.option pop
 
 	/*
-	 * Disable FPU to detect illegal usage of
-	 * floating point in kernel space
+	 * Disable FPU & VECTOR to detect illegal usage of
+	 * floating point or vector in kernel space
 	 */
-	li t0, SR_FS
+	li t0, SR_FS_VS
 	csrc CSR_STATUS, t0
 
 	/* Set trap vector to spin forever to help debug */
@@ -234,10 +234,10 @@ pmp_done:
 .option pop
 
 	/*
-	 * Disable FPU to detect illegal usage of
-	 * floating point in kernel space
+	 * Disable FPU & VECTOR to detect illegal usage of
+	 * floating point or vector in kernel space
 	 */
-	li t0, SR_FS
+	li t0, SR_FS_VS
 	csrc CSR_STATUS, t0
 
 #ifdef CONFIG_RISCV_BOOT_SPINWAIT
-- 
2.17.1

