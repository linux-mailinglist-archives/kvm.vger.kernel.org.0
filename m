Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39AD16D6784
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 17:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235872AbjDDPg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 11:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235744AbjDDPgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 11:36:11 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0334EC5
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 08:35:52 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id bm2so24520880oib.4
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 08:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680622552; x=1683214552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YI338JaQ174nkLqVWr+V6SK8k3Md0go2Oy6ecZq7aOE=;
        b=cZufMmezK/J3K5t1K+9nvjGAxjSo3wsUgZD4EzIcvmpax4PAxS5DtiHA6Zd6IEZZzY
         UYym8zYFUa7q2J1DFOBna6w6ggsJI0+T4lnTdz8sJ76K8L0sL+zQ1vNdevrbHTEwF9fp
         TZsUpuryPx7vSfbyq87QJhRkNeaj/QOP1FoxGZ65ekIZi9M1HKYQR9qgQGp0ZNZHYlHl
         jUqNOftXtguXH3FWz6W3NSo/UuuTnqSAo8mNpZmcGn01Epo6otC/lXdus4pbEFrXcvWv
         6zc4aoygOROkx9s/00XhvfrXeUth6pSiFtnruhCTW8WJaCvkVTB878T9xuftCfRxD5mk
         BY4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680622552; x=1683214552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YI338JaQ174nkLqVWr+V6SK8k3Md0go2Oy6ecZq7aOE=;
        b=5xVmfb5z9fHqh625HnJayjepXuOPqYaB2/X7dKQR3Z0V/z/aJs6zN8J5VccOAnpv4o
         y/8+NP+ohmcLRqRMNYNj27RyMLoOSuMMgzrgYzUbD4rEIiUvAi/LUghYrWsOmEhQs6fo
         vDDgT5fgBFQV2RfB6Iwrk5se32M95mY4WRGddwSj3LsIOzvrGsKD5bPF8ms92HEyyY6o
         k9NFesWi+cHviYMVL+PlRgD8MFvzn+9K24IaszbSDQXt3OdTVc58g0CkhUh/gGmttzrl
         3vrIzFWxexRfAaVsnjteysyT5Mdg96OAdtDCfjb42u+NWkuU2uGzY+IYWocrTsR32JYW
         vppg==
X-Gm-Message-State: AAQBX9f3PbToe7f0GRTPsR36nzu3PfNXeyYaK2LxLEVvXdufgJfSc1vK
        HzME3yUjWRZDG11V6bMtDhclwQ==
X-Google-Smtp-Source: AKy350Y7jOZU2sRY4GBAOKv6/kTq0ePgKeNcDBlKsSNcfhN1N2WnXjQtQ35toFLBayQrNm19871UCA==
X-Received: by 2002:a05:6808:d49:b0:389:4bc5:8094 with SMTP id w9-20020a0568080d4900b003894bc58094mr12549130oik.3.1680622551730;
        Tue, 04 Apr 2023 08:35:51 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id w124-20020acadf82000000b00387384dc768sm5325803oig.9.2023.04.04.08.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 08:35:51 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v4 7/9] RISC-V: KVM: Use bitmap for irqs_pending and irqs_pending_mask
Date:   Tue,  4 Apr 2023 21:04:50 +0530
Message-Id: <20230404153452.2405681-8-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230404153452.2405681-1-apatel@ventanamicro.com>
References: <20230404153452.2405681-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To support 64 VCPU local interrupts on RV32 host, we should use
bitmap for irqs_pending and irqs_pending_mask in struct kvm_vcpu_arch.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h |  7 ++--
 arch/riscv/kvm/vcpu.c             | 53 ++++++++++++++++++++-----------
 2 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 3157cf748df1..ee0acccb1d3b 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -204,8 +204,9 @@ struct kvm_vcpu_arch {
 	 * in irqs_pending. Our approach is modeled around multiple producer
 	 * and single consumer problem where the consumer is the VCPU itself.
 	 */
-	unsigned long irqs_pending;
-	unsigned long irqs_pending_mask;
+#define KVM_RISCV_VCPU_NR_IRQS	64
+	DECLARE_BITMAP(irqs_pending, KVM_RISCV_VCPU_NR_IRQS);
+	DECLARE_BITMAP(irqs_pending_mask, KVM_RISCV_VCPU_NR_IRQS);
 
 	/* VCPU Timer */
 	struct kvm_vcpu_timer timer;
@@ -334,7 +335,7 @@ int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
 int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
 void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu);
-bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long mask);
+bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, u64 mask);
 void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 57bdbfc17d48..811c7e9a308c 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -141,8 +141,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	kvm_riscv_vcpu_aia_reset(vcpu);
 
-	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
-	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
+	bitmap_zero(vcpu->arch.irqs_pending, KVM_RISCV_VCPU_NR_IRQS);
+	bitmap_zero(vcpu->arch.irqs_pending_mask, KVM_RISCV_VCPU_NR_IRQS);
 
 	kvm_riscv_vcpu_pmu_reset(vcpu);
 
@@ -474,6 +474,7 @@ static int kvm_riscv_vcpu_general_get_csr(struct kvm_vcpu *vcpu,
 	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
 		kvm_riscv_vcpu_flush_interrupts(vcpu);
 		*out_val = (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_VALID_MASK;
+		*out_val |= csr->hvip & ~IRQ_LOCAL_MASK;
 	} else
 		*out_val = ((unsigned long *)csr)[reg_num];
 
@@ -497,7 +498,7 @@ static inline int kvm_riscv_vcpu_general_set_csr(struct kvm_vcpu *vcpu,
 	((unsigned long *)csr)[reg_num] = reg_val;
 
 	if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
-		WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
+		WRITE_ONCE(vcpu->arch.irqs_pending_mask[0], 0);
 
 	return 0;
 }
@@ -799,9 +800,9 @@ void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu)
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 	unsigned long mask, val;
 
-	if (READ_ONCE(vcpu->arch.irqs_pending_mask)) {
-		mask = xchg_acquire(&vcpu->arch.irqs_pending_mask, 0);
-		val = READ_ONCE(vcpu->arch.irqs_pending) & mask;
+	if (READ_ONCE(vcpu->arch.irqs_pending_mask[0])) {
+		mask = xchg_acquire(&vcpu->arch.irqs_pending_mask[0], 0);
+		val = READ_ONCE(vcpu->arch.irqs_pending[0]) & mask;
 
 		csr->hvip &= ~mask;
 		csr->hvip |= val;
@@ -825,12 +826,12 @@ void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
 	if ((csr->hvip ^ hvip) & (1UL << IRQ_VS_SOFT)) {
 		if (hvip & (1UL << IRQ_VS_SOFT)) {
 			if (!test_and_set_bit(IRQ_VS_SOFT,
-					      &v->irqs_pending_mask))
-				set_bit(IRQ_VS_SOFT, &v->irqs_pending);
+					      v->irqs_pending_mask))
+				set_bit(IRQ_VS_SOFT, v->irqs_pending);
 		} else {
 			if (!test_and_set_bit(IRQ_VS_SOFT,
-					      &v->irqs_pending_mask))
-				clear_bit(IRQ_VS_SOFT, &v->irqs_pending);
+					      v->irqs_pending_mask))
+				clear_bit(IRQ_VS_SOFT, v->irqs_pending);
 		}
 	}
 
@@ -843,14 +844,20 @@ void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
 
 int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
 {
-	if (irq != IRQ_VS_SOFT &&
+	/*
+	 * We only allow VS-mode software, timer, and external
+	 * interrupts when irq is one of the local interrupts
+	 * defined by RISC-V privilege specification.
+	 */
+	if (irq < IRQ_LOCAL_MAX &&
+	    irq != IRQ_VS_SOFT &&
 	    irq != IRQ_VS_TIMER &&
 	    irq != IRQ_VS_EXT)
 		return -EINVAL;
 
-	set_bit(irq, &vcpu->arch.irqs_pending);
+	set_bit(irq, vcpu->arch.irqs_pending);
 	smp_mb__before_atomic();
-	set_bit(irq, &vcpu->arch.irqs_pending_mask);
+	set_bit(irq, vcpu->arch.irqs_pending_mask);
 
 	kvm_vcpu_kick(vcpu);
 
@@ -859,25 +866,33 @@ int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
 
 int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
 {
-	if (irq != IRQ_VS_SOFT &&
+	/*
+	 * We only allow VS-mode software, timer, and external
+	 * interrupts when irq is one of the local interrupts
+	 * defined by RISC-V privilege specification.
+	 */
+	if (irq < IRQ_LOCAL_MAX &&
+	    irq != IRQ_VS_SOFT &&
 	    irq != IRQ_VS_TIMER &&
 	    irq != IRQ_VS_EXT)
 		return -EINVAL;
 
-	clear_bit(irq, &vcpu->arch.irqs_pending);
+	clear_bit(irq, vcpu->arch.irqs_pending);
 	smp_mb__before_atomic();
-	set_bit(irq, &vcpu->arch.irqs_pending_mask);
+	set_bit(irq, vcpu->arch.irqs_pending_mask);
 
 	return 0;
 }
 
-bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long mask)
+bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, u64 mask)
 {
 	unsigned long ie;
 
 	ie = ((vcpu->arch.guest_csr.vsie & VSIP_VALID_MASK)
-		<< VSIP_TO_HVIP_SHIFT) & mask;
-	if (READ_ONCE(vcpu->arch.irqs_pending) & ie)
+		<< VSIP_TO_HVIP_SHIFT) & (unsigned long)mask;
+	ie |= vcpu->arch.guest_csr.vsie & ~IRQ_LOCAL_MASK &
+		(unsigned long)mask;
+	if (READ_ONCE(vcpu->arch.irqs_pending[0]) & ie)
 		return true;
 
 	/* Check AIA high interrupts */
-- 
2.34.1

