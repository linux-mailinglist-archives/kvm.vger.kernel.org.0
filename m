Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806243795F4
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbhEJRb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233217AbhEJRaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 13:30:12 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3D0F61469;
        Mon, 10 May 2021 17:29:06 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lg9Gk-000Uqg-Sq; Mon, 10 May 2021 18:00:35 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v4 55/66] KVM: arm64: Allow populating S2 SW bits
Date:   Mon, 10 May 2021 17:59:09 +0100
Message-Id: <20210510165920.1913477-56-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210510165920.1913477-1-maz@kernel.org>
References: <20210510165920.1913477-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The S2 page table code doesn't use the SW bits yet, but we are about
to need them to encode some guest Stage-2 information (its mapping size
in the form of the TTL encoding).

Propagate the SW bits specified by the caller, and store them into
the corresponding entry.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h | 10 ++++++++++
 arch/arm64/kvm/hyp/pgtable.c         |  6 ++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index c3674c47d48c..4f432ea3094c 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -92,6 +92,10 @@ struct kvm_pgtable {
  * @KVM_PGTABLE_PROT_W:		Write permission.
  * @KVM_PGTABLE_PROT_R:		Read permission.
  * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
+ * @KVM_PGTABLE_PROT_S2_SW0:	SW bit 0.
+ * @KVM_PGTABLE_PROT_S2_SW1:	SW bit 1.
+ * @KVM_PGTABLE_PROT_S2_SW2:	SW bit 2.
+ * @KVM_PGTABLE_PROT_S2_SW3:	SW bit 3.
  */
 enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_X			= BIT(0),
@@ -99,6 +103,12 @@ enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_R			= BIT(2),
 
 	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
+
+	/* Cunningly, this matches the PTE bits... */
+	KVM_PGTABLE_PROT_S2_SW0			= BIT(55),
+	KVM_PGTABLE_PROT_S2_SW1			= BIT(56),
+	KVM_PGTABLE_PROT_S2_SW2			= BIT(57),
+	KVM_PGTABLE_PROT_S2_SW3			= BIT(58),
 };
 
 #define PAGE_HYP		(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c37c1dc4feaf..fa85da30c9b8 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -43,6 +43,7 @@
 #define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
 
 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
+#define KVM_PTE_LEAF_ATTR_HI_S2_SW	GENMASK(58, 55)
 
 #define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
@@ -539,6 +540,7 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
 	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
+	attr |= prot & KVM_PTE_LEAF_ATTR_HI_S2_SW;
 	*ptep = attr;
 
 	return 0;
@@ -975,6 +977,10 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	if (prot & KVM_PGTABLE_PROT_X)
 		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
 
+	/* Always propagate the SW bits */
+	clr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_SW, 0xf);
+	set |= prot & KVM_PTE_LEAF_ATTR_HI_S2_SW;
+
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level);
 	if (!ret)
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, level);
-- 
2.29.2

