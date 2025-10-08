Return-Path: <kvm+bounces-59650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 501B4BC6374
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 19:57:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC5D14059E3
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 17:57:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDD842C0289;
	Wed,  8 Oct 2025 17:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nhb3iT/2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D381A23BE;
	Wed,  8 Oct 2025 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759946213; cv=none; b=WipwThiBtJCYbdEkqlluPWDmcYlU05kLaao3oHQoXRvc2BwFvkkud/On+6FGt+l/PIarh9Enq8yMwY5b1jpK48Ib3LGF2BfNWYFOMtjHDXbnkBurDVns080KpXH/xFwZqjuDG14cVLbjQad2WI+4Izi/NKV7xgg7Xz2eLL3f2hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759946213; c=relaxed/simple;
	bh=v+oYzBJQWZLWE7QRgteYfMB2HjOGiuAm03ecAjKgBPY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BVPeBaYWglNhnUcNoL4m+JG10ReI7YI/Oy68iCIBIU7ku16qHMrAJcB/G2XY0UdOy5CYurEhmnw3iJLoa5mYjvqjB5sfWmmA/dljJYa4FBfPNbDTfqkR8qmUE6owktm3jCGmM/DD54w5CRkjfuIB+GEIykeW2BqlL73x/cIefQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nhb3iT/2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 598HILeL014540;
	Wed, 8 Oct 2025 17:56:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=H3kfyL
	e/7Gl2BWrXvYdIwy/xfa3DOfvvs2jhgyzJe9Y=; b=nhb3iT/2xgu5SCKZta7cTT
	ZmM0eEjQW3W9Wkr0HJCIQJcvkGEv66y3xyGbhaQ1b/BbpaZkKDGQaosoN+80jSYx
	8mcjVGwaooOH9YkBIDQ5qQ/DUm//9UPpv0NNK0+78GxusXp4WGk2SqcBz4/R037h
	1ttho90OngiafA2KmIj4GXto0WlaPBHJVrjCDJ4Knubigad8MmBEh3YvLmJ2W1P5
	4p+OSMgrk13k7hOBTZ7A4/zH4Idx3hCTC06ho6shzfKa6gebhkkT/WhjTiaTQux4
	EfyABfhpLVl0HNkK+8NoToYduD7mbVQEbT9o6k18TRho/3A75C/vp9rgf7sPGv4A
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49nv84g5aq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Oct 2025 17:56:39 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 598HNccQ008346;
	Wed, 8 Oct 2025 17:56:39 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49nvanr3s3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Oct 2025 17:56:39 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 598Hubjl31261396
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Oct 2025 17:56:37 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 56CC85805F;
	Wed,  8 Oct 2025 17:56:37 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D9A458051;
	Wed,  8 Oct 2025 17:56:36 +0000 (GMT)
Received: from [9.61.247.26] (unknown [9.61.247.26])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Oct 2025 17:56:36 +0000 (GMT)
Message-ID: <21ef5524-738a-43d5-bc9a-87f907a8aa70@linux.ibm.com>
Date: Wed, 8 Oct 2025 10:56:35 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/10] PCI: Avoid saving error values for config space
To: Lukas Wunner <lukas@wunner.de>
Cc: Benjamin Block <bblock@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, alex.williamson@redhat.com,
        helgaas@kernel.org, clg@redhat.com, schnelle@linux.ibm.com,
        mjrosato@linux.ibm.com
References: <20250924171628.826-1-alifm@linux.ibm.com>
 <20250924171628.826-2-alifm@linux.ibm.com>
 <20251001151543.GB408411@p1gen4-pw042f0m>
 <ae5b191d-ffc6-4d40-a44b-d08e04cac6be@linux.ibm.com>
 <aOE1JMryY_Oa663e@wunner.de>
 <c0818c13-8075-4db0-b76f-3c9b10516e7a@linux.ibm.com>
 <aOQX6ZTMvekd6gWy@wunner.de>
 <8c14d648-453c-4426-af69-4e911a1128c1@linux.ibm.com>
 <aOZoWDQV0TNh-NiM@wunner.de>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <aOZoWDQV0TNh-NiM@wunner.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=HKPO14tv c=1 sm=1 tr=0 ts=68e6a5d7 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=20KFwNOVAAAA:8 a=Jm_7_FXN7palLUutC2gA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: LOzPvl3q4uO-sFKTsQmaEIEqZjZoyutq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX7lRmZlWZ+LJH
 PSR+4QXIVRwWWmdPkouXQXvz1+MMxBcnXaUzHJuSLK3zdvBpW53maL+fl/k5l1+ZLjxs9gwXg8k
 pThTn2hhU37lqsZoPfmCOVaASWxC3oVQW7l5ppEx45vH4rVzyE/ZB4NUso7JtVmHqUf5a0dYt3O
 X1thVeO47+G1sCIB3cOEkjYQyywBLOY/r1xfWhO8vgkW7F0o77RoJ0g/SlNbNBp2r9QmYawGTmV
 M9sEu2z5u/vLC1zk5BvdWK5vuIF2Zo6mLC/FzBr6hU9r7fs4A+zQJeo4gz0En881D0qjobybaiG
 JZidSj07YNczNUQ7WNH02FLYlFsWE5sZWEapGD026ewSfEQy8Ovcue2EPotcJswIQjwny9CybgS
 BKUplFR6dvR9EiLsV/VtfdECvne2ew==
X-Proofpoint-ORIG-GUID: LOzPvl3q4uO-sFKTsQmaEIEqZjZoyutq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-08_05,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121


On 10/8/2025 6:34 AM, Lukas Wunner wrote:
> On Mon, Oct 06, 2025 at 02:35:49PM -0700, Farhan Ali wrote:
>> On 10/6/2025 12:26 PM, Lukas Wunner wrote:
>>> On Mon, Oct 06, 2025 at 10:54:51AM -0700, Farhan Ali wrote:
>>>> On 10/4/2025 7:54 AM, Lukas Wunner wrote:
>>>>> I believe this also makes patch [01/10] in your series unnecessary.
>>>> I tested your patches + patches 2-10 of this series. It unfortunately didn't
>>>> completely help with the s390x use case. We still need the check to in
>>>> pci_save_state() from this patch to make sure we are not saving error
>>>> values, which can be written back to the device in pci_restore_state().
>>> What's the caller of pci_save_state() that needs this?
>>>
>>> Can you move the check for PCI_POSSIBLE_ERROR() to the caller?
>>> I think plenty of other callers don't need this, so it adds
>>> extra overhead for them and down the road it'll be difficult
>>> to untangle which caller needs it and which doesn't.
>> The caller would be pci_dev_save_and_disable(). Are you suggesting moving
>> the PCI_POSSIBLE_ERROR() prior to calling pci_save_state()?
> I'm not sure yet.  Let's back up a little:  I'm missing an
> architectural description how you're intending to do error
> recovery in the VM.  If I understand correctly, you're
> informing the VM of the error via the ->error_detected() callback.
>
> You're saying you need to check for accessibility of the device
> prior to resetting it from the VM, does that mean you're attempting
> a reset from the ->error_detected() callback?
>
> According to Documentation/PCI/pci-error-recovery.rst, the device
> isn't supposed to be considered accessible in ->error_detected().
> The first callback which allows access is ->mmio_enabled().
>
> I also don't quite understand why the VM needs to perform a reset.
> Why can't you just let the VM tell the host that a reset is needed
> (PCI_ERS_RESULT_NEED_RESET) and then the host resets the device on
> behalf of the VM?

The ->error_detected() callback is used to inform userspace of an error. 
In the case of a VM, using QEMU as a userspace, once notified of an 
error QEMU will inject an error into the guest in s390x architecture 
specific way [1] (probably should have linked the QEMU series in the 
cover letter). Once notified of the error VM's device driver will drive 
the recovery action. The recovery action require a reset of the device 
and on s390x PCI devices are reset using architecture specific 
instructions (zpci_device_hot_reset()). QEMU will intercept any low 
level recovery instructions from the VM and then perform a reset of 
device on behalf of the VM [2]. QEMU performs a reset by invoking the 
VFIO_DEVICE_RESET ioctl, which attempts to reset the device 
using pci_try_reset_function().

Once a device is in an error state, MMIO to the device is blocked and so 
any PCI reads to the Config Space will return -1. Since 
pci_try_reset_function() will try to save the state of device's Config 
Space with pci_dev_save_and_disable(), it will end up saving -1 as the 
state. Later when we try to restore the state after a reset, we end up 
corrupting device registers which can send the device into an error 
state again. I was trying to avoid this with the patch.

Hopefully, this answers your questions.

[1] QEMU series 
https://lore.kernel.org/all/20250925174852.1302-1-alifm@linux.ibm.com/

[2] v1 patch series discussion on some nuances of reset mechanism 
https://lore.kernel.org/all/20250814145743.204ca19a.alex.williamson@redhat.com/

>
> Furthermore, I'm thinking that you should be using pci_channel_offline()
> to detect accessibility of the device, rather than reading from
> Config Space and checking for PCI_POSSIBLE_ERROR().
>
>>> The state saved on device addition is just the initial state and
>>> it is fine if later on it gets updated (which is a nicer term than
>>> "overwritten").  E.g. when portdrv.c instantiates port services
>>> and drivers are bound to them, various registers in Config Space
>>> are changed, hence pcie_portdrv_probe() calls pci_save_state()
>>> again.
>>>
>>> However we can discuss whether pci_save_state() is still needed
>>> in pci_dev_save_and_disable().
>> The commit 8dd7f8036c12 ("PCI: add support for function level reset")
>> introduced the logic of saving/restoring the device state after an FLR. My
>> assumption is it was done to save the most recent state of the device (as
>> the state could be updated by drivers). So I think it would still make sense
>> to save the device state in pci_dev_save_and_disable() if the Config Space
>> is still accessible?
> Yes, right now we can't assume that drivers call pci_save_state()
> in their probe hook if they modified Config Space.  They may rely
> on the state being saved prior to reset or a D3hot/D3cold transition.
> So we need to keep the pci_dev_save_and_disable() call for now.
>
> Generally the expectation is that Config Space is accessible when
> performing a reset with pci_try_reset_function().  Since that's
> apparently not guaranteed for your use case, I'm wondering if you
> might be using the function in a context it's not supposed to be used.

I am open to suggestions on how we can do this.

Thanks

Farhan


