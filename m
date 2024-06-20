Return-Path: <kvm+bounces-20128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71949910D7C
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 18:48:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2E271C221E9
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B3871B47C7;
	Thu, 20 Jun 2024 16:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xNNpJcci"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20EC1B47B2
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 16:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718902040; cv=none; b=dyA0f3Rsb096W9vX9K9aUVuO5uysabnVMKF05VVfLKaC9osgCemnTqdtBgd7blXy3mG6t8Lbb0wSV1nA8FY0JNhzEy94Re8BGgjpJiprJ+X+ttADEvJErmurZNriHZJ8C4b79Ol2Py+7BF8WZVhXsp49/SJgDDKgXbLdr4oIbkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718902040; c=relaxed/simple;
	bh=eHFcSnx/FrqvvY+4VU8ze04GVmd2fbF4l7dDs6USX/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjI58B2WSNpzO0sPuZ4t2a1PXCy88bKp6qiom73cbByxsP4nXGOskprZTt1exVYfIr99M2GmjPKR7tQWKgBbb9Czbb0gYVqfLoFeEwtvSdymL9NC0/4K+m3EK8lGeOYi+NbILrIBcGXVbTVZNK3yh9kfhUuuKhL0OCFQCgYfwxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xNNpJcci; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718902037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cStQMLZGUlCbmuI60XeY0OY25KBZNZcrijUKFbj3MYQ=;
	b=xNNpJcci+IX/dKs2+h8LpwC8LyofKfTBiVRoLC0USlzPbHawItPjiRUAmyBNcwiOaz1SDt
	PRKwlY4AQMYs7DcF0S7Xg4eUt6hJEl+zkXrajRewuJ8m234VLszNqc6Lp7oDXiKdx1GePQ
	1qNIX14kE/2+3pWBH6kjhI1uZOYI+aw=
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
Subject: [PATCH v3 08/15] KVM: arm64: Spin off helper for programming CPTR traps
Date: Thu, 20 Jun 2024 16:46:45 +0000
Message-ID: <20240620164653.1130714-9-oliver.upton@linux.dev>
In-Reply-To: <20240620164653.1130714-1-oliver.upton@linux.dev>
References: <20240620164653.1130714-1-oliver.upton@linux.dev>
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

Reviewed-by: Marc Zyngier <maz@kernel.org>
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
2.45.2.741.gdbec12cfda-goog


