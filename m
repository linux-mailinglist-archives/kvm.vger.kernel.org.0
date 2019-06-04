Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 709E134D31
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 18:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbfFDQZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 12:25:29 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:53286 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727385AbfFDQZ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 12:25:29 -0400
Received: by mail-it1-f193.google.com with SMTP id m187so1098397ite.3;
        Tue, 04 Jun 2019 09:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=keUx6OuTtnNnS8af2D8MRcezvwV9OMJ0K5kA2b/Onj8=;
        b=W/L7XlWaFAFC25Fsz4CXjMTrwc8PsTmaQ8HGbUAYsAo60RiR9fODX6dyVe9/QY2ZPe
         kcWVcaBcvoM3Te+G8UuxrDWK305KGBkb1QlFNgoTOUwmB+ySljpLY/LNOkHUVfyNof5Y
         RWu7BSCU1KTy8xhog0NHEaML4VIAPY9wEs13EyeiRTVcW4HQ+i43ncoyTxb18LtXyoba
         s3ClM75/YGscb0IR39VRwOcvsCp/wc+Cl4w4GI4e1I/Xc6JGJtjCga77WcgnCTSYxXi3
         xSGoOldTC1VSI6zCOg8zXg51veJ3U2NQOIATn6cfOFQzWuzsWsENpwwbGLogs8uow04Y
         Bt4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=keUx6OuTtnNnS8af2D8MRcezvwV9OMJ0K5kA2b/Onj8=;
        b=CjP1GWtYsURk6o5VjeuFiYnqWXTz9WW2tG6BZdn675qimLYBI/GftCQmzAkAF0gvvu
         tLu5DVNrl1KwQCRi12hWI8QXlfo255UWttlpwMMJWeUXz9Xye/0qkuCGn/lJ32BV4pCS
         tPp+aBTdYSjeEni62PBmxGDRrUMcdXnKmK6jTSYh38/FiUNBU/GlBYUXBcg4t0nWlZ7B
         yYRbFwyWX4tskKkkHlUPWabErFfM51KE83mLi7r+nASnoyXKaqKglM1sGlXIgPaV2RyW
         lyl2SMIRir1XVnd+QCQbBosYc8WhQbICnhMXyZVguB/x9rCwmL53NP6LyvKM1cyhJ6JF
         8z7w==
X-Gm-Message-State: APjAAAW1Xug2a8qrMwH8UKPvKSGSEBji8+XoUObEzdqSP9PENCgAYrAC
        pP1VsrS9dV6t5vyuNW6q63GxSwnvbqxbOGH8+t4=
X-Google-Smtp-Source: APXvYqx/4rCisoqpGnzzw0zsbZQJzp6XnK7vklgy6SJ5670sERpis86AGb6uijJLfZA5p9whZRyv+dcYdZCQul/rIyg=
X-Received: by 2002:a02:5b05:: with SMTP id g5mr20735653jab.114.1559665528083;
 Tue, 04 Jun 2019 09:25:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190603170306.49099-1-nitesh@redhat.com> <20190603170306.49099-2-nitesh@redhat.com>
 <CAKgT0Udnc_cmgBLFEZ5udexsc1cfjX1rJR3qQFOW-7bfuFh6gQ@mail.gmail.com>
 <4cdfee20-126e-bc28-cf1c-2cfd484ca28e@redhat.com> <CAKgT0Ud6uKpcj9HFHYOThCY=0_P0=quBLbsDR7uUMdbwcYeSTw@mail.gmail.com>
 <09e6caea-7000-b3e4-d297-df6bea78e127@redhat.com>
In-Reply-To: <09e6caea-7000-b3e4-d297-df6bea78e127@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 4 Jun 2019 09:25:16 -0700
Message-ID: <CAKgT0UeMpcckGpT6OnC2kqgtyT2p9bvNgE2C0eqW1GOJTU-DHA@mail.gmail.com>
Subject: Re: [RFC][Patch v10 1/2] mm: page_hinting: core infrastructure
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, dodgen@google.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 4, 2019 at 9:08 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
>
> On 6/4/19 11:14 AM, Alexander Duyck wrote:
> > On Tue, Jun 4, 2019 at 5:55 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
> >>
> >> On 6/3/19 3:04 PM, Alexander Duyck wrote:
> >>> On Mon, Jun 3, 2019 at 10:04 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
> >>>> This patch introduces the core infrastructure for free page hinting in
> >>>> virtual environments. It enables the kernel to track the free pages which
> >>>> can be reported to its hypervisor so that the hypervisor could
> >>>> free and reuse that memory as per its requirement.
> >>>>
> >>>> While the pages are getting processed in the hypervisor (e.g.,
> >>>> via MADV_FREE), the guest must not use them, otherwise, data loss
> >>>> would be possible. To avoid such a situation, these pages are
> >>>> temporarily removed from the buddy. The amount of pages removed
> >>>> temporarily from the buddy is governed by the backend(virtio-balloon
> >>>> in our case).
> >>>>
> >>>> To efficiently identify free pages that can to be hinted to the
> >>>> hypervisor, bitmaps in a coarse granularity are used. Only fairly big
> >>>> chunks are reported to the hypervisor - especially, to not break up THP
> >>>> in the hypervisor - "MAX_ORDER - 2" on x86, and to save space. The bits
> >>>> in the bitmap are an indication whether a page *might* be free, not a
> >>>> guarantee. A new hook after buddy merging sets the bits.
> >>>>
> >>>> Bitmaps are stored per zone, protected by the zone lock. A workqueue
> >>>> asynchronously processes the bitmaps, trying to isolate and report pages
> >>>> that are still free. The backend (virtio-balloon) is responsible for
> >>>> reporting these batched pages to the host synchronously. Once reporting/
> >>>> freeing is complete, isolated pages are returned back to the buddy.
> >>>>
> >>>> There are still various things to look into (e.g., memory hotplug, more
> >>>> efficient locking, possible races when disabling).
> >>>>
> >>>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> >>> So one thing I had thought about, that I don't believe that has been
> >>> addressed in your solution, is to determine a means to guarantee
> >>> forward progress. If you have a noisy thread that is allocating and
> >>> freeing some block of memory repeatedly you will be stuck processing
> >>> that and cannot get to the other work. Specifically if you have a zone
> >>> where somebody is just cycling the number of pages needed to fill your
> >>> hinting queue how do you get around it and get to the data that is
> >>> actually code instead of getting stuck processing the noise?
> >> It should not matter. As every time the memory threshold is met, entire
> >> bitmap
> >> is scanned and not just a chunk of memory for possible isolation. This
> >> will guarantee
> >> forward progress.
> > So I think there may still be some issues. I see how you go from the
> > start to the end, but how to you loop back to the start again as pages
> > are added? The init_hinting_wq doesn't seem to have a way to get back
> > to the start again if there is still work to do after you have
> > completed your pass without queue_work_on firing off another thread.
> >
> That will be taken care as the part of a new job, which will be
> en-queued as soon
> as the free memory count for the respective zone will reach the threshold.

So does that mean that you have multiple threads all calling
queue_work_on until you get below the threshold? If so it seems like
that would get expensive since that is an atomic test and set
operation that would be hammered until you get below that threshold.
