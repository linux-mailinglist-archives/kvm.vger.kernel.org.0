Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEDE67ED7B
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 19:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbjA0S1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 13:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235371AbjA0S0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 13:26:44 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285627CC82
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 10:26:26 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id nn18-20020a17090b38d200b0022bfb584987so5533661pjb.2
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 10:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+UCsgdBat0A/X8QbgW8UxlHki/znQOwLUkBQOZIZWgo=;
        b=qTZC1QY7AeVzJn+28DVAop48QwDUY48K0u17ecV9zQxbYCz8Bg0s0HQDbQQdG3i41g
         v5X9wikUTMaYjBauUozPB+4ZVT9+zlxxRx2QVnto/2ZSqEoEJmJJvGXq93/NWmNM7qty
         iyCV3IWGqunMwM2I0qqk/L2qU/CbnX27dkHi0Tj+ci20TWqvQq40vIYzLE4pAndkjDkA
         +esrjVhQT9YpuS8LApEcU6yXB8A7qt0g5+RlwG6LwG3XsiKOzFZM8V0bgCeGoE9p7Dd5
         fOs1D/B65zdExuEvvvu7GjNNTmZkd0G73g3i8rKtDa47KKPlK3mBmyTY/KuRBKY4dNWj
         FNRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+UCsgdBat0A/X8QbgW8UxlHki/znQOwLUkBQOZIZWgo=;
        b=y9VvCJehk/JyujV96Y739CFOWCCO02Iuo/VyhRKFYTXmYhhfVIt0H/XU/nUvudnvK5
         uo/H+b2n14/HyB5iu7FB1l8a1UoFvJHoajLXQXEckqO1J09YrpH0FFFC0IlQKBHQg7Zl
         xk7uPorpFD9en844kbTfNslRyVyIUXpvQCvS08RYYGcp1EUsiOGAxZXBdW32nl2VeIIL
         DUG0SkNlWliBjufu4TGtP9oHh48y6XZIOvyXWMPYVfm/j2qGVGx4VOaU9+yxWamKFYrt
         lxdLaglppVpYWbsavKIPQ4pPLxRkytbdYRBbI9j2ZHXoDefHBRN0Rb95FwME9/Oaa3zZ
         bC4Q==
X-Gm-Message-State: AO0yUKWFNSX21/2ZM6gZkkiXsh/KBl1QVHWXWpDN9ode5NZmA6vALQ1p
        toMOLi56FrobwPWjnEkVuYmZbw==
X-Google-Smtp-Source: AK7set8tCZddvibqDFZRfz+6EOq+DZgY/T/9oZk6ciwnoibDCr3ANI/hoO5lvwjf7m4N8O2RA+sG2g==
X-Received: by 2002:a17:902:da8e:b0:194:6f3b:3aa1 with SMTP id j14-20020a170902da8e00b001946f3b3aa1mr7245179plx.55.1674843986465;
        Fri, 27 Jan 2023 10:26:26 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jc5-20020a17090325c500b00189d4c666c8sm3195219plb.153.2023.01.27.10.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 10:26:26 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v3 14/14] RISC-V: KVM: Increment firmware pmu events
Date:   Fri, 27 Jan 2023 10:25:58 -0800
Message-Id: <20230127182558.2416400-15-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127182558.2416400-1-atishp@rivosinc.com>
References: <20230127182558.2416400-1-atishp@rivosinc.com>
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

KVM supports firmware events now. Invoke the firmware event increment
function from appropriate places.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/tlb.c              | 4 ++++
 arch/riscv/kvm/vcpu_sbi_replace.c | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
index 309d79b..b797f7c 100644
--- a/arch/riscv/kvm/tlb.c
+++ b/arch/riscv/kvm/tlb.c
@@ -181,6 +181,7 @@ void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
 
 void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu)
 {
+	kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_FENCE_I_RCVD);
 	local_flush_icache_all();
 }
 
@@ -264,15 +265,18 @@ void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu)
 						d.addr, d.size, d.order);
 			break;
 		case KVM_RISCV_HFENCE_VVMA_ASID_GVA:
+			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD);
 			kvm_riscv_local_hfence_vvma_asid_gva(
 						READ_ONCE(v->vmid), d.asid,
 						d.addr, d.size, d.order);
 			break;
 		case KVM_RISCV_HFENCE_VVMA_ASID_ALL:
+			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD);
 			kvm_riscv_local_hfence_vvma_asid_all(
 						READ_ONCE(v->vmid), d.asid);
 			break;
 		case KVM_RISCV_HFENCE_VVMA_GVA:
+			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_RCVD);
 			kvm_riscv_local_hfence_vvma_gva(
 						READ_ONCE(v->vmid),
 						d.addr, d.size, d.order);
diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index abeb55f..71a671e 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -11,6 +11,7 @@
 #include <linux/kvm_host.h>
 #include <asm/sbi.h>
 #include <asm/kvm_vcpu_timer.h>
+#include <asm/kvm_vcpu_pmu.h>
 #include <asm/kvm_vcpu_sbi.h>
 
 static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
@@ -25,6 +26,7 @@ static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		return 0;
 	}
 
+	kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_SET_TIMER);
 #if __riscv_xlen == 32
 	next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
 #else
@@ -57,6 +59,7 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		return 0;
 	}
 
+	kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_IPI_SENT);
 	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
 		if (hbase != -1UL) {
 			if (tmp->vcpu_id < hbase)
@@ -67,6 +70,7 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		ret = kvm_riscv_vcpu_set_interrupt(tmp, IRQ_VS_SOFT);
 		if (ret < 0)
 			break;
+		kvm_riscv_vcpu_pmu_incr_fw(tmp, SBI_PMU_FW_IPI_RECVD);
 	}
 
 	return ret;
@@ -90,6 +94,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 	switch (funcid) {
 	case SBI_EXT_RFENCE_REMOTE_FENCE_I:
 		kvm_riscv_fence_i(vcpu->kvm, hbase, hmask);
+		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_FENCE_I_SENT);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA:
 		if (cp->a2 == 0 && cp->a3 == 0)
@@ -97,6 +102,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 		else
 			kvm_riscv_hfence_vvma_gva(vcpu->kvm, hbase, hmask,
 						  cp->a2, cp->a3, PAGE_SHIFT);
+		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_SENT);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
 		if (cp->a2 == 0 && cp->a3 == 0)
@@ -107,6 +113,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 						       hbase, hmask,
 						       cp->a2, cp->a3,
 						       PAGE_SHIFT, cp->a4);
+		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_SENT);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA:
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA_VMID:
-- 
2.25.1

