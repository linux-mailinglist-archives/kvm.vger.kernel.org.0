Return-Path: <kvm+bounces-62225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D224C3C916
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:49:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C4D5626394
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:40:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A96234DB5E;
	Thu,  6 Nov 2025 16:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cggS6yMr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D6B287518;
	Thu,  6 Nov 2025 16:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762447089; cv=none; b=jx8I8yG1SA+S4kjVBcvbVdCiVerwM0OOynWNdW+io0BPiT61O9Oytr0orILNY67G10B4B4GZWY88YFRIL6PgY9XycTqDeTaqDcxkeff16sxen6SEQ2s0wLWoMmGEgaJ0q7MnXzWrvJRB29V3Ey/v+rmoGevGwP8xKBmPId7OiSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762447089; c=relaxed/simple;
	bh=CYIeQD9b+y6VN8RgJNGj9LBi97jbwyv1eQ0qXrEMlOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qAu/9ndSh9E6zKLdIIcnxeh/UTCQhpVyHFbEQJmx0B+ndiOHfdQOjzBAu3IzHJaBY6LqosrDvxb3k2P35bHEd7QRpzO3zAJMNRdCJzOGESQSyEniqKpwU7tT8sBl1WdpokVqvhHtsa35eXw6aX3U/1WLo7w+p/KIcyvfwLHphNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com; spf=pass smtp.mailfrom=de.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cggS6yMr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=de.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A66bKov028252;
	Thu, 6 Nov 2025 16:38:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=aU1pQI
	WYInYxmXTeOholEs4c9kD1dhRu52+eRPTQThA=; b=cggS6yMrztjhEWNqWCzhPS
	YJnsXzdiws1TBdUgkn71FyVDiTYzmNv2EpmMFqKA1VAJ0ZadAnIZ/Rpyf5506p8t
	qLtGSNrzm0CO+ozx+XZS3sDrpeyd7/fnOIn12XZ4IBx1BD0dPQyz9D3QrAbN/QlW
	ijrWAJpXIzoB4og9zHDBgLH0n7Khd1XIzsqAZBqawNRl/begn5HSZG41LLtE5XGU
	vheUMcbacGkCo9Ebvmn9Ps9L5bXpPa4LW9Bzyc9m6rwmka00CKidtV9cRCfUYuHK
	ZgFGSw58fyTABtA8zDX4JMd8bizGJ5vobLS7iTqJPuWDXwieoILFGhooRpVnMh3w
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59q98bun-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:38:03 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6FHqDv018784;
	Thu, 6 Nov 2025 16:38:02 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a5whnpf21-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:38:02 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A6Gbw6G57082284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Nov 2025 16:37:58 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B78B52004B;
	Thu,  6 Nov 2025 16:37:58 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F75220040;
	Thu,  6 Nov 2025 16:37:58 +0000 (GMT)
Received: from [9.155.199.94] (unknown [9.155.199.94])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Nov 2025 16:37:58 +0000 (GMT)
Message-ID: <95a76871-771a-4fac-9771-c9e1f4a888ea@de.ibm.com>
Date: Thu, 6 Nov 2025 17:37:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 21/23] KVM: s390: Enable 1M pages for gmap
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, david@redhat.com, gerald.schaefer@linux.ibm.com
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
 <20251106161117.350395-22-imbrenda@linux.ibm.com>
 <5dd6e694-8cf9-4b1c-ae83-088b6bd22a17@de.ibm.com>
 <20251106173650.31907261@p-imbrenda>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20251106173650.31907261@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=StmdKfO0 c=1 sm=1 tr=0 ts=690cceeb cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=5sJ8VKY1vcdsYsRJmOUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Dxoqecpu3TmIX9REChJRyfO3QtVplp-3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAxOCBTYWx0ZWRfX3LmNWjF9h0IQ
 EGv+27rIKyfOfjobr7eDaySxCX8Vicm6hHee4KW+Ke9HukAqpi+/rOJpJVrLmOmaEALiVBxi6BF
 mJ/82fD072gWkhQ9rfxEb/7HU5ui7lgEsPxzpVYjGyvGktLG7HiPYB1lIC9FjXoIIEVv4KiHwEP
 wdN6Hjt7J7jLIQ0QS8cMYmd/8toGfvcrddeQiiavtx02fjdNT49FTCdnO+PmLp40GyZmHZN+rkM
 J/f/8SqADtWPn1QsOUwMcXJ0X6l+eDoYYONC0jBUHHzVtu1Su4IbW3UIjLuI8P4+d9P3I1JYoGA
 bAnUIvlpa6A1CNbekzNcPN0ZapiXcFd5iAZxHOArQNEVqgXO7kuXubrsRDxFyceJYg/Sq7+YHWO
 TwvmxLya2R3NPTVhjDz2uJ5rlbwRRg==
X-Proofpoint-GUID: Dxoqecpu3TmIX9REChJRyfO3QtVplp-3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 adultscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010018



Am 06.11.25 um 17:36 schrieb Claudio Imbrenda:
> On Thu, 6 Nov 2025 17:22:33 +0100
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> Am 06.11.25 um 17:11 schrieb Claudio Imbrenda:
>>> While userspace is allowed to have pages of any size, the new gmap
>>> would always use 4k pages to back the guest.
>>>
>>> Enable 1M pages for gmap.
>>>
>>> This allows 1M pages to be used to back a guest when userspace is using
>>> 1M pages for the corresponding addresses (e.g. THP or hugetlbfs).
>>>
>>> Remove the limitation that disallowed having nested guests and
>>> hugepages at the same time.
>>
>> Nice. This might allow us to enable hpage=1 as new default as soon as
>> things stabilize.
>>
>> We would also be able to use 2GB huge pages for the qemu mapping?
> 
> yes, but I don't think that userspace can have 2G THPs right now

Not THP, but hugetlbfs.


