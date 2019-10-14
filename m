Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA858D6B04
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 23:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731958AbfJNVB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 17:01:56 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40607 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfJNVB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 17:01:56 -0400
Received: by mail-io1-f65.google.com with SMTP id h144so40930405iof.7
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 14:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LIW05+M4irMe4+9h6vWezKjdjFsJJszdQFsHnY3fEw8=;
        b=Q0lUQvsbY3kwf7bTPn3G39faIX7pODD7GV/Ibo00OwXaDw79uHMMkVOHQVzkI3jTuy
         4u/ZXV1PBoOSf2SMiOnMQx2LMbc/samK5qMj44SOZVzC/1nOFyota4CKhCwLnpeVNRSp
         tMXi8KqfhHpfA14PxET0a8qELw7e1MtZCWKyDTCn/u8oTWCPiTZ7xMK5uGBHVAcEtJ8E
         ovvtOKh8aB9Y8+Hm4CbXrBsDnHhbnPgaOlSQKyVTVdlYKLxF6xEkOlcKtHldGVizh6T5
         2My+i81z2ENbc0/XcfQE4AFfGcxlqiHnrT37FJDZkS8pEpivsWAGByvFWtmMzVq7KRTq
         DJhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LIW05+M4irMe4+9h6vWezKjdjFsJJszdQFsHnY3fEw8=;
        b=b4UBAT5aUlLln4C8WJaW8ojHbF9FPphQYMG9e8RnX8oXBGEdiiMtmInEtNMsiVpuuQ
         3fj5yKi/jApGJg1rHbEVneuAUyF/pnM88gRSrAafAAN6g6cH7Iulbok8Lj5JphJAo+mz
         oX+eioi9LXaMtn81ptaCdrCBJULQXOcnPJgLRGpCKmS4b+Xjd5pfydgXSczOTmjcdFfu
         DKBsya5U+nZvjvTVAV1PnjYSnuuS+kZijTjtbulwXOR17emEPHiIytisp3c65JjQ8T7/
         khZr11QpwBE0Hy11JeJGaFfw6WhtYozi/ANvm9Z82EBszJGr4z879ReW3jeStXqRTpll
         L8zA==
X-Gm-Message-State: APjAAAUHXL+Y0cMmA6++fTVwzXHltDyGX+QKtnE4W0vzS7PIdljou6iy
        eD3TbTJzN0kGNi8Sf1q7MNwukYoWZZC2Cby86AmJAw==
X-Google-Smtp-Source: APXvYqwrgpfTXttUlC5qAhXZqj5Gn1J0dvWnpv84J4hELkjyWtcZkZ9wwQdBCs8xje1wHmaZ/GAamXGmnqNjUlPpzLk=
X-Received: by 2002:a92:c8cb:: with SMTP id c11mr2576271ilq.119.1571086913194;
 Mon, 14 Oct 2019 14:01:53 -0700 (PDT)
MIME-Version: 1.0
References: <20191011194032.240572-1-aaronlewis@google.com>
 <20191011194032.240572-3-aaronlewis@google.com> <20191012001838.GA11329@linux.intel.com>
 <CALMp9eQR3RbP8bkXSCp34izY4z76YFAxUGYbQmJ9JjizoAKy2A@mail.gmail.com> <20191014190529.GF22962@linux.intel.com>
In-Reply-To: <20191014190529.GF22962@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 14 Oct 2019 14:01:41 -0700
Message-ID: <CALMp9eQg+8eg_2dXaR51MMcjxLU=m48KW8hVoZWA_4mPAhU_uw@mail.gmail.com>
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

On Mon, Oct 14, 2019 at 12:05 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Sat, Oct 12, 2019 at 10:36:15AM -0700, Jim Mattson wrote:
> > On Fri, Oct 11, 2019 at 5:18 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Fri, Oct 11, 2019 at 12:40:29PM -0700, Aaron Lewis wrote:
> > > > Set IA32_XSS for the guest and host during VM Enter and VM Exit
> > > > transitions rather than by using the MSR-load areas.
> > > >
> > > > By moving away from using the MSR-load area we can have a unified
> > > > solution for both AMD and Intel.
> > > >
> > > > Reviewed-by: Jim Mattson <jmattson@google.com>
> > > > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > > > ---
> > > >  arch/x86/include/asm/kvm_host.h |  1 +
> > > >  arch/x86/kvm/svm.c              |  7 +++++--
> > > >  arch/x86/kvm/vmx/vmx.c          | 22 ++++++++++------------
> > > >  arch/x86/kvm/x86.c              | 23 +++++++++++++++++++----
> > > >  arch/x86/kvm/x86.h              |  4 ++--
> > > >  5 files changed, 37 insertions(+), 20 deletions(-)
> > > >
> > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > index 50eb430b0ad8..634c2598e389 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -562,6 +562,7 @@ struct kvm_vcpu_arch {
> > > >       u64 smbase;
> > > >       u64 smi_count;
> > > >       bool tpr_access_reporting;
> > > > +     bool xsaves_enabled;
> > > >       u64 ia32_xss;
> > > >       u64 microcode_version;
> > > >       u64 arch_capabilities;
> > > > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > > > index f8ecb6df5106..da69e95beb4d 100644
> > > > --- a/arch/x86/kvm/svm.c
> > > > +++ b/arch/x86/kvm/svm.c
> > > > @@ -5628,7 +5628,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
> > > >       svm->vmcb->save.cr2 = vcpu->arch.cr2;
> > > >
> > > >       clgi();
> > > > -     kvm_load_guest_xcr0(vcpu);
> > > > +     kvm_load_guest_xsave_controls(vcpu);
> > > >
> > > >       if (lapic_in_kernel(vcpu) &&
> > > >               vcpu->arch.apic->lapic_timer.timer_advance_ns)
> > > > @@ -5778,7 +5778,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
> > > >       if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
> > > >               kvm_before_interrupt(&svm->vcpu);
> > > >
> > > > -     kvm_put_guest_xcr0(vcpu);
> > > > +     kvm_load_host_xsave_controls(vcpu);
> > > >       stgi();
> > > >
> > > >       /* Any pending NMI will happen here */
> > > > @@ -5887,6 +5887,9 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
> > > >  {
> > > >       struct vcpu_svm *svm = to_svm(vcpu);
> > > >
> > > > +     vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
> > > > +                                 boot_cpu_has(X86_FEATURE_XSAVES);
> > >
> > > This looks very much like a functional change to SVM, which feels wrong
> > > for a patch with a subject of "KVM: VMX: Use wrmsr for switching between
> > > guest and host IA32_XSS" feels wrong.  Shouldn't this be unconditionally
> > > set false in this patch, and then enabled in " kvm: svm: Add support for
> > > XSAVES on AMD"?
> >
> > Nothing is being enabled here. Vcpu->arch.xsaves_enabled simply tells
> > us whether or not the guest can execute the XSAVES instruction. Any
> > guest with the ability to set CR4.OSXSAVE on an AMD host that supports
> > XSAVES can use the instruction.
>
> Not enabling per se, but it's a functional change as it means MSR_IA32_XSS
> will be written in kvm_load_{guest,host}_xsave_controls() if host_xss!=0.

Fortunately, host_xss is guaranteed to be zero for the nonce. :-)

Perhaps the commit message just needs to be updated? The only
alternatives I see are:
1. Deliberately introducing buggy code to be removed later in the series, or
2. Introducing SVM-specific code first, to be removed later in the series.
