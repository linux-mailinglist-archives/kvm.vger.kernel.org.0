Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8FAC264033
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 10:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbgIJIiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 04:38:03 -0400
Received: from mga07.intel.com ([134.134.136.100]:49071 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730484AbgIJIgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 04:36:50 -0400
IronPort-SDR: ouN9a/6yGbXTxQjLQSg/GkEUPnSYOnK7Um7ADTX16sA+mIdLnuQZNmFAPduuoP/sCiSx/eUnOY
 KVca203eCBYA==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="222691547"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="222691547"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 01:36:49 -0700
IronPort-SDR: +EDDpfCYRTdRoHjNofeNzcJtwlZejqaidJLecIN7n/T5soSPgYxMn5zyqSgciUTeA12obfYezy
 OnMhcyt1owWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="285159045"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.141])
  by fmsmga007.fm.intel.com with ESMTP; 10 Sep 2020 01:36:46 -0700
Date:   Thu, 10 Sep 2020 16:32:30 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     mdf@kernel.org, kwankhede@nvidia.com, linux-fpga@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, trix@redhat.com,
        lgoncalv@redhat.com,
        Matthew Gerlach <matthew.gerlach@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>, yilun.xu@intel.com
Subject: Re: [PATCH 3/3] Documentation: fpga: dfl: Add description for VFIO
  Mdev support
Message-ID: <20200910083230.GA16318@yilunxu-OptiPlex-7050>
References: <1599549212-24253-1-git-send-email-yilun.xu@intel.com>
 <1599549212-24253-4-git-send-email-yilun.xu@intel.com>
 <20200908151002.553ed7ae@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908151002.553ed7ae@w520.home>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex:

Thanks for your quick response and is helpful to me. I did some more
investigation and some comments inline.

On Tue, Sep 08, 2020 at 03:10:02PM -0600, Alex Williamson wrote:
> On Tue,  8 Sep 2020 15:13:32 +0800
> Xu Yilun <yilun.xu@intel.com> wrote:
> 
> > This patch adds description for VFIO Mdev support for dfl devices on
> > dfl bus.
> > 
> > Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> > Signed-off-by: Matthew Gerlach <matthew.gerlach@linux.intel.com>
> > ---
> >  Documentation/fpga/dfl.rst | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > 
> > diff --git a/Documentation/fpga/dfl.rst b/Documentation/fpga/dfl.rst
> > index 0404fe6..f077754 100644
> > --- a/Documentation/fpga/dfl.rst
> > +++ b/Documentation/fpga/dfl.rst
> > @@ -502,6 +502,26 @@ FME Partial Reconfiguration Sub Feature driver (see drivers/fpga/dfl-fme-pr.c)
> >  could be a reference.
> >  
> >  
> > +VFIO Mdev support for DFL devices
> > +=================================
> > +As we introduced a dfl bus for private features, they could be added to dfl bus
> > +as independent dfl devices. There is a requirement to handle these devices
> > +either by kernel drivers or by direct access from userspace. Usually we bind
> > +the kernel drivers to devices which provide board management functions, and
> > +gives user direct access to devices which cooperate closely with user
> > +controlled Accelerated Function Unit (AFU). We realize this with a VFIO Mdev
> > +implementation. When we bind the vfio-mdev-dfl driver to a dfl device, it
> > +realizes a group of callbacks and registers to the Mdev framework as a
> > +parent (physical) device. It could then create one (available_instances == 1)
> > +mdev device.
> > +Since dfl devices are sub devices of FPGA DFL physical devices (e.g. PCIE
> > +device), which provide no DMA isolation for each sub device, this may leads to
> > +DMA isolation problem if a private feature is designed to be capable of DMA.
> > +The AFU user could potentially access the whole device addressing space and
> > +impact the private feature. So now the general HW design rule is, no DMA
> > +capability for private features. It eliminates the DMA isolation problem.
> 
> What's the advantage of entangling mdev/vfio in this approach versus
> simply exposing the MMIO region of the device via sysfs (similar to a
> resource file in pci-sysfs)?  This implementation doesn't support
> interrupts, it doesn't support multiplexing of a device, it doesn't
> perform any degree of mediation, it seems to simply say "please don't
> do DMA".  I don't think that's acceptable for an mdev driver.  If you
> want to play loose with isolation, do it somewhere else.  Thanks,

The intention of the patchset is to enable the userspace drivers for dfl
devices. The dfl devices are actually different IP blocks integrated in
FPGA to support different board functionalities. They are sub devices of
the FPGA PCIe device. Their mmio blocks are in PCIE bar regions. And we
want some of the dfl devices handled by the userspace drivers.

Some dfl devices are capable of interrupt. I didn't add interrupt code
in this patch cause now the IRQ capable dfl devices are all handled by
kernel drivers. But as a generic FPGA platform, IRQ handling for userspace
drivers should be supported.

And I can see there are several ways to enable the userspace driver.

1. Some specific sysfs like pci do. But seems it is not the common way for
userspace driver. It does't support interrupt. And potentially users
operate on the same mmio region together with kernel driver at the same
time.

2. VFIO driver with NOIOMMU enabled. I think it meets our needs. Do you
think it is good we implement an VFIO driver for dfl devices?

3. VFIO mdev. I implemented it because it will not block us from lacking
of valid iommu group. And since the driver didn't perform any mediation,
I should give up.

4. UIO driver. It should work. I'm wondering if option 2 covers the
functionalities of UIO and has more enhancement. So option 2 may be
better?

Thanks again for your time, and I really appreciate you would give some
guide on it.

Yilun.

> 
> Alex
