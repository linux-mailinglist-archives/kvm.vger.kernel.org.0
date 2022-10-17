Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA444600E40
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 13:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbiJQLyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 07:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiJQLyA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 07:54:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9485853C
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 04:53:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FCB46104D
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886E4C43470;
        Mon, 17 Oct 2022 11:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666007630;
        bh=iCQvJqIBHlz/qoj4u7oHbyxitmwvOTi7uXENaLoM508=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJ/DVoZfyMXiVOq9U7MLmdr8QbBTj3mtty6Asgmr1KjgjjKgeSRGt0ztGd95QZRVO
         AuX+gtuosOou7Eah0dunPfhj/dUxfUTbQwjH+ZhzpAcdZQ3ws86ugDRoAD4VQB6EIF
         BrLVeBWy3x5c1jZqtRvCNXIK0zEEECAUBkt6H4eMNjuM1B+lvtGxm0tE+T7y7h2RRX
         NbIhKnheDQo9que48glYbsVejHbYfOs1Ok8mUYsojt0vpvIWU3qwBylFbV3fXOFV85
         aIzxdbshA4njc2msJro0KbGPBtimcqylpywDLvi6mbfJ0xOVkKeYdY9BYid7Tpzujq
         lMMI1SO1X7AFQ==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.linux.dev
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 25/25] KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()
Date:   Mon, 17 Oct 2022 12:52:09 +0100
Message-Id: <20221017115209.2099-26-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221017115209.2099-1-will@kernel.org>
References: <20221017115209.2099-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a stepping stone towards deprivileging the host's access to the
guest's vCPU structures, introduce some naive flush/sync routines to
copy most of the host vCPU into the hyp vCPU on vCPU run and back
again on return to EL1.

This allows us to run using the pKVM hyp structures when KVM is
initialised in protected mode.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  4 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     | 79 +++++++++++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 28 +++++++++
 3 files changed, 109 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 5d456438445c..38424b98ed84 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -67,4 +67,8 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 		     unsigned long vcpu_hva);
 int __pkvm_teardown_vm(pkvm_handle_t handle);
 
+struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
+					 unsigned int vcpu_idx);
+void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu);
+
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index b5f3fcfe9135..728e01d4536b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -22,11 +22,86 @@ DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
+static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+
+	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
+
+	hyp_vcpu->vcpu.arch.sve_state	= kern_hyp_va(host_vcpu->arch.sve_state);
+	hyp_vcpu->vcpu.arch.sve_max_vl	= host_vcpu->arch.sve_max_vl;
+
+	hyp_vcpu->vcpu.arch.hw_mmu	= host_vcpu->arch.hw_mmu;
+
+	hyp_vcpu->vcpu.arch.hcr_el2	= host_vcpu->arch.hcr_el2;
+	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
+	hyp_vcpu->vcpu.arch.cptr_el2	= host_vcpu->arch.cptr_el2;
+
+	hyp_vcpu->vcpu.arch.iflags	= host_vcpu->arch.iflags;
+	hyp_vcpu->vcpu.arch.fp_state	= host_vcpu->arch.fp_state;
+
+	hyp_vcpu->vcpu.arch.debug_ptr	= kern_hyp_va(host_vcpu->arch.debug_ptr);
+	hyp_vcpu->vcpu.arch.host_fpsimd_state = host_vcpu->arch.host_fpsimd_state;
+
+	hyp_vcpu->vcpu.arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
+
+	hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3 = host_vcpu->arch.vgic_cpu.vgic_v3;
+}
+
+static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	struct vgic_v3_cpu_if *hyp_cpu_if = &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
+	struct vgic_v3_cpu_if *host_cpu_if = &host_vcpu->arch.vgic_cpu.vgic_v3;
+	unsigned int i;
+
+	host_vcpu->arch.ctxt		= hyp_vcpu->vcpu.arch.ctxt;
+
+	host_vcpu->arch.hcr_el2		= hyp_vcpu->vcpu.arch.hcr_el2;
+	host_vcpu->arch.cptr_el2	= hyp_vcpu->vcpu.arch.cptr_el2;
+
+	host_vcpu->arch.fault		= hyp_vcpu->vcpu.arch.fault;
+
+	host_vcpu->arch.iflags		= hyp_vcpu->vcpu.arch.iflags;
+	host_vcpu->arch.fp_state	= hyp_vcpu->vcpu.arch.fp_state;
+
+	host_cpu_if->vgic_hcr		= hyp_cpu_if->vgic_hcr;
+	for (i = 0; i < hyp_cpu_if->used_lrs; ++i)
+		host_cpu_if->vgic_lr[i] = hyp_cpu_if->vgic_lr[i];
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
+		struct pkvm_hyp_vcpu *hyp_vcpu;
+		struct kvm *host_kvm;
+
+		host_kvm = kern_hyp_va(host_vcpu->kvm);
+		hyp_vcpu = pkvm_load_hyp_vcpu(host_kvm->arch.pkvm.handle,
+					      host_vcpu->vcpu_idx);
+		if (!hyp_vcpu) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		flush_hyp_vcpu(hyp_vcpu);
+
+		ret = __kvm_vcpu_run(&hyp_vcpu->vcpu);
+
+		sync_hyp_vcpu(hyp_vcpu);
+		pkvm_put_hyp_vcpu(hyp_vcpu);
+	} else {
+		/* The host is fully trusted, run its vCPU directly. */
+		ret = __kvm_vcpu_run(host_vcpu);
+	}
 
-	cpu_reg(host_ctxt, 1) =  __kvm_vcpu_run(kern_hyp_va(vcpu));
+out:
+	cpu_reg(host_ctxt, 1) =  ret;
 }
 
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 826335ccad9d..d4d2ed07a481 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -241,6 +241,33 @@ static struct pkvm_hyp_vm *get_vm_by_handle(pkvm_handle_t handle)
 	return vm_table[idx];
 }
 
+struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
+					 unsigned int vcpu_idx)
+{
+	struct pkvm_hyp_vcpu *hyp_vcpu = NULL;
+	struct pkvm_hyp_vm *hyp_vm;
+
+	hyp_spin_lock(&vm_table_lock);
+	hyp_vm = get_vm_by_handle(handle);
+	if (!hyp_vm || hyp_vm->nr_vcpus <= vcpu_idx)
+		goto unlock;
+
+	hyp_vcpu = hyp_vm->vcpus[vcpu_idx];
+	hyp_page_ref_inc(hyp_virt_to_page(hyp_vm));
+unlock:
+	hyp_spin_unlock(&vm_table_lock);
+	return hyp_vcpu;
+}
+
+void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct pkvm_hyp_vm *hyp_vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
+
+	hyp_spin_lock(&vm_table_lock);
+	hyp_page_ref_dec(hyp_virt_to_page(hyp_vm));
+	hyp_spin_unlock(&vm_table_lock);
+}
+
 static void unpin_host_vcpu(struct kvm_vcpu *host_vcpu)
 {
 	if (host_vcpu)
@@ -286,6 +313,7 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 	hyp_vcpu->vcpu.vcpu_idx = vcpu_idx;
 
 	hyp_vcpu->vcpu.arch.hw_mmu = &hyp_vm->kvm.arch.mmu;
+	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
 done:
 	if (ret)
 		unpin_host_vcpu(host_vcpu);
-- 
2.38.0.413.g74048e4d9e-goog

