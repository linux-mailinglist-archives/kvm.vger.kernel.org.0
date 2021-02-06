Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8BC311934
	for <lists+kvm@lfdr.de>; Sat,  6 Feb 2021 04:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhBFC5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 21:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhBFCbz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 21:31:55 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E152C08EE5E
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 16:32:29 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id u66so7293105qkd.13
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 16:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=pp8fidxQDUFla17Oiws2IWIbULFigNiSSfGs09JA2vk=;
        b=b18RVzQAnJVFPbIGZXNu0CUWEM+61tFcDjq8Je09drj6fLcNJTF1NaXKxkkMLUkr6L
         hLhW6mZaPUnoLEVlClJ8a/YZ09VuBKt643gRBGpG86g3ufH5iEwsVXMRDM+HUP+pv7Q6
         8W39vR6OWGTMsifsOtyYyDQQwO2wRjwXOWkcJNVPlsRJWtkH713+vbzEcxV809UrG21N
         IxFczrmXiUVIc+yF3SGWL2C7IBJB9Unw0NVIsuWLLljk+3a2EEoF0UpL33QCRmBAYO95
         cf2/zuoWem4+PoL3tzj9G0Smo0zWg5qnsxcSgqlXA01D+BuIu9hmydC3TcxboGNgvDOK
         ottg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=pp8fidxQDUFla17Oiws2IWIbULFigNiSSfGs09JA2vk=;
        b=oPaInUjsTPfXTwNGSyjVp62PLXaXLaJ8MouPMpNpFzv9XHEo45/IxpILQYkHbueWik
         v4NNQpNETGZirWfoNL/k0bOtA27e2wYsya5VpDWNM2hFAliwUggNImuMFDEOs9qV+t4c
         /2VlRWVB4Oup1OE9A6HvKQaT6cdF5fY/BZsyqstRzNUeg+7H4rz5QAVixztfPWMceUaW
         jN3Y/mE3SZU0ny9DkIAhPsM86Ge/oS/T8D0OWTe4w+uBUYnRYwDxZrnMis18RvNY3Dae
         d1VQ2nJt5KjIs51XERormgZJ8CBq0f5ElMBQF+pIb947o5qXiMYxD6sYl2XxkFOYtTRe
         Q7Gg==
X-Gm-Message-State: AOAM532UoVsqtHQjnNBcrNE3XK/X36PQD0b1Eqj5dpKGZfv60tWHSC9L
        Y7YvVinhpOf8QdhvOfp8oQveBeFlohM=
X-Google-Smtp-Source: ABdhPJyNOekQxKxWr22DCjEyGNcytvgr4nXfqY1cTHSIF2dulDCnKdFw/f5Ec8jjKbcfP7TsurNgQtrPFpY=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:d169:a9f7:513:e5])
 (user=seanjc job=sendgmr) by 2002:ad4:4993:: with SMTP id t19mr6916734qvx.41.1612571548281;
 Fri, 05 Feb 2021 16:32:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Feb 2021 16:32:24 -0800
Message-Id: <20210206003224.302728-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH] KVM: SVM: Delay restoration of host MSR_TSC_AUX until return
 to userspace
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
 arch/x86/kvm/svm/svm.c | 50 ++++++++++++++++++------------------------
 arch/x86/kvm/svm/svm.h |  7 ------
 2 files changed, 21 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4141caea857a..a5231a8841ff 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -220,6 +220,15 @@ struct kvm_ldttss_desc {
 
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
@@ -965,6 +974,9 @@ static __init int svm_hardware_setup(void)
 		kvm_tsc_scaling_ratio_frac_bits = 32;
 	}
 
+	if (boot_cpu_has(X86_FEATURE_RDTSCP))
+		kvm_define_user_return_msr(TSC_AUX_URET_SLOT, MSR_TSC_AUX);
+
 	/* Check for pause filtering support */
 	if (!boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
 		pause_filter_count = 0;
@@ -1418,19 +1430,10 @@ static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
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
@@ -1449,29 +1452,15 @@ static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
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
@@ -2948,12 +2937,15 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
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
index 39e071fdab0c..4053f564e27e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -23,11 +23,6 @@
 
 #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
 
-static const u32 host_save_user_msrs[] = {
-	MSR_TSC_AUX,
-};
-#define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
-
 #define MAX_DIRECT_ACCESS_MSRS	18
 #define MSRPM_OFFSETS	16
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
@@ -115,8 +110,6 @@ struct vcpu_svm {
 
 	u64 next_rip;
 
-	u64 host_user_msrs[NR_HOST_SAVE_USER_MSRS];
-
 	u64 spec_ctrl;
 	/*
 	 * Contains guest-controlled bits of VIRT_SPEC_CTRL, which will be
-- 
2.30.0.478.g8a0d178c01-goog

