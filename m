Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE320C129C
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2019 03:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbfI2BEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Sep 2019 21:04:12 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39138 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729032AbfI2BEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Sep 2019 21:04:12 -0400
Received: by mail-oi1-f196.google.com with SMTP id w144so8253426oia.6;
        Sat, 28 Sep 2019 18:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mjDCHjvefjsOl4i4odq9Y1SXsI3TKsYxqV+9CCCkRQ0=;
        b=PizXarv4j80epZJBEGUgV+rJ/1SaITLPVKuYmufn9DP/i5Fc3Uel1k48GoUceWedFE
         BP9LtEeOSxAyBr+Qdrr4MYEkzR2gaml5e8Jk95CYads4/WD7+bjRhJR8r9192XNl58CF
         F54KkQLKHGHYZ2RBhr++yNUquAk5FoNZglTr5Ja9i/jLirojNULTx9ZMT3qlvZC2WXxK
         baRLL0rLm5eBKqCeZ34hUzS8kU03mkB4iKZ55+4LlsxFYEIqskuIiqiPGh6GXAXnccsW
         Xd7O3n91ZDD6zN9H/rqwljmXnjBjwOzvMcFuqkeK3YqvRk7iEkCz8JNZkIlxK0wcXAZf
         68bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mjDCHjvefjsOl4i4odq9Y1SXsI3TKsYxqV+9CCCkRQ0=;
        b=k0ilnPtYTASXss2SVQDbmcXkwAJ7lciYdVV+eoSe7y9+Xt7POV3sLDdEH2qtIV+6TD
         UwklJAtEXW9at9KNv6LA9uWppM0KSx0/iomSZtJDCaRSrWiOWwRvtkZqxdJBkr5X6LoQ
         d7kKyUHguO2mmEY0JPvKqrPtXCLyyX9PvMa0CrepGwks7syPeJkYmXr0WuWRx6zBpRbz
         XUTEFSEdb/EnZxwRUv6RbLjUVr0V8/ZAUgpUInlKoIh2LpINxFEaPbMpjOVHyD2/PDX3
         IFw14yAbF89fJxu5tZ9VieJfwkjCem24KacWlmmmxpiZiJ8q5ChstCWP/3kT3CL44cGl
         v9Kw==
X-Gm-Message-State: APjAAAV0cJl0I6tzP/EhCShNulXOFMAPCUAJwBDbk29DGU6tVdkqEKQM
        YcZbHhjxDiPszcsuBH5jt/2nrxhXyknlcdANnvQ=
X-Google-Smtp-Source: APXvYqxtb6RSr+qU2hCAwS7kVNdsLkzt8dSL9e3b3c1Ig3+Z3jgC31Gd9TbeTYbdblbxnKvq6DrccOkx40AxswpCdjE=
X-Received: by 2002:aca:d709:: with SMTP id o9mr13108299oig.174.1569719052063;
 Sat, 28 Sep 2019 18:04:12 -0700 (PDT)
MIME-Version: 1.0
References: <1569572822-28942-1-git-send-email-wanpengli@tencent.com> <20190927154958.GB11810@amt.cnet>
In-Reply-To: <20190927154958.GB11810@amt.cnet>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Sun, 29 Sep 2019 09:03:57 +0800
Message-ID: <CANRm+Cw5Ngj7aw_Q_5X+CE3+Rjwb=0U2Nsmi7U0vKUbdpKgeSg@mail.gmail.com>
Subject: Re: [PATCH] KVM: Don't shrink/grow vCPU halt_poll_ns if host side
 polling is disabled
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 28 Sep 2019 at 01:24, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> On Fri, Sep 27, 2019 at 04:27:02PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Don't waste cycles to shrink/grow vCPU halt_poll_ns if host
> > side polling is disabled.
> >
> > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  virt/kvm/kvm_main.c | 28 +++++++++++++++-------------
> >  1 file changed, 15 insertions(+), 13 deletions(-)
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index e6de315..b368be4 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2359,20 +2359,22 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> >       kvm_arch_vcpu_unblocking(vcpu);
> >       block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
> >
> > -     if (!vcpu_valid_wakeup(vcpu))
> > -             shrink_halt_poll_ns(vcpu);
> > -     else if (halt_poll_ns) {
> > -             if (block_ns <= vcpu->halt_poll_ns)
> > -                     ;
> > -             /* we had a long block, shrink polling */
> > -             else if (vcpu->halt_poll_ns && block_ns > halt_poll_ns)
> > +     if (!kvm_arch_no_poll(vcpu)) {
> > +             if (!vcpu_valid_wakeup(vcpu))
> >                       shrink_halt_poll_ns(vcpu);
> > -             /* we had a short halt and our poll time is too small */
> > -             else if (vcpu->halt_poll_ns < halt_poll_ns &&
> > -                     block_ns < halt_poll_ns)
> > -                     grow_halt_poll_ns(vcpu);
> > -     } else
> > -             vcpu->halt_poll_ns = 0;
> > +             else if (halt_poll_ns) {
> > +                     if (block_ns <= vcpu->halt_poll_ns)
> > +                             ;
> > +                     /* we had a long block, shrink polling */
> > +                     else if (vcpu->halt_poll_ns && block_ns > halt_poll_ns)
> > +                             shrink_halt_poll_ns(vcpu);
> > +                     /* we had a short halt and our poll time is too small */
> > +                     else if (vcpu->halt_poll_ns < halt_poll_ns &&
> > +                             block_ns < halt_poll_ns)
> > +                             grow_halt_poll_ns(vcpu);
> > +             } else
> > +                     vcpu->halt_poll_ns = 0;
> > +     }
> >
> >       trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
> >       kvm_arch_vcpu_block_finish(vcpu);
> > --
> > 2.7.4
>
> Looks good.

I will add your ACK in v2.

    Wanpeng
