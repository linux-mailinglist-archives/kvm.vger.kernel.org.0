Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7EE1BD090
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 01:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgD1XYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 19:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726044AbgD1XYF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 19:24:05 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B72C03C1AD
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 16:24:05 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id y26so241660ioj.2
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 16:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tYTe3rXjQCNrBkKTXCmJf8lKprp2RWUAlHsRaWNxGTc=;
        b=TXuANhi0BR/JvyNjZ8nFnQsNZ4GupoZB2lYXOs15aNSTXp8rXR8eORnV/dPHv5qVQO
         wtgyDJ2jD8GYUaTGPEjvTkkvFhLb8Sj1iszbfT4W0QH/hWFvecz9SLWlyz6qJpFr/u/e
         xVfR3geOpR/9ejNcEqBvcj4oXzS743JT5vt2JSc7V88h1ShcNVcBgF4vJh1HOkK21TaS
         0bGkVsqcf8wWQ016Azt0Ro1bKOedsJuhvo67WQwQcfsntwjg10hsHHRwWspyMmE/lC5m
         KE8nAWQ7H7+ELIVDnsmiZu1Y9ttYzJybd/6JoEFXeaqjPzn2QE9uI7DEkcn8Dxus7gvx
         wnWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tYTe3rXjQCNrBkKTXCmJf8lKprp2RWUAlHsRaWNxGTc=;
        b=f2BrNF+v7iACRw+kw5q4NT+N60K8Gn7Hor0w1+K+T27BcEAB2NL5EuYHomPMlH5V/J
         D54yuwN19cC0sNV18sGj5V0KsbQTlR1/5ubKrL1GPJ1pwcl0a0I6Q7UiZwSPHIgswcyF
         YeyydlVE/R7kYYZFYrav4/2CJi/ZoQD9awEeunYo0qsZrP3sAiqnzXgV9fghUDczHYrr
         PNWy6wxI2TLFQab0kAg8Ppn/wHvtrJgE+5h+QpdiLhRy2aD8vgU6UTolNIBm/GK2YrzG
         EXjJJ+tEryazHvzXyIysN6BFSkDjNH2n65QkpkKekihaYL7S087S7rVDOZLCVlhPd91u
         vf6A==
X-Gm-Message-State: AGi0PuadwyFCk/7sEAwxd5wK6Xk1SotXApd1MK+SYRNhD5v6ri7H78Td
        /GaWfdBEH6GY6XOOMglNVd5tjxDICiImVy1c90VhZsAyr1w=
X-Google-Smtp-Source: APiQypJARVyM9++FPpENPWT9FRn8ts9pOcs46/T52gRBupV/SBqZ6MaFNM0VJKXMuJDTTIEqosCza1ykao3hdWRhF5Q=
X-Received: by 2002:a5e:a610:: with SMTP id q16mr28422670ioi.75.1588116244121;
 Tue, 28 Apr 2020 16:24:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
 <20200423022550.15113-10-sean.j.christopherson@intel.com> <CALMp9eSuYqeVmWhb6q7T5DAW_Npbuin_N1+sbWjvcu0zTqiwsQ@mail.gmail.com>
 <20200428225949.GP12735@linux.intel.com>
In-Reply-To: <20200428225949.GP12735@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Apr 2020 16:23:52 -0700
Message-ID: <CALMp9eR8VsGAPrKLM2ZCG_DBTJa5Cn+raaUtzG=4V-bp_jxqWw@mail.gmail.com>
Subject: Re: [PATCH 09/13] KVM: nVMX: Prioritize SMI over nested IRQ/NMI
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 3:59 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Apr 28, 2020 at 03:04:02PM -0700, Jim Mattson wrote:
> > On Wed, Apr 22, 2020 at 7:26 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > Check for an unblocked SMI in vmx_check_nested_events() so that pendi=
ng
> > > SMIs are correctly prioritized over IRQs and NMIs when the latter eve=
nts
> > > will trigger VM-Exit.  This also fixes an issue where an SMI that was
> > > marked pending while processing a nested VM-Enter wouldn't trigger an
> > > immediate exit, i.e. would be incorrectly delayed until L2 happened t=
o
> > > take a VM-Exit.
> > >
> > > Fixes: 64d6067057d96 ("KVM: x86: stubs for SMM support")
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > ---
> > >  arch/x86/kvm/vmx/nested.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index 1fdaca5fd93d..8c16b190816b 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -3750,6 +3750,12 @@ static int vmx_check_nested_events(struct kvm_=
vcpu *vcpu)
> > >                 return 0;
> > >         }
> > >
> > > +       if (vcpu->arch.smi_pending && !is_smm(vcpu)) {
> > > +               if (block_nested_events)
> > > +                       return -EBUSY;
> > > +               goto no_vmexit;
> > > +       }
> > > +
> >
> > From the SDM, volume 3:
> >
> > =E2=80=A2 System-management interrupts (SMIs), INIT signals, and higher
> > priority events take priority over MTF VM exits.
> >
> > I think this block needs to be moved up.
>
> Hrm.  It definitely needs to be moved above the preemption timer, though =
I
> can't find any public documentation about the preemption timer's priority=
.

Section 25.2 of the SDM, volume 3:

Debug-trap exceptions and higher priority events take priority over VM
exits caused by the VMX-preemption
timer. VM exits caused by the VMX-preemption timer take priority over
VM exits caused by the =E2=80=9CNMI-window
exiting=E2=80=9D VM-execution control and lower priority events.
