Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF604643E1
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 01:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345596AbhLAAUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 19:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237423AbhLAAUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 19:20:51 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3A5C061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 16:17:29 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id e11so44384374ljo.13
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 16:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cF6+RZVV2V22LWQcmcFWsNufsA1AFXKO/lVuZ4XjJyE=;
        b=mS66KN9nxUH45OAP//pf+vuxHG9mHCwYAXGDGZOL/Ig/t6MqC0iH3p4hlIc7cNNpW9
         Fo6ol7Yl2fY2uH3KqQoivoLqEsFSo7YQXNR7ei54OBQVIzWOpVAUc7qUSt8/N52FjtHJ
         Q/Y60pePzSY914YYPE44LhDPkMP4lMk/4Y9qFLgKi5sPbM2xE1a4/L7qALz1Qkv/KTTV
         KEVisI2s3XlB6qk5UxdVv7IoUUj0WehXvY8fvY+z384WjessxwOKMqixmq94JzvYgUhg
         dNNTJUpufaggmqDSGCINObyxucOy/u07M2+wiK843uCrmSTLOw99396iwQQ5IYZbg+th
         C9OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cF6+RZVV2V22LWQcmcFWsNufsA1AFXKO/lVuZ4XjJyE=;
        b=fee95Hdh6ddcbFuDASFPIKrzMr20RqGA1wqTe+r8e8bHwfG2ViUrr2jNsq86VrvlUz
         AB1u6JZ6xVR3EDRpi0/txLet3A5Vlyd1cQPh2CS/5Xuu/gjFrxLXyJQKnrkY81JLZNoP
         2Tix++b8HmaGdPOBQylX48qqjeEhUFKtx0RxyQff4pEJRy1vJXPVxdy09YbS3f9ctzLB
         FGaX2vdt4oWN6oktXXp/kkd+SSYK+BZANMWzI/PsTXj2gjns4F5nEj1ASvjikOHI5cqB
         6OHP9tHuIj7Q8w9yzw82+m5L33bgp2PDZk1dkyiDbmPthitnXuuEws1MpChBysdZ41kc
         y/fg==
X-Gm-Message-State: AOAM531m2HaMODSyxxXJi11jXftTeklTiQh7Dw9LLAqvbBXrVTzf3p5U
        +7IyDrSCeMT5Gd/Hs01OXMF5NHQmGmPP1UG31sjVvw==
X-Google-Smtp-Source: ABdhPJyGDokqxt5L5TW/r7n6BCegGXXsBgDiF0fB9qsFb6LMNi8HA6qODPRtLiGI8kw//XQx9a9ACT7vxJHMC+NRUH8=
X-Received: by 2002:a2e:9e59:: with SMTP id g25mr2129651ljk.464.1638317847491;
 Tue, 30 Nov 2021 16:17:27 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-14-dmatlack@google.com>
 <YaDQSKnZ3bN501Ml@xz-m1.local> <CALzav=fVd4mLMyf6RBS=yDuN+hMM0hoa7+YHdYucRcJDjD4EfA@mail.gmail.com>
In-Reply-To: <CALzav=fVd4mLMyf6RBS=yDuN+hMM0hoa7+YHdYucRcJDjD4EfA@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 30 Nov 2021 16:17:01 -0800
Message-ID: <CALzav=ex+5y7-5a-8Vum2-eOKuKYe=RU9NvrS82H=sTwj2mqaw@mail.gmail.com>
Subject: Re: [RFC PATCH 13/15] KVM: x86/mmu: Split large pages during CLEAR_DIRTY_LOG
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021 at 4:16 PM David Matlack <dmatlack@google.com> wrote:
>
> On Fri, Nov 26, 2021 at 4:17 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Fri, Nov 19, 2021 at 11:57:57PM +0000, David Matlack wrote:
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 6768ef9c0891..4e78ef2dd352 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -1448,6 +1448,12 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> > >               gfn_t start = slot->base_gfn + gfn_offset + __ffs(mask);
> > >               gfn_t end = slot->base_gfn + gfn_offset + __fls(mask);
> > >
> > > +             /*
> > > +              * Try to proactively split any large pages down to 4KB so that
> > > +              * vCPUs don't have to take write-protection faults.
> > > +              */
> > > +             kvm_mmu_try_split_large_pages(kvm, slot, start, end, PG_LEVEL_4K);
> > > +
> > >               kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);
> > >
> > >               /* Cross two large pages? */
> >
> > Is it intended to try split every time even if we could have split it already?
> > As I remember Paolo mentioned that we can skip split if it's not the 1st
> > CLEAR_LOG on the same range, and IIUC that makes sense.
> >
> > But indeed I don't see a trivial way to know whether this is the first clear of
> > this range.  Maybe we can maintain "how many huge pages are there under current
> > kvm_mmu_page node" somehow?  Then if root sp has the counter==0, then we can
> > skip it.  Just a wild idea..
> >
> > Or maybe it's intended to try split unconditionally for some reason?  If so
> > it'll be great to mention that either in the commit message or in comments.
>
> Thanks for calling this out. Could the same be said about the existing
> code that unconditionally tries to write-protect 2M+ pages? I aimed to
> keep parity with the write-protection calls (always try to split
> before write-protecting) but I agree there might be opportunities
> available to skip altogether.
>
> By the way, looking at this code again I think I see some potential bugs:
>  - I don't think I ever free split_caches in the initially-all-set case.
>  - What happens if splitting fails the CLEAR_LOG but succeeds the
> CLEAR_LOG?

Gah, meant to say "first CLEAR_LOG" and "second CLEAR_LOG" here.

> We would end up propagating the write-protection on the 2M
> page down to the 4K page. This might cause issues if using PML.
>
> >
> > Thanks,
> >
> > --
> > Peter Xu
> >
