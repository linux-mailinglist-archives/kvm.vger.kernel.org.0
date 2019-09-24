Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6A3BD034
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 19:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730488AbfIXRHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 13:07:24 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43033 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbfIXRHY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 13:07:24 -0400
Received: by mail-io1-f68.google.com with SMTP id v2so6214213iob.10;
        Tue, 24 Sep 2019 10:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lmspopvSKpX7B64KcDeaaqo7jPi/4Ao7F6ujlQxBuGE=;
        b=hcDEnqCq6c4biZl3J7K7tP0DKQ9JAzpWVtMOsVyhDsOwK1Ca7YXRaADqifdZsfBxK7
         5fowDdvrvKRMrOhFHJm0S1wSSZaVnkt7nE6t0r8wrldzrkt7jofiucDzmrDp4jtjIdGr
         VprKVbGpHUYmn0ePw6mO7ytb1umpXoLNto9BB1nw6xLSLimvL7FaiYm6rGYP8VJS3T/e
         Lqqc360+YVyzPJyJ0HLDEhHCtt+hrfFCOpzZ81xzmIMFbdOp1TqHgB6fgOmeJche3MSq
         43ZFEtB4puCyV22ccg7GBY9eLrnPIBLpvee33+WcBox/2wdUM+3Pbds3zhpY/FWgOXlL
         XtLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lmspopvSKpX7B64KcDeaaqo7jPi/4Ao7F6ujlQxBuGE=;
        b=KjHy0079oCmruI6njkrvkIgvQ1grliFZ/IlvpDzBLW6EFCaGsJyUjfBQgDyANPMaKY
         ufTEQ7dgCcHsAOm1Ry/sdZ4CxMXFnEudP2zgELXT/R8yvUJ7/veLOHv3xqvixi3XujyX
         z7p0yOmvb4eid57xUBYl5zhhnPobxyxzmz9dPe3DqTIBE0zWKFLBXuu53H7W5iJoUTXO
         dUyi6dU+uQsLRApNSnw6xUaF22RbHKUW8CJVdytyvg5ELCkH+NerCPgZzbtZZy9PvODg
         vAin0e/AC6RwjkvZAtjp7bzBm2bVigVVQdgAmy6R6faRdb7q5WqLAPh8lHUsTG3CJmf1
         MDmQ==
X-Gm-Message-State: APjAAAX99c/4lkPbrNvlXK/zpHQoIWi5RzTvU5a6upuT9H+rVokf/B/r
        OjfkWtnenwXdE7As/FEgeustZjLdn43e19NXc24=
X-Google-Smtp-Source: APXvYqzTx4/P0xGyBwbu8UrJ3aYyizZ4e4JPbj3P3E7+rFvspFGEEfawedIVxihESqhtv9T0LO547VkHQL4a0Kac6WE=
X-Received: by 2002:a6b:ac85:: with SMTP id v127mr4175604ioe.97.1569344843093;
 Tue, 24 Sep 2019 10:07:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190918175109.23474.67039.stgit@localhost.localdomain>
 <20190924142342.GX23050@dhcp22.suse.cz> <d2a7acdd-3bb9-05c9-42d0-70a500801cd6@redhat.com>
In-Reply-To: <d2a7acdd-3bb9-05c9-42d0-70a500801cd6@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 24 Sep 2019 10:07:11 -0700
Message-ID: <CAKgT0UedoNBk3cp64SpCzXJqjtqBWZQSB7QzF7R_jhTDXbzNPg@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm / virtio: Provide support for unused page reporting
To:     David Hildenbrand <david@redhat.com>
Cc:     Michal Hocko <mhocko@kernel.org>, virtio-dev@lists.oasis-open.org,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
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

On Tue, Sep 24, 2019 at 8:32 AM David Hildenbrand <david@redhat.com> wrote:
>
> On 24.09.19 16:23, Michal Hocko wrote:
> > On Wed 18-09-19 10:52:25, Alexander Duyck wrote:
> > [...]
> >> In order to try and keep the time needed to find a non-reported page to
> >> a minimum we maintain a "reported_boundary" pointer. This pointer is used
> >> by the get_unreported_pages iterator to determine at what point it should
> >> resume searching for non-reported pages. In order to guarantee pages do
> >> not get past the scan I have modified add_to_free_list_tail so that it
> >> will not insert pages behind the reported_boundary.
> >>
> >> If another process needs to perform a massive manipulation of the free
> >> list, such as compaction, it can either reset a given individual boundary
> >> which will push the boundary back to the list_head, or it can clear the
> >> bit indicating the zone is actively processing which will result in the
> >> reporting process resetting all of the boundaries for a given zone.
> >
> > Is this any different from the previous version? The last review
> > feedback (both from me and Mel) was that we are not happy to have an
> > externally imposed constrains on how the page allocator is supposed to
> > maintain its free lists.
> >
> > If this is really the only way to go forward then I would like to hear
> > very convincing arguments about other approaches not being feasible.
>
> Adding to what Alexander said, I don't consider the other approaches
> (especially the bitmap-based approach Nitesh is currently working on)
> infeasible. There might be more rough edges (e.g., sparse zones) and
> eventually sometimes a little more work to be done, but definitely
> feasible. Incorporating stuff into the buddy might make some tasks
> (e.g., identify free pages) more efficient.
>
> I still somewhat like the idea of capturing hints of free pages (in
> whatever data structure) and then going over the hints, seeing if the
> pages are still free. Then only temporarily isolating the still-free
> pages, reporting them, and un-isolating them after they were reported. I
> like the idea that the pages are not fake-allocated but only temporarily
> blocked. That works nicely e.g., with the movable zone (contain only
> movable data).

One other change in this patch set is that I split the headers so that
there is an internal header that resides in the mm tree and an
external one that provides the page reporting device structure and the
register/unregister functions. All that virtio-balloon knows is that
it is registering a notifier and will be called with scatter gather
lists for memory that is not currently in use by the kernel. It has no
visibility into the internal free_areas or the current state of the
buddy allocator. Rather than having two blocks that are both trying to
maintain that state, I have consolidated it all into the buddy
allocator with page reporting.

> But anyhow, after decades of people working on free page
> hinting/reporting, I am happy with anything that gets accepted upstream :D

Agreed. After working on this for 9 months I would be happy to get
something upstream that addresses this.

- Alex
