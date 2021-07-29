Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6223D9BFA
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 05:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhG2DBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 23:01:07 -0400
Received: from mga12.intel.com ([192.55.52.136]:3045 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233341AbhG2DBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 23:01:06 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10059"; a="192387570"
X-IronPort-AV: E=Sophos;i="5.84,276,1620716400"; 
   d="scan'208";a="192387570"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2021 20:01:02 -0700
X-IronPort-AV: E=Sophos;i="5.84,276,1620716400"; 
   d="scan'208";a="506874636"
Received: from wye1-mobl1.ccr.corp.intel.com (HELO localhost) ([10.249.174.73])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2021 20:00:59 -0700
Date:   Thu, 29 Jul 2021 11:00:56 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: A question of TDP unloading.
Message-ID: <20210729030056.uk644q3eeoux2qfa@linux.intel.com>
References: <20210727161957.lxevvmy37azm2h7z@linux.intel.com>
 <YQBLZ/RrBFxE4G4w@google.com>
 <20210728065605.e4ql2hzrj5fkngux@linux.intel.com>
 <20210728072514.GA375@yzhao56-desk.sh.intel.com>
 <CANgfPd_Rt3udm8mUHzX=MaXPOafkXhUt++7ACNsG1PnPiLswnw@mail.gmail.com>
 <20210728172241.aizlvj2alvxfvd43@linux.intel.com>
 <CANgfPd_o+HC80aqTQn7CA3o4rN2AFPDUp_Jxj9CQ6Rie9+yAug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_o+HC80aqTQn7CA3o4rN2AFPDUp_Jxj9CQ6Rie9+yAug@mail.gmail.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 10:55:01AM -0700, Ben Gardon wrote:
> On Wed, Jul 28, 2021 at 10:23 AM Yu Zhang <yu.c.zhang@linux.intel.com> wrote:
> >
> > On Wed, Jul 28, 2021 at 09:23:53AM -0700, Ben Gardon wrote:
> > > On Wed, Jul 28, 2021 at 12:40 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >
> > > > On Wed, Jul 28, 2021 at 02:56:05PM +0800, Yu Zhang wrote:
> > > > > Thanks a lot for your reply, Sean.
> > > > >
> > > > > On Tue, Jul 27, 2021 at 06:07:35PM +0000, Sean Christopherson wrote:
> > > > > > On Wed, Jul 28, 2021, Yu Zhang wrote:
> > > > > > > Hi all,
> > > > > > >
> > > > > > >   I'd like to ask a question about kvm_reset_context(): is there any
> > > > > > >   reason that we must alway unload TDP root in kvm_mmu_reset_context()?
> > >
> > > I just realized I sent my response to Yu yesterday without reply-all.
> > > Sending it again here for posterity. I'll add comments on the
> > > discussion inline below too.
> >
> > Thanks Ben, I copied my reply here. With some gramar fixes. :)
> >
> > >
> > > Hi Yu,
> > >
> > > I think the short answer here is no, there's no reason we can't keep
> > > the root around for later.
> > >
> > > When developing the TDP MMU, we were primarily concerned about
> > > performance post-boot, especially during migration or when
> > > re-populating memory for demand paging. In these scenarios the guest
> > > role doesn't really change and so the TDP MMU's shadow page tables
> > > aren't torn down. In my initial testing, I thought I only ever
> > > observed two TDP MMU roots be allocated over the life of the VM, but I
> > > could be wrong.
> >
> > Well I observed more, may be because I am using OVMF? Note, the vCPU
> > number is just one in my test.
> 
> Having just one vCPU is likely to lead to more thrash, but I'm
> guessing a lot of these transitions happen before the guest starts
> using multiple vCPUs anyway.
> 
> >
> > >
> > > For the TDP MMU root to be torn down, there also has to be no vCPU
> > > using it. This probably happens in transitions to SMM and guest root
> > > level changes, but I suspected that there would usually be at least
> > > one vCPU in some "normal" mode, post boot. That may have been an
> > > incorrect assumption.
> > >
> > > I think the easiest solution to this would be to just have the TDP MMU
> > > roots track the life of the VM by adding an extra increment to their
> > > reference count on allocation and an extra decrement when the VM is
> > > torn down. However this introduces a problem because it increases the
> > > amount of memory the TDP MMU is likely to be using for its page
> > > tables. (It could use the memory either way but it would require some
> > > surprising guest behavior.)
> >
> > So your suggestion is, once allocated, do not free the root page until
> > the VM is destroyed?
> 
> Yeah, this wouldn't be a great solution for a production setting but
> if you just want to quantify the impact of teardown it's an easy hack.
> 
> >
> > >
> > > I have a few questions about these unnecessary tear-downs during boot:
> > > 1. How many teardowns did you observe, and how many different roles
> > > did they represent? Just thrashing between two roles, or 12 different
> > > roles?
> >
> > I saw 106 reloadings of the root TDP. Among them, 14 are caused by memslot
> > changes. Remaining ones are caused by the context reset from CR0/CR4/EFER
> > changes(85 for CR0 changes). And I believe most are using the same roles,
> > because in legacy TDP, only 4 different TDP roots are allocated due to the
> > context reset(and several more are caused by memslot updating). But in TDP
> > MMU, that means 106 times of TDP root being torn down and reallocated.
> >
> > > 2. When the TDP MMU's page tables got torn down, how much memory did
> > > they map / how big were they?
> >
> > I did not collect this in TDP MMU, but I once tried with legacy TDP. IIRC,
> > there are only several SPs allocated in one TDP table when the context resets.
> 
> Ooof that's a lot of resets, though if there are only a handful of
> pages mapped, it might not be a noticeable performance impact. I think
> it'd be worth collecting some performance data to quantify the impact.

Yes. Too many reset will definitely hurt the performance, though I did not see
obvious delay.

> 
> >
> > > 3. If you hacked in the extra refcount increment I suggested above,
> > > how much of a difference in boot time does it make?
> >
> > I have not tried this, but I think that proposal is let TDP MMU try to
> > reuse previous root page with same mmu role with current context, just
> > like the legacy TDP does?
> 
> Yeah, exactly. The TDP MMU is actually already designed to do this,
> but it depends on another vCPU keeping the root's refcount elevated to
> keep the root around.
> 
> >
> > Actually I am curious, why would the root needs to be unloaded at all(even
> > in the legacy TDP code)? Sean's reply mentioned that change of the mmu role
> > is the reason, but I do not understand yet.
> 
> Will follow up on this below.
> 
> >
> > >
> > > For 2 and 3 I ask because if the guest hasn't accessed much of it's
> > > memory early in boot, the paging structure won't be very large and
> > > tearing it down / rebuilding it is pretty cheap.
> >
> > Agree. But I am a bit surprised to see so many CR0 changes in the boot time.
> >
> > >
> > > We may find that we need some kind of page quota for the TDP MMU after
> > > all, if we want to have a bunch of roots at the same time. If that's
> > > the case, perhaps we should spawn another email thread to discuss how
> > > that should work.
> >
> > Could we find a way to obviate the requirement of unloading(if unnecessary)?
> 
> Could you be more specific about what you mean by unloading? Do you
> mean just not using the current paging structure for a bit or tearing
> down the whole paging structure?

I meant just not using the current paging structure. Tearing down the whole TDP
can be avoided, by adding some account for the root SP(which may need some quota).
But if we can avoid the unnecessary unloading for both legacy TDP and TDP MMU, we
can solve this once and for all. :)

B.R.
Yu

