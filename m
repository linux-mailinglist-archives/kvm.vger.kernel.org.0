Return-Path: <kvm+bounces-35776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3951EA14FB8
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 13:55:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 744187A16BF
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 12:55:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 262B31FF1D8;
	Fri, 17 Jan 2025 12:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jvMBIweN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CDF1FCCEE;
	Fri, 17 Jan 2025 12:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737118513; cv=none; b=ZM4OggyIXA0ayDn5cBWWn9VGBpFGq+8Xl8pDPEysoJwwkmeH8crfb2m3DfyeksZudV2T6BJaDmGlCodPDZkbyph5fFt+Zy+MdIdZMjG+onzO1NNqJKMIdeF0YRA6CyNG5nx6YBG0wmAjvuTbgec0jBpxkNriYrBoJ5u3QcLe/gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737118513; c=relaxed/simple;
	bh=K+B0bxaz7wsJWKz3jZMKbZnLN5+OC6mCY4LlrcwGWgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ev+FD9maoCD7AN1iQjfPjquc4U5qdGTpgF1wXHIiobQakvusM+ylmbiOblEsn/V00soJ+EtlWFCFw1VFzcz9e1gww6E4oUMKNPQW5lEb/g5tO3uXkiCAyGERIVWoS8CPpGTZCi2Zzv9OeLPYMiimtK0uXE4KfCMS/W9HyCbZXvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jvMBIweN; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50H3rWqG015119;
	Fri, 17 Jan 2025 12:55:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=3V9PPv
	NutBMaD9LEZMYNx9jEbB/TsV8RFYpqFA+Ve7k=; b=jvMBIweNCSsMfrG0LCaZ5s
	DR65XmPV8dalB/n9/uyhlaLTIzy2IWTzmlXwWKVEqqAp0McClysktofhA2eGZkiM
	tDPqGpWqPaJF/oVjFV9aSwb6/97dEP2jUrJqtwXJSMyl7bVmK8UDcbzpXiI3FxwP
	QJu9uNmf3xeSte+dPCdOXpUix8NWLGBUQYP1RGV04MnmpkZ3bAmzy3UhVkLM0Ads
	8ct00UZdhYpzbLGInIu59FLI+8qEOfSv3+iv9DR4Il/g0IzhDyWUG8/9dA+oIoBK
	+sukKjkM62wdOuL1U6LWJlimQrI/QmD4Qd3GqDHB4RAUG8aMPcUQ3LxE0u/YwyQA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447fpua7e0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 12:55:09 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HB68U4001108;
	Fri, 17 Jan 2025 12:55:08 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44456kapsm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 12:55:08 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HCt6Tl30737148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 12:55:06 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA4D45805B;
	Fri, 17 Jan 2025 12:55:06 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8BA6658058;
	Fri, 17 Jan 2025 12:55:05 +0000 (GMT)
Received: from [9.61.176.130] (unknown [9.61.176.130])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jan 2025 12:55:05 +0000 (GMT)
Message-ID: <f614bde5-6b35-4d6c-a373-f97671ea565d@linux.ibm.com>
Date: Fri, 17 Jan 2025 07:55:05 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Halil Pasic <pasic@linux.ibm.com>, Rorie Reyes <rreyes@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, hca@linux.ibm.com, borntraeger@de.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, jjherne@linux.ibm.com
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
 <20250114150540.64405f27.alex.williamson@redhat.com>
 <5d6402ce-38bd-4632-927e-2551fdd01dbe@linux.ibm.com>
 <20250116011746.20cf941c.pasic@linux.ibm.com>
 <89a1a029-172a-407a-aeb4-0b6228da07e5@linux.ibm.com>
 <20250116115228.10eeb510.alex.williamson@redhat.com>
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20250116115228.10eeb510.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: w3sJKgTdmIeSelq1FNWiuDN5wG4Lcrmc
X-Proofpoint-ORIG-GUID: w3sJKgTdmIeSelq1FNWiuDN5wG4Lcrmc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 clxscore=1015 malwarescore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=897
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501170100




On 1/16/25 11:52 AM, Alex Williamson wrote:
> On Thu, 16 Jan 2025 10:38:41 -0500
> Anthony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> On 1/15/25 7:17 PM, Halil Pasic wrote:
>>> On Wed, 15 Jan 2025 14:35:02 -0500
>>> Anthony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>   
>>>>>> +static int vfio_ap_set_cfg_change_irq(struct ap_matrix_mdev *matrix_mdev, unsigned long arg)
>>>>>> +{
>>>>>> +	s32 fd;
>>>>>> +	void __user *data;
>>>>>> +	unsigned long minsz;
>>>>>> +	struct eventfd_ctx *cfg_chg_trigger;
>>>>>> +
>>>>>> +	minsz = offsetofend(struct vfio_irq_set, count);
>>>>>> +	data = (void __user *)(arg + minsz);
>>>>>> +
>>>>>> +	if (get_user(fd, (s32 __user *)data))
>>>>>> +		return -EFAULT;
>>>>>> +
>>>>>> +	if (fd == -1) {
>>>>>> +		if (matrix_mdev->cfg_chg_trigger)
>>>>>> +			eventfd_ctx_put(matrix_mdev->cfg_chg_trigger);
>>>>>> +		matrix_mdev->cfg_chg_trigger = NULL;
>>>>>> +	} else if (fd >= 0) {
>>>>>> +		cfg_chg_trigger = eventfd_ctx_fdget(fd);
>>>>>> +		if (IS_ERR(cfg_chg_trigger))
>>>>>> +			return PTR_ERR(cfg_chg_trigger);
>>>>>> +
>>>>>> +		if (matrix_mdev->cfg_chg_trigger)
>>>>>> +			eventfd_ctx_put(matrix_mdev->cfg_chg_trigger);
>>>>>> +
>>>>>> +		matrix_mdev->cfg_chg_trigger = cfg_chg_trigger;
>>>>>> +	} else {
>>>>>> +		return -EINVAL;
>>>>>> +	}
>>>>>> +
>>>>>> +	return 0;
>>>>>> +}
>>>>> How does this guard against a use after free, such as the eventfd being
>>>>> disabled or swapped concurrent to a config change?  Thanks,
>>>>>
>>>>> Alex
>>>> Hi Alex. I spent a great deal of time today trying to figure out exactly
>>>> what
>>>> you are asking here; reading about eventfd and digging through code.
>>>> I looked at other places where eventfd is used to set up communication
>>>> of events targetting a vfio device from KVM to userspace (e.g.,
>>>> hw/vfio/ccw.c)
>>>> and do not find anything much different than what is done here. In fact,
>>>> this code looks identical to the code that sets up an eventfd for the
>>>> VFIO_AP_REQ_IRQ_INDEX.
>>>>
>>>> Maybe you can explain how an eventfd is disabled or swapped, or maybe
>>>> explain how we can guard against its use after free. Thanks.
>>> Maybe I will try! The value of matrix_mdev->cfg_chg_trigger is used in:
>>> * vfio_ap_set_cfg_change_irq() (rw, with matrix_dev->mdevs_lock)
>>> * signal_guest_ap_cfg_changed()(r, takes no locks itself, )
>>>     * called by vfio_ap_mdev_update_guest_apcb()
>>>       * called at a bunch of places but AFAICT always with
>>>         matrix_dev->mdevs_lock held
>>>     * called by vfio_ap_mdev_unset_kvm() (with matrix_dev->mdevs_lock held
>>>       via get_update_locks_for_kvm())
>>> * vfio_ap_mdev_probe() (w, assigns NULL to it)
>>>
>>> If vfio_ap_set_cfg_change_irq() could change/destroy
>>> matrix_mdev->cfg_chg_trigger while another thread of execution
>>> is using it e.g. with signal_guest_ap_cfg_changed() that would be a
>>> possible UAF and thus BAD.
>>>
>>> Now AFAICT matrix_mdev->cfg_chg_trigger is protected by
>>> matrix_dev->mdevs_lock on each access except for in vfio_ap_mdev_probe()
>>> which is AFAIK just an initialization in a safe state where we are
>>> guaranteed to have exclusive access.
>>>
>>> The eventfd is swapped and disabled in vfio_ap_set_cfg_change_irq() with
>>> userspace supplying a new valid fd or -1 respectively.
>>>
>>> Tony does that answer your question to Alex?
>>>
>>> Alex, does the above answer your question on what guards against UAF (the
>>> short answer is: matrix_dev->mdevs_lock)?
> Yes, that answers my question, thanks for untangling it.  We might
> consider a lockdep_assert_held() in the new
> signal_guest_ap_cfg_changed() since it does get called from a variety
> of paths and we need that lock to prevent the UAF.
>
>> I agree that the matrix_dev->mdevs_lock does prevent changes to
>> matrix_mdev->cfg_chg_trigger while it is being accessed by the
>> vfio_ap device driver. My confusion arises from my interpretation of
>> Alex's question; it seemed to me that he was talking its use outside
>> of the vfio_ap driver and how to guard against that.
> Nope, Halil zeroed in on the UAF possibility that concerned me.  Thanks,

He is a marksman!:)

>
> Alex
>


