Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352F22889EE
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 15:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732290AbgJINkJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 09:40:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:25028 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729045AbgJINkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 09:40:09 -0400
IronPort-SDR: S65Po7RK79ZrFCMjDtY03woDfqgSvRr54W4VTtRZh+dsUxYUbzPe2eCm+28PzgW3Wrx+HANSSp
 aeadS9c3Laeg==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="152403423"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="152403423"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 06:40:07 -0700
IronPort-SDR: +/24peG8+fE/BkbOhbSgHpazY85zJmfMLhky4/Ni5DTcJA6igLZMsGcWqGpWWT7evW8LcZBu0l
 bKwf9JJxLi2Q==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="518661433"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 06:40:06 -0700
Date:   Fri, 9 Oct 2020 06:40:05 -0700
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
Subject: Re: [PATCH v3 11/18] dmaengine: idxd: ims setup for the vdcm
Message-ID: <20201009134005.GD63643@otc-nc-03>
References: <87r1q92mkx.fsf@nanos.tec.linutronix.de>
 <44e19c5d-a0d2-0ade-442c-61727701f4d8@intel.com>
 <87y2kgux2l.fsf@nanos.tec.linutronix.de>
 <20201008233210.GH4734@nvidia.com>
 <20201009012231.GA60263@otc-nc-03>
 <20201009115737.GI4734@nvidia.com>
 <20201009124307.GA63643@otc-nc-03>
 <20201009124945.GJ4734@nvidia.com>
 <20201009130208.GC63643@otc-nc-03>
 <20201009131218.GK4734@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009131218.GK4734@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 09, 2020 at 10:12:18AM -0300, Jason Gunthorpe wrote:
> On Fri, Oct 09, 2020 at 06:02:09AM -0700, Raj, Ashok wrote:
> > On Fri, Oct 09, 2020 at 09:49:45AM -0300, Jason Gunthorpe wrote:
> > > On Fri, Oct 09, 2020 at 05:43:07AM -0700, Raj, Ashok wrote:
> > > > On Fri, Oct 09, 2020 at 08:57:37AM -0300, Jason Gunthorpe wrote:
> > > > > On Thu, Oct 08, 2020 at 06:22:31PM -0700, Raj, Ashok wrote:
> > > > > 
> > > > > > Not randomly put there Jason :-).. There is a good reason for it. 
> > > > > 
> > > > > Sure the PASID value being associated with the IRQ make sense, but
> > > > > combining that register with the interrupt mask is just a compltely
> > > > > random thing to do.
> > > > 
> > > > Hummm... Not sure what you are complaining.. but in any case giving
> > > > hardware a more efficient way to store interrupt entries breaking any
> > > > boundaries that maybe implied by the spec is why IMS was defined.
> > > 
> > > I'm saying this PASID stuff is just some HW detail of IDXD and nothing
> > > that the core irqchip code should concern itself with
> > 
> > Ok, so you are saying this is device specific why is generic framework
> > having to worry about the PASID stuff? 
> > 
> > I thought we are consolidating code that otherwise similar drivers would
> > require anyway. I thought that's what Thomas was accomplishing with the new
> > framework.
> 
> My point is why would another driver combine PASID and the IRQ mask in
> one register? There is no spec saying to do this, no common design

IMS is a concept. How a device organizes its interrupt data is completely
hardware specific. Some vendor could keep them organized like how MSIx is
done today, and put PASID's in a separate offset. Or put all interrupt
related entries all in one place like how idxd handles it today.

Cheers,
Ashok
