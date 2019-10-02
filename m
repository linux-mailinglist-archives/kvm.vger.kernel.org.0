Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE33C4531
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 02:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbfJBAzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 20:55:25 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45798 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfJBAzZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 20:55:25 -0400
Received: by mail-io1-f68.google.com with SMTP id c25so52880746iot.12;
        Tue, 01 Oct 2019 17:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LuVYHXtAtfPB7NgWUrBHL8wWFe9Ng5SaWzeFaUqnAvY=;
        b=pCwPjp7e5OZQ9dLTqEQj0hxLaFXKQDazKMNIuHW2dsj3WsZriVj9s2OinbmSItDxds
         pPvDq6K2n1/43rwOzYkN+1jCQ29B6xyhKlGLKinitc2MuWH/GZiUPMhNwz+DGjgyAytd
         60GUMlD3b0zK+nPLzW0T4vG2dST8DAqP6H6bBygvwaW9uDtN1oIPua5jc4X7QGW1R2Ji
         t/xQRJ9ZRBFUb6y/btVIUSiNupyYn9lM3PE4zI7KdaNchRU9HR6msyjz4vnjsrthMpg7
         c0d1XL2VUKp5+pT4k0Cyq/cJ4D9M91TfcTTPznOcc7iHhm+0vxRsw/I2r3Fbel4NDrQ7
         gkhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LuVYHXtAtfPB7NgWUrBHL8wWFe9Ng5SaWzeFaUqnAvY=;
        b=iLT6Y3QNPCV4JgvyEy1fNRc7ssEWT+NiRC31N2xZbZUVKkVcR+Me3lWnspYyp4oxzG
         IfKsQKsTuOrekk9/5hcWcb5dZMudSNjwajmkmcc+poYkyLaR9RDTGke95PofNt6Jn1EG
         uAtkDTiyC2U1rn0u8FUPB9NwoZIOWacBMDeZhdpss/a5bu5L92QyiXtyUVTX1jhxjJPK
         MVaj+HEDbTxYtLEHOYNt8Dp5UkcBHTyWYDTOyqcOFkX4WntkOqnXg7VDW6T6ovWiAqIE
         Q63k6vssQjlVutOM9OB4C8oG8Gaivni4jFJVsCGyHDwao0Uuuhf1bNEkADIbylKa8VtM
         6oVw==
X-Gm-Message-State: APjAAAWAc0junLm8R0l1J+Qmp63kuPvQLT9rr3XH5CWonYWOXg4R+cTy
        X3wCGXQZnjH59S8tPu47JvfAxJ67qx0fNl92qiM=
X-Google-Smtp-Source: APXvYqz253doH9SN4jaawIY7twEkdj3WUa8M6jP5FeLkxxNlg9Sk7Y3etLm4fYnkmUNc85bT+H4HKDDu3kDYihHarZk=
X-Received: by 2002:a6b:da06:: with SMTP id x6mr1094200iob.42.1569977724436;
 Tue, 01 Oct 2019 17:55:24 -0700 (PDT)
MIME-Version: 1.0
References: <20191001152441.27008.99285.stgit@localhost.localdomain>
 <7233498c-2f64-d661-4981-707b59c78fd5@redhat.com> <1ea1a4e11617291062db81f65745b9c95fd0bb30.camel@linux.intel.com>
 <8bd303a6-6e50-b2dc-19ab-4c3f176c4b02@redhat.com>
In-Reply-To: <8bd303a6-6e50-b2dc-19ab-4c3f176c4b02@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 1 Oct 2019 17:55:13 -0700
Message-ID: <CAKgT0Uf37xAFK2CWqUZJgn7bWznSAi6qncLxBpC55oSpBMG1HQ@mail.gmail.com>
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

On Tue, Oct 1, 2019 at 12:16 PM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
>
> On 10/1/19 12:21 PM, Alexander Duyck wrote:
> > On Tue, 2019-10-01 at 17:35 +0200, David Hildenbrand wrote:
> >> On 01.10.19 17:29, Alexander Duyck wrote:
> >>> This series provides an asynchronous means of reporting to a hypervisor
> >>> that a guest page is no longer in use and can have the data associated
> >>> with it dropped. To do this I have implemented functionality that allows
> >>> for what I am referring to as unused page reporting. The advantage of
> >>> unused page reporting is that we can support a significant amount of
> >>> memory over-commit with improved performance as we can avoid having to
> >>> write/read memory from swap as the VM will instead actively participate
> >>> in freeing unused memory so it doesn't have to be written.
> >>>
> >>> The functionality for this is fairly simple. When enabled it will allocate
> >>> statistics to track the number of reported pages in a given free area.
> >>> When the number of free pages exceeds this value plus a high water value,
> >>> currently 32, it will begin performing page reporting which consists of
> >>> pulling non-reported pages off of the free lists of a given zone and
> >>> placing them into a scatterlist. The scatterlist is then given to the page
> >>> reporting device and it will perform the required action to make the pages
> >>> "reported", in the case of virtio-balloon this results in the pages being
> >>> madvised as MADV_DONTNEED. After this they are placed back on their
> >>> original free list. If they are not merged in freeing an additional bit is
> >>> set indicating that they are a "reported" buddy page instead of a standard
> >>> buddy page. The cycle then repeats with additional non-reported pages
> >>> being pulled until the free areas all consist of reported pages.
> >>>
> >>> In order to try and keep the time needed to find a non-reported page to
> >>> a minimum we maintain a "reported_boundary" pointer. This pointer is used
> >>> by the get_unreported_pages iterator to determine at what point it should
> >>> resume searching for non-reported pages. In order to guarantee pages do
> >>> not get past the scan I have modified add_to_free_list_tail so that it
> >>> will not insert pages behind the reported_boundary. Doing this allows us
> >>> to keep the overhead to a minimum as re-walking the list without the
> >>> boundary will result in as much as 18% additional overhead on a 32G VM.
> >>>
> >>>
> > <snip>
> >
> >>> As far as possible regressions I have focused on cases where performing
> >>> the hinting would be non-optimal, such as cases where the code isn't
> >>> needed as memory is not over-committed, or the functionality is not in
> >>> use. I have been using the will-it-scale/page_fault1 test running with 16
> >>> vcpus and have modified it to use Transparent Huge Pages. With this I see
> >>> almost no difference with the patches applied and the feature disabled.
> >>> Likewise I see almost no difference with the feature enabled, but the
> >>> madvise disabled in the hypervisor due to a device being assigned. With
> >>> the feature fully enabled in both guest and hypervisor I see a regression
> >>> between -1.86% and -8.84% versus the baseline. I found that most of the
> >>> overhead was due to the page faulting/zeroing that comes as a result of
> >>> the pages having been evicted from the guest.
> >> I think Michal asked for a performance comparison against Nitesh's
> >> approach, to evaluate if keeping the reported state + tracking inside
> >> the buddy is really worth it. Do you have any such numbers already? (or
> >> did my tired eyes miss them in this cover letter? :/)
> >>
> > I thought what Michal was asking for was what was the benefit of using the
> > boundary pointer. I added a bit up above and to the description for patch
> > 3 as on a 32G VM it adds up to about a 18% difference without factoring in
> > the page faulting and zeroing logic that occurs when we actually do the
> > madvise.
> >
> > Do we have a working patch set for Nitesh's code? The last time I tried
> > running his patch set I ran into issues with kernel panics. If we have a
> > known working/stable patch set I can give it a try.
>
> Did you try the v12 patch-set [1]?
> I remember that you reported the CPU stall issue, which I fixed in the v12.
>
> [1] https://lkml.org/lkml/2019/8/12/593

So I tried testing with the spin_lock calls replaced with spin_lock
_irq to resolve the IRQ issue. I also had shuffle enabled in order to
increase the number of pages being dirtied.

With that setup the bitmap approach is running significantly worse
then my approach, even with the boundary removed. Since I had to
modify the code to even getting working I am not comfortable posting
numbers. My suggestion would be to look at reworking the patch set and
post numbers for my patch set versus the bitmap approach and we can
look at them then. I would prefer not to spend my time fixing and
tuning a patch set that I am still not convinced is viable.

Thanks.

- Alex
