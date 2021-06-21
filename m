Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3CA3AF4C9
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 20:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbhFUSUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 14:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbhFUSUU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 14:20:20 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3A2C0610CE
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 11:01:51 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id o17-20020a9d76510000b02903eabfc221a9so18670343otl.0
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 11:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UobgsoS85WbWilqD+j03Ck0yLeFapzsQgkkT7VS2Rdc=;
        b=YPaQooXYhSoY7J2jKyGUCtzuq9ZJDp70SgZvpS0PDADnDfaXhdD6lR0K4CEqrLRUh5
         z71QZsDfa3pIQk4ICLiVuEK6tC6II3ALggNoz5HXI75aWHWUwbBNlhIe9e3pQ/ahiay5
         m9mJh16PNaazUo8Vv+eNgrqrkyLBgM5NQtjqz8pvx8S/FZAemy7C5kanvDGC3C7lilvm
         z4aoBGAC+syzybDCPQ7OOfC/HIeFPy/uACn2GSOUetnBQ6E32rxW/W7BucEu3lDSZxvk
         3teVGXEJbQwir7zZfLj/txB3kql6cFcAujLSkTFHIk0VGw8EAtN2MiRm9iwJMtU9zARA
         Np7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UobgsoS85WbWilqD+j03Ck0yLeFapzsQgkkT7VS2Rdc=;
        b=amgozrfiUG2xkoywYoJJC1hMyfOEmxrXKh1LZsTUpjxQgANjhf58TeRnKhynFXyLOK
         RJJaYd9VfgzWSuCHIkZyxD8E3OplGStcoavEFUTHyOSlMvQ9g5/UD1b5phdyzICDbsl2
         RKqAhqYAXH2RZUCT3Aj1OJLdvKVg6/8SsdHooVe7Uxas5sUvb1AyRUeMX5v86ms0/VLE
         EkWueRjq1Z01GCV2J11r8K1ynAUjv1Vat9mhrlkd8mFqOY4n258kOMdteW3TKX3ZH0ly
         0oFc+szDGhawDVRV3KVqflLpoMklCsq65Hli0bi6+TQAn/HaJinYac7cG8z9U7ziHwYS
         iQbw==
X-Gm-Message-State: AOAM531DJqRY3Db1gCkFUK/rVXdYLhBZmRcqpJAjPPvDfzvHRjCL3kxe
        G3GKW9ATfpyqL9k6X1+ZxxSB9DPWT3TvC9Uf401qtQ==
X-Google-Smtp-Source: ABdhPJyBqkyXivJgH658wOOGmRfckRkH7V9cWxEQnnsYG6biR7E2uQYgwK4rBFTLHIsiYGRHTEMgiu37F0MPTp+xtAI=
X-Received: by 2002:a9d:6855:: with SMTP id c21mr1679873oto.56.1624298510779;
 Mon, 21 Jun 2021 11:01:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200903141122.72908-1-mgamal@redhat.com> <CALMp9eT7yDGncP-G9v3fC=9PP3FD=uE1SBy1EPBbqkbrWSAXSg@mail.gmail.com>
 <11bb013a6beb7ccb3a5f5d5112fbccbf3eb64705.camel@redhat.com>
In-Reply-To: <11bb013a6beb7ccb3a5f5d5112fbccbf3eb64705.camel@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 21 Jun 2021 11:01:39 -0700
Message-ID: <CALMp9eTU8C4gXWfsLF-_=ymRC7Vqb0St=0BKvuvcNjBkqQBayA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: VMX: Make smaller physical guest address space
 support user-configurable
To:     Mohammed Gamal <mgamal@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 2:22 AM Mohammed Gamal <mgamal@redhat.com> wrote:
>
> On Fri, 2021-01-15 at 16:08 -0800, Jim Mattson wrote:
> > On Thu, Sep 3, 2020 at 7:12 AM Mohammed Gamal <mgamal@redhat.com>
> > wrote:
> > >
> > > This patch exposes allow_smaller_maxphyaddr to the user as a module
> > > parameter.
> > >
> > > Since smaller physical address spaces are only supported on VMX,
> > > the parameter
> > > is only exposed in the kvm_intel module.
> > > Modifications to VMX page fault and EPT violation handling will
> > > depend on whether
> > > that parameter is enabled.
> > >
> > > Also disable support by default, and let the user decide if they
> > > want to enable
> > > it.
> > >
> > > Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
> > > ---
> > >  arch/x86/kvm/vmx/vmx.c | 15 ++++++---------
> > >  arch/x86/kvm/vmx/vmx.h |  3 +++
> > >  arch/x86/kvm/x86.c     |  2 +-
> > >  3 files changed, 10 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 819c185adf09..dc778c7b5a06 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -129,6 +129,9 @@ static bool __read_mostly
> > > enable_preemption_timer = 1;
> > >  module_param_named(preemption_timer, enable_preemption_timer,
> > > bool, S_IRUGO);
> > >  #endif
> > >
> > > +extern bool __read_mostly allow_smaller_maxphyaddr;
> >
> > Since this variable is in the kvm module rather than the kvm_intel
> > module, its current setting is preserved across "rmmod kvm_intel;
> > modprobe kvm_intel." That is, if set to true, it doesn't revert to
> > false after "rmmod kvm_intel." Is that the intended behavior?
> >
>
> IIRC, this is because this setting was indeed not intended to be just
> VMX-specific, but since AMD has an issue with PTE accessed-bits being
> set by hardware and thus we can't yet enable this feature on it, it
> might make sense to move the variable to the kvm_intel module for now.

Um...

We do allow it for SVM, if NPT is not enabled. In fact, we set it
unconditionally in that case. See commit 3edd68399dc15 ("KVM: x86: Add
a capability for GUEST_MAXPHYADDR < HOST_MAXPHYADDR support").

Perhaps it should be a module parameter for SVM as well?

And, in any case, it would be nice if the parameter reverted to false
when the kvm_intel module is unloaded.

> Paolo, what do you think?
>
>
