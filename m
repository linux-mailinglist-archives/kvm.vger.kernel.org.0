Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 038E8AEDAC
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 16:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732423AbfIJOsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 10:48:54 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43872 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfIJOsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 10:48:54 -0400
Received: by mail-io1-f68.google.com with SMTP id r8so13156316iol.10;
        Tue, 10 Sep 2019 07:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y51Wmq0LRgJPRQu0wESyACMKgIN3oGN4hPyCwS8B9Fw=;
        b=PzcNTtgFRZmzMv0K1KK0mg45o4Yljkgb90mn498QkmecMBhhZ5hVU/NDRq0XyRodXv
         oqt8Gfa8DdtOS8BNXSn78trtFzo/cG4x2Q3hTi0E8/87ACzQRuE0GaG6NPFNj2w7i5hz
         d9eH/XfpdFJ4ZsSIItHV5fPjLK39IDFhjDsIgyoeiWYb/OgukBbYhH7k63i7aX9m43JY
         B2q7D5PGC8y5aL/e8xurQByjUcIrfbOUk1u3uk1YXpi2aKIq2f9GOVhCzAD0nNiZ6KBc
         mxNmVjxT2XEjrQHY1egt7O+EREMCd1qYYvBFoCb6XuBlHZGCELCMyobbvgTykr1X77AJ
         JGUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y51Wmq0LRgJPRQu0wESyACMKgIN3oGN4hPyCwS8B9Fw=;
        b=jUjXbcwCx+FQJvXSp97hvAgMMT5MvCcmQR8TxZUPgWJkk5Ygpz0qpZJNhU3RP6xRv9
         1ugbaLGR1Mnd5ZRQzgwSNTODWTsIPZ4WkQooqlvM2VKjKhCFnlnLhTl1YIIrcJzQCTRl
         JFBCaVf1n0bEURuCHgIyb9gGo2/ZhDpGOl2bU6dsVvhgz0E+EJIjF7SNdaf7QUgELmks
         fzmqRNW+jg14azlr8BKN7Lxh5JZQ5vqYedSyqB9/G7pQdNgw16MNR2f7gq1A7+ebjsFU
         QjmGfQEGdufyHH2IXHZKzG0EBwewGfnXVxqp1iCkdtuw6i/c/dfzEX/Q2SwGyvxoXmT7
         aH6A==
X-Gm-Message-State: APjAAAVwhWPDTStoyJZUXEmTAu1seJaMmiwTih5Ii94zwtC/veit2yyt
        NuvupbHSCU4HqJenLjPaSDFm8CxYGv+HHwJEBmY=
X-Google-Smtp-Source: APXvYqwN74shiAyKliNs3JxV0dTTuWrOoxH7hX54E/H8prvfohDIALH6Vobq+JG8UlF+hibP/Y2WKvw7cp3R4NGGfXs=
X-Received: by 2002:a5d:8908:: with SMTP id b8mr1353105ion.237.1568126932604;
 Tue, 10 Sep 2019 07:48:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
 <20190907172520.10910.83100.stgit@localhost.localdomain> <20190910122030.GV2063@dhcp22.suse.cz>
In-Reply-To: <20190910122030.GV2063@dhcp22.suse.cz>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 10 Sep 2019 07:48:41 -0700
Message-ID: <CAKgT0Ufw1h45q9H5jraOJkRwvnrxfVNe99bVF1VWCLrzxCrMmg@mail.gmail.com>
Subject: Re: [PATCH v9 2/8] mm: Adjust shuffle code to allow for future coalescing
To:     Michal Hocko <mhocko@kernel.org>
Cc:     virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, ying.huang@intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 10, 2019 at 5:20 AM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Sat 07-09-19 10:25:20, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> >
> > Move the head/tail adding logic out of the shuffle code and into the
> > __free_one_page function since ultimately that is where it is really
> > needed anyway. By doing this we should be able to reduce the overhead
> > and can consolidate all of the list addition bits in one spot.
>
> This changelog doesn't really explain why we want this. You are
> reshuffling the code, allright, but why do we want to reshuffle? Is the
> result readability a better code reuse or something else? Where
> does the claimed reduced overhead coming from?
>
> From a quick look buddy_merge_likely looks nicer than the code splat
> we have. Good.
>
> But then
>
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>
> [...]
>
> > -     if (is_shuffle_order(order))
> > -             add_to_free_area_random(page, &zone->free_area[order],
> > -                             migratetype);
> > +     area = &zone->free_area[order];
> > +     if (is_shuffle_order(order) ? shuffle_pick_tail() :
> > +         buddy_merge_likely(pfn, buddy_pfn, page, order))
>
> Ouch this is just awful don't you think?

Yeah. I am going to go with Kirill's suggestion and probably do
something more along the lines of:
       bool to_tail;
        ...
        if (is_shuffle_order(order))
                to_tail = shuffle_pick_tail();
       else
                to_tail = buddy_merge_likely(pfn, buddy_pfn, page, order);

        if (to_tail)
                add_to_free_area_tail(page, area, migratetype);
        else
                add_to_free_area(page, area, migratetype);
