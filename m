Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6863C5BE6E2
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 15:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiITNTh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 09:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbiITNTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 09:19:34 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 015AED83
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 06:19:31 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9B031042;
        Tue, 20 Sep 2022 06:19:37 -0700 (PDT)
Received: from e121798.cambridge.arm.com (e121798.cambridge.arm.com [10.1.196.158])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 88F0B3F73D;
        Tue, 20 Sep 2022 06:19:30 -0700 (PDT)
Date:   Tue, 20 Sep 2022 14:19:28 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 06/19] lib/alloc_phys: Remove
 allocation accounting
Message-ID: <Yym94MMavW1T33XM@e121798.cambridge.arm.com>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-7-alexandru.elisei@arm.com>
 <20220920084047.gblxkhedbugl7giz@kamzik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920084047.gblxkhedbugl7giz@kamzik>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Tue, Sep 20, 2022 at 10:40:47AM +0200, Andrew Jones wrote:
> On Tue, Aug 09, 2022 at 10:15:45AM +0100, Alexandru Elisei wrote:
> > The page allocator has better allocation tracking and is used by all
> > architectures, while the physical allocator is now never used for
> > allocating memory.
> > 
> > Simplify the physical allocator by removing allocation accounting. This
> > accomplishes two things:
> > 
> > 1. It makes the allocator more useful, as the warning that was displayed
> > each allocation after the 256th is removed.
> > 
> > 2. Together with the lock removal, the physical allocator becomes more
> > appealing as a very early allocator, when using the page allocator might
> > not be desirable or feasible.
> 
> How does the locking cause problems when used in an early allocator?

By "early allocator" I mean here an allocator that can be used with the MMU
off.

The "desirable or feasible" part refers to the fact that the page allocator
cannot be used an early allocator (when the MMU is off) because 1. It
doesn't do the necessary cache maintenance operations and 2. It would be
hard to do add them, as the internal structures that the page allocator
maintains are significantly more complex than what the physical allocator
uses.

With this part: "together with the lock removal, the physical allocator
becomes more appealing as a very early allocator [..]" I was trying to say
that the physical allocator has now become as simple as it can possibly be
(well, align_min could also be removed and leave it up to the calling code
to request correctly aligned allocations but it's debatable if users of the
allocator should know about how it's implemented). I can reword or remove
this part if you feel it's confusing.

Thanks,
Alex

> 
> > 
> > Also, phys_alloc_show() has received a slight change in the way it displays
> > the use and free regions: the end of the region is now non-inclusive, to
> > allow phys_alloc_show() to express that no memory has been used, or no
> > memory is free, in which case the start and the end adresses are equal.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  lib/alloc_phys.c | 65 ++++++++++++++----------------------------------
> >  lib/alloc_phys.h |  5 ++--
> >  2 files changed, 21 insertions(+), 49 deletions(-)
> >
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
