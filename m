Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE21722B6D
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbjFEPkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234917AbjFEPk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:40:26 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F91D18E
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 08:40:18 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1b04782fe07so25690585ad.3
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 08:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685979617; x=1688571617;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EvrLPd1cTqQ0pEVjiT8YUKSvx/1xPgu8clZhUQSofCQ=;
        b=GLGpLSOO2XQGnAjD+WTSHwZSoz7d6GqWYDdRRuaFM0fOXgUKJjD/vDh+BPvkA/RgyU
         685CXX6eIHuTbnIUzRxlQybayn8cRJM2+Xz+RvF9qfWKesDHBItFu9Z29l1Jp9/sEwIK
         NDZR5kWj6facZIXcTG8CaaattaKnUv9kDlSTnQ21Bd7TBZqx4z/9xRNAw1/CRtiX9SqL
         UUfDoiu02MWoCs+dBtUtAIobuD5akmfGI9NXiQfMwO9XmZ0qH1X80TlyAGpBLfHZQrBN
         no+/MLmmn3PKtBmXm1fF/hw1H6IzIJriTRSqWrbgGHnNtULrHKYTZE6x1zccrxa0RPGI
         FPmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979617; x=1688571617;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EvrLPd1cTqQ0pEVjiT8YUKSvx/1xPgu8clZhUQSofCQ=;
        b=Nfcqu37eMT6ZG5UpMivAsseRrrQyh5XFS3oUWM3nxiuiEtHNt3JyCKPfJaVrds2Kjt
         sDwOFITKvgvQdUPiHTMjQpmNrsqYrYFB8XVIp71Ihg1VDxIMbmvHeeXbGZshM0h2GoNV
         2r0Ka5aT6vaN/Cr1g60Rn5eA+Vgn/o/ebWZioQGTyZTejf9CdhwWXStVVZgO9ISO2hku
         GXO7bBTkqPRlrau8oC1WVfoiS2Xzl1SsmNWO7nkZBVYqjoQ5TOd63UuT0gZld6TGA7NO
         lK67oDVb2T+/wvz6OxGRbM4prPufFv7vygyIyCxi5okFfI42Kw9EsSQuzM6tO39NpWKk
         yGuA==
X-Gm-Message-State: AC+VfDwPjkcBD4J8vvlP+nsqawjoGnrRc+k8V/EarPeNHhl/VTev51ig
        ATrhlxBOFJ6tMGVToDgoVMViOQ==
X-Google-Smtp-Source: ACHHUZ4UH3+nQ7w0dxAK1qHTv+AY0CqemgAzfxycKSq/ENc3IsLO/TPxD8RwA0uyPe86zzm/LsZEXQ==
X-Received: by 2002:a17:902:ea0a:b0:1b0:66b6:6ae5 with SMTP id s10-20020a170902ea0a00b001b066b66ae5mr4752327plg.61.1685979617657;
        Mon, 05 Jun 2023 08:40:17 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jk19-20020a170903331300b001b0aec3ed59sm6725962plb.256.2023.06.05.08.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:40:17 -0700 (PDT)
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
Subject: [PATCH -next v21 07/27] riscv: Introduce Vector enable/disable helpers
Date:   Mon,  5 Jun 2023 11:07:04 +0000
Message-Id: <20230605110724.21391-8-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230605110724.21391-1-andy.chiu@sifive.com>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
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

