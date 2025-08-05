Return-Path: <kvm+bounces-53976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F30DB1B2B5
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:44:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 581E9181E54
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 11:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D620B25CC6C;
	Tue,  5 Aug 2025 11:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mRWs78ax"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6794C2F30;
	Tue,  5 Aug 2025 11:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754394253; cv=none; b=D0rpopj8O9oXqYB9gNMM8xNZ8ID3AGbYno9zgo7/PLb7vBjKxop2CPDqq0JuASxLTgJZmMRLkNli24wyAJ+9kejbU5sbO/z42Ix7RUGKCkmPccLKhQKJyTmO2Zlu7sttEv3dEEGDe8GWnjXsgFKl9uDufDZN8mTFcUEhGordniA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754394253; c=relaxed/simple;
	bh=tSicJJUUzwDpdZ7T9kknH0es0dyUPEUOlD/aMDWKwk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RsGTqoyiIChOv1r81cWRXGDvHQroyhm3aOgVxVUKvy3LIgmE8p/lT18o2forEr2ZXBpBhr0cMRqBeL5zc6XfDckQMhnqpz8bN97sD9wFfpVUNcWcqkGQ9qlSirt255bhxbtdRfk4vBtW1wjv40g8PssB8xT7djuPzSx6nsNZXgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com; spf=pass smtp.mailfrom=de.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mRWs78ax; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=de.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5759KRgA031917;
	Tue, 5 Aug 2025 11:44:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VotaNn
	gmIWAOrZVzgXH4L9e9nO0fM3kNicVc2pm8X8E=; b=mRWs78axx6+Va+AWLTXABV
	XcTsoO3cxH2+idEcCbGcgXMl16UgcLhPyOdsrAbLzXDnu/6sCLNeljCqCuXK0ZwN
	+5MZ/tZ3dOU3afKZNRl4vJY/9yZv+ra8wxk4zIb5U9DfHdJ9D8NVJvY9pQRIDjBX
	wbG18YlqcB9TxrILLYbxBb4muKcuNzVC7CVYStAIrZBxVhV352S9kXlizgjShzdT
	N+lgqKdxJpOW5iiiHHIelNglMEaptatjzF1mV+5QXd9Dg6rXcy5fpfxOyr88Kzyc
	A6hM2RH8nCtQQZEARFXJSvimuBgu+f3koae1lmoij2SvmyKoH3kMGokCeWoH2o8A
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48983t6h7j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 11:44:09 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5759ZYGT004594;
	Tue, 5 Aug 2025 11:44:08 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 489yq2hxq4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 11:44:08 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 575Bi4l058589514
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Aug 2025 11:44:04 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 607B42004B;
	Tue,  5 Aug 2025 11:44:04 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 27FAB20040;
	Tue,  5 Aug 2025 11:44:04 +0000 (GMT)
Received: from [9.152.224.86] (unknown [9.152.224.86])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 Aug 2025 11:44:04 +0000 (GMT)
Message-ID: <5b0b8d5e-efab-4c5b-be1e-93d8a8f155b3@de.ibm.com>
Date: Tue, 5 Aug 2025 13:44:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com,
        mhartmay@linux.ibm.com
References: <20250805111446.40937-1-imbrenda@linux.ibm.com>
 <20250805111446.40937-3-imbrenda@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20250805111446.40937-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDA4MyBTYWx0ZWRfXzuh3JWpiXeje
 3pQMynG4Q7ckIph8DM5EIAXA1IIp3XvPpflLGhORSN42Qll9Nm2YltL8e1MV0n7Rg6qGATsJJYJ
 nkR82NAPm0pJuWtKZ77NjAwQgK3CG7fC4gwOSrMtSvJa2yZAMeYKNdy1lVpx2hrKuh/Tnk7/wQH
 hjdResdRCBX8qmKVcpf5Z2JAHEgqS8qd2W77veSbrlyobTX3AUuekQ+c0A5Hfr57K3VYcrC6rPi
 zp+QdnRVdfV/bDjVBwuZU9ZPMzE0SZdHPywIDFRtZ5yxu35IAMDn954UOZshEZcOB9jHZGrRdwg
 Xpxa5wOCEAO/q9tWvAWtgGXyDV6l6CaqXfcb3+KeZM5mCk07OOlqCH1E13JSzbCAckPF4jCgGaD
 99z8SP59+mWxDFovjl462JikWdQ6Kk5VVSpAWbLadmv3lWtj/O/bYm8wPECxN1NJylspxp4k
X-Proofpoint-GUID: UajXKCz5t-TMix1_eBHbtmwp_9fLY6Cd
X-Proofpoint-ORIG-GUID: UajXKCz5t-TMix1_eBHbtmwp_9fLY6Cd
X-Authority-Analysis: v=2.4 cv=AZSxH2XG c=1 sm=1 tr=0 ts=6891ee89 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=3LKg8ZfnZWUu6ZJkRk8A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 impostorscore=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2508050083

Am 05.08.25 um 13:14 schrieb Claudio Imbrenda:
> Pass the right type of flag to vcpu_dat_fault_handler(); it expects a
> FOLL_* flag (in particular FOLL_WRITE), but FAULT_FLAG_WRITE is passed
> instead.
> 
> This still works because they happen to have the same integer value,
> but it's a mistake, thus the fix.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: 05066cafa925 ("s390/mm/fault: Handle guest-related program interrupts in KVM")

Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>

Shouldnt we rename the parameter to __kvm_s390_handle_dat_fault and
vcpu_dat_fault_handler from flags to foll as well in their
implementation and prototypes to keep this consistent?

> ---
>   arch/s390/kvm/kvm-s390.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index d5ad10791c25..d41d77f2c7cd 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4954,13 +4954,13 @@ static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, un
>   
>   static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
>   {
> -	unsigned int flags = 0;
> +	unsigned int foll = 0;
>   	unsigned long gaddr;
>   	int rc;
>   
>   	gaddr = current->thread.gmap_teid.addr * PAGE_SIZE;
>   	if (kvm_s390_cur_gmap_fault_is_write())
> -		flags = FAULT_FLAG_WRITE;
> +		foll = FOLL_WRITE;
>   
>   	switch (current->thread.gmap_int_code & PGM_INT_CODE_MASK) {
>   	case 0:
> @@ -5002,7 +5002,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
>   			send_sig(SIGSEGV, current, 0);
>   		if (rc != -ENXIO)
>   			break;
> -		flags = FAULT_FLAG_WRITE;
> +		foll = FOLL_WRITE;
>   		fallthrough;
>   	case PGM_PROTECTION:
>   	case PGM_SEGMENT_TRANSLATION:
> @@ -5012,7 +5012,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
>   	case PGM_REGION_SECOND_TRANS:
>   	case PGM_REGION_THIRD_TRANS:
>   		kvm_s390_assert_primary_as(vcpu);
> -		return vcpu_dat_fault_handler(vcpu, gaddr, flags);
> +		return vcpu_dat_fault_handler(vcpu, gaddr, foll);
>   	default:
>   		KVM_BUG(1, vcpu->kvm, "Unexpected program interrupt 0x%x, TEID 0x%016lx",
>   			current->thread.gmap_int_code, current->thread.gmap_teid.val);


