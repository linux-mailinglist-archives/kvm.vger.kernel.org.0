Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E9E1B5898
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 11:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgDWJyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 05:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDWJya (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 05:54:30 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97ABCC03C1AF;
        Thu, 23 Apr 2020 02:54:30 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id t3so1174387oou.8;
        Thu, 23 Apr 2020 02:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2+tCyipaNqVV0N3AqaOsT6FQs4vP2wHKkBmD2urCaQg=;
        b=BJrEApAs6KnHtxWnrK7DdtZVtIakjCkamAHbflZmeIDx3ODZRfnl2JLAWbIpYpWvEG
         cNFD63Rol9SC9vpUBaFqdznz8V5NHpyXd9pWCrozEhox7uZUNP6nnPnYDQkSvKVvJD1l
         ntJOXVLGztXNaVXhY3VlZACxRXBx1UYHSw+nnphdauxz+a/JAmVbbTBXw1Zc6W7FvECQ
         lTy7oCoRvG4O4WeXqObE5DGgR9oSjqurj+d05eokN8V9aAT6Ws7VPubIM5tnDamul6PI
         Z/WNbCyVuOdAdGP/iMi/ywsUeTnYvD02QuDCD106e3R0EVUAXmsWBOj9xKo0UWy4lcZ5
         zF7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2+tCyipaNqVV0N3AqaOsT6FQs4vP2wHKkBmD2urCaQg=;
        b=s1D+bxalbSJI3FOBfV7t325n3JX+v6wIsc373CAF4uusggWCWv6UGTwZhxZDHZuBkj
         E7PoEDrAGxu/UE/UPFmQd/5LVpk4cVzRyQbODqkixF5zB/TYzUOVKo2EISd2NM+sXCwT
         WDgumTQ6PYSfhN+exMAtT2NTHuYW+9mE8nFwsKd5UDnrm/qPKEyZciZnUYLh6Y7Jr0ol
         lDkdHs2IdqUgJGdHl8J0EnB0YdyPhCW1z/4u9UZbMzyxtt2OS2KtjotCs1Ni0KYw24xG
         LAOXJ1LmAxlyncFgq6aNNU/o2tYPHYJ23QmgpWrltyu5sBKjIA+A2ka2j7aQvhVhhZYh
         JgSw==
X-Gm-Message-State: AGi0PubgDy+qlbQidP0lI5pFmDKYtnQHVM2iLzkGokJtmqECO05PTVOF
        W4T3PKSHEndsdjaHcK9htBSpnEWsKkFvtWXD8Rg=
X-Google-Smtp-Source: APiQypLOEV9PcQMTp0kxuOhw0v6xZ7EDA7GhTwOKfda/G84PzeNSqtYsrgdZg+XZFBibqnwNgG1zxfxGGkSB65YmvWk=
X-Received: by 2002:a4a:a5d0:: with SMTP id k16mr2580802oom.41.1587635670034;
 Thu, 23 Apr 2020 02:54:30 -0700 (PDT)
MIME-Version: 1.0
References: <1587632507-18997-1-git-send-email-wanpengli@tencent.com>
 <1587632507-18997-5-git-send-email-wanpengli@tencent.com> <1309372a-0dcf-cba6-9d65-e50139bbe46b@redhat.com>
In-Reply-To: <1309372a-0dcf-cba6-9d65-e50139bbe46b@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 23 Apr 2020 17:54:19 +0800
Message-ID: <CANRm+CwwUO9Snyvuhyg8zbLf9DRhQ8RhRddkrdu+wRjF8v5tdw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] KVM: X86: TSCDEADLINE MSR emulation fastpath
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

On Thu, 23 Apr 2020 at 17:39, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 23/04/20 11:01, Wanpeng Li wrote:
> > +
> > +void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
> > +{
> > +     if (__kvm_set_lapic_tscdeadline_msr(vcpu, data))
> > +             start_apic_timer(vcpu->arch.apic);
> > +}
> > +
> > +int kvm_set_lapic_tscdeadline_msr_fast(struct kvm_vcpu *vcpu, u64 data)
> > +{
> > +     struct kvm_lapic *apic = vcpu->arch.apic;
> > +
> > +     if (__kvm_set_lapic_tscdeadline_msr(vcpu, data)) {
> > +             atomic_set(&apic->lapic_timer.pending, 0);
> > +             if (start_hv_timer(apic))
> > +                     return tscdeadline_expired_timer_fast(vcpu);
> > +     }
> > +
> > +     return 1;
> >  }
> >
> > +static int tscdeadline_expired_timer_fast(struct kvm_vcpu *vcpu)
> > +{
> > +     if (kvm_check_request(KVM_REQ_PENDING_TIMER, vcpu)) {
> > +             kvm_clear_request(KVM_REQ_PENDING_TIMER, vcpu);
> > +             kvm_inject_apic_timer_irqs_fast(vcpu);
> > +             atomic_set(&vcpu->arch.apic->lapic_timer.pending, 0);
> > +     }
> > +
> > +     return 0;
> > +}
>
> This could also be handled in apic_timer_expired.  For example you can
> add an argument from_timer_fn and do
>
>         if (!from_timer_fn) {
>                 WARN_ON(kvm_get_running_vcpu() != vcpu);
>                 kvm_inject_apic_timer_irqs_fast(vcpu);
>                 return;
>         }
>
>         if (kvm_use_posted_timer_interrupt(apic->vcpu)) {
>                 ...
>         }
>         atomic_inc(&apic->lapic_timer.pending);
>         kvm_set_pending_timer(vcpu);
>
> and then you don't need kvm_set_lapic_tscdeadline_msr_fast and

I guess you mean don't need tscdeadline_expired_timer_fast().

    Wanpeng
