Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282D01C3B81
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 15:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgEDNoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 09:44:05 -0400
Received: from foss.arm.com ([217.140.110.172]:45142 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbgEDNoE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 09:44:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE34E1FB;
        Mon,  4 May 2020 06:44:03 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A7B13F71F;
        Mon,  4 May 2020 06:44:02 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 25/32] vfio/pci: Don't write configuration
 value twice
To:     =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>,
        kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-26-alexandru.elisei@arm.com>
 <18d7c29d-84c8-4c30-79b8-29a84bbea14a@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <1f25fd8d-23eb-9335-0ac4-52f695e4e634@arm.com>
Date:   Mon, 4 May 2020 14:44:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <18d7c29d-84c8-4c30-79b8-29a84bbea14a@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 4/2/20 9:35 AM, André Przywara wrote:
> On 26/03/2020 15:24, Alexandru Elisei wrote:
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
> It seems still a bit fragile, since we rely on code in other places to
> limit "sz" to 4 or less, but in practice we should be covered.
>
> Can you maybe add an assert here to prevent accidents on the stack?

Sure, sounds reasonable.

Thanks,
Alex
>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Cheers,
> Andre
>
>> ---
>>  vfio/pci.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/vfio/pci.c b/vfio/pci.c
>> index fe02574390f6..8b2a0c8dbac3 100644
>> --- a/vfio/pci.c
>> +++ b/vfio/pci.c
>> @@ -470,7 +470,7 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
>>  	struct vfio_region_info *info;
>>  	struct vfio_pci_device *pdev;
>>  	struct vfio_device *vdev;
>> -	void *base = pci_hdr;
>> +	u32 tmp;
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
>>
