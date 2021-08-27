Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D733F919A
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 03:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243975AbhH0A6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 20:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243954AbhH0A6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 20:58:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC89CC0612E7
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 17:57:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g192-20020a25dbc9000000b0059bd2958c8aso2022662ybf.5
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 17:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=BKACFpkyclmSNZOzZCvoQ85Q5j0ibf+pUktwZSnA2VE=;
        b=uDGNAKy3X8wgG4FPiD0TolBumhb9mvdkmZ5pXk9jMiSPuEv6IzBrAY2yREw0PMXzi4
         9KSpq/MIGbNRkWH+90XdYBr08BMNemkexcswrPOoxwAVc9eNlnrdscRQYZv1qWj5RVJQ
         Uu5cGBTR2dLrVmB+fbyQ0f2saIhD4/u6CJuZoKrKwJgASrh55N/fvDtm72qpzzHlRHHS
         5MsttnXx7/8NWuUSXTy9DIxqvoIYMeSt7SrSLZoZYq6Cz9pNjweGfVRu94/2EucLJNq+
         age0a4QpYT7qPSqnVfS8AXaoz7sVZQi9saQiXGh1vd9lEsvZMwvUn3vvO8JTj1WmcE1u
         xE7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=BKACFpkyclmSNZOzZCvoQ85Q5j0ibf+pUktwZSnA2VE=;
        b=e8A/Oz5dWRTJ8Toxq/NK2wXxZL914x2BBEtc0rS1tHBdnZ/pbGeT8Xhzu2x7Vyx+1+
         NLKhpArR9se6Ki1Sg2k8+Nx8yZdwSPOir0PJejtqLW1fyTYsI3WE4ZK7L4JaggEp1EbW
         UO3NMrK9HWT8h9vjacYeX05IU38SG0hWuQXVKc4HvxPKp2tDef1+RYZ8lbwWp0CzC9Wj
         VorsyXqOqXHv86YKGK0ptdIMZI0MMA9wW5bRJACapNzw4hpC/W2+rsv2AmWc0FDmzqCw
         /v8RxwaoktFzGFHrjDgAOjzc0I1B4rIcKOMc7ox45TfQg1qiUjkp+o4vjKtZH+Kd1pN/
         P05Q==
X-Gm-Message-State: AOAM533VVDPFt8yiS0MHceCWjbMN58wpUtXBN6ZIAm3oiGtDHqr/AYGO
        AgtLcNYc+TLKO68zanDBNRPjt7oePrQ=
X-Google-Smtp-Source: ABdhPJw0TCNYmfMyjk3pp1TIQWtZYYXC1+CmXfKBRCTWftHhXnIexf6rTbOO9IR4Dc7O+dyoa9Bys+IIj5k=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:c16c:db05:96b2:1475])
 (user=seanjc job=sendgmr) by 2002:a25:4f8a:: with SMTP id d132mr1902818ybb.486.1630025863019;
 Thu, 26 Aug 2021 17:57:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 26 Aug 2021 17:57:09 -0700
In-Reply-To: <20210827005718.585190-1-seanjc@google.com>
Message-Id: <20210827005718.585190-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210827005718.585190-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 06/15] KVM: x86: Register perf callbacks only when actively
 handling interrupt
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

Register KVM's perf callback only when handling an interrupt that may be
a PMI (sadly this includes IRQs), and unregister the callback immediately
after handling the interrupt (or closing the window).  Registering the
callback on a per-CPU basis (with preemption disabled!), fixes a mostly
theoretical bug where perf could dereference a NULL pointer due to KVM
unloading and unregistering the callbacks in between perf queries of the
callback functions.  The precise registration will also allow for future
cleanups and optimizations, e.g. the existence of the callbacks can serve
as the "in guest" check.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c         | 27 +++++++++++++++++----------
 arch/x86/kvm/x86.h         | 10 ++++++++++
 include/linux/perf_event.h |  2 ++
 kernel/events/core.c       | 12 ++++++++++++
 4 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bae951344e28..bc4ee6ea7752 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8274,28 +8274,31 @@ int kvm_is_in_guest(void)
 
 static int kvm_is_user_mode(void)
 {
-	int user_mode = 3;
+	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
 
-	if (__this_cpu_read(current_vcpu))
-		user_mode = static_call(kvm_x86_get_cpl)(__this_cpu_read(current_vcpu));
+	if (WARN_ON_ONCE(!vcpu))
+		return 0;
 
-	return user_mode != 0;
+	return static_call(kvm_x86_get_cpl)(vcpu) != 0;
 }
 
 static unsigned long kvm_get_guest_ip(void)
 {
-	unsigned long ip = 0;
+	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
 
-	if (__this_cpu_read(current_vcpu))
-		ip = kvm_rip_read(__this_cpu_read(current_vcpu));
+	if (WARN_ON_ONCE(!vcpu))
+		return 0;
 
-	return ip;
+	return kvm_rip_read(vcpu);
 }
 
 static void kvm_handle_intel_pt_intr(void)
 {
 	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
 
+	if (WARN_ON_ONCE(!vcpu))
+		return;
+
 	kvm_make_request(KVM_REQ_PMI, vcpu);
 	__set_bit(MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI_BIT,
 			(unsigned long *)&vcpu->arch.pmu.global_status);
@@ -8308,6 +8311,12 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
 	.handle_intel_pt_intr	= NULL,
 };
 
+void kvm_register_perf_callbacks(void)
+{
+	__perf_register_guest_info_callbacks(&kvm_guest_cbs);
+}
+EXPORT_SYMBOL_GPL(kvm_register_perf_callbacks);
+
 #ifdef CONFIG_X86_64
 static void pvclock_gtod_update_fn(struct work_struct *work)
 {
@@ -11063,7 +11072,6 @@ int kvm_arch_hardware_setup(void *opaque)
 
 	if (ops->intel_pt_intr_in_guest && ops->intel_pt_intr_in_guest())
 		kvm_guest_cbs.handle_intel_pt_intr = kvm_handle_intel_pt_intr;
-	perf_register_guest_info_callbacks(&kvm_guest_cbs);
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
@@ -11092,7 +11100,6 @@ int kvm_arch_hardware_setup(void *opaque)
 
 void kvm_arch_hardware_unsetup(void)
 {
-	perf_unregister_guest_info_callbacks();
 	kvm_guest_cbs.handle_intel_pt_intr = NULL;
 
 	static_call(kvm_x86_hardware_unsetup)();
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 7d66d63dc55a..5cedc0e8a5d5 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -387,15 +387,25 @@ static inline bool kvm_cstate_in_guest(struct kvm *kvm)
 	return kvm->arch.cstate_in_guest;
 }
 
+void kvm_register_perf_callbacks(void);
+static inline void kvm_unregister_perf_callbacks(void)
+{
+	__perf_unregister_guest_info_callbacks();
+}
+
 DECLARE_PER_CPU(struct kvm_vcpu *, current_vcpu);
 
 static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu)
 {
 	__this_cpu_write(current_vcpu, vcpu);
+
+	kvm_register_perf_callbacks();
 }
 
 static inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
 {
+	kvm_unregister_perf_callbacks();
+
 	__this_cpu_write(current_vcpu, NULL);
 }
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c98253dae037..7a367bf1b78d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1238,6 +1238,8 @@ extern void perf_event_bpf_event(struct bpf_prog *prog,
 
 #ifdef CONFIG_HAVE_GUEST_PERF_EVENTS
 DECLARE_PER_CPU(struct perf_guest_info_callbacks *, perf_guest_cbs);
+extern void __perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
+extern void __perf_unregister_guest_info_callbacks(void);
 extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 extern void perf_unregister_guest_info_callbacks(void);
 #endif /* CONFIG_HAVE_GUEST_PERF_EVENTS */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9bc1375d6ed9..2f28d9d8dc94 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6485,6 +6485,18 @@ static void perf_pending_event(struct irq_work *entry)
 #ifdef CONFIG_HAVE_GUEST_PERF_EVENTS
 DEFINE_PER_CPU(struct perf_guest_info_callbacks *, perf_guest_cbs);
 
+void __perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
+{
+	__this_cpu_write(perf_guest_cbs, cbs);
+}
+EXPORT_SYMBOL_GPL(__perf_register_guest_info_callbacks);
+
+void __perf_unregister_guest_info_callbacks(void)
+{
+	__this_cpu_write(perf_guest_cbs, NULL);
+}
+EXPORT_SYMBOL_GPL(__perf_unregister_guest_info_callbacks);
+
 void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 {
 	int cpu;
-- 
2.33.0.259.gc128427fd7-goog

