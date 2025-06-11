Return-Path: <kvm+bounces-49067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 59C83AD578B
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 15:51:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1865B189E8B6
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 13:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD2FE28BAB3;
	Wed, 11 Jun 2025 13:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WHvInfJX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25291E487;
	Wed, 11 Jun 2025 13:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749649863; cv=none; b=ffXh3Ln+uq4jkocDPJhPmVCuwL3zoah0CKQ+RwFxrDcNYuN3rWhv0uBTUx+X4Nq/Ze1qg7sd4oDW/Zm1rsuO7kwlAqIP+V1mXXP15+qEB7/KOkb0l3W+Ot0ITlXQm0/fzDE8vfm38zCFFRYc/zqcQj2tkPEeRSvYzQGuaYg3HAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749649863; c=relaxed/simple;
	bh=Dn/yF4tv1L6vdrhzkr6R5Cpsn7ot4gdbtnmxxApYyl0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ewHpObQaNv/1S52BrwPyAd3zhKHsAU40bW79iqUdzhSJz4cPO6MY/Xp4FdmwcOz8EI+U5/+kp+boN/gD3/giO4YQIO6aloyuRJdaCbPhrcYu0h4b5aLJNjkHXzchQvW89qsHofgfj7BI0HdKoPEgvDXQQnLKHTJBJpH2rIFCczQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WHvInfJX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C812C4CEEE;
	Wed, 11 Jun 2025 13:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749649863;
	bh=Dn/yF4tv1L6vdrhzkr6R5Cpsn7ot4gdbtnmxxApYyl0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WHvInfJXz/50bS0+1y1CqOkuJpn2/ViHSWZEo6zAS6DFicXO8OD42xIf3JH6X5bBv
	 IienWC56NlvWtXNzscMAgHmLg/gAq2e6r8cjBLr38HdqVE5QS0739Vaz05DYTGs8Vv
	 jX+dLx+Dxuoefo9SeDIRzUrV3CjEra7HNlv/pRdf0IlmpshBtBPtAp3xQRK++MIWvZ
	 +1YgiMFvL2mROd74Tr3VO5GUYz2UQkU3m/sdUgs3P1vOxCiajI4O8fyocItkVIJhLK
	 kaAHEBoDFh3ilvby8iiVlNv+lWf0iRK6MgoiTHHgnLVOUzrwlgSBS7Ex/ei4Igu4Hz
	 G4BJOznW5gsqQ==
Message-ID: <56d0e247-8095-4793-a5a9-0b5cf2565b88@kernel.org>
Date: Wed, 11 Jun 2025 06:50:59 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] PCI: Explicitly put devices into D0 when initializing
 - Bug report
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>, bhelgaas@google.com,
 alex.williamson@redhat.com
Cc: mario.limonciello@amd.com, rafael.j.wysocki@intel.com,
 huang.ying.caritas@gmail.com, stern@rowland.harvard.edu,
 linux-pci@vger.kernel.org, mike.ximing.chen@intel.com, ahsan.atta@intel.com,
 suman.kumar.chakraborty@intel.com, kvm@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <aEl8J3kv6HAcAkUp@gcabiddu-mobl.ger.corp.intel.com>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <aEl8J3kv6HAcAkUp@gcabiddu-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/2025 5:52 AM, Cabiddu, Giovanni wrote:
> Hi Mario, Bjorn and Alex,
> 
> On Wed, Apr 23, 2025 at 11:31:32PM -0500, Mario Limonciello wrote:
>> From: Mario Limonciello <mario.limonciello@amd.com>
>>
>> AMD BIOS team has root caused an issue that NVME storage failed to come
>> back from suspend to a lack of a call to _REG when NVME device was probed.
>>
>> commit 112a7f9c8edbf ("PCI/ACPI: Call _REG when transitioning D-states")
>> added support for calling _REG when transitioning D-states, but this only
>> works if the device actually "transitions" D-states.
>>
>> commit 967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI
>> devices") added support for runtime PM on PCI devices, but never actually
>> 'explicitly' sets the device to D0.
>>
>> To make sure that devices are in D0 and that platform methods such as
>> _REG are called, explicitly set all devices into D0 during initialization.
>>
>> Fixes: 967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI devices")
>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>> ---
> Through a bisect, we identified that this patch, in v6.16-rc1,
> introduces a regression on vfio-pci across all Intel QuickAssist (QAT)
> devices. Specifically, the ioctl VFIO_GROUP_GET_DEVICE_FD call fails
> with -EACCES.
> 
> Upon further investigation, the -EACCES appears to originate from the
> rpm_resume() function, which is called by pm_runtime_resume_and_get()
> within vfio_pci_core_enable(). Here is the exact call trace:
> 
>      drivers/base/power/runtime.c: rpm_resume()
>      drivers/base/power/runtime.c: __pm_runtime_resume()
>      include/linux/pm_runtime.h: pm_runtime_resume_and_get()
>      drivers/vfio/pci/vfio_pci_core.c: vfio_pci_core_enable()
>      drivers/vfio/pci/vfio_pci.c: vfio_pci_open_device()
>      drivers/vfio/vfio_main.c: device->ops->open_device()
>      drivers/vfio/vfio_main.c: vfio_df_device_first_open()
>      drivers/vfio/vfio_main.c: vfio_df_open()
>      drivers/vfio/group.c: vfio_df_group_open()
>      drivers/vfio/group.c: vfio_device_open_file()
>      drivers/vfio/group.c: vfio_group_ioctl_get_device_fd()
>      drivers/vfio/group.c: vfio_group_fops_unl_ioctl(..., VFIO_GROUP_GET_DEVICE_FD, ...)
> 
> Is this a known issue that affects other devices? Is there any ongoing
> discussion or fix in progress?
> 
> Thanks,
> 

This is the first I've heard about an issue with that patch.

Does setting the VFIO parameter disable_idle_d3 help?

If so; this feels like an imbalance of runtime PM calls in the VFIO 
stack that this patch exposed.

Alex, any ideas?

