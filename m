Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC53C367622
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 02:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244166AbhDVASP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 20:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhDVASO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 20:18:14 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD007C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 17:17:39 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o187-20020a2528c40000b02904e567b4bf7eso17910973ybo.10
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 17:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=TNz2FBkufKTcsHNiDDGsGzoST1t4D0jYYkLUrh9Lj04=;
        b=C52ABESOBrQ4hNk64m0bvImdImzscUFZkE9fKNI8cNC5fKiZBxy6+c88xmZQC5LQyN
         Urd/GAfviJZzejYGOvef1zX24doxtW3P/Vb57eG+/X0IdecFqG39RdglldYeb3SIAxxk
         Sxx+8fZx3wHFtRkr9fjiv2q0mJ+zknI3j+K+k69h0j1xlp/IY6J5MiL2YzTaDTpcDtF+
         kOTznXRepw+L5OGm0omSVRs0v9lokZiSwmnc79U62K/fqpHDwTSzWMe3rFiMYc2BjYxf
         dHDYDZa9ZcP2Zs8q0fchkfdBn8uMlVGUKNjrpGbBvm/CTmk/H+mI8zAhQa7ARIU2n5fH
         bezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=TNz2FBkufKTcsHNiDDGsGzoST1t4D0jYYkLUrh9Lj04=;
        b=XwDg3Nrf4pGIqAaAhWzx6hwk0BAJdeINs941lRzl+Zq52kdWbckf/nBa5V2x8CFyJP
         x1HdpPdrThKr+l8K62uysVzDabb9YJdComaKjnDjxUd1tk4gJfSpKuUsFiAMi/Q1SjAj
         +wJeeQoKs2Nyyh7wwJ91ZmB+K0L3Zds3wwdud8yr78yvDLfP1/2Z3Tl0qyg7oiA5e+sd
         VaHsgYsGYkQ0kRb1UkXz9k/rocOpYnPNQryeDS9H4EVLu1d5BOBcMAmS1EjGgMmDya9u
         I/SVARR2h215OPcPIkwdYxxJEQxCjwXOf/gtD4qRZctH2+gC9hAhwhTG03ZfeoSa3h+a
         RaKg==
X-Gm-Message-State: AOAM530rsBqQNRQG1b34bwWMeH2RHte3+hzVvsM4GuSmcck2CNhDvHpQ
        v+D8m+Q+hVOvr6MFpg6uaeDitdUz+Oo=
X-Google-Smtp-Source: ABdhPJxCA7boQtZvF+ipmEriSnoFhgjHaPGn/Kl5s0CwWWHcFjqB40SgM7QMqzcAJUaTzpOxLuzIOE0rnWk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:7603:: with SMTP id r3mr873838ybc.272.1619050658986;
 Wed, 21 Apr 2021 17:17:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 17:17:36 -0700
Message-Id: <20210422001736.3255735-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2] KVM: SVM: Delay restoration of host MSR_TSC_AUX until
 return to userspace
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use KVM's "user return MSRs" framework to defer restoring the host's
MSR_TSC_AUX until the CPU returns to userspace.  Add/improve comments to
clarify why MSR_TSC_AUX is intercepted on both RDMSR and WRMSR, and why
it's safe for KVM to keep the guest's value loaded even if KVM is
scheduled out.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---

v2: Rebased to kvm/queue (ish), commit 0e91d1992235 ("KVM: SVM: Allocate SEV
    command structures on local stack")
 
 arch/x86/kvm/svm/svm.c | 50 ++++++++++++++++++------------------------
 arch/x86/kvm/svm/svm.h |  7 ------
 2 files changed, 21 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cd8c333ed2dc..596361449f25 100644
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
@@ -2893,12 +2882,15 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			return 1;
 
 		/*
-		 * This is rare, so we update the MSR here instead of using
-		 * direct_access_msrs.  Doing that would require a rdmsr in
-		 * svm_vcpu_put.
+		 * TSC_AUX is usually changed only during boot and never read
+		 * directly.  Intercept TSC_AUX instead of exposing it to the
+		 * guest via direct_acess_msrs, and switch it via user return.
 		 */
 		svm->tsc_aux = data;
-		wrmsrl(MSR_TSC_AUX, svm->tsc_aux);
+
+		preempt_disable();
+		kvm_set_user_return_msr(TSC_AUX_URET_SLOT, data, -1ull);
+		preempt_enable();
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		if (!boot_cpu_has(X86_FEATURE_LBRV)) {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 454da1c1d9b7..9dce6f290041 100644
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
 
@@ -128,8 +123,6 @@ struct vcpu_svm {
 
 	u64 next_rip;
 
-	u64 host_user_msrs[NR_HOST_SAVE_USER_MSRS];
-
 	u64 spec_ctrl;
 	/*
 	 * Contains guest-controlled bits of VIRT_SPEC_CTRL, which will be
-- 
2.31.1.498.g6c1eba8ee3d-goog

