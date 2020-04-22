Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2325A1B43BF
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 14:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgDVMA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 08:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgDVMA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 08:00:59 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E73C20787;
        Wed, 22 Apr 2020 12:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587556858;
        bh=u+4FuEwnjYI5qwvLEzafYDQhxRYZxiIACMXXRLk2yo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ph3+Cp7eKK/OBbQWaS3fM/ZpACcxWBP3I+eocFF4QKdUcdQFA+gvRQNRGEYPrjcU0
         1svO0CKc5xofjOYIprYplANpLoacxy9MYFdbGuUEFyhvO7rn5u9PvTFHCUKIKYVNfe
         1hfA2bSU8AeQkvF9UKgXnt0XynwCGsAXlpQnfF5I=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRE3k-005UI7-D9; Wed, 22 Apr 2020 13:00:56 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 02/26] KVM: arm64: Move __load_guest_stage2 to kvm_mmu.h
Date:   Wed, 22 Apr 2020 13:00:26 +0100
Message-Id: <20200422120050.3693593-3-maz@kernel.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200422120050.3693593-1-maz@kernel.org>
References: <20200422120050.3693593-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Having __load_guest_stage2 in kvm_hyp.h is quickly going to trigger
a circular include problem. In order to avoid this, let's move
it to kvm_mmu.h, where it will be a better fit anyway.

In the process, drop the __hyp_text annotation, which doesn't help
as the function is marked as __always_inline.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h | 18 ------------------
 arch/arm64/include/asm/kvm_mmu.h | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index fe57f60f06a89..dcb63bf941057 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -10,7 +10,6 @@
 #include <linux/compiler.h>
 #include <linux/kvm_host.h>
 #include <asm/alternative.h>
-#include <asm/kvm_mmu.h>
 #include <asm/sysreg.h>
 
 #define __hyp_text __section(.hyp.text) notrace
@@ -88,22 +87,5 @@ void deactivate_traps_vhe_put(void);
 u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
 void __noreturn __hyp_do_panic(unsigned long, ...);
 
-/*
- * Must be called from hyp code running at EL2 with an updated VTTBR
- * and interrupts disabled.
- */
-static __always_inline void __hyp_text __load_guest_stage2(struct kvm *kvm)
-{
-	write_sysreg(kvm->arch.vtcr, vtcr_el2);
-	write_sysreg(kvm_get_vttbr(kvm), vttbr_el2);
-
-	/*
-	 * ARM errata 1165522 and 1530923 require the actual execution of the
-	 * above before we can switch to the EL1/EL0 translation regime used by
-	 * the guest.
-	 */
-	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT_VHE));
-}
-
 #endif /* __ARM64_KVM_HYP_H__ */
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 30b0e8d6b8953..5ba1310639ec6 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -604,5 +604,22 @@ static __always_inline u64 kvm_get_vttbr(struct kvm *kvm)
 	return kvm_phys_to_vttbr(baddr) | vmid_field | cnp;
 }
 
+/*
+ * Must be called from hyp code running at EL2 with an updated VTTBR
+ * and interrupts disabled.
+ */
+static __always_inline void __load_guest_stage2(struct kvm *kvm)
+{
+	write_sysreg(kvm->arch.vtcr, vtcr_el2);
+	write_sysreg(kvm_get_vttbr(kvm), vttbr_el2);
+
+	/*
+	 * ARM erratum 1165522 requires the actual execution of the above
+	 * before we can switch to the EL1/EL0 translation regime used by
+	 * the guest.
+	 */
+	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT_VHE));
+}
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
-- 
2.26.1

