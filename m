Return-Path: <kvm+bounces-54698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 327CFB271A4
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:33:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 499341B67F8B
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 22:33:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1173280CF6;
	Thu, 14 Aug 2025 22:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="H+9LMaCi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE4D1C9DE5;
	Thu, 14 Aug 2025 22:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755210810; cv=none; b=FWJgWw1FPuZ66SLlDHXP7ywLFJO39icxoZRmo1KtwpCVtrhchrnEgbEamTHL86ubGw8wO0HzypXi6ePNHcgsG9ffot0QP5M5979da+nfbwBcSww9Gj04Q2mKnFKzs/EvdrwFjAESu4EwdSBJd2ZBJPWtEw8vHWR09SeNXoQ++9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755210810; c=relaxed/simple;
	bh=uW9o2cHRiQIZjKiQBTACGjxSgnXl+8ONtFIZBOuFIAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vxvr0MRINwmi70O9d+/KrGUwnAZw27ALjP1uV11QfFtaCtrd/SikwtzBG3ulpeqAoFE+P6C5sOmkmp7slxjWr/seGAOEKiqeNuN/47Tl2P1y3OKxioVnPSQ4oeliMxwcFAm9lewj9vmTeHpr5nizAWbwMfUVTo88GRY3zrRzt9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=H+9LMaCi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57EEVVFn011894;
	Thu, 14 Aug 2025 22:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=zuSRUD
	2rkBpJ9+1LYHIAK5zHzxLoyqKNgz3w9zgHtps=; b=H+9LMaCi11Ud44/JfEIOge
	XkB/UfLnKsJy9gq+D32C/3kJcRymCSfUpsbwWplSTlwevV6P5yPkvhH1QUjMmBQW
	IHb27MHLmNL4y88Lff9LC/E9LCPGQ7iPquc+uVbUzXspkSBneRdG/YpwgXANH5NY
	M16Cs6NhRgpGOYoSLQ6ID8G2ddNcXccGj7tEyF+FJeYGy1QJTlZBgwTJk0AbEfSN
	Iik68/WgwswCOO+6XVe+/K/451phykVkMjPhfsIfVCiSDf/zpJxIU4gtBK68/VWs
	0p1hG6vr4CYl+LEyoG9QpCEj01MzQFqUZZD5TF4oWsq5xqJ2eEbtsc7oS5RNUpMg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48durumuck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Aug 2025 22:33:23 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57ELvnQG028674;
	Thu, 14 Aug 2025 22:33:22 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48ej5neaxk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Aug 2025 22:33:22 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57EMXDDa29950518
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 22:33:13 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 27A6958072;
	Thu, 14 Aug 2025 22:33:21 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 93CE058071;
	Thu, 14 Aug 2025 22:33:20 +0000 (GMT)
Received: from [9.61.240.42] (unknown [9.61.240.42])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 14 Aug 2025 22:33:20 +0000 (GMT)
Message-ID: <576abfa6-effb-48b7-b15a-c964fad6ddea@linux.ibm.com>
Date: Thu, 14 Aug 2025 15:33:19 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 5/6] vfio-pci/zdev: Perform platform specific function
 reset for zPCI
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>,
        Bjorn Helgaas <helgaas@kernel.org>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mjrosato@linux.ibm.com
References: <20250813170821.1115-1-alifm@linux.ibm.com>
 <20250813170821.1115-6-alifm@linux.ibm.com>
 <20250813143034.36f8c3a4.alex.williamson@redhat.com>
 <7059025f-f337-493d-a50c-ccce8fb4beee@linux.ibm.com>
 <20250813165631.7c22ef0f.alex.williamson@redhat.com>
 <5c76f6cfb535828f6586a67bd3409981663d14d8.camel@linux.ibm.com>
 <350a9bd5-c2a9-4206-98fd-8a7913d36112@linux.ibm.com>
 <20250814145743.204ca19a.alex.williamson@redhat.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <20250814145743.204ca19a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _Sf7S6Ij0waST6W5barAPpyxPrhMN5Vk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfXyHGdOL8+jly5
 pxyvdo9r8VcDNqPl1hcRQta7tNcwdYrztG+ijsh0jReN9zV6FyWQirWtgYUhLIWNRbA6eW/inSm
 BLVGB7ahrjJ7Tm5k/muUy/siYg1s0kjwYTqX+lHqgWClj3VkjF+OZfqjKhimkWR1b3Znf4uj5T7
 kX+v2XOKtA5slH5uKsPJ0githD676WhJS0GIxHGiwUWcRNASf7/btQQf+H5tuJIcfOPPI1WiI6q
 gpE0N/UkS10/6aHCOkr8xB8S+PmftFnJaXTwfdPaluv1RUKnG0FSSChwJ5a7WoN19lgtKLW9wea
 rg6iJKRx0pwGY+KcETirxeFK+Jz1PFBiiZNdoTHnMJhmnCVIpLCS+A2y0Cznx3BHXH3B5oqmEjj
 66t4lBVM
X-Authority-Analysis: v=2.4 cv=QtNe3Uyd c=1 sm=1 tr=0 ts=689e6433 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=EquB62_POOUgM3g_TNIA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: _Sf7S6Ij0waST6W5barAPpyxPrhMN5Vk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-14_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 phishscore=0 clxscore=1015 malwarescore=0
 spamscore=0 suspectscore=0 impostorscore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508120224


On 8/14/2025 1:57 PM, Alex Williamson wrote:
> On Thu, 14 Aug 2025 09:33:47 -0700
> Farhan Ali <alifm@linux.ibm.com> wrote:
>
>> On 8/14/2025 6:12 AM, Niklas Schnelle wrote:
>>> On Wed, 2025-08-13 at 16:56 -0600, Alex Williamson wrote:
>>>> On Wed, 13 Aug 2025 14:52:24 -0700
>>>> Farhan Ali <alifm@linux.ibm.com> wrote:
>>>>   
>>>>> On 8/13/2025 1:30 PM, Alex Williamson wrote:
>>>>>> On Wed, 13 Aug 2025 10:08:19 -0700
>>>>>> Farhan Ali <alifm@linux.ibm.com> wrote:
>>>>>>      
>>>>>>> For zPCI devices we should drive a platform specific function reset
>>>>>>> as part of VFIO_DEVICE_RESET. This reset is needed recover a zPCI device
>>>>>>> in error state.
>>>>>>>
>>>>>>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>>>>>>> ---
>>>>>>>     arch/s390/pci/pci.c              |  1 +
>>>>>>>     drivers/vfio/pci/vfio_pci_core.c |  4 ++++
>>>>>>>     drivers/vfio/pci/vfio_pci_priv.h |  5 ++++
>>>>>>>     drivers/vfio/pci/vfio_pci_zdev.c | 39 ++++++++++++++++++++++++++++++++
>>>>>>>     4 files changed, 49 insertions(+)
>>> --- snip ---
>>>>>>>     
>>>>>>> +int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev)
>>>>>>> +{
>>>>>>> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
>>>>>>> +	int rc = -EIO;
>>>>>>> +
>>>>>>> +	if (!zdev)
>>>>>>> +		return -ENODEV;
>>>>>>> +
>>>>>>> +	/*
>>>>>>> +	 * If we can't get the zdev->state_lock the device state is
>>>>>>> +	 * currently undergoing a transition and we bail out - just
>>>>>>> +	 * the same as if the device's state is not configured at all.
>>>>>>> +	 */
>>>>>>> +	if (!mutex_trylock(&zdev->state_lock))
>>>>>>> +		return rc;
>>>>>>> +
>>>>>>> +	/* We can reset only if the function is configured */
>>>>>>> +	if (zdev->state != ZPCI_FN_STATE_CONFIGURED)
>>>>>>> +		goto out;
>>>>>>> +
>>>>>>> +	rc = zpci_hot_reset_device(zdev);
>>>>>>> +	if (rc != 0)
>>>>>>> +		goto out;
>>>>>>> +
>>>>>>> +	if (!vdev->pci_saved_state) {
>>>>>>> +		pci_err(vdev->pdev, "No saved available for the device");
>>>>>>> +		rc = -EIO;
>>>>>>> +		goto out;
>>>>>>> +	}
>>>>>>> +
>>>>>>> +	pci_dev_lock(vdev->pdev);
>>>>>>> +	pci_load_saved_state(vdev->pdev, vdev->pci_saved_state);
>>>>>>> +	pci_restore_state(vdev->pdev);
>>>>>>> +	pci_dev_unlock(vdev->pdev);
>>>>>>> +out:
>>>>>>> +	mutex_unlock(&zdev->state_lock);
>>>>>>> +	return rc;
>>>>>>> +}
>>>>>> This looks like it should be a device or arch specific reset
>>>>>> implemented in drivers/pci, not vfio.  Thanks,
>>>>>>
>>>>>> Alex
>>>>> Are you suggesting to move this to an arch specific function? One thing
>>>>> we need to do after the zpci_hot_reset_device, is to correctly restore
>>>>> the config space of the device. And for vfio-pci bound devices we want
>>>>> to restore the state of the device to when it was initially opened.
>>>> We generally rely on the abstraction of pci_reset_function() to select
>>>> the correct type of reset for a function scope reset.  We've gone to
>>>> quite a bit of effort to implement all device specific resets and
>>>> quirks in the PCI core to be re-used across the kernel.
>>>>
>>>> Calling zpci_hot_reset_device() directly seems contradictory to those
>>>> efforts.  Should pci_reset_function() call this universally on s390x
>>>> rather than providing access to FLR/PM/SBR reset?
>>>>   
>>> I agree with you Alex. Still trying to figure out what's needed for
>>> this. We already do zpci_hot_reset_device() in reset_slot() from the
>>> s390_pci_hpc.c hotplug slot driver and that does get called via
>>> pci_reset_hotplug_slot() and pci_reset_function(). There are a few
>>> problems though that meant it didn't work for Farhan but I agree maybe
>>> we can fix them for the general case. For one pci_reset_function()
>>> via DEVICE_RESET first tries FLR but that won't work with the device in
>>> the error state and MMIO blocked. Sadly __pci_reset_function_locked()
>>> then concludes that other resets also won't work. So that's something
>>> we might want to improve in general, for example maybe we need
>>> something more like pci_dev_acpi_reset() with higher priority than FLR.
>> Yeah I did think of adding something like s390x CLP reset as part of the
>> reset methods. AFAIU the s390x CLP reset is similar to ACPI _RST. But
>> that would introduce s390x specific code in pci core common code.
>>
>>> Now for pci_reset_hotplug_slot() via VFIO_DEVICE_PCI_HOT_RESET I'm not
>>> sure why that won't work as is. @Farhan do you know?
>> VFIO_DEVICE_PCI_HOT_RESET would have been sufficient interface for
>> majority of PCI devices on s390x as that would drive a bus reset. It was
>> sufficient as most devices were single bus devices. But in the latest
>> generation of machines (z17) we expose true SR-IOV and an OS can have
>> access to both PF and VFs and so these are on the same bus and can have
>> different ownership based on what is bound to vfio-pci.
>>
>> My thinking for extending VFIO_DEVICE_RESET is because AFAIU its a per
>> function reset mechanism, which maps well with what our architecture
>> provides. On s390x we can drive a per function reset (via firmware)
>> through the CLP instruction driven by the zpci_hot_reset_device(). And
>> doing it as vfio zpci specific function would confine the s390x logic.
>>
>>>>    Why is it
>>>> universally correct here given the ioctl previously made use of
>>>> standard reset mechanisms?
>>>>
>>>> The DEVICE_RESET ioctl is simply an in-place reset of the device,
>>>> without restoring the original device state.  So we're also subtly
>>>> changing that behavior here, presumably because we're targeting the
>>>> specific error recovery case.  Have you considered how this might
>>>> break non-error-recovery use cases?
>>>>
>>>> I wonder if we want a different reset mechanism for this use case
>>>> rather than these subtle semantic changes.
>>> I think an alternative to that, which Farhan actually had in the
>>> previous internal version, is to implement
>>> pci_error_handlers::reset_done() and do the pci_load_saved_state()
>>> there. That would only affect the error recovery case leaving other
>>> cases alone.
>>>
>>>
>>> Thanks,
>>> Niklas
>> The reason I abandoned reset_done() callback idea is because its not
>> sufficient to recover the device correctly. Today before driving a reset
>> we save the state of the device. When a device is in error state, any
>> pci load/store (on s390x they are actual instructions :)) to config
>> space would return an error value (0xffffffff). We don't have any checks
>> in pci_save_state to prevent storing error values. And after a reset
>> when we try to restore the config space (pci_dev_restore) we try to
>> write the error value and this can be problematic. By the time the
>> reset_done() callback is invoked, its already too late.
> It's too late because we've re-written the error value back to config
> space and as a result the device is broken?
>
>
Yes, exactly.

>   What if
> pci_restore_state() were a little smarter to detect that it has bad
> read data from pci_save_state() and only restores state based on kernel
> data?  Would that leave the device in a functional state that
> reset_done() could restore the original saved state and push it out to
> the device?

Yeah I think this could work. I can try something like this.

>> @Alex,
>> I am open to ideas/suggestions on this. Do we think we need a separate
>> VFIO ioctl to drive this or a new reset mechanism as Niklas suggested?
> Unfortunately I was short sighted on VFIO_DEVICE_RESET and it's the one
> ioctl that doesn't have any flags, so it's not very extensible.
>
> Can we do more of the above, ie. enlighten the FLR/PM reset callbacks to
> return -ENOTTY if the device is in an error state and config space is
> returning -1 such that we fall through to a slot reset that doesn't
> care how broken the device is and you auto-magically get the zpci
> function you want?  Follow-up with pushing the original state in
> reset_done()?  Thanks,
>
> Alex
>
Yeah I can do that. I think adding some validation checks to the FLR/PM 
callbacks wouldn't be a bad idea if its acceptable for PCI maintainers.

If you are okay with a reset_done() callback, I will try to incorporate 
your suggestions and spin a new series.

Thanks
Farhan



