Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E89181818F
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 23:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfEHVSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 17:18:47 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46257 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfEHVSr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 17:18:47 -0400
Received: by mail-lf1-f67.google.com with SMTP id k18so15568889lfj.13
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 14:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/D1LnRcJ8JOyrPw5vCuTsPNkPAQO2L8zFkHNfIC4apg=;
        b=dX/uRyrg9NkbQIOGVHQRUljJ2FHf679obgFa1utfNh/YxtTtQe2YO8FAbUFO2c8rKf
         dWy+qvBPV/60cjii8h65JtUrMbiOr0V+UArII5yj/lkJA9HGIgIFDyRm2CRJYXc2fg+5
         6ZwgfWyKhSnMLc4V2+CpxDg2cjNHR2JySZwEfxU+48zlxB503jwB4ZolfK2H70EbGjt8
         7lwYg4pPKJKmQxarLZaVr0LbXSTcuLsrskqqftrP/qzjt3PGLjhqnBkBDs8Rjf7Og1Jt
         NpzOXsT5Ac2WfJoxH86kb+gfLZj9c2R65YpwI9JXyFv8GCo+Wh+CSK+8ITuCDsiZ7Lle
         BxAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/D1LnRcJ8JOyrPw5vCuTsPNkPAQO2L8zFkHNfIC4apg=;
        b=Sksme1zAd1yk1WrqeyrVpsImtCRNlB1LEgysPbnBeo+uadTETGOSYXsKTB/AePhBWO
         DPJYF5EE3hBc4MecC5AzDZF1Hpd7Akc4mWt+0vgLVMnoKELDL0GALpB38+IfL/UPaR6t
         QYMKVheYVOF2EQ/5yAojQpUQhTyhzLXQNNa9Zhy4bNvMD0tGEdWVlxuftu8W2McdmbXD
         kRv2d7WUmGdgovUJEO8F+bX+Azu1DdXqOfmvFuTOoObm9jNp5x5nhmwt8KlNP04zzNGQ
         MbGf8LD5CVlp9mJmpqKkrr5rhbNgXoYQj+WPwVaMVhzQWQRwHJaClAekEgMlSbkBusqn
         5kmw==
X-Gm-Message-State: APjAAAVeeVuOlh72lq6Dp0v/VWJUEhbQgQUIPyxvUvdHCeyYRN9YWLGh
        zNzF/gW2JnDCE/VGanvUvU0W4BlElsDh7RgeDfA1/A==
X-Google-Smtp-Source: APXvYqw3PBiPkccRhR2dAkYoeeeqJj52uaQqpTXPj/BvO8mMhsVz9d7j2gUllcz2WPG2fZeiM/C1jqYnFOILfEZeZzc=
X-Received: by 2002:ac2:4a86:: with SMTP id l6mr145692lfp.51.1557350324396;
 Wed, 08 May 2019 14:18:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190502183133.258026-1-aaronlewis@google.com>
 <87zho37s2h.fsf@vitty.brq.redhat.com> <CAAAPnDHJ=ZC+CoKYkYkRsv+WJJjHJ66iN6jU72spL3+LckUpvA@mail.gmail.com>
 <878svgsovg.fsf@vitty.brq.redhat.com>
In-Reply-To: <878svgsovg.fsf@vitty.brq.redhat.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 8 May 2019 14:18:33 -0700
Message-ID: <CAAAPnDFsixYb2R-0uN-_DCEb4U-MEo0Pd1hmFzpqqAojc9GxXA@mail.gmail.com>
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
Date: Wed, May 8, 2019 at 12:55 PM
To: Aaron Lewis
Cc: Peter Shier, Paolo Bonzini, <rkrcmar@redhat.com>, Jim Mattson,
Marc Orr, <kvm@vger.kernel.org>

> Aaron Lewis <aaronlewis@google.com> writes:
>
> > From: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Date: Fri, May 3, 2019 at 3:25 AM
> > To: Aaron Lewis
> > Cc: Peter Shier, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
> > <jmattson@google.com>, <marcorr@google.com>, <kvm@vger.kernel.org>
> >
> >> Aaron Lewis <aaronlewis@google.com> writes:
> >>
> >> > Move call to nested_enable_evmcs until after free_nested() is complete.
> >> >
> >> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> >> > Reviewed-by: Marc Orr <marcorr@google.com>
> >> > Reviewed-by: Peter Shier <pshier@google.com>
> >> > ---
> >> >  arch/x86/kvm/vmx/nested.c | 6 +++---
> >> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >> >
> >> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> >> > index 081dea6e211a..3b39c60951ac 100644
> >> > --- a/arch/x86/kvm/vmx/nested.c
> >> > +++ b/arch/x86/kvm/vmx/nested.c
> >> > @@ -5373,9 +5373,6 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
> >> >       if (kvm_state->format != 0)
> >> >               return -EINVAL;
> >> >
> >> > -     if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
> >> > -             nested_enable_evmcs(vcpu, NULL);
> >> > -
> >> >       if (!nested_vmx_allowed(vcpu))
> >> >               return kvm_state->vmx.vmxon_pa == -1ull ? 0 : -EINVAL;
> >> >
> >> > @@ -5417,6 +5414,9 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
> >> >       if (kvm_state->vmx.vmxon_pa == -1ull)
> >> >               return 0;
> >> >
> >> > +     if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
> >> > +             nested_enable_evmcs(vcpu, NULL);
> >> > +
> >> >       vmx->nested.vmxon_ptr = kvm_state->vmx.vmxon_pa;
> >> >       ret = enter_vmx_operation(vcpu);
> >> >       if (ret)
> >>
> >> nested_enable_evmcs() doesn't do much, actually, in case it was
> >> previously enabled it doesn't do anything and in case it wasn't ordering
> >> with free_nested() (where you're aiming at nested_release_evmcs() I
> >> would guess) shouldn't matter. So could you please elaborate (better in
> >> the commit message) why do we need this re-ordered? My guess is that
> >> you'd like to perform checks for e.g. 'vmx.vmxon_pa == -1ull' before
> >> we actually start doing any changes but let's clarify that.
> >>
> >> Thanks!
> >>
> >> --
> >> Vitaly
> >
> > There are two reasons for doing this:
> > 1. We don't want to set new state if we are going to leave nesting and
> > exit the function (ie: vmx.vmxon_pa = -1), like you pointed out.
> > 2. To be more future proof, we don't want to set new state before
> > tearing down state.  This could cause conflicts down the road.
> >
> > I can add this to the commit message if there are no objections to
> > these points.
>
> Sounds good to me, please do. Thanks!
>
> --
> Vitaly

Here is the updated patch:


Move call to nested_enable_evmcs until after free_nested() is
complete.  There are two reasons for doing this:
1. We don't want to set new state if we are going to leave nesting and
exit the function (ie: vmx.vmxon_pa = -1).
2. To be more future proof, we don't want to set new state before
tearing down state.  This could cause conflicts down the road.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/vmx/nested.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fe5814df5149..6ecc301df874 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5373,9 +5373,6 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
  if (kvm_state->format != 0)
  return -EINVAL;

- if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
- nested_enable_evmcs(vcpu, NULL);
-
  if (!nested_vmx_allowed(vcpu))
  return kvm_state->vmx.vmxon_pa == -1ull ? 0 : -EINVAL;

@@ -5417,6 +5414,9 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
  if (kvm_state->vmx.vmxon_pa == -1ull)
  return 0;

+ if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
+ nested_enable_evmcs(vcpu, NULL);
+
  vmx->nested.vmxon_ptr = kvm_state->vmx.vmxon_pa;
  ret = enter_vmx_operation(vcpu);
  if (ret)
