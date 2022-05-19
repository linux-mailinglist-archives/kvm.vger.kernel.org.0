Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89EA352D4B5
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbiESNqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiESNo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:44:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E0CD9E94
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:44:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DBC9BCE2440
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5E7C36AE5;
        Thu, 19 May 2022 13:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967872;
        bh=QDHr3L/fq3ClG6rylwskyI3NtEAihjTV6Wf96x2oT30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tifGlaNNTa02n/YUhhJl1/bYo/VHDakmvfYCPAek1jkaBxr1B+67WoLAjqsKmy166
         jWct6zdSl5cvsBwMcjwekYBEK5thXjrXy0aOKisKlO3km60qzxJX428Cx5aehgnfnB
         a9Vn24eKz9ec6pLglToe/bpFfzeAIMuuN6uj3ENhneAP5F+GlxJRWYgmh6ediYh/N+
         23fv/LtjIijHClN22GSZmjVNPfhi4ZmZ5lqsIMVx1PnSfXljQ1SQxABPj1NaxiYKID
         ARmcEA89Mjl7G2vuKgostaODlLextILI3hks13a3NmRxcSCChSHgo7k+YmqMIwzUw9
         I+43tmBauGnEw==
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
Subject: [PATCH 32/89] KVM: arm64: Use the shadow vCPU structure in handle___kvm_vcpu_run()
Date:   Thu, 19 May 2022 14:41:07 +0100
Message-Id: <20220519134204.5379-33-will@kernel.org>
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

As a stepping stone towards deprivileging the host's access to the
guest's vCPU structures, introduce some naive flush/sync routines to
copy most of the host vCPU into the shadow vCPU on vCPU run and back
again on return to EL1.

This allows us to run using the shadow structure when KVM is initialised
in protected mode.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  4 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     | 82 +++++++++++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 27 +++++++++
 3 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index f841e2b252cd..e600dc4965c4 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -63,5 +63,9 @@ int __pkvm_init_shadow(struct kvm *kvm, unsigned long shadow_hva,
 		       size_t shadow_size, unsigned long pgd_hva);
 int __pkvm_teardown_shadow(unsigned int shadow_handle);
 
+struct kvm_shadow_vcpu_state *
+pkvm_load_shadow_vcpu_state(unsigned int shadow_handle, unsigned int vcpu_idx);
+void pkvm_put_shadow_vcpu_state(struct kvm_shadow_vcpu_state *shadow_state);
+
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 629d306c91c0..7a0d95e28e00 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -22,11 +22,89 @@ DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
+static void flush_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
+{
+	struct kvm_vcpu *shadow_vcpu = &shadow_state->shadow_vcpu;
+	struct kvm_vcpu *host_vcpu = shadow_state->host_vcpu;
+
+	shadow_vcpu->arch.ctxt		= host_vcpu->arch.ctxt;
+
+	shadow_vcpu->arch.sve_state	= kern_hyp_va(host_vcpu->arch.sve_state);
+	shadow_vcpu->arch.sve_max_vl	= host_vcpu->arch.sve_max_vl;
+
+	shadow_vcpu->arch.hw_mmu	= host_vcpu->arch.hw_mmu;
+
+	shadow_vcpu->arch.hcr_el2	= host_vcpu->arch.hcr_el2;
+	shadow_vcpu->arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
+	shadow_vcpu->arch.cptr_el2	= host_vcpu->arch.cptr_el2;
+
+	shadow_vcpu->arch.flags		= host_vcpu->arch.flags;
+
+	shadow_vcpu->arch.debug_ptr	= kern_hyp_va(host_vcpu->arch.debug_ptr);
+	shadow_vcpu->arch.host_fpsimd_state = host_vcpu->arch.host_fpsimd_state;
+
+	shadow_vcpu->arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
+
+	shadow_vcpu->arch.vgic_cpu.vgic_v3 = host_vcpu->arch.vgic_cpu.vgic_v3;
+}
+
+static void sync_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
+{
+	struct kvm_vcpu *shadow_vcpu = &shadow_state->shadow_vcpu;
+	struct kvm_vcpu *host_vcpu = shadow_state->host_vcpu;
+	struct vgic_v3_cpu_if *shadow_cpu_if = &shadow_vcpu->arch.vgic_cpu.vgic_v3;
+	struct vgic_v3_cpu_if *host_cpu_if = &host_vcpu->arch.vgic_cpu.vgic_v3;
+	unsigned int i;
+
+	host_vcpu->arch.ctxt		= shadow_vcpu->arch.ctxt;
+
+	host_vcpu->arch.hcr_el2		= shadow_vcpu->arch.hcr_el2;
+	host_vcpu->arch.cptr_el2	= shadow_vcpu->arch.cptr_el2;
+
+	host_vcpu->arch.fault		= shadow_vcpu->arch.fault;
+
+	host_vcpu->arch.flags		= shadow_vcpu->arch.flags;
+
+	host_cpu_if->vgic_hcr		= shadow_cpu_if->vgic_hcr;
+	for (i = 0; i < shadow_cpu_if->used_lrs; ++i)
+		host_cpu_if->vgic_lr[i] = shadow_cpu_if->vgic_lr[i];
+}
+
 static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 {
-	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
+	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 1);
+	int ret;
+
+	host_vcpu = kern_hyp_va(host_vcpu);
+
+	if (unlikely(is_protected_kvm_enabled())) {
+		struct kvm_shadow_vcpu_state *shadow_state;
+		struct kvm_vcpu *shadow_vcpu;
+		struct kvm *host_kvm;
+		unsigned int handle;
+
+		host_kvm = kern_hyp_va(host_vcpu->kvm);
+		handle = host_kvm->arch.pkvm.shadow_handle;
+		shadow_state = pkvm_load_shadow_vcpu_state(handle,
+							   host_vcpu->vcpu_idx);
+		if (!shadow_state) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		shadow_vcpu = &shadow_state->shadow_vcpu;
+		flush_shadow_state(shadow_state);
+
+		ret = __kvm_vcpu_run(shadow_vcpu);
+
+		sync_shadow_state(shadow_state);
+		pkvm_put_shadow_vcpu_state(shadow_state);
+	} else {
+		ret = __kvm_vcpu_run(host_vcpu);
+	}
 
-	cpu_reg(host_ctxt, 1) =  __kvm_vcpu_run(kern_hyp_va(vcpu));
+out:
+	cpu_reg(host_ctxt, 1) =  ret;
 }
 
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index a4a518b2a43b..9cd2bf75ed88 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -244,6 +244,33 @@ static struct kvm_shadow_vm *find_shadow_by_handle(unsigned int shadow_handle)
 	return shadow_table[shadow_idx];
 }
 
+struct kvm_shadow_vcpu_state *
+pkvm_load_shadow_vcpu_state(unsigned int shadow_handle, unsigned int vcpu_idx)
+{
+	struct kvm_shadow_vcpu_state *shadow_state = NULL;
+	struct kvm_shadow_vm *vm;
+
+	hyp_spin_lock(&shadow_lock);
+	vm = find_shadow_by_handle(shadow_handle);
+	if (!vm || vm->kvm.created_vcpus <= vcpu_idx)
+		goto unlock;
+
+	shadow_state = &vm->shadow_vcpu_states[vcpu_idx];
+	hyp_page_ref_inc(hyp_virt_to_page(vm));
+unlock:
+	hyp_spin_unlock(&shadow_lock);
+	return shadow_state;
+}
+
+void pkvm_put_shadow_vcpu_state(struct kvm_shadow_vcpu_state *shadow_state)
+{
+	struct kvm_shadow_vm *vm = shadow_state->shadow_vm;
+
+	hyp_spin_lock(&shadow_lock);
+	hyp_page_ref_dec(hyp_virt_to_page(vm));
+	hyp_spin_unlock(&shadow_lock);
+}
+
 static void unpin_host_vcpus(struct kvm_shadow_vcpu_state *shadow_vcpu_states,
 			     unsigned int nr_vcpus)
 {
-- 
2.36.1.124.g0e6072fb45-goog

