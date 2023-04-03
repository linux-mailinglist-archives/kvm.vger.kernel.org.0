Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E16E6D40B4
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 11:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbjDCJeh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 05:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbjDCJeM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 05:34:12 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5576FAF1B
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 02:33:54 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id a30-20020a9d3e1e000000b006a13f728172so12089796otd.3
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 02:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680514433; x=1683106433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G+FKlGY9+fsxmXa+E2ygJ8SqSZPYKfuMuKdW0nBwESI=;
        b=YeO8AtHtNrxFd09O0Kv4XtU6gmmvhqa+32++wYbcO3Sn/g9LxebMLwQypOxMg/6HQa
         yWFYsJL6Fp2RRvTbWgJIaBJYcwB8HDfn2SltCxWI4THa5jjyKaARqZVDUoJYAw8y91rV
         vJ1ww+xXy2iYXmg2RqQ5nkIlUOk5lhbrfvS1F+7LEAa8RjJl2EI+JqCjjozOeOhu8h7d
         Y/EFPrErjSV8Pn/f7I+wNkpuRvQh/jYpEOQprcMVV305V9w+C4M4fQtBpIR5Ngpn8M3B
         OscG6i3382bUuuPHVeCYw6h5DwFafwLLr8FRDbm/0oNi6fU16Q4SIvgU+8FT5Rb/yTTH
         gvDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680514433; x=1683106433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G+FKlGY9+fsxmXa+E2ygJ8SqSZPYKfuMuKdW0nBwESI=;
        b=QVs9ExEqcYWxBQbIUsIObZr2ztmUYSw1rj9gFzJnrcL/Qlyoer4V6xMmTDfiZEqZRw
         xbibVX2bAqAfOJEv0CKZRKQmlCfNCsut8zPT0YxUnp4TvDXwBCzhcyi3s9rVgRIjXd1g
         XU7M8L++PcMoRsycsgbs6S/QXq52tEBRqzBWCU/sp9BS38v5iYHTBmC1S/s9bqHPnNnn
         5lm/DhWbtpTLjXZbUhsX54L+GcGyGd+b+VV3cKVFnCjOr2R883UlCIt7UHLz5/5Y//q+
         FuPICrUS94S4yrTDtuQRpL+q3Xn/ltyeenWtcXYHevOGXFVvTWK69upvwpfqWgpgHPri
         L8uQ==
X-Gm-Message-State: AAQBX9dTvYbS1Mracl+sjyLPCBIOi+XdqDrq7MKqbGmbxvtThKbdFTs1
        X9xXpOTy1638I/nypNhpYikaYA==
X-Google-Smtp-Source: AKy350bRi1WrUjTU9kelZslJWpcjqtZN2JY6TsllxNwi9kovezaUK4RaVAw2QJhClRT0LeVrPvcQwg==
X-Received: by 2002:a05:6830:1503:b0:6a3:2513:c452 with SMTP id k3-20020a056830150300b006a32513c452mr2917922otp.23.1680514433022;
        Mon, 03 Apr 2023 02:33:53 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id f5-20020a9d6c05000000b006a154373578sm3953953otq.39.2023.04.03.02.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 02:33:52 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v3 5/8] RISC-V: KVM: Implement subtype for CSR ONE_REG interface
Date:   Mon,  3 Apr 2023 15:03:07 +0530
Message-Id: <20230403093310.2271142-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230403093310.2271142-1-apatel@ventanamicro.com>
References: <20230403093310.2271142-1-apatel@ventanamicro.com>
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

To make the CSR ONE_REG interface extensible, we implement subtype
for the CSR ONE_REG IDs. The existing CSR ONE_REG IDs are treated
as subtype = 0 (aka General CSRs).

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/uapi/asm/kvm.h |  3 +-
 arch/riscv/kvm/vcpu.c             | 88 +++++++++++++++++++++++--------
 2 files changed, 69 insertions(+), 22 deletions(-)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 47a7c3958229..182023dc9a51 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -65,7 +65,7 @@ struct kvm_riscv_core {
 #define KVM_RISCV_MODE_S	1
 #define KVM_RISCV_MODE_U	0
 
-/* CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+/* General CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
 struct kvm_riscv_csr {
 	unsigned long sstatus;
 	unsigned long sie;
@@ -152,6 +152,7 @@ enum KVM_RISCV_SBI_EXT_ID {
 
 /* Control and status registers are mapped as type 3 */
 #define KVM_REG_RISCV_CSR		(0x03 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_CSR_GENERAL	(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
 #define KVM_REG_RISCV_CSR_REG(name)	\
 		(offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 1fd54ec15622..aca6b4fb7519 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -460,27 +460,72 @@ static int kvm_riscv_vcpu_set_reg_core(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
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
+	} else
+		*out_val = ((unsigned long *)csr)[reg_num];
+
+	return 0;
+}
+
+static inline int kvm_riscv_vcpu_general_set_csr(struct kvm_vcpu *vcpu,
+						 unsigned long reg_num,
+						 unsigned long reg_val)
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
+		WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
+
+	return 0;
+}
+
 static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vcpu *vcpu,
 				      const struct kvm_one_reg *reg)
 {
-	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	int rc;
 	unsigned long __user *uaddr =
 			(unsigned long __user *)(unsigned long)reg->addr;
 	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
 					    KVM_REG_SIZE_MASK |
 					    KVM_REG_RISCV_CSR);
-	unsigned long reg_val;
+	unsigned long reg_val, reg_subtype;
 
 	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
 		return -EINVAL;
-	if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
-		return -EINVAL;
 
-	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
-		kvm_riscv_vcpu_flush_interrupts(vcpu);
-		reg_val = (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_VALID_MASK;
-	} else
-		reg_val = ((unsigned long *)csr)[reg_num];
+	reg_subtype = reg_num & KVM_REG_RISCV_SUBTYPE_MASK;
+	reg_num &= ~KVM_REG_RISCV_SUBTYPE_MASK;
+	switch (reg_subtype) {
+	case KVM_REG_RISCV_CSR_GENERAL:
+		rc = kvm_riscv_vcpu_general_get_csr(vcpu, reg_num, &reg_val);
+		break;
+	default:
+		rc = -EINVAL;
+		break;
+	}
+	if (rc)
+		return rc;
 
 	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
@@ -491,31 +536,32 @@ static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vcpu *vcpu,
 static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
 				      const struct kvm_one_reg *reg)
 {
-	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	int rc;
 	unsigned long __user *uaddr =
 			(unsigned long __user *)(unsigned long)reg->addr;
 	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
 					    KVM_REG_SIZE_MASK |
 					    KVM_REG_RISCV_CSR);
-	unsigned long reg_val;
+	unsigned long reg_val, reg_subtype;
 
 	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
 		return -EINVAL;
-	if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
-		return -EINVAL;
 
 	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 
-	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
-		reg_val &= VSIP_VALID_MASK;
-		reg_val <<= VSIP_TO_HVIP_SHIFT;
+	reg_subtype = reg_num & KVM_REG_RISCV_SUBTYPE_MASK;
+	reg_num &= ~KVM_REG_RISCV_SUBTYPE_MASK;
+	switch (reg_subtype) {
+	case KVM_REG_RISCV_CSR_GENERAL:
+		rc = kvm_riscv_vcpu_general_set_csr(vcpu, reg_num, reg_val);
+		break;
+	default:
+		rc = -EINVAL;
+		break;
 	}
-
-	((unsigned long *)csr)[reg_num] = reg_val;
-
-	if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
-		WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
+	if (rc)
+		return rc;
 
 	return 0;
 }
-- 
2.34.1

