Return-Path: <kvm+bounces-62773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 277FAC4E988
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 15:52:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB4023BC6A3
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 14:42:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3046D3396FE;
	Tue, 11 Nov 2025 14:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cBLxYscf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79ED3385B8;
	Tue, 11 Nov 2025 14:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762871880; cv=none; b=H6zyza2rQEDagi8x80EjApewLcfyYO2Y218Xkh8qzZJEjub/MHpxy+0qvkRit04+koIHBmHQNHQcM+gNfLJL0DIYGRR3dLhGh4jg86UIPHcb8Ib6eNt3Hqid/WcgZFKLS9YbF29g6Vok2nKPW7kRFIrjmaoZWC+YIKsNgi7OPGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762871880; c=relaxed/simple;
	bh=fpM4rZm2eTFj5lA0ILdXZXAm1QmHZWdHUdT36ODYhpU=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=FrU8eLfU9kfk2Dik1jdtcpSycDBcJozo8d9CDm4zfx+a/w1hCFOAbXzn8vFhXMBoFOKy8zLCcOny90U1MYxxtu4fVK9wepPytbsZZYAWv6Uu3zRdfFLdNn+Ud8hXolFEkym9OqvlZz1ZYMTFUkFPLC6WRoDMNfgsYTTf9BFotdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cBLxYscf; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB377lt016772;
	Tue, 11 Nov 2025 14:37:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JyOEWN
	2IWol6MDam6GH2q2lnGc1owVcKuC9mQE4g/Y4=; b=cBLxYscf6ER9HxoLJHXeyY
	ty42DGawV+mqA2ihBvnPfh0JSUmcjYOHFFlNVYeSOqX0on1nSrK+uOpPUe6bXi9L
	k9nCmggE8KQ7/XIAwK7omA2qYCQd8KdOTLY19agipshUN9McBbN8oIn3x+NXNPqA
	2nmCHYi7JBvUCPM02a7dYVMcOEVZEf9HGDtBpI01F2Req6M0tYEGerjZutmcGUro
	x1PbSfJ8eTM0IdaAgd35sEb5axddyXbyuVD2mW89YjRuZdH3rwoR6l4GGUqvyR1h
	tITJ/QW9FXEVM+5129V4XSaLcd3nWIxULc9s1iZ2HmTHeshmMEX+AZ5LZ81akEig
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5cj4dgd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 14:37:54 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABDl8m6007313;
	Tue, 11 Nov 2025 14:37:53 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aajdjb0ph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 14:37:53 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5ABEbnNj16056730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 14:37:49 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C83B320043;
	Tue, 11 Nov 2025 14:37:49 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 92A9120040;
	Tue, 11 Nov 2025 14:37:49 +0000 (GMT)
Received: from darkmoore (unknown [9.111.33.212])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Nov 2025 14:37:49 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 11 Nov 2025 15:37:44 +0100
Message-Id: <DE5XX691NDPL.23EQ56H2AP7CK@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        "Heiko Carstens"
 <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander
 Gordeev" <agordeev@linux.ibm.com>,
        "Christian Borntraeger"
 <borntraeger@linux.ibm.com>,
        "Janosch Frank" <frankja@linux.ibm.com>,
        "Nico
 Boehr" <nrb@linux.ibm.com>,
        "David Hildenbrand" <david@redhat.com>,
        "Sven
 Schnelle" <svens@linux.ibm.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>, "Shuah Khan" <shuah@kernel.org>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>
Subject: Re: [PATCH RFC v2 01/11] KVM: s390: Add SCAO read and write helpers
X-Mailer: aerc 0.20.1
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
 <20251110-vsieie-v2-1-9e53a3618c8c@linux.ibm.com>
 <20251111144511.64450b0e@p-imbrenda>
In-Reply-To: <20251111144511.64450b0e@p-imbrenda>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Ss+dKfO0 c=1 sm=1 tr=0 ts=69134a42 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=F1t4R9oC0O7z7MunMTsA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA5NSBTYWx0ZWRfX8Tebmb6YcY6s
 RL0Sj9qi+LUEEYxfUp0i3y1UfpHSIwTuqMadsjQ6Letb1W8lJsf6bbh3jLeVkaezkAfOx4m1zmm
 46smpans+AkYQZq1IuHuiqWTt7J1V7lLbgo0ZOKFwb9NUt8jZW6JAWZ4tBhZsCTEABvmfFBW1hs
 tQv8o5qLDmyYCtvA4hiWETqVxmynBEmEtUvUvBaMY6FhSqcBnf1VsZ61E13bh0xjfFuZnUmPhQy
 F2SPRvzeciFmu+5kvKot5silWctuyzjzhyIgWdKcdar3fthu5c8lvGAbxZJrBlXnKJBCOcCJZER
 rCtgAwDoMWWc28+NmpcOrQIvv4iplYWIeHimHm8B74vEDyw0ao4gPYkM4farshgMBkF+tns2l5M
 cJcYXvtPR5Uuem1XCY73D+eTTZbdpg==
X-Proofpoint-GUID: UYLt-63Dy6Yti-VvDvi0tU-RpLlkehKO
X-Proofpoint-ORIG-GUID: UYLt-63Dy6Yti-VvDvi0tU-RpLlkehKO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_02,2025-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080095

On Tue Nov 11, 2025 at 2:45 PM CET, Claudio Imbrenda wrote:
> On Mon, 10 Nov 2025 18:16:41 +0100
> Christoph Schlameuss <schlameuss@linux.ibm.com> wrote:
>
>> Introduce some small helper functions to get and set the system control
>> area origin address from the SIE control block.
>>=20
>> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
>> ---
>>  arch/s390/kvm/vsie.c | 29 +++++++++++++++++++++--------
>>  1 file changed, 21 insertions(+), 8 deletions(-)
>>=20
>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>> index 347268f89f2f186bea623a3adff7376cabc305b2..ced2ca4ce5b584403d900ed1=
1cb064919feda8e9 100644
>> --- a/arch/s390/kvm/vsie.c
>> +++ b/arch/s390/kvm/vsie.c
>> @@ -123,6 +123,23 @@ static int prefix_is_mapped(struct vsie_page *vsie_=
page)
>>  	return !(atomic_read(&vsie_page->scb_s.prog20) & PROG_REQUEST);
>>  }
>> =20
>> +static gpa_t read_scao(struct kvm *kvm, struct kvm_s390_sie_block *scb)
>> +{
>> +	gpa_t sca;
>
> is it, though?
>
>> +
>> +	sca =3D READ_ONCE(scb->scaol) & ~0xfUL;
>> +	if (test_kvm_cpu_feat(kvm, KVM_S390_VM_CPU_FEAT_64BSCAO))
>> +		sca |=3D (u64)READ_ONCE(scb->scaoh) << 32;
>
> this feels more like an hpa_t, which is what you also use in the
> function below
>

It actually can be either. Without vsie sigp this is a gpa for reading and
writing. With vsie sigp this is a gpa when reading and a hpa when writing
it. It might be best to not imply anything here but just use "unsigned long=
"
for these functions.

>> +
>> +	return sca;
>> +}
>> +
>> +static void write_scao(struct kvm_s390_sie_block *scb, hpa_t hpa)
>> +{
>> +	scb->scaoh =3D (u32)((u64)hpa >> 32);
>> +	scb->scaol =3D (u32)(u64)hpa;
>> +}
>> +
>>  /* copy the updated intervention request bits into the shadow scb */
>>  static void update_intervention_requests(struct vsie_page *vsie_page)
>>  {
>> @@ -714,12 +731,11 @@ static void unpin_blocks(struct kvm_vcpu *vcpu, st=
ruct vsie_page *vsie_page)
>>  	struct kvm_s390_sie_block *scb_s =3D &vsie_page->scb_s;
>>  	hpa_t hpa;
>> =20
>> -	hpa =3D (u64) scb_s->scaoh << 32 | scb_s->scaol;
>> +	hpa =3D read_scao(vcpu->kvm, scb_s);
>>  	if (hpa) {
>>  		unpin_guest_page(vcpu->kvm, vsie_page->sca_gpa, hpa);
>>  		vsie_page->sca_gpa =3D 0;
>> -		scb_s->scaol =3D 0;
>> -		scb_s->scaoh =3D 0;
>> +		write_scao(scb_s, 0);
>>  	}
>> =20
>>  	hpa =3D scb_s->itdba;
>> @@ -773,9 +789,7 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct =
vsie_page *vsie_page)
>>  	gpa_t gpa;
>>  	int rc =3D 0;
>> =20
>> -	gpa =3D READ_ONCE(scb_o->scaol) & ~0xfUL;
>> -	if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_64BSCAO))
>> -		gpa |=3D (u64) READ_ONCE(scb_o->scaoh) << 32;
>> +	gpa =3D read_scao(vcpu->kvm, scb_o);
>>  	if (gpa) {
>>  		if (gpa < 2 * PAGE_SIZE)
>>  			rc =3D set_validity_icpt(scb_s, 0x0038U);
>> @@ -792,8 +806,7 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct =
vsie_page *vsie_page)
>>  		if (rc)
>>  			goto unpin;
>>  		vsie_page->sca_gpa =3D gpa;
>> -		scb_s->scaoh =3D (u32)((u64)hpa >> 32);
>> -		scb_s->scaol =3D (u32)(u64)hpa;
>> +		write_scao(scb_s, hpa);
>>  	}
>> =20
>>  	gpa =3D READ_ONCE(scb_o->itdba) & ~0xffUL;
>>=20


