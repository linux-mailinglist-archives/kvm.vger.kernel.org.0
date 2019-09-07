Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1B0AC437
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2019 05:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394087AbfIGDPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 23:15:32 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36130 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389123AbfIGDPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 23:15:32 -0400
Received: by mail-io1-f66.google.com with SMTP id b136so17373308iof.3;
        Fri, 06 Sep 2019 20:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0SbxJSZH3xErImLG80umcUNoBk+9xCCDmjHpdYfWSdI=;
        b=KEmSCTrFRi5v4BfEGIMfu73TLPv6udM3bR6gfWTZy/5zzC65y2+/mWvG8YBtmoq2b2
         ERoPBzhsKJlm5uBrYKabXRRYM2dJNsBLY3jqJukp6HFhXq2qxCM+BwiwdrXidPTNUrTY
         BQ/M1eUI/QsJqAjkHiTdxL+62a1i4ha/Wq/gs6a2vwAiTiOJq7eec9Cv+ttD9ElMyy83
         bW19dkXFsucLiuSSZMmL8G5CF/8GHuDYD9RYM/WI+DU5hpMth22geGxtrMPbAmP/oa1t
         cO8vc0IR+L1V1dBgIAqvD2OMtmyjm8q8zNsy6ROkqQovCiIfc82c6P45TZp279DIIvvy
         PN4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0SbxJSZH3xErImLG80umcUNoBk+9xCCDmjHpdYfWSdI=;
        b=VFqqAnEI5xGV8Qjv+UmRROuCSTARqIiV+vqWIvWlkpGF72fZmjHgGgJ3/56n+A6CqD
         7F+umU00BZutO2zHWdBFxEH4BkWyDbVBts+h6L0Aax7wJjLzbWlLgTqqS2eHKrukal+i
         TLffQPIcofFSyU6ffayf0vq6zDxVXad5TQGdEyGa3ZSEhqF7mbl2xYAvVoFv5WlixuLl
         uekbnGpWbunRfY4Tjj7rYWpuVP1ObV5JU7zJOZsdneK1REY9MbBw3BucfeCNt4uQtCtt
         fevng5bgPp8+jqaJz5++NVV2cr6qspDCY2xeYwIKFyycEOCojNKPyXGvUnGpCOS2aY3u
         DOCA==
X-Gm-Message-State: APjAAAX9e1YkJlJN7LOLaWad4KfnMxnxifl2XytqAEOuN1Q/G+xypSym
        Yf1jkYJUQtPXI55T8oSPDQiVrtrnKDvazy2WtIw=
X-Google-Smtp-Source: APXvYqzMKQWDegw54LhTAG2I7IbZAeamrmRENinp3sOSixubhuWe2/Lb4c7+X+JTMG4bueI+YTKM2zJypOUVeylKJ4Y=
X-Received: by 2002:a5d:91ce:: with SMTP id k14mr2399826ior.95.1567826131164;
 Fri, 06 Sep 2019 20:15:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190906145213.32552.30160.stgit@localhost.localdomain> <20190906112155-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190906112155-mutt-send-email-mst@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 6 Sep 2019 20:15:20 -0700
Message-ID: <CAKgT0UcuZQPzcQ6cA5tKPG3+4yQP2jk+AHYcjoyrMXq0pBAiBw@mail.gmail.com>
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

Looks like there was a couple issues on arm64 and ia64 architectures.
I believe I have those fixed up and will submit a v9 in the morning
after my test runs have completed.

Thanks.

- Alex
