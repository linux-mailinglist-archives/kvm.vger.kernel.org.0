Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47A2D18065
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 21:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbfEHTVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 15:21:22 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40455 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfEHTVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 15:21:22 -0400
Received: by mail-lf1-f67.google.com with SMTP id h13so224564lfc.7
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 12:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IinFytKQ0XqvKhSVy8stzb9zoK+hMY6QgVRofywqRa4=;
        b=GbaIqS287zTqpvP7AR4WDV9ezkFTJa2mJ8IdeDljI1LoAqIcqs3KYUIFNiLQNwaadV
         dOUQtfgcszSr8/Ufm1wlBK4/w57EehacWCpNdhG+4MjrYwy/zxaDP/fkDyqYoi3g3/I/
         cZFvhBQRpucdxoEmjO5fRD4iedRYfCa7dWRkfHrmfU0HCDzq45I07fdVbsaqxlDDnRbL
         2wwttQIMCX+5i7xsuCURvKzTi8aXWzVQMcbghMQ92hVGqgdZzHBzfsAxHpvnvOQ5uplm
         WUnWP4DwBUyLOp14rzV1ytdH3zRRoNpRDzxoFM/h2eoIV7PxUErsD1Uj5u/C2elOP8zZ
         PgGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IinFytKQ0XqvKhSVy8stzb9zoK+hMY6QgVRofywqRa4=;
        b=o3H6lKouCobo6MINND/dEpEFVi5Ofnu0gWTvh4belrSShfMEr9FBCHUmaZAZXgAQpu
         PWDos2owhW5V7kgmnBOmtOMXYKXPwxodFK2ZyBboKfATFViL3Ojg0TLgFYTxwjDiMcoG
         3zTTclxZluHPwTObxuWAd/cINx9qFLP2gcvk/zZnAeOQemN8bHfcsau+CPN6F7wFO6ni
         7ALfAVM9k4vTdF4D8EA76G2Pko4EeRQV6CSUEZKSm3l3HME2vgEzjy2z/bAcB3yIkqOO
         y1Gp18nHMjwaw0GqUAaSCLzswz9mUxv2yMirVklBD9BJkWIJeiZsvbhk1s7jQ16aCh3S
         N6cw==
X-Gm-Message-State: APjAAAUbBwSuxN1tObUGeMc8n6lGfsZCiFZ6LAYo7Qy1S8pKzNkEZI7I
        qMdO7pFvCCCLklQsb/sqL/ihqxWL9bbKaNXIQeOmQg==
X-Google-Smtp-Source: APXvYqxqf0lhjktArHozBH/aLfmzCnUDu8a2kAPq8xwHm8gQem3+EKnqhzdbmSuTt6jsKwvPMYdabxql6uOpk/3EJbM=
X-Received: by 2002:ac2:483c:: with SMTP id 28mr11422681lft.93.1557343279681;
 Wed, 08 May 2019 12:21:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190502183133.258026-1-aaronlewis@google.com> <87zho37s2h.fsf@vitty.brq.redhat.com>
In-Reply-To: <87zho37s2h.fsf@vitty.brq.redhat.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 8 May 2019 12:21:08 -0700
Message-ID: <CAAAPnDHJ=ZC+CoKYkYkRsv+WJJjHJ66iN6jU72spL3+LckUpvA@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: nVMX: KVM_SET_NESTED_STATE - Tear down old EVMCS
 state before setting new state
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        Jim Mattson <jmattson@google.com>,
        Marc Orr <marcorr@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Fri, May 3, 2019 at 3:25 AM
To: Aaron Lewis
Cc: Peter Shier, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
<jmattson@google.com>, <marcorr@google.com>, <kvm@vger.kernel.org>

> Aaron Lewis <aaronlewis@google.com> writes:
>
> > Move call to nested_enable_evmcs until after free_nested() is complete.
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > Reviewed-by: Marc Orr <marcorr@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 081dea6e211a..3b39c60951ac 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -5373,9 +5373,6 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
> >       if (kvm_state->format != 0)
> >               return -EINVAL;
> >
> > -     if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
> > -             nested_enable_evmcs(vcpu, NULL);
> > -
> >       if (!nested_vmx_allowed(vcpu))
> >               return kvm_state->vmx.vmxon_pa == -1ull ? 0 : -EINVAL;
> >
> > @@ -5417,6 +5414,9 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
> >       if (kvm_state->vmx.vmxon_pa == -1ull)
> >               return 0;
> >
> > +     if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
> > +             nested_enable_evmcs(vcpu, NULL);
> > +
> >       vmx->nested.vmxon_ptr = kvm_state->vmx.vmxon_pa;
> >       ret = enter_vmx_operation(vcpu);
> >       if (ret)
>
> nested_enable_evmcs() doesn't do much, actually, in case it was
> previously enabled it doesn't do anything and in case it wasn't ordering
> with free_nested() (where you're aiming at nested_release_evmcs() I
> would guess) shouldn't matter. So could you please elaborate (better in
> the commit message) why do we need this re-ordered? My guess is that
> you'd like to perform checks for e.g. 'vmx.vmxon_pa == -1ull' before
> we actually start doing any changes but let's clarify that.
>
> Thanks!
>
> --
> Vitaly

There are two reasons for doing this:
1. We don't want to set new state if we are going to leave nesting and
exit the function (ie: vmx.vmxon_pa = -1), like you pointed out.
2. To be more future proof, we don't want to set new state before
tearing down state.  This could cause conflicts down the road.

I can add this to the commit message if there are no objections to these points.
