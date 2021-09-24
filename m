Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83299417597
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345544AbhIXN0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345621AbhIXNZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:25:20 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D47CC03402B
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:55:01 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id b20-20020ac87fd4000000b002a69ee90efbso28909245qtk.11
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=y44fzIX1ftLMcQsIMexqk7MlH9WcFM4Uf4DFLHOV8zw=;
        b=kbcSGdX6W1DTAU32KsoIRyu5RXf3fqm9Ft5iyr3m/VyqUU0YPxHG/sYle+VkB16whN
         9piwWyrAzf3Hxu30Th595VibMFLO2rpVfcxRv8/4Vr3TxfZOOinM57oyVhs3Lyv3EEw9
         3CD8zN0/CXFY+HOMRwnQZFvaTz/vPVp1e2YFjT8nonSduXGwPCwDIb6KxRjLfSKyrEtU
         rm8/pwdZ5NhnzCLYTqiDn9sxDW66NgWRbLMVtkQ6y1APguvqZIitvKc9pajmjDzx7G2S
         D3fDEfhzx/5Av6NBQz11mDPmB0KHsuaTGp3D1kawfgMWZ5D6+PDgqcBdRjHtYliJMgMP
         flYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=y44fzIX1ftLMcQsIMexqk7MlH9WcFM4Uf4DFLHOV8zw=;
        b=aNf2u92nFgqPzntExL5r3IL/zrjGTP+7e1NkYlp1Bu+3yH/AIj4hfJO+2HSexQLAFs
         hPZRj1F+a7/Hb/rtloov5LBwhRIwjdaIcdLq6QznPozMHJkvMqV+NIgFFLaedrvRLVoS
         Cu7cBKfaVDWedV8aqEsj/in0Pb3ibseq13VXl7UBCILX/Qlkyf6o98YeB09d/Nf0pIVv
         iDHgi0mMh4x/mxKhYUM41jojuxIW9bf95BgbjEcqonwZHKJb+uGGObGIno6vFKsMXQZm
         pVBFi1b7x6CAg36xSeV7XdfZwYOphOH+HO9qytCTeJkyLrLHgzbVaybtOSZ6SHpRMXQJ
         0peA==
X-Gm-Message-State: AOAM530OtkHYv2dmIohNQkcvtjzowwKu6vUgAWUb8Xvmu8YkPFnjJycQ
        S1L4QdhRNJ55aJ7gbgVcFYlhICaELw==
X-Google-Smtp-Source: ABdhPJwzDg459e5SoIW1gM5OBltgwgX9FKJl95y+IxUYvre8ucu6ik03AQSvZPZnEMDcAv3LYlxmQdXBGA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:2e4:: with SMTP id
 h4mr9596859qvu.3.1632488100413; Fri, 24 Sep 2021 05:55:00 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:57 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-29-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 28/30] KVM: arm64: reduce scope of pVM fixup_guest_exit
 to hyp_state and kvm_cpu_ctxt
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com, drjones@redhat.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reduce the scope of fixup_guest_exit for protected VMs to only
need hyp_state and kvm_cpu_ctxt

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 23 +++++++++++++++++++----
 arch/arm64/kvm/hyp/nvhe/switch.c        |  7 ++-----
 arch/arm64/kvm/hyp/vhe/switch.c         |  3 +--
 3 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 3ef429cfd9af..ea9571f712c6 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -423,11 +423,8 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
  * the guest, false when we should restore the host state and return to the
  * main run loop.
  */
-static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, struct vgic_dist *vgic, u64 *exit_code)
+static inline bool _fixup_guest_exit(struct kvm_vcpu *vcpu, struct vgic_dist *vgic, struct kvm_cpu_context *vcpu_ctxt, struct vcpu_hyp_state *vcpu_hyps, u64 *exit_code)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		hyp_state_fault(vcpu_hyps).esr_el2 = read_sysreg_el2(SYS_ESR);
 
@@ -518,6 +515,24 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, struct vgic_dist *vgi
 	return true;
 }
 
+static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
+	struct vcpu_hyp_state *hyps = &vcpu->arch.hyp_state;
+	// TODO: create helper for getting VA
+	struct kvm *kvm = vcpu->kvm;
+
+	if (is_nvhe_hyp_code())
+		kvm = kern_hyp_va(kvm);
+
+	return _fixup_guest_exit(vcpu, &kvm->arch.vgic, ctxt, hyps, exit_code);
+}
+
+static inline bool fixup_pvm_guest_exit(struct kvm_vcpu *vcpu, struct vgic_dist *vgic, struct kvm_cpu_context *ctxt, struct vcpu_hyp_state *hyps, u64 *exit_code)
+{
+	return _fixup_guest_exit(vcpu, vgic, ctxt, hyps, exit_code);
+}
+
 static inline void __kvm_unexpected_el2_exception(void)
 {
 	extern char __guest_exit_panic[];
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index aa0dc4f0433b..1920aebbe49a 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -182,8 +182,6 @@ static int __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_hyp_state *vcpu_hyps = &vcpu->arch.hyp_state;
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu->arch.ctxt;
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	struct vgic_dist *vgic = &kvm->arch.vgic;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
 	bool pmu_switch_needed;
@@ -245,7 +243,7 @@ static int __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 		exit_code = __guest_enter(guest_ctxt);
 
 		/* And we're baaack! */
-	} while (fixup_guest_exit(vcpu, vgic, &exit_code));
+	} while (fixup_guest_exit(vcpu, &exit_code));
 
 	__sysreg_save_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
@@ -285,7 +283,6 @@ static int __kvm_vcpu_run_pvm(struct kvm_vcpu *vcpu)
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	struct vgic_dist *vgic = &kvm->arch.vgic;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
 	u64 exit_code;
@@ -325,7 +322,7 @@ static int __kvm_vcpu_run_pvm(struct kvm_vcpu *vcpu)
 		exit_code = __guest_enter(guest_ctxt);
 
 		/* And we're baaack! */
-	} while (fixup_guest_exit(vcpu, vgic, &exit_code));
+	} while (fixup_pvm_guest_exit(vcpu, &kvm->arch.vgic, vcpu_ctxt, vcpu_hyps, &exit_code));
 
 	__sysreg_save_state_nvhe(guest_ctxt);
 	__timer_disable_traps();
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 7f926016cebe..4a05aff37325 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -110,7 +110,6 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
 	u64 exit_code;
@@ -148,7 +147,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 		exit_code = __guest_enter(guest_ctxt);
 
 		/* And we're baaack! */
-	} while (fixup_guest_exit(vcpu, vgic, &exit_code));
+	} while (fixup_guest_exit(vcpu, &exit_code));
 
 	sysreg_save_guest_state_vhe(guest_ctxt);
 
-- 
2.33.0.685.g46640cef36-goog

