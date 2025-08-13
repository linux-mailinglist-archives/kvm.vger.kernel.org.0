Return-Path: <kvm+bounces-54612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28844B25552
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 23:28:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB076171E89
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 21:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E56C2FFDDE;
	Wed, 13 Aug 2025 21:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Z5U9Q98+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4831188715;
	Wed, 13 Aug 2025 21:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755120368; cv=none; b=VsUofCcKN8Nh+Zh07Z+IRH59M7+F2c9f85GH2hX3/ppi/vUjD3csCm8pJ68ZRG0gKkVzIL7EBpdN1HzXVh+f+byqi6EBF0QHeRsjQTT1rfVlyUOfKB/i4HhE3bBZwisfgL3EbtNtu27Ej2QJgUjl1g6t2gTcsAxrkwJYThIzwf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755120368; c=relaxed/simple;
	bh=3M/RF2aGHkoup3HiZLfX6Prv5nuggoZBOZrL0M2s5zo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NoXNmyKf/1vNsFDoj88gjhl4fAa1gRCMBTE8BIooeFz9JMlatU8a24wMosj3LG1Ga99DtM1sG5nWiD/QYDiKhIOqPaN2ggQ/KTiBeITbOkmeMfIQi0l7i88G9sef+lAlMJdEqCw2lPtd8tdk8hkha07vJ95uHinIG/0Msf4zmGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Z5U9Q98+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DI6hVu015579;
	Wed, 13 Aug 2025 21:26:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=irPx7z
	Rt+uwD8Prdvyw1kLkzpVu9k7TMDafiojlNDUY=; b=Z5U9Q98+UwWzz0T9HE45lN
	jqZLsl7/KZhco+efLqD3Bg8Wvm51UQOnFhlw4fGmw7rHKdjiXNT/frjYELuyt+QK
	dV0e2eY4xeuK1Gl9AnTWck6cOQjnbhl872caosBkH0MaFL5FJaH7Pfdvi3hE2dOl
	70N5DBLz1hQmFeMYYttewDsxM0WsmEXcrdnwNfHTfXNY0LHF9lKx0V/FhlcBkbB5
	7jEzo3DHaGQE4oJvMF8PUfqKyLeKBSmm2nybsvBFe3sRDK2t25N7mz3iSZkt6wzQ
	65p3eoErSe4q5JNHbSvYF6EhBzkwsL9k8OPFxgLHFVXVumKYtPAKvm9t/uXeOQaA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48gype8ud2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 21:26:04 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57DJxPSh028572;
	Wed, 13 Aug 2025 21:26:03 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48ej5n96st-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 21:26:03 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57DLQ1hw16515752
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 21:26:01 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 617965805A;
	Wed, 13 Aug 2025 21:26:01 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A389958054;
	Wed, 13 Aug 2025 21:26:00 +0000 (GMT)
Received: from [9.61.254.249] (unknown [9.61.254.249])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 21:26:00 +0000 (GMT)
Message-ID: <f18e339f-0eb6-4270-9107-58bb70ef0d08@linux.ibm.com>
Date: Wed, 13 Aug 2025 14:25:59 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 4/6] vfio-pci/zdev: Setup a zpci memory region for
 error information
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, schnelle@linux.ibm.com,
        mjrosato@linux.ibm.com
References: <20250813170821.1115-1-alifm@linux.ibm.com>
 <20250813170821.1115-5-alifm@linux.ibm.com>
 <20250813143028.1eb08bea.alex.williamson@redhat.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <20250813143028.1eb08bea.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=eaU9f6EH c=1 sm=1 tr=0 ts=689d02ec cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=4VSETjsjW--cN9yHaHoA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: P_BUkS1dP5RKXz-0XlCt4FVcvjr8vMly
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEzMDE2NyBTYWx0ZWRfX7VQD4ycnngwe
 WwT8WRV1t5I+0AvJz2Ztv3LCklq5GPV+qo5y0px/lNlnKVnEnMTVC8t7ATR4K256kOVumy0miKk
 G9XPsXXnp1a51cXLtF1IL3+7WzArypgc/oNub4DInY4Nf97TvMPZUjmQE8kh+Ed5f/sUEE2Rj90
 HJqsnOqGjXp8fVY/0r9CT/fjhn5LvnV+mO36KNrTEv+3prBJioJaIuam8XS9x0iUya6nXdoMnSy
 CsyAB5pmsAeoIycAhttCYiGae3R9IghrU4oi1SSjPCZHW3TcpmzxHamcAvfqBPEktzEVg/4STXt
 Vt/55QnfAw+hfS/lGXaBz/Ni5eN3/FdhZuFOYny7neBJKKy9UJwBQcP1TCnMCp5WbTway4FD40B
 wrvDy833
X-Proofpoint-ORIG-GUID: P_BUkS1dP5RKXz-0XlCt4FVcvjr8vMly
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508130167


On 8/13/2025 1:30 PM, Alex Williamson wrote:
> On Wed, 13 Aug 2025 10:08:18 -0700
> Farhan Ali <alifm@linux.ibm.com> wrote:
>> diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
>> index 77f2aff1f27e..bcd06f334a42 100644
>> --- a/include/uapi/linux/vfio_zdev.h
>> +++ b/include/uapi/linux/vfio_zdev.h
>> @@ -82,4 +82,9 @@ struct vfio_device_info_cap_zpci_pfip {
>>   	__u8 pfip[];
>>   };
>>   
>> +struct vfio_device_zpci_err_region {
>> +	__u16 pec;
>> +	int pending_errors;
>> +};
>> +
>>   #endif
> If this is uapi it would hopefully include some description, but if
> this is the extent of what can be read from the device specific region,
> why not just return it via a DEVICE_FEATURE ioctl?  Thanks,
>
> Alex
>
Yes, will add more details about the uapi. My thinking was based on how 
we expose some other vfio device information on s390x, such as SCHIB for 
vfio-ccw device.

I didn't think about the DEVICE_FEATURE ioctl. But looking into it, it 
looks like we would have to define a device feature (for eg: 
VFIO_DEVICE_FEATURE_ZPCI_ERROR), and expose this information via 
GET_FEATURE? If the preference is to use the DEVICE_FEATURE ioctl I can 
try that. Curious, any specific reason you prefer the DEVICE_FEATURE 
ioctl to the memory region?

Thanks
Farhan



