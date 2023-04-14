Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D066E27CF
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 17:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjDNP73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 11:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjDNP72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 11:59:28 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E2F83D2
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 08:59:26 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d15so1499490pll.12
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 08:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1681487966; x=1684079966;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6nGKmDwG9+jNVeR75v05JMRVwMFJUAElECktRxuQgsc=;
        b=mM2vdqpkz2PBDDMrZvLiutf/ppjF1tCkaGP/crzjPrGQC7zlwYPJBix5iA6jmNH8fR
         LYABnDcmXEMK5KGZbECXDl4ndHVN2C0fLoIlOLGPm7BDAxe7VsWXcTPlVE3ojjKfwS/+
         dp7odakVnTOC3JBLRQ1xgAhaDy8CeITNr4D+Hs3XGChG32aocBrilAGAw+HV+is8Kf5G
         gZTZehgkU4QgO+G8kPL0RzpDo6rLzM7MbfDySeGYYAbt/ory/u5oC+bMs+WdMbPAQBZ0
         va77J9q6zwz0bzp9Wb1xVOGjsWQfClGhNn0HMmGLhFJJC5DNWPeu7sFGIyuUs/omzpyB
         cY7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681487966; x=1684079966;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6nGKmDwG9+jNVeR75v05JMRVwMFJUAElECktRxuQgsc=;
        b=k53hIZ6LJWSWWvuRXDSXUen8fxokXVg1P43phrme3/lHoprrd7WpUrzHIvWQXOcSgb
         vKQwx80iLddmcOG+nZxaggjLwrc7lEKSiGNwP29VFTkXB+eu+nqLxzI+d+s7/Cna6xFA
         2bJ8+xsgjW/2c3z4Q0lRKPLWzyL64jYNL9vyIo3/vvu9ARokygbT4N/lRIZyF20wpDqr
         AFR29nUQSAdC4ck6BtWsihmLASEOc7g5PGM4CksFPCQ1KEXRxUlIIkCNlFjoddcROF1C
         ivJyvvfSra/alNha+wZj6KPvcCgbXlr2+LowzwZHtJ68N6OhHw0DV43ebCcFV1K+HfLk
         kVZA==
X-Gm-Message-State: AAQBX9fqa9QjPX9z+vg9DLwzCtOHHGyUWn4u+fzwBs7BNqxXicvJyyhZ
        dPjMDEVPdBA5qMsAZ5B7OttYuA==
X-Google-Smtp-Source: AKy350bcQ+ZmyMAff8Obq6yV3BPKqrDn2XpjHAqeL+rg6LKB5pICPuePzioMZgZyYVR/Af5fsEAdrg==
X-Received: by 2002:a17:902:e54a:b0:1a2:3b6:8319 with SMTP id n10-20020a170902e54a00b001a203b68319mr3730449plf.54.1681487966260;
        Fri, 14 Apr 2023 08:59:26 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id br8-20020a17090b0f0800b00240d4521958sm3083584pjb.18.2023.04.14.08.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 08:59:25 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>
Subject: [PATCH -next v18 06/20] riscv: Introduce Vector enable/disable helpers
Date:   Fri, 14 Apr 2023 15:58:29 +0000
Message-Id: <20230414155843.12963-7-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230414155843.12963-1-andy.chiu@sifive.com>
References: <20230414155843.12963-1-andy.chiu@sifive.com>
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

