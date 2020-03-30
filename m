Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0228E1977E3
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 11:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgC3JaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 05:30:24 -0400
Received: from foss.arm.com ([217.140.110.172]:48330 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727376AbgC3JaY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 05:30:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFC5831B;
        Mon, 30 Mar 2020 02:30:23 -0700 (PDT)
Received: from [192.168.3.111] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CC7583F52E;
        Mon, 30 Mar 2020 02:30:22 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 12/32] vfio/pci: Ignore expansion ROM BAR
 writes
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-13-alexandru.elisei@arm.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
X-Enigmail-Draft-Status: N11100
Organization: ARM Ltd.
Message-ID: <751b91a9-dfe2-fb9f-8485-dac9e9a62cd3@arm.com>
Date:   Mon, 30 Mar 2020 10:29:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200326152438.6218-13-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/03/2020 15:24, Alexandru Elisei wrote:
> To get the size of the expansion ROM, software writes 0xfffff800 to the
> expansion ROM BAR in the PCI configuration space. PCI emulation executes
> the optional configuration space write callback that a device can implement
> before emulating this write.
> 
> kvmtool's implementation of VFIO doesn't have support for emulating
> expansion ROMs. However, the callback writes the guest value to the
> hardware BAR, and then it reads it back to the emulated BAR to make sure
> the write has completed successfully.
> 
> After this, we return to regular PCI emulation and because the BAR is no
> longer 0, we write back to the BAR the value that the guest used to get the
> size. As a result, the guest will think that the ROM size is 0x800 after
> the subsequent read and we end up unintentionally exposing to the guest a
> BAR which we don't emulate.
> 
> Let's fix this by ignoring writes to the expansion ROM BAR.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Thanks,
Andre

> ---
>  vfio/pci.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/vfio/pci.c b/vfio/pci.c
> index 1bdc20038411..1f38f90c3ae9 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -472,6 +472,9 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
>  	struct vfio_device *vdev;
>  	void *base = pci_hdr;
>  
> +	if (offset == PCI_ROM_ADDRESS)
> +		return;
> +
>  	pdev = container_of(pci_hdr, struct vfio_pci_device, hdr);
>  	vdev = container_of(pdev, struct vfio_device, pci);
>  	info = &vdev->regions[VFIO_PCI_CONFIG_REGION_INDEX].info;
> 

