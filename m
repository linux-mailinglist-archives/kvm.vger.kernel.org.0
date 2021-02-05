Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED49310142
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 01:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhBEADQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 19:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbhBEADO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 19:03:14 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAF3C061786
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 16:02:33 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id q5so4286916ilc.10
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 16:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DRlw1BEuyomdDJLxk78/bJrM7aLmjlY5EXUOw6h3EOY=;
        b=Dv6Sn9U7xzjLvTRIkoTdd5BML4cTfVQx72a8UHn/s2xVMk7qvDNjfh19Id10SHqBtU
         8dCahoSaZ5ZaGsA85JwNopJHfNVKhf0Piow0FViF8vrBPjXv69DfMuq9zRSDJhos6YJU
         h/2Z0CFkJI8rTGrN/0xe4aTM+AG25J43xjhgaqn6LyvFxdZpYCtFKCmX7bjeIrxigkpc
         Ck1Qa41WnA3GaGsK2xAKvqWJ1xVZcvZi3oZzTmCPcPEztrbW5WvyEYH1MC652eXCwO8E
         l3nw4LCBpFzLUpf9JMokXYnra/qgLxi4E+1pK2Rql8D3myuT0yH+lCjYIJ0i5ZnR3OZH
         DMjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DRlw1BEuyomdDJLxk78/bJrM7aLmjlY5EXUOw6h3EOY=;
        b=PcDoxT+IbicVsq2f2acvADOZg91GlC9d0haMgLhO4SsawDZ1Jj4WDpmbqbv/zeRev8
         9Fywb4bb8KnDGAoHXbCFBy0HL2rtjfE1B9aEbBSIvRCuI5JYoWEwpCq/zJbmGhePzbQ6
         TsPQ6uErHWWOFruNZ1hAXE73ERUEJ8MvjUsWNDbjz5x4iMVf2BRAyYG9nP+aLv9BT0MG
         GSx0BByRBAAFtbfWyJvsO7TsxLbeb4bFIa8KCDjHWKGXxLry0cq7S+3akqvXnKUHOyWY
         SAZuIJhpoHE53csfHx2B68mFgnCXvBjmM3G2A7oMbM8n8V/vL55ZkWUphmGAK5cywskG
         NEKQ==
X-Gm-Message-State: AOAM530IZfHMa1KO/0299DJAt4KE80Nk6uWwRMjYkxXkhC+kSeGTTsn/
        7lAqcm413EcxEmuFqMj4sHTfJKrqBlulPV6SNCwfTg==
X-Google-Smtp-Source: ABdhPJyniATJC0osHOzyQR4BvrN08cms2xRmjWl6h0L7mQLa01ZsxiLW10AuCIj6oveC9MtJYxo3rxGoTTbDs3yveC4=
X-Received: by 2002:a92:cbce:: with SMTP id s14mr1578328ilq.306.1612483353143;
 Thu, 04 Feb 2021 16:02:33 -0800 (PST)
MIME-Version: 1.0
References: <20210204221959.232582-1-bgardon@google.com> <20210204225144.GU6468@xz-x1>
In-Reply-To: <20210204225144.GU6468@xz-x1>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 4 Feb 2021 16:02:22 -0800
Message-ID: <CANgfPd-FK5VzDgpR8CYk+k_WxFz6FQun4Y+kPWt1qnVwWZMfXQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Optimize flushing the PML buffer
To:     Peter Xu <peterx@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 4, 2021 at 2:51 PM Peter Xu <peterx@redhat.com> wrote:
>
> Hi, Ben,
>
> On Thu, Feb 04, 2021 at 02:19:59PM -0800, Ben Gardon wrote:
> > The average time for each run demonstrated a strange bimodal distribution,
> > with clusters around 2 seconds and 2.5 seconds. This may have been a
> > result of vCPU migration between NUMA nodes.
>
> Have you thought about using numactl or similar technique to verify your idea
> (force both vcpu threads binding, and memory allocations)?
>
> From the numbers it already shows improvements indeed, but just curious since
> you raised this up. :)

Frustratingly, the test machines I have don't have numactl installed
but I've been meaning to add cpu pinning to the selftests perf tests
anyway, so maybe this is a good reason to do it.

>
> > @@ -5707,13 +5708,18 @@ static void vmx_flush_pml_buffer(struct kvm_vcpu *vcpu)
> >       else
> >               pml_idx++;
> >
> > +     memslots = kvm_vcpu_memslots(vcpu);
> > +
> >       pml_buf = page_address(vmx->pml_pg);
> >       for (; pml_idx < PML_ENTITY_NUM; pml_idx++) {
> > +             struct kvm_memory_slot *memslot;
> >               u64 gpa;
> >
> >               gpa = pml_buf[pml_idx];
> >               WARN_ON(gpa & (PAGE_SIZE - 1));
> > -             kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
> > +
> > +             memslot = __gfn_to_memslot(memslots, gpa >> PAGE_SHIFT);
> > +             mark_page_dirty_in_slot(vcpu->kvm, memslot, gpa >> PAGE_SHIFT);
>
> Since at it: make "gpa >> PAGE_SHIFT" a temp var too?

That's a good idea, I'll try it.

>
> Thanks,
>
> --
> Peter Xu
>
