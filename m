Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B851287FF7
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 03:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgJIBWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 21:22:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:3588 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbgJIBWe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 21:22:34 -0400
IronPort-SDR: i4TZgkCgPEDAkCGz/9iXtjzmAQf4iBx56Z8Aauws9YSChvo/pq01nW7WAinKIINjMk9I0naFPY
 Y9DKly3iKwWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="165490296"
X-IronPort-AV: E=Sophos;i="5.77,353,1596524400"; 
   d="scan'208";a="165490296"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 18:22:33 -0700
IronPort-SDR: JAvf5QKWpmPeCKr0CEBrwqKK1z9BzRyDlH438xxOFtxLoKKkNaohlGpuIFHCrHyfGrfPTV4bS9
 qzdr8AnV/pRA==
X-IronPort-AV: E=Sophos;i="5.77,353,1596524400"; 
   d="scan'208";a="343630539"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 18:22:32 -0700
Date:   Thu, 8 Oct 2020 18:22:31 -0700
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
Message-ID: <20201009012231.GA60263@otc-nc-03>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
 <160021253189.67751.12686144284999931703.stgit@djiang5-desk3.ch.intel.com>
 <87mu17ghr1.fsf@nanos.tec.linutronix.de>
 <0f9bdae0-73d7-1b4e-b478-3cbd05c095f4@intel.com>
 <87r1q92mkx.fsf@nanos.tec.linutronix.de>
 <44e19c5d-a0d2-0ade-442c-61727701f4d8@intel.com>
 <87y2kgux2l.fsf@nanos.tec.linutronix.de>
 <20201008233210.GH4734@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008233210.GH4734@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason

On Thu, Oct 08, 2020 at 08:32:10PM -0300, Jason Gunthorpe wrote:
> On Fri, Oct 09, 2020 at 01:17:38AM +0200, Thomas Gleixner wrote:
> > Dave,
> > 
> > On Thu, Oct 08 2020 at 09:51, Dave Jiang wrote:
> > > On 10/8/2020 12:39 AM, Thomas Gleixner wrote:
> > >> On Wed, Oct 07 2020 at 14:54, Dave Jiang wrote:
> > >>> On 9/30/2020 12:57 PM, Thomas Gleixner wrote:
> > >>>> Aside of that this is fiddling in the IMS storage array behind the irq
> > >>>> chips back without any comment here and a big fat comment about the
> > >>>> shared usage of ims_slot::ctrl in the irq chip driver.
> > >>>>
> > >>> This is to program the pasid fields in the IMS table entry. Was
> > >>> thinking the pasid fields may be considered device specific so didn't
> > >>> attempt to add the support to the core code.
> > >> 
> > >> Well, the problem is that this is not really irq chip functionality.
> > >> 
> > >> But the PASID programming needs to touch the IMS storage which is also
> > >> touched by the irq chip.
> > >> 
> > >> This might be correct as is, but without a big fat comment explaining
> > >> WHY it is safe to do so without any form of serialization this is just
> > >> voodoo and unreviewable.
> > >> 
> > >> Can you please explain when the PASID is programmed and what the state
> > >> of the interrupt is at that point? Is this a one off setup operation or
> > >> does this happen dynamically at random points during runtime?
> > >
> > > I will put in comments for the function to explain why and when we modify the 
> > > pasid field for the IMS entry. Programming of the pasid is done right before we 
> > > request irq. And the clearing is done after we free the irq. We will not be 
> > > touching the IMS field at runtime. So the touching of the entry should be safe.
> > 
> > Thanks for clarifying that.
> > 
> > Thinking more about it, that very same thing will be needed for any
> > other IMS device and of course this is not going to end well because
> > some driver will fiddle with the PASID at the wrong time.
> 
> Why? This looks like some quirk of the IDXD HW where it just randomly
> put PASID along with the IRQ mask register. Probably because PASID is
> not the full 32 bits.

Not randomly put there Jason :-).. There is a good reason for it. I'm sure
Dave must have responded already. ENQCMD for DSA has the interrupt handle
on which the notification should be sent. Since the data from from user
space HW will verify if the PASID for IMS entry matches what is there in
the descriptor. 

Check description in section 9.2.2.1 of the DSA specification, when PASID
enable is 1, this field is checked against the PASID field of the
descriptor. Also check Section 5.4 and Interrupt Virtualization 7.3.3 for
more info.

> 
> AFAIK the PASID is not tagged on the MemWr TLP triggering the
> interrupt, so it really is unrelated to the irq.

Correct, the purpose is not to send PASID prefix for interrupt tranactions.

> 
> I think the ioread to get the PASID is rather ugly, it should pluck

Where do you see the ioread? I suppose idxd driver will fill in from the
aux_domain default PASID. Not reading from the device IMS entry.

> the PASID out of some driver specific data structure with proper
> locking, and thus use the sleepable version of the irqchip?
> 
> This is really not that different from what I was describing for queue
> contexts - the queue context needs to be assigned to the irq # before
> it can be used in the irq chip other wise there is no idea where to
> write the msg to. Just like pasid here.

Sorry, I don't follow you on this.. you mean context in hardware or user
context that holds interrupt addr/data values?

