Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1EA417D7AB
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 02:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgCIBKZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Mar 2020 21:10:25 -0400
Received: from mga07.intel.com ([134.134.136.100]:42111 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726622AbgCIBKZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Mar 2020 21:10:25 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Mar 2020 18:10:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,530,1574150400"; 
   d="scan'208";a="414640640"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga005.jf.intel.com with ESMTP; 08 Mar 2020 18:10:22 -0700
Date:   Sun, 8 Mar 2020 21:00:56 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: Re: [PATCH v3 2/7] vfio: introduce vfio_dma_rw to read/write a range
 of IOVAs
Message-ID: <20200309010055.GA18137@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200224084350.31574-1-yan.y.zhao@intel.com>
 <20200224084715.31753-1-yan.y.zhao@intel.com>
 <20200306012148.GB1530@joy-OptiPlex-7040>
 <20200306092746.088a01a3@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306092746.088a01a3@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 07, 2020 at 12:27:46AM +0800, Alex Williamson wrote:
> On Thu, 5 Mar 2020 20:21:48 -0500
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Mon, Feb 24, 2020 at 04:47:15PM +0800, Zhao, Yan Y wrote:
> > > vfio_dma_rw will read/write a range of user space memory pointed to by
> > > IOVA into/from a kernel buffer without enforcing pinning the user space
> > > memory.
> > > 
> > > TODO: mark the IOVAs to user space memory dirty if they are written in
> > > vfio_dma_rw().
> > > 
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > ---
> > >  drivers/vfio/vfio.c             | 49 +++++++++++++++++++++
> > >  drivers/vfio/vfio_iommu_type1.c | 77 +++++++++++++++++++++++++++++++++
> > >  include/linux/vfio.h            |  5 +++
> > >  3 files changed, 131 insertions(+)
> > > 
> > > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > > index 914bdf4b9d73..902867627cbf 100644
> > > --- a/drivers/vfio/vfio.c
> > > +++ b/drivers/vfio/vfio.c
> > > @@ -1998,6 +1998,55 @@ int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn, int npage)
> > >  }
> > >  EXPORT_SYMBOL(vfio_unpin_pages);
> > >  
> > > +
> > > +/*
> > > + * This interface allows the CPUs to perform some sort of virtual DMA on
> > > + * behalf of the device.
> > > + *
> > > + * CPUs read/write a range of IOVAs pointing to user space memory into/from
> > > + * a kernel buffer.
> > > + *
> > > + * As the read/write of user space memory is conducted via the CPUs and is
> > > + * not a real device DMA, it is not necessary to pin the user space memory.
> > > + *
> > > + * The caller needs to call vfio_group_get_external_user() or
> > > + * vfio_group_get_external_user_from_dev() prior to calling this interface,
> > > + * so as to prevent the VFIO group from disposal in the middle of the call.
> > > + * But it can keep the reference to the VFIO group for several calls into
> > > + * this interface.
> > > + * After finishing using of the VFIO group, the caller needs to release the
> > > + * VFIO group by calling vfio_group_put_external_user().
> > > + *
> > > + * @group [in]: vfio group of a device
> > > + * @iova [in] : base IOVA of a user space buffer
> > > + * @data [in] : pointer to kernel buffer
> > > + * @len [in]  : kernel buffer length
> > > + * @write     : indicate read or write
> > > + * Return error code on failure or 0 on success.
> > > + */
> > > +int vfio_dma_rw(struct vfio_group *group, dma_addr_t iova,
> > > +		void *data, size_t len, bool write)  
> > hi Alex
> > May I rename this interface to vfio_dma_rw_from_group() that takes
> > VFIO group as arg and add another interface vfio_dma_rw(struct device *dev...) ?
> > That might be easier for a driver to use the second one if it does not care about
> > performance much.
> 
> Perhaps vfio_group_dma_rw() and vfio_dev_dma_rw()?  I'd be reluctant to
> add the latter, if a caller doesn't care about performance then they
> won't mind making a couple calls to get and release the group reference.
> Thanks,
>
yes, it makes sense. Then I withdraw this request :)

Thanks
Yan
