Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579261B3425
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 02:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgDVAtF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 20:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726012AbgDVAtF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 20:49:05 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26640C0610D5;
        Tue, 21 Apr 2020 17:49:05 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id t199so447505oif.7;
        Tue, 21 Apr 2020 17:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fyWIvNsFDIbDhj5AHIg5Xemvwg92lR3Mt2pRS9IX/eY=;
        b=ZRepC3bJo7TngfHSxmUTuuwFth5NE423gQHfzhrwqKOW/rG5flMB9dP4weA4JGtEHy
         UOBQ4Lf1S1PdyWACh3vfJi+ahA2GTwmdqRTMkpI2odZ1aVL0cmeI4P3R+JuMjM6MgytQ
         BBqEyteRb5uhGwjNUkbcjf0X/8GMIgRTWOgHzd70a+ST/Ejez9ptO9rYQk/v71Xf42Yw
         5YsUN63ngS+fYMnpRva8OJhT/fudkSJYWu0RBS6xqRLaXVBKgoYt48ip6j8vFF82b0c1
         kVJaUDUc9DIjdq5gzUf2jw/IG4Fcq1OEV6pL8Zt6C2WhiSUTp0gE5zargeJiJLOLexqp
         F8ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fyWIvNsFDIbDhj5AHIg5Xemvwg92lR3Mt2pRS9IX/eY=;
        b=gwQakFJCVVSkmXm8oGpNBnINI2anJVUX5YPDcId0V15c/pmqZ31LOHBCHbFhYfliek
         wgkezHM8fvUyEZXLfT0YN48D6YZ09iyf6dn5nsSqpWMMrjjUqih2UHV1p6V1XH4lrZDs
         kUU8HmI60nSHGpvg1CdAh1zbvmf91/sPe2WDtX7g1fh+SZmt3JDeXcua0Rh+6dUocdLr
         vTDviTJHdBU+JqFcnodDj3nZd2BdnkEwy/nP419ER8hGyG2HnoLabCVmCX+GJUB2AUgQ
         KdipwNXEcsIlWIrVN96HfQJWHipE/b85dAHIp1hTnO/eiYJ6MDNbaeVJujB4woZj+Em3
         JENg==
X-Gm-Message-State: AGi0Pub4UlEXzEZa4xixzgiXi0GShIUZR7K+kROMdt5J+cV9763+HSnd
        zpEtsFqg13p3PzYZWUlbC86FtmOgJBzSqdxBBWU=
X-Google-Smtp-Source: APiQypLD9AwSNYzuxvfQfpcQ099bZV8Nz8y3kuAYm1wHcLyTZkfVBsJCzZstjc+PvCkJN1SfCN9lsgMQMrz02HpXq8w=
X-Received: by 2002:aca:2801:: with SMTP id 1mr4840905oix.141.1587516544513;
 Tue, 21 Apr 2020 17:49:04 -0700 (PDT)
MIME-Version: 1.0
References: <1587468026-15753-1-git-send-email-wanpengli@tencent.com>
 <1587468026-15753-2-git-send-email-wanpengli@tencent.com> <ed968729-5d2a-a318-1d8f-db39e6ee72cb@redhat.com>
In-Reply-To: <ed968729-5d2a-a318-1d8f-db39e6ee72cb@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 22 Apr 2020 08:48:53 +0800
Message-ID: <CANRm+CxzROx=eawemmzh==2Mz-DxKSyYFSxHqLxUiGFFnWkAYw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: X86: TSCDEADLINE MSR emulation fastpath
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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

On Tue, 21 Apr 2020 at 19:37, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 21/04/20 13:20, Wanpeng Li wrote:
> > +     case MSR_IA32_TSCDEADLINE:
> > +             if (!kvm_x86_ops.event_needs_reinjection(vcpu)) {
> > +                     data = kvm_read_edx_eax(vcpu);
> > +                     if (!handle_fastpath_set_tscdeadline(vcpu, data))
> > +                             ret = EXIT_FASTPATH_CONT_RUN;
> > +             }
> >               break;
>
> Can you explain the event_needs_reinjection case?  Also, does this break

This is used to catch the case vmexit occurred while another event was
being delivered to guest software, I move the
vmx_exit_handlers_fastpath() call after vmx_complete_interrupts()
which will decode such event and make kvm_event_needs_reinjection
return true.

> AMD which does not implement the callback?

Now I add the tscdeadline msr emulation and vmx-preemption timer
fastpath pair for Intel platform.

>
> > +
> > +     reg = kvm_lapic_get_reg(apic, APIC_LVTT);
> > +     if (kvm_apic_hw_enabled(apic) && !(reg & APIC_LVT_MASKED)) {
> > +             vector = reg & APIC_VECTOR_MASK;
> > +             kvm_lapic_clear_vector(vector, apic->regs + APIC_TMR);
> > +
> > +             if (vcpu->arch.apicv_active) {
> > +                     if (pi_test_and_set_pir(vector, &vmx->pi_desc))
> > +                             return;
> > +
> > +                     if (pi_test_and_set_on(&vmx->pi_desc))
> > +                             return;
> > +
> > +                     vmx_sync_pir_to_irr(vcpu);
> > +             } else {
> > +                     kvm_lapic_set_irr(vector, apic);
> > +                     kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
> > +                     vmx_inject_irq(vcpu);
> > +             }
> > +     }
>
> This is mostly a copy of
>
>                if (kvm_x86_ops.deliver_posted_interrupt(vcpu, vector)) {
>                         kvm_lapic_set_irr(vector, apic);
>                         kvm_make_request(KVM_REQ_EVENT, vcpu);
>                         kvm_vcpu_kick(vcpu);
>                 }
>                 break;
>
> (is it required to do vmx_sync_pir_to_irr?).  So you should not special

I observe send notification vector as in
kvm_x86_ops.deliver_posted_interrupt() is ~900 cycles worse than
vmx_sync_pir_to_irr in my case. It needs to wait guest vmentry, then
the physical cpu ack the notification vector, read posted-interrupt
desciptor etc. For the non-APICv part, original copy needs to wait
inject_pending_event to do these stuff.

> case LVTT and move this code to lapic.c instead.  But even before that...
>
> >
> > +
> > +     if (kvm_start_hv_timer(apic)) {
> > +             if (kvm_check_request(KVM_REQ_PENDING_TIMER, vcpu)) {
> > +                     if (kvm_x86_ops.interrupt_allowed(vcpu)) {
> > +                             kvm_clear_request(KVM_REQ_PENDING_TIMER, vcpu);
> > +                             kvm_x86_ops.fast_deliver_interrupt(vcpu);
> > +                             atomic_set(&apic->lapic_timer.pending, 0);
> > +                             apic->lapic_timer.tscdeadline = 0;
> > +                             return 0;
> > +                     }
> > +                     return 1;
>
>
> Is it actually common that the timer is set back in time and therefore
> this code is executed?

It is used to handle the already-expired timer.

    Wanpeng
