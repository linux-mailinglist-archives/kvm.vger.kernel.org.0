Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA3E27F463
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 23:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730967AbgI3Vtv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 17:49:51 -0400
Received: from mga04.intel.com ([192.55.52.120]:18352 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729912AbgI3Vtu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 17:49:50 -0400
IronPort-SDR: 3pwTbQ+PyLHo+/t7/m+oYJNBO6awHIDHPr2gKiEVcgDYssxxqQ3AUD5/nNW0DM2Bnxd1KNgOkj
 yakTHZFtxZ0g==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="159954216"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="159954216"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 14:49:43 -0700
IronPort-SDR: whgfrvKYaHNYFGsg59jQmb1KuytntRh+SRaISfKFhavWJ8UbYdE12wOGXii/sLxyjSAhvbtvCv
 Kx+YOyMkj4uA==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="457826098"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 14:49:43 -0700
Date:   Wed, 30 Sep 2020 14:49:41 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20200930214941.GB26492@otc-nc-03>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
 <160021248979.67751.3799965857372703876.stgit@djiang5-desk3.ch.intel.com>
 <87sgazgl0b.fsf@nanos.tec.linutronix.de>
 <20200930185103.GT816047@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930185103.GT816047@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason

On Wed, Sep 30, 2020 at 03:51:03PM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 30, 2020 at 08:47:00PM +0200, Thomas Gleixner wrote:
> 
> > > +	pci_read_config_dword(pdev, SIOVCAP(dvsec), &val32);
> > > +	if ((val32 & 0x1) && idxd->hw.gen_cap.max_ims_mult) {
> > > +		idxd->ims_size = idxd->hw.gen_cap.max_ims_mult * 256ULL;
> > > +		dev_dbg(dev, "IMS size: %u\n", idxd->ims_size);
> > > +		set_bit(IDXD_FLAG_SIOV_SUPPORTED, &idxd->flags);
> > > +		dev_dbg(&pdev->dev, "IMS supported for device\n");
> > > +		return;
> > > +	}
> > > +
> > > +	dev_dbg(&pdev->dev, "SIOV unsupported for device\n");
> > 
> > It's really hard to find the code inside all of this dev_dbg()
> > noise. But why is this capability check done in this driver? Is this
> > capability stuff really IDXD specific or is the next device which
> > supports this going to copy and pasta the above?
> 
> It is the weirdest thing, IMHO. Intel defined a dvsec cap in their
> SIOV cookbook, but as far as I can see it serves no purpose at
> all.
> 
> Last time I asked I got some unclear mumbling about "OEMs".
> 
One of the parameters it has is the "supported system page-sizes" which is
usually there in the SRIOV properties. So it needed a place holder for
that. 

IMS is a device specific capability, and I almost forgot why we needed
until I had to checking internally. Remember when a device is given to a
guest, MSIX routing via Interrupt Remapping is automatic via the VFIO/IRQFD
and such.

When we provision an entire PCI device that is IMS capable. The guest
driver does know it can update the IMS entries directly without going to
the host. But in order to do remapping we need something like how we manage
PASID allocation from guest, so an IRTE entry can be allocated and the host
driver can write the proper values for IMS.

Hope this helps clear things up.

Cheers,
Ashok

