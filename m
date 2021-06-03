Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC62F39A9DE
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 20:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhFCSSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 14:18:41 -0400
Received: from mga04.intel.com ([192.55.52.120]:11462 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFCSSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 14:18:41 -0400
IronPort-SDR: nq+U15UXWPM6lMBVvzAr1toyl85P2Lu4L1uWLCz7i+/BrUHwwA6cbKHl1CCTn0pJKMFHUR4gX+
 0ArvgLdU68Yg==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="202256216"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="202256216"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 11:16:38 -0700
IronPort-SDR: 9pBvENtfWuBMbET//Z1zc0S1vJhEpeu/skYlOjWVxtlNDyqkMly957fa7Ne228wAOY12hp6yte
 ueK+lCzlzh/A==
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="417479645"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 11:16:37 -0700
Date:   Thu, 3 Jun 2021 11:19:14 -0700
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Shenming Lu <lushenming@huawei.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210603111914.653c4f61@jacob-builder>
In-Reply-To: <23a482f9-b88a-da98-3800-f3fd9ea85fbd@huawei.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
        <c9c066ae-2a25-0799-51a7-0ca47fff41a1@huawei.com>
        <aa1624bf-e472-2b66-1d20-54ca23c19fd2@linux.intel.com>
        <ed4f6e57-4847-3ed2-75de-cea80b2fbdb8@huawei.com>
        <01fe5034-42c8-6923-32f1-e287cc36bccc@linux.intel.com>
        <20210601173323.GN1002214@nvidia.com>
        <23a482f9-b88a-da98-3800-f3fd9ea85fbd@huawei.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shenming,

On Wed, 2 Jun 2021 12:50:26 +0800, Shenming Lu <lushenming@huawei.com>
wrote:

> On 2021/6/2 1:33, Jason Gunthorpe wrote:
> > On Tue, Jun 01, 2021 at 08:30:35PM +0800, Lu Baolu wrote:
> >   
> >> The drivers register per page table fault handlers to /dev/ioasid which
> >> will then register itself to iommu core to listen and route the per-
> >> device I/O page faults.   
> > 
> > I'm still confused why drivers need fault handlers at all?  
> 
> Essentially it is the userspace that needs the fault handlers,
> one case is to deliver the faults to the vIOMMU, and another
> case is to enable IOPF on the GPA address space for on-demand
> paging, it seems that both could be specified in/through the
> IOASID_ALLOC ioctl?
> 
I would think IOASID_BIND_PGTABLE is where fault handler should be
registered. There wouldn't be any IO page fault without the binding anyway.

I also don't understand why device drivers should register the fault
handler, the fault is detected by the pIOMMU and injected to the vIOMMU. So
I think it should be the IOASID itself register the handler.

> Thanks,
> Shenming
> 


Thanks,

Jacob
