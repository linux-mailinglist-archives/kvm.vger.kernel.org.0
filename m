Return-Path: <kvm+bounces-31853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BC409C8F91
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 17:21:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 904E0B38510
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 15:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD47418EFCB;
	Thu, 14 Nov 2024 15:35:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA5A5149C53;
	Thu, 14 Nov 2024 15:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731598532; cv=none; b=IuQAwOFVbdCe9v0rfrLzNbVdw7k5rOf5WnVauphGZJ0Rn/Npb0XkDoRYsVOY5fScHBIz+iJjMQGyG0WnFw2Tf8WHmkZQg72uvBQMj+a+AcnmQGtDqsamCwveRYgTHYixzDWnLfF49hbkLFoPeUtaU+jR7CGvdc6LPgVuxdlcfWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731598532; c=relaxed/simple;
	bh=IT4Y74OkXGP7crFm1QoLu/BRJuwnmPvZBB2U0jdzxGs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FRrQL58tAFKo/QceAetQXFIBILtPyrYT3n/l4M2Jxc0VgNtkbCx05kfZcZFyYbUT5lU41aKhC99xA9fFZbH26lknv7XSHhW5Mhb1LAmQ4Qxb38ifV1ErMkwJU6FoVWm/6yorx77njehVgKqLvfXMzBm7/fySbLgHcetM9Zzg4hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6827B169E;
	Thu, 14 Nov 2024 07:35:57 -0800 (PST)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A1FB3F59E;
	Thu, 14 Nov 2024 07:35:16 -0800 (PST)
Message-ID: <2621385c-6fcf-4035-a5a0-5427a08045c8@arm.com>
Date: Thu, 14 Nov 2024 15:35:15 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFCv1 0/7] vfio: Allow userspace to specify the address
 for each MSI vector
To: Alex Williamson <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, tglx@linutronix.de, maz@kernel.org,
 bhelgaas@google.com, leonro@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, dlemoal@kernel.org,
 kevin.tian@intel.com, smostafa@google.com,
 andriy.shevchenko@linux.intel.com, reinette.chatre@intel.com,
 eric.auger@redhat.com, ddutile@redhat.com, yebin10@huawei.com,
 brauner@kernel.org, apatel@ventanamicro.com,
 shivamurthy.shastri@linutronix.de, anna-maria@linutronix.de,
 nipun.gupta@amd.com, marek.vasut+renesas@mailbox.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1731130093.git.nicolinc@nvidia.com>
 <a63e7c3b-ce96-47a5-b462-d5de3a2edb56@arm.com>
 <ZzPOsrbkmztWZ4U/@Asurada-Nvidia> <20241113013430.GC35230@nvidia.com>
 <20241113141122.2518c55a.alex.williamson@redhat.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20241113141122.2518c55a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13/11/2024 9:11 pm, Alex Williamson wrote:
> On Tue, 12 Nov 2024 21:34:30 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
>> On Tue, Nov 12, 2024 at 01:54:58PM -0800, Nicolin Chen wrote:
>>> On Mon, Nov 11, 2024 at 01:09:20PM +0000, Robin Murphy wrote:
>>>> On 2024-11-09 5:48 am, Nicolin Chen wrote:
>>>>> To solve this problem the VMM should capture the MSI IOVA allocated by the
>>>>> guest kernel and relay it to the GIC driver in the host kernel, to program
>>>>> the correct MSI IOVA. And this requires a new ioctl via VFIO.
>>>>
>>>> Once VFIO has that information from userspace, though, do we really need
>>>> the whole complicated dance to push it right down into the irqchip layer
>>>> just so it can be passed back up again? AFAICS
>>>> vfio_msi_set_vector_signal() via VFIO_DEVICE_SET_IRQS already explicitly
>>>> rewrites MSI-X vectors, so it seems like it should be pretty
>>>> straightforward to override the message address in general at that
>>>> level, without the lower layers having to be aware at all, no?
>>>
>>> Didn't see that clearly!! It works with a simple following override:
>>> --------------------------------------------------------------------
>>> @@ -497,6 +497,10 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>>>                  struct msi_msg msg;
>>>
>>>                  get_cached_msi_msg(irq, &msg);
>>> +               if (vdev->msi_iovas) {
>>> +                       msg.address_lo = lower_32_bits(vdev->msi_iovas[vector]);
>>> +                       msg.address_hi = upper_32_bits(vdev->msi_iovas[vector]);
>>> +               }
>>>                  pci_write_msi_msg(irq, &msg);
>>>          }
>>>   
>>> --------------------------------------------------------------------
>>>
>>> With that, I think we only need one VFIO change for this part :)
>>
>> Wow, is that really OK from a layering perspective? The comment is
>> pretty clear on the intention that this is to resync the irq layer
>> view of the device with the physical HW.
>>
>> Editing the msi_msg while doing that resync smells bad.
>>
>> Also, this is only doing MSI-X, we should include normal MSI as
>> well. (it probably should have a resync too?)
> 
> This was added for a specific IBM HBA that clears the vector table
> during a built-in self test, so it's possible the MSI table being in
> config space never had the same issue, or we just haven't encountered
> it.  I don't expect anything else actually requires this.

Yeah, I wasn't really suggesting to literally hook into this exact case; 
it was more just a general observation that if VFIO already has one 
justification for tinkering with pci_write_msi_msg() directly without 
going through the msi_domain layer, then adding another (wherever it 
fits best) can't be *entirely* unreasonable.

At the end of the day, the semantic here is that VFIO does know more 
than the IRQ layer, and does need to program the endpoint differently 
from what the irqchip assumes, so I don't see much benefit in dressing 
that up more than functionally necessary.

>> I'd want Thomas/Marc/Alex to agree.. (please read the cover letter for
>> context)
> 
> It seems suspect to me too.  In a sense it is still just synchronizing
> the MSI address, but to a different address space.
> 
> Is it possible to do this with the existing write_msi_msg callback on
> the msi descriptor?  For instance we could simply translate the msg
> address and call pci_write_msi_msg() (while avoiding an infinite
> recursion).  Or maybe there should be an xlate_msi_msg callback we can
> register.  Or I suppose there might be a way to insert an irqchip that
> does the translation on write.  Thanks,

I'm far from keen on the idea, but if there really is an appetite for 
more indirection, then I guess the least-worst option would be yet 
another type of iommu_dma_cookie to work via the existing 
iommu_dma_compose_msi_msg() flow, with some interface for VFIO to update 
per-device addresses directly. But then it's still going to need some 
kind of "layering violation" for VFIO to poke the IRQ layer into 
re-composing and re-writing a message whenever userspace feels like 
changing an address, because we're fundamentally stepping outside the 
established lifecycle of a kernel-managed IRQ around which said layering 
was designed...

Thanks,
Robin.

