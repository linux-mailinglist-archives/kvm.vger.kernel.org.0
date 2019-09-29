Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1A9BC137F
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2019 07:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfI2FZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Sep 2019 01:25:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44172 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbfI2FZv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Sep 2019 01:25:51 -0400
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8A68E83F42
        for <kvm@vger.kernel.org>; Sun, 29 Sep 2019 05:25:50 +0000 (UTC)
Received: by mail-pg1-f200.google.com with SMTP id h36so6485164pgb.3
        for <kvm@vger.kernel.org>; Sat, 28 Sep 2019 22:25:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=U2Fqhrhhc3c5hT+09GB0Tz123AzZHSVYeE1k74C2N8Q=;
        b=nAmoNxIzgTUqRxmJCg+EsNbr9jhaDcjtQD7MSompb/KGp591J7QR93grZ/8os1rbIO
         4qen65f3G7A8S55+8+ZR+AWFkKI+5/og4U9XLwPtB8wDxQX7SIeAuPfxYW+3hXt7sLPo
         sz1zoptih2Xe/RzpGzqwumgKmpwbPCWxUPQdvfytPGwItC/k6/KNDJepO0+6K2q/0oEh
         e9lYKg6hmg2EG5FmJ04O/wTk+Hk5VDUUDk8oKNdmee9hHZNLQcw3KUyicDUXQmnRKGEM
         w+3OlImjjb6cUylVj25OHaGqnF7BGaCXRVl2Rv3JMsM3q+cmXZwhsdmdz6yjNjYWBcs1
         yBOQ==
X-Gm-Message-State: APjAAAXVoUSYICEfd/lpsBBARikuBCS1bCbNq3N19tZf8vAX0egcKGtz
        7bZfmrFd5RiZAxgERT1pO+YFB+Xb2QzzOsJ3EHBokxAms6DkW+MWOQTfq4ipNmgDVG/EzpDNTku
        OBZ9Sk6S7j0o+
X-Received: by 2002:a65:6111:: with SMTP id z17mr17809438pgu.415.1569734749963;
        Sat, 28 Sep 2019 22:25:49 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxSwESBBqWbUZ8IYCB+ndAeHAFp/knXskQIwKbF6UdAPwArDrPxhK0qMIyDkQyFVFJVbYrxHA==
X-Received: by 2002:a65:6111:: with SMTP id z17mr17809411pgu.415.1569734749539;
        Sat, 28 Sep 2019 22:25:49 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y6sm7985721pfp.82.2019.09.28.22.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 22:25:47 -0700 (PDT)
Date:   Sun, 29 Sep 2019 13:25:32 +0800
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
Message-ID: <20190929052532.GA12953@xz-x1>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122454.9888-3-baolu.lu@linux.intel.com>
 <20190925052157.GL28074@xz-x1>
 <c9792e0b-bf42-1dbb-f060-0b1a43125f47@linux.intel.com>
 <20190926034905.GW28074@xz-x1>
 <52778812-129b-0fa7-985d-5814e9d84047@linux.intel.com>
 <20190927053449.GA9412@xz-x1>
 <66823e27-aa33-5968-b5fd-e5221fb1fffe@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <66823e27-aa33-5968-b5fd-e5221fb1fffe@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 28, 2019 at 04:23:16PM +0800, Lu Baolu wrote:
> Hi Peter,
> 
> On 9/27/19 1:34 PM, Peter Xu wrote:
> > Hi, Baolu,
> > 
> > On Fri, Sep 27, 2019 at 10:27:24AM +0800, Lu Baolu wrote:
> > > > > > > +	spin_lock(&(domain)->page_table_lock);				\
> > > > > > 
> > > > > > Is this intended to lock here instead of taking the lock during the
> > > > > > whole page table walk?  Is it safe?
> > > > > > 
> > > > > > Taking the example where nm==PTE: when we reach here how do we
> > > > > > guarantee that the PMD page that has this PTE is still valid?
> > > > > 
> > > > > We will always keep the non-leaf pages in the table,
> > > > 
> > > > I see.  Though, could I ask why?  It seems to me that the existing 2nd
> > > > level page table does not keep these when unmap, and it's not even use
> > > > locking at all by leveraging cmpxchg()?
> > > 
> > > I still need some time to understand how cmpxchg() solves the race issue
> > > when reclaims pages. For example.
> > > 
> > > Thread A				Thread B
> > > -A1: check all PTE's empty		-B1: up-level PDE valid
> > > -A2: clear the up-level PDE
> > > -A3: reclaim the page			-B2: populate the PTEs
> > > 
> > > Both (A1,A2) and (B1,B2) should be atomic. Otherwise, race could happen.
> > 
> > I'm not sure of this, but IMHO it is similarly because we need to
> > allocate the iova ranges from iova allocator first, so thread A (who's
> > going to unmap pages) and thread B (who's going to map new pages)
> > should never have collapsed regions if happening concurrently.  I'm
> 
> Although they don't collapse, they might share a same pmd entry. If A
> cleared the pmd entry and B goes ahead with populating the pte's. It
> will crash.

My understanding is that if A was not owning all the pages on that PMD
entry then it will never free the page that was backing that PMD
entry.  Please refer to the code in dma_pte_clear_level() where it
has:

        /* If range covers entire pagetable, free it */
        if (start_pfn <= level_pfn &&
                last_pfn >= level_pfn + level_size(level) - 1) {
                ...
        } else {
                ...
        }

Note that when going into the else block, the PMD won't be freed but
only the PTEs that upon the PMD will be cleared.

In the case you mentioned above, IMHO it should go into that else
block.  Say, thread A must not contain the whole range of that PMD
otherwise thread B won't get allocated with pages within that range
covered by the same PMD.

Thanks,

-- 
Peter Xu
