Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F342BB7DE
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 17:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbfIWP2M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 11:28:12 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44564 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfIWP2M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 11:28:12 -0400
Received: by mail-io1-f65.google.com with SMTP id j4so34366979iog.11;
        Mon, 23 Sep 2019 08:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ovt/JswJZVCgn7gC8S4lJscYd7cbBemmVRbh0mTK6j8=;
        b=DIL1sv8HFoMOCTvY7W467j9MaGY0XQ/cpfliC2FJd/FeyrcnifvBizVcCTvnyAFGIO
         cGheg0eSIIuJBVwN3y7Zr6AyEA6w42em57dkPqn/YBaIGXhMY+V3T02jinZJJdmndquZ
         wmQjkGFyh4MAxEMt95AnBtjAbpPBEgxpszO0c1Jhco2oTN/3BzvoJk4R22PEA65ByoAs
         hERyYTCJW35FEYvB9k5mPgTit9zhbKRMFJtM4CaQY7vGLmPJESVRCVfwVRRpWb6+zdws
         At0ZjLLmFGNozw0nE8OSV6p54JuOZl5KaOWm8llJUap4yEcI7FuKiYJbA9urGVmIhU1E
         iHoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ovt/JswJZVCgn7gC8S4lJscYd7cbBemmVRbh0mTK6j8=;
        b=uP2A97MXVMvtIOQJvAaipBhFS5du5aab9hT61+L7We0Q4TXDuCIdxqQsQJZurApbSd
         RD5qgV/3TK42EYfyQd+0I9t8pVDhI+i+EAKRf+9FOaU45HfV3rOjIcPtJ+oaVF2jr3gz
         P1g0Qx90XZzrMNP4439tG7SCjESjN1NUnFPHNlC8w21dyjqyVuUul2a0/CjVcm+gTwka
         MV/n3gpdsn/3g/McAx6ts6sehetchpC8ZuIV3nCV+cwsMxNnn7I955R2sKitb7hmK2J0
         wm6SIYI90q6uzYrM9HNarjhrtMqhQ8+dm8GIbrraFD8j2FeADrqFnXCEi9/M3sFPGgKY
         EybA==
X-Gm-Message-State: APjAAAU+kfrd7Zd/O3OoX60QGGwicYyUEJo88OlEw7o6/x1zO5k8kL01
        EcBFucqIWYrW7mROhIcGZ0ibKjTUMGLVRxEqft8=
X-Google-Smtp-Source: APXvYqy2qdjvGFEyVfH+HCnC4m6roo43HVkj5cfovY7yzUHvANgw9POBQ+vbh318GLdMzmTYpQDcuZxK3VD9smRReus=
X-Received: by 2002:a5e:990f:: with SMTP id t15mr1173125ioj.270.1569252491032;
 Mon, 23 Sep 2019 08:28:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190918175109.23474.67039.stgit@localhost.localdomain>
 <20190918175249.23474.51171.stgit@localhost.localdomain> <20190923041330-mutt-send-email-mst@kernel.org>
 <CAKgT0UfFBO9h3heGSo+AaZgUNpy5uuOm3yh62bYwYJ5dq+t1gQ@mail.gmail.com> <20190923105746-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190923105746-mutt-send-email-mst@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 23 Sep 2019 08:28:00 -0700
Message-ID: <CAKgT0Ufp0bdz3YkbAoKWd5DALFjAkHaSUn_UywW1+3hk4tjPSQ@mail.gmail.com>
Subject: Re: [PATCH v10 3/6] mm: Introduce Reported pages
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        linux-mm <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        linux-arm-kernel@lists.infradead.org,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 8:00 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Sep 23, 2019 at 07:50:15AM -0700, Alexander Duyck wrote:
> > > > +static inline void
> > > > +page_reporting_reset_boundary(struct zone *zone, unsigned int order, int mt)
> > > > +{
> > > > +     int index;
> > > > +
> > > > +     if (order < PAGE_REPORTING_MIN_ORDER)
> > > > +             return;
> > > > +     if (!test_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags))
> > > > +             return;
> > > > +
> > > > +     index = get_reporting_index(order, mt);
> > > > +     reported_boundary[index] = &zone->free_area[order].free_list[mt];
> > > > +}
> > >
> > > So this seems to be costly.
> > > I'm guessing it's the access to flags:
> > >
> > >
> > >         /* zone flags, see below */
> > >         unsigned long           flags;
> > >
> > >         /* Primarily protects free_area */
> > >         spinlock_t              lock;
> > >
> > >
> > >
> > > which is in the same cache line as the lock.
> >
> > I'm not sure what you mean by this being costly?
>
> I've just been wondering why does will it scale report a 1.5% regression
> with this patch.

Are you talking about data you have collected from a test you have
run, or the data I have run?

In the case of the data I have run I notice almost no difference as
long as the pages are not actually being madvised. Once I turn on the
madvise then I start seeing the regression, but almost all of that is
due to page zeroing/faulting. There isn't expected to be a gain from
this patchset until you start having guests dealing with memory
overcommit on the host. Then at that point the patch set should start
showing gains when the madvise bits are enabled in QEMU.

Also the test I have been running is a modified version of the
page_fault1 test to specifically target transparent huge pages in
order to make this test that much more difficult, the standard
page_fault1 test wasn't showing much of anything since the overhead
for breaking a 2M page into 512 4K pages and zeroing those
individually in the guest  was essentially drowning out the effect of
the patches themselves.

- Alex
