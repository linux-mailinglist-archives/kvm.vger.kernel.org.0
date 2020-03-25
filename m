Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F671191DF0
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 01:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgCYAQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 20:16:25 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:40058 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbgCYAQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 20:16:25 -0400
Received: by mail-oi1-f193.google.com with SMTP id y71so477280oia.7;
        Tue, 24 Mar 2020 17:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xliuxZL0N48dRPjxOaKyrNwz6ljCGZsPU9rKwkE7dMU=;
        b=EHRCFejjY7irVPRNrXToOdyPzFbIIVxupoMSIZ3sZHI5sW6dPc/MOGfEcs2D1oijRf
         iJCqcJ0SaYXZIkdO2TK50428ar8Hfu6RfIkiBBm5KPw47FjlbWAaEKPP0PzqHcIuyDBs
         3mFoJzvZIDlYwJt2IBN+gOI0bAp9ndohAOFQKwcPyvCrih02ttSjsDowYGj55sq7EPnY
         6FvOSijPVES5PGFBGYhKzUxbQhACthtCR9VSgv2ptsjDXOpYzMRApxpIG+31ogp2LwS7
         NTNp0UL78h5ek7JFQPY1EktTqXpx5rdULzFIUYP4p0o7HOA0klTHaNpsI/qoJ58qBGDk
         6sxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xliuxZL0N48dRPjxOaKyrNwz6ljCGZsPU9rKwkE7dMU=;
        b=la4Eomiinb9j7yY6NXr2GSeOtd2K5dWuMKLbjFet5V28pHFqYBUrrIVAZpPf4lSkYv
         y1OyKpT5xtYQfTM3IjixlYHwNqYR42kdtntszs+rQph3hEErAc9jUuIjalKRL1FbSxmP
         LXRqAiaqPLqixyVBDt6bxe0a/NdikxO3ZVnHbVhOS+Q1mC5HjXDDsBMWxdAYc2GVaMVo
         wOsdXdLRXb51VSZZOxzwXSxWOLejuTNW9FcXepki1O4Csnaz9ox/MImMyiDDNyAn4DLc
         vgZEP0DivSQjmc6Dw91hw4wsy/Bc0RC1OZsOpsykBqXppqg8e7zS7Umu1OBp231aDkFq
         faxg==
X-Gm-Message-State: ANhLgQ32mXI3EQtlewJ23jQDfBNP1He9x1UqpGqbQ3qZ+gtV0AR2VrqT
        ZbiVF1rohtCnZZ1AwgyLTQ11BQ1o3ktosoE+2oM=
X-Google-Smtp-Source: ADFU+vuWZfSmCCCpQULIK9/hyWt2qgVGVD6m9TH4/fYLs5foUB6Ms/445kjkoaT2BeBAlEVI35QGAvmTJ4aTbVnLHeM=
X-Received: by 2002:aca:f288:: with SMTP id q130mr236015oih.33.1585095384559;
 Tue, 24 Mar 2020 17:16:24 -0700 (PDT)
MIME-Version: 1.0
References: <1585031530-19823-1-git-send-email-wanpengli@tencent.com> <87imit7p36.fsf@vitty.brq.redhat.com>
In-Reply-To: <87imit7p36.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 25 Mar 2020 08:16:13 +0800
Message-ID: <CANRm+Cx8sNJmwB3kYWxfcWJNi9A3AdAtLdpwMduiRTfkz2PJVw@mail.gmail.com>
Subject: Re: [PATCH] KVM: LAPIC: Also cancel preemption timer when disarm
 LAPIC timer
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

On Tue, 24 Mar 2020 at 23:24, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > The timer is disarmed when switching between TSC deadline and other modes,
> > we should set everything to disarmed state, however, LAPIC timer can be
> > emulated by preemption timer, it still works if vmx->hv_deadline_timer is
> > not -1. This patch also cancels preemption timer when disarm LAPIC timer.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 338de38..a38f1a8 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1445,6 +1445,8 @@ static void limit_periodic_timer_frequency(struct kvm_lapic *apic)
> >       }
> >  }
> >
> > +static void cancel_hv_timer(struct kvm_lapic *apic);
> > +
>
> Nitpick: cancel_hv_timer() is only 4 lines long so I'd suggest we move
> it instead of adding a forward declaration.

There are other preemption timer operations like start_hv_timer etc
around cancel_hv_timer, so it is not that suitable to move directly.

    Wanpeng
