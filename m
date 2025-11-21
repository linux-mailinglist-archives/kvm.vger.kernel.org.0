Return-Path: <kvm+bounces-64156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 473E0C7A783
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 16:19:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EC5834EE0F1
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 15:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AB482D9EDD;
	Fri, 21 Nov 2025 15:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="h03wW9gY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2948A288C86;
	Fri, 21 Nov 2025 15:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763737866; cv=none; b=JfM9CboLFdY6jG8DP4Wpg4+O8/JRHA6AggFDh/YU0X7I/1ikxQpaQ3dMHr8W8wHgs4t0vYQ5bZsPClJT6hAWASMtZUyTpfAJsGq5vB+AW8WQ0gthY9gy52PrBvw1dB91oB7ZwnCXFn63WOA0d0NqCNVBkCAVxLPIjdyaWyBA6VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763737866; c=relaxed/simple;
	bh=Gbi8Ncy5CZiM7aZnnYqb5XfnQM+zGFpFUb1CSpVAYHA=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:Cc:To:
	 References:In-Reply-To; b=gQwSR8TLfw1TlVetwt4O1Pzvlk2ijX76nP0MxhxZJQJrNYPfB3isMFPR3XiLTIU05CDfPJ3QYO9js37q40ZTNpa+pxH0fqwjHyUpuupz8jprEbyqUEizKRKqZWe2qaNs2YrZFWel/gvqvwCFEVCmOw0uCIAW1Np84NhyPwsB5m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=h03wW9gY; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALEWURX023454;
	Fri, 21 Nov 2025 15:10:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=UBZWGq
	6deHy/W5Je0L4Ak+pL2cvdRhOVS+aEBwQhdQk=; b=h03wW9gYrsh+w/sVs/SxhP
	Bx76prxrLXvkg0t2iXjfSJyEibXqI90Rro0X5PViimyLsOt/5JF5WUV+ki+YcRLM
	wjykfsSewe/kyJAlnCbZl5n+rKZEeNoBJnAUv+j64d1JnbPnlAq9ZvwrKlApI6fm
	odZpQnQ0Dh1w26W7wmAO9pE+eVbOlP559pLMs8EZbuBlQx4LYivlQACHX04KeGFw
	CdPvZV7M8CeE60AHTIITtAyMriptlQoV36DQnobYhko/KfL1AymZwJU6KW8QmLPe
	RPC0wl7+7Ywb1v5bELRP8wKcN5teG3DF2T7i3+ttNU5ijLNjp2vaYP6d6fltW+dw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejk1vpjh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Nov 2025 15:10:53 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALCL3Pd005065;
	Fri, 21 Nov 2025 15:10:52 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af5bkmtjt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Nov 2025 15:10:51 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5ALFAlmk11469126
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 15:10:47 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A090620043;
	Fri, 21 Nov 2025 15:10:47 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7309020040;
	Fri, 21 Nov 2025 15:10:47 +0000 (GMT)
Received: from darkmoore (unknown [9.111.24.50])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 21 Nov 2025 15:10:47 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 21 Nov 2025 16:10:42 +0100
Message-Id: <DEEGVV2BJUF7.3QYGABJQ3HMV9@linux.ibm.com>
Subject: Re: [PATCH RFC v2 07/11] KVM: s390: Shadow VSIE SCA in guest-1
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
To: "Janosch Frank" <frankja@linux.ibm.com>,
        "Christoph Schlameuss"
 <schlameuss@linux.ibm.com>,
        <kvm@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
 <20251110-vsieie-v2-7-9e53a3618c8c@linux.ibm.com>
 <0bd2c3f1-211e-41b3-a3ce-8d9ccfe2b1c0@linux.ibm.com>
In-Reply-To: <0bd2c3f1-211e-41b3-a3ce-8d9ccfe2b1c0@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=C/nkCAP+ c=1 sm=1 tr=0 ts=692080fd cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=zLEXaDGtvme6yjfbcSsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: dvf_s_gMTIPbHJ1bUieaeVi7a2q2ldNr
X-Proofpoint-ORIG-GUID: dvf_s_gMTIPbHJ1bUieaeVi7a2q2ldNr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXwKwwDkDPytOU
 DUQdSS4013ymppv34Rmkc6dNder8nM0qthgdLF4UbkArMj5vi7SBxYflZaAsGAMXE/5sVMTX4VH
 T7CP4rQ9JHRMlCpVtsoGwCXpTrS3stfSe9yugDjLM5gJGQEZmLeKObjVvX210m5hXu9oZTzjbHP
 gG15uh+ObQoKZ35JOrnGrLYXQhvA7t9iPWW5oarqPGNBxNqcEqSeD2+i40EdF5yz0kniGwfOtzo
 hqhWhWmq8I5j0JAix6+jU45c/pxLI3nw6o/KZoszVUL/JkjcQaZXG+fMf13sD5EGzsRl68qLYli
 iReOfTXBLIj2XEE1qfRnt52SIRSCEu5lMS33nf4J1t5h9rrPtvR74itbtrgepeRoAEtWl98RDxq
 OfMJDZ8FrdIyIkX6sm9FgUR+afSS6Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_03,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 spamscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

On Tue Nov 18, 2025 at 5:04 PM CET, Janosch Frank wrote:
> On 11/10/25 18:16, Christoph Schlameuss wrote:
>> Restructure kvm_s390_handle_vsie() to create a guest-1 shadow of the SCA
>> if guest-2 attempts to enter SIE with an SCA. If the SCA is used the
>> vsie_pages are stored in a new vsie_sca struct instead of the arch vsie
>> struct.
>>=20
>> When the VSIE-Interpretation-Extension Facility is active (minimum z17)
>> the shadow SCA (ssca_block) will be created and shadows of all CPUs
>> defined in the configuration are created.
>> SCAOL/H in the VSIE control block are overwritten with references to the
>> shadow SCA.
>>=20
>> The shadow SCA contains the addresses of the original guest-3 SCA as
>> well as the original VSIE control blocks. With these addresses the
>> machine can directly monitor the intervention bits within the original
>> SCA entries, enabling it to handle SENSE_RUNNING and EXTERNAL_CALL sigp
>> instructions without exiting VSIE.
>>=20
>> The original SCA will be pinned in guest-2 memory and only be unpinned
>> before reuse. This means some pages might still be pinned even after the
>> guest 3 VM does no longer exist.
>>=20
>> The ssca_blocks are also kept within a radix tree to reuse already
>> existing ssca_blocks efficiently. While the radix tree and array with
>> references to the ssca_blocks are held in the vsie_sca struct.
>> The use of vsie_scas is tracked using an ref_count.
>>=20
>> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h       |  11 +-
>>   arch/s390/include/asm/kvm_host_types.h |   5 +-
>>   arch/s390/kvm/kvm-s390.c               |   6 +-
>>   arch/s390/kvm/kvm-s390.h               |   2 +-
>>   arch/s390/kvm/vsie.c                   | 672 +++++++++++++++++++++++++=
+++-----
>>   5 files changed, 596 insertions(+), 100 deletions(-)
>>=20
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kv=
m_host.h
>> index 647014edd3de8abc15067e7203c4855c066c53ad..191b23edf0ac7e9a3e1fd9cd=
c6fc4c9a9e6769f8 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -597,13 +597,22 @@ struct sie_page2 {
>>   };
>>  =20
>>   struct vsie_page;
>> +struct vsie_sca;
>>  =20
>> +/*
>> + * vsie_pages, scas and accompanied management vars
>> + */
>>   struct kvm_s390_vsie {
>>   	struct mutex mutex;
>>   	struct radix_tree_root addr_to_page;
>>   	int page_count;
>>   	int next;
>> -	struct vsie_page *pages[KVM_MAX_VCPUS];
>> +	struct vsie_page *pages[KVM_S390_MAX_VSIE_VCPUS];
>> +	struct rw_semaphore ssca_lock;
>
> Might make sense to name it sca_lock, since we're not locking sscas.
>
>> +	struct radix_tree_root osca_to_sca;
>> +	int sca_count;
>> +	int sca_next;
>> +	struct vsie_sca *scas[KVM_S390_MAX_VSIE_VCPUS];
>>   };
>>  =20
>
> [...]
>
>> +
>> +/*
>> + * Pin and get an existing or new guest system control area.
>> + *
>> + * May sleep.
>> + */
>> +static struct vsie_sca *get_vsie_sca(struct kvm_vcpu *vcpu, struct vsie=
_page *vsie_page,
>> +				     gpa_t sca_addr)
>> +{
>> +	struct vsie_sca *sca, *sca_new =3D NULL;
>> +	struct kvm *kvm =3D vcpu->kvm;
>> +	unsigned int max_sca;
>> +	int rc;
>> +
>> +	rc =3D validate_scao(vcpu, vsie_page->scb_o, vsie_page->sca_gpa);
>> +	if (rc)
>> +		return ERR_PTR(rc);
>> +
>> +	/* get existing sca */
>> +	down_read(&kvm->arch.vsie.ssca_lock);
>> +	sca =3D get_existing_vsie_sca(kvm, sca_addr);
>> +	up_read(&kvm->arch.vsie.ssca_lock);
>> +	if (sca)
>> +		return sca;
>> +
>> +	/*
>> +	 * Allocate new ssca, it will likely be needed below.
>> +	 * We want at least #online_vcpus shadows, so every VCPU can execute t=
he
>> +	 * VSIE in parallel. (Worst case all single core VMs.)
>> +	 */
>
> We're allocating an SCA and then its SSCA.
>

Fixed.

>> +	max_sca =3D MIN(atomic_read(&kvm->online_vcpus), KVM_S390_MAX_VSIE_VCP=
US);
>> +	if (kvm->arch.vsie.sca_count < max_sca) {
>> +		BUILD_BUG_ON(sizeof(struct vsie_sca) > PAGE_SIZE);
>> +		sca_new =3D (void *)__get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>> +		if (!sca_new)
>> +			return ERR_PTR(-ENOMEM);
>> +
>> +		if (use_vsie_sigpif(vcpu->kvm)) {
>> +			BUILD_BUG_ON(offsetof(struct ssca_block, cpu) !=3D 64);
>> +			sca_new->ssca =3D alloc_pages_exact(sizeof(*sca_new->ssca),
>> +							  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>> +			if (!sca_new->ssca) {
>> +				free_page((unsigned long)sca);
>
> Shouldn't this be sca_new which we just allocated?
> I think it might have been a mistake to have both sca and sca_new in=20
> this function even though I understand why you need it.
>

Yes it should. But I did already simplify this nested allocation into a sin=
gle
allocation for the next version. So it will be simpler.

>> +				sca_new =3D NULL;
>
> Why?
> We're returning in the next line.
>

Only out of an abundance of cleanup. Will remove these for local variables =
in
error paths.

>> +				return ERR_PTR(-ENOMEM);
>> +			}
>> +		}
>> +	}
>
> How about something like:
>
> Now we're taking the ssca lock in write mode so that we can manipulate=20
> the radix tree and recheck for existing scas with exclusive access.
>
> In the next lines we try three things to get an SCA:
>   - Retry getting an existing SCA
>   - Using our newly allocated SCA if we're under the limit
>   - Reusing an SCA with a different osca
>

Yes, that is a good description. And I see that this is a bit tricky to
understand to warrant that. Thanks.

>> +
>> +	/* enter write lock and recheck to make sure ssca has not been created=
 by other cpu */
>> +	down_write(&kvm->arch.vsie.ssca_lock);
>> +	sca =3D get_existing_vsie_sca(kvm, sca_addr);
>> +	if (sca)
>> +		goto out;
>> +
>> +	/* check again under write lock if we are still under our sca_count li=
mit */
>> +	if (sca_new && kvm->arch.vsie.sca_count < max_sca) {
>> +		/* make use of vsie_sca just created */
>> +		sca =3D sca_new;
>> +		sca_new =3D NULL;
>> +
>> +		kvm->arch.vsie.scas[kvm->arch.vsie.sca_count] =3D sca;
>> +	} else {
>> +		/* reuse previously created vsie_sca allocation for different osca */
>> +		sca =3D get_free_existing_vsie_sca(kvm);
>> +		/* with nr_vcpus scas one must be free */
>> +		if (IS_ERR(sca))
>> +			goto out;
>> +
>> +		unpin_sca(kvm, sca);
>> +		radix_tree_delete(&kvm->arch.vsie.osca_to_sca, sca->sca_gpa);
>> +		memset(sca, 0, sizeof(struct vsie_sca));

