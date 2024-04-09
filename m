Return-Path: <kvm+bounces-14013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C20C089E1E9
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 19:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F35661C21A93
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 17:55:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80CCF156C59;
	Tue,  9 Apr 2024 17:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YKS+TzHa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE1F156894;
	Tue,  9 Apr 2024 17:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712685322; cv=none; b=QPhu7GvVmpIHq5Fh215FL32EXKKk1H45HNkEjly5S4fPol/PVnYGTNFL+5VotL9yYy0w7KQkjB9FPt6qg4U0e80y0Hb1VVeTSwGNXJd2rBApcGUeIoZnbVCUxlJNpwtO546xA4n8cyj6r6xCK+hc6d2eJYiTX05YovSdKXPfWys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712685322; c=relaxed/simple;
	bh=MbSICqkJzFStWUQy0NsOnkYwLTmMPFQpz5H6hKUnyCg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mg4VZRgN8b6/vEBkarGvIbgXuaTaoCZd/O2rejQ5FA13Ue7vIiYZS0Re9MEnjbg+QPmtA5Al/VPcOwBbVWF1SIn8rUgihPw8U6VZNBAC+URvUvRrnZjZhiEQl7xaOIYZHIgaxyBSYYs52rYFDeObWhaXUIbIfP7ls9NZ5KcasGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YKS+TzHa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D17CC43390;
	Tue,  9 Apr 2024 17:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712685322;
	bh=MbSICqkJzFStWUQy0NsOnkYwLTmMPFQpz5H6hKUnyCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YKS+TzHaISKIIPKABi+3oxBab1lth92+suuoySXhD/BcOMBpSL8W/xHx4vVr+f23X
	 vXwPvT4QoXseliUC3vVuWGLAJmpoyt8yhJ96ABDZpRxNdCLvIvYoz3BeXzESP1lhkZ
	 BHRMYE67q9ELEtOCFECt4mMLgrSVcvJd6U21PONFGLEIGCyoUfH7RI4E//QHee4Y/1
	 LZNWKjJEjwDrcZxmuq4n8wEQqr91HIeelRrS9paAKqg6qCxLYFAdthPIQRkCVcT3Mi
	 npCpi8v4WCGH0CMxZuq+iE9k8gXC8xcTSmmH8YdeJAo7WNEgh7Uo8byqRAc6I9MnEl
	 rice++Cx6Z1WA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ruFgm-002szC-N5;
	Tue, 09 Apr 2024 18:55:20 +0100
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
	Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 05/16] KVM: arm64: nv: Add Stage-1 EL2 invalidation primitives
Date: Tue,  9 Apr 2024 18:54:37 +0100
Message-Id: <20240409175448.3507472-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240409175448.3507472-1-maz@kernel.org>
References: <20240409175448.3507472-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com
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
index 24b5e6b23417..38644fa648fa 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -234,6 +234,8 @@ extern void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 					phys_addr_t start, unsigned long pages);
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
 
+extern int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding);
+
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 1a60b95381e8..7ffc3f4b09f0 100644
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
+		__tlb_switch_to_guest(mmu, &cxt);
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
+		__tlb_switch_to_host(&cxt);
+
+	return ret;
+}
-- 
2.39.2


