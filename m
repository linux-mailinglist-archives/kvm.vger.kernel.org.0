Return-Path: <kvm+bounces-18308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D67308D3A03
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 16:56:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 066621C21363
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C46EF17F36E;
	Wed, 29 May 2024 14:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I1nejoL5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E473716A379;
	Wed, 29 May 2024 14:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716994595; cv=none; b=HwmbOhy7m9Vj6eUqZ1WNzYs1clwn0d/GthjznKWKOTmhdvnsVAKILadgZb3Pw8ZPrb5G3ejKE6MyoJeVbmk2eP+MQWGm2kY7j+7h+/QzFYc/mvj1ceP9tsgSpQPIkOJr2dXt4SxZg/kHgHkdlkC/16yvL+k+OJizKNPv69vh4gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716994595; c=relaxed/simple;
	bh=d6gYfXREzLx9AC4i/x7IJLh2xN8ioZDrcyAlf13uvAA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nxWEqaRYBMC0HflIOAh8/LAXEO5RHRx8Xz9kUQKLkt/HHWoLjOr1y65LP3QywLibbv+HSZLOayXihD0kKxeH1XQNqW9ImJ6Ss8yc+/CcCeknN0NBZ1L5IZ9yFY5ro3FHe50wVx0NA7NF6cGt1h5d9ix8ZDxkc0JWiLGbKDaodPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I1nejoL5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864F1C2BD10;
	Wed, 29 May 2024 14:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716994594;
	bh=d6gYfXREzLx9AC4i/x7IJLh2xN8ioZDrcyAlf13uvAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1nejoL5g1fUFP+mt7ebayHqAVddPT0chfguMCnBQurxYVcnMLQj5J+1MkVn/nfvX
	 tzS+E0a7GF1+q+9g9UpnIo6pOI0dk98m+DKkvDCuoVnbhXOgS2wNY71pSCaocIo00a
	 2ytjVol8tiR+vdFPXd6QXCbBnfjVPxS4p12CK/USXx6UL9eKI9scijc1UOAK9AAnKi
	 iwA4wv7u1zJlf+TBhsz0jRcxbMIOuWbYAm6dNLkxcRkdE4F1JFKPr/telGC6P8Nzs3
	 8V+bQV811rSij/JhJ9PKQZtKqex1VfZAUphg/RGmXISiXjHVqd1LFTOO8NzXdr9xU9
	 zuw9hr+AXpF/A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sCKjA-00GekF-Bu;
	Wed, 29 May 2024 15:56:32 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v2 02/16] KVM: arm64: nv: Implement nested Stage-2 page table walk logic
Date: Wed, 29 May 2024 15:56:14 +0100
Message-Id: <20240529145628.3272630-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240529145628.3272630-1-maz@kernel.org>
References: <20240529145628.3272630-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Christoffer Dall <christoffer.dall@linaro.org>

Based on the pseudo-code in the ARM ARM, implement a stage 2 software
page table walker.

Co-developed-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/esr.h        |   1 +
 arch/arm64/include/asm/kvm_nested.h |  13 ++
 arch/arm64/kvm/nested.c             | 265 ++++++++++++++++++++++++++++
 3 files changed, 279 insertions(+)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 7abf09df7033..15a4be765cad 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -152,6 +152,7 @@
 #define ESR_ELx_Xs_MASK		(GENMASK_ULL(4, 0))
 
 /* ISS field definitions for exceptions taken in to Hyp */
+#define ESR_ELx_FSC_ADDRSZ	(0x00)
 #define ESR_ELx_CV		(UL(1) << 24)
 #define ESR_ELx_COND_SHIFT	(20)
 #define ESR_ELx_COND_MASK	(UL(0xF) << ESR_ELx_COND_SHIFT)
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index a69faee31342..5404b7b843cf 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -68,6 +68,19 @@ extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu);
 extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
 extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
 
+struct kvm_s2_trans {
+	phys_addr_t output;
+	unsigned long block_size;
+	bool writable;
+	bool readable;
+	int level;
+	u32 esr;
+	u64 upper_attr;
+};
+
+extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
+			      struct kvm_s2_trans *result);
+
 int kvm_init_nv_sysregs(struct kvm *kvm);
 
 #ifdef CONFIG_ARM64_PTR_AUTH
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 0a6b894b6390..627470fbe0f4 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -91,6 +91,271 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+struct s2_walk_info {
+	int	     (*read_desc)(phys_addr_t pa, u64 *desc, void *data);
+	void	     *data;
+	u64	     baddr;
+	unsigned int max_pa_bits;
+	unsigned int max_ipa_bits;
+	unsigned int pgshift;
+	unsigned int pgsize;
+	unsigned int ps;
+	unsigned int sl;
+	unsigned int t0sz;
+	bool	     be;
+};
+
+static unsigned int ps_to_output_size(unsigned int ps)
+{
+	switch (ps) {
+	case 0: return 32;
+	case 1: return 36;
+	case 2: return 40;
+	case 3: return 42;
+	case 4: return 44;
+	case 5:
+	default:
+		return 48;
+	}
+}
+
+static u32 compute_fsc(int level, u32 fsc)
+{
+	return fsc | (level & 0x3);
+}
+
+static int check_base_s2_limits(struct s2_walk_info *wi,
+				int level, int input_size, int stride)
+{
+	int start_size;
+
+	/* Check translation limits */
+	switch (wi->pgsize) {
+	case SZ_64K:
+		if (level == 0 || (level == 1 && wi->max_ipa_bits <= 42))
+			return -EFAULT;
+		break;
+	case SZ_16K:
+		if (level == 0 || (level == 1 && wi->max_ipa_bits <= 40))
+			return -EFAULT;
+		break;
+	case SZ_4K:
+		if (level < 0 || (level == 0 && wi->max_ipa_bits <= 42))
+			return -EFAULT;
+		break;
+	}
+
+	/* Check input size limits */
+	if (input_size > wi->max_ipa_bits)
+		return -EFAULT;
+
+	/* Check number of entries in starting level table */
+	start_size = input_size - ((3 - level) * stride + wi->pgshift);
+	if (start_size < 1 || start_size > stride + 4)
+		return -EFAULT;
+
+	return 0;
+}
+
+/* Check if output is within boundaries */
+static int check_output_size(struct s2_walk_info *wi, phys_addr_t output)
+{
+	unsigned int output_size = ps_to_output_size(wi->ps);
+
+	if (output_size > wi->max_pa_bits)
+		output_size = wi->max_pa_bits;
+
+	if (output_size != 48 && (output & GENMASK_ULL(47, output_size)))
+		return -1;
+
+	return 0;
+}
+
+/*
+ * This is essentially a C-version of the pseudo code from the ARM ARM
+ * AArch64.TranslationTableWalk  function.  I strongly recommend looking at
+ * that pseudocode in trying to understand this.
+ *
+ * Must be called with the kvm->srcu read lock held
+ */
+static int walk_nested_s2_pgd(phys_addr_t ipa,
+			      struct s2_walk_info *wi, struct kvm_s2_trans *out)
+{
+	int first_block_level, level, stride, input_size, base_lower_bound;
+	phys_addr_t base_addr;
+	unsigned int addr_top, addr_bottom;
+	u64 desc;  /* page table entry */
+	int ret;
+	phys_addr_t paddr;
+
+	switch (wi->pgsize) {
+	default:
+	case SZ_64K:
+	case SZ_16K:
+		level = 3 - wi->sl;
+		first_block_level = 2;
+		break;
+	case SZ_4K:
+		level = 2 - wi->sl;
+		first_block_level = 1;
+		break;
+	}
+
+	stride = wi->pgshift - 3;
+	input_size = 64 - wi->t0sz;
+	if (input_size > 48 || input_size < 25)
+		return -EFAULT;
+
+	ret = check_base_s2_limits(wi, level, input_size, stride);
+	if (WARN_ON(ret))
+		return ret;
+
+	base_lower_bound = 3 + input_size - ((3 - level) * stride +
+			   wi->pgshift);
+	base_addr = wi->baddr & GENMASK_ULL(47, base_lower_bound);
+
+	if (check_output_size(wi, base_addr)) {
+		out->esr = compute_fsc(level, ESR_ELx_FSC_ADDRSZ);
+		return 1;
+	}
+
+	addr_top = input_size - 1;
+
+	while (1) {
+		phys_addr_t index;
+
+		addr_bottom = (3 - level) * stride + wi->pgshift;
+		index = (ipa & GENMASK_ULL(addr_top, addr_bottom))
+			>> (addr_bottom - 3);
+
+		paddr = base_addr | index;
+		ret = wi->read_desc(paddr, &desc, wi->data);
+		if (ret < 0)
+			return ret;
+
+		/*
+		 * Handle reversedescriptors if endianness differs between the
+		 * host and the guest hypervisor.
+		 */
+		if (wi->be)
+			desc = be64_to_cpu((__force __be64)desc);
+		else
+			desc = le64_to_cpu((__force __le64)desc);
+
+		/* Check for valid descriptor at this point */
+		if (!(desc & 1) || ((desc & 3) == 1 && level == 3)) {
+			out->esr = compute_fsc(level, ESR_ELx_FSC_FAULT);
+			out->upper_attr = desc;
+			return 1;
+		}
+
+		/* We're at the final level or block translation level */
+		if ((desc & 3) == 1 || level == 3)
+			break;
+
+		if (check_output_size(wi, desc)) {
+			out->esr = compute_fsc(level, ESR_ELx_FSC_ADDRSZ);
+			out->upper_attr = desc;
+			return 1;
+		}
+
+		base_addr = desc & GENMASK_ULL(47, wi->pgshift);
+
+		level += 1;
+		addr_top = addr_bottom - 1;
+	}
+
+	if (level < first_block_level) {
+		out->esr = compute_fsc(level, ESR_ELx_FSC_FAULT);
+		out->upper_attr = desc;
+		return 1;
+	}
+
+	/*
+	 * We don't use the contiguous bit in the stage-2 ptes, so skip check
+	 * for misprogramming of the contiguous bit.
+	 */
+
+	if (check_output_size(wi, desc)) {
+		out->esr = compute_fsc(level, ESR_ELx_FSC_ADDRSZ);
+		out->upper_attr = desc;
+		return 1;
+	}
+
+	if (!(desc & BIT(10))) {
+		out->esr = compute_fsc(level, ESR_ELx_FSC_ACCESS);
+		out->upper_attr = desc;
+		return 1;
+	}
+
+	/* Calculate and return the result */
+	paddr = (desc & GENMASK_ULL(47, addr_bottom)) |
+		(ipa & GENMASK_ULL(addr_bottom - 1, 0));
+	out->output = paddr;
+	out->block_size = 1UL << ((3 - level) * stride + wi->pgshift);
+	out->readable = desc & (0b01 << 6);
+	out->writable = desc & (0b10 << 6);
+	out->level = level;
+	out->upper_attr = desc & GENMASK_ULL(63, 52);
+	return 0;
+}
+
+static int read_guest_s2_desc(phys_addr_t pa, u64 *desc, void *data)
+{
+	struct kvm_vcpu *vcpu = data;
+
+	return kvm_read_guest(vcpu->kvm, pa, desc, sizeof(*desc));
+}
+
+static void vtcr_to_walk_info(u64 vtcr, struct s2_walk_info *wi)
+{
+	wi->t0sz = vtcr & TCR_EL2_T0SZ_MASK;
+
+	switch (vtcr & VTCR_EL2_TG0_MASK) {
+	case VTCR_EL2_TG0_4K:
+		wi->pgshift = 12;	 break;
+	case VTCR_EL2_TG0_16K:
+		wi->pgshift = 14;	 break;
+	case VTCR_EL2_TG0_64K:
+	default:	    /* IMPDEF: treat any other value as 64k */
+		wi->pgshift = 16;	 break;
+	}
+
+	wi->pgsize = BIT(wi->pgshift);
+	wi->ps = FIELD_GET(VTCR_EL2_PS_MASK, vtcr);
+	wi->sl = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
+	wi->max_ipa_bits = VTCR_EL2_IPA(vtcr);
+	/* Global limit for now, should eventually be per-VM */
+	wi->max_pa_bits = get_kvm_ipa_limit();
+}
+
+int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
+		       struct kvm_s2_trans *result)
+{
+	u64 vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
+	struct s2_walk_info wi;
+	int ret;
+
+	result->esr = 0;
+
+	if (!vcpu_has_nv(vcpu))
+		return 0;
+
+	wi.read_desc = read_guest_s2_desc;
+	wi.data = vcpu;
+	wi.baddr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
+
+	vtcr_to_walk_info(vtcr, &wi);
+
+	wi.be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
+
+	ret = walk_nested_s2_pgd(gipa, &wi, result);
+	if (ret)
+		result->esr |= (kvm_vcpu_get_esr(vcpu) & ~ESR_ELx_FSC);
+
+	return ret;
+}
+
 struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
-- 
2.39.2


