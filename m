Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899075124FD
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 00:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238081AbiD0WIB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 18:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237989AbiD0WH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 18:07:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A764D82D37
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 15:04:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57E3EB82AE8
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 22:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061F1C385A9;
        Wed, 27 Apr 2022 22:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651097085;
        bh=pd+ppBS4AMOOPk2OjVc3EDZ0y0+9s9EffkC7oPOrVaA=;
        h=From:To:Cc:Subject:Date:From;
        b=bNd0y9GXq5k/qn0mRLOX7NDrArqeGsR6IzOkgOvtveIcb8irWHjo6I8JXX7U6wfyF
         lSrhzyx70dySogcKsWMtoVQq6oIOmNNbCICS6dDL+/oZOdMfw6v5Mk8YKjwLBZuwpY
         6S6KEf99Zgjmx7/E0G7xXPQ0UcSzp7GrviE+cej2UfIYUzShMMV7wHSCxU5f9lcDzj
         iXESud4NQi2xXHC36GuAS80f/ZCigDGqxr4GR1wDf1L/9LKCPpni4Yni/OFOslwkrd
         dPpD919UPz2vAnTUBWgdNUsJ3qj6Z7xcNzzc2IxImlr1bqM8rvg1NlY4ft29WNSogB
         AzQErIphDSG5w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1njpm6-007U5C-Ix; Wed, 27 Apr 2022 23:04:42 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v2] KVM: arm64: Inject exception on out-of-IPA-range translation fault
Date:   Wed, 27 Apr 2022 23:04:34 +0100
Message-Id: <20220427220434.3097449-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com, qperret@google.com, will@kernel.org, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When taking a translation fault for an IPA that is outside of
the range defined by the hypervisor (between the HW PARange and
the IPA range), we stupidly treat it as an IO and forward the access
to userspace. Of course, userspace can't do much with it, and things
end badly.

Arguably, the guest is braindead, but we should at least catch the
case and inject an exception.

Check the faulting IPA against:
- the sanitised PARange: inject an address size fault
- the IPA size: inject an abort

Reported-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h |  1 +
 arch/arm64/kvm/inject_fault.c        | 28 ++++++++++++++++++++++++++++
 arch/arm64/kvm/mmu.c                 | 19 +++++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 7496deab025a..f71358271b71 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -40,6 +40,7 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu);
 void kvm_inject_vabt(struct kvm_vcpu *vcpu);
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
+void kvm_inject_size_fault(struct kvm_vcpu *vcpu);
 
 void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index b47df73e98d7..ba20405d2dc2 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -145,6 +145,34 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr)
 		inject_abt64(vcpu, true, addr);
 }
 
+void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
+{
+	unsigned long addr, esr;
+
+	addr  = kvm_vcpu_get_fault_ipa(vcpu);
+	addr |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+
+	if (kvm_vcpu_trap_is_iabt(vcpu))
+		kvm_inject_pabt(vcpu, addr);
+	else
+		kvm_inject_dabt(vcpu, addr);
+
+	/*
+	 * If AArch64 or LPAE, set FSC to 0 to indicate an Address
+	 * Size Fault at level 0, as if exceeding PARange.
+	 *
+	 * Non-LPAE guests will only get the external abort, as there
+	 * is no way to to describe the ASF.
+	 */
+	if (vcpu_el1_is_32bit(vcpu) &&
+	    !(vcpu_read_sys_reg(vcpu, TCR_EL1) & TTBCR_EAE))
+		return;
+
+	esr = vcpu_read_sys_reg(vcpu, ESR_EL1);
+	esr &= ~GENMASK_ULL(5, 0);
+	vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
+}
+
 /**
  * kvm_inject_undefined - inject an undefined instruction into the guest
  * @vcpu: The vCPU in which to inject the exception
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 53ae2c0640bc..5400fc020164 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1337,6 +1337,25 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
 
+	if (fault_status == FSC_FAULT) {
+		/* Beyond sanitised PARange (which is the IPA limit) */
+		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
+			kvm_inject_size_fault(vcpu);
+			return 1;
+		}
+
+		/* Falls between the IPA range and the PARange? */
+		if (fault_ipa >= BIT_ULL(vcpu->arch.hw_mmu->pgt->ia_bits)) {
+			fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+
+			if (is_iabt)
+				kvm_inject_pabt(vcpu, fault_ipa);
+			else
+				kvm_inject_dabt(vcpu, fault_ipa);
+			return 1;
+		}
+	}
+
 	/* Synchronous External Abort? */
 	if (kvm_vcpu_abt_issea(vcpu)) {
 		/*
-- 
2.34.1

