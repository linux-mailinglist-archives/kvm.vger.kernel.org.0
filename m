Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F50352D4C2
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238895AbiESNqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239011AbiESNpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:45:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F650A503F
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:45:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E4F1B824AA
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510CDC36AE3;
        Thu, 19 May 2022 13:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967927;
        bh=8OjZsLF2wkXtv2aTPoN0QIpD2cu5xYWElGWpPMfY3OU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OMUQiwFrj0VO96u+pbo84x+j1YaW8rWqIZJtuiqrg/3d1GnLr0PewYXh+E8MfqrWp
         BvZz8TqNjfnCvGC2gOUtPNg2UZCCnd5iSLOQrOzUyPXw6LOVc93sIiuxISN6bUU5LM
         PUYomexnxj7l8IBlW50n72FOctPfIQcPDVKCCXm58Cq0sUet8oNlEWHi+yM5Tys27Q
         1BWFZOf3Eu+kH8SJhqU4CHCnYpem3L7qEHunb0DwUVXN8x+KAIpx4D8u1tzXyzhOcK
         OU3VwYwI3nqINgHqTqSSCK+qWjwH4KWjSNkfg9UWEXFAKPKS7X8yoBO4uKVIkuzjDc
         OSBkQT9GPB/yw==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 46/89] KVM: arm64: Introduce the pkvm_vcpu_{load,put} hypercalls
Date:   Thu, 19 May 2022 14:41:21 +0100
Message-Id: <20220519134204.5379-47-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

Rather than look-up the shadow vCPU on every run hypercall at EL2,
introduce a per-CPU loaded_shadow_state' which is updated by a pair of
load/put hypercalls that are called directly from
kvm_arch_vcpu_{load,put}() when pKVM is enabled.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h       |  2 +
 arch/arm64/kvm/arm.c                   | 14 ++++++
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  7 +++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     | 65 ++++++++++++++++++--------
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 28 +++++++++++
 arch/arm64/kvm/vgic/vgic-v3.c          |  6 ++-
 6 files changed, 100 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 22b5ee9f2b5c..07ee95d0f97d 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -78,6 +78,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_shadow,
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_shadow,
+	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
+	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c9b8e2ca5cb5..514519563976 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -429,12 +429,26 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		vcpu_ptrauth_disable(vcpu);
 	kvm_arch_vcpu_load_debug_state_flags(vcpu);
 
+	if (is_protected_kvm_enabled()) {
+		kvm_call_hyp_nvhe(__pkvm_vcpu_load,
+				  vcpu->kvm->arch.pkvm.shadow_handle,
+				  vcpu->vcpu_idx, vcpu->arch.hcr_el2);
+		kvm_call_hyp(__vgic_v3_restore_vmcr_aprs,
+			     &vcpu->arch.vgic_cpu.vgic_v3);
+	}
+
 	if (!cpumask_test_cpu(smp_processor_id(), vcpu->kvm->arch.supported_cpus))
 		vcpu_set_on_unsupported_cpu(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	if (is_protected_kvm_enabled()) {
+		kvm_call_hyp(__vgic_v3_save_vmcr_aprs,
+			     &vcpu->arch.vgic_cpu.vgic_v3);
+		kvm_call_hyp_nvhe(__pkvm_vcpu_put);
+	}
+
 	kvm_arch_vcpu_put_debug_state_flags(vcpu);
 	kvm_arch_vcpu_put_fp(vcpu);
 	if (has_vhe())
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 3997eb3dff55..343d87877aa2 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -24,6 +24,12 @@ struct kvm_shadow_vcpu_state {
 
 	/* A pointer to the shadow vm. */
 	struct kvm_shadow_vm *shadow_vm;
+
+	/*
+	 * Points to the per-cpu pointer of the cpu where it's loaded, or NULL
+	 * if not loaded.
+	 */
+	struct kvm_shadow_vcpu_state **loaded_shadow_state;
 };
 
 /*
@@ -79,6 +85,7 @@ int __pkvm_teardown_shadow(unsigned int shadow_handle);
 struct kvm_shadow_vcpu_state *
 pkvm_load_shadow_vcpu_state(unsigned int shadow_handle, unsigned int vcpu_idx);
 void pkvm_put_shadow_vcpu_state(struct kvm_shadow_vcpu_state *shadow_state);
+struct kvm_shadow_vcpu_state *pkvm_loaded_shadow_vcpu_state(void);
 
 u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
 bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 32e7e1cad00f..9e3a2aa6f737 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -138,40 +138,63 @@ static void sync_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 	sync_timer_state(shadow_state);
 }
 
+static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(unsigned int, shadow_handle, host_ctxt, 1);
+	DECLARE_REG(unsigned int, vcpu_idx, host_ctxt, 2);
+	DECLARE_REG(u64, hcr_el2, host_ctxt, 3);
+	struct kvm_shadow_vcpu_state *shadow_state;
+	struct kvm_vcpu *shadow_vcpu;
+
+	if (!is_protected_kvm_enabled())
+		return;
+
+	shadow_state = pkvm_load_shadow_vcpu_state(shadow_handle, vcpu_idx);
+	if (!shadow_state)
+		return;
+
+	shadow_vcpu = &shadow_state->shadow_vcpu;
+
+	if (shadow_state_is_protected(shadow_state)) {
+		/* Propagate WFx trapping flags, trap ptrauth */
+		shadow_vcpu->arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI |
+					       HCR_API | HCR_APK);
+		shadow_vcpu->arch.hcr_el2 |= hcr_el2 & (HCR_TWE | HCR_TWI);
+	}
+}
+
+static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
+{
+	struct kvm_shadow_vcpu_state *shadow_state;
+
+	if (!is_protected_kvm_enabled())
+		return;
+
+	shadow_state = pkvm_loaded_shadow_vcpu_state();
+
+	if (shadow_state) {
+		pkvm_put_shadow_vcpu_state(shadow_state);
+	}
+}
+
 static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 1);
 	int ret;
 
-	host_vcpu = kern_hyp_va(host_vcpu);
-
 	if (unlikely(is_protected_kvm_enabled())) {
-		struct kvm_shadow_vcpu_state *shadow_state;
-		struct kvm_vcpu *shadow_vcpu;
-		struct kvm *host_kvm;
-		unsigned int handle;
-
-		host_kvm = kern_hyp_va(host_vcpu->kvm);
-		handle = host_kvm->arch.pkvm.shadow_handle;
-		shadow_state = pkvm_load_shadow_vcpu_state(handle,
-							   host_vcpu->vcpu_idx);
-		if (!shadow_state) {
-			ret = -EINVAL;
-			goto out;
-		}
-
-		shadow_vcpu = &shadow_state->shadow_vcpu;
+		struct kvm_shadow_vcpu_state *shadow_state = pkvm_loaded_shadow_vcpu_state();
+		struct kvm_vcpu *shadow_vcpu = &shadow_state->shadow_vcpu;
+
 		flush_shadow_state(shadow_state);
 
 		ret = __kvm_vcpu_run(shadow_vcpu);
 
 		sync_shadow_state(shadow_state);
-		pkvm_put_shadow_vcpu_state(shadow_state);
 	} else {
-		ret = __kvm_vcpu_run(host_vcpu);
+		ret = __kvm_vcpu_run(kern_hyp_va(host_vcpu));
 	}
 
-out:
 	cpu_reg(host_ctxt, 1) =  ret;
 }
 
@@ -414,6 +437,8 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
 	HANDLE_FUNC(__pkvm_init_shadow),
 	HANDLE_FUNC(__pkvm_teardown_shadow),
+	HANDLE_FUNC(__pkvm_vcpu_load),
+	HANDLE_FUNC(__pkvm_vcpu_put),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 960427d6c168..f18f622336b8 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -17,6 +17,12 @@ unsigned long __icache_flags;
 /* Used by kvm_get_vttbr(). */
 unsigned int kvm_arm_vmid_bits;
 
+/*
+ * The shadow state for the currently loaded vcpu. Used only when protected KVM
+ * is enabled for both protected and non-protected VMs.
+ */
+static DEFINE_PER_CPU(struct kvm_shadow_vcpu_state *, loaded_shadow_state);
+
 /*
  * Set trap register values based on features in ID_AA64PFR0.
  */
@@ -252,15 +258,30 @@ pkvm_load_shadow_vcpu_state(unsigned int shadow_handle, unsigned int vcpu_idx)
 	struct kvm_shadow_vcpu_state *shadow_state = NULL;
 	struct kvm_shadow_vm *vm;
 
+	/* Cannot load a new vcpu without putting the old one first. */
+	if (__this_cpu_read(loaded_shadow_state))
+		return NULL;
+
 	hyp_spin_lock(&shadow_lock);
 	vm = find_shadow_by_handle(shadow_handle);
 	if (!vm || vm->kvm.created_vcpus <= vcpu_idx)
 		goto unlock;
 
 	shadow_state = &vm->shadow_vcpu_states[vcpu_idx];
+
+	/* Ensure vcpu isn't loaded on more than one cpu simultaneously. */
+	if (unlikely(shadow_state->loaded_shadow_state)) {
+		shadow_state = NULL;
+		goto unlock;
+	}
+	shadow_state->loaded_shadow_state = this_cpu_ptr(&loaded_shadow_state);
+
 	hyp_page_ref_inc(hyp_virt_to_page(vm));
 unlock:
 	hyp_spin_unlock(&shadow_lock);
+
+	__this_cpu_write(loaded_shadow_state, shadow_state);
+
 	return shadow_state;
 }
 
@@ -269,10 +290,17 @@ void pkvm_put_shadow_vcpu_state(struct kvm_shadow_vcpu_state *shadow_state)
 	struct kvm_shadow_vm *vm = shadow_state->shadow_vm;
 
 	hyp_spin_lock(&shadow_lock);
+	shadow_state->loaded_shadow_state = NULL;
+	__this_cpu_write(loaded_shadow_state, NULL);
 	hyp_page_ref_dec(hyp_virt_to_page(vm));
 	hyp_spin_unlock(&shadow_lock);
 }
 
+struct kvm_shadow_vcpu_state *pkvm_loaded_shadow_vcpu_state(void)
+{
+	return __this_cpu_read(loaded_shadow_state);
+}
+
 static void unpin_host_vcpus(struct kvm_shadow_vcpu_state *shadow_vcpu_states,
 			     unsigned int nr_vcpus)
 {
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 18b7fda8d59c..07e62575d0f3 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -720,7 +720,8 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
-	kvm_call_hyp(__vgic_v3_restore_vmcr_aprs, cpu_if);
+	if (likely(!is_protected_kvm_enabled()))
+		kvm_call_hyp(__vgic_v3_restore_vmcr_aprs, cpu_if);
 
 	if (has_vhe())
 		__vgic_v3_activate_traps(cpu_if);
@@ -734,7 +735,8 @@ void vgic_v3_put(struct kvm_vcpu *vcpu, bool blocking)
 
 	WARN_ON(vgic_v4_put(vcpu, blocking));
 
-	kvm_call_hyp(__vgic_v3_save_vmcr_aprs, cpu_if);
+	if (likely(!is_protected_kvm_enabled()))
+		kvm_call_hyp(__vgic_v3_save_vmcr_aprs, cpu_if);
 
 	if (has_vhe())
 		__vgic_v3_deactivate_traps(cpu_if);
-- 
2.36.1.124.g0e6072fb45-goog

