Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86EA6C24B9
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 23:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjCTWYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 18:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCTWYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 18:24:10 -0400
Received: from out-17.mta1.migadu.com (out-17.mta1.migadu.com [95.215.58.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0663A4EE7
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 15:23:40 -0700 (PDT)
Date:   Mon, 20 Mar 2023 22:22:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679350932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Ie1PggKpWyqQmQo1JqLICaE5ex47zzesMZErjJwkhA=;
        b=wNSZoQ7dW77z4Ba/kYGA9Y2665AThTVU1Zun0l2OdZ/6UexR4hm9ItX0YoRMnB6/UXg45u
        NOX6KglmSUdziILUKI4acnFBDl+sg2D991EnBwaXVW7s2LXnOMglR+uQN1BoOIchnfPgxR
        A0UhifljutidObM2hE9yV0U6XDjQAXs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Anish Moorthy <amoorthy@google.com>, jthoughton@google.com,
        kvm@vger.kernel.org
Subject: Re: [WIP Patch v2 09/14] KVM: Introduce KVM_CAP_MEMORY_FAULT_NOWAIT
 without implementation
Message-ID: <ZBjckKb6eWx2vSin@linux.dev>
References: <20230315021738.1151386-1-amoorthy@google.com>
 <20230315021738.1151386-10-amoorthy@google.com>
 <ZBS4o75PVHL4FQqw@linux.dev>
 <ZBTK0vzAoWqY1hDh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBTK0vzAoWqY1hDh@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean,

On Fri, Mar 17, 2023 at 01:17:22PM -0700, Sean Christopherson wrote:
> On Fri, Mar 17, 2023, Oliver Upton wrote:
> > On Wed, Mar 15, 2023 at 02:17:33AM +0000, Anish Moorthy wrote:
> > > Add documentation, memslot flags, useful helper functions, and the
> > > actual new capability itself.
> > > 
> > > Memory fault exits on absent mappings are particularly useful for
> > > userfaultfd-based live migration postcopy. When many vCPUs fault upon a
> > > single userfaultfd the faults can take a while to surface to userspace
> > > due to having to contend for uffd wait queue locks. Bypassing the uffd
> > > entirely by triggering a vCPU exit avoids this contention and can improve
> > > the fault rate by as much as 10x.
> > > ---
> > >  Documentation/virt/kvm/api.rst | 37 +++++++++++++++++++++++++++++++---
> > >  include/linux/kvm_host.h       |  6 ++++++
> > >  include/uapi/linux/kvm.h       |  3 +++
> > >  tools/include/uapi/linux/kvm.h |  2 ++
> > >  virt/kvm/kvm_main.c            |  7 ++++++-
> > >  5 files changed, 51 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > index f9ca18bbec879..4932c0f62eb3d 100644
> > > --- a/Documentation/virt/kvm/api.rst
> > > +++ b/Documentation/virt/kvm/api.rst
> > > @@ -1312,6 +1312,7 @@ yet and must be cleared on entry.
> > >    /* for kvm_userspace_memory_region::flags */
> > >    #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
> > >    #define KVM_MEM_READONLY	(1UL << 1)
> > > +  #define KVM_MEM_ABSENT_MAPPING_FAULT (1UL << 2)
> > 
> > call it KVM_MEM_EXIT_ABSENT_MAPPING
> 
> Ooh, look, a bikeshed!  :-)

Couldn't help myself :)

> I don't think it should have "EXIT" in the name.  The exit to userspace is a side
> effect, e.g. KVM already exits to userspace on unresolved userfaults.  The only
> thing this knob _directly_ controls is whether or not KVM attempts the slow path.
> If we give the flag a name like "exit on absent userspace mappings", then KVM will
> appear to do the wrong thing when KVM exits on a truly absent userspace mapping.
> 
> And as I argued in the last version[*], I am _strongly_ opposed to KVM speculating
> on why KVM is exiting to userspace.  I.e. KVM should not set a special flag if
> the memslot has "fast only" behavior.  The only thing the flag should do is control
> whether or not KVM tries slow paths, what KVM does in response to an unresolved
> fault should be an orthogonal thing.
> 
> E.g. If KVM encounters an unmapped page while prefetching SPTEs, KVM will (correctly)
> not exit to userspace and instead simply terminate the prefetch.  Obviously we
> could solve that through documentation, but I don't see any benefit in making this
> more complex than it needs to be.

I couldn't care less about what the user-facing portion of this thing is
called, TBH. We could just refer to it as KVM_MEM_BIT_2 /s

The only bit I wanted to avoid is having a collision in the kernel between
literal faults arising from hardware and exits to userspace that we are also
calling 'faults'.

> [*] https://lkml.kernel.org/r/Y%2B0RYMfw6pHrSLX4%40google.com
> 
> > > +7.35 KVM_CAP_MEMORY_FAULT_NOWAIT
> > > +--------------------------------
> > > +
> > > +:Architectures: x86, arm64
> > > +:Returns: -EINVAL.
> > > +
> > > +The presence of this capability indicates that userspace may pass the
> > > +KVM_MEM_ABSENT_MAPPING_FAULT flag to KVM_SET_USER_MEMORY_REGION to cause KVM_RUN
> > > +to exit to populate 'kvm_run.memory_fault' and exit to userspace (*) in response
> > > +to page faults for which the userspace page tables do not contain present
> > > +mappings. Attempting to enable the capability directly will fail.
> > > +
> > > +The 'gpa' and 'len' fields of kvm_run.memory_fault will be set to the starting
> > > +address and length (in bytes) of the faulting page. 'flags' will be set to
> > > +KVM_MEMFAULT_REASON_ABSENT_MAPPING.
> > > +
> > > +Userspace should determine how best to make the mapping present, then take
> > > +appropriate action. For instance, in the case of absent mappings this might
> > > +involve establishing the mapping for the first time via UFFDIO_COPY/CONTINUE or
> > > +faulting the mapping in using MADV_POPULATE_READ/WRITE. After establishing the
> > > +mapping, userspace can return to KVM to retry the previous memory access.
> > > +
> > > +(*) NOTE: On x86, KVM_CAP_X86_MEMORY_FAULT_EXIT must be enabled for the
> > > +KVM_MEMFAULT_REASON_ABSENT_MAPPING_reason: otherwise userspace will only receive
> > > +a -EFAULT from KVM_RUN without any useful information.
> > 
> > I'm not a fan of this architecture-specific dependency. Userspace is already
> > explicitly opting in to this behavior by way of the memslot flag. These sort
> > of exits are entirely orthogonal to the -EFAULT conversion earlier in the
> > series.
> 
> Ya, yet another reason not to speculate on why KVM wasn't able to resolve a fault.

Regardless of what we name this memslot flag, we're already getting explicit
opt-in from userspace for new behavior. There seems to be zero value in
supporting memslot_flag && !MEMORY_FAULT_EXIT (i.e. returning EFAULT),
so why even bother?

Requiring two levels of opt-in to have the intended outcome for a single
architecture seems nauseating from a userspace perspective.

-- 
Thanks,
Oliver
