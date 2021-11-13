Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2970244F076
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 02:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbhKMBZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 20:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235288AbhKMBZk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 20:25:40 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83982C061767
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 17:22:49 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id r7-20020a63ce47000000b002a5cadd2f25so5647380pgi.9
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 17:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=K2RrFeCoM3oSUmdtd3lbeaWPVCloJKULJo2uGZ1r79E=;
        b=ZtlR2+nS0IKTZkdZ+iOB/3biPj5mqutgRk8kNQsIEw7z+XWEo+BqN3FnuTCtrKmxet
         xNbwn80O8CG3bALgllFt7Of37R9JN5+ezAmmYga3PViucXn1Wnep5A4SP/0ZPL0NTIN6
         AhhJuelp0+TnzXGrC++hwN40dscFhSY6Byq/AhFM1m93gKU0BgVKAqPinBR6XkrBLZf3
         nVQcov7Qv2xjfCP6yHNUXxuIwImLhmkRHw/SoupitowgMors3vwezLwgyCJghjcbHDa8
         jZqnC/Xe7SZLkEqGg+UcGe33Hsvzh4eGCusKcFFPy0KgYQmmVthhe7dxNA0AVJirjbqM
         bDlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=K2RrFeCoM3oSUmdtd3lbeaWPVCloJKULJo2uGZ1r79E=;
        b=monekVv6oLHvO7xME47Z6uihxOUspuS5W04XzLBJBgHant8xPy+lR99nwSNzdytLAw
         kmmREIywTz71am/D91tmzWjL9tqarYaeFwf3VYMHbuOwHAqPt1CHWQpNkvgwQRdnaKiu
         4PVy5BAgD5jHt17tKGVvgxIf6RAXZVvzNfinFQzFu3QfCTguw0VkFOz+2UeCIf5db60u
         LJ9ab7VdaEuRyPKfTAhiW6doK8HvjlWQHezv/bZC0Vohwc0Hh2IrLJITzr0KNHmH7HTL
         hvDXpZjWNofqg3S6Pbazyuixn2adRIAdyQfptq7uKaP0jcbZKm63M+/VDVsMrBZjLOPN
         NiEQ==
X-Gm-Message-State: AOAM532h7pfI69vfjb9yq16PNXjZx4cI/Q4bG+rFOZL7b7ZsOj5UcCWI
        y5eQdNeIDa+XPR1dE556eC4gHEnuQIFp
X-Google-Smtp-Source: ABdhPJwF3UWNAsLH1G2l2TXGsB0hvJnIBmWY3EVPoDjpML3MqbXumCuHHbdlyxNGDRm7QYJjESgDoDoTwgEz
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a62:7a54:0:b0:494:6e78:994b with SMTP id
 v81-20020a627a54000000b004946e78994bmr17996474pfc.5.1636766568955; Fri, 12
 Nov 2021 17:22:48 -0800 (PST)
Date:   Sat, 13 Nov 2021 01:22:25 +0000
In-Reply-To: <20211113012234.1443009-1-rananta@google.com>
Message-Id: <20211113012234.1443009-3-rananta@google.com>
Mime-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v2 02/11] KVM: Introduce kvm_vcpu_has_run_once
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Architectures such as arm64 and riscv uses vcpu variables
such as has_run_once and ran_atleast_once, respectively,
to mark if the vCPU has started running. Since these are
architecture agnostic variables, introduce
kvm_vcpu_has_run_once() as a core kvm functionality and
use this instead of the architecture defined variables.

No functional change intended.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 ---
 arch/arm64/kvm/arm.c              | 8 ++++----
 arch/arm64/kvm/vgic/vgic-init.c   | 2 +-
 arch/riscv/include/asm/kvm_host.h | 3 ---
 arch/riscv/kvm/vcpu.c             | 7 ++-----
 include/linux/kvm_host.h          | 7 +++++++
 virt/kvm/kvm_main.c               | 1 +
 7 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4be8486042a7..02dffe50a20c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -367,9 +367,6 @@ struct kvm_vcpu_arch {
 	int target;
 	DECLARE_BITMAP(features, KVM_VCPU_MAX_FEATURES);
 
-	/* Detect first run of a vcpu */
-	bool has_run_once;
-
 	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
 	u64 vsesr_el2;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f5490afe1ebf..0cc148211b4e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -344,7 +344,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.has_run_once && unlikely(!irqchip_in_kernel(vcpu->kvm)))
+	if (kvm_vcpu_has_run_once(vcpu) && unlikely(!irqchip_in_kernel(vcpu->kvm)))
 		static_branch_dec(&userspace_irqchip_in_use);
 
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
@@ -582,13 +582,13 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	struct kvm *kvm = vcpu->kvm;
 	int ret = 0;
 
-	if (likely(vcpu->arch.has_run_once))
+	if (likely(kvm_vcpu_has_run_once(vcpu)))
 		return 0;
 
 	if (!kvm_arm_vcpu_is_finalized(vcpu))
 		return -EPERM;
 
-	vcpu->arch.has_run_once = true;
+	vcpu->has_run_once = true;
 
 	kvm_arm_vcpu_init_debug(vcpu);
 
@@ -1116,7 +1116,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	 * need to invalidate the I-cache though, as FWB does *not*
 	 * imply CTR_EL0.DIC.
 	 */
-	if (vcpu->arch.has_run_once) {
+	if (kvm_vcpu_has_run_once(vcpu)) {
 		if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
 			stage2_unmap_vm(vcpu->kvm);
 		else
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 0a06d0648970..6fb41097880b 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -91,7 +91,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		return ret;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (vcpu->arch.has_run_once)
+		if (kvm_vcpu_has_run_once(vcpu))
 			goto out_unlock;
 	}
 	ret = 0;
diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 25ba21f98504..645e95f61d47 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -147,9 +147,6 @@ struct kvm_vcpu_csr {
 };
 
 struct kvm_vcpu_arch {
-	/* VCPU ran at least once */
-	bool ran_atleast_once;
-
 	/* ISA feature bits (similar to MISA) */
 	unsigned long isa;
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index e3d3aed46184..18cbc8b0c03d 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -75,9 +75,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *cntx;
 
-	/* Mark this VCPU never ran */
-	vcpu->arch.ran_atleast_once = false;
-
 	/* Setup ISA features available to VCPU */
 	vcpu->arch.isa = riscv_isa_extension_base(NULL) & KVM_RISCV_ISA_ALLOWED;
 
@@ -190,7 +187,7 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 
 	switch (reg_num) {
 	case KVM_REG_RISCV_CONFIG_REG(isa):
-		if (!vcpu->arch.ran_atleast_once) {
+		if (!kvm_vcpu_has_run_once(vcpu)) {
 			vcpu->arch.isa = reg_val;
 			vcpu->arch.isa &= riscv_isa_extension_base(NULL);
 			vcpu->arch.isa &= KVM_RISCV_ISA_ALLOWED;
@@ -682,7 +679,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	struct kvm_run *run = vcpu->run;
 
 	/* Mark this VCPU ran at least once */
-	vcpu->arch.ran_atleast_once = true;
+	vcpu->has_run_once = true;
 
 	vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 60a35d9fe259..b373929c71eb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -360,6 +360,8 @@ struct kvm_vcpu {
 	 * it is a valid slot.
 	 */
 	int last_used_slot;
+
+	bool has_run_once;
 };
 
 /* must be called with irqs disabled */
@@ -1847,4 +1849,9 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
+static inline bool kvm_vcpu_has_run_once(struct kvm_vcpu *vcpu)
+{
+	return vcpu->has_run_once;
+}
+
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3f6d450355f0..1ec8a8e959b2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -433,6 +433,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->ready = false;
 	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
 	vcpu->last_used_slot = 0;
+	vcpu->has_run_once = false;
 }
 
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
-- 
2.34.0.rc1.387.gb447b232ab-goog

