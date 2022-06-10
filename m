Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7727546290
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 11:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347847AbiFJJfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 05:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348063AbiFJJff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 05:35:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120042253D
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 02:35:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B903061EE4
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 09:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251B9C34114;
        Fri, 10 Jun 2022 09:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654853728;
        bh=WO98t9PGem9PjQfpIvFZjfbm0/gruHeGAc6P6CvY+1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sskOLIp1Y3k/bSaWbmw+9nKYVDoSSSW2cTBbrB/7ujV8mSnNsP6E7bpLu0CGKr/Li
         fdE1GhkykMcsp3bg+vbxxrzpbdkDDopMbvmhGiWiGf4tKiD0adhDeWFYrE1SpbEAOF
         pUI6juhdyaTzHOf0Np/YMAR44pdDJnywHqRsKezwJN9yLx9Ks5pIiIlB5giOFYX07C
         kc7WUqQhirnMaScu2UebtVMBv6c7FVvoUJrx0cR9iyefYlFsIRsZDXKLwbvsJg0aRR
         goNXOAMMXvFbFDx6nIzxtpT3z/OIuvXWaQut28hXLnKh2qOiFj1km33VxyUDByFJeM
         PHn+i+HCGFa/Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nzawq-00H6Dt-O1; Fri, 10 Jun 2022 10:28:56 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>,
        Reiji Watanabe <reijiw@google.com>, kernel-team@android.com
Subject: [PATCH v2 12/19] KVM: arm64: Move vcpu WFIT flag to the state flag set
Date:   Fri, 10 Jun 2022 10:28:31 +0100
Message-Id: <20220610092838.1205755-13-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610092838.1205755-1-maz@kernel.org>
References: <20220610092838.1205755-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org, reijiw@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The host kernel uses the WFIT flag to remember that a vcpu has used
this instruction and wake it up as required. Move it to the state
set, as nothing in the hypervisor uses this information.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++--
 arch/arm64/kvm/arch_timer.c       | 2 +-
 arch/arm64/kvm/arm.c              | 2 +-
 arch/arm64/kvm/handle_exit.c      | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0c22514cb7c7..0fb1a5b86f16 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -521,6 +521,8 @@ struct kvm_vcpu_arch {
 #define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
 /* Physical CPU not in supported_cpus */
 #define ON_UNSUPPORTED_CPU	__vcpu_single_flag(sflags, BIT(2))
+/* WFIT instruction trapped */
+#define IN_WFIT			__vcpu_single_flag(sflags, BIT(3))
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
@@ -542,8 +544,6 @@ struct kvm_vcpu_arch {
 	__size_ret;							\
 })
 
-/* vcpu_arch flags field values: */
-#define KVM_ARM64_WFIT			(1 << 17) /* WFIT instruction trapped */
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
 				 KVM_GUESTDBG_USE_HW | \
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 4e39ace073af..5290ca5db663 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -242,7 +242,7 @@ static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
 static bool vcpu_has_wfit_active(struct kvm_vcpu *vcpu)
 {
 	return (cpus_have_final_cap(ARM64_HAS_WFXT) &&
-		(vcpu->arch.flags & KVM_ARM64_WFIT));
+		vcpu_get_flag(vcpu, IN_WFIT));
 }
 
 static u64 wfit_delay_ns(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5beabbe69585..8b9da9d30485 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -657,7 +657,7 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 	preempt_enable();
 
 	kvm_vcpu_halt(vcpu);
-	vcpu->arch.flags &= ~KVM_ARM64_WFIT;
+	vcpu_clear_flag(vcpu, IN_WFIT);
 	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 
 	preempt_disable();
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index f66c0142b335..d045f5b973b9 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -120,7 +120,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 		kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
 	} else {
 		if (esr & ESR_ELx_WFx_ISS_WFxT)
-			vcpu->arch.flags |= KVM_ARM64_WFIT;
+			vcpu_set_flag(vcpu, IN_WFIT);
 
 		kvm_vcpu_wfi(vcpu);
 	}
-- 
2.34.1

