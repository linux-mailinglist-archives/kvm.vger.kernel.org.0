Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C454968360D
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 20:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjAaTGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 14:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjAaTGv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 14:06:51 -0500
Received: from out-233.mta0.migadu.com (out-233.mta0.migadu.com [91.218.175.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7A715574
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 11:06:50 -0800 (PST)
Date:   Tue, 31 Jan 2023 19:06:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675192007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZmtUF7xjL5ODD9h13/vWb0RTU4ZRTPtj2CaIlUkmR3g=;
        b=rzlb8oI2umgUIUXqdrIkpJ1G/vmiAMvKva0tvD2Tqk4I0kM+77GIAAeOI1jpkERECidISD
        q+Ni/TsCsk8mkx15lx6qkB/TMkm2IN0I5xuWohcc0+m+0TDQvQ4REJXcACtdujBxo4v5bh
        38rnhVTeFFZK3oD/qm0mUiq8f3bHg/k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ricardo Koller <ricarkol@google.com>,
        Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 6/9] KVM: arm64: Split huge pages when dirty logging is
 enabled
Message-ID: <Y9lmu8Ql/5nPRkX3@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-7-ricarkol@google.com>
 <Y9BfdgL+JSYCirvm@thinky-boi>
 <CAOHnOrysMhp_8Kdv=Pe-O8ZGDbhN5HiHWVhBv795_E6+4RAzPw@mail.gmail.com>
 <86v8ktkqfx.wl-maz@kernel.org>
 <CAOHnOrx-vvuZ9n8xDRmJTBCZNiqvcqURVyrEt2tDpw5bWT0qew@mail.gmail.com>
 <Y9g0KGmsZqAZiTSP@google.com>
 <Y9hsV02TpQeoB0oN@google.com>
 <Y9lTz3ryasgkfhs/@google.com>
 <Y9lV5XEf7NV8i9uI@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9lV5XEf7NV8i9uI@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023 at 05:54:45PM +0000, Sean Christopherson wrote:
> On Tue, Jan 31, 2023, Oliver Upton wrote:
> > On Tue, Jan 31, 2023 at 01:18:15AM +0000, Sean Christopherson wrote:
> > > On Mon, Jan 30, 2023, Oliver Upton wrote:
> > > > I think that Marc's suggestion of having userspace configure this is
> > > > sound. After all, userspace _should_ know the granularity of the backing
> > > > source it chose for guest memory.
> > > > 
> > > > We could also interpret a cache size of 0 to signal that userspace wants
> > > > to disable eager page split for a VM altogether. It is entirely possible that
> > > > the user will want a differing QoS between slice-of-hardware and
> > > > overcommitted VMs.
> > > 
> > > Maybe.  It's also entirely possible that QoS is never factored in, e.g. if QoS
> > > guarantees for all VMs on a system are better met by enabling eager splitting
> > > across the board.
> > > 
> > > There are other reasons to use module/kernel params beyond what Marc listed, e.g.
> > > to let the user opt out even when something is on by default.  x86's TDP MMU has
> > > benefited greatly from downstream users being able to do A/B performance testing
> > > this way.  I suspect x86's eager_page_split knob was added largely for this
> > > reason, e.g. to easily see how a specific workload is affected by eager splitting.
> > > That seems like a reasonable fit on the ARM side as well.
> > 
> > There's a rather important distinction here in that we'd allow userspace
> > to select the page split cache size, which should be correctly sized for
> > the backing memory source. Considering the break-before-make rules of
> > the architecture, the only way eager split is performant on arm64 is by
> > replacing a block entry with a fully populated table hierarchy in one
> > operation. AFAICT, you don't have this problem on x86, as the
> > architecture generally permits a direct valid->valid transformation
> > without an intermediate invalidation. Well, ignoring iTLB multihit :)
> > 
> > So, the largest transformation we need to do right now is on a PUD w/
> > PAGE_SIZE=4K, leading to 513 pages as proposed in the series. Exposing
> > that configuration option in a module parameter is presumptive that all
> > VMs on a host use the exact same memory configuration, which doesn't
> > feel right to me.
> 
> Can you elaborate on the cache size needing to be tied to the backing source?

The proposed eager split mechanism attempts to replace a block with a
a fully populated page table hierarchy (i.e. mapped at PTE granularity)
in order to avoid successive break-before-make invalidations. The cache
size must be >= the number of pages required to build out that fully
mapped page table hierarchy.

> Do the issues arise if you get to a point where KVM can have PGD-sized hugepages
> with PAGE_SIZE=4KiB?

Those problems when splitting any hugepage larger than a PMD. It just
so happens that the only configuration that supports larger mappings is
4K at the moment.

If we were to take the step-down approach to eager page splitting, there
will be a lot of knock-on break-before-make operations as we go
PUD -> PMD -> PTE.

> Or do you want to let userspace optimize _now_ for PMD+4KiB?

The default cache value should probably optimize for PMD splitting and
give userspace the option to scale that up for PUD or greater if it sees
fit.

-- 
Thanks,
Oliver
