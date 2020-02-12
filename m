Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA8A159E8F
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 02:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgBLBT3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 20:19:29 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:41019 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728070AbgBLBT3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 20:19:29 -0500
Received: by mail-io1-f65.google.com with SMTP id m25so296645ioo.8;
        Tue, 11 Feb 2020 17:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kAE5YK5ptxtbuQnOU15dRXQpkp+DTRx4GZkHUX5A+v4=;
        b=CkaG5GejNspicmv5zvT1An89YyaxAHBpKAQi9dtfonhl+Zk5q48JqbkKpUo6aTlB22
         sARdQCNbVC4rH8Uln3FSNqeOBnz2DAD045ne0kgzcCVV/7WzWpqC5V9XevHd94bTrW8P
         D9cIIn89CGhGk/KupLMB1QVvp50C+QcIRcB8jcAEAj8Yhpca/SccHGIL5A/3dwZ1Q0Ws
         Q1KXsHKFsXiiqFugKo4f/FogTh84MC7+5CfIMkN05ryb/AJp86ZXX1ijbk9cg7bQ4xMR
         AoC/WA/+XhC7rAXGYIZCpc1M64fQoj5hpYDJzPWSYL3MUriEnDFMIAZPxVVXviBc9KSE
         9f0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kAE5YK5ptxtbuQnOU15dRXQpkp+DTRx4GZkHUX5A+v4=;
        b=i62usv/IeC5WKJ7QCZtCFM4mg1yO3DDmx+QBiUQU+X2Q2SCDvJFdX7gLvGUsS+MAA8
         c0S19/m+e835rf3B16vp+54h4RmCIbnvvjlXH4wDo28Ek71bBEBkjwwNPiGQ2Hrf0qED
         hixlEh7dOrBJvSiAZk8rjp3DhyDi9l64VYeMvnmQoTyp91+NGs+BnzEYULzfVNyaYY0S
         88wobGhxus67ULJY8GTyG5EaSUxXG2Owc7GfV9dvELHiLLXexjQYSgzCd3unhWWmKxfY
         cTozsTAuWMQy0mPG0hm9XfiLMFPklS7xnLLQ6bXZ0j2egBPjoZ0Wr3/fD1HP4Jpd0nnF
         ko0g==
X-Gm-Message-State: APjAAAWpWuSFGFqB017Zenjaqt74XcTLCmKhhX9orQCu4QH66z6nN3n1
        FN2bThJMRPBMerYt4m0OZsqFBkfcOLSZq8fv43E=
X-Google-Smtp-Source: APXvYqynLPmdSNLhpziF/vijEhxYQZVqmzYbFPwtfE+PuECGlAsnYff4gawpAvHezgL8NLLeMoqRQ7S7rFoPF+/bARE=
X-Received: by 2002:a6b:6e06:: with SMTP id d6mr15011186ioh.95.1581470366660;
 Tue, 11 Feb 2020 17:19:26 -0800 (PST)
MIME-Version: 1.0
References: <20200211224416.29318.44077.stgit@localhost.localdomain>
 <20200211150510.ca864143284c8ccaa906f524@linux-foundation.org>
 <c45a6e8ab6af089da1001c0db28783dcea6bebd5.camel@linux.intel.com> <20200211161927.1068232d044e892782aef9ae@linux-foundation.org>
In-Reply-To: <20200211161927.1068232d044e892782aef9ae@linux-foundation.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 11 Feb 2020 17:19:15 -0800
Message-ID: <CAKgT0Ud==Z1BAF-ja-ZtGR5Dxj+7dE3YEpB-D-Wk4A9U1Yooew@mail.gmail.com>
Subject: Re: [PATCH v17 0/9] mm / virtio: Provide support for free page reporting
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Matthew Wilcox <willy@infradead.org>, lcapitulino@redhat.com,
        Dave Hansen <dave.hansen@intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Michal Hocko <mhocko@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Oscar Salvador <osalvador@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 4:19 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Tue, 11 Feb 2020 15:55:31 -0800 Alexander Duyck <alexander.h.duyck@linux.intel.com> wrote:
>
> > On the host I just have to monitor /proc/meminfo and I can see the
> > difference. I get the following results on the host, in the enabled case
> > it takes about 30 seconds for it to settle into the final state since I
> > only report page a bit at a time:
> > Baseline/Applied
> >   MemTotal:    131963012 kB
> >   MemFree:      95189740 kB
> >
> > Enabled:
> >   MemTotal:    131963012 kB
> >   MemFree:     126459472 kB
> >
> > This is what I was referring to with the comment above. I had a test I was
> > running back around the first RFC that consisted of bringing up enough VMs
> > so that there was a bit of memory overcommit and then having the VMs in
> > turn run memhog. As I recall the difference between the two was  something
> > like a couple minutes to run through all the VMs as the memhog would take
> > up to 40+ seconds for one that was having to pull from swap while it took
> > only 5 to 7 seconds for the VMs that were all running the page hinting.
> >
> > I had referenced it here in the RFC:
> > https://lore.kernel.org/lkml/20190204181118.12095.38300.stgit@localhost.localdomain/
> >
> > I have been verifying the memory has been getting freed but didn't feel
> > like the test added much value so I haven't added it to the cover page for
> > a while since the time could vary widely and is dependent on things like
> > the disk type used for the host swap since my SSD is likely faster than
> > spinning rust, but may not be as fast as other SSDs on the market. Since
> > the disk speed can play such a huge role I wasn't comfortable posting
> > numbers since the benefits could vary so widely.
>
> OK, thanks.  I'll add the patches to the mm pile.  The new
> mm/page_reporting.c is unreviewed afaict, so I guess you own that for
> now ;)

I will see what I can do to get some additional review of those
patches. There has been some review, but I rewrote that block after
suggestions as I had to split it out over several patches to account
for the gains from the changes in patches 7 and 8.

> It would be very nice to get some feedback from testers asserting "yes,
> this really helped my workload" but I understand this sort of testing
> is hard to obtain at this stage.

Without the QEMU patches applied there isn't much that this patch set
can do on its own, so that is another piece I have to work on. Yet
another reason to make sure it does no harm if it is not enabled.

So far the one that surprised me the most is that somebody from Huawei
was working to add device pass-thru support to it already.
https://lore.kernel.org/lkml/1578408399-20092-1-git-send-email-weiqi4@huawei.com/

Thanks.

- Alex
