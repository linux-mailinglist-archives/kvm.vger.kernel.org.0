Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621BE788DF7
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 19:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbjHYRr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 13:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236411AbjHYRrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 13:47:16 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE592128
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 10:47:14 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-583c49018c6so17046187b3.0
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 10:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692985633; x=1693590433;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uw0yDTgzovAxkPYn3WJ2t3od+3d1Ix16IVIhY0kAlMs=;
        b=e3j/cJiXyUn71kV3UwAPWDqSmPpJ269QG6XYQN3HUW1QkP5kVH/sEGBgPCfDtUr5Ye
         UB+7UdcuhW5/AfvnBkchrU/F6jL0lU1yiIWdp33ScKYLupnORjTSC5ED0ayNwRNVEMON
         4V0/f8WZdnTLCqSp5vVLEXsWlf7K8S6cFR2wAIvMsUo+4KpwYXniQUBn8JBZiuhe8PFL
         9TetNML6maCOHVHnOuF4rIZSJurYdf395TTdWLGXeB4KS7WmhZXCqh/u0QjLfl5xkacn
         TyeEU/NJv0ZFDBYlgVX3c7iEp9yRqe69KDWWrLjXO+wbKgBZ7wFQgPf9j8VF55zRWnuu
         E39Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692985633; x=1693590433;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uw0yDTgzovAxkPYn3WJ2t3od+3d1Ix16IVIhY0kAlMs=;
        b=bFXypJl4VEh0VQddm5fQotjYXvqUI628ae2khXZq/wh3fp138jzb8hyEtZ3QCGoCjt
         x28cNo9tVA6yaMjFt570JaAXiwR1FpDN8ELlq2GwktFImRSLeYLP/W6jRFH6exldt0Ci
         dNU1b3kxtjQpdexktqvCxa1O0AFlE585zrRZ6HYl8G9fOfOJLk+izkU0O7hWHuqpgS70
         JvvkZRTnr8602MFFKO+XgcLHrkIsxQzgke9RKGSzp4jAmiVOwKiD36Iul97Q+1LyFxwV
         cAizxdQqPpEZxdBptF4ArKiQTX3Op3CWy8HtqtdF2JKLvRB5uP4K8DWc3w/Co63PBhVg
         zvaQ==
X-Gm-Message-State: AOJu0YyOgfyRSNIJVCHkUOEKMyBvrCjoJrzNjAMerS/NzPv4mtZ43XMz
        5keKezd9dDT7+Tq60y/pqwv8yhrbr2s=
X-Google-Smtp-Source: AGHT+IGproihkQ0gP6PC+Qs58DPiypBxvQRceV5okoICjntKZxJFwLasVv1y+9oFYevDFkkc84nj+Ymhuq0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b615:0:b0:586:5d03:67d4 with SMTP id
 u21-20020a81b615000000b005865d0367d4mr540998ywh.7.1692985633702; Fri, 25 Aug
 2023 10:47:13 -0700 (PDT)
Date:   Fri, 25 Aug 2023 10:47:12 -0700
In-Reply-To: <20230718234512.1690985-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com>
Message-ID: <ZOjpIL0SFH+E3Dj4@google.com>
Subject: Re: [RFC PATCH v11 00/29]  KVM: guest_memfd() and per-page attributes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jorg Rodel <jroedel@suse.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 18, 2023, Sean Christopherson wrote:
> This is the next iteration of implementing fd-based (instead of vma-based)
> memory for KVM guests.  If you want the full background of why we are doing
> this, please go read the v10 cover letter[1].
> 
> The biggest change from v10 is to implement the backing storage in KVM
> itself, and expose it via a KVM ioctl() instead of a "generic" sycall.
> See link[2] for details on why we pivoted to a KVM-specific approach.
> 
> Key word is "biggest".  Relative to v10, there are many big changes.
> Highlights below (I can't remember everything that got changed at
> this point).
> 
> Tagged RFC as there are a lot of empty changelogs, and a lot of missing
> documentation.  And ideally, we'll have even more tests before merging.
> There are also several gaps/opens (to be discussed in tomorrow's PUCK).
> 
> v11:
>  - Test private<=>shared conversions *without* doing fallocate()
>  - PUNCH_HOLE all memory between iterations of the conversion test so that
>    KVM doesn't retain pages in the guest_memfd
>  - Rename hugepage control to be a very generic ALLOW_HUGEPAGE, instead of
>    giving it a THP or PMD specific name.
>  - Fold in fixes from a lot of people (thank you!)
>  - Zap SPTEs *before* updating attributes to ensure no weirdness, e.g. if
>    KVM handles a page fault and looks at inconsistent attributes
>  - Refactor MMU interaction with attributes updates to reuse much of KVM's
>    framework for mmu_notifiers.
> 
> [1] https://lore.kernel.org/all/20221202061347.1070246-1-chao.p.peng@linux.intel.com
> [2] https://lore.kernel.org/all/ZEM5Zq8oo+xnApW9@google.com

Trimmed the Cc substantially to discuss what needs to be done (within our control)
to have a chance of landing this "soon".

We've chipped away at the todo list a bit, but there are still several non-trivial
things that need to get addressed before we can merge guest_memfd().  If we move
*really* fast, e.g. get everything address in less than 3 weeks, we have an outside
chance at hitting 6.7.  But honestly, I think it 6.7 is extremely unlikely.

For 6.8, we'll be in good shape if we can get a non-RFC posted in the next ~6
weeks, i.e. by end of September, though obviously the sooner the better.  If we slip
much beyond that, 6.8 is going to be tough due to people disappearing for year-end
stuff and holidays, i.e. we won't have enough time to address feedback _and_ get a
another round of reviews.

Speaking purely from a personal perspective, I really, really want to hit 6.8 so
that this doesn't drag into 2024.

Loosely ordered by size and urgency (bigger, more urgent stuff first).  Please
holler if I've missed something (taking notes is my Achilles heel).


Filemap vs. xarray
------------------
This is the main item that needs attention.  I don't want to merge guest_memfd()
without doing this comparison, as not using filemap means we don't need AS_UNMOVABLE.
Arguably we could merge a filemap implementation without AS_UNMOVABLE and just eat
the suboptimal behavior, but not waiting a little while longer to do everything we
can to get this right the first time seems ridiculous after we've been working on
this for literally years.

Paolo was going to work on an axarray implementation, but AFAIK he hasn't done
anything yet.  We (Google) don't have anyone available to work on an xarray
implementation for several weeks (at best), so if anyone has the bandwidth and
desire to take stab at an xarray implementation, please speak up.


kvm_gmem_error_page()
---------------------
As pointed out by Vishal[*], guest_memfd()'s error/poison handling is garbage.
KVM needs to unmap, check for poison, and probably also restrict the allowed
mapping size if a partial page is poisoned.

This item also needs actually testing, e.g. via error injection.  Writing a
proper selftest may not be feasible, but at a bare minimum, someone needs to
manually verify an error on a guest_memfd() can get routed all the way into the
guest, e.g. as an #MC on x86.

This needs an owner.  I'm guessing 2-3 weeks?  Though I tend to be overly
optimistic when sizing these things...

[*] https://lore.kernel.org/all/CAGtprH9a2jX-hdww9GPuMrO9noNeXkoqE8oejtVn2vD0AZa3zA@mail.gmail.com


Documentation
-------------
Obviously a must have.  AFAIK, no one is "officially" signed up to work on this.
I honestly haven't looked at the document in recent versions, so I have no idea
how much effort is required.


Fully anonymous inode vs. proper filesystem
-------------------------------------------
This is another one that needs to get sorted out before merging, but it should
be a much smaller task (a day or two).  I will get to this in a few weeks unless
someone beats me to the punch.


KVM_CAP_GUEST_MEMFD
-------------------
New ioctl() needs a new cap.  Trivial, just capturing here so I don't forget.


Changelogs
----------
This one is on me, though I will probably procrastinate until all the other todo
items are close to being finished.


Tests
-----
I would really like to have a test that verifies KVM actually installs hugepages,
but I'm ok merging without such a test, mainly because I suspect it will be
annoyingly difficult to end up with a test that isn't flaky.

Beyond that, and the aforementioned memory poisoining, IMO, we have enough test
coverage.  I am always open to more tests, but I don't think adding more coverage
is a must have for merging.


.release_folio and .invalidate_folio versus .evict_inode
--------------------------------------------------------
I think we're good on this one?  IIRC, without a need to "clean" physical memory
(SNP and TDX), we don't need to do anything special.

Mike or Ackerley, am I forgetting anything?


NUMA
----
I am completely comfortable doing nothing as part of the initial merge.  We have
line of sight to supporting NUMA policies in the form of fbind(), and I would be
quite surprised if we get much pushback on implementing fbind().


RSS stats
---------
My preference is to not do anything in the initial implementation, and defer any
changes until later.  IMO, while odd, not capturing guest_memfd() in RSS is
acceptable as there are no virtual mappings to account.  I completely agree that
we would ideally surface the memory usage to userspace in some way, but I don't
think it's so critical that it needs to happen as part of the initial merge.


Intrahost migration support
---------------------------
Ackerley's RFC[*] is enough for me to have confidence that we can support
intrahost migration without having to rework the ABI.  Please holler if you
disagree.

[*] https://lkml.kernel.org/r/cover.1691446946.git.ackerleytng%40google.com

