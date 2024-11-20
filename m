Return-Path: <kvm+bounces-32149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F7A9D3C73
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 14:18:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1FAF4B23F3E
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 13:18:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B417E1A9B37;
	Wed, 20 Nov 2024 13:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J45koYJ1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20D81A0AE1
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 13:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732108678; cv=none; b=UO2/JaXizuU4TwFIuIYoxJQB7orkb1r8CTxbsJ0ZwNOU9YFvXl5HSC8jIvCwcSpiLVi6lkixc6ShW22r5wcSlNrbxXnNzVhivWB+SuwsgiK9E/rQNXo0Mf/KkxEAiaqpJWGSXufa5VLlT9dp1kUZ6i9EPdZkb2roCnByh9Egn7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732108678; c=relaxed/simple;
	bh=7pYmcfAOVL4lH7Ez8B+rVq5uAfANeVBdvrYZSZINoWw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jp3reW8Ob14WPcGnOWxNmWqoHw/IpBDfeXU/C2sc8KicZKW3X2G0ggXZe6B2v9ITNXiQENbDczULrAqClqWykD9L3uRTl2BqvfZfcgKX2yZzqntY84hjOn9SJJ7D/5k8SOaC23NunlF5zHnLUYN0jTCnECdchGnqic4+EAm06j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J45koYJ1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732108674;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7pYmcfAOVL4lH7Ez8B+rVq5uAfANeVBdvrYZSZINoWw=;
	b=J45koYJ1PeRy3gxXljhYBc8JoEpVWN2xzgHF+2ZdPjVuRdkLXfB8QR+w6p5rWXAQFFN0ql
	P6YS7Q+qJmAdZomUNMlk7o1SbBOpE7CL9kqls3u27ZIfeK7SCiPTbqiw3msbYjvn/DsLD8
	+c4xHd/b9EvV/1mSRuL9v48T+C28+vY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-lpPTaa_xPXmLcFpQjFa5Sg-1; Wed, 20 Nov 2024 08:17:53 -0500
X-MC-Unique: lpPTaa_xPXmLcFpQjFa5Sg-1
X-Mimecast-MFC-AGG-ID: lpPTaa_xPXmLcFpQjFa5Sg
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6d415a50c7bso73428416d6.0
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 05:17:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732108673; x=1732713473;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7pYmcfAOVL4lH7Ez8B+rVq5uAfANeVBdvrYZSZINoWw=;
        b=Z8lLlXTh5STdnknoHR2/N2207R3znOCnQZ3oeED2N6Xr7SJ0G72F3+1obdPAMX5thT
         8K1z/DrMqZnv1BJU4DMjCD3LMV2QUaIDAaWne76HtNh+koJ2QqeQlR6+5xgszN5cTd0H
         0FyiDfUgB0cFMK5LJsnNX/b2cln6RyQr7sNgt7aeq7ofkKXS3pgPzVMpiRgUhoKZul5e
         xx6j2lujvak5f94nhf2JKrqjEYVUFNhJh0BPzIB/JtYBEZVgZlvJGqMfM5hqjz0o46WU
         KdDksmQ8YCH5xZP2dpFf/d10uHNiLxnEd1aWHXQ82B4D8muiehVqP9uL4QiMZwsXZM/F
         rUyA==
X-Forwarded-Encrypted: i=1; AJvYcCXOfuf8TkXuXc3eJmnLNqhgEXqU3muRamfcxgxVlx5QM5vycuKUbb2GOAyF6cBs4w41qoQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YybGCG3aUOet5alPCycPLo6QubAEUXK68YDKZlgvoQXQ8xzvtAt
	ToOKDN/SPihaiHNtOHhTvomfHrbg8/lh8lLA5ENYFPyGFVn2eOjl37Ojhxrj8a3VTOdDohFTUbt
	sn83aGKrlz7zS5TNFqzOkeyEVFBGKM76Ezs9u65W0bXGOHznaDg==
X-Received: by 2002:a05:6214:21a9:b0:6d4:10b0:c242 with SMTP id 6a1803df08f44-6d43782650cmr36004776d6.26.1732108673333;
        Wed, 20 Nov 2024 05:17:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEoyaTxmYX8UT3QHHo+4fHJkXgTEZWD6Y5LfaFiT6Th8SIw6Ey1ch5deEOkok5XrGrNJJGMpw==
X-Received: by 2002:a05:6214:21a9:b0:6d4:10b0:c242 with SMTP id 6a1803df08f44-6d43782650cmr36004416d6.26.1732108673005;
        Wed, 20 Nov 2024 05:17:53 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d43812ab1csm10435266d6.93.2024.11.20.05.17.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 05:17:52 -0800 (PST)
Message-ID: <66977090-d707-4585-b0c5-8b48f663827e@redhat.com>
Date: Wed, 20 Nov 2024 14:17:46 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFCv1 0/7] vfio: Allow userspace to specify the address
 for each MSI vector
Content-Language: en-US
To: Robin Murphy <robin.murphy@arm.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, tglx@linutronix.de, maz@kernel.org,
 bhelgaas@google.com, leonro@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, dlemoal@kernel.org,
 kevin.tian@intel.com, smostafa@google.com,
 andriy.shevchenko@linux.intel.com, reinette.chatre@intel.com,
 ddutile@redhat.com, yebin10@huawei.com, brauner@kernel.org,
 apatel@ventanamicro.com, shivamurthy.shastri@linutronix.de,
 anna-maria@linutronix.de, nipun.gupta@amd.com,
 marek.vasut+renesas@mailbox.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1731130093.git.nicolinc@nvidia.com>
 <a63e7c3b-ce96-47a5-b462-d5de3a2edb56@arm.com>
 <ZzPOsrbkmztWZ4U/@Asurada-Nvidia> <20241113013430.GC35230@nvidia.com>
 <20241113141122.2518c55a.alex.williamson@redhat.com>
 <2621385c-6fcf-4035-a5a0-5427a08045c8@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <2621385c-6fcf-4035-a5a0-5427a08045c8@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/14/24 16:35, Robin Murphy wrote:
> On 13/11/2024 9:11 pm, Alex Williamson wrote:
>> On Tue, 12 Nov 2024 21:34:30 -0400
>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>
>>> On Tue, Nov 12, 2024 at 01:54:58PM -0800, Nicolin Chen wrote:
>>>> On Mon, Nov 11, 2024 at 01:09:20PM +0000, Robin Murphy wrote:
>>>>> On 2024-11-09 5:48 am, Nicolin Chen wrote:
>>>>>> To solve this problem the VMM should capture the MSI IOVA
>>>>>> allocated by the
>>>>>> guest kernel and relay it to the GIC driver in the host kernel,
>>>>>> to program
>>>>>> the correct MSI IOVA. And this requires a new ioctl via VFIO.
>>>>>
>>>>> Once VFIO has that information from userspace, though, do we
>>>>> really need
>>>>> the whole complicated dance to push it right down into the irqchip
>>>>> layer
>>>>> just so it can be passed back up again? AFAICS
>>>>> vfio_msi_set_vector_signal() via VFIO_DEVICE_SET_IRQS already
>>>>> explicitly
>>>>> rewrites MSI-X vectors, so it seems like it should be pretty
>>>>> straightforward to override the message address in general at that
>>>>> level, without the lower layers having to be aware at all, no?
>>>>
>>>> Didn't see that clearly!! It works with a simple following override:
>>>> --------------------------------------------------------------------
>>>> @@ -497,6 +497,10 @@ static int vfio_msi_set_vector_signal(struct
>>>> vfio_pci_core_device *vdev,
>>>>                  struct msi_msg msg;
>>>>
>>>>                  get_cached_msi_msg(irq, &msg);
>>>> +               if (vdev->msi_iovas) {
>>>> +                       msg.address_lo =
>>>> lower_32_bits(vdev->msi_iovas[vector]);
>>>> +                       msg.address_hi =
>>>> upper_32_bits(vdev->msi_iovas[vector]);
>>>> +               }
>>>>                  pci_write_msi_msg(irq, &msg);
>>>>          }
>>>>   --------------------------------------------------------------------
>>>>
>>>> With that, I think we only need one VFIO change for this part :)
>>>
>>> Wow, is that really OK from a layering perspective? The comment is
>>> pretty clear on the intention that this is to resync the irq layer
>>> view of the device with the physical HW.
>>>
>>> Editing the msi_msg while doing that resync smells bad.
>>>
>>> Also, this is only doing MSI-X, we should include normal MSI as
>>> well. (it probably should have a resync too?)
>>
>> This was added for a specific IBM HBA that clears the vector table
>> during a built-in self test, so it's possible the MSI table being in
>> config space never had the same issue, or we just haven't encountered
>> it.  I don't expect anything else actually requires this.
>
> Yeah, I wasn't really suggesting to literally hook into this exact
> case; it was more just a general observation that if VFIO already has
> one justification for tinkering with pci_write_msi_msg() directly
> without going through the msi_domain layer, then adding another
> (wherever it fits best) can't be *entirely* unreasonable.
>
> At the end of the day, the semantic here is that VFIO does know more
> than the IRQ layer, and does need to program the endpoint differently
> from what the irqchip assumes, so I don't see much benefit in dressing
> that up more than functionally necessary.
>
>>> I'd want Thomas/Marc/Alex to agree.. (please read the cover letter for
>>> context)
>>
>> It seems suspect to me too.  In a sense it is still just synchronizing
>> the MSI address, but to a different address space.
>>
>> Is it possible to do this with the existing write_msi_msg callback on
>> the msi descriptor?  For instance we could simply translate the msg
>> address and call pci_write_msi_msg() (while avoiding an infinite
>> recursion).  Or maybe there should be an xlate_msi_msg callback we can
>> register.  Or I suppose there might be a way to insert an irqchip that
>> does the translation on write.  Thanks,
>
> I'm far from keen on the idea, but if there really is an appetite for
> more indirection, then I guess the least-worst option would be yet
> another type of iommu_dma_cookie to work via the existing
> iommu_dma_compose_msi_msg() flow, with some interface for VFIO to
> update per-device addresses direcitly. But then it's still going to
> need some kind of "layering violation" for VFIO to poke the IRQ layer
> into re-composing and re-writing a message whenever userspace feels
> like changing an address, because we're fundamentally stepping outside
> the established lifecycle of a kernel-managed IRQ around which said
> layering was designed...

for the record, the first integration was based on such distinct
iommu_dma_cookie

[PATCH v15 00/12] SMMUv3 Nested Stage Setup (IOMMU part) <https://lore.kernel.org/all/20210411111228.14386-1-eric.auger@redhat.com/#r>, patches 8 - 11

Thanks

Eric



>
> Thanks,
> Robin.
>


