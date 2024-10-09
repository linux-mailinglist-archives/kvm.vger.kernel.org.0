Return-Path: <kvm+bounces-28344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D75997554
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:04:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33B571F216A1
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B40A01E9065;
	Wed,  9 Oct 2024 19:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hyH4lb82"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D385F1E7C3E;
	Wed,  9 Oct 2024 19:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500449; cv=none; b=P63AvvhSvozGgVlmOUha68fqAowglO1r0GABONjuxFd/0qcbxVen+ChZ4+CAj/S/6XQIPyVEfHaDDihkfdLLdqd/ZAucoTPqK3CZvYxqNcyaZWT/LoswvhDIfz2pamyRpYWOa4Y8qFM25vXCm9Cuj4J50frltRvbF7E8Mi5yzzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500449; c=relaxed/simple;
	bh=V1xKLMdx1CEKIaDPkTkjz5EYFw+JZUJEYia7tstoCfs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lk5yfn+wvThwb1zJ6NQ6XgWKeJButoPZVVvoPofT88pv1QhPnNQIIajaP117AjW9GeFFoKnprwcmTo2ft7Zk9VfVqBsU7ND63vvZwyZkY/CyzhqQs7CKtg9m8aDm8sBvP2BbGAhbRs/JB4b5YHAz97zP03ZupeSMh2Oo4urUy58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hyH4lb82; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D58C4CECC;
	Wed,  9 Oct 2024 19:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500449;
	bh=V1xKLMdx1CEKIaDPkTkjz5EYFw+JZUJEYia7tstoCfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hyH4lb82+thyIiIeTe9F8okEOZjdEwYKmt6gkjMYbIOh5oqVtkCBEYCuY8q5btZDC
	 lcHU/LP26hxw9XroFU+qZAgE0EyTZHvgrkmr1gh1KNYN2wuFfg/iAteEnx6IiQO8UV
	 emZtFercWylVCEosb/3A6MpG2rg777LKVYkwfTN5Yj5EYCX6AQu9fLrsBoPAeyeQFj
	 J06T9iJkMkykP80iLaYyLc8q1IiN4Id8wJ+ARafsuu4I+MyNhmr+LHPSporE/CQlou
	 KACehXEhebnK8JVdo6JYJ9P5y/wB+8OCMz65rYCEd7Z1exFJcqZ8IPCT/Dur0g4Ksg
	 doAnYsBds9sdA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvT-001wcY-Dc;
	Wed, 09 Oct 2024 20:00:47 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 32/36] KVM: arm64: Add POE save/restore for AT emulation fast-path
Date: Wed,  9 Oct 2024 20:00:15 +0100
Message-Id: <20241009190019.3222687-33-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241009190019.3222687-1-maz@kernel.org>
References: <20241009190019.3222687-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Just like the other extensions affecting address translation,
we must save/restore POE so that an out-of-context translation
context can be restored and used with the AT instructions.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 3d93ed1795603..4921284eeedff 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -440,6 +440,8 @@ struct mmu_config {
 	u64	tcr2;
 	u64	pir;
 	u64	pire0;
+	u64	por_el0;
+	u64	por_el1;
 	u64	sctlr;
 	u64	vttbr;
 	u64	vtcr;
@@ -458,6 +460,10 @@ static void __mmu_config_save(struct mmu_config *config)
 			config->pir	= read_sysreg_el1(SYS_PIR);
 			config->pire0	= read_sysreg_el1(SYS_PIRE0);
 		}
+		if (system_supports_poe()) {
+			config->por_el1	= read_sysreg_el1(SYS_POR);
+			config->por_el0	= read_sysreg_s(SYS_POR_EL0);
+		}
 	}
 	config->sctlr	= read_sysreg_el1(SYS_SCTLR);
 	config->vttbr	= read_sysreg(vttbr_el2);
@@ -485,6 +491,10 @@ static void __mmu_config_restore(struct mmu_config *config)
 			write_sysreg_el1(config->pir, SYS_PIR);
 			write_sysreg_el1(config->pire0, SYS_PIRE0);
 		}
+		if (system_supports_poe()) {
+			write_sysreg_el1(config->por_el1, SYS_POR);
+			write_sysreg_s(config->por_el0, SYS_POR_EL0);
+		}
 	}
 	write_sysreg_el1(config->sctlr,	SYS_SCTLR);
 	write_sysreg(config->vttbr,	vttbr_el2);
@@ -1105,6 +1115,10 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIR_EL1), SYS_PIR);
 			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIRE0_EL1), SYS_PIRE0);
 		}
+		if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1POE, IMP)) {
+			write_sysreg_el1(vcpu_read_sys_reg(vcpu, POR_EL1), SYS_POR);
+			write_sysreg_s(vcpu_read_sys_reg(vcpu, POR_EL0), SYS_POR_EL0);
+		}
 	}
 	write_sysreg_el1(vcpu_read_sys_reg(vcpu, SCTLR_EL1),	SYS_SCTLR);
 	__load_stage2(mmu, mmu->arch);
-- 
2.39.2


