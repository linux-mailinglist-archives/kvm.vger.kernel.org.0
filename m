Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4ED3FCC20
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 19:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbhHaRQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 13:16:20 -0400
Received: from foss.arm.com ([217.140.110.172]:56834 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhHaRQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 13:16:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E2C16D;
        Tue, 31 Aug 2021 10:15:24 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C005A3F766;
        Tue, 31 Aug 2021 10:15:22 -0700 (PDT)
Date:   Tue, 31 Aug 2021 18:14:58 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Vivek Gautam <vivek.gautam@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, alexandru.elisei@arm.com,
        lorenzo.pieralisi@arm.com, jean-philippe@linaro.org,
        eric.auger@redhat.com
Subject: Re: [PATCH] vfio/pci: Add support for PCIe extended capabilities
Message-ID: <20210831181458.48d2f35f@slackpad.fritz.box>
In-Reply-To: <20210810062514.18980-1-vivek.gautam@arm.com>
References: <20210810062514.18980-1-vivek.gautam@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 Aug 2021 11:55:14 +0530
Vivek Gautam <vivek.gautam@arm.com> wrote:

Hi Vivek,

> Add support to parse extended configuration space for vfio based
> assigned PCIe devices and add extended capabilities for the device
> in the guest. This allows the guest to see and work on extended
> capabilities, for example to toggle PRI extended cap to enable and
> disable Shared virtual addressing (SVA) support.
> PCIe extended capability header that is the first DWORD of all
> extended caps is shown below -
> 
>    31               20  19   16  15                 0
>    ____________________|_______|_____________________
>   |    Next cap off    |  1h   |     Cap ID          |
>   |____________________|_______|_____________________|
> 
> Out of the two upper bytes of extended cap header, the
> lower nibble is actually cap version - 0x1.
> 'next cap offset' if present at bits [31:20], should be
> right shifted by 4 bits to calculate the position of next
> capability.
> This change supports parsing and adding ATS, PRI and PASID caps.
> 
> Signed-off-by: Vivek Gautam <vivek.gautam@arm.com>
> ---
>  include/kvm/pci.h |   6 +++
>  vfio/pci.c        | 104 ++++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 103 insertions(+), 7 deletions(-)
> 
> diff --git a/include/kvm/pci.h b/include/kvm/pci.h
> index 0f2d5bb..a365337 100644
> --- a/include/kvm/pci.h
> +++ b/include/kvm/pci.h
> @@ -165,6 +165,12 @@ struct pci_exp_cap {
>  	u32 root_status;
>  };
>  
> +struct pci_ext_cap_hdr {
> +	u16	type;
> +	/* bit 19:16 = 0x1: Cap version */
> +	u16	next;
> +};
> +
>  struct pci_device_header;
>  
>  typedef int (*bar_activate_fn_t)(struct kvm *kvm,
> diff --git a/vfio/pci.c b/vfio/pci.c
> index ea33fd6..d045e0d 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -665,19 +665,105 @@ static int vfio_pci_add_cap(struct vfio_device *vdev, u8 *virt_hdr,
>  	return 0;
>  }
>  
> +static ssize_t vfio_pci_ext_cap_size(struct pci_ext_cap_hdr *cap_hdr)
> +{
> +	switch (cap_hdr->type) {
> +	case PCI_EXT_CAP_ID_ATS:
> +		return PCI_EXT_CAP_ATS_SIZEOF;
> +	case PCI_EXT_CAP_ID_PRI:
> +		return PCI_EXT_CAP_PRI_SIZEOF;
> +	case PCI_EXT_CAP_ID_PASID:
> +		return PCI_EXT_CAP_PASID_SIZEOF;
> +	default:
> +		pr_err("unknown extended PCI capability 0x%x", cap_hdr->type);
> +		return 0;

It looks somewhat weird to report an error, but then silently carry on
anyways. Since the return value is signed, you could return something
negative and check for that error in the caller.
I see that is copied from the "normal" capabilities, but maybe this
should be cleaned up there as well? It looks like ending here should be
an internal error, when this list is not up-to-date with the switch/case
below (which can be solved as well on the way).

> +	}
> +}
> +
> +static int vfio_pci_add_ext_cap(struct vfio_device *vdev, u8 *virt_hdr,
> +			    struct pci_ext_cap_hdr *cap, off_t pos)
> +{
> +	struct pci_ext_cap_hdr *last;
> +
> +	cap->next = 0;
> +	last = PCI_CAP(virt_hdr, 0x100);
> +
> +	while (last->next)
> +		last = PCI_CAP(virt_hdr, last->next);
> +
> +	last->next = pos;

This should be folded into the next statement, but ...

> +	/*
> +	 * Out of the two upper bytes of extended cap header, the
> +	 * nibble [19:16] is actually cap version that should be 0x1,
> +	 * so shift back the actual 'next' value by 4 bits.
> +	 */
> +	last->next = (last->next << 4) | 0x1;
> +	memcpy(virt_hdr + pos, cap, vfio_pci_ext_cap_size(cap));

So here you silently ignore the error when we see an unsupported
capability. Granted, copying 0 bytes doesn't do anything, but at the
same time we already updated the next pointer. So I guess you should
query for the size first, and bail out if this is unsupported. Not sure
what to do then, but I think we just ignore/filter that capability then?

> +
> +	return 0;
> +
> +}
> +
> +static int vfio_pci_parse_ext_caps(struct vfio_device *vdev, u8 *virt_hdr)
> +{
> +	int ret;
> +	u16 pos, next;
> +	struct pci_ext_cap_hdr *ext_cap;
> +	struct vfio_pci_device *pdev = &vdev->pci;
> +
> +	/* Extended cap only for PCIe devices */
> +	if (!arch_has_pci_exp())
> +		return 0;
> +
> +	/* Extended caps start from 0x100 offset. */
> +	pos = 0x100;

Please move that into the for-loop statement.

> +
> +	for (; pos; pos = next) {
> +		ext_cap = PCI_CAP(&pdev->hdr, pos);

Don't we need to check if there are extended capabilities at offset
0x100 first?
"Absence of any Extended Capabilities is required to be indicated by an
Extended Capability header with a Capability ID of 0000h, a Capability
Version of 0h, and a Next Capability Offset of 000h."

> +		/*
> +		 * Out of the two upper bytes of extended cap header, the
> +		 * lowest nibble is actually cap version.
> +		 * 'next cap offset' if present at bits [31:20], while
> +		 * bits [19:16] are set to 1 to indicate cap version.
> +		 * So to get position of next cap right shift by 4 bits.
> +		 */
> +		next = (ext_cap->next >> 4);
> +
> +		switch (ext_cap->type) {
> +		case PCI_EXT_CAP_ID_ATS:
> +			ret = vfio_pci_add_ext_cap(vdev, virt_hdr, ext_cap, pos);
> +			if (ret)

That function seems to be always returning 0, but this would be fixed
anyway, I guess. And then you could save the switch/case (which
is somewhat redundant with the one in vfio_pci_ext_cap_size()), and just
pass every capability to vfio_pci_add_ext_cap().

> +				return ret;
> +			break;
> +		case PCI_EXT_CAP_ID_PRI:
> +			ret = vfio_pci_add_ext_cap(vdev, virt_hdr, ext_cap, pos);
> +			if (ret)
> +				return ret;
> +			break;
> +		case PCI_EXT_CAP_ID_PASID:
> +			ret = vfio_pci_add_ext_cap(vdev, virt_hdr, ext_cap, pos);
> +			if (ret)
> +				return ret;
> +			break;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static int vfio_pci_parse_caps(struct vfio_device *vdev)
>  {
>  	int ret;
>  	size_t size;
>  	u16 pos, next;
>  	struct pci_cap_hdr *cap;
> -	u8 virt_hdr[PCI_DEV_CFG_SIZE_LEGACY];
> +	u8 virt_hdr[PCI_DEV_CFG_SIZE];
>  	struct vfio_pci_device *pdev = &vdev->pci;
>  
>  	if (!(pdev->hdr.status & PCI_STATUS_CAP_LIST))
>  		return 0;
>  
> -	memset(virt_hdr, 0, PCI_DEV_CFG_SIZE_LEGACY);
> +	memset(virt_hdr, 0, PCI_DEV_CFG_SIZE);
>  
>  	pos = pdev->hdr.capabilities & ~3;
>  
> @@ -715,9 +801,13 @@ static int vfio_pci_parse_caps(struct vfio_device *vdev)
>  		}
>  	}
>  
> +	ret = vfio_pci_parse_ext_caps(vdev, virt_hdr);
> +	if (ret)
> +		return ret;
> +
>  	/* Wipe remaining capabilities */
>  	pos = PCI_STD_HEADER_SIZEOF;
> -	size = PCI_DEV_CFG_SIZE_LEGACY - PCI_STD_HEADER_SIZEOF;
> +	size = PCI_DEV_CFG_SIZE - PCI_STD_HEADER_SIZEOF;
>  	memcpy((void *)&pdev->hdr + pos, virt_hdr + pos, size);
>  
>  	return 0;
> @@ -725,7 +815,7 @@ static int vfio_pci_parse_caps(struct vfio_device *vdev)
>  
>  static int vfio_pci_parse_cfg_space(struct vfio_device *vdev)
>  {
> -	ssize_t sz = PCI_DEV_CFG_SIZE_LEGACY;
> +	ssize_t sz = PCI_DEV_CFG_SIZE;
>  	struct vfio_region_info *info;
>  	struct vfio_pci_device *pdev = &vdev->pci;
>  
> @@ -831,10 +921,10 @@ static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
>  	/* Install our fake Configuration Space */
>  	info = &vdev->regions[VFIO_PCI_CONFIG_REGION_INDEX].info;
>  	/*
> -	 * We don't touch the extended configuration space, let's be cautious
> -	 * and not overwrite it all with zeros, or bad things might happen.

It would be good to hear from Alex what those bad things are, and if
passing on those extended caps now fixes those.

Cheers,
Andre

> +	 * Update the extended configuration space as well since we
> +	 * are now populating the extended capabilities.
>  	 */
> -	hdr_sz = PCI_DEV_CFG_SIZE_LEGACY;
> +	hdr_sz = PCI_DEV_CFG_SIZE;
>  	if (pwrite(vdev->fd, &pdev->hdr, hdr_sz, info->offset) != hdr_sz) {
>  		vfio_dev_err(vdev, "failed to write %zd bytes to Config Space",
>  			     hdr_sz);

