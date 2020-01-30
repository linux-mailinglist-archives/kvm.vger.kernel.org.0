Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 373C714DE38
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 16:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgA3Pwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 10:52:38 -0500
Received: from foss.arm.com ([217.140.110.172]:54710 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbgA3Pwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 10:52:38 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 03E9731B;
        Thu, 30 Jan 2020 07:52:38 -0800 (PST)
Received: from [10.1.27.189] (e121566-lin.cambridge.arm.com [10.1.27.189])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 24BF53F67D;
        Thu, 30 Jan 2020 07:52:35 -0800 (PST)
Subject: Re: [PATCH v2 kvmtool 13/30] vfio/pci: Ignore expansion ROM BAR
 writes
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-14-alexandru.elisei@arm.com>
 <20200130145041.37b8e6fc@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <2bb06067-dce3-5fdd-23d9-2c9d5c7c9c56@arm.com>
Date:   Thu, 30 Jan 2020 15:52:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200130145041.37b8e6fc@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 1/30/20 2:50 PM, Andre Przywara wrote:
> On Thu, 23 Jan 2020 13:47:48 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> To get the size of the expansion ROM, software writes 0xfffff800 to the
>> expansion ROM BAR in the PCI configuration space. PCI emulation executes
>> the optional configuration space write callback that a device can
>> implement before emulating this write.
>>
>> VFIO doesn't have support for emulating expansion ROMs.
> With "VFIO doesn't have support" you mean kvmtool's VFIO implementation or the kernel's VFIO driver?
> Because to me it looks like it should work in the kernel, at least for the BAR sizing on the expansion ROM BAR:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/vfio/pci/vfio_pci_config.c#n477
>
> Am I missing something here?

kvmtool's implementation of VFIO doesn't have support for expansion roms, sorry
for the confusion. VFIO definitely has support for expansion roms, I actually
have some patches that I wrote in a previous iteration of this series that
enable kvmtool to use it (I'll come back to them after this series gets merged).

>
> QEMU seems to have code to load the ROM from the device and present that to the guest, but I am not sure exactly why.

Same here, I don't know why qemu does that, I would have imagined that the
KVM_MEM_READONLY flag for KVM_SET_USER_MEMORY_REGION is a perfect use case for
expansion ROM emulation. To sanitize accesses? To make it possible for the user
to provide its own firmware file for the device? Either way, I think this is a
discussion for another time.

To summarize, I'll reword the commit to remove the confusion - kvmtool's
implementation of VFIO doesn't have support for expansion ROM bars and emulation.

Thanks,
Alex
>
> Cheers,
> Andre
>
>> However, the
>> callback writes the guest value to the hardware BAR, and then it reads
>> it back to the BAR to make sure the write has completed successfully.
>>
>> After this, we return to regular PCI emulation and because the BAR is
>> no longer 0, we write back to the BAR the value that the guest used to
>> get the size. As a result, the guest will think that the ROM size is
>> 0x800 after the subsequent read and we end up unintentionally exposing
>> to the guest a BAR which we don't emulate.
>>
>> Let's fix this by ignoring writes to the expansion ROM BAR.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  vfio/pci.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/vfio/pci.c b/vfio/pci.c
>> index 1bdc20038411..1f38f90c3ae9 100644
>> --- a/vfio/pci.c
>> +++ b/vfio/pci.c
>> @@ -472,6 +472,9 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
>>  	struct vfio_device *vdev;
>>  	void *base = pci_hdr;
>>  
>> +	if (offset == PCI_ROM_ADDRESS)
>> +		return;
>> +
>>  	pdev = container_of(pci_hdr, struct vfio_pci_device, hdr);
>>  	vdev = container_of(pdev, struct vfio_device, pci);
>>  	info = &vdev->regions[VFIO_PCI_CONFIG_REGION_INDEX].info;
