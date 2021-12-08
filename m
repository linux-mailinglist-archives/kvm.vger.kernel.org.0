Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61F546CA6C
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243340AbhLHB6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243363AbhLHB6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:58:33 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FE1C061574
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:55:02 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id 4-20020a170902c20400b0014381f710d5so275780pll.11
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=38STVYNnHf1ImtQglc09yjFixFFYWD5c3jGnqMjOUCU=;
        b=phWbrjJ1H0y3VK4fM/x9wBe1LtqnNECU6bLoRGLChYCDdRFsZOmPh/v+ugCEM1ndQB
         /D9vP8SpZxjzKJtGX4sviuWQMVz4/E8X6B1scK2EeLUlKZtfOwnYZOWoVNzlUWUph/1P
         50nrr7XZOURKg2sADAOwkPtvzxI0GMtgZirE79c8m0HO2Cu55JUeC8BeSu7dhS4NTIWH
         sgZozBL1w4QVcyXs2G4jU61qSCPsOHgkFl1DWbtnELxF+wIuRaVhw1Ms3fPuLxn072rt
         Ly5J3zYLyrSVSF/QmCPPa5bw+0pHoMD3Fm4IdGItrXu1CHSr1f+g125gM9MzcghwtcP9
         0WfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=38STVYNnHf1ImtQglc09yjFixFFYWD5c3jGnqMjOUCU=;
        b=h44h1WLtLulZ9oMuHevu9CpK1kdeVBoLvhDn1lGAycYYOMAJcfUcmU/0m8jMbSrfk4
         VvHZCwE6YiRgaJE1mDLFljwQFx9H/MdKt0S1a7ckqoUdban7iO61xAaVtL5Fx+4F1N8X
         yVjxzpuljGAI6wnM00KN3UXpAK2HEI+rnElAOilwNsTMzyU6bmhBlQNvXp6L4bUSo94U
         rItpi1x9vbh2CHZ4xJZenvGR70M3yAi7oc/mgEx6GM6XD5VqcJogIIWfzhLlKfM1n710
         nWg2ZM+FGJ4+5OXjdXn1ivMWaOZskq78xpcfL++esrdpLdecCZziQrrKQZhmYxZ5FVsV
         TAfg==
X-Gm-Message-State: AOAM5316pxuxCOdMLJM/jztW3zk4a2Q4uBagdpVT2esRf9JCXpxuB7SJ
        VPqrA39v3defTdq4a1ySqJdv2O+iGGQ=
X-Google-Smtp-Source: ABdhPJwHhL9PY6Jly+I8sC7b3HgkQQ6+im/8CrJfoqFehx4IJIYQ6kIJOER+Mmp5ynoeq4t1uJX3KHe2hO4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:248b:b0:49f:9d7f:84e2 with SMTP id
 c11-20020a056a00248b00b0049f9d7f84e2mr2946235pfv.40.1638928502131; Tue, 07
 Dec 2021 17:55:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:19 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-10-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 09/26] KVM: x86: Remove defunct pre_block/post_block
 kvm_x86_ops hooks
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop kvm_x86_ops' pre/post_block() now that all implementations are nops.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 --
 arch/x86/include/asm/kvm_host.h    | 12 ------------
 arch/x86/kvm/vmx/vmx.c             | 13 -------------
 arch/x86/kvm/x86.c                 |  6 +-----
 4 files changed, 1 insertion(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index cefe1d81e2e8..c2b007171abd 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -96,8 +96,6 @@ KVM_X86_OP(handle_exit_irqoff)
 KVM_X86_OP_NULL(request_immediate_exit)
 KVM_X86_OP(sched_in)
 KVM_X86_OP_NULL(update_cpu_dirty_logging)
-KVM_X86_OP_NULL(pre_block)
-KVM_X86_OP_NULL(post_block)
 KVM_X86_OP_NULL(vcpu_blocking)
 KVM_X86_OP_NULL(vcpu_unblocking)
 KVM_X86_OP_NULL(update_pi_irte)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e41ad1ead721..fb62ed94e52f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1447,18 +1447,6 @@ struct kvm_x86_ops {
 	const struct kvm_pmu_ops *pmu_ops;
 	const struct kvm_x86_nested_ops *nested_ops;
 
-	/*
-	 * Architecture specific hooks for vCPU blocking due to
-	 * HLT instruction.
-	 * Returns for .pre_block():
-	 *    - 0 means continue to block the vCPU.
-	 *    - 1 means we cannot block the vCPU since some event
-	 *        happens during this period, such as, 'ON' bit in
-	 *        posted-interrupts descriptor is set.
-	 */
-	int (*pre_block)(struct kvm_vcpu *vcpu);
-	void (*post_block)(struct kvm_vcpu *vcpu);
-
 	void (*vcpu_blocking)(struct kvm_vcpu *vcpu);
 	void (*vcpu_unblocking)(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a5ba9a069f5d..1b8804d93776 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7442,16 +7442,6 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 		secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_ENABLE_PML);
 }
 
-static int vmx_pre_block(struct kvm_vcpu *vcpu)
-{
-	return 0;
-}
-
-static void vmx_post_block(struct kvm_vcpu *vcpu)
-{
-
-}
-
 static void vmx_setup_mce(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.mcg_cap & MCG_LMCE_P)
@@ -7650,9 +7640,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
 	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
 
-	.pre_block = vmx_pre_block,
-	.post_block = vmx_post_block,
-
 	.pmu_ops = &intel_pmu_ops,
 	.nested_ops = &vmx_nested_ops,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f13a61830d9d..4a2341e4ff30 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10043,8 +10043,7 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 {
 	bool hv_timer;
 
-	if (!kvm_arch_vcpu_runnable(vcpu) &&
-	    (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu) == 0)) {
+	if (!kvm_arch_vcpu_runnable(vcpu)) {
 		/*
 		 * Switch to the software timer before halt-polling/blocking as
 		 * the guest's timer may be a break event for the vCPU, and the
@@ -10066,9 +10065,6 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 		if (hv_timer)
 			kvm_lapic_switch_to_hv_timer(vcpu);
 
-		if (kvm_x86_ops.post_block)
-			static_call(kvm_x86_post_block)(vcpu);
-
 		if (!kvm_check_request(KVM_REQ_UNHALT, vcpu))
 			return 1;
 	}
-- 
2.34.1.400.ga245620fadb-goog

