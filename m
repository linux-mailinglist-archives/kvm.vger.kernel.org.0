Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202E54658F3
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 23:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343784AbhLAWOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 17:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343722AbhLAWOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 17:14:39 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24A6C061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 14:11:17 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id p23so32932854iod.7
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 14:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=reEy9NsiS52zGPWswsWY6KD4yxA5Be1vtjoXpbKeRXc=;
        b=rJjUz8q3jutEO1+4TbK3+wqB4YyqM3vXtmhu7hI88pewgTJ7jIaABKHYy3bZbqASsP
         164T5sVgGQdPTCnMscjV3zDosu1T2UR7E1GVPLxCjC92FOddHYf9ydKnOKRxBDW9EUqF
         NmzwPSZOWkFidABHp2D7Xeoxv5wq8gEkORreAcpVH/Xmq4z5fXbZlBv9LK76oEgdUpaI
         AN3VHf/7OgaQHw2xlzkQ/L8Rtv9ZSMLXDOw4uqZnj91h8Xn/7aAlTQ7x5uesqlpAf8lw
         Ih+X+Tr699B5rn7Rgl1TkGIB/v9uFuBvXIIRb6Tr+fhafsRJEFBf8IN5o1as1bWsJ9lt
         7I4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=reEy9NsiS52zGPWswsWY6KD4yxA5Be1vtjoXpbKeRXc=;
        b=5mUInUoV4yvg3OZyn76oauzb6rqU1fcLuMC1AuTplGPKjoK2/xldzHTBFu+CPnYTH5
         yvVJfaX4Z/e858ZUlQpepF3eaGa/L864F4aO/7eijbqyurMWe/Hnvxr3BtAdU/GnxOAN
         atc02XWpoV9n6HHQbajzP0BI4vr9+qLyhBZvQnGuarXntD6fM4R3Xlj8RBqLx/V6+7nA
         DL7EfT9fKRjS39ODis1boxYO2wN5HPDU1C5pI/AU/yMUQKwZZwtjWP/mm8ZplqoGSGIz
         x81umxdqZUXBnryvYjUk00EA8IBYi2D1nCfEoeScECS3VeI85TrukGJMlsV4Av5lmb9f
         lZ3g==
X-Gm-Message-State: AOAM533h5bPCt5RIXZUwmk7fvxnqFYsQfJ453fgHxUmOw3Wgbc+qM+GR
        y7vT2pZ4S+aql6+C6fD3N5kVfoLPPH41RyYgVQGi6A==
X-Google-Smtp-Source: ABdhPJw4lyLQ5vpp8zEvI2Qo3ffrsyXJPMcE28092jHs3P3VEjRmXiTqboLaoHHqjx3Y84MqXQtLHZ3kXBwj/xcPdlg=
X-Received: by 2002:a6b:7602:: with SMTP id g2mr12593262iom.37.1638396677295;
 Wed, 01 Dec 2021 14:11:17 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-14-dmatlack@google.com>
 <YafLdpkoTrtyoEjy@google.com> <CANgfPd_K9kBu9Fd83wx0heMiWziLthg9tXD=6GsvLsFd0GapYA@mail.gmail.com>
 <YafYOYdMqxzWiHRL@google.com>
In-Reply-To: <YafYOYdMqxzWiHRL@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 1 Dec 2021 14:11:06 -0800
Message-ID: <CANgfPd8ctCiSyAF7yrxaVXAqxuS8dWU5YWMf_rsXfqosc5qRDA@mail.gmail.com>
Subject: Re: [RFC PATCH 13/15] KVM: x86/mmu: Split large pages during CLEAR_DIRTY_LOG
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 1, 2021 at 12:17 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Dec 01, 2021, Ben Gardon wrote:
> > On Wed, Dec 1, 2021 at 11:22 AM Sean Christopherson <seanjc@google.com> wrote:
> > > I would prefer we use hugepage when possible, mostly because that's the terminology
> > > used by the kernel.  KVM is comically inconsistent, but if we make an effort to use
> > > hugepage when adding new code, hopefully someday we'll have enough inertia to commit
> > > fully to hugepage.
> >
> > In my mind "huge page" implies 2M and "large page" is generic to 2m
> > and 1g. (IDK if we settled on a name for 1G pages)
>
> What about 4m PSE pages?  :-)
>
> I'm mostly joking, but it does raise the point that trying to provide unique names
> for each size is a bit of a fools errand, especially on non-x86 architectures that
> support a broader variety of hugepage sizes.  IMO, the least ambiguous way to refer
> to hugepages is to say that everything that isn't a 4k page (or whatever PAGE_SIZE
> is on the architecture) is a hugepage, and then explicitly state the size of the
> page if it matters.
>
> > I've definitely been guilty of reinforcing this inconsistent
> > terminology. (Though it was consistent in my head, of course.) If we
> > want to pick one and use it everywhere, I'm happy to get onboard with
> > a standard terminology.
>
> I hear you on using "large page", I've had to undo a solid decade of "large page"
> terminology from my pre-Linux days.  But for better or worse, the kernel uses
> hugepage, e.g. hugetlbfs supports 1gb and 2mb pages.  I think we should follow
> the kernel, especially since we have aspirations of unifying more of KVM's MMU
> across multiple architectures.

Sounds good to me. I'll keep that in mind in future patches. I'm happy
to call them anything as long as we all use the same terms.
