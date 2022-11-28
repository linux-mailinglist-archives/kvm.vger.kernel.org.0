Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC4763AD71
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 17:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbiK1QP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 11:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbiK1QPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 11:15:10 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6495E25282
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 08:15:04 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id io19so10612938plb.8
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 08:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ji6gUrAoWYT3XHk2lFOFtFs8PLEDbbIx9YYSf+S6VSU=;
        b=AjDuDNL8yAH4u64rbRauvAnfDwFYGSkUwRQHNT35gUX2qBC27sLneXYjLxoHThqaMD
         2XKsXAk0kyRCA8MF5ECg+7l/bjOsfAhXTdcnUzQKToxbZCG0Q2GZmXEWxCxO4g2snJLE
         foNXnRy9leX4WRty4LXz7pmeQJLWIQ1A8NVw+F5ctpUmMQ32/SLtKOmvjs1GkJ1qwusW
         lUuvExjF232MPQ4MgVW27YlIZHN8VjhclqVGFcw/FodzbFb00xTqWaAgx20VQEApxtLr
         oLMdXe0Q9PX7jsop2JH5Pb0TXuCxBMNa4l83br5MLpo/XVe6m/rYKBz4/sQHPpIOH9uW
         tAaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ji6gUrAoWYT3XHk2lFOFtFs8PLEDbbIx9YYSf+S6VSU=;
        b=rWfr/QMY60ONMopDmHKbIZZKRieZAn6Lhwwjtj6rIFfSdmAn8Smy4FeSNd4bA73Gn3
         S5lrQzQGJNxuyGtbMrs+ltlaDSVvP8MSwDeNOgqKcw7+sKH6BqQxCTewFhuI4zYa+x76
         xg4YNEFdVXQBXMRDekBmgBOgo8le9+xdM4gEqIOk2XfiEr7AEWtSEwYjgPpfoZw4YNMo
         UAtoC5J59Pd6d1+x2DoJuyfU2arbhSASUgBV2JWRbXDwz4w5oLCM/9DFAcz5TaRTifJo
         THEP5hMgpPfrdTay5nrdGU1UsBREo/m1ur9QSKuDmVhEolgiLhlLEEmCYbuS0ZpluQGc
         b+Ew==
X-Gm-Message-State: ANoB5pnLWssaYr0lm7KV4OpMPoe1aXeeBEjSREPLyXLw1aVcn5EQkGS0
        x8TAtrGkqgyTHm3s88raErKDxbZfW56sxQ==
X-Google-Smtp-Source: AA0mqf7yAshre1MYiIFD0k1ifqLxcshH2Yv8NLWThlH1BDV1OaAOo4j6oo9TJuEJSkDguwxkCNaAag==
X-Received: by 2002:a17:902:c702:b0:189:4bde:53c1 with SMTP id p2-20020a170902c70200b001894bde53c1mr25593754plp.1.1669652103621;
        Mon, 28 Nov 2022 08:15:03 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([171.76.85.0])
        by smtp.gmail.com with ESMTPSA id k145-20020a628497000000b0056246403534sm8210805pfd.88.2022.11.28.08.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 08:15:03 -0800 (PST)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 7/9] RISC-V: KVM: Save mvendorid, marchid, and mimpid when creating VCPU
Date:   Mon, 28 Nov 2022 21:44:22 +0530
Message-Id: <20221128161424.608889-8-apatel@ventanamicro.com>
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

We should save VCPU mvendorid, marchid, and mimpid at the time
of creating VCPU so that we don't have to do host SBI call every
time Guest/VM ask for these details.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h |  5 +++++
 arch/riscv/kvm/vcpu.c             |  6 ++++++
 arch/riscv/kvm/vcpu_sbi_base.c    | 11 +++++------
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 91c74b09a970..93f43a3e7886 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -165,6 +165,11 @@ struct kvm_vcpu_arch {
 	/* ISA feature bits (similar to MISA) */
 	DECLARE_BITMAP(isa, RISCV_ISA_EXT_MAX);
 
+	/* Vendor, Arch, and Implementation details */
+	unsigned long mvendorid;
+	unsigned long marchid;
+	unsigned long mimpid;
+
 	/* SSCRATCH, STVEC, and SCOUNTEREN of Host */
 	unsigned long host_sscratch;
 	unsigned long host_stvec;
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 68c86f632d37..312a8a926867 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -21,6 +21,7 @@
 #include <asm/csr.h>
 #include <asm/cacheflush.h>
 #include <asm/hwcap.h>
+#include <asm/sbi.h>
 
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
@@ -171,6 +172,11 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 			set_bit(host_isa, vcpu->arch.isa);
 	}
 
+	/* Setup vendor, arch, and implementation details */
+	vcpu->arch.mvendorid = sbi_get_mvendorid();
+	vcpu->arch.marchid = sbi_get_marchid();
+	vcpu->arch.mimpid = sbi_get_mimpid();
+
 	/* Setup VCPU hfence queue */
 	spin_lock_init(&vcpu->arch.hfence_lock);
 
diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
index 0c806f61c629..5d65c634d301 100644
--- a/arch/riscv/kvm/vcpu_sbi_base.c
+++ b/arch/riscv/kvm/vcpu_sbi_base.c
@@ -19,7 +19,6 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 {
 	int ret = 0;
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
-	struct sbiret ecall_ret;
 
 	switch (cp->a6) {
 	case SBI_EXT_BASE_GET_SPEC_VERSION:
@@ -48,13 +47,13 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			*out_val = kvm_vcpu_sbi_find_ext(cp->a0) ? 1 : 0;
 		break;
 	case SBI_EXT_BASE_GET_MVENDORID:
+		*out_val = vcpu->arch.mvendorid;
+		break;
 	case SBI_EXT_BASE_GET_MARCHID:
+		*out_val = vcpu->arch.marchid;
+		break;
 	case SBI_EXT_BASE_GET_MIMPID:
-		ecall_ret = sbi_ecall(SBI_EXT_BASE, cp->a6, 0, 0, 0, 0, 0, 0);
-		if (!ecall_ret.error)
-			*out_val = ecall_ret.value;
-		/*TODO: We are unnecessarily converting the error twice */
-		ret = sbi_err_map_linux_errno(ecall_ret.error);
+		*out_val = vcpu->arch.mimpid;
 		break;
 	default:
 		ret = -EOPNOTSUPP;
-- 
2.34.1

