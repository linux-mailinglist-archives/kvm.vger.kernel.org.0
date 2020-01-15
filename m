Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAF7313C148
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 13:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgAOMnX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 07:43:23 -0500
Received: from foss.arm.com ([217.140.110.172]:36388 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgAOMnX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 07:43:23 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A778331B;
        Wed, 15 Jan 2020 04:43:22 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D4FC33F534;
        Wed, 15 Jan 2020 04:43:21 -0800 (PST)
Subject: Re: [PATCH kvmtool 04/16] Check that a PCI device's memory size is
 power of two
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
References: <20191125103033.22694-1-alexandru.elisei@arm.com>
 <20191125103033.22694-5-alexandru.elisei@arm.com>
 <20191127182514.23d719ff@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <8800ef85-045e-f83d-6a43-d62f5cc8d8dd@arm.com>
Date:   Wed, 15 Jan 2020 12:43:20 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191127182514.23d719ff@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/27/19 6:25 PM, Andre Przywara wrote:
> On Mon, 25 Nov 2019 10:30:21 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> According to the PCI local bus specification [1], a device's memory size
>> must be a power of two. This is also implicit in the mechanism that a CPU
>> uses to get the memory size requirement for a PCI device.
>>
>> The vesa device requests a memory size that isn't a power of two.
>> According to the same spec [1], a device is allowed to consume more memory
>> than it actually requires. As a result, the amount of memory that the vesa
>> device now reserves has been increased.
>>
>> To prevent slip-ups in the future, a few BUILD_BUG_ON statements were added
>> in places where the memory size is known at compile time.
>>
>> [1] PCI Local Bus Specification Revision 3.0, section 6.2.5.1
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  hw/vesa.c          | 2 ++
>>  include/kvm/util.h | 2 ++
>>  include/kvm/vesa.h | 6 +++++-
>>  vfio/pci.c         | 5 +++++
>>  virtio/pci.c       | 3 +++
>>  5 files changed, 17 insertions(+), 1 deletion(-)
>>
>> diff --git a/hw/vesa.c b/hw/vesa.c
>> index f3c5114cf4fe..75670a51be5f 100644
>> --- a/hw/vesa.c
>> +++ b/hw/vesa.c
>> @@ -58,6 +58,8 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>>  	char *mem;
>>  	int r;
>>  
>> +	BUILD_BUG_ON(!is_power_of_two(VESA_MEM_SIZE));
>> +
>>  	if (!kvm->cfg.vnc && !kvm->cfg.sdl && !kvm->cfg.gtk)
>>  		return NULL;
>>  
>> diff --git a/include/kvm/util.h b/include/kvm/util.h
>> index 4ca7aa9392b6..e90f1c2db39f 100644
>> --- a/include/kvm/util.h
>> +++ b/include/kvm/util.h
>> @@ -104,6 +104,8 @@ static inline unsigned long roundup_pow_of_two(unsigned long x)
>>  	return x ? 1UL << fls_long(x - 1) : 0;
>>  }
>>  
>> +#define is_power_of_two(x)	((x) ? ((x) & ((x) - 1)) == 0 : 0)
> This gives weird results for negative values (which the kernel avoids by having this a static inline and using an unsigned type).
> Not sure we care, but maybe (x > 0) ? ... would fix this?

Good point, I will fix it by changing the implicit comparison against 0 at the
beginning with (x) > 0.

>
>> +
>>  struct kvm;
>>  void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size);
>>  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
>> diff --git a/include/kvm/vesa.h b/include/kvm/vesa.h
>> index 0fac11ab5a9f..e7d971343642 100644
>> --- a/include/kvm/vesa.h
>> +++ b/include/kvm/vesa.h
>> @@ -5,8 +5,12 @@
>>  #define VESA_HEIGHT	480
>>  
>>  #define VESA_MEM_ADDR	0xd0000000
>> -#define VESA_MEM_SIZE	(4*VESA_WIDTH*VESA_HEIGHT)
>>  #define VESA_BPP	32
>> +/*
>> + * We actually only need VESA_BPP/8*VESA_WIDTH*VESA_HEIGHT bytes. But the memory
>> + * size must be a power of 2, so we round up.
>> + */
>> +#define VESA_MEM_SIZE	(1 << 21)
> I don't think it's worth calculating the value and rounding it up, but can we have a BUILD_BUG checking that VESA_MEM_SIZE is big enough to hold the framebuffer?

I'm not sure what you mean. The current value of VESA_MEM_SIZE is not a power of
two, which breaks the spec. That's the reason for changing it. Are you suggesting
that we keep VESA_MEM_SIZE = 1 << 21, we remove the power_of_two check and add a
BUILD_BUG on VESA_MEM_SIZE < 4 * VESA_WIDTH * VESA_HEIGHT?

Thanks,
Alex
>
> Cheers,
> Andre
>
>>  
>>  struct kvm;
>>  struct biosregs;
>> diff --git a/vfio/pci.c b/vfio/pci.c
>> index 76e24c156906..914732cc6897 100644
>> --- a/vfio/pci.c
>> +++ b/vfio/pci.c
>> @@ -831,6 +831,11 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
>>  	/* Ignore invalid or unimplemented regions */
>>  	if (!region->info.size)
>>  		return 0;
>> +	if (!is_power_of_two(region->info.size)) {
>> +		vfio_dev_err(vdev, "region is not power of two: 0x%llx",
>> +			     region->info.size);
>> +		return -EINVAL;
>> +	}
>>  
>>  	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX) {
>>  		/* Trap and emulate MSI-X table */
>> diff --git a/virtio/pci.c b/virtio/pci.c
>> index 99653cad2c0f..04e801827df9 100644
>> --- a/virtio/pci.c
>> +++ b/virtio/pci.c
>> @@ -435,6 +435,9 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>>  	vpci->kvm = kvm;
>>  	vpci->dev = dev;
>>  
>> +	BUILD_BUG_ON(!is_power_of_two(IOPORT_SIZE));
>> +	BUILD_BUG_ON(!is_power_of_two(PCI_IO_SIZE));
>> +
>>  	r = ioport__register(kvm, IOPORT_EMPTY, &virtio_pci__io_ops, IOPORT_SIZE, vdev);
>>  	if (r < 0)
>>  		return r;
