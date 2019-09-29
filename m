Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBAC3C1299
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2019 02:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbfI2A6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Sep 2019 20:58:12 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:43516 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728569AbfI2A6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Sep 2019 20:58:12 -0400
Received: by mail-oi1-f196.google.com with SMTP id t84so8218665oih.10;
        Sat, 28 Sep 2019 17:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jDGwvCvb5E2eEWTa00TQPF5L0ICfXuc7lmyzsfISs80=;
        b=L3RmqzENw0ntdeFscgJnviCqaVsfSg3zrlN9EIJki+GLrPs/NTxtDWKhWVPO8kGwBY
         /ps5m50X6RcBEO3z2EzcLdeCxVbjVcg3mDJAq12at6WVu7riC4B7yBeo+bxp31+xQ0Kn
         ShHBGAb0Zhlb+cR0ST9L29oOBljku1yrrd9Zxvz5RynrVkKf7HorawOqS1A5fRz5ohAE
         SscTt2gWqSeE/qe0vGNywKOkpmhikqpL8Ni/3gj5AmtJZjPcxd5dOC8qMm/80ole1O0I
         CzIAjnossrV+bc3wXP+EaDj12m9afNVpXiEjaek+JsW9bxW8u4xvkkkuQdqkokNEz5YP
         gwEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jDGwvCvb5E2eEWTa00TQPF5L0ICfXuc7lmyzsfISs80=;
        b=Sgkm3VGfDr2Yo6yDYr7TPDeDwMu4320uBAN0TNU5EMFvfU6L5CubcsgnkrmtYSAPXx
         3dMXPsiY2gu26SJcFYYAYhUEFwHRBkuUCNE7wqfn57YNLNqBoxZ1TnpILpqfVbaVF4qx
         lIKg1DjyUUQ0h16Mn7/YB8uZDfnmwuIlsBH67vMV6eBCgPDXznP+1EnotRD1EOJM29Wk
         IPTR466BpkgVZfYe6+maQ4aC9gENwjj4OsOpAKus5sK7RVj3nplurNzm+JZMy4IxNM1f
         Y46OIcGQLfTOW4fSw5p2sX6GtF8/rDmIjKO75gzPOnHA8FjCRKqsf9mEek10k996TXRC
         pwuA==
X-Gm-Message-State: APjAAAVpV2vP0QhWGJ1remQoloGLEJWDiS2lJRwP9joZyaX1+jB2D7w+
        UHHpBehmtCql3ciuXFkWpMXX8UoRoWyHmJzcftw=
X-Google-Smtp-Source: APXvYqwGtBpVsMcdjhBaD1LhsULDB/U95PMuv5imCGqFaOnUCn1MaM44S/bfn1C3U1NYcHgadMm7Nen9KvDOvmqhNoE=
X-Received: by 2002:a05:6808:8da:: with SMTP id k26mr12805968oij.5.1569718689992;
 Sat, 28 Sep 2019 17:58:09 -0700 (PDT)
MIME-Version: 1.0
References: <1569572822-28942-1-git-send-email-wanpengli@tencent.com> <20190927144234.GD24889@linux.intel.com>
In-Reply-To: <20190927144234.GD24889@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Sun, 29 Sep 2019 08:57:55 +0800
Message-ID: <CANRm+Cyajk9LEry3KSEt=q6EHB2v7WN87xYOa0pWhVqeJxeOeQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: Don't shrink/grow vCPU halt_poll_ns if host side
 polling is disabled
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Sep 2019 at 22:42, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
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
>
> Can vcpu->halt_poll_ns be cached and used both here and in the similar
> check above?  E.g.:
>
>         unsigned int vcpu_halt_poll_ns;
>
>         vcpu_halt_poll_ns = kvm_arch_no_poll(vcpu) ? 0 : vcpu->halt_poll_ns;
>
>         if (vcpu_halt_poll_ns) {
>                 ...
>         }

This is not correct, !kvm_arch_no_poll(vcpu) && vcpu->halt_poll_ns ==
0, you will stop grow.

>
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
>
>
> Not your code,

Not the truth. :)

>but it'd be a good time to add braces to the 'if' and
> 'else'.  Per Documentation/process/coding-style.rst:
>
>   Do not unnecessarily use braces where a single statement will do.
>
>   ...
>
>   This does not apply if only one branch of a conditional statement is a single
>   statement; in the latter case use braces in both branches:
>
>         if (condition) {
>                 do_this();
>                 do_that();
>         } else {
>                 otherwise();
>         }

Will do in v2.

    Wanpeng
