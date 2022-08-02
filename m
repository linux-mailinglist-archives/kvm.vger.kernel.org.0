Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FD658804A
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiHBQbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiHBQbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:31:43 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BD217E16
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:31:42 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id d7so9728734pgc.13
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 09:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=tZSf07sg0fk/9dgcqNB6Ry/A8jgISpdwbk+jhT7aWZ8=;
        b=RB37ZYHOrAQN2jfUAsUDBGcG5RLo8Yzn0dRBJvLM4XmpEQz1QhZBtA6kcNEQpNLm9L
         YOj3HfN+rEiyPkMSt9Cy2pdC6enxOgXO8YTlaWEqliXWbciVKD7diUxzJCR+wCZsGqnL
         +4Sy7qJaUKBx5zbhO5T+5hzuePieKWbwU1c0NekYSDDEvLAuVCsvCJYOc+ioyQxU7X0/
         bnkYd/ObTavMHAy1YFdTPaEIOcMr6fAGMtu4G6Lfgfy2YuTx7ju4btLxqTx6jLjEm6Uo
         tpuRn/DKQKaOaXhiIr7xRBbTFyvHjeTpsFnVL/bPeZHfG+7B5Ch68+lFf8gLmMn9tI4K
         ZSAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=tZSf07sg0fk/9dgcqNB6Ry/A8jgISpdwbk+jhT7aWZ8=;
        b=tAZH/3P/1U1Y111MRJsGmLaccDeAN0luvtJpkqIupLU7OF7vCWkkbFtP9Tow2hah6q
         np5ercLlcaTPM03j6PN8+LCVOnb8mHFGwYR2YlfzjT1UVALe43q06kAPwP4stWfHJBrW
         FGmAzrwI0TpZFC4Rhanq1cmT26OqCDP5gwH6ebpMoF85N3B0rgzgaq/F1DR4xtxPWFrt
         ZO8oSDbP+a5gYLcthpzuhh1ctTF/TOQsOAZvN31DFGm6Nsz1CLScaphqmoIEJbcwve2F
         RdV+QZa9UFef2U7FugKJvU0Vjph6Ntm4sNEC7vkLHR0KyUOlHSHl9FYNVkiI0dRlYEFN
         CBJA==
X-Gm-Message-State: AJIora8E5EzX+msN7cn1QnlmRY33GnMZVtWx9Tadr6jqdLyetXiJb+FG
        hV1RTlv5IkX8IyZRbEfhSVejTQ==
X-Google-Smtp-Source: AGRyM1vtZ/s/QFATV2Lm1/TA0aK3QErLVxPsa4bq3CKtaWgQ3jjed101jiS2kerJCYN2jmGEqBKYFA==
X-Received: by 2002:a05:6a00:114c:b0:528:2c7a:630e with SMTP id b12-20020a056a00114c00b005282c7a630emr21594186pfm.86.1659457901419;
        Tue, 02 Aug 2022 09:31:41 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id k2-20020aa79722000000b005289bfcee91sm11035213pfg.59.2022.08.02.09.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 09:31:40 -0700 (PDT)
Date:   Tue, 2 Aug 2022 09:31:35 -0700
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vipin Sharma <vipinsh@google.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Make page tables for eager page splitting
 NUMA aware
Message-ID: <YulRZ+uXFOE1y2dj@google.com>
References: <20220801151928.270380-1-vipinsh@google.com>
 <YuhPT2drgqL+osLl@google.com>
 <YuhoJUoPBOu5eMz8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuhoJUoPBOu5eMz8@google.com>
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

On Mon, Aug 01, 2022 at 11:56:21PM +0000, Sean Christopherson wrote:
> On Mon, Aug 01, 2022, David Matlack wrote:
> > On Mon, Aug 01, 2022 at 08:19:28AM -0700, Vipin Sharma wrote:
> > That being said, KVM currently has a gap where a guest doing a lot of
> > remote memory accesses when touching memory for the first time will
> > cause KVM to allocate the TDP page tables on the arguably wrong node.
> 
> Userspace can solve this by setting the NUMA policy on a VMA or shared-object
> basis.  E.g. create dedicated memslots for each NUMA node, then bind each of the
> backing stores to the appropriate host node.
> 
> If there is a gap, e.g. a backing store we want to use doesn't properly support
> mempolicy for shared mappings, then we should enhance the backing store.

Just to clarify: this patch, and my comment here, is about the NUMA
locality of KVM's page tables, not guest memory.

KVM allocates all page tables through __get_free_page() which uses the
current task's mempolicy. This means the only way for userspace to
control the page table NUMA locality is to set mempolicies on the
threads on which KVM will allocate page tables (vCPUs and any thread
doing eager page splitting, i.e. enable dirty logging or
KVM_CLEAR_DIRTY_LOG).

The ideal setup from a NUMA locality perspective would be that page
tables are always on the local node, but that would require KVM maintain
multiple copies of page tables (at minimum one per physical NUMA node),
which is extra memory and complexity.

With the current KVM MMU (one page table hierarchy shared by all vCPUs),
the next best setup, I'd argue, is to co-locate the page tables with the
memory they are mapping. This setup would ensure that a vCPU accessing
memory in its local virtual node would primarily be accessing page
tables in the local physical node when doing page walks. Obviously page
tables at levels 5, 4, and 3, which likely map memory spanning multiple
nodes, could not always be co-located with all the memory they map.

My comment here is saying that there is no way for userspace to actually
enforce the above policy. There is no mempolicy userspace can set on
vCPU threads to ensure that KVM co-locates page tables with the memory
they are mapping. All userspace can do is force KVM to allocate page
tables on the same node as the vCPU thread, or on a specific node.

For eager page splitting, userspace can control what range of memory is
going to be split by controlling the memslot layout, so it is possible
for userspace to set an appropriate mempolicy on that thread. But if you
agree about my point about vCPU threads above, I think it would be a
step in the right direction to have KVM start forcibly co-locating page
tables with memory for eager page splitting (and we can fix the vCPU
case later).

> 
> > > We can improve TDP MMU eager page splitting by making
> > > tdp_mmu_alloc_sp_for_split() NUMA-aware. Specifically, when splitting a
> > > huge page, allocate the new lower level page tables on the same node as the
> > > huge page.
> > > 
> > > __get_free_page() is replaced by alloc_page_nodes(). This introduces two
> > > functional changes.
> > > 
> > >   1. __get_free_page() removes gfp flag __GFP_HIGHMEM via call to
> > >   __get_free_pages(). This should not be an issue  as __GFP_HIGHMEM flag is
> > >   not passed in tdp_mmu_alloc_sp_for_split() anyway.
> > > 
> > >   2. __get_free_page() calls alloc_pages() and use thread's mempolicy for
> > >   the NUMA node allocation. From this commit, thread's mempolicy will not
> > >   be used and first preference will be to allocate on the node where huge
> > >   page was present.
> > 
> > It would be worth noting that userspace could change the mempolicy of
> > the thread doing eager splitting to prefer allocating from the target
> > NUMA node, as an alternative approach.
> > 
> > I don't prefer the alternative though since it bleeds details from KVM
> > into userspace, such as the fact that enabling dirty logging does eager
> > page splitting, which allocates page tables. 
> 
> As above, if userspace is cares about vNUMA, then it already needs to be aware of
> some of KVM/kernel details.  Separate memslots aren't strictly necessary, e.g.
> userspace could stitch together contiguous VMAs to create a single mega-memslot,
> but that seems like it'd be more work than just creating separate memslots.
> 
> And because eager page splitting for dirty logging runs with mmu_lock held for,
> userspace might also benefit from per-node memslots as it can do the splitting on
> multiple tasks/CPUs.
> 
> Regardless of what we do, the behavior needs to be document, i.e. KVM details will
> bleed into userspace.  E.g. if KVM is overriding the per-task NUMA policy, then
> that should be documented.

+1

> 
> > It's also unnecessary since KVM can infer an appropriate NUMA placement
> > without the help of userspace, and I can't think of a reason for userspace to
> > prefer a different policy.
> 
> I can't think of a reason why userspace would want to have a different policy for
> the task that's enabling dirty logging, but I also can't think of a reason why
> KVM should go out of its way to ignore that policy.
> 
> IMO this is a "bug" in dirty_log_perf_test, though it's probably a good idea to
> document how to effectively configure vNUMA-aware memslots.
