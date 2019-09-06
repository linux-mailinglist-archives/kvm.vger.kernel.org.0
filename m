Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39DDBABC50
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 17:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394815AbfIFPZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 11:25:55 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37653 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731738AbfIFPZz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 11:25:55 -0400
Received: by mail-io1-f67.google.com with SMTP id r4so13599839iop.4;
        Fri, 06 Sep 2019 08:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N3FQEUSrBcDUfBeBfn5iCz+oSEqlloCS/pOKCoa2Zr0=;
        b=bgqPFZOdreq6PKuwjn62NrUjiulsqs09d/Gb8LjLNEs9G7HSU/RYbrcusE7+j93bbt
         ZNsiZhnSpiVn4xshXGTOP41Zhh95aNeL6YoFa4FzsIe4j81n7vD4tXH/11gzKEMpbsWG
         sODjHkkbKsQhVeBDNX0+hFtrjw8zAjfPhVHcKf0zbVkHuqfr+UUXFofddBouEiQhNFQc
         h5lD1fsFu5fy1FMAXTqksih7B3M/LRJrZKA8nyi2MKYfIY0EF76p3ur4BAidhBzLdOfN
         qMUoNboAFq7Ftys58HMDjwz72VDg0e7C72Gs5afM6ENseG/z+X5YA6JPCfMSOoUDsoE0
         z0Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N3FQEUSrBcDUfBeBfn5iCz+oSEqlloCS/pOKCoa2Zr0=;
        b=r5L/6Mj3FWx+mx7zy6A2dZLTX2wkV3xcO2cUs7si/9Zowm+45L0QvsxXlRejzsLKFH
         azEEWRJDuKB4zwCtE/3lurtEZJdP61ZMXuJCNrHGje86WNEVVQtvAlA8oNc4/QwpbiYr
         K5IGNSeeG+WSSvp9WqytG8qyocR2GSGlZSDjstNR+bT1YIC3l+M7rAEjabCRTh7AtXoY
         YNI/GPxLpEQOZ6aA2jEm6ULeYyFEtPA6wKFPF9B7dTU3CyzYhjCvnhIFzSMAnAe9JMf+
         2isXLYcuT9SZCHjDCJkCkmJEXEYkjCBqFBe8gtGWFhmWNO3bexd8pKP6WXHS3wnYPJtK
         JqEQ==
X-Gm-Message-State: APjAAAVG2p3v/lkhS1kXHRA5DNm3CiV+xgPepDXNSOGlIW9ia9g3Z+bg
        +s02r4r9gGiVlvtixNhZn4RZtnUq389o/Aki2ZJdcA==
X-Google-Smtp-Source: APXvYqwcGzRHOiIe83l2KSz9xAxgf3rf+jrakAFe9L11I466Xd43WAGC5SKvXq6IpFJAS6PXb2pvUJF/d3rtHSR26Kw=
X-Received: by 2002:a5d:8908:: with SMTP id b8mr11171098ion.237.1567783554482;
 Fri, 06 Sep 2019 08:25:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190906145213.32552.30160.stgit@localhost.localdomain> <20190906112155-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190906112155-mutt-send-email-mst@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 6 Sep 2019 08:25:43 -0700
Message-ID: <CAKgT0UcXLesZ2tBwp9u05OpBJpVDFL61qX9Qpj7VUqdRqw=U_Q@mail.gmail.com>
Subject: Re: [PATCH v8 0/7] mm / virtio: Provide support for unused page reporting
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        virtio-dev@lists.oasis-open.org,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 6, 2019 at 8:23 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Fri, Sep 06, 2019 at 07:53:21AM -0700, Alexander Duyck wrote:
> > This series provides an asynchronous means of reporting to a hypervisor
> > that a guest page is no longer in use and can have the data associated
> > with it dropped. To do this I have implemented functionality that allows
> > for what I am referring to as unused page reporting
> >
> > The functionality for this is fairly simple. When enabled it will allocate
> > statistics to track the number of reported pages in a given free area.
> > When the number of free pages exceeds this value plus a high water value,
> > currently 32, it will begin performing page reporting which consists of
> > pulling pages off of free list and placing them into a scatter list. The
> > scatterlist is then given to the page reporting device and it will perform
> > the required action to make the pages "reported", in the case of
> > virtio-balloon this results in the pages being madvised as MADV_DONTNEED
> > and as such they are forced out of the guest. After this they are placed
> > back on the free list, and an additional bit is added if they are not
> > merged indicating that they are a reported buddy page instead of a
> > standard buddy page. The cycle then repeats with additional non-reported
> > pages being pulled until the free areas all consist of reported pages.
> >
> > I am leaving a number of things hard-coded such as limiting the lowest
> > order processed to PAGEBLOCK_ORDER, and have left it up to the guest to
> > determine what the limit is on how many pages it wants to allocate to
> > process the hints. The upper limit for this is based on the size of the
> > queue used to store the scattergather list.
>
> I queued this  so this gets tested on linux-next but the mm core changes
> need acks from appropriate people.

Thanks. I will see what I can do to get some more mm people reviewing
these changes.

- Alex
