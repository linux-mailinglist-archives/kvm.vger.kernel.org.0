Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 025E0E74FF
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2019 16:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbfJ1PYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Oct 2019 11:24:17 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:35394 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbfJ1PYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Oct 2019 11:24:17 -0400
Received: by mail-il1-f194.google.com with SMTP id p8so8536564ilp.2;
        Mon, 28 Oct 2019 08:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d5lAMRfHtk2EQ8kdZ9OB3W0LQMkhl/amzHwPWCWvW14=;
        b=Z6vYaxKPcOGy25FF9pf7qir9Rqlme+c8mQkk8btbXmmVTT6UYwfOsWMly7W9XEBI8o
         HgHhJ9AIO22Uuqga8nvRkREa14Tot8KYdkJYmaQV4aLJEuxiRnEnGyopc36qgx47eVwQ
         b3alzoWycnAQaPezRAm/VrlBY/C2qzw2fG/lFzRhHuf6vNIJMuf+sxbrykS33gOIZ1ai
         IFSna665SU1lHebs9BEOZwxW+MLBL3wk79T+hm1g5RlSo4wbP2ar3eE49gDiP+rtSP07
         A8KAmicIlutBIEc579NOBUdeHFKSvtwXKaLzxAil4m13JC2TeI6SlhgwE8i9Cwn+okdC
         SVMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d5lAMRfHtk2EQ8kdZ9OB3W0LQMkhl/amzHwPWCWvW14=;
        b=tVuWr9OA3e1g2pezHrCFb7R5DDB2ME8DKnSX9itBLsQ/s5OMwPrBgbCS1jwgPOvEr5
         ohyO3T3zfLEcMHbmmMKsJz7avwo+GdCggMzutan4shHmJqsMPgVuYHkuSQDySYJata8k
         OBcQi/ywbbktc20FQHachYiHHGVFnpIe4u84dT/iGwLDlAX5XFNkihIDsEj94Zp6QK17
         Ya6LiBqniZs/uf+0i2CqRuVrHiMJOfflh7tXPtlsG21xhDVMT1gwCl2ODPkfPEH6/nDa
         APA8XFS5PubMdBRChpnYeJyHEl66H38OlsPnUz5fcPMHpX7FQraLzfPC+63t1UpWRv3X
         rbrQ==
X-Gm-Message-State: APjAAAWaAYKNHuSyrCU1uJmIvjqdmIPzKYK+nqKa+iRYFZasFEe6guqu
        V0AslAob+6DY4mAIeVPN9TCYdQcmsFJ9VngQqw0=
X-Google-Smtp-Source: APXvYqyfgTgUajiGv2w6khwqi9U4IsCrcrOyR1GO4gPo2AlNqjopyIrCsEicGQbR4CIN0pp166szPL4Do0g9w/mvrSU=
X-Received: by 2002:a92:9f1c:: with SMTP id u28mr19473440ili.97.1572276256522;
 Mon, 28 Oct 2019 08:24:16 -0700 (PDT)
MIME-Version: 1.0
References: <20191022221223.17338.5860.stgit@localhost.localdomain> <3888d486-d046-b35f-a365-655f8c4d3bf2@redhat.com>
In-Reply-To: <3888d486-d046-b35f-a365-655f8c4d3bf2@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 28 Oct 2019 08:24:05 -0700
Message-ID: <CAKgT0UdkPwsc8KrSAURt1FuD8nX8o50CLDcd21RQw8AW7PVMVg@mail.gmail.com>
Subject: Re: [PATCH v12 0/6] mm / virtio: Provide support for unused page reporting
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        Dave Hansen <dave.hansen@intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Oscar Salvador <osalvador@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 28, 2019 at 7:34 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
>
> On 10/22/19 6:27 PM, Alexander Duyck wrote:
>
>
> [...]
> > Below are the results from various benchmarks. I primarily focused on two
> > tests. The first is the will-it-scale/page_fault2 test, and the other is
> > a modified version of will-it-scale/page_fault1 that was enabled to use
> > THP. I did this as it allows for better visibility into different parts
> > of the memory subsystem. The guest is running on one node of a E5-2630 v3
> > CPU with 48G of RAM that I split up into two logical nodes in the guest
> > in order to test with NUMA as well.
> >
> > Test              page_fault1 (THP)     page_fault2
> > Baseline       1  1256106.33  +/-0.09%   482202.67  +/-0.46%
> >                 16  8864441.67  +/-0.09%  3734692.00  +/-1.23%
> >
> > Patches applied  1  1257096.00  +/-0.06%   477436.00  +/-0.16%
> >                 16  8864677.33  +/-0.06%  3800037.00  +/-0.19%
> >
> > Patches enabled        1  1258420.00  +/-0.04%   480080.00  +/-0.07%
> >  MADV disabled  16  8753840.00  +/-1.27%  3782764.00  +/-0.37%
> >
> > Patches enabled        1  1267916.33  +/-0.08%   472075.67  +/-0.39%
> >                 16  8287050.33  +/-0.67%  3774500.33  +/-0.11%
>
> If I am not mistaken then you are only observing the number of processes (and
> not the number of threads) launched over the 1st and the 16th vcpu  reported by
> will-it-scale?

You are correct these results are for the processes. I monitored them
for 1 - 16, but only included the results for 1 and 16 since those
seem to be the most relevant data points.
