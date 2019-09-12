Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8A08B12A7
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 18:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732781AbfILQUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 12:20:15 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45452 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfILQUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 12:20:15 -0400
Received: by mail-io1-f66.google.com with SMTP id f12so56063374iog.12
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 09:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RhA03o75OD+ZBFEfqmjtglWrooCHou7fbqnvxWxZk30=;
        b=mMbKQJiQ8dHwiBHDUMZjEOtXWB+eG6G3k5OhltVLFE3NeUONbujHOlTYC9H+xlzRmb
         ZiuOllEOLE8EqHWvTbcAWitUK4ulO+qlQiZ0htati68Ioj90GRTmIL+402eQdfJbIlQQ
         frp8KRMon+iiuSVOyvlX91bjMR2pJyJ5YX74FIY+dismzjklDKJZO4NctWV/JHsn0o8+
         0FxAlxm+s0Cn6gEcfC3zTdxtK9+gRgQL+6Wm7ZW1vRuFzH5cSiejaflP7J5TZzuX/tmE
         X5/t2LU4tLYCOxubUz68dAl/XyV1EYCekSLyyEPbkVBzYuXzU+dygA4xEm0URPuvILmq
         mGAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RhA03o75OD+ZBFEfqmjtglWrooCHou7fbqnvxWxZk30=;
        b=rDiLWkqRwAyk1TTMLO9GaW473ZjfD+z5o3/pe3actJ7N942JybDzKrvUNs1+NRNfcp
         e9Rm530AZ9XRCGa2JIXyUiDqq4piRe25eh+jHPbkZFSd76mmiHm2h8wsL9M4RJBPIWT1
         f/Enu7M+1vnAz8UqtArPbiGFUo+xQj+1Y/53iCyixuC2TfYWoTW13Tvssq5Iqb9vRT1R
         pzv+Ek8HoJxtWASSg8orEFsIJuAAM4StbkA77UXGkPK1O88sF6aBcXbruOCE4+pJBZE0
         LkikOUGOt/teMVX5mqVHC8wX4mCcuQlG+d9XwJo2sRSmlqeIyo9QPdWK9q1HV4lOQ8Ce
         cwZg==
X-Gm-Message-State: APjAAAUXs1s0jH65moGk9RtDeoQ0FJ5j3DChILLaIjqq07ie+IKlJiAH
        FWfXrZxn7feINKgYPz6m2anjhA/s1VWpb9zDJvuhUQ==
X-Google-Smtp-Source: APXvYqxxD5WDm9AxJung/OlkcbytWmz48mDXQimqe+u4lr4WVjEYT/XlCPNA4ODUfJ9alZT0pOkqo0apT8rL/xelsS0=
X-Received: by 2002:a6b:1606:: with SMTP id 6mr471368iow.108.1568305213072;
 Thu, 12 Sep 2019 09:20:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190912041817.23984-1-huangfq.daxian@gmail.com> <87tv9hew2k.fsf@vitty.brq.redhat.com>
In-Reply-To: <87tv9hew2k.fsf@vitty.brq.redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 12 Sep 2019 09:20:01 -0700
Message-ID: <CALMp9eRu=C+MQmRpKh5WtyqBKq=ja8Wj7fD5NTFhZi9EZd+84w@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: work around leak of uninitialized stack contents
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 12, 2019 at 1:51 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Fuqian Huang <huangfq.daxian@gmail.com> writes:
>
> > Emulation of VMPTRST can incorrectly inject a page fault
> > when passed an operand that points to an MMIO address.
> > The page fault will use uninitialized kernel stack memory
> > as the CR2 and error code.
> >
> > The right behavior would be to abort the VM with a KVM_EXIT_INTERNAL_ERROR
> > exit to userspace;
>
> Hm, why so? KVM_EXIT_INTERNAL_ERROR is basically an error in KVM, this
> is not a proper reaction to a userspace-induced condition (or ever).

This *is* an error in KVM. KVM should properly emulate the quadword
store to the emulated device. Doing anything else is just wrong.

KVM_INTERNAL_ERROR is basically a cop-out for things that are hard.

> I also looked at VMPTRST's description in Intel's manual and I can't
> find and explicit limitation like "this must be normal memory". We're
> just supposed to inject #PF "If a page fault occurs in accessing the
> memory destination operand."
>
> In case it seems to be too cumbersome to handle VMPTRST to MMIO and we
> think that nobody should be doing that I'd rather prefer injecting #GP.

That is not the architected behavior at all. Now you're just making things up!

> Please tell me what I'm missing :-)
>
> >  however, it is not an easy fix, so for now just ensure
> > that the error code and CR2 are zero.
> >
> > Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
> > ---
> >  arch/x86/kvm/x86.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 290c3c3efb87..7f442d710858 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5312,6 +5312,7 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
> >       /* kvm_write_guest_virt_system can pull in tons of pages. */
> >       vcpu->arch.l1tf_flush_l1d = true;
> >
> > +     memset(exception, 0, sizeof(*exception));
> >       return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
> >                                          PFERR_WRITE_MASK, exception);
> >  }
>
> --
> Vitaly
