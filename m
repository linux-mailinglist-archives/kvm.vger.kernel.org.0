Return-Path: <kvm+bounces-57901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA81EB7FF00
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 16:24:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6750542E06
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 434972D9789;
	Wed, 17 Sep 2025 14:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aXBMdqkl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA7E2222D1;
	Wed, 17 Sep 2025 14:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758117954; cv=none; b=EVkw44bPLXsv86JAkREJWfDWZfB+cnuLWkNWdLyyVjWiq+xE238LuHfTr06N8aB0O3d/1WZlJk2Zwl7bElGJN7NPammPDl8lpWqwwLuOwwdYGWy097uKqruQcDQZqas4Sj8qCvEh/G2WJ/c+4N1UaB62nlRWXVec4f5j/Hur5V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758117954; c=relaxed/simple;
	bh=1HIJ8jS+xm0KGroS76vny29pK20Zh/Zz6Ewdr37h3+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I7GeNmCAE1/N0DHhliV3I+zU4D/EP50wssYNvHgdO+Eu7TE19THyQwoCUdGLszeUiR6vsI6Y/ZVo/CCR0HpIOMOHaZw5QS58JWVQ1oBaYyq3buuLtkVXCeqfWurpdv+kYclmh08NQvyAY5VW4Q6wvd+epmAz1SkSv0oSD7qS+o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com; spf=pass smtp.mailfrom=de.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aXBMdqkl; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=de.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58H9PfZl020190;
	Wed, 17 Sep 2025 14:05:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=hZTPLq
	KDsiXxBTMgn2LkBmo4QrLLEGq8y6ezmJnVp/I=; b=aXBMdqklYpC6G8v+UkUTgm
	AtxshK4bTptl98EMNaTHbkwYVjK6dJ4/mtZbtcZpi1AejvKBzQQw63Q3IosvJgI1
	ckkXcf3hiec7HzxT04EF8d+KCPYvFR6CoknFI9UNRooiH25XUAD/pt/6O+1h/MYw
	4necOIEeADiW5gCjIMfGiIAQbRIncs40zb8A6ZzDRu/Fl2MWQY2mGd+bLuJY+Pgc
	seZQupIPLrKMa8CW3n4YO+KlIlwBEgB6amWtOhLe9JFAmrLKCh2l5ZU0s4TOuVK/
	Odcta5jAxV3TCxRLG3EJTusHghMuZ5k7IaZMO5JjZI0d1a5372Va9CIbrSBzDmUA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4m3x4q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 14:05:49 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58HAru6s022278;
	Wed, 17 Sep 2025 14:05:48 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495kxpsky0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 14:05:48 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HE5iSk56295896
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 14:05:45 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D516120043;
	Wed, 17 Sep 2025 14:05:44 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5112A20040;
	Wed, 17 Sep 2025 14:05:44 +0000 (GMT)
Received: from [9.87.139.79] (unknown [9.87.139.79])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Sep 2025 14:05:44 +0000 (GMT)
Message-ID: <f63f9223-f848-4d02-91b5-f3fe85658754@de.ibm.com>
Date: Wed, 17 Sep 2025 16:05:44 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/20] KVM: s390: KVM page table management functions:
 allocation
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-9-imbrenda@linux.ibm.com>
 <20250916162653.27229G04-hca@linux.ibm.com>
 <20250916184737.47224f56@p-imbrenda>
 <63e8c905-28b1-4e1f-be77-e0789bd75692@de.ibm.com>
 <20250916190514.1a3082bd@p-imbrenda>
 <15f451d9-ecb3-4a82-9b9a-2de64b93944d@de.ibm.com>
 <20250916173644.27229Kcc-hca@linux.ibm.com>
 <20250917072733.7515Af5-hca@linux.ibm.com>
 <20250917132556.4814fe98@p-imbrenda>
 <20250917123006.7515C59-hca@linux.ibm.com>
 <20250917151124.1a53b0a6@p-imbrenda>
 <976f2cf6-e56f-4089-923d-29098746018b@de.ibm.com>
 <20250917160002.778b1905@p-imbrenda>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20250917160002.778b1905@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: P5T0Kjjs5pYSld2yuDjMKK9D-dFAKJof
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX2Wv1lGb4bPiy
 gEUm3eUfMdVPARQLKhLfCLoBOVsgYgOVjDLLj0tfMG8F2UkVRJSsYLSlYlafMEVDgOzwqrzjQzg
 nVi0670hWVOHiNxMMJdxzLXIRw37dJSSC7cQAUN6Ul2WgN1sPe+l7jhbesn+Je1CY14SpoR5Twg
 ITkYZysg3iobOrAcU3E9jV5csqQCiaSnU24Qzhz3MZKxs2VQT7btUsh60wFYXB5J2/DjhHGxsij
 hWmBmzn5rMo0WT184mfnEqfy9erMpSmUiBKrvyOZ0AYopnsAvpWkg3kCTo9vRZQtV+kPhiG7ztV
 28wfmlh7FpUCyFtxmm2zItiQ12hJqWJfA729X8WzLGyy23cZK584y6qOlxoZrZ4yMMlrko5CcL5
 G/e3HgH2
X-Proofpoint-ORIG-GUID: P5T0Kjjs5pYSld2yuDjMKK9D-dFAKJof
X-Authority-Analysis: v=2.4 cv=QrNe3Uyd c=1 sm=1 tr=0 ts=68cac03d cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=nzabHkwyfHmwa4cunr8A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204



Am 17.09.25 um 16:00 schrieb Claudio Imbrenda:
> On Wed, 17 Sep 2025 15:26:33 +0200
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> Am 17.09.25 um 15:11 schrieb Claudio Imbrenda:
>>> On Wed, 17 Sep 2025 14:30:06 +0200
>>> Heiko Carstens <hca@linux.ibm.com> wrote:
>>>    
>>>> On Wed, Sep 17, 2025 at 01:25:56PM +0200, Claudio Imbrenda wrote:
>>>>> On Wed, 17 Sep 2025 09:27:33 +0200
>>>>> Heiko Carstens <hca@linux.ibm.com> wrote:
>>>>>       
>>>>>> On Tue, Sep 16, 2025 at 07:36:44PM +0200, Heiko Carstens wrote:
>>>>>>> On Tue, Sep 16, 2025 at 07:06:06PM +0200, Christian Borntraeger wrote:
>>>>>>>>
>>>>>>>> Am 16.09.25 um 19:05 schrieb Claudio Imbrenda:
>>>>>>>>         
>>>>>>>>>>> I think GFP_ATOMIC actually gives more guarantees?
>>>>>>>>>>
>>>>>>>>>> In real life GFP_ATOMIC can fail, GFP_KERNEL does not.All gfp allocation failures
>>>>>>>>>> are usually the atomic ones.
>>>>>>>>>
>>>>>>>>> interesting... then I guess I need GFP_KERNEL | GFP_ATOMIC ?
>>>>>>>>
>>>>>>>> No. ATOMIC always means: can fail.
>>>>>
>>>>> my issue is that GFP_KERNEL can sleep, and this allocation is sometimes
>>>>> called from atomic contexts (e.g. while holding spinlocks)
>>>>>
>>>>> the right way to do this would be with mempools, to allocate memory
>>>>> (and potentially sleep) when we are not in atomic context, and use it
>>>>> whenever needed. this is on my to-do list for the future, but right now
>>>>> I'd like to avoid having to refactor a ton of code.
>>>>
>>>> I doubt this is accetable even for an intermediate solution. As soon
>>>> as the host is under memory pressure and starts doing I/O to free up
>>>> memory, you will end up in -ENOMEM situations for simple guest page
>>>> allocations.
>>>>
>>>> What happens with a guest in such a situation? Is this gracefully
>>>> handled without that the guest is terminated?
>>>
>>> well, we return -ENOMEM to userspace (and qemu will probably kill the
>>> guest)
>>>
>>> but if we can't even allocate 16kB, probably we're already in a pretty
>>> bad situation
>>>
>>> if you think this is not acceptable, I guess I'll have to implement
>>> mempools
>>
>> This is not acceptable. 16k atomic allocations are pretty much guaranteed
>> to fail after a while of high workload.
>> What are the callers of this allocation?
> 
> literally anything that touches the gmap page tables, since we need to
> hold kvm->mmu_lock, which is an rw spinlock

So how is x86 allocating page table memory. I cant see GPF_ATOMIC or mempool over there.

