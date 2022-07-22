Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22F357E4D2
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 18:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbiGVQvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 12:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235603AbiGVQu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 12:50:58 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9197B2A263
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 09:50:57 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id bk6-20020a17090b080600b001f2138a2a7bso6728852pjb.1
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 09:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JO4EgaFLA+7AeATY37WXQlGJ9vdJOA0mjTrTo1yHUWU=;
        b=bq+HPB5ICJBE7xBIVRuNq+EPfcnoMUoLuXKksB72CK/VjmEbn4i9TVIwnfsu56z21Q
         DWM/ngg7QCZriV1iyAEKzNlWFWhvBhOc403GaQ/UGjb/oxQgJAOin4v+loO9HnjoV61T
         0w9dvMzfQ+gJjANcmO76tv5n6MFedvhjDJR7Cg6ipQMVeC3CQhIzRvwr94/m0+rgCZtv
         2fYvKpWmEiXHoWb+OJeCV1FmufOnEqTRgmPjYBW+GI3fWQBDj2f+e6YNSTT6I+Rm6Xco
         WVNrYVFdKaOSlxbZ3HM5FGX8qGT7dy527SffgvIrSp5C7hUAFYwkwyHvU8n8OUh77vHe
         GYAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JO4EgaFLA+7AeATY37WXQlGJ9vdJOA0mjTrTo1yHUWU=;
        b=4101BqIaQ0lOgtw8csECltq+VVVwnSdkyMARSFPeQvlR4SHJTdKybYvkI3kZ2rvm9/
         ahMWXotKwmB/73kqYaQivrZWrGYRKU+5248Z9j+OIeGC1cPJZsZwv7vBbfarUYuMMPOz
         v93P8qnSqUIX32EEKhIsn5bXWSGCzHR8+N/AxUWAvcnZmX64CxaCi1zcHV0xKLdg5AMl
         Upb9N8zhaXmH4p5I0vAeXMho/KFoyTE9lYzVAT84nGxf6GIKJ71IxRJLmiU9bSyG6q1c
         C0DFzv1xLl3rhyPS9TIsuL94qw6nq83/qjHQecJ7Um2L8iSXGaizon49Cnn1ztXeKUC1
         L3SA==
X-Gm-Message-State: AJIora8vbPTJkC1pI/rMMaaKMZlSWFeAH8hENp1sIDO5xueUnAwFhPpB
        2tZL8UoExj9f0P2HqcYFiW7BPQ==
X-Google-Smtp-Source: AGRyM1ugctXp/cOpPZAz/TTQpitjVDRcbpFZbfjDJ5+U3/UXlRTApFXjaoxWKtg4T6l9D98ypoh6tA==
X-Received: by 2002:a17:902:8f98:b0:16d:2a9:d5c7 with SMTP id z24-20020a1709028f9800b0016d02a9d5c7mr423460plo.5.1658508656994;
        Fri, 22 Jul 2022 09:50:56 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902ea0700b0016a3f9e4865sm4028476plg.148.2022.07.22.09.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 09:50:56 -0700 (PDT)
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
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rob Herring <robh@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Wei Fu <wefu@redhat.com>
Subject: [PATCH v7 2/4] RISC-V: Enable sstc extension parsing from DT
Date:   Fri, 22 Jul 2022 09:50:45 -0700
Message-Id: <20220722165047.519994-3-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220722165047.519994-1-atishp@rivosinc.com>
References: <20220722165047.519994-1-atishp@rivosinc.com>
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

