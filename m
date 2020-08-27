Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3EE254D1D
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 20:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgH0Sbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 14:31:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgH0Sbl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 14:31:41 -0400
Received: from localhost (104.sub-72-107-126.myvzw.com [72.107.126.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AE012080C;
        Thu, 27 Aug 2020 18:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598553100;
        bh=OVeBLQ6ZQ5fFczEC90MY0MqT8L1x33M4Ml5mV1UOMUc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=1Kz4pPFZuVx7j5PK98uKnHg9Z1cY6JSry2vNHanYP5I5aGmjuSRIwfpsq0LIdITrY
         Tzel6Kcu31vjkvEaX4Qrce5dUH2d1iQBapxVtPLsRUN0WR/G72hns7TtbFkO4/Vg5P
         tvBGl4MbCJmRrOR013kh4QITysNXVlhecv7j+V3A=
Date:   Thu, 27 Aug 2020 13:31:38 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, bhelgaas@google.com,
        schnelle@linux.ibm.com, pmorel@linux.ibm.com, mpe@ellerman.id.au,
        oohall@gmail.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3] PCI: Introduce flag for detached virtual functions
Message-ID: <20200827183138.GA1929779@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1597333243-29483-2-git-send-email-mjrosato@linux.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Re the subject line, this patch does a lot more than just "introduce a
flag"; AFAICT it actually enables important VFIO functionality, e.g.,
something like:

  vfio/pci: Enable MMIO access for s390 detached VFs

On Thu, Aug 13, 2020 at 11:40:43AM -0400, Matthew Rosato wrote:
> s390x has the notion of providing VFs to the kernel in a manner
> where the associated PF is inaccessible other than via firmware.
> These are not treated as typical VFs and access to them is emulated
> by underlying firmware which can still access the PF.  After
> the referened commit however these detached VFs were no longer able
> to work with vfio-pci as the firmware does not provide emulation of
> the PCI_COMMAND_MEMORY bit.  In this case, let's explicitly recognize
> these detached VFs so that vfio-pci can allow memory access to
> them again.

Out of curiosity, in what sense is the PF inaccessible?  Is it
*impossible* for Linux to access the PF, or is it just not enumerated
by clp_list_pci() so Linux doesn't know about it?

VFs do not implement PCI_COMMAND, so I guess "firmware does not
provide emulation of PCI_COMMAND_MEMORY" means something like "we
can't access the PF so we can't enable/disable PCI_COMMAND_MEMORY"?

s/referened/referenced/

> Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  arch/s390/pci/pci_bus.c            | 13 +++++++++++++
>  drivers/vfio/pci/vfio_pci_config.c |  8 ++++----
>  include/linux/pci.h                |  4 ++++
>  3 files changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/pci/pci_bus.c b/arch/s390/pci/pci_bus.c
> index 642a993..1b33076 100644
> --- a/arch/s390/pci/pci_bus.c
> +++ b/arch/s390/pci/pci_bus.c
> @@ -184,6 +184,19 @@ static inline int zpci_bus_setup_virtfn(struct zpci_bus *zbus,
>  }
>  #endif
>  
> +void pcibios_bus_add_device(struct pci_dev *pdev)
> +{
> +	struct zpci_dev *zdev = to_zpci(pdev);
> +
> +	/*
> +	 * If we have a VF on a non-multifunction bus, it must be a VF that is
> +	 * detached from its parent PF.  We rely on firmware emulation to
> +	 * provide underlying PF details.

What exactly does "multifunction bus" mean?  I'm familiar with
multi-function *devices*, but not multi-function buses.

> +	 */
> +	if (zdev->vfn && !zdev->zbus->multifunction)
> +		pdev->detached_vf = 1;
> +}
> +
>  static int zpci_bus_add_device(struct zpci_bus *zbus, struct zpci_dev *zdev)
>  {
>  	struct pci_bus *bus;
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index d98843f..98f93d1 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -406,7 +406,7 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
>  	 * PF SR-IOV capability, there's therefore no need to trigger
>  	 * faults based on the virtual value.
>  	 */
> -	return pdev->is_virtfn || (cmd & PCI_COMMAND_MEMORY);
> +	return dev_is_vf(&pdev->dev) || (cmd & PCI_COMMAND_MEMORY);

I'm not super keen on the idea of having two subtly different ways of
identifying VFs.  I think that will be confusing.  This seems to be
the critical line, so whatever we do here, it will be out of the
ordinary and probably deserves a little comment.

If Linux doesn't see the PF, does pci_physfn(VF) return NULL, i.e., is
VF->physfn NULL?

>  }
>  
>  /*
> @@ -420,7 +420,7 @@ static void vfio_bar_restore(struct vfio_pci_device *vdev)
>  	u16 cmd;
>  	int i;
>  
> -	if (pdev->is_virtfn)
> +	if (dev_is_vf(&pdev->dev))
>  		return;
>  
>  	pci_info(pdev, "%s: reset recovery - restoring BARs\n", __func__);
> @@ -521,7 +521,7 @@ static int vfio_basic_config_read(struct vfio_pci_device *vdev, int pos,
>  	count = vfio_default_config_read(vdev, pos, count, perm, offset, val);
>  
>  	/* Mask in virtual memory enable for SR-IOV devices */
> -	if (offset == PCI_COMMAND && vdev->pdev->is_virtfn) {
> +	if ((offset == PCI_COMMAND) && (dev_is_vf(&vdev->pdev->dev))) {
>  		u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
>  		u32 tmp_val = le32_to_cpu(*val);
>  
> @@ -1713,7 +1713,7 @@ int vfio_config_init(struct vfio_pci_device *vdev)
>  	vdev->rbar[5] = le32_to_cpu(*(__le32 *)&vconfig[PCI_BASE_ADDRESS_5]);
>  	vdev->rbar[6] = le32_to_cpu(*(__le32 *)&vconfig[PCI_ROM_ADDRESS]);
>  
> -	if (pdev->is_virtfn) {
> +	if (dev_is_vf(&pdev->dev)) {
>  		*(__le16 *)&vconfig[PCI_VENDOR_ID] = cpu_to_le16(pdev->vendor);
>  		*(__le16 *)&vconfig[PCI_DEVICE_ID] = cpu_to_le16(pdev->device);
>  
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 8355306..7c062de 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -445,6 +445,7 @@ struct pci_dev {
>  	unsigned int	is_probed:1;		/* Device probing in progress */
>  	unsigned int	link_active_reporting:1;/* Device capable of reporting link active */
>  	unsigned int	no_vf_scan:1;		/* Don't scan for VFs after IOV enablement */
> +	unsigned int	detached_vf:1;		/* VF without local PF access */
>  	pci_dev_flags_t dev_flags;
>  	atomic_t	enable_cnt;	/* pci_enable_device has been called */
>  
> @@ -1057,6 +1058,8 @@ struct resource *pci_find_parent_resource(const struct pci_dev *dev,
>  void pci_sort_breadthfirst(void);
>  #define dev_is_pci(d) ((d)->bus == &pci_bus_type)
>  #define dev_is_pf(d) ((dev_is_pci(d) ? to_pci_dev(d)->is_physfn : false))
> +#define dev_is_vf(d) ((dev_is_pci(d) ? (to_pci_dev(d)->is_virtfn || \
> +					to_pci_dev(d)->detached_vf) : false))
>  
>  /* Generic PCI functions exported to card drivers */
>  
> @@ -1764,6 +1767,7 @@ static inline struct pci_dev *pci_get_domain_bus_and_slot(int domain,
>  
>  #define dev_is_pci(d) (false)
>  #define dev_is_pf(d) (false)
> +#define dev_is_vf(d) (false)
>  static inline bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
>  { return false; }
>  static inline int pci_irqd_intx_xlate(struct irq_domain *d,
> -- 
> 1.8.3.1
> 
