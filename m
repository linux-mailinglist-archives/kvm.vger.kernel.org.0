Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CA37085E2
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 18:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjERQVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 12:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjERQVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 12:21:16 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F97FE68
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:20:49 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64d2467d640so683555b3a.1
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684426849; x=1687018849;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EvrLPd1cTqQ0pEVjiT8YUKSvx/1xPgu8clZhUQSofCQ=;
        b=FtLX8JHMQVKFgHWdhhjDwu5jM+3buCm2ENvMKVrAVq3ECMS1bVPyUMeq2sWQDArIBS
         weDpuuKtqbRkamnCmrUT2qEzUeeJUuFLpxRfpG+7cRZ+TBvXVMhFeTMlvz62Szg5I53a
         2w9TC3AuvI6dJyYFj6+rtYIp2YS+SK4mhZqne9iu1i/N+c1OofX9baV5rP7q+pT1k9XC
         e2HV/TAzc8dM18AE/dYTLU4qH91Z1fROP1jdnrYvxyJtKJ6MOJou2kOJXVOqlS6psFHq
         dOQYanISqH6CNTuS8uHjbkKImoTX0yDVWEWXOk7LhLR+PMPEZ1WzsBnw3geXeADcfiZZ
         MKbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684426849; x=1687018849;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EvrLPd1cTqQ0pEVjiT8YUKSvx/1xPgu8clZhUQSofCQ=;
        b=HqPw65InHfIXW4D2iKn3zHaz/NneOYDV775Ype6/rew51vKMnP77UWqbfSGrr81ySS
         fBClmCVQICO0Eqs4mY9PmYxsydepTDsrZ6d3v1A2g4V2k6y7iKEdv+2amP+G9uRbJc3G
         yd7Dw5kzosEAJ8gaG18HtWN57R8hDe4y5hjnHPQEFHykMsRNsUOFHIBhZjepPaaX/E4h
         YQge2hBnXETOkUHEgIXrDU018fo1FB1mwZLI4gMw0uDFJACBk/GrAey7ZoOOYE2o4rN6
         D8UXOCgGu9LOfYRDkgAiKs8s+U+2sX1MKjk13XwiOxYK4O2Cd+SC4HJBnVbiHJEGNINI
         rLNQ==
X-Gm-Message-State: AC+VfDwn9hO+OoduhjavH4BKJsC1uNVaDB9eLOJc+DZgzaIugIR9AO5d
        WGG5UfSVm+412oc5tVLhKMLojg==
X-Google-Smtp-Source: ACHHUZ5F3YhKPesHs63kyS2hI87hWRcOXYkoisFdhsrt59NTCICskzaqIsvfB/OKK4tRgfNkxyJKRg==
X-Received: by 2002:a05:6a00:2ea4:b0:64a:9090:5147 with SMTP id fd36-20020a056a002ea400b0064a90905147mr5497396pfb.10.1684426848755;
        Thu, 18 May 2023 09:20:48 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id x23-20020a62fb17000000b006414b2c9efasm1515862pfm.123.2023.05.18.09.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 09:20:48 -0700 (PDT)
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
Subject: [PATCH -next v20 07/26] riscv: Introduce Vector enable/disable helpers
Date:   Thu, 18 May 2023 16:19:30 +0000
Message-Id: <20230518161949.11203-8-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230518161949.11203-1-andy.chiu@sifive.com>
References: <20230518161949.11203-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
---
 arch/riscv/include/asm/vector.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index bdbb05b70151..51bb37232943 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -11,12 +11,23 @@
 #ifdef CONFIG_RISCV_ISA_V
 
 #include <asm/hwcap.h>
+#include <asm/csr.h>
 
 static __always_inline bool has_vector(void)
 {
 	return riscv_has_extension_unlikely(RISCV_ISA_EXT_v);
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

