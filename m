Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57EAC26B04D
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 00:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgIOWHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 18:07:08 -0400
Received: from mga03.intel.com ([134.134.136.65]:48289 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728131AbgIOWG6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 18:06:58 -0400
IronPort-SDR: S+YXMIwPgmI81wypZUNsFQ/1O3Q9czlRIx4V60mVzWqSBXtvEBXEVd9+gI1pz8S4o4SqFqT5TQ
 iqSu9OswDieA==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="159408574"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="159408574"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 15:06:50 -0700
IronPort-SDR: EfDWGJzMGmk10dgnAirVuFw17Os1O9V/Z1BF1Y8pAKaT0+yY+JGcISidpqtFqTI4uX9m7sRxzv
 NzGPvFeRi0Xw==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="302326059"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 15:06:50 -0700
Date:   Tue, 15 Sep 2020 15:08:51 -0700
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>, <eric.auger@redhat.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <kevin.tian@intel.com>, <jun.j.tian@intel.com>,
        <yi.y.sun@intel.com>, <peterx@redhat.com>, <hao.wu@intel.com>,
        <stefanha@gmail.com>, <iommu@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Jacon Jun Pan <jacob.jun.pan@intel.com>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200915150851.76436ca1@jacob-builder>
In-Reply-To: <20200915184510.GB1573713@nvidia.com>
References: <20200914134738.GX904879@nvidia.com>
        <20200914162247.GA63399@otc-nc-03>
        <20200914163354.GG904879@nvidia.com>
        <20200914105857.3f88a271@x1.home>
        <20200914174121.GI904879@nvidia.com>
        <20200914122328.0a262a7b@x1.home>
        <20200914190057.GM904879@nvidia.com>
        <20200914224438.GA65940@otc-nc-03>
        <20200915113341.GW904879@nvidia.com>
        <20200915181154.GA70770@otc-nc-03>
        <20200915184510.GB1573713@nvidia.com>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On Tue, 15 Sep 2020 15:45:10 -0300, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Sep 15, 2020 at 11:11:54AM -0700, Raj, Ashok wrote:
> > > PASID applies widely to many device and needs to be introduced with a
> > > wide community agreement so all scenarios will be supportable.  
> > 
> > True, reading some of the earlier replies I was clearly confused as I
> > thought you were talking about mdev again. But now that you stay it, you
> > have moved past mdev and its the PASID interfaces correct?  
> 
> Yes, we agreed mdev for IDXD at LPC, didn't talk about PASID.
> 
> > For the native user applications have just 1 PASID per
> > process. There is no need for a quota management.  
> 
> Yes, there is. There is a limited pool of HW PASID's. If one user fork
> bombs it can easially claim an unreasonable number from that pool as
> each process will claim a PASID. That can DOS the rest of the system.
> 
> If PASID DOS is a worry then it must be solved at the IOMMU level for
> all user applications that might trigger a PASID allocation. VFIO is
> not special.
> 
> > IIUC, you are asking that part of the interface to move to a API
> > interface that potentially the new /dev/sva and VFIO could share? I
> > think the API's for PASID management themselves are generic (Jean's
> > patchset + Jacob's ioasid set management).  
> 
> Yes, the in kernel APIs are pretty generic now, and can be used by
> many types of drivers.
> 
Right, IOMMU UAPIs are not VFIO specific, we pass user pointer to the IOMMU
layer to process.

Similarly for PASID management, the IOASID extensions we are proposing
will handle ioasid_set (groups/pools), quota, permissions, and notifications
in the IOASID core. There is nothing VFIO specific.
https://lkml.org/lkml/2020/8/22/12

> As JasonW kicked this off, VDPA will need all this identical stuff
> too. We already know this, and I think Intel VDPA HW will need it, so
> it should concern you too :)
> 
> A PASID vIOMMU solution sharable with VDPA and VFIO, based on a PASID
> control char dev (eg /dev/sva, or maybe /dev/iommu) seems like a
> reasonable starting point for discussion.
> 
I am not sure what can really be consolidated in /dev/sva. VFIO and VDPA
will have their own kerne-user interfaces anyway for their usage models.
They are just providing the specific transport while sharing generic IOMMU
UAPIs and IOASID management.

As I mentioned PASID management is already consolidated in the IOASID layer,
so for VDPA or other users, it just matter of create its own ioasid_set,
doing allocation.

IOASID is also available to the in-kernel users which does not
need /dev/sva AFAICT. For bare metal SVA, I don't see a need to create this
'floating' state of the PASID when created by /dev/sva. PASID allocation
could happen behind the scene when users need to bind page tables to a
device DMA stream. Security authorization of the PASID is natively enforced
when user try to bind page table, there is no need to pass the FD handle of
the PASID back to the kernel as you suggested earlier.

Thanks,

Jacob
