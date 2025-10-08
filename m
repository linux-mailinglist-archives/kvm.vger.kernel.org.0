Return-Path: <kvm+bounces-59656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AE691BC6B7A
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 23:56:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 544934EF724
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 21:56:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1652C1586;
	Wed,  8 Oct 2025 21:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TlwUoGJk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6598529B239;
	Wed,  8 Oct 2025 21:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759960574; cv=none; b=CbgzO1F5bO+nLBMVLH23CQjdZXsiC527CJUeBAv/Hao5SHSXcsTpc3MbQpfGgHKy6xXohcfqz3C+YA/+VCTzNehvQfjBPetNv/jGXCGFIiSqN2PFzMd0uXbNe6gPQOVNuNMHgZ3M2X54NtqhEar1+LBl+sgUlaRgI8V/Gfr0cD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759960574; c=relaxed/simple;
	bh=0rfxjyHOddxQ8hZqlGb1CK88Ff9d2Hi11Y2V+jVAi3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PyLQkMLwJFmyX5erj4Zb5K9DsueAh2fyY1g4RHfcZ8CMouqIb3w2O6J2Q0M+7pppfVDyvwh9IwI4X4Qw3swRG9xNB8auX9JwLBW27DR/RZfsCEdw9VRx7Ye1uD9flUbFMA1/wEAwVDQdx0fPHQH1u2lqDBRKmwqhXDFfyicbyFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TlwUoGJk; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 598HIAcF031169;
	Wed, 8 Oct 2025 21:56:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Jg9l8H
	pCGdLbuHt/Z/homSWGaghUJXOjnsqhbplyurI=; b=TlwUoGJkRFDxUvbYtuP/uJ
	6gBJDjGcWZO8GIFQJNRVsCWAc5A6fEaQqOtVR2RB0YZNqolKry9if4FHZ5DWOdZu
	nirAWPXAkMI1iF+lq5fknMSrzXjUPSFs3oqxIvXjAWscNdYu3169DoawbuGHvjDd
	2mAUysulor10s5u9NYapuvmit6CDFKmPpOJrLdy6rWcUlV5H8vwZThya8sqdIn8r
	eWbDncJBhUd8q9A4GegSkA0ybjkx3A6CqiKEwjBpm69f0WpfHXt9TuR6uJBsgTut
	nVDUTAFJ3qjIFWzTfb0Mo16xf/g8JXH4cvr/2X2FkvSPjUp3FC5aIJRyToOi+G/Q
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49nv81h3mt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Oct 2025 21:56:01 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 598Kw6Gg021058;
	Wed, 8 Oct 2025 21:56:00 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49nv8sh219-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Oct 2025 21:56:00 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 598Ltxfj6292990
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Oct 2025 21:55:59 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E3CB358050;
	Wed,  8 Oct 2025 21:55:58 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A58C858045;
	Wed,  8 Oct 2025 21:55:57 +0000 (GMT)
Received: from [9.61.248.56] (unknown [9.61.248.56])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Oct 2025 21:55:57 +0000 (GMT)
Message-ID: <6c514ba0-7910-4770-903f-62c3e827a40b@linux.ibm.com>
Date: Wed, 8 Oct 2025 14:55:56 -0700
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
 <21ef5524-738a-43d5-bc9a-87f907a8aa70@linux.ibm.com>
 <aOaqEhLOzWzswx8O@wunner.de>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <aOaqEhLOzWzswx8O@wunner.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WE5074a20LXxA8D4pJECRdCkl1uVe9Zh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX/6ZGPa0VAxjx
 aD9xHYLm7Swy1g52dZeuG30C6TPLEm0UhrUoq0njB6CwWHOX0IiM9juNakfAiOP1+QCgSXvF32v
 rkFzOUrd5wJNg6GqFB6aWTznJg9QW73MJjHdALPkAVT4dsq1kud18d3owrqHrR4Ous9HrOC8Cm5
 megYmt9OGJH1jvM+lkH+rpmvcKFsCEWeA553CS+DXf14xQalCiwK0LZDEe8n6MHyYzzcw5Pow/z
 u+NuMtLWUNswC9TfXkwgNK0LZG7WI9G39KR0DAS3naK5+z+TOspb7XTpe3AX/rgYxEatfaGlFyV
 +2DTLIPRTLbdBMVwpKqVhYaCkFy9MZLgu8pOE3uV5KqauUjeQTm0onej2aHw/NaEDW4q/gDdaae
 696nCqwvC8Ra8WP1yAStAURGt/odhw==
X-Authority-Analysis: v=2.4 cv=cKntc1eN c=1 sm=1 tr=0 ts=68e6ddf1 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VB4aJ3K6SYa5zSpflLIA:9
 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: WE5074a20LXxA8D4pJECRdCkl1uVe9Zh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-08_07,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121


On 10/8/2025 11:14 AM, Lukas Wunner wrote:
> On Wed, Oct 08, 2025 at 10:56:35AM -0700, Farhan Ali wrote:
>> On 10/8/2025 6:34 AM, Lukas Wunner wrote:
>>> I'm not sure yet.  Let's back up a little:  I'm missing an
>>> architectural description how you're intending to do error
>>> recovery in the VM.  If I understand correctly, you're
>>> informing the VM of the error via the ->error_detected() callback.
>>>
>>> You're saying you need to check for accessibility of the device
>>> prior to resetting it from the VM, does that mean you're attempting
>>> a reset from the ->error_detected() callback?
>>>
>>> According to Documentation/PCI/pci-error-recovery.rst, the device
>>> isn't supposed to be considered accessible in ->error_detected().
>>> The first callback which allows access is ->mmio_enabled().
>>>
>> The ->error_detected() callback is used to inform userspace of an error. In
>> the case of a VM, using QEMU as a userspace, once notified of an error QEMU
>> will inject an error into the guest in s390x architecture specific way [1]
>> (probably should have linked the QEMU series in the cover letter). Once
>> notified of the error VM's device driver will drive the recovery action. The
>> recovery action require a reset of the device and on s390x PCI devices are
>> reset using architecture specific instructions (zpci_device_hot_reset()).
> According to Documentation/PCI/pci-error-recovery.rst:
>
>     "STEP 1: Notification
>      --------------------
>      Platform calls the error_detected() callback on every instance of
>      every driver affected by the error.
>      At this point, the device might not be accessible anymore, [...]
>      it gives the driver a chance to cleanup, waiting for pending stuff
>      (timers, whatever, etc...) to complete; it can take semaphores,
>      schedule, etc... everything but touch the device."
>                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> And yet you're touching the device by trying to reset it.
>
> The code you're introducing in patch [01/10] only becomes necessary
> because you're not following the above-quoted protocol.  If you
> follow the protocol, patch [01/10] becomes unnecessary.
>
>>> I also don't quite understand why the VM needs to perform a reset.
>>> Why can't you just let the VM tell the host that a reset is needed
>>> (PCI_ERS_RESULT_NEED_RESET) and then the host resets the device on
>>> behalf of the VM?
> Could you answer this question please?
>
>
The reset is not performed by the VM, reset is still done by the host. 
My approach for a VM to let the host know that reset was needed, was to 
intercept any reset instructions for the PCI device in QEMU. QEMU would 
then drive a reset via VFIO_DEVICE_RESET. Maybe I am missing something, 
but based on what we have today in vfio driver, we don't have a 
mechanism for userspace to reset a device other than VFIO_DEVICE_RESET 
and VFIO_PCI_DEVICE_HOT_RESET ioctls.



