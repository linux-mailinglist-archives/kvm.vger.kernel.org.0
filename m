Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71BB5F17F5
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbiJABEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbiJABDZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:03:25 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB7222BDC
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:00:33 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h62-20020a636c41000000b0043cc1874c79so3672395pgc.5
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=eyqwbJm349LRYDQj4Q3eY3vUEz8lELViSUC9TUap8Us=;
        b=ZVOriJJzNGNQ8e+FXIjb978WN+CG2URZWCyccFMwUjllgXvPkZI+VqWjlN8zTxsEVG
         6mCPHwv5THKb2iei/AGvGCG7mIEMU+xSlMZKR4bgRIPbPf6zd3ezyloLUB0Rz/2dJT1F
         0XXagK2WdEz6RHA/z1QcJteLDvKHVn5B6f1B0U45QZ1HhMrZSDsR0wItVDojYJlfzGhs
         Z8Td61OMrGKCbqjlTXPGjqzcGzolYoGLVWW7H+iMy2bIbYM3vLbz/iiRL6CdLGilT5kk
         z2/Lr1y2lTiB2QQfM4uRjdONX6tqSn6A0CsCza2SzpkSpSsNldgyMydFLi6hNJz2Rb0c
         bU7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=eyqwbJm349LRYDQj4Q3eY3vUEz8lELViSUC9TUap8Us=;
        b=xiU/VpUTYymRbeDayasOBhg4yJadNEdikY1tV4RPDcPR4F9TU9sRHH9/hmnZ8t36Wm
         7K63NeoMDSRbx7s7lUY3NQtck7vMBtQnXWzzIoMbaHuXP0F4HRwxcS8gVh1PsQJ97HrD
         XrF3gTkvM/Pags68w4skjrNo6y04yWSn3DCBv9w8qXPt9OVdoqO1w1q7fjt0sTeY8ZhU
         KZW0MK0UEzOF5xX2ReqyL729W605E7M72F8mPKwYrzgHSweIuZciXWsw8U/dp5GkK77F
         oAAHV2n3gW1BeU+j7IBSTKR2fuYJt4rjNQIyUE4O4+F2isY7r7iS4nYUESvMhOHgbgpc
         rJ3w==
X-Gm-Message-State: ACrzQf1sVMJqzg36Sh0yP6RihFAhkugUFg3FbiJf5N2kW5bu5rw6jrHE
        ix2npmh7YQ9HhK4CUuXwhcd3ZJU3VqU=
X-Google-Smtp-Source: AMsMyM4WwT6dQV1S5TROIgrH4Ra7twSZw1IOtYSUxAtIMJ3XRfa5mSDyPvx13IcqemI4KrI+zQP2GIcNc9Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8607:0:b0:53b:13b5:2b6a with SMTP id
 p7-20020aa78607000000b0053b13b52b6amr11924368pfn.52.1664586012423; Fri, 30
 Sep 2022 18:00:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:59:15 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-33-seanjc@google.com>
Subject: [PATCH v4 32/32] KVM: x86: Track required APICv inhibits with
 variable, not callback
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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

Track the per-vendor required APICv inhibits with a variable instead of
calling into vendor code every time KVM wants to query the set of
required inhibits.  The required inhibits are a property of the vendor's
virtualization architecture, i.e. are 100% static.

Using a variable allows the compiler to inline the check, e.g. generate
a single-uop TEST+Jcc, and thus eliminates any desire to avoid checking
inhibits for performance reasons.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h    |  2 +-
 arch/x86/kvm/svm/avic.c            | 20 --------------------
 arch/x86/kvm/svm/svm.c             |  2 +-
 arch/x86/kvm/svm/svm.h             | 17 ++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c             | 24 +++++++++++-------------
 arch/x86/kvm/x86.c                 |  9 +++++++--
 7 files changed, 36 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 82ba4a564e58..533d0e804e5a 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -76,7 +76,6 @@ KVM_X86_OP(set_nmi_mask)
 KVM_X86_OP(enable_nmi_window)
 KVM_X86_OP(enable_irq_window)
 KVM_X86_OP_OPTIONAL(update_cr8_intercept)
-KVM_X86_OP(check_apicv_inhibit_reasons)
 KVM_X86_OP(refresh_apicv_exec_ctrl)
 KVM_X86_OP_OPTIONAL(hwapic_irr_update)
 KVM_X86_OP_OPTIONAL(hwapic_isr_update)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4fd06965c773..41d1c684a1e1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1566,7 +1566,7 @@ struct kvm_x86_ops {
 	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
 	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
-	bool (*check_apicv_inhibit_reasons)(enum kvm_apicv_inhibit reason);
+	const unsigned long required_apicv_inhibits;
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
 	void (*hwapic_isr_update)(int isr);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 35b0ef877e53..5b25944274b5 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -966,26 +966,6 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 	return ret;
 }
 
-bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
-{
-	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
-			  BIT(APICV_INHIBIT_REASON_ABSENT) |
-			  BIT(APICV_INHIBIT_REASON_HYPERV) |
-			  BIT(APICV_INHIBIT_REASON_NESTED) |
-			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
-			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
-			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
-			  BIT(APICV_INHIBIT_REASON_SEV)      |
-			  BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |
-			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
-			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |
-			  BIT(APICV_INHIBIT_REASON_X2APIC) |
-			  BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED);
-
-	return supported & BIT(reason);
-}
-
-
 static inline int
 avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 37fe7bcf8496..6bca3f9f39e6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4800,8 +4800,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.update_cr8_intercept = svm_update_cr8_intercept,
 	.set_virtual_apic_mode = avic_refresh_virtual_apic_mode,
 	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
-	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
 	.apicv_post_state_restore = avic_apicv_post_state_restore,
+	.required_apicv_inhibits = AVIC_REQUIRED_APICV_INHIBITS,
 
 	.get_exit_info = svm_get_exit_info,
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 29c334a932c3..dfde85782da5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -619,6 +619,22 @@ void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
 extern struct kvm_x86_nested_ops svm_nested_ops;
 
 /* avic.c */
+#define AVIC_REQUIRED_APICV_INHIBITS			\
+(							\
+	BIT(APICV_INHIBIT_REASON_DISABLE) |		\
+	BIT(APICV_INHIBIT_REASON_ABSENT) |		\
+	BIT(APICV_INHIBIT_REASON_HYPERV) |		\
+	BIT(APICV_INHIBIT_REASON_NESTED) |		\
+	BIT(APICV_INHIBIT_REASON_IRQWIN) |		\
+	BIT(APICV_INHIBIT_REASON_PIT_REINJ) |		\
+	BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |		\
+	BIT(APICV_INHIBIT_REASON_SEV)      |		\
+	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
+	BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |	\
+	BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |	\
+	BIT(APICV_INHIBIT_REASON_X2APIC) |		\
+	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED)	\
+)
 
 bool avic_hardware_setup(struct kvm_x86_ops *ops);
 int avic_ga_log_notifier(u32 ga_tag);
@@ -632,7 +648,6 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void avic_vcpu_put(struct kvm_vcpu *vcpu);
 void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu);
 void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
-bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason);
 int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 			uint32_t guest_irq, bool set);
 void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5920166d7260..54bc447ba87e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7949,18 +7949,16 @@ static void vmx_hardware_unsetup(void)
 	free_kvm_area();
 }
 
-static bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
-{
-	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
-			  BIT(APICV_INHIBIT_REASON_ABSENT) |
-			  BIT(APICV_INHIBIT_REASON_HYPERV) |
-			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
-			  BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |
-			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
-			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
-
-	return supported & BIT(reason);
-}
+#define VMX_REQUIRED_APICV_INHIBITS			\
+(							\
+	BIT(APICV_INHIBIT_REASON_DISABLE)|		\
+	BIT(APICV_INHIBIT_REASON_ABSENT) |		\
+	BIT(APICV_INHIBIT_REASON_HYPERV) |		\
+	BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |		\
+	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
+	BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |	\
+	BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED)	\
+)
 
 static void vmx_vm_destroy(struct kvm *kvm)
 {
@@ -8044,7 +8042,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
 	.apicv_post_state_restore = vmx_apicv_post_state_restore,
-	.check_apicv_inhibit_reasons = vmx_check_apicv_inhibit_reasons,
+	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
 	.hwapic_irr_update = vmx_hwapic_irr_update,
 	.hwapic_isr_update = vmx_hwapic_isr_update,
 	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a20002924eb4..b307637d9200 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10251,6 +10251,11 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
 }
 
+static bool kvm_is_required_apicv_inhibit(enum kvm_apicv_inhibit reason)
+{
+	return kvm_x86_ops.required_apicv_inhibits & BIT(reason);
+}
+
 void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -10294,7 +10299,7 @@ static void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 		return;
 
 	if (apic_x2apic_mode(vcpu->arch.apic) &&
-	    static_call(kvm_x86_check_apicv_inhibit_reasons)(APICV_INHIBIT_REASON_X2APIC))
+	    kvm_is_required_apicv_inhibit(APICV_INHIBIT_REASON_X2APIC))
 		kvm_inhibit_apic_access_page(vcpu);
 
 	__kvm_vcpu_update_apicv(vcpu);
@@ -10307,7 +10312,7 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 
 	lockdep_assert_held_write(&kvm->arch.apicv_update_lock);
 
-	if (!static_call(kvm_x86_check_apicv_inhibit_reasons)(reason))
+	if (!kvm_is_required_apicv_inhibit(reason))
 		return;
 
 	old = new = kvm->arch.apicv_inhibit_reasons;
-- 
2.38.0.rc1.362.ged0d419d3c-goog

