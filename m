Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65ACC6A203D
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 18:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjBXRDl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 12:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjBXRDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 12:03:39 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18B18A5C
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:03:26 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id h14so111422plf.10
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=X3MkKxTtH8sEXZX8feLpoFOu0c9GU2RA9cYjHPd/7hw=;
        b=Bg43datoA2cgA998jVLblZtOW5cERhvM38D7my2aghj36G/lcN5ShYQXQOIu7BzXTB
         M/sb5+2ydiLQ7t4VgUSbBKgS9KZ2d2PHWWVcYNrwbkwOiNLTzF42B32hBEBC8GeQEV4t
         5rxXghogr+utnvxo+fU9aqPnDCR8lWFB1iXN7mNpAgnbS9u3fdG2nOZkGW3f2+N01BmI
         /PZcI3mfaZmm2fE44NdHB6CExeR4S/txlh1O6engbExA5k6cn49oxMJSdJAu1B2AdS1k
         mn/8fIyhE9KTta6L2xT6sq/1mUWqXe6CnJd9oEQaKYMhB3JN9OE4Q5B128P0ugqZ8/8e
         34Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X3MkKxTtH8sEXZX8feLpoFOu0c9GU2RA9cYjHPd/7hw=;
        b=BCOX0TTkqRjWN7Vv1UDzGf0BVeXW20i453c7tLmP0cTCTPKcZn3nWOun0QYsjtIW28
         iKIOT44aJaclmp15kJCYgkkfR5aO/BVxXNSTVWG65KWggE/1iVoS6yUQvqZvabre9Lik
         fwpwaYTgk1iiozeVf2dgjZI90mdJ/4tnn2uGrlQCH58cyZik2wgiD3Yqoiw+7V9vbqlm
         DvbVN2AHMFE4GQnQ7isocYzhGBKEX+5+sxuA3VZAhPYJ4mfNGnniVaCmG0PnpVaJbSMz
         /mVC2/27ItGFzxxYD7TlVMZ9/uOkuKp1kiknljCtCt5BlFQ967JBGLSEpQfZ3H+u4JAG
         hJgQ==
X-Gm-Message-State: AO0yUKVG+6yocEGE8wUWRXPbNn0P6oc2zbX+urAK72J+4gyWET0SVh5O
        DKQ3ihIdTzbRStZ2iBNy/hlJSg==
X-Google-Smtp-Source: AK7set+863/F2Dp7uatapWKFz0IcESh4AKj4CFEbBw4SrbN4EN21XCbHMFs5PFBOEM5xUaBZrrKzvQ==
X-Received: by 2002:a17:903:74b:b0:198:f36b:7dfa with SMTP id kl11-20020a170903074b00b00198f36b7dfamr12993620plb.12.1677258206100;
        Fri, 24 Feb 2023 09:03:26 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902b60c00b0019472226769sm9234731pls.251.2023.02.24.09.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 09:03:25 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v14 18/19] riscv: KVM: Add vector lazy save/restore support
Date:   Fri, 24 Feb 2023 17:01:17 +0000
Message-Id: <20230224170118.16766-19-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230224170118.16766-1-andy.chiu@sifive.com>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vincent Chen <vincent.chen@sifive.com>

This patch adds vector context save/restore for guest VCPUs. To reduce the
impact on KVM performance, the implementation imitates the FP context
switch mechanism to lazily store and restore the vector context only when
the kernel enters/exits the in-kernel run loop and not during the KVM
world switch.

Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 arch/riscv/include/asm/kvm_host.h        |   2 +
 arch/riscv/include/asm/kvm_vcpu_vector.h |  77 ++++++++++
 arch/riscv/include/uapi/asm/kvm.h        |   7 +
 arch/riscv/kvm/Makefile                  |   1 +
 arch/riscv/kvm/vcpu.c                    |  30 ++++
 arch/riscv/kvm/vcpu_vector.c             | 177 +++++++++++++++++++++++
 6 files changed, 294 insertions(+)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_vector.h
 create mode 100644 arch/riscv/kvm/vcpu_vector.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 93f43a3e7886..58d660995f22 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -14,6 +14,7 @@
 #include <linux/kvm_types.h>
 #include <linux/spinlock.h>
 #include <asm/hwcap.h>
+#include <asm/ptrace.h>
 #include <asm/kvm_vcpu_fp.h>
 #include <asm/kvm_vcpu_insn.h>
 #include <asm/kvm_vcpu_sbi.h>
@@ -140,6 +141,7 @@ struct kvm_cpu_context {
 	unsigned long sstatus;
 	unsigned long hstatus;
 	union __riscv_fp_state fp;
+	struct __riscv_v_ext_state vector;
 };
 
 struct kvm_vcpu_csr {
diff --git a/arch/riscv/include/asm/kvm_vcpu_vector.h b/arch/riscv/include/asm/kvm_vcpu_vector.h
new file mode 100644
index 000000000000..a6dae7e2859d
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_vcpu_vector.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2021 Western Digital Corporation or its affiliates.
+ * Copyright (C) 2022 SiFive
+ *
+ * Authors:
+ *     Atish Patra <atish.patra@wdc.com>
+ *     Anup Patel <anup.patel@wdc.com>
+ *     Vincent Chen <vincent.chen@sifive.com>
+ *     Greentime Hu <greentime.hu@sifive.com>
+ */
+
+#ifndef __KVM_VCPU_RISCV_VECTOR_H
+#define __KVM_VCPU_RISCV_VECTOR_H
+
+#include <linux/types.h>
+
+#ifdef CONFIG_RISCV_ISA_V
+#include <asm/vector.h>
+#include <asm/kvm_host.h>
+
+static __always_inline void __kvm_riscv_vector_save(struct kvm_cpu_context *context)
+{
+	__riscv_v_vstate_save(&context->vector, context->vector.datap);
+}
+
+static __always_inline void __kvm_riscv_vector_restore(struct kvm_cpu_context *context)
+{
+	__riscv_v_vstate_restore(&context->vector, context->vector.datap);
+}
+
+void kvm_riscv_vcpu_vector_reset(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_guest_vector_save(struct kvm_cpu_context *cntx,
+				      unsigned long *isa);
+void kvm_riscv_vcpu_guest_vector_restore(struct kvm_cpu_context *cntx,
+					 unsigned long *isa);
+void kvm_riscv_vcpu_host_vector_save(struct kvm_cpu_context *cntx);
+void kvm_riscv_vcpu_host_vector_restore(struct kvm_cpu_context *cntx);
+void kvm_riscv_vcpu_free_vector_context(struct kvm_vcpu *vcpu);
+#else
+
+struct kvm_cpu_context;
+
+static inline void kvm_riscv_vcpu_vector_reset(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline void kvm_riscv_vcpu_guest_vector_save(struct kvm_cpu_context *cntx,
+						    unsigned long *isa)
+{
+}
+
+static inline void kvm_riscv_vcpu_guest_vector_restore(struct kvm_cpu_context *cntx,
+						       unsigned long *isa)
+{
+}
+
+static inline void kvm_riscv_vcpu_host_vector_save(struct kvm_cpu_context *cntx)
+{
+}
+
+static inline void kvm_riscv_vcpu_host_vector_restore(struct kvm_cpu_context *cntx)
+{
+}
+
+static inline void kvm_riscv_vcpu_free_vector_context(struct kvm_vcpu *vcpu)
+{
+}
+#endif
+
+int kvm_riscv_vcpu_get_reg_vector(struct kvm_vcpu *vcpu,
+				  const struct kvm_one_reg *reg,
+				  unsigned long rtype);
+int kvm_riscv_vcpu_set_reg_vector(struct kvm_vcpu *vcpu,
+				  const struct kvm_one_reg *reg,
+				  unsigned long rtype);
+#endif
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 3e3de7d486e1..b6d7f96d57ab 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -153,6 +153,13 @@ enum KVM_RISCV_ISA_EXT_ID {
 /* ISA Extension registers are mapped as type 7 */
 #define KVM_REG_RISCV_ISA_EXT		(0x07 << KVM_REG_RISCV_TYPE_SHIFT)
 
+/* V extension registers are mapped as type 8 */
+#define KVM_REG_RISCV_VECTOR		(0x08 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_VECTOR_CSR_REG(name)	\
+		(offsetof(struct __riscv_v_ext_state, name) / sizeof(unsigned long))
+#define KVM_REG_RISCV_VECTOR_REG(n)	\
+		((n) + sizeof(struct __riscv_v_ext_state) / sizeof(unsigned long))
+
 #endif
 
 #endif /* __LINUX_KVM_RISCV_H */
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 019df9208bdd..b26bc605a267 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -17,6 +17,7 @@ kvm-y += mmu.o
 kvm-y += vcpu.o
 kvm-y += vcpu_exit.o
 kvm-y += vcpu_fp.o
+kvm-y += vcpu_vector.o
 kvm-y += vcpu_insn.o
 kvm-y += vcpu_switch.o
 kvm-y += vcpu_sbi.o
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index b060d26ab783..ab21ef25e314 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -22,6 +22,8 @@
 #include <asm/cacheflush.h>
 #include <asm/hwcap.h>
 #include <asm/sbi.h>
+#include <asm/vector.h>
+#include <asm/kvm_vcpu_vector.h>
 
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
@@ -134,6 +136,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	kvm_riscv_vcpu_fp_reset(vcpu);
 
+	kvm_riscv_vcpu_vector_reset(vcpu);
+
 	kvm_riscv_vcpu_timer_reset(vcpu);
 
 	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
@@ -189,6 +193,15 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	cntx->hstatus |= HSTATUS_SPVP;
 	cntx->hstatus |= HSTATUS_SPV;
 
+	if (has_vector()) {
+		cntx->vector.datap = kmalloc(riscv_v_vsize, GFP_KERNEL);
+		if (!cntx->vector.datap)
+			return -ENOMEM;
+		vcpu->arch.host_context.vector.datap = kzalloc(riscv_v_vsize, GFP_KERNEL);
+		if (!vcpu->arch.host_context.vector.datap)
+			return -ENOMEM;
+	}
+
 	/* By default, make CY, TM, and IR counters accessible in VU mode */
 	reset_csr->scounteren = 0x7;
 
@@ -219,6 +232,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 	/* Free unused pages pre-allocated for G-stage page table mappings */
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
+
+	/* Free vector context space for host and guest kernel */
+	kvm_riscv_vcpu_free_vector_context(vcpu);
 }
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
@@ -595,6 +611,9 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
 						 KVM_REG_RISCV_FP_D);
 	case KVM_REG_RISCV_ISA_EXT:
 		return kvm_riscv_vcpu_set_reg_isa_ext(vcpu, reg);
+	case KVM_REG_RISCV_VECTOR:
+		return kvm_riscv_vcpu_set_reg_vector(vcpu, reg,
+						 KVM_REG_RISCV_VECTOR);
 	default:
 		break;
 	}
@@ -622,6 +641,9 @@ static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
 						 KVM_REG_RISCV_FP_D);
 	case KVM_REG_RISCV_ISA_EXT:
 		return kvm_riscv_vcpu_get_reg_isa_ext(vcpu, reg);
+	case KVM_REG_RISCV_VECTOR:
+		return kvm_riscv_vcpu_get_reg_vector(vcpu, reg,
+						 KVM_REG_RISCV_VECTOR);
 	default:
 		break;
 	}
@@ -888,6 +910,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_riscv_vcpu_host_fp_save(&vcpu->arch.host_context);
 	kvm_riscv_vcpu_guest_fp_restore(&vcpu->arch.guest_context,
 					vcpu->arch.isa);
+	kvm_riscv_vcpu_host_vector_save(&vcpu->arch.host_context);
+	kvm_riscv_vcpu_guest_vector_restore(&vcpu->arch.guest_context,
+					    vcpu->arch.isa);
 
 	vcpu->cpu = cpu;
 }
@@ -903,6 +928,11 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_riscv_vcpu_host_fp_restore(&vcpu->arch.host_context);
 
 	kvm_riscv_vcpu_timer_save(vcpu);
+	kvm_riscv_vcpu_guest_vector_save(&vcpu->arch.guest_context,
+					 vcpu->arch.isa);
+	kvm_riscv_vcpu_host_vector_restore(&vcpu->arch.host_context);
+
+	csr_write(CSR_HGATP, 0);
 
 	csr->vsstatus = csr_read(CSR_VSSTATUS);
 	csr->vsie = csr_read(CSR_VSIE);
diff --git a/arch/riscv/kvm/vcpu_vector.c b/arch/riscv/kvm/vcpu_vector.c
new file mode 100644
index 000000000000..68f194771794
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_vector.c
@@ -0,0 +1,177 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Western Digital Corporation or its affiliates.
+ * Copyright (C) 2022 SiFive
+ *
+ * Authors:
+ *     Atish Patra <atish.patra@wdc.com>
+ *     Anup Patel <anup.patel@wdc.com>
+ *     Vincent Chen <vincent.chen@sifive.com>
+ *     Greentime Hu <greentime.hu@sifive.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <linux/uaccess.h>
+#include <asm/hwcap.h>
+#include <asm/kvm_vcpu_vector.h>
+
+#ifdef CONFIG_RISCV_ISA_V
+extern unsigned long riscv_v_vsize;
+void kvm_riscv_vcpu_vector_reset(struct kvm_vcpu *vcpu)
+{
+	unsigned long *isa = vcpu->arch.isa;
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+
+	cntx->sstatus &= ~SR_VS;
+	if (riscv_isa_extension_available(isa, v)) {
+		cntx->sstatus |= SR_VS_INITIAL;
+		WARN_ON(!cntx->vector.datap);
+		memset(cntx->vector.datap, 0, riscv_v_vsize);
+	} else {
+		cntx->sstatus |= SR_VS_OFF;
+	}
+}
+
+static void kvm_riscv_vcpu_vector_clean(struct kvm_cpu_context *cntx)
+{
+	cntx->sstatus &= ~SR_VS;
+	cntx->sstatus |= SR_VS_CLEAN;
+}
+
+void kvm_riscv_vcpu_guest_vector_save(struct kvm_cpu_context *cntx,
+				      unsigned long *isa)
+{
+	if ((cntx->sstatus & SR_VS) == SR_VS_DIRTY) {
+		if (riscv_isa_extension_available(isa, v))
+			__kvm_riscv_vector_save(cntx);
+		kvm_riscv_vcpu_vector_clean(cntx);
+	}
+}
+
+void kvm_riscv_vcpu_guest_vector_restore(struct kvm_cpu_context *cntx,
+					 unsigned long *isa)
+{
+	if ((cntx->sstatus & SR_VS) != SR_VS_OFF) {
+		if (riscv_isa_extension_available(isa, v))
+			__kvm_riscv_vector_restore(cntx);
+		kvm_riscv_vcpu_vector_clean(cntx);
+	}
+}
+
+void kvm_riscv_vcpu_host_vector_save(struct kvm_cpu_context *cntx)
+{
+	/* No need to check host sstatus as it can be modified outside */
+	if (riscv_isa_extension_available(NULL, v))
+		__kvm_riscv_vector_save(cntx);
+}
+
+void kvm_riscv_vcpu_host_vector_restore(struct kvm_cpu_context *cntx)
+{
+	if (riscv_isa_extension_available(NULL, v))
+		__kvm_riscv_vector_restore(cntx);
+}
+
+void kvm_riscv_vcpu_free_vector_context(struct kvm_vcpu *vcpu)
+{
+	kfree(vcpu->arch.guest_reset_context.vector.datap);
+	kfree(vcpu->arch.host_context.vector.datap);
+}
+#else
+#define riscv_v_vsize (0)
+#endif
+
+static void *kvm_riscv_vcpu_vreg_addr(struct kvm_vcpu *vcpu,
+				      unsigned long reg_num,
+				      size_t reg_size)
+{
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+	void *reg_val;
+	size_t vlenb = riscv_v_vsize / 32;
+
+	if (reg_num < KVM_REG_RISCV_VECTOR_REG(0)) {
+		if (reg_size != sizeof(unsigned long))
+			return NULL;
+		switch (reg_num) {
+		case KVM_REG_RISCV_VECTOR_CSR_REG(vstart):
+			reg_val = &cntx->vector.vstart;
+			break;
+		case KVM_REG_RISCV_VECTOR_CSR_REG(vl):
+			reg_val = &cntx->vector.vl;
+			break;
+		case KVM_REG_RISCV_VECTOR_CSR_REG(vtype):
+			reg_val = &cntx->vector.vtype;
+			break;
+		case KVM_REG_RISCV_VECTOR_CSR_REG(vcsr):
+			reg_val = &cntx->vector.vcsr;
+			break;
+		case KVM_REG_RISCV_VECTOR_CSR_REG(datap):
+		default:
+			return NULL;
+		}
+	} else if (reg_num <= KVM_REG_RISCV_VECTOR_REG(31)) {
+		if (reg_size != vlenb)
+			return NULL;
+		reg_val = cntx->vector.datap
+			  + (reg_num - KVM_REG_RISCV_VECTOR_REG(0)) * vlenb;
+	} else {
+		return NULL;
+	}
+
+	return reg_val;
+}
+
+int kvm_riscv_vcpu_get_reg_vector(struct kvm_vcpu *vcpu,
+				  const struct kvm_one_reg *reg,
+				  unsigned long rtype)
+{
+	unsigned long *isa = vcpu->arch.isa;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    rtype);
+	void *reg_val = NULL;
+	size_t reg_size = KVM_REG_SIZE(reg->id);
+
+	if (rtype == KVM_REG_RISCV_VECTOR &&
+	    riscv_isa_extension_available(isa, v)) {
+		reg_val = kvm_riscv_vcpu_vreg_addr(vcpu, reg_num, reg_size);
+	}
+
+	if (!reg_val)
+		return -EINVAL;
+
+	if (copy_to_user(uaddr, reg_val, reg_size))
+		return -EFAULT;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_set_reg_vector(struct kvm_vcpu *vcpu,
+				  const struct kvm_one_reg *reg,
+				  unsigned long rtype)
+{
+	unsigned long *isa = vcpu->arch.isa;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    rtype);
+	void *reg_val = NULL;
+	size_t reg_size = KVM_REG_SIZE(reg->id);
+
+	if (rtype == KVM_REG_RISCV_VECTOR &&
+	    riscv_isa_extension_available(isa, v)) {
+		reg_val = kvm_riscv_vcpu_vreg_addr(vcpu, reg_num, reg_size);
+	}
+
+	if (!reg_val)
+		return -EINVAL;
+
+	if (copy_from_user(reg_val, uaddr, reg_size))
+		return -EFAULT;
+
+	return 0;
+}
-- 
2.17.1

