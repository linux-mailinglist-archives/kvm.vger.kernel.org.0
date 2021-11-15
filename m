Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE83451789
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 23:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348717AbhKOWc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 17:32:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:43016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344287AbhKOWUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 17:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96FA561AD2;
        Mon, 15 Nov 2021 22:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637014668;
        bh=O3XWXpuP4JyzBpAnL/WOSpf8m8SFaojzS7K+2Ae5RZo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=km/LghMuevoo8pewpHoaepFIkXTw+JY5kSemLdsSd/WNU9oyMsKve+s0YIjjAglss
         vlgxo1iJb2GAMkAHvbCJLidq1dpdAO+IxmV5v16pVbdM+athvPzsLQ+0/ReU28wnmO
         QOqbuQCv97q1aYNECVRhKlNgu5oiGDh2AqzF3ppuiBdttPDU1SUcYlUeWwWFmEMvig
         n1mVNEKc8pFKkj3BMEio9QX9SAhekriQvtPvR0cm0JIVyw3DITrSCi4e9WX0enpF2f
         V4MXczkaxJqtk7t5xtn1PSIGdiviCqz36wVPPktfv1ENLaelF7f3R3DS49EmeVlK4f
         XuO+mHaVSfJPw==
Date:   Mon, 15 Nov 2021 16:17:47 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        rafael@kernel.org, Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] PCI: pci_stub: Suppress kernel DMA ownership
 auto-claiming
Message-ID: <20211115221747.GA1587608@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115020552.2378167-4-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 10:05:44AM +0800, Lu Baolu wrote:
> pci_stub allows the admin to block driver binding on a device and make
> it permanently shared with userspace. Since pci_stub does not do DMA,
> it is safe. However the admin must understand that using pci_stub allows
> userspace to attack whatever device it was bound to.

This commit log doesn't say what the patch does.  I think it tells us
something about what pci-stub *already* does ("allows admin to block
driver binding") and something about why that is safe ("does not do
DMA").

But it doesn't say what this patch changes.  Based on the subject
line, I expected something like:

  As of ("<commit subject>"), <some function>() marks the iommu_group
  as containing only devices with kernel drivers that manage DMA.

  Avoid this default behavior for pci-stub because it does not program
  any DMA itself.  This allows <some desirable behavior>.

> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/pci/pci-stub.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/pci/pci-stub.c b/drivers/pci/pci-stub.c
> index e408099fea52..6324c68602b4 100644
> --- a/drivers/pci/pci-stub.c
> +++ b/drivers/pci/pci-stub.c
> @@ -36,6 +36,9 @@ static struct pci_driver stub_driver = {
>  	.name		= "pci-stub",
>  	.id_table	= NULL,	/* only dynamic id's */
>  	.probe		= pci_stub_probe,
> +	.driver		= {
> +		.suppress_auto_claim_dma_owner = true,
> +	},
>  };
>  
>  static int __init pci_stub_init(void)
> -- 
> 2.25.1
> 
