Return-Path: <kvm+bounces-19628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85148907D5C
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 22:19:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DEF61C23F2F
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 20:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C88213C832;
	Thu, 13 Jun 2024 20:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CINM/8cW"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7A913BAD9
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 20:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718309933; cv=none; b=u/EsX9L8KXE8ys1DhKl1EtFDZXaLOpdJpi/S5MRbJwinp+tEygQLua31uGEf2FGj/LRA788/SgHc9ks8XRpTyE+v/u/pVI0B8Tiy9oHuwJHBaelf+YT+DzhfPcoUkj97o83xB+ahbHCjcSk/AiWR+CEAbJQ3h4v+xMS5kssVEKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718309933; c=relaxed/simple;
	bh=1gQ3VJDYhI3w4SWiYVcsOD8IwGrYRiv41a2jO6SUv14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvZaclmWnpw1I3PphXplnUcWICKByH2Bq1ByZa94naiMS/1Z0PWVhaAbXnJeCsA/y3/V0BlEJ1qKpQKRKCFsEjacVLTNbjQsShosV5nKLf3l0LXXCY2AJ5GvY/eTyR3z+nf6h6KGeKAtRZEB00D68U+r0w8jaxJvdfcmQRaRuQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CINM/8cW; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718309930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mgvqC7WLJslUQDWVjGnfKGGRyKxketT5brA13gOHVto=;
	b=CINM/8cWnYHxX8TDH255lzbUrTIAdQIaZGK0pZq2tYDXKPdPgs2wYgBspeEyZWNDURBEBG
	Dj9FoqitEUn7igmDyljujKs0OxPgYRUlMdg8yM2GxPDgC7c3CxJ1lbAX3+TikI4B9Lk1it
	XKfb1PfudV1vfnV5fGJSzlVUnqrr3tw=
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
Subject: [PATCH v2 11/15] KVM: arm64: nv: Honor guest hypervisor's FP/SVE traps in CPTR_EL2
Date: Thu, 13 Jun 2024 20:17:52 +0000
Message-ID: <20240613201756.3258227-12-oliver.upton@linux.dev>
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

Start folding the guest hypervisor's FP/SVE traps into the value
programmed in hardware. Note that as of writing this is dead code, since
KVM does a full put() / load() for every nested exception boundary which
saves + flushes the FP/SVE state.

However, this will become useful when we can keep the guest's FP/SVE
state alive across a nested exception boundary and the host no longer
needs to conservatively program traps.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 925de4b4efd2..b0b1935a3626 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -67,6 +67,8 @@ static u64 __compute_hcr(struct kvm_vcpu *vcpu)
 
 static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 {
+	u64 cptr;
+
 	/*
 	 * With VHE (HCR.E2H == 1), accesses to CPACR_EL1 are routed to
 	 * CPTR_EL2. In general, CPACR_EL1 has the same layout as CPTR_EL2,
@@ -85,6 +87,35 @@ static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 		__activate_traps_fpsimd32(vcpu);
 	}
 
+	/*
+	 * Layer the guest hypervisor's trap configuration on top of our own if
+	 * we're in a nested context.
+	 */
+	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
+		goto write;
+
+	cptr = vcpu_sanitised_cptr_el2(vcpu);
+
+	/*
+	 * Pay attention, there's some interesting detail here.
+	 *
+	 * The CPTR_EL2.xEN fields are 2 bits wide, although there are only two
+	 * meaningful trap states when HCR_EL2.TGE = 0 (running a nested guest):
+	 *
+	 *  - CPTR_EL2.xEN = x0, traps are enabled
+	 *  - CPTR_EL2.xEN = x1, traps are disabled
+	 *
+	 * In other words, bit[0] determines if guest accesses trap or not. In
+	 * the interest of simplicity, clear the entire field if the guest
+	 * hypervisor has traps enabled to dispel any illusion of something more
+	 * complicated taking place.
+	 */
+	if (!(SYS_FIELD_GET(CPACR_ELx, FPEN, cptr) & BIT(0)))
+		val &= ~CPACR_ELx_FPEN;
+	if (!(SYS_FIELD_GET(CPACR_ELx, ZEN, cptr) & BIT(0)))
+		val &= ~CPACR_ELx_ZEN;
+
+write:
 	write_sysreg(val, cpacr_el1);
 }
 
-- 
2.45.2.627.g7a2c4fd464-goog


