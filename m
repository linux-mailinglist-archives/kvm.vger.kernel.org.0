Return-Path: <kvm+bounces-62219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 724B4C3C7D6
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:38:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AEE984F12E1
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:28:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B1C3491D3;
	Thu,  6 Nov 2025 16:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hkp6Su9e"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0962868A6;
	Thu,  6 Nov 2025 16:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762446163; cv=none; b=d5s37tWhWRae9Ea+rldcDrGurRW+ndKgmlmpmYPL8pcX5soZsawZNYWE97/BF6E6/jH1o0D4g6PexyzEB8AAkB0s25OsPydmOcjAsTHwqFH4ZzyIaxKGpdtCKTJG7Mh0KS1jPNSTassRTYqIfEZlzFPPwy98bxa3TVoHaeAoeC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762446163; c=relaxed/simple;
	bh=BJKZakp+nskiXeblo35WSHDYUgSoi68DkTGPZiwZAlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=agPeO/Nyjm/DoSjAky2rWYRVBUN8Yeie159ue1xXSdIJDkXAsYm5vbzAqOtGya5zaQiGSb3ec3iw1fsnWuBesmZhjEue/2a76qMUFJTtQLkXW7GOpRNnb2Ez0n1tD0LF7bZZkiIUUemvQtQtVlfluoCRm02sL1F1Ypa2qvnyxvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com; spf=pass smtp.mailfrom=de.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hkp6Su9e; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=de.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A68E5no004950;
	Thu, 6 Nov 2025 16:22:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=vHI5Z+
	zCluZbDav1xjH1HzDGNP3X6M67QjQ7jSeh8zo=; b=hkp6Su9eqelqGO9cy7RbuK
	nHHcPv8lrDVhjUHoa/0WmpPumg4E6+skyBaFnLOeA6F0wAnhDsNc3C039bd6tvfO
	NBfb+YAxlIahLAltRjP0RID8LXAEX8wzqx0MBkIenZ3ThKg71I9Otr8iBiOCHfYe
	opJmfUT2V2Gb2DtYy5LVb7yTeoQv3MLgI0YGciyPfXzNVrvdcMSLivHL+40YFP42
	BAKi1IoCE+F476cjLM8M/q1hWbhReD80JE0vCfy5aq3vHLYTKHaV5Kh3FahBDHMB
	J1osCyHziLKFApbnozBZipA/QtS87Az1r5kJegKrouogbu+EEzV8qKkNoOapXUGg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a57mrfdy0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:22:39 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6F8KRe009831;
	Thu, 6 Nov 2025 16:22:38 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a5x1kpasg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:22:38 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A6GMYM339911878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Nov 2025 16:22:34 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 590E920043;
	Thu,  6 Nov 2025 16:22:34 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D626F20040;
	Thu,  6 Nov 2025 16:22:33 +0000 (GMT)
Received: from [9.155.199.94] (unknown [9.155.199.94])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Nov 2025 16:22:33 +0000 (GMT)
Message-ID: <5dd6e694-8cf9-4b1c-ae83-088b6bd22a17@de.ibm.com>
Date: Thu, 6 Nov 2025 17:22:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 21/23] KVM: s390: Enable 1M pages for gmap
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        david@redhat.com, gerald.schaefer@linux.ibm.com
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
 <20251106161117.350395-22-imbrenda@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20251106161117.350395-22-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: c46-cRktUHCAobPYCSnH0_UD5Kf9bEq7
X-Authority-Analysis: v=2.4 cv=MKhtWcZl c=1 sm=1 tr=0 ts=690ccb4f cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6ItpLjnqAre2Uv_fE_cA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: c46-cRktUHCAobPYCSnH0_UD5Kf9bEq7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAwMSBTYWx0ZWRfXxScOihMx6Gr+
 Qxxdn0Jpaak/ZRrvchASrb7hMX4elhK0ZQthGg8B01dkAJ4ivK5U+w+llbd3cqhxgtiefA0pTGr
 y5csPfqS5ZccKsRIBX2cFF8sFBWBw/UuZUI0zio8IcS+OtHGkiQxcpLlkPRpk4pAxmtpRP0xVQS
 xisdBp+/eMfEKoOgQPBDpeB06DR3I0VGRtwXCgBS7gPJ6m6jSYXEaMqlYdwqvLg2P7VLY83gin/
 0+H4dggPVzW7AlWa9imhlJHYkhZhpUlPVFufhwD6lboMrcA1fykRFYskUeRM77zPfYGqqDDm9xz
 LLVvU+/tj6kYzA7F4JXB4bvXQq5qSS7Bt3FnCm9ctdz8oOFksZw91hLxLbWx4sTI4QzD3N/sjEK
 qKZCKH2uOBoSHmXtXdrZVq04M/vxJA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 bulkscore=0 impostorscore=0 clxscore=1011
 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010001

Am 06.11.25 um 17:11 schrieb Claudio Imbrenda:
> While userspace is allowed to have pages of any size, the new gmap
> would always use 4k pages to back the guest.
> 
> Enable 1M pages for gmap.
> 
> This allows 1M pages to be used to back a guest when userspace is using
> 1M pages for the corresponding addresses (e.g. THP or hugetlbfs).
> 
> Remove the limitation that disallowed having nested guests and
> hugepages at the same time.

Nice. This might allow us to enable hpage=1 as new default as soon as
things stabilize.

We would also be able to use 2GB huge pages for the qemu mapping?
With this patch we then have 1MB pages for the guest mapping.

As a future improvement, maybe also allow guest mapping 2GB pages.


