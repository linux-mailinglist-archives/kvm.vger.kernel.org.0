Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F4018DB48
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgCTWkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:40:43 -0400
Received: from mga18.intel.com ([134.134.136.126]:39389 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgCTWkm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 18:40:42 -0400
IronPort-SDR: kH4iqVVYDt6+SS39nW8uFDshNbmpVDCXtVBmE2sPGrMOsWikQgMDr9rzyzws6q4jckN+9s9Duf
 99Pv+Ds9TIQg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 15:40:41 -0700
IronPort-SDR: pyLLTZi2gIvKDVwpeObT3yARmB1LpSwiUyS7YsjM6UsmLLLB7zHgQgvKKuu+Ms0OtUaA2gjW2F
 VgogiJExqp3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="239357468"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 20 Mar 2020 15:40:41 -0700
Date:   Fri, 20 Mar 2020 15:40:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: Re: [PATCH 1/7] KVM: Fix out of range accesses to memslots
Message-ID: <20200320224041.GB3866@linux.intel.com>
References: <20200320205546.2396-1-sean.j.christopherson@intel.com>
 <20200320205546.2396-2-sean.j.christopherson@intel.com>
 <20200320221708.GF127076@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200320221708.GF127076@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 20, 2020 at 06:17:08PM -0400, Peter Xu wrote:
> On Fri, Mar 20, 2020 at 01:55:40PM -0700, Sean Christopherson wrote:
> > Reset the LRU slot if it becomes invalid when deleting a memslot to fix
> > an out-of-bounds/use-after-free access when searching through memslots.
> > 
> > Explicitly check for there being no used slots in search_memslots(), and
> > in the caller of s390's approximation variant.
> > 
> > Fixes: 36947254e5f9 ("KVM: Dynamically size memslot array based on number of used slots")
> > Reported-by: Qian Cai <cai@lca.pw>
> > Cc: Peter Xu <peterx@redhat.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/s390/kvm/kvm-s390.c | 3 +++
> >  include/linux/kvm_host.h | 3 +++
> >  virt/kvm/kvm_main.c      | 3 +++
> >  3 files changed, 9 insertions(+)
> > 
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index 807ed6d722dd..cb15fdda1fee 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -2002,6 +2002,9 @@ static int kvm_s390_get_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
> >  	struct kvm_memslots *slots = kvm_memslots(kvm);
> >  	struct kvm_memory_slot *ms;
> >  
> > +	if (unlikely(!slots->used_slots))
> > +		return 0;
> > +
> >  	cur_gfn = kvm_s390_next_dirty_cmma(slots, args->start_gfn);
> >  	ms = gfn_to_memslot(kvm, cur_gfn);
> >  	args->count = 0;
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 35bc52e187a2..b19dee4ed7d9 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1032,6 +1032,9 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn)
> >  	int slot = atomic_read(&slots->lru_slot);
> >  	struct kvm_memory_slot *memslots = slots->memslots;
> >  
> > +	if (unlikely(!slots->used_slots))
> > +		return NULL;
> > +
> >  	if (gfn >= memslots[slot].base_gfn &&
> >  	    gfn < memslots[slot].base_gfn + memslots[slot].npages)
> >  		return &memslots[slot];
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 28eae681859f..f744bc603c53 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -882,6 +882,9 @@ static inline void kvm_memslot_delete(struct kvm_memslots *slots,
> >  
> >  	slots->used_slots--;
> >  
> > +	if (atomic_read(&slots->lru_slot) >= slots->used_slots)
> > +		atomic_set(&slots->lru_slot, 0);
> 
> Nit: could we drop the atomic ops?  The "slots" is still only used in
> the current thread before the rcu assignment, so iirc it's fine (and
> RCU assignment should have a mem barrier when needed anyway).

No, atomic_t wraps an int inside a struct to prevent direct usage, e.g.

virt/kvm/kvm_main.c: In function ‘kvm_memslot_delete’:
virt/kvm/kvm_main.c:885:22: error: invalid operands to binary >= (have ‘atomic_t {aka struct <anonymous>}’ and ‘int’)
  if (slots->lru_slot >= slots->used_slots)
                      ^
virt/kvm/kvm_main.c:886:19: error: incompatible types when assigning to type ‘atomic_t {aka struct <anonymous>}’ from type ‘int’
   slots->lru_slot = 0;


Buy yeah, the compiler barrier associated with atomic_read() isn't
necessary.

> I thought resetting lru_slot to zero would be good enough when
> duplicating the slots... however if we want to do finer grained reset,
> maybe even better to reset also those invalidated ones (since we know
> this information)?
> 
>    	if (slots->lru_slot >= slots->id_to_index[memslot->id])
>    		slots->lru_slot = 0;

I'd prefer to go with the more obviously correct version.  This code will
rarely trigger, e.g. larger slots have lower indices and are more likely to
be the LRU (by virtue of being the biggest), and dynamic memslot deletion
is usually for relatively small ranges that are being remapped by the guest.

> Thanks,
> 
> > +
> >  	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots; i++) {
> >  		mslots[i] = mslots[i + 1];
> >  		slots->id_to_index[mslots[i].id] = i;
> > -- 
> > 2.24.1
> > 
> 
> -- 
> Peter Xu
> 
