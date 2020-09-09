Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7EF262ADD
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 10:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgIIIsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 04:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgIIIsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 04:48:09 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1C7C061573;
        Wed,  9 Sep 2020 01:48:09 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id y6so1604793oie.5;
        Wed, 09 Sep 2020 01:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vs8ZPkNQmexxc7E0Oa9UTwq9fWU6mZuoRLeLSp4xkTE=;
        b=fVHPWV0vOB+2pOhiIN6Yp01V+MKYPihZTgswReN/d50y2o79KhNs1GO3mfz/2nH2/u
         GUIocaEiboTsbIrEQun7lk/OF9Vs0ee43xKK8MeR5ULX64ml9i1gNA8UvjsT/d9be8CE
         76asbUP0F6Xw96Kz3nNZggFPNx8X4QGkpC7smWmtgOZTESBbzsgkNigt2yQpYZt4nGpi
         w1oIvuBrbxkEAph1aSzQBEBQb9sxSW4Ah6lLbFYhn/raRtEA5MeCUmjxVxKIAEZs87FD
         pPrHOdgBQUz0dE6Ko6CieSrYwfJgLSuE7MS9n2o+YC/I5XLU6SaLvmK7baCy4QMuyeZm
         Q7YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vs8ZPkNQmexxc7E0Oa9UTwq9fWU6mZuoRLeLSp4xkTE=;
        b=ZuDorft4qBf5JteIwlP2+Ougo1warNp7cv4l1d4KQctVmoSmX4vJVQDO6QOyui/mQq
         PuMaElmLGBRBnJAiiLIZ9hjHhaANhNS3XyBissi8q91/ODDyHVzt+UpsHJhtGhG2aXNB
         wHIJcHy+grvNjxwpWz8USHnQk+hrrmvV2JLiNtIRifm8ZVPKny/R/GmZwR+5AadKOPdN
         zXDyjNCJpkEiIyth02dq/0RMrMeY6guiPJAEOlFDgW+v7kPrD5HVLwsuGJCxRmU3iTc4
         vVfK+U5oL+pcWv+os381XDWvp9IF5OfrXbMdkViXk5V6vUAX+g3jvhiyn9XnsXIQ/Gaa
         Yr1Q==
X-Gm-Message-State: AOAM530yyvk1tz4hfzIiWgVc0Xr6gDcm0CEPFdRl886jZ++qTKIIn0MF
        LOrd6qdrfLozYR8FEA49LwHFYrzeEWAbZCIURNU=
X-Google-Smtp-Source: ABdhPJzrYgfb0ipw8qdNiyqp4B3fahWhApXVGyM/MF7Qj7OqTJTjOpkYJusQV9Mz3T5WFnMGBLCUkc4vYuExACcGDUs=
X-Received: by 2002:aca:2b0f:: with SMTP id i15mr1884880oik.141.1599641284973;
 Wed, 09 Sep 2020 01:48:04 -0700 (PDT)
MIME-Version: 1.0
References: <1599620119-12971-1-git-send-email-wanpengli@tencent.com> <87eenbmjo4.fsf@vitty.brq.redhat.com>
In-Reply-To: <87eenbmjo4.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 9 Sep 2020 16:47:53 +0800
Message-ID: <CANRm+CxR=U1jYMsqGEUOJ+G6ekUs3igZxzNzrepHp17QYrcEnw@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: SVM: Move svm_complete_interrupts() into svm_vcpu_run()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Paul K ." <kronenpj@kronenpj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 9 Sep 2020 at 16:36, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Moving svm_complete_interrupts() into svm_vcpu_run() which can align VMX
> > and SVM with respect to completing interrupts.
> >
> > Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Cc: Paul K. <kronenpj@kronenpj.dyndns.org>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index c61bc3b..74bcf0a 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -2938,8 +2938,6 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
> >       if (npt_enabled)
> >               vcpu->arch.cr3 = svm->vmcb->save.cr3;
> >
> > -     svm_complete_interrupts(svm);
> > -
> >       if (is_guest_mode(vcpu)) {
> >               int vmexit;
> >
> > @@ -3530,6 +3528,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
> >                    SVM_EXIT_EXCP_BASE + MC_VECTOR))
> >               svm_handle_mce(svm);
> >
> > +     svm_complete_interrupts(svm);
> > +
> >       vmcb_mark_all_clean(svm->vmcb);
> >       return exit_fastpath;
> >  }
>
> This seems to be the right thing to do, however, the amount of code
> between kvm_x86_ops.run() and kvm_x86_ops.handle_exit() is non-trivial,
> hope it won't blow up in testing...
>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> One more thing:
>
> VMX version does
>
>         vmx_complete_interrupts(vmx);
>         if (is_guest_mode(vcpu))
>                 return EXIT_FASTPATH_NONE;
>
> and on SVM we analyze is_guest_mode() inside
> svm_exit_handlers_fastpath() - should we also change that for
> conformity?

Agreed, will do in v2.

    Wanpeng
