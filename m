Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01D727F701
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 03:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730633AbgJABHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 21:07:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:58575 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728660AbgJABHT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 21:07:19 -0400
IronPort-SDR: ZmMO062tAYveuLdPZkJMMX8Bh/Ot+hgYSTKkgsGbGq6PpBvtDPuDRTNVKXYZp+8aVjRL9vxwUi
 y6qjUipihZCA==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="163448273"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="163448273"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 18:07:09 -0700
IronPort-SDR: mMnIrO7b8wP6KqVofoHDTHCZSjzenL4Bd4WKXBQTZfFg32rXdJ4WGHlQIgxq++fYLqgTSe3ozB
 s2F4M+5EmKcw==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="312802720"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 18:07:07 -0700
Date:   Wed, 30 Sep 2020 18:07:06 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com, rafael@kernel.org,
        netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v3 05/18] dmaengine: idxd: add IMS support in base driver
Message-ID: <20201001010706.GD26492@otc-nc-03>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
 <160021248979.67751.3799965857372703876.stgit@djiang5-desk3.ch.intel.com>
 <87sgazgl0b.fsf@nanos.tec.linutronix.de>
 <20200930185103.GT816047@nvidia.com>
 <20200930214941.GB26492@otc-nc-03>
 <87d023gc71.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d023gc71.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On Wed, Sep 30, 2020 at 11:57:22PM +0200, Thomas Gleixner wrote:
> On Wed, Sep 30 2020 at 14:49, Ashok Raj wrote:
> >> It is the weirdest thing, IMHO. Intel defined a dvsec cap in their
> >> SIOV cookbook, but as far as I can see it serves no purpose at
> >> all.
> >> 
> >> Last time I asked I got some unclear mumbling about "OEMs".
> >> 
> > One of the parameters it has is the "supported system page-sizes" which is
> > usually there in the SRIOV properties. So it needed a place holder for
> > that. 
> >
> > IMS is a device specific capability, and I almost forgot why we needed
> > until I had to checking internally. Remember when a device is given to a
> > guest, MSIX routing via Interrupt Remapping is automatic via the VFIO/IRQFD
> > and such.
> 
> -ENOPARSE

Let me try again to see if this will turn into ESUCCESS :-)

Devices exposed to guest need host OS support for programming interrupt
entries in the IOMMU interrupt remapping table. VFIO provides those 
services for standard interrupt schemes like MSI/MSIx for instance. 
Since IMS is device specific VFIO can't provide an intercept when 
IMS entries are programmed by the guest OS. 

If the virtualisation software doesn't expose vIOMMU with virtual
capabilities to allocate IRTE entries and support for vIRTE in guest
then its expected to turn off the IMS capability. Hence driver running 
in guest will not enable IMS.

> 
> > When we provision an entire PCI device that is IMS capable. The guest
> > driver does know it can update the IMS entries directly without going to
> > the host. But in order to do remapping we need something like how we manage
> > PASID allocation from guest, so an IRTE entry can be allocated and the host
> > driver can write the proper values for IMS.
> 
> And how is that related to that capbility thing?
> 
> Also this stuff is host side and not guest side. I seriously doubt that
> you want to hand in the whole PCI device which contains the IMS

You are right, but nothing prevents a user from simply taking a full PCI
device and assign to guest. 

> thing. The whole point of IMS was as far as I was told that you can
> create gazillions of subdevices and have seperate MSI interrupts for
> each of them.


Cheers,
Ashok
