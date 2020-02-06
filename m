Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 922AE154ACC
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 19:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgBFSHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 13:07:36 -0500
Received: from mga18.intel.com ([134.134.136.126]:14788 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727662AbgBFSHg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 13:07:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 10:07:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,410,1574150400"; 
   d="scan'208";a="379143775"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga004.jf.intel.com with ESMTP; 06 Feb 2020 10:07:35 -0800
Date:   Thu, 6 Feb 2020 10:12:53 -0800
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [RFC v3 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Message-ID: <20200206101253.7fb43e07@jacob-builder>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A1993E8@SHSMSX104.ccr.corp.intel.com>
References: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
        <1580299912-86084-2-git-send-email-yi.l.liu@intel.com>
        <20200129165540.335774d5@w520.home>
        <A2975661238FB949B60364EF0F2C25743A1993E8@SHSMSX104.ccr.corp.intel.com>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On Fri, 31 Jan 2020 12:41:06 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > > +static int vfio_iommu_type1_pasid_free(struct vfio_iommu *iommu,
> > > +				       unsigned int pasid)
> > > +{
> > > +	struct vfio_mm *vmm = iommu->vmm;
> > > +	int ret = 0;
> > > +
> > > +	mutex_lock(&iommu->lock);
> > > +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {  
> > 
> > But we could have been IOMMU backed when the pasid was allocated,
> > did we just leak something?  In fact, I didn't spot anything in
> > this series that handles a container with pasids allocated losing
> > iommu backing. I'd think we want to release all pasids when that
> > happens since permission for the user to hold pasids goes along
> > with having an iommu backed device.  
> 
> oh, yes. If a container lose iommu backend, then needs to reclaim the
> allocated PASIDs. right? I'll add it. :-)
> 
> > Also, do we want _free() paths that can fail?  
> 
> I remember we discussed if a _free() path can fail, I think we agreed
> to let _free() path always success. :-)

Just to add some details. We introduced IOASID notifier such that when
VFIO frees a PASID, consumers such as IOMMU, can do the cleanup
therefore ensure free always succeeds.
https://www.spinics.net/lists/kernel/msg3349928.html
https://www.spinics.net/lists/kernel/msg3349930.html
This was not in my v9 set as I was considering some race conditions
w.r.t. registering notifier, gets notifications, and free call. I will
post it in v10.

Thanks,

Jacob
