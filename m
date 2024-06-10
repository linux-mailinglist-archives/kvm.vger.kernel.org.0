Return-Path: <kvm+bounces-19211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B684902303
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 15:50:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5B031F22F84
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 13:50:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A07154C00;
	Mon, 10 Jun 2024 13:43:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B622982D9F;
	Mon, 10 Jun 2024 13:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718027019; cv=none; b=tbzguvAqScPI7J8amSrg8qxfRYcO/vYivWqZPKfuspkZ1HdbgSVFmngUhG6iA4Gy/CjcnCGoL+OEWjSZhTiQsq4V7It1Ks4uNcw6cd+6gBv0bOVp1czKe/jFZJD6fcQ1+Rgmd8wy8IilD1ElnJXBFF21em1cAz0eBfMVwbgu0EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718027019; c=relaxed/simple;
	bh=hvWKx2/cH7WbDpxK1un3tT1XovoT8FW3TCS9EIPyA9s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZXahrRaUKYyJ0wg4358U32SSWD3/VeX7V4YcL3ecq/O/tArw5MeOaTPjYzxXhWLqHLmkaTdoNes3/Xr7d5b+FA9lB1W63dUmbZCszVEykRUuAqze9pEDP4tLyDu4PIl9rRsbjZUCFfy2OZ2/COOEye+CB2hoWqcdb89F6MF3e00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9523E106F;
	Mon, 10 Jun 2024 06:44:01 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 133583F58B;
	Mon, 10 Jun 2024 06:43:33 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v3 24/43] KVM: arm64: Handle Realm PSCI requests
Date: Mon, 10 Jun 2024 14:41:43 +0100
Message-Id: <20240610134202.54893-25-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240610134202.54893-1-steven.price@arm.com>
References: <20240610134202.54893-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RMM needs to be informed of the target REC when a PSCI call is made
with an MPIDR argument. Expose an ioctl to the userspace in case the PSCI
is handled by it.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_rme.h |  3 +++
 arch/arm64/kvm/arm.c             | 25 +++++++++++++++++++++++++
 arch/arm64/kvm/psci.c            | 29 +++++++++++++++++++++++++++++
 arch/arm64/kvm/rme.c             | 15 +++++++++++++++
 4 files changed, 72 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index c50854f44674..5492e60aa8de 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -117,6 +117,9 @@ int realm_set_ipa_state(struct kvm_vcpu *vcpu,
 			unsigned long addr, unsigned long end,
 			unsigned long ripas,
 			unsigned long *top_ipa);
+int realm_psci_complete(struct kvm_vcpu *calling,
+			struct kvm_vcpu *target,
+			unsigned long status);
 
 #define RME_RTT_BLOCK_LEVEL	2
 #define RME_RTT_MAX_LEVEL	3
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index aa57aa8cab4e..77ea231cfb04 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1718,6 +1718,22 @@ static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 	return __kvm_arm_vcpu_set_events(vcpu, events);
 }
 
+static int kvm_arm_vcpu_rmm_psci_complete(struct kvm_vcpu *vcpu,
+					  struct kvm_arm_rmm_psci_complete *arg)
+{
+	struct kvm_vcpu *target = kvm_mpidr_to_vcpu(vcpu->kvm, arg->target_mpidr);
+
+	if (!target)
+		return -EINVAL;
+
+	/*
+	 * RMM v1.0 only supports PSCI_RET_SUCCESS or PSCI_RET_DENIED
+	 * for the status. But, let us leave it to the RMM to filter
+	 * for making this future proof.
+	 */
+	return realm_psci_complete(vcpu, target, arg->psci_status);
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -1840,6 +1856,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 		return kvm_arm_vcpu_finalize(vcpu, what);
 	}
+	case KVM_ARM_VCPU_RMM_PSCI_COMPLETE: {
+		struct kvm_arm_rmm_psci_complete req;
+
+		if (!kvm_is_realm(vcpu->kvm))
+			return -EINVAL;
+		if (copy_from_user(&req, argp, sizeof(req)))
+			return -EFAULT;
+		return kvm_arm_vcpu_rmm_psci_complete(vcpu, &req);
+	}
 	default:
 		r = -EINVAL;
 	}
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 1f69b667332b..f9abab5d50d7 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -103,6 +103,12 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 
 	reset_state->reset = true;
 	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
+	/*
+	 * Make sure we issue PSCI_COMPLETE before the VCPU can be
+	 * scheduled.
+	 */
+	if (vcpu_is_rec(vcpu))
+		realm_psci_complete(source_vcpu, vcpu, PSCI_RET_SUCCESS);
 
 	/*
 	 * Make sure the reset request is observed if the RUNNABLE mp_state is
@@ -115,6 +121,10 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 
 out_unlock:
 	spin_unlock(&vcpu->arch.mp_state_lock);
+	if (vcpu_is_rec(vcpu) && ret != PSCI_RET_SUCCESS)
+		realm_psci_complete(source_vcpu, vcpu,
+				    ret == PSCI_RET_ALREADY_ON ?
+				    PSCI_RET_SUCCESS : PSCI_RET_DENIED);
 	return ret;
 }
 
@@ -142,6 +152,25 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 	/* Ignore other bits of target affinity */
 	target_affinity &= target_affinity_mask;
 
+	if (vcpu_is_rec(vcpu)) {
+		struct kvm_vcpu *target_vcpu;
+
+		/* RMM supports only zero affinity level */
+		if (lowest_affinity_level != 0)
+			return PSCI_RET_INVALID_PARAMS;
+
+		target_vcpu = kvm_mpidr_to_vcpu(kvm, target_affinity);
+		if (!target_vcpu)
+			return PSCI_RET_INVALID_PARAMS;
+
+		/*
+		 * Provide the references of running and target RECs to the RMM
+		 * so that the RMM can complete the PSCI request.
+		 */
+		realm_psci_complete(vcpu, target_vcpu, PSCI_RET_SUCCESS);
+		return PSCI_RET_SUCCESS;
+	}
+
 	/*
 	 * If one or more VCPU matching target affinity are running
 	 * then ON else OFF
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 337b3dd1e00c..45d49d12a34c 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -95,6 +95,21 @@ static void free_delegated_page(struct realm *realm, phys_addr_t phys)
 	free_page((unsigned long)phys_to_virt(phys));
 }
 
+int realm_psci_complete(struct kvm_vcpu *calling, struct kvm_vcpu *target,
+			unsigned long status)
+{
+	int ret;
+
+	ret = rmi_psci_complete(virt_to_phys(calling->arch.rec.rec_page),
+				virt_to_phys(target->arch.rec.rec_page),
+				status);
+
+	if (ret)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int realm_rtt_create(struct realm *realm,
 			    unsigned long addr,
 			    int level,
-- 
2.34.1


