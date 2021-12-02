Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F1B4669FF
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 19:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348397AbhLBSqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 13:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237809AbhLBSqV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 13:46:21 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E6FC06174A
        for <kvm@vger.kernel.org>; Thu,  2 Dec 2021 10:42:59 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id z6so355523plk.6
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 10:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lzmdLN0fCFoRtC4Wfk0cBBxY3xXkAKBST5W6a/Kyu4c=;
        b=ErT8VtCLAftKZhNB3ExJwkIsm/WERH6PCl6XVfa4b0KEl/cEcQkcPaTtfW3ZiMN7yw
         61wUsvYnpQ53ZlVjdVXAwSF7B033zfWVz26pjEloMJ9A1oUFWr0Hp8+Wt7bYgxUCwEH3
         V1/Vxj6fIvOb+DW9N51PkrkbME5t09LPhKF7y8zs+hCF5p/8jq6gDoIoLL6LO+8Gj2mE
         lbWrbFPaH0UPmN73KWND+loYqkp4aTUI1B55itZzTB4BUK9FqKKQo5XvdOQsjU+xG1wA
         25Xj55xLHrDcqFsZU7kX9qhHcKUy/5f3Jw6/h5iP1Gj/8SMec7JKRECiyfDABdIFmPPD
         h7oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lzmdLN0fCFoRtC4Wfk0cBBxY3xXkAKBST5W6a/Kyu4c=;
        b=eGqiJgPAl/DF+5JdyVOf3pyZI8EntHoCUIkUf9cpT1c+VtzVXiZujTFWMzI7JkcJP0
         045CjMFKxNS8e8/9uHKXRZjovSCSlmJgNGX+I8G7JX92TdM86zFW9UMynchhHtf06uDh
         +mLrctLDrw8weQNBl/IrxYBJ+0TAIghJObNEjYpp+pWXiAzuaVuHmT8wOljIHq3AqHpC
         beyGb0nmLrZ7cgc+JFq+ndJFULERASQY7BkTnI3ToHMErZ00A/gIVj7GGxTdk5swkVv2
         MhAZtHXEi+FZDi9djAQcwKVX8BWlph3ggZzZOlUL8I4MWaV2qnTzIbCNpm/th4z7aCOr
         aFXg==
X-Gm-Message-State: AOAM531JpYtdOhzmnmD/xb0faKTW/eTHwYv93uzaUyYToU/TjNXsEXc9
        XyimJZuurBwKvjSLit/x+XlSng==
X-Google-Smtp-Source: ABdhPJzLFBnF0YwWbTBrQjEoc+E+ZnLGXowaVzDAzbp2tEz9fQzojZvcbxKF0zD2puUyjw63Ol3eKQ==
X-Received: by 2002:a17:902:e890:b0:142:f3:7bf7 with SMTP id w16-20020a170902e89000b0014200f37bf7mr16877298plg.87.1638470578295;
        Thu, 02 Dec 2021 10:42:58 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c81sm462920pfb.166.2021.12.02.10.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 10:42:57 -0800 (PST)
Date:   Thu, 2 Dec 2021 18:42:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [RFC PATCH 12/15] KVM: x86/mmu: Split large pages when dirty
 logging is enabled
Message-ID: <YakTrkA6xzD5dzyN@google.com>
References: <20211119235759.1304274-13-dmatlack@google.com>
 <YaDMg3/xUSwL5+Ei@xz-m1.local>
 <CALzav=cXgCSP3RLh+gss65==B6eYXC82V3zNjv2KCNehUMQewA@mail.gmail.com>
 <YabJSdRklj3T6FWJ@google.com>
 <CALzav=cJpWPF1RzsEZcoN+ZX8kM3OquKQR-8rdTksZ6cs1R+EQ@mail.gmail.com>
 <YabeFZxWqPAuoEtZ@xz-m1.local>
 <Yae+8Oshu9sVrrvd@google.com>
 <CALzav=c9F+f=UqBjQD9sotNC72j2Gq1Fa=cdLoz2xOjRd5hypg@mail.gmail.com>
 <YagHRESjukJoS7NQ@google.com>
 <CALzav=dDEhU3uN9CofYQqCukT3QJUm+pjRz2WTr-Ss9TNVBgLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=dDEhU3uN9CofYQqCukT3QJUm+pjRz2WTr-Ss9TNVBgLg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 02, 2021, David Matlack wrote:
> On Wed, Dec 1, 2021 at 3:37 PM Sean Christopherson <seanjc@google.com> wrote:
> > It's not just the extra objects, it's the overall complexity that bothers me.
> > Complexity isn't really the correct word, it's more that as written, the logic
> > is spread over several files and is disingenuous from the perspective that the
> > split_cache is in kvm->arch, which implies persistence, but the cache are
> > completely torn down after evey memslot split.
> >
> > I suspect part of the problem is that the code is trying to plan for a future
> > where nested MMUs also support splitting large pages.  Usually I'm all for that
> > sort of thing, but in this case it creates a lot of APIs that should not exist,
> > either because the function is not needed at all, or because it's a helper buried
> > in tdp_mmu.c.  E.g. assert_split_caches_invariants() is overkill.
> >
> > That's solvable by refactoring and shuffling code, but using kvm_mmu_memory_cache
> > still feels wrong.  The caches don't fully solve the might_sleep() problem since
> > the loop still has to drop mmu_lock purely because it needs to allocate memory,
> 
> I thought dropping the lock to allocate memory was a good thing. It
> reduces the length of time we hold the RCU read lock and mmu_lock in
> read mode. Plus it avoids the retry-with-reclaim and lets us reuse the
> existing sp allocation code.

It's not a simple reuse though, e.g. it needs new logic to detect when the caches
are empty, requires a variant of tdp_mmu_iter_cond_resched(), needs its own instance
of caches and thus initialization/destruction of the caches, etc...

> Eager page splitting itself does not need to be that performant since
> it's not on the critical path of vCPU execution. But holding the MMU
> lock can negatively affect vCPU performance.
> 
> But your preference is to allocate without dropping the lock when possible. Why?

Because they're two different things.  Lock contention is already handled by
tdp_mmu_iter_cond_resched().  If mmu_lock is not contended, holding it for a long
duration is a complete non-issue.

Dropping mmu_lock means restarting the walk at the root because a different task
may have zapped/changed upper level entries.  If every allocation is dropping
mmu_lock, that adds up to a lot of extra memory accesses, especially when using
5-level paging.

Batching allocations via mmu_caches mostly works around that problem, but IMO
it's more complex overall than the retry-on-failure approach because it bleeds
core details into several locations, e.g. the split logic needs to know intimate
details of kvm_mmu_memory_cache, and we end up with two (or one complex) versions
of tdp_mmu_iter_cond_resched().

In general, I also dislike relying on magic numbers (the capacity of the cache)
for performance.  At best, we have to justify the magic number, now and in the
future.  At worst, someone will have a use case that doesn't play nice with KVM's
chosen magic number and then we have to do more tuning, e.g. see the PTE prefetch
stuff where the magic number of '8' (well, 7) ran out of gas for modern usage.
I don't actually think tuning will be problematic for this case, but I'd rather
avoid the discussion entirely if possible.

I'm not completely opposed to using kvm_mmu_memory_cache to batch allocations,
but I think we should do so if and only if batching has measurably better
performance for things we care about.  E.g. if eager splitting takes n% longer
under heavy memory pressure, but vCPUs aren't impacted, do we care?
