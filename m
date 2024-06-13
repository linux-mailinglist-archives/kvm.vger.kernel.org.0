Return-Path: <kvm+bounces-19627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A0B6907D5B
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 22:19:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3505BB22B18
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 20:19:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C39C13BAE7;
	Thu, 13 Jun 2024 20:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PJZ5MR37"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7839D13BAC6
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 20:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718309931; cv=none; b=X3LVQE/KqNvolxN9w20svkngbNOejp+4nbkwsBV4VQeM6EBenNIPSdvbc/yQeObFuUyfXrP2aPiDAOsORCc8AaVrScChcIGfxctKMzn5237jzO3rRlcmbxsb2gUfL2SNPhg50gqC557oGpmRYoMdi2XMcavzfMBjMrPa3uy7SP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718309931; c=relaxed/simple;
	bh=Z5HK4DtD6XDVRFZ9PDJseMqSOWjdLR9OlS0/BOVAR8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBkDbG4m9GNjEf2vBMbiNmZzhHAZjriKizO4ScSD+QMKTph5N+y7BxyuAnnZGKGP3u3NpblFnAeTbkXalLiEaJYxsyC7peOvFfRLwszaw6kOBdzP3ikIGE4v0cgetAu2u8bmjL82YemCoQ5N/NPNJvcIqdtrJkp1UB3jcD63pLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PJZ5MR37; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718309928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L6HDoJfx/rDOB71SSyN+wyy9X8fDW3NwKLqxSG3jeWA=;
	b=PJZ5MR370WZedzhYosgd5lpImaGQGgruZm2IIwtMPWLVJDYRAFrluiOZ80dmmUdQk2BdoF
	bsmGLPrG/iMJ9H1zIGQJW2QzJLkNQX0pprp6v+OcpKV85SNl7RgdIesPMU2ziKiBDtBgtH
	WizEjX4hT1/z3wbAgQcSKB3dP5VpBy4=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 10/15] KVM: arm64: Spin off helper for programming CPTR traps
Date: Thu, 13 Jun 2024 20:17:51 +0000
Message-ID: <20240613201756.3258227-11-oliver.upton@linux.dev>
In-Reply-To: <20240613201756.3258227-1-oliver.upton@linux.dev>
References: <20240613201756.3258227-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A subsequent change to KVM will add preliminary support for merging a
guest hypervisor's CPTR traps with that of KVM. Prepare by spinning off
a new helper for managing CPTR traps.

Avoid reading CPACR_EL1 for the baseline trap config, and start off with
the most restrictive set of traps that is subsequently relaxed.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 49 ++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index f6e5ecd8b310..925de4b4efd2 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -65,6 +65,29 @@ static u64 __compute_hcr(struct kvm_vcpu *vcpu)
 	return hcr | (__vcpu_sys_reg(vcpu, HCR_EL2) & ~NV_HCR_GUEST_EXCLUDE);
 }
 
+static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * With VHE (HCR.E2H == 1), accesses to CPACR_EL1 are routed to
+	 * CPTR_EL2. In general, CPACR_EL1 has the same layout as CPTR_EL2,
+	 * except for some missing controls, such as TAM.
+	 * In this case, CPTR_EL2.TAM has the same position with or without
+	 * VHE (HCR.E2H == 1) which allows us to use here the CPTR_EL2.TAM
+	 * shift value for trapping the AMU accesses.
+	 */
+	u64 val = CPACR_ELx_TTA | CPTR_EL2_TAM;
+
+	if (guest_owns_fp_regs()) {
+		val |= CPACR_ELx_FPEN;
+		if (vcpu_has_sve(vcpu))
+			val |= CPACR_ELx_ZEN;
+	} else {
+		__activate_traps_fpsimd32(vcpu);
+	}
+
+	write_sysreg(val, cpacr_el1);
+}
+
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
@@ -91,31 +114,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	val = read_sysreg(cpacr_el1);
-	val |= CPACR_ELx_TTA;
-	val &= ~(CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN |
-		 CPACR_EL1_SMEN_EL0EN | CPACR_EL1_SMEN_EL1EN);
-
-	/*
-	 * With VHE (HCR.E2H == 1), accesses to CPACR_EL1 are routed to
-	 * CPTR_EL2. In general, CPACR_EL1 has the same layout as CPTR_EL2,
-	 * except for some missing controls, such as TAM.
-	 * In this case, CPTR_EL2.TAM has the same position with or without
-	 * VHE (HCR.E2H == 1) which allows us to use here the CPTR_EL2.TAM
-	 * shift value for trapping the AMU accesses.
-	 */
-
-	val |= CPTR_EL2_TAM;
-
-	if (guest_owns_fp_regs()) {
-		if (vcpu_has_sve(vcpu))
-			val |= CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
-	} else {
-		val &= ~(CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN);
-		__activate_traps_fpsimd32(vcpu);
-	}
-
-	write_sysreg(val, cpacr_el1);
+	__activate_cptr_traps(vcpu);
 
 	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el1);
 }
-- 
2.45.2.627.g7a2c4fd464-goog


