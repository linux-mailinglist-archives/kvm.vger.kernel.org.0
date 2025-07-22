Return-Path: <kvm+bounces-53152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20A1AB0E0BC
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 17:39:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 334BEAC1F9F
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 15:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C70427932E;
	Tue, 22 Jul 2025 15:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R7Pltk+9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA2725C833;
	Tue, 22 Jul 2025 15:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753198751; cv=none; b=No8haoM6cK7VBh5tN47d4kw6tyl5lnlrmrqS0dKMeuR4csSrmi4KjlgnX09Fq30Xq6+dlQWRUJweUKdDi2otl6g/7lk2+zP2PgSV9AGYDBMwSrCyYlqIWd5DONeuyxxu7uC68lzm0Z3e3bD6Efz5p1wwwhtWPXc6+fk9K8Kk/lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753198751; c=relaxed/simple;
	bh=/Gjkuw+5Y7LJ0hoFeke0nCDcX+sNxHdnXykOv3WdwLI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NNuiMxXM3yq6hbsGT5zVsAH2yfGgG8efLSPptsCGlbipSUyk9M1mV6MCZNv8YdVahv55WWFe4oKdyUAg/C/uWjDNCFKpuRR0aJTH3MB+1PshhpwrUKMBctumCTJ4TlfIpAssQxgzcbHKEKlWvyz+0bq3sSOlkmBbX2NltshhFm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R7Pltk+9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0C0C4CEF1;
	Tue, 22 Jul 2025 15:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753198751;
	bh=/Gjkuw+5Y7LJ0hoFeke0nCDcX+sNxHdnXykOv3WdwLI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R7Pltk+9rewNqhHJrfLjs8QVOCuOal4FZD8jjgzvt+aAdMBSsX0KA/oG4AVdfnOE7
	 CDtUTsFpa7w/LRaxgrBzDbhFbV7u7RmMpz3Tp4PQZ13+bwBGmTm0FS50D2Ullb7MOZ
	 6twI50kQ0hUpFsdvBEKDXmItWkIW4Qjymiv96G70JOHSatn0Dv6NKWFT+7UCAG/QC5
	 IfZqHlByrcE4HaeSViJU8fEKUgXYxVBnXz0XBtWUh4aUokxQ+LEUJOZVM2xtjaSsUy
	 5swpx0d9Rg0QGKxoNsbVN6oKtNsh6565sqhioEC0+lVfveb2WqK04ENVtQQ0UgMgcB
	 /8/aLpaVhX0BQ==
Message-ID: <93253093-f6a8-4c34-988d-bdc9489cf4f0@kernel.org>
Date: Tue, 22 Jul 2025 10:39:08 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 8/9] fbcon: Use screen info to find primary device
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: David Airlie <airlied@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Simona Vetter <simona@ffwll.ch>, Lukas Wunner <lukas@wunner.de>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux.dev>,
 "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>,
 "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
 "open list:SOUND" <linux-sound@vger.kernel.org>,
 Daniel Dadap <ddadap@nvidia.com>,
 Mario Limonciello <mario.limonciello@amd.com>
References: <20250722153322.GA2785882@bhelgaas>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <20250722153322.GA2785882@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/25 10:33 AM, Bjorn Helgaas wrote:
> On Tue, Jul 22, 2025 at 09:45:28AM -0500, Mario Limonciello wrote:
>> On 7/22/25 9:38 AM, Bjorn Helgaas wrote:
>>> On Thu, Jul 17, 2025 at 12:38:11PM -0500, Mario Limonciello wrote:
>>>> From: Mario Limonciello <mario.limonciello@amd.com>
>>>>
>>>> On systems with non VGA GPUs fbcon can't find the primary GPU because
>>>> video_is_primary_device() only checks the VGA arbiter.
>>>>
>>>> Add a screen info check to video_is_primary_device() so that callers
>>>> can get accurate data on such systems.
>>>
>>> This relies on screen_info, which I think is an x86 BIOS-ism.  Isn't
>>> there a UEFI console path?  How does that compare with this?  Is that
>>> relevant or is it something completely different?
>>
>> When I created and tested this I actually did this on a UEFI system (which
>> provides a UEFI GOP driver).
> 
> I guess screen_info is actually *not* an x86 BIOS-ism, and on UEFI
> systems, we do actually rely on UEFI, e.g., in efi_setup_gop(),
> alloc_screen_info(), init_screen_info()?

Right.  This all works because of the framebuffer allocated pre-boot and 
reused by the kernel.

> 
> But this patch is x86-specific, so I'm guessing the same problem could
> occur on arm64, Loongson, or other UEFI platforms, and this series
> doesn't address those?

I've never seen a multi GPU solution on another architecture, but that 
of course doesn't preclude one being created some day.

The series lays the groundwork that if it happens on another 
architecture we can easily add an architecture specific solution for 
those.  If the solution is the same we could switch to a common helper.

> 
>>>>    bool video_is_primary_device(struct device *dev)
>>>>    {
>>>> +#ifdef CONFIG_SCREEN_INFO
>>>> +	struct screen_info *si = &screen_info;
>>>> +#endif
>>>>    	struct pci_dev *pdev;
>>>>    	if (!dev_is_pci(dev))
>>>> @@ -34,7 +38,18 @@ bool video_is_primary_device(struct device *dev)
>>>>    	pdev = to_pci_dev(dev);
>>>> -	return (pdev == vga_default_device());
>>>> +	if (!pci_is_display(pdev))
>>>> +		return false;
>>>> +
>>>> +	if (pdev == vga_default_device())
>>>> +		return true;
>>>> +
>>>> +#ifdef CONFIG_SCREEN_INFO
>>>> +	if (pdev == screen_info_pci_dev(si))
>>>> +		return true;
>>>> +#endif
>>>> +
>>>> +	return false;
>>>>    }
>>>>    EXPORT_SYMBOL(video_is_primary_device);
>>>> -- 
>>>> 2.43.0
>>>>
>>


