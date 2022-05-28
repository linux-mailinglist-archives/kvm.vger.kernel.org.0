Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959E6536CAB
	for <lists+kvm@lfdr.de>; Sat, 28 May 2022 13:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353172AbiE1LuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 May 2022 07:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355837AbiE1LuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 May 2022 07:50:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BED611829
        for <kvm@vger.kernel.org>; Sat, 28 May 2022 04:50:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C5F6B816FE
        for <kvm@vger.kernel.org>; Sat, 28 May 2022 11:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED638C3411A;
        Sat, 28 May 2022 11:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653738599;
        bh=AkMuVhr5rTYujT3XS/iMRTcjONn9P25B4EDiWqrs1o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJpix81Xn0l8JwPJLFw5vgpDw7WPjrmyTTruKVK6Km2I0aKpJl5ShNpcgvLyeXJOH
         Qtk57bLwjelIhTkaJsokXq8ImNLBI2a6i+jRrXO86I0BI0/HyX/v3dlwUs0a2Z4y+a
         m8j/Nz9Vx1+/8CnYgy/G4VR2+20uyRnTdTij+hekj1Eeq3P9ob4eHl/6bwD3Sw79id
         TUCVAaRiAD3iHlyXzyqSDfFc3hbAVlO0TbylZGMYXKdljrYCKvENlE0lhwl++F3crW
         954WPlr/HHO7gGfWt4MSpwOdUSX6YtvbYRYlNBy8ZJzfYRJYS4wxhZfGuOR7YEfhh8
         nHNwg3StZoBvQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nuumC-00EEGh-Ar; Sat, 28 May 2022 12:38:36 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>, kernel-team@android.com
Subject: [PATCH 12/18] KVM: arm64: Move vcpu WFIT flag to the state flag set
Date:   Sat, 28 May 2022 12:38:22 +0100
Message-Id: <20220528113829.1043361-13-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220528113829.1043361-1-maz@kernel.org>
References: <20220528113829.1043361-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++--
 arch/arm64/kvm/arch_timer.c       | 2 +-
 arch/arm64/kvm/arm.c              | 2 +-
 arch/arm64/kvm/handle_exit.c      | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e0a2edca5861..fe7e1c44e6e9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -513,6 +513,8 @@ struct kvm_vcpu_arch {
 #define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
 /* Physical CPU not in supported_cpus */
 #define ON_UNSUPPORTED_CPU	__vcpu_single_flag(sflags, BIT(2))
+/* WFIT instruction trapped */
+#define IN_WFIT			__vcpu_single_flag(sflags, BIT(3))
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
@@ -534,8 +536,6 @@ struct kvm_vcpu_arch {
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
index d7d42d79ede1..49a3fe9f7009 100644
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
index 2ebebd3efaee..dac86d2c6654 100644
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

