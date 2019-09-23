Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7B6BB81D
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 17:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732204AbfIWPh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 11:37:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36034 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727563AbfIWPh4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 11:37:56 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3437F88306
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 15:37:55 +0000 (UTC)
Received: by mail-qt1-f199.google.com with SMTP id j5so16979498qtn.10
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 08:37:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E4QK3gDwO4DVf24v4ZLxlDMDZWgHlHSA6oyD8Fga644=;
        b=sh8VXlFENVjaDm7e+hg0sABOueMa9AhddOkiwjxUwG0thmWNIW401y7evW2l9dR2Ng
         vjoNf+G/Ad2PWJU2ajIuMtzuYYE0WX69LrDvRCv03u+Xv13k9mFx7ameAdU/PYg7LQ4k
         nWb/20Q8bMBRnr6v4EmoUkva7+noCXNFyfiaPRu8yH5bXYcxRUi5hpZnIjSvbC+PbtoX
         Bskh096W8WPlVdAKrt0aQKXZk4O5EdMFhx4+GWkh1OSUPpyoIUUnXSaB6I7DormctAZQ
         a7b8rLnHEPYzTgNz+5CskOo4JSSSiYqLDJ7uFW6Kfj3uRJTmHmQwKtzkbeToDGm/ZqN5
         fHIw==
X-Gm-Message-State: APjAAAUUmEHmamg5p20fVlFB1jCPBXshuWhVgI70gQK+mqm2yBK03+Dm
        4epea8rDGtUUFxwdjAJD1UASLMl89IlSEpZWA3RmPJWC16e4f2XI/jV88yxbhWzH1OVLVcpD6B0
        885ravKTv5eaN
X-Received: by 2002:a37:57c6:: with SMTP id l189mr452346qkb.246.1569253074529;
        Mon, 23 Sep 2019 08:37:54 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwMQYK4n8L9Q6BZh5x7gAOg7nRwOrwBwHigRwbuP/jdi+b4Ycl1HHmEcZoDvnm4Qa21KTqtNw==
X-Received: by 2002:a37:57c6:: with SMTP id l189mr452317qkb.246.1569253074360;
        Mon, 23 Sep 2019 08:37:54 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id l7sm5265164qke.67.2019.09.23.08.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 08:37:53 -0700 (PDT)
Date:   Mon, 23 Sep 2019 11:37:45 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
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
Subject: Re: [PATCH v10 3/6] mm: Introduce Reported pages
Message-ID: <20190923113722-mutt-send-email-mst@kernel.org>
References: <20190918175109.23474.67039.stgit@localhost.localdomain>
 <20190918175249.23474.51171.stgit@localhost.localdomain>
 <20190923041330-mutt-send-email-mst@kernel.org>
 <CAKgT0UfFBO9h3heGSo+AaZgUNpy5uuOm3yh62bYwYJ5dq+t1gQ@mail.gmail.com>
 <20190923105746-mutt-send-email-mst@kernel.org>
 <CAKgT0Ufp0bdz3YkbAoKWd5DALFjAkHaSUn_UywW1+3hk4tjPSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Ufp0bdz3YkbAoKWd5DALFjAkHaSUn_UywW1+3hk4tjPSQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 08:28:00AM -0700, Alexander Duyck wrote:
> On Mon, Sep 23, 2019 at 8:00 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Sep 23, 2019 at 07:50:15AM -0700, Alexander Duyck wrote:
> > > > > +static inline void
> > > > > +page_reporting_reset_boundary(struct zone *zone, unsigned int order, int mt)
> > > > > +{
> > > > > +     int index;
> > > > > +
> > > > > +     if (order < PAGE_REPORTING_MIN_ORDER)
> > > > > +             return;
> > > > > +     if (!test_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags))
> > > > > +             return;
> > > > > +
> > > > > +     index = get_reporting_index(order, mt);
> > > > > +     reported_boundary[index] = &zone->free_area[order].free_list[mt];
> > > > > +}
> > > >
> > > > So this seems to be costly.
> > > > I'm guessing it's the access to flags:
> > > >
> > > >
> > > >         /* zone flags, see below */
> > > >         unsigned long           flags;
> > > >
> > > >         /* Primarily protects free_area */
> > > >         spinlock_t              lock;
> > > >
> > > >
> > > >
> > > > which is in the same cache line as the lock.
> > >
> > > I'm not sure what you mean by this being costly?
> >
> > I've just been wondering why does will it scale report a 1.5% regression
> > with this patch.
> 
> Are you talking about data you have collected from a test you have
> run, or the data I have run?

About the kernel test robot auto report that was sent recently.

> In the case of the data I have run I notice almost no difference as
> long as the pages are not actually being madvised. Once I turn on the
> madvise then I start seeing the regression, but almost all of that is
> due to page zeroing/faulting. There isn't expected to be a gain from
> this patchset until you start having guests dealing with memory
> overcommit on the host. Then at that point the patch set should start
> showing gains when the madvise bits are enabled in QEMU.
> 
> Also the test I have been running is a modified version of the
> page_fault1 test to specifically target transparent huge pages in
> order to make this test that much more difficult, the standard
> page_fault1 test wasn't showing much of anything since the overhead
> for breaking a 2M page into 512 4K pages and zeroing those
> individually in the guest  was essentially drowning out the effect of
> the patches themselves.
> 
> - Alex
