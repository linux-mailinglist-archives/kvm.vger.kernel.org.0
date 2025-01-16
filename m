Return-Path: <kvm+bounces-35673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 32680A13DDE
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 16:39:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6575E1885D49
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 15:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAFF122BAAE;
	Thu, 16 Jan 2025 15:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hjABPMmk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA5E1DE881;
	Thu, 16 Jan 2025 15:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737041930; cv=none; b=kRk6C+1Yw5KlbYGrBOaopHo90lgcBNGc5+gDBurUZdzBrL7alzbnckVYoA1cAd1UejZ02yUX2Y3V8u7lnzyW0dmyNjho5NF+wvIfz6StWNKtxroSSU30xOnekCk4RL6Hn6bGkjya0OQLnSMOmSzmZWmnNL6jb2EvIjXr39g8EQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737041930; c=relaxed/simple;
	bh=YuRkZ4RQKeJO8fufTCCX8kVqtSHNnC4hTDbaVnj7otg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qAmmsQGtAFsaBvCsnTwTv4P9bYWhjPkWvDqXwkyxdDKt1Exs7f8qluuJd3fwIVN4pYdbZ2mcqbhRoPf8Ai/dB86SCq3U519hOIED2vI0PDUqqN0izexMKbwIAkCc/EV5BXm1ySBLlQyjWZNSXnbGQCpxQiCXET9zCUd6tn0iPaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hjABPMmk; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GE21Aq004600;
	Thu, 16 Jan 2025 15:38:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ypBShM
	721uvzeOQuo9I8KPiO7ccU1ZLYzZr9TIK8qmw=; b=hjABPMmkT4SEdxz6J+HnGK
	kZcOrVSxoYnLbKhruLX7K7LvAIvGZTmdt6goKGc4aNqfE4nwXbyQz3xZHMosyATj
	AroBztADzpFa+DfCPB5k8uuZjyezT1PkKGuGSLSSwYFgKAp5+APHKwWq7Yn+43Qa
	QipVD+F7udYDcG9xVCwpGHzn7GfY6qzE/o6OJNE+F2b05EQK+nLrZSFWae/YtRGf
	931fuDV1JNnZDC7uSMPtPZ9z+TC0BIrM2m37n57Q9IjSf8evSkFkPAZagqr7Qwj3
	7iI/LxqCXZPDVG4Wnlkl2XurIP6Yh7Ktfh3rAGV5f95QPmV6n5uWREj44zSyeUQw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446tkhb9j2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 15:38:45 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50GCp8Bx002700;
	Thu, 16 Jan 2025 15:38:44 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443byekgf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 15:38:44 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50GFchLc18678174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 15:38:43 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6EA035805B;
	Thu, 16 Jan 2025 15:38:43 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4BAC558058;
	Thu, 16 Jan 2025 15:38:42 +0000 (GMT)
Received: from [9.61.176.130] (unknown [9.61.176.130])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Jan 2025 15:38:42 +0000 (GMT)
Message-ID: <89a1a029-172a-407a-aeb4-0b6228da07e5@linux.ibm.com>
Date: Thu, 16 Jan 2025 10:38:41 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
To: Halil Pasic <pasic@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Rorie Reyes <rreyes@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hca@linux.ibm.com,
        borntraeger@de.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        jjherne@linux.ibm.com
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
 <20250114150540.64405f27.alex.williamson@redhat.com>
 <5d6402ce-38bd-4632-927e-2551fdd01dbe@linux.ibm.com>
 <20250116011746.20cf941c.pasic@linux.ibm.com>
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20250116011746.20cf941c.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RVn2aQYsroivr7RMqhe5zhRKFkmK6KLZ
X-Proofpoint-ORIG-GUID: RVn2aQYsroivr7RMqhe5zhRKFkmK6KLZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxscore=0 clxscore=1015
 bulkscore=0 lowpriorityscore=0 mlxlogscore=942 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501160117




On 1/15/25 7:17 PM, Halil Pasic wrote:
> On Wed, 15 Jan 2025 14:35:02 -0500
> Anthony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>>>> +static int vfio_ap_set_cfg_change_irq(struct ap_matrix_mdev *matrix_mdev, unsigned long arg)
>>>> +{
>>>> +	s32 fd;
>>>> +	void __user *data;
>>>> +	unsigned long minsz;
>>>> +	struct eventfd_ctx *cfg_chg_trigger;
>>>> +
>>>> +	minsz = offsetofend(struct vfio_irq_set, count);
>>>> +	data = (void __user *)(arg + minsz);
>>>> +
>>>> +	if (get_user(fd, (s32 __user *)data))
>>>> +		return -EFAULT;
>>>> +
>>>> +	if (fd == -1) {
>>>> +		if (matrix_mdev->cfg_chg_trigger)
>>>> +			eventfd_ctx_put(matrix_mdev->cfg_chg_trigger);
>>>> +		matrix_mdev->cfg_chg_trigger = NULL;
>>>> +	} else if (fd >= 0) {
>>>> +		cfg_chg_trigger = eventfd_ctx_fdget(fd);
>>>> +		if (IS_ERR(cfg_chg_trigger))
>>>> +			return PTR_ERR(cfg_chg_trigger);
>>>> +
>>>> +		if (matrix_mdev->cfg_chg_trigger)
>>>> +			eventfd_ctx_put(matrix_mdev->cfg_chg_trigger);
>>>> +
>>>> +		matrix_mdev->cfg_chg_trigger = cfg_chg_trigger;
>>>> +	} else {
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>> How does this guard against a use after free, such as the eventfd being
>>> disabled or swapped concurrent to a config change?  Thanks,
>>>
>>> Alex
>> Hi Alex. I spent a great deal of time today trying to figure out exactly
>> what
>> you are asking here; reading about eventfd and digging through code.
>> I looked at other places where eventfd is used to set up communication
>> of events targetting a vfio device from KVM to userspace (e.g.,
>> hw/vfio/ccw.c)
>> and do not find anything much different than what is done here. In fact,
>> this code looks identical to the code that sets up an eventfd for the
>> VFIO_AP_REQ_IRQ_INDEX.
>>
>> Maybe you can explain how an eventfd is disabled or swapped, or maybe
>> explain how we can guard against its use after free. Thanks.
> Maybe I will try! The value of matrix_mdev->cfg_chg_trigger is used in:
> * vfio_ap_set_cfg_change_irq() (rw, with matrix_dev->mdevs_lock)
> * signal_guest_ap_cfg_changed()(r, takes no locks itself, )
>    * called by vfio_ap_mdev_update_guest_apcb()
>      * called at a bunch of places but AFAICT always with
>        matrix_dev->mdevs_lock held
>    * called by vfio_ap_mdev_unset_kvm() (with matrix_dev->mdevs_lock held
>      via get_update_locks_for_kvm())
> * vfio_ap_mdev_probe() (w, assigns NULL to it)
>
> If vfio_ap_set_cfg_change_irq() could change/destroy
> matrix_mdev->cfg_chg_trigger while another thread of execution
> is using it e.g. with signal_guest_ap_cfg_changed() that would be a
> possible UAF and thus BAD.
>
> Now AFAICT matrix_mdev->cfg_chg_trigger is protected by
> matrix_dev->mdevs_lock on each access except for in vfio_ap_mdev_probe()
> which is AFAIK just an initialization in a safe state where we are
> guaranteed to have exclusive access.
>
> The eventfd is swapped and disabled in vfio_ap_set_cfg_change_irq() with
> userspace supplying a new valid fd or -1 respectively.
>
> Tony does that answer your question to Alex?
>
> Alex, does the above answer your question on what guards against UAF (the
> short answer is: matrix_dev->mdevs_lock)?

I agree that the matrix_dev->mdevs_lock does prevent changes to
matrix_mdev->cfg_chg_trigger while it is being accessed by the
vfio_ap device driver. My confusion arises from my interpretation of
Alex's question; it seemed to me that he was talking its use outside
of the vfio_ap driver and how to guard against that.

>
> Regards,
> Halil
>
>
>


