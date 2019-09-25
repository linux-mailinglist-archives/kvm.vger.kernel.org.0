Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB669BD9F2
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 10:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442779AbfIYIfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 04:35:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49378 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437424AbfIYIfa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 04:35:30 -0400
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9EB21C059B7A
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 08:35:29 +0000 (UTC)
Received: by mail-pg1-f197.google.com with SMTP id 6so3145910pgi.10
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 01:35:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CBc45OeQcvvswm6VllW/DcLsxnRal5m6t5OBDsogK1c=;
        b=DhKmKmiXegYLbt9KL8phJ3vz/YVD4NNhUqMbA/3eJOnVBXnvajE2jYxk36F8mx2CdZ
         ZyAkkSRGdWGn2KuULMgD5IRhu1OCzTV1+uEiRX9bdplB4dxYls58QNJcc8w94rRX83sY
         +vrCitTZ+WJeONK2Hhu1jxANuneBi06fY7W4dQYkkBxj8XUeV4o2Mvx4cBkgUeAtc+V8
         mrQVNvitIziSLan4VsiEOqqShkQHjXjzY1ADVksjYekYfTklXhvZJx7u1uyJKTiyG/Y1
         xX43tmxgPl24KcaacwH8ft103NKUAdvHwWltC6ZAH6pT7m1XzVFpDVJ6C5B8SNrUgilq
         lRxA==
X-Gm-Message-State: APjAAAVmSJTmdYMLxEzFHKVw3qMVnzXLW1zAlUgkYB0r91bqQu7zji9G
        1I0ct2ov9nZ+k56u9UAuYlDiZU8uzV9qNSRfgBp62jfxwH/UBloQSsk8BjBTLGuKo0KQ7AVXmEn
        Xa1K8EhQk1qXV
X-Received: by 2002:a17:90a:a613:: with SMTP id c19mr5107212pjq.11.1569400529149;
        Wed, 25 Sep 2019 01:35:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwTwI2GBx3mYJA7q4j7DwyuCNyNYODVb5K7FYMon6YtcWvF63UgXcbRm5MG2PYtVak+7eQfkA==
X-Received: by 2002:a17:90a:a613:: with SMTP id c19mr5107183pjq.11.1569400528844;
        Wed, 25 Sep 2019 01:35:28 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x6sm9264648pfd.53.2019.09.25.01.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 01:35:27 -0700 (PDT)
Date:   Wed, 25 Sep 2019 16:35:16 +0800
From:   Peter Xu <peterx@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 2/4] iommu/vt-d: Add first level page table interfaces
Message-ID: <20190925083516.GQ28074@xz-x1>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122454.9888-3-baolu.lu@linux.intel.com>
 <20190923203102.GB21816@araj-mobl1.jf.intel.com>
 <9cfe6042-f0fb-ea5e-e134-f6f5bb9eb7b0@linux.intel.com>
 <20190925043050.GK28074@xz-x1>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58F018@SHSMSX104.ccr.corp.intel.com>
 <20190925052402.GM28074@xz-x1>
 <1713f03c-4d47-34ad-f36d-882645c36389@linux.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58F4EA@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D58F4EA@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 25, 2019 at 07:32:48AM +0000, Tian, Kevin wrote:
> > From: Lu Baolu [mailto:baolu.lu@linux.intel.com]
> > Sent: Wednesday, September 25, 2019 2:52 PM
> > 
> > Hi Peter and Kevin,
> > 
> > On 9/25/19 1:24 PM, Peter Xu wrote:
> > > On Wed, Sep 25, 2019 at 04:38:31AM +0000, Tian, Kevin wrote:
> > >>> From: Peter Xu [mailto:peterx@redhat.com]
> > >>> Sent: Wednesday, September 25, 2019 12:31 PM
> > >>>
> > >>> On Tue, Sep 24, 2019 at 09:38:53AM +0800, Lu Baolu wrote:
> > >>>>>> intel_mmmap_range(domain, addr, end, phys_addr, prot)
> > >>>>>
> > >>>>> Maybe think of a different name..? mmmap seems a bit weird :-)
> > >>>>
> > >>>> Yes. I don't like it either. I've thought about it and haven't
> > >>>> figured out a satisfied one. Do you have any suggestions?
> > >>>
> > >>> How about at least split the word using "_"?  Like "mm_map", then
> > >>> apply it to all the "mmm*" prefixes.  Otherwise it'll be easily
> > >>> misread as mmap() which is totally irrelevant to this...
> > >>>
> > >>
> > >> what is the point of keeping 'mm' here? replace it with 'iommu'?
> > >
> > > I'm not sure of what Baolu thought, but to me "mm" makes sense itself
> > > to identify this from real IOMMU page tables (because IIUC these will
> > > be MMU page tables).  We can come up with better names, but IMHO
> > > "iommu" can be a bit misleading to let people refer to the 2nd level
> > > page table.
> > 
> > "mm" represents a CPU (first level) page table;
> > 
> > vs.
> > 
> > "io" represents an IOMMU (second level) page table.
> > 
> 
> IOMMU first level is not equivalent to CPU page table, though you can
> use the latter as the first level (e.g. in SVA). Especially here you are
> making IOVA->GPA as the first level, which is not CPU page table.
> 
> btw both levels are for "io" i.e. DMA purposes from VT-d p.o.v. They
> are just hierarchical structures implemented by VT-d, with slightly
> different format.

Regarding to the "slightly different format", do you mean the
extended-accessed bit?

Even if there are differences, they do look very similar.  If you see
the same chap 9.7 table, the elements are exactly called PTE, PDE,
PDPE, and so on - they're named exactly the same as MMU page tables.
With that, IMHO it still sounds reasonable if we want to relate this
"1st level iommu page table" with the existing MMU page table using
the "mm" prefix...

Regards,

-- 
Peter Xu
