Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8FE3F91A5
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 03:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244072AbhH0A7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 20:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243968AbhH0A6l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 20:58:41 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E59C06129E
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 17:57:52 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id m6-20020ac807c6000000b0029994381c5fso229974qth.5
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 17:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=APlw6FoeYyjS3BPQZoCRIAf0ql6GYvWTuNomlW8snXU=;
        b=LuT11C5Peh4krF2EeyCdRCxcbNvhcakRbKzYpV3qZ6O2Z4PVpX/pEIk2oLYVzCzATI
         LirVe+4RAAMNQA5oiT6FeR7Vf9UzP3TZBQ1RW6eIIDw0eYoqjBIHJCOb3m7m1RgUcZdn
         bOJ3i8Ik5ehFXpmB//AMa+N0DT/avx0k1s6Bh0Z4wQ47vO3Y5BHzjhy1obtH40imLbdg
         1DczFHZq/wmvU1GEirxYMIFLIuwM5dyIeEobru75ofGyf5WLMEq8/LlYDYJwN2l4QhOG
         8GED2Mpk3QJ4QR32vEcxwTxNC2AHBjbOsMdxCn7mUPHsS1u7SGXczKvCreOLUwK7WywP
         dKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=APlw6FoeYyjS3BPQZoCRIAf0ql6GYvWTuNomlW8snXU=;
        b=qZ8BmFwKra7eFHZXq0UdeRqgr+s+V+DiKJEBgvzo3hE/YZrMElGaYAUxAqJSgh/0FH
         +u7CbY3D5QEI/2ZmWSdULsuwUOuwONb2ReNFuocYbcoMtkA6UeuIxqewm71EOAmswuyb
         E0ECR1BEyCn2wmbILHjIKDBV+Tqj1Q5lAVwnc9R1dY5sClWXrFvLnP386mohCkClHLiQ
         8tHM4XxCwsXFC73YH1RVlxjmjCPC5tMAhzPaqVxbbbt8gnNOVm364POQB8SdDDdXLkAB
         zrC+tuwZrQaA6BQX5nIqxEPrImjh25aSn89KWx7QbXoJ5kin/94rhfOcr6SEV0GY6EHQ
         VYZw==
X-Gm-Message-State: AOAM532B5gJMe+hv7p1Mk9dfcZw05IAPvZ5tyZLb++7adOFynHW18aj3
        q3YuDTUdldXmLUpl7ha/49csg0JxzhY=
X-Google-Smtp-Source: ABdhPJxV8SLmQ7eQT1AmY1MtULBcvEHZk3qClIQX5AbSsyjIRBSmPH3McGvB8qU+Qq94IjkJESGPvkRvUxQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:c16c:db05:96b2:1475])
 (user=seanjc job=sendgmr) by 2002:a05:6214:2465:: with SMTP id
 im5mr7220558qvb.46.1630025871976; Thu, 26 Aug 2021 17:57:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 26 Aug 2021 17:57:13 -0700
In-Reply-To: <20210827005718.585190-1-seanjc@google.com>
Message-Id: <20210827005718.585190-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210827005718.585190-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 10/15] KVM: Move x86's perf guest info callbacks to generic KVM
From:   Sean Christopherson <seanjc@google.com>
To:     Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move x86's perf guest callbacks into common KVM, as they are semantically
identical to arm64's callbacks (the only other such KVM callbacks).
arm64 will convert to the common versions in a future patch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 48 +++++----------------------------
 arch/x86/kvm/x86.h              |  6 -----
 include/linux/kvm_host.h        | 12 +++++++++
 virt/kvm/kvm_main.c             | 46 +++++++++++++++++++++++++++++++
 5 files changed, 66 insertions(+), 47 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 465b35736d9b..63553a1f43ee 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -36,6 +36,7 @@
 #include <asm/hyperv-tlfs.h>
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
+#define __KVM_WANT_PERF_CALLBACKS
 
 #define KVM_MAX_VCPUS 288
 #define KVM_SOFT_MAX_VCPUS 240
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e337aef60793..7cb0f04e24ee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8264,32 +8264,6 @@ static void kvm_timer_init(void)
 			  kvmclock_cpu_online, kvmclock_cpu_down_prep);
 }
 
-static int kvm_is_in_guest(void)
-{
-	/* x86's callbacks are registered only when handling a guest NMI. */
-	return true;
-}
-
-static int kvm_is_user_mode(void)
-{
-	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
-
-	if (WARN_ON_ONCE(!vcpu))
-		return 0;
-
-	return static_call(kvm_x86_get_cpl)(vcpu) != 0;
-}
-
-static unsigned long kvm_get_guest_ip(void)
-{
-	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
-
-	if (WARN_ON_ONCE(!vcpu))
-		return 0;
-
-	return kvm_rip_read(vcpu);
-}
-
 static void kvm_handle_intel_pt_intr(void)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
@@ -8302,19 +8276,6 @@ static void kvm_handle_intel_pt_intr(void)
 			(unsigned long *)&vcpu->arch.pmu.global_status);
 }
 
-static struct perf_guest_info_callbacks kvm_guest_cbs = {
-	.is_in_guest		= kvm_is_in_guest,
-	.is_user_mode		= kvm_is_user_mode,
-	.get_guest_ip		= kvm_get_guest_ip,
-	.handle_intel_pt_intr	= NULL,
-};
-
-void kvm_register_perf_callbacks(void)
-{
-	__perf_register_guest_info_callbacks(&kvm_guest_cbs);
-}
-EXPORT_SYMBOL_GPL(kvm_register_perf_callbacks);
-
 #ifdef CONFIG_X86_64
 static void pvclock_gtod_update_fn(struct work_struct *work)
 {
@@ -11069,7 +11030,7 @@ int kvm_arch_hardware_setup(void *opaque)
 	kvm_ops_static_call_update();
 
 	if (ops->intel_pt_intr_in_guest && ops->intel_pt_intr_in_guest())
-		kvm_guest_cbs.handle_intel_pt_intr = kvm_handle_intel_pt_intr;
+		kvm_set_intel_pt_intr_handler(kvm_handle_intel_pt_intr);
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
@@ -11098,7 +11059,7 @@ int kvm_arch_hardware_setup(void *opaque)
 
 void kvm_arch_hardware_unsetup(void)
 {
-	kvm_guest_cbs.handle_intel_pt_intr = NULL;
+	kvm_set_intel_pt_intr_handler(NULL);
 
 	static_call(kvm_x86_hardware_unsetup)();
 }
@@ -11725,6 +11686,11 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 	return vcpu->arch.preempted_in_kernel;
 }
 
+unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
+{
+	return kvm_rip_read(vcpu);
+}
+
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index f13f15d2fab8..e1fe738c3827 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -387,12 +387,6 @@ static inline bool kvm_cstate_in_guest(struct kvm *kvm)
 	return kvm->arch.cstate_in_guest;
 }
 
-void kvm_register_perf_callbacks(void);
-static inline void kvm_unregister_perf_callbacks(void)
-{
-	__perf_unregister_guest_info_callbacks();
-}
-
 static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu, bool is_nmi)
 {
 	WRITE_ONCE(vcpu->arch.handling_nmi_from_guest, is_nmi);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e4d712e9f760..0db9af0b628c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1163,6 +1163,18 @@ static inline bool kvm_arch_intc_initialized(struct kvm *kvm)
 }
 #endif
 
+#ifdef __KVM_WANT_PERF_CALLBACKS
+
+void kvm_set_intel_pt_intr_handler(void (*handler)(void));
+unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu);
+
+void kvm_register_perf_callbacks(void);
+static inline void kvm_unregister_perf_callbacks(void)
+{
+	__perf_unregister_guest_info_callbacks();
+}
+#endif
+
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type);
 void kvm_arch_destroy_vm(struct kvm *kvm);
 void kvm_arch_sync_events(struct kvm *kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e67c93ca403..13c4f58a75e5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5460,6 +5460,52 @@ struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
         return &kvm_running_vcpu;
 }
 
+#ifdef __KVM_WANT_PERF_CALLBACKS
+static int kvm_is_in_guest(void)
+{
+	/* Registration of KVM's callback signifies "in guest". */
+	return true;
+}
+
+static int kvm_is_user_mode(void)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (WARN_ON_ONCE(!vcpu))
+		return 0;
+
+	return !kvm_arch_vcpu_in_kernel(vcpu);
+}
+
+static unsigned long kvm_get_guest_ip(void)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (WARN_ON_ONCE(!vcpu))
+		return 0;
+
+	return kvm_arch_vcpu_get_ip(vcpu);
+}
+
+static struct perf_guest_info_callbacks kvm_guest_cbs = {
+	.is_in_guest		= kvm_is_in_guest,
+	.is_user_mode		= kvm_is_user_mode,
+	.get_guest_ip		= kvm_get_guest_ip,
+	.handle_intel_pt_intr	= NULL,
+};
+
+void kvm_set_intel_pt_intr_handler(void (*handler)(void))
+{
+	kvm_guest_cbs.handle_intel_pt_intr = handler;
+}
+
+void kvm_register_perf_callbacks(void)
+{
+	__perf_register_guest_info_callbacks(&kvm_guest_cbs);
+}
+EXPORT_SYMBOL_GPL(kvm_register_perf_callbacks);
+#endif
+
 struct kvm_cpu_compat_check {
 	void *opaque;
 	int *ret;
-- 
2.33.0.259.gc128427fd7-goog

