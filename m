Return-Path: <kvm+bounces-18315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 325828D3A0C
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 16:57:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D43411F22FED
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA51181CE8;
	Wed, 29 May 2024 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F/l3zg3p"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE6B1802B9;
	Wed, 29 May 2024 14:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716994596; cv=none; b=pamxy6TbaV9RlmI5hhEy9JKNGskOQ+hjTSZNiR1iILNr5oUT3d7PoIOw2KlEj6w83pYGSg8My1XeoKRiPZ+ELBEOqKetIXRVvfe5+cMYbQwarPF9COUHDQoYjDLLuAZNadCjsbe5KoASwD+tWYDYji7tzQCNjS3GUmNdHHTOa2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716994596; c=relaxed/simple;
	bh=TXqDeliwtDbro2ukAy98u0cPZAGA3/YtK7hdnrx8i8Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RbZZpQIeS0wsUhStWkl/PzchbrL14M+9rmUHuTZyKdvSjdvyb+GWnwrLtDSaOHiWVafy6jx5b4hyj+tFLqN7Kv7lTctq141ndHSDs99YStUwtu9gOTRrMVv46UYUdO/pwTeOc3fw0yMjnQC5sPI5rX7DpgFNGT4XL7KKWJwiNRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F/l3zg3p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18676C4AF0A;
	Wed, 29 May 2024 14:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716994596;
	bh=TXqDeliwtDbro2ukAy98u0cPZAGA3/YtK7hdnrx8i8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/l3zg3pzKv4e8sa76bybmEKHP7n6/LD2LEqeSArhp7fhobkbMEG4rBrMXIhc3lI4
	 e7hTd7i54XvMj6foavyjEcmXIHdkqyYp5OqOJdachSpTQXFIuqkSWNApkY0xP4Alb8
	 fKmxU6e2JG2zogIkEXIVg5IZP+jzofMtUcxVnO/aQy09PfP0pHkEuyM6VV4XCVSUim
	 o95ZJaTu2/v7JFBC0UXjJBMyKHd8+eOkJE6nGxuiCrhLiCpVcFpXAiFCYeLas7cVZM
	 GQ7HHq+ynrENGTWschrsawrixdZCCd4tg/Xe0RpaXihNG0XFyjhKsRbXhfaOvfS5Xq
	 RxFRLBIyGA+cA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sCKjC-00GekF-CB;
	Wed, 29 May 2024 15:56:34 +0100
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
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v2 12/16] KVM: arm64: nv: Tag shadow S2 entries with guest's leaf S2 level
Date: Wed, 29 May 2024 15:56:24 +0100
Message-Id: <20240529145628.3272630-13-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240529145628.3272630-1-maz@kernel.org>
References: <20240529145628.3272630-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Populate bits [56:55] of the leaf entry with the level provided
by the guest's S2 translation. This will allow us to better scope
the invalidation by remembering the mapping size.

Of course, this assume that the guest will issue an invalidation
with an address that falls into the same leaf. If the guest doesn't,
we'll over-invalidate.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  8 ++++++++
 arch/arm64/kvm/mmu.c                | 17 +++++++++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index fcb0de3a93fe..971dbe533730 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -5,6 +5,7 @@
 #include <linux/bitfield.h>
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_pgtable.h>
 
 static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
 {
@@ -195,4 +196,11 @@ static inline bool kvm_auth_eretax(struct kvm_vcpu *vcpu, u64 *elr)
 }
 #endif
 
+#define KVM_NV_GUEST_MAP_SZ	(KVM_PGTABLE_PROT_SW1 | KVM_PGTABLE_PROT_SW0)
+
+static inline u64 kvm_encode_nested_level(struct kvm_s2_trans *trans)
+{
+	return FIELD_PREP(KVM_NV_GUEST_MAP_SZ, trans->level);
+}
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4ed93a384255..f3a8ec70bd29 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1598,11 +1598,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * Potentially reduce shadow S2 permissions to match the guest's own
 	 * S2. For exec faults, we'd only reach this point if the guest
 	 * actually allowed it (see kvm_s2_handle_perm_fault).
+	 *
+	 * Also encode the level of the nested translation in the SW bits of
+	 * the PTE/PMD/PUD. This will be retrived on TLB invalidation from
+	 * the guest.
 	 */
 	if (nested) {
 		writable &= kvm_s2_trans_writable(nested);
 		if (!kvm_s2_trans_readable(nested))
 			prot &= ~KVM_PGTABLE_PROT_R;
+
+		prot |= kvm_encode_nested_level(nested);
 	}
 
 	read_lock(&kvm->mmu_lock);
@@ -1661,14 +1667,21 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * permissions only if vma_pagesize equals fault_granule. Otherwise,
 	 * kvm_pgtable_stage2_map() should be called to change block size.
 	 */
-	if (fault_is_perm && vma_pagesize == fault_granule)
+	if (fault_is_perm && vma_pagesize == fault_granule) {
+		/*
+		 * Drop the SW bits in favour of those stored in the
+		 * PTE, which will be preserved.
+		 */
+		prot &= ~KVM_NV_GUEST_MAP_SZ;
 		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
-	else
+	} else {
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
 					     memcache,
 					     KVM_PGTABLE_WALK_HANDLE_FAULT |
 					     KVM_PGTABLE_WALK_SHARED);
+	}
+
 out_unlock:
 	read_unlock(&kvm->mmu_lock);
 
-- 
2.39.2


