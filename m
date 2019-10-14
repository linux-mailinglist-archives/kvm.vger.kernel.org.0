Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B7FD69DA
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 21:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733124AbfJNTFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 15:05:31 -0400
Received: from mga18.intel.com ([134.134.136.126]:13005 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728005AbfJNTFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 15:05:31 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 12:05:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="195069869"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 14 Oct 2019 12:05:29 -0700
Date:   Mon, 14 Oct 2019 12:05:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/5] KVM: VMX: Use wrmsr for switching between guest
 and host IA32_XSS
Message-ID: <20191014190529.GF22962@linux.intel.com>
References: <20191011194032.240572-1-aaronlewis@google.com>
 <20191011194032.240572-3-aaronlewis@google.com>
 <20191012001838.GA11329@linux.intel.com>
 <CALMp9eQR3RbP8bkXSCp34izY4z76YFAxUGYbQmJ9JjizoAKy2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQR3RbP8bkXSCp34izY4z76YFAxUGYbQmJ9JjizoAKy2A@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 12, 2019 at 10:36:15AM -0700, Jim Mattson wrote:
> On Fri, Oct 11, 2019 at 5:18 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Fri, Oct 11, 2019 at 12:40:29PM -0700, Aaron Lewis wrote:
> > > Set IA32_XSS for the guest and host during VM Enter and VM Exit
> > > transitions rather than by using the MSR-load areas.
> > >
> > > By moving away from using the MSR-load area we can have a unified
> > > solution for both AMD and Intel.
> > >
> > > Reviewed-by: Jim Mattson <jmattson@google.com>
> > > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > > ---
> > >  arch/x86/include/asm/kvm_host.h |  1 +
> > >  arch/x86/kvm/svm.c              |  7 +++++--
> > >  arch/x86/kvm/vmx/vmx.c          | 22 ++++++++++------------
> > >  arch/x86/kvm/x86.c              | 23 +++++++++++++++++++----
> > >  arch/x86/kvm/x86.h              |  4 ++--
> > >  5 files changed, 37 insertions(+), 20 deletions(-)
> > >
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 50eb430b0ad8..634c2598e389 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -562,6 +562,7 @@ struct kvm_vcpu_arch {
> > >       u64 smbase;
> > >       u64 smi_count;
> > >       bool tpr_access_reporting;
> > > +     bool xsaves_enabled;
> > >       u64 ia32_xss;
> > >       u64 microcode_version;
> > >       u64 arch_capabilities;
> > > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > > index f8ecb6df5106..da69e95beb4d 100644
> > > --- a/arch/x86/kvm/svm.c
> > > +++ b/arch/x86/kvm/svm.c
> > > @@ -5628,7 +5628,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
> > >       svm->vmcb->save.cr2 = vcpu->arch.cr2;
> > >
> > >       clgi();
> > > -     kvm_load_guest_xcr0(vcpu);
> > > +     kvm_load_guest_xsave_controls(vcpu);
> > >
> > >       if (lapic_in_kernel(vcpu) &&
> > >               vcpu->arch.apic->lapic_timer.timer_advance_ns)
> > > @@ -5778,7 +5778,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
> > >       if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
> > >               kvm_before_interrupt(&svm->vcpu);
> > >
> > > -     kvm_put_guest_xcr0(vcpu);
> > > +     kvm_load_host_xsave_controls(vcpu);
> > >       stgi();
> > >
> > >       /* Any pending NMI will happen here */
> > > @@ -5887,6 +5887,9 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
> > >  {
> > >       struct vcpu_svm *svm = to_svm(vcpu);
> > >
> > > +     vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
> > > +                                 boot_cpu_has(X86_FEATURE_XSAVES);
> >
> > This looks very much like a functional change to SVM, which feels wrong
> > for a patch with a subject of "KVM: VMX: Use wrmsr for switching between
> > guest and host IA32_XSS" feels wrong.  Shouldn't this be unconditionally
> > set false in this patch, and then enabled in " kvm: svm: Add support for
> > XSAVES on AMD"?
> 
> Nothing is being enabled here. Vcpu->arch.xsaves_enabled simply tells
> us whether or not the guest can execute the XSAVES instruction. Any
> guest with the ability to set CR4.OSXSAVE on an AMD host that supports
> XSAVES can use the instruction.

Not enabling per se, but it's a functional change as it means MSR_IA32_XSS
will be written in kvm_load_{guest,host}_xsave_controls() if host_xss!=0.

> > > +
> > >       /* Update nrips enabled cache */
> > >       svm->nrips_enabled = !!guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
> > >
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 409e9a7323f1..ce3020914c69 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -106,8 +106,6 @@ module_param(enable_apicv, bool, S_IRUGO);
> > >  static bool __read_mostly nested = 1;
> > >  module_param(nested, bool, S_IRUGO);
> > >
> > > -static u64 __read_mostly host_xss;
> > > -
> > >  bool __read_mostly enable_pml = 1;
> > >  module_param_named(pml, enable_pml, bool, S_IRUGO);
> > >
> > > @@ -2074,11 +2072,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > >               if (data != 0)
> > >                       return 1;
> > >               vcpu->arch.ia32_xss = data;
> > > -             if (vcpu->arch.ia32_xss != host_xss)
> > > -                     add_atomic_switch_msr(vmx, MSR_IA32_XSS,
> > > -                             vcpu->arch.ia32_xss, host_xss, false);
> > > -             else
> > > -                     clear_atomic_switch_msr(vmx, MSR_IA32_XSS);
> >
> > I'm pretty sure the "vmx_xsaves_supported()" check in this case statement
> > can be removed after this patch.  The host support check was necessary
> > when the MSR load/save list was being used, but moving to xsaves_enabled
> > means theres no risk of writing MSR_IA32_XSS when it's not supported.
> 
> I agree. vmx_xsaves_supported() only tells us if the XSAVES
> instruction can be enabled. It does not tell us anything about the
> existence of IA32_XSS in the guest.
> 
> > >               break;
> > >       case MSR_IA32_RTIT_CTL:
> > >               if ((pt_mode != PT_MODE_HOST_GUEST) ||
> > > @@ -4038,6 +4031,8 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
> > >                       guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
> > >                       guest_cpuid_has(vcpu, X86_FEATURE_XSAVES);
> > >
> > > +             vcpu->arch.xsaves_enabled = xsaves_enabled;
> >
> > Doesn't this conflict with the direction of the previous patch, "KVM: VMX:
> > Remove unneeded check for X86_FEATURE_XSAVE"?  xsaves_enabled is %true iff
> > both XSAVE and XSAVES are exposed to the guest.
> 
> There's no conflict, because the predicates are different. The
> previous patch removed the test for XSAVE in the emulation of
> RDMSR/WRMSR(IA32_XSS), because the presence of the IA32_XSS MSR
> depends only on CPUID.(EAX=0DH, ECX=1):EAX.XSS[bit 3]. However,
> architecturally, the XSAVES instruction will raise #UD if either
> CPUID.01H:ECX.XSAVE[bit 26] = 0 or CPUID.(EAX=0DH,ECX=1):EAX.XSS[bit
> 3] = 0. (Unfortunately, AMD does not allow us to enforce architectural
> behavior without breaking the existing ABI, as Paolo pointed out
> previously. This puts us in the bizarre situation where an AMD guest
> may be able to execute XSAVES even though it cannot read or write
> IA32_XSS.)
> 
> > Alternatively, couldn't KVM check arch.xsaves_enabled in the MSR handling?
> 
> No. The existence of the IA32_XSS MSR is not the same as the ability
> of the guest to execute XSAVES.

Ugh, that's obnoxious.
