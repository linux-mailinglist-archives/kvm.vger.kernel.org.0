Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFAB4102BC5
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 19:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfKSShB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 13:37:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:17254 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbfKSShA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 13:37:00 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 10:36:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,219,1571727600"; 
   d="scan'208";a="204587440"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 19 Nov 2019 10:36:58 -0800
Date:   Tue, 19 Nov 2019 10:36:58 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI
 fastpath
Message-ID: <20191119183658.GC25672@linux.intel.com>
References: <1574145389-12149-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1574145389-12149-1-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 19, 2019 at 02:36:28PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> ICR and TSCDEADLINE MSRs write cause the main MSRs write vmexits in 
> our product observation, multicast IPIs are not as common as unicast 
> IPI like RESCHEDULE_VECTOR and CALL_FUNCTION_SINGLE_VECTOR etc.
> 
> This patch tries to optimize x2apic physical destination mode, fixed 
> delivery mode single target IPI by delivering IPI to receiver as soon 
> as possible after sender writes ICR vmexit to avoid various checks 
> when possible, especially when running guest w/ --overcommit cpu-pm=on
> or guest can keep running, IPI can be injected to target vCPU by 
> posted-interrupt immediately.
> 
> Testing on Xeon Skylake server:
> 
> The virtual IPI latency from sender send to receiver receive reduces 
> more than 200+ cpu cycles.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * add tracepoint
>  * Instead of a separate vcpu->fast_vmexit, set exit_reason
>    to vmx->exit_reason to -1 if the fast path succeeds.
>  * move the "kvm_skip_emulated_instruction(vcpu)" to vmx_handle_exit
>  * moving the handling into vmx_handle_exit_irqoff()
> 
>  arch/x86/include/asm/kvm_host.h |  4 ++--
>  arch/x86/include/uapi/asm/vmx.h |  1 +
>  arch/x86/kvm/svm.c              |  4 ++--
>  arch/x86/kvm/vmx/vmx.c          | 40 +++++++++++++++++++++++++++++++++++++---
>  arch/x86/kvm/x86.c              |  5 +++--
>  5 files changed, 45 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 898ab9e..0daafa9 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1084,7 +1084,7 @@ struct kvm_x86_ops {
>  	void (*tlb_flush_gva)(struct kvm_vcpu *vcpu, gva_t addr);
>  
>  	void (*run)(struct kvm_vcpu *vcpu);
> -	int (*handle_exit)(struct kvm_vcpu *vcpu);
> +	int (*handle_exit)(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reason);
>  	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
>  	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
>  	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
> @@ -1134,7 +1134,7 @@ struct kvm_x86_ops {
>  	int (*check_intercept)(struct kvm_vcpu *vcpu,
>  			       struct x86_instruction_info *info,
>  			       enum x86_intercept_stage stage);
> -	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
> +	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reason);
>  	bool (*mpx_supported)(void);
>  	bool (*xsaves_supported)(void);
>  	bool (*umip_emulated)(void);
> diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
> index 3eb8411..b33c6e1 100644
> --- a/arch/x86/include/uapi/asm/vmx.h
> +++ b/arch/x86/include/uapi/asm/vmx.h
> @@ -88,6 +88,7 @@
>  #define EXIT_REASON_XRSTORS             64
>  #define EXIT_REASON_UMWAIT              67
>  #define EXIT_REASON_TPAUSE              68
> +#define EXIT_REASON_NEED_SKIP_EMULATED_INSN -1
>  
>  #define VMX_EXIT_REASONS \
>  	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \

Rather than pass a custom exit reason around, can we simply handle *all*
x2apic ICR writes during handle_exit_irqoff() for both VMX and SVM?  The
only risk I can think of is that KVM could stall too long before enabling
IRQs.


From 1ea8ff1aa766928c869ef7c1eb437fe4f7b8daf9 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Tue, 19 Nov 2019 09:50:42 -0800
Subject: [PATCH] KVM: x86: Add a fast path for sending virtual IPIs in x2APIC
 mode

Add a fast path to handle writes to the ICR when the local APIC is
emulated in the kernel and x2APIC is enabled.  The fast path is invoked
at ->handle_exit_irqoff() to emulate only the effect of the ICR write
itself, i.e. the sending of IPIs.  Sending IPIs early in the VM-Exit
flow reduces the latency of virtual IPIs by avoiding the expensive bits
of transitioning from guest to host, e.g. reacquiring KVM's SRCU lock.

Suggested-by: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/emulate.c |  1 -
 arch/x86/kvm/lapic.c   |  5 +++--
 arch/x86/kvm/lapic.h   | 25 +++++++++++++++++++++++++
 arch/x86/kvm/svm.c     |  3 +++
 arch/x86/kvm/vmx/vmx.c |  2 ++
 5 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 952d1a4f4d7e..8313234e7d64 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -19,7 +19,6 @@
  */
 
 #include <linux/kvm_host.h>
-#include "kvm_cache_regs.h"
 #include <asm/kvm_emulate.h>
 #include <linux/stringify.h>
 #include <asm/debugreg.h>
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 452cedd6382b..0f02820332d4 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2655,9 +2655,10 @@ int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	if (reg == APIC_ICR2)
 		return 1;
 
-	/* if this is ICR write vector before command */
+	/* ICR writes are handled early by kvm_x2apic_fast_icr_write(). */
 	if (reg == APIC_ICR)
-		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
+		return 0;
+
 	return kvm_lapic_reg_write(apic, reg, (u32)data);
 }
 
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index c1d77436126a..19fd2734d9e6 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -6,6 +6,8 @@
 
 #include <linux/kvm_host.h>
 
+#include "kvm_cache_regs.h"
+
 #define KVM_APIC_INIT		0
 #define KVM_APIC_SIPI		1
 #define KVM_APIC_LVT_NUM	6
@@ -245,4 +247,27 @@ static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 	return apic_base & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE);
 }
 
+/*
+ * Fast path for sending virtual IPIs immediately after VM-Exit.  Fault
+ * detection and injection, e.g. if x2apic is disabled, tracing and/or skipping
+ * of the emulated instruction are all handled in the standard WRMSR path,
+ * kvm_emulate_wrmsr().
+ */
+static inline void kvm_x2apic_fast_icr_write(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	u64 data;
+
+	if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(apic))
+		return;
+
+	if (kvm_rcx_read(vcpu) != (APIC_BASE_MSR + (APIC_ICR >> 4)))
+		return;
+
+	data = kvm_read_edx_eax(vcpu);
+
+	kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
+	WARN_ON_ONCE(kvm_lapic_reg_write(apic, APIC_ICR, (u32)data));
+}
+
 #endif
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d02a73a48461..713510210b29 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6189,7 +6189,10 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 
 static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (svm->vmcb->control.exit_code && svm->vmcb->control.exit_info_1)
+		kvm_x2apic_fast_icr_write(vcpu);
 }
 
 static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 621142e55e28..82412c4085fc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6231,6 +6231,8 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 		handle_external_interrupt_irqoff(vcpu);
 	else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
 		handle_exception_nmi_irqoff(vmx);
+	else if (vmx->exit_reason == EXIT_REASON_MSR_WRITE)
+		kvm_x2apic_fast_icr_write(vcpu);
 }
 
 static bool vmx_has_emulated_msr(int index)
-- 
2.24.0

