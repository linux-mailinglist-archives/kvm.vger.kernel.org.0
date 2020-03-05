Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A31F17A6E0
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 14:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgCEN6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 08:58:41 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44876 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgCEN6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 08:58:40 -0500
Received: by mail-ed1-f67.google.com with SMTP id g19so6854920eds.11;
        Thu, 05 Mar 2020 05:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rNTzXrB832O0d7PUWukTa9E1/zE695OCKFkidoMrZjI=;
        b=oNp+TOTEL1Y59xfMv4csWvhQdlJwA74XbypevDWOnVcCQs6g/isYG+IkYoixHDgI6d
         6T+fvjBw7voWQ50R6yKgHDmJWkDJt/PjQAXCTMyccDhfMafItIzlPZplsMUOi3fotpL/
         neWeDmzHv38IlT1D1TgMZVZGaSRmfjlMAKVQQIylnvBOdAvjEhB6FgAbBIFo2iMFYbnv
         DdDYfI4/URKRN2GxE2YdCnHEpSJ2BUzo/3s5PLTKHtx+WKSchsi3PAvF0+ix3ikF6NKI
         gswBnDMnTxjJ5w9OZToT/uOKtOosr0rP4HqeiZGyD7hNWo/HXOnsJYev1CDKxhg9YcVU
         eM1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rNTzXrB832O0d7PUWukTa9E1/zE695OCKFkidoMrZjI=;
        b=pPArEtxRbEejLfkb+mGCiz/XbFrh1JSBm07INRwvtqTxluWjD3g5pvRSP0F+uiHwce
         ogP9o2l5WcMzjKqATyGXhV3xk0iFQs8ALg9R+1xKmj9uFGEmVG4PSUYlsDPxgVziDJwt
         ckAn08HobjGkx4QNitWbtBz+yAEKLS8KbV5kN2RnsmDjH3EV1EBMk4Nx7rDs5ASQKwYn
         vFkpnqLoUu3LGXVhH1n2KQ27h8zCRa0vDbjd7dTcwavbxsLS7brV/4oRjMCOq4oH9dVu
         MdeKw9gIGKTJk7x5HlWSiFFIo2XIF16PR11I5Odda487yz1IHaDW3KzIbTOelwkw031X
         fQcg==
X-Gm-Message-State: ANhLgQ04vY7IYBJKrYW5Wa7o2hHKFyYU3l/gjWcVdAhpY4wJrh0Vjk67
        ed9cSWIl4d+PYErWwQ9YfysoI1tApkXrNiLvirw=
X-Google-Smtp-Source: ADFU+vuEQDLgoFWSTJ7Owr5NAls8SMcGCCsmvg7rsI+JTHTQ3xmXBNNtbjEV7pKoiYjLgPSwnTHPYN1yUb0mKq0c1cA=
X-Received: by 2002:a50:d849:: with SMTP id v9mr8738830edj.105.1583416718881;
 Thu, 05 Mar 2020 05:58:38 -0800 (PST)
MIME-Version: 1.0
References: <20200303130356.50405-1-arilou@gmail.com> <20200303130356.50405-4-arilou@gmail.com>
 <87mu8wdxtt.fsf@vitty.brq.redhat.com>
In-Reply-To: <87mu8wdxtt.fsf@vitty.brq.redhat.com>
From:   Jon Doron <arilou@gmail.com>
Date:   Thu, 5 Mar 2020 15:58:37 +0200
Message-ID: <CAP7QCojt9J6KoSCtr3c0vDa1GB0=V1VAkMf4pxKY2zK1sEXP_g@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] x86/kvm/hyper-v: Add support for synthetic
 debugger via hypercalls
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 4, 2020 at 4:00 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Jon Doron <arilou@gmail.com> writes:
>
> > There is another mode for the synthetic debugger which uses hypercalls
> > to send/recv network data instead of the MSR interface.
> >
> > This interface is much slower and less recommended since you might get
> > a lot of VMExits while KDVM polling for new packets to recv, rather
> > than simply checking the pending page to see if there is data avialble
> > and then request.
> >
> > Signed-off-by: Jon Doron <arilou@gmail.com>
> > ---
> >  arch/x86/include/asm/hyperv-tlfs.h |  5 +++++
> >  arch/x86/kvm/hyperv.c              | 11 +++++++++++
> >  2 files changed, 16 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> > index 8efdf974c23f..4fa6bf3732a6 100644
> > --- a/arch/x86/include/asm/hyperv-tlfs.h
> > +++ b/arch/x86/include/asm/hyperv-tlfs.h
> > @@ -283,6 +283,8 @@
> >  #define HV_X64_MSR_SYNDBG_PENDING_BUFFER     0x400000F5
> >  #define HV_X64_MSR_SYNDBG_OPTIONS            0x400000FF
> >
> > +#define HV_X64_SYNDBG_OPTION_USE_HCALLS              BIT(2)
> > +
>
> BIT(2) of what? :-) Also, you don't seem to use this define anywhere.
>

Will use it now :) and it's a syndbg MSR option bit

> >  /* Hyper-V guest crash notification MSR's */
> >  #define HV_X64_MSR_CRASH_P0                  0x40000100
> >  #define HV_X64_MSR_CRASH_P1                  0x40000101
> > @@ -392,6 +394,9 @@ struct hv_tsc_emulation_status {
> >  #define HVCALL_SEND_IPI_EX                   0x0015
> >  #define HVCALL_POST_MESSAGE                  0x005c
> >  #define HVCALL_SIGNAL_EVENT                  0x005d
> > +#define HVCALL_POST_DEBUG_DATA                       0x0069
> > +#define HVCALL_RETRIEVE_DEBUG_DATA           0x006a
> > +#define HVCALL_RESET_DEBUG_SESSION           0x006b
> >  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
> >  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
> >
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index 7ec962d433af..593e0f3f4dba 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -1794,6 +1794,17 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> >               }
> >               ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, true, false);
> >               break;
> > +     case HVCALL_POST_DEBUG_DATA:
> > +     case HVCALL_RETRIEVE_DEBUG_DATA:
> > +     case HVCALL_RESET_DEBUG_SESSION:
> > +             vcpu->run->exit_reason = KVM_EXIT_HYPERV;
> > +             vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
> > +             vcpu->run->hyperv.u.hcall.input = param;
> > +             vcpu->run->hyperv.u.hcall.params[0] = ingpa;
> > +             vcpu->run->hyperv.u.hcall.params[1] = outgpa;
> > +             vcpu->arch.complete_userspace_io =
> > +                             kvm_hv_hypercall_complete_userspace;
> > +             return 0;
> >       default:
> >               ret = HV_STATUS_INVALID_HYPERCALL_CODE;
> >               break;
>
> --
> Vitaly
>
