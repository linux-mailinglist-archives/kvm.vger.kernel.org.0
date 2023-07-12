Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A923D750DA2
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjGLQLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbjGLQLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:11:09 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01A919B9
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:11:05 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-66872d4a141so4976719b3a.1
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689178265; x=1691770265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GHJImrVD2XL3oL1dawrSeKAYR0VlpwbjbzqVnunLK3c=;
        b=LiuifeXIIqehUO3TE79wfAJMWXNb2VJBw0qX7Jdd1mtwtCc96SMSIfuZKULmmowyIH
         FWlhcGvvGjMe1d8+TRZIlSN/Zr2Z1DvLBAo/CHOSgT7mTGPVJfqppu7wCLH4rYKpsJAj
         A2C5DGaZe0JtjlbqY/64D8rDjamSIoUKl/LTLcgbw0/cD329EAKqI6B7vYW4cXdnPqqv
         eZPaQhMtQiDp2tMH3/JA/DCElTc/b53JZgVQfdmWGgjtOb7y8MURXK5WN1P4s2Y3JXeu
         IfJ1eYbsxSXo4S8u7oYAZxDm7cg2DnxOYgXq5Na/7oWgaIwL7o2+5wSccC8WMkLyxwIX
         Hgew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689178265; x=1691770265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GHJImrVD2XL3oL1dawrSeKAYR0VlpwbjbzqVnunLK3c=;
        b=fXyKWSgctMyMaVw9Mekv+C2HYgvkfbeIpfX0YPkAVifb4D8BQM0PTSN/fYibRjMdbw
         wTax8/XN8bR9ucasntIpxPSIDZviUUjmRJ0cpZLlrY5Vvcsf4SI58OTpJgpRXUzCmUF4
         GMd0wsNjNFFMyjDJaxEF3lcdG4vGPUqHccKJEPppOakt0lFmt15IWM3cINq2KRCl9wVJ
         MJ5amWuC9QfL1yyqHA4VqJuMpD3kjKUYDFCzD04yoxhWEtASRrryomvvOT4wmMronOn7
         HgcYe27vZnl0eX2J88jZVeCZcNX1gW/JBgK4seVnIKHCz3Ea70amo54Or4V/3FAvFEMu
         Jiaw==
X-Gm-Message-State: ABy/qLY0KR6LCny2J/QFxZl7Aorkjz28bSjM/rGwFLlaqsT72iHohsV+
        e1s7ulGCJXaqiUI36Vzr5VsnsA==
X-Google-Smtp-Source: APBJJlF91RFf6NF4r9up1g/jdv5HJC7oolva6ayjYQ07KdNffbIhoOQNyIdc9mbcXweN9OQjczerUw==
X-Received: by 2002:a17:902:d38c:b0:1b5:5aa0:cfd9 with SMTP id e12-20020a170902d38c00b001b55aa0cfd9mr15427875pld.48.1689178265170;
        Wed, 12 Jul 2023 09:11:05 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.82.173])
        by smtp.gmail.com with ESMTPSA id bc2-20020a170902930200b001b9f032bb3dsm3811650plb.3.2023.07.12.09.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:11:04 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Samuel Ortiz <sameo@rivosinc.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 1/7] RISC-V: KVM: Factor-out ONE_REG related code to its own source file
Date:   Wed, 12 Jul 2023 21:40:41 +0530
Message-Id: <20230712161047.1764756-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712161047.1764756-1-apatel@ventanamicro.com>
References: <20230712161047.1764756-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VCPU ONE_REG interface has grown over time and it will continue
to grow with new ISA extensions and other features. Let us move all
ONE_REG related code to its own source file so that vcpu.c only
focuses only on high-level VCPU functions.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h |   6 +
 arch/riscv/kvm/Makefile           |   1 +
 arch/riscv/kvm/vcpu.c             | 529 +----------------------------
 arch/riscv/kvm/vcpu_onereg.c      | 547 ++++++++++++++++++++++++++++++
 4 files changed, 555 insertions(+), 528 deletions(-)
 create mode 100644 arch/riscv/kvm/vcpu_onereg.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 2d8ee53b66c7..55bc7bdbff48 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -337,6 +337,12 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 
 void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch);
 
+void kvm_riscv_vcpu_setup_isa(struct kvm_vcpu *vcpu);
+int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
+			   const struct kvm_one_reg *reg);
+int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
+			   const struct kvm_one_reg *reg);
+
 int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
 int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
 void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu);
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index fee0671e2dc1..4c2067fc59fc 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -19,6 +19,7 @@ kvm-y += vcpu_exit.o
 kvm-y += vcpu_fp.o
 kvm-y += vcpu_vector.o
 kvm-y += vcpu_insn.o
+kvm-y += vcpu_onereg.o
 kvm-y += vcpu_switch.o
 kvm-y += vcpu_sbi.o
 kvm-$(CONFIG_RISCV_SBI_V01) += vcpu_sbi_v01.o
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index d12ef99901fc..452d6548e951 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -13,16 +13,12 @@
 #include <linux/kdebug.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
-#include <linux/uaccess.h>
 #include <linux/vmalloc.h>
 #include <linux/sched/signal.h>
 #include <linux/fs.h>
 #include <linux/kvm_host.h>
 #include <asm/csr.h>
 #include <asm/cacheflush.h>
-#include <asm/hwcap.h>
-#include <asm/sbi.h>
-#include <asm/vector.h>
 #include <asm/kvm_vcpu_vector.h>
 
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
@@ -46,79 +42,6 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 		       sizeof(kvm_vcpu_stats_desc),
 };
 
-#define KVM_RISCV_BASE_ISA_MASK		GENMASK(25, 0)
-
-#define KVM_ISA_EXT_ARR(ext)		[KVM_RISCV_ISA_EXT_##ext] = RISCV_ISA_EXT_##ext
-
-/* Mapping between KVM ISA Extension ID & Host ISA extension ID */
-static const unsigned long kvm_isa_ext_arr[] = {
-	[KVM_RISCV_ISA_EXT_A] = RISCV_ISA_EXT_a,
-	[KVM_RISCV_ISA_EXT_C] = RISCV_ISA_EXT_c,
-	[KVM_RISCV_ISA_EXT_D] = RISCV_ISA_EXT_d,
-	[KVM_RISCV_ISA_EXT_F] = RISCV_ISA_EXT_f,
-	[KVM_RISCV_ISA_EXT_H] = RISCV_ISA_EXT_h,
-	[KVM_RISCV_ISA_EXT_I] = RISCV_ISA_EXT_i,
-	[KVM_RISCV_ISA_EXT_M] = RISCV_ISA_EXT_m,
-	[KVM_RISCV_ISA_EXT_V] = RISCV_ISA_EXT_v,
-
-	KVM_ISA_EXT_ARR(SSAIA),
-	KVM_ISA_EXT_ARR(SSTC),
-	KVM_ISA_EXT_ARR(SVINVAL),
-	KVM_ISA_EXT_ARR(SVNAPOT),
-	KVM_ISA_EXT_ARR(SVPBMT),
-	KVM_ISA_EXT_ARR(ZBB),
-	KVM_ISA_EXT_ARR(ZIHINTPAUSE),
-	KVM_ISA_EXT_ARR(ZICBOM),
-	KVM_ISA_EXT_ARR(ZICBOZ),
-};
-
-static unsigned long kvm_riscv_vcpu_base2isa_ext(unsigned long base_ext)
-{
-	unsigned long i;
-
-	for (i = 0; i < KVM_RISCV_ISA_EXT_MAX; i++) {
-		if (kvm_isa_ext_arr[i] == base_ext)
-			return i;
-	}
-
-	return KVM_RISCV_ISA_EXT_MAX;
-}
-
-static bool kvm_riscv_vcpu_isa_enable_allowed(unsigned long ext)
-{
-	switch (ext) {
-	case KVM_RISCV_ISA_EXT_H:
-		return false;
-	case KVM_RISCV_ISA_EXT_V:
-		return riscv_v_vstate_ctrl_user_allowed();
-	default:
-		break;
-	}
-
-	return true;
-}
-
-static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
-{
-	switch (ext) {
-	case KVM_RISCV_ISA_EXT_A:
-	case KVM_RISCV_ISA_EXT_C:
-	case KVM_RISCV_ISA_EXT_I:
-	case KVM_RISCV_ISA_EXT_M:
-	case KVM_RISCV_ISA_EXT_SSAIA:
-	case KVM_RISCV_ISA_EXT_SSTC:
-	case KVM_RISCV_ISA_EXT_SVINVAL:
-	case KVM_RISCV_ISA_EXT_SVNAPOT:
-	case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
-	case KVM_RISCV_ISA_EXT_ZBB:
-		return false;
-	default:
-		break;
-	}
-
-	return true;
-}
-
 static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
@@ -176,7 +99,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	int rc;
 	struct kvm_cpu_context *cntx;
 	struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
-	unsigned long host_isa, i;
 
 	/* Mark this VCPU never ran */
 	vcpu->arch.ran_atleast_once = false;
@@ -184,12 +106,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	bitmap_zero(vcpu->arch.isa, RISCV_ISA_EXT_MAX);
 
 	/* Setup ISA features available to VCPU */
-	for (i = 0; i < ARRAY_SIZE(kvm_isa_ext_arr); i++) {
-		host_isa = kvm_isa_ext_arr[i];
-		if (__riscv_isa_extension_available(NULL, host_isa) &&
-		    kvm_riscv_vcpu_isa_enable_allowed(i))
-			set_bit(host_isa, vcpu->arch.isa);
-	}
+	kvm_riscv_vcpu_setup_isa(vcpu);
 
 	/* Setup vendor, arch, and implementation details */
 	vcpu->arch.mvendorid = sbi_get_mvendorid();
@@ -294,450 +211,6 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 	return VM_FAULT_SIGBUS;
 }
 
-static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
-					 const struct kvm_one_reg *reg)
-{
-	unsigned long __user *uaddr =
-			(unsigned long __user *)(unsigned long)reg->addr;
-	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
-					    KVM_REG_SIZE_MASK |
-					    KVM_REG_RISCV_CONFIG);
-	unsigned long reg_val;
-
-	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
-		return -EINVAL;
-
-	switch (reg_num) {
-	case KVM_REG_RISCV_CONFIG_REG(isa):
-		reg_val = vcpu->arch.isa[0] & KVM_RISCV_BASE_ISA_MASK;
-		break;
-	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
-		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOM))
-			return -EINVAL;
-		reg_val = riscv_cbom_block_size;
-		break;
-	case KVM_REG_RISCV_CONFIG_REG(zicboz_block_size):
-		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOZ))
-			return -EINVAL;
-		reg_val = riscv_cboz_block_size;
-		break;
-	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
-		reg_val = vcpu->arch.mvendorid;
-		break;
-	case KVM_REG_RISCV_CONFIG_REG(marchid):
-		reg_val = vcpu->arch.marchid;
-		break;
-	case KVM_REG_RISCV_CONFIG_REG(mimpid):
-		reg_val = vcpu->arch.mimpid;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
-		return -EFAULT;
-
-	return 0;
-}
-
-static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
-					 const struct kvm_one_reg *reg)
-{
-	unsigned long __user *uaddr =
-			(unsigned long __user *)(unsigned long)reg->addr;
-	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
-					    KVM_REG_SIZE_MASK |
-					    KVM_REG_RISCV_CONFIG);
-	unsigned long i, isa_ext, reg_val;
-
-	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
-		return -EINVAL;
-
-	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
-		return -EFAULT;
-
-	switch (reg_num) {
-	case KVM_REG_RISCV_CONFIG_REG(isa):
-		/*
-		 * This ONE REG interface is only defined for
-		 * single letter extensions.
-		 */
-		if (fls(reg_val) >= RISCV_ISA_EXT_BASE)
-			return -EINVAL;
-
-		if (!vcpu->arch.ran_atleast_once) {
-			/* Ignore the enable/disable request for certain extensions */
-			for (i = 0; i < RISCV_ISA_EXT_BASE; i++) {
-				isa_ext = kvm_riscv_vcpu_base2isa_ext(i);
-				if (isa_ext >= KVM_RISCV_ISA_EXT_MAX) {
-					reg_val &= ~BIT(i);
-					continue;
-				}
-				if (!kvm_riscv_vcpu_isa_enable_allowed(isa_ext))
-					if (reg_val & BIT(i))
-						reg_val &= ~BIT(i);
-				if (!kvm_riscv_vcpu_isa_disable_allowed(isa_ext))
-					if (!(reg_val & BIT(i)))
-						reg_val |= BIT(i);
-			}
-			reg_val &= riscv_isa_extension_base(NULL);
-			/* Do not modify anything beyond single letter extensions */
-			reg_val = (vcpu->arch.isa[0] & ~KVM_RISCV_BASE_ISA_MASK) |
-				  (reg_val & KVM_RISCV_BASE_ISA_MASK);
-			vcpu->arch.isa[0] = reg_val;
-			kvm_riscv_vcpu_fp_reset(vcpu);
-		} else {
-			return -EOPNOTSUPP;
-		}
-		break;
-	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
-		return -EOPNOTSUPP;
-	case KVM_REG_RISCV_CONFIG_REG(zicboz_block_size):
-		return -EOPNOTSUPP;
-	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
-		if (!vcpu->arch.ran_atleast_once)
-			vcpu->arch.mvendorid = reg_val;
-		else
-			return -EBUSY;
-		break;
-	case KVM_REG_RISCV_CONFIG_REG(marchid):
-		if (!vcpu->arch.ran_atleast_once)
-			vcpu->arch.marchid = reg_val;
-		else
-			return -EBUSY;
-		break;
-	case KVM_REG_RISCV_CONFIG_REG(mimpid):
-		if (!vcpu->arch.ran_atleast_once)
-			vcpu->arch.mimpid = reg_val;
-		else
-			return -EBUSY;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int kvm_riscv_vcpu_get_reg_core(struct kvm_vcpu *vcpu,
-				       const struct kvm_one_reg *reg)
-{
-	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
-	unsigned long __user *uaddr =
-			(unsigned long __user *)(unsigned long)reg->addr;
-	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
-					    KVM_REG_SIZE_MASK |
-					    KVM_REG_RISCV_CORE);
-	unsigned long reg_val;
-
-	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
-		return -EINVAL;
-	if (reg_num >= sizeof(struct kvm_riscv_core) / sizeof(unsigned long))
-		return -EINVAL;
-
-	if (reg_num == KVM_REG_RISCV_CORE_REG(regs.pc))
-		reg_val = cntx->sepc;
-	else if (KVM_REG_RISCV_CORE_REG(regs.pc) < reg_num &&
-		 reg_num <= KVM_REG_RISCV_CORE_REG(regs.t6))
-		reg_val = ((unsigned long *)cntx)[reg_num];
-	else if (reg_num == KVM_REG_RISCV_CORE_REG(mode))
-		reg_val = (cntx->sstatus & SR_SPP) ?
-				KVM_RISCV_MODE_S : KVM_RISCV_MODE_U;
-	else
-		return -EINVAL;
-
-	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
-		return -EFAULT;
-
-	return 0;
-}
-
-static int kvm_riscv_vcpu_set_reg_core(struct kvm_vcpu *vcpu,
-				       const struct kvm_one_reg *reg)
-{
-	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
-	unsigned long __user *uaddr =
-			(unsigned long __user *)(unsigned long)reg->addr;
-	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
-					    KVM_REG_SIZE_MASK |
-					    KVM_REG_RISCV_CORE);
-	unsigned long reg_val;
-
-	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
-		return -EINVAL;
-	if (reg_num >= sizeof(struct kvm_riscv_core) / sizeof(unsigned long))
-		return -EINVAL;
-
-	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
-		return -EFAULT;
-
-	if (reg_num == KVM_REG_RISCV_CORE_REG(regs.pc))
-		cntx->sepc = reg_val;
-	else if (KVM_REG_RISCV_CORE_REG(regs.pc) < reg_num &&
-		 reg_num <= KVM_REG_RISCV_CORE_REG(regs.t6))
-		((unsigned long *)cntx)[reg_num] = reg_val;
-	else if (reg_num == KVM_REG_RISCV_CORE_REG(mode)) {
-		if (reg_val == KVM_RISCV_MODE_S)
-			cntx->sstatus |= SR_SPP;
-		else
-			cntx->sstatus &= ~SR_SPP;
-	} else
-		return -EINVAL;
-
-	return 0;
-}
-
-static int kvm_riscv_vcpu_general_get_csr(struct kvm_vcpu *vcpu,
-					  unsigned long reg_num,
-					  unsigned long *out_val)
-{
-	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
-
-	if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
-		return -EINVAL;
-
-	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
-		kvm_riscv_vcpu_flush_interrupts(vcpu);
-		*out_val = (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_VALID_MASK;
-		*out_val |= csr->hvip & ~IRQ_LOCAL_MASK;
-	} else
-		*out_val = ((unsigned long *)csr)[reg_num];
-
-	return 0;
-}
-
-static inline int kvm_riscv_vcpu_general_set_csr(struct kvm_vcpu *vcpu,
-						 unsigned long reg_num,
-						 unsigned long reg_val)
-{
-	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
-
-	if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
-		return -EINVAL;
-
-	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
-		reg_val &= VSIP_VALID_MASK;
-		reg_val <<= VSIP_TO_HVIP_SHIFT;
-	}
-
-	((unsigned long *)csr)[reg_num] = reg_val;
-
-	if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
-		WRITE_ONCE(vcpu->arch.irqs_pending_mask[0], 0);
-
-	return 0;
-}
-
-static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vcpu *vcpu,
-				      const struct kvm_one_reg *reg)
-{
-	int rc;
-	unsigned long __user *uaddr =
-			(unsigned long __user *)(unsigned long)reg->addr;
-	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
-					    KVM_REG_SIZE_MASK |
-					    KVM_REG_RISCV_CSR);
-	unsigned long reg_val, reg_subtype;
-
-	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
-		return -EINVAL;
-
-	reg_subtype = reg_num & KVM_REG_RISCV_SUBTYPE_MASK;
-	reg_num &= ~KVM_REG_RISCV_SUBTYPE_MASK;
-	switch (reg_subtype) {
-	case KVM_REG_RISCV_CSR_GENERAL:
-		rc = kvm_riscv_vcpu_general_get_csr(vcpu, reg_num, &reg_val);
-		break;
-	case KVM_REG_RISCV_CSR_AIA:
-		rc = kvm_riscv_vcpu_aia_get_csr(vcpu, reg_num, &reg_val);
-		break;
-	default:
-		rc = -EINVAL;
-		break;
-	}
-	if (rc)
-		return rc;
-
-	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
-		return -EFAULT;
-
-	return 0;
-}
-
-static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
-				      const struct kvm_one_reg *reg)
-{
-	int rc;
-	unsigned long __user *uaddr =
-			(unsigned long __user *)(unsigned long)reg->addr;
-	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
-					    KVM_REG_SIZE_MASK |
-					    KVM_REG_RISCV_CSR);
-	unsigned long reg_val, reg_subtype;
-
-	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
-		return -EINVAL;
-
-	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
-		return -EFAULT;
-
-	reg_subtype = reg_num & KVM_REG_RISCV_SUBTYPE_MASK;
-	reg_num &= ~KVM_REG_RISCV_SUBTYPE_MASK;
-	switch (reg_subtype) {
-	case KVM_REG_RISCV_CSR_GENERAL:
-		rc = kvm_riscv_vcpu_general_set_csr(vcpu, reg_num, reg_val);
-		break;
-	case KVM_REG_RISCV_CSR_AIA:
-		rc = kvm_riscv_vcpu_aia_set_csr(vcpu, reg_num, reg_val);
-		break;
-	default:
-		rc = -EINVAL;
-		break;
-	}
-	if (rc)
-		return rc;
-
-	return 0;
-}
-
-static int kvm_riscv_vcpu_get_reg_isa_ext(struct kvm_vcpu *vcpu,
-					  const struct kvm_one_reg *reg)
-{
-	unsigned long __user *uaddr =
-			(unsigned long __user *)(unsigned long)reg->addr;
-	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
-					    KVM_REG_SIZE_MASK |
-					    KVM_REG_RISCV_ISA_EXT);
-	unsigned long reg_val = 0;
-	unsigned long host_isa_ext;
-
-	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
-		return -EINVAL;
-
-	if (reg_num >= KVM_RISCV_ISA_EXT_MAX ||
-	    reg_num >= ARRAY_SIZE(kvm_isa_ext_arr))
-		return -EINVAL;
-
-	host_isa_ext = kvm_isa_ext_arr[reg_num];
-	if (__riscv_isa_extension_available(vcpu->arch.isa, host_isa_ext))
-		reg_val = 1; /* Mark the given extension as available */
-
-	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
-		return -EFAULT;
-
-	return 0;
-}
-
-static int kvm_riscv_vcpu_set_reg_isa_ext(struct kvm_vcpu *vcpu,
-					  const struct kvm_one_reg *reg)
-{
-	unsigned long __user *uaddr =
-			(unsigned long __user *)(unsigned long)reg->addr;
-	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
-					    KVM_REG_SIZE_MASK |
-					    KVM_REG_RISCV_ISA_EXT);
-	unsigned long reg_val;
-	unsigned long host_isa_ext;
-
-	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
-		return -EINVAL;
-
-	if (reg_num >= KVM_RISCV_ISA_EXT_MAX ||
-	    reg_num >= ARRAY_SIZE(kvm_isa_ext_arr))
-		return -EINVAL;
-
-	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
-		return -EFAULT;
-
-	host_isa_ext = kvm_isa_ext_arr[reg_num];
-	if (!__riscv_isa_extension_available(NULL, host_isa_ext))
-		return	-EOPNOTSUPP;
-
-	if (!vcpu->arch.ran_atleast_once) {
-		/*
-		 * All multi-letter extension and a few single letter
-		 * extension can be disabled
-		 */
-		if (reg_val == 1 &&
-		    kvm_riscv_vcpu_isa_enable_allowed(reg_num))
-			set_bit(host_isa_ext, vcpu->arch.isa);
-		else if (!reg_val &&
-			 kvm_riscv_vcpu_isa_disable_allowed(reg_num))
-			clear_bit(host_isa_ext, vcpu->arch.isa);
-		else
-			return -EINVAL;
-		kvm_riscv_vcpu_fp_reset(vcpu);
-	} else {
-		return -EOPNOTSUPP;
-	}
-
-	return 0;
-}
-
-static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
-				  const struct kvm_one_reg *reg)
-{
-	switch (reg->id & KVM_REG_RISCV_TYPE_MASK) {
-	case KVM_REG_RISCV_CONFIG:
-		return kvm_riscv_vcpu_set_reg_config(vcpu, reg);
-	case KVM_REG_RISCV_CORE:
-		return kvm_riscv_vcpu_set_reg_core(vcpu, reg);
-	case KVM_REG_RISCV_CSR:
-		return kvm_riscv_vcpu_set_reg_csr(vcpu, reg);
-	case KVM_REG_RISCV_TIMER:
-		return kvm_riscv_vcpu_set_reg_timer(vcpu, reg);
-	case KVM_REG_RISCV_FP_F:
-		return kvm_riscv_vcpu_set_reg_fp(vcpu, reg,
-						 KVM_REG_RISCV_FP_F);
-	case KVM_REG_RISCV_FP_D:
-		return kvm_riscv_vcpu_set_reg_fp(vcpu, reg,
-						 KVM_REG_RISCV_FP_D);
-	case KVM_REG_RISCV_ISA_EXT:
-		return kvm_riscv_vcpu_set_reg_isa_ext(vcpu, reg);
-	case KVM_REG_RISCV_SBI_EXT:
-		return kvm_riscv_vcpu_set_reg_sbi_ext(vcpu, reg);
-	case KVM_REG_RISCV_VECTOR:
-		return kvm_riscv_vcpu_set_reg_vector(vcpu, reg,
-						 KVM_REG_RISCV_VECTOR);
-	default:
-		break;
-	}
-
-	return -EINVAL;
-}
-
-static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
-				  const struct kvm_one_reg *reg)
-{
-	switch (reg->id & KVM_REG_RISCV_TYPE_MASK) {
-	case KVM_REG_RISCV_CONFIG:
-		return kvm_riscv_vcpu_get_reg_config(vcpu, reg);
-	case KVM_REG_RISCV_CORE:
-		return kvm_riscv_vcpu_get_reg_core(vcpu, reg);
-	case KVM_REG_RISCV_CSR:
-		return kvm_riscv_vcpu_get_reg_csr(vcpu, reg);
-	case KVM_REG_RISCV_TIMER:
-		return kvm_riscv_vcpu_get_reg_timer(vcpu, reg);
-	case KVM_REG_RISCV_FP_F:
-		return kvm_riscv_vcpu_get_reg_fp(vcpu, reg,
-						 KVM_REG_RISCV_FP_F);
-	case KVM_REG_RISCV_FP_D:
-		return kvm_riscv_vcpu_get_reg_fp(vcpu, reg,
-						 KVM_REG_RISCV_FP_D);
-	case KVM_REG_RISCV_ISA_EXT:
-		return kvm_riscv_vcpu_get_reg_isa_ext(vcpu, reg);
-	case KVM_REG_RISCV_SBI_EXT:
-		return kvm_riscv_vcpu_get_reg_sbi_ext(vcpu, reg);
-	case KVM_REG_RISCV_VECTOR:
-		return kvm_riscv_vcpu_get_reg_vector(vcpu, reg,
-						 KVM_REG_RISCV_VECTOR);
-	default:
-		break;
-	}
-
-	return -EINVAL;
-}
-
 long kvm_arch_vcpu_async_ioctl(struct file *filp,
 			       unsigned int ioctl, unsigned long arg)
 {
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
new file mode 100644
index 000000000000..836ffe79311a
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -0,0 +1,547 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ * Copyright (C) 2023 Ventana Micro Systems Inc.
+ *
+ * Authors:
+ *	Anup Patel <apatel@ventanamicro.com>
+ */
+
+#include <linux/bitops.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/uaccess.h>
+#include <linux/kvm_host.h>
+#include <asm/cacheflush.h>
+#include <asm/hwcap.h>
+#include <asm/kvm_vcpu_vector.h>
+
+#define KVM_RISCV_BASE_ISA_MASK		GENMASK(25, 0)
+
+#define KVM_ISA_EXT_ARR(ext)		\
+[KVM_RISCV_ISA_EXT_##ext] = RISCV_ISA_EXT_##ext
+
+/* Mapping between KVM ISA Extension ID & Host ISA extension ID */
+static const unsigned long kvm_isa_ext_arr[] = {
+	[KVM_RISCV_ISA_EXT_A] = RISCV_ISA_EXT_a,
+	[KVM_RISCV_ISA_EXT_C] = RISCV_ISA_EXT_c,
+	[KVM_RISCV_ISA_EXT_D] = RISCV_ISA_EXT_d,
+	[KVM_RISCV_ISA_EXT_F] = RISCV_ISA_EXT_f,
+	[KVM_RISCV_ISA_EXT_H] = RISCV_ISA_EXT_h,
+	[KVM_RISCV_ISA_EXT_I] = RISCV_ISA_EXT_i,
+	[KVM_RISCV_ISA_EXT_M] = RISCV_ISA_EXT_m,
+	[KVM_RISCV_ISA_EXT_V] = RISCV_ISA_EXT_v,
+
+	KVM_ISA_EXT_ARR(SSAIA),
+	KVM_ISA_EXT_ARR(SSTC),
+	KVM_ISA_EXT_ARR(SVINVAL),
+	KVM_ISA_EXT_ARR(SVNAPOT),
+	KVM_ISA_EXT_ARR(SVPBMT),
+	KVM_ISA_EXT_ARR(ZBB),
+	KVM_ISA_EXT_ARR(ZIHINTPAUSE),
+	KVM_ISA_EXT_ARR(ZICBOM),
+	KVM_ISA_EXT_ARR(ZICBOZ),
+};
+
+static unsigned long kvm_riscv_vcpu_base2isa_ext(unsigned long base_ext)
+{
+	unsigned long i;
+
+	for (i = 0; i < KVM_RISCV_ISA_EXT_MAX; i++) {
+		if (kvm_isa_ext_arr[i] == base_ext)
+			return i;
+	}
+
+	return KVM_RISCV_ISA_EXT_MAX;
+}
+
+static bool kvm_riscv_vcpu_isa_enable_allowed(unsigned long ext)
+{
+	switch (ext) {
+	case KVM_RISCV_ISA_EXT_H:
+		return false;
+	case KVM_RISCV_ISA_EXT_V:
+		return riscv_v_vstate_ctrl_user_allowed();
+	default:
+		break;
+	}
+
+	return true;
+}
+
+static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
+{
+	switch (ext) {
+	case KVM_RISCV_ISA_EXT_A:
+	case KVM_RISCV_ISA_EXT_C:
+	case KVM_RISCV_ISA_EXT_I:
+	case KVM_RISCV_ISA_EXT_M:
+	case KVM_RISCV_ISA_EXT_SSAIA:
+	case KVM_RISCV_ISA_EXT_SSTC:
+	case KVM_RISCV_ISA_EXT_SVINVAL:
+	case KVM_RISCV_ISA_EXT_SVNAPOT:
+	case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
+	case KVM_RISCV_ISA_EXT_ZBB:
+		return false;
+	default:
+		break;
+	}
+
+	return true;
+}
+
+void kvm_riscv_vcpu_setup_isa(struct kvm_vcpu *vcpu)
+{
+	unsigned long host_isa, i;
+
+	for (i = 0; i < ARRAY_SIZE(kvm_isa_ext_arr); i++) {
+		host_isa = kvm_isa_ext_arr[i];
+		if (__riscv_isa_extension_available(NULL, host_isa) &&
+		    kvm_riscv_vcpu_isa_enable_allowed(i))
+			set_bit(host_isa, vcpu->arch.isa);
+	}
+}
+
+static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
+					 const struct kvm_one_reg *reg)
+{
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CONFIG);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+
+	switch (reg_num) {
+	case KVM_REG_RISCV_CONFIG_REG(isa):
+		reg_val = vcpu->arch.isa[0] & KVM_RISCV_BASE_ISA_MASK;
+		break;
+	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
+		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOM))
+			return -EINVAL;
+		reg_val = riscv_cbom_block_size;
+		break;
+	case KVM_REG_RISCV_CONFIG_REG(zicboz_block_size):
+		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOZ))
+			return -EINVAL;
+		reg_val = riscv_cboz_block_size;
+		break;
+	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
+		reg_val = vcpu->arch.mvendorid;
+		break;
+	case KVM_REG_RISCV_CONFIG_REG(marchid):
+		reg_val = vcpu->arch.marchid;
+		break;
+	case KVM_REG_RISCV_CONFIG_REG(mimpid):
+		reg_val = vcpu->arch.mimpid;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
+					 const struct kvm_one_reg *reg)
+{
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CONFIG);
+	unsigned long i, isa_ext, reg_val;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	switch (reg_num) {
+	case KVM_REG_RISCV_CONFIG_REG(isa):
+		/*
+		 * This ONE REG interface is only defined for
+		 * single letter extensions.
+		 */
+		if (fls(reg_val) >= RISCV_ISA_EXT_BASE)
+			return -EINVAL;
+
+		if (!vcpu->arch.ran_atleast_once) {
+			/* Ignore the enable/disable request for certain extensions */
+			for (i = 0; i < RISCV_ISA_EXT_BASE; i++) {
+				isa_ext = kvm_riscv_vcpu_base2isa_ext(i);
+				if (isa_ext >= KVM_RISCV_ISA_EXT_MAX) {
+					reg_val &= ~BIT(i);
+					continue;
+				}
+				if (!kvm_riscv_vcpu_isa_enable_allowed(isa_ext))
+					if (reg_val & BIT(i))
+						reg_val &= ~BIT(i);
+				if (!kvm_riscv_vcpu_isa_disable_allowed(isa_ext))
+					if (!(reg_val & BIT(i)))
+						reg_val |= BIT(i);
+			}
+			reg_val &= riscv_isa_extension_base(NULL);
+			/* Do not modify anything beyond single letter extensions */
+			reg_val = (vcpu->arch.isa[0] & ~KVM_RISCV_BASE_ISA_MASK) |
+				  (reg_val & KVM_RISCV_BASE_ISA_MASK);
+			vcpu->arch.isa[0] = reg_val;
+			kvm_riscv_vcpu_fp_reset(vcpu);
+		} else {
+			return -EOPNOTSUPP;
+		}
+		break;
+	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
+		return -EOPNOTSUPP;
+	case KVM_REG_RISCV_CONFIG_REG(zicboz_block_size):
+		return -EOPNOTSUPP;
+	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
+		if (!vcpu->arch.ran_atleast_once)
+			vcpu->arch.mvendorid = reg_val;
+		else
+			return -EBUSY;
+		break;
+	case KVM_REG_RISCV_CONFIG_REG(marchid):
+		if (!vcpu->arch.ran_atleast_once)
+			vcpu->arch.marchid = reg_val;
+		else
+			return -EBUSY;
+		break;
+	case KVM_REG_RISCV_CONFIG_REG(mimpid):
+		if (!vcpu->arch.ran_atleast_once)
+			vcpu->arch.mimpid = reg_val;
+		else
+			return -EBUSY;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_get_reg_core(struct kvm_vcpu *vcpu,
+				       const struct kvm_one_reg *reg)
+{
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CORE);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+	if (reg_num >= sizeof(struct kvm_riscv_core) / sizeof(unsigned long))
+		return -EINVAL;
+
+	if (reg_num == KVM_REG_RISCV_CORE_REG(regs.pc))
+		reg_val = cntx->sepc;
+	else if (KVM_REG_RISCV_CORE_REG(regs.pc) < reg_num &&
+		 reg_num <= KVM_REG_RISCV_CORE_REG(regs.t6))
+		reg_val = ((unsigned long *)cntx)[reg_num];
+	else if (reg_num == KVM_REG_RISCV_CORE_REG(mode))
+		reg_val = (cntx->sstatus & SR_SPP) ?
+				KVM_RISCV_MODE_S : KVM_RISCV_MODE_U;
+	else
+		return -EINVAL;
+
+	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg_core(struct kvm_vcpu *vcpu,
+				       const struct kvm_one_reg *reg)
+{
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CORE);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+	if (reg_num >= sizeof(struct kvm_riscv_core) / sizeof(unsigned long))
+		return -EINVAL;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	if (reg_num == KVM_REG_RISCV_CORE_REG(regs.pc))
+		cntx->sepc = reg_val;
+	else if (KVM_REG_RISCV_CORE_REG(regs.pc) < reg_num &&
+		 reg_num <= KVM_REG_RISCV_CORE_REG(regs.t6))
+		((unsigned long *)cntx)[reg_num] = reg_val;
+	else if (reg_num == KVM_REG_RISCV_CORE_REG(mode)) {
+		if (reg_val == KVM_RISCV_MODE_S)
+			cntx->sstatus |= SR_SPP;
+		else
+			cntx->sstatus &= ~SR_SPP;
+	} else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_general_get_csr(struct kvm_vcpu *vcpu,
+					  unsigned long reg_num,
+					  unsigned long *out_val)
+{
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+
+	if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
+		return -EINVAL;
+
+	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
+		kvm_riscv_vcpu_flush_interrupts(vcpu);
+		*out_val = (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_VALID_MASK;
+		*out_val |= csr->hvip & ~IRQ_LOCAL_MASK;
+	} else
+		*out_val = ((unsigned long *)csr)[reg_num];
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_general_set_csr(struct kvm_vcpu *vcpu,
+					  unsigned long reg_num,
+					  unsigned long reg_val)
+{
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+
+	if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
+		return -EINVAL;
+
+	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
+		reg_val &= VSIP_VALID_MASK;
+		reg_val <<= VSIP_TO_HVIP_SHIFT;
+	}
+
+	((unsigned long *)csr)[reg_num] = reg_val;
+
+	if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
+		WRITE_ONCE(vcpu->arch.irqs_pending_mask[0], 0);
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vcpu *vcpu,
+				      const struct kvm_one_reg *reg)
+{
+	int rc;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CSR);
+	unsigned long reg_val, reg_subtype;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+
+	reg_subtype = reg_num & KVM_REG_RISCV_SUBTYPE_MASK;
+	reg_num &= ~KVM_REG_RISCV_SUBTYPE_MASK;
+	switch (reg_subtype) {
+	case KVM_REG_RISCV_CSR_GENERAL:
+		rc = kvm_riscv_vcpu_general_get_csr(vcpu, reg_num, &reg_val);
+		break;
+	case KVM_REG_RISCV_CSR_AIA:
+		rc = kvm_riscv_vcpu_aia_get_csr(vcpu, reg_num, &reg_val);
+		break;
+	default:
+		rc = -EINVAL;
+		break;
+	}
+	if (rc)
+		return rc;
+
+	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
+				      const struct kvm_one_reg *reg)
+{
+	int rc;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CSR);
+	unsigned long reg_val, reg_subtype;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	reg_subtype = reg_num & KVM_REG_RISCV_SUBTYPE_MASK;
+	reg_num &= ~KVM_REG_RISCV_SUBTYPE_MASK;
+	switch (reg_subtype) {
+	case KVM_REG_RISCV_CSR_GENERAL:
+		rc = kvm_riscv_vcpu_general_set_csr(vcpu, reg_num, reg_val);
+		break;
+	case KVM_REG_RISCV_CSR_AIA:
+		rc = kvm_riscv_vcpu_aia_set_csr(vcpu, reg_num, reg_val);
+		break;
+	default:
+		rc = -EINVAL;
+		break;
+	}
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_get_reg_isa_ext(struct kvm_vcpu *vcpu,
+					  const struct kvm_one_reg *reg)
+{
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_ISA_EXT);
+	unsigned long reg_val = 0;
+	unsigned long host_isa_ext;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+
+	if (reg_num >= KVM_RISCV_ISA_EXT_MAX ||
+	    reg_num >= ARRAY_SIZE(kvm_isa_ext_arr))
+		return -EINVAL;
+
+	host_isa_ext = kvm_isa_ext_arr[reg_num];
+	if (__riscv_isa_extension_available(vcpu->arch.isa, host_isa_ext))
+		reg_val = 1; /* Mark the given extension as available */
+
+	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg_isa_ext(struct kvm_vcpu *vcpu,
+					  const struct kvm_one_reg *reg)
+{
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_ISA_EXT);
+	unsigned long reg_val;
+	unsigned long host_isa_ext;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+
+	if (reg_num >= KVM_RISCV_ISA_EXT_MAX ||
+	    reg_num >= ARRAY_SIZE(kvm_isa_ext_arr))
+		return -EINVAL;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	host_isa_ext = kvm_isa_ext_arr[reg_num];
+	if (!__riscv_isa_extension_available(NULL, host_isa_ext))
+		return	-EOPNOTSUPP;
+
+	if (!vcpu->arch.ran_atleast_once) {
+		/*
+		 * All multi-letter extension and a few single letter
+		 * extension can be disabled
+		 */
+		if (reg_val == 1 &&
+		    kvm_riscv_vcpu_isa_enable_allowed(reg_num))
+			set_bit(host_isa_ext, vcpu->arch.isa);
+		else if (!reg_val &&
+			 kvm_riscv_vcpu_isa_disable_allowed(reg_num))
+			clear_bit(host_isa_ext, vcpu->arch.isa);
+		else
+			return -EINVAL;
+		kvm_riscv_vcpu_fp_reset(vcpu);
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
+			   const struct kvm_one_reg *reg)
+{
+	switch (reg->id & KVM_REG_RISCV_TYPE_MASK) {
+	case KVM_REG_RISCV_CONFIG:
+		return kvm_riscv_vcpu_set_reg_config(vcpu, reg);
+	case KVM_REG_RISCV_CORE:
+		return kvm_riscv_vcpu_set_reg_core(vcpu, reg);
+	case KVM_REG_RISCV_CSR:
+		return kvm_riscv_vcpu_set_reg_csr(vcpu, reg);
+	case KVM_REG_RISCV_TIMER:
+		return kvm_riscv_vcpu_set_reg_timer(vcpu, reg);
+	case KVM_REG_RISCV_FP_F:
+		return kvm_riscv_vcpu_set_reg_fp(vcpu, reg,
+						 KVM_REG_RISCV_FP_F);
+	case KVM_REG_RISCV_FP_D:
+		return kvm_riscv_vcpu_set_reg_fp(vcpu, reg,
+						 KVM_REG_RISCV_FP_D);
+	case KVM_REG_RISCV_ISA_EXT:
+		return kvm_riscv_vcpu_set_reg_isa_ext(vcpu, reg);
+	case KVM_REG_RISCV_SBI_EXT:
+		return kvm_riscv_vcpu_set_reg_sbi_ext(vcpu, reg);
+	case KVM_REG_RISCV_VECTOR:
+		return kvm_riscv_vcpu_set_reg_vector(vcpu, reg,
+						 KVM_REG_RISCV_VECTOR);
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
+int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
+			   const struct kvm_one_reg *reg)
+{
+	switch (reg->id & KVM_REG_RISCV_TYPE_MASK) {
+	case KVM_REG_RISCV_CONFIG:
+		return kvm_riscv_vcpu_get_reg_config(vcpu, reg);
+	case KVM_REG_RISCV_CORE:
+		return kvm_riscv_vcpu_get_reg_core(vcpu, reg);
+	case KVM_REG_RISCV_CSR:
+		return kvm_riscv_vcpu_get_reg_csr(vcpu, reg);
+	case KVM_REG_RISCV_TIMER:
+		return kvm_riscv_vcpu_get_reg_timer(vcpu, reg);
+	case KVM_REG_RISCV_FP_F:
+		return kvm_riscv_vcpu_get_reg_fp(vcpu, reg,
+						 KVM_REG_RISCV_FP_F);
+	case KVM_REG_RISCV_FP_D:
+		return kvm_riscv_vcpu_get_reg_fp(vcpu, reg,
+						 KVM_REG_RISCV_FP_D);
+	case KVM_REG_RISCV_ISA_EXT:
+		return kvm_riscv_vcpu_get_reg_isa_ext(vcpu, reg);
+	case KVM_REG_RISCV_SBI_EXT:
+		return kvm_riscv_vcpu_get_reg_sbi_ext(vcpu, reg);
+	case KVM_REG_RISCV_VECTOR:
+		return kvm_riscv_vcpu_get_reg_vector(vcpu, reg,
+						 KVM_REG_RISCV_VECTOR);
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
-- 
2.34.1

