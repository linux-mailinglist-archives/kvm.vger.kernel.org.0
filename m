Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF57D681C8C
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 22:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjA3VSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 16:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjA3VSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 16:18:46 -0500
Received: from out-52.mta0.migadu.com (out-52.mta0.migadu.com [91.218.175.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A441360B4
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 13:18:45 -0800 (PST)
Date:   Mon, 30 Jan 2023 21:18:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675113523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rsyCX5RRL5loV9M7/fB0vDq+CM5ISUwY8tUlpHclZls=;
        b=l39FTYdydVrifO4QFvQaw+3rHweLz/w/vp/tOSXpGyEApZyRZ8dAolcEFKzmi8wXsy2k4n
        BfM26jr0idIbG9rPTuXR1XqHfpZOvpQXbayEftnaz9yQbgA93de2tpQmEe/4I1qiNYJMML
        OTB2GTld/yG7SkD/KQXNmxIAmvoxjxM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 6/9] KVM: arm64: Split huge pages when dirty logging is
 enabled
Message-ID: <Y9g0KGmsZqAZiTSP@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-7-ricarkol@google.com>
 <Y9BfdgL+JSYCirvm@thinky-boi>
 <CAOHnOrysMhp_8Kdv=Pe-O8ZGDbhN5HiHWVhBv795_E6+4RAzPw@mail.gmail.com>
 <86v8ktkqfx.wl-maz@kernel.org>
 <CAOHnOrx-vvuZ9n8xDRmJTBCZNiqvcqURVyrEt2tDpw5bWT0qew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOHnOrx-vvuZ9n8xDRmJTBCZNiqvcqURVyrEt2tDpw5bWT0qew@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 07:45:15AM -0800, Ricardo Koller wrote:
> Hi Marc,
> 
> On Thu, Jan 26, 2023 at 12:10 PM Marc Zyngier <maz@kernel.org> wrote:

[...]

> >
> > The one thing that would convince me to make it an option is the
> > amount of memory this thing consumes. 512+ pages is a huge amount, and
> > I'm not overly happy about that. Why can't this be a userspace visible
> > option, selectable on a per VM (or memslot) basis?
> >
> 
> It should be possible.  I am exploring a couple of ideas that could
> help when the hugepages are not 1G (e.g., 2M).  However, they add
> complexity and I'm not sure they help much.
> 
> (will be using PAGE_SIZE=4K to make things simpler)
> 
> This feature pre-allocates 513 pages before splitting every 1G range.
> For example, it converts 1G block PTEs into trees made of 513 pages.
> When not using this feature, the same 513 pages would be allocated,
> but lazily over a longer period of time.
> 
> Eager-splitting pre-allocates those pages in order to split huge-pages
> into fully populated trees.  Which is needed in order to use FEAT_BBM
> and skipping the expensive TLBI broadcasts.  513 is just the number of
> pages needed to break a 1G huge-page.
> 
> We could optimize for smaller huge-pages, like 2M by splitting 1
> huge-page at a time: only preallocate one 4K page at a time.  The
> trick is how to know that we are splitting 2M huge-pages.  We could
> either get the vma pagesize or use hints from userspace.  I'm not sure
> that this is worth it though.  The user will most likely want to split
> big ranges of memory (>1G), so optimizing for smaller huge-pages only
> converts the left into the right:
> 
> alloc 1 page            |    |  alloc 512 pages
> split 2M huge-page      |    |  split 2M huge-page
> alloc 1 page            |    |  split 2M huge-page
> split 2M huge-page      | => |  split 2M huge-page
>                         ...
> alloc 1 page            |    |  split 2M huge-page
> split 2M huge-page      |    |  split 2M huge-page
> 
> Still thinking of what else to do.

I think that Marc's suggestion of having userspace configure this is
sound. After all, userspace _should_ know the granularity of the backing
source it chose for guest memory.

We could also interpret a cache size of 0 to signal that userspace wants
to disable eager page split for a VM altogether. It is entirely possible
that the user will want a differing QoS between slice-of-hardware and
overcommitted VMs.

-- 
Thanks,
Oliver
