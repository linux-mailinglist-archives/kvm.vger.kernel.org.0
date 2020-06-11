Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C94A1F70CC
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 01:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgFKXTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 19:19:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:54817 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgFKXTm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 19:19:42 -0400
IronPort-SDR: /e8IMUcCmRV4SpnuVMO8EikxbhJF5FkY5r06R+jt6jua1sktp+ZidvAfGOazS+KLnr20SHWeo2
 /GvZ7Bz2diNA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 16:19:41 -0700
IronPort-SDR: AGUrCH3jTbmFw0VS5HaFBFEvT/Llroj3vgjcZqsmwo1bPwjfkUlLgdwXTuw1GBgZ2T00/h/SS1
 uoy89sWFFWPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,501,1583222400"; 
   d="scan'208";a="473995204"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga005.fm.intel.com with ESMTP; 11 Jun 2020 16:19:39 -0700
Date:   Thu, 11 Jun 2020 19:09:40 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     David Edmondson <dme@dme.org>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH v4 04/10] vfio/pci: let vfio_pci know number of
 vendor regions and vendor irqs
Message-ID: <20200611230940.GD13961@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
 <20200518024944.14263-1-yan.y.zhao@intel.com>
 <20200604172515.614e9864.cohuck@redhat.com>
 <20200605021542.GG12300@joy-OptiPlex-7040>
 <m23671943a.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m23671943a.fsf@dme.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 11, 2020 at 01:31:05PM +0100, David Edmondson wrote:
> On Thursday, 2020-06-04 at 22:15:42 -04, Yan Zhao wrote:
> 
> > On Thu, Jun 04, 2020 at 05:25:15PM +0200, Cornelia Huck wrote:
> >> On Sun, 17 May 2020 22:49:44 -0400
> >> Yan Zhao <yan.y.zhao@intel.com> wrote:
> >> 
> >> > This allows a simpler VFIO_DEVICE_GET_INFO ioctl in vendor driver
> >> > 
> >> > Cc: Kevin Tian <kevin.tian@intel.com>
> >> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> >> > ---
> >> >  drivers/vfio/pci/vfio_pci.c         | 23 +++++++++++++++++++++--
> >> >  drivers/vfio/pci/vfio_pci_private.h |  2 ++
> >> >  include/linux/vfio.h                |  3 +++
> >> >  3 files changed, 26 insertions(+), 2 deletions(-)
> >> > 
> >> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> >> > index 290b7ab55ecf..30137c1c5308 100644
> >> > --- a/drivers/vfio/pci/vfio_pci.c
> >> > +++ b/drivers/vfio/pci/vfio_pci.c
> >> > @@ -105,6 +105,24 @@ void *vfio_pci_vendor_data(void *device_data)
> >> >  }
> >> >  EXPORT_SYMBOL_GPL(vfio_pci_vendor_data);
> >> >  
> >> > +int vfio_pci_set_vendor_regions(void *device_data, int num_vendor_regions)
> >> > +{
> >> > +	struct vfio_pci_device *vdev = device_data;
> >> > +
> >> > +	vdev->num_vendor_regions = num_vendor_regions;
> >> 
> >> Do we need any kind of sanity check here, in case this is called with a
> >> bogus value?
> >>
> > you are right. it at least needs to be >=0.
> > maybe type of "unsigned int" is more appropriate for num_vendor_regions.
> > we don't need to check its max value as QEMU would check it.
> 
> That seems like a bad precedent - the caller may not be QEMU.
>
but the caller has to query that through vfio_pci_ioctl() and at there
info.num_regions = VFIO_PCI_NUM_REGIONS + vdev->num_regions +  vdev->num_vendor_regions;         

info.num_regions is of type __u32.


Thanks
Yan
