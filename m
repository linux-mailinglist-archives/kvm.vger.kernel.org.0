Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876D368ADCE
	for <lists+kvm@lfdr.de>; Sun,  5 Feb 2023 02:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbjBEBPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 20:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjBEBP1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 20:15:27 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A882125957
        for <kvm@vger.kernel.org>; Sat,  4 Feb 2023 17:15:26 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id c10-20020a17090a1d0a00b0022e63a94799so12175900pjd.2
        for <kvm@vger.kernel.org>; Sat, 04 Feb 2023 17:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CL8v0AQsX+ZaW68BNuHu0nM6ZE+yLKRe23LChc9y1ZE=;
        b=ZRH+09m+6M7w5O02O/M1IQSX6OH9TPKSMDeduT/LPjQfAoHWtVmRHc7KboHPEaBuDh
         e30NIc9hGxOiY3e47LJBY4kbDXEGMn2gvW6j3SIMbRpEdistHyBgozYCQJ4OdE8nNHcx
         u3S5BzL/0EutLz3NwbN2HdsSaWW43/erZLr5RJSHNa6qYLu089XGcFkmyoLBEgajHyHW
         bmmgjiguVeOJntuVmuAt4LBPBF5OMkkG/z6m2aYXWqKpHsxzMcEz81T0/2R1nKJ/hIgo
         loxj97sBJufboe2zjWthIhnQYZP1aC5tcaAhTFzsIvQEDdn8gUK8/hSX3njbdPQ7sPzy
         uaqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CL8v0AQsX+ZaW68BNuHu0nM6ZE+yLKRe23LChc9y1ZE=;
        b=Pn8G+aQj3h/YhUD3tjLtz+OTxk31erMBx/qCAq88wsYRrt3T8y+vGkfl2zcYMHJKO4
         eoYYs5p+8WZ1mqHcBjeZS/fc+T8r3U/DlJ3dhEjgoBEgt5YRDdR+O4OF6jycJ6p4dJr1
         99DzC9LNA/pw3jVTb5TsOTyzJbnNKgltEdjN4UfqGN2PZksJ6D2UFJhx/W6Fggxo12J6
         LJfs1LF9PKK1x4E72L9NpXtl+qsAS+hAneZPQzUJJ7ptGkjvBtln6A9x8RZQ7Oewypfi
         GHJ6ypcb7Btzq+pfT868Ql5Bzjgehp09YCgBXoa9Rogx5JjxymSMCHa8d50wBKB4Rrnn
         umhQ==
X-Gm-Message-State: AO0yUKUI1UzrVYzIDGPuJlGpaOWjRFCk0NeW7Lwvs7ViJSR/GNpY1Zfh
        xT9qbyh5RApm2jxkJZCXI37rmA==
X-Google-Smtp-Source: AK7set8RpnACAcot1AknBBPjsvtsA7H1/tXvbKnuz/e95wuvEaah03h17AYyNjAOK8R3bSJl4avgDg==
X-Received: by 2002:a17:90b:3ec3:b0:22c:6cd4:2686 with SMTP id rm3-20020a17090b3ec300b0022c6cd42686mr16241370pjb.30.1675559726394;
        Sat, 04 Feb 2023 17:15:26 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id c7-20020a17090a020700b0023080c4c3bcsm2721917pjc.31.2023.02.04.17.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 17:15:26 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v5 04/14] RISC-V: KVM: Define a probe function for SBI extension data structures
Date:   Sat,  4 Feb 2023 17:15:05 -0800
Message-Id: <20230205011515.1284674-5-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230205011515.1284674-1-atishp@rivosinc.com>
References: <20230205011515.1284674-1-atishp@rivosinc.com>
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

Currently the probe function just checks if an SBI extension is
registered or not. However, the extension may not want to advertise
itself depending on some other condition.
An additional extension specific probe function will allow
extensions to decide if they want to be advertised to the caller or
not. Any extension that does not require additional dependency checks
can avoid implementing this function.

Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h | 3 +++
 arch/riscv/kvm/vcpu_sbi_base.c        | 7 +++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index f79478a..45ba341 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -29,6 +29,9 @@ struct kvm_vcpu_sbi_extension {
 	int (*handler)(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		       unsigned long *out_val, struct kvm_cpu_trap *utrap,
 		       bool *exit);
+
+	/* Extension specific probe function */
+	unsigned long (*probe)(struct kvm_vcpu *vcpu);
 };
 
 void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
index 5d65c63..be47828 100644
--- a/arch/riscv/kvm/vcpu_sbi_base.c
+++ b/arch/riscv/kvm/vcpu_sbi_base.c
@@ -19,6 +19,7 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 {
 	int ret = 0;
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+	const struct kvm_vcpu_sbi_extension *sbi_ext;
 
 	switch (cp->a6) {
 	case SBI_EXT_BASE_GET_SPEC_VERSION:
@@ -43,8 +44,10 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			 */
 			kvm_riscv_vcpu_sbi_forward(vcpu, run);
 			*exit = true;
-		} else
-			*out_val = kvm_vcpu_sbi_find_ext(cp->a0) ? 1 : 0;
+		} else {
+			sbi_ext = kvm_vcpu_sbi_find_ext(cp->a0);
+			*out_val = sbi_ext && sbi_ext->probe ? sbi_ext->probe(vcpu) : !!sbi_ext;
+		}
 		break;
 	case SBI_EXT_BASE_GET_MVENDORID:
 		*out_val = vcpu->arch.mvendorid;
-- 
2.25.1

