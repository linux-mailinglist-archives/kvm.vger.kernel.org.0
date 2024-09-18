Return-Path: <kvm+bounces-27066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C62A797BB10
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 12:46:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89A0E282605
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 10:46:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AB2A1865F5;
	Wed, 18 Sep 2024 10:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rq0qfeYZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072DF381D5;
	Wed, 18 Sep 2024 10:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726656370; cv=none; b=QwobJo4nv0PGE6ZIIlswqXc0WRvWKgDHz/oy+nIg3p4kIR90rCwGwg/wwMg5Lf723vAsz9N0rLAvrLU6FO4hjvkq9WkERu8SoimWSpBEyc/wFLNU6IEXlOpx+cjpF5Qg6owdvHk1LtM7kRsSeKb/8+PF2iQR6YXvu6Jtoi3xKyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726656370; c=relaxed/simple;
	bh=YfHHtQTEI9uJjv1+oEusc6SIb8XwsYQTZBH7mfgjLhQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FN6jUqwIT3QVMWwojFYI0zD8mlRKAFR6anU+PPKr85C6Do1HB0Tv+zfaF3Ps+B+YItMDNM6taKRfZh/Yjt6Q7fUbNdHgwtdFIJaBwg80PgvTWs9H0Ef1myQrt2I/Q7Gyqr1sJVGxj0yCpLYMLM8E8uT1+cowzRQByQztJRFL2uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rq0qfeYZ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48IAC46M006120;
	Wed, 18 Sep 2024 10:46:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=/
	OHSy56H5jWT5Ig+CtsMXnV9oYynZfYkASG43hgWfXs=; b=rq0qfeYZm1+EVqRM5
	f3oV8Kn+K9L3S1U7xTNkAYWbmRjtwLzU3frONSk0iGe2lLuUbg/5T1PdOi75Cssr
	FnXqPl5h0M23T4aYEHXkhFjTWJ1iZ3mL51+oxN6zxpDriQI2ZXj6xXbGXQO7PrY5
	FtQgGo3k0QB6x73oGk3GOa+d2SpRS88TxB4BWplQfu329Bqw5xWxpHiF8eSYCg1R
	IPZuhXQ0hmtb0mhupiqGGtoQlA7V2lJPC74EC6ASyecwVtuAFOXngOOY3Yy3UFv+
	fvqBR7vg4/3iG6lDr883W0jzzVLhhxc77atbbn5rR6sF51GRf5bKHr+dz/D8G0T7
	McW5Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n41amwxs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Sep 2024 10:46:05 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 48IAk5cV003991;
	Wed, 18 Sep 2024 10:46:05 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n41amwxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Sep 2024 10:46:05 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48IA4Xha000642;
	Wed, 18 Sep 2024 10:46:04 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41nn71apvf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Sep 2024 10:46:04 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48IAk09v51118538
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Sep 2024 10:46:00 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CABA620043;
	Wed, 18 Sep 2024 10:46:00 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 995C620040;
	Wed, 18 Sep 2024 10:46:00 +0000 (GMT)
Received: from [9.152.224.192] (unknown [9.152.224.192])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 18 Sep 2024 10:46:00 +0000 (GMT)
Message-ID: <314ca299-b390-41f6-b528-c0524b67f14b@linux.ibm.com>
Date: Wed, 18 Sep 2024 12:46:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] KVM: s390: Change virtual to physical address
 access in diag 0x258 handler
To: Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20240917151904.74314-1-nrb@linux.ibm.com>
 <20240917151904.74314-3-nrb@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20240917151904.74314-3-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Quq2FWtSvo6vFpIkNnkMGowny-zrCcs3
X-Proofpoint-ORIG-GUID: cYeQKmOjqkCaCuct6rdDUAL2goY5vJGY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-18_08,2024-09-16_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 mlxlogscore=989 bulkscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 spamscore=0 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409180063



Am 17.09.24 um 17:18 schrieb Nico Boehr:
> From: Michael Mueller <mimu@linux.ibm.com>
> 
> The parameters for the diag 0x258 are real addresses, not virtual, but
> KVM was using them as virtual addresses. This only happened to work, since
> the Linux kernel as a guest used to have a 1:1 mapping for physical vs
> virtual addresses.
> 
> Fix KVM so that it correctly uses the addresses as real addresses.
> 
> Cc: stable@vger.kernel.org
> Fixes: 8ae04b8f500b ("KVM: s390: Guest's memory access functions get access registers")
> Suggested-by: Vasily Gorbik <gor@linux.ibm.com>
> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> [ nrb: drop tested-by tags ]
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

> ---
>   arch/s390/kvm/diag.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
> index 2a32438e09ce..74f73141f9b9 100644
> --- a/arch/s390/kvm/diag.c
> +++ b/arch/s390/kvm/diag.c
> @@ -77,7 +77,7 @@ static int __diag_page_ref_service(struct kvm_vcpu *vcpu)
>   	vcpu->stat.instruction_diagnose_258++;
>   	if (vcpu->run->s.regs.gprs[rx] & 7)
>   		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> -	rc = read_guest(vcpu, vcpu->run->s.regs.gprs[rx], rx, &parm, sizeof(parm));
> +	rc = read_guest_real(vcpu, vcpu->run->s.regs.gprs[rx], &parm, sizeof(parm));
>   	if (rc)
>   		return kvm_s390_inject_prog_cond(vcpu, rc);
>   	if (parm.parm_version != 2 || parm.parm_len < 5 || parm.code != 0x258)

