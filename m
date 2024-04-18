Return-Path: <kvm+bounces-15086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 35F948A9AE5
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 15:10:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E10BE1F21D0F
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 13:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393BB15FD19;
	Thu, 18 Apr 2024 13:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GStT0MXM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17440145337;
	Thu, 18 Apr 2024 13:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713445776; cv=none; b=MZO4gUdzaNju7YKoBPkizDMrTEIpFe7OAl714NNjtB2h4lolKe8ivcDGwj/6UCxooVv4zpQIrZ9MlC53XLlN/tXFwjw0lXGCObRILGPi3iWmw6SxgtAJe+sTWT6+JKJQFAGPpKPJho5O+Qiy6850FTGHaHudaqYh1uJzkL+eyKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713445776; c=relaxed/simple;
	bh=Z8LqLKETTuqPbNx9AIZuOgf3LNGzlBMZYBlVi5bQc3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rnDtckvEwxWz9Et4vskt67uJGDbZ7mgaS51UmbTwIstPRn3h9ei9S32ufvpOxnezeITCzP2cIkQjbPBWy+W24YMo1AbYU23lP/LJLrFqEm1yQfBL3gyVI1aY1JGodfeQJPdsNlcUpdG/ivC/WP3D8d/qoKq/CsRz5kuUQuHThSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GStT0MXM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43ID8jU3007642;
	Thu, 18 Apr 2024 13:09:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RaI5RA/Q5QPRrrhoR9duIhNVwqkwcc6C9qMHRKNHl+Q=;
 b=GStT0MXMLM/fZ9pe8YXt69mb+WpGa4ehYFCflmtI1TebfTGuMbPUuO7bFFnEttDSGBpW
 wVjQT2tYVG8bdJ5Dp0s8vaUIjKR3RCxcLs48OrDl9BDsHP8mgIt4bC3h/HXWy87Ur1ea
 OG9YwjXWDQgRJ3xAyBqYuela6as1U9OG3ItFOtMY6xuJO3ksmt8+q6QcY4JBOUX8EU6t
 aTY6SuWGr6L6Sa3qMYJOWu+A/ACjxwgvja03h9WYrHbiyap/VyGC7jtnVQ3bkhm2zmeo
 liJWDwa2pRwk/Mgrered6Ws1P8sjCBP9Z2EJssVeAecdv7ag1WdPqSTLHHeM5tyWcBQQ 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xk44rr044-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Apr 2024 13:09:28 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43ID9SkW008360;
	Thu, 18 Apr 2024 13:09:28 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xk44rr041-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Apr 2024 13:09:28 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43IB566T027289;
	Thu, 18 Apr 2024 13:09:27 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xg4s0aw1y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Apr 2024 13:09:27 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43ID9LH348693672
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Apr 2024 13:09:23 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8FB9520043;
	Thu, 18 Apr 2024 13:09:21 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 591E320040;
	Thu, 18 Apr 2024 13:09:21 +0000 (GMT)
Received: from [9.152.224.222] (unknown [9.152.224.222])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Apr 2024 13:09:21 +0000 (GMT)
Message-ID: <453afb13-c7e3-4156-9dbb-c6317503c715@linux.ibm.com>
Date: Thu, 18 Apr 2024 15:09:20 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] s390/mm: re-enable the shared zeropage for !PV and
 !skeys KVM guests
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Sven Schnelle <svens@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20240411161441.910170-1-david@redhat.com>
 <20240411161441.910170-3-david@redhat.com>
 <Zh1w1QTNSy+rrCH7@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <8533cb18-42ff-42bc-b9e5-b0537aa51b21@redhat.com>
 <Zh4cqZkuPR9V1t1o@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <20d1d8c5-70e9-4b00-965b-918f275cfae7@linux.ibm.com>
 <a6a4b284-e21b-4a04-88d1-7402eb5a08ef@redhat.com>
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <a6a4b284-e21b-4a04-88d1-7402eb5a08ef@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: U_NintKTDQIUuOR8ZvOzcdWvOEEHjrHp
X-Proofpoint-ORIG-GUID: T0JHOIK5lgqLYJh6QQs6jAcpUgEmZbJt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-18_11,2024-04-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=782
 priorityscore=1501 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404180093



Am 16.04.24 um 15:41 schrieb David Hildenbrand:
> On 16.04.24 14:02, Christian Borntraeger wrote:
>>
>>
>> Am 16.04.24 um 08:37 schrieb Alexander Gordeev:
>>
>>>> We could piggy-back on vm_fault_to_errno(). We could use
>>>> vm_fault_to_errno(rc, FOLL_HWPOISON), and only continue (retry) if the rc is 0 or
>>>> -EFAULT, otherwise fail with the returned error.
>>>>
>>>> But I'd do that as a follow up, and also use it in break_ksm() in the same fashion.
>>>
>>> @Christian, do you agree with this suggestion?
>>
>> I would need to look into that more closely to give a proper answer. In general I am ok
>> with this but I prefer to have more eyes on that.
>>   From what I can tell we should cover all the normal cases with our CI as soon as it hits
>> next. But maybe we should try to create/change a selftest to trigger these error cases?
> 
> If we find a shared zeropage we expect the next unsharing fault to succeed except:
> 
> (1) OOM, in which case we translate to -ENOMEM.
> 
> (2) Some obscure race with MADV_DONTNEED paired with concurrent truncate(), in which case we get an error, but if we look again, we will find the shared zeropage no longer mapped. (this is what break_ksm() describes)
> 
> (3) MCE while copying the page, which doesn't quite apply here.
> 
> For the time being, we only get shared zeropages in (a) anon mappings (b) MAP_PRIVATE shmem mappings via UFFDIO_ZEROPAGE. So (2) is hard or even impossible to trigger. (1) is hard to test as well, and (3) ...
> 
> No easy way to extend selftests that I can see.

Yes, lets just go forward.
> 
> If we repeatedly find a shared zeropage in a COW mapping and get an error from the unsharing fault, something else would be deeply flawed. So I'm not really worried about that, but I agree that having a more centralized check will make sense.

