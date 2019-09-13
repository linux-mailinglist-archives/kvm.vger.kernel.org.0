Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77C50B253A
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 20:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389794AbfIMSam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 14:30:42 -0400
Received: from mga03.intel.com ([134.134.136.65]:62063 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389005AbfIMSal (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 14:30:41 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Sep 2019 11:30:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="190389839"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 13 Sep 2019 11:30:40 -0700
Date:   Fri, 13 Sep 2019 11:30:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Orr <marcorr@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nvmx: test max atomic switch MSRs
Message-ID: <20190913183040.GA8904@linux.intel.com>
References: <20190912180928.123660-1-marcorr@google.com>
 <20190913152442.GC31125@linux.intel.com>
 <CAA03e5F3SNxcYxdeOg6ZUfxRA5gBe7qaMxSATL13sq1cUL63KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA03e5F3SNxcYxdeOg6ZUfxRA5gBe7qaMxSATL13sq1cUL63KQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 13, 2019 at 11:02:39AM -0700, Marc Orr wrote:
> > > +static void *alloc_2m_page(void)
> > > +{
> > > +     return alloc_pages(PAGE_2M_ORDER);
> > > +}
> >
> > Allocating 2mb pages is complete overkill.  The absolute theoretical max
> > for the number of MSRs is (8 * 512) = 4096, for a total of 32kb per list.
> > We can even show the math so that it's obvious how the size is calculated.
> > Plus one order so we can test overrun.
> > /*
> >  * The max number of MSRs is specified in 3 bits bits, plus 1. I.e. 7+1==8.
> >  * Allocate 64k bytes of data to cover max_msr_list_size and then some.
> >  */
> > static const u32 msr_list_page_order = 4;
> 
> 8 * 512 should be 16 * 512, right [1]? Therefore, the maximum
> theoretical is 64 kB.

*sigh*  I stand by my assertion that "Math is hard".  :-)

> I'll happily apply what you've suggested in v2. But I don't see why
> it's so terrible to over-allocate here. Leveraging a generic 2 MB page
> allocator can be reused going forward, and encourages uniformity
> across tests.

My main concern is avoiding setting 6mb+ of memory.  I like to run the
tests in L1 and L2 and would prefer to keep overhead at a minimum.

As for the allocation itself, being precise in the allocation size is a
form of documentation, e.g. it conveys that the size/order was chosen to
ensure enough space for the maximum theoretical list size.  A purely
arbitrary size, especially one that corresponds with a large page size,
can lead to people looking for things that don't exist, e.g. the 2mb size
is partially what led me to believe that this test was deliberately
exceeding the limit, otherwise why allocate such a large amount of memory?
I also didn't know if 2mb was sufficient to handle the maximum theoretical
list size.

> [1]
> struct vmx_msr_entry {
>   u32 index;
>   u32 reserved;
>   u64 value;
> } __aligned(16);
> 
> > > +static void populate_msr_list(struct vmx_msr_entry *msr_list, int count)
> > > +{
> > > +     int i;
> > > +
> > > +     for (i = 0; i < count; i++) {
> > > +             msr_list[i].index = MSR_IA32_TSC;
> > > +             msr_list[i].reserved = 0;
> > > +             msr_list[i].value = 0x1234567890abcdef;
> >
> > Maybe overkill, but we can use a fast string op for this.  I think
> > I got the union right?
> >
> > static void populate_msr_list(struct vmx_msr_entry *msr_list, int count)
> > {
> >         union {
> >                 struct vmx_msr_entry msr;
> >                 u64 val;
> >         } tmp;
> >
> >         tmp.msr.index = MSR_IA32_TSC;
> >         tmp.msr.reserved = 0;
> >         tmp.msr.value = 0x1234567890abcdef;
> >
> >         asm volatile (
> >                 "rep stosq\n\t"
> >                 : "=c"(count), "=D"(msr_list)
> >                 : "a"(tmp.val), "c"(count), "D"(msr_list)
> >                 : "memory"
> >         );
> > }
> 
> :-). I do think it's overkill. However, I'm OK to apply this
> suggestion in v2 if everyone is OK with me adding a comment that
> explains it in terms of the original code, so that x86 noobs, like
> myself, can understand what's going on.

Never mind, I can't count.  This only works if the size of the entry
is 8 bytes.

> > This is a misleading name, e.g. it took me quite a while to realize this
> > is testing only the passing scenario.  For me, "limit test" implies that
> > it'd be deliberately exceeding the limit, or at least testing both the
> > passing and failing cases.  I suppose we can't easily test the VMX abort
> > cases, but we can at least test VM_ENTER_LOAD.
> >
> > Distilling things down to the bare minimum yields something like the
> > following.
> 
> Looks excellent overall. Still not clear what the consensus is on
> whether or not to test the VM-entry failure. I think a flag seems like
> a reasonable compromise. I've never added a flag to a kvm-unit-test,
> so I'll see if I can figure that out.

No need for a flag if you want to go that route, just put it in a separate
VMX subtest and exclude said test from the [vmx] config, i.e. make the
test opt-in.
