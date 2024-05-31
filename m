Return-Path: <kvm+bounces-18566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F2758D6CCA
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 01:15:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3CF1B2578A
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 23:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 223371339A4;
	Fri, 31 May 2024 23:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="F1Ivev/p"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE84F132128
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 23:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717197272; cv=none; b=u+Wn3iRchGhdbN9rumHbMRAugT+crHmDXj0J9SK9FW35NOxBS46pFQsg1u6IOJ/zTgMaYayiNmPPGoCs2SXQPN7tvTHTj5nKhWhEb88zjKoae6PpMAN9clAAU9eB3Y+z8eygydF4YaLvZmN2GOB7jxub3zD5KovACjlxOCg8IY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717197272; c=relaxed/simple;
	bh=/vPV6XsCBYymf8jQ15TYS5mo3L1eZ6ECmEoP0aaBhW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWqhL9E48gpVVA5XG4SMq8rx/NpKM82bSaVvg7wp7e7CB0KLuGH6HWWiWvZzQZBCVDC5g2M9wSZ3+vZ/h4jIkUo5EuloFKW75+KNtwzkH99P9R8niTMamNYpyoKC7hXV0BC8AWVZC6dhgkw+tFuQ9g1+HhN9mM1eXUTfAuB/W8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=F1Ivev/p; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717197269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jX+HAuUD+h1pnNqLCXa1MtH1/GNEOwTZYSR4zD8uAjg=;
	b=F1Ivev/pXccrS5amFgWkkYqvxcuNEe6pMOorSgLX+TmCjlbjam0TQdAmVxS8eYbExuHTJ+
	D77JqOofG98OwPVDEtZqcZfezHx5FfXRTNshFrWcwo1b11ognnf84tSuw9JdnsBEpA7PBx
	uZklbtD7GjwB2dvX2PlBStEohY2TXeU=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 09/11] KVM: arm64: Spin off helper for programming CPTR traps
Date: Fri, 31 May 2024 23:13:56 +0000
Message-ID: <20240531231358.1000039-10-oliver.upton@linux.dev>
In-Reply-To: <20240531231358.1000039-1-oliver.upton@linux.dev>
References: <20240531231358.1000039-1-oliver.upton@linux.dev>
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
index d7af5f46f22a..697253673d7b 100644
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
2.45.1.288.g0e0cd299f1-goog


