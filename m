Return-Path: <kvm+bounces-63405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D6CDC65B09
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 19:19:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 70CF93596D6
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 18:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D1923126DA;
	Mon, 17 Nov 2025 18:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="S1UC2G5z"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E930C30DD29;
	Mon, 17 Nov 2025 18:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763403320; cv=none; b=U5eegj5eyFTgmPX1DyZVw3YvHR0BuJjo64/qMjWY6dSHGaIYJZsGSrcfJWMe2CsRQF3pAxu2ydC3DeGgP8HYW9cxd0XQ5qZ5ORICXO+p0eVKAUG93zlVdeaBK3H/lWyq1btTfdY476QpIuqMrl8wwXAklin5rvI6BKzc7nijFrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763403320; c=relaxed/simple;
	bh=q/YGFmbuG37wOjReemkXJT9vnRcy4s9IBQS4GZRPS5Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fuqs8RrRxKXJXtem6CUBEIETAcfYJTsiLvwUQmrcFP3BBvoBUx4d3I5xUYN/k4wZc8JxA2RmQx0mPfboLPH8BpzwDd6ftkrWjHuXMHErHIV+WgPrXnb+ezIDqmCjrRBk0rnNH3fCM3zN5YCC78bzxBmG6VMA8iq0D9vuvv7vtL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=S1UC2G5z; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHBFEkm002293;
	Mon, 17 Nov 2025 18:15:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=QMLHw1
	Jy/B9zu96RSIjNkq4cnbKhzfUedWkR0Xn4JDY=; b=S1UC2G5zva5sQyv1eB8+K4
	dzDFXqYkrHO2AjrHBYo9+Edw1OaeLZEr+AsmxoqxHInt5iF8MISPda6zZHm0jVIv
	oBxGwwGWzEsY/ykwbcZFlxRj+qkRh/ZbmORPlqfoKWdk00U0CluWOtraOsimhKD3
	opfvvIZLm8fuUAy3FFu5U4ctI202Inhe1u5kEjCE1qtp7E3LXq13En2KllkpEw/g
	jvyfkl8YS7fAhVVdKPk3JH5qbJGiBo71/ImAAIUqONgd5Wj8Lzw8O9lVNSVoLMVk
	LhcO3L9puMj6GVcvgORRrAFc2kn7hDMFKOPuS/OZ0fbiXD8tZBiPAcLvaNllTH5A
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejgwqa84-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Nov 2025 18:15:02 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHFFIwX006964;
	Mon, 17 Nov 2025 18:15:02 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4af62j73kv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Nov 2025 18:15:02 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AHIEwBI16318974
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 18:14:58 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E2D420043;
	Mon, 17 Nov 2025 18:14:58 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB8D120040;
	Mon, 17 Nov 2025 18:14:57 +0000 (GMT)
Received: from [9.111.46.125] (unknown [9.111.46.125])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Nov 2025 18:14:57 +0000 (GMT)
Message-ID: <3e4020ae-9fdb-46be-8f18-4319fc09c5cc@linux.ibm.com>
Date: Mon, 17 Nov 2025 19:14:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: Implement CHECK_STOP support and fix
 GET_MP_STATE
To: Josephine Pfeiffer <hi@josie.lol>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc: david@kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251117151800.248407-1-hi@josie.lol>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20251117151800.248407-1-hi@josie.lol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nj5_nKwpWoUOBWQvWZdWvQEJzYjVK9Pp
X-Authority-Analysis: v=2.4 cv=YqwChoYX c=1 sm=1 tr=0 ts=691b6627 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VaHay6u1mMcvSU3id2oA:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: nj5_nKwpWoUOBWQvWZdWvQEJzYjVK9Pp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXxFHNgTteGYYT
 n+hhgLQpDaqYNPSxpvMD20ohvw2JdbL3ntvIH3yDjFdqO77pP+x9I6WrpZR7vOvn61FlDd1/xF/
 tdO2ecLiTeDZmJ14zNcjJk2b2AbfogyxmYE1KnahM2Oe9FpLthWN3lXx3Y4WQgsapjcuIP7jOUb
 vv1fO13lNQvo+UD75UlKxWZBIOMVPidzrBJDEsTV6+KXjJWngk7qpZWjTiiUegp57RoN8S62m+I
 v5vm53Ia5Q+mVltG9GqI89GJYurpQV3lx3hcSZ56B+R5GLNJQIGQ4KAqeATainNa5TL4b33/oXl
 /Zi5Pf6OTHQg/24WcTynWtbEQ44WT2D4jbSZxmfAL9qdHSHCc7vC5LS7+UzD7gNotRvmyjQsXSg
 7fLyBXxanTJfVZDFIpTm5cpfYxMy4A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_03,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1011 adultscore=0 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511150032

Am 17.11.25 um 16:18 schrieb Josephine Pfeiffer:
> Add support for KVM_MP_STATE_CHECK_STOP to enable proper VM migration
> and error handling for s390 guests. The CHECK_STOP state represents a
> CPU that encountered a severe machine check and is halted in an error
> state.

I think the patch description is misleading. We do have proper VM
migration and we also have error handling in the kvm module. The host
machine check handler will forward guest machine checks to the guest.
This logic  is certainly not perfect but kind of good enough for most
cases.
Now: The architecture defines that state and the interface is certainly
there. So implementing it will allow userspace to put a CPU into checkstop
state if you ever need that. We also have a checkstop state that you
can put a secure CPU in.

The usecase is dubious though. The only case of the options from POP
chapter11 that makes sense to me in a virtualized environment is an exigent
machine check but a problem to actually deliver that (multiple reasons,
like the OS has machine checks disabled in PSW, or the prefix register
is broken).

So I am curious, do you have any specific usecase in mind?
I assume you have a related QEMU patch somewhere?

> 
> This implementation adds:
> - CPUSTAT_CHECK_STOP flag to track check-stopped CPUs
> - is_vcpu_check_stopped() helper macro for state checking
> - kvm_s390_vcpu_check_stop() function to transition CPUs to CHECK_STOP
> - Integration with Protected VM Ultravisor (PV_CPU_STATE_CHKSTP)
> - Interrupt blocking for check-stopped CPUs in deliverable_irqs()
> - Recovery path enabling CHECK_STOP -> OPERATING transitions
> - Proper state precedence where CHECK_STOP takes priority over STOPPED
> 
> Signed-off-by: Josephine Pfeiffer <hi@josie.lol>
> ---
>   arch/s390/include/asm/kvm_host_types.h |  1 +
>   arch/s390/kvm/interrupt.c              |  3 ++
>   arch/s390/kvm/kvm-s390.c               | 72 ++++++++++++++++++++++----
>   arch/s390/kvm/kvm-s390.h               |  6 +++
>   arch/s390/kvm/sigp.c                   |  8 ++-
>   5 files changed, 77 insertions(+), 13 deletions(-)
> 

 From a quick glance the patch in general does not look wrong but at least this is wrong:> diff --git a/arch/s390/include/asm/kvm_host_types.h b/arch/s390/include/asm/kvm_host_types.h
> index 1394d3fb648f..a86e326a2eee 100644
> --- a/arch/s390/include/asm/kvm_host_types.h
> +++ b/arch/s390/include/asm/kvm_host_types.h
> @@ -111,6 +111,7 @@ struct mcck_volatile_info {
>   	((((sie_block)->sidad & SIDAD_SIZE_MASK) + 1) * PAGE_SIZE)
>   
>   #define CPUSTAT_STOPPED    0x80000000
> +#define CPUSTAT_CHECK_STOP 0x40000000
Bit 1 of the sie control block is a hardware defined bit and
its meaning is not checkstop, so this is not the right way to do it.
Lets first clarify your usecase so that we can see what the right way forward is.

Christian


