Return-Path: <kvm+bounces-19693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88D87908DC6
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 16:47:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27CCB289385
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 14:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D36024964D;
	Fri, 14 Jun 2024 14:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XWkeOP9V"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B7F3FE46;
	Fri, 14 Jun 2024 14:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718376378; cv=none; b=k4UiJGWsX4K8nd9R/vc6A2L+eNkZXsyqp4u7uPWxTweOfrNuuoGDegIEwJEwivlj8Qt4LrxrAOWT+utTMUZmNL96BPsoZAx0940PmzQHzpqeyxZvbZbiBROF14/vF77JOBTAu5JVBDW1QQfwDjhj8ILbbQS77xjWe6wtmHtwQKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718376378; c=relaxed/simple;
	bh=tF0+jo6r1XQaiY6VpcR6fJhYL/ePWXdF5hUhxNq7Xv8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=edU6rKn3+aiMSsCqT96yd0c4QzaOa1K6XrYPcdAeNIpHzmXmGCOf0NYFIPyQP+f8jr+PA6ePZwD5pTinfFqWZ7iAf6EMgobrvXxhW+qtCiTfSQAyejK8a9cS/Sx2LiQi1r3PSLVezjESeK6+HONcwrVJPwdNhu9AmeKyoNTk0zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XWkeOP9V; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B28C3277B;
	Fri, 14 Jun 2024 14:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718376377;
	bh=tF0+jo6r1XQaiY6VpcR6fJhYL/ePWXdF5hUhxNq7Xv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWkeOP9VR+9KgT76nomxhYC8AnFLSVOJQuv4x4rsrqZCx7E/hCaEzcwVM1/toLf6E
	 hj4Ksd0KflAr7UEeUhe7XSgWn8mmzQn2/toVToGeaIcO8lUCkem6+fcVttu1JFhbHE
	 zU87Uzya9aLXB5MnkmCmVkWwr/B6nfLKua+/ALKWdNwjNUUPABpZYccp1ral+MLlB9
	 H/rq2Wrw+Je60JCra7xgKt5aZIs+Jd2baKe9VlufygDmL/8oX0creDUvf95gOMcjJK
	 Bf9mwaBn1PsdomWDU1ceTMbETo2RVF0Q9oyeEoIEWXDJQBf3PD4nj8x9XSX8HdV0+Z
	 UzuXo5nyf9WeA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sI8C0-003wb4-6H;
	Fri, 14 Jun 2024 15:46:16 +0100
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
Subject: [PATCH v3 12/16] KVM: arm64: nv: Tag shadow S2 entries with guest's leaf S2 level
Date: Fri, 14 Jun 2024 15:45:48 +0100
Message-Id: <20240614144552.2773592-13-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240614144552.2773592-1-maz@kernel.org>
References: <20240614144552.2773592-1-maz@kernel.org>
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
 arch/arm64/kvm/mmu.c                | 19 +++++++++++++++++--
 2 files changed, 25 insertions(+), 2 deletions(-)

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
index 4ed93a384255..6981b1bc0946 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1598,11 +1598,19 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * Potentially reduce shadow S2 permissions to match the guest's own
 	 * S2. For exec faults, we'd only reach this point if the guest
 	 * actually allowed it (see kvm_s2_handle_perm_fault).
+	 *
+	 * Also encode the level of the original translation in the SW bits
+	 * of the leaf entry as a proxy for the span of that translation.
+	 * This will be retrieved on TLB invalidation from the guest and
+	 * used to limit the invalidation scope if a TTL hint or a range
+	 * isn't provided.
 	 */
 	if (nested) {
 		writable &= kvm_s2_trans_writable(nested);
 		if (!kvm_s2_trans_readable(nested))
 			prot &= ~KVM_PGTABLE_PROT_R;
+
+		prot |= kvm_encode_nested_level(nested);
 	}
 
 	read_lock(&kvm->mmu_lock);
@@ -1661,14 +1669,21 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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


