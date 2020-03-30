Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13B821977E4
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 11:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgC3Jaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 05:30:35 -0400
Received: from foss.arm.com ([217.140.110.172]:48346 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728031AbgC3Jaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 05:30:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 59DB331B;
        Mon, 30 Mar 2020 02:30:34 -0700 (PDT)
Received: from [192.168.3.111] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 79D8D3F52E;
        Mon, 30 Mar 2020 02:30:33 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 13/32] vfio/pci: Don't access unallocated
 regions
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-14-alexandru.elisei@arm.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
X-Enigmail-Draft-Status: N11100
Organization: ARM Ltd.
Message-ID: <280f9e99-dd58-de59-f840-f7816e1d2b83@arm.com>
Date:   Mon, 30 Mar 2020 10:29:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200326152438.6218-14-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/03/2020 15:24, Alexandru Elisei wrote:

Hi,

> Don't try to configure a BAR if there is no region associated with it.
> 
> Also move the variable declarations from inside the loop to the start of
> the function for consistency.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  vfio/pci.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/vfio/pci.c b/vfio/pci.c
> index 1f38f90c3ae9..4412c6d7a862 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -645,16 +645,19 @@ static int vfio_pci_parse_cfg_space(struct vfio_device *vdev)
>  static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
>  {
>  	int i;
> +	u64 base;
>  	ssize_t hdr_sz;
>  	struct msix_cap *msix;
>  	struct vfio_region_info *info;
>  	struct vfio_pci_device *pdev = &vdev->pci;
> +	struct vfio_region *region;
>  
>  	/* Initialise the BARs */
>  	for (i = VFIO_PCI_BAR0_REGION_INDEX; i <= VFIO_PCI_BAR5_REGION_INDEX; ++i) {
> -		u64 base;
> -		struct vfio_region *region = &vdev->regions[i];
> +		if ((u32)i == vdev->info.num_regions)
> +			break;
>  
> +		region = &vdev->regions[i];
>  		/* Construct a fake reg to match what we've mapped. */
>  		if (region->is_ioport) {
>  			base = (region->port_base & PCI_BASE_ADDRESS_IO_MASK) |
> @@ -853,11 +856,12 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
>  	u32 bar;
>  	size_t map_size;
>  	struct vfio_pci_device *pdev = &vdev->pci;
> -	struct vfio_region *region = &vdev->regions[nr];
> +	struct vfio_region *region;
>  
>  	if (nr >= vdev->info.num_regions)
>  		return 0;
>  
> +	region = &vdev->regions[nr];
>  	bar = pdev->hdr.bar[nr];
>  
>  	region->vdev = vdev;
> 

