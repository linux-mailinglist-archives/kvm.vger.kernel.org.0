Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95D546219D
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 21:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhK2UKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 15:10:50 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50198 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348333AbhK2UIs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 15:08:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5A8D9CE13DF
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83125C53FCD;
        Mon, 29 Nov 2021 20:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216327;
        bh=2ThkwV02KLfELC/usIrKEsYVmRRm/yHVr4F9Cx+Dngw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0uH7D1z0AFrAjWMCNMBiB7zMbl+T0kAkO07VKHKPSVBx5qmHNHAga3ggCW3vBCr1
         YuFMMLXcJatV32Y+2Xxx8INGb3vHG91VUDPBQpf+Gq/pAlaYFuyRQ1nI6ex5H/wQj2
         8mRm6LpeXQ22opHOZ31qz9CCf4uYF/eGf5c+yv83SdYQwLhAZmlI7Z4RFA/IADoc05
         0NvkaK/XmLg/DI2C7OLwDB5ZPgT+iYkz910fmk4xuxrn5NuAIVYWKiwxRssVOuUOye
         VIWHX6XCpNQEkESiD6wHrpmEjDa/Lfh/damAI3goQUkbSagJqCE8m5OGJGdINV7b23
         yIad/gVFy8KyA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmr0-008gvR-J1; Mon, 29 Nov 2021 20:02:22 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v5 41/69] KVM: arm64: nv: Restrict S2 RD/WR permissions to match the guest's
Date:   Mon, 29 Nov 2021 20:01:22 +0000
Message-Id: <20211129200150.351436-42-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
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
index fc3613d3f503..d63f60f95abc 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1123,6 +1123,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
@@ -1161,7 +1172,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	if (device)
 		prot |= KVM_PGTABLE_PROT_DEVICE;
-	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
+	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC) &&
+		 kvm_s2_trans_executable(nested))
 		prot |= KVM_PGTABLE_PROT_X;
 
 	/*
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index c34e96955e04..fb748f2b9e87 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -493,7 +493,7 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
 		return 0;
 
 	if (kvm_vcpu_trap_is_iabt(vcpu)) {
-		forward_fault = (trans->upper_attr & BIT(54));
+		forward_fault = !kvm_s2_trans_executable(trans);
 	} else {
 		bool write_fault = kvm_is_write_fault(vcpu);
 
-- 
2.30.2

