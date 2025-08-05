Return-Path: <kvm+bounces-53978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E12DB1B2D7
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:54:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 548D1188D553
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 11:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0759B25E828;
	Tue,  5 Aug 2025 11:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ArAdZlSI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3E7248F42;
	Tue,  5 Aug 2025 11:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754394869; cv=none; b=A5nRc8DRRDiJZdyhZzu++/tzOzsc3sezzYOvcPH57R3vJ4RJI7W2hMjtK4FZwXc4yp26/nDryc5G3twXa/rE8DP7BXiSqNi2+9Fe/6UkRRAhfuq0T10xsnGSIAu5MOEfHVx+Nv0ESriQm64L7WANxhkxIq9c5G8+WmLmzQHX2as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754394869; c=relaxed/simple;
	bh=/ei+iA4HKDwB8/BUD35AL6sbVw6y20oVC+gdu1k/Gg0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NvtlgNtcAuwAmtR80H8iSrqL5QwXYhM33hNbu/egrCsP78M82S8Elu5PkZUydUgVnvcOo4h3FtKvAatFq5bDvGvz4uJAbUNoz1H65rYuf7rsEawDTXAst5TAljnYpDg44nvC9vdNDsbtAuhjEGjYNe4IRY8iYcQUqdWyTBV7RT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com; spf=pass smtp.mailfrom=de.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ArAdZlSI; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=de.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5758xTa0005063;
	Tue, 5 Aug 2025 11:54:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=V+j1r+
	cF8apMbp5eO+t1yh7TLfHA03dva8elP5P2zr4=; b=ArAdZlSIsUUxz1JqVT7YPq
	Zf0SAkvUnQlk9qvqEXAoBgsgZT8sy0qmgOCJjKWuqijC9VK6jCluHK7YgjwRPM4k
	Z8hK4kplSm8RNCJEsoPiYd+LxMZtylo8UfvEKB46zrrCx+1TXKS8KsXA9veyW6o9
	V4HD3DAzXg1rYUSeZRQk/ZpVbZz+TdWuefeo7/MXaV39GbsI4B7rcj4Qr0XhGSpg
	MHPG8P/S/U5yG5rzhHjShKW/BaZvtOjCRSmc/kgJAOpXHwTswT/8hHbHu+jtMqQ6
	g4a3CWrMen/2fPy7MsdB2F76uRBGhFxWKpxUpOrGcAwTr6kzKCdjKnLLbfYeJLXA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48a4aa2815-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 11:54:24 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57594rHn009594;
	Tue, 5 Aug 2025 11:54:23 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 489x0p27ge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 11:54:23 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 575BsJe045482408
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Aug 2025 11:54:19 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 790EF2004B;
	Tue,  5 Aug 2025 11:54:19 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 263FC20040;
	Tue,  5 Aug 2025 11:54:19 +0000 (GMT)
Received: from [9.152.224.86] (unknown [9.152.224.86])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 Aug 2025 11:54:19 +0000 (GMT)
Message-ID: <c7e8276f-3b40-484b-a81a-d293c1e632dd@de.ibm.com>
Date: Tue, 5 Aug 2025 13:54:18 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] KVM: s390: Fix incorrect usage of
 mmu_notifier_register()
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com,
        mhartmay@linux.ibm.com
References: <20250805111446.40937-1-imbrenda@linux.ibm.com>
 <20250805111446.40937-2-imbrenda@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20250805111446.40937-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fQtn-qtmtKRBMIAIiib5um1D5-z3WXft
X-Authority-Analysis: v=2.4 cv=dNummPZb c=1 sm=1 tr=0 ts=6891f0f1 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=h5QcjqOEMrQRjDIlvBAA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: fQtn-qtmtKRBMIAIiib5um1D5-z3WXft
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDA4NiBTYWx0ZWRfX3KH1t6j53r62
 GpNr/piSr1ELIUNsSD4iWk8T+yxJnm4d07Rm2KvupxPOuTg9TXiXl+78UqROygYJlwUhfwR419J
 ik8Fd1emZsGoh37Wjs1FHPehHGtvTNKsaZ+0uQBYdMbZYXIAUqQI2sEXd7RDzbCIbeg2nSKkV+5
 AMGJ6I+gLnAACX6uZzWQxmeXoO3sWO8a8haAiVEUjEUDPeCCUJr0jRDVGO4N8upGfxZPQihklaI
 oXz5A8bzqOakFNshsatJ+1Fd3ZKZWzxUC8fYWKrrGWBs5VVAefEERh4TfTP0LlXxxTws9cHCeIT
 TJWnc85D4NBwFHloWVgM3Xr5UjfpaJlYMg/jj8i9M9W/5s+l4gl9aWvrZfZfSX6O+Jv2RInUCVP
 HZrsdz1E8uvNmb5SJ3J8qy0VJq1imCEU62JIjHJrtrkKpSSfOu+tFItm6pFeaXz+R+LUFuPB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0 spamscore=0
 suspectscore=0 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2508050086



Am 05.08.25 um 13:14 schrieb Claudio Imbrenda:
> If mmu_notifier_register() fails, for example because a signal was
> pending, the mmu_notifier will not be registered. But when the VM gets
> destroyed, it will get unregistered anyway and that will cause one
> extra mmdrop(), which will eventually cause the mm of the process to
> be freed too early, and cause a use-after free.
> 
> This bug happens rarely, and only when secure guests are involved.
> 
> The solution is to check the return value of mmu_notifier_register()
> and return it to the caller (ultimately it will be propagated all the
> way to userspace). In case of -EINTR, userspace will try again.
> 
> Fixes: ca2fd0609b5d ("KVM: s390: pv: add mmu_notifier")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

> ---
>   arch/s390/kvm/pv.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 14c330ec8ceb..e85fb3247b0e 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -622,6 +622,15 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>   	int cc, ret;
>   	u16 dummy;
>   
> +	/* Add the notifier only once. No races because we hold kvm->lock */
> +	if (kvm->arch.pv.mmu_notifier.ops != &kvm_s390_pv_mmu_notifier_ops) {
> +		ret = mmu_notifier_register(&kvm->arch.pv.mmu_notifier, kvm->mm);
> +		if (ret)
> +			return ret;
> +		/* The notifier will be unregistered when the VM is destroyed */
> +		kvm->arch.pv.mmu_notifier.ops = &kvm_s390_pv_mmu_notifier_ops;
> +	}
> +
>   	ret = kvm_s390_pv_alloc_vm(kvm);
>   	if (ret)
>   		return ret;
> @@ -657,11 +666,6 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>   		return -EIO;
>   	}
>   	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
> -	/* Add the notifier only once. No races because we hold kvm->lock */
> -	if (kvm->arch.pv.mmu_notifier.ops != &kvm_s390_pv_mmu_notifier_ops) {
> -		kvm->arch.pv.mmu_notifier.ops = &kvm_s390_pv_mmu_notifier_ops;
> -		mmu_notifier_register(&kvm->arch.pv.mmu_notifier, kvm->mm);
> -	}
>   	return 0;
>   }
>   


