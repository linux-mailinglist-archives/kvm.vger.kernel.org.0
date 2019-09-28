Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB71C1186
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2019 19:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbfI1RXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Sep 2019 13:23:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53536 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728741AbfI1RX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Sep 2019 13:23:26 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B751C89AC5;
        Sat, 28 Sep 2019 17:23:25 +0000 (UTC)
Received: from mail (ovpn-125-159.rdu2.redhat.com [10.10.125.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7ABFF60600;
        Sat, 28 Sep 2019 17:23:25 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 10/14] KVM: monolithic: x86: drop the kvm_pmu_ops structure
Date:   Sat, 28 Sep 2019 13:23:19 -0400
Message-Id: <20190928172323.14663-11-aarcange@redhat.com>
In-Reply-To: <20190928172323.14663-1-aarcange@redhat.com>
References: <20190928172323.14663-1-aarcange@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Sat, 28 Sep 2019 17:23:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cleanup after the structure was finally left completely unused.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ---
 arch/x86/kvm/pmu.h              | 20 --------------------
 arch/x86/kvm/pmu_amd.c          | 15 ---------------
 arch/x86/kvm/svm.c              |  1 -
 arch/x86/kvm/vmx/pmu_intel.c    | 15 ---------------
 arch/x86/kvm/vmx/vmx.c          |  2 --
 6 files changed, 56 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 75affbf7861b..0481648852c0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1348,9 +1348,6 @@ struct kvm_x86_ops {
 					   gfn_t offset, unsigned long mask);
 	int (*write_log_dirty)(struct kvm_vcpu *vcpu);
 
-	/* pmu operations of sub-arch */
-	const struct kvm_pmu_ops *pmu_ops;
-
 	/*
 	 * Architecture specific hooks for vCPU blocking due to
 	 * HLT instruction.
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 82f07e3492df..c74d4ab30f66 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -36,23 +36,6 @@ extern void kvm_x86_pmu_refresh(struct kvm_vcpu *vcpu);
 extern void kvm_x86_pmu_init(struct kvm_vcpu *vcpu);
 extern void kvm_x86_pmu_reset(struct kvm_vcpu *vcpu);
 
-struct kvm_pmu_ops {
-	unsigned (*find_arch_event)(struct kvm_pmu *pmu, u8 event_select,
-				    u8 unit_mask);
-	unsigned (*find_fixed_event)(int idx);
-	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
-	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
-	struct kvm_pmc *(*msr_idx_to_pmc)(struct kvm_vcpu *vcpu, unsigned idx,
-					  u64 *mask);
-	int (*is_valid_msr_idx)(struct kvm_vcpu *vcpu, unsigned idx);
-	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
-	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
-	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
-	void (*refresh)(struct kvm_vcpu *vcpu);
-	void (*init)(struct kvm_vcpu *vcpu);
-	void (*reset)(struct kvm_vcpu *vcpu);
-};
-
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
@@ -138,7 +121,4 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
-
-extern struct kvm_pmu_ops intel_pmu_ops;
-extern struct kvm_pmu_ops amd_pmu_ops;
 #endif /* __KVM_X86_PMU_H */
diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index 7ea588023949..1b09ae337516 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -300,18 +300,3 @@ void kvm_x86_pmu_reset(struct kvm_vcpu *vcpu)
 		pmc->counter = pmc->eventsel = 0;
 	}
 }
-
-struct kvm_pmu_ops amd_pmu_ops = {
-	.find_arch_event = kvm_x86_pmu_find_arch_event,
-	.find_fixed_event = kvm_x86_pmu_find_fixed_event,
-	.pmc_is_enabled = kvm_x86_pmu_pmc_is_enabled,
-	.pmc_idx_to_pmc = kvm_x86_pmu_pmc_idx_to_pmc,
-	.msr_idx_to_pmc = kvm_x86_pmu_msr_idx_to_pmc,
-	.is_valid_msr_idx = kvm_x86_pmu_is_valid_msr_idx,
-	.is_valid_msr = kvm_x86_pmu_is_valid_msr,
-	.get_msr = kvm_x86_pmu_get_msr,
-	.set_msr = kvm_x86_pmu_set_msr,
-	.refresh = kvm_x86_pmu_refresh,
-	.init = kvm_x86_pmu_init,
-	.reset = kvm_x86_pmu_reset,
-};
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 057ba1f8d7b3..50c57112c0ce 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7305,7 +7305,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.sched_in = kvm_x86_sched_in,
 
-	.pmu_ops = &amd_pmu_ops,
 	.deliver_posted_interrupt = kvm_x86_deliver_posted_interrupt,
 	.dy_apicv_has_pending_interrupt = kvm_x86_dy_apicv_has_pending_interrupt,
 	.update_pi_irte = kvm_x86_update_pi_irte,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 758d6dbdbed2..530ca9942ecd 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -356,18 +356,3 @@ void kvm_x86_pmu_reset(struct kvm_vcpu *vcpu)
 	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status =
 		pmu->global_ovf_ctrl = 0;
 }
-
-struct kvm_pmu_ops intel_pmu_ops = {
-	.find_arch_event = kvm_x86_pmu_find_arch_event,
-	.find_fixed_event = kvm_x86_pmu_find_fixed_event,
-	.pmc_is_enabled = kvm_x86_pmu_pmc_is_enabled,
-	.pmc_idx_to_pmc = kvm_x86_pmu_pmc_idx_to_pmc,
-	.msr_idx_to_pmc = kvm_x86_pmu_msr_idx_to_pmc,
-	.is_valid_msr_idx = kvm_x86_pmu_is_valid_msr_idx,
-	.is_valid_msr = kvm_x86_pmu_is_valid_msr,
-	.get_msr = kvm_x86_pmu_get_msr,
-	.set_msr = kvm_x86_pmu_set_msr,
-	.refresh = kvm_x86_pmu_refresh,
-	.init = kvm_x86_pmu_init,
-	.reset = kvm_x86_pmu_reset,
-};
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index faccffc4709e..6e995e37a8c8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7805,8 +7805,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.pre_block = kvm_x86_pre_block,
 	.post_block = kvm_x86_post_block,
 
-	.pmu_ops = &intel_pmu_ops,
-
 	.update_pi_irte = kvm_x86_update_pi_irte,
 
 #ifdef CONFIG_X86_64
