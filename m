Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFE93FA269
	for <lists+kvm@lfdr.de>; Sat, 28 Aug 2021 02:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbhH1AiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 20:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbhH1Ahj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 20:37:39 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7190C0612AD
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 17:36:48 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id b15-20020a05622a020f00b0029e28300d94so802608qtx.16
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 17:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=kV+43gCo9lUv9XBpq5GszAcUqdFbD0VTdN9gkn90biY=;
        b=rxQFl/E0q7TG4eTtS8cvaKjpz+1uZzXKYUahAXBLz4zSPj8Lw+VLh8Mb1BBBtiQKNw
         BlNjA876gHwdxDucFChcGa5H2Zi316XYlCmTuKX+ROmAwLv/BIgb2shswMUBN0+4HLwS
         zQZ7ZkLSnOZFUPXFuFHGYUDr9nX4Oea1w/M1oQqjqJxqbK6ba2arrO/e5Qo8o9ZtAlj/
         FOSv9aQsEN9L3IoU1DIQcVeEZ3bqRPKaoHTa52LbneQ89SWlRvFoztysKfBpWoaqqjBB
         nB92v+uOO+V41If/3hHsbxNnCSO1+LGRQHtXQib4wWZe8INcZp3C8P1oHhmk1iC8OAIJ
         Gmig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=kV+43gCo9lUv9XBpq5GszAcUqdFbD0VTdN9gkn90biY=;
        b=K1PGXPJpAgnt/3Wg+QpOI2eurxBMLfdr+fx5TEi1m1gbF0QdOcVRx15Js1K80ICvAh
         csuSXtB/A698MlJZNlcpJ7y9Fgyy1zNjD8guRz8cPZdK2css2H94SIyxeDQLSkhO9AK0
         oVr39X3I97R4OvYVhmwgflr5WE33ReRKIXwx+s2tpdDXmBMgsjLVCSI3d8gNRDlBEdAQ
         sqgXQ6IQ/JZdIM7h0BXH6AAUnfZwZPf9GNcs0aUZy6OTokSBMrGgpKZPDNI5oRHYUYRy
         KkEmbffJcPJ/PO0UReXEPrb6vqNYIPE7j7k9RJa5y8qJ0L9Aae4Xco60BVPRHdBLw+aP
         iooQ==
X-Gm-Message-State: AOAM5315vYUmHYLyNx95ZRomCu0+CXKEAf8MU6QWs9pxDi6XSdF5Asdo
        9WK8wnzIYp8UeRAQTmS/r/PV1rRker0=
X-Google-Smtp-Source: ABdhPJzs4DFqQHNeRKzV+tkWBighuxilPoPlwqBBJW7KkYH0Bkccb5PXEDnQkRBBiHYdU/kdTKgE4wfebtg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:f66c:b851:7e79:7ed4])
 (user=seanjc job=sendgmr) by 2002:a0c:f88f:: with SMTP id u15mr12630183qvn.38.1630111008043;
 Fri, 27 Aug 2021 17:36:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Aug 2021 17:35:55 -0700
In-Reply-To: <20210828003558.713983-1-seanjc@google.com>
Message-Id: <20210828003558.713983-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210828003558.713983-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v2 10/13] KVM: Move x86's perf guest info callbacks to generic KVM
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
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
 arch/x86/include/asm/kvm_host.h |  4 +++
 arch/x86/kvm/x86.c              | 53 +++++++--------------------------
 include/linux/kvm_host.h        | 12 ++++++++
 virt/kvm/kvm_main.c             | 40 +++++++++++++++++++++++++
 4 files changed, 67 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2d86a2dfc775..a98c7907110c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1543,6 +1543,10 @@ static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
 		return -ENOTSUPP;
 }
 
+#define __KVM_WANT_PERF_CALLBACKS
+#define kvm_arch_pmi_in_guest(vcpu) \
+	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
+
 int kvm_mmu_module_init(void);
 void kvm_mmu_module_exit(void);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1427ac1fc1f2..1bea616402e6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8264,43 +8264,12 @@ static void kvm_timer_init(void)
 			  kvmclock_cpu_online, kvmclock_cpu_down_prep);
 }
 
-static inline bool kvm_pmi_in_guest(struct kvm_vcpu *vcpu)
-{
-	return vcpu && vcpu->arch.handling_intr_from_guest;
-}
-
-static unsigned int kvm_guest_state(void)
-{
-	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
-	unsigned int state;
-
-	if (!kvm_pmi_in_guest(vcpu))
-		return 0;
-
-	state = PERF_GUEST_ACTIVE;
-	if (static_call(kvm_x86_get_cpl)(vcpu))
-		state |= PERF_GUEST_USER;
-
-	return state;
-}
-
-static unsigned long kvm_guest_get_ip(void)
-{
-	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
-
-	/* Retrieving the IP must be guarded by a call to kvm_guest_state(). */
-	if (WARN_ON_ONCE(!kvm_pmi_in_guest(vcpu)))
-		return 0;
-
-	return kvm_rip_read(vcpu);
-}
-
 static unsigned int kvm_handle_intel_pt_intr(void)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 	/* '0' on failure so that the !PT case can use a RET0 static call. */
-	if (!kvm_pmi_in_guest(vcpu))
+	if (!kvm_arch_pmi_in_guest(vcpu))
 		return 0;
 
 	kvm_make_request(KVM_REQ_PMI, vcpu);
@@ -8309,12 +8278,6 @@ static unsigned int kvm_handle_intel_pt_intr(void)
 	return 1;
 }
 
-static struct perf_guest_info_callbacks kvm_guest_cbs = {
-	.state			= kvm_guest_state,
-	.get_ip			= kvm_guest_get_ip,
-	.handle_intel_pt_intr	= NULL,
-};
-
 #ifdef CONFIG_X86_64
 static void pvclock_gtod_update_fn(struct work_struct *work)
 {
@@ -11068,9 +11031,11 @@ int kvm_arch_hardware_setup(void *opaque)
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
 	kvm_ops_static_call_update();
 
+	/* Temporary ugliness. */
 	if (ops->intel_pt_intr_in_guest && ops->intel_pt_intr_in_guest())
-		kvm_guest_cbs.handle_intel_pt_intr = kvm_handle_intel_pt_intr;
-	perf_register_guest_info_callbacks(&kvm_guest_cbs);
+		kvm_register_perf_callbacks(kvm_handle_intel_pt_intr);
+	else
+		kvm_register_perf_callbacks(NULL);
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
@@ -11099,8 +11064,7 @@ int kvm_arch_hardware_setup(void *opaque)
 
 void kvm_arch_hardware_unsetup(void)
 {
-	perf_unregister_guest_info_callbacks();
-	kvm_guest_cbs.handle_intel_pt_intr = NULL;
+	kvm_unregister_perf_callbacks();
 
 	static_call(kvm_x86_hardware_unsetup)();
 }
@@ -11727,6 +11691,11 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
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
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e4d712e9f760..34d99034852f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1163,6 +1163,18 @@ static inline bool kvm_arch_intc_initialized(struct kvm *kvm)
 }
 #endif
 
+#ifdef __KVM_WANT_PERF_CALLBACKS
+
+void kvm_set_intel_pt_intr_handler(unsigned int (*handler)(void));
+unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu);
+
+void kvm_register_perf_callbacks(unsigned int (*pt_intr_handler)(void));
+static inline void kvm_unregister_perf_callbacks(void)
+{
+	perf_unregister_guest_info_callbacks();
+}
+#endif
+
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type);
 void kvm_arch_destroy_vm(struct kvm *kvm);
 void kvm_arch_sync_events(struct kvm *kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e67c93ca403..2c61db39b501 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5460,6 +5460,46 @@ struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
         return &kvm_running_vcpu;
 }
 
+#ifdef __KVM_WANT_PERF_CALLBACKS
+static unsigned int kvm_guest_state(void)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+	unsigned int state;
+
+	if (!kvm_arch_pmi_in_guest(vcpu))
+		return 0;
+
+	state = PERF_GUEST_ACTIVE;
+	if (!kvm_arch_vcpu_in_kernel(vcpu))
+		state |= PERF_GUEST_USER;
+
+	return state;
+}
+
+static unsigned long kvm_guest_get_ip(void)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	/* Retrieving the IP must be guarded by a call to kvm_guest_state(). */
+	if (WARN_ON_ONCE(!kvm_arch_pmi_in_guest(vcpu)))
+		return 0;
+
+	return kvm_arch_vcpu_get_ip(vcpu);
+}
+
+static struct perf_guest_info_callbacks kvm_guest_cbs = {
+	.state			= kvm_guest_state,
+	.get_ip			= kvm_guest_get_ip,
+	.handle_intel_pt_intr	= NULL,
+};
+
+void kvm_register_perf_callbacks(unsigned int (*pt_intr_handler)(void))
+{
+	kvm_guest_cbs.handle_intel_pt_intr = pt_intr_handler;
+	perf_register_guest_info_callbacks(&kvm_guest_cbs);
+}
+#endif
+
 struct kvm_cpu_compat_check {
 	void *opaque;
 	int *ret;
-- 
2.33.0.259.gc128427fd7-goog

