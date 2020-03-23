Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7C9818EE1E
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 03:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgCWCxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 22:53:06 -0400
Received: from mga14.intel.com ([192.55.52.115]:19865 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727059AbgCWCxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 22:53:06 -0400
IronPort-SDR: //UD5DrvzBtkjxZOdNDsaDUQWyHSKVRL9WJsJ3lZijXAGYbJIfGFcdTozARhmJ0lCcHobmQXmK
 qG/4d9Nhj10Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 19:53:04 -0700
IronPort-SDR: lqqBrhqceOe8jZ9MbL23llbbR4S9C5niNFgZasxhdIdoV8WEYCrg0mXDJmkUY5EHioaqWdSrAu
 tZe9MFm7rLyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,294,1580803200"; 
   d="scan'208";a="419359109"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga005.jf.intel.com with ESMTP; 22 Mar 2020 19:52:59 -0700
Date:   Sun, 22 Mar 2020 22:43:28 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v14 Kernel 7/7] vfio: Selective dirty page tracking if
 IOMMU backed device pins pages
Message-ID: <20200323024328.GC5456@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1584560474-19946-1-git-send-email-kwankhede@nvidia.com>
 <1584560474-19946-8-git-send-email-kwankhede@nvidia.com>
 <20200319062433.GH4641@joy-OptiPlex-7040>
 <20200320134142.3abe56ea@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320134142.3abe56ea@w520.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 21, 2020 at 03:41:42AM +0800, Alex Williamson wrote:
> On Thu, 19 Mar 2020 02:24:33 -0400
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> > On Thu, Mar 19, 2020 at 03:41:14AM +0800, Kirti Wankhede wrote:
> > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > index 912629320719..deec09f4b0f6 100644
> > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > @@ -72,6 +72,7 @@ struct vfio_iommu {
> > >  	bool			v2;
> > >  	bool			nesting;
> > >  	bool			dirty_page_tracking;
> > > +	bool			pinned_page_dirty_scope;
> > >  };
> > >  
> > >  struct vfio_domain {
> > > @@ -99,6 +100,7 @@ struct vfio_group {
> > >  	struct iommu_group	*iommu_group;
> > >  	struct list_head	next;
> > >  	bool			mdev_group;	/* An mdev group */
> > > +	bool			pinned_page_dirty_scope;
> > >  };
> > >  
> > >  struct vfio_iova {
> > > @@ -132,6 +134,10 @@ struct vfio_regions {
> > >  static int put_pfn(unsigned long pfn, int prot);
> > >  static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu);
> > >  
> > > +static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
> > > +					       struct iommu_group *iommu_group);
> > > +
> > > +static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu);
> > >  /*
> > >   * This code handles mapping and unmapping of user data buffers
> > >   * into DMA'ble space using the IOMMU
> > > @@ -556,11 +562,13 @@ static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
> > >  }
> > >  
> > >  static int vfio_iommu_type1_pin_pages(void *iommu_data,
> > > +				      struct iommu_group *iommu_group,
> > >  				      unsigned long *user_pfn,
> > >  				      int npage, int prot,
> > >  				      unsigned long *phys_pfn)
> > >  {
> > >  	struct vfio_iommu *iommu = iommu_data;
> > > +	struct vfio_group *group;
> > >  	int i, j, ret;
> > >  	unsigned long remote_vaddr;
> > >  	struct vfio_dma *dma;
> > > @@ -630,8 +638,14 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> > >  				   (vpfn->iova - dma->iova) >> pgshift, 1);
> > >  		}
> > >  	}  
> > 
> > Could you provide an interface lightweight than vfio_pin_pages for pass-through
> > devices? e.g. vfio_mark_iova_dirty()
> > 
> > Or at least allowing phys_pfn to be empty for pass-through devices.
> > 
> > This is really inefficient:
> > bitmap_set(dma->bitmap, (vpfn->iova - dma->iova) / pgsize, 1));
> > i.e.
> > in order to mark an iova dirty, it has to go through iova ---> pfn --> iova
> > while acquiring pfn is not necessary for pass-through devices.
> 
> I think this would be possible, but I don't think it should be gating
> to this series.  We don't have such consumers yet.  Thanks,
>
ok. Reasonable.

Thanks
Yan
