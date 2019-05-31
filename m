Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED51331199
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 17:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfEaPvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 11:51:17 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:35742 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbfEaPvR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 11:51:17 -0400
Received: by mail-it1-f196.google.com with SMTP id u186so16046960ith.0;
        Fri, 31 May 2019 08:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gHtluLlql7uIgW9EoxVJYiAb34hYFdaoxcaZYJdHUNE=;
        b=HAbz3OcJsjmFUot3sx7BlMmcox/IDu22qsjQS8yZGSfA6Dw7VvS1bXDWHz5pi26AUg
         JQZAxnUUwFmoJ5YbVvXEdgFeLwWlD9SArvBkWr/oDTIc7gN5ipN+SUEKiVeXS2wqvX5c
         98y0MMr+GoTgry0q9g4XthtArtDF13eclHo4V5ntqXlOmj2XZ8+DDFGxY5lgSFEe3K8U
         L40hpxxZS9gXb/N+GlV4u8jZhS5ToSQSWo/smAzJvffu+AouSW6KskezPaCweACF0Jvg
         YMYj3rnaPN7tX+Wn0RudahGJ5GQhe7FW7jKowlzYbScCmSyBpxTYw4SKmhW5XvRgJE8H
         Rdyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gHtluLlql7uIgW9EoxVJYiAb34hYFdaoxcaZYJdHUNE=;
        b=EZQBKx3/Z0l+bhphMWsoX44h7jCn6YkXL8ACKzOqzFqr5nfkJ7x5/ubOJWap8MMfzL
         /xdC4WfHWDyVkSQtpy1XEUwXJrSTNwoJaIo3bFWLnnH2/2QSQk3T1H+SeRWA9+Im2W0S
         ZwukjrrgCzPAW2SqFhCiHXrri/GJDu97R6e/fV6vvkUwSaVvHjokMWnHRpbmcu5ZLG+U
         uy7jkyjhGYn7Gn4am3oHJwnO1GaP6xLGBAz9Vs4DwuOQt9tJ7M34U10A4gY7HIo6fJkY
         tSWLjWTGiBwoZyZM1gLd8sOK+w9tZVXm/UjUcKmIohJm6X+JWtOPFik4aSfZtVSAW3BP
         r8Ww==
X-Gm-Message-State: APjAAAXjCubEIPBwvFKztob940uEj9cQqcdrmdGHWjWN8vyfe+5cSBOb
        4dncRvbKt2wizloUglntDuBmF/bP+BJ7OU7luCU=
X-Google-Smtp-Source: APXvYqzCdLergzoUgE4ZRGJta7bSmgKLXKTbd7ZLqr1DbCybIlguQXp0G+OHHBnLpOz88WzuahUohkC5i4gwQKKhCCU=
X-Received: by 2002:a24:d145:: with SMTP id w66mr7471748itg.71.1559317876201;
 Fri, 31 May 2019 08:51:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190530215223.13974.22445.stgit@localhost.localdomain> <34c0ea04-720f-6915-6a99-b05e5eb87968@redhat.com>
In-Reply-To: <34c0ea04-720f-6915-6a99-b05e5eb87968@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 31 May 2019 08:51:03 -0700
Message-ID: <CAKgT0UdDx3u4x=oveX40wBsAMq4GnKeLwC1JEb3sQveVXt4m=g@mail.gmail.com>
Subject: Re: [RFC PATCH 00/11] mm / virtio: Provide support for paravirtual
 waste page treatment
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
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

On Fri, May 31, 2019 at 4:16 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
>
> On 5/30/19 5:53 PM, Alexander Duyck wrote:
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
> >
> > This patch set is still far more intrusive then I would really like for
> > what it has to do. Currently I am splitting the nr_free_pages into two
> > values and having to add a pointer and an index to track where we area in
> > the treatment process for a given free_area. I'm also not sure I have
> > covered all possible corner cases where pages can get into the free_area
> > or move from one migratetype to another.
> >
> > Also I am still leaving a number of things hard-coded such as limiting the
> > lowest order processed to PAGEBLOCK_ORDER, and have left it up to the
> > guest to determine what size of reactor it wants to allocate to process
> > the hints.
> >
> > Another consideration I am still debating is if I really want to process
> > the aerator_cycle() function in interrupt context or if I should have it
> > running in a thread somewhere else.
>
> Can you please share some performance numbers?
>
> I will be sharing a less mm-intrusive bitmap-based approach hopefully by
> next week.
> Let's compare the two approaches then, in the meanwhile I will start
> reviewing your patch-set.

The performance can vary quite a bit depending on the configuration.
So for example with the memory shuffling enabled I saw an overall
improvement in transactions in the page_fault1 test I was running,
however I suspect that is just due to the fact that I inlined the bit
that was doing the shuffling at the 2nd patch in.

I'm still working on gathering data so you can consider the data
provided below as preliminary, and I want to emphasize your mileage
may vary as it seems like the config used can make a big difference.

So the results below are for a will-it-scale test of a VM running with
16 VCPUs and 32G of memory. The clean version is without patches
applied, and "aerate" is with patches applied. I disabled the memory
shuffling in the config for the kernels since it seemed like an unfair
comparison with it enabled. Before the test I ran "memhog 32g" to pull
in all available memory on the "clean" test and to pull in and flush
all the memory on the "aerate" tests. One thing that isn't really
making sense to me yet is why the results for the aerate version
appear to be better then the clean version when we start getting into
higher thread counts. One thing I notice is that clear_page_erms jumps
to the top of a perf trace on the host at about the inflection point
where the "clean" guest starts to under-perform versus the "aerate"
guest. So it is possible that there may be some benefit to having the
host clear the pages before the guest processes them.

5.2.0-rc2-next-20190529-clean #53
tasks,processes,processes_idle,threads,threads_idle,linear
0,0,100,0,100,0
1,574916,93.73,574313,93.70,574916
2,1006964,87.47,918228,87.52,1149832
3,1373857,81.23,1170468,82.35,1724748
4,1781250,74.98,1526831,76.77,2299664
5,1973790,68.74,1764815,69.86,2874580
6,2235127,62.53,1912371,65.42,3449496
7,2499192,56.28,1936901,61.63,4024412
8,2581220,50.05,2114032,56.54,4599328
9,2804630,43.81,2202166,52.37,5174244
10,2746340,37.58,2194305,48.31,5749160
11,2694687,31.33,2189028,41.74,6324076
12,2772102,25.16,2176312,40.85,6898992
13,2854235,18.94,2146288,37.61,7473908
14,2720456,12.73,2063334,32.67,8048824
15,2753005,6.51,2103228,26.65,8623740
16,2595824,0.36,2142308,25.96,9198656
tasks,processes,processes_idle,threads,threads_idle,linear
0,0,100,0,100,0
1,568948,93.73,570092,93.72,570092
2,1006781,87.47,911829,87.57,1140184
3,1360418,81.23,1189920,82.22,1710276
4,1749889,74.99,1476555,77.22,2280368
5,1927251,68.76,1681522,70.49,2850460
6,2221112,62.51,1845148,65.74,3420552
7,2497960,56.29,1983406,61.44,3990644
8,2586250,50.01,2062633,56.99,4560736
9,2570559,43.82,1989225,53.14,5130828
10,2692389,37.57,2159570,48.07,5700920
11,2621505,31.33,2214469,43.73,6271012
12,2772863,25.15,2164639,40.35,6841104
13,2839319,18.94,2184126,36.90,7411196
14,2712433,12.77,2048788,31.16,7981288
15,2779543,6.54,2105144,27.29,8551380
16,2605799,0.34,2101187,23.20,9121472

5.2.0-rc2-next-20190529-aerate+ #55
tasks,processes,processes_idle,threads,threads_idle,linear
0,0,100,0,100,0
1,538715,93.73,538909,93.73,538909
2,985096,87.46,899393,87.54,1077818
3,1421187,81.25,1271836,81.88,1616727
4,1745358,75.00,1435337,77.61,2155636
5,2031097,68.76,1766946,70.37,2694545
6,2234646,62.51,1794401,66.94,3233454
7,2455541,56.27,2101020,59.42,3772363
8,2576793,50.09,1810192,59.45,4311272
9,2772082,43.82,2315719,50.58,4850181
10,2794868,37.62,1996644,50.84,5389090
11,2931943,31.36,2147434,42.58,5927999
12,2837655,25.12,2032434,42.79,6466908
13,2881797,18.95,2163387,36.80,7005817
14,2802190,12.73,2049732,30.00,7544726
15,2684374,6.53,2039098,26.48,8083635
16,2695848,0.41,2044131,22.08,8622544
tasks,processes,processes_idle,threads,threads_idle,linear
0,0,100,0,100,0
1,533361,93.72,532973,93.73,533361
2,980085,87.46,904796,87.50,1066722
3,1387100,81.21,1271080,81.41,1600083
4,1720030,74.99,1539417,75.99,2133444
5,1942111,68.74,1530612,73.21,2666805
6,2226552,62.51,1777038,66.97,3200166
7,2469715,56.27,2084451,59.72,3733527
8,2567333,50.04,1820491,59.38,4266888
9,2744551,43.82,2259861,51.73,4800249
10,2768107,37.60,2240844,48.10,5333610
11,2879636,31.37,2134152,46.56,5866971
12,2826859,25.18,1960830,44.07,6400332
13,2905216,19.05,1887735,36.66,6933693
14,2841688,12.79,2047092,30.18,7467054
15,2832234,6.57,2066059,25.31,8000415
16,2758579,0.38,1961050,22.16,8533776
