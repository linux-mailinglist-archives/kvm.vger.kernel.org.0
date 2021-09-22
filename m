Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C95413E49
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 02:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhIVAHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 20:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbhIVAH2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 20:07:28 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20D3C0613E4
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 17:05:57 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id e6-20020a0cb446000000b0037eeb9851dfso7168600qvf.17
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 17:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Cp2CdTnLL6A1x2kdouAhprhgeg+5iimEQVWESNgPeTg=;
        b=im2v/L0cygljwm5grHDru5KUhJuz5mZRJLACtD7RonWb5WoFe/D5WuNqzEdPm4G7v8
         rtZr1SHPj05vTG7DdnlSfc+js4UC81QNGDJIA03zdbB9ZdKNy7ID7mCnhXtnu+34C5yg
         kUtUAZ7DnWVxLqGUghCbUvK1tlzpDYoybfavKORupjQBShzw6o2YA6YeI5IYrMg7CfgX
         eElXUTHHYzoIzH2D6fm/ZsLOYCZfPdqD00Yv1xavmD27sqD4jDFv4lzctvG3WIPr12RY
         fcZFN2Q5aGT2PHFfiGVI0yXdul/Sbxc2AMnbSor81BxbiWNV0X2MfR+Z7ZjLq99nqexs
         iEqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Cp2CdTnLL6A1x2kdouAhprhgeg+5iimEQVWESNgPeTg=;
        b=m2yjseuGYzcBzrOys+OArYIQXazAueGwtFtRTeMQAa4Sjb7S6vHfua1rPA2YjLmSU8
         kCCAHwhkKWiArOZvPFcii7vWEw4fgMwmosfGI+MU9AYjq7XrVNb28nSDHLblXBsXrUjB
         9Yr7w4DIlbs+UEnUX8B+jcdRK2DCH0CqFct3RxE+8Zt9qJKqFDCiIsCzQHEqnfyHFZJc
         i9Ktma/eKu8LxbjlcwPZWoNxBvacetqC2w6qxAfJtry1hkwLB2fFgIgD47KpD5Cqf5Ik
         z1nwd0fwVo+mbQetQw8QRW5gvrDTidbiajx5hxDbiH2NO5Eb41UkqC9164fTaKvqgoTa
         5Duw==
X-Gm-Message-State: AOAM530hnZ3n9zO6KgyGeAelke1QfSaDgwx0LLxnNjpfbgZdsLNFtZ7+
        V9eiZvQlDMOYsaY/CMZRA+DYgb45W5E=
X-Google-Smtp-Source: ABdhPJzsZI5IFhqZMKlAhv/Y45oE9l0vm7I+arslrU5gdLF3H8fHDTQL7yct2ww41HqVKvUsbfn37B7Lw9I=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:b022:92d6:d37b:686c])
 (user=seanjc job=sendgmr) by 2002:ad4:4671:: with SMTP id z17mr33495586qvv.62.1632269156742;
 Tue, 21 Sep 2021 17:05:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 21 Sep 2021 17:05:23 -0700
In-Reply-To: <20210922000533.713300-1-seanjc@google.com>
Message-Id: <20210922000533.713300-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210922000533.713300-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v3 06/16] perf/core: Rework guest callbacks to prepare for
 static_call support
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-csky@vger.kernel.org,
        linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

To prepare for using static_calls to optimize perf's guest callbacks,
replace ->is_in_guest and ->is_user_mode with a new multiplexed hook
->state, tweak ->handle_intel_pt_intr to play nice with being called when
there is no active guest, and drop "guest" from ->is_in_guest.

Return '0' from ->state and ->handle_intel_pt_intr to indicate "not in
guest" so that DEFINE_STATIC_CALL_RET0 can be used to define the static
calls, i.e. no callback == !guest.

Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Originally-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
[sean: extracted from static_call patch, fixed get_ip() bug, wrote changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kernel/perf_callchain.c | 13 +++++-----
 arch/arm64/kvm/perf.c              | 35 +++++++++++---------------
 arch/x86/events/core.c             | 13 +++++-----
 arch/x86/events/intel/core.c       |  5 +---
 arch/x86/include/asm/kvm_host.h    |  2 +-
 arch/x86/kvm/pmu.c                 |  2 +-
 arch/x86/kvm/x86.c                 | 40 ++++++++++++++++--------------
 arch/x86/xen/pmu.c                 | 32 ++++++++++--------------
 include/linux/perf_event.h         | 10 +++++---
 kernel/events/core.c               |  1 +
 10 files changed, 74 insertions(+), 79 deletions(-)

diff --git a/arch/arm64/kernel/perf_callchain.c b/arch/arm64/kernel/perf_callchain.c
index 86d9f2013172..274dc3e11b6d 100644
--- a/arch/arm64/kernel/perf_callchain.c
+++ b/arch/arm64/kernel/perf_callchain.c
@@ -104,7 +104,7 @@ void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 {
 	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
+	if (guest_cbs && guest_cbs->state()) {
 		/* We don't support guest os callchain now */
 		return;
 	}
@@ -152,7 +152,7 @@ void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	struct stackframe frame;
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
+	if (guest_cbs && guest_cbs->state()) {
 		/* We don't support guest os callchain now */
 		return;
 	}
@@ -165,8 +165,8 @@ unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
 	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 
-	if (guest_cbs && guest_cbs->is_in_guest())
-		return guest_cbs->get_guest_ip();
+	if (guest_cbs && guest_cbs->state())
+		return guest_cbs->get_ip();
 
 	return instruction_pointer(regs);
 }
@@ -174,10 +174,11 @@ unsigned long perf_instruction_pointer(struct pt_regs *regs)
 unsigned long perf_misc_flags(struct pt_regs *regs)
 {
 	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
+	unsigned int guest_state = guest_cbs ? guest_cbs->state() : 0;
 	int misc = 0;
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
-		if (guest_cbs->is_user_mode())
+	if (guest_state) {
+		if (guest_state & PERF_GUEST_USER)
 			misc |= PERF_RECORD_MISC_GUEST_USER;
 		else
 			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
index c37c0cf1bfe9..3e99ac4ab2d6 100644
--- a/arch/arm64/kvm/perf.c
+++ b/arch/arm64/kvm/perf.c
@@ -13,39 +13,34 @@
 
 DEFINE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
 
-static int kvm_is_in_guest(void)
+static unsigned int kvm_guest_state(void)
 {
-        return kvm_get_running_vcpu() != NULL;
-}
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+	unsigned int state;
 
-static int kvm_is_user_mode(void)
-{
-	struct kvm_vcpu *vcpu;
-
-	vcpu = kvm_get_running_vcpu();
+	if (!vcpu)
+		return 0;
 
-	if (vcpu)
-		return !vcpu_mode_priv(vcpu);
+	state = PERF_GUEST_ACTIVE;
+	if (!vcpu_mode_priv(vcpu))
+		state |= PERF_GUEST_USER;
 
-	return 0;
+	return state;
 }
 
 static unsigned long kvm_get_guest_ip(void)
 {
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
-	vcpu = kvm_get_running_vcpu();
+	if (WARN_ON_ONCE(!vcpu))
+		return 0;
 
-	if (vcpu)
-		return *vcpu_pc(vcpu);
-
-	return 0;
+	return *vcpu_pc(vcpu);
 }
 
 static struct perf_guest_info_callbacks kvm_guest_cbs = {
-	.is_in_guest	= kvm_is_in_guest,
-	.is_user_mode	= kvm_is_user_mode,
-	.get_guest_ip	= kvm_get_guest_ip,
+	.state		= kvm_guest_state,
+	.get_ip		= kvm_get_guest_ip,
 };
 
 void kvm_perf_init(void)
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index ffb3e6c0d367..3a7630fdd340 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2765,7 +2765,7 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
 	struct unwind_state state;
 	unsigned long addr;
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
+	if (guest_cbs && guest_cbs->state()) {
 		/* TODO: We don't support guest os callchain now */
 		return;
 	}
@@ -2869,7 +2869,7 @@ perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs
 	struct stack_frame frame;
 	const struct stack_frame __user *fp;
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
+	if (guest_cbs && guest_cbs->state()) {
 		/* TODO: We don't support guest os callchain now */
 		return;
 	}
@@ -2948,8 +2948,8 @@ unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
 	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 
-	if (guest_cbs && guest_cbs->is_in_guest())
-		return guest_cbs->get_guest_ip();
+	if (guest_cbs && guest_cbs->state())
+		return guest_cbs->get_ip();
 
 	return regs->ip + code_segment_base(regs);
 }
@@ -2957,10 +2957,11 @@ unsigned long perf_instruction_pointer(struct pt_regs *regs)
 unsigned long perf_misc_flags(struct pt_regs *regs)
 {
 	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
+	unsigned int guest_state = guest_cbs ? guest_cbs->state() : 0;
 	int misc = 0;
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
-		if (guest_cbs->is_user_mode())
+	if (guest_state) {
+		if (guest_state & PERF_GUEST_USER)
 			misc |= PERF_RECORD_MISC_GUEST_USER;
 		else
 			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 9baa46185d94..524ad1f747bd 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2855,10 +2855,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 		handled++;
 
 		guest_cbs = perf_get_guest_cbs();
-		if (unlikely(guest_cbs && guest_cbs->is_in_guest() &&
-			     guest_cbs->handle_intel_pt_intr))
-			guest_cbs->handle_intel_pt_intr();
-		else
+		if (likely(!guest_cbs || !guest_cbs->handle_intel_pt_intr()))
 			intel_pt_interrupt();
 	}
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1ea4943a73d7..1080166fc0cf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1874,7 +1874,7 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu);
 int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err);
 void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu);
 
-int kvm_is_in_guest(void);
+unsigned int kvm_guest_state(void);
 
 void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 				     u32 size);
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 0772bad9165c..5b68d4188de0 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -87,7 +87,7 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 		 * woken up. So we should wake it, but this is impossible from
 		 * NMI context. Do it from irq work instead.
 		 */
-		if (!kvm_is_in_guest())
+		if (!kvm_guest_state())
 			irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
 		else
 			kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ffc6c2d73508..6cc66466f301 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8267,44 +8267,48 @@ static void kvm_timer_init(void)
 DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
 EXPORT_PER_CPU_SYMBOL_GPL(current_vcpu);
 
-int kvm_is_in_guest(void)
+unsigned int kvm_guest_state(void)
 {
-	return __this_cpu_read(current_vcpu) != NULL;
-}
+	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
+	unsigned int state;
 
-static int kvm_is_user_mode(void)
-{
-	int user_mode = 3;
+	if (!vcpu)
+		return 0;
 
-	if (__this_cpu_read(current_vcpu))
-		user_mode = static_call(kvm_x86_get_cpl)(__this_cpu_read(current_vcpu));
+	state = PERF_GUEST_ACTIVE;
+	if (static_call(kvm_x86_get_cpl)(vcpu))
+		state |= PERF_GUEST_USER;
 
-	return user_mode != 0;
+	return state;
 }
 
-static unsigned long kvm_get_guest_ip(void)
+static unsigned long kvm_guest_get_ip(void)
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
 
-static void kvm_handle_intel_pt_intr(void)
+static unsigned int kvm_handle_intel_pt_intr(void)
 {
 	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
 
+	/* '0' on failure so that the !PT case can use a RET0 static call. */
+	if (!vcpu)
+		return 0;
+
 	kvm_make_request(KVM_REQ_PMI, vcpu);
 	__set_bit(MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI_BIT,
 			(unsigned long *)&vcpu->arch.pmu.global_status);
+	return 1;
 }
 
 static struct perf_guest_info_callbacks kvm_guest_cbs = {
-	.is_in_guest		= kvm_is_in_guest,
-	.is_user_mode		= kvm_is_user_mode,
-	.get_guest_ip		= kvm_get_guest_ip,
+	.state			= kvm_guest_state,
+	.get_ip			= kvm_guest_get_ip,
 	.handle_intel_pt_intr	= NULL,
 };
 
diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index e13b0b49fcdf..89dd6b1708b0 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -413,34 +413,29 @@ int pmu_apic_update(uint32_t val)
 }
 
 /* perf callbacks */
-static int xen_is_in_guest(void)
+static unsigned int xen_guest_state(void)
 {
 	const struct xen_pmu_data *xenpmu_data = get_xenpmu_data();
+	unsigned int state = 0;
 
 	if (!xenpmu_data) {
 		pr_warn_once("%s: pmudata not initialized\n", __func__);
-		return 0;
+		return state;
 	}
 
 	if (!xen_initial_domain() || (xenpmu_data->domain_id >= DOMID_SELF))
-		return 0;
+		return state;
 
-	return 1;
-}
+	state |= PERF_GUEST_ACTIVE;
 
-static int xen_is_user_mode(void)
-{
-	const struct xen_pmu_data *xenpmu_data = get_xenpmu_data();
-
-	if (!xenpmu_data) {
-		pr_warn_once("%s: pmudata not initialized\n", __func__);
-		return 0;
+	if (xenpmu_data->pmu.pmu_flags & PMU_SAMPLE_PV) {
+		if (xenpmu_data->pmu.pmu_flags & PMU_SAMPLE_USER)
+			state |= PERF_GUEST_USER;
+	} else if (xenpmu_data->pmu.r.regs.cpl & 3) {
+		state |= PERF_GUEST_USER;
 	}
 
-	if (xenpmu_data->pmu.pmu_flags & PMU_SAMPLE_PV)
-		return (xenpmu_data->pmu.pmu_flags & PMU_SAMPLE_USER);
-	else
-		return !!(xenpmu_data->pmu.r.regs.cpl & 3);
+	return state;
 }
 
 static unsigned long xen_get_guest_ip(void)
@@ -456,9 +451,8 @@ static unsigned long xen_get_guest_ip(void)
 }
 
 static struct perf_guest_info_callbacks xen_guest_cbs = {
-	.is_in_guest            = xen_is_in_guest,
-	.is_user_mode           = xen_is_user_mode,
-	.get_guest_ip           = xen_get_guest_ip,
+	.state                  = xen_guest_state,
+	.get_ip			= xen_get_guest_ip,
 };
 
 /* Convert registers from Xen's format to Linux' */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 317d4658afe9..f9be88a47434 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -26,11 +26,13 @@
 # include <asm/local64.h>
 #endif
 
+#define PERF_GUEST_ACTIVE	0x01
+#define PERF_GUEST_USER	0x02
+
 struct perf_guest_info_callbacks {
-	int				(*is_in_guest)(void);
-	int				(*is_user_mode)(void);
-	unsigned long			(*get_guest_ip)(void);
-	void				(*handle_intel_pt_intr)(void);
+	unsigned int			(*state)(void);
+	unsigned long			(*get_ip)(void);
+	unsigned int			(*handle_intel_pt_intr)(void);
 };
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d90a43572400..2e3dc9fbd5d9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6483,6 +6483,7 @@ static void perf_pending_event(struct irq_work *entry)
 }
 
 struct perf_guest_info_callbacks *perf_guest_cbs;
+
 void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 {
 	if (WARN_ON_ONCE(perf_guest_cbs))
-- 
2.33.0.464.g1972c5931b-goog

