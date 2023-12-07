Return-Path: <kvm+bounces-3871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F0A7808BDC
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 16:31:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE69E1F211C5
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 15:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 246594594E;
	Thu,  7 Dec 2023 15:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ge2qPERJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D806C10E3;
	Thu,  7 Dec 2023 07:31:24 -0800 (PST)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B7FHPRG022631;
	Thu, 7 Dec 2023 15:31:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HuWvFvcr/mC74jZHPiQaVgBRkwEivXlwrOK4769QA2g=;
 b=Ge2qPERJ5N1H7ECiEQrCz3ppigtIoT2Uy8M5P7mNXoZO0/dttZEQ6DtvJKUoM/1T9vH0
 ih+hjZUYl2OsmbX3OJrP4R7dr0peY0TKmrnYSYHQkTBmZTFF9QGXgphxhJOoGkjrnznp
 5iH/cZwWrFA+FO+0pTodAIR3o1FJ3Z6W34J4lruEUyr7nly1tuEpsZOywV/Bfk2d6XaQ
 bjZHgOfLy7R7qFGBMZlFxQZ8GS+boieV0WPMrsvL93RjPIlTyye7PH6bkmevj7Hskl65
 uersXD2+qJ9c7a/Gd+Jwtq4g301JudpErjGf7BgeL+wru8Jpwf/rEBbJ1enONyOaAbhr bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uud24fs1r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Dec 2023 15:31:22 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B7FI1XM027872;
	Thu, 7 Dec 2023 15:31:22 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uud24fs10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Dec 2023 15:31:21 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B7EMebO013743;
	Thu, 7 Dec 2023 15:31:21 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3utau4by09-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Dec 2023 15:31:21 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B7FVIqI18809512
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Dec 2023 15:31:18 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7BEC65804B;
	Thu,  7 Dec 2023 15:31:18 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 04BDC58059;
	Thu,  7 Dec 2023 15:31:10 +0000 (GMT)
Received: from [9.61.158.74] (unknown [9.61.158.74])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 Dec 2023 15:31:09 +0000 (GMT)
Message-ID: <483f23b2-0c88-49e2-8b40-7b17cd2b46cc@linux.ibm.com>
Date: Thu, 7 Dec 2023 10:31:06 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] s390/vfio-ap: handle response code 01 on queue reset
Content-Language: en-US
To: Halil Pasic <pasic@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        david@redhat.com, Reinhard Buendgen <BUENDGEN@de.ibm.com>
References: <20231129143529.260264-1-akrowiak@linux.ibm.com>
 <b43414ef-7aa4-9e5c-a706-41861f0d346c@linux.ibm.com>
 <1f4720d7-93f1-4e38-a3ad-abaf99596e7c@linux.ibm.com>
 <05cfc382-d01d-4370-b8bb-d3805e957f2e@linux.ibm.com>
 <20231204171506.42aa687f.pasic@linux.ibm.com>
 <d780a15a7c073e7d437f8120a72e8d29@linux.ibm.com>
 <20231206181727.376c3d67.pasic@linux.ibm.com>
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20231206181727.376c3d67.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4oqZgj2SjW_75L3EIb6kXMmDRx2r6Pmz
X-Proofpoint-ORIG-GUID: JPsT5elpzc5Bh6d_VWDloAtXMc3U1eRX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-07_12,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312070127


On 12/6/23 12:17 PM, Halil Pasic wrote:
> On Tue, 05 Dec 2023 09:04:23 +0100
> Harald Freudenberger <freude@linux.ibm.com> wrote:
>
>> On 2023-12-04 17:15, Halil Pasic wrote:
>>> On Mon, 4 Dec 2023 16:16:31 +0100
>>> Christian Borntraeger <borntraeger@linux.ibm.com> wrote:
>>>    
>>>> Am 04.12.23 um 15:53 schrieb Tony Krowiak:
>>>>>
>>>>> On 11/29/23 12:12, Christian Borntraeger wrote:
>>>>>> Am 29.11.23 um 15:35 schrieb Tony Krowiak:
>>>>>>> In the current implementation, response code 01 (AP queue number not valid)
>>>>>>> is handled as a default case along with other response codes returned from
>>>>>>> a queue reset operation that are not handled specifically. Barring a bug,
>>>>>>> response code 01 will occur only when a queue has been externally removed
>>>>>>> from the host's AP configuration; nn this case, the queue must
>>>>>>> be reset by the machine in order to avoid leaking crypto data if/when the
>>>>>>> queue is returned to the host's configuration. The response code 01 case
>>>>>>> will be handled specifically by logging a WARN message followed by cleaning
>>>>>>> up the IRQ resources.
>>>>>>>   
>>>>>> To me it looks like this can be triggered by the LPAR admin, correct? So it
>>>>>> is not desireable but possible.
>>>>>> In that case I prefer to not use WARN, maybe use dev_warn or dev_err instead.
>>>>>> WARN can be a disruptive event if panic_on_warn is set.
>>>>> Yes, it can be triggered by the LPAR admin. I can't use dev_warn here because we don't have a reference to any device, but I can use pr_warn if that suffices.
>>>> Ok, please use pr_warn then.
>>> Shouldn't we rather make this an 'info'. I mean we probably do not want
>>> people complaining about this condition. Yes it should be a besNo info logging is done via the S390 Debug Feature in vfio_ap.
>>>        There are a few warning messages logged solely in the handle_pqap
>>>        and vfio_ap_irq_enable functions. The question is, why are we
>>>        talking about the S390 Debug Feature? We are talking about using
>>>        pr_warn verses pr_info. What am I missing here?t
>>> practice
>>> to coordinate such things with the guest, and ideally remove the
>>> resource
>>> from the guest first. But AFAIU our stack is supposed to be able to
>>> handle something like this. IMHO issuing a warning is excessive
>>> measure.
>>> I know Reinhard and Tony probably disagree with the last sentence
>>> though.
>> Halil, Tony, the thing about about info versus warning versus error is
>> our
>> own stuff. Keep in mind that these messages end up in the "debug
>> feature"
>> as FFDC data. So it comes to the point which FFDC data do you/Tony want
>> to
>> see there ? It should be enough to explain to a customer what happened
>> without the need to "recreate with higher debug level" if something
>> serious
>> happened. So my private decision table is:
>> 1) is it something serious, something exceptional, something which may
>> not
>>      come up again if tried to recreate ? Yes -> make it visible on the
>> first
>>      occurrence as error msg.
>> 2) is it something you want to read when a customer hits it and you tell
>> him
>>      to extract and examine the debug feature data ? Yes -> make it a
>> warning
>>      and make sure your debug feature by default records warnings.
>> 3) still serious, but may flood the debug feature. Good enough and high
>>      probability to reappear on a recreate ? Yes -> make it an info
>> message
>>      and live with the risk that you may not be able to explain to a
>> customer
>>      what happened without a recreate and higher debug level.
>> 4) not 1-3, -> maybe a debug msg but still think about what happens when
>> a
>>      customer enables "debug feature" with highest level. Does it squeeze
>> out
>>      more important stuff ? Maybe make it dynamic debug with pr_debug()
>> (see
>>      kernel docu admin-guide/dynamic-debug-howto.rst).
> AFAIU the default log level of the S390 Debug Feature is 3 that is
> error. So warnings do not help us there by default. And if we are
> already asking the reporter to crank up the loglevel of the debug
> feature, we can as the reporter to crank it up to 5, assumed there
> is not too much stuff that log level 5 in that area... How much
> info stuff do we have for the 'ap' debug facility (I hope
> that is the facility used by vfio_ap)?


No info logging is done via the S390 Debug Feature in vfio_ap. There are 
a few warning messages logged solely in the handle_pqap and 
vfio_ap_irq_enable functions. The question is, why are we talking about 
the S390 Debug Feature given the discussion is about using pr_warn 
verses pr_info. What am I missing here?


>
> I think log levels are supposed to be primarily about severity, and
> and I'm not sure that a queue becoming unavailable in G1 without
> fist re-configuring the G2 so that it no more has access to the
> given queue is not really a warning severity thing. IMHO if we
> really do want people complaining about this should they ever see it,
> yes it should be a warning. If not then probably not.
>
> Regards,
> Halil

