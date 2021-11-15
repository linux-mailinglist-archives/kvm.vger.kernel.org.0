Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A32451688
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 22:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346472AbhKOVam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 16:30:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:52354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352978AbhKOUvT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 15:51:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29D5C63240;
        Mon, 15 Nov 2021 20:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637009303;
        bh=Ab04UsOLuYDaWgm25keP0dnQCwf2wKgMMT8FZu0wdU4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=p+hZZ1wwOqkazM54o6HvrGw9tCG0HCBtef7yJtD1WKlY1aVo0bn1uDBS3uH2zcTum
         F1hwf/F/+qWGyMrgMbPGJi3/MaQbqVkcJiSJTP7Sso6dp1MeM62oJ6EbZ0dqqUw8RC
         XDutK2ZgWNduVzYoxkXW4dPZOz4gnxdL+xd0lKnEVHgxdeeSml/+l35jc0SDOg+tOe
         XjdyGPwy4QyA/zVawD0Ox/ObYmU2s2nOfF+1SSCB8gE/nxeeyG6SjuroobyovNR3PQ
         /jaXEC8b1Lzdog7PhMV6IudqpvicpbPfktdvROHIVrrIIgzgZ/vQ+E8qQd9+N/mJoL
         fEZElHCplMLLw==
Date:   Mon, 15 Nov 2021 14:48:21 -0600
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
Message-ID: <20211115204821.GA1587269@bhelgaas>
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
> it is safe. 

Can you elaborate on what "permanently shared with userspace" means
here?  I assume it's only permanent as long as pci-stub is bound to
the device?

Also, a few words about what "it is safe" means here would be helpful.

> However the admin must understand that using pci_stub allows
> userspace to attack whatever device it was bound to.

The admin isn't going to read this sentence.  Should there be a doc
update related to this?  What sort of attack does this refer to?

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
