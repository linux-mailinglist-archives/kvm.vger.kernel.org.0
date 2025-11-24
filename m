Return-Path: <kvm+bounces-64342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AFE47C80086
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 11:57:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C599D4E543E
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 10:57:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C8DF2FB962;
	Mon, 24 Nov 2025 10:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Zx4nOcd7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5642FB0B9;
	Mon, 24 Nov 2025 10:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763981848; cv=none; b=SCw2nMfmQvqgav5DihOD5uvFdDfm1IzMbHuuykG218BxnLFwWAFyC2m8UjoJbmZys9j6hPtKB/MYVEyXKekCLhakfOs+YdqCq79wQPnBGfyDkxKYMBO//MinlbjiDwV3oAJBT8SauywDV5oSBnkQVHvyT4VVt6BCFA4dCc2/BCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763981848; c=relaxed/simple;
	bh=WTIsLO+NhTz0IkApmRRn+HL48kpaFXBdgOzrQ53AOAo=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:Subject:From:
	 References:In-Reply-To; b=I6KbbjtP/RXL7qpVPPEIO9Cykl4QXyRSJRBBHfkVUwKnFF8zDUMjnP3zLA+r/KZpS0OEKNLyrdjjsgwJaYVznS1eLmoFXuIMCJ9+VvLiW/1XIlUmUSu3Grr0EM9Nq8Z5WjIlik4x9ihphcZLx/OlQepZMiwnLvX/xfLjrs5GPMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Zx4nOcd7; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO9JF4q003546;
	Mon, 24 Nov 2025 10:57:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=6NPazR
	+pcyuqtzNV3B0lOOC1rrpBUCbp1QOzzwRcwGU=; b=Zx4nOcd7TdYpzXUfomMZFU
	Gc/pUbCyX0I883xD83HqayVLcqnDEdcyYSyFHHNXiFGjXoqI2+OoB3qy5r7ckrsF
	M1/KWxGIzYvoqM/0jEDOkEl381eJJJUxjaP2ojt4N7uBCg1KOQqXCH1EuQRDWQoK
	C+s0rutteRBl9MyR8hTgknWmYyrE2C68iZzDMIieVQCKEX6CF6Bo3/1/Op+plmDD
	saoZ2DuY7XeHgTxbTcu3fKLRL7bVdRznU4SdhqZz54h52g3SZp8KcC+bGcuGaPYe
	KnZz3RQPRQv2paQGIPqFnoskZzitFdNvanf8Iia8IIqc5leVxyZyoJ3/OnoA+ltA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak2kpqf86-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 10:57:15 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO8F3Yo025116;
	Mon, 24 Nov 2025 10:57:15 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4akt71568a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 10:57:14 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AOAvBaR11600172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 10:57:11 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC25920043;
	Mon, 24 Nov 2025 10:57:10 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B3D6A20040;
	Mon, 24 Nov 2025 10:57:10 +0000 (GMT)
Received: from darkmoore (unknown [9.111.94.126])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Nov 2025 10:57:10 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 24 Nov 2025 11:57:05 +0100
Message-Id: <DEGVDBEDNAV3.3FB0VGQ9RWPWZ@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, "Heiko Carstens" <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander Gordeev"
 <agordeev@linux.ibm.com>,
        "Christian Borntraeger"
 <borntraeger@linux.ibm.com>,
        "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "Nico Boehr" <nrb@linux.ibm.com>,
        "David Hildenbrand" <david@redhat.com>,
        "Sven Schnelle" <svens@linux.ibm.com>,
        "Paolo Bonzini"
 <pbonzini@redhat.com>,
        "Shuah Khan" <shuah@kernel.org>
To: "Janosch Frank" <frankja@linux.ibm.com>,
        "Christoph Schlameuss"
 <schlameuss@linux.ibm.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC v2 10/11] KVM: s390: Add VSIE shadow configuration
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
X-Mailer: aerc 0.21.0
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
 <20251110-vsieie-v2-10-9e53a3618c8c@linux.ibm.com>
 <2087b6b4-34b4-4509-9cae-bfe719d99992@linux.ibm.com>
In-Reply-To: <2087b6b4-34b4-4509-9cae-bfe719d99992@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAwMCBTYWx0ZWRfX5r/Tg79dcqGX
 2yCvDFm2yCWJcwmOtl+DYoy4SYej8P8qiMIuhR3Kr0Y6wyZtfJcSkglEC9/9mCY+W2Mjhlkce8E
 eqxAVQTFGnz+tfmD1UUI4ZzHf+2iaKhgV4TZzQEoCS8VQBzbk2XVPFILCle4aXACe3C6ltBLGkG
 tym0rge+5IUE3nk1kqAgk57Tm1kSsVeAFoyA6osqDgTIaPwK4kCxoN+b/Sj2AtJO14Qbjq9gutG
 NcxAmXl7TPR/23n2RFKZLwuL9zkZ2/gk53F3+Jgazir5PQmcPYju+wP8F38iMWiq4YPJsjT9ckZ
 Vez++1Lbp8buBdxLixC2rjRIQ5uwMt4SKzt9pyLcfc/gYWvv0+QZy5chPkyqPZzL9Ycru98Re2b
 mq4Q+38mrGxHkb1O6TWxkIIHkS6w8Q==
X-Authority-Analysis: v=2.4 cv=fJM0HJae c=1 sm=1 tr=0 ts=69243a0b cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=Ww8LI7ojZHvPq9H9oV4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: b-NhKUEt-N-DHW_DfmhHNwImUjqz6hIE
X-Proofpoint-ORIG-GUID: b-NhKUEt-N-DHW_DfmhHNwImUjqz6hIE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220000

On Thu Nov 20, 2025 at 12:02 PM CET, Janosch Frank wrote:
> On 11/10/25 18:16, Christoph Schlameuss wrote:
>> Introduce two new module parameters allowing to keep more shadow
>> structures
>>=20
>> * vsie_shadow_scb_max
>>    Override the maximum number of VSIE control blocks / vsie_pages to
>>    shadow in guest-1. KVM will use the maximum of the current number of
>>    vCPUs and a maximum of 256 or this value if it is lower.
>>    This is the number of guest-3 control blocks / CPUs to keep shadowed
>>    to minimize the repeated shadowing effort.
>
> KVM will either use this value or the number of current VCPUs. Either=20
> way the number will be capped to 256.
>

>>=20
>> * vsie_shadow_sca_max
>>    Override the maximum number of VSIE system control areas to
>>    shadow in guest-1. KVM will use a minimum of the current number of
>>    vCPUs and a maximum of 256 or this value if it is lower.
>>    This is the number of guest-3 system control areas / VMs to keep
>>    shadowed to minimize repeated shadowing effort.
>>=20
>> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> Except for the current implementation with arrays, nothing is limiting=20
> us from going over 256 in the future by changing the code. I'm not sure=
=20
> if I ever want to see such an environment in practice though.
>

Even if we would implement that I would not expect to see any improvement f=
rom
that without SIGPI. It would be interesting if a crazy over committed syste=
m
would even benefit from that or not. That would mainly bring down the not
running SCB shadow and SCA shadow re-init effort.

>>   arch/s390/kvm/vsie.c | 18 +++++++++++++++---
>>   1 file changed, 15 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>> index b69ef763b55296875522f2e63169446b5e2d5053..cd114df5e119bd289d14037d=
1f1c5bfe148cf5c7 100644
>> --- a/arch/s390/kvm/vsie.c
>> +++ b/arch/s390/kvm/vsie.c
>> @@ -98,9 +98,19 @@ struct vsie_sca {
>>   	struct vsie_page	*pages[KVM_S390_MAX_VSIE_VCPUS];
>>   };
>>  =20
>> +/* maximum vsie shadow scb */
>> +unsigned int vsie_shadow_scb_max;
>
> Don't we need to initialize the variables or mark them static so they are=
 0?
>

Yes, initializing to 1.

Interestingly I at least not notice this acting up weirdly.

>> +module_param(vsie_shadow_scb_max, uint, 0644);
>> +MODULE_PARM_DESC(vsie_shadow_scb_max, "Maximum number of VSIE shadow co=
ntrol blocks to keep. Values smaller number vcpus uses number of vcpus; max=
imum 256");
>> +
>> +/* maximum vsie shadow sca */
>> +unsigned int vsie_shadow_sca_max;
>> +module_param(vsie_shadow_sca_max, uint, 0644);
>> +MODULE_PARM_DESC(vsie_shadow_sca_max, "Maximum number of VSIE shadow sy=
stem control areas to keep. Values smaller number of vcpus uses number of v=
cpus; 0 to disable sca shadowing; maximum 256");
>> +
>>   static inline bool use_vsie_sigpif(struct kvm *kvm)
>>   {
>> -	return kvm->arch.use_vsie_sigpif;
>> +	return kvm->arch.use_vsie_sigpif && vsie_shadow_sca_max;
>
> This functions as the enablement of vsie_sigpif?
> Is there a reason why we don't want this enabled per default?
>

Yes, setting both values to default to 1 seems most logical to me.

I am setting this in my testing so I did actually not notice I set the defa=
ult
to disable here. Thanks.

>>   }
>>  =20
>>   static inline bool use_vsie_sigpif_for(struct kvm *kvm, struct vsie_pa=
ge *vsie_page)
>> @@ -907,7 +917,8 @@ static struct vsie_sca *get_vsie_sca(struct kvm_vcpu=
 *vcpu, struct vsie_page *vs
>>   	 * We want at least #online_vcpus shadows, so every VCPU can execute =
the
>>   	 * VSIE in parallel. (Worst case all single core VMs.)
>>   	 */
>> -	max_sca =3D MIN(atomic_read(&kvm->online_vcpus), KVM_S390_MAX_VSIE_VCP=
US);
>> +	max_sca =3D MIN(MAX(atomic_read(&kvm->online_vcpus), vsie_shadow_sca_m=
ax),
>> +		      KVM_S390_MAX_VSIE_VCPUS);
>>   	if (kvm->arch.vsie.sca_count < max_sca) {
>>   		BUILD_BUG_ON(sizeof(struct vsie_sca) > PAGE_SIZE);
>>   		sca_new =3D (void *)__get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO)=
;
>> @@ -1782,7 +1793,8 @@ static struct vsie_page *get_vsie_page(struct kvm_=
vcpu *vcpu, unsigned long addr
>>   		put_vsie_page(vsie_page);
>>   	}
>>  =20
>> -	max_vsie_page =3D MIN(atomic_read(&kvm->online_vcpus), KVM_S390_MAX_VS=
IE_VCPUS);
>> +	max_vsie_page =3D MIN(MAX(atomic_read(&kvm->online_vcpus), vsie_shadow=
_scb_max),
>> +			    KVM_S390_MAX_VSIE_VCPUS);
>>  =20
>>   	/* allocate new vsie_page - we will likely need it */
>>   	if (addr || kvm->arch.vsie.page_count < max_vsie_page) {
>>=20


