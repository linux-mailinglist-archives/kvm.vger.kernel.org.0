Return-Path: <kvm+bounces-65669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F9EBCB3A4E
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 18:37:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 114C430C27D1
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 17:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63BF7329E48;
	Wed, 10 Dec 2025 17:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cN4+VWQ5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC68329390;
	Wed, 10 Dec 2025 17:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765387834; cv=none; b=JL1ng1MruykxGVWSQqz2dJNrJDfMLeJovDCJrbYeGoZ3jOK6abyNhw5o4U/szO9XaPbJ3emHD+vG49SQDCB2sAVqEtXqZT0Uo8AvhBydajxPpTxZAVqB/aKqwltJ3nMYOdJXAhfew2b7CxpD0MxPoHeBSx40j1V8pjD9dzM3yl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765387834; c=relaxed/simple;
	bh=iGSMpz04w1pT5imROni6zGKAJvnyidKOwCelMQ5/JEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwlJ9hBvOzIpSwymIiM9bjNenRxMV8osG5OdomRndSsB25HNnRFD6KAlSTn8EcslqFV+dir7Ve17yCF8Ti8AbbcXrFeXIf0/Y852QrdrzTedFnuoLD/B0rkKlqW9oQSwSam+zV4zX8cnXvP4QRxdy3z/hTIenSRWGnic7LRWts8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cN4+VWQ5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968ECC19422;
	Wed, 10 Dec 2025 17:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765387833;
	bh=iGSMpz04w1pT5imROni6zGKAJvnyidKOwCelMQ5/JEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cN4+VWQ5vXNaiCRn3F7lZJoCuzk2W1TRBj4QsVTqfyJ8IChFjyo3mjP2UdAsi7dcg
	 /Lg0LawE37PYE2hPxvJ7+mT9G57ACOu4OA4SDBAR+ovD0N99X3Xvi31G3Z+A1BtqS8
	 Wo5plDhlj7d+lrOIBVZJLwM/LmraazVzX8uWhoBRrq1k1Te/nhl9J3T6C8ChYIGVeM
	 K0m1H/iGAinlabT6+J6zK5v5OmCvYb/C6b41+Yta67qK2zTqqKSUMZ+l3dwG6Qv6sA
	 /VDgLkTo4jess+eWsPkfStjvawHsGJaoFaj3aeEXiEH3Wsz2lVCMw1AJ7PsjMIGIvN
	 Wenct/2ZN59Ow==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vTO1H-0000000BnnB-3Huj;
	Wed, 10 Dec 2025 17:30:31 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Sebastian Ene <sebastianene@google.com>
Subject: [PATCH v2 6/6] KVM: arm64: Honor UX/PX attributes for EL2 S1 mappings
Date: Wed, 10 Dec 2025 17:30:24 +0000
Message-ID: <20251210173024.561160-7-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251210173024.561160-1-maz@kernel.org>
References: <20251210173024.561160-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, alexandru.elisei@arm.com, Sascha.Bischoff@arm.com, qperret@google.com, tabba@google.com, sebastianene@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we potentially have two bits to deal with when setting
execution permissions, make sure we correctly handle them when both
when building the page tables and when reading back from them.

Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h | 12 +++---------
 arch/arm64/kvm/hyp/pgtable.c         | 24 +++++++++++++++++++++---
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index be68b89692065..095e6b73740a6 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -87,15 +87,9 @@ typedef u64 kvm_pte_t;
 
 #define KVM_PTE_LEAF_ATTR_HI_SW		GENMASK(58, 55)
 
-#define __KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
-#define __KVM_PTE_LEAF_ATTR_HI_S1_UXN	BIT(54)
-#define __KVM_PTE_LEAF_ATTR_HI_S1_PXN	BIT(53)
-
-#define KVM_PTE_LEAF_ATTR_HI_S1_XN					\
-	({ cpus_have_final_cap(ARM64_KVM_HVHE) ?			\
-			(__KVM_PTE_LEAF_ATTR_HI_S1_UXN |		\
-			 __KVM_PTE_LEAF_ATTR_HI_S1_PXN) :		\
-			__KVM_PTE_LEAF_ATTR_HI_S1_XN; })
+#define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
+#define KVM_PTE_LEAF_ATTR_HI_S1_UXN	BIT(54)
+#define KVM_PTE_LEAF_ATTR_HI_S1_PXN	BIT(53)
 
 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)
 
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index e0bd6a0172729..97c0835d25590 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -342,6 +342,9 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 	if (!(prot & KVM_PGTABLE_PROT_R))
 		return -EINVAL;
 
+	if (!cpus_have_final_cap(ARM64_KVM_HVHE))
+		prot &= ~KVM_PGTABLE_PROT_UX;
+
 	if (prot & KVM_PGTABLE_PROT_X) {
 		if (prot & KVM_PGTABLE_PROT_W)
 			return -EINVAL;
@@ -351,8 +354,16 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 
 		if (system_supports_bti_kernel())
 			attr |= KVM_PTE_LEAF_ATTR_HI_S1_GP;
+	}
+
+	if (cpus_have_final_cap(ARM64_KVM_HVHE)) {
+		if (!(prot & KVM_PGTABLE_PROT_PX))
+			attr |= KVM_PTE_LEAF_ATTR_HI_S1_PXN;
+		if (!(prot & KVM_PGTABLE_PROT_UX))
+			attr |= KVM_PTE_LEAF_ATTR_HI_S1_UXN;
 	} else {
-		attr |= KVM_PTE_LEAF_ATTR_HI_S1_XN;
+		if (!(prot & KVM_PGTABLE_PROT_PX))
+			attr |= KVM_PTE_LEAF_ATTR_HI_S1_XN;
 	}
 
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
@@ -373,8 +384,15 @@ enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte)
 	if (!kvm_pte_valid(pte))
 		return prot;
 
-	if (!(pte & KVM_PTE_LEAF_ATTR_HI_S1_XN))
-		prot |= KVM_PGTABLE_PROT_X;
+	if (cpus_have_final_cap(ARM64_KVM_HVHE)) {
+		if (!(pte & KVM_PTE_LEAF_ATTR_HI_S1_PXN))
+			prot |= KVM_PGTABLE_PROT_PX;
+		if (!(pte & KVM_PTE_LEAF_ATTR_HI_S1_UXN))
+			prot |= KVM_PGTABLE_PROT_UX;
+	} else {
+		if (!(pte & KVM_PTE_LEAF_ATTR_HI_S1_XN))
+			prot |= KVM_PGTABLE_PROT_PX;
+	}
 
 	ap = FIELD_GET(KVM_PTE_LEAF_ATTR_LO_S1_AP, pte);
 	if (ap == KVM_PTE_LEAF_ATTR_LO_S1_AP_RO)
-- 
2.47.3


