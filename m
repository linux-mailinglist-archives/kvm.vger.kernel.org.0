Return-Path: <kvm+bounces-42299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DFD9AA7795C
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 13:10:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 297453A8879
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 11:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 573851F193C;
	Tue,  1 Apr 2025 11:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jnik4p0y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024B41C1F2F;
	Tue,  1 Apr 2025 11:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743505834; cv=none; b=OOKmJ2MS/k6Um1Myq9kRdnQ8t9zueGJqU1ksYgF8qgpdz8cpw0MDR0WN6jLfaf/W5k/NRMtixxfbHZliw7MnkyesF27FoukVoBR4kNLmOg/c4fufp9jFk9XiRUW8aqmnwBQL3L2kpObAGZnjh1B08JtwCuExSNp8K+kw6N8sDWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743505834; c=relaxed/simple;
	bh=Kub9SCpfDg9klKiKVsLTytb+wj8pjUfxJOUT3DKae9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ColngW3B+55LVdshw0CFmxmukAr/+ALuAi5M039hs3rLVR8rYS8db6grsPYHRIYV2j5YpknOXQ2V2O6IPRRc8PFaWEdOLUTXYHz3qOwc/3AeeoYKIV1xXbrFGVkdljpfFgHmu8bbLBqglrirs+sUAHjJ9z/ZhYYgzXIdhkBUrCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jnik4p0y; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5317sK4v027925;
	Tue, 1 Apr 2025 11:10:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Kub9SC
	pfDg9klKiKVsLTytb+wj8pjUfxJOUT3DKae9U=; b=jnik4p0yeIelwWQe6UmHkg
	7p1PG5ck1vsECoqSABnF1jK2gXGItmNdc1izINxTZ5wcP9DqKY6e4hXUW3P+vhYr
	hyS/xAuGwm2kGYS4MEndCflq2BQ6oFnR/DGuAKuD4SiGUm8jwzd9QjOzcgVE9kVh
	BXhSdVnh3uDZ5tTNzfP3R6bo4idss5kJUhuQsDy+ylcC8T2bhPWPZi93dBHWZpZV
	RZV3HyxxPJCDZKpoHAVnq7E+m0+H8ocStMmudezwvRHHkh3bN5RejQg/iHSw/8sn
	A6i90E2efp0gREss4MV8Z4OkbhK2Qr58dRzYVCHRVSQJnoSlLN8eWzACQ2axopIQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45qu32dhcs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Apr 2025 11:10:31 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5319JGRc001719;
	Tue, 1 Apr 2025 11:10:31 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 45rddkrd87-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Apr 2025 11:10:31 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 531BATUm30016230
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 1 Apr 2025 11:10:29 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 922935805C;
	Tue,  1 Apr 2025 11:10:29 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE9545805D;
	Tue,  1 Apr 2025 11:10:28 +0000 (GMT)
Received: from [9.61.7.200] (unknown [9.61.7.200])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  1 Apr 2025 11:10:28 +0000 (GMT)
Message-ID: <90c4101d-8294-445a-bdab-a1746398e607@linux.ibm.com>
Date: Tue, 1 Apr 2025 07:10:28 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] s390/vio-ap: Fix no AP queue sharing allowed message
 written to kernel log
To: Heiko Carstens <hca@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gor@linux.ibm.com
References: <20250311103304.1539188-1-akrowiak@linux.ibm.com>
 <156b71cf-b94f-4fa0-a149-62bb8c2a797b@linux.ibm.com>
 <20250401082410.7691A4a-hca@linux.ibm.com>
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20250401082410.7691A4a-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: h3kzb_OokEMahSCZeJn9ILZQ_ZKDC-_1
X-Proofpoint-ORIG-GUID: h3kzb_OokEMahSCZeJn9ILZQ_ZKDC-_1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-01_04,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxlogscore=863 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504010070




On 4/1/25 4:24 AM, Heiko Carstens wrote:
> On Mon, Mar 31, 2025 at 06:22:42PM -0400, Anthony Krowiak wrote:
>> Gentlemen,
>>
>> I got some review comments from Heiko for v1 and implemented his suggested
>> changes. I have not heard from anyone else, but I think if Heiko agrees that
>> the changes are sufficient, I think this can go upstream via the s390 tree.
>> What say you?
>>
>> Kind regards,
>> Tony Krowiak
> Applied, with subject fixed, and some minor coding style fixes.

Thanks Heiko.

> Thanks!


