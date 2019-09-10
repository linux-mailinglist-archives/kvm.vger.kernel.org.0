Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB8F7AF339
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 01:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbfIJX0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 19:26:15 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46260 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfIJX0O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 19:26:14 -0400
Received: by mail-io1-f68.google.com with SMTP id d17so19677033ios.13
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 16:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e0yMAkPqiKPir+n1j8srB24VKkYYyhVMoQLwVTHaJAc=;
        b=F5hfxo3VvPyW7ojgUmJqvhUktD7sMP9xDzj+DFoZ88d8ia3Vd0ZmXEsraxB2/vRsCD
         rctWKj9LzlBhilWvG6PmIJ9im1oIFyUbPUyDYcPdTw63QdsCa/H04s3A+xNx1c6VsLmm
         HSr99EUMroIaQsmyEMr5w8SqObju+2JsNdfMwBhPeBghAIa3njNUmfCu/iTUYe6pN8Wd
         Ub+jgmogPo917589VAJDiPusnCsLa8wyDxT2TdC9KMdLBg9QKkOjhkZiTIJxU+p9orzd
         m7urN9oO0a/joh2eQe/x5hhXecHBp3pZOwvatyrSrd4SJSZAo2fj/g2baJbukhEVO1tR
         qJFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e0yMAkPqiKPir+n1j8srB24VKkYYyhVMoQLwVTHaJAc=;
        b=Kgn89fc+g6PA8EhZdnEanHsYCiMWUhKywIudJW0AerFjg04MyYScQgMUtRR5OjnnbP
         zpbkg3qkAMXurvgU9e9LSukan2Ya9dRPDfqkgPQ4fqWoLiJRye9fHl38PtMSr2jB1skK
         cnHCZgcy2L1g0agC4JF0ZmbYbNTHiv/baaYVsyBBXG44zKoouOSp/kJ33xYXKk9wDvdE
         YmIwgiMxPUbJJ/hgyDzCXNRI9AtNibyigT9rR7SKJr5E1iBXDm7G1mgdCI+es9qAjfzo
         M+5JIVcM92eM403APSLQJA+wnjOUcYORfN6E1vfDQGHNBzemh/QAhZbym0znYGc1xB/0
         zrGg==
X-Gm-Message-State: APjAAAXlC97BsIMLDRmr/mKRjIb9Wvp5+JfeTXA7p9SsVrPjKrVbcoVi
        pFPjHB+KAj3GZS3ULYjn/zmOVsM4TQ5jJxX+Xbp1zA==
X-Google-Smtp-Source: APXvYqw/eFb+doTO+2UWGPL9XspAj/mEase+WvrKdTMQ73DT1YoCNrqr4LHf9Fap8Z/Bp82rin4Y7oQ+6tFASrg1CA0=
X-Received: by 2002:a5e:a80a:: with SMTP id c10mr1594653ioa.122.1568157973660;
 Tue, 10 Sep 2019 16:26:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190910102742.47729-1-xiaoyao.li@intel.com> <20190910102742.47729-3-xiaoyao.li@intel.com>
 <CALMp9eSbiZn6KtJ-aQuqmWZ+UBte1=hVa2V0qzLYrGqKPcP8fg@mail.gmail.com> <6ce6567e286b4432d62a730dd1697a3592c36a82.camel@intel.com>
In-Reply-To: <6ce6567e286b4432d62a730dd1697a3592c36a82.camel@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 10 Sep 2019 16:26:02 -0700
Message-ID: <CALMp9eQCwSOJDSMHkqhsYyEZjaRo0B5yt+Y7i+fsA-GZ9xfFRA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: CPUID: Put maxphyaddr updating together with
 virtual address width checking
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 10, 2019 at 3:52 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On Tue, 2019-09-10 at 10:13 -0700, Jim Mattson wrote:
> > On Tue, Sep 10, 2019 at 3:42 AM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> > >
> > > Since both of maxphyaddr updating and virtual address width checking
> > > need to query the cpuid leaf 0x80000008. We can put them together.
> > >
> > > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > ---
> > >  arch/x86/kvm/cpuid.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index 67fa44ab87af..fd0a66079001 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -118,6 +118,7 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
> > >                 best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
> > >
> > >         /*
> > > +        * Update physical address width and check virtual address width.
> > >          * The existing code assumes virtual address is 48-bit or 57-bit in
> > > the
> > >          * canonical address checks; exit if it is ever changed.
> > >          */
> > > @@ -127,7 +128,10 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
> > >
> > >                 if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
> > >                         return -EINVAL;
> > > +
> > > +               vcpu->arch.maxphyaddr = best->eax & 0xff;
> > >         }
> > > +       vcpu->arch.maxphyaddr = 36;
> >
> > Perhaps I'm missing something, but it looks to me like you always set
> > vcpu->arch.maxphyaddr to 36, regardless of what may be enumerated by
> > leaf 0x80000008.
>
> Oh, I made a stupid mistake. It should be included in the else case.
>
> >
> > Is there really much of an advantage to open-coding
> > cpuid_query_maxphyaddr() here?
>
> Indeed not so much.
> It can avoid two more kvm_find_cpuid_entry() calling that we don't handle leaf
> 0x80000008 twice in two place.

I'm inclined to leave things as they are. As your previous attempt
demonstrates, having the same logic replicated in multiple places is
prone to error. I can't imagine that this would be a
performance-sensitive path.

> > >         best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
> > >         if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> > > @@ -144,8 +148,6 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
> > >                 }
> > >         }
> > >
> > > -       /* Update physical-address width */
> > > -       vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
> > >         kvm_mmu_reset_context(vcpu);
> > >
> > >         kvm_pmu_refresh(vcpu);
> > > --
> > > 2.19.1
> > >
>
