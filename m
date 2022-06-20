Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765E3552860
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245221AbiFTXnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239318AbiFTXnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:43:05 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B0811C26
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 16:43:04 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id t21so5265584pfq.1
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 16:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UUV6tz2InON+G8AkEZW7LFdFnckw9xLV/oc9guSWUEw=;
        b=tus7WxsEc5f0ODcAaMAW/iErYdCFKtaokFn8szgdZemwcgVm7F7qhzxmCnZbk3jUmc
         0aKWZ42fo3QM9uITRQ9+J2Pb7fGyTQu3Vzbu/qDzLfEUtBWwr+yTZCaPxQLIWDBDcJgJ
         PbHEzADAqi2UacJgr8Ab3SjJS72RgobIUcNkajiPrJqAGzWLQw9qDTu3gQuiT/O+ix8Y
         G8mZHchHyEbUnM7sj8wpxI/xIpM2+xzNXPS1y0MxGzikkTmVA9v5iz+4B3WYaitAFvyw
         /j8s2/moZsTOjYMKUMjimbaNxHgfPKdy2x202qKbf3O8YniT/lEEUzoy/JNzohoRmB/h
         b5tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UUV6tz2InON+G8AkEZW7LFdFnckw9xLV/oc9guSWUEw=;
        b=FMfa5gM2BlXh6mHZXSzd8RZiay/kjRJezUg3RI98aes3Ei442C8uVtvass7fLdljxY
         s+1yUQT5gwMGkSQekjuxZsb6tT2sb4FR68y0uRUUu2oyLUmb8emujdSnynR8payxwU3V
         oruf4DsZEAEG/jioQXGtiXbP1ZjEMi8spMBdXVV9394POijHpl5X6ETFBKHfVjKr2uA6
         +2ZN2NPvoE1Na7CSrO+Z9U2vemo5pPBuhoAHpaI53nVeAvJThxHw9rOyCN1zZYNYCwyj
         aNKdrkSN+AwWZdA+Mbh4q/Ku380bBPp+OKTa1B3LtgFppPOKpes7RRhVe/GEBauOtuOx
         gLbw==
X-Gm-Message-State: AJIora8SM78x4ZocMPIK3YaGD4Rf1ESZ7tCoRdQ70gMWxd4D4ZcWJAw5
        dxynefXbTyY8FQb49aSRv4SZ4w==
X-Google-Smtp-Source: AGRyM1vz2B367E43oS1XzqC3w5I7unFMIvv8cJbxni/FCR+fOq6W8CxjHAUINnznlz9GFi6bvPp3ZA==
X-Received: by 2002:a63:3fcb:0:b0:40c:4da1:555a with SMTP id m194-20020a633fcb000000b0040c4da1555amr18364683pga.3.1655768583733;
        Mon, 20 Jun 2022 16:43:03 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id o12-20020a62f90c000000b0051b4e53c487sm9722348pfh.45.2022.06.20.16.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 16:43:03 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Subject: [PATCH] RISC-V: KVM: Improve ISA extension by using a bitmap
Date:   Mon, 20 Jun 2022 16:42:54 -0700
Message-Id: <20220620234254.2610040-1-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the every vcpu only stores the ISA extensions in a unsigned long
which is not scalable as number of extensions will continue to grow.
Using a bitmap allows the ISA extension to support any number of
extensions. The CONFIG one reg interface implementation is modified to
support the bitmap as well. But it is meant only for base extensions.
Thus, the first element of the bitmap array is sufficient for that
interface.

In the future, all the new multi-letter extensions must use the
ISA_EXT one reg interface that allows enabling/disabling any extension
now.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_host.h    |  3 +-
 arch/riscv/include/asm/kvm_vcpu_fp.h |  8 +--
 arch/riscv/kvm/vcpu.c                | 81 ++++++++++++++--------------
 arch/riscv/kvm/vcpu_fp.c             | 27 +++++-----
 4 files changed, 59 insertions(+), 60 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 319c8aeb42af..c749cdacbd63 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -14,6 +14,7 @@
 #include <linux/kvm_types.h>
 #include <linux/spinlock.h>
 #include <asm/csr.h>
+#include <asm/hwcap.h>
 #include <asm/kvm_vcpu_fp.h>
 #include <asm/kvm_vcpu_timer.h>
 
@@ -170,7 +171,7 @@ struct kvm_vcpu_arch {
 	int last_exit_cpu;
 
 	/* ISA feature bits (similar to MISA) */
-	unsigned long isa;
+	DECLARE_BITMAP(isa, RISCV_ISA_EXT_MAX);
 
 	/* SSCRATCH, STVEC, and SCOUNTEREN of Host */
 	unsigned long host_sscratch;
diff --git a/arch/riscv/include/asm/kvm_vcpu_fp.h b/arch/riscv/include/asm/kvm_vcpu_fp.h
index 4da9b8e0f050..e86bb67f2a8a 100644
--- a/arch/riscv/include/asm/kvm_vcpu_fp.h
+++ b/arch/riscv/include/asm/kvm_vcpu_fp.h
@@ -22,9 +22,9 @@ void __kvm_riscv_fp_d_restore(struct kvm_cpu_context *context);
 
 void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx,
-				  unsigned long isa);
+				  unsigned long *isa);
 void kvm_riscv_vcpu_guest_fp_restore(struct kvm_cpu_context *cntx,
-				     unsigned long isa);
+				     unsigned long *isa);
 void kvm_riscv_vcpu_host_fp_save(struct kvm_cpu_context *cntx);
 void kvm_riscv_vcpu_host_fp_restore(struct kvm_cpu_context *cntx);
 #else
@@ -32,12 +32,12 @@ static inline void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu)
 {
 }
 static inline void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx,
-						unsigned long isa)
+						unsigned long *isa)
 {
 }
 static inline void kvm_riscv_vcpu_guest_fp_restore(
 					struct kvm_cpu_context *cntx,
-					unsigned long isa)
+					unsigned long *isa)
 {
 }
 static inline void kvm_riscv_vcpu_host_fp_save(struct kvm_cpu_context *cntx)
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 7f4ad5e4373a..cb2a65b5d563 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -46,8 +46,19 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 						riscv_isa_extension_mask(i) | \
 						riscv_isa_extension_mask(m))
 
-#define KVM_RISCV_ISA_ALLOWED (KVM_RISCV_ISA_DISABLE_ALLOWED | \
-			       KVM_RISCV_ISA_DISABLE_NOT_ALLOWED)
+#define KVM_RISCV_ISA_MASK GENMASK(25, 0)
+
+/* Mapping between KVM ISA Extension ID & Host ISA extension ID */
+static unsigned long kvm_isa_ext_arr[] = {
+	RISCV_ISA_EXT_a,
+	RISCV_ISA_EXT_c,
+	RISCV_ISA_EXT_d,
+	RISCV_ISA_EXT_f,
+	RISCV_ISA_EXT_h,
+	RISCV_ISA_EXT_i,
+	RISCV_ISA_EXT_m,
+	RISCV_ISA_EXT_SSCOFPMF,
+};
 
 static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 {
@@ -99,13 +110,20 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *cntx;
 	struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
+	unsigned long host_isa, i;
 
 	/* Mark this VCPU never ran */
 	vcpu->arch.ran_atleast_once = false;
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
+	bitmap_zero(vcpu->arch.isa, RISCV_ISA_EXT_MAX);
 
 	/* Setup ISA features available to VCPU */
-	vcpu->arch.isa = riscv_isa_extension_base(NULL) & KVM_RISCV_ISA_ALLOWED;
+	for (i = 0; i < ARRAY_SIZE(kvm_isa_ext_arr); i++) {
+		host_isa = kvm_isa_ext_arr[i];
+		if (__riscv_isa_extension_available(NULL, host_isa) &&
+		   host_isa != RISCV_ISA_EXT_h)
+			set_bit(host_isa, vcpu->arch.isa);
+	}
 
 	/* Setup VCPU hfence queue */
 	spin_lock_init(&vcpu->arch.hfence_lock);
@@ -199,7 +217,7 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
 
 	switch (reg_num) {
 	case KVM_REG_RISCV_CONFIG_REG(isa):
-		reg_val = vcpu->arch.isa;
+		reg_val = vcpu->arch.isa[0] & KVM_RISCV_ISA_MASK;
 		break;
 	default:
 		return -EINVAL;
@@ -220,6 +238,7 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 					    KVM_REG_SIZE_MASK |
 					    KVM_REG_RISCV_CONFIG);
 	unsigned long reg_val;
+	unsigned long isa_mask;
 
 	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
 		return -EINVAL;
@@ -227,13 +246,19 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 
+	/* This ONE REG interface is only defined for single letter extensions */
+	if (fls(reg_val) >= RISCV_ISA_EXT_BASE)
+		return -EINVAL;
+
 	switch (reg_num) {
 	case KVM_REG_RISCV_CONFIG_REG(isa):
 		if (!vcpu->arch.ran_atleast_once) {
 			/* Ignore the disable request for these extensions */
-			vcpu->arch.isa = reg_val | KVM_RISCV_ISA_DISABLE_NOT_ALLOWED;
-			vcpu->arch.isa &= riscv_isa_extension_base(NULL);
-			vcpu->arch.isa &= KVM_RISCV_ISA_ALLOWED;
+			isa_mask = (reg_val | KVM_RISCV_ISA_DISABLE_NOT_ALLOWED);
+			isa_mask &= riscv_isa_extension_base(NULL);
+			/* Do not modify anything beyond single letter extensions */
+			isa_mask |= (~KVM_RISCV_ISA_MASK);
+			bitmap_and(vcpu->arch.isa, vcpu->arch.isa, &isa_mask, RISCV_ISA_EXT_MAX);
 			kvm_riscv_vcpu_fp_reset(vcpu);
 		} else {
 			return -EOPNOTSUPP;
@@ -374,17 +399,6 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-/* Mapping between KVM ISA Extension ID & Host ISA extension ID */
-static unsigned long kvm_isa_ext_arr[] = {
-	RISCV_ISA_EXT_a,
-	RISCV_ISA_EXT_c,
-	RISCV_ISA_EXT_d,
-	RISCV_ISA_EXT_f,
-	RISCV_ISA_EXT_h,
-	RISCV_ISA_EXT_i,
-	RISCV_ISA_EXT_m,
-};
-
 static int kvm_riscv_vcpu_get_reg_isa_ext(struct kvm_vcpu *vcpu,
 					  const struct kvm_one_reg *reg)
 {
@@ -403,7 +417,7 @@ static int kvm_riscv_vcpu_get_reg_isa_ext(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	host_isa_ext = kvm_isa_ext_arr[reg_num];
-	if (__riscv_isa_extension_available(&vcpu->arch.isa, host_isa_ext))
+	if (__riscv_isa_extension_available(vcpu->arch.isa, host_isa_ext))
 		reg_val = 1; /* Mark the given extension as available */
 
 	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
@@ -437,30 +451,17 @@ static int kvm_riscv_vcpu_set_reg_isa_ext(struct kvm_vcpu *vcpu,
 	if (!__riscv_isa_extension_available(NULL, host_isa_ext))
 		return	-EOPNOTSUPP;
 
-	if (host_isa_ext >= RISCV_ISA_EXT_BASE &&
-	    host_isa_ext < RISCV_ISA_EXT_MAX) {
-		/*
-		 * Multi-letter ISA extension. Currently there is no provision
-		 * to enable/disable the multi-letter ISA extensions for guests.
-		 * Return success if the request is to enable any ISA extension
-		 * that is available in the hardware.
-		 * Return -EOPNOTSUPP otherwise.
-		 */
-		if (!reg_val)
-			return -EOPNOTSUPP;
-		else
-			return 0;
-	}
-
-	/* Single letter base ISA extension */
 	if (!vcpu->arch.ran_atleast_once) {
+		/* All multi-letter extension and a few single letter extension can be disabled */
 		host_isa_ext_mask = BIT_MASK(host_isa_ext);
-		if (!reg_val && (host_isa_ext_mask & KVM_RISCV_ISA_DISABLE_ALLOWED))
-			vcpu->arch.isa &= ~host_isa_ext_mask;
+		if (!reg_val &&
+		   ((host_isa_ext_mask & KVM_RISCV_ISA_DISABLE_ALLOWED) ||
+		   ((host_isa_ext >= RISCV_ISA_EXT_BASE) && (host_isa_ext < RISCV_ISA_EXT_MAX))))
+			clear_bit(host_isa_ext, vcpu->arch.isa);
+		else if (reg_val == 1 && (host_isa_ext != RISCV_ISA_EXT_h))
+			set_bit(host_isa_ext, vcpu->arch.isa);
 		else
-			vcpu->arch.isa |= host_isa_ext_mask;
-		vcpu->arch.isa &= riscv_isa_extension_base(NULL);
-		vcpu->arch.isa &= KVM_RISCV_ISA_ALLOWED;
+			return -EINVAL;
 		kvm_riscv_vcpu_fp_reset(vcpu);
 	} else {
 		return -EOPNOTSUPP;
diff --git a/arch/riscv/kvm/vcpu_fp.c b/arch/riscv/kvm/vcpu_fp.c
index d4308c512007..748a8f6a9b5d 100644
--- a/arch/riscv/kvm/vcpu_fp.c
+++ b/arch/riscv/kvm/vcpu_fp.c
@@ -16,12 +16,11 @@
 #ifdef CONFIG_FPU
 void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu)
 {
-	unsigned long isa = vcpu->arch.isa;
 	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
 
 	cntx->sstatus &= ~SR_FS;
-	if (riscv_isa_extension_available(&isa, f) ||
-	    riscv_isa_extension_available(&isa, d))
+	if (riscv_isa_extension_available(vcpu->arch.isa, f) ||
+	    riscv_isa_extension_available(vcpu->arch.isa, d))
 		cntx->sstatus |= SR_FS_INITIAL;
 	else
 		cntx->sstatus |= SR_FS_OFF;
@@ -34,24 +33,24 @@ static void kvm_riscv_vcpu_fp_clean(struct kvm_cpu_context *cntx)
 }
 
 void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx,
-				  unsigned long isa)
+				  unsigned long *isa)
 {
 	if ((cntx->sstatus & SR_FS) == SR_FS_DIRTY) {
-		if (riscv_isa_extension_available(&isa, d))
+		if (riscv_isa_extension_available(isa, d))
 			__kvm_riscv_fp_d_save(cntx);
-		else if (riscv_isa_extension_available(&isa, f))
+		else if (riscv_isa_extension_available(isa, f))
 			__kvm_riscv_fp_f_save(cntx);
 		kvm_riscv_vcpu_fp_clean(cntx);
 	}
 }
 
 void kvm_riscv_vcpu_guest_fp_restore(struct kvm_cpu_context *cntx,
-				     unsigned long isa)
+				     unsigned long *isa)
 {
 	if ((cntx->sstatus & SR_FS) != SR_FS_OFF) {
-		if (riscv_isa_extension_available(&isa, d))
+		if (riscv_isa_extension_available(isa, d))
 			__kvm_riscv_fp_d_restore(cntx);
-		else if (riscv_isa_extension_available(&isa, f))
+		else if (riscv_isa_extension_available(isa, f))
 			__kvm_riscv_fp_f_restore(cntx);
 		kvm_riscv_vcpu_fp_clean(cntx);
 	}
@@ -80,7 +79,6 @@ int kvm_riscv_vcpu_get_reg_fp(struct kvm_vcpu *vcpu,
 			      unsigned long rtype)
 {
 	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
-	unsigned long isa = vcpu->arch.isa;
 	unsigned long __user *uaddr =
 			(unsigned long __user *)(unsigned long)reg->addr;
 	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
@@ -89,7 +87,7 @@ int kvm_riscv_vcpu_get_reg_fp(struct kvm_vcpu *vcpu,
 	void *reg_val;
 
 	if ((rtype == KVM_REG_RISCV_FP_F) &&
-	    riscv_isa_extension_available(&isa, f)) {
+	    riscv_isa_extension_available(vcpu->arch.isa, f)) {
 		if (KVM_REG_SIZE(reg->id) != sizeof(u32))
 			return -EINVAL;
 		if (reg_num == KVM_REG_RISCV_FP_F_REG(fcsr))
@@ -100,7 +98,7 @@ int kvm_riscv_vcpu_get_reg_fp(struct kvm_vcpu *vcpu,
 		else
 			return -EINVAL;
 	} else if ((rtype == KVM_REG_RISCV_FP_D) &&
-		   riscv_isa_extension_available(&isa, d)) {
+		   riscv_isa_extension_available(vcpu->arch.isa, d)) {
 		if (reg_num == KVM_REG_RISCV_FP_D_REG(fcsr)) {
 			if (KVM_REG_SIZE(reg->id) != sizeof(u32))
 				return -EINVAL;
@@ -126,7 +124,6 @@ int kvm_riscv_vcpu_set_reg_fp(struct kvm_vcpu *vcpu,
 			      unsigned long rtype)
 {
 	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
-	unsigned long isa = vcpu->arch.isa;
 	unsigned long __user *uaddr =
 			(unsigned long __user *)(unsigned long)reg->addr;
 	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
@@ -135,7 +132,7 @@ int kvm_riscv_vcpu_set_reg_fp(struct kvm_vcpu *vcpu,
 	void *reg_val;
 
 	if ((rtype == KVM_REG_RISCV_FP_F) &&
-	    riscv_isa_extension_available(&isa, f)) {
+	    riscv_isa_extension_available(vcpu->arch.isa, f)) {
 		if (KVM_REG_SIZE(reg->id) != sizeof(u32))
 			return -EINVAL;
 		if (reg_num == KVM_REG_RISCV_FP_F_REG(fcsr))
@@ -146,7 +143,7 @@ int kvm_riscv_vcpu_set_reg_fp(struct kvm_vcpu *vcpu,
 		else
 			return -EINVAL;
 	} else if ((rtype == KVM_REG_RISCV_FP_D) &&
-		   riscv_isa_extension_available(&isa, d)) {
+		   riscv_isa_extension_available(vcpu->arch.isa, d)) {
 		if (reg_num == KVM_REG_RISCV_FP_D_REG(fcsr)) {
 			if (KVM_REG_SIZE(reg->id) != sizeof(u32))
 				return -EINVAL;
-- 
2.25.1

