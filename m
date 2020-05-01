Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A051C20E8
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 00:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgEAWwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 18:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726045AbgEAWwf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 May 2020 18:52:35 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F052C061A0C;
        Fri,  1 May 2020 15:52:35 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id o24so1132547oic.0;
        Fri, 01 May 2020 15:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5NE2ugARjA4M7w+U0ZI4lUiKzfDBfGonNFho9vSGY6c=;
        b=d5tWuAYYRY+B32Ms7iZ1bEDObBbIb6LyabvATNyFEdeCEK0Ye0hOva1MP4ffrSL6jl
         +yEIORxrZrxBIct14Ko5go7cir8ja61kcisYd9Ry5qstWEyJXNpPNfvP1HAx6HXcYuYB
         dKxR53sKEG+m2/CqFQB4ofJuGafJJCHrJv1xLnWHbxGT5GXKTaiIeKx57v607Uii8BtJ
         b9NrmjOj86fQSjQGGSM6Dvs64xA0wwAyUZozg2Soga3gSgrikmIh3B07Wpu2F68muq6U
         JYLO2zpdlD9qanx4ATXY6EpB1Pd5I3whEK/L4JkARu637VaiUrHOKU21qOEjk2lBdPvc
         Yoyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5NE2ugARjA4M7w+U0ZI4lUiKzfDBfGonNFho9vSGY6c=;
        b=ew0AzJIb5alQRbzvpF6mxLUNiD8tzl1IheDwko1vH57UOQtgqq12nBLpoH1gQlBBcg
         gWNy/EL9Rk3XvWC5lHHY8FcrLN1HcxPm5JKba7Xa9jNDclHGYiWtpskiqa3ik6JuY/3Y
         oDX2GHK3dZ3xNmBQJV8YasM1Lyd90xiEyw3rnWHteCy+W0T4gQwB1AUKAnV/BboncWA9
         asWHzoZCW1tC8DMxKK/ccAbpWH+8WGxN/psZM/Rky4Oq1yT7C6Td/kNXvydKWxwu39kp
         S5td12GY/oN7BcQvwUW9DLFYQ/3iAc0ieByOyvBB8XGVhj2L/Bb0uDtKgvcAEjgM0bV7
         UhKQ==
X-Gm-Message-State: AGi0PubEOJigxeaOdpLsuR4Ho6sWAetphodo8Zvq6TamJpXkXx0ozApR
        l/dKNeuKbWDgBPom1Rxe7f2r0m0PFuTD48H64HM=
X-Google-Smtp-Source: APiQypKryX6rVpcnoQm7RQhW5rfJ7a114pIVCUDVctwuZzdk7plx/cYiVJnmQiMAJ9ChFg29AMfARiq0VKK2fv5AhjQ=
X-Received: by 2002:aca:fc45:: with SMTP id a66mr1458670oii.5.1588373554626;
 Fri, 01 May 2020 15:52:34 -0700 (PDT)
MIME-Version: 1.0
References: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
 <1588055009-12677-2-git-send-email-wanpengli@tencent.com> <87ees5f6gh.fsf@vitty.brq.redhat.com>
 <20200501141159.GC3798@linux.intel.com>
In-Reply-To: <20200501141159.GC3798@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Sat, 2 May 2020 06:52:22 +0800
Message-ID: <CANRm+Cz9-3xN2m+z2Rr75xgV_k722mVfSuCyPetLr6mBN4rE2Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/7] KVM: VMX: Introduce generic fastpath handler
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 1 May 2020 at 22:12, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Apr 30, 2020 at 03:28:46PM +0200, Vitaly Kuznetsov wrote:
> > Wanpeng Li <kernellwp@gmail.com> writes:
> >
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > Introduce generic fastpath handler to handle MSR fastpath, VMX-preemption
> > > timer fastpath etc, move it after vmx_complete_interrupts() in order that
> > > later patch can catch the case vmexit occurred while another event was
> > > being delivered to guest. There is no obversed performance difference for
> > > IPI fastpath testing after this move.
> > >
> > > Tested-by: Haiwei Li <lihaiwei@tencent.com>
> > > Cc: Haiwei Li <lihaiwei@tencent.com>
> > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > ---
> > >  arch/x86/kvm/vmx/vmx.c | 21 ++++++++++++++++-----
> > >  1 file changed, 16 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 3ab6ca6..9b5adb4 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -6583,6 +6583,20 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
> > >     }
> > >  }
> > >
> > > +static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
> > > +{
> > > +   if (!is_guest_mode(vcpu)) {
> >
> > Nitpick: do we actually expect to have any fastpath handlers anytime
> > soon? If not, we could've written this as
> >
> >       if (is_guest_mode(vcpu))
> >               return EXIT_FASTPATH_NONE;
> >
> > and save on identation)
>
> Agreed.  An alternative approach would be to do the check in the caller, e.g.
>
>         if (is_guest_mode(vcpu))
>                 return EXIT_FASTPATH_NONE;
>
>         return vmx_exit_handlers_fastpath(vcpu);
>
> I don't have a strong preference either way.
>
> > > +           switch (to_vmx(vcpu)->exit_reason) {
> > > +           case EXIT_REASON_MSR_WRITE:
> > > +                   return handle_fastpath_set_msr_irqoff(vcpu);
> > > +           default:
> > > +                   return EXIT_FASTPATH_NONE;
> > > +           }
> > > +   }
> > > +
> > > +   return EXIT_FASTPATH_NONE;
> > > +}
> > > +
> > >  bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
> > >
> > >  static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
> > > @@ -6757,17 +6771,14 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
> > >     if (unlikely(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
> > >             return EXIT_FASTPATH_NONE;
> > >
> > > -   if (!is_guest_mode(vcpu) && vmx->exit_reason == EXIT_REASON_MSR_WRITE)
> > > -           exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
> > > -   else
> > > -           exit_fastpath = EXIT_FASTPATH_NONE;
> > > -
> > >     vmx->loaded_vmcs->launched = 1;
> > >     vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
> > >
> > >     vmx_recover_nmi_blocking(vmx);
> > >     vmx_complete_interrupts(vmx);
> > >
> > > +   exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
>
> No need for capturing the result in a local variable, just return the function
> call.

As you know later patches need to handle an local variable even
through we can make 1/7 nicer, it is just overridden.

    Wanpeng
