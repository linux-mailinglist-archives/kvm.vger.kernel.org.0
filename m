Return-Path: <kvm+bounces-46508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62A38AB6E8D
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 16:53:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 301073B2DED
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 14:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10B1A1B0F2C;
	Wed, 14 May 2025 14:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EZyIATW7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2856186E20;
	Wed, 14 May 2025 14:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747234361; cv=none; b=N6HZdMBVEdYXxHW/3D0+8sX6UqDkX6/4cpWPoAT+2uYvmRg29T9j7nEy7HasdCDB9uQV1Tb08eyWI+IIxD6TvPhfMq7McnsL20Aj3fFXLOvPsAm7JkEzQ80L7x6qkX/PMvT9pXWRrFnZm8xLLjAmDovsKBROlaEcAyFQ4R6HGSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747234361; c=relaxed/simple;
	bh=MGry8nGOh38zyKXq66KoqnQD7ODjB3x9wJqWF5lMYzY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B1gV+Ll2Vq2XgiU4Yh0tAO8t5pQzGJY0jJ1XywEZ+Bm+2UPeLxxKeb3ENlATzInv7NzEeakLfksYnPyZdNcfAE6ts1T3T0R+GYW9TPIV5Kjt90ny5lNkozjuVtwufRkAcK0NIsBcJ+mtmp8rPR0kLEWz81ZbRhFjmSDaJGB/cbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EZyIATW7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54E8pOJ5029482;
	Wed, 14 May 2025 14:52:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=sP9HCX
	m3oiUlMsavHEc5ksXvFcineQQa645gWvOSAPI=; b=EZyIATW7w7UAdIdAiRL3SZ
	8qAbqpGt+LYy7JqNRpJHtlMJthhCzFBQ8iZy6q273n+ANx2fgd+hXHIbPG/45Gee
	1492Sm65ZeYfFQAHwf0ikUEYh+M/DEO9LY/7GmtHLH961SDV5B/zHExw6XqXiMZY
	QyY371DkYEBCwMf7I8AGc9c7Wa9iFA5Pq2tkxaZYt4aVw2SUhqqavWi7GSyi9Jnm
	CTSS7zsowlB1tsNUr17g46ZWWYPKQgbGoS6xn4Ttu55lNti9XMTbJEQgzWPavQ1m
	r42YD8gLhNhAb1ltJM5CqmS2lSyi1dL4gxTLEGkQVj+6GUP78XvCu+cbmzQ9yFxA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46mr1ghtf6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 14:52:24 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54EDWk0X019883;
	Wed, 14 May 2025 14:52:23 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46mbfrmsb5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 14:52:23 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54EEqJOq34669212
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 14:52:19 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8659A200CA;
	Wed, 14 May 2025 14:52:19 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B1DDE200A8;
	Wed, 14 May 2025 14:52:18 +0000 (GMT)
Received: from [9.111.70.163] (unknown [9.111.70.163])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 May 2025 14:52:18 +0000 (GMT)
Message-ID: <6f8f3780-902b-49d4-a766-ea2e1a8f85ea@linux.ibm.com>
Date: Wed, 14 May 2025 16:52:18 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [akpm-mm:mm-new 320/331] arch/s390/kvm/gaccess.c:321:2: error:
 expected identifier
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
        kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Yang Shi <yang@os.amperecomputing.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
References: <202505140943.IgHDa9s7-lkp@intel.com>
 <63ddfc13-6608-4738-a4a2-219066e7a36d@kuka.com>
 <8e506dd6-245f-4987-91de-496c4e351ace@lucifer.local>
 <20250514162722.01c6c247@p-imbrenda>
 <0da0f2fc-c97f-4e95-b28e-fa8e7bede9cb@linux.ibm.com>
 <20250514164822.4b44dc5c@p-imbrenda>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20250514164822.4b44dc5c@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vZQvzaD6N2zKvmDBrayT5pqw2jZzs1K6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDEzMCBTYWx0ZWRfXzLJ5iNsvV+yB 3jA/+o81u1shUiK2qniX3WjvGKQjxeTmfT6V1IiKG1D0MJ/GZphNr94WH0jf4OpcpRU/fh0H/Gl eMyxNVG+UmkD5ejn3hm84rdeKBhRfm4oytj/fLuRpjXfxgROwgedAYRjRB8m8iRkBI9U3OIbvtb
 75Fc110Wq+EKpeg7gaB79Z1KH6aIpTBRVNhHhpuqqNoazYOMiKYIt217Y0oyQ1fUzFTfRbRrm0N qeXNBLZIdlzm+Gl6yCOYYQQltMrHhlfstd2AOFbHIfP84Tz89tet+VKpiI4G1r/GseRPQVpWffW Ah7YcJRivGhmnfripCt9rw/KUEAOgmUeCS4N47lLolgLKGJZ9ER6ZCVybjPCYiG6p0TCrx4n+Z9
 NALJYInoFNKbMJ2kgBy5njkcwDfbrRyoacnuFGK6s6qT2GSbDMtRDl9zXYR3OodaQjXl5+VB
X-Proofpoint-GUID: vZQvzaD6N2zKvmDBrayT5pqw2jZzs1K6
X-Authority-Analysis: v=2.4 cv=QOxoRhLL c=1 sm=1 tr=0 ts=6824ae28 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=zy4cdgbtwusFmoiP-5MA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 clxscore=1015 mlxscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=978
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505140130



Am 14.05.25 um 16:48 schrieb Claudio Imbrenda:

>>>>> A possible fix for this would be to rename PROT_NONE in the enum to PROT_TYPE_NONE.
>>>
>>> please write a patch to rename PROT_NONE in our enum to
>>> PROT_TYPE_DUMMY, I can review it quickly.
>>>
>>> if Paolo has no objections, I'm fine with having the patch go through
>>> the mm tree
>>
>> Yes, lets do a quick fix and I can also do
>> Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>>
>> for a s/PROT_NONE/PROT_TYPE_NONE/g
>> patch.
> 
> I'd rather have PROT_TYPE_DUMMY, since it's a dummy value and not
> something that indicates "no protection"

makes sense.

