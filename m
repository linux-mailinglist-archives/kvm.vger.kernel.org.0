Return-Path: <kvm+bounces-49761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5696FADDD27
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 22:22:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B5F7189FD80
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 20:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D46EF2E3AFF;
	Tue, 17 Jun 2025 20:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HDGsc1mh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB472EFD89;
	Tue, 17 Jun 2025 20:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750191758; cv=none; b=BG8ib6PYHZE0V4B9I8dfLOOLUUWwl9f5Rf3dYGQYbtquVR2NNHi0hhuPdKqaelA7LAPaQrfhvWwCUroo/dCnXVaORg5Xrq86CVrAvzp0wGbVCF2Cqw21drdPvZfC+HOkuv1qW1wpM3Nc5qkEpaLMCyvLmordxcdWAtrpu17PLig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750191758; c=relaxed/simple;
	bh=J6g0JMbLqQPGqasC6o9XOXSYlfEwiBhYFRmGDDOKVKk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e1cNMfFfTfrHDrAg9WfK2eKJDW002Kh045vjS87m7dK7FvzBJuhnpyJi3FaRlhhdvPuFJGBnNGiIUO+dQkVCB48R9WDry8i6B6WPXOQdbUYQ1HE0yCX1U0qp0FAFYuZoR1naakOqEpVR4L3BZtTz7nSVEL4a22db/R0BM/cb5FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HDGsc1mh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34571C4CEE3;
	Tue, 17 Jun 2025 20:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750191757;
	bh=J6g0JMbLqQPGqasC6o9XOXSYlfEwiBhYFRmGDDOKVKk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HDGsc1mhUWSEa8FKP84Yqh4/mc3eosyuoTZNAuaZ99uZ59tERqY8mwEvz697A9CN5
	 zwTIptPUEfGyGckjrte0eOrnVVQz8D/DNKApTH8LhLCSUN8/pPNWRYqnEM5mPoXj0J
	 iBV1EOkAm5encrjRlcZqXylH6PFTOr4T21z0EqN+Ly+6YPTuUN3LBYIqJsseDThtbP
	 easTYu+UXRUBZxf22exZF3zuvZagMPzQMQqL8vYL48flKYuqiZN89cg5MuniBRc2Bz
	 tj9ULiqqIorn0Znw+DqFFYSZxt5mLf11wgUJILhzv1YFVekciGl98+MftbF1rTyFzw
	 Up8otWSF17luA==
Message-ID: <08257531-c8e4-47b1-a5d1-1e67378ff129@kernel.org>
Date: Tue, 17 Jun 2025 15:22:34 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/6] vgaarb: Look at all PCI display devices in VGA
 arbiter
To: Alex Williamson <alex.williamson@redhat.com>,
 David Airlie <airlied@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Simona Vetter <simona@ffwll.ch>, Lukas Wunner <lukas@wunner.de>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Jaroslav Kysela <perex@perex.cz>,
 Takashi Iwai <tiwai@suse.com>,
 "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux.dev>,
 "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>,
 "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
 "open list:SOUND" <linux-sound@vger.kernel.org>,
 Daniel Dadap <ddadap@nvidia.com>,
 Mario Limonciello <mario.limonciello@amd.com>
References: <20250617175910.1640546-1-superm1@kernel.org>
 <20250617175910.1640546-7-superm1@kernel.org>
 <20250617132228.434adebf.alex.williamson@redhat.com>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <20250617132228.434adebf.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/17/25 2:22 PM, Alex Williamson wrote:
> On Tue, 17 Jun 2025 12:59:10 -0500
> Mario Limonciello <superm1@kernel.org> wrote:
> 
>> From: Mario Limonciello <mario.limonciello@amd.com>
>>
>> On a mobile system with an AMD integrated GPU + NVIDIA discrete GPU the
>> AMD GPU is not being selected by some desktop environments for any
>> rendering tasks. This is because neither GPU is being treated as
>> "boot_vga" but that is what some environments use to select a GPU [1].
>>
>> The VGA arbiter driver only looks at devices that report as PCI display
>> VGA class devices. Neither GPU on the system is a PCI display VGA class
>> device:
>>
>> c5:00.0 3D controller: NVIDIA Corporation Device 2db9 (rev a1)
>> c6:00.0 Display controller: Advanced Micro Devices, Inc. [AMD/ATI] Device 150e (rev d1)
>>
>> If the GPUs were looked at the vga_is_firmware_default() function actually
>> does do a good job at recognizing the case from the device used for the
>> firmware framebuffer.
>>
>> Modify the VGA arbiter code and matching sysfs file entries to examine all
>> PCI display class devices. The existing logic stays the same.
>>
>> This will cause all GPUs to gain a `boot_vga` file, but the correct device
>> (AMD GPU in this case) will now show `1` and the incorrect device shows `0`.
>> Userspace then picks the right device as well.
>>
>> Link: https://github.com/robherring/libpciaccess/commit/b2838fb61c3542f107014b285cbda097acae1e12 [1]
>> Suggested-by: Daniel Dadap <ddadap@nvidia.com>
>> Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>> ---
>>   drivers/pci/pci-sysfs.c | 2 +-
>>   drivers/pci/vgaarb.c    | 8 ++++----
>>   2 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
>> index 268c69daa4d57..c314ee1b3f9ac 100644
>> --- a/drivers/pci/pci-sysfs.c
>> +++ b/drivers/pci/pci-sysfs.c
>> @@ -1707,7 +1707,7 @@ static umode_t pci_dev_attrs_are_visible(struct kobject *kobj,
>>   	struct device *dev = kobj_to_dev(kobj);
>>   	struct pci_dev *pdev = to_pci_dev(dev);
>>   
>> -	if (a == &dev_attr_boot_vga.attr && pci_is_vga(pdev))
>> +	if (a == &dev_attr_boot_vga.attr && pci_is_display(pdev))
>>   		return a->mode;
>>   
>>   	return 0;
>> diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
>> index 78748e8d2dbae..63216e5787d73 100644
>> --- a/drivers/pci/vgaarb.c
>> +++ b/drivers/pci/vgaarb.c
>> @@ -1499,8 +1499,8 @@ static int pci_notify(struct notifier_block *nb, unsigned long action,
>>   
>>   	vgaarb_dbg(dev, "%s\n", __func__);
>>   
>> -	/* Only deal with VGA class devices */
>> -	if (!pci_is_vga(pdev))
>> +	/* Only deal with PCI display class devices */
>> +	if (!pci_is_display(pdev))
>>   		return 0;
>>   
>>   	/*
>> @@ -1546,12 +1546,12 @@ static int __init vga_arb_device_init(void)
>>   
>>   	bus_register_notifier(&pci_bus_type, &pci_notifier);
>>   
>> -	/* Add all VGA class PCI devices by default */
>> +	/* Add all PCI display class devices by default */
>>   	pdev = NULL;
>>   	while ((pdev =
>>   		pci_get_subsys(PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
>>   			       PCI_ANY_ID, pdev)) != NULL) {
>> -		if (pci_is_vga(pdev))
>> +		if (pci_is_display(pdev))
>>   			vga_arbiter_add_pci_device(pdev);
>>   	}
>>   
> 
> At the very least a non-VGA device should not mark that it decodes
> legacy resources, marking the boot VGA device is only a part of what
> the VGA arbiter does.  It seems none of the actual VGA arbitration
> interfaces have been considered here though.
> 
> I still think this is a bad idea and I'm not sure Thomas didn't
> withdraw his ack in the previous round[1].  Thanks,

Ah; I didn't realize that was intended to be a withdrawl.
If there's another version of this I'll remove it.

Dave,

What is your current temperature on this approach?

Do you still think it's best for something in the kernel or is this 
better done in libpciaccess?

Mutter, Kwin, and Cosmic all handle this case in the compositor.


> 
> Alex
> 
> [1]https://lore.kernel.org/all/bc0a3ac2-c86c-43b8-b83f-edfdfa5ee184@suse.de/
> 


