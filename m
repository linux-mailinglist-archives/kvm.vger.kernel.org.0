Return-Path: <kvm+bounces-14021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D62ED89E1F0
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 19:56:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 40942B239E7
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 17:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D38EC15747E;
	Tue,  9 Apr 2024 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+L9mvAc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DEA156C7A;
	Tue,  9 Apr 2024 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712685324; cv=none; b=M7jdNzttARnYMnB/yG+NkwDEFshRSBzLzdKd6MGuiycJJdn+W9tRQiHXT7fzM7NJkSYR6/ncHGrx/w63BSAIozYj10N+YSmJWW6RYX5FG3ij5iKs3ZieAumMrW9fr3HomWpU4syg59fZCzssshBuUcwdWkihud0qu6IDgQs3vgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712685324; c=relaxed/simple;
	bh=Kei5ds62oIzT4KV1KEEI+VNx43fEOcG+qlqv90tFjp8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VaLg8qH1cXdeMgsVkXmO5aTb/EthtsBvrZEkUSDdyeo4OhHk7gorUkmMDE9M6oCe0OuAwOzF6wWGAxSoPC89wnABfiALbOZ2b/wIcyEZqp3INwOxAabEOP0iLsc8/n7/QsuSIF4luIJjBA4lqOnZTJC6teeS5tivGpHLE7bvh4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+L9mvAc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF73C43609;
	Tue,  9 Apr 2024 17:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712685323;
	bh=Kei5ds62oIzT4KV1KEEI+VNx43fEOcG+qlqv90tFjp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+L9mvAc2Z7oL+OPziCT+uRKh9Np8syk/uduU8dSSnCEG8c6yDeTFRGnwwWKQpwwq
	 s4NrFtvSxP6T7svAeDC3nEKxiGddnNNpN1a4BcdLHxwD8UzXAQSMsTfqvKur41WRpF
	 A0pcHkBzdgzXxkXeVI8Kbb/q065x0HCB0foPnKQAVo+TwLkVOWgnyH0HFmbmV+WlN/
	 BqseVDRIN2uE7p+faupLwk/wFug5ZeuE3mJ8GSKGZxXNDVJ3SdrmNtIi0FhDgXX32A
	 pFLA6tfk8H6TCRL+//CipI6qd7X1py8ZnkHCP8Deq4ssqtRx01fdpjT8NHxsIUc4Xd
	 Jq5qkhJasq4xw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ruFgo-002szC-5K;
	Tue, 09 Apr 2024 18:55:22 +0100
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
	Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 12/16] KVM: arm64: nv: Tag shadow S2 entries with guest's leaf S2 level
Date: Tue,  9 Apr 2024 18:54:44 +0100
Message-Id: <20240409175448.3507472-13-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240409175448.3507472-1-maz@kernel.org>
References: <20240409175448.3507472-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com
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
 arch/arm64/kvm/mmu.c                | 16 ++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index ec79e16d8436..3119e0a195dc 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -5,6 +5,7 @@
 #include <linux/bitfield.h>
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_pgtable.h>
 
 static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
 {
@@ -182,4 +183,11 @@ static inline bool kvm_supported_tlbi_s1e2_op(struct kvm_vcpu *vpcu, u32 instr)
 
 int kvm_init_nv_sysregs(struct kvm *kvm);
 
+#define KVM_NV_GUEST_MAP_SZ	(KVM_PGTABLE_PROT_SW1 | KVM_PGTABLE_PROT_SW0)
+
+static inline u64 kvm_encode_nested_level(struct kvm_s2_trans *trans)
+{
+	return FIELD_PREP(KVM_NV_GUEST_MAP_SZ, trans->level);
+}
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index cf31da306622..0412c3c07c75 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1606,11 +1606,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
@@ -1667,14 +1673,20 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
 
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret) {
-- 
2.39.2


