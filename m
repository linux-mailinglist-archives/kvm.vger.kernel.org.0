Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34A8A18D87E
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 20:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgCTTlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 15:41:53 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:45059 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbgCTTlx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 15:41:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584733311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sJ40QxRG0OlYWuzwDUDKkNSHifuUoZHuj8C6hMwyzYc=;
        b=Ci7W8HJ9FFJtUPKPqhRAHrYbIgaG1nxLiFZINT8BUCMuRywqw40p1zbZ3Nxv9O/HTZgNAW
        RlLiaIYGZEVNHiF8tIRkeLRNnqYdsPpExL6c5dW8boV7FCGy66wb3l0JWHPuY+yZ8uch4n
        dYRSFuw0zAadrl0LJ+Ypd5eAnFBYdQY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-jzy-x6bGOB2sQYPzmScm1A-1; Fri, 20 Mar 2020 15:41:47 -0400
X-MC-Unique: jzy-x6bGOB2sQYPzmScm1A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6223E477;
        Fri, 20 Mar 2020 19:41:45 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B2125C219;
        Fri, 20 Mar 2020 19:41:43 +0000 (UTC)
Date:   Fri, 20 Mar 2020 13:41:42 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
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
Message-ID: <20200320134142.3abe56ea@w520.home>
In-Reply-To: <20200319062433.GH4641@joy-OptiPlex-7040>
References: <1584560474-19946-1-git-send-email-kwankhede@nvidia.com>
        <1584560474-19946-8-git-send-email-kwankhede@nvidia.com>
        <20200319062433.GH4641@joy-OptiPlex-7040>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Mar 2020 02:24:33 -0400
Yan Zhao <yan.y.zhao@intel.com> wrote:
> On Thu, Mar 19, 2020 at 03:41:14AM +0800, Kirti Wankhede wrote:
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index 912629320719..deec09f4b0f6 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -72,6 +72,7 @@ struct vfio_iommu {
> >  	bool			v2;
> >  	bool			nesting;
> >  	bool			dirty_page_tracking;
> > +	bool			pinned_page_dirty_scope;
> >  };
> >  
> >  struct vfio_domain {
> > @@ -99,6 +100,7 @@ struct vfio_group {
> >  	struct iommu_group	*iommu_group;
> >  	struct list_head	next;
> >  	bool			mdev_group;	/* An mdev group */
> > +	bool			pinned_page_dirty_scope;
> >  };
> >  
> >  struct vfio_iova {
> > @@ -132,6 +134,10 @@ struct vfio_regions {
> >  static int put_pfn(unsigned long pfn, int prot);
> >  static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu);
> >  
> > +static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
> > +					       struct iommu_group *iommu_group);
> > +
> > +static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu);
> >  /*
> >   * This code handles mapping and unmapping of user data buffers
> >   * into DMA'ble space using the IOMMU
> > @@ -556,11 +562,13 @@ static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
> >  }
> >  
> >  static int vfio_iommu_type1_pin_pages(void *iommu_data,
> > +				      struct iommu_group *iommu_group,
> >  				      unsigned long *user_pfn,
> >  				      int npage, int prot,
> >  				      unsigned long *phys_pfn)
> >  {
> >  	struct vfio_iommu *iommu = iommu_data;
> > +	struct vfio_group *group;
> >  	int i, j, ret;
> >  	unsigned long remote_vaddr;
> >  	struct vfio_dma *dma;
> > @@ -630,8 +638,14 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >  				   (vpfn->iova - dma->iova) >> pgshift, 1);
> >  		}
> >  	}  
> 
> Could you provide an interface lightweight than vfio_pin_pages for pass-through
> devices? e.g. vfio_mark_iova_dirty()
> 
> Or at least allowing phys_pfn to be empty for pass-through devices.
> 
> This is really inefficient:
> bitmap_set(dma->bitmap, (vpfn->iova - dma->iova) / pgsize, 1));
> i.e.
> in order to mark an iova dirty, it has to go through iova ---> pfn --> iova
> while acquiring pfn is not necessary for pass-through devices.

I think this would be possible, but I don't think it should be gating
to this series.  We don't have such consumers yet.  Thanks,

Alex

