Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923784C351A
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 19:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbiBXSzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 13:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbiBXSzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 13:55:39 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259F424FB98
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 10:55:09 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id s1so2590721plg.12
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 10:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xajxmw55etB7oRz7LjEGLyvfrY76QKuGvbP77OdweQ4=;
        b=F+cej6p92CBL7EdhHsGofg0FSEHeABn9Vz7PkpoxVML3oGy2SG7iN7zcC0WAMh2iOH
         K7gRMtZuJRkI7epx7nw5/fCcfGfB6un4GjSehi4O/6H+u1AKv3p6/4zyQM1d+6H0cxUE
         Jt/BkowW9aLZvxPvo7qlovoTlqrYhRlmIxpoAWg9yKXqfHA69unm+me97XppFF1N+w0C
         QdYa3N0adKC0ki7/eaz+Ap/mxuITzfUDjksREmbca+6sf66e076e+GYlhmXjmoQ9xFHX
         FXRCl0QQN9/MPdiCzVZcM3VXbgLYCEiJDB246CcCnhkA6OpgixlZE4D4N6u7NfYj9tH1
         Lchw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xajxmw55etB7oRz7LjEGLyvfrY76QKuGvbP77OdweQ4=;
        b=t7wjX8/LVBUoNPYSLqX2XZ39jKt8aEqtKNHun+2GXxIoMByyQlcQBuOGS+0t/h8iw3
         FRJSWH9Se7szWzCdC9Tgm7TmA2n/cKLxVgtHy28QbeTwcdvRs6pEVE6k3WNWsgw3dk17
         8XAK2hE8qDHDjO5Ohbhn5kbpRI4J9UZ9CHZin83MA2foUHfKFKOYCOFJTtlWp1YLNADn
         TmHldLPBM5TBwoBHEKuVx8SJ1/K2lFdQWvM73O6rVoVgkY1dcDh8HWm+GgRH83PjhSSD
         SNMCDpJ214HXB3Rg6h8xGisoCSunboUHz6Hix7MF6oOYzBvoJ3cIqQFLpf/7eK9Rh8e9
         L3Tg==
X-Gm-Message-State: AOAM532V9JcQQqto+vwof499tPEEJyR8JS2XClMT5thjVHxacS1cAwnq
        kGC6AwWPf3dJCJq8FSMgLTRiufWMZ9DpeHj84BeNCw==
X-Google-Smtp-Source: ABdhPJz6LEsgT935/5l+ZTthM6obizIHMpjTI5Ae3cnvpEA3P66nhGcxiKqtrqMKMX5fSS1duiHRnfVG19wg8lVHmn8=
X-Received: by 2002:a17:902:cf02:b0:14f:e0c2:1514 with SMTP id
 i2-20020a170902cf0200b0014fe0c21514mr3906011plg.90.1645728908462; Thu, 24 Feb
 2022 10:55:08 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-4-dmatlack@google.com>
 <YhBHBuObbNZLUQGR@google.com>
In-Reply-To: <YhBHBuObbNZLUQGR@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 24 Feb 2022 10:54:41 -0800
Message-ID: <CALzav=e1Dp1o6uaAQEuXwT2KRzsJpyZyqzXxVu5TebgXr0o2Mw@mail.gmail.com>
Subject: Re: [PATCH 03/23] KVM: x86/mmu: Decompose kvm_mmu_get_page() into
 separate functions
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 18, 2022 at 5:25 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Feb 03, 2022, David Matlack wrote:
> > Decompose kvm_mmu_get_page() into separate helper functions to increase
> > readability and prepare for allocating shadow pages without a vcpu
> > pointer.
> >
> > Specifically, pull the guts of kvm_mmu_get_page() into 3 helper
> > functions:
> >
> > kvm_mmu_get_existing_sp_mabye_unsync() -
>
> Heh, this ain't Java.   Just add two underscores to whatever it's primary caller
> ends up being named; that succinctly documents the relationship _and_ suggests
> that there's some "danger" in using the inner helper.
>
> >   Walks the page hash checking for any existing mmu pages that match the
> >   given gfn and role. Does not attempt to synchronize the page if it is
> >   unsync.
> >
> > kvm_mmu_get_existing_sp() -
>
> Meh.  We should really be able to distill this down to something like
> kvm_mmu_find_sp().  I'm also tempted to say we go with shadow_page instead of
> "sp" for these helpers, so long as the line lengths don't get too brutal.  KVM
> uses "sp" and "spte" in lots of places, but I suspect it would be helpful to
> KVM newbies if the core routines actually spell out shadow_page, a la
> to_shadow_page().

s/get_existing/find/ sounds good to me.

I'll play around with s/sp/shadow_page/ but I suspect it will make the
line lengths quite long. But if I also replace "maybe_unsync" with
double-underscores it might work out.

>
> >   Gets an existing page from the page hash if it exists and guarantees
> >   the page, if one is returned, is synced.  Implemented as a thin wrapper
> >   around kvm_mmu_get_existing_page_mabye_unsync. Requres access to a vcpu
> >   pointer in order to sync the page.
> >
> > kvm_mmu_create_sp()
>
> Probably prefer s/create/alloc to match existing terminology for allocating roots.
> Though looking through the series, there's going to be a lot of juggling of names.
>
> It probably makes sense to figure out what names we want to end up with and then
> work back from there.  I'll be back next week for a proper bikeshed session. :-)

kvm_mmu_create_sp() is temporary anyway. It goes away after patch 6
and we just have kvm_mmu_alloc_sp() and kvm_mmu_init_sp().

I'll see what I can do about using kvm_mmu_alloc_sp() as the temporary
name, but the next patch renames kvm_mmu_alloc_page() to
kvm_mmu_alloc_sp() so it will take some juggling for sure.
