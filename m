Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9D03C64DF
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 22:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbhGLUXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 16:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbhGLUXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 16:23:45 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A65C0613DD
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 13:20:56 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so704312pjo.3
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 13:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8o2qA0jse1VOvFPFaD6PgYYLJfCn5VH7o/A/Icr1vKc=;
        b=KUMSx4IiytM86cklRmiMj8llxA+f2mJDuBPdHoLG55KZsSMpTqrb7Hvf5mskjMKU9q
         lmtBj9d9luDpxPeSiVnM7OJ2zc8qlWZRNu/y65Z7YWP0JS2RMtruTj2sYrZFAnpMv19v
         zTxKiceNTnB1WZGfHfgPtr/SQ9kT+qVEJ5ynC9d+mvyVy2UtB2ftBQodMz7/tnnDVrOj
         GKtYYScJWN/UIXqz8lkLFXqh17or7wCxG/9lO69tcV/Ah3I6jqVRHyRX2aACmTXvJsoG
         Y1DxBGvSd0pLNI1Hzbrt2+H7aWUM58W4/n3NgM0fiBbGAZ0qnIKB7ABO63xyGOMK2859
         xjKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8o2qA0jse1VOvFPFaD6PgYYLJfCn5VH7o/A/Icr1vKc=;
        b=l/vHBYSvOhYsCgk/zizU7DKWcVQovYy8ddWaznifNv0o30fqOvBFHgFNAFfKepwlEv
         gexM26CjbyZGh8BqzEKkvd8hQg4uSnU+cpXyEbmqdw6NwGdrqZ3WlW1Zt4MbtUZXh90X
         nE8/dHXWLXKpYhat+EiOo//iExpdLF2FnGlm18sePippGdzOXT3CZ0o72J1el4XYkGt8
         J0E3jydZBEMlGq+J87LPelzetEH4C/fr98BgNdCfoNkF+SKOe0Yv85wugJY2tx9n7OXE
         I7oua64kAbS1Rr+fc25/FSRy5v9N7yX1bnd2oiMvxz5fyXAU9eveFuD355OIhJa074Kt
         WCEQ==
X-Gm-Message-State: AOAM5322qef4b5GYSyW8kGSzVmc2yHFfGFd7A6VKAVuNodFejRAzonHR
        ba12zviAfZIxKUUVk2REP012rA==
X-Google-Smtp-Source: ABdhPJwIjq9lYuQhM3FH2gc+pxAdwAiYrs0l12AOk5fB9VWB2KLk0fYkbyVNblL9BUDJu5BmwUnnmQ==
X-Received: by 2002:a17:90a:6345:: with SMTP id v5mr15940089pjs.17.1626121255710;
        Mon, 12 Jul 2021 13:20:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a9sm16277331pfo.69.2021.07.12.13.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 13:20:55 -0700 (PDT)
Date:   Mon, 12 Jul 2021 20:20:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Ben Gardon <bgardon@google.com>, kvm <kvm@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/6] KVM: x86/mmu: Make
 walk_shadow_page_lockless_{begin,end} interoperate with the TDP MMU
Message-ID: <YOykI/ptLoyvxo2a@google.com>
References: <20210630214802.1902448-1-dmatlack@google.com>
 <20210630214802.1902448-4-dmatlack@google.com>
 <CANgfPd8Vo0qvBiGuQLrt4U6ChCUgXZ9kx3VoEjAZDjkOS5bZWQ@mail.gmail.com>
 <YOyFutKh8Ora2+V9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOyFutKh8Ora2+V9@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 12, 2021, David Matlack wrote:
> On Mon, Jul 12, 2021 at 10:02:31AM -0700, Ben Gardon wrote:
> > On Wed, Jun 30, 2021 at 2:48 PM David Matlack <dmatlack@google.com> wrote:
> > >
> > > Acquire the RCU read lock in walk_shadow_page_lockless_begin and release
> > > it in walk_shadow_page_lockless_end when the TDP MMU is enabled.  This
> > > should not introduce any functional changes but is used in the following
> > > commit to make fast_page_fault interoperate with the TDP MMU.
> > >
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > 
> > Reviewed-by: Ben Gardon <bgardon@google.com>
> > 
> > This as I understand this, we're just lifting the rcu_lock/unlock out
> > of kvm_tdp_mmu_get_walk, and then putting all the TDP MMU specific
> > stuff down a level under walk_shadow_page_lockless_begin/end and
> > get_walk.
> > 
> > Instead of moving kvm_tdp_mmu_get_walk_lockless into get_walk, it
> > could also be open-coded as:
> > 
> > walk_shadow_page_lockless_begin
> >  if (is_tdp_mmu(vcpu->arch.mmu))
> >                leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
> >  else
> >                leaf = get_walk(vcpu, addr, sptes, &root);
> > walk_shadow_page_lockless_end
> > 
> > in get_mmio_spte, since get_walk isn't used anywhere else. Then
> > walk_shadow_page_lockless_begin/end could also be moved up out of
> > get_walk instead of having to add a goto to that function.
> > I don't have a strong preference either way, but the above feels like
> > a slightly simpler refactor.
> 
> I don't have a strong preference either way as well. I'd be happy to
> switch to your suggestion in v3.

I vote for Ben's suggestion.  As is, I think it would be too easy to overlook the
TDP MMU path in get_walk() and focus only on the for-loop.
