Return-Path: <kvm+bounces-43959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D10F7A9918F
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:32:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E04CD925F78
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 15:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B510E29AAF2;
	Wed, 23 Apr 2025 15:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O2JIbN+Q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C9E28B509;
	Wed, 23 Apr 2025 15:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421317; cv=none; b=cQv4CBHf3MW8o/hL3PAYbn9fP5bTTXJ9HTOqVrMjvpHcCYP0MjSP5TWH6r9fT1XyuwzMCOcTBgvavvJPxFxZKn9iFciLw5zFEktMvc435efljNC/xAbTyrm4n66x50PLwRiTftkcggKw3e3VU8R8AlhIi9Q4atZxcDo0UtlSuhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421317; c=relaxed/simple;
	bh=iqPl/CjPWZmIy/wD6gTTXYinaag2iqtsZvdP8NH+rPE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pgMyYVNPPvEzFNbzrAqTZ38hc8NoB4Juuj4KC6OsppiCa8aRwwK7X2p1T/nQOXp4+kB/0T49BaYqEL2H/XYVjn+RY3hN4617fDfb6STetIoOmRld5yxy+gBmnEOiCVcyUUnj4d+cmnMQeEoIJ44D7Yc1XPM0wSriMzbpugD4m5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O2JIbN+Q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4EBC4CEE3;
	Wed, 23 Apr 2025 15:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745421317;
	bh=iqPl/CjPWZmIy/wD6gTTXYinaag2iqtsZvdP8NH+rPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O2JIbN+Qlp1z172C3jC/uR9tQucCJp6KhYiO9/0dZ/lXx/8erwZlUJJU9/8MwFsSc
	 F0OI+No7Wn/vSPG6Brqg7d9rTkPGxqup6BJN2oZSrofdIxcLPEUQEi7XxqKCAAFcuP
	 yZVBm27zd0mjyGvNh9KsE7FMh959qOdU0SQDSufJG5Vb2UwdtyhPWpraUT08rIePYa
	 6T6x4gqX9DPpq74Tc103Hh39Odjx2hQUdZRRaxAbd8oWMZ/IQR+ifIkJJc7uePHF7W
	 yYRh9aDqscczr2rJTHvt57cdYJpTVxsj0oqlgO1hyl0kzp2MK043NiKWKzWSl1doTY
	 v3hhbiLroZ6Xg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u7boh-0082xr-V0;
	Wed, 23 Apr 2025 16:15:16 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v3 11/17] KVM: arm64: nv: Handle VNCR_EL2 invalidation from MMU notifiers
Date: Wed, 23 Apr 2025 16:15:02 +0100
Message-Id: <20250423151508.2961768-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250423151508.2961768-1-maz@kernel.org>
References: <20250423151508.2961768-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
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
index f4f14bbdef277..ed3599e8dd06a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -433,6 +433,30 @@ static unsigned int ttl_to_size(u8 ttl)
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
@@ -783,6 +807,53 @@ int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
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
@@ -795,6 +866,8 @@ void kvm_nested_s2_wp(struct kvm *kvm)
 		if (kvm_s2_mmu_valid(mmu))
 			kvm_stage2_wp_range(mmu, 0, kvm_phys_size(mmu));
 	}
+
+	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
 }
 
 void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
@@ -809,6 +882,8 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 		if (kvm_s2_mmu_valid(mmu))
 			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
 	}
+
+	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
 }
 
 void kvm_nested_s2_flush(struct kvm *kvm)
-- 
2.39.2


