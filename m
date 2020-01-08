Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB7B31349CA
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 18:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729814AbgAHRvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 12:51:07 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:41382 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbgAHRvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 12:51:06 -0500
Received: by mail-il1-f194.google.com with SMTP id f10so3370136ils.8
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 09:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2QsbHvRt75FxPOQ+y58oumWYh9J8V/b3eTBzwoHKeaw=;
        b=tCbKiMCiuZ8LXtaIeoCfHzwXywRMt3AbSS6VTt2tEf5JYciG/tYfOgXtR9oSEmpNcn
         seCLibvJQ8LvS9pksTuKyuZ6s2sOxlv78VIRNCSm6z+PlVEsuk3QUggp3NvXbkL44MEr
         l7wxL8pkmD0/RLyArPicz+HA5stqG10GrFuttb1K9Vim4Nw66mOKTu8y/SBSy0F12svd
         kQxIuHwIHGDwfOrdX4tBKv2UN/Ati7KbiHLdcCXqCvxGuuHQVqK2dpy3aO6px11sqyGL
         +KyMvRZ7iSd5z40dZeR88G6Sjw654wgiH5c5WLZWaaQYnXguBBXgrQUui6Tcx9h/6EbL
         Pp3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2QsbHvRt75FxPOQ+y58oumWYh9J8V/b3eTBzwoHKeaw=;
        b=SApp53Sdjc1VZOZSZaoe9gRaPUyyyoCtuECeqnMdsjS4FTVFIKo2QLWm6myD7nTTdx
         sgGia0KyAmfLMjasYM8Mmdh2jVjaYEWI5qPWSu6Qj+qXLmrJK95Bjl8hqTgINBcQXXYf
         4LJYcVA56qdC1kbD34uti2glQ/HoAB1Xv0qp+8xb8dEyj62KM4QDfAzkdxb22BKZzvbf
         H6T0sAL73Rv4VfvBqNoNOxBVqZIPskG1+5Rajq9L5n2EmcshtMqUA2wMLiyM1zmYRSg4
         v62GJi7LPILKpR5I4z/1Yrx/sdkNfgil0ZfijCKrfhDBwadDhdoUpQEtKXXIQ/CoH02n
         jAyA==
X-Gm-Message-State: APjAAAVEuqp4mRsbBlZ90v204rKS9VmJFJG1O3cJ1E9FDqBIZXFk9A5g
        P26ptcEVvZZJo3OdbB0iI+vWS/0JO86gnnKglzvJrw==
X-Google-Smtp-Source: APXvYqwi7A0ngVdaUFrSuc7X9bqPXpVU6UNhMOccSl7eKdCXvL4e8wU8qNHDb/KIQLv+kQp7Vcqx2OYJtBV59j4WkxI=
X-Received: by 2002:a92:3b98:: with SMTP id n24mr5220217ilh.108.1578505865855;
 Wed, 08 Jan 2020 09:51:05 -0800 (PST)
MIME-Version: 1.0
References: <20200108001859.25254-1-sean.j.christopherson@intel.com> <87d0bus1b7.fsf@vitty.brq.redhat.com>
In-Reply-To: <87d0bus1b7.fsf@vitty.brq.redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 8 Jan 2020 09:50:55 -0800
Message-ID: <CALMp9eS47Gip-yZq0tP5s8xRJ-fcbp41O7n2tBc=8Q-urZ3E6A@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Fix a benign Bitwise vs. Logical OR mixup
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 8, 2020 at 2:13 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>
> > Use a Logical OR in __is_rsvd_bits_set() to combine the two reserved bit
> > checks, which are obviously intended to be logical statements.  Switching
> > to a Logical OR is functionally a nop, but allows the compiler to better
> > optimize the checks.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 7269130ea5e2..72e845709027 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3970,7 +3970,7 @@ __is_rsvd_bits_set(struct rsvd_bits_validate *rsvd_check, u64 pte, int level)
> >  {
> >       int bit7 = (pte >> 7) & 1, low6 = pte & 0x3f;
> >
> > -     return (pte & rsvd_check->rsvd_bits_mask[bit7][level-1]) |
> > +     return (pte & rsvd_check->rsvd_bits_mask[bit7][level-1]) ||
> >               ((rsvd_check->bad_mt_xwr & (1ull << low6)) != 0);
>
> Redundant parentheses detected!

I think you mean superfluous rather than redundant.

> >  }
>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Reviewed-by: Jim Mattson <jmattson@google.com>
