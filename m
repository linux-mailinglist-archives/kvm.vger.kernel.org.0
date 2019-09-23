Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D976EBB879
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 17:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbfIWPul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 11:50:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37270 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbfIWPul (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 11:50:41 -0400
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AA57BC053B26
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 15:50:40 +0000 (UTC)
Received: by mail-qk1-f199.google.com with SMTP id w7so18099919qkf.10
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 08:50:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cj6Y1lnq7bXcC3kz0vWm87eC1U075TsPfURyzMigVaw=;
        b=U1ovUV/CxiHDu9g7WJQXAhxIJKRBfMM9swhoQLYA19n0xmUejC90zVUt/RdseueYlD
         BHmNPw/qNNq+W7r4EkENxswzncCB/CO2s0w0vCeQvvuptl3TmqLPM4mCnv7HR8QrBfy/
         afhRBKzyhC8Te6cLlRlvlS2ER7na1CvbyAVqVvlhXju4APTuBp2CAa3pvSoL44DNnt4s
         kReYzxG59+A/TzYlNGOM82rvXdOccQCozGTna0u8oWb+VWlZJPcSXR1jE7O4ESWF914F
         FsOGW4sLgpTrv9bjfIwY1LxLF9QCS3USGnJpS8erPSahvotTSL0DB4hRg2HiuKbXhRPv
         HTng==
X-Gm-Message-State: APjAAAU0dJRLR9ZJskqwGfcDadDrkp/+KVQ9Ep+/9yKhK1VrBzZvwKti
        XYLtwitoa2mRdNKzIuQVyImOPu7dw9fKbmkeT5xFFQiThQeexTa+A1uXWrUEttwmjFYBjW5sWA0
        34OIYkes4Ep/U
X-Received: by 2002:a37:bc82:: with SMTP id m124mr466938qkf.231.1569253840058;
        Mon, 23 Sep 2019 08:50:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxEKUtkTOCpbmKAVsuN5DEp8c5GEKKqBTQD9x7NMYUI+PUXnD6G5Fo6ixIl97M10Uj/81ScUg==
X-Received: by 2002:a37:bc82:: with SMTP id m124mr466905qkf.231.1569253839907;
        Mon, 23 Sep 2019 08:50:39 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id g10sm5061349qki.41.2019.09.23.08.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 08:50:39 -0700 (PDT)
Date:   Mon, 23 Sep 2019 11:50:31 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
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
Message-ID: <20190923114946-mutt-send-email-mst@kernel.org>
References: <20190918175109.23474.67039.stgit@localhost.localdomain>
 <20190918175249.23474.51171.stgit@localhost.localdomain>
 <20190923041330-mutt-send-email-mst@kernel.org>
 <CAKgT0UfFBO9h3heGSo+AaZgUNpy5uuOm3yh62bYwYJ5dq+t1gQ@mail.gmail.com>
 <20190923105746-mutt-send-email-mst@kernel.org>
 <CAKgT0Ufp0bdz3YkbAoKWd5DALFjAkHaSUn_UywW1+3hk4tjPSQ@mail.gmail.com>
 <20190923113722-mutt-send-email-mst@kernel.org>
 <baf3dd5c-9368-d621-a83a-114bb5ae8291@redhat.com>
 <49395e48-175f-8483-77f5-5fc3aca8b7cb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49395e48-175f-8483-77f5-5fc3aca8b7cb@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 05:47:24PM +0200, David Hildenbrand wrote:
> On 23.09.19 17:45, David Hildenbrand wrote:
> > On 23.09.19 17:37, Michael S. Tsirkin wrote:
> >> On Mon, Sep 23, 2019 at 08:28:00AM -0700, Alexander Duyck wrote:
> >>> On Mon, Sep 23, 2019 at 8:00 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >>>>
> >>>> On Mon, Sep 23, 2019 at 07:50:15AM -0700, Alexander Duyck wrote:
> >>>>>>> +static inline void
> >>>>>>> +page_reporting_reset_boundary(struct zone *zone, unsigned int order, int mt)
> >>>>>>> +{
> >>>>>>> +     int index;
> >>>>>>> +
> >>>>>>> +     if (order < PAGE_REPORTING_MIN_ORDER)
> >>>>>>> +             return;
> >>>>>>> +     if (!test_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags))
> >>>>>>> +             return;
> >>>>>>> +
> >>>>>>> +     index = get_reporting_index(order, mt);
> >>>>>>> +     reported_boundary[index] = &zone->free_area[order].free_list[mt];
> >>>>>>> +}
> >>>>>>
> >>>>>> So this seems to be costly.
> >>>>>> I'm guessing it's the access to flags:
> >>>>>>
> >>>>>>
> >>>>>>         /* zone flags, see below */
> >>>>>>         unsigned long           flags;
> >>>>>>
> >>>>>>         /* Primarily protects free_area */
> >>>>>>         spinlock_t              lock;
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> which is in the same cache line as the lock.
> >>>>>
> >>>>> I'm not sure what you mean by this being costly?
> >>>>
> >>>> I've just been wondering why does will it scale report a 1.5% regression
> >>>> with this patch.
> >>>
> >>> Are you talking about data you have collected from a test you have
> >>> run, or the data I have run?
> >>
> >> About the kernel test robot auto report that was sent recently.
> > 
> > https://lkml.org/lkml/2019/9/21/112
> > 
> > And if I'm correct, that regression is observable in case reporting is
> > not enabled. (so with this patch applied only, e.g., on a bare-metal system)
> > 
> 
> To be even more precise: # CONFIG_PAGE_REPORTING is not set

Even if it was, I'd hope for 0 overhead when not present runtime.

-- 
MST
