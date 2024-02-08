Return-Path: <kvm+bounces-8336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B6984E0C7
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 13:37:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62D0B1C22222
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 12:37:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEFF37602C;
	Thu,  8 Feb 2024 12:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QU53q/Fz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258BD347A2;
	Thu,  8 Feb 2024 12:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707395837; cv=none; b=dGFNL5CDphfmI/jEyQsiLb+n2bhPOyZx4d7kwVQy72xUbFRiN9k7QjXm/oCglmnKeGdI7V8dk4m1oAxzkzWq2B6kZrXEcRlbGd6gDdWyplCGQ00L3xpaDXnex1fOnNfpqUpnoabS8sSg32Q5Zzoqbdal5nxtr5FFi7TA32Io3aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707395837; c=relaxed/simple;
	bh=WC1pPvGD9nZJeseQ/9l/X9qM+I43+ch0pQirfnO6d78=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MdpDICZ+gkevkmBqeV/UKEyi4aDI7z5lWTV/rtCUEVX8SG6ElqB5ZcFtPhLsarFs520+oXplti6T0VFCv9b3zdcBL4xAQojFqTYJYHFTOY5C81bRvdtW3aH6+ipvr/ksrC3qSLxV5osU/uiiU55OjucC1E4zRE6DKRdMwdzgxQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QU53q/Fz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418CBJrF024220;
	Thu, 8 Feb 2024 12:37:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xk3DHPiJA4y/oCw4/ZLhmC0/v4IxZmAmhtaP8iUhLUk=;
 b=QU53q/FzMlFYsUv3iggu+gGhkiyfLp2sECR0O9W04IZxY3XdnArOYFoEs9q0GUOrTQIv
 IkJsFTnG2hSUedRp40twfQYYcS7KrqzTyjAIutIAm2B/dE4eg4Wa1cs7SxmEmHEktLLa
 q/P+HLTzlHeebr5T1Q0r2zMCxfEbpDdBVRb50v/1ronHOd8qYOJv0m5drs/Kp1J+6LbQ
 hJg4wELU6ulDZ54CpV+sB+nsL3sM91cQmDwNjV3TYqVvAbWzZ3wHakxcZwHJqrgdBPz7
 swOTyo/wrEYVONiJiwXYj4NIihbf8SA8hJasp2OWRAXxwjL54pDfLk/r9T5jx+jOpXIv nw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w4tncqqe5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Feb 2024 12:37:14 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 418C071s003797;
	Thu, 8 Feb 2024 12:37:13 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w4tncqqdb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Feb 2024 12:37:13 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 418CF8Js014761;
	Thu, 8 Feb 2024 12:37:12 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3w20tp4byw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Feb 2024 12:37:12 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 418Cb8KK26935904
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Feb 2024 12:37:08 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 446462004B;
	Thu,  8 Feb 2024 12:37:08 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B41EC20043;
	Thu,  8 Feb 2024 12:37:07 +0000 (GMT)
Received: from [9.171.61.221] (unknown [9.171.61.221])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  8 Feb 2024 12:37:07 +0000 (GMT)
Message-ID: <84ae4b14-a514-462a-b084-4657f0353332@linux.ibm.com>
Date: Thu, 8 Feb 2024 13:37:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] KVM: s390: remove extra copy of access registers into
 KVM_RUN
Content-Language: en-US
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Claudio Imbrenda
 <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
References: <20240131205832.2179029-1-farman@linux.ibm.com>
 <5ecbe9f3-827d-4308-90cd-84e065a76489@linux.ibm.com>
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <5ecbe9f3-827d-4308-90cd-84e065a76489@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eikHKVWc0KhEQueGFDVuQ3CuMf-IkUvO
X-Proofpoint-ORIG-GUID: nxmrF0JVlOVtGpMEyVgy2Snm7UaFSDuf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_03,2024-02-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 impostorscore=0 spamscore=0 clxscore=1015 mlxlogscore=696
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311290000 definitions=main-2402080067

On 2/8/24 12:50, Christian Borntraeger wrote:
> Am 31.01.24 um 21:58 schrieb Eric Farman:
>> The routine ar_translation() is called by get_vcpu_asce(), which is
>> called from a handful of places, such as an interception that is
>> being handled during KVM_RUN processing. In that case, the access
>> registers of the vcpu had been saved to a host_acrs struct and then
>> the guest access registers loaded from the KVM_RUN struct prior to
>> entering SIE. Saving them back to KVM_RUN at this point doesn't do
>> any harm, since it will be done again at the end of the KVM_RUN
>> loop when the host access registers are restored.
>>
>> But that's not the only path into this code. The MEM_OP ioctl can
>> be used while specifying an access register, and will arrive here.
>>
>> Linux itself doesn't use the access registers for much, but it does
>> squirrel the thread local storage variable into ACRs 0 and 1 in
>> copy_thread() [1]. This means that the MEM_OP ioctl may copy
>> non-zero access registers (the upper- and lower-halves of the TLS
>> pointer) to the KVM_RUN struct, which will end up getting propogated
>> to the guest once KVM_RUN ioctls occur. Since these are almost
>> certainly invalid as far as an ALET goes, an ALET Specification
>> Exception would be triggered if it were attempted to be used.
>>
>> [1] arch/s390/kernel/process.c:169
>>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>
>> Notes:
>>       I've gone back and forth about whether the correct fix is
>>       to simply remove the save_access_regs() call and inspect
>>       the contents from the most recent KVM_RUN directly, versus
>>       storing the contents locally. Both work for me but I've
>>       opted for the latter, as it continues to behave the same
>>       as it does today but without the implicit use of the
>>       KVM_RUN space. As it is, this is (was) the only reference
>>       to vcpu->run in this file, which stands out since the
>>       routines are used by other callers.
>>       
>>       Curious about others' thoughts.
> 
> Given the main idea that we have the guest ARs loaded in the kvm module
> when running a guest and that the kernel does not use those. This avoids
> saving/restoring the ARs for all the fast path exits.
> The MEM_OP is indeed a separate path.
> So what about making this slightly slower by doing something like this
> (untested, white space damaged)

We could fence AR loading/storing via the the PSW address space bits for 
more performance and not do a full sync/store regs here.

> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 7aa0e668488f0..79e8b3aa7b1c0 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -5402,6 +5402,7 @@ static long kvm_s390_vcpu_mem_op(struct kvm_vcpu *vcpu,
>                           return -ENOMEM;
>           }
>    
> +       sync_regs(vcpu);
>           acc_mode = mop->op == KVM_S390_MEMOP_LOGICAL_READ ? GACC_FETCH : GACC_STORE;
>           if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
>                   r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
> @@ -5432,6 +5433,7 @@ static long kvm_s390_vcpu_mem_op(struct kvm_vcpu *vcpu,
>    
>    out_free:
>           vfree(tmpbuf);
> +       store_regs(vcpu);
>           return r;
>    }
>    
> 
> Maybe we could even have a bit in sync/store regs and a BUG_ON in places where
> we access any lazy register.


