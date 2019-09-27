Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE25FBFE8F
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 07:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbfI0FfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 01:35:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47254 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbfI0FfC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 01:35:02 -0400
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C674E8535D
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 05:35:01 +0000 (UTC)
Received: by mail-pf1-f197.google.com with SMTP id b13so1118227pfp.6
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 22:35:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mBl7CqEFnuiBVIosznLhBRSsfbIbyqx6omx1FBXMtlc=;
        b=V9ofc7hSKNUETA17eMb2gQtXT79Dii/MDbnDktMyb9/LnBHeCJw6WAtkaqf62qYGiY
         Swvg0qNTwtrUa5oLEK2k+IB0ePDM4a79aRnA85++NX1LCKmOuiP5wx2D4Ko7IPanvIdj
         mA/IF8ANbyQCjM84x52GXgO+2xDr2C3irq/yuRu+31PcbQBEyCqaWIVh36O/bQpvJxde
         H2PwjOh8E3hj0hiANGIhSVDyWLRMOuIGcRUVLMalrSUgkWgumWuND9SFI5gpYuPBHiSd
         QxH+qJxBtZi/QfErcpk9ZriyVeoMATCT6oSRI0WxK6ZtcCaXwx9MxCSfD82m5+67ipen
         bhQQ==
X-Gm-Message-State: APjAAAWKbDN7EMOwWoUSzNhsaeuj7gydGx0dso9TcPN+SsDinB55rsBg
        cpPMcsE2ihFnNXRY1b0jfH9YpGdWqGPNhcQSiadhsWQ0WCO98Iot8kYN7rFLREuTvWhU2wSDP40
        jMa9Hn68KelkK
X-Received: by 2002:a17:902:bcc7:: with SMTP id o7mr2651683pls.171.1569562501266;
        Thu, 26 Sep 2019 22:35:01 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw+d8wnzo3fq8B9I9MvsVPlu0L/7S0a7m9u5S0N98kvFGYIuq3wGdoeC/vaNpEkgYdVd0Zc4A==
X-Received: by 2002:a17:902:bcc7:: with SMTP id o7mr2651659pls.171.1569562500947;
        Thu, 26 Sep 2019 22:35:00 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s3sm3832607pjq.32.2019.09.26.22.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 22:34:59 -0700 (PDT)
Date:   Fri, 27 Sep 2019 13:34:49 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        kevin.tian@intel.com, Yi Sun <yi.y.sun@linux.intel.com>,
        ashok.raj@intel.com, kvm@vger.kernel.org, sanjay.k.kumar@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        yi.y.sun@intel.com
Subject: Re: [RFC PATCH 2/4] iommu/vt-d: Add first level page table interfaces
Message-ID: <20190927053449.GA9412@xz-x1>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122454.9888-3-baolu.lu@linux.intel.com>
 <20190925052157.GL28074@xz-x1>
 <c9792e0b-bf42-1dbb-f060-0b1a43125f47@linux.intel.com>
 <20190926034905.GW28074@xz-x1>
 <52778812-129b-0fa7-985d-5814e9d84047@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52778812-129b-0fa7-985d-5814e9d84047@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Baolu,

On Fri, Sep 27, 2019 at 10:27:24AM +0800, Lu Baolu wrote:
> > > > > +	spin_lock(&(domain)->page_table_lock);				\
> > > > 
> > > > Is this intended to lock here instead of taking the lock during the
> > > > whole page table walk?  Is it safe?
> > > > 
> > > > Taking the example where nm==PTE: when we reach here how do we
> > > > guarantee that the PMD page that has this PTE is still valid?
> > > 
> > > We will always keep the non-leaf pages in the table,
> > 
> > I see.  Though, could I ask why?  It seems to me that the existing 2nd
> > level page table does not keep these when unmap, and it's not even use
> > locking at all by leveraging cmpxchg()?
> 
> I still need some time to understand how cmpxchg() solves the race issue
> when reclaims pages. For example.
> 
> Thread A				Thread B
> -A1: check all PTE's empty		-B1: up-level PDE valid
> -A2: clear the up-level PDE
> -A3: reclaim the page			-B2: populate the PTEs
> 
> Both (A1,A2) and (B1,B2) should be atomic. Otherwise, race could happen.

I'm not sure of this, but IMHO it is similarly because we need to
allocate the iova ranges from iova allocator first, so thread A (who's
going to unmap pages) and thread B (who's going to map new pages)
should never have collapsed regions if happening concurrently.  I'm
referring to intel_unmap() in which we won't free the iova region
before domain_unmap() completes (which should cover the whole process
of A1-A3) so the same iova range to be unmapped won't be allocated to
any new pages in some other thread.

There's also a hint in domain_unmap():

  /* we don't need lock here; nobody else touches the iova range */

> 
> Actually, the iova allocator always packs IOVA ranges close to the top
> of the address space. This results in requiring a minimal number of
> pages to map the allocated IOVA ranges, which makes memory onsumption
> by IOMMU page tables tolerable. Hence, we don't need to reclaim the
> pages until the whole page table is about to tear down. The real data
> on my test machine also improves this.

Do you mean you have run the code with a 1st-level-supported IOMMU
hardware?  IMHO any data point would be good to be in the cover letter
as reference.

[...]

> > > > > +static struct page *
> > > > > +mmunmap_pte_range(struct dmar_domain *domain, pmd_t *pmd,
> > > > > +		  unsigned long addr, unsigned long end,
> > > > > +		  struct page *freelist, bool reclaim)
> > > > > +{
> > > > > +	int i;
> > > > > +	unsigned long start;
> > > > > +	pte_t *pte, *first_pte;
> > > > > +
> > > > > +	start = addr;
> > > > > +	pte = pte_offset_kernel(pmd, addr);
> > > > > +	first_pte = pte;
> > > > > +	do {
> > > > > +		set_pte(pte, __pte(0));
> > > > > +	} while (pte++, addr += PAGE_SIZE, addr != end);
> > > > > +
> > > > > +	domain_flush_cache(domain, first_pte, (void *)pte - (void *)first_pte);
> > > > > +
> > > > > +	/* Add page to free list if all entries are empty. */
> > > > > +	if (reclaim) {
> > > > 
> > > > Shouldn't we know whether to reclaim if with (addr, end) specified as
> > > > long as they cover the whole range of this PMD?
> > > 
> > > Current policy is that we don't reclaim any pages until the whole page
> > > table will be torn down.
> > 
> > Ah OK.  But I saw that you're passing in relaim==!start_addr.
> > Shouldn't that errornously trigger if one wants to unmap the 1st page
> > as well even if not the whole address space?
> 
> IOVA 0 is assumed to be reserved by the allocator. Otherwise, we have no
> means to check whether a IOVA is valid.

Is this an assumption of the allocator?  Could that change in the future?

IMHO that's not necessary if so, after all it's as simple as replacing
(!start_addr) with (start == 0 && end == END).  I see that in
domain_unmap() it has a similar check when freeing pgd:

  if (start_pfn == 0 && last_pfn == DOMAIN_MAX_PFN(domain->gaw))

Thanks,

-- 
Peter Xu
