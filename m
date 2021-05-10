Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3B237957D
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbhEJR2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:28:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231381AbhEJR2S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 13:28:18 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C7AD61469;
        Mon, 10 May 2021 17:27:13 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lg9GX-000Uqg-RY; Mon, 10 May 2021 18:00:22 +0100
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
Subject: [PATCH v4 36/66] KVM: arm64: nv: Restrict S2 RD/WR permissions to match the guest's
Date:   Mon, 10 May 2021 17:58:50 +0100
Message-Id: <20210510165920.1913477-37-maz@kernel.org>
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

When mapping a page in a shadow stage-2, special care must be
taken not to be more permissive than the guest is (writable or
readable page when the guest hasn't set that permission).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 15 +++++++++++++++
 arch/arm64/kvm/mmu.c                | 14 +++++++++++++-
 arch/arm64/kvm/nested.c             |  2 +-
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 4f93a5dab183..3f3d8e10bd99 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -93,6 +93,21 @@ static inline u32 kvm_s2_trans_esr(struct kvm_s2_trans *trans)
 	return trans->esr;
 }
 
+static inline bool kvm_s2_trans_readable(struct kvm_s2_trans *trans)
+{
+	return trans->readable;
+}
+
+static inline bool kvm_s2_trans_writable(struct kvm_s2_trans *trans)
+{
+	return trans->writable;
+}
+
+static inline bool kvm_s2_trans_executable(struct kvm_s2_trans *trans)
+{
+	return !(trans->upper_attr & BIT(54));
+}
+
 extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 			      struct kvm_s2_trans *result);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6b3753460293..6db8fa8bc5a3 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -991,6 +991,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault && device)
 		return -ENOEXEC;
 
+	/*
+	 * Potentially reduce shadow S2 permissions to match the guest's own
+	 * S2. For exec faults, we'd only reach this point if the guest
+	 * actually allowed it (see kvm_s2_handle_perm_fault).
+	 */
+	if (kvm_is_shadow_s2_fault(vcpu)) {
+		writable &= kvm_s2_trans_writable(nested);
+		if (!kvm_s2_trans_readable(nested))
+			prot &= ~KVM_PGTABLE_PROT_R;
+	}
+
 	spin_lock(&kvm->mmu_lock);
 	pgt = vcpu->arch.hw_mmu->pgt;
 	if (mmu_notifier_retry(kvm, mmu_seq))
@@ -1016,7 +1027,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	if (device)
 		prot |= KVM_PGTABLE_PROT_DEVICE;
-	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
+	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC) &&
+		 kvm_s2_trans_executable(nested))
 		prot |= KVM_PGTABLE_PROT_X;
 
 	/*
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 57f32768d04d..2e6a97e43396 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -481,7 +481,7 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
 		return 0;
 
 	if (kvm_vcpu_trap_is_iabt(vcpu)) {
-		forward_fault = (trans->upper_attr & BIT(54));
+		forward_fault = !kvm_s2_trans_executable(trans);
 	} else {
 		bool write_fault = kvm_is_write_fault(vcpu);
 
-- 
2.29.2

