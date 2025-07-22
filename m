Return-Path: <kvm+bounces-53140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC23DB0DF7B
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 16:51:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 856AB3A6F00
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 14:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DE6B2EBDC3;
	Tue, 22 Jul 2025 14:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iObvlvFJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D3C1C84DD;
	Tue, 22 Jul 2025 14:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753195531; cv=none; b=DbFPkpOZZPwc5DFfyeWMyJBFfVTAk+roL9LxyJtwoHshAkZC/EmowtnMj5NCv3kJFtEyXC4UK2HJ30MU0x4v5yOdHWDIAglAUivgL1ljfkCjwWgYgvOFU7hCf5B1J9OcsFzx7+Db1i3M0uKu/VEB1zcDkd6dLcGHIJbVJIJEDoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753195531; c=relaxed/simple;
	bh=gbnu6v4qJ8E6RxAmysMcS7ozBaN1WJkvfllvPveke1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g+DSZnKk0O5h55/DiREaYDnU+dqiKacF2CmWRSYPUq4SACO9URd2R6HjB7Xqfv5uv1Pqnf6TVDyIWu+M+0uXzEjL1VjjFdFhe4aYp8B/ELLFc05pCr/pzfcmJT0rUzjxbbp1CEXbTOaBjyQ9gk4wz1X/Odck7Gu6KL7TDOPE+ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iObvlvFJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59462C4CEF1;
	Tue, 22 Jul 2025 14:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753195531;
	bh=gbnu6v4qJ8E6RxAmysMcS7ozBaN1WJkvfllvPveke1w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iObvlvFJoDDH3xMhNJJVO6d5Xj+rdJGAdrzfzTVdtmscgkINHdOLbmh3YBF5jQf1f
	 ZB4aGP9JA3tWbfJzH63/YqwnM/QPTnJs41gYNDs3NG3bGwmF1UbiDgWrvYJYquVZIv
	 xy6WaCTItaAnhzSYjNyTBt7r0L14WLewWMEmDjjROKMUpvQMaZYbYIuD4QtoqYRCPs
	 l1DLZFvcYrDngoH4ZhhglHCUGEm9sT2+B5jGoNQRwJOcEcxT4Lw4IBot1vysrh1uYf
	 eFOd80riEbwzpnw1P0COKS5VETCMQ1QMoU9xPfpA4c6ii0NkofZqCFmqPEv2pnpfDN
	 YcHTvfLkZT9nQ==
Message-ID: <3e260136-009b-44cd-8fe8-85c34cd93ff8@kernel.org>
Date: Tue, 22 Jul 2025 09:45:28 -0500
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
References: <20250722143817.GA2783917@bhelgaas>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <20250722143817.GA2783917@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/25 9:38 AM, Bjorn Helgaas wrote:
> On Thu, Jul 17, 2025 at 12:38:11PM -0500, Mario Limonciello wrote:
>> From: Mario Limonciello <mario.limonciello@amd.com>
>>
>> On systems with non VGA GPUs fbcon can't find the primary GPU because
>> video_is_primary_device() only checks the VGA arbiter.
>>
>> Add a screen info check to video_is_primary_device() so that callers
>> can get accurate data on such systems.
> 
> This relies on screen_info, which I think is an x86 BIOS-ism.  Isn't
> there a UEFI console path?  How does that compare with this?  Is that
> relevant or is it something completely different?

When I created and tested this I actually did this on a UEFI system 
(which provides a UEFI GOP driver).
  >
>>   bool video_is_primary_device(struct device *dev)
>>   {
>> +#ifdef CONFIG_SCREEN_INFO
>> +	struct screen_info *si = &screen_info;
>> +#endif
>>   	struct pci_dev *pdev;
>>   
>>   	if (!dev_is_pci(dev))
>> @@ -34,7 +38,18 @@ bool video_is_primary_device(struct device *dev)
>>   
>>   	pdev = to_pci_dev(dev);
>>   
>> -	return (pdev == vga_default_device());
>> +	if (!pci_is_display(pdev))
>> +		return false;
>> +
>> +	if (pdev == vga_default_device())
>> +		return true;
>> +
>> +#ifdef CONFIG_SCREEN_INFO
>> +	if (pdev == screen_info_pci_dev(si))
>> +		return true;
>> +#endif
>> +
>> +	return false;
>>   }
>>   EXPORT_SYMBOL(video_is_primary_device);
>>   
>> -- 
>> 2.43.0
>>


