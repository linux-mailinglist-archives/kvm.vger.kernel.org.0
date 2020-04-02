Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 950CC19C967
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 21:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388571AbgDBTGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 15:06:53 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38864 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732598AbgDBTGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 15:06:52 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jK5AO-0001Yn-7q; Thu, 02 Apr 2020 21:06:16 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 2444D100D52; Thu,  2 Apr 2020 21:06:15 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, "Kenneth R . Crudup" <kenny@panix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Nadav Amit <namit@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/split_lock: Refactor and export handle_user_split_lock() for KVM
In-Reply-To: <20200402171946.GH13879@linux.intel.com>
References: <20200402124205.334622628@linutronix.de> <20200402155554.27705-1-sean.j.christopherson@intel.com> <20200402155554.27705-3-sean.j.christopherson@intel.com> <87v9mhn7nf.fsf@nanos.tec.linutronix.de> <20200402171946.GH13879@linux.intel.com>
Date:   Thu, 02 Apr 2020 21:06:15 +0200
Message-ID: <87mu7tn1w8.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:
> On Thu, Apr 02, 2020 at 07:01:56PM +0200, Thomas Gleixner wrote:
>> >  static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
>> >  static inline void switch_to_sld(unsigned long tifn) {}
>> > -static inline bool handle_user_split_lock(struct pt_regs *regs, long error_code)
>> > +static inline bool handle_user_split_lock(unsigned long ip)
>> 
>> This is necessary because VMX can be compiled without CPU_SUP_INTEL?
>
> Ya, it came about when cleaning up the IA32_FEATURE_CONTROL MSR handling
> to consolidate duplicate code.
>
> config KVM_INTEL
>         tristate "KVM for Intel (and compatible) processors support"
>         depends on KVM && IA32_FEAT_CTL
>
> config IA32_FEAT_CTL
>         def_bool y
>         depends on CPU_SUP_INTEL || CPU_SUP_CENTAUR || CPU_SUP_ZHAOXIN

Ah, indeed. So something like the below would make sense. Hmm?

Of course that can be mangled into Xiaoyao's patches, I'm not worried
about my patch count :)

Aside of that I really wish Intel HW folks had indicated the source of
the #AC via the error code. It can only be 0 or 1 for the regular #AC so
there would have been 31 bits to chose from.

Thanks,

        tglx

8<----------------
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -43,14 +43,14 @@ unsigned int x86_stepping(unsigned int s
 #ifdef CONFIG_CPU_SUP_INTEL
 extern void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
 extern void switch_to_sld(unsigned long tifn);
-extern bool handle_user_split_lock(struct pt_regs *regs, long error_code);
+extern int handle_ac_split_lock(unsigned long ip);
 extern void split_lock_validate_module_text(struct module *me, void *text, void *text_end);
 #else
 static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
 static inline void switch_to_sld(unsigned long tifn) {}
-static inline bool handle_user_split_lock(struct pt_regs *regs, long error_code)
+static int handle_ac_split_lock(unsigned long ip)
 {
-	return false;
+	return -ENOSYS;
 }
 static inline void split_lock_validate_module_text(struct module *me, void *text, void *text_end) {}
 #endif

--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1102,13 +1102,20 @@ static void split_lock_init(void)
 	split_lock_verify_msr(sld_state != sld_off);
 }
 
-bool handle_user_split_lock(struct pt_regs *regs, long error_code)
+int handle_ac_split_lock(unsigned long ip)
 {
-	if ((regs->flags & X86_EFLAGS_AC) || sld_state == sld_fatal)
-		return false;
+	switch (sld_state) {
+	case sld_warn:
+		break;
+	case sld_off:
+		pr_warn_once("#AC: Spurious trap at address: 0x%lx\n", ip);
+		return -ENOSYS;
+	case sld_fatal:
+		return -EFAULT;
+	}
 
 	pr_warn_ratelimited("#AC: %s/%d took a split_lock trap at address: 0x%lx\n",
-			    current->comm, current->pid, regs->ip);
+			    current->comm, current->pid, ip);
 
 	/*
 	 * Disable the split lock detection for this task so it can make
@@ -1117,8 +1124,9 @@ bool handle_user_split_lock(struct pt_re
 	 */
 	sld_update_msr(false);
 	set_tsk_thread_flag(current, TIF_SLD);
-	return true;
+	return 0;
 }
+EXPORT_SYMBOL_GPL(handle_ac_split_lock);
 
 /*
  * This function is called only when switching between tasks with
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -304,7 +304,7 @@ dotraplinkage void do_alignment_check(st
 
 	local_irq_enable();
 
-	if (handle_user_split_lock(regs, error_code))
+	if (!(regs->flags & X86_EFLAGS_AC) && !handle_ac_split_lock(regs->ip))
 		return;
 
 	do_trap(X86_TRAP_AC, SIGBUS, "alignment check", regs,
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -65,6 +65,7 @@
 
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
+MODULE_INFO(sld_safe, "Y");
 
 #ifdef MODULE
 static const struct x86_cpu_id vmx_cpu_id[] = {
@@ -4623,6 +4624,22 @@ static int handle_machine_check(struct k
 	return 1;
 }
 
+static bool guest_handles_ac(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * If guest has alignment checking enabled in CR0 and activated in
+	 * eflags, then the #AC originated from CPL3 and the guest is able
+	 * to handle it. It does not matter whether this is a regular or
+	 * a split lock operation induced #AC.
+	 */
+	if (vmx_get_cpl(vcpu) == 3 && kvm_read_cr0_bits(vcpu, X86_CR0_AM) &&
+	    kvm_get_rflags(vcpu) & X86_EFLAGS_AC)
+		return true;
+
+	/* Add guest SLD handling checks here once it's supported */
+	return false;
+}
+
 static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -4630,6 +4647,7 @@ static int handle_exception_nmi(struct k
 	u32 intr_info, ex_no, error_code;
 	unsigned long cr2, rip, dr6;
 	u32 vect_info;
+	int err;
 
 	vect_info = vmx->idt_vectoring_info;
 	intr_info = vmx->exit_intr_info;
@@ -4688,9 +4706,6 @@ static int handle_exception_nmi(struct k
 		return handle_rmode_exception(vcpu, ex_no, error_code);
 
 	switch (ex_no) {
-	case AC_VECTOR:
-		kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
-		return 1;
 	case DB_VECTOR:
 		dr6 = vmcs_readl(EXIT_QUALIFICATION);
 		if (!(vcpu->guest_debug &
@@ -4719,6 +4734,29 @@ static int handle_exception_nmi(struct k
 		kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
 		kvm_run->debug.arch.exception = ex_no;
 		break;
+	case AC_VECTOR:
+		if (guest_handles_ac(vcpu)) {
+			kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
+			return 1;
+		}
+		/*
+		 * Handle #AC caused by split lock detection. If the host
+		 * mode is sld_warn, then it warns, marks current with
+		 * TIF_SLD and disables split lock detection. So the guest
+		 * can just continue.
+		 *
+		 * If the host mode is fatal, the handling code warned. Let
+		 * qemu kill itself.
+		 *
+		 * If the host mode is off, then this #AC is bonkers and
+		 * something is badly wrong. Let it fail as well.
+		 */
+		err = handle_ac_split_lock(kvm_rip_read(vcpu));
+		if (!err)
+			return 1;
+		/* Propagate the error type to user space */
+		error_code = err == -EFAULT ? 0x100 : 0x200;
+		fallthrough;
 	default:
 		kvm_run->exit_reason = KVM_EXIT_EXCEPTION;
 		kvm_run->ex.exception = ex_no;
