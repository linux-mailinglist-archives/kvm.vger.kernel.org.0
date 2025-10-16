Return-Path: <kvm+bounces-60227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB905BE57CE
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 23:00:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE496582545
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 21:00:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3EDB2E2661;
	Thu, 16 Oct 2025 21:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="moSYQ9IK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58611B3937;
	Thu, 16 Oct 2025 21:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760648433; cv=none; b=dgAt2mR6nznP3rdna4dQSkyglMsnoj6pVHbR4Xe7jPjXEuIFxAQrgKOXOMMadz33381HQjsRuFz528gSgdIfHbCMW9FA+AyW4NDIYVnSvqIJGEUZ+jBHjPgguccy59ZTMd5e/zfovjIHdklBMNxiKDgdbyXu5IjqeIVf4xyhozo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760648433; c=relaxed/simple;
	bh=R8mh5FQ8064vB6hbEAdsDztpZEieJ8efrSDaY6rzYgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DoO+b03QA6rCDw7uYpsPkih/2hn/p2YBlSvQToaEl7HSnBbQbtl5GNru+dQck08PnpqZvaT/a3vKvYTMo2rt9kEXsjGfgoiTsB0g5bT4ZxVvvD7c/CrcLWSzgXu0PBuOOC/eehHsAD4V+5jLUGurAdfn2T7y33DsFJjAL4P5NeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=moSYQ9IK; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59GK7o4A021089;
	Thu, 16 Oct 2025 21:00:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=t7l/y8
	hH/vFoPwZP3Zfq2IwPXzUBxuBk1Tqib7Yw4C8=; b=moSYQ9IKvrPGw/kMg1WkvX
	mORvn1l41hjFkkmoHEJVcFKSHE0Z61BvPYVfuzZ7JOdo+9jVZlRxQi9iiZ0j3RCv
	SWKTfJvAbI/IITsTRZrmk/h49jxkiLVOjZAvmJKMeJJ/pHpMeOwctL/fecZUbJkr
	AnRxtBSVBVjmiTo8UxLKfUK1tEgw2XVlRPqDmJpX1L/2+j53wmpM0Rr+s0LIzc/b
	nO5POess6Qf4gFmS0bQd+hCOSclH+ATZijlqq70MskYPNjxwGzZ4HzU2+p0eLtpN
	tMQCxosMZ97i76gwDvOZYTyEYppbZizmQbCXh05jr6ICmrCLcKr3iRvwmSTqLEIA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qew0bxqu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Oct 2025 21:00:26 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59GJho19015207;
	Thu, 16 Oct 2025 21:00:26 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 49r1jsg3x4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Oct 2025 21:00:26 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59GL0PRn7078448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Oct 2025 21:00:25 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 31FC558043;
	Thu, 16 Oct 2025 21:00:25 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F8D45805E;
	Thu, 16 Oct 2025 21:00:24 +0000 (GMT)
Received: from [9.61.254.141] (unknown [9.61.254.141])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Oct 2025 21:00:24 +0000 (GMT)
Message-ID: <1ee79c53-4c29-475f-b44e-6839b1feef78@linux.ibm.com>
Date: Thu, 16 Oct 2025 14:00:22 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/10] PCI: Avoid saving error values for config space
To: Niklas Schnelle <schnelle@linux.ibm.com>, Lukas Wunner <lukas@wunner.de>
Cc: Benjamin Block <bblock@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, alex.williamson@redhat.com,
        helgaas@kernel.org, clg@redhat.com, mjrosato@linux.ibm.com
References: <20251001151543.GB408411@p1gen4-pw042f0m>
 <ae5b191d-ffc6-4d40-a44b-d08e04cac6be@linux.ibm.com>
 <aOE1JMryY_Oa663e@wunner.de>
 <c0818c13-8075-4db0-b76f-3c9b10516e7a@linux.ibm.com>
 <aOQX6ZTMvekd6gWy@wunner.de>
 <8c14d648-453c-4426-af69-4e911a1128c1@linux.ibm.com>
 <aOZoWDQV0TNh-NiM@wunner.de>
 <21ef5524-738a-43d5-bc9a-87f907a8aa70@linux.ibm.com>
 <aOaqEhLOzWzswx8O@wunner.de>
 <d69f239040b830718b124c5bcef01b5075768226.camel@linux.ibm.com>
 <aOtL_Y6HH5-qh2jD@wunner.de>
 <bb59edee909ceb09527cedec10896d45126f0027.camel@linux.ibm.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <bb59edee909ceb09527cedec10896d45126f0027.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nYRmfBHz-sJUtlkxxhCAHULZ3YAIdEdY
X-Authority-Analysis: v=2.4 cv=eJkeTXp1 c=1 sm=1 tr=0 ts=68f15ceb cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=PKv9noQjo39VnIMqULwA:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxNCBTYWx0ZWRfXyuDHD4JM2u4g
 bbK7WrmK5hQz+YdmBVZeGIooFLX16nb8sJ9MGhgmdUXtgf/ROPKEHo6hDkcyPLuzSIl6REhDt7C
 3P2X6qV5J6i/pcmmbF04kVbvLHZBnrtP+VDr7GJvbgIfc9zuRPsSAzzo+lQ9LtYyBMm/gUnQxis
 FkIYIKcQ8DY2fVvPFUkAV7UinEM7qFkbShk0SclYQaROUTzcJ391I1XYsyUC7FxPLUnp8gKlaTo
 CSlQIADeadrDT0pDHP9B+mNwTtQCy17jSv/X3xVQaMQksf1cc133P8c3GAziKr+oCw/cBOa5ajV
 StDG4l2dg0MViDWob1DSqBNWhFkPOMS286uXLTKmNGVd6UHsiRSZTA4QxDS7cAnnPxCRgQiJ0TN
 H0JsrcTxPgdBc316lMxBcjGrO+r8xQ==
X-Proofpoint-GUID: nYRmfBHz-sJUtlkxxhCAHULZ3YAIdEdY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 impostorscore=0
 phishscore=0 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510110014


On 10/14/2025 5:07 AM, Niklas Schnelle wrote:
> On Sun, 2025-10-12 at 08:34 +0200, Lukas Wunner wrote:
>> On Thu, Oct 09, 2025 at 11:12:03AM +0200, Niklas Schnelle wrote:
>>> On Wed, 2025-10-08 at 20:14 +0200, Lukas Wunner wrote:
>>>> And yet you're touching the device by trying to reset it.
>>>>
>>>> The code you're introducing in patch [01/10] only becomes necessary
>>>> because you're not following the above-quoted protocol.  If you
>>>> follow the protocol, patch [01/10] becomes unnecessary.
>>> I agree with your point above error_detected() should not touch the
>>> device. My understanding of Farhan's series though is that it follows
>>> that rule. As I understand it error_detected() is only used to inject
>>> the s390 specific PCI error event into the VM using the information
>>> stored in patch 7. As before vfio-pci returns
>>> PCI_ERS_RESULT_CAN_RECOVER from error_detected() but then with patch 7
>>> the pass-through case is detected and this gets turned into
>>> PCI_ERS_RESULT_RECOVERED and the rest of the s390 recovery code gets
>>> skipped. And yeah, writing it down I'm not super happy with this part,
>>> maybe it would be better to have an explicit
>>> PCI_ERS_RESULT_LEAVE_AS_IS.
>> Thanks, that's the high-level overview I was looking for.
>>
>> It would be good to include something like this at least
>> in the cover letter or additionally in the commit messages
>> so that it's easier for reviewers to connect the dots.
>>
>> I was expecting paravirtualized error handling, i.e. the
>> VM is aware it's virtualized and vfio essentially proxies
>> the pci_ers_result return value of the driver (e.g. nvme)
>> back to the host, thereby allowing the host to drive error
>> recovery normally.  I'm not sure if there are technical
>> reasons preventing such an approach.
> It does sound technically feasible but sticking to the already
> architected error reporting and recovery has clear advantages. For one
> it will work with existing Linux versions without guest changes and it
> also has precedent with it working already in the z/VM hypervisor for
> years. I agree that there is some level of mismatch with Linux'
> recovery support but I don't think that outweighs having a clean
> virtualization support where the host and guest use the same interface.
>
>> If you do want to stick with your alternative approach,
>> maybe doing the error handling in the ->mmio_enabled() phase
>> instead of ->error_detected() would make more sense.
>> In that phase you're allowed to access the device,
>> you can also attempt a local reset and return
>> PCI_ERS_RESULT_RECOVERED on success.
>>
>> You'd have to return PCI_ERS_RESULT_CAN_RECOVER though
>> from the ->error_detected() callback in order to progress
>> to the ->mmio_enabled() step.
>>
>> Does that make sense?
>>
>> Thanks,
>>
>> Lukas
> The problem with using ->mmio_enabled() is two fold. For one we
> sometimes have to do a reset instead of clearing the error state, for
> example if the device was not only put in the error state but also
> disabled, or if the guest driver wants it, so we would also have to use
> ->slot_reset() and could end up with two resets. Second and more
> importantly this would break the guests assumption that the device will
> be in the error state with MMIO and DMA blocked when it gets an error
> event. On the other hand, that's exactly the state it is in if we
> report the error in the ->error_detected() callback and then skip the
> rest of recovery so it can be done in the guest, likely with the exact
> same Linux code. I'd assume this should be similar if QEMU/KVM wanted
> to virtualize AER+DPC except that there MMIO remains accessible?
>
> Here's an idea. Could it be an option to detect the pass-through in the
> vfio-pci driver's ->error_detected() callback, possibly with feedback
> from QEMU (@Alex?), and then return PCI_ERS_RESULT_RECOVERED from there
> skipping the rest of recovery?
>
> The skipping would be in-line with the below section of the
> documentation i.e. "no further intervention":
>
>    - PCI_ERS_RESULT_RECOVERED
>        Driver returns this if it thinks the device is usable despite
>        the error and does not need further intervention.
>
> It's just that in this case the device really remains with MMIO and DMA
> blocked, usable only in the sense that the vfio-pci + guest VM combo
> knows how to use a device with MMIO and DMA blocked with the guest
> recovery.
>
> Thanks,
> Niklas

Hi Lukas,

Hope this helps to clarify why we still need patch [01/10] (or at least 
the check in pci_save_state() to see if the device responds with error 
value or not if we move forward with your patch series PCI: Universal 
error recoverability of devices). We can discuss if that check needs to 
be moved somewhere else if there is concern with overhead in 
pci_save_state(). Discussing with Niklas (off mailing list), we were 
thinking if it makes sense if vfio_pci_core_aer_err_detected() returned 
PCI_ERS_RESULT_RECOVERED if it doesn't need any further intervention 
from platform recovery to align closer to pcie-error-recovery 
documentation? One proposal would be to have a flag in struct 
vfio_pci_core_device(eg vdev->mediated_recovery), which can be used to 
return PCI_ERS_RESULT_RECOVERED in vfio_pci_core_aer_err_detected()if 
the flag was set. The flag could be set by userspace using 
VFIO_DEVICE_FEATURE_SET for the device feature 
VFIO_DEVICE_FEATURE_ZPCI_ERROR (would like to hear Alex's thoughts on 
this proposal).

Thanks

Farhan


