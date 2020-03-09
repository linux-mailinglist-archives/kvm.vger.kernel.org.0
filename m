Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 602BC17E36E
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 16:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgCIPVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 11:21:21 -0400
Received: from foss.arm.com ([217.140.110.172]:53712 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgCIPVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 11:21:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6089430E;
        Mon,  9 Mar 2020 08:21:20 -0700 (PDT)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6AF983F534;
        Mon,  9 Mar 2020 08:21:19 -0700 (PDT)
Subject: Re: [PATCH v2 kvmtool 24/30] vfio/pci: Don't write configuration
 value twice
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-25-alexandru.elisei@arm.com>
 <20200205183525.0ed83c94@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <b2ddb3f6-7d92-921d-d66c-fd8987f632e9@arm.com>
Date:   Mon, 9 Mar 2020 15:21:18 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200205183525.0ed83c94@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/5/20 6:35 PM, Andre Przywara wrote:
> On Thu, 23 Jan 2020 13:47:59 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> After writing to the device fd as part of the PCI configuration space
>> emulation, we read back from the device to make sure that the write
>> finished. The value is read back into the PCI configuration space and
>> afterwards, the same value is copied by the PCI emulation code. Let's
>> read from the device fd into a temporary variable, to prevent this
>> double write.
>>
>> The double write is harmless in itself. But when we implement
>> reassignable BARs, we need to keep track of the old BAR value, and the
>> VFIO code is overwritting it.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  vfio/pci.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/vfio/pci.c b/vfio/pci.c
>> index abde16dc8693..8a775a4a4a54 100644
>> --- a/vfio/pci.c
>> +++ b/vfio/pci.c
>> @@ -470,7 +470,7 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
>>  	struct vfio_region_info *info;
>>  	struct vfio_pci_device *pdev;
>>  	struct vfio_device *vdev;
>> -	void *base = pci_hdr;
>> +	u32 tmp;
> Can we make this a u64, please? I am not sure if 64-bit MMIO is allowed for PCI config space accesses, but a guest could do it anyway, and it looks like it would overwrite the vdev pointer on the stack here in this case.

See my replies to the next patch in the series.

Thanks,
Alex
>
> Cheers,
> Andre.
>
>>  
>>  	if (offset == PCI_ROM_ADDRESS)
>>  		return;
>> @@ -490,7 +490,7 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
>>  	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSI)
>>  		vfio_pci_msi_cap_write(kvm, vdev, offset, data, sz);
>>  
>> -	if (pread(vdev->fd, base + offset, sz, info->offset + offset) != sz)
>> +	if (pread(vdev->fd, &tmp, sz, info->offset + offset) != sz)
>>  		vfio_dev_warn(vdev, "Failed to read %d bytes from Configuration Space at 0x%x",
>>  			      sz, offset);
>>  }
