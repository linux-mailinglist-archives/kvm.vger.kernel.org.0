Return-Path: <kvm+bounces-68514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2562BD3AD23
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 15:54:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E406830BD803
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 14:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67A6B37F8AF;
	Mon, 19 Jan 2026 14:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ayLMJGLx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EC0241663;
	Mon, 19 Jan 2026 14:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768834163; cv=none; b=BvXFuDNHTp+bxiILHdJkELd5VTqhnGStSZbdImvqIKcGv+5itCKUXFE2omk5uC6CcO0m9ihUsBLCb6YYMJdLVUfaS0lzM+89GrX7gZKmWvoD+bUApgC+eL0b5DJerXtL4qb9Z1hfGVcCtFZg5iaUnxOFMVlHvKSpifY/P4TwKD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768834163; c=relaxed/simple;
	bh=jFRABCzaZs0BsGTURW1O2hBVNMsGvbzNr7gfQ7Z78F4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MtrETeagYrRmo6BAOr5RtJ9lRqZ690+JYKRmkxP+RiiLf5FNd3wesdQdIWEgo0gt6Y3b95SeKoS2f8TPklEoQICUHNVxg6q5xQs1uIjvhKWqHHgF1T9ywZW4Cxpk5t8QoZTAgL2sDHUWZbAigYDaes1dKgG+oFwXdWVc6r1Zwrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ayLMJGLx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60J3LS0Y018050;
	Mon, 19 Jan 2026 14:49:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Gc9N4V
	OMewHBI3g/rDtxlmqqpO34HMKF2GL31lWdq+c=; b=ayLMJGLxSEvWsTT3DyMM+I
	c7mK9g+rG/4wp4PPb6HTW/L6J2wUWBbQwI9azFnPNJxxENncWf29/Sf5KVOv65LG
	POC89leC+2ASHpp7o793W+AV6wf/mOJNdqPBCfpSygIlhGiihgsIfBKYIfgN1XPR
	SLcHwnyEl4lq7acyHPZ1Y7hKB/W3K4ZC362Uyq92bkG6o8Ha1nXRo5l5W9Ja5YF4
	Na0AEimVzaxCe2bfhCFadrEYTw9vyaEv+ifygl29zm7V9xiEWOiliF+cYckGo306
	pjc675ZC2Flhus8RZvl5LTZkS3c2BEOSYOY+SehANQ/nKeTA9zf+VzRlOOpDfU3g
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4br0uf89et-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 Jan 2026 14:49:18 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60JECJjX009377;
	Mon, 19 Jan 2026 14:49:17 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4brp8jy76p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 Jan 2026 14:49:17 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60JEnDNc59441546
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 14:49:13 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 47FCF20040;
	Mon, 19 Jan 2026 14:49:13 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D2F8B20043;
	Mon, 19 Jan 2026 14:49:12 +0000 (GMT)
Received: from [9.111.60.229] (unknown [9.111.60.229])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 19 Jan 2026 14:49:12 +0000 (GMT)
Message-ID: <c3ef38be-602e-40ce-a451-92088c67d88f@linux.ibm.com>
Date: Mon, 19 Jan 2026 15:49:12 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: vsie: retry SIE when unable to get vsie_page
To: Eric Farman <farman@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20251217030107.1729776-1-farman@linux.ibm.com>
 <8334988f-2caa-4361-b0b9-50b9f41f6d8a@linux.ibm.com>
 <f34d767b2a56fb26526566e43fa355235ee53932.camel@linux.ibm.com>
 <20260114105033.23d3c699@p-imbrenda>
 <23154a0c6b4b9e625daa2b1bbaadc349bf3a99ed.camel@linux.ibm.com>
 <3d997b2645c80396c0f7c69f95fd8ec0d4784b20.camel@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <3d997b2645c80396c0f7c69f95fd8ec0d4784b20.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yqRIESMXp1-Cak4pa1Dw4iSeCA9Oamdy
X-Proofpoint-ORIG-GUID: yqRIESMXp1-Cak4pa1Dw4iSeCA9Oamdy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE5MDEyNCBTYWx0ZWRfX1iDSQgpy61GW
 ISw7DthlhdcSy70Rd8M5ZTO4dA0ZZfSW+yUh+hwE3eFEcgOajhZJmxmTsVv1w5CrtZrPtmuYM8Z
 d6DKr/A6TXnCYj5QjFgaJyRbLv63Igjkx8fKzFIa8a3tyV6/xG+Ipp/eMNv7Ho5qvCFxOr4t1kB
 qboRUBmTV3utp/6LzQV3AhWW/ffVi7mkHMNp1fEVSDJa6LvKvO8nqO7Shc6pdzwCTnJpk/Yaued
 kFfZkPU4wnWeEzdHW2pHvBKdUA/0LvYKRTd2072nHcOd8pA7x+s8A23uxE90iOp4MO9xpSFDjcw
 RJ7/qqmXU3DChNA1eb0RTVdPw6Fhz6ZBxfhXw+JyMU9cUxibUL3qEJXz2UsO2lhwB7/EFlHHUUA
 IanhKUqNqBbhQHqVuLlyd0ihDczS77zL0EqWOBCTSs8CnVrq0N7vWfqVha84YLt0w3e8E1FC3qT
 cepE69cZUg2IKsQShrA==
X-Authority-Analysis: v=2.4 cv=bopBxUai c=1 sm=1 tr=0 ts=696e446e cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=3F0M1WNf6RbkfYYVzbkA:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-19_03,2026-01-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 impostorscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601190124

On 1/16/26 16:45, Eric Farman wrote:
> On Thu, 2026-01-15 at 16:17 -0500, Eric Farman wrote:
>> On Wed, 2026-01-14 at 10:50 +0100, Claudio Imbrenda wrote:
>>> On Mon, 05 Jan 2026 10:46:53 -0500
>>> Eric Farman <farman@linux.ibm.com> wrote:
>>>
>>>> On Mon, 2026-01-05 at 13:41 +0100, Janosch Frank wrote:
>>>>> On 12/17/25 04:01, Eric Farman wrote:
>>>>>> SIE may exit because of pending host work, such as handling an interrupt,
>>>>>> in which case VSIE rewinds the guest PSW such that it is transparently
>>>>>> resumed (see Fixes tag). There is still one scenario where those conditions
>>>
>>> can you add a few words to (very briefly) explain what the scenario is?
>>
>> Maybe if this paragraph were rewritten this way, instead?
>>
>> --8<--
>> SIE may exit because of pending host work, such as handling an interrupt,
>> in which case VSIE rewinds the guest PSW such that it is transparently
>> resumed (see Fixes tag). Unlike those other places that return rc=0, this
>> return leaves the guest PSW in place, requiring the guest to handle an
>> intercept that was meant to be serviced by the host. This showed up when
>> testing heavy I/O workloads, when multiple vcpus attempted to dispatch the
>> same SIE block and incurred failures inserting them into the radix tree.
>> -->8--
> 
> Spoke to Claudio offline, and he suggested the following edit to the above:
> 
> --8<--
> SIE may exit because of pending host work, such as handling an interrupt,
> in which case VSIE rewinds the guest PSW such that it is transparently
> resumed (see Fixes tag). Unlike those other places that return rc=0, this
> return leaves the guest PSW in place, requiring the guest to handle a
> spurious intercept. This showed up when testing heavy I/O workloads,
> when multiple vcpus attempted to dispatch the same SIE block and incurred
> failures inserting them into the radix tree.
> -->8--
> 
>>
>> @Janosch, if that ends up being okay, can you update the patch or do you want me to send a v2?

I can fix that up.

