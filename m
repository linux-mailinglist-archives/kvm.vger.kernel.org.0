Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAEDE6B0BE
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 23:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388797AbfGPVHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 17:07:12 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39532 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728340AbfGPVHM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 17:07:12 -0400
Received: by mail-qt1-f196.google.com with SMTP id l9so21119433qtu.6;
        Tue, 16 Jul 2019 14:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lU0ZKpvPEM02SqJNjy+uAeZT1GMqvehKcxtKUy4ZdV4=;
        b=rOdL+DUB3An79WA+jPt9CMyw8MQxV91n8PIHvK6IJiWgQtrywzryWK6lI+sXoku94C
         cQKvqy4QEHF2aN8DyZ2sBwxx2l7eXZrsQkKivPTgYSKYgg/+xWXZES0GVCy5epaVnlih
         qGIJ+/pYkZIIg/5VtmE80Ky9PAOMTQRECOWrCnLwNUtySSyfnjjHjHxFvfwdQS2JoBnh
         tQo3H3FkRsQywCOzy/OXl/q6t3ucoosNiPJtUh6pEQ5CHAp0Vy39ABpiZP4YhVJvsPk0
         ouUR4f1JyR5Hf3+19/k4ddY/EJ1FF+jF6axym7qj68Dsj8c2hpIVAUOyy2vKfq3EIMUa
         oXQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lU0ZKpvPEM02SqJNjy+uAeZT1GMqvehKcxtKUy4ZdV4=;
        b=KPfZEeEQ+gbPJ+gSauoalOo0HTptWyio9Q7/tvsLq/EFsGGaEwrKFBn050gyNGQ1Ur
         ussNnEjfqzR6u1ZXJ/ZU15jWwpjBvciikft+7E+zMDHSjxbPPPG9RVHxxXPVSzQXai/s
         gT3kbsB1A/sCaV2nu0Xac1gvExXsmlnguXAfCydTn5eOGU3YX9e6GL38gejuqpLZbw0+
         eCY5NUgv86Xer9ppdoc8jZTnWEfETIM54zusUgsJfVxoSnQdERDBgw2/Xw28AAm+ruAN
         tIo36YS+i7nWxGFW+T5N9KJfRfGMXu44IkqRFTpIsUlEYwvVkQUew1SCiGoLPhFY/C1W
         cPxw==
X-Gm-Message-State: APjAAAXYuPx4B6KOYjRVYMxBhk8lUTocQ9l0JlDk0wK5wPz+c2YWxXiK
        1hc8uqc45AovmUY5JJ/fmSkG55+fG4YhOwaW4IA=
X-Google-Smtp-Source: APXvYqxSi83uaBDrLmOo3wSuY6zQNktY2GDbKYBvzNCkongdEuyCLYoe4d5ugxdDzo4TmrLBBlAf0mMjQ7pyUBrP0w0=
X-Received: by 2002:aed:3742:: with SMTP id i60mr24421385qtb.376.1563311230570;
 Tue, 16 Jul 2019 14:07:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190619222922.1231.27432.stgit@localhost.localdomain>
 <20190619223338.1231.52537.stgit@localhost.localdomain> <20190716055017-mutt-send-email-mst@kernel.org>
 <CAKgT0Uc-2k9o7pjtf-GFAgr83c7RM-RTJ8-OrEzFv92uz+MTDw@mail.gmail.com>
 <20190716115535-mutt-send-email-mst@kernel.org> <CAKgT0Ud47-cWu9VnAAD_Q2Fjia5gaWCz_L9HUF6PBhbugv6tCQ@mail.gmail.com>
 <20190716125845-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190716125845-mutt-send-email-mst@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 16 Jul 2019 14:06:59 -0700
Message-ID: <CAKgT0UfgPdU1H5ZZ7GL7E=_oZNTzTwZN60Q-+2keBxDgQYODfg@mail.gmail.com>
Subject: Re: [PATCH v1 6/6] virtio-balloon: Add support for aerating memory
 via hinting
To:     "Michael S. Tsirkin" <mst@redhat.com>
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
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 16, 2019 at 10:41 AM Michael S. Tsirkin <mst@redhat.com> wrote:

<snip>

> > > This is what I am saying. Having watched that patchset being developed,
> > > I think that's simply because processing blocks required mm core
> > > changes, which Wei was not up to pushing through.
> > >
> > >
> > > If we did
> > >
> > >         while (1) {
> > >                 alloc_pages
> > >                 add_buf
> > >                 get_buf
> > >                 free_pages
> > >         }
> > >
> > > We'd end up passing the same page to balloon again and again.
> > >
> > > So we end up reserving lots of memory with alloc_pages instead.
> > >
> > > What I am saying is that now that you are developing
> > > infrastructure to iterate over free pages,
> > > FREE_PAGE_HINT should be able to use it too.
> > > Whether that's possible might be a good indication of
> > > whether the new mm APIs make sense.
> >
> > The problem is the infrastructure as implemented isn't designed to do
> > that. I am pretty certain this interface will have issues with being
> > given small blocks to process at a time.
> >
> > Basically the design for the FREE_PAGE_HINT feature doesn't really
> > have the concept of doing things a bit at a time. It is either
> > filling, stopped, or done. From what I can tell it requires a
> > configuration change for the virtio balloon interface to toggle
> > between those states.
>
> Maybe I misunderstand what you are saying.
>
> Filling state can definitely report things
> a bit at a time. It does not assume that
> all of guest free memory can fit in a VQ.

I think where you and I may differ is that you are okay with just
pulling pages until you hit OOM, or allocation failures. Do I have
that right? In my mind I am wanting to perform the hinting on a small
block at a time and work through things iteratively.

The problem is the FREE_PAGE_HINT doesn't have the option of returning
pages until all pages have been pulled. It is run to completion and
will keep filling the balloon until an allocation fails and the host
says it is done. I would prefer to avoid that as I prefer to simply
notify the host of a fixed block of pages at a time and let it process
without having to have a thread on each side actively pushing pages,
or listening for the incoming pages.

> > > > The basic idea with the bubble hinting was to essentially create mini
> > > > balloons. As such I had based the code off of the balloon inflation
> > > > code. The only spot where it really differs is that I needed the
> > > > ability to pass higher order pages so I tweaked thinks and passed
> > > > "hints" instead of "pfns".
> > >
> > > And that is fine. But there isn't really such a big difference with
> > > FREE_PAGE_HINT except FREE_PAGE_HINT triggers upon host request and not
> > > in response to guest load.
> >
> > I disagree, I believe there is a significant difference.
>
> Yes there is, I just don't think it's in the iteration.
> The iteration seems to be useful to hinting.

I agree that iteration is useful to hinting. The problem is the
FREE_PAGE_HINT code isn't really designed to be iterative. It is
designed to run with a polling thread on each side and it is meant to
be run to completion.

> > The
> > FREE_PAGE_HINT code was implemented to be more of a streaming
> > interface.
>
> It's implemented like this but it does not follow from
> the interface. The implementation is a combination of
> attempts to minimize # of exits and minimize mm core changes.

The problem is the interface doesn't have a good way of indicating
that it is done with a block of pages.

So what I am probably looking at if I do a sg implementation for my
hinting is to provide one large sg block for all 32 of the pages I
might be holding. I'm assuming that will still be processed as one
contiguous block. With that I can then at least maintain a single
response per request.

> > This is one of the things Linus kept complaining about in
> > his comments. This code attempts to pull in ALL of the higher order
> > pages, not just a smaller block of them.
>
> It wants to report all higher order pages eventually, yes.
> But it's absolutely fine to report a chunk and then wait
> for host to process the chunk before reporting more.
>
> However, interfaces we came up with for this would call
> into virtio with a bunch of locks taken.
> The solution was to take pages off the free list completely.
> That in turn means we can't return them until
> we have processed all free memory.

I get that. The problem is the interface is designed around run to
completion. For example it will sit there in a busy loop waiting for a
free buffer because it knows the other side is suppose to be
processing the pages already.

> > Honestly the difference is
> > mostly in the hypervisor interface than what is needed for the kernel
> > interface, however the design of the hypervisor interface would make
> > doing things more incrementally much more difficult.
>
> OK that's interesting. The hypervisor interface is not
> documented in the spec yet. Let me take a stub at a writeup now. So:
>
>
>
> - hypervisor requests reporting by modifying command ID
>   field in config space, and interrupting guest
>
> - in response, guest sends the command ID value on a special
>   free page hinting VQ,
>   followed by any number of buffers. Each buffer is assumed
>   to be the address and length of memory that was
>   unused *at some point after the time when command ID was sent*.
>
>   Note that hypervisor takes pains to handle the case
>   where memory is actually no longer free by the time
>   it gets the memory.
>   This allows guest driver to take more liberties
>   and free pages without waiting for guest to
>   use the buffers.
>
>   This is also one of the reason we call this a free page hint -
>   the guarantee that page is free is a weak one,
>   in that sense it's more of a hint than a promise.
>   That helps guarantee we don't create OOM out of blue.
>
> - guest eventually sends a special buffer signalling to
>   host that it's done sending free pages.
>   It then stops reporting until command id changes.

The pages are not freed back to the guest until the host reports that
it is "DONE" via a configuration change. Doing that stops any further
progress, and attempting to resume will just restart from the
beginning.

The big piece this design is missing is the incremental notification
pages have been processed. The existing code just fills the vq with
pages and keeps doing it until it cannot allocate any more pages. We
would have to add logic to stop, flush, and resume to the existing
framework.

> - host can restart the process at any time by
>   updating command ID. That will make guest stop
>   and start from the beginning.
>
> - host can also stop the process by specifying a special
>   command ID value.
>
>
> =========
>
>
> Now let's compare to what you have here:
>
> - At any time after boot, guest walks over free memory and sends
>   addresses as buffers to the host
>
> - Memory reported is then guaranteed to be unused
>   until host has used the buffers
>
>
> Is above a fair summary?
>
> So yes there's a difference but the specific bit of chunking is same
> imho.

The big difference is that I am returning the pages after they are
processed, while FREE_PAGE_HINT doesn't and isn't designed to. The
problem is the interface doesn't allow for a good way to identify that
any given block of pages has been processed and can be returned.
Instead pages go in, but they don't come out until the configuration
is changed and "DONE" is reported. The act of reporting "DONE" will
reset things and start them all over which kind of defeats the point.
