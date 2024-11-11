Return-Path: <kvm+bounces-31473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CBE79C3F48
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 14:09:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BE3B282E76
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD4E319CD0B;
	Mon, 11 Nov 2024 13:09:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71C04153BED;
	Mon, 11 Nov 2024 13:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731330571; cv=none; b=XnfirOG/Idr8pLOHCoOtTLXn8WMDEyDNczLfsuUPgKIFRtKrj2RqAy4sQMA1cVIB+4RHcNbjx+mknfRht4gXrGobLrTJ6HTSuZEJrm1R7SclCZspyvZuBksi9u5VQoDtPs9+X7G9k5q4RFPKux6FzyrG1d9sRiCKK7PFs4Fodns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731330571; c=relaxed/simple;
	bh=zAnfbjazIKCKkvUjNTVKN/Fduo3MPuJ3ZujI3eyZNtc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OwUzxXsZUK3Nv9zzXB2qgXvZegQChzs7SQ/FpxrM1LQ9sZoLBk1o3E+CYHigxEiCMvdVvDv9uiC7j+3T0Ku4m5OeJgre2SX34G3mMtWSl9yr/Ja7nqe6gSF1k/Mx1kENJpzaf6nKJwKDIfML2gmiMoYhFgaP9G4RxZIjCO5zHLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 695071CE0;
	Mon, 11 Nov 2024 05:09:55 -0800 (PST)
Received: from [10.57.91.162] (unknown [10.57.91.162])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 69E743F66E;
	Mon, 11 Nov 2024 05:09:20 -0800 (PST)
Message-ID: <a63e7c3b-ce96-47a5-b462-d5de3a2edb56@arm.com>
Date: Mon, 11 Nov 2024 13:09:20 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFCv1 0/7] vfio: Allow userspace to specify the address
 for each MSI vector
To: Nicolin Chen <nicolinc@nvidia.com>, maz@kernel.org, tglx@linutronix.de,
 bhelgaas@google.com, alex.williamson@redhat.com
Cc: jgg@nvidia.com, leonro@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 dlemoal@kernel.org, kevin.tian@intel.com, smostafa@google.com,
 andriy.shevchenko@linux.intel.com, reinette.chatre@intel.com,
 eric.auger@redhat.com, ddutile@redhat.com, yebin10@huawei.com,
 brauner@kernel.org, apatel@ventanamicro.com,
 shivamurthy.shastri@linutronix.de, anna-maria@linutronix.de,
 nipun.gupta@amd.com, marek.vasut+renesas@mailbox.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1731130093.git.nicolinc@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <cover.1731130093.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-11-09 5:48 am, Nicolin Chen wrote:
> On ARM GIC systems and others, the target address of the MSI is translated
> by the IOMMU. For GIC, the MSI address page is called "ITS" page. When the
> IOMMU is disabled, the MSI address is programmed to the physical location
> of the GIC ITS page (e.g. 0x20200000). When the IOMMU is enabled, the ITS
> page is behind the IOMMU, so the MSI address is programmed to an allocated
> IO virtual address (a.k.a IOVA), e.g. 0xFFFF0000, which must be mapped to
> the physical ITS page: IOVA (0xFFFF0000) ===> PA (0x20200000).
> When a 2-stage translation is enabled, IOVA will be still used to program
> the MSI address, though the mappings will be in two stages:
>    IOVA (0xFFFF0000) ===> IPA (e.g. 0x80900000) ===> 0x20200000
> (IPA stands for Intermediate Physical Address).
> 
> If the device that generates MSI is attached to an IOMMU_DOMAIN_DMA, the
> IOVA is dynamically allocated from the top of the IOVA space. If attached
> to an IOMMU_DOMAIN_UNMANAGED (e.g. a VFIO passthrough device), the IOVA is
> fixed to an MSI window reported by the IOMMU driver via IOMMU_RESV_SW_MSI,
> which is hardwired to MSI_IOVA_BASE (IOVA==0x8000000) for ARM IOMMUs.
> 
> So far, this IOMMU_RESV_SW_MSI works well as kernel is entirely in charge
> of the IOMMU translation (1-stage translation), since the IOVA for the ITS
> page is fixed and known by kernel. However, with virtual machine enabling
> a nested IOMMU translation (2-stage), a guest kernel directly controls the
> stage-1 translation with an IOMMU_DOMAIN_DMA, mapping a vITS page (at an
> IPA 0x80900000) onto its own IOVA space (e.g. 0xEEEE0000). Then, the host
> kernel can't know that guest-level IOVA to program the MSI address.
> 
> To solve this problem the VMM should capture the MSI IOVA allocated by the
> guest kernel and relay it to the GIC driver in the host kernel, to program
> the correct MSI IOVA. And this requires a new ioctl via VFIO.

Once VFIO has that information from userspace, though, do we really need 
the whole complicated dance to push it right down into the irqchip layer 
just so it can be passed back up again? AFAICS 
vfio_msi_set_vector_signal() via VFIO_DEVICE_SET_IRQS already explicitly 
rewrites MSI-X vectors, so it seems like it should be pretty 
straightforward to override the message address in general at that 
level, without the lower layers having to be aware at all, no?

Thanks,
Robin.

> Extend the VFIO path to allow an MSI target IOVA to be forwarded into the
> kernel and pushed down to the GIC driver.
> 
> Add VFIO ioctl VFIO_IRQ_SET_ACTION_PREPARE with VFIO_IRQ_SET_DATA_MSI_IOVA
> to carry the data.
> 
> The downstream calltrace is quite long from the VFIO to the ITS driver. So
> in order to carry the MSI IOVA from the top to its_irq_domain_alloc(), add
> patches in a leaf-to-root order:
> 
>    vfio_pci_core_ioctl:
>      vfio_pci_set_irqs_ioctl:
>        vfio_pci_set_msi_prepare:                           // PATCH-7
>          pci_alloc_irq_vectors_iovas:                      // PATCH-6
>            __pci_alloc_irq_vectors:                        // PATCH-5
>              __pci_enable_msi/msix_range:                  // PATCH-4
>                msi/msix_capability_init:                   // PATCH-3
>                  msi/msix_setup_msi_descs:
>                    msi_insert_msi_desc();                  // PATCH-1
>                  pci_msi_setup_msi_irqs:
>                    msi_domain_alloc_irqs_all_locked:
>                      __msi_domain_alloc_locked:
>                        __msi_domain_alloc_irqs:
>                          __irq_domain_alloc_irqs:
>                            irq_domain_alloc_irqs_locked:
>                              irq_domain_alloc_irqs_hierarchy:
>                                msi_domain_alloc:
>                                  irq_domain_alloc_irqs_parent:
>                                    its_irq_domain_alloc(); // PATCH-2
> 
> Note that this series solves half the problem, since it only allows kernel
> to set the physical PCI MSI/MSI-X on the device with the correct head IOVA
> of a 2-stage translation, where the guest kernel does the stage-1 mapping
> that MSI IOVA (0xEEEE0000) to its own vITS page (0x80900000) while missing
> the stage-2 mapping from that IPA to the physical ITS page:
>    0xEEEE0000 ===> 0x80900000 =x=> 0x20200000
> A followup series should fill that gap, doing the stage-2 mapping from the
> vITS page 0x80900000 to the physical ITS page (0x20200000), likely via new
> IOMMUFD ioctl. Once VMM sets up this stage-2 mapping, VM will act the same
> as bare metal relying on a running kernel to handle the stage-1 mapping:
>    0xEEEE0000 ===> 0x80900000 ===> 0x20200000
> 
> This series (prototype) is on Github:
> https://github.com/nicolinc/iommufd/commits/vfio_msi_giova-rfcv1/
> It's tested by hacking the host kernel to hard-code a stage-2 mapping.
> 
> Thanks!
> Nicolin
> 
> Nicolin Chen (7):
>    genirq/msi: Allow preset IOVA in struct msi_desc for MSI doorbell
>      address
>    irqchip/gic-v3-its: Bypass iommu_cookie if desc->msi_iova is preset
>    PCI/MSI: Pass in msi_iova to msi_domain_insert_msi_desc
>    PCI/MSI: Allow __pci_enable_msi_range to pass in iova
>    PCI/MSI: Extract a common __pci_alloc_irq_vectors function
>    PCI/MSI: Add pci_alloc_irq_vectors_iovas helper
>    vfio/pci: Allow preset MSI IOVAs via VFIO_IRQ_SET_ACTION_PREPARE
> 
>   drivers/pci/msi/msi.h             |   3 +-
>   include/linux/msi.h               |  11 +++
>   include/linux/pci.h               |  18 ++++
>   include/linux/vfio_pci_core.h     |   1 +
>   include/uapi/linux/vfio.h         |   8 +-
>   drivers/irqchip/irq-gic-v3-its.c  |  21 ++++-
>   drivers/pci/msi/api.c             | 136 ++++++++++++++++++++----------
>   drivers/pci/msi/msi.c             |  20 +++--
>   drivers/vfio/pci/vfio_pci_intrs.c |  41 ++++++++-
>   drivers/vfio/vfio_main.c          |   3 +
>   kernel/irq/msi.c                  |   6 ++
>   11 files changed, 212 insertions(+), 56 deletions(-)
> 


