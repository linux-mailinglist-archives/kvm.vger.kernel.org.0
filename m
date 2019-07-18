Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7016C89B
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 07:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfGRFON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 01:14:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41268 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbfGRFON (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 01:14:13 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7B71B30655F9;
        Thu, 18 Jul 2019 05:14:12 +0000 (UTC)
Received: from redhat.com (ovpn-120-147.rdu2.redhat.com [10.10.120.147])
        by smtp.corp.redhat.com (Postfix) with SMTP id 00C501001B0C;
        Thu, 18 Jul 2019 05:13:59 +0000 (UTC)
Date:   Thu, 18 Jul 2019 01:13:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Zhang <yang.zhang.wz@gmail.com>, pagupta@redhat.com,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, wei.w.wang@intel.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dan.j.williams@intel.com,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: Re: [PATCH v1 6/6] virtio-balloon: Add support for aerating memory
 via hinting
Message-ID: <20190718003211-mutt-send-email-mst@kernel.org>
References: <20190619222922.1231.27432.stgit@localhost.localdomain>
 <20190619223338.1231.52537.stgit@localhost.localdomain>
 <20190716055017-mutt-send-email-mst@kernel.org>
 <CAKgT0Uc-2k9o7pjtf-GFAgr83c7RM-RTJ8-OrEzFv92uz+MTDw@mail.gmail.com>
 <20190716115535-mutt-send-email-mst@kernel.org>
 <CAKgT0Ud47-cWu9VnAAD_Q2Fjia5gaWCz_L9HUF6PBhbugv6tCQ@mail.gmail.com>
 <20190716125845-mutt-send-email-mst@kernel.org>
 <CAKgT0UfgPdU1H5ZZ7GL7E=_oZNTzTwZN60Q-+2keBxDgQYODfg@mail.gmail.com>
 <20190717055804-mutt-send-email-mst@kernel.org>
 <CAKgT0Uf4iJxEx+3q_Vo9L1QPuv9PhZUv1=M9UCsn6_qs7rG4aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Uf4iJxEx+3q_Vo9L1QPuv9PhZUv1=M9UCsn6_qs7rG4aw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 18 Jul 2019 05:14:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 17, 2019 at 09:43:52AM -0700, Alexander Duyck wrote:
> On Wed, Jul 17, 2019 at 3:28 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Jul 16, 2019 at 02:06:59PM -0700, Alexander Duyck wrote:
> > > On Tue, Jul 16, 2019 at 10:41 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > <snip>
> > >
> > > > > > This is what I am saying. Having watched that patchset being developed,
> > > > > > I think that's simply because processing blocks required mm core
> > > > > > changes, which Wei was not up to pushing through.
> > > > > >
> > > > > >
> > > > > > If we did
> > > > > >
> > > > > >         while (1) {
> > > > > >                 alloc_pages
> > > > > >                 add_buf
> > > > > >                 get_buf
> > > > > >                 free_pages
> > > > > >         }
> > > > > >
> > > > > > We'd end up passing the same page to balloon again and again.
> > > > > >
> > > > > > So we end up reserving lots of memory with alloc_pages instead.
> > > > > >
> > > > > > What I am saying is that now that you are developing
> > > > > > infrastructure to iterate over free pages,
> > > > > > FREE_PAGE_HINT should be able to use it too.
> > > > > > Whether that's possible might be a good indication of
> > > > > > whether the new mm APIs make sense.
> > > > >
> > > > > The problem is the infrastructure as implemented isn't designed to do
> > > > > that. I am pretty certain this interface will have issues with being
> > > > > given small blocks to process at a time.
> > > > >
> > > > > Basically the design for the FREE_PAGE_HINT feature doesn't really
> > > > > have the concept of doing things a bit at a time. It is either
> > > > > filling, stopped, or done. From what I can tell it requires a
> > > > > configuration change for the virtio balloon interface to toggle
> > > > > between those states.
> > > >
> > > > Maybe I misunderstand what you are saying.
> > > >
> > > > Filling state can definitely report things
> > > > a bit at a time. It does not assume that
> > > > all of guest free memory can fit in a VQ.
> > >
> > > I think where you and I may differ is that you are okay with just
> > > pulling pages until you hit OOM, or allocation failures. Do I have
> > > that right?
> >
> > This is exactly what the current code does. But that's an implementation
> > detail which came about because we failed to find any other way to
> > iterate over free blocks.
> 
> I get that. However my concern is that permeated other areas of the
> implementation that make taking another approach much more difficult
> than it needs to be.

Implementation would have to change to use an iterator obviously. But I don't see
that it leaked out to a hypervisor interface.

In fact take a look at virtio_balloon_shrinker_scan
and you will see that it calls shrink_free_pages
without waiting for the device at all.

> > > In my mind I am wanting to perform the hinting on a small
> > > block at a time and work through things iteratively.
> > >
> > > The problem is the FREE_PAGE_HINT doesn't have the option of returning
> > > pages until all pages have been pulled. It is run to completion and
> > > will keep filling the balloon until an allocation fails and the host
> > > says it is done.
> >
> > OK so there are two points. One is that FREE_PAGE_HINT does not
> > need to allocate a page at all. It really just wants to
> > iterate over free pages.
> 
> I agree that it should just want to iterate over pages. However the
> issue I am trying to point out is that it doesn't have any guarantees
> on ordering and that is my concern. What I want to avoid is
> potentially corrupting memory.

I get that. I am just trying to make sure you are aware that for
FREE_PAGE_HINT specifically ordering does not matter because it does not
care when hypervisor used the buffers. It only cares that page was
free after it got the request. used buffers are only tracked to avoid
overflowing the VQ. This is different from your hinting where you make
it the responsibility of the guest to not allocate page before it was
used.

> 
> So for example with my current hinting approach I am using the list of
> hints because I get back one completion indicating all of the hints
> have been processed. It is only at that point that I can go back and
> make the memory available for allocation again.

Right. But just counting them would work just as well, no?
At least as long as you wait for everything to complete...
If you want to pipeline, see below


> 
> So one big issue right now with the FREE_PAGE_HINT approach is that it
> is designed to be all or nothing. Using the balloon makes it
> impossible for us to be incremental as all the pages are contained in
> one spot. What we would need is some way to associate a page with a
> given vq buffer.

Sorry if I'm belaboring the obvious, but isn't this what 'void *data' in
virtqueue_add_inbuf is designed for?  And if you only ever use
virtqueue_add_inbuf and virtqueue_add_outbuf on a given VQ, then you can
track two pointers using virtqueue_add_inbuf_ctx.

> Ultimately in order to really make the FREE_PAGE_HINT
> logic work with something like my page hinting logic it would need to
> work more like a network Rx ring in that we would associate a page per
> buffer and have some way of knowing the two are associated.

Right. That's exactly how virtio net does it btw.

> > The reason FREE_PAGE_HINT does not free up pages until we finished
> > iterating over the free list it not a hypervisor API. The reason is we
> > don't want to keep getting the same address over and over again.
> >
> > > I would prefer to avoid that as I prefer to simply
> > > notify the host of a fixed block of pages at a time and let it process
> > > without having to have a thread on each side actively pushing pages,
> > > or listening for the incoming pages.
> >
> > Right. And FREE_PAGE_HINT can go even further. It can push a page and
> > let linux use it immediately. It does not even need to wait for host to
> > process anything unless the VQ gets full.
> 
> If it is doing what you are saying it will be corrupting memory.

No and that is hypervisor's responsibility.

I think you are missing part of the picture here.

Here is a valid implementation:

Before asking for hints, hypervisor write-protects all memory, and logs
all write faults. When hypervisor gets the hint, if page has since been
modified, the hint is ignored.





> At a
> minimum it has to wait until the page has been processed and the dirty
> bit cleared before it can let linux use it again. It is all a matter
> of keeping the dirty bit coherent. If we let linux use it again
> immediately and then cleared the dirty bit we would open up a possible
> data corruption race during migration as a dirty page might not be
> marked as such.

I think you are talking about the dirty bit on the host, right?

The implication is that calling MADV_FREE from qemu would
not be a good implementation of FREE_PAGE_HINT.
And indeed, as far as I can see it does nothing of the sort.



> > >
> > > > > > > The basic idea with the bubble hinting was to essentially create mini
> > > > > > > balloons. As such I had based the code off of the balloon inflation
> > > > > > > code. The only spot where it really differs is that I needed the
> > > > > > > ability to pass higher order pages so I tweaked thinks and passed
> > > > > > > "hints" instead of "pfns".
> > > > > >
> > > > > > And that is fine. But there isn't really such a big difference with
> > > > > > FREE_PAGE_HINT except FREE_PAGE_HINT triggers upon host request and not
> > > > > > in response to guest load.
> > > > >
> > > > > I disagree, I believe there is a significant difference.
> > > >
> > > > Yes there is, I just don't think it's in the iteration.
> > > > The iteration seems to be useful to hinting.
> > >
> > > I agree that iteration is useful to hinting. The problem is the
> > > FREE_PAGE_HINT code isn't really designed to be iterative. It is
> > > designed to run with a polling thread on each side and it is meant to
> > > be run to completion.
> >
> > Absolutely. But that's a bug I think.
> 
> I think it is a part of the design. Basically in order to avoid
> corrupting memory it cannot return the page to the guest kernel until
> it has finished clearing the dirty bits associated with the pages.

OK I hope I clarified by that's not supposed to be the case.

> > > > > The
> > > > > FREE_PAGE_HINT code was implemented to be more of a streaming
> > > > > interface.
> > > >
> > > > It's implemented like this but it does not follow from
> > > > the interface. The implementation is a combination of
> > > > attempts to minimize # of exits and minimize mm core changes.
> > >
> > > The problem is the interface doesn't have a good way of indicating
> > > that it is done with a block of pages.
> > >
> > > So what I am probably looking at if I do a sg implementation for my
> > > hinting is to provide one large sg block for all 32 of the pages I
> > > might be holding.
> >
> > Right now if you pass an sg it will try to allocate a buffer
> > on demand for you. If this is a problem I could come up
> > with a new API that lets caller allocate the buffer.
> > Let me know.
> >
> > > I'm assuming that will still be processed as one
> > > contiguous block. With that I can then at least maintain a single
> > > response per request.
> >
> > Why do you care? Won't a counter of outstanding pages be enough?
> > Down the road maybe we could actually try to pipeline
> > things a bit. So send 32 pages once you get 16 of these back
> > send 16 more. Better for SMP configs and does not hurt
> > non-SMP too much. I am not saying we need to do it right away though.
> 
> So the big thing is we cannot give the page back to the guest kernel
> until we know the processing has been completed. In the case of the
> MADV_DONT_NEED call it will zero out the entire page on the next
> access. If the guest kernel had already written data by the time we
> get to that it would cause a data corruption and kill the whole guest.


Exactly but FREE_PAGE_HINT does not cause qemu to call MADV_DONT_NEED.

> > > > > This is one of the things Linus kept complaining about in
> > > > > his comments. This code attempts to pull in ALL of the higher order
> > > > > pages, not just a smaller block of them.
> > > >
> > > > It wants to report all higher order pages eventually, yes.
> > > > But it's absolutely fine to report a chunk and then wait
> > > > for host to process the chunk before reporting more.
> > > >
> > > > However, interfaces we came up with for this would call
> > > > into virtio with a bunch of locks taken.
> > > > The solution was to take pages off the free list completely.
> > > > That in turn means we can't return them until
> > > > we have processed all free memory.
> > >
> > > I get that. The problem is the interface is designed around run to
> > > completion. For example it will sit there in a busy loop waiting for a
> > > free buffer because it knows the other side is suppose to be
> > > processing the pages already.
> >
> > I didn't get this part.
> 
> I think the part you may not be getting is that we cannot let the
> guest use the page until the hint has been processed. Otherwise we
> risk corrupting memory. That is the piece that has me paranoid. If we
> end up performing a hint on a page that is use somewhere in the kernel
> it will corrupt memory one way or another. That is the thing I have to
> avoid at all cost.

You have to do it, sure. And that is because you do not
assume that hypervisor does it for you. But FREE_PAGE_HINT doesn't,
hypervisor takes care of that.

> That is why I have to have a way to know exactly which pages have been
> processed and which haven't before I return pages to the guest.
> Otherwise I am just corrupting memory.

Sure. That isn't really hard though.

> 
> > > > > Honestly the difference is
> > > > > mostly in the hypervisor interface than what is needed for the kernel
> > > > > interface, however the design of the hypervisor interface would make
> > > > > doing things more incrementally much more difficult.
> > > >
> > > > OK that's interesting. The hypervisor interface is not
> > > > documented in the spec yet. Let me take a stub at a writeup now. So:
> > > >
> > > >
> > > >
> > > > - hypervisor requests reporting by modifying command ID
> > > >   field in config space, and interrupting guest
> > > >
> > > > - in response, guest sends the command ID value on a special
> > > >   free page hinting VQ,
> > > >   followed by any number of buffers. Each buffer is assumed
> > > >   to be the address and length of memory that was
> > > >   unused *at some point after the time when command ID was sent*.
> > > >
> > > >   Note that hypervisor takes pains to handle the case
> > > >   where memory is actually no longer free by the time
> > > >   it gets the memory.
> > > >   This allows guest driver to take more liberties
> > > >   and free pages without waiting for guest to
> > > >   use the buffers.
> > > >
> > > >   This is also one of the reason we call this a free page hint -
> > > >   the guarantee that page is free is a weak one,
> > > >   in that sense it's more of a hint than a promise.
> > > >   That helps guarantee we don't create OOM out of blue.
> >
> > I would like to stress the last paragraph above.
> 
> The problem is we don't want to give bad hints. What we do based on
> the hint is clear the dirty bit. If we clear it in err when the page
> is actually in use it will lead to data corruption after migration.

That's true for your patches. I get that.

> The idea with the hint is that you are saying the page is currently
> not in use, however if you send that hint late and have already freed
> the page back you can corrupt memory.


That part is I think wrong - assuming "you" means upstream code.

> > > >
> > > > - guest eventually sends a special buffer signalling to
> > > >   host that it's done sending free pages.
> > > >   It then stops reporting until command id changes.
> > >
> > > The pages are not freed back to the guest until the host reports that
> > > it is "DONE" via a configuration change. Doing that stops any further
> > > progress, and attempting to resume will just restart from the
> > > beginning.
> >
> > Right but it's not a requirement. Host does not assume this at all.
> > It's done like this simply because we can't iterate over pages
> > with the existing API.
> 
> The problem is nothing about the implementation was designed for
> iteration. What I would have to do is likely gut and rewrite the
> entire guest side of the FREE_PAGE_HINT code in order to make it work
> iteratively.


Right. I agree.

> As I mentioned it would probably have to look more like a
> NIC Rx ring in handling because we would have to have some sort of way
> to associate the pages 1:1 to the buffers.
>
> > > The big piece this design is missing is the incremental notification
> > > pages have been processed. The existing code just fills the vq with
> > > pages and keeps doing it until it cannot allocate any more pages. We
> > > would have to add logic to stop, flush, and resume to the existing
> > > framework.
> >
> > But not to the hypervisor interface. Hypervisor is fine
> > with pages being reused immediately. In fact, even before they
> > are processed.
> 
> I don't think that is actually the case. If it does that I am pretty
> sure it will corrupt memory during migration.
> 
> Take a look at qemu_guest_free_page_hint:
> https://github.com/qemu/qemu/blob/master/migration/ram.c#L3342
> 
> I'm pretty sure that code is going in and clearing the dirty bitmap
> for memory.

Yes it does. However the trick is that meanwhile
kvm is logging new writes. So the bitmap that
is being cleared is the bitmap that was logged before the request
was sent to guest.

> If we were to allow a page to be allocated and used and
> then perform the hint it is going to introduce a race where the page
> might be missed for migration and could result in memory corruption.

commit c13c4153f76db23cac06a12044bf4dd346764059 has this explanation:

    Note: balloon will report pages which were free at the time of this call.
    As the reporting happens asynchronously, dirty bit logging must be
    enabled before this free_page_start call is made. Guest reporting must be
    disabled before the migration dirty bitmap is synchronized.

but over multiple iterations this seems to have been dropped
from code comments. Wei, would you mind going back
and documenting the APIs you used?
They seem to be causing confusion ...

> 
> > > > - host can restart the process at any time by
> > > >   updating command ID. That will make guest stop
> > > >   and start from the beginning.
> > > >
> > > > - host can also stop the process by specifying a special
> > > >   command ID value.
> > > >
> > > >
> > > > =========
> > > >
> > > >
> > > > Now let's compare to what you have here:
> > > >
> > > > - At any time after boot, guest walks over free memory and sends
> > > >   addresses as buffers to the host
> > > >
> > > > - Memory reported is then guaranteed to be unused
> > > >   until host has used the buffers
> > > >
> > > >
> > > > Is above a fair summary?
> > > >
> > > > So yes there's a difference but the specific bit of chunking is same
> > > > imho.
> > >
> > > The big difference is that I am returning the pages after they are
> > > processed, while FREE_PAGE_HINT doesn't and isn't designed to.
> >
> > It doesn't but the hypervisor *is* designed to support that.
> 
> Not really, it seems like it is more just a side effect of things.

I hope the commit log above is enough to convice you we did
think about this.

> Also as I mentioned before I am also not a huge fan of polling on both
> sides as it is just going to burn through CPU. If we are iterative and
> polling it is going to end up with us potentially pushing one CPU at
> 100%, and if the one CPU doing the polling cannot keep up with the
> page updates coming from the other CPUs we would be stuck in that
> state for a while. I would have preferred to see something where the
> CPU would at least allow other tasks to occur while it is waiting for
> buffers to be returned by the host.

You lost me here. What does polling have to do with it?


> > > The
> > > problem is the interface doesn't allow for a good way to identify that
> > > any given block of pages has been processed and can be returned.
> >
> > And that's because FREE_PAGE_HINT does not care.
> > It can return any page at any point even before hypervisor
> > saw it.
> 
> I disagree, see my comment above.

OK let's see if above is enough to convice you. Or maybe  we
have a bug when shrinker is invoked :) But I don't think so.

> > > Instead pages go in, but they don't come out until the configuration
> > > is changed and "DONE" is reported. The act of reporting "DONE" will
> > > reset things and start them all over which kind of defeats the point.
> >
> > Right.
> >
> > But if you consider how we are using the shrinker you will
> > see that it's kind of broken.
> > For example not keeping track of allocated
> > pages means the count we return is broken
> > while reporting is active.
> >
> > I looked at fixing it but really if we can just
> > stop allocating memory that would be way cleaner.
> 
> Agreed. If we hit an OOM we should probably just stop the free page
> hinting and treat that as the equivalent to an allocation failure.

And fix the shrinker count to include the pages in the vq. Yea.

> 
> As-is I think this also has the potential for corrupting memory since
> it will likely be returning the most recent pages added to the balloon
> so the pages are likely still on the processing queue.

That part is fine I think because of the above.

> 
> > For example we allocate pages until shrinker kicks in.
> > Fair enough but in fact many it would be better to
> > do the reverse: trigger shrinker and then send as many
> > free pages as we can to host.
> 
> I'm not sure I understand this last part.

Oh basically what I am saying is this: one of the reasons to use page
hinting is when host is short on memory.  In that case, why don't we use
shrinker to ask kernel drivers to free up memory? Any memory freed could
then be reported to host.

-- 
MST
