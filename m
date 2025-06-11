Return-Path: <kvm+bounces-49108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F148AD604F
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:46:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47F5E178C85
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 20:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C8D52BD59B;
	Wed, 11 Jun 2025 20:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PTrs60vs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348EE29D19;
	Wed, 11 Jun 2025 20:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749674754; cv=none; b=m22iC1aWvxSMmcPecRVV1jUVnQ3A9uu6zzguaRmmKSpkTpSqev2Vc5g+loqL89IZI/iNll0Sfzr3DM1nQcW1uOyozt1QFLBdDL7KqhR8P8eGU0u9xyGvMnpNGvwuMkSSXQKJl8D0K1iFRWbVP6nXIzjqeRUXwzmcy1bSWIzkNVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749674754; c=relaxed/simple;
	bh=9gGcrTlaX7Ot+p0Hmy1/rRrTB0t9BF5n36xDTYnvymk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a607P6UREB2Ag0eFxfy5T5ySMRXRiZ2mJ92epBW8rVE6B5VsgNk4XD83gZnOYbJoSHKCxayPn9PwiL5v3Jnned5l7pMpP64TK9rkQ43nP6Aq5LlsR1+Oh0so10ScKvTZaVukqebqoNISmKCW/Avwi4vpvIzHGa90aWaT2gvC0S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PTrs60vs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946D9C4CEE3;
	Wed, 11 Jun 2025 20:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749674753;
	bh=9gGcrTlaX7Ot+p0Hmy1/rRrTB0t9BF5n36xDTYnvymk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PTrs60vsOrANk8DoJOFF6F5kfjt9Eh2LOMutAG5DtF9zqjSvEFMWlR4/4S9/yTPAH
	 wcJDdOq8L3uJoYSLLR/pR7JG97UQOUowrmQkSUG162rC8eh7f/MdL71XyG9err4+NU
	 oKRhwZcOoRgEtgx6hcw1jjyOCVDFY+rH5cHh0XbP0k+36i9AgCght0jIhrq8LzbjCA
	 NowiAXLIZiGGm7sQ0wdGzT/kSrdvzGtDHb/MlxamT9CzUR/5ImUAqyvsuVx0cT+qBo
	 LOf2PRtIzB4Qxzkoz0paxOwMmaugDdD0oiX1dAOB+tMTt+A3O5JoJ6lC41zfdKdDOh
	 5DDVaAc5NjbNQ==
Message-ID: <e4047149-ddfe-4b70-991c-81beb18f8291@kernel.org>
Date: Wed, 11 Jun 2025 13:45:49 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] PCI: Explicitly put devices into D0 when initializing
 - Bug report
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>
Cc: bhelgaas@google.com, mario.limonciello@amd.com,
 rafael.j.wysocki@intel.com, huang.ying.caritas@gmail.com,
 stern@rowland.harvard.edu, linux-pci@vger.kernel.org,
 mike.ximing.chen@intel.com, ahsan.atta@intel.com,
 suman.kumar.chakraborty@intel.com, kvm@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <aEl8J3kv6HAcAkUp@gcabiddu-mobl.ger.corp.intel.com>
 <56d0e247-8095-4793-a5a9-0b5cf2565b88@kernel.org>
 <20250611100002.1e14381a.alex.williamson@redhat.com>
 <aEmrJSqhApz/sRe8@gcabiddu-mobl.ger.corp.intel.com>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <aEmrJSqhApz/sRe8@gcabiddu-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/2025 9:13 AM, Cabiddu, Giovanni wrote:
> On Wed, Jun 11, 2025 at 10:00:02AM -0600, Alex Williamson wrote:
>> On Wed, 11 Jun 2025 06:50:59 -0700
>> Mario Limonciello <superm1@kernel.org> wrote:
>>
>>> On 6/11/2025 5:52 AM, Cabiddu, Giovanni wrote:
>>>> Hi Mario, Bjorn and Alex,
>>>>
>>>> On Wed, Apr 23, 2025 at 11:31:32PM -0500, Mario Limonciello wrote:
>>>>> From: Mario Limonciello <mario.limonciello@amd.com>
>>>>>
>>>>> AMD BIOS team has root caused an issue that NVME storage failed to come
>>>>> back from suspend to a lack of a call to _REG when NVME device was probed.
>>>>>
>>>>> commit 112a7f9c8edbf ("PCI/ACPI: Call _REG when transitioning D-states")
>>>>> added support for calling _REG when transitioning D-states, but this only
>>>>> works if the device actually "transitions" D-states.
>>>>>
>>>>> commit 967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI
>>>>> devices") added support for runtime PM on PCI devices, but never actually
>>>>> 'explicitly' sets the device to D0.
>>>>>
>>>>> To make sure that devices are in D0 and that platform methods such as
>>>>> _REG are called, explicitly set all devices into D0 during initialization.
>>>>>
>>>>> Fixes: 967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI devices")
>>>>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>>>>> ---
>>>> Through a bisect, we identified that this patch, in v6.16-rc1,
>>>> introduces a regression on vfio-pci across all Intel QuickAssist (QAT)
>>>> devices. Specifically, the ioctl VFIO_GROUP_GET_DEVICE_FD call fails
>>>> with -EACCES.
>>>>
>>>> Upon further investigation, the -EACCES appears to originate from the
>>>> rpm_resume() function, which is called by pm_runtime_resume_and_get()
>>>> within vfio_pci_core_enable(). Here is the exact call trace:
>>>>
>>>>       drivers/base/power/runtime.c: rpm_resume()
>>>>       drivers/base/power/runtime.c: __pm_runtime_resume()
>>>>       include/linux/pm_runtime.h: pm_runtime_resume_and_get()
>>>>       drivers/vfio/pci/vfio_pci_core.c: vfio_pci_core_enable()
>>>>       drivers/vfio/pci/vfio_pci.c: vfio_pci_open_device()
>>>>       drivers/vfio/vfio_main.c: device->ops->open_device()
>>>>       drivers/vfio/vfio_main.c: vfio_df_device_first_open()
>>>>       drivers/vfio/vfio_main.c: vfio_df_open()
>>>>       drivers/vfio/group.c: vfio_df_group_open()
>>>>       drivers/vfio/group.c: vfio_device_open_file()
>>>>       drivers/vfio/group.c: vfio_group_ioctl_get_device_fd()
>>>>       drivers/vfio/group.c: vfio_group_fops_unl_ioctl(..., VFIO_GROUP_GET_DEVICE_FD, ...)
>>>>
>>>> Is this a known issue that affects other devices? Is there any ongoing
>>>> discussion or fix in progress?
>>>>
>>>> Thanks,
>>>>    
>>>
>>> This is the first I've heard about an issue with that patch.
>>>
>>> Does setting the VFIO parameter disable_idle_d3 help?
>>>
>>> If so; this feels like an imbalance of runtime PM calls in the VFIO
>>> stack that this patch exposed.
>>>
>>> Alex, any ideas?
>>
>> Does the device in question have a PM capability?  I note that
>> 4d4c10f763d7 makes the sequence:
>>
>>         pm_runtime_forbid(&dev->dev);
>>         pm_runtime_set_active(&dev->dev);
>>         pm_runtime_enable(&dev->dev);
>>
>> Dependent on the presence of a PM capability.  The PM capability is
>> optional on SR-IOV VFs.  This feels like a bug in the original patch,
>> we should be able to use pm_runtime ops on a device without
>> specifically checking if the device supports PCI PM.
>>
>> vfio-pci also has a somewhat unique sequence versus other drivers, we
>> don't call pci_enable_device() until the user opens the device, but we
>> want to put the device into low power before that occurs.  Historically
>> PCI-core left device in an unknown power state between driver uses, so
>> we've needed to manually move the device to D0 before calling
>> pm_runtime_allow() and pm_runtime_put() (see
>> vfio_pci_core_register_device()).  Possibly this is redundant now but
>> we're using pci_set_power_state() which shouldn't interact with
>> pm_runtime, so my initial guess is that we might be unbalanced because
>> this is a VF w/o a PM capability and we've missed the expected
>> pm_runtime initialization sequence.  Thanks,
> 
> Yes, for Intel QAT, the issue occurs with a VF without the PM capability.
> 
> Thanks,
> 

Got it, thanks Alex!  I think this should help return it to previous 
behavior for devices without runtime PM and still fix the problem it 
needed to.

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 3dd44d1ad829..c495c3c692f5 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3221,15 +3221,17 @@ void pci_pm_init(struct pci_dev *dev)

         /* find PCI PM capability in list */
         pm = pci_find_capability(dev, PCI_CAP_ID_PM);
-       if (!pm)
+       if (!pm) {
+               goto poweron;
                 return;
+       }
         /* Check device's ability to generate PME# */
         pci_read_config_word(dev, pm + PCI_PM_PMC, &pmc);

         if ((pmc & PCI_PM_CAP_VER_MASK) > 3) {
                 pci_err(dev, "unsupported PM cap regs version (%u)\n",
                         pmc & PCI_PM_CAP_VER_MASK);
-               return;
+               goto poweron;
         }

         dev->pm_cap = pm;
@@ -3274,6 +3276,7 @@ void pci_pm_init(struct pci_dev *dev)
         pci_read_config_word(dev, PCI_STATUS, &status);
         if (status & PCI_STATUS_IMM_READY)
                 dev->imm_ready = 1;
+poweron:
         pci_pm_power_up_and_verify_state(dev);
         pm_runtime_forbid(&dev->dev);
         pm_runtime_set_active(&dev->dev);

