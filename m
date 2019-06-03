Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D93133339A
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 17:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfFCPeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 11:34:01 -0400
Received: from mga04.intel.com ([192.55.52.120]:47247 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbfFCPeA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 11:34:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jun 2019 08:34:00 -0700
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jun 2019 08:33:59 -0700
Message-ID: <f510f69ec5744e80fc612ae06a35b49d56cf2c80.camel@linux.intel.com>
Subject: Re: [RFC PATCH 00/11] mm / virtio: Provide support for paravirtual
 waste page treatment
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>, nitesh@redhat.com,
        kvm@vger.kernel.org, mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com
Date:   Mon, 03 Jun 2019 08:33:59 -0700
In-Reply-To: <09c42bc7-ddc7-6b34-44d8-ffb5e63c7c6f@redhat.com>
References: <20190530215223.13974.22445.stgit@localhost.localdomain>
         <09c42bc7-ddc7-6b34-44d8-ffb5e63c7c6f@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2019-06-03 at 11:31 +0200, David Hildenbrand wrote:
> On 30.05.19 23:53, Alexander Duyck wrote:
> > This series provides an asynchronous means of hinting to a hypervisor
> > that a guest page is no longer in use and can have the data associated
> > with it dropped. To do this I have implemented functionality that allows
> > for what I am referring to as "waste page treatment".
> > 
> > I have based many of the terms and functionality off of waste water
> > treatment, the idea for the similarity occured to me after I had reached
> > the point of referring to the hints as "bubbles", as the hints used the
> > same approach as the balloon functionality but would disappear if they
> > were touched, as a result I started to think of the virtio device as an
> > aerator. The general idea with all of this is that the guest should be
> > treating the unused pages so that when they end up heading "downstream"
> > to either another guest, or back at the host they will not need to be
> > written to swap.
> > 
> > So for a bit of background for the treatment process, it is based on a
> > sequencing batch reactor (SBR)[1]. The treatment process itself has five
> > stages. The first stage is the fill, with this we take the raw pages and
> > add them to the reactor. The second stage is react, in this stage we hand
> > the pages off to the Virtio Balloon driver to have hints attached to them
> > and for those hints to be sent to the hypervisor. The third stage is
> > settle, in this stage we are waiting for the hypervisor to process the
> > pages, and we should receive an interrupt when it is completed. The fourth
> > stage is to decant, or drain the reactor of pages. Finally we have the
> > idle stage which we will go into if the reference count for the reactor
> > gets down to 0 after a drain, or if a fill operation fails to obtain any
> > pages and the reference count has hit 0. Otherwise we return to the first
> > state and start the cycle over again.
> 
> While I like this analogy, I don't like the terminology mixed into
> linux-mm core.
> 
> mm/aeration.c? Bubble? Treated? whut?
> 
> Can you come up with a terminology once can understand without a PHD in
> biology? (if that is even the right field of study, I have no idea)

I had started with the bubble, as I had mentioned before. From there I got
to aerator because of the fact that we were filling the memory with holes.
I figure the first two work pretty well, but I am not really attached to
any of the other terms. As far as the rest of the terminology most of it
is actually chemistry if I am not mistaken. I could probably just swap out
"Treated" with "Aerated" and it would work just as well. I would also need
to get away from the more complex terms such as "decant", but for the most
part that is just a matter of finding the synonyms such as "drain".

> ALSO: isn't the analogy partially wrong? Nobody would be using "waste
> water" just because they are low on "clean water". At least not in my
> city (I hope so ;) ). But maybe I am not getting the whole concept
> because we are dealing with pages we want to hint to the hypervisor and
> not with actual "waste".

Actually the analogy isn't for a low condition. The analogy would be for a
condition where we have an excess of waste water and don't want to contain
it. As such we want to treat it and return it to the water cycle.

As far as the "waste" in the analogy I was thinking more of the page data.
When a page has been used we normally mark it as "Dirty", so I thought it
would be an apt analogy since those dirty pages would have to be written
to long term storage if we didn't do something to invalidate the page
data.

> > This patch set is still far more intrusive then I would really like for
> > what it has to do. Currently I am splitting the nr_free_pages into two
> > values and having to add a pointer and an index to track where we area in
> > the treatment process for a given free_area. I'm also not sure I have
> > covered all possible corner cases where pages can get into the free_area
> > or move from one migratetype to another.
> 
> Yes, it is quite intrusive. Maybe we can minimize the impact/error
> proneness.

My hope by submitting this as an RFC was to get input on what directions I
might need to head in before I went to far down this current path.

> > Also I am still leaving a number of things hard-coded such as limiting the
> > lowest order processed to PAGEBLOCK_ORDER, and have left it up to the
> > guest to determine what size of reactor it wants to allocate to process
> > the hints.
> > 
> > Another consideration I am still debating is if I really want to process
> > the aerator_cycle() function in interrupt context or if I should have it
> > running in a thread somewhere else.
> 
> Did you get to test/benchmark the difference?

I haven't yet.

