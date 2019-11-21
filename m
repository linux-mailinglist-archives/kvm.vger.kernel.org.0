Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC93E10481F
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 02:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfKUBen (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 20:34:43 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:33833 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfKUBen (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 20:34:43 -0500
Received: by mail-oi1-f196.google.com with SMTP id l202so1738533oig.1;
        Wed, 20 Nov 2019 17:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lpEa+/BRm24XesFPsnNk5cI0mT1TDDR8Zk/jTKgI6uM=;
        b=hCQOu+RtXc+YXfM1Aja28NLxoCRtfmCn2qZbMjZj5luctKt9TvpQsZJerrqPznbs1n
         K3zr4y7z2dA/M6CkglXs6aS7AVLpRj+13QF0doj3sxcoOFQh7uc2Xx+ZLc7+bYvrHkRz
         yStcTqVPDo0yD6y94m9A7mG+48ywg401un2aDv8C+VEyfNA1eRFgF3PAPc2w0m/K5HlA
         Tx4ryfdHVA65brhhxqvEwtu5vGwhB7H/1CILjybawf+/N98lrvo8TdI4GCWms8H01oKP
         g51T6XE+PtDo8agk1mKeP5FfxSj/CxM4+KOgLR4rYj1IyCToj20LOLNn9VhXGfgVvW9k
         iG+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lpEa+/BRm24XesFPsnNk5cI0mT1TDDR8Zk/jTKgI6uM=;
        b=IGitO5EUApfom5R3MAXyNda+NUwDasz4Ak8+ZSzIKfCH1t5I2P4nf0bGHU4tLg0sVK
         HahU4W9+ZL2e53ZUM5c+u/eWF5fteoL58vkfLRKRKvlznjTczMh5VA+cR2u+94r05QXR
         PSt0HoWl0jsxLhL7gBiq6wTU+h3UqrfyGShvNDSix17oyNA01C3Acx4RWhLOQJ5FdckU
         t0t3nfmDD2JoXJZy2+ARVz55obEFCsTZ5sXlnx1o/Ciyu8UysV/Snc7t9J02IMzL1er4
         RIRrWMp5nmf7Vfn9mLBmNx59MwAVbL/3vx+9S1oVYRvlEzdWfwOn6IKzD34+vMo7MxLZ
         dodQ==
X-Gm-Message-State: APjAAAU3YsjgfZJ3VPZCKYeIIDeVdP3Vu0nGmV8Ef0EnIFU4tx2AohoJ
        pmqqNooQAFElKRNs8lfRWXbtfxH6zwULeXhXkzI=
X-Google-Smtp-Source: APXvYqwSSP+8HVivUWXCp6o5UY+Z2Yt0nRWPRkJz7YfyieQdmUfv+3R4fBsTIDUJxwAyEFviUq3P6xI7T2McJgjJLV0=
X-Received: by 2002:aca:c50f:: with SMTP id v15mr5658442oif.5.1574300082776;
 Wed, 20 Nov 2019 17:34:42 -0800 (PST)
MIME-Version: 1.0
References: <1574145389-12149-1-git-send-email-wanpengli@tencent.com>
 <09CD3BD3-1F5E-48DA-82ED-58E3196DBD83@oracle.com> <CANRm+CxZ5Opj44Aj+LL18nVSuU63hXpt9U9E3jJEQP67Hx6WMg@mail.gmail.com>
 <20191120170228.GC32572@linux.intel.com>
In-Reply-To: <20191120170228.GC32572@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 21 Nov 2019 09:34:34 +0800
Message-ID: <CANRm+CyTeKkAyi5Dswi1JpBjCiMc9c4B4jj5+JKoY_aFhb-AwA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI fastpath
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Nov 2019 at 01:02, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, Nov 20, 2019 at 11:49:36AM +0800, Wanpeng Li wrote:
> > On Tue, 19 Nov 2019 at 20:11, Liran Alon <liran.alon@oracle.com> wrote:
> > > > +
> > > > +static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu, u32 *exit_reason)
> > > > {
> > > >       struct vcpu_vmx *vmx = to_vmx(vcpu);
> > > >
> > > > @@ -6231,6 +6263,8 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> > > >               handle_external_interrupt_irqoff(vcpu);
> > > >       else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
> > > >               handle_exception_nmi_irqoff(vmx);
> > > > +     else if (vmx->exit_reason == EXIT_REASON_MSR_WRITE)
> > > > +             *exit_reason = handle_ipi_fastpath(vcpu);
> > >
> > > 1) This case requires a comment as the only reason it is called here is an
> > > optimisation.  In contrast to the other cases which must be called before
> > > interrupts are enabled on the host.
> > >
> > > 2) I would rename handler to handle_accel_set_msr_irqoff().  To signal this
> > > handler runs with host interrupts disabled and to make it a general place
> > > for accelerating WRMSRs in case we would require more in the future.
> >
> > Yes, TSCDEADLINE/VMX PREEMPTION TIMER is in my todo list after this merged
> > upstream, handle all the comments in v3, thanks for making this nicer
> > further. :)
>
> Handling those is very different than what is being proposed here though.
> For this case, only the side effect of the WRMSR is being expedited, KVM
> still goes through the heavy VM-Exit handler path to handle emulating the
> WRMSR itself.
>
> To truly expedite things like TSCDEADLINE, the entire emulation of WRMSR
> would need be handled without going through the standard VM-Exit handler,
> which is a much more fundamental change to vcpu_enter_guest() and has
> different requirements.  For example, keeping IRQs disabled is pointless
> for generic WRMSR emulation since the interrupt will fire as soon as KVM
> resumes the guest, whereas keeping IRQs disabled for processing ICR writes
> is a valid optimization since recognition of the IPI on the dest vCPU
> isn't dependent on KVM resuming the current vCPU.
>
> Rather than optimizing full emulation flows one at a time, i.e. exempting
> the ICR case, I wonder if we're better off figuring out a way to improve
> the performance of VM-Exit handling at a larger scale, e.g. avoid locking
> kvm->srcu unnecessarily, Andrea's retpolin changes, etc...

I use the latest kvm/queue, so Andrea's patch is there. As you know,
improve the performance of vmexit is a long term effort. But, let's
make v4 upstream firstly. :)

    Wanpeng
