Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B44B587496
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 01:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbiHAX41 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 19:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbiHAX40 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 19:56:26 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32E323BEE
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 16:56:25 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y141so12034309pfb.7
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 16:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=V6WHXhqn/X7TOSFwMnLNQi+h+Hy5x1whbaIhx6t4ylA=;
        b=BgBIzg4JP8/ok61pyrEft6oWj93sbOVdFLgVXVuw9oQ2q5syTHiDA24VvqNVrdjjHH
         fl30hyWq06a/rXTCwa7yxPzthmUW2VPtMmrdnRyQQv99LbwYLRSe8yX3Fvf/RL68M6L8
         o+lN/ZBSYU2f8mI++MiP4lLkoi6icgltVNCBLr8rl/ziqIQlYTAg/1ous5K0sA5ezQVH
         HklEyuMDyjPZLhT4375l00tVblp3mpic9XlPHbQhfXiWuzDgX/uEpDrX4FhqlDxVW74Q
         bWrC/lB4NpUk4jw9GFHHqN4XxtcHMMGOWpa2jn3t1nFteuZ3vRllmf1H1npFd2O72M1z
         CWcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=V6WHXhqn/X7TOSFwMnLNQi+h+Hy5x1whbaIhx6t4ylA=;
        b=rZtOpX8hNP9N88dEoYI0cC7HqzEXYZBsn0lwhvYea5uU5Efg5R7RrswJ8p0vNOTkee
         UydTFPW0mxLewMNdWkry/ycX7I6WgtEPPiK6c4idO8bedBl1I0JcQpCQiR8YvTpv4smi
         VBIzvjTyAK6NF+b+d+kMUbEBwrmRXkwucLwMBfbl+nqZnZjQWORv3itR/2iLbskk1Kry
         1TD0q74ScnSvXdPurAxUjEkYlOr576ocqPorWpsEOUTp+JgjIIj9g+biLxx8k7XddWBJ
         m/1Z9H+NufUJxe8ZwC/xfiLWHD3EoDVgI28v+1+7E0sNpKVMAJ7kIqYfB/xFZgjiiEYb
         Lr1g==
X-Gm-Message-State: ACgBeo0sfWdlmubtpuRnU+hWzLjgSr6kryiuzMVDEtx7WdehGhkw5TXV
        KAzvvUNw9qVZWqC5BuNMz/zsyw==
X-Google-Smtp-Source: AA6agR5XUzOeKTPZyYhsV3rIAm+jdWFRwn8yeLm84iL1sNXwnBHCYxfznITzpGcKQJfTNL0p9Ub/yg==
X-Received: by 2002:a63:6d1:0:b0:41c:45d:7d49 with SMTP id 200-20020a6306d1000000b0041c045d7d49mr6424986pgg.437.1659398185291;
        Mon, 01 Aug 2022 16:56:25 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 18-20020a621812000000b005251fff13dfsm9230601pfy.155.2022.08.01.16.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 16:56:24 -0700 (PDT)
Date:   Mon, 1 Aug 2022 23:56:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Vipin Sharma <vipinsh@google.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Make page tables for eager page splitting
 NUMA aware
Message-ID: <YuhoJUoPBOu5eMz8@google.com>
References: <20220801151928.270380-1-vipinsh@google.com>
 <YuhPT2drgqL+osLl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuhPT2drgqL+osLl@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 01, 2022, David Matlack wrote:
> On Mon, Aug 01, 2022 at 08:19:28AM -0700, Vipin Sharma wrote:
> That being said, KVM currently has a gap where a guest doing a lot of
> remote memory accesses when touching memory for the first time will
> cause KVM to allocate the TDP page tables on the arguably wrong node.

Userspace can solve this by setting the NUMA policy on a VMA or shared-object
basis.  E.g. create dedicated memslots for each NUMA node, then bind each of the
backing stores to the appropriate host node.

If there is a gap, e.g. a backing store we want to use doesn't properly support
mempolicy for shared mappings, then we should enhance the backing store.

> > We can improve TDP MMU eager page splitting by making
> > tdp_mmu_alloc_sp_for_split() NUMA-aware. Specifically, when splitting a
> > huge page, allocate the new lower level page tables on the same node as the
> > huge page.
> > 
> > __get_free_page() is replaced by alloc_page_nodes(). This introduces two
> > functional changes.
> > 
> >   1. __get_free_page() removes gfp flag __GFP_HIGHMEM via call to
> >   __get_free_pages(). This should not be an issue  as __GFP_HIGHMEM flag is
> >   not passed in tdp_mmu_alloc_sp_for_split() anyway.
> > 
> >   2. __get_free_page() calls alloc_pages() and use thread's mempolicy for
> >   the NUMA node allocation. From this commit, thread's mempolicy will not
> >   be used and first preference will be to allocate on the node where huge
> >   page was present.
> 
> It would be worth noting that userspace could change the mempolicy of
> the thread doing eager splitting to prefer allocating from the target
> NUMA node, as an alternative approach.
> 
> I don't prefer the alternative though since it bleeds details from KVM
> into userspace, such as the fact that enabling dirty logging does eager
> page splitting, which allocates page tables. 

As above, if userspace is cares about vNUMA, then it already needs to be aware of
some of KVM/kernel details.  Separate memslots aren't strictly necessary, e.g.
userspace could stitch together contiguous VMAs to create a single mega-memslot,
but that seems like it'd be more work than just creating separate memslots.

And because eager page splitting for dirty logging runs with mmu_lock held for,
userspace might also benefit from per-node memslots as it can do the splitting on
multiple tasks/CPUs.

Regardless of what we do, the behavior needs to be document, i.e. KVM details will
bleed into userspace.  E.g. if KVM is overriding the per-task NUMA policy, then
that should be documented.

> It's also unnecessary since KVM can infer an appropriate NUMA placement
> without the help of userspace, and I can't think of a reason for userspace to
> prefer a different policy.

I can't think of a reason why userspace would want to have a different policy for
the task that's enabling dirty logging, but I also can't think of a reason why
KVM should go out of its way to ignore that policy.

IMO this is a "bug" in dirty_log_perf_test, though it's probably a good idea to
document how to effectively configure vNUMA-aware memslots.
