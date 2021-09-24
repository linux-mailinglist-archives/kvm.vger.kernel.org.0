Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287E641758B
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346008AbhIXNZd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345341AbhIXNY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:24:59 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABD7C08EB31
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:36 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id 100-20020aed30ed000000b002a6b3dc6465so22819027qtf.13
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=56Ft6X8W77hY1O7BY33JIx3hfVz1zTOJLBEzRbdZLVw=;
        b=bNf2MAkSxeUvnC8APurNJOKp8j5WNRVTRWXn3WErUfYnVGPg5v/3n5gcIVXKw4t9W+
         ++aRVwRIoyywjT6TVBxQg1NUQyGIG0VzdvUVrPmsmOd0j6qsR/jOMsEc8AodGDClGEYE
         ilc5+eCrH2jUWhkTldhPyKFHm6/CQrcZGo/No50sHneGSa0fwYmSP74YwjfYULkYD+hn
         c5Y2MjS7Qyto3oZ343G5CHx9di3IAseWbWfsc1zBK/cjTfGcfNSlwFNI2q+xAnHGH574
         EU/1NvgGryTNgZSf9rJArmTNgJZZQh+vL1Qo+AIO/e4ZwxL72jO5CZVB43cxyj7O4E83
         ruhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=56Ft6X8W77hY1O7BY33JIx3hfVz1zTOJLBEzRbdZLVw=;
        b=Rf1BbILvmc5PRnoa8iBehiU4qeB27pdsuEm+MD9JYXP3hG6ZLy7fdE/0Udg9Ik0WY6
         5torGRvRrRj7288HRDafL7akY12QE5O2IPEmJhMqvZzpuPZP/0asCxbUt3LFRYBDbrj7
         KYFQWfTfsMnxDL859q2vbfN8mMQtPYblO2Ewh1Z3PKXKFRUyMyJBBClHNn17/xmiQFQr
         VGeSHVDnv1OBFvBeaIo3Wvjb83fvAsTCx3ZBKddo2ZweF0awBHO2DXFVDwyOGKmkmNhN
         vQvbBVGG/aLr1QM/dpDaLbwtdowwTbTmSjf70GNBWuydvQns9R2QJBmMvil05mip7iat
         q7iQ==
X-Gm-Message-State: AOAM530ClszEEDWYi8HYyhlk0ACaAUrm3vc5mYdtHtHldMFZu9PmYiY4
        oClL2SNWcHK2jcNYDDik5cOfI8SBVg==
X-Google-Smtp-Source: ABdhPJyUkz++TQP8NYy0o2i3otydUYMEFbi7J6On+R3jI66SeEyVA2YIEWBaY5/7X1wyxFyCNX3yufb4nQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:cb10:: with SMTP id o16mr10045783qvk.57.1632488075438;
 Fri, 24 Sep 2021 05:54:35 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:45 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-17-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 16/30] KVM: arm64: reduce scope of vgic_v3 access parameters
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

Now that the __vgic_v3_perform_cpuif_access only needs
vgic_v3_cpu_if, kvm_cpu_context, vcpu_hyps, pass these rather
than the whole vcpu.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h        | 4 +++-
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c         | 9 ++++-----
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index d9a8872a7efb..b379c2b96f33 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -63,7 +63,9 @@ void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if);
-int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
+int __vgic_v3_perform_cpuif_access(struct vgic_v3_cpu_if *cpu_if,
+				   struct kvm_cpu_context *vcpu_ctxt,
+				   struct vcpu_hyp_state *vcpu_hyps);
 
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __timer_enable_traps(void);
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 30fcfe84f609..44e76993a9b4 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -502,7 +502,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, struct vgic_dist *vgi
 	if (static_branch_unlikely(&vgic_v3_cpuif_trap) &&
 	    (kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 ||
 	     kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_CP15_32)) {
-		int ret = __vgic_v3_perform_cpuif_access(vcpu);
+		int ret = __vgic_v3_perform_cpuif_access(&vcpu->arch.vgic_cpu.vgic_v3, vcpu_ctxt, vcpu_hyps);
 
 		if (ret == 1)
 			goto guest;
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 3e1951b04fce..2c16e0cd45f0 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -1097,11 +1097,10 @@ static void __vgic_v3_write_ctlr(struct vgic_v3_cpu_if *cpu_if,
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
 
-int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
+int __vgic_v3_perform_cpuif_access(struct vgic_v3_cpu_if *cpu_if,
+				   struct kvm_cpu_context *vcpu_ctxt,
+				   struct vcpu_hyp_state *vcpu_hyps)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	int rt;
 	u32 esr;
 	u32 vmcr;
@@ -1112,7 +1111,7 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 
 	esr = kvm_hyp_state_get_esr(vcpu_hyps);
 	if (ctxt_mode_is_32bit(vcpu_ctxt)) {
-		if (!kvm_condition_valid(vcpu)) {
+		if (!__kvm_condition_valid(vcpu_ctxt, vcpu_hyps)) {
 			__kvm_skip_instr(vcpu_ctxt, vcpu_hyps);
 			return 1;
 		}
-- 
2.33.0.685.g46640cef36-goog

