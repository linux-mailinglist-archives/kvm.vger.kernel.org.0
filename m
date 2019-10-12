Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 402C7D5166
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2019 19:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbfJLRga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Oct 2019 13:36:30 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46065 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728162AbfJLRg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Oct 2019 13:36:29 -0400
Received: by mail-io1-f65.google.com with SMTP id c25so28105954iot.12
        for <kvm@vger.kernel.org>; Sat, 12 Oct 2019 10:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PKA0LE76tZ46mBewbVcksXCohtWdvYjfiShIb4rS1+U=;
        b=M0rdFh9PMKwy6dmT0CSE4t46Ajd1T7TGO83QWDWCPPqaUI0aqTt3+QNVoybiPOakiw
         B7OuXwDWoxzedcW6yn8XB84Zzf3Vu3BHg5TrzB2uokSIV+LUrc57UNudvBEubH5HhV+e
         ypkr9j8Kp8/TcrKzFXwGgfmJgt1JTsHflWznWjxa8BuJThTIMdVXU+sGYaywTb3MzRx2
         A9ZQ29L3AACi4qpHMLrl6we4FJ9M+wwI9Ro840R4d1++JOyx5JJqeU8iExEn4wGKdjnJ
         FYU3sNeYwxByxGwYjRymuq/4yK6XPTwxHW8FQpJsT1X63J4/O0t4W3YJF4wOmZ1oiUIx
         ju4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PKA0LE76tZ46mBewbVcksXCohtWdvYjfiShIb4rS1+U=;
        b=HbJzWZesU9AR3fby+BpDrTg+cf7xFyT2BUk0xbij/FWML9gPIsw/LVVkhCVBDDKArD
         TCGQ4xiMPaKVnN07wrAzKc5peCsSIxMJPIMoIVMS8h/d5C+QPVI7ZcZfzMIT4xlQP0OM
         09aSoppz3qyy/iaElc64wozolfT3x62PiAnV3E6xnyXOLjqU1G3XGprE9RfrO/rOfBjc
         /+pllVDibQlrPvgwqnfJodvzhpRRL4WAnxoESs3tPuD26i5mGccQY5saVt/VMudfKyy/
         orZtBpnokJf0vMsTIk7Payp5rKyRRMn6wu2TkfdxF1aaeE4S5Qb/l9Nmkrp3cadEkiTC
         Ktgw==
X-Gm-Message-State: APjAAAUSLs9905MoLaqPWkOiFcVqR/3m3whHNo3w8mFTUSyqmmISzuDP
        b2jQWog8K6g6tYwr3XLK/vFR4n4CQ8hiovSrRuAeqQ==
X-Google-Smtp-Source: APXvYqzltMFnhJuSGwVZBfpLBVAyGG4hSUB5p/NvnIRmqrWrOuQOOuDZz6OTMYMshI5rMQGqAdu1dSNAjZTtjxyL9Pc=
X-Received: by 2002:a5d:8d8f:: with SMTP id b15mr26164357ioj.296.1570901786539;
 Sat, 12 Oct 2019 10:36:26 -0700 (PDT)
MIME-Version: 1.0
References: <20191011194032.240572-1-aaronlewis@google.com>
 <20191011194032.240572-3-aaronlewis@google.com> <20191012001838.GA11329@linux.intel.com>
In-Reply-To: <20191012001838.GA11329@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Sat, 12 Oct 2019 10:36:15 -0700
Message-ID: <CALMp9eQR3RbP8bkXSCp34izY4z76YFAxUGYbQmJ9JjizoAKy2A@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] KVM: VMX: Use wrmsr for switching between guest
 and host IA32_XSS
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 11, 2019 at 5:18 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Oct 11, 2019 at 12:40:29PM -0700, Aaron Lewis wrote:
> > Set IA32_XSS for the guest and host during VM Enter and VM Exit
> > transitions rather than by using the MSR-load areas.
> >
> > By moving away from using the MSR-load area we can have a unified
> > solution for both AMD and Intel.
> >
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  1 +
> >  arch/x86/kvm/svm.c              |  7 +++++--
> >  arch/x86/kvm/vmx/vmx.c          | 22 ++++++++++------------
> >  arch/x86/kvm/x86.c              | 23 +++++++++++++++++++----
> >  arch/x86/kvm/x86.h              |  4 ++--
> >  5 files changed, 37 insertions(+), 20 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 50eb430b0ad8..634c2598e389 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -562,6 +562,7 @@ struct kvm_vcpu_arch {
> >       u64 smbase;
> >       u64 smi_count;
> >       bool tpr_access_reporting;
> > +     bool xsaves_enabled;
> >       u64 ia32_xss;
> >       u64 microcode_version;
> >       u64 arch_capabilities;
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index f8ecb6df5106..da69e95beb4d 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -5628,7 +5628,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
> >       svm->vmcb->save.cr2 = vcpu->arch.cr2;
> >
> >       clgi();
> > -     kvm_load_guest_xcr0(vcpu);
> > +     kvm_load_guest_xsave_controls(vcpu);
> >
> >       if (lapic_in_kernel(vcpu) &&
> >               vcpu->arch.apic->lapic_timer.timer_advance_ns)
> > @@ -5778,7 +5778,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
> >       if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
> >               kvm_before_interrupt(&svm->vcpu);
> >
> > -     kvm_put_guest_xcr0(vcpu);
> > +     kvm_load_host_xsave_controls(vcpu);
> >       stgi();
> >
> >       /* Any pending NMI will happen here */
> > @@ -5887,6 +5887,9 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
> >  {
> >       struct vcpu_svm *svm = to_svm(vcpu);
> >
> > +     vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
> > +                                 boot_cpu_has(X86_FEATURE_XSAVES);
>
> This looks very much like a functional change to SVM, which feels wrong
> for a patch with a subject of "KVM: VMX: Use wrmsr for switching between
> guest and host IA32_XSS" feels wrong.  Shouldn't this be unconditionally
> set false in this patch, and then enabled in " kvm: svm: Add support for
> XSAVES on AMD"?

Nothing is being enabled here. Vcpu->arch.xsaves_enabled simply tells
us whether or not the guest can execute the XSAVES instruction. Any
guest with the ability to set CR4.OSXSAVE on an AMD host that supports
XSAVES can use the instruction.

> > +
> >       /* Update nrips enabled cache */
> >       svm->nrips_enabled = !!guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 409e9a7323f1..ce3020914c69 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -106,8 +106,6 @@ module_param(enable_apicv, bool, S_IRUGO);
> >  static bool __read_mostly nested = 1;
> >  module_param(nested, bool, S_IRUGO);
> >
> > -static u64 __read_mostly host_xss;
> > -
> >  bool __read_mostly enable_pml = 1;
> >  module_param_named(pml, enable_pml, bool, S_IRUGO);
> >
> > @@ -2074,11 +2072,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >               if (data != 0)
> >                       return 1;
> >               vcpu->arch.ia32_xss = data;
> > -             if (vcpu->arch.ia32_xss != host_xss)
> > -                     add_atomic_switch_msr(vmx, MSR_IA32_XSS,
> > -                             vcpu->arch.ia32_xss, host_xss, false);
> > -             else
> > -                     clear_atomic_switch_msr(vmx, MSR_IA32_XSS);
>
> I'm pretty sure the "vmx_xsaves_supported()" check in this case statement
> can be removed after this patch.  The host support check was necessary
> when the MSR load/save list was being used, but moving to xsaves_enabled
> means theres no risk of writing MSR_IA32_XSS when it's not supported.

I agree. vmx_xsaves_supported() only tells us if the XSAVES
instruction can be enabled. It does not tell us anything about the
existence of IA32_XSS in the guest.

> >               break;
> >       case MSR_IA32_RTIT_CTL:
> >               if ((pt_mode != PT_MODE_HOST_GUEST) ||
> > @@ -4038,6 +4031,8 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
> >                       guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
> >                       guest_cpuid_has(vcpu, X86_FEATURE_XSAVES);
> >
> > +             vcpu->arch.xsaves_enabled = xsaves_enabled;
>
> Doesn't this conflict with the direction of the previous patch, "KVM: VMX:
> Remove unneeded check for X86_FEATURE_XSAVE"?  xsaves_enabled is %true iff
> both XSAVE and XSAVES are exposed to the guest.

There's no conflict, because the predicates are different. The
previous patch removed the test for XSAVE in the emulation of
RDMSR/WRMSR(IA32_XSS), because the presence of the IA32_XSS MSR
depends only on CPUID.(EAX=0DH, ECX=1):EAX.XSS[bit 3]. However,
architecturally, the XSAVES instruction will raise #UD if either
CPUID.01H:ECX.XSAVE[bit 26] = 0 or CPUID.(EAX=0DH,ECX=1):EAX.XSS[bit
3] = 0. (Unfortunately, AMD does not allow us to enforce architectural
behavior without breaking the existing ABI, as Paolo pointed out
previously. This puts us in the bizarre situation where an AMD guest
may be able to execute XSAVES even though it cannot read or write
IA32_XSS.)

> Alternatively, couldn't KVM check arch.xsaves_enabled in the MSR handling?

No. The existence of the IA32_XSS MSR is not the same as the ability
of the guest to execute XSAVES.

> > +
> >               if (!xsaves_enabled)
> >                       exec_control &= ~SECONDARY_EXEC_XSAVES;
> >
> > @@ -6540,7 +6535,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >       if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
> >               vmx_set_interrupt_shadow(vcpu, 0);
> >
> > -     kvm_load_guest_xcr0(vcpu);
> > +     kvm_load_guest_xsave_controls(vcpu);
> >
> >       if (static_cpu_has(X86_FEATURE_PKU) &&
> >           kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
> > @@ -6647,7 +6642,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >                       __write_pkru(vmx->host_pkru);
> >       }
> >
> > -     kvm_put_guest_xcr0(vcpu);
> > +     kvm_load_host_xsave_controls(vcpu);
> >
> >       vmx->nested.nested_run_pending = 0;
> >       vmx->idt_vectoring_info = 0;
> > @@ -7091,6 +7086,12 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> >  {
> >       struct vcpu_vmx *vmx = to_vmx(vcpu);
> >
> > +     /*
> > +      * This will be set back to true in vmx_compute_secondary_exec_control()
> > +      * if it should be true, so setting it to false here is okay.
>
> Or simply:
>
>         /* xsaves_enabled is recomputed in vmx_compute_secondary_exec_control(). */
>
> > +      */
> > +     vcpu->arch.xsaves_enabled = false;
> > +
> >       if (cpu_has_secondary_exec_ctrls()) {
> >               vmx_compute_secondary_exec_control(vmx);
> >               vmcs_set_secondary_exec_control(vmx);
> > @@ -7599,9 +7600,6 @@ static __init int hardware_setup(void)
> >               WARN_ONCE(host_bndcfgs, "KVM: BNDCFGS in host will be lost");
> >       }
> >
> > -     if (boot_cpu_has(X86_FEATURE_XSAVES))
> > -             rdmsrl(MSR_IA32_XSS, host_xss);
> > -
> >       if (!cpu_has_vmx_vpid() || !cpu_has_vmx_invvpid() ||
> >           !(cpu_has_vmx_invvpid_single() || cpu_has_vmx_invvpid_global()))
> >               enable_vpid = 0;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 661e2bf38526..a61570d7034b 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -176,6 +176,8 @@ struct kvm_shared_msrs {
> >  static struct kvm_shared_msrs_global __read_mostly shared_msrs_global;
> >  static struct kvm_shared_msrs __percpu *shared_msrs;
> >
> > +static u64 __read_mostly host_xss;
> > +
> >  struct kvm_stats_debugfs_item debugfs_entries[] = {
> >       { "pf_fixed", VCPU_STAT(pf_fixed) },
> >       { "pf_guest", VCPU_STAT(pf_guest) },
> > @@ -812,27 +814,37 @@ void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_lmsw);
> >
> > -void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu)
> > +void kvm_load_guest_xsave_controls(struct kvm_vcpu *vcpu)
> >  {
> >       if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE) &&
> >                       !vcpu->guest_xcr0_loaded) {
> >               /* kvm_set_xcr() also depends on this */
> >               if (vcpu->arch.xcr0 != host_xcr0)
> >                       xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
> > +
> > +             if (vcpu->arch.xsaves_enabled &&
> > +                 vcpu->arch.ia32_xss != host_xss)
> > +                     wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
> > +
> >               vcpu->guest_xcr0_loaded = 1;
> >       }
> >  }
> > -EXPORT_SYMBOL_GPL(kvm_load_guest_xcr0);
> > +EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_controls);
> >
> > -void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu)
> > +void kvm_load_host_xsave_controls(struct kvm_vcpu *vcpu)
> >  {
> >       if (vcpu->guest_xcr0_loaded) {
> >               if (vcpu->arch.xcr0 != host_xcr0)
> >                       xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
> > +
> > +             if (vcpu->arch.xsaves_enabled &&
> > +                 vcpu->arch.ia32_xss != host_xss)
> > +                     wrmsrl(MSR_IA32_XSS, host_xss);
> > +
> >               vcpu->guest_xcr0_loaded = 0;
> >       }
> >  }
> > -EXPORT_SYMBOL_GPL(kvm_put_guest_xcr0);
> > +EXPORT_SYMBOL_GPL(kvm_load_host_xsave_controls);
> >
> >  static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
> >  {
> > @@ -9293,6 +9305,9 @@ int kvm_arch_hardware_setup(void)
> >               kvm_default_tsc_scaling_ratio = 1ULL << kvm_tsc_scaling_ratio_frac_bits;
> >       }
> >
> > +     if (boot_cpu_has(X86_FEATURE_XSAVES))
> > +             rdmsrl(MSR_IA32_XSS, host_xss);
>
> More code that goes beyond the subject of the patch, as host_xss is now
> being read and potentially switched on SVM platforms.  I don't mind the
> change itself being part of this patch (unlike setting xsaves_enabled),
> but IMO the subject should make it more clear that this is a common x86
> change.  Arguably this should be two patches, one to do what this subject
> says and a second to move the code to common x86, but that seems like
> overkill.
>
> >       kvm_init_msr_list();
> >       return 0;
> >  }
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index dbf7442a822b..0d04e865665b 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -366,7 +366,7 @@ static inline bool kvm_pat_valid(u64 data)
> >       return (data | ((data & 0x0202020202020202ull) << 1)) == data;
> >  }
> >
> > -void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
> > -void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
> > +void kvm_load_guest_xsave_controls(struct kvm_vcpu *vcpu);
> > +void kvm_load_host_xsave_controls(struct kvm_vcpu *vcpu);
> >
> >  #endif
> > --
> > 2.23.0.700.g56cf767bdb-goog
> >
