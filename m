Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3448C427650
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 04:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244707AbhJICSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 22:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244289AbhJICRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 22:17:48 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEDFC0613B8
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 19:14:06 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id 100-20020aed30ed000000b002a6b3dc6465so8821755qtf.13
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 19:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=vAfx5V7oXhMQdNK6n8fKDF9GGCBj6ltSzPsyuPD42Bs=;
        b=HyCTY7JAidC//XRRYdKJX4UqDMF+OOF3bUAiJb+P7QyZ+wCs6Z/juMFKBQx23iMMVN
         cqVP/RAmIlHJJh/IhCDJgzpkP3/4PSr5HvmGU1YPAIdroNNdN/LgWT1sdedqNCFyThVJ
         OB3PsHG+5QPOxxfyOCjKqjYqJ4/3yZaYt4IJa7HdBQLnErOW6mzpDjvlQYRWWwwhfSDr
         es8zEbyw0sk5VgOb2rS8SbWA9aRFUd6GPvV5QVuzDE3suPpPWMfVuh4VMHrQBClBm931
         uNAJ7v8jb3UYDmZvbfs/UX4HaL+qaNp7Uu3y1027BulayBFMmGfZVNaeWs+z9FeE6i1a
         QWaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=vAfx5V7oXhMQdNK6n8fKDF9GGCBj6ltSzPsyuPD42Bs=;
        b=Lyo/2RAtU3+nFUG7dgYI47MNCWuVhquLQbF6gCq3oqq2ClYwJSU+tMfV+qH+cgXZbS
         AvP5ezj0HH8/BaiYr86BlS6+tjdD+LkfU6QnyMfPkYjLU7tkiw2i4gSRK26XpPM3Pl8f
         nDrZ0waekyc+rP6LLX6Bg2Mk8UsEprEcV2mDTMz4MySz3nSg9KzKyR3eEPzyMU+2v5MT
         azeSd00rAu2ugATYzqvhj4WRIjzKZnH2eSJitv6fWXC9++JckB35WQDdKfpfX/w4//CK
         6RxzHIfD2aamn6ZRMUn5Z+OSGQjJPsS1PkbLs94V+5/8R8ZVVTl+xZTYrKw7DXYqUsiB
         pt1w==
X-Gm-Message-State: AOAM531aRE+eZif7tbNiAdBotr/P/19Y1dfSPyiXHUuQtcnpKZjUDb7Y
        W2zl/oEbnKEm2OIPzkCuysAYXY6Xmt4=
X-Google-Smtp-Source: ABdhPJx91iwUKT3XNp8Nkk81qQnI7CC/+A7yDe4tFSaroMx6ORDJ7jKPf6Pp/KOtyNzdi03H7gazxyAr7d8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:ac8:5c0a:: with SMTP id i10mr1952886qti.23.1633745645576;
 Fri, 08 Oct 2021 19:14:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:27 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-35-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 34/43] KVM: x86: Remove defunct pre_block/post_block
 kvm_x86_ops hooks
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop kvm_x86_ops' pre/post_block() now that all implementations are nops.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
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
index 328103a520d3..76a8dddc1a48 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1445,18 +1445,6 @@ struct kvm_x86_ops {
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
index a24f19874716..13e732a818f3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7462,16 +7462,6 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
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
@@ -7665,9 +7655,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
 	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
 
-	.pre_block = vmx_pre_block,
-	.post_block = vmx_post_block,
-
 	.pmu_ops = &intel_pmu_ops,
 	.nested_ops = &vmx_nested_ops,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 909e932a7ae7..9643f23c28c7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9898,8 +9898,7 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 {
 	bool hv_timer;
 
-	if (!kvm_arch_vcpu_runnable(vcpu) &&
-	    (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu) == 0)) {
+	if (!kvm_arch_vcpu_runnable(vcpu)) {
 		/*
 		 * Switch to the software timer before halt-polling/blocking as
 		 * the guest's timer may be a break event for the vCPU, and the
@@ -9921,9 +9920,6 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 		if (hv_timer)
 			kvm_lapic_switch_to_hv_timer(vcpu);
 
-		if (kvm_x86_ops.post_block)
-			static_call(kvm_x86_post_block)(vcpu);
-
 		if (!kvm_check_request(KVM_REQ_UNHALT, vcpu))
 			return 1;
 	}
-- 
2.33.0.882.g93a45727a2-goog

