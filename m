Return-Path: <kvm+bounces-38294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D1BA36EF7
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 16:03:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB495189469A
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 15:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0751FBEB4;
	Sat, 15 Feb 2025 15:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OS7JbLwq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B7B1EA7DA;
	Sat, 15 Feb 2025 15:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739631724; cv=none; b=LiYAiomnsJ2iMomvQgSt/kKmVR7Qb//8ECU7Hk+L27le3sZHPaK/0dlOtcO0270G/vWpIMuNFytDmIG9wCu9V+dAgGGAFlmgZMEzVNorJSCLRHPEWSOTFN7oDQ0o2bkdhDYcZt8VqgEKIfmtAMbJ8l83ZSv/sHZs96/O5WlwexM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739631724; c=relaxed/simple;
	bh=swLBJmERcPDLbXmsNkw4xLrv8Q5M/C9U8J43Npx/IBQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TrVzWzaWWbm1Lz2b5G9QQ4ZkCvmIZHUg11lpd/bhW+LiznwDk7dn/TotBkMOlqbcb7C3iksV/pBMOYDgwM5FBDNFv1OtsuadduRRH2axD7vxgAjn6FFLoqdAtl02d1cJwywM3iRJlzwa/nTo9fpclrPmsJZpSnQOMvnbDyOZrxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OS7JbLwq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C184C4CEE6;
	Sat, 15 Feb 2025 15:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739631724;
	bh=swLBJmERcPDLbXmsNkw4xLrv8Q5M/C9U8J43Npx/IBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OS7JbLwqE1ta1gfsU0cFjZIUdQO3q0jn8lNLUYy1+VmscheDleuJTd2LE7U6Vt9zl
	 Q6HErA2dHWU/IjJlS3SyLEA1mvxv6pQkQH4Kybcpy5D66lPcihgd4ukVRB7AyZxApO
	 wFKOzHxfKKnjj+6puHa1vKAtOH/Ivg2ul5vwnXNzDKnekX5iC7WuF0V2OKGEn0d2AI
	 d08TovU36aNC9VrWDCZw2QDiczQxBnV+oBIfnK8Ebsgv8N1+stucTNWMJNDxafIMYm
	 KRFyg2JylhKNy1LmlIPr47e7fJfKno37jMekTiF0KMOu7fpXTI5qPaZ74cE2t4QhcU
	 SLr5pC07+Cikw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjJgA-004Nz6-C8;
	Sat, 15 Feb 2025 15:02:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 11/14] KVM: arm64: nv: Handle VNCR_EL2 invalidation from MMU notifiers
Date: Sat, 15 Feb 2025 15:01:31 +0000
Message-Id: <20250215150134.3765791-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215150134.3765791-1-maz@kernel.org>
References: <20250215150134.3765791-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

During an invalidation triggered by an MMU notifier, we need to
make sure we can drop the *host* mapping that would have been
translated by the stage-2 mapping being invalidated.

For the moment, the invalidation is pretty brutal, as we nuke
the full IPA range, and therefore any VNCR_EL2 mapping.

At some point, we'll be more light-weight, and the code is able
to deal with something more targetted.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 75 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 51e1a3eba996a..32d2640313ab6 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -432,6 +432,30 @@ static unsigned int ttl_to_size(u8 ttl)
 	return max_size;
 }
 
+static u8 pgshift_level_to_ttl(u16 shift, u8 level)
+{
+	u8 ttl;
+
+	switch(shift) {
+	case 12:
+		ttl = TLBI_TTL_TG_4K;
+		break;
+	case 14:
+		ttl = TLBI_TTL_TG_16K;
+		break;
+	case 16:
+		ttl = TLBI_TTL_TG_64K;
+		break;
+	default:
+		BUG();
+	}
+
+	ttl <<= 2;
+	ttl |= level & 3;
+
+	return ttl;
+}
+
 /*
  * Compute the equivalent of the TTL field by parsing the shadow PT.  The
  * granule size is extracted from the cached VTCR_EL2.TG0 while the level is
@@ -782,6 +806,53 @@ int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
 	return kvm_inject_nested_sync(vcpu, esr_el2);
 }
 
+static void invalidate_vncr(struct vncr_tlb *vt)
+{
+	vt->valid = false;
+	if (vt->cpu != -1)
+		clear_fixmap(vncr_fixmap(vt->cpu));
+}
+
+static void kvm_invalidate_vncr_ipa(struct kvm *kvm, u64 start, u64 end)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	if (!kvm_has_feat(kvm, ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY))
+		return;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct vncr_tlb *vt = vcpu->arch.vncr_tlb;
+		u64 ipa_start, ipa_end, ipa_size;
+
+		/*
+		 * Careful here: We end-up here from an MMU notifier,
+		 * and this can race against a vcpu not being onlined
+		 * yet, without the pseudo-TLB being allocated.
+		 *
+		 * Skip those, as they obviously don't participate in
+		 * the invalidation at this stage.
+		 */
+		if (!vt)
+			continue;
+
+		if (!vt->valid)
+			continue;
+
+		ipa_size = ttl_to_size(pgshift_level_to_ttl(vt->wi.pgshift,
+							    vt->wr.level));
+		ipa_start = vt->wr.pa & (ipa_size - 1);
+		ipa_end = ipa_start + ipa_size;
+
+		if (ipa_end <= start || ipa_start >= end)
+			continue;
+
+		invalidate_vncr(vt);
+	}
+}
+
 void kvm_nested_s2_wp(struct kvm *kvm)
 {
 	int i;
@@ -794,6 +865,8 @@ void kvm_nested_s2_wp(struct kvm *kvm)
 		if (kvm_s2_mmu_valid(mmu))
 			kvm_stage2_wp_range(mmu, 0, kvm_phys_size(mmu));
 	}
+
+	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
 }
 
 void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
@@ -808,6 +881,8 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 		if (kvm_s2_mmu_valid(mmu))
 			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
 	}
+
+	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
 }
 
 void kvm_nested_s2_flush(struct kvm *kvm)
-- 
2.39.2


