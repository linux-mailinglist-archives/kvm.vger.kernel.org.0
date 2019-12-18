Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBDE125199
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 20:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfLRTO5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 14:14:57 -0500
Received: from mga18.intel.com ([134.134.136.126]:38112 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbfLRTO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 14:14:57 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 11:14:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="240892015"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 18 Dec 2019 11:14:56 -0800
Date:   Wed, 18 Dec 2019 11:14:55 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH 13/28] kvm: mmu: Add an iterator for concurrent
 paging structure walks
Message-ID: <20191218191455.GD25201@linux.intel.com>
References: <20190926231824.149014-1-bgardon@google.com>
 <20190926231824.149014-14-bgardon@google.com>
 <20191203021514.GK8120@linux.intel.com>
 <CANgfPd_9KpwOuk1pQ7jzhmFksE-FBaFMPP-yhmG1yu9txUBi3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_9KpwOuk1pQ7jzhmFksE-FBaFMPP-yhmG1yu9txUBi3Q@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 18, 2019 at 10:25:45AM -0800, Ben Gardon wrote:
> On Mon, Dec 2, 2019 at 6:15 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > > +static bool direct_walk_iterator_next_pte(struct direct_walk_iterator *iter)
> > > +{
> > > +     /*
> > > +      * This iterator could be iterating over a large number of PTEs, such
> > > +      * that if this thread did not yield, it would cause scheduler\
> > > +      * problems. To avoid this, yield if needed. Note the check on
> > > +      * MMU_LOCK_MAY_RESCHED in direct_walk_iterator_cond_resched. This
> > > +      * iterator will not yield unless that flag is set in its lock_mode.
> > > +      */
> > > +     direct_walk_iterator_cond_resched(iter);
> >
> > This looks very fragile, e.g. one of the future patches even has to avoid
> > problems with this code by limiting the number of PTEs it processes.
>
> With this, functions either need to limit the number of PTEs they
> process or pass the MMU_LOCK_MAY_RESCHED to the iterator. It would
> probably be safer to invert the flag and make it
> MMU_LOCK_MAY_NOT_RESCHED for functions that can self-regulate the
> number of PTEs they process or have weird synchronization
> requirements. For example, the page fault handler can't reschedule and
> we know it won't process many entries, so we could pass
> MMU_LOCK_MAY_NOT_RESCHED in there.

That doesn't address the underlying fragility of the iterator, i.e. relying
on callers to self-regulate.  Especially since the threshold is completely
arbitrary, e.g. in zap_direct_gfn_range(), what's to say PDPE and lower is
always safe, e.g. if should_resched() becomes true at the very start of the
walk?

The direct comparison to zap_direct_gfn_range() is slot_handle_level_range(),
which supports rescheduling regardless of what function is being invoked.
What prevents the TDP iterator from doing the same?  E.g. what's the worst
case scenario if a reschedule pops up at an inopportune time?
