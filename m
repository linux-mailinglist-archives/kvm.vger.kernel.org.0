Return-Path: <kvm+bounces-64343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 12525C800B6
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 11:59:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B785B342BA9
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 10:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55A112FB989;
	Mon, 24 Nov 2025 10:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="M3xCB+Fe"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EFB2EFD9F;
	Mon, 24 Nov 2025 10:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763981967; cv=none; b=r9s/T5N/PsBd7+rfEI4pfQpHWhrjgOELZ0kJ/QEGRa0LhuJYm+qSmbZ+frhBpPRO1N5Om6YW2o9iH0hBXCeqYFFAT0hxxaJNZKtRVmHmgkwtN2D7ZS2i40DsCoECMv/aTMnqOeC5Zuamb0PrI/kKTDNh1Vdni9PMks+g9ySiG58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763981967; c=relaxed/simple;
	bh=wcZg11RZUES8YmKnaXOp6YTp39+g7OJyQs9ej2T9ssk=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=r6w8K64pP63iw8PX1pzon9Fox+hOiU6QufbXn0rtpVd8WT7dQYKb/BFNmQ8T+SENWF2EczIToVaIGQ3QgouoheMZYB0XpDo8g+TGfAC0qHeFg0daqIqm6JlEf5xcErfBEj29Siiuzhl/yI2JfbvY/9ZJB9kDd6dHq3xg90SMwzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=M3xCB+Fe; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO7RUll018154;
	Mon, 24 Nov 2025 10:59:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=f78FA6
	2+m7CMNqKF2K7jMVi/lf8JzQwBBajRO6X1+1U=; b=M3xCB+Feqatd7cnomau73V
	tDSbVyXFL+WmuPMo0EmLodkfv02XX+xkekMfpl2xYuQHI+uxqxlfLXvDpkMYdq8p
	4MBUPRiDnxADh82PlmbEgw/K/1FtxDCuN52TrNEGYSvuINA4NvazracB2dtShSp8
	/RoyCJcjj9iWmStVu5VzOGw5eKvFIggpes5DtYA49pz2RwlEpg/Dw50hjmm8Y2gD
	BaTKAaIpoKWSP4UYXOxcdyqmWsX4Un6sTNCCpolL+Wsr2RBUTAiT2uB2LkxpiXNz
	4vyZpGdT89V3KF/7cRa4CxlaCAJ7GBS6GDGKaBwt1HwfG9rtZj7CjcpENxFnLucw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak2kpqfh3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 10:59:21 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO88CLG018996;
	Mon, 24 Nov 2025 10:59:20 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aksqjd8f2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 10:59:20 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AOAxGPC30409116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 10:59:16 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9657320043;
	Mon, 24 Nov 2025 10:59:16 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5937D20040;
	Mon, 24 Nov 2025 10:59:16 +0000 (GMT)
Received: from darkmoore (unknown [9.111.94.126])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Nov 2025 10:59:16 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 24 Nov 2025 11:59:11 +0100
Message-Id: <DEGVEX4N3B0M.23FKGJG23E91K@linux.ibm.com>
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
Subject: Re: [PATCH RFC v2 11/11] KVM: s390: Add VSIE shadow stat counters
X-Mailer: aerc 0.21.0
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
 <20251110-vsieie-v2-11-9e53a3618c8c@linux.ibm.com>
 <c9264abb-4bcc-498b-adf9-1167d519b254@linux.ibm.com>
In-Reply-To: <c9264abb-4bcc-498b-adf9-1167d519b254@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAwMCBTYWx0ZWRfX49t06ztVxyXt
 XMDCMnLF3NiFNdHXgHjeyOoLmwBvh68P6N3gEsDGuF1f4EDJof2UDCcx2wo3Ni9aoOjt1L9GlGx
 k9Ivibg90EOladJjwc3YaGYs882D8wY0cnG7RqQh6uAXnXPX29UsRI54czcOG3NEKEH3RmmAAJB
 9I+GyWiq1trvGlmPtXhBsTOkVzY4UHGWRjZl8KfjFoV1JK+RICR7iJc28S5jHcZRc34tfT+KvxO
 +o3z7TUhRT41jhN8HH8GTodAti9nZRvF4s491U7FdzQ87tE1BcnAMOSuAC0zVbBtr3sEkzFuEm1
 WBbvDa/Xc1cH32rbrQ1L9+pJwxz8eO+2s9DMCz6JvPvCk/v6uAd+evm8ZVNrLcwQc12QIATW4TW
 wGYg3xlJDxJwyVbtimXiMbSpqxRVnA==
X-Authority-Analysis: v=2.4 cv=fJM0HJae c=1 sm=1 tr=0 ts=69243a89 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=uSb5l8NPJHgLTqABBf0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: KsC6ws1DnIiclHcsoY7C_3iIppcAqMg-
X-Proofpoint-ORIG-GUID: KsC6ws1DnIiclHcsoY7C_3iIppcAqMg-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220000

On Thu Nov 20, 2025 at 12:07 PM CET, Janosch Frank wrote:
> On 11/10/25 18:16, Christoph Schlameuss wrote:
>> Add new stat counters to VSIE shadowing to be able to verify and monitor
>> the functionality.
>>=20
>> * vsie_shadow_scb shows the number of allocated SIE control block
>>    shadows. Should count upwards between 0 and the max number of cpus.
>> * vsie_shadow_sca shows the number of allocated system control area
>>    shadows. Should count upwards between 0 and the max number of cpus.
>> * vsie_shadow_sca_create shows the number of newly allocated system
>>    control area shadows.
>> * vsie_shadow_sca_reuse shows the number of reused system control area
>>    shadows.
>>=20
>> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h | 4 ++++
>>   arch/s390/kvm/kvm-s390.c         | 4 ++++
>>   arch/s390/kvm/vsie.c             | 9 ++++++++-
>>   3 files changed, 16 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kv=
m_host.h
>> index 191b23edf0ac7e9a3e1fd9cdc6fc4c9a9e6769f8..ef7bf2d357f8d289b5f163ec=
95976c5d270d1380 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -457,6 +457,10 @@ struct kvm_vm_stat {
>>   	u64 gmap_shadow_r3_entry;
>>   	u64 gmap_shadow_sg_entry;
>>   	u64 gmap_shadow_pg_entry;
>> +	u64 vsie_shadow_scb;
>> +	u64 vsie_shadow_sca;
>> +	u64 vsie_shadow_sca_create;
>> +	u64 vsie_shadow_sca_reuse;
>>   };
>>  =20
>>   struct kvm_arch_memory_slot {
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index e3fc53e33e90be7dab75f73ebd0b949c13d22939..d86bf2206c230ce25fd48610=
c8305326e260e590 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -79,6 +79,10 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] =3D =
{
>>   	STATS_DESC_COUNTER(VM, gmap_shadow_r3_entry),
>>   	STATS_DESC_COUNTER(VM, gmap_shadow_sg_entry),
>>   	STATS_DESC_COUNTER(VM, gmap_shadow_pg_entry),
>> +	STATS_DESC_COUNTER(VM, vsie_shadow_scb),
>> +	STATS_DESC_COUNTER(VM, vsie_shadow_sca),
>> +	STATS_DESC_COUNTER(VM, vsie_shadow_sca_create),
>> +	STATS_DESC_COUNTER(VM, vsie_shadow_sca_reuse),
>>   };
>>  =20
>>   const struct kvm_stats_header kvm_vm_stats_header =3D {
>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>> index cd114df5e119bd289d14037d1f1c5bfe148cf5c7..f7c1a217173cefe93d091462=
3df08efa14270771 100644
>> --- a/arch/s390/kvm/vsie.c
>> +++ b/arch/s390/kvm/vsie.c
>> @@ -767,6 +767,8 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct =
vsie_page *vsie_page)
>>   out:
>>   	if (rc)
>>   		unshadow_scb(vcpu, vsie_page);
>> +	else
>> +		vcpu->kvm->stat.vsie_shadow_scb++;
>>   	return rc;
>>   }
>>  =20
>> @@ -843,8 +845,10 @@ static struct vsie_sca *get_existing_vsie_sca(struc=
t kvm *kvm, hpa_t sca_o_gpa)
>>   {
>>   	struct vsie_sca *sca =3D radix_tree_lookup(&kvm->arch.vsie.osca_to_sc=
a, sca_o_gpa);
>>  =20
>> -	if (sca)
>> +	if (sca) {
>>   		WARN_ON_ONCE(atomic_inc_return(&sca->ref_count) < 1);
>> +		kvm->stat.vsie_shadow_sca_reuse++;
>> +	}
>>   	return sca;
>>   }
>>  =20
>> @@ -958,6 +962,8 @@ static struct vsie_sca *get_vsie_sca(struct kvm_vcpu=
 *vcpu, struct vsie_page *vs
>>   		sca_new =3D NULL;
>>  =20
>>   		kvm->arch.vsie.scas[kvm->arch.vsie.sca_count] =3D sca;
>> +		kvm->arch.vsie.sca_count++;
>
> Why are you touching a non-stat variable in this patch?
>

That must have slipped in here while merging changes. It of cause needs to =
go into patch 7. Thanks.

>> +		kvm->stat.vsie_shadow_sca++;
>>   	} else {
>>   		/* reuse previously created vsie_sca allocation for different osca *=
/
>>   		sca =3D get_free_existing_vsie_sca(kvm);
>> @@ -992,6 +998,7 @@ static struct vsie_sca *get_vsie_sca(struct kvm_vcpu=
 *vcpu, struct vsie_page *vs
>>  =20
>>   	atomic_set(&sca->ref_count, 1);
>>   	radix_tree_insert(&kvm->arch.vsie.osca_to_sca, sca->sca_gpa, sca);
>> +	kvm->stat.vsie_shadow_sca_create++;
>>  =20
>>   out:
>>   	up_write(&kvm->arch.vsie.ssca_lock);
>>=20


