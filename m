Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED056C8B23
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 16:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfJBO0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 10:26:04 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:32852 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfJBO0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 10:26:04 -0400
Received: by mail-io1-f65.google.com with SMTP id z19so57447935ior.0;
        Wed, 02 Oct 2019 07:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EZDH5fmtx84N/FA2DzFvaaolbsd+J9iBLD5hVgfYHUw=;
        b=gaKYdTskfQ4v6HYIY+JvWXJsfXYA5zEifd8viqarIpymnW5yClMh0TTueb5O9TJG4m
         B4QdL+HrLreSVUqjQM1wMDWrtcoRcIQdzm9s4uOJ6O8+aodZNqtfNr0U917vdd29+i18
         XveTai6RxBsHly9KdDHGuPCP5nBf4N+N5RB9QHC5lleZy18zbCvSXsyjUsSfPpyGM3dZ
         5TufF5sE+8fWpAoQys1SlsYwU/5FSsL2Jc/WwmFszl2VDaUUbY/9zAJzFCLZ5IhGrmh6
         SbHwWwVAQfPM5sJcQmKKRAzZSROPb9rjpSn0eOgJ56DHcWs1GZzWmp85ZSV9EOiyx8tC
         PRfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EZDH5fmtx84N/FA2DzFvaaolbsd+J9iBLD5hVgfYHUw=;
        b=DIJvy2MMC2++U4u/mcZDxr9K7iKMy11wGTH/0nYJzYqfDDjkeP3yx6scAtsqEc5Bln
         lO9wILYmhMLxdklW89s9WPsshgxGf9eBrej48Hh7Fp04DBccybr6uvVWzXre6lF9dS0k
         4qQ2z68GSFCRmy3oQpCkhZv7IefS95rFJR+iDxtpBUqXpd9vTOCFVH5QZTUH4afT3iM5
         eCPau4TJr2qTDMQt56Fp1nNRnrOUVzyWhFtUGxEvRsp7lK8Y8ejxX5K3K7KBxVvVUxPX
         NUQ6c3uiWCrTMjj7M4XpiU62jaaxqI2B1JbPervUlmIFP2CbA3WVHlKiG9oBXBCJB5jl
         VqZg==
X-Gm-Message-State: APjAAAVSEQyZq73alSNK3qSCuFQ91EsYpGxtd3O3btNASAkisyNf8+4Z
        Pk9er09yySV16a6HumSUQUtzXmvmNn0U6eJCyuY=
X-Google-Smtp-Source: APXvYqwSvKuEL2HXaM2JPuO0AJ2TQbqnKScQq+YdzwN3RcglXqDUiH+8EcSdOBI+TqWjYK7nwQrpsxBsXYuWUhCs3y4=
X-Received: by 2002:a02:8502:: with SMTP id g2mr1532070jai.87.1570026362893;
 Wed, 02 Oct 2019 07:26:02 -0700 (PDT)
MIME-Version: 1.0
References: <20191001152441.27008.99285.stgit@localhost.localdomain>
 <7233498c-2f64-d661-4981-707b59c78fd5@redhat.com> <1ea1a4e11617291062db81f65745b9c95fd0bb30.camel@linux.intel.com>
 <8bd303a6-6e50-b2dc-19ab-4c3f176c4b02@redhat.com> <CAKgT0Uf37xAFK2CWqUZJgn7bWznSAi6qncLxBpC55oSpBMG1HQ@mail.gmail.com>
 <c06b68cb-5e94-ae3e-f84e-48087d675a8f@redhat.com>
In-Reply-To: <c06b68cb-5e94-ae3e-f84e-48087d675a8f@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 2 Oct 2019 07:25:50 -0700
Message-ID: <CAKgT0Ud6TT=XxqFx6ePHzbUYqMp5FHVPozRvnNZK3tKV7j2xjg@mail.gmail.com>
Subject: Re: [PATCH v11 0/6] mm / virtio: Provide support for unused page reporting
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 2, 2019 at 3:37 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
>
> On 10/1/19 8:55 PM, Alexander Duyck wrote:
> > On Tue, Oct 1, 2019 at 12:16 PM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
> >>
> >> On 10/1/19 12:21 PM, Alexander Duyck wrote:
> >>> On Tue, 2019-10-01 at 17:35 +0200, David Hildenbrand wrote:
> >>>> On 01.10.19 17:29, Alexander Duyck wrote:

<snip>

> >>> Do we have a working patch set for Nitesh's code? The last time I tried
> >>> running his patch set I ran into issues with kernel panics. If we have a
> >>> known working/stable patch set I can give it a try.
> >> Did you try the v12 patch-set [1]?
> >> I remember that you reported the CPU stall issue, which I fixed in the v12.
> >>
> >> [1] https://lkml.org/lkml/2019/8/12/593
> > So I tried testing with the spin_lock calls replaced with spin_lock
> > _irq to resolve the IRQ issue. I also had shuffle enabled in order to
> > increase the number of pages being dirtied.
> >
> > With that setup the bitmap approach is running significantly worse
> > then my approach, even with the boundary removed. Since I had to
> > modify the code to even getting working I am not comfortable posting
> > numbers.
>
> I didn't face any issue in getting the code work or compile.
> Before my v12 posting, I did try your previously suggested test
> (will-it-scale/page_fault1 for 12 hours on a 60 GB) and didn't see any issues.
> I think it would help more if you can share the setup which you are running.

So one issue with the standard page_fault1 is that it is only
operating at the 4K page level. You won't see much impact from you
patches with that as the overhead of splitting a MAX_ORDER - 2 page
down to a 4K page will end up being the biggest thing you are
benchmarking.

I think I have brought it up before but I am running with the
page_fault1 modified to use THP. Making the change is pretty
straightforward as  all you have to do is add an madvise to the test
code. All that is needed is to add "madvise(c, MEMSIZE,
MADV_HUGEPAGE);" between the assert and the for loop in the
page_fault1 code and then rebuild the test. I actually copied
page_fault1.c into a file I named page_fault4.c and added the line. As
a result it seems like the code will build it as an additional test.

The only other alteration I can think of that might have much impact
would be to enable the page shuffling. The idea is that it will cause
us to use more pages because half of the pages freed are dumped to the
tail of the list so we are constantly churning the memory.

> > My suggestion would be to look at reworking the patch set and
> > post numbers for my patch set versus the bitmap approach and we can
> > look at them then.
>
> Agreed. However, in order to fix an issue I have to reproduce it first.

With the tweak I have suggested above it should make it much easier to
reproduce. Basically all you need is to have the allocation competing
against hinting. Currently the hinting isn't doing this because the
allocations are mostly coming out of 4K pages instead of higher order
ones.

Alternatively you could just make the suggestion I had proposed about
using spin_lock/unlock_irq in your worker thread and that resolved it
for me.

> >  I would prefer not to spend my time fixing and
> > tuning a patch set that I am still not convinced is viable.
>
> You  don't have to, I can fix the issues in my patch-set. :)

Sounds good. Hopefully the stuff I pointed out above helps you to get
a reproduction and resolve the issues.

- Alex
