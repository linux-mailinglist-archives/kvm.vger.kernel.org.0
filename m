Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42CA67B42D
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 15:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbjAYOVo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 09:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235467AbjAYOVi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 09:21:38 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AD747EEF
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:21:32 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id a18so5450307plm.2
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+7HecywGlJlNGqgW5DTmk825ntRt7eobb4WEX9z99xY=;
        b=gisRvU9kgDZ2QpFge4hNwXnXAzJien4RgFybF/izeNP7kzDdNeYRBdbPgB0Ia8cW0W
         JIjsAaAsN9h59Z1yJpqmr4osLvwDqsLgUjm/2/5UjBkiXClDfh9OJNazsBZwgaKhrlM3
         3+zZ7HGxIMgnp7GDXUVzew9WM2ko9wYlVpAzIhiLRvBQf9thP5j9pAzoutA0+4piHpFY
         iuiU5fW8ugwwoiDuXXr1Ygj9f6r5iSm0kbtIr84/H4LdG8D2NllYi9SCr+IHvvdCkRPA
         ZkdTixLN6NfD08aaBTe2jaYCMyirNr/acT3nHx4OyXhvttSKGmSb1vabupdjs6y98/1V
         rctg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+7HecywGlJlNGqgW5DTmk825ntRt7eobb4WEX9z99xY=;
        b=OiqbEu25thxA4JPuCuq3epuPkG5+1UCq9jMYTtoOmHKTH9IW18IBsQLynBc/qp6v/B
         pOAfdtRjCfxiPLK41RJ56k51r9JXo8YcchkvhZJmKhmnE2WImRCWhBU5NJdxD7Nbwg77
         gniPl20AsqE6RNW2jXmIl1kTTDlcRwf02fnGPc2l0SyFMSfLBT+wixve4pkI9Y4JYWj3
         RHcCsbfXVG0BW7S1clqmz0YPD9m5wGZZRA0fBPv4rpBHB/cIKzXn8KkR7OgB/uZPGrwm
         7p5kw1J+Y+8leOgVitojR8l86tliy5KJ+6uuKSlTGscUta2Yi5Lcxymuu0WklvDOwUJx
         GPVQ==
X-Gm-Message-State: AO0yUKWnay1Z30bahkGhfgeZonBAJvnQbVRA6CLvxsAelQVva85u/UPu
        YcxGFEpZ3Divh7ka0DnFQhezUg==
X-Google-Smtp-Source: AK7set+taHzTHqbs/8HQ6ZBO3PAr7J4C/hcNzYvOlh4K21lnF2smtxgLFEFzTtxVG1DC83tsP1APig==
X-Received: by 2002:a17:902:da81:b0:196:e77:f07b with SMTP id j1-20020a170902da8100b001960e77f07bmr10029018plx.39.1674656492301;
        Wed, 25 Jan 2023 06:21:32 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id bu11-20020a63294b000000b004a3510effa5sm3203520pgb.65.2023.01.25.06.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:21:31 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>
Subject: [PATCH -next v13 06/19] riscv: Introduce Vector enable/disable helpers
Date:   Wed, 25 Jan 2023 14:20:43 +0000
Message-Id: <20230125142056.18356-7-andy.chiu@sifive.com>
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
index 917c8867e702..0fda0faf5277 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -11,12 +11,23 @@
 #ifdef CONFIG_RISCV_ISA_V
 
 #include <asm/hwcap.h>
+#include <asm/csr.h>
 
 static __always_inline bool has_vector(void)
 {
 	return static_branch_likely(&riscv_isa_ext_keys[RISCV_ISA_EXT_KEY_VECTOR]);
 }
 
+static __always_inline void rvv_enable(void)
+{
+	csr_set(CSR_SSTATUS, SR_VS);
+}
+
+static __always_inline void rvv_disable(void)
+{
+	csr_clear(CSR_SSTATUS, SR_VS);
+}
+
 #else /* ! CONFIG_RISCV_ISA_V  */
 
 static __always_inline bool has_vector(void) { return false; }
-- 
2.17.1

