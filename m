Return-Path: <kvm+bounces-62786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 98636C4F101
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 17:38:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 024FE4F705E
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 16:34:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91EF83730D9;
	Tue, 11 Nov 2025 16:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SXsuXKUo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D9B3730CB;
	Tue, 11 Nov 2025 16:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762878858; cv=none; b=UquQVLY6UEuu9eCcgfzDUYPF34XHcLEa+qVQZZJr5yp6LlVVacb6JG6u4MkednTSkPVUxFYWvfE4Y84WNlzeUl9mcLpYhBOyR4PDdlEpU1nufL1KvnQ/PUt7sO8WH+7d8yJJ/MhHFFfpijZ8QhbS+eN4Z392Q5Tu/xtDqoQIvNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762878858; c=relaxed/simple;
	bh=KrzYFF9zR89B6Oaf4D8r7JXYC4sNf/lOSJ6nBJNJvaQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=qd/kKYC2bUt5Nk0wijaJDCsoF02seKm/0im5iwJF44c25UqaNWoAlEt0hN2jkmk2T1Fkjsu9xGGiDOpDo1ZcBoOtbRMwvyT9cC2nTm3NsJtiPsDH+FBM9UAwdj0DjUIdLynYm1aiQLLVZrf0dMQTkC4Q6sM7Y1e06az5iRd0RO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SXsuXKUo; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB50Ll1031499;
	Tue, 11 Nov 2025 16:34:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=F989jz
	5247bYLcZgPAyIEz+NOWuM7E2LUzujjrc1yiI=; b=SXsuXKUoj5q11EYGszU06B
	qbTbZsmMrHvAI0YM2yESR1XVXTtLRaQ8h9hi4reftINAx1xE9Y1IeajrMXEdigAv
	u6Jr73lIFyDXmf/Ff9hRurr6dafFGYP5tEMbWqN9ECGXW5wM+fF8lzRn3ZXN7z2K
	EJbkxNBrhEGH7264XQ7aLX3UrsHL7a9+gWBxQGUkO0YAkmgI2Din2FaxYJOSO4Np
	kpFMjJjQfmnkzhV4bAoFlU4bc4MC92JkMixenZLVg7rd49VM2lX4Oy6WNn/M57Tj
	8323lmpKscw6Y4rJD11YGRyayX4Vp5d6XLXzbaal/fOdayCIEZS2gC8s4EtBgg2A
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wk86624-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 16:34:12 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABE1i5g008260;
	Tue, 11 Nov 2025 16:34:11 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aah6muq9c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 16:34:11 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5ABGY7RA43188480
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 16:34:07 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 77D542004F;
	Tue, 11 Nov 2025 16:34:07 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B423320040;
	Tue, 11 Nov 2025 16:34:06 +0000 (GMT)
Received: from darkmoore (unknown [9.87.148.94])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Nov 2025 16:34:06 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 11 Nov 2025 17:34:00 +0100
Message-Id: <DE60E769OKA9.WHUN623MD8L1@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
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
To: "Janosch Frank" <frankja@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC v2 08/11] KVM: s390: Allow guest-3 cpu add and
 remove with vsie sigpif
X-Mailer: aerc 0.20.1
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
 <20251110-vsieie-v2-8-9e53a3618c8c@linux.ibm.com>
 <1a694540-3e7b-4453-8f7f-294eaf904afe@linux.ibm.com>
In-Reply-To: <1a694540-3e7b-4453-8f7f-294eaf904afe@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAyMiBTYWx0ZWRfX1k8bkjwE85eL
 wVUiOuzABlc+R/5qO5AUOwgVYdwtdO+MUWRZ4OrxU+UMklkEt057XEY/Nu75kE1q23X7In4v8Bz
 8Qf9HsHl+nDcGBxCP9mBW78giqTbB1SLHcD/cnUVzZrsg1HHJMz3KCOWP7PWd9Y/gH/uS4nFuu7
 NDbKWfVVLdr5bK4wUXpBvXdE9ZZnJY5gJxEHVGArWFhOB/h3pUdFKmbmHS57hId0fKgdv0NIKzd
 1/J06xDZYNvhO3/5t/pKA4105453XElUWwN7ZFb7wFXT7c1tInXerF2u5gL6bShU3aWBf+KK0V7
 MPFYBwYEFepYOwHs30nU4dbOxCNwxObVqGqyl+tjAvkzdISPUC2veaeaguxxuDf7vzvjiZuGxHv
 Y/YHsY3EAPOUci6+LZB9nyJn+G/Wkw==
X-Authority-Analysis: v=2.4 cv=ZK3aWH7b c=1 sm=1 tr=0 ts=69136584 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=xPGm2OtmPOwl28xsW98A:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: QkSBlm8BfwkJWNOINIoP2vPmdYt2GxFr
X-Proofpoint-GUID: QkSBlm8BfwkJWNOINIoP2vPmdYt2GxFr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_02,2025-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511080022

On Tue Nov 11, 2025 at 4:47 PM CET, Janosch Frank wrote:
> On 11/10/25 18:16, Christoph Schlameuss wrote:
>> As we are shadowing the SCA we need to add and remove the pointers to
>> the shadowed control blocks and sca entries whenever the mcn changes.
>>=20
>> It is not expected that the mcn changes frequently for a already running
>> guest-3 configuration. So we can simply re-init the ssca whenever the
>> mcn changes.
>> To detect the mcn change we store the expected mcn in the struct
>> vsie_sca when running the ssca init.
>>=20
>> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
>> ---
>>   arch/s390/kvm/vsie.c | 20 ++++++++++++++++++--
>>   1 file changed, 18 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>> index 72c794945be916cc107aba74e1609d3b4780d4b9..1e15220e1f1ecfd83b10aa06=
20ca84ff0ff3c1ac 100644
>> --- a/arch/s390/kvm/vsie.c
>> +++ b/arch/s390/kvm/vsie.c
>> @@ -1926,12 +1926,27 @@ static int init_ssca(struct kvm_vcpu *vcpu, stru=
ct vsie_page *vsie_page, struct
>>   	return PTR_ERR(vsie_page_n);
>>   }
>>  =20
>> +static bool sca_mcn_equals(struct vsie_sca *sca, u64 *mcn)
>> +{
>> +	bool is_esca =3D test_bit(VSIE_SCA_ESCA, &sca->flags);
>> +	int i;
>> +
>> +	if (!is_esca)
>> +		return ((struct bsca_block *)phys_to_virt(sca->ssca->osca))->mcn =3D=
=3D *mcn;
>> +
>> +	for (i =3D 0; i < 4; i++)
>> +		if (((struct esca_block *)phys_to_virt(sca->ssca->osca))->mcn[i] !=3D=
 sca->mcn[i])
>> +			return false;
>
> You're reimplementing memcmp(), no?
> Instead of casting which makes the comparison really messy you could use=
=20
> offsetof.
>
> Something like this (+- errors):
>
> void *osca =3D phys_to_virt(sca->ssca->osca);
> int offset =3D offsetof(struct bsca_block, mcn);
> int size =3D 8;
>
> if (test_bit(VSIE_SCA_ESCA, &sca->flags)) {
> 	size =3D 8 * 4;
> 	offset =3D offsetof(struct esca_block, mcn);
> }
>
> return !memcmp(osca + offset, mcn, size);
>
>

Yes, that is exactly what it is. Will use your proposal instead.

>> +	return true;
>> +}
>> +
>>   /*
>>    * Shadow the sca on vsie enter.
>>    */
>>   static int shadow_sca(struct kvm_vcpu *vcpu, struct vsie_page *vsie_pa=
ge, struct vsie_sca *sca)
>>   {
>>   	struct kvm_s390_sie_block *scb_s =3D &vsie_page->scb_s;
>> +	bool do_init_ssca;
>>   	int rc;
>>  =20
>>   	vsie_page->sca =3D sca;
>> @@ -1947,8 +1962,9 @@ static int shadow_sca(struct kvm_vcpu *vcpu, struc=
t vsie_page *vsie_page, struct
>>   	if (!use_vsie_sigpif_for(vcpu->kvm, vsie_page))
>>   		return false;
>>  =20
>> -	/* skip if the guest does not have an usable sca */
>> -	if (!sca->ssca->osca) {
>> +	do_init_ssca =3D !sca->ssca->osca;
>> +	do_init_ssca =3D do_init_ssca || !sca_mcn_equals(sca, sca->mcn);
>> +	if (do_init_ssca) {
>>   		rc =3D init_ssca(vcpu, vsie_page, sca);
>>   		if (rc)
>>   			return rc;
>>=20


