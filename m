Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E646557BE59
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 21:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbiGTTX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 15:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiGTTXz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 15:23:55 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3444F6A4
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 12:23:54 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id f11so17266049pgj.7
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 12:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JO4EgaFLA+7AeATY37WXQlGJ9vdJOA0mjTrTo1yHUWU=;
        b=F5LLa+fti1ldqbN1oggUaGJdciAVFKbR5+6Ynx5vr02UiAXfBtaiR4TNUGh61mbiif
         5vLxqOMia10VhbKdBKIqxy5sEblKTJJa4VtjsiXYkFii4Q2uPdNcDVRb8KIeLlsHAxCa
         WZ4KsxXyIDoAk9i007nAyz7siGGxTWYsNVDVysgUKylfM7+DsiV8DJldr1DNH8gO4eez
         hHS3Su1nTW1d7iJMrIj02pzOyhUa1pMBjPAzaRxryW+O3nl9sOfCld2s35P+jvNRDkyL
         R0mhnBEUokGFEg/RTzciQ8x4Ob1he5KkVZPdBqu25kRxIW4gXnW8VV6BQ47vpAsuwvQ3
         H4eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JO4EgaFLA+7AeATY37WXQlGJ9vdJOA0mjTrTo1yHUWU=;
        b=NwLi0ZjlRebMzB1iWkko22+FfylL3TL560fJfl+3xgFWASRbv4i5KBUMvJuvGAlw/M
         3nRrxF7ZA114/KkY8g6M9VgLf2/5ZdaEVdflovUSKbPSXUk/fyW/GSQ93WmSXK4I5Pl0
         ue3ux4mCNbxpeUuYy2GYTSac8PZeizMaV5XBVyiPIJ0KIRI4iiyASoeen38wgATHpUJe
         +20OHYOmYIBGfY37oBwRBN18bPk3VUl2J4KEu07sKaBA+MJaUZ3h1ppp7lIypwbBSBeW
         jDh1YUtjIw6LDwypRaL/Qiy8YOmhxuj6pqSyFosYB4updPN09NDwBKmULbqfYykx6r/G
         TBjw==
X-Gm-Message-State: AJIora+7yFCrV87ayFMFFqfyf8D92VtWMG4BdSTuzrrSuLh5N5PrfhoH
        LhQYKptcSugYhhAf4zy9e0HOjA==
X-Google-Smtp-Source: AGRyM1srE6PB4hYPgFpjfbQll7ccCgxCL74nS8/5jSzOtV/Dpz4OwUpbO6UtkrHOiR37g9OoKefmtg==
X-Received: by 2002:a63:f91b:0:b0:40d:d291:1555 with SMTP id h27-20020a63f91b000000b0040dd2911555mr35543371pgi.399.1658345034349;
        Wed, 20 Jul 2022 12:23:54 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id y23-20020a17090264d700b0016d2e772550sm219902pli.175.2022.07.20.12.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 12:23:54 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Liu Shaohua <liush@allwinnertech.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Philipp Tomsich <philipp.tomsich@vrull.eu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Wei Fu <wefu@redhat.com>
Subject: [PATCH v5 2/4] RISC-V: Enable sstc extension parsing from DT
Date:   Wed, 20 Jul 2022 12:23:40 -0700
Message-Id: <20220720192342.3428144-3-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220720192342.3428144-1-atishp@rivosinc.com>
References: <20220720192342.3428144-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ISA extension framework now allows parsing any multi-letter
ISA extension.

Enable that for sstc extension.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/hwcap.h | 1 +
 arch/riscv/kernel/cpu.c        | 1 +
 arch/riscv/kernel/cpufeature.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 4e2486881840..b186fff75198 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -53,6 +53,7 @@ extern unsigned long elf_hwcap;
 enum riscv_isa_ext_id {
 	RISCV_ISA_EXT_SSCOFPMF = RISCV_ISA_EXT_BASE,
 	RISCV_ISA_EXT_SVPBMT,
+	RISCV_ISA_EXT_SSTC,
 	RISCV_ISA_EXT_ID_MAX = RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
index fba9e9f46a8c..0016d9337fe0 100644
--- a/arch/riscv/kernel/cpu.c
+++ b/arch/riscv/kernel/cpu.c
@@ -89,6 +89,7 @@ int riscv_of_parent_hartid(struct device_node *node)
 static struct riscv_isa_ext_data isa_ext_arr[] = {
 	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
 	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
+	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
 	__RISCV_ISA_EXT_DATA("", RISCV_ISA_EXT_MAX),
 };
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 12b05ce164bb..034bdbd189d0 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -199,6 +199,7 @@ void __init riscv_fill_hwcap(void)
 			} else {
 				SET_ISA_EXT_MAP("sscofpmf", RISCV_ISA_EXT_SSCOFPMF);
 				SET_ISA_EXT_MAP("svpbmt", RISCV_ISA_EXT_SVPBMT);
+				SET_ISA_EXT_MAP("sstc", RISCV_ISA_EXT_SSTC);
 			}
 #undef SET_ISA_EXT_MAP
 		}
-- 
2.25.1

