Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F88288985
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 15:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388027AbgJINCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 09:02:11 -0400
Received: from mga17.intel.com ([192.55.52.151]:62522 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732468AbgJINCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 09:02:10 -0400
IronPort-SDR: uKE6w33UzN6q7opVsHN2RgDPrcrnDEzqjHos/y9mIdnRit9+LLB+zAdfy/FxBDT+hXU/ZDIuIR
 NjhgGR+hqE4w==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="145345145"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="145345145"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 06:02:10 -0700
IronPort-SDR: ia+0ITxIDXeFcOk4w1AbDophh2jsIPDsLNB+/Pv6iXw4OELTaqDQugZcB8gTl0BpZfKOst5meK
 mO4rg/nEukow==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="462182527"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 06:02:10 -0700
Date:   Fri, 9 Oct 2020 06:02:09 -0700
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
Message-ID: <20201009130208.GC63643@otc-nc-03>
References: <87mu17ghr1.fsf@nanos.tec.linutronix.de>
 <0f9bdae0-73d7-1b4e-b478-3cbd05c095f4@intel.com>
 <87r1q92mkx.fsf@nanos.tec.linutronix.de>
 <44e19c5d-a0d2-0ade-442c-61727701f4d8@intel.com>
 <87y2kgux2l.fsf@nanos.tec.linutronix.de>
 <20201008233210.GH4734@nvidia.com>
 <20201009012231.GA60263@otc-nc-03>
 <20201009115737.GI4734@nvidia.com>
 <20201009124307.GA63643@otc-nc-03>
 <20201009124945.GJ4734@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009124945.GJ4734@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 09, 2020 at 09:49:45AM -0300, Jason Gunthorpe wrote:
> On Fri, Oct 09, 2020 at 05:43:07AM -0700, Raj, Ashok wrote:
> > On Fri, Oct 09, 2020 at 08:57:37AM -0300, Jason Gunthorpe wrote:
> > > On Thu, Oct 08, 2020 at 06:22:31PM -0700, Raj, Ashok wrote:
> > > 
> > > > Not randomly put there Jason :-).. There is a good reason for it. 
> > > 
> > > Sure the PASID value being associated with the IRQ make sense, but
> > > combining that register with the interrupt mask is just a compltely
> > > random thing to do.
> > 
> > Hummm... Not sure what you are complaining.. but in any case giving
> > hardware a more efficient way to store interrupt entries breaking any
> > boundaries that maybe implied by the spec is why IMS was defined.
> 
> I'm saying this PASID stuff is just some HW detail of IDXD and nothing
> that the core irqchip code should concern itself with

Ok, so you are saying this is device specific why is generic framework
having to worry about the PASID stuff? 

I thought we are consolidating code that otherwise similar drivers would
require anyway. I thought that's what Thomas was accomplishing with the new
framework.

He is the architect in chief for this... having PASID in the framework
seems like everybody could benefit instead of just being idxd specific.

This isn't the only game in town. 
