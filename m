Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86613B0CCC
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 12:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731082AbfILKY1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 06:24:27 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34879 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730811AbfILKY1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 06:24:27 -0400
Received: by mail-ed1-f66.google.com with SMTP id f24so5847399edv.2
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 03:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+mmfaBX0Np9W/b7Q5MqD32lbNina1cQ/FOr9Xbx+2SA=;
        b=rjY82Sy3etyc/lURHAAH5Zl+/VTkVL1QfiSGIjGFzaoW/tFRFM+zEYupBdTECALHrG
         yPnD/zet+9v/0zbzm/E5VjxIC4kHBGoI6fG6y3ZudVWE1Fqr5jUEFHOhmpHGUgJBjFLR
         Pp4qZYYyCBsVXmvAX8dVxq7xFDjWJd+exfdSoleHOrbAKfryXx1FyZtARD7dR7tAJFzo
         JrefYLyjWx+Ptmb0NQyHMPY02QIUK5RaU1NoX/BBPIIVc7yZpU9xVdpA7vqiSPpdXXbt
         d5OJ8VA03djK7lmxCv6oPg+S+/UFNoBoSlbJXwZ5azlQ2uo9F1xXDa4+5x33RZHpoQkO
         TV/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+mmfaBX0Np9W/b7Q5MqD32lbNina1cQ/FOr9Xbx+2SA=;
        b=E7iKzuaKHIaemnUi+yl9RTpAKb1WBEUx3+zqiWDxXZqH617bQ5fiYFp/2OAe4rPXmB
         GNk2fDgsKVtY5VAl1s5Yip1hjKnzGjPY61BRqxEGWb4dRbYrxlhdPX2GRWdQMovNIbCR
         P6xc6uTiaVESgdNMhVNvqpjfQlQEf7unJUT0ErY2Jw+6QABG0jUgEJ1F1UOpgwok8sx2
         Rh3dOkmi7EitwzNVUQvP7PyLLdyt2MJmd6weP8hpSsCbsrVA6/f0VeVJhPWIc87oU9xS
         xHgPyHFY7phlTvGHc2T2EIgQJnBLU8PJg3N2R9K3kT3ve8BGOWi7i6d4fsHlQUPy9cq2
         rA3Q==
X-Gm-Message-State: APjAAAUYZMHmNDJ/COZ/yhl1/N/z7qyxlMHcP9PnQMNtFI8csjHxTWP9
        ZkcyyVcQ7/UlOSo15H7BnJcQfw==
X-Google-Smtp-Source: APXvYqxqQuNiTjkjaC8Hs02PHF+LHAOwtw4KJLDqhBlQ3F6XmLygJAqZUw/cEZVOIq4hY2vxi9be2Q==
X-Received: by 2002:a50:8961:: with SMTP id f30mr40528236edf.144.1568283865271;
        Thu, 12 Sep 2019 03:24:25 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id qt5sm2710889ejb.11.2019.09.12.03.24.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2019 03:24:24 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 04633100B4A; Thu, 12 Sep 2019 13:24:26 +0300 (+03)
Date:   Thu, 12 Sep 2019 13:24:25 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
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
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v9 0/8] stg mail -e --version=v9 \
Message-ID: <20190912102425.wzhhe6ygfgg64sma@box>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
 <20190910124209.GY2063@dhcp22.suse.cz>
 <CAKgT0Udr6nYQFTRzxLbXk41SiJ-pcT_bmN1j1YR4deCwdTOaUQ@mail.gmail.com>
 <20190910144713.GF2063@dhcp22.suse.cz>
 <CAKgT0UdB4qp3vFGrYEs=FwSXKpBEQ7zo7DV55nJRO2C-KCEOrw@mail.gmail.com>
 <20190910175213.GD4023@dhcp22.suse.cz>
 <1d7de9f9f4074f67c567dbb4cc1497503d739e30.camel@linux.intel.com>
 <20190911113619.GP4023@dhcp22.suse.cz>
 <CAKgT0UfOp1c+ov=3pBD72EkSB9Vm7mG5G6zJj4=j=UH7zCgg2Q@mail.gmail.com>
 <20190912091925.GM4023@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912091925.GM4023@dhcp22.suse.cz>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 12, 2019 at 11:19:25AM +0200, Michal Hocko wrote:
> On Wed 11-09-19 08:12:03, Alexander Duyck wrote:
> > On Wed, Sep 11, 2019 at 4:36 AM Michal Hocko <mhocko@kernel.org> wrote:
> > >
> > > On Tue 10-09-19 14:23:40, Alexander Duyck wrote:
> > > [...]
> > > > We don't put any limitations on the allocator other then that it needs to
> > > > clean up the metadata on allocation, and that it cannot allocate a page
> > > > that is in the process of being reported since we pulled it from the
> > > > free_list. If the page is a "Reported" page then it decrements the
> > > > reported_pages count for the free_area and makes sure the page doesn't
> > > > exist in the "Boundary" array pointer value, if it does it moves the
> > > > "Boundary" since it is pulling the page.
> > >
> > > This is still a non-trivial limitation on the page allocation from an
> > > external code IMHO. I cannot give any explicit reason why an ordering on
> > > the free list might matter (well except for page shuffling which uses it
> > > to make physical memory pattern allocation more random) but the
> > > architecture seems hacky and dubious to be honest. It shoulds like the
> > > whole interface has been developed around a very particular and single
> > > purpose optimization.
> > 
> > How is this any different then the code that moves a page that will
> > likely be merged to the tail though?
> 
> I guess you are referring to the page shuffling. If that is the case
> then this is an integral part of the allocator for a reason and it is
> very well obvious in the code including the consequences. I do not
> really like an idea of hiding similar constrains behind a generic
> looking feature which is completely detached from the allocator and so
> any future change of the allocator might subtly break it.

I don't necessary follow why shuffling is more integral to page allocator
than reporting would be. It's next to shutffle.c under mm/ and integrated
in a simillar way.

-- 
 Kirill A. Shutemov
