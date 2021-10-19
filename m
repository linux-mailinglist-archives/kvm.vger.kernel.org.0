Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C69E433CFE
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 19:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbhJSRJ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 13:09:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:47372 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230303AbhJSRJ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 13:09:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="215740673"
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="215740673"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2021 10:07:44 -0700
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="574261206"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2021 10:07:43 -0700
Date:   Tue, 19 Oct 2021 10:11:34 -0700
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [RFC 01/20] iommu/iommufd: Add /dev/iommu core
Message-ID: <20211019101134.00ee12ac@jacob-builder>
In-Reply-To: <20211019165747.GU2744544@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
        <20210919063848.1476776-2-yi.l.liu@intel.com>
        <20210921154138.GM327412@nvidia.com>
        <PH0PR11MB56583356619B3ECC23AB1BA8C3B99@PH0PR11MB5658.namprd11.prod.outlook.com>
        <20211015111807.GD2744544@nvidia.com>
        <20211019095734.2a3fb785@jacob-builder>
        <20211019165747.GU2744544@nvidia.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On Tue, 19 Oct 2021 13:57:47 -0300, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Oct 19, 2021 at 09:57:34AM -0700, Jacob Pan wrote:
> > Hi Jason,
> > 
> > On Fri, 15 Oct 2021 08:18:07 -0300, Jason Gunthorpe <jgg@nvidia.com>
> > wrote: 
> > > On Fri, Oct 15, 2021 at 09:18:06AM +0000, Liu, Yi L wrote:
> > >   
> > > > >   Acquire from the xarray is
> > > > >    rcu_lock()
> > > > >    ioas = xa_load()
> > > > >    if (ioas)
> > > > >       if (down_read_trylock(&ioas->destroying_lock))    
> > > > 
> > > > all good suggestions, will refine accordingly. Here destroying_lock
> > > > is a rw_semaphore. right? Since down_read_trylock() accepts a
> > > > rwsem.    
> > > 
> > > Yes, you probably need a sleeping lock
> > >   
> > I am not following why we want a sleeping lock inside RCU protected
> > section?  
> 
> trylock is not sleeping
Of course, thanks for clarifying.

> > For ioas, do we really care about the stale data to choose rw_lock vs
> > RCU? Destroying can be kfree_rcu?  
> 
> It needs a hard fence so things don't continue to use the IOS once it
> is destroyed.
I guess RCU can do that also perhaps can scale better?

> Jason


Thanks,

Jacob
