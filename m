Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82735369CCE
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 00:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244176AbhDWWfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 18:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244060AbhDWWe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 18:34:58 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17841C061574
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 15:34:20 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id k12-20020a05620a0b8cb02902e028cc62baso15546656qkh.17
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 15:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=W0FsZgKrGD/FRL2xwnIckJkdwWI7yxmbTghAbdzf5Sc=;
        b=Iyor596ihpz1j4rciZ/W2f1ON2t53sv+AVrjqaO7ZAAOAj+be+Hxk+i+OTmgVYMxGh
         2EijwHDTftvNRbPG2Sy+dJXc0laVixVeqZR5JDfwN4O4KwOuUuBykwVMK7iTNWRGu/Nh
         UDQBlv2QSrZBagAG2E4Xk5QY7G8tvsOwDs8owCFlEM8NAv2P44wOZGT7KCkk1n4Wi5cD
         Aqp6d1mmZEf7dIdRjV5CRYhqq7I4SPe0gn0ovzD11xeA29kRGdRUoU+rv2DVc8hYAZhU
         3/H1rsTQrhhU2MglUGXd5LJPCOJwlQlRCyd1hnNXYGJeuzJYZee++l0hxRWG4NfQct4H
         sGjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=W0FsZgKrGD/FRL2xwnIckJkdwWI7yxmbTghAbdzf5Sc=;
        b=scfRz8g90Z9BAvBg2AjGzcFNyRRBJDbAfuLZYNayZvjWCjEro4IK/7jtdgqVcvdgwb
         BqKQjtHLo+RlW/CPdrP3mVy4sGrijbTHyQmc5sSIxL4wATzEQ4TO3jGnWalhBA+FPNPg
         MIPyjj7woi0B48pqVgzloBDfQHKckMGb0iah7Y4ETNJddCfZvtvGmzFLGiMZ+ucXQoBN
         6isMSW55Ogy/vSSfWwN9360OBFH8zvwjDS9hItkL5eN3gJEq37YlDGVJOSk19uxPiPuy
         J/36Si6KmFHb7kQ+s7YdwHfz2uN/NXBv4pHztE00+iYfRgzlp4sr3PUBHWVzi4qSlISJ
         e4dQ==
X-Gm-Message-State: AOAM532J8s9aWGwKIqkkyHTaOMx9/JXK93b8VlSnCBIj3g7qnmPnyQDy
        5OiUmQUA1XoN+8CYLsyatlzIxb9hZAM=
X-Google-Smtp-Source: ABdhPJwKOk1AWyr9bMoQUdeSREhAWALjm4o4jVWciBFB9eOEw+sue3i6ihgCZu89/JCQ6XK93XsNX28Hzhg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a05:6214:a8d:: with SMTP id
 ev13mr6868770qvb.23.1619217259300; Fri, 23 Apr 2021 15:34:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 15:34:04 -0700
In-Reply-To: <20210423223404.3860547-1-seanjc@google.com>
Message-Id: <20210423223404.3860547-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210423223404.3860547-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v3 4/4] KVM: SVM: Delay restoration of host MSR_TSC_AUX until
 return to userspace
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use KVM's "user return MSRs" framework to defer restoring the host's
MSR_TSC_AUX until the CPU returns to userspace.  Add/improve comments to
clarify why MSR_TSC_AUX is intercepted on both RDMSR and WRMSR, and why
it's safe for KVM to keep the guest's value loaded even if KVM is
scheduled out.

Cc: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 52 +++++++++++++++++++-----------------------
 arch/x86/kvm/svm/svm.h |  7 ------
 2 files changed, 23 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4c7604fca009..a4bd7cb19755 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -213,6 +213,15 @@ struct kvm_ldttss_desc {
 
 DEFINE_PER_CPU(struct svm_cpu_data *, svm_data);
 
+/*
+ * Only MSR_TSC_AUX is switched via the user return hook.  EFER is switched via
+ * the VMCB, and the SYSCALL/SYSENTER MSRs are handled by VMLOAD/VMSAVE.
+ *
+ * RDTSCP and RDPID are not used in the kernel, specifically to allow KVM to
+ * defer the restoration of TSC_AUX until the CPU returns to userspace.
+ */
+#define TSC_AUX_URET_SLOT	0
+
 static const u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
 
 #define NUM_MSR_MAPS ARRAY_SIZE(msrpm_ranges)
@@ -958,6 +967,9 @@ static __init int svm_hardware_setup(void)
 		kvm_tsc_scaling_ratio_frac_bits = 32;
 	}
 
+	if (boot_cpu_has(X86_FEATURE_RDTSCP))
+		kvm_define_user_return_msr(TSC_AUX_URET_SLOT, MSR_TSC_AUX);
+
 	/* Check for pause filtering support */
 	if (!boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
 		pause_filter_count = 0;
@@ -1423,19 +1435,10 @@ static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
-	unsigned int i;
 
 	if (svm->guest_state_loaded)
 		return;
 
-	/*
-	 * Certain MSRs are restored on VMEXIT (sev-es), or vmload of host save
-	 * area (non-sev-es). Save ones that aren't so we can restore them
-	 * individually later.
-	 */
-	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
-		rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
-
 	/*
 	 * Save additional host state that will be restored on VMEXIT (sev-es)
 	 * or subsequent vmload of host save area.
@@ -1454,29 +1457,15 @@ static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	/* This assumes that the kernel never uses MSR_TSC_AUX */
 	if (static_cpu_has(X86_FEATURE_RDTSCP))
-		wrmsrl(MSR_TSC_AUX, svm->tsc_aux);
+		kvm_set_user_return_msr(TSC_AUX_URET_SLOT, svm->tsc_aux, -1ull);
 
 	svm->guest_state_loaded = true;
 }
 
 static void svm_prepare_host_switch(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-	unsigned int i;
-
-	if (!svm->guest_state_loaded)
-		return;
-
-	/*
-	 * Certain MSRs are restored on VMEXIT (sev-es), or vmload of host save
-	 * area (non-sev-es). Restore the ones that weren't.
-	 */
-	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
-		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
-
-	svm->guest_state_loaded = false;
+	to_svm(vcpu)->guest_state_loaded = false;
 }
 
 static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
@@ -2785,6 +2774,7 @@ static int svm_set_vm_cr(struct kvm_vcpu *vcpu, u64 data)
 static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	int r;
 
 	u32 ecx = msr->index;
 	u64 data = msr->data;
@@ -2888,11 +2878,15 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		break;
 	case MSR_TSC_AUX:
 		/*
-		 * This is rare, so we update the MSR here instead of using
-		 * direct_access_msrs.  Doing that would require a rdmsr in
-		 * svm_vcpu_put.
+		 * TSC_AUX is usually changed only during boot and never read
+		 * directly.  Intercept TSC_AUX instead of exposing it to the
+		 * guest via direct_access_msrs, and switch it via user return.
 		 */
-		wrmsrl(MSR_TSC_AUX, svm->tsc_aux);
+		preempt_disable();
+		r = kvm_set_user_return_msr(TSC_AUX_URET_SLOT, data, -1ull);
+		preempt_enable();
+		if (r)
+			return 1;
 
 		svm->tsc_aux = data;
 		break;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d6206196eec1..5d8027e9c1c5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -23,11 +23,6 @@
 
 #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
 
-static const u32 host_save_user_msrs[] = {
-	MSR_TSC_AUX,
-};
-#define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
-
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
@@ -129,8 +124,6 @@ struct vcpu_svm {
 
 	u64 next_rip;
 
-	u64 host_user_msrs[NR_HOST_SAVE_USER_MSRS];
-
 	u64 spec_ctrl;
 	/*
 	 * Contains guest-controlled bits of VIRT_SPEC_CTRL, which will be
-- 
2.31.1.498.g6c1eba8ee3d-goog

