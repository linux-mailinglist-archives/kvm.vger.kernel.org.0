Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3601F2A1083
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 22:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgJ3VuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 17:50:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgJ3VuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 17:50:05 -0400
Received: from localhost (230.sub-72-107-127.myvzw.com [72.107.127.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E44620727;
        Fri, 30 Oct 2020 21:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604094605;
        bh=XBtI38gBY2LUs9T56LUuQiqKjYkDA984xK5MQgz6sw8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=UvoHZ10e9J8v+wrDIr001koO2sMM1ZUXczs7oxi3ableAcz3NP+ZvjgXtNRqFvZUd
         909BTQ7KJQOErkJYhKlWD3aPFOz7UUCy7PyjIHwsjdJzI1NU7Fbrl0F1ErFXAnHVia
         xERFyZPZ2p5MpQz4s2psmRolrIYl4PH7tWOGnERQ=
Date:   Fri, 30 Oct 2020 16:50:03 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, tglx@linutronix.de,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        rafael@kernel.org, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Message-ID: <20201030215003.GA606323@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71da5f66-e929-bab1-a1c6-a9ac9627a141@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 30, 2020 at 02:20:03PM -0700, Dave Jiang wrote:
> 
> 
> On 10/30/2020 12:51 PM, Bjorn Helgaas wrote:
> > On Fri, Oct 30, 2020 at 11:51:32AM -0700, Dave Jiang wrote:
> > > Intel Scalable I/O Virtualization (SIOV) enables sharing of I/O devices
> > > across isolated domains through PASID based sub-device partitioning.
> > > Interrupt Message Storage (IMS) enables devices to store the interrupt
> > > messages in a device-specific optimized manner without the scalability
> > > restrictions of the PCIe defined MSI-X capability. IMS is one of the
> > > features supported under SIOV.
> > > 
> > > Move SIOV detection code from Intel iommu driver code to common PCI. Making
> > > the detection code common allows supported accelerator drivers to query the
> > > PCI core for SIOV and IMS capabilities. The support code will add the
> > > ability to query the PCI DVSEC capabilities for the SIOV cap.
> > 
> > This patch really does not include anything related to SIOV other than
> > adding a little code to *find* the capability.  It doesn't add
> > anything that actually *uses* it.  I think this patch should simply
> > add pci_find_dvsec(), and it doesn't need any of this SIOV or IMS
> > description.
> 
> Thanks for the review Bjorn! I'll carve out a patch with just find_dvsec()
> and apply your comments and recommendations.
> 
> So the intel-iommu driver checks for the SIOV cap. And the idxd driver
> checks for SIOV and IMS cap. There will be other upcoming drivers that will
> check for such cap too. It is Intel vendor specific right now, but SIOV is
> public and other vendors may implement to the spec. Is there a good place to
> put the common capability check for that?

Let's wait and see what that code looks like and figure it out then.
We can always move it to the PCI core if it turns out to be generic.

Right now the code only finds a capability and checks a bit in it.
None of that is anything the PCI core is interested in.

> There are some other fields in the SIOV dvsec cap, but presently they are
> not being utilized. The idxd driver is only interested in making sure that
> SIOV and IMS (sub feature) support are present at this point.

I'm a little dubious about code that checks whether support is present
but doesn't actually *do* anything with that support, but as long as
it's outside the PCI core, that's up to you :)

Bjorn
