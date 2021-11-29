Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F6F4621B0
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 21:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhK2ULp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 15:11:45 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50518 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344222AbhK2UJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 15:09:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F2CF8CE1407
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33100C53FC7;
        Mon, 29 Nov 2021 20:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216371;
        bh=6hZQyOZ9NUfBRMqXUMWM6jZMoyFklw6GsxNcnhbH+Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mm0IUw36bb3TIF8aBdIUZer4551CmkWvpdRbCjaDiTmUjkDfFzpLJip21Rd5jVtI2
         PyKb3MBnubetP86b1tOKYMfCgB8Q8Y3VMsQpI48oRsqT6VUBgI7ui4ZZLseqoIqtbt
         V1RK98kVw7tDjau+YzvsA2bMpgcnRJEY5XUSd236n1D5rXb95VvBVBI4Xw1+W9Izfv
         3dITW+u+OSLv32sxWDuH5J11tn/3pdY43Eyx29uFZyLWZtjFDcdA6Cyc+e69EyeFTY
         w6XHAfG+hg14b4yhL7XKi/+RcEgtQkxuSuXAFIrMiX6CKFNSIf7N6hixiACbELQYOU
         i+8YFtKFkWz1g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmrG-008gvR-Ed; Mon, 29 Nov 2021 20:02:38 +0000
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
Subject: [PATCH v5 60/69] KVM: arm64: nv: Tag shadow S2 entries with nested level
Date:   Mon, 29 Nov 2021 20:01:41 +0000
Message-Id: <20211129200150.351436-61-maz@kernel.org>
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

Populate bits [56:55] of the leaf entry with the level provided
by the guest's S2 translation.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 8 ++++++++
 arch/arm64/kvm/mmu.c                | 6 ++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 34499c496ae6..76fbf5de1f2c 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -5,6 +5,8 @@
 #include <linux/bitfield.h>
 #include <linux/kvm_host.h>
 
+#include <asm/kvm_pgtable.h>
+
 static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu)
 {
 	return (!__is_defined(__KVM_NVHE_HYPERVISOR__) &&
@@ -135,4 +137,10 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
 
 #define KVM_NV_GUEST_MAP_SZ	GENMASK_ULL(56, 55)
 
+static inline u64 kvm_encode_nested_level(struct kvm_s2_trans *trans)
+{
+	return FIELD_PREP(KVM_PGTABLE_PROT_SW1 | KVM_PGTABLE_PROT_SW0,
+			  trans->level);
+}
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7e640cae732d..388a6d25bf34 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1157,11 +1157,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * Potentially reduce shadow S2 permissions to match the guest's own
 	 * S2. For exec faults, we'd only reach this point if the guest
 	 * actually allowed it (see kvm_s2_handle_perm_fault).
+	 *
+	 * Also encode the level of the nested translation in the SW bits of
+	 * the PTE/PMD/PUD. This will be retrived on TLB invalidation from
+	 * the guest.
 	 */
 	if (kvm_is_shadow_s2_fault(vcpu)) {
 		writable &= kvm_s2_trans_writable(nested);
 		if (!kvm_s2_trans_readable(nested))
 			prot &= ~KVM_PGTABLE_PROT_R;
+
+		prot |= kvm_encode_nested_level(nested);
 	}
 
 	spin_lock(&kvm->mmu_lock);
-- 
2.30.2

