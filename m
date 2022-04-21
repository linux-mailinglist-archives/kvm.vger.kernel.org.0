Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E1550A5C5
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 18:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbiDUQec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 12:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbiDUQdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 12:33:53 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DD648302
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 09:31:03 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id f17so9682205ybj.10
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 09:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=85KhqeJYci7KtDV6WnG3kCKWzEDclQTTPrHp0DkW/4I=;
        b=S7qrv0c9ibm9ObfrK3N2O6JQD0lgfWJP3iX06KjZsLuEmxFHObUR5eAz8SdwO5Nm3p
         vzT/oJjHKWXzpWA73Q/qJMuaOnsvvJEvki+yBtUMKAnOjGXxv+NNRJyegojLmEymoMPN
         X+A9ktZZ9XWy4cgPZ3cvSqhIkvpuTZDdzkL7qF3Myx6sorEGHfPtcFmVMP4oAcJY1+Ou
         FKxllXtwprwzxlaOy1GKs6996L7ExTBCTRz1YZpPIv7zWcGJqJ1GpYN9HZvWn9vjrmdq
         qfEMwiV9qAwvWzx2jdBivNrjiXTrlNhvAaO1SW+++UfneqJ8yeSipAyPGWyA0pZL8gZY
         8X1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=85KhqeJYci7KtDV6WnG3kCKWzEDclQTTPrHp0DkW/4I=;
        b=id9HOCb7gA4U4urT/5CRXtU7Yvcyc1W2sT8v7mET2MhSoplgl9n5hEB6akzzs0KgDn
         geyuAW9gt/U7dsDamwiZ2/3KFE/W0Ig5d9pzcl1CCH84DV+/NWja4uifyr+N+VdtoUkH
         uglx6buMEOqeAIq03zC7Nz48sikWpRByIs4n4baGek9NEy99EKwykE0AbLq75UwZ4sAI
         YgpBCj/KW+u6AXQhB7B9ItPbkguvxM7dSvXNIFRVtm7+6oOEV1owo+3kdMqJFPKEI6Og
         KUkcMi6BQ8XfyBUwcvcOXSjNl5uUYTYRPTZ2XJraXq7yIFTXbdaHhy6fbcioIj+90g7L
         3bUg==
X-Gm-Message-State: AOAM532fJOMqcfBdFGmNtPchkA3qiWRyQL4239T32ExFwfIE63iuF/kg
        GkaWQ5BP5mX9jwzEN68fweKJN2VfgL6BG8I1XXVrCQ==
X-Google-Smtp-Source: ABdhPJxI3f+nxc2oRFOpDB/a5OEQMffl8ehlvKNFIdsC9CIQ+joF/lNpYwk0ZFH/AYir2u09DHK53XcQqGK8liK6Wj8=
X-Received: by 2002:a25:8546:0:b0:61e:1d34:ec71 with SMTP id
 f6-20020a258546000000b0061e1d34ec71mr451287ybn.259.1650558662967; Thu, 21 Apr
 2022 09:31:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com> <CANgfPd8V5AdH0dEAox2PvKJpqDrqmfJyiwoLpxEGqVfb7EEP9Q@mail.gmail.com>
 <CAOQ_QsieUXOFXLkZ=ya0RUpU8Mv2sd9hmskwEW99tH26cjjX_A@mail.gmail.com>
In-Reply-To: <CAOQ_QsieUXOFXLkZ=ya0RUpU8Mv2sd9hmskwEW99tH26cjjX_A@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 21 Apr 2022 09:30:52 -0700
Message-ID: <CANgfPd80wTYX92Q9dP7irMdZW+Y0_VNFQ19xJaf5DvndEaa7dw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/17] KVM: arm64: Parallelize stage 2 fault handling
To:     Oliver Upton <oupton@google.com>
Cc:     "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>,
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 19, 2022 at 11:36 AM Oliver Upton <oupton@google.com> wrote:
>
> On Tue, Apr 19, 2022 at 10:57 AM Ben Gardon <bgardon@google.com> wrote:
> >
> > On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
> > >
> > > Presently KVM only takes a read lock for stage 2 faults if it believes
> > > the fault can be fixed by relaxing permissions on a PTE (write unprotect
> > > for dirty logging). Otherwise, stage 2 faults grab the write lock, which
> > > predictably can pile up all the vCPUs in a sufficiently large VM.
> > >
> > > The x86 port of KVM has what it calls the TDP MMU. Basically, it is an
> > > MMU protected by the combination of a read-write lock and RCU, allowing
> > > page walkers to traverse in parallel.
> > >
> > > This series is strongly inspired by the mechanics of the TDP MMU,
> > > making use of RCU to protect parallel walks. Note that the TLB
> > > invalidation mechanics are a bit different between x86 and ARM, so we
> > > need to use the 'break-before-make' sequence to split/collapse a
> > > block/table mapping, respectively.
> > >
> > > Nonetheless, using atomics on the break side allows fault handlers to
> > > acquire exclusive access to a PTE (lets just call it locked). Once the
> > > PTE lock is acquired it is then safe to assume exclusive access.
> > >
> > > Special consideration is required when pruning the page tables in
> > > parallel. Suppose we are collapsing a table into a block. Allowing
> > > parallel faults means that a software walker could be in the middle of
> > > a lower level traversal when the table is unlinked. Table
> > > walkers that prune the paging structures must now 'lock' all descendent
> > > PTEs, effectively asserting exclusive ownership of the substructure
> > > (no other walker can install something to an already locked pte).
> > >
> > > Additionally, for parallel walks we need to punt the freeing of table
> > > pages to the next RCU sync, as there could be multiple observers of the
> > > table until all walkers exit the RCU critical section. For this I
> > > decided to cram an rcu_head into page private data for every table page.
> > > We wind up spending a bit more on table pages now, but lazily allocating
> > > for rcu callbacks probably doesn't make a lot of sense. Not only would
> > > we need a large cache of them (think about installing a level 1 block)
> > > to wire up callbacks on all descendent tables, but we also then need to
> > > spend memory to actually free memory.
> >
> > FWIW we used a similar approach in early versions of the TDP MMU, but
> > instead of page->private used page->lru so that more metadata could be
> > stored in page->private.
> > Ultimately that ended up being too limiting and we decided to switch
> > to just using the associated struct kvm_mmu_page as the list element.
> > I don't know if ARM has an equivalent construct though.
>
> ARM currently doesn't have any metadata it needs to tie with the table
> pages. We just do very basic page reference counting for every valid
> PTE. I was going to link together pages (hence the page header), but
> we actually do not have a functional need for it at the moment. In
> fact, struct page::rcu_head would probably fit the bill and we can
> avoid extra metadata/memory for the time being.

Ah, right! I page::rcu_head was the field I was thinking of.

>
> Perhaps best to keep it simple and do the rest when we have a genuine
> need for it.

Completely agree. I'm surprised that ARM doesn't have a need for a
metadata structure associated with each page of the stage 2 paging
structure, but if you don't need it, that definitely makes things
simpler.

>
> --
> Thanks,
> Oliver
