Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40101BB750
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 09:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgD1HRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 03:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgD1HRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 03:17:43 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC08C03C1A9;
        Tue, 28 Apr 2020 00:17:41 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id i27so30929861ota.7;
        Tue, 28 Apr 2020 00:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+qoRw4sNtKeON7FHmVZdwqZNioDMYulAX/VsZESJF8I=;
        b=FvDxgdGJgQM7T1VASWRIDYHdwDKAhqJ3GYjM32cOEYT2SuCCl6lRENorYhT5zKAiVB
         IyUOx/Y5uWHcnYxB8owwWlfWK2O1xlWMyLVgQegHR3LiO3QkNZ0+alxMZbGtzfJFzK41
         a4rOCHHiDuGVLgTZJsKaRh17ZMxqORcPZCVxqCu0TAZKcBonBOYe/87140TAGNhkh0uV
         mo7RzvG9OpL15c34Ogl3nlkIYaCzYYN8vo1SCWpDMWpk0EMy+CotNncSXSWqU/EaeYTy
         HsKsBPeuKQxkoEszlJ80VsgS8UdDuo67UtE8IyI7IBLSzGXOeCEODONB8hfWdGPaxOqp
         TrAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+qoRw4sNtKeON7FHmVZdwqZNioDMYulAX/VsZESJF8I=;
        b=tH3HUlbSJyynXPUhV+gSwUUJ68o/Euw8yvCW3kWvnap74MDmSPtd211Fyqvw2p/c+Y
         bbGa2CdLt/kBDagywf0sTAeqU6LxPw7sJILC0vYkfuuEujQj0+zl9oVeGblBONb00q9t
         tnBODK6ds/PjafFR0wql1m8kcj/fHjFzpKi2OCAOE9Kw7u1nhysqJQdEpwYZbv91g1wW
         4LbCAT7GHiiLnd9w8XOw8VWnNTQwUphNeORG6KkbXyK+1a00O1fSSNo5UPkv3eNv4y5q
         bhcu3eS8FG5rTGx2bxNsNvS5AYn/4C8rqNOMCHMHmfdxGBOxMwInOnRJPSyR4AzoIFnj
         HQhQ==
X-Gm-Message-State: AGi0PuYTJzod757kIofkT2l2/Nnu7bJzxRiyK5SVDjq4IIO4fZSkCJ9N
        qx0emVXn23Aovj4WwfQ8zNkgAAZHDXk+OFs52cI=
X-Google-Smtp-Source: APiQypJUXTnJiPqIZ99D5rHkPZMUmFGMBwDmtbd57BHOsCvcgctEALeqNLsAIFDh0FQpoIHzmN3EwyEdmNmXtxWCjTA=
X-Received: by 2002:a05:6830:20d9:: with SMTP id z25mr13560177otq.254.1588058261338;
 Tue, 28 Apr 2020 00:17:41 -0700 (PDT)
MIME-Version: 1.0
References: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
 <1587709364-19090-3-git-send-email-wanpengli@tencent.com> <20200427183013.GN14870@linux.intel.com>
In-Reply-To: <20200427183013.GN14870@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 28 Apr 2020 15:17:30 +0800
Message-ID: <CANRm+CxfYB9TULkZdnUVyhFgLLWBScDXFRBrFo0Nig_H0VH_1w@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] KVM: X86: Introduce need_cancel_enter_guest helper
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Apr 2020 at 02:30, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Apr 24, 2020 at 02:22:41PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Introduce need_cancel_enter_guest() helper, we need to check some
> > conditions before doing CONT_RUN, in addition, it can also catch
> > the case vmexit occurred while another event was being delivered
> > to guest software since vmx_complete_interrupts() adds the request
> > bit.
> >
> > Tested-by: Haiwei Li <lihaiwei@tencent.com>
> > Cc: Haiwei Li <lihaiwei@tencent.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 12 +++++++-----
> >  arch/x86/kvm/x86.c     | 10 ++++++++--
> >  arch/x86/kvm/x86.h     |  1 +
> >  3 files changed, 16 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index f1f6638..5c21027 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6577,7 +6577,7 @@ bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
> >
> >  static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >  {
> > -     enum exit_fastpath_completion exit_fastpath;
> > +     enum exit_fastpath_completion exit_fastpath = EXIT_FASTPATH_NONE;
> >       struct vcpu_vmx *vmx = to_vmx(vcpu);
> >       unsigned long cr3, cr4;
> >
> > @@ -6754,10 +6754,12 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >       vmx_recover_nmi_blocking(vmx);
> >       vmx_complete_interrupts(vmx);
> >
> > -     exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
> > -     /* static call is better with retpolines */
> > -     if (exit_fastpath == EXIT_FASTPATH_CONT_RUN)
> > -             goto cont_run;
> > +     if (!kvm_need_cancel_enter_guest(vcpu)) {
> > +             exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
> > +             /* static call is better with retpolines */
> > +             if (exit_fastpath == EXIT_FASTPATH_CONT_RUN)
> > +                     goto cont_run;
> > +     }
> >
> >       return exit_fastpath;
> >  }
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 59958ce..4561104 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1581,6 +1581,13 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
> >
> > +bool kvm_need_cancel_enter_guest(struct kvm_vcpu *vcpu)
>
> What about kvm_vcpu_<???>_pending()?  Not sure what a good ??? would be.
> The "cancel_enter_guest" wording is a bit confusing when this is called
> from the VM-Exit path.
>
> > +{
> > +     return (vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu)
> > +         || need_resched() || signal_pending(current));
>
> Parantheses around the whole statement are unnecessary.  Personal preference
> is to put the || before the newline.

Handle the comments in v4.

    Wanpeng
