Return-Path: <kvm+bounces-41494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 882AAA691AA
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 15:56:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EA60464F5B
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 14:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA061DF973;
	Wed, 19 Mar 2025 14:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iHDn2wOS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBB91B4F17;
	Wed, 19 Mar 2025 14:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395292; cv=none; b=IglqrDThsU2APwQs8NN9Uh+TbuqMMVZV/feAYat6nEpVkrXYWjBViNoQmZZXJ/d1AvDEkZoMJnDzHlUVX9SYWccdyKG3XwS+8UmzJeDG5Z+fKjA4SGQwYJLpswLCM8+lGMdU0ZJ/fJd0wjfWhyUktVi0cBnbSTEx4/g2xNeB4h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395292; c=relaxed/simple;
	bh=D2VBA6BO/HpOhdKlKq+1hehXwWz3nWVv6q0TlNxhRJ8=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=J/cLd2/URu+RCFQ3SHix29ju7hYOA58zXHii3gUOqgtvwPt6X50PAQle+di6rcBbr6QNcYHfWC7sK6sWblBrd3bu4zebU4O62Ps1aADgeUeh8bKXoENeOKywKr8lJKBMevkknpCD8HknoVy99p/MbodH3lyYI/qIwwHpwQmPRak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iHDn2wOS; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52JE3QH4027546;
	Wed, 19 Mar 2025 14:41:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=DvSKAH
	Q3PTU+Z0ZoJmjiBwy85bxf19zi2A9UYM0srUc=; b=iHDn2wOSMC8jUkjeWUdxfj
	DO3QaHUolkX5PJD0FP48CrO/jQ/GYFERo5wLp9fSSgBuOSQtTBiqMCjBhKwxhOjs
	OS08Ml//+1AYQeyU527GWcJvWAm/vUA8FOnGlxXt5o+y1eCojI9yzxZYb2aCSJ8t
	trRj4UtoeDDfgz0QARDqUXrGveUSmrprHhxYXS2wT9DDIeiVrBrgmegVyoVyZe6I
	c49x6PyxGUPGOCLwA/E6HQf124eT6DIjzYZ4/cI3K9GeU4gDQ8yyErSd4oJ1FJVn
	j4pEVnhLE8olg7au94GtquxAuK341edjBh3qP7WNxk7N/xBXzkwIDBoQvlA3dGOQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45fybpr7fv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Mar 2025 14:41:27 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52JC2cas032356;
	Wed, 19 Mar 2025 14:41:27 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45dkvtjc5h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Mar 2025 14:41:26 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52JEfMg940829414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Mar 2025 14:41:23 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D95C82004B;
	Wed, 19 Mar 2025 14:41:22 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD1F620040;
	Wed, 19 Mar 2025 14:41:22 +0000 (GMT)
Received: from darkmoore (unknown [9.155.210.150])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 19 Mar 2025 14:41:22 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 19 Mar 2025 15:41:17 +0100
Message-Id: <D8KBKS9B7SHE.3AL1L7RDLM0IP@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>,
        "Claudio Imbrenda"
 <imbrenda@linux.ibm.com>,
        "Nico Boehr" <nrb@linux.ibm.com>,
        "David
 Hildenbrand" <david@redhat.com>,
        "Sven Schnelle" <svens@linux.ibm.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>, <linux-s390@vger.kernel.org>
To: "Janosch Frank" <frankja@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 3/5] KVM: s390: Shadow VSIE SCA in guest-1
X-Mailer: aerc 0.20.1
References: <20250318-vsieie-v1-0-6461fcef3412@linux.ibm.com>
 <20250318-vsieie-v1-3-6461fcef3412@linux.ibm.com>
 <47c6f4b7-b8a6-4b20-b915-1c4c2d9e7c74@linux.ibm.com>
In-Reply-To: <47c6f4b7-b8a6-4b20-b915-1c4c2d9e7c74@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _kq01GbqnjSp6Ya2Ugzulpkknr3AcM1N
X-Proofpoint-GUID: _kq01GbqnjSp6Ya2Ugzulpkknr3AcM1N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-19_05,2025-03-19_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=659
 suspectscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 impostorscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503190098

On Wed Mar 19, 2025 at 2:41 PM CET, Janosch Frank wrote:
> On 3/18/25 7:59 PM, Christoph Schlameuss wrote:
>> Introduce a new shadow_sca function into kvm_s390_handle_vsie.
>> kvm_s390_handle_vsie is called within guest-1 when guest-2 initiates the
>> VSIE.
>>=20
>> shadow_sca and unshadow_sca create and manage ssca_block structs in
>> guest-1 memory. References to the created ssca_blocks are kept within an
>> array and limited to the number of cpus. This ensures each VSIE in
>> execution can have its own SCA. Having the amount of shadowed SCAs
>> configurable above this is left to another patch.
>>=20
>> SCAOL/H in the VSIE control block are overwritten with references to the
>> shadow SCA. The original SCA pointer is saved in the vsie_page and
>> restored on VSIE exit. This limits the amount of change in the
>> preexisting VSIE pin and shadow functions.
>>=20
>> The shadow SCA contains the addresses of the original guest-3 SCA as
>> well as the original VSIE control blocks. With these addresses the
>> machine can directly monitor the intervention bits within the original
>> SCA entries.
>>=20
>> The ssca_blocks are also kept within a radix tree to reuse already
>> existing ssca_blocks efficiently. While the radix tree and array with
>> references to the ssca_blocks are held in kvm_s390_vsie.
>> The use of the ssca_blocks is tracked using an ref_count on the block
>> itself.
>>=20
>> No strict mapping between the guest-1 vcpu and guest-3 vcpu is enforced.
>> Instead each VSIE entry updates the shadow SCA creating a valid mapping
>> for all cpus currently in VSIE.
>>=20
>> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h |  22 +++-
>>   arch/s390/kvm/vsie.c             | 264 +++++++++++++++++++++++++++++++=
+++++++-
>>   2 files changed, 281 insertions(+), 5 deletions(-)
>>=20
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kv=
m_host.h
>> index 0aca5fa01f3d772c3b3dd62a22134c0d4cb9dc22..4ab196caa9e79e4c4d295d23=
fed65e1a142e6ab1 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -29,6 +29,7 @@
>>   #define KVM_S390_BSCA_CPU_SLOTS 64
>>   #define KVM_S390_ESCA_CPU_SLOTS 248
>>   #define KVM_MAX_VCPUS 255
>> +#define KVM_S390_MAX_VCPUS 256
>
> #define KVM_S390_SSCA_CPU_SLOTS 256
>
> Yes, I'm aware, that ESCA and MAX_VCPUS are pretty confusing.
> I'm searching for solutions but they might take a while.
>
>>  =20
>>   #define KVM_INTERNAL_MEM_SLOTS 1
>>  =20
>> @@ -137,13 +138,23 @@ struct esca_block {
>>  =20
>>   /*
>>    * The shadow sca / ssca needs to cover both bsca and esca depending o=
n what the
>> - * guest uses so we use KVM_S390_ESCA_CPU_SLOTS.
>> + * guest uses so we allocate space for 256 entries that are defined in =
the
>> + * architecture.
>>    * The header part of the struct must not cross page boundaries.
>>    */
>>   struct ssca_block {
>>   	__u64	osca;
>>   	__u64	reserved08[7];
>> -	struct ssca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];
>> +	struct ssca_entry cpu[KVM_S390_MAX_VCPUS];
>
> This should have been resolved in the previous patch, no?
>

Oops, yes, exactly.

>> +};
>> +
>> +/*
>> + * Store the vsie ssca block and accompanied management data.
>> + */
>> +struct ssca_vsie {
>> +	struct ssca_block ssca;			/* 0x0000 */
>> +	__u8	reserved[0x2200 - 0x2040];	/* 0x2040 */
>> +	atomic_t ref_count;			/* 0x2200 */
>>   };
>>  =20
>
> [...]
>
>>   void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, unsigned long star=
t,
>>   				 unsigned long end)
>>   {
>> @@ -699,6 +932,9 @@ static void unpin_blocks(struct kvm_vcpu *vcpu, stru=
ct vsie_page *vsie_page)
>>  =20
>>   	hpa =3D (u64) scb_s->scaoh << 32 | scb_s->scaol;
>>   	if (hpa) {
>> +		/* with vsie_sigpif scaoh/l was pointing to g1 ssca_block but
>> +		 * should have been reset in unshadow_sca()
>> +		 */
>
> There shouldn't be text in the first or last line of multi-line comments.
>

Will fix. Thx. (checkpatch seems to be fine with this, so I assume just in =
not
desired?)

>>   		unpin_guest_page(vcpu->kvm, vsie_page->sca_gpa, hpa);
>>   		vsie_page->sca_gpa =3D 0;
>>   		scb_s->scaol =3D 0;
>> @@ -775,6 +1011,9 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct=
 vsie_page *vsie_page)
>>   		if (rc)
>>   			goto unpin;
>>   		vsie_page->sca_gpa =3D gpa;
>> +		/* with vsie_sigpif scaoh and scaol will be overwritten
>> +		 * in shadow_sca to point to g1 ssca_block instead
>> +		 */
>
> Same
>
>>   		scb_s->scaoh =3D (u32)((u64)hpa >> 32);
>>   		scb_s->scaol =3D (u32)(u64)hpa;
>>   	}
>> @@ -1490,12 +1729,17 @@ int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
>>   		goto out_unpin_scb;
>>   	rc =3D pin_blocks(vcpu, vsie_page);
>>   	if (rc)
>> -		goto out_unshadow;
>> +		goto out_unshadow_scb;
>> +	rc =3D shadow_sca(vcpu, vsie_page);
>> +	if (rc)
>> +		goto out_unpin_blocks;
>>   	register_shadow_scb(vcpu, vsie_page);
>>   	rc =3D vsie_run(vcpu, vsie_page);
>>   	unregister_shadow_scb(vcpu);
>
> For personal preference I'd like to have a \n here to visually separate=
=20
> the cleanup from the rest of the code.
>

Sure. Will insert that.

>> +	unshadow_sca(vcpu, vsie_page);
>> +out_unpin_blocks:
>>   	unpin_blocks(vcpu, vsie_page);
>> -out_unshadow:
>> +out_unshadow_scb:
>>   	unshadow_scb(vcpu, vsie_page);
>>   out_unpin_scb:
>>   	unpin_scb(vcpu, vsie_page, scb_addr);
>> @@ -1510,12 +1754,15 @@ void kvm_s390_vsie_init(struct kvm *kvm)
>>   {
>>   	mutex_init(&kvm->arch.vsie.mutex);
>>   	INIT_RADIX_TREE(&kvm->arch.vsie.addr_to_page, GFP_KERNEL_ACCOUNT);
>> +	init_rwsem(&kvm->arch.vsie.ssca_lock);
>> +	INIT_RADIX_TREE(&kvm->arch.vsie.osca_to_ssca, GFP_KERNEL_ACCOUNT);
>>   }
>>  =20
>>   /* Destroy the vsie data structures. To be called when a vm is destroy=
ed. */
>>   void kvm_s390_vsie_destroy(struct kvm *kvm)
>>   {
>>   	struct vsie_page *vsie_page;
>> +	struct ssca_vsie *ssca;
>>   	int i;
>>  =20
>>   	mutex_lock(&kvm->arch.vsie.mutex);
>> @@ -1531,6 +1778,17 @@ void kvm_s390_vsie_destroy(struct kvm *kvm)
>>   	}
>>   	kvm->arch.vsie.page_count =3D 0;
>>   	mutex_unlock(&kvm->arch.vsie.mutex);
>> +
>> +	down_write(&kvm->arch.vsie.ssca_lock);
>> +	for (i =3D 0; i < kvm->arch.vsie.ssca_count; i++) {
>> +		ssca =3D kvm->arch.vsie.sscas[i];
>> +		kvm->arch.vsie.sscas[i] =3D NULL;
>> +		radix_tree_delete(&kvm->arch.vsie.osca_to_ssca,
>> +				  (u64)phys_to_virt(ssca->ssca.osca));
>> +		free_pages((unsigned long)ssca, SSCA_PAGEORDER);
>> +	}
>> +	kvm->arch.vsie.ssca_count =3D 0;
>> +	up_write(&kvm->arch.vsie.ssca_lock);
>>   }
>>  =20
>>   void kvm_s390_vsie_kick(struct kvm_vcpu *vcpu)
>>=20


