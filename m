Return-Path: <kvm+bounces-19686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45365908DC1
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 16:46:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A246D1F233CB
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 14:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1443145005;
	Fri, 14 Jun 2024 14:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="buPgvgcw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27B44A22;
	Fri, 14 Jun 2024 14:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718376377; cv=none; b=kl0ypcclXATGP+ezm4EofXeyX4fK5ieCYfyXiB4bwDDkvcY/E4n5utxzlvSxyQ+QHjOn3QPmCm81YBcllM97M9/8zobi0hyTvHSAdlOXKdNQMYxJqh45rH9hb+4v77Xtji83GwN0jIpY6Sf9/S1Tk0lk3g4HO/eyYEbzXtGJ6KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718376377; c=relaxed/simple;
	bh=qxOd1g386ZnUPeAZXlZxq/wPbDs9wDu8KbyUnvcmyho=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TAmiG8CvW5vuhdX/me/k6QojBcJOB+XxPQ478d5Xyu1BsaOthekMErOIbq4Tj8cUJ35I2WPKczHjz3bQiMTDnlHIeNRnSXWCts1Vto0T2dSCPutSkSecCsIG/jRU9JlmBS1oW8zDpWmhBC4nxX5SPIoNeTXnLvqDK/S4/W7TPJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=buPgvgcw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAF8C4AF1D;
	Fri, 14 Jun 2024 14:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718376376;
	bh=qxOd1g386ZnUPeAZXlZxq/wPbDs9wDu8KbyUnvcmyho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=buPgvgcwLOkKPVWj2iX4preOPfxJCXbER0bCqlxdV7yksnyqnEWbi+i0gO9PiuScx
	 BNI68o+e1/cQIuAQN1eIQ2UIhT7pyeLM9AVkiENmgmap/45+6TM23VsMJi5KpbGmpj
	 boUEKUDiJTw3IcaFe6es1EwJ6hEJLZaAahuM50C6IzDzOix79aurrLLjdYUHz+GVBx
	 dTm4E57OSyJPHPNm0Lw01BRRhaf46Mo9lkFVKW6gjcMmbDpQ9xodSERL0I/k8/ShjU
	 eP1Dhm5rfz3O1cO9WhJzhvSf8E7ilJea400SAvuCEnDrp6rLviXX892V5oC93fIH17
	 8SDwoiL1iOZtw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sI8By-003wb4-OC;
	Fri, 14 Jun 2024 15:46:14 +0100
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
Subject: [PATCH v3 05/16] KVM: arm64: nv: Add Stage-1 EL2 invalidation primitives
Date: Fri, 14 Jun 2024 15:45:41 +0100
Message-Id: <20240614144552.2773592-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240614144552.2773592-1-maz@kernel.org>
References: <20240614144552.2773592-1-maz@kernel.org>
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

Provide the primitives required to handle TLB invalidation for
Stage-1 EL2 TLBs, which by definition do not require messing
with the Stage-2 page tables.

Co-developed-by: Jintack Lim <jintack.lim@linaro.org>
Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h |  2 +
 arch/arm64/kvm/hyp/vhe/tlb.c     | 65 ++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index a6330460d9e5..2181a11b9d92 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -232,6 +232,8 @@ extern void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 					phys_addr_t start, unsigned long pages);
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
 
+extern int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding);
+
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 5fa0359f3a87..75aa36465805 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -219,3 +219,68 @@ void __kvm_flush_vm_context(void)
 	__tlbi(alle1is);
 	dsb(ish);
 }
+
+/*
+ * TLB invalidation emulation for NV. For any given instruction, we
+ * perform the following transformtions:
+ *
+ * - a TLBI targeting EL2 S1 is remapped to EL1 S1
+ * - a non-shareable TLBI is upgraded to being inner-shareable
+ */
+int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding)
+{
+	struct tlb_inv_context cxt;
+	int ret = 0;
+
+	/*
+	 * The guest will have provided its own DSB ISHST before trapping.
+	 * If it hasn't, that's its own problem, and we won't paper over it
+	 * (plus, there is plenty of extra synchronisation before we even
+	 * get here...).
+	 */
+
+	if (mmu)
+		enter_vmid_context(mmu, &cxt);
+
+	switch (sys_encoding) {
+	case OP_TLBI_ALLE2:
+	case OP_TLBI_ALLE2IS:
+	case OP_TLBI_VMALLE1:
+	case OP_TLBI_VMALLE1IS:
+		__tlbi(vmalle1is);
+		break;
+	case OP_TLBI_VAE2:
+	case OP_TLBI_VAE2IS:
+	case OP_TLBI_VAE1:
+	case OP_TLBI_VAE1IS:
+		__tlbi(vae1is, va);
+		break;
+	case OP_TLBI_VALE2:
+	case OP_TLBI_VALE2IS:
+	case OP_TLBI_VALE1:
+	case OP_TLBI_VALE1IS:
+		__tlbi(vale1is, va);
+		break;
+	case OP_TLBI_ASIDE1:
+	case OP_TLBI_ASIDE1IS:
+		__tlbi(aside1is, va);
+		break;
+	case OP_TLBI_VAAE1:
+	case OP_TLBI_VAAE1IS:
+		__tlbi(vaae1is, va);
+		break;
+	case OP_TLBI_VAALE1:
+	case OP_TLBI_VAALE1IS:
+		__tlbi(vaale1is, va);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	dsb(ish);
+	isb();
+
+	if (mmu)
+		exit_vmid_context(&cxt);
+
+	return ret;
+}
-- 
2.39.2


