Return-Path: <kvm+bounces-48156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91861ACAB4E
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 11:24:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 705353BBD23
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 09:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90CC61DF721;
	Mon,  2 Jun 2025 09:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UHLppZaa"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FC91D516F;
	Mon,  2 Jun 2025 09:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748856289; cv=none; b=BEXK7S/1JnIf4bxVIJ7wVwBcGm2IhvO5nYfxpm8f5NwyR/LjZ+hXOgLU8bzm/HDfgApwgHVlmy8xdOSk2SWiVVgBlSrli5NVwWk0HoqZd5FC2Fn3eaQ3KQpipyFfjxmziUh6ax24OjzaJEcuXXnqJ/TIVRF1HozXJrl+SMhi5+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748856289; c=relaxed/simple;
	bh=0MJrTG0AIvkwugChi+McuCSaHdDoHbP30WWs0aFxFck=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=HUzl0oLICCW65WNWokWkQ8Gymz3SJCuF0N7lhE09VP/wYyNpxMyq9dMwcN7917Zn+6sykEcQeslgiyMwKJOCnMdRbwonPN2J0/FFzoWsnd//8RZ1XWGChCMe/4feqha/084u04RHsxnu46cAG/x0qPXJ2zRLVdz2l5mRWiVu4LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UHLppZaa; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5523jb7X026824;
	Mon, 2 Jun 2025 09:24:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=McNrdU
	DjPTSMsOb7FRfFlWB3rFg2R0cVQwd1Ssz9TKw=; b=UHLppZaaG7CVEE/kubluV+
	atLt0BgX4OEDRa7c0aH9F8qjxF4jGIUsqgG6qE9o4I6fhR1RybJUi6HhE7Rr9vGv
	cCmbzfdlubhydPnOR5qKyWIBG0usIxhowS0wUfBWlCyOdrxNaSQ+nCYnmF8+ike4
	H1jx/l/AATD3WNTpx/UxEaZ/QkzWmhZeHhfKFIYtrFaVG/5YAUjmu8rYIdo/v6i6
	pjUHAEVxHTSAoi5tBh2H85NIHMKz0fja52Mhz+ZeXpxpMZvcYt9rQp+KYIPPIXD2
	zIRuD4FGfaQwTQaz9z8IUWzGgkTJjnoUZgYLM+cTYyLfkm1UyPtVPHPvy6GOQGTg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46yr6p8ca4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Jun 2025 09:24:45 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5528UfTs014640;
	Mon, 2 Jun 2025 09:24:44 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470dkm5exf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Jun 2025 09:24:44 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5529Oegg52167052
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Jun 2025 09:24:40 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 69C0A20043;
	Mon,  2 Jun 2025 09:24:40 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B2FD20040;
	Mon,  2 Jun 2025 09:24:40 +0000 (GMT)
Received: from darkmoore (unknown [9.111.39.121])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Jun 2025 09:24:40 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Jun 2025 11:24:34 +0200
Message-Id: <DABXT5G4XDH2.36Y0Z944ORJCQ@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>,
        "Christian Borntraeger"
 <borntraeger@linux.ibm.com>,
        "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "David Hildenbrand" <david@redhat.com>,
        "Heiko Carstens"
 <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander
 Gordeev" <agordeev@linux.ibm.com>,
        "Sven Schnelle" <svens@linux.ibm.com>,
        "Thomas Huth" <thuth@redhat.com>
To: "Janosch Frank" <frankja@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] KVM: s390: Always allocate esca_block
X-Mailer: aerc 0.20.1
References: <20250522-rm-bsca-v3-0-51d169738fcf@linux.ibm.com>
 <20250522-rm-bsca-v3-2-51d169738fcf@linux.ibm.com>
 <609a3511-4dae-47b8-a6a6-45b8f3b989a8@linux.ibm.com>
In-Reply-To: <609a3511-4dae-47b8-a6a6-45b8f3b989a8@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAyMDA3NyBTYWx0ZWRfX5ia+JkJgjIL7 8hj6MaeBIWa3vrj12eMjyhkmyUBK6RyUoDQJEMW0NGnu85VADAEsNSL4bNTCkdzZrEKNM8fg7n3 KjDqOq2M+PFqcf4ZjQZbNrU+QOGYINj+VRtpTovWYxnZ+X2UlzyX0FTuJMVxXz0wbqW9/2+dAoS
 n3ohxcVJ7RzYGx6cQ56gAdEr/YezP5gJArBX7cz1ARhcxl9n73qQBlE2E7BFJiuAQfyRzAKu9zH U30okLMrPJC5Vdk9oochLTdYTR+uVOulCJ80o2oBwNAGGCIvULiiP+LbnvAPKtRTAtGOyZhiwMw lwfteG/PH+XIBSlCtgOSaHfCcaRcZguOoSwMhp+2okBp5jvWHdNSHnSy6GX9X/2M8vKG/vHSpyk
 pxYcN8qMzwYUYg4Jq1PoY7XgEzGAu8JZSUYUaaWt7HVGJS78FmWUc4V5mkZzwJs9R/gybKY0
X-Proofpoint-ORIG-GUID: c9Uit-S1SVv8_MvAw67rZ3O8-MUKgkH4
X-Proofpoint-GUID: c9Uit-S1SVv8_MvAw67rZ3O8-MUKgkH4
X-Authority-Analysis: v=2.4 cv=V4l90fni c=1 sm=1 tr=0 ts=683d6ddd cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=L1-7jygj_eJouCaRcvEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-02_03,2025-05-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 clxscore=1015
 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2506020077

On Mon May 26, 2025 at 12:36 PM CEST, Janosch Frank wrote:
> On 5/22/25 11:31 AM, Christoph Schlameuss wrote:
>> Instead of allocating a BSCA and upgrading it for PV or when adding the
>> 65th cpu we can always use the ESCA.
>>=20
>> The only downside of the change is that we will always allocate 4 pages
>> for a 248 cpu ESCA instead of a single page for the BSCA per VM.
>> In return we can delete a bunch of checks and special handling depending
>> on the SCA type as well as the whole BSCA to ESCA conversion.
>>=20
>> As a fallback we can still run without SCA entries when the SIGP
>> interpretation facility or ESCA are not available.
>>=20
>> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h |   1 -
>>   arch/s390/kvm/interrupt.c        |  71 +++++------------
>>   arch/s390/kvm/kvm-s390.c         | 161 ++++++-------------------------=
--------
>>   arch/s390/kvm/kvm-s390.h         |   4 +-
>>   4 files changed, 45 insertions(+), 192 deletions(-)
>>=20
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kv=
m_host.h
>> index f51bac835260f562eaf4bbfd373a24bfdbc43834..d03e354a63d9c931522c1a16=
07eba8685c24527f 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -631,7 +631,6 @@ struct kvm_s390_pv {
>>  =20
>
> [...]
>
>>   int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>   {
>> -	gfp_t alloc_flags =3D GFP_KERNEL_ACCOUNT;
>> -	int i, rc;
>> +	gfp_t alloc_flags =3D GFP_KERNEL_ACCOUNT | __GFP_ZERO;
>>   	char debug_name[16];
>> -	static unsigned long sca_offset;
>> +	int i, rc;
>>  =20
>>   	rc =3D -EINVAL;
>>   #ifdef CONFIG_KVM_S390_UCONTROL
>> @@ -3358,17 +3341,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned l=
ong type)
>>   	if (!sclp.has_64bscao)
>>   		alloc_flags |=3D GFP_DMA;
>>   	rwlock_init(&kvm->arch.sca_lock);
>> -	/* start with basic SCA */
>> -	kvm->arch.sca =3D (struct bsca_block *) get_zeroed_page(alloc_flags);
>> -	if (!kvm->arch.sca)
>> -		goto out_err;
>>   	mutex_lock(&kvm_lock);
>> -	sca_offset +=3D 16;
>> -	if (sca_offset + sizeof(struct bsca_block) > PAGE_SIZE)
>> -		sca_offset =3D 0;
>> -	kvm->arch.sca =3D (struct bsca_block *)
>> -			((char *) kvm->arch.sca + sca_offset);
>> +
>> +	kvm->arch.sca =3D alloc_pages_exact(sizeof(*kvm->arch.sca), alloc_flag=
s);
>
> kvm->arch.sca is (void *) at the point of this patch, which makes this a=
=20
> very bad idea. Granted, you fix that up in the next patch but this is=20
> still wrong.
>
> Any reason why you have patch #3 at all?
> We could just squash it and avoid this problem?
>

Yes, I can just roll that up into a single patch. Just thought it would be =
a bit
easier to review this way.

>>   	mutex_unlock(&kvm_lock);
>> +	if (!kvm->arch.sca)
>> +		goto out_err;
>>  =20
>>   	sprintf(debug_name, "kvm-%u", current->pid);
>>  =20
>
> [...]
>
>>   /* needs disabled preemption to protect from TOD sync and vcpu_load/pu=
t */
>> @@ -3919,7 +3808,7 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vc=
pu)
>>   		vcpu->arch.sie_block->eca |=3D ECA_IB;
>>   	if (sclp.has_siif)
>>   		vcpu->arch.sie_block->eca |=3D ECA_SII;
>> -	if (sclp.has_sigpif)
>> +	if (kvm_s390_use_sca_entries())
>>   		vcpu->arch.sie_block->eca |=3D ECA_SIGPI;
>>   	if (test_kvm_facility(vcpu->kvm, 129)) {
>>   		vcpu->arch.sie_block->eca |=3D ECA_VX;
>> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
>> index 8d3bbb2dd8d27802bbde2a7bd1378033ad614b8e..2c8e177e4af8f2dab07fd42a=
904cefdea80f6855 100644
>> --- a/arch/s390/kvm/kvm-s390.h
>> +++ b/arch/s390/kvm/kvm-s390.h
>> @@ -531,7 +531,7 @@ int kvm_s390_handle_per_event(struct kvm_vcpu *vcpu)=
;
>>   /* support for Basic/Extended SCA handling */
>>   static inline union ipte_control *kvm_s390_get_ipte_control(struct kvm=
 *kvm)
>>   {
>> -	struct bsca_block *sca =3D kvm->arch.sca; /* SCA version doesn't matte=
r */
>> +	struct esca_block *sca =3D kvm->arch.sca; /* SCA version doesn't matte=
r */
>
> Remove the comment as well please
>

That's also fully removed in patch 3 along with he whole method.

>>  =20
>>   	return &sca->ipte_control;
>>   }
>> @@ -542,7 +542,7 @@ static inline int kvm_s390_use_sca_entries(void)
>>   	 * might use the entries. By not setting the entries and keeping them
>>   	 * invalid, hardware will not access them but intercept.
>>   	 */
>> -	return sclp.has_sigpif;
>> +	return sclp.has_sigpif && sclp.has_esca;
>>   }
>>   void kvm_s390_reinject_machine_check(struct kvm_vcpu *vcpu,
>>   				     struct mcck_volatile_info *mcck_info);
>>=20


