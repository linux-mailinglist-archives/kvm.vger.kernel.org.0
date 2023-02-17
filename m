Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E98A769B651
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 00:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjBQXLd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 18:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjBQXLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 18:11:11 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857226C01D
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 15:10:44 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 64-20020a250243000000b007eba3f8e3baso2338506ybc.4
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 15:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6T3Gs2nuLFt+Gi9I5SyZU1o7dxUXgiYSrrrG2VNSMxo=;
        b=Wt0DYMxGoRYkGatQPo0coKl/wrq7XW9qyPmdmUcYgYWqmxuF681eSGUYynQunnMGGC
         xzoG074xtnXxckeWUMdMuWVp2SSsVy1IiIfyNm+dk/D+Zv5n0TgI4qxGq4xHjEnajKC+
         2FBcS7lAs0bdc3CeB1Thb5ALnwV3m3OShvahkhL79qyWZ0amtCnp98lLVxLvyyLiDNFK
         4JOfuA8IXxUJM3RkOO+9eIgwPp3lnHjBjV184/6Ezh1U9VNqdoYwI5xPccf4SbfjHGAA
         5reeKVcnzRZdWBLPF4eaCJI3zTWyXmGD0sq8YUOxeM6NXFHtC8VCb4PtWvcXfLbItS0t
         9TbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6T3Gs2nuLFt+Gi9I5SyZU1o7dxUXgiYSrrrG2VNSMxo=;
        b=17BT9fvf6jUjExauDps5YeZf7cdMXro3NjPSNqkMRYBrNK1XZkF/skITSVGqNJU2lg
         k28R/tJ7E/gHTNokvVLlrmoAZaRNL/E7/FRviyN/380ikHrAJUe0ICu9UU/ZxfegyErM
         s8pzhxpfmNa6nn4q/aDE7KUl+ExRIDaeiVFft+qRNTeCwqp86FFMKKBey2/RrAOQLb+m
         dGHLAK18+A+49IPE1u0CZ4c+/1Zn7QveE9lYukLWYfK+1QFDISi2w7WJBqE1Q1RoDr+a
         cLEgdDdm73/RyX7oJoPYVn7bjSg6hiZ7H36ka64J0X6CzH58LruULf7/zxxcP/Wf+Xnw
         gtng==
X-Gm-Message-State: AO0yUKWntktyWZNJzpkruFgyFd3Z9MbdWvQobT57/eSrmEGbXUGvzuS/
        aJtfrGYopZIeBs2VyTZ6jMRj7hmF3Ec=
X-Google-Smtp-Source: AK7set+BLiMCMLxrwe6aIMejKhKuKOHIkqsRRgXPHUHo62iVRzAIWpbn42fyi84tYEqZIDTg3o5M2pCNiBk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10c:b0:997:c919:4484 with SMTP id
 o12-20020a056902010c00b00997c9194484mr16415ybh.6.1676675442720; Fri, 17 Feb
 2023 15:10:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 17 Feb 2023 15:10:19 -0800
In-Reply-To: <20230217231022.816138-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230217231022.816138-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230217231022.816138-10-seanjc@google.com>
Subject: [PATCH 09/12] KVM: nSVM: Use KVM-governed feature framework to track
 "LBRv enabled"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track "LBR virtualization exposed to L1" via a governed feature flag
instead of using a dedicated bit/flag in vcpu_svm.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/governed_features.h |  1 +
 arch/x86/kvm/svm/nested.c        | 23 +++++++++++++----------
 arch/x86/kvm/svm/svm.c           |  7 +++++--
 arch/x86/kvm/svm/svm.h           |  1 -
 4 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index b66b9d550f33..16c58d61bdf6 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -10,6 +10,7 @@ KVM_GOVERNED_X86_FEATURE(XSAVES)
 KVM_GOVERNED_X86_FEATURE(NRIPS)
 KVM_GOVERNED_X86_FEATURE(TSCRATEMSR)
 KVM_GOVERNED_X86_FEATURE(V_VMSAVE_VMLOAD)
+KVM_GOVERNED_X86_FEATURE(LBRV)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6a96058c0e48..9e210b03e635 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -540,6 +540,7 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	bool new_vmcb12 = false;
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	nested_vmcb02_compute_g_pat(svm);
 
@@ -565,18 +566,18 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		vmcb_mark_dirty(vmcb02, VMCB_DT);
 	}
 
-	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
+	kvm_set_rflags(vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
 
-	svm_set_efer(&svm->vcpu, svm->nested.save.efer);
+	svm_set_efer(vcpu, svm->nested.save.efer);
 
-	svm_set_cr0(&svm->vcpu, svm->nested.save.cr0);
-	svm_set_cr4(&svm->vcpu, svm->nested.save.cr4);
+	svm_set_cr0(vcpu, svm->nested.save.cr0);
+	svm_set_cr4(vcpu, svm->nested.save.cr4);
 
 	svm->vcpu.arch.cr2 = vmcb12->save.cr2;
 
-	kvm_rax_write(&svm->vcpu, vmcb12->save.rax);
-	kvm_rsp_write(&svm->vcpu, vmcb12->save.rsp);
-	kvm_rip_write(&svm->vcpu, vmcb12->save.rip);
+	kvm_rax_write(vcpu, vmcb12->save.rax);
+	kvm_rsp_write(vcpu, vmcb12->save.rsp);
+	kvm_rip_write(vcpu, vmcb12->save.rip);
 
 	/* In case we don't even reach vcpu_run, the fields are not updated */
 	vmcb02->save.rax = vmcb12->save.rax;
@@ -590,7 +591,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		vmcb_mark_dirty(vmcb02, VMCB_DR);
 	}
 
-	if (unlikely(svm->lbrv_enabled && (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
+	if (unlikely(guest_can_use(vcpu, X86_FEATURE_LBRV) &&
+		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
 		/*
 		 * Reserved bits of DEBUGCTL are ignored.  Be consistent with
 		 * svm_set_msr's definition of reserved bits.
@@ -712,7 +714,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 
 	vmcb02->control.virt_ext            = vmcb01->control.virt_ext &
 					      LBR_CTL_ENABLE_MASK;
-	if (svm->lbrv_enabled)
+	if (guest_can_use(vcpu, X86_FEATURE_LBRV))
 		vmcb02->control.virt_ext  |=
 			(svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK);
 
@@ -1021,7 +1023,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
-	if (unlikely(svm->lbrv_enabled && (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
+	if (unlikely(guest_can_use(vcpu, X86_FEATURE_LBRV) &&
+		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
 		svm_copy_lbrs(vmcb12, vmcb02);
 		svm_update_lbrv(vcpu);
 	} else if (unlikely(vmcb01->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b3f0271c73b9..42591c77f98a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -994,9 +994,11 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
 	bool current_enable_lbrv = !!(svm->vmcb->control.virt_ext &
 				      LBR_CTL_ENABLE_MASK);
 
-	if (unlikely(is_guest_mode(vcpu) && svm->lbrv_enabled))
+	if (unlikely(is_guest_mode(vcpu) &&
+		     guest_can_use(vcpu, X86_FEATURE_LBRV))) {
 		if (unlikely(svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))
 			enable_lbrv = true;
+	}
 
 	if (enable_lbrv == current_enable_lbrv)
 		return;
@@ -4149,7 +4151,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	if (tsc_scaling)
 		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_TSCRATEMSR);
 
-	svm->lbrv_enabled = lbrv && guest_cpuid_has(vcpu, X86_FEATURE_LBRV);
+	if (lbrv)
+		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_LBRV);
 
 	if (vls && !guest_cpuid_is_intel(vcpu))
 		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1e3e7462b1d7..60817ff346b0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -258,7 +258,6 @@ struct vcpu_svm {
 	bool soft_int_injected;
 
 	/* optional nested SVM features that are enabled for this guest  */
-	bool lbrv_enabled                 : 1;
 	bool pause_filter_enabled         : 1;
 	bool pause_threshold_enabled      : 1;
 	bool vgif_enabled                 : 1;
-- 
2.39.2.637.g21b0678d19-goog

