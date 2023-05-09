Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B7B6FC3E9
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 12:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235173AbjEIKcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 06:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235269AbjEIKb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 06:31:58 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6504DD9C
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 03:31:49 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1ab0c697c2bso53455195ad.1
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 03:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683628309; x=1686220309;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wdT8PJ8oH1xp8pRaW3V56IfqtFcYTK0lyTpuGxj9OGI=;
        b=dEyjenlH8KNtGGE0LzwpQCnXQrGwiZonY0VzG1DZI3BoDMmCE1APNK7EpqOvJnSM9U
         SHiB3BDqnX44K0xYiiKVKDsc2bxbtQmLgy/XcMc3HjYVKtLPy6HNJXR7xM0qsrfUn56P
         ez3vP11D5ZC/goMxSu0BNgkFU4ljoa1wUnglHvZxzy7ec2BqYzogPRD/CXs+HgCgZTLy
         cc6vy7SSoIO+Gl2MAEtui2mWFGoERTgdZLrhfGMKIUcbHQPBM197+2ABmRrIUw/vTvRP
         I+h0y6pMhH7e/5zqnvNe9GOPuQVe3Zmq+QXl1p1q9FhXMUG3WiD3sP3G2+cQH8bmqZDh
         xrYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683628309; x=1686220309;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wdT8PJ8oH1xp8pRaW3V56IfqtFcYTK0lyTpuGxj9OGI=;
        b=FGdzkMCmxkSJ5S9q0HV8Cz4Mo1fWYvIhYO/d6QuhK1ohZkUu18rX1mFc/vNWLKX/lW
         kOQ4Q579PhV7lLbwH38JNm7FkTDZgxwOzvfLnn4uZ4MddyW5fr7/uZKa63QAJoI632Yb
         nOMQpxXGaS7SFvY16s1t4xvgaLIQbNbdYdTyaUq8VdLwpCgJTI8PGNg19mWFTfxxLEAm
         vhDyrgnGbXDxE5LYwzLJtQXIaSS4nvnt15FcsCrjIPCqTViKHYMqbTIkPokv0Wm8PfPp
         fFQP4Hf072z/THiUeJr+pyLwwP3avGMKHGpTX3ov96H+P3Xegmm+0m68lqXJL6tos8ry
         0M2A==
X-Gm-Message-State: AC+VfDyMBO5xcZz1U3gKXWFfDEKYV5Gai0EqPCM+38KP7BGcrAzvMOBr
        pCFvXlh8cCwKZpW5JjdjPu8v/A==
X-Google-Smtp-Source: ACHHUZ53xZYSNwoONmUG4WIDAbzuioKTIVZMq4k8YL6PVVqG3QazEaniinqBNr8eY8d+la89wqpTbw==
X-Received: by 2002:a17:902:9897:b0:1ab:253e:6906 with SMTP id s23-20020a170902989700b001ab253e6906mr12331938plp.67.1683628309309;
        Tue, 09 May 2023 03:31:49 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id o11-20020a170902d4cb00b001a076025715sm1195191plg.117.2023.05.09.03.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:31:48 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Guo Ren <guoren@kernel.org>
Subject: [PATCH -next v19 07/24] riscv: Introduce Vector enable/disable helpers
Date:   Tue,  9 May 2023 10:30:16 +0000
Message-Id: <20230509103033.11285-8-andy.chiu@sifive.com>
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

From: Greentime Hu <greentime.hu@sifive.com>

These are small and likely to be frequently called so implement as
inline routines (vs. function call).

Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
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

