Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B532D6A0B
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 22:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394084AbgLJViC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 16:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394011AbgLJVhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 16:37:10 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE60C0613CF
        for <kvm@vger.kernel.org>; Thu, 10 Dec 2020 13:36:30 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id o25so7436763oie.5
        for <kvm@vger.kernel.org>; Thu, 10 Dec 2020 13:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lvqnV+13VNyt5vDx3/2IhkUH55xEUV3vG3CbI5Bhkfw=;
        b=dwQmETGXPjVY4l1Lhj4nmRXyhY9b4AEi4ep79hGgApLAVFZ/pzwT/IF9CZv/4X3Ubs
         QPdAqOfMUdayk2GwC0OmZIM8ry0SsyGWTMzu1uOv1BxGv/pFDKYQm/QF6Rh+4ynTV69t
         rIkvt9RQg01m0CIald/Ztw8R/Z9aLr7hixWbyXYr4Gt3fDv1BxvAnf+eF3cvHy+6ticF
         YPt2VOyvBMdx1kM1sxyWzfUBUwmmYusXreB89GDYN2K/fl8o+nF2eIIRT0mM2AFQ8/iU
         7YWiI+JYb8SC+hIe+RD4FdffQ3KE1X68fNb+L83GFs4xMyX9OhNkKkGX4rEZrRInn+ku
         rTAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lvqnV+13VNyt5vDx3/2IhkUH55xEUV3vG3CbI5Bhkfw=;
        b=UxWKPerXM35Wj21Am7N4WWeWXz/O10WSBzsbPg6o48W1ylThO7QqUxutos0rX5ugBZ
         B+DyJQl0FMCMT5N3Qzlh3+AuRV6pp0G/Ms562/Js0uV7hZsu/xTNDp7stPBmulkZBa5f
         fmEemSWi7CC2sUqw7XqQjeIr1aE0StpK61BRHqkuvWv/nuRyQZ+pWl+DNTgqtN75O60y
         gKdOS55s4wqIYzVgl8JGE/vGc5MLY8aoEWZRQlfBxgN5cujY8F8FXkygITbjrchkzTo2
         fCunEKe0kAngIP1bwGSw5/a3j1hJYwH/0aHk/Gx9ZgHyptLXHn7LME/WSKNjN/QktHGu
         DKhA==
X-Gm-Message-State: AOAM531rWUANRZPX5GPPZeBL4vbRFZ9kAY7TnWKaQWTqMByqiA5VOEvp
        Ftpq0V7ekf13hyi7smD61g8UGOJYhLvdz1QqZFp4HA==
X-Google-Smtp-Source: ABdhPJxa5UFU0MuxMx8LOLH7Sqt3aQjEVhX/SFq6BGgFAk2KEucXDokwdkHHzw6ycIBB9ekbYXZZC1knyKZlvLhXarc=
X-Received: by 2002:aca:d06:: with SMTP id 6mr7161565oin.13.1607636189542;
 Thu, 10 Dec 2020 13:36:29 -0800 (PST)
MIME-Version: 1.0
References: <160738054169.28590.5171339079028237631.stgit@bmoger-ubuntu>
 <160738067970.28590.1275116532320186155.stgit@bmoger-ubuntu>
 <CALMp9eRSvWemdiBygMJ18yP9T0UzL0nNbpD__bRis7M5LqOK+g@mail.gmail.com> <737ec565-ec4f-1d9e-a7f8-dfa7976e64e6@amd.com>
In-Reply-To: <737ec565-ec4f-1d9e-a7f8-dfa7976e64e6@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 10 Dec 2020 13:36:18 -0800
Message-ID: <CALMp9eS2YSX_Tjaji3sZjWAKdS=orJVH1H6NbXMoi23ZFbcURQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "kyung.min.park@intel.com" <kyung.min.park@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "mgross@linux.intel.com" <mgross@linux.intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Phillips, Kim" <kim.phillips@amd.com>,
        "Huang2, Wei" <Wei.Huang2@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 10, 2020 at 1:26 PM Babu Moger <babu.moger@amd.com> wrote:
>
> Hi Jim,
>
> > -----Original Message-----
> > From: Jim Mattson <jmattson@google.com>
> > Sent: Monday, December 7, 2020 5:06 PM
> > To: Moger, Babu <Babu.Moger@amd.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>; Thomas Gleixner
> > <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>; Borislav Petkov
> > <bp@alien8.de>; Yu, Fenghua <fenghua.yu@intel.com>; Tony Luck
> > <tony.luck@intel.com>; Wanpeng Li <wanpengli@tencent.com>; kvm list
> > <kvm@vger.kernel.org>; Lendacky, Thomas <Thomas.Lendacky@amd.com>;
> > Peter Zijlstra <peterz@infradead.org>; Sean Christopherson
> > <seanjc@google.com>; Joerg Roedel <joro@8bytes.org>; the arch/x86
> > maintainers <x86@kernel.org>; kyung.min.park@intel.com; LKML <linux-
> > kernel@vger.kernel.org>; Krish Sadhukhan <krish.sadhukhan@oracle.com>; =
H .
> > Peter Anvin <hpa@zytor.com>; mgross@linux.intel.com; Vitaly Kuznetsov
> > <vkuznets@redhat.com>; Phillips, Kim <kim.phillips@amd.com>; Huang2, We=
i
> > <Wei.Huang2@amd.com>
> > Subject: Re: [PATCH 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
> >
> > On Mon, Dec 7, 2020 at 2:38 PM Babu Moger <babu.moger@amd.com> wrote:
> > >
> > > Newer AMD processors have a feature to virtualize the use of the
> > > SPEC_CTRL MSR. When supported, the SPEC_CTRL MSR is automatically
> > > virtualized and no longer requires hypervisor intervention.
> > >
> > > This feature is detected via CPUID function 0x8000000A_EDX[20]:
> > > GuestSpecCtrl.
> > >
> > > Hypervisors are not required to enable this feature since it is
> > > automatically enabled on processors that support it.
> > >
> > > When this feature is enabled, the hypervisor no longer has to
> > > intercept the usage of the SPEC_CTRL MSR and no longer is required to
> > > save and restore the guest SPEC_CTRL setting when switching
> > > hypervisor/guest modes.  The effective SPEC_CTRL setting is the guest
> > > SPEC_CTRL setting or'ed with the hypervisor SPEC_CTRL setting. This
> > > allows the hypervisor to ensure a minimum SPEC_CTRL if desired.
> > >
> > > This support also fixes an issue where a guest may sometimes see an
> > > inconsistent value for the SPEC_CTRL MSR on processors that support
> > > this feature. With the current SPEC_CTRL support, the first write to
> > > SPEC_CTRL is intercepted and the virtualized version of the SPEC_CTRL
> > > MSR is not updated. When the guest reads back the SPEC_CTRL MSR, it
> > > will be 0x0, instead of the actual expected value. There isn=E2=80=99=
t a
> > > security concern here, because the host SPEC_CTRL value is or=E2=80=
=99ed with
> > > the Guest SPEC_CTRL value to generate the effective SPEC_CTRL value.
> > > KVM writes with the guest's virtualized SPEC_CTRL value to SPEC_CTRL
> > > MSR just before the VMRUN, so it will always have the actual value
> > > even though it doesn=E2=80=99t appear that way in the guest. The gues=
t will
> > > only see the proper value for the SPEC_CTRL register if the guest was
> > > to write to the SPEC_CTRL register again. With Virtual SPEC_CTRL
> > > support, the MSR interception of SPEC_CTRL is disabled during
> > > vmcb_init, so this will no longer be an issue.
> > >
> > > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > > ---
> >
> > Shouldn't there be some code to initialize a new "guest SPEC_CTRL"
> > value in the VMCB, both at vCPU creation, and at virtual processor rese=
t?
>
> Yes, I think so. I will check on this.
>
> >
> > >  arch/x86/kvm/svm/svm.c |   17 ++++++++++++++---
> > >  1 file changed, 14 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c index
> > > 79b3a564f1c9..3d73ec0cdb87 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -1230,6 +1230,14 @@ static void init_vmcb(struct vcpu_svm *svm)
> > >
> > >         svm_check_invpcid(svm);
> > >
> > > +       /*
> > > +        * If the host supports V_SPEC_CTRL then disable the intercep=
tion
> > > +        * of MSR_IA32_SPEC_CTRL.
> > > +        */
> > > +       if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> > > +               set_msr_interception(&svm->vcpu, svm->msrpm,
> > MSR_IA32_SPEC_CTRL,
> > > +                                    1, 1);
> > > +
> > >         if (kvm_vcpu_apicv_active(&svm->vcpu))
> > >                 avic_init_vmcb(svm);
> > >
> > > @@ -3590,7 +3598,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struc=
t
> > kvm_vcpu *vcpu)
> > >          * is no need to worry about the conditional branch over the =
wrmsr
> > >          * being speculatively taken.
> > >          */
> > > -       x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
> > > +       if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> > > +               x86_spec_ctrl_set_guest(svm->spec_ctrl,
> > > + svm->virt_spec_ctrl);
> >
> > Is this correct for the nested case? Presumably, there is now a "guest
> > SPEC_CTRL" value somewhere in the VMCB. If L1 does not intercept this M=
SR,
> > then we need to transfer the "guest SPEC_CTRL" value from the
> > vmcb01 to the vmcb02, don't we?
>
> Here is the text from to be published documentation.
> "When in host mode, the host SPEC_CTRL value is in effect and writes
> update only the host version of SPEC_CTRL. On a VMRUN, the processor load=
s
> the guest version of SPEC_CTRL from the VMCB. For non- SNP enabled guests=
,
> processor behavior is controlled by the logical OR of the two registers.
> When the guest writes SPEC_CTRL, only the guest version is updated. On a
> VMEXIT, the guest version is saved into the VMCB and the processor return=
s
> to only using the host SPEC_CTRL for speculation control. The guest
> SPEC_CTRL is located at offset 0x2E0 in the VMCB."  This offset is into
> the save area of the VMCB (i.e. 0x400 + 0x2E0).
>
> The feature X86_FEATURE_V_SPEC_CTRL will not be advertised to guests.
> So, the guest will use the same mechanism as today where it will save and
> restore the value into/from svm->spec_ctrl. If the value saved in the VMS=
A
> is left untouched, both an L1 and L2 guest will get the proper value.
> Thing that matters is the initial setup of vmcb01 and vmcb02 when this
> feature is available in host(bare metal). I am going to investigate that
> part. Do you still think I am missing something here?

It doesn't matter whether X86_FEATURE_V_SPEC_CTRL is advertised to L1
or not. If L1 doesn't virtualize MSR_SPEC_CTRL for L2, then L1 and L2
share the same value for that MSR. With this change, the current value
in vmcb01 is only in vmcb01, and doesn't get propagated anywhere else.
Hence, if L1 changes the value of MSR_SPEC_CTRL, that change is not
visible to L2.

Thinking about what Sean said about live migration, I think the
correct solution here is that the authoritative value for this MSR
should continue to live in svm->spec_ctrl. When the CPU supports
X86_FEATURE_V_SPEC_CTRL, we should just transfer the value into the
VMCB prior to VMRUN and out of the VMCB after #VMEXIT.

>
> >
> > >         svm_vcpu_enter_exit(vcpu, svm);
> > >
> > > @@ -3609,12 +3618,14 @@ static __no_kcsan fastpath_t
> > svm_vcpu_run(struct kvm_vcpu *vcpu)
> > >          * If the L02 MSR bitmap does not intercept the MSR, then we =
need to
> > >          * save it.
> > >          */
> > > -       if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)=
))
> > > +       if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL) &&
> > > +           unlikely(!msr_write_intercepted(vcpu,
> > > + MSR_IA32_SPEC_CTRL)))
> > >                 svm->spec_ctrl =3D native_read_msr(MSR_IA32_SPEC_CTRL=
);
> >
> > Is this correct for the nested case? If L1 does not intercept this MSR,=
 then it
> > might have changed while L2 is running. Presumably, the hardware has st=
ored
> > the new value somewhere in the vmcb02 at #VMEXIT, but now we need to mo=
ve
> > that value into the vmcb01, don't we?
> >
> > >         reload_tss(vcpu);
> > >
> > > -       x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctr=
l);
> > > +       if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> > > +               x86_spec_ctrl_restore_host(svm->spec_ctrl,
> > > + svm->virt_spec_ctrl);
> > >
> > >         vcpu->arch.cr2 =3D svm->vmcb->save.cr2;
> > >         vcpu->arch.regs[VCPU_REGS_RAX] =3D svm->vmcb->save.rax;
> > >
> >
> > It would be great if you could add some tests to kvm-unit-tests.
>
> Yes. I will check on this part.
>
> Thanks
> Babu
