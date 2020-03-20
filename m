Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B76418DB7E
	for <lists+kvm@lfdr.de>; Sat, 21 Mar 2020 00:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbgCTXIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 19:08:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:27376 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbgCTXH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 19:07:59 -0400
IronPort-SDR: I+AQGVERzFSy+qilyyhu/KMMQDmcJpUY/a1mZloSmQJvY/9EiU/XFCTD+j8mEoMLr2wTKSG2J/
 EWyv05OxlPQA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 16:07:59 -0700
IronPort-SDR: LU95IsHGJJyqn4kA6wEBUyYA9ONo3x2Gm+6Ul+T+H68nK64sJKq6PjQzzvg/mk4uT4QPVOSHmA
 VsEWcRS5D2fA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="249025235"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 20 Mar 2020 16:07:58 -0700
Date:   Fri, 20 Mar 2020 16:07:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: Re: [PATCH 1/7] KVM: Fix out of range accesses to memslots
Message-ID: <20200320230758.GA8418@linux.intel.com>
References: <20200320205546.2396-1-sean.j.christopherson@intel.com>
 <20200320205546.2396-2-sean.j.christopherson@intel.com>
 <20200320221708.GF127076@xz-x1>
 <20200320224041.GB3866@linux.intel.com>
 <20200320225802.GH127076@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320225802.GH127076@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 20, 2020 at 06:58:02PM -0400, Peter Xu wrote:
> On Fri, Mar 20, 2020 at 03:40:41PM -0700, Sean Christopherson wrote:
 > > I thought resetting lru_slot to zero would be good enough when
> > > duplicating the slots... however if we want to do finer grained reset,
> > > maybe even better to reset also those invalidated ones (since we know
> > > this information)?
> > > 
> > >    	if (slots->lru_slot >= slots->id_to_index[memslot->id])
> > >    		slots->lru_slot = 0;
> > 
> > I'd prefer to go with the more obviously correct version.  This code will
> > rarely trigger, e.g. larger slots have lower indices and are more likely to
> > be the LRU (by virtue of being the biggest), and dynamic memslot deletion
> > is usually for relatively small ranges that are being remapped by the guest.
> 
> IMHO the more obvious correct version could be unconditionally setting
> lru_slot to something invalid (e.g. -1) in kvm_dup_memslots(), then in
> the two search_memslots() skip the cache if lru_slot is invalid.
> That's IMHO easier to understand than the "!slots->used_slots" checks.
> But I've no strong opinion.

We'd still need the !slots->used_slots check.  I considered adding an
explicit check on @slot for the cache lookup, e.g.

static inline struct kvm_memory_slot *
search_memslots(struct kvm_memslots *slots, gfn_t gfn)
{
	int start = 0, end = slots->used_slots;
	int slot = atomic_read(&slots->lru_slot);
	struct kvm_memory_slot *memslots = slots->memslots;

	if (likely(slot < slots->used_slots) &&
	    gfn >= memslots[slot].base_gfn &&
	    gfn < memslots[slot].base_gfn + memslots[slot].npages)
		return &memslots[slot];


But then the back half of the function still ends up with an out-of-bounds
bug.  E.g. if used_slots == 0, then start==0, and memslots[start].base_gfn
accesses garbage.

	while (start < end) {
		slot = start + (end - start) / 2;

		if (gfn >= memslots[slot].base_gfn)
			end = slot;
		else
			start = slot + 1;
	}

	if (gfn >= memslots[start].base_gfn &&
	    gfn < memslots[start].base_gfn + memslots[start].npages) {
		atomic_set(&slots->lru_slot, start);
		return &memslots[start];
	}

	return NULL;
}

I also didn't want to invalidate the lru_slot any more than is necessary,
not that I'd expect it to make a noticeable difference even in a
pathalogical scenario, but it seemed prudent.
