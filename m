Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F0C5880F0
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 19:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbiHBRWY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 13:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiHBRWX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 13:22:23 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A95548E8E
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 10:22:22 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id w10so14106281plq.0
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 10:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=XmXyg3atnOF0W1my4Azyvvp0Ty/+W6UASEOLUT0YYAo=;
        b=hRHYGQ5hGjWVuyXA7K3jugJfYvZ5h4FXLHuEJPc1bURUzwtY3SD9oVAqhA50l2hHSE
         JHsoEfPrRAZuzJIIfdlNWtOE0aijdbnV6YGA6OvqaSL4V7ZSdWDb6u8cmSMykQX8IHto
         5AKdFp67IsboKYtcUAKrv/rsNdZwjA+PkG7gaM6kSZH7FbcFf5ynr8z5POtwmAYNB8qV
         0yH/t5cF5xMwjv9jMC/V1oG3VP6eg8574xEPhyTXx8vZC9ZyDTz5D/mZpo7uJnZmnfSb
         fX+XBqZ3pbRZVg6PzWIMGIuJE9sZmv14JunZqO6c/Sw7+DfiSre2u2uQMqcIxA2oCF+f
         iu9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=XmXyg3atnOF0W1my4Azyvvp0Ty/+W6UASEOLUT0YYAo=;
        b=v5PUwbR9oIWBBZugDr0ruN0ZLclha7ATTrNFxCrFm53fCchLDbuBm/rCGn9Cs4YKF/
         kWUMnMjGYSaWUPt1nCcjyFHc3dwrxaQt59VkKeFbgrPZBtUJnS75gHFL4MmrnMOL+sOg
         jItWxpNRpOGBRUvySSaLXvphBCni9sBojWMzDqIkoVRvWsI4O5fQIac9yJBl55rJwB+p
         rb8JJe0a5zcJ5GyCxWHaFSCDBDdbD9RhD3RYcsLhp94agvmiv1fozK53KhZOp3KuqctY
         3hyULX3kwJ4KgSR42zMibCPXFL/KUbBvD9pHG8KzpSEUB48qV43z2rJzABjH13FNQapO
         AZWg==
X-Gm-Message-State: ACgBeo3D2oOn7h2v8hlcoW1oW2xlnXGS6BUpq2EUOJZL5EQXBe1WP2Hc
        qUFut57MXhCRQsecXIRkmXpVFg==
X-Google-Smtp-Source: AA6agR59hJfH9tfXVnRaPZtA4b9uK8jX33ZeTGWxc+ZSj7+tM3LQhFHn1jNiQ1H/T66kq3F28mZ/gg==
X-Received: by 2002:a17:903:244e:b0:16d:d5cd:c184 with SMTP id l14-20020a170903244e00b0016dd5cdc184mr20640649pls.44.1659460941545;
        Tue, 02 Aug 2022 10:22:21 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j11-20020a170902da8b00b0016d1f6d1b99sm12201925plx.49.2022.08.02.10.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 10:22:21 -0700 (PDT)
Date:   Tue, 2 Aug 2022 17:22:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Vipin Sharma <vipinsh@google.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Make page tables for eager page splitting
 NUMA aware
Message-ID: <YuldSf4T2j4rIrIo@google.com>
References: <20220801151928.270380-1-vipinsh@google.com>
 <YuhPT2drgqL+osLl@google.com>
 <YuhoJUoPBOu5eMz8@google.com>
 <YulRZ+uXFOE1y2dj@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YulRZ+uXFOE1y2dj@google.com>
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

On Tue, Aug 02, 2022, David Matlack wrote:
> On Mon, Aug 01, 2022 at 11:56:21PM +0000, Sean Christopherson wrote:
> > On Mon, Aug 01, 2022, David Matlack wrote:
> > > On Mon, Aug 01, 2022 at 08:19:28AM -0700, Vipin Sharma wrote:
> > > That being said, KVM currently has a gap where a guest doing a lot of
> > > remote memory accesses when touching memory for the first time will
> > > cause KVM to allocate the TDP page tables on the arguably wrong node.
> > 
> > Userspace can solve this by setting the NUMA policy on a VMA or shared-object
> > basis.  E.g. create dedicated memslots for each NUMA node, then bind each of the
> > backing stores to the appropriate host node.
> > 
> > If there is a gap, e.g. a backing store we want to use doesn't properly support
> > mempolicy for shared mappings, then we should enhance the backing store.
> 
> Just to clarify: this patch, and my comment here, is about the NUMA
> locality of KVM's page tables, not guest memory.

Oooh, I overlooked the "TDP page tables" part in the above paragraph.

> KVM allocates all page tables through __get_free_page() which uses the
> current task's mempolicy. This means the only way for userspace to
> control the page table NUMA locality is to set mempolicies on the
> threads on which KVM will allocate page tables (vCPUs and any thread
> doing eager page splitting, i.e. enable dirty logging or
> KVM_CLEAR_DIRTY_LOG).
> 
> The ideal setup from a NUMA locality perspective would be that page
> tables are always on the local node, but that would require KVM maintain
> multiple copies of page tables (at minimum one per physical NUMA node),
> which is extra memory and complexity.

Hmm, it actually wouldn't be much complexity, e.g. a few bits in the role, but
the memory would indeed be a problem.

> With the current KVM MMU (one page table hierarchy shared by all vCPUs),
> the next best setup, I'd argue, is to co-locate the page tables with the
> memory they are mapping. This setup would ensure that a vCPU accessing
> memory in its local virtual node would primarily be accessing page
> tables in the local physical node when doing page walks. Obviously page
> tables at levels 5, 4, and 3, which likely map memory spanning multiple
> nodes, could not always be co-located with all the memory they map.
> 
> My comment here is saying that there is no way for userspace to actually
> enforce the above policy. There is no mempolicy userspace can set on
> vCPU threads to ensure that KVM co-locates page tables with the memory
> they are mapping. All userspace can do is force KVM to allocate page
> tables on the same node as the vCPU thread, or on a specific node.
> 
> For eager page splitting, userspace can control what range of memory is
> going to be split by controlling the memslot layout, so it is possible
> for userspace to set an appropriate mempolicy on that thread. But if you
> agree about my point about vCPU threads above, I think it would be a
> step in the right direction to have KVM start forcibly co-locating page
> tables with memory for eager page splitting (and we can fix the vCPU
> case later).

I agree that there's a gap with respect to a vCPU being the first to touch a
remote node, but I disagree that forcibly co-locating page tables for eager page
splitting is necessary.

Userspace can already force the ideal setup for eager page splitting by configuring
vNUMA-aware memslots and using a task with appropriate policy to toggle dirty
logging.  And userspace really should be encouraged to do that, because otherwise
walking the page tables in software to do the split is going to be constantly
accessing remote memory.

And if anyone ever wants to fix the aforementioned gap, the two fixes that come to
mind would be to tie the policy to the memslot, or to do page_to_nid() on the
underlying page (with the assumption that memory that's not backed by struct page
isn't NUMA-aware, so fall back to task policy).  At that point, having one-off code
to pull the node from the existing page tables is also unnecessary.
