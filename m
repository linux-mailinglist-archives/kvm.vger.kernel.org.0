Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF60507943
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 20:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357434AbiDSSkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 14:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354589AbiDSSjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 14:39:35 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D64D3D4A7
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 11:36:41 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id r18so21683456ljp.0
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 11:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=igrepIlJhovin1ZitPt/fwfo5UFpiMUyDj9kpyJCGUE=;
        b=Z9B5FbZM8I02OP9Qkj77nY3yfcEmO1xlNXbWFQ8NlS0+aiVDthPvSdWH7VxST/i0V5
         Yfyt479QC07Kp9fubFhV4Mx6rBmGcjCtjtgQ4ZXdJU9kTXtYu1Hm8tsO0FxS3A083qOT
         yn7nYPAtNLFgmLYWPpkCsZJbK0TWcsyL62rL8cDupXnEJF2vNtkyBe1NA3FyW61aLCG+
         n+mU/tOOkT/Qse06ANMN0vsSRoqXPFKJeujuK6WhAEQwPtHqRzfLx4/kXLx9Nkz/nhZA
         nA4YbXbaxh6KC3olCzZq7amawJHZOFs5S41FMCyvcEC3qRuZgWWHbcJJGgD4n54B2C4l
         dagg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=igrepIlJhovin1ZitPt/fwfo5UFpiMUyDj9kpyJCGUE=;
        b=W0cxgj0U43HddFiMhAPDN5kz98G55wKhfDWlGKdUhoSj1XpUzdUunLhV2cqbI2JPkx
         IYz2ix2HucFh26n4MNtprnTml1VFZ42PVCPwHGtpH9efYriS9LyVzXEQp5ieJTtWDkF/
         doVyRdTnoSsfJQnrt+LvPq6r09ZvAJ580uaRRNYxipoFWhqs4yWUs6Op+aCRl1nNu2FG
         vvw81iVfttHCn9/+3ETy0/wypsiqsPsFIdf+mLzI6SuyOV1d/jM2xCPVmr/VnepsL4Cw
         VXRnFdroWXv6c1EpdznQX8pP4mnIdvDr5/fNq1eBuy0X7fpWZFEaDXO474GT6mQNmcsJ
         5Ybw==
X-Gm-Message-State: AOAM533DaqJigyFGpBIyUs2o8QoIDvr5/3SQlQqi4j4UOhxjPG3ivAFe
        AzKyggaHozwlPyBSxbH6qs4XjZYaeZQfNlxSaI//AQ==
X-Google-Smtp-Source: ABdhPJyJ4/g7pwfK7Ecm19c7JGK2gaZy4Nc/2tlPzIbimaLm3zH663J4xaxf7hSCk7oZ9W+AfJ0gXfmbRSIibpBngRo=
X-Received: by 2002:a05:651c:1a0c:b0:24d:c538:d504 with SMTP id
 by12-20020a05651c1a0c00b0024dc538d504mr3532020ljb.479.1650393399468; Tue, 19
 Apr 2022 11:36:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com> <CANgfPd8V5AdH0dEAox2PvKJpqDrqmfJyiwoLpxEGqVfb7EEP9Q@mail.gmail.com>
In-Reply-To: <CANgfPd8V5AdH0dEAox2PvKJpqDrqmfJyiwoLpxEGqVfb7EEP9Q@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 19 Apr 2022 11:36:28 -0700
Message-ID: <CAOQ_QsieUXOFXLkZ=ya0RUpU8Mv2sd9hmskwEW99tH26cjjX_A@mail.gmail.com>
Subject: Re: [RFC PATCH 00/17] KVM: arm64: Parallelize stage 2 fault handling
To:     Ben Gardon <bgardon@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
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

On Tue, Apr 19, 2022 at 10:57 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
> >
> > Presently KVM only takes a read lock for stage 2 faults if it believes
> > the fault can be fixed by relaxing permissions on a PTE (write unprotect
> > for dirty logging). Otherwise, stage 2 faults grab the write lock, which
> > predictably can pile up all the vCPUs in a sufficiently large VM.
> >
> > The x86 port of KVM has what it calls the TDP MMU. Basically, it is an
> > MMU protected by the combination of a read-write lock and RCU, allowing
> > page walkers to traverse in parallel.
> >
> > This series is strongly inspired by the mechanics of the TDP MMU,
> > making use of RCU to protect parallel walks. Note that the TLB
> > invalidation mechanics are a bit different between x86 and ARM, so we
> > need to use the 'break-before-make' sequence to split/collapse a
> > block/table mapping, respectively.
> >
> > Nonetheless, using atomics on the break side allows fault handlers to
> > acquire exclusive access to a PTE (lets just call it locked). Once the
> > PTE lock is acquired it is then safe to assume exclusive access.
> >
> > Special consideration is required when pruning the page tables in
> > parallel. Suppose we are collapsing a table into a block. Allowing
> > parallel faults means that a software walker could be in the middle of
> > a lower level traversal when the table is unlinked. Table
> > walkers that prune the paging structures must now 'lock' all descendent
> > PTEs, effectively asserting exclusive ownership of the substructure
> > (no other walker can install something to an already locked pte).
> >
> > Additionally, for parallel walks we need to punt the freeing of table
> > pages to the next RCU sync, as there could be multiple observers of the
> > table until all walkers exit the RCU critical section. For this I
> > decided to cram an rcu_head into page private data for every table page.
> > We wind up spending a bit more on table pages now, but lazily allocating
> > for rcu callbacks probably doesn't make a lot of sense. Not only would
> > we need a large cache of them (think about installing a level 1 block)
> > to wire up callbacks on all descendent tables, but we also then need to
> > spend memory to actually free memory.
>
> FWIW we used a similar approach in early versions of the TDP MMU, but
> instead of page->private used page->lru so that more metadata could be
> stored in page->private.
> Ultimately that ended up being too limiting and we decided to switch
> to just using the associated struct kvm_mmu_page as the list element.
> I don't know if ARM has an equivalent construct though.

ARM currently doesn't have any metadata it needs to tie with the table
pages. We just do very basic page reference counting for every valid
PTE. I was going to link together pages (hence the page header), but
we actually do not have a functional need for it at the moment. In
fact, struct page::rcu_head would probably fit the bill and we can
avoid extra metadata/memory for the time being.

Perhaps best to keep it simple and do the rest when we have a genuine
need for it.

--
Thanks,
Oliver
