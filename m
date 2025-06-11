Return-Path: <kvm+bounces-49013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B08A2AD52E8
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 13:00:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 078A93AEE32
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 10:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E319D2DCC06;
	Wed, 11 Jun 2025 10:50:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 939BA2DCBFA;
	Wed, 11 Jun 2025 10:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749639028; cv=none; b=iSBH1N7ZNLk79CZ4iFdeDsPz28qtKDmaxlwjcKsrytvbGxpVq4H40KUM/qb9TLgKqMQEW8eY6Zdbkc1acdVOfoU3HGuLgO/Y2d5wv6eq+l5u/WiHNGHQtvM5/bHB+p52A4l04L9APuxJWjuPBN9l/mA3m11NhslDfXoB/wfSdYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749639028; c=relaxed/simple;
	bh=BGAdAGxGPv/wWM3IShO30N4ErgXmt9zYABu40vkPJdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7L7KIZMgFDiRGnHYmvQSkx7QjEN+2GQ7WSZBZxZ+4iD50i9AtFPMU1YZutB+DPb4KRa3WTh63IOkn14aBgfe3emcH04SgIb6jPtohZeOR/XbBcAC/sl3McKD+txeipBdP+iT7bcjUiXQRoNuUrLl7TS2QZJi00eQBC0MNNVGLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 90EB515A1;
	Wed, 11 Jun 2025 03:50:06 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.67.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 029093F673;
	Wed, 11 Jun 2025 03:50:22 -0700 (PDT)
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>
Subject: [PATCH v9 23/43] KVM: arm64: Handle Realm PSCI requests
Date: Wed, 11 Jun 2025 11:48:20 +0100
Message-ID: <20250611104844.245235-24-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250611104844.245235-1-steven.price@arm.com>
References: <20250611104844.245235-1-steven.price@arm.com>
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
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
Changes since v6:
 * Use vcpu_is_rec() rather than kvm_is_realm(vcpu->kvm).
 * Minor renaming/formatting fixes.
---
 arch/arm64/include/asm/kvm_rme.h |  3 +++
 arch/arm64/kvm/arm.c             | 25 +++++++++++++++++++++++++
 arch/arm64/kvm/psci.c            | 30 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/rme.c             | 14 ++++++++++++++
 4 files changed, 72 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index df88ae51b7c9..2d7d7233c525 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -120,6 +120,9 @@ int realm_map_non_secure(struct realm *realm,
 			 kvm_pfn_t pfn,
 			 unsigned long size,
 			 struct kvm_mmu_memory_cache *memcache);
+int realm_psci_complete(struct kvm_vcpu *source,
+			struct kvm_vcpu *target,
+			unsigned long status);
 
 static inline bool kvm_realm_is_private_address(struct realm *realm,
 						unsigned long addr)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e79829eb5c5b..5502997b7354 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1760,6 +1760,22 @@ static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
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
@@ -1882,6 +1898,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 		return kvm_arm_vcpu_finalize(vcpu, what);
 	}
+	case KVM_ARM_VCPU_RMM_PSCI_COMPLETE: {
+		struct kvm_arm_rmm_psci_complete req;
+
+		if (!vcpu_is_rec(vcpu))
+			return -EPERM;
+		if (copy_from_user(&req, argp, sizeof(req)))
+			return -EFAULT;
+		return kvm_arm_vcpu_rmm_psci_complete(vcpu, &req);
+	}
 	default:
 		r = -EINVAL;
 	}
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 3b5dbe9a0a0e..a68f3c1878a5 100644
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
@@ -115,6 +121,11 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 
 out_unlock:
 	spin_unlock(&vcpu->arch.mp_state_lock);
+	if (vcpu_is_rec(vcpu) && ret != PSCI_RET_SUCCESS) {
+		realm_psci_complete(source_vcpu, vcpu,
+				    ret == PSCI_RET_ALREADY_ON ?
+				    PSCI_RET_SUCCESS : PSCI_RET_DENIED);
+	}
 	return ret;
 }
 
@@ -142,6 +153,25 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
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
+		 * Provide the references of the source and target RECs to the
+		 * RMM so that the RMM can complete the PSCI request.
+		 */
+		realm_psci_complete(vcpu, target_vcpu, PSCI_RET_SUCCESS);
+		return PSCI_RET_SUCCESS;
+	}
+
 	/*
 	 * If one or more VCPU matching target affinity are running
 	 * then ON else OFF
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 0fe55e369782..5f1fdefc0364 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -165,6 +165,20 @@ static void free_rtt(phys_addr_t phys)
 	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
 }
 
+int realm_psci_complete(struct kvm_vcpu *source, struct kvm_vcpu *target,
+			unsigned long status)
+{
+	int ret;
+
+	ret = rmi_psci_complete(virt_to_phys(source->arch.rec.rec_page),
+				virt_to_phys(target->arch.rec.rec_page),
+				status);
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
2.43.0


