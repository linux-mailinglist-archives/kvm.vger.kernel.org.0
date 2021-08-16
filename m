Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BF93ECBF6
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbhHPANB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbhHPAM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:12:58 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C19AC061764
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:28 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id u6-20020ad448660000b02903500bf28866so11832377qvy.23
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IzZpuEsgwV0AULnFn0VDAkOlC3SkP0x8cjQf8LHfPG8=;
        b=Z6KJIWUoRZm4gv1SxUSGM1H6/YnrARuwOEm5BdLr/NIw2XcC76fYJA/umAxe1eKVRy
         roA/HxRxx9DEMfnoH0VYW9Dq7WKsVqbZsfl1UXp5C/+7nEOY8tPdtSNnp4an2z/fhNP/
         /hSJ1Yvy7h7zW7dQBoz3hSL9+ruqcYlSuE/QwBGN4ED8WT9ee1x0wY5zXsU7K4Wilody
         ju6OQD7sBLOx6tKwDvk16FD6QRCIOyUPis0cP8sn5jutVX57b7PmSIos9ixZ9RnXzIZA
         G4LmfbIOdX/Jzm+JanelRb5nJzx8rt9LZLR+Ox5DuoF1uojBAVpWBWsEZP0xlBp886dY
         UhXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IzZpuEsgwV0AULnFn0VDAkOlC3SkP0x8cjQf8LHfPG8=;
        b=jkGDh9mAgtf6aqpl1gOTPdHUAh1jIae7BZFyLRjvWgPQ1LPxuAWWNl6EC/fCDGtdQP
         OeK+oczrvTzIEi5QErmOfBlPd0x+PE6SlN+cfHeI8bRaHE2qVQLOu4HHyUTOtiPQq/VL
         qTOQgiR1RTpiebLQBqDFSFummnIrwN8co8oOmXHr9/1XA2/n6uTeKhhue/JN8uRFPBXn
         3qvA6S0GX5J4OSdDE91214pNRp+mg9LfrQ8yT9t71rUD63ZHpFz0LV8FOzeZ6Hv9x62J
         0YP1zecIH1zqrFn5DrPHuXmmha0Co8JC2gCl3fTw7w8oFJ898jA3LNZnaCuBiTyt7HVM
         Yu5Q==
X-Gm-Message-State: AOAM530BxT4XxoygGz5qXrJmJluhQNKShsuEDNXT0PfIyIo2VVhRt2mS
        +mzNks/kSVxGLQDG26Qgy8rKm4Vd2VGn9pYlp2kqNTmes7Y44+TMMEAsUpEdUPl050eJE2qmmuc
        IXqDfRTR3i851wi+/8NXMHTIG6Y3bYY8rB6itcgT/1l9d1sJpvo75pvD5fw==
X-Google-Smtp-Source: ABdhPJyq1E1IRX+IFCz2UT4Lu7i7B0G3RsUFCvBiLDi44WCVFhrddU+e2oHM6bxVIVMm1WK477KidWJeex0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:10c4:: with SMTP id
 r4mr13783414qvs.58.1629072747465; Sun, 15 Aug 2021 17:12:27 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:12:16 +0000
In-Reply-To: <20210816001217.3063400-1-oupton@google.com>
Message-Id: <20210816001217.3063400-7-oupton@google.com>
Mime-Version: 1.0
References: <20210816001217.3063400-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 6/7] KVM: arm64: Configure timer traps in vcpu_load() for VHE
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for emulated physical counter-timer offsetting, configure
traps on every vcpu_load() for VHE systems. As before, these trap
settings do not affect host userspace, and are only active for the
guest.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/arch_timer.c  | 10 +++++++---
 arch/arm64/kvm/arm.c         |  4 +---
 include/kvm/arm_arch_timer.h |  2 --
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 46380c389683..1689c2e20cd3 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -51,6 +51,7 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
 static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 			      struct arch_timer_context *timer,
 			      enum kvm_arch_timer_regs treg);
+static void kvm_timer_enable_traps_vhe(void);
 
 u32 timer_get_ctl(struct arch_timer_context *ctxt)
 {
@@ -663,6 +664,9 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 
 	if (map.emul_ptimer)
 		timer_emulate(map.emul_ptimer);
+
+	if (has_vhe())
+		kvm_timer_enable_traps_vhe();
 }
 
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
@@ -1355,12 +1359,12 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 }
 
 /*
- * On VHE system, we only need to configure the EL2 timer trap register once,
- * not for every world switch.
+ * On VHE system, we only need to configure the EL2 timer trap register on
+ * vcpu_load(), but not every world switch into the guest.
  * The host kernel runs at EL2 with HCR_EL2.TGE == 1,
  * and this makes those bits have no effect for the host kernel execution.
  */
-void kvm_timer_init_vhe(void)
+static void kvm_timer_enable_traps_vhe(void)
 {
 	/* When HCR_EL2.E2H ==1, EL1PCEN and EL1PCTEN are shifted by 10 */
 	u32 cnthctl_shift = 10;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0de4b41c3706..f882a7fb3a1b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1559,9 +1559,7 @@ static void cpu_hyp_reinit(void)
 
 	cpu_hyp_reset();
 
-	if (is_kernel_in_hyp_mode())
-		kvm_timer_init_vhe();
-	else
+	if (!is_kernel_in_hyp_mode())
 		cpu_init_hyp_mode();
 
 	cpu_set_hyp_vector();
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 615f9314f6a5..254653b42da0 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -87,8 +87,6 @@ u64 kvm_phys_timer_read(void);
 void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
 
-void kvm_timer_init_vhe(void);
-
 bool kvm_arch_timer_get_input_level(int vintid);
 
 #define vcpu_timer(v)	(&(v)->arch.timer_cpu)
-- 
2.33.0.rc1.237.g0d66db33f3-goog

