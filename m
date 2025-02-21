Return-Path: <kvm+bounces-38859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EF1FEA3F9F5
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 17:03:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49E7716149B
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 15:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25E1D212D71;
	Fri, 21 Feb 2025 15:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GCjikiFl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02C31EEA32;
	Fri, 21 Feb 2025 15:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740153363; cv=none; b=jQyw62tH9IEPMk8eKptHjdZcB5q2hp/JpXNlqODotJKMO9S9nr17dXAH6Jg30UaChdBs00Jzk2mqGLr4O8BCrOkkfxiNOS9Uy9hVnLRQQgmebmhPq9uSKrb1rDBdloOU2lw43Ih9rLRSbVgt4lSedfX25xaeYjD0bcO+eSklceM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740153363; c=relaxed/simple;
	bh=c3guHAxmKN+Oe6JsIfaBRYhvDWRoheJERAhF1oMGrNU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=imeCd/P0DYqgYxzIM1r5K4QHe/e0y5YtTDU4sOxFEk2iPT+e1Ut9/rC/tg5FwlTYL6jnyDkpv8tTYzLnodR1H1xbBiZw1XbifnsqotzUQSPUGTIMnycDSKg610WK+FRBbNg4WEWV8DHvzhix7pLu4Xn6Hg2Srgfjm5EfhOQLO/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GCjikiFl; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51LAj9Lw032246;
	Fri, 21 Feb 2025 15:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0aF1oI
	X1pTS5Q+jvcBTTS6kBqS6814vwS2mlFDg3Z+8=; b=GCjikiFlbXf5c8Ww4dFge3
	sxVrz9PIkmvmYMRIw20tAwWZt/J5IMBOWF/vf7Fw05zAbs95+U44pEu+A8vKxa4d
	fCl5u+UTbQUaafchzX9DBQ5wVZ78gRskm4QhQVlem3vXQVSMQuT0gw1QQ71eefXG
	/T8en4tRKUyDMgLXpejtlh1+VJNSJ17UrTgapdgt6rmSbhqRuGCKquFZEEr5lY6J
	ISVdrlxxYurrLAxubYSBhSrd+AkBIUSlRQXxQPy31dL7puccT0JUE4rTyNlvEIeO
	qd3VgOy1cx2F4Z92xpeOnlrLa5xCbLIAh2kHM/q2gKExZ59Qfbt/HDhWSpQd0fDw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44xdhavdjn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Feb 2025 15:55:56 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51LF1DeX009702;
	Fri, 21 Feb 2025 15:55:55 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44w03ygtgn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Feb 2025 15:55:55 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51LFtrKv53084486
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Feb 2025 15:55:53 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 564765805A;
	Fri, 21 Feb 2025 15:55:53 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF6BE58054;
	Fri, 21 Feb 2025 15:55:51 +0000 (GMT)
Received: from [9.61.107.75] (unknown [9.61.107.75])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 21 Feb 2025 15:55:51 +0000 (GMT)
Message-ID: <a5fed2fd-5265-4b0a-a323-6b2ea602e2ba@linux.ibm.com>
Date: Fri, 21 Feb 2025 10:55:51 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] s390/vio-ap: Fix no AP queue sharing allowed message
 written to kernel log
To: Heiko Carstens <hca@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, agordeev@linux.ibm.com, gor@linux.ibm.com
References: <20250220000742.2930832-1-akrowiak@linux.ibm.com>
 <20250221095719.11661Ba2-hca@linux.ibm.com>
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20250221095719.11661Ba2-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wZxbqJZB6reubS_ekVGXlNu4M28AjeSU
X-Proofpoint-ORIG-GUID: wZxbqJZB6reubS_ekVGXlNu4M28AjeSU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-21_05,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502210111




On 2/21/25 4:57 AM, Heiko Carstens wrote:
> On Wed, Feb 19, 2025 at 07:07:38PM -0500, Anthony Krowiak wrote:
>> -#define MDEV_SHARING_ERR "Userspace may not re-assign queue %02lx.%04lx " \
>> -			 "already assigned to %s"
>> +#define MDEV_SHARING_ERR "Userspace may not assign queue %02lx.%04lx " \
>> +			 "to mdev: already assigned to %s"
> Please do not split error messages across several lines, so it is easy
> to grep such for messages. If this would have been used for printk
> directly checkpatch would have emitted a message.

fixed

>
>> +#define MDEV_IN_USE_ERR "Can not reserve queue %02lx.%04lx for host driver: " \
>> +			"in use by mdev"
> Same here.

fixed

>
>>   	for_each_set_bit_inv(apid, apm, AP_DEVICES)
>>   		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS)
>> -			dev_warn(dev, MDEV_SHARING_ERR, apid, apqi, mdev_name);
>> +			dev_warn(mdev_dev(assignee->mdev), MDEV_SHARING_ERR,
>> +				 apid, apqi, dev_name(mdev_dev(assigned_to->mdev)));
> Braces are missing. Even it the above is not a bug: bodies of for
> statements must be enclosed with braces if they have more than one
> line:

fixed

>
>    	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
>    		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
> 			dev_warn(mdev_dev(assignee->mdev), MDEV_SHARING_ERR,
> 				 apid, apqi, dev_name(mdev_dev(assigned_to->mdev))
> 		}
> 	}
>
>> +static void vfio_ap_mdev_log_in_use_err(struct ap_matrix_mdev *assignee,
>> +					unsigned long *apm, unsigned long *aqm)
>> +{
>> +	unsigned long apid, apqi;
>> +
>> +	for_each_set_bit_inv(apid, apm, AP_DEVICES)
>> +		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS)
>> +			dev_warn(mdev_dev(assignee->mdev), MDEV_IN_USE_ERR,
>> +				 apid, apqi);
>> +}
> Same here.

fixed

>
>> +
>> +/**assigned
>>    * vfio_ap_mdev_verify_no_sharing - verify APQNs are not shared by matrix mdevs
> Stray "assigned" - as a result this is not kernel doc anymore.

fixed

>
>> + * @assignee the matrix mdev to which @mdev_apm and @mdev_aqm are being
>> + *           assigned; or, NULL if this function was called by the AP bus driver
>> + *           in_use callback to verify none of the APQNs being reserved for the
>> + *           host device driver are in use by a vfio_ap mediated device
>>    * @mdev_apm: mask indicating the APIDs of the APQNs to be verified
>>    * @mdev_aqm: mask indicating the APQIs of the APQNs to be verified
> Missing ":" behind @assignee. Please keep this consistent.

fixed

>
>> @@ -912,17 +930,21 @@ static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
>>   
>>   		/*
>>   		 * We work on full longs, as we can only exclude the leftover
>> -		 * bits in non-inverse order. The leftover is all zeros.
>> +		 * bits in non-inverse order. The leftover is all zeros.assigned
>>   		 */
> Another random "assigned" word.

My IDE sometimes randomly pastes things in the clipboard.
fixed

>
>> +		if (assignee)
>> +			vfio_ap_mdev_log_sharing_err(assignee, assigned_to,
>> +						     apm, aqm);
>> +		else
>> +			vfio_ap_mdev_log_in_use_err(assigned_to, apm, aqm);
> if body with multiple lines -> braces. Or better make that
> vfio_ap_mdev_log_sharing_err() call a long line. If you want to keep
> the line-break add braces to both the if and else branch.

fixed



