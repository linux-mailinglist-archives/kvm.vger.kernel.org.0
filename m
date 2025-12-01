Return-Path: <kvm+bounces-64983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54E6BC9588D
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 02:46:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E8FA3A2FBA
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 01:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AA761547E7;
	Mon,  1 Dec 2025 01:46:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A6C3B186;
	Mon,  1 Dec 2025 01:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764553593; cv=none; b=du5U8QEHM0hs8A5OF/NOpGihLxD9s/lZatzX95Td30wPrw+sHckuJei2dKO4D1KSbXQyZerHKIpDl1PzsHcPYSkE+1CfxURqyL1PV2cz+7Nrns9pkfdtGAnpFy5759gUcMjRfgLSHmjgKGbdMFtw7KmmobZjKpX4buSdQDy5UoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764553593; c=relaxed/simple;
	bh=zQk3DEOPSmblHG+Y2AODvaSB9c8Mqy/BweSJ4C9UuG8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mab7LK9A7Z6DfGUJGDtWkgnXJWNikjLhuX1TuOYjryfAKZ9YZ0YjnUCBGWIPgsZdLIR2gB96neHrlwAP8YREAQ7X/bLnTQ2ioQ4+zE5fMjZLdGT2SJycpXE3JUkKTOCC+fYNfwm4zb/ZURRFJsKl3ZwWcX/CjG51pMLxrClZmS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.. (unknown [121.237.244.238])
	by APP-01 (Coremail) with SMTP id qwCowABX7Mtv8yxp69+vAg--.18496S2;
	Mon, 01 Dec 2025 09:46:24 +0800 (CST)
From: zhouquan@iscas.ac.cn
To: anup@brainfault.org,
	ajones@ventanamicro.com,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com
Cc: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Quan Zhou <zhouquan@iscas.ac.cn>
Subject: [PATCH 3/4] RISC-V: KVM: Add suuport for zicfiss/zicfilp/svadu FWFT features
Date: Mon,  1 Dec 2025 09:28:48 +0800
Message-Id: <1793aa636969da0a09d27c9c12f6d5f8f0d1cd21.1764509485.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1764509485.git.zhouquan@iscas.ac.cn>
References: <cover.1764509485.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowABX7Mtv8yxp69+vAg--.18496S2
X-Coremail-Antispam: 1UD129KBjvJXoWxtw1xGr1UXF47Zr1rWryDJrb_yoW7tw4UpF
	WxWF9rWayfJr9Y93ZYyrsrWFWYgws7K3ZFyay7G34FvFy2kF45JF1kKr9rAryDA340vFWS
	kF4qqF1UCrs0v3JanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxV
	WxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
	Yx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7Cj
	xVA2Y2ka0xkIwI1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r1q6r43MxkIecxEwVAFwV
	WkMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8
	JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIx
	AIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjiSdPUUUUU=
	=
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiDAgDBmks7K0aZgAAs5

From: Quan Zhou <zhouquan@iscas.ac.cn>

Add support in KVM SBI FWFT extension to allow VS-mode to request
SBI_FWFT_{LANDING_PAD/SHADOW_STACK/PTE_AD_HW_UPDATING}.

Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
---
 arch/riscv/include/uapi/asm/kvm.h |   3 +
 arch/riscv/kvm/vcpu_sbi_fwft.c    | 129 ++++++++++++++++++++++++++++++
 2 files changed, 132 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 7ca087848a43..d93b70d89010 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -232,6 +232,9 @@ struct kvm_riscv_sbi_fwft_feature {
 struct kvm_riscv_sbi_fwft {
 	struct kvm_riscv_sbi_fwft_feature misaligned_deleg;
 	struct kvm_riscv_sbi_fwft_feature pointer_masking;
+	struct kvm_riscv_sbi_fwft_feature landing_pad;
+	struct kvm_riscv_sbi_fwft_feature shadow_stack;
+	struct kvm_riscv_sbi_fwft_feature pte_ad_hw_updating;
 };
 
 /* Possible states for kvm_riscv_timer */
diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
index 62cc9c3d5759..0dc0e70fc83b 100644
--- a/arch/riscv/kvm/vcpu_sbi_fwft.c
+++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
@@ -213,6 +213,108 @@ static long kvm_sbi_fwft_get_pointer_masking_pmlen(struct kvm_vcpu *vcpu,
 	return SBI_SUCCESS;
 }
 
+static long kvm_sbi_fwft_set_henvcfg_flag(struct kvm_vcpu *vcpu,
+					 struct kvm_sbi_fwft_config *conf,
+					 bool one_reg_access, unsigned long value,
+					 unsigned long flag)
+{
+	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
+
+	if (value == 1)
+		cfg->henvcfg |= flag;
+	else if (value == 0)
+		cfg->henvcfg &= ~flag;
+	else
+		return SBI_ERR_INVALID_PARAM;
+
+	if (!one_reg_access)
+		csr_write(CSR_HENVCFG, cfg->henvcfg);
+
+	return SBI_SUCCESS;
+}
+
+static bool kvm_sbi_fwft_pointer_landing_pad_supported(struct kvm_vcpu *vcpu)
+{
+	return riscv_isa_extension_available(vcpu->arch.isa, ZICFILP);
+}
+
+static void kvm_sbi_fwft_reset_landing_pad(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.cfg.henvcfg &= ~ENVCFG_LPE;
+}
+
+static long kvm_sbi_fwft_set_landing_pad(struct kvm_vcpu *vcpu,
+						   struct kvm_sbi_fwft_config *conf,
+						   bool one_reg_access, unsigned long value)
+{
+	return kvm_sbi_fwft_set_henvcfg_flag(vcpu, conf, one_reg_access, value, ENVCFG_LPE);
+}
+
+static long kvm_sbi_fwft_get_landing_pad(struct kvm_vcpu *vcpu,
+						   struct kvm_sbi_fwft_config *conf,
+						   bool one_reg_access, unsigned long *value)
+{
+	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
+
+	*value = (cfg->henvcfg & ENVCFG_LPE) == ENVCFG_LPE;
+	return SBI_SUCCESS;
+}
+
+static bool kvm_sbi_fwft_pointer_shadow_stack_supported(struct kvm_vcpu *vcpu)
+{
+	return riscv_isa_extension_available(vcpu->arch.isa, ZICFISS);
+}
+
+static void kvm_sbi_fwft_reset_shadow_stack(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.cfg.henvcfg &= ~ENVCFG_SSE;
+}
+
+static long kvm_sbi_fwft_set_shadow_stack(struct kvm_vcpu *vcpu,
+						   struct kvm_sbi_fwft_config *conf,
+						   bool one_reg_access, unsigned long value)
+{
+	return kvm_sbi_fwft_set_henvcfg_flag(vcpu, conf, one_reg_access, value, ENVCFG_SSE);
+}
+
+static long kvm_sbi_fwft_get_shadow_stack(struct kvm_vcpu *vcpu,
+						   struct kvm_sbi_fwft_config *conf,
+						   bool one_reg_access, unsigned long *value)
+{
+	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
+
+	*value = (cfg->henvcfg & ENVCFG_SSE) == ENVCFG_SSE;
+	return SBI_SUCCESS;
+}
+
+static bool kvm_sbi_fwft_pointer_pte_ad_hw_updating_supported(struct kvm_vcpu *vcpu)
+{
+	return riscv_isa_extension_available(vcpu->arch.isa, SVADU) &&
+		!riscv_isa_extension_available(vcpu->arch.isa, SVADE);
+}
+
+static void kvm_sbi_fwft_reset_pte_ad_hw_updating(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.cfg.henvcfg &= ~ENVCFG_ADUE;
+}
+
+static long kvm_sbi_fwft_set_pte_ad_hw_updating(struct kvm_vcpu *vcpu,
+						   struct kvm_sbi_fwft_config *conf,
+						   bool one_reg_access, unsigned long value)
+{
+	return kvm_sbi_fwft_set_henvcfg_flag(vcpu, conf, one_reg_access, value, ENVCFG_ADUE);
+}
+
+static long kvm_sbi_fwft_get_pte_ad_hw_updating(struct kvm_vcpu *vcpu,
+						   struct kvm_sbi_fwft_config *conf,
+						   bool one_reg_access, unsigned long *value)
+{
+	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
+
+	*value = (cfg->henvcfg & ENVCFG_ADUE) == ENVCFG_ADUE;
+	return SBI_SUCCESS;
+}
+
 #endif
 
 static const struct kvm_sbi_fwft_feature features[] = {
@@ -236,6 +338,33 @@ static const struct kvm_sbi_fwft_feature features[] = {
 		.get = kvm_sbi_fwft_get_pointer_masking_pmlen,
 	},
 #endif
+	{
+		.id = SBI_FWFT_LANDING_PAD,
+		.first_reg_num = offsetof(struct kvm_riscv_sbi_fwft, landing_pad.enable) /
+				 sizeof(unsigned long),
+		.supported = kvm_sbi_fwft_landing_pad_supported,
+		.reset = kvm_sbi_fwft_reset_landing_pad,
+		.set = kvm_sbi_fwft_set_landing_pad,
+		.get = kvm_sbi_fwft_get_landing_pad,
+	},
+	{
+		.id = SBI_FWFT_SHADOW_STACK,
+		.first_reg_num = offsetof(struct kvm_riscv_sbi_fwft, shadow_stack.enable) /
+				 sizeof(unsigned long),
+		.supported = kvm_sbi_fwft_shadow_stack_supported,
+		.reset = kvm_sbi_fwft_reset_shadow_stack,
+		.set = kvm_sbi_fwft_set_shadow_stack,
+		.get = kvm_sbi_fwft_get_shadow_stack,
+	},
+	{
+		.id = SBI_FWFT_PTE_AD_HW_UPDATING,
+		.first_reg_num = offsetof(struct kvm_riscv_sbi_fwft, pte_ad_hw_updating.enable) /
+				 sizeof(unsigned long),
+		.supported = kvm_sbi_fwft_pte_ad_hw_updating_supported,
+		.reset = kvm_sbi_fwft_reset_pte_ad_hw_updating,
+		.set = kvm_sbi_fwft_set_pte_ad_hw_updating,
+		.get = kvm_sbi_fwft_get_pte_ad_hw_updating,
+	},
 };
 
 static const struct kvm_sbi_fwft_feature *kvm_sbi_fwft_regnum_to_feature(unsigned long reg_num)
-- 
2.34.1


