Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1ED6A2030
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 18:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjBXRCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 12:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjBXRCT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 12:02:19 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9337C6C19A
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:02:07 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id h14so108134plf.10
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=koVyRaRqxsrDWUrYBU8SOpV584+iZ/LEAwINA8yYDNw=;
        b=gNJplNOUBbEPEsbUXzNCR/S7URO5fxtOMyxTHZNyo4yuJxk9N8FBXkdiHuVgPQsrS+
         NUD/gQo/p8OXfyhY5kl3CqFsxqeEnbh8hvNEYTFiQGQGDqJC8jVMAQILU+x0sUviRAaM
         B1aziI3RtiOJZv3GoFoyP2+TOVhBjTCJCLn70Hb7sRkiKt+bh6KRk9YtS/UEEBq8NJ/M
         KUVy/2Rk42caR8b6A9qzHRpOyQ/D3wTSdQLvyIRcNB30yxaElo8br98e355JAbJV+7vT
         ASTjQ+kObzzTjL1tIpsplGBgVFWSEF7L93/45e5gKu/v2OPKMEbNP+ZIYNMbDaLdR8Ml
         X3iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=koVyRaRqxsrDWUrYBU8SOpV584+iZ/LEAwINA8yYDNw=;
        b=qXS2Agt5kGp6jfA+KWDoe0F8Bde8PWYrNp8zLUAF2odonFFvUqUVbW5QV4cFWxhXZw
         +PkcVXyNSh+CIzgij8YhX0N7hdNmJ7yN8MJKG7Sio8JzJEZ6vJKE0J0y4beaF3OwYN8m
         m51/Mz/5IO+aMQ5crrgPElbZO4ScPiiB7Bp/FM9FG4i+TprOha9fdFaTxZZjeJBRF3+p
         v1o58jv8fZJ05qTV9AUR6lMTmwszrTwSKQXci94FHL5nwCmI5oqCsExwNmR3fFw/nvxR
         SdcSorHRActWFlhEZuersbSJ1LyFMdPasgZEfnUFT2OMlWFGNr1Wr5HNaOErXJFnyJYn
         +dyg==
X-Gm-Message-State: AO0yUKW54AA8wzXCWdyEcQXh+6UyMgbFCEeXROvWAwMj6Bm9wU0oZ3N2
        NyA83lBT/zyQnXgYF3Ye9Pq/Ew==
X-Google-Smtp-Source: AK7set87gGJjD+nHWmm9FxzEE29v4LyYPmGs1/TwwamuxjFalRbTlle2D/CceQqh2G+WOHETlNFp4w==
X-Received: by 2002:a17:902:f988:b0:19c:e0fe:ed1e with SMTP id ky8-20020a170902f98800b0019ce0feed1emr886986plb.69.1677258126886;
        Fri, 24 Feb 2023 09:02:06 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902b60c00b0019472226769sm9234731pls.251.2023.02.24.09.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 09:02:06 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>
Subject: [PATCH -next v14 06/19] riscv: Introduce Vector enable/disable helpers
Date:   Fri, 24 Feb 2023 17:01:05 +0000
Message-Id: <20230224170118.16766-7-andy.chiu@sifive.com>
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

These are small and likely to be frequently called so implement as
inline routines (vs. function call).

Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
[vineetg: create new patch from meshup, introduced asm variant]
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
[andy.chiu: remove calls from asm thus remove asm vaiant]
---
 arch/riscv/include/asm/vector.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index 427a3b51df72..dfe5a321b2b4 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -11,12 +11,23 @@
 #ifdef CONFIG_RISCV_ISA_V
 
 #include <asm/hwcap.h>
+#include <asm/csr.h>
 
 static __always_inline bool has_vector(void)
 {
 	return riscv_has_extension_likely(RISCV_ISA_EXT_v);
 }
 
+static __always_inline void riscv_v_enable(void)
+{
+	csr_set(CSR_SSTATUS, SR_VS);
+}
+
+static __always_inline void riscv_v_disable(void)
+{
+	csr_clear(CSR_SSTATUS, SR_VS);
+}
+
 #else /* ! CONFIG_RISCV_ISA_V  */
 
 static __always_inline bool has_vector(void) { return false; }
-- 
2.17.1

