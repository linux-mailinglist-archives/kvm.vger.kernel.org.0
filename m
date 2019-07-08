Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B25629B5
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 21:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731542AbfGHTgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 15:36:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:11227 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727163AbfGHTgf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 15:36:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 12:36:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,466,1557212400"; 
   d="scan'208";a="167208212"
Received: from ynam-mobl1.amr.corp.intel.com (HELO [10.251.9.168]) ([10.251.9.168])
  by fmsmga007.fm.intel.com with ESMTP; 08 Jul 2019 12:36:33 -0700
Subject: Re: [PATCH v1 5/6] mm: Add logic for separating "aerated" pages from
 "raw" pages
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>, nitesh@redhat.com,
        kvm@vger.kernel.org, david@redhat.com, mst@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com
References: <20190619222922.1231.27432.stgit@localhost.localdomain>
 <20190619223331.1231.39271.stgit@localhost.localdomain>
 <f704f160-49fb-2fdf-e8ac-44b47245a75c@intel.com>
 <66a43ec2912265ff7f1a16e0cf5258d5c3c61de5.camel@linux.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Openpgp: preference=signencrypt
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
Message-ID: <a73eac6b-7fce-7a0d-46ab-1a7aa10dfe08@intel.com>
Date:   Mon, 8 Jul 2019 12:36:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <66a43ec2912265ff7f1a16e0cf5258d5c3c61de5.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/8/19 12:02 PM, Alexander Duyck wrote:
> On Tue, 2019-06-25 at 13:24 -0700, Dave Hansen wrote:
>> I also don't see what the boundary has to do with aerated pages being on
>> the tail of the list.  If you want them on the tail, you just always
>> list_add_tail() them.
> 
> The issue is that there are multiple things that can add to the tail of
> the list. For example the shuffle code or the lower order buddy expecting
> its buddy to be freed. In those cases I don't want to add to tail so
> instead I am adding those to the boundary. By doing that I can avoid
> having the tail of the list becoming interleaved with raw and aerated
> pages.

So, it sounds like we've got the following data structure rules:

1. We have one list_head and one list of pages
2. For the purposes of allocation, the list is treated the same as
   before these patches
3. For a "free()", the behavior changes and we now have two "tails":
   3a. Aerated pages are freed into the tail of the list
   3b. Cold pages are freed at the boundary between aerated and non.
       This serves to...  This is also referred to as a "tail".
   3a. Hot pages are never aerated and are still freed into the head
       of the list.

Did I miss any?  Could you please spell it out this way in future
changelogs?


>>> +struct list_head *__aerator_get_tail(unsigned int order, int migratetype);
>>>  static inline struct list_head *aerator_get_tail(struct zone *zone,
>>>  						 unsigned int order,
>>>  						 int migratetype)
>>>  {
>>> +#ifdef CONFIG_AERATION
>>> +	if (order >= AERATOR_MIN_ORDER &&
>>> +	    test_bit(ZONE_AERATION_ACTIVE, &zone->flags))
>>> +		return __aerator_get_tail(order, migratetype);
>>> +#endif
>>>  	return &zone->free_area[order].free_list[migratetype];
>>>  }
>>
>> Logically, I have no idea what this is doing.  "Go get pages out of the
>> aerated list?"  "raw list"?  Needs comments.
> 
> I'll add comments. Really now that I think about it I should probably
> change the name for this anyway. What is really being returned is the tail
> for the non-aerated list. Specifically if ZONE_AERATION_ACTIVE is set we
> want to prevent any insertions below the list of aerated pages, so we are
> returning the first entry in the aerated list and using that as the
> tail/head of a list tail insertion.
> 
> Ugh. I really need to go back and name this better.

OK, so we now have two tails?  One that's called both a boundary and a
tail at different parts of the code?

>>>  static inline void aerator_notify_free(struct zone *zone, int order)
>>>  {
>>> +#ifdef CONFIG_AERATION
>>> +	if (!static_key_false(&aerator_notify_enabled))
>>> +		return;
>>> +	if (order < AERATOR_MIN_ORDER)
>>> +		return;
>>> +	if (test_bit(ZONE_AERATION_REQUESTED, &zone->flags))
>>> +		return;
>>> +	if (aerator_raw_pages(&zone->free_area[order]) < AERATOR_HWM)
>>> +		return;
>>> +
>>> +	__aerator_notify(zone);
>>> +#endif
>>>  }
>>
>> Again, this is really hard to review.  I see some possible overhead in a
>> fast path here, but only if aerator_notify_free() is called in a fast
>> path.  Is it?  I have to go digging in the previous patches to figure
>> that out.
> 
> This is called at the end of __free_one_page().
> 
> I tried to limit the impact as much as possible by ordering the checks the
> way I did. The order check should limit the impact pretty significantly as
> that is the only one that will be triggered for every page, then the
> higher order pages are left to deal with the test_bit and
> aerator_raw_pages checks.

That sounds like a good idea.  But, that good idea is very hard to
distill from the code in the patch.

Imagine if the function stared being commented with:

/* Called from a hot path in __free_one_page() */

And said:


	if (!static_key_false(&aerator_notify_enabled))
		return;

	/* Avoid (slow) notifications when no aeration is performed: */
	if (order < AERATOR_MIN_ORDER)
		return;
	if (test_bit(ZONE_AERATION_REQUESTED, &zone->flags))
		return;

	/* Some other relevant comment: */
	if (aerator_raw_pages(&zone->free_area[order]) < AERATOR_HWM)
		return;

	/* This is slow, but should happen very rarely: */
	__aerator_notify(zone);

>>> +static void aerator_populate_boundaries(struct zone *zone)
>>> +{
>>> +	unsigned int order, mt;
>>> +
>>> +	if (test_bit(ZONE_AERATION_ACTIVE, &zone->flags))
>>> +		return;
>>> +
>>> +	for_each_aerate_migratetype_order(order, mt)
>>> +		aerator_reset_boundary(zone, order, mt);
>>> +
>>> +	set_bit(ZONE_AERATION_ACTIVE, &zone->flags);
>>> +}
>>
>> This function appears misnamed as it's doing more than boundary
>> manipulation.
> 
> The ZONE_AERATION_ACTIVE flag is what is used to indicate that the
> boundaries are being tracked. Without that we just fall back to using the
> free_list tail.

Is the flag used for other things?  Or just to indicate that boundaries
are being tracked?

>>> +struct list_head *__aerator_get_tail(unsigned int order, int migratetype)
>>> +{
>>> +	return boundary[order - AERATOR_MIN_ORDER][migratetype];
>>> +}
>>> +
>>> +void __aerator_del_from_boundary(struct page *page, struct zone *zone)
>>> +{
>>> +	unsigned int order = page_private(page) - AERATOR_MIN_ORDER;
>>> +	int mt = get_pcppage_migratetype(page);
>>> +	struct list_head **tail = &boundary[order][mt];
>>> +
>>> +	if (*tail == &page->lru)
>>> +		*tail = page->lru.next;
>>> +}
>>
>> Ewww.  Please just track the page that's the boundary, not the list head
>> inside the page that's the boundary.
>>
>> This also at least needs one comment along the lines of: Move the
>> boundary if the page representing the boundary is being removed.
> 
> So the reason for using the list_head is because we can end up with a
> boundary for an empty list. In that case we don't have a page to point to
> but just the list_head for the list itself. It actually makes things quite
> a bit simpler, otherwise I have to perform extra checks to see if the list
> is empty.

Could you please double-check that keeping a 'struct page *' is truly
more messy?

>>> +void aerator_add_to_boundary(struct page *page, struct zone *zone)
>>> +{
>>> +	unsigned int order = page_private(page) - AERATOR_MIN_ORDER;
>>> +	int mt = get_pcppage_migratetype(page);
>>> +	struct list_head **tail = &boundary[order][mt];
>>> +
>>> +	*tail = &page->lru;
>>> +}
>>> +
>>> +void aerator_shutdown(void)
>>> +{
>>> +	static_key_slow_dec(&aerator_notify_enabled);
>>> +
>>> +	while (atomic_read(&a_dev_info->refcnt))
>>> +		msleep(20);
>>
>> We generally frown on open-coded check/sleep loops.  What is this for?
> 
> We are waiting on the aerator to finish processing the list it had active.
> With the static key disabled we should see the refcount wind down to 0.
> Once that occurs we can safely free the a_dev_info structure since there
> will be no other uses of it.

That's fine, but we still don't open-code sleep loops.  Please remove this.

"Wait until we can free the thing" sounds to me like RCU.  Do you want
to use RCU here?  A synchronize_rcu() call can be a very powerful thing
if the read-side critical sections are amenable to it.

>>> +static void aerator_schedule_initial_aeration(void)
>>> +{
>>> +	struct zone *zone;
>>> +
>>> +	for_each_populated_zone(zone) {
>>> +		spin_lock(&zone->lock);
>>> +		__aerator_notify(zone);
>>> +		spin_unlock(&zone->lock);
>>> +	}
>>> +}
>>
>> Why do we need an initial aeration?
> 
> This is mostly about avoiding any possible races while we are brining up
> the aerator. If we assume we are just going to start a cycle of aeration
> for all zones when the aerator is brought up it makes it easier to be sure
> we have gone though and checked all of the zones after initialization is
> complete.

Let me ask a different way:  What will happen if we don't have this?
Will things crash?  Will they be slow?  Do we not know?

>>> +{
>>> +	struct list_head *batch = &a_dev_info->batch;
>>> +	int budget = a_dev_info->capacity;
>>
>> Where does capacity come from?
> 
> It is the limit on how many pages we can process at a time. The value is
> set in a_dev_info before the call to aerator_startup.

Let me ask another way: Does it come from the user?  Or is it
automatically determined by some in-kernel heuristic?

>>> +		while ((page = get_aeration_page(zone, order, mt))) {
>>> +			list_add_tail(&page->lru, batch);
>>> +
>>> +			if (!--budget)
>>> +				return;
>>> +		}
>>> +	}
>>> +
>>> +	/*
>>> +	 * If there are no longer enough free pages to fully populate
>>> +	 * the aerator, then we can just shut it down for this zone.
>>> +	 */
>>> +	clear_bit(ZONE_AERATION_REQUESTED, &zone->flags);
>>> +	atomic_dec(&a_dev_info->refcnt);
>>> +}
>>
>> Huh, so this is the number of threads doing aeration?  Didn't we just
>> make a big deal about there only being one zone being aerated at a time?
>>  Or, did I misunderstand what refcnt is from its lack of clear
>> documentation?
> 
> The refcnt is the number of zones requesting aeration plus one additional
> if the thread is active. We are limited to only having pages from one zone
> in the aerator at a time. That is to prevent us from having to maintain
> multiple boundaries.

That sounds like excellent documentation to add to 'refcnt's definition.

>>> +static void aerator_drain(struct zone *zone)
>>> +{
>>> +	struct list_head *list = &a_dev_info->batch;
>>> +	struct page *page;
>>> +
>>> +	/*
>>> +	 * Drain the now aerated pages back into their respective
>>> +	 * free lists/areas.
>>> +	 */
>>> +	while ((page = list_first_entry_or_null(list, struct page, lru))) {
>>> +		list_del(&page->lru);
>>> +		put_aeration_page(zone, page);
>>> +	}
>>> +}
>>> +
>>> +static void aerator_scrub_zone(struct zone *zone)
>>> +{
>>> +	/* See if there are any pages to pull */
>>> +	if (!test_bit(ZONE_AERATION_REQUESTED, &zone->flags))
>>> +		return;
>>
>> How would someone ask for the zone to be scrubbed when aeration has not
>> been requested?
> 
> I'm not sure what you are asking here. Basically this function is called
> per zone by aerator_cycle. Which now that I think about it I should
> probably swap the names around that we perform a cycle per zone and just
> scrub memory generically.

It looks like aerator_cycle() calls aerator_scrub_zone() on all zones
all the time.  This is the code responsible for ensuring that we don't
do any aeration work on zones that do not need it.

