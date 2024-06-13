Return-Path: <kvm+bounces-19622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 57F68907D56
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 22:19:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A14F1C243FD
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 20:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5A2213B586;
	Thu, 13 Jun 2024 20:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eVzlLU7n"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC9D13B2A8
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 20:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718309922; cv=none; b=r+aPqS57GkH6e5ZRMY30GTW8TyzeNV8x1k5DZ1EElNFlAbLilhdRPlInHY3kZGeRHyKpwUjdM54ikJOuOT8gU0nN2IIiVsBstnKjNtwQDTGqH4mRLraKRYyik6Addb/piTmp1YOarmhVY8UpgM1ul78JNVWq4CZeMN3bftF9Pc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718309922; c=relaxed/simple;
	bh=pG5B1IPQE0BjCE1GIuF9fsSNcHsEFhIpr144bsSE+y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQr+HYfuCI6K1vDJoFDafOTtuufs5qsS3itoXf/t/OubmfTjPlQ5TRuTW97SO3f/rxA7qVrfZs/k9mG2swW+iWHDxR4iOmbBhADeLA/HnM1KUeD5cc3lqZGcNPKAWSCiSU0wQ0B/X0ypzRotXORz58LVWvYiTG+NURM7Mi5ukfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eVzlLU7n; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718309918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KwkNuLdV08wQ9dtQtrJ/mjJaun+fIMs2MrW9qbIU49E=;
	b=eVzlLU7n3iCPuctbt7bbVIRUo9kwY32Wsh4kMZWELRAbBMjwE3nPeHZBZngJt8ejvq3ijf
	MAFsrWeLomrdblApAVdE9PQvjoauJguYnaV8vMkSvsX+bvPUDgiZ0nJMT+VfCZJf1Pq7MH
	anBMboiJIx4Y+6/Ui/Dd1S/YC3YoMt0=
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
Subject: [PATCH v2 05/15] KVM: arm64: nv: Load guest hyp's ZCR into EL1 state
Date: Thu, 13 Jun 2024 20:17:46 +0000
Message-ID: <20240613201756.3258227-6-oliver.upton@linux.dev>
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

Load the guest hypervisor's ZCR_EL2 into the corresponding EL1 register
when restoring SVE state, as ZCR_EL2 affects the VL in the hypervisor
context.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h       | 4 ++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8170c04fde91..e01e6de414f1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -844,6 +844,10 @@ struct kvm_vcpu_arch {
 
 #define vcpu_sve_max_vq(vcpu)	sve_vq_from_vl((vcpu)->arch.sve_max_vl)
 
+#define vcpu_sve_zcr_el1(vcpu)						\
+	(unlikely(is_hyp_ctxt(vcpu)) ? __vcpu_sys_reg(vcpu, ZCR_EL2) :	\
+				       __vcpu_sys_reg(vcpu, ZCR_EL1))
+
 #define vcpu_sve_state_size(vcpu) ({					\
 	size_t __size_ret;						\
 	unsigned int __vcpu_vq;						\
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 5ecd2600d9df..71a93e336a0c 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -317,7 +317,8 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
 	__sve_restore_state(vcpu_sve_pffr(vcpu),
 			    &vcpu->arch.ctxt.fp_regs.fpsr);
-	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
+
+	write_sysreg_el1(vcpu_sve_zcr_el1(vcpu), SYS_ZCR);
 }
 
 /*
-- 
2.45.2.627.g7a2c4fd464-goog


