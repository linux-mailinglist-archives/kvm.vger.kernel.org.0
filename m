Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CE263AD6D
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 17:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiK1QPJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 11:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbiK1QPE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 11:15:04 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7C024BF0
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 08:14:56 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id x13-20020a17090a46cd00b00218f611b6e9so10625377pjg.1
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 08:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5vvqUKmjIlo2M+VXNYk9fymWjR9KRElpX3u4BLE4jMI=;
        b=liRaBUEKu2MYafBpndLUswBx84/iGkUeSpwIkM1ayLv71FbHHAdoSwYsy8RFoOuVg0
         NVRR46SYjlR4McTk73LTvT7Vn+S0o0JxILW2NqjxMbYb5cDH3rmtRFM/mxmM7KOECHBv
         EwvJRiMLiC+aVVzG5UblNwd9Lf7PVDCnGirQJ87Supl0JpY5MCxal8Nk2kVibfnt6pFG
         79/qA0AyZXTyFBy4upYyciVHZHY8H0+xFpdUBvqwsd4j3xtReMeRCmaDNnggFEmmSRJo
         gqv5IBRmUjCuS6yjsCwh7rGPsCaGO0w09rhCjkXWuucdTO5Nqwwh/gTAhKkuZ5w4Rmg0
         t5iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5vvqUKmjIlo2M+VXNYk9fymWjR9KRElpX3u4BLE4jMI=;
        b=z7TMSd0vUSbVj1XqrsMtKl1uXfBebyYY2VCq+Ef4ilGH1hp/Qa/Ma9WydaDPG6sria
         OKLkWHsJgnWawBH7dJcboxDeS0vlVyE0FpYxbwtTtEuAqCkDgk5AvSJXUoyWEr8XYmQU
         pj+dcX9GZA3/Cysa/UN/85UR1p255vwsNLfZyM4Sq9RDkNiwbeLyZ4RpPL5nLdZBvm03
         6okFu3TBF8qQ4Sz12tU5MZ2Ssw9tQ7RO01QHBBaD4wU+Jluu/6SDAzUboLoNhv3x9D4G
         9IJkwC1UjYESO+BlAXNge2aWn0aYcjDRG7QBNA/AbE0goqsauDCZ7mU+5LfmS99UACtg
         61qw==
X-Gm-Message-State: ANoB5pklGuDBfBQM4NNjaE+DzdhCsuXCguwiPi0KAuTBFcZ3Unp9diiY
        zM9LzXpm2QIFc4uiiFh6o4skUA==
X-Google-Smtp-Source: AA0mqf5Xb59cW1JF8tw86FD9XA9POLw2LsXSD66lgcwv1aWXWX4IUtipw364kc5dpdR93c/3Gwh/bQ==
X-Received: by 2002:a17:90a:4302:b0:20a:e469:dc7d with SMTP id q2-20020a17090a430200b0020ae469dc7dmr53155068pjg.97.1669652095403;
        Mon, 28 Nov 2022 08:14:55 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([171.76.85.0])
        by smtp.gmail.com with ESMTPSA id k145-20020a628497000000b0056246403534sm8210805pfd.88.2022.11.28.08.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 08:14:55 -0800 (PST)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 5/9] RISC-V: KVM: Move sbi related struct and functions to kvm_vcpu_sbi.h
Date:   Mon, 28 Nov 2022 21:44:20 +0530
Message-Id: <20221128161424.608889-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221128161424.608889-1-apatel@ventanamicro.com>
References: <20221128161424.608889-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just like asm/kvm_vcpu_timer.h, we should have all sbi related struct
and functions in asm/kvm_vcpu_sbi.h.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h     | 10 ++--------
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  6 ++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 6502f9099965..91c74b09a970 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -16,6 +16,7 @@
 #include <asm/hwcap.h>
 #include <asm/kvm_vcpu_fp.h>
 #include <asm/kvm_vcpu_insn.h>
+#include <asm/kvm_vcpu_sbi.h>
 #include <asm/kvm_vcpu_timer.h>
 
 #define KVM_MAX_VCPUS			1024
@@ -94,10 +95,6 @@ struct kvm_arch {
 	struct kvm_guest_timer timer;
 };
 
-struct kvm_sbi_context {
-	int return_handled;
-};
-
 struct kvm_cpu_trap {
 	unsigned long sepc;
 	unsigned long scause;
@@ -216,7 +213,7 @@ struct kvm_vcpu_arch {
 	struct kvm_csr_decode csr_decode;
 
 	/* SBI context */
-	struct kvm_sbi_context sbi_context;
+	struct kvm_vcpu_sbi_context sbi_context;
 
 	/* Cache pages needed to program page tables with spinlock held */
 	struct kvm_mmu_memory_cache mmu_page_cache;
@@ -326,7 +323,4 @@ bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long mask);
 void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
 
-int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
-int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
-
 #endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index d4e3e600beef..f79478a85d2d 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -14,6 +14,10 @@
 #define KVM_SBI_VERSION_MAJOR 1
 #define KVM_SBI_VERSION_MINOR 0
 
+struct kvm_vcpu_sbi_context {
+	int return_handled;
+};
+
 struct kvm_vcpu_sbi_extension {
 	unsigned long extid_start;
 	unsigned long extid_end;
@@ -31,7 +35,9 @@ void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
 void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
 				     struct kvm_run *run,
 				     u32 type, u64 flags);
+int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
 const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid);
+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
 #ifdef CONFIG_RISCV_SBI_V01
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01;
-- 
2.34.1

