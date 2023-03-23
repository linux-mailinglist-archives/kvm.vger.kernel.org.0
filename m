Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A756C6BBA
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 16:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbjCWPAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 11:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbjCWPAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 11:00:13 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972DE1ACF8
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 08:00:06 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso2338312pjb.2
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 08:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679583606;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6nGKmDwG9+jNVeR75v05JMRVwMFJUAElECktRxuQgsc=;
        b=Rz41bOqdKfl5FfAf65R7fUQGQX1CzCAON8GMDbEPTjJc+Ea0PVKsuf2+GpTQEJL9Bp
         bY+tkHzGfmFJVhiAzf3bM6MPdE01bkF6uNUUoFKy2sUODXQTlA2Iz05JtvpTfQ5kIln3
         TFoxrqWFkMJU1glN8/fRwTK7D09J7kW7WszfdkGuH2HdjYSEUXQcrrO7johdGVfbIaCn
         PWU/T75XvVvO+g71UJilt/RdOYV8w4mVxWkFhB0kbQSf2gtD5qigJT0VniGcFhXRv5zC
         Aoo7PpJIfkhnbD4MLff+iLmSP16tTABjSff+vkRsm2LFEdEs+KL8ovv2NJoA5VYjta6M
         yExA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679583606;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6nGKmDwG9+jNVeR75v05JMRVwMFJUAElECktRxuQgsc=;
        b=ghlWLW1ymL+La/dTK2KCgXmVpoW9pgnc22a3dSS6O0MWJJk0S7JEl0F5v+ckSs0UIO
         0+5kbsvEr5huzZVMh9XLdtVvMG/YrtNZ7kvv1r3AKM0tfBWGfratsjfPP7/wi56PXyW/
         Y4hbk+cDIxgcm4vdfp/FVfmlQT2s4r3iPHDV92xpNMcjr/QDx7kkLS6MMaS7IGQ3o08c
         h8bWE0xIRsSujOnIp+68Sqwk7OGgOIFsUIMbev2jv/eM3kTPpmUQd+442l7YrwO8w9GJ
         uwTyFyH2f1uvx6643mmrP6FMIU9zKiuGyTIdSfI0XCC7I+4I17M5fcSSKOB4Kx+bIgA5
         wOJg==
X-Gm-Message-State: AO0yUKVopLT015kDrRFuuhJ2pW8e6YYoE3UVpdITn3ftz/rjwC1YTtte
        4ZAVAmqq2ZJOviY0pCmh51knSg==
X-Google-Smtp-Source: AK7set+uoxNy2JVwtQ/ySsF5piETGWumQRej0C/cqwQforKo3fh/cYPJk1holgP2j/v4Dycx8bWqOw==
X-Received: by 2002:a17:90b:4a43:b0:22c:6d7c:c521 with SMTP id lb3-20020a17090b4a4300b0022c6d7cc521mr7293331pjb.45.1679583605730;
        Thu, 23 Mar 2023 08:00:05 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902854900b0019f53e0f136sm12503965plo.232.2023.03.23.08.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 08:00:05 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH -next v16 06/20] riscv: Introduce Vector enable/disable helpers
Date:   Thu, 23 Mar 2023 14:59:10 +0000
Message-Id: <20230323145924.4194-7-andy.chiu@sifive.com>
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

