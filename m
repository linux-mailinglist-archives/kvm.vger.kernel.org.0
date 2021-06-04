Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF8039BCE9
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 18:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhFDQVz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 4 Jun 2021 12:21:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:33810 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229667AbhFDQVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 12:21:54 -0400
IronPort-SDR: 5+W7pf5l1yBpcI/BBBc7rWLyqFeMVDlxOROqny9Q6+q0BwkeJR+098U8siZo4Gb+AeJ3leiFGt
 zaO4YtxYwLvg==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="204134791"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="204134791"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 09:20:05 -0700
IronPort-SDR: CTvtJdPKdL7KqXyLzIbdMrFdnFKp+Ju+OSzf2PnUoTrmxEGmg1uGDqEgovEeQOFzdWMSQpKoeJ
 wr0Z0gzGuBXA==
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="446738781"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 09:20:05 -0700
Date:   Fri, 4 Jun 2021 09:22:43 -0700
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Shenming Lu <lushenming@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210604092243.245bd0f4@jacob-builder>
In-Reply-To: <1175ebd5-9d8e-2000-6d05-baa93e960915@redhat.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
        <c9c066ae-2a25-0799-51a7-0ca47fff41a1@huawei.com>
        <aa1624bf-e472-2b66-1d20-54ca23c19fd2@linux.intel.com>
        <ed4f6e57-4847-3ed2-75de-cea80b2fbdb8@huawei.com>
        <01fe5034-42c8-6923-32f1-e287cc36bccc@linux.intel.com>
        <20210601173323.GN1002214@nvidia.com>
        <23a482f9-b88a-da98-3800-f3fd9ea85fbd@huawei.com>
        <20210603111914.653c4f61@jacob-builder>
        <1175ebd5-9d8e-2000-6d05-baa93e960915@redhat.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On Fri, 4 Jun 2021 09:30:37 +0800, Jason Wang <jasowang@redhat.com> wrote:

> 在 2021/6/4 上午2:19, Jacob Pan 写道:
> > Hi Shenming,
> >
> > On Wed, 2 Jun 2021 12:50:26 +0800, Shenming Lu <lushenming@huawei.com>
> > wrote:
> >  
> >> On 2021/6/2 1:33, Jason Gunthorpe wrote:  
> >>> On Tue, Jun 01, 2021 at 08:30:35PM +0800, Lu Baolu wrote:
> >>>      
> >>>> The drivers register per page table fault handlers to /dev/ioasid
> >>>> which will then register itself to iommu core to listen and route
> >>>> the per- device I/O page faults.  
> >>> I'm still confused why drivers need fault handlers at all?  
> >> Essentially it is the userspace that needs the fault handlers,
> >> one case is to deliver the faults to the vIOMMU, and another
> >> case is to enable IOPF on the GPA address space for on-demand
> >> paging, it seems that both could be specified in/through the
> >> IOASID_ALLOC ioctl?
> >>  
> > I would think IOASID_BIND_PGTABLE is where fault handler should be
> > registered. There wouldn't be any IO page fault without the binding
> > anyway.
> >
> > I also don't understand why device drivers should register the fault
> > handler, the fault is detected by the pIOMMU and injected to the
> > vIOMMU. So I think it should be the IOASID itself register the handler.
> >  
> 
> 
> As discussed in another thread.
> 
> I think the reason is that ATS doesn't forbid the #PF to be reported via 
> a device specific way.
> 
Yes, in that case we should support both. Give the device driver a chance
to handle the IOPF if it can.

> Thanks
> 
> 
> >  
> >> Thanks,
> >> Shenming
> >>  
> >
> > Thanks,
> >
> > Jacob
> >  
> 


Thanks,

Jacob
