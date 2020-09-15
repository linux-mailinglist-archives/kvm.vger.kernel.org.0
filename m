Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661C826AD91
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 21:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgIOT1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 15:27:50 -0400
Received: from mga03.intel.com ([134.134.136.65]:34175 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727901AbgIOT0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 15:26:44 -0400
IronPort-SDR: s5j48qpel9yqH5Fd8stCssoC9tAsX3yERgUygbrPBvB8U1Yjwj/nSs7reJYxTlw+vlTfZYdAyB
 xxU0gMaNRlbA==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="159385634"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="159385634"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 12:26:40 -0700
IronPort-SDR: hhhAAG+hfXZ3oD4WJ5QXwumRC8Gx2W6szlEll9sgaTobnOaC2A5t1sTEB3EUHv1UnJ388HHsRk
 FNP12tMYpCbw==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="482954094"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 12:26:39 -0700
Date:   Tue, 15 Sep 2020 12:26:32 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org, kevin.tian@intel.com,
        jacob.jun.pan@linux.intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jacon Jun Pan <jacob.jun.pan@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200915192632.GA71024@otc-nc-03>
References: <20200914162247.GA63399@otc-nc-03>
 <20200914163354.GG904879@nvidia.com>
 <20200914105857.3f88a271@x1.home>
 <20200914174121.GI904879@nvidia.com>
 <20200914122328.0a262a7b@x1.home>
 <20200914190057.GM904879@nvidia.com>
 <20200914224438.GA65940@otc-nc-03>
 <20200915113341.GW904879@nvidia.com>
 <20200915181154.GA70770@otc-nc-03>
 <20200915184510.GB1573713@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915184510.GB1573713@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 03:45:10PM -0300, Jason Gunthorpe wrote:
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

Not sure how you had this played out.. For PASID used in ENQCMD today for
our SVM usages, we *DO* not automatically propagate or allocate new PASIDs. 

The new process needs to bind to get a PASID for its own use. For threads
of same process the PASID is inherited. For forks(), we do not
auto-allocate them. Since PASID isn't a sharable resource much like how you
would not pass mmio mmap's to forked processes that cannot be shared correct?
Such as your doorbell space for e.g. 

> 
> If PASID DOS is a worry then it must be solved at the IOMMU level for
> all user applications that might trigger a PASID allocation. VFIO is
> not special.

Feels like you can simply avoid the PASID DOS rather than permit it to
happen. 
> 
> > IIUC, you are asking that part of the interface to move to a API interface
> > that potentially the new /dev/sva and VFIO could share? I think the API's
> > for PASID management themselves are generic (Jean's patchset + Jacob's
> > ioasid set management).
> 
> Yes, the in kernel APIs are pretty generic now, and can be used by
> many types of drivers.

Good, so there is no new requirements here I suppose.
> 
> As JasonW kicked this off, VDPA will need all this identical stuff
> too. We already know this, and I think Intel VDPA HW will need it, so
> it should concern you too :)

This is one of those things that I would disagree and commit :-).. 

> 
> A PASID vIOMMU solution sharable with VDPA and VFIO, based on a PASID
> control char dev (eg /dev/sva, or maybe /dev/iommu) seems like a
> reasonable starting point for discussion.

Looks like now we are getting closer to what we need. :-)

Given that PASID api's are general purpose today and any driver can use it
to take advantage. VFIO fortunately or unfortunately has the IOMMU things
abstracted. I suppose that support is also mostly built on top of the
generic iommu* api abstractions in a vendor neutral way? 

I'm still lost on what is missing that vDPA can't build on top of what is
available?

Cheers,
Ashok
