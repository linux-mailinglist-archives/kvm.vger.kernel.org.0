Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC611953EE
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 10:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgC0J1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 05:27:18 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:33336 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgC0J1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Mar 2020 05:27:16 -0400
Received: by mail-oi1-f195.google.com with SMTP id m14so8251306oic.0;
        Fri, 27 Mar 2020 02:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mxJM5ZIhu7LpQ+5NV71sEjP70ux0ckHNNXazRf9xK2k=;
        b=qclDenfHJNoe/IbZxPSfOepV1+OSvwFv2zwQd92O5HAfGOLqhoZDmdC5cKQ6tXtqDv
         r9aF7m/wkriX8p0dI89Uj+oZ8xKuoXjKxkU0F02iKIfpjNBbI2cEKtNlVXfF9FugLVIA
         ljpmEwXZzTrVQoLu/Xz37CPdnQqa+oku+v97n+FYIp6SkRhYY0bBq4R94hUB54htYP4m
         9mHCZNoZ0F7DYNIbD3bC9N123yuXzAYbIM363NlRJrMmzlzyKQY3681J6v10P5h6FWyg
         hGVbwkP6yhbRQSmLujKhFYgSg2bPcyvcwzonjl6bjmW0VCzoMzhO7KgXeKSDy8ffmKzp
         Y50g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mxJM5ZIhu7LpQ+5NV71sEjP70ux0ckHNNXazRf9xK2k=;
        b=jvOXCowtkcJH4ecJ4eA8ZRIyxjmdagvlzLILJjFdDygefbf59JuXRbwlJ36eMFPIGq
         QoARUIIR6Zo2sbxunBXtqUpBfVAWYzaCoiIQPnTnSShlQqhq+FqyW2+hYEu80k7KrzD6
         s9ZW/IOjLrvvbAGd4ABb0ta4uenPMOwFa01vv7vXnokNBjXRkOqJKgvpa0+SAWX7KAhm
         gmAJNQOqV89lTwSnYRQNpGgImkIEJdyhmspBUTTIxddJUAY5fwP7fiKT+QQKp5kQMYsL
         alUArc8/MLzWk+0LDySlIxa/RcmFKfeaD8DaN/FdDFPJ0Fi9aFzerR5MxejmLFJ7jt2n
         662Q==
X-Gm-Message-State: ANhLgQ37qFsgPrjmpxUjh7NdVRY9slBI5mB0nVau2+CHn021b3lkIyci
        P+DZ6UTgM3+7esFzAEamVXOhd1z81cvWJuSaMsM=
X-Google-Smtp-Source: ADFU+vvxewAN9wA5TUvmoNDEwLFRuGiDSd8Fyty0Qven1rU+JHBVv9EW4qnwryLCjS/JFO3ppsHqsCEAN3uB3kOPAok=
X-Received: by 2002:aca:f288:: with SMTP id q130mr3241437oih.33.1585301235733;
 Fri, 27 Mar 2020 02:27:15 -0700 (PDT)
MIME-Version: 1.0
References: <1585290240-18643-1-git-send-email-wanpengli@tencent.com>
 <1585290240-18643-2-git-send-email-wanpengli@tencent.com> <87eete415a.fsf@vitty.brq.redhat.com>
In-Reply-To: <87eete415a.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 27 Mar 2020 17:27:04 +0800
Message-ID: <CANRm+CzHSTrGPpqxwzhtCvKtK-jpLvF=MvxVA06dCSAZbHgFng@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: LAPIC: Don't need to clear IPI delivery status
 for x2apic
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Mar 2020 at 17:07, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > IPI delivery status field is not present for x2apic, don't need
> > to clear IPI delivery status for x2apic.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c | 3 ++-
> >  arch/x86/kvm/x86.c   | 1 -
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 88929b1..f6d69e2 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1942,7 +1942,8 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
> >       }
> >       case APIC_ICR:
> >               /* No delay here, so we always clear the pending bit */
>
> 'Always' in the comment above now reads a bit odd, I'd suggest modifying
> it to 'Immediately clear Delivery Status field in xAPIC mode' - or just
> drop it altogeter.

Thank you for your review, I guess Paolo can do it when apply.

    Wanpeng

>
> > -             val &= ~(1 << 12);
> > +             if (!apic_x2apic_mode(apic))
> > +                     val &= ~(1 << 12);
> >               kvm_apic_send_ipi(apic, val, kvm_lapic_get_reg(apic, APIC_ICR2));
> >               kvm_lapic_set_reg(apic, APIC_ICR, val);
> >               break;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 495709f..6ced0e1 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1562,7 +1562,6 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
> >               ((data & APIC_MODE_MASK) == APIC_DM_FIXED) &&
> >               ((u32)(data >> 32) != X2APIC_BROADCAST)) {
> >
> > -             data &= ~(1 << 12);
> >               kvm_apic_send_ipi(vcpu->arch.apic, (u32)data, (u32)(data >> 32));
> >               kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR2, (u32)(data >> 32));
> >               kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR, (u32)data);
>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> --
> Vitaly
>
