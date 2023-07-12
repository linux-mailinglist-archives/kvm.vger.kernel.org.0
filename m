Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E9A750DA4
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbjGLQLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbjGLQLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:11:13 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864941BFA
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:11:10 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-55b1238cab4so3775415a12.2
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689178270; x=1691770270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DTUMIEDhcKf2bFBb/5BSCfijz7GR+v5Ad2nUk3NUi0Q=;
        b=DBy3wZ8TzbwTSWBfOP++4PzWuBd8ru08ph1IXO4TsE4JEf37vUxH5co7qmup01LJnE
         JjxKmSVHVo+OdfN0ySGY2IBsAcrhOjPcsFWFwb5Uziv0VCQdR0eTYOyOVbfWzYjQW6xR
         /qdUKimBRDNqNK4s+XVWZISSWwCH0zjyV9Y62uucjJWEXWSivplUYPxgFUuKcDZbh8pL
         szastF2RGm3WNn6FpPC4WQGlrPsPp1BKqh1Y9hYc0SKFW0UhLBpK2EY1RqtYT1/jowT2
         RwNwUY3kHwz0qR6pualkBr7Pp2NQCW40CmPbAbqyzoe1rFkgTEMiTlKLL+99A58kqZS8
         Km3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689178270; x=1691770270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DTUMIEDhcKf2bFBb/5BSCfijz7GR+v5Ad2nUk3NUi0Q=;
        b=iWCjb9iTZwqrDId7CxUh001OSnmGkTh93Kr+JtUzmFxhmg22UUGn8yyMjJkTBpty17
         7e3joAn/5t+KoNkvERzWMrILwxTBeloRRWB1vdgqfEwIDT6E21vd1K9nkJZW3K+EeB/x
         qH39N59AuVdTrAPUAle2QS3tOUwlUfpFbpEU4JnkAhD3jmRXuVCq+nIEa1EC5wIz87Ng
         r0TNOgMA8Oe2mWcslxyvb/Oqc0z/dteihyW6Fvmtft8c/6enWY0d4nRGKR7Ld07KgFFV
         YgpeX079QsPl2vbqTXAOagTlSrnhhTj9QoNL85VXBbNaC/vqgCO169ftHaL/QUaPrzXR
         JdCg==
X-Gm-Message-State: ABy/qLY45nZVGf7EK1iXTqbL6lk5kCR9lZQ5j7JZ/1eg1zVmTb6JpqE/
        Y80O8bm2MGzHoQRGCZFlKNPkfA==
X-Google-Smtp-Source: APBJJlGsx/YmWFy6gTZ9WN+HYb6lFatRjBmtvz+ASObwDYHyCHP87qgrdXgdVoI9bb0IcE5detKGIw==
X-Received: by 2002:a17:902:ab98:b0:1b8:3cb8:7926 with SMTP id f24-20020a170902ab9800b001b83cb87926mr14382566plr.23.1689178269799;
        Wed, 12 Jul 2023 09:11:09 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.82.173])
        by smtp.gmail.com with ESMTPSA id bc2-20020a170902930200b001b9f032bb3dsm3811650plb.3.2023.07.12.09.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:11:09 -0700 (PDT)
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
Subject: [PATCH 2/7] RISC-V: KVM: Extend ONE_REG to enable/disable multiple ISA extensions
Date:   Wed, 12 Jul 2023 21:40:42 +0530
Message-Id: <20230712161047.1764756-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712161047.1764756-1-apatel@ventanamicro.com>
References: <20230712161047.1764756-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the ISA extension ONE_REG interface only allows enabling or
disabling one extension at a time. To improve this, we extend the ISA
extension ONE_REG interface (similar to SBI extension ONE_REG interface)
so that KVM user space can enable/disable multiple extensions in one
ioctl.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/uapi/asm/kvm.h |   9 ++
 arch/riscv/kvm/vcpu_onereg.c      | 153 ++++++++++++++++++++++++------
 2 files changed, 133 insertions(+), 29 deletions(-)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 930fdc4101cd..6c2285f86545 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -193,6 +193,15 @@ enum KVM_RISCV_SBI_EXT_ID {
 
 /* ISA Extension registers are mapped as type 7 */
 #define KVM_REG_RISCV_ISA_EXT		(0x07 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_ISA_SINGLE	(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_ISA_MULTI_EN	(0x1 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_ISA_MULTI_DIS	(0x2 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_ISA_MULTI_REG(__ext_id)	\
+		((__ext_id) / __BITS_PER_LONG)
+#define KVM_REG_RISCV_ISA_MULTI_MASK(__ext_id)	\
+		(1UL << ((__ext_id) % __BITS_PER_LONG))
+#define KVM_REG_RISCV_ISA_MULTI_REG_LAST	\
+		KVM_REG_RISCV_ISA_MULTI_REG(KVM_RISCV_ISA_EXT_MAX - 1)
 
 /* SBI extension registers are mapped as type 8 */
 #define KVM_REG_RISCV_SBI_EXT		(0x08 << KVM_REG_RISCV_TYPE_SHIFT)
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 836ffe79311a..236359722364 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -408,55 +408,34 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static int kvm_riscv_vcpu_get_reg_isa_ext(struct kvm_vcpu *vcpu,
-					  const struct kvm_one_reg *reg)
+static int riscv_vcpu_get_isa_ext_single(struct kvm_vcpu *vcpu,
+					 unsigned long reg_num,
+					 unsigned long *reg_val)
 {
-	unsigned long __user *uaddr =
-			(unsigned long __user *)(unsigned long)reg->addr;
-	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
-					    KVM_REG_SIZE_MASK |
-					    KVM_REG_RISCV_ISA_EXT);
-	unsigned long reg_val = 0;
 	unsigned long host_isa_ext;
 
-	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
-		return -EINVAL;
-
 	if (reg_num >= KVM_RISCV_ISA_EXT_MAX ||
 	    reg_num >= ARRAY_SIZE(kvm_isa_ext_arr))
 		return -EINVAL;
 
+	*reg_val = 0;
 	host_isa_ext = kvm_isa_ext_arr[reg_num];
 	if (__riscv_isa_extension_available(vcpu->arch.isa, host_isa_ext))
-		reg_val = 1; /* Mark the given extension as available */
-
-	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
-		return -EFAULT;
+		*reg_val = 1; /* Mark the given extension as available */
 
 	return 0;
 }
 
-static int kvm_riscv_vcpu_set_reg_isa_ext(struct kvm_vcpu *vcpu,
-					  const struct kvm_one_reg *reg)
+static int riscv_vcpu_set_isa_ext_single(struct kvm_vcpu *vcpu,
+					 unsigned long reg_num,
+					 unsigned long reg_val)
 {
-	unsigned long __user *uaddr =
-			(unsigned long __user *)(unsigned long)reg->addr;
-	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
-					    KVM_REG_SIZE_MASK |
-					    KVM_REG_RISCV_ISA_EXT);
-	unsigned long reg_val;
 	unsigned long host_isa_ext;
 
-	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
-		return -EINVAL;
-
 	if (reg_num >= KVM_RISCV_ISA_EXT_MAX ||
 	    reg_num >= ARRAY_SIZE(kvm_isa_ext_arr))
 		return -EINVAL;
 
-	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
-		return -EFAULT;
-
 	host_isa_ext = kvm_isa_ext_arr[reg_num];
 	if (!__riscv_isa_extension_available(NULL, host_isa_ext))
 		return	-EOPNOTSUPP;
@@ -482,6 +461,122 @@ static int kvm_riscv_vcpu_set_reg_isa_ext(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int riscv_vcpu_get_isa_ext_multi(struct kvm_vcpu *vcpu,
+					unsigned long reg_num,
+					unsigned long *reg_val)
+{
+	unsigned long i, ext_id, ext_val;
+
+	if (reg_num > KVM_REG_RISCV_ISA_MULTI_REG_LAST)
+		return -EINVAL;
+
+	for (i = 0; i < BITS_PER_LONG; i++) {
+		ext_id = i + reg_num * BITS_PER_LONG;
+		if (ext_id >= KVM_RISCV_ISA_EXT_MAX)
+			break;
+
+		ext_val = 0;
+		riscv_vcpu_get_isa_ext_single(vcpu, ext_id, &ext_val);
+		if (ext_val)
+			*reg_val |= KVM_REG_RISCV_ISA_MULTI_MASK(ext_id);
+	}
+
+	return 0;
+}
+
+static int riscv_vcpu_set_isa_ext_multi(struct kvm_vcpu *vcpu,
+					unsigned long reg_num,
+					unsigned long reg_val, bool enable)
+{
+	unsigned long i, ext_id;
+
+	if (reg_num > KVM_REG_RISCV_ISA_MULTI_REG_LAST)
+		return -EINVAL;
+
+	for_each_set_bit(i, &reg_val, BITS_PER_LONG) {
+		ext_id = i + reg_num * BITS_PER_LONG;
+		if (ext_id >= KVM_RISCV_ISA_EXT_MAX)
+			break;
+
+		riscv_vcpu_set_isa_ext_single(vcpu, ext_id, enable);
+	}
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_get_reg_isa_ext(struct kvm_vcpu *vcpu,
+					  const struct kvm_one_reg *reg)
+{
+	int rc;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_ISA_EXT);
+	unsigned long reg_val, reg_subtype;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+
+	reg_subtype = reg_num & KVM_REG_RISCV_SUBTYPE_MASK;
+	reg_num &= ~KVM_REG_RISCV_SUBTYPE_MASK;
+
+	reg_val = 0;
+	switch (reg_subtype) {
+	case KVM_REG_RISCV_ISA_SINGLE:
+		rc = riscv_vcpu_get_isa_ext_single(vcpu, reg_num, &reg_val);
+		break;
+	case KVM_REG_RISCV_ISA_MULTI_EN:
+	case KVM_REG_RISCV_ISA_MULTI_DIS:
+		rc = riscv_vcpu_get_isa_ext_multi(vcpu, reg_num, &reg_val);
+		if (!rc && reg_subtype == KVM_REG_RISCV_ISA_MULTI_DIS)
+			reg_val = ~reg_val;
+		break;
+	default:
+		rc = -EINVAL;
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
+static int kvm_riscv_vcpu_set_reg_isa_ext(struct kvm_vcpu *vcpu,
+					  const struct kvm_one_reg *reg)
+{
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_ISA_EXT);
+	unsigned long reg_val, reg_subtype;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+
+	reg_subtype = reg_num & KVM_REG_RISCV_SUBTYPE_MASK;
+	reg_num &= ~KVM_REG_RISCV_SUBTYPE_MASK;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	switch (reg_subtype) {
+	case KVM_REG_RISCV_ISA_SINGLE:
+		return riscv_vcpu_set_isa_ext_single(vcpu, reg_num, reg_val);
+	case KVM_REG_RISCV_SBI_MULTI_EN:
+		return riscv_vcpu_set_isa_ext_multi(vcpu, reg_num, reg_val, true);
+	case KVM_REG_RISCV_SBI_MULTI_DIS:
+		return riscv_vcpu_set_isa_ext_multi(vcpu, reg_num, reg_val, false);
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
 			   const struct kvm_one_reg *reg)
 {
-- 
2.34.1

