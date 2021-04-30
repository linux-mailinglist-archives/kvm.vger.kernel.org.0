Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5E136F82E
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 11:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhD3JzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 05:55:13 -0400
Received: from foss.arm.com ([217.140.110.172]:44722 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229606AbhD3JzM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 05:55:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C087031B;
        Fri, 30 Apr 2021 02:54:24 -0700 (PDT)
Received: from lpieralisi (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 01C143F73B;
        Fri, 30 Apr 2021 02:54:22 -0700 (PDT)
Date:   Fri, 30 Apr 2021 10:54:17 +0100
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Shanker Donthineni <sdonthineni@nvidia.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vikram Sethi <vsethi@nvidia.com>,
        Jason Sequeira <jsequeira@nvidia.com>, jgg@nvidia.com,
        benh@kernel.crashing.org
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Message-ID: <20210430095417.GA13686@lpieralisi>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
 <20210429162906.32742-2-sdonthineni@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429162906.32742-2-sdonthineni@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[+Jason, Ben]

On Thu, Apr 29, 2021 at 11:29:05AM -0500, Shanker Donthineni wrote:
> For pass-through device assignment, the ARM64 KVM hypervisor retrieves
> the memory region properties physical address, size, and whether a
> region backed with struct page or not from VMA. The prefetchable
> attribute of a BAR region isn't visible to KVM to make an optimal
> decision for stage2 attributes.
> 
> This patch updates vma->vm_page_prot and maps with write-combine
> attribute if the associated BAR is prefetchable. For ARM64
> pgprot_writecombine() is mapped to memory-type MT_NORMAL_NC which
> has no side effects on reads and multiple writes can be combined.
> 
> Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

A bit of background information that may be useful:

https://lore.kernel.org/linux-pci/2b539df4c9ec703458e46da2fc879ee3b310b31c.camel@kernel.crashing.org

Lorenzo

> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 5023e23db3bc..1b734fe1dd51 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1703,7 +1703,11 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
>  	}
>  
>  	vma->vm_private_data = vdev;
> -	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +	if (IS_ENABLED(CONFIG_ARM64) &&
> +	    (pci_resource_flags(pdev, index) & IORESOURCE_PREFETCH))
> +		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
> +	else
> +		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>  	vma->vm_pgoff = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
>  
>  	/*
> -- 
> 2.17.1
> 
