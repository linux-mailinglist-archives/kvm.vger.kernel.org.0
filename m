Return-Path: <kvm+bounces-18561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE678D6CC5
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 01:14:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EBC81C2401D
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 23:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AB8A130486;
	Fri, 31 May 2024 23:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AeGkZ8V6"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038DE12F5B8
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 23:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717197263; cv=none; b=XlgtZktyPKWUCQC+9lE6+ymWmJOZBWT+dpXscNuo2gGdxEFqRogab2Q5nSSTlxNDnRVRT0EEClJ48PdzhMrx0AuS7VH/KKZ062kFNiavxBFKvdXtxBpQwSd3NlET9Zu5uL00jgUlXCjD51ZYtKuy1USC4/RPcl5R7dpu4jJCuJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717197263; c=relaxed/simple;
	bh=6D8D9i3XydQ+ncxh2tn2cwLi/WZrfPVtOsD55yigttk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pm3yHQkLg3xA/L6gQk9F+APmReqbSM/k5osRMkdK7BtjiPFJrdfz22PSDirNRdsQqVPBjJg/h51EPQt9jwiIHsa7Z/1zkRvgG3mXzVLiO1s69iEvzwll2nEq1BArj7i0g53WgbNirpClHXCbfCrGK4cDWkykYkx8JDqkpX+QSKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AeGkZ8V6; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717197260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=75vx2xB9G5elNFx0s0w58jNdeKZ7431l9UtTNZ3JoLI=;
	b=AeGkZ8V6qH123pi/2ON6eEU4ZxQHMkyQSxnpI/nu32ea1Q5IRnUdISmt66aoGphk6RBG/r
	lmjV99oUot34W+ghks1l7BCoFhsjyr2rLXsA0m4Xg+loSNgJjECqKa2xyHmVlK5b5FOn1a
	mYqCHO+4Aiw47HUh1eL2RjctdV7O5gc=
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
Subject: [PATCH 04/11] KVM: arm64: nv: Load guest hyp's ZCR into EL1 state
Date: Fri, 31 May 2024 23:13:51 +0000
Message-ID: <20240531231358.1000039-5-oliver.upton@linux.dev>
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
index 5872eaafc7f0..e1e888340739 100644
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
2.45.1.288.g0e0cd299f1-goog


