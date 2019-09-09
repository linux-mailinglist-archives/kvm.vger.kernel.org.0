Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61478ADBE4
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 17:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbfIIPMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 11:12:14 -0400
Received: from mga06.intel.com ([134.134.136.31]:38457 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbfIIPMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 11:12:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 08:12:12 -0700
X-IronPort-AV: E=Sophos;i="5.64,486,1559545200"; 
   d="scan'208";a="335622307"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 08:12:12 -0700
Message-ID: <f2fc0cda183098aa9b3b071ff0f49249f6d94bd5.camel@linux.intel.com>
Subject: Re: [PATCH v9 1/8] mm: Add per-cpu logic to page shuffling
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, catalin.marinas@arm.com, david@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, osalvador@suse.de,
        yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        ying.huang@intel.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, fengguang.wu@intel.com,
        kirill.shutemov@linux.intel.com
Date:   Mon, 09 Sep 2019 08:12:12 -0700
In-Reply-To: <20190909090701.7ebz4foxyu3rxzvc@box>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
         <20190907172512.10910.74435.stgit@localhost.localdomain>
         <20190909090701.7ebz4foxyu3rxzvc@box>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2019-09-09 at 12:07 +0300, Kirill A. Shutemov wrote:
> On Sat, Sep 07, 2019 at 10:25:12AM -0700, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > 
> > Change the logic used to generate randomness in the suffle path so that we
> 
> Typo.
> 
> > can avoid cache line bouncing. The previous logic was sharing the offset
> > and entropy word between all CPUs. As such this can result in cache line
> > bouncing and will ultimately hurt performance when enabled.
> > 
> > To resolve this I have moved to a per-cpu logic for maintaining a unsigned
> > long containing some amount of bits, and an offset value for which bit we
> > can use for entropy with each call.
> > 
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > ---
> >  mm/shuffle.c |   33 +++++++++++++++++++++++----------
> >  1 file changed, 23 insertions(+), 10 deletions(-)
> > 
> > diff --git a/mm/shuffle.c b/mm/shuffle.c
> > index 3ce12481b1dc..9ba542ecf335 100644
> > --- a/mm/shuffle.c
> > +++ b/mm/shuffle.c
> > @@ -183,25 +183,38 @@ void __meminit __shuffle_free_memory(pg_data_t *pgdat)
> >  		shuffle_zone(z);
> >  }
> >  
> > +struct batched_bit_entropy {
> > +	unsigned long entropy_bool;
> > +	int position;
> > +};
> > +
> > +static DEFINE_PER_CPU(struct batched_bit_entropy, batched_entropy_bool);
> > +
> >  void add_to_free_area_random(struct page *page, struct free_area *area,
> >  		int migratetype)
> >  {
> > -	static u64 rand;
> > -	static u8 rand_bits;
> > +	struct batched_bit_entropy *batch;
> > +	unsigned long entropy;
> > +	int position;
> >  
> >  	/*
> > -	 * The lack of locking is deliberate. If 2 threads race to
> > -	 * update the rand state it just adds to the entropy.
> > +	 * We shouldn't need to disable IRQs as the only caller is
> > +	 * __free_one_page and it should only be called with the zone lock
> > +	 * held and either from IRQ context or with local IRQs disabled.
> >  	 */
> > -	if (rand_bits == 0) {
> > -		rand_bits = 64;
> > -		rand = get_random_u64();
> > +	batch = raw_cpu_ptr(&batched_entropy_bool);
> > +	position = batch->position;
> > +
> > +	if (--position < 0) {
> > +		batch->entropy_bool = get_random_long();
> > +		position = BITS_PER_LONG - 1;
> >  	}
> >  
> > -	if (rand & 1)
> > +	batch->position = position;
> > +	entropy = batch->entropy_bool;
> > +
> > +	if (1ul & (entropy >> position))
> 
> Maybe something like this would be more readble:
> 
> 	if (entropy & BIT(position))
> 
> >  		add_to_free_area(page, area, migratetype);
> >  	else
> >  		add_to_free_area_tail(page, area, migratetype);
> > -	rand_bits--;
> > -	rand >>= 1;
> >  }
> > 
> > 

Thanks for the review. I will update these two items for v10.

- Alex

