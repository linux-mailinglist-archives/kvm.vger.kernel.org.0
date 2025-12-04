Return-Path: <kvm+bounces-65268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 89149CA3187
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 10:52:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A5B913018744
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 09:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A0CA2566F7;
	Thu,  4 Dec 2025 09:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="r4/Vt3GK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34E132FA3F
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 09:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764841941; cv=none; b=RJcIhcyu5DLY4No8qPibJQe96Dmy9nRfmZkX/XuQ+ze6y/AAirJ8BSLY+suGkdU3kojN53u0qJr5OYJCbkjCvEKxbBmLalqTPFiIxWh54JmeERGFfisvjyKIIVI75MNxo5rnrLPr/3BmIos73/SNADSMDFcpnsINeoeXmdqI/9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764841941; c=relaxed/simple;
	bh=B5zzEXJhz2ZD5cjaZwjP2lPWx+Ebg19Y3dIg6hcHFX0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=urUzbiUS9U8sbfzBs5vZJLH3dO8O2iyxkXmoYGGxIKUPZ3c1Di8JPbd3Lxtk+P7Fi3Y5LFiByy7hpETxrpkCuMBVF9VCfpeY6pVymuMurHZsGX88RaKNmdJzB/5OBpQVhTF9a9avy5IQXC4ReDZ0EZDgIdE9CBZpmrWQ4O7/ezI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=r4/Vt3GK; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5B411Cc1020119;
	Thu, 4 Dec 2025 09:52:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=zmxF3/
	DP1IQrzzwdBMIgMxlVlzfhSXqo+7j42U4/G00=; b=r4/Vt3GKB6fRiO9HjtmYyq
	KtWANXfZxiydeNwg+jSkE9cKc6wMwEHsHHOnhoNossHg8hiWoZyglgjrmdKUr0lX
	ZFMA1lTvkiJpaP0cTwrdHOuWJ+mYbEcKc7X9ZOSC2gkcYtn/ZPoJubUR9LIikmup
	6LKUkteXdT0lhwtH8/Ucdgr5lk1ItG4CcQp37e4Xrmy12HTkmjvLOHdntWvJZW9Y
	myaAuImF+GfHvL6Dp3xpeidZ4lZXjyCfbqm+rivYJ6OzU2lNWPC5mVZkqHdHieaV
	/yCfjSmf0lVj2oBa5R8PKwS4lSWu941yuawbKgZGr00tINA/QEeEgzqfjNYxY3tg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqp8q785u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Dec 2025 09:52:08 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5B49o2qD012391;
	Thu, 4 Dec 2025 09:52:08 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqp8q785s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Dec 2025 09:52:08 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5B48Tjmr003857;
	Thu, 4 Dec 2025 09:52:07 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ardcjxu0q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Dec 2025 09:52:07 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5B49q6oZ25887476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 4 Dec 2025 09:52:06 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 65A3658053;
	Thu,  4 Dec 2025 09:52:06 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8488658061;
	Thu,  4 Dec 2025 09:52:03 +0000 (GMT)
Received: from [9.79.201.141] (unknown [9.79.201.141])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  4 Dec 2025 09:52:03 +0000 (GMT)
Message-ID: <23721641-d08d-4e1c-8fc2-8c0f16f82b1f@linux.ibm.com>
Date: Thu, 4 Dec 2025 15:22:00 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] target/ppc/kvm : Use macro names instead of hardcoded
 constants as return values
To: Gautam Menghani <gautam@linux.ibm.com>, npiggin@gmail.com,
        harshpb@linux.ibm.com, pbonzini@redhat.com, sjitindarsingh@gmail.com
Cc: qemu-ppc@nongnu.org, kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20251202124654.11481-1-gautam@linux.ibm.com>
Content-Language: en-US
From: Chinmay Rath <rathc@linux.ibm.com>
In-Reply-To: <20251202124654.11481-1-gautam@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAwMCBTYWx0ZWRfX3Zo8A80o9QD8
 xLUoYpetH8x6kPGBPbCXJ1faFKZ1C7KFgmCdCH5e09P/S4EVKt8W8QxB3fb61FdoNz9AMVvw3OL
 JfVqzMNfnkljSXZJ7b1SO7Qe1OY39UvjBEPjLfc/y9/2FSgGDFFvKu+5AoGcAhofz6gUx9k4p6S
 H7PSyGNlT/qa2A42v4QpX11LwY+6w7hVbvImjhHc+L7bfbqvRTdL2D2HCtBY+JpzV38zy3TeMtv
 WWHcesfDOJSdpHkT252rdbJpcXuygJmFgIJFPzlCt2lZXKgv2hS0Rqf/p6l1/hfZ1HPJ7Qq+iD2
 n73QYXCcMDXYp7OwEimdBsaBtacu3dKheYidsXkHDBdEGdFFOuc3DHpXzi7U/NKw+OwFYLDK1ny
 kT7+9YxfpmUBtHjehhyrIA1g7Q9CWw==
X-Authority-Analysis: v=2.4 cv=dIerWeZb c=1 sm=1 tr=0 ts=693159c8 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=uOFx0X2q0oB2CtcaZQEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: P444gTh1akQPUw3NrLTQa33jLUo5XqGb
X-Proofpoint-GUID: oyPRJJMIJ8COq1WCb2W0JNhBtluK8aVj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-04_02,2025-12-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511290000


On 12/2/25 18:16, Gautam Menghani wrote:
> In the parse_* functions used to parse the return values of
> KVM_PPC_GET_CPU_CHAR ioctl, the return values are hardcoded as numbers.
> Use the macro names for better readability. No functional change
> intended.
>
> Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> ---
Reviewed-by: Chinmay Rath <rathc@linux.ibm.com>
>   target/ppc/kvm.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 43124bf1c7..464240d911 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -2450,26 +2450,26 @@ static int parse_cap_ppc_safe_cache(struct kvm_ppc_cpu_char c)
>       bool l1d_thread_priv_req = !kvmppc_power8_host();
>   
>       if (~c.behaviour & c.behaviour_mask & H_CPU_BEHAV_L1D_FLUSH_PR) {
> -        return 2;
> +        return SPAPR_CAP_FIXED;
>       } else if ((!l1d_thread_priv_req ||
>                   c.character & c.character_mask & H_CPU_CHAR_L1D_THREAD_PRIV) &&
>                  (c.character & c.character_mask
>                   & (H_CPU_CHAR_L1D_FLUSH_ORI30 | H_CPU_CHAR_L1D_FLUSH_TRIG2))) {
> -        return 1;
> +        return SPAPR_CAP_WORKAROUND;
>       }
>   
> -    return 0;
> +    return SPAPR_CAP_BROKEN;
>   }
>   
>   static int parse_cap_ppc_safe_bounds_check(struct kvm_ppc_cpu_char c)
>   {
>       if (~c.behaviour & c.behaviour_mask & H_CPU_BEHAV_BNDS_CHK_SPEC_BAR) {
> -        return 2;
> +        return SPAPR_CAP_FIXED;
>       } else if (c.character & c.character_mask & H_CPU_CHAR_SPEC_BAR_ORI31) {
> -        return 1;
> +        return SPAPR_CAP_WORKAROUND;
>       }
>   
> -    return 0;
> +    return SPAPR_CAP_BROKEN;
>   }
>   
>   static int parse_cap_ppc_safe_indirect_branch(struct kvm_ppc_cpu_char c)
> @@ -2486,15 +2486,15 @@ static int parse_cap_ppc_safe_indirect_branch(struct kvm_ppc_cpu_char c)
>           return SPAPR_CAP_FIXED_IBS;
>       }
>   
> -    return 0;
> +    return SPAPR_CAP_BROKEN;
>   }
>   
>   static int parse_cap_ppc_count_cache_flush_assist(struct kvm_ppc_cpu_char c)
>   {
>       if (c.character & c.character_mask & H_CPU_CHAR_BCCTR_FLUSH_ASSIST) {
> -        return 1;
> +        return SPAPR_CAP_WORKAROUND;
>       }
> -    return 0;
> +    return SPAPR_CAP_BROKEN;
>   }
>   
>   bool kvmppc_has_cap_xive(void)

