Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7A2BB768
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 17:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731294AbfIWPAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 11:00:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44818 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbfIWPAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 11:00:34 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BA6952D6A23
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 15:00:33 +0000 (UTC)
Received: by mail-qt1-f199.google.com with SMTP id s14so17648128qtn.4
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 08:00:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QNoXmel+GlMigZDcUd1vYpLYfL7zFiKdxBF3l1k0lPQ=;
        b=L1gvnABwdrhd7YL/nHLz4WyacZ0/pggJt9gsTJUBHQZHCroLc6BeT7gPDl6d9dI23G
         LzVkn8WAbu+zILVd6EG/ND3Rk7DOW6E9eaImCRGB95BIfb5roOPUidBpwqx40rvY8OQs
         4/3Gou8+IOIIXxTj0WSJkYuJjGhubJQNBbDUMdLVaY8yO74/hQHLVbOmrNXZM9lAvJIu
         izKZb6xWqKOGwct4lEIMWeO+BbAwE03tnzbUrpo390kgMehzDHlNRaVufQq5GmdKT+Qr
         RwUTDZsfEKXOB+gDEtfFXEsIpiQ1PAtmgFvtgWUlpjBKNcRwvbNYTZqcGZp3ubXyq8rj
         A0Wg==
X-Gm-Message-State: APjAAAUJFvmy3Lwh7gsQpdAJ5VDE3KMK5rybRL4rh7EyvFtUHAh5DopV
        S3ZGofw1hXHg+RJmNCiZl2/OuR459OiClS1O/zYMtPoQONvwidHJaCBhXawPuKQsR0HaCNZ8PfN
        Dxv9HvALN56S8
X-Received: by 2002:ac8:2c50:: with SMTP id e16mr317599qta.257.1569250832849;
        Mon, 23 Sep 2019 08:00:32 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyFUJn6BvXztT9hmWoUunZD0ZUcW4uUuFms3FLLwyr9jPXb7ZlVF254P3OydfcVZPOAJdBaaA==
X-Received: by 2002:ac8:2c50:: with SMTP id e16mr317578qta.257.1569250832651;
        Mon, 23 Sep 2019 08:00:32 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id j17sm5330553qki.99.2019.09.23.08.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 08:00:31 -0700 (PDT)
Date:   Mon, 23 Sep 2019 11:00:23 -0400
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
Message-ID: <20190923105746-mutt-send-email-mst@kernel.org>
References: <20190918175109.23474.67039.stgit@localhost.localdomain>
 <20190918175249.23474.51171.stgit@localhost.localdomain>
 <20190923041330-mutt-send-email-mst@kernel.org>
 <CAKgT0UfFBO9h3heGSo+AaZgUNpy5uuOm3yh62bYwYJ5dq+t1gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UfFBO9h3heGSo+AaZgUNpy5uuOm3yh62bYwYJ5dq+t1gQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 07:50:15AM -0700, Alexander Duyck wrote:
> > > +static inline void
> > > +page_reporting_reset_boundary(struct zone *zone, unsigned int order, int mt)
> > > +{
> > > +     int index;
> > > +
> > > +     if (order < PAGE_REPORTING_MIN_ORDER)
> > > +             return;
> > > +     if (!test_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags))
> > > +             return;
> > > +
> > > +     index = get_reporting_index(order, mt);
> > > +     reported_boundary[index] = &zone->free_area[order].free_list[mt];
> > > +}
> >
> > So this seems to be costly.
> > I'm guessing it's the access to flags:
> >
> >
> >         /* zone flags, see below */
> >         unsigned long           flags;
> >
> >         /* Primarily protects free_area */
> >         spinlock_t              lock;
> >
> >
> >
> > which is in the same cache line as the lock.
> 
> I'm not sure what you mean by this being costly?

I've just been wondering why does will it scale report a 1.5% regression
with this patch.

> Also, at least on my system, pahole seems to indicate they are in
> different cache lines.
> 
> /* --- cacheline 3 boundary (192 bytes) --- */
> struct zone_padding        _pad1_;               /*   192     0 */
> struct free_area           free_area[11];        /*   192  1144 */
> /* --- cacheline 20 boundary (1280 bytes) was 56 bytes ago --- */
> long unsigned int          flags;                /*  1336     8 */
> /* --- cacheline 21 boundary (1344 bytes) --- */
> spinlock_t                 lock;                 /*  1344     4 */
> 
> Basically these flags aren't supposed to be touched unless we are
> holding the lock anyway so I am not sure it would be all that costly
> for this setup. Basically we are holding the lock when the flag is set
> or cleared, and we only set it if it is not already set. If needed
> though I suppose I could look at moving the flags if you think that is
> an issue. However I would probably need to add some additional padding
> to prevent the lock from getting into the same cache line as the
> free_area values.

-- 
MST
