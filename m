Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712DA3CE537
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 18:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346324AbhGSPsO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 11:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350277AbhGSPpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:47 -0400
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A5EC0ABCA4
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 08:38:17 -0700 (PDT)
Received: by mail-wm1-x349.google.com with SMTP id p9-20020a7bcc890000b02902190142995dso4125997wma.4
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 09:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uVNKfeEG4b+Qdmha097ZuRQElAnejEBo7Qe/StGCOZM=;
        b=DB0fOgJNXJ5E70tS+AsuZ/8rTH252TGNNrznMxapYyCfvmyUQVkYIodcjacdGvbshM
         FYS/fHQ/w+3hODQfs8HalbOa4v1gDDGNxZqldxaSHFpGr1H953Dfuv8uRQK35Y2JEb3T
         nKKig4yBHxW3bpl9bP100AW17eSDryRG4ouQrZu7Q28jXu5SVKxEYzYXfJGkYKbeNlzd
         ozfMugLUuEb8ft6Yx9hXwgX0k/qs+yfPjWFhYEcifYEVWW3eHjSUW70RiV/+mx35igxv
         Tvj/IYXKqi/bNEzZZRxE+D6TGsuWbcAx1SrKpm4e2JSRT329y78NahiFAERQkeAC61mQ
         kZAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uVNKfeEG4b+Qdmha097ZuRQElAnejEBo7Qe/StGCOZM=;
        b=I+aknG+qomxBS3fTAnQyhZB6liWMLbGDfb4qsJ/MuEpAGxksJ95KrLbc6419WIW7rq
         tPHYwDLIqwjdZjU4sKJLmc0Oxxh4av08Lal1qHKZg4vBQ7qOJ/n66EbQN5NuSmZfS2eY
         NVIw/QASLZZAmND5MEBDPilUX4yMz4Ops3+abf6UUyZsjh07FWq11nF30nWgHdLYnvv2
         OFq8fG4CMc0MVDsSZz72hmW9LjFB8diYCQTOn8BJONNyQvqcyVQisGa4HwLPDzChI3Pi
         LjnzdKGntrpwcbbF1Eqki/VcCKCfzJUnDX2VPR/fkHuZUku4RLSbJfxufQehWbTuabUI
         JAgg==
X-Gm-Message-State: AOAM532mgQZwPKbvEfDd9T6yGC9rgOA+8YQ5I+Gh0dat9e/gSdX4PJGR
        Ws2SpJaQBSBiG8Fo090nGxz1wLEodQ==
X-Google-Smtp-Source: ABdhPJzXIU8ksmYOLwiK37hqDGGMkNRvl2jPeHRvgKtrSj3QhSyZyJU4Cywip2U8/yLAHnQqc9Ep1pEz1g==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:1c7:: with SMTP id 190mr26767213wmb.170.1626710640541;
 Mon, 19 Jul 2021 09:04:00 -0700 (PDT)
Date:   Mon, 19 Jul 2021 17:03:37 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-7-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 06/15] KVM: arm64: Restore mdcr_el2 from vcpu
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On deactivating traps, restore the value of mdcr_el2 from the
newly created and preserved host value vcpu context, rather than
directly reading the hardware register.

Up until and including this patch the two values are the same,
i.e., the hardware register and the vcpu one. A future patch will
be changing the value of mdcr_el2 on activating traps, and this
ensures that its value will be restored.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h       |  5 ++++-
 arch/arm64/include/asm/kvm_hyp.h        |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  6 +++++-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 11 ++---------
 arch/arm64/kvm/hyp/vhe/switch.c         | 12 ++----------
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c      |  2 +-
 6 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4d2d974c1522..76462c6a91ee 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -287,10 +287,13 @@ struct kvm_vcpu_arch {
 	/* Stage 2 paging state used by the hardware on next switch */
 	struct kvm_s2_mmu *hw_mmu;
 
-	/* HYP configuration */
+	/* Values of trap registers for the guest. */
 	u64 hcr_el2;
 	u64 mdcr_el2;
 
+	/* Values of trap registers for the host before guest entry. */
+	u64 mdcr_el2_host;
+
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
 
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 9d60b3006efc..657d0c94cf82 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -95,7 +95,7 @@ void __sve_restore_state(void *sve_pffr, u32 *fpsr);
 
 #ifndef __KVM_NVHE_HYPERVISOR__
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
-void deactivate_traps_vhe_put(void);
+void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu);
 #endif
 
 u64 __guest_enter(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e4a2f295a394..a0e78a6027be 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -92,11 +92,15 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 		write_sysreg(0, pmselr_el0);
 		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
 	}
+
+	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 }
 
-static inline void __deactivate_traps_common(void)
+static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 {
+	write_sysreg(vcpu->arch.mdcr_el2_host, mdcr_el2);
+
 	write_sysreg(0, hstr_el2);
 	if (kvm_arm_support_pmu_v3())
 		write_sysreg(0, pmuserenr_el0);
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index f7af9688c1f7..1778593a08a9 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -69,12 +69,10 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 static void __deactivate_traps(struct kvm_vcpu *vcpu)
 {
 	extern char __kvm_hyp_host_vector[];
-	u64 mdcr_el2, cptr;
+	u64 cptr;
 
 	___deactivate_traps(vcpu);
 
-	mdcr_el2 = read_sysreg(mdcr_el2);
-
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		u64 val;
 
@@ -92,13 +90,8 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 		isb();
 	}
 
-	__deactivate_traps_common();
-
-	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
-	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
-	mdcr_el2 |= MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT;
+	__deactivate_traps_common(vcpu);
 
-	write_sysreg(mdcr_el2, mdcr_el2);
 	write_sysreg(this_cpu_ptr(&kvm_init_params)->hcr_el2, hcr_el2);
 
 	cptr = CPTR_EL2_DEFAULT;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index b3229924d243..0d0c9550fb08 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -91,17 +91,9 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
 	__activate_traps_common(vcpu);
 }
 
-void deactivate_traps_vhe_put(void)
+void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
 {
-	u64 mdcr_el2 = read_sysreg(mdcr_el2);
-
-	mdcr_el2 &= MDCR_EL2_HPMN_MASK |
-		    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
-		    MDCR_EL2_TPMS;
-
-	write_sysreg(mdcr_el2, mdcr_el2);
-
-	__deactivate_traps_common();
+	__deactivate_traps_common(vcpu);
 }
 
 /* Switch to the guest for VHE systems running in EL2 */
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 2a0b8c88d74f..007a12dd4351 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -101,7 +101,7 @@ void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *host_ctxt;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
-	deactivate_traps_vhe_put();
+	deactivate_traps_vhe_put(vcpu);
 
 	__sysreg_save_el1_state(guest_ctxt);
 	__sysreg_save_user_state(guest_ctxt);
-- 
2.32.0.402.g57bb445576-goog

