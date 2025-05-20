Return-Path: <kvm+bounces-47085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B925ABD216
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 10:35:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 880E84A227C
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 08:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F4972609D6;
	Tue, 20 May 2025 08:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MbIweyuj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403152641F3;
	Tue, 20 May 2025 08:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747730122; cv=none; b=ucg4oAcTydDdHuRJuelgwrpzgEKL0BCX/BzEytF58iYVn/lMh44ACr5ad5P+2Tl7wGXfkyP68TWsJbmoQjOG2CuHashwAlAwpwAbUoioI0CN9Nm070JW0yZO49cLlKihSJBD4dSUmkHFUV9DXHH6DGhsvftA7u9p68p854M4mh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747730122; c=relaxed/simple;
	bh=DB4MFiNGQ/Yo0KCARdE9N39Tr7wqNyEhs4IY2TbNROY=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=eP/biWYD9PBYd44yUQCVkIXjt0tkZOpfE1kO6QgZXGmNVq5ujvncO20tv/9vqEww6K9yovJnxvkkpUhw2z5xPNDFDrZgq4zr++xICSxq5XTI4GHHWiR8MgVNm0paSvdE8l0JFwLuX0kwPtn62txE4K27lU5ZfkOGy3VEHKGH0s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MbIweyuj; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54K7hjHk012339;
	Tue, 20 May 2025 08:35:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=aDGrGv
	ajedzdf5vho21QnaZU/wUkszsW/R+3WIn0s9Y=; b=MbIweyujk+73gpSVrvdkuy
	Fg5fNFSzHGXOwSGCVY6fwbjP+IqaPwk+7daohRnmtnOmrtOcEiUtUtbhE0n7lrRS
	6d7b3MDrYpLXK6QNFn8catSOeNzSOg246GAZHBWVgD98RaxV4IomDqC4C+YXak7T
	l6DGOCP/fh+6dO9un/Qs4uf/Cj/TG+VnItnaPheFEjGcCDgI17XxbBdisAqOp96h
	0Krm7EjDdGwaVe+z2vc/PjmnaxAMj3kkocc4C4oIemL05YMq30HmDnflxVXsAgVC
	38zgFccm1lFrcIalH5nLCtQAahwyT5R6/Op3RfocR0uqypL3lOwmrlVNZqcnSW5Q
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46rab72xtn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 08:35:14 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54K5gex5013843;
	Tue, 20 May 2025 08:35:13 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46q4stb5k9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 08:35:13 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54K8ZAgY21496160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 08:35:10 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 31CFF20040;
	Tue, 20 May 2025 08:35:10 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F3B3F2006A;
	Tue, 20 May 2025 08:35:09 +0000 (GMT)
Received: from darkmoore (unknown [9.111.66.212])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 20 May 2025 08:35:09 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 20 May 2025 10:35:04 +0200
Message-Id: <DA0UM5YL6IFH.1KE7UH4H6XBZM@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>,
        "Christian Borntraeger"
 <borntraeger@linux.ibm.com>,
        "Janosch Frank" <frankja@linux.ibm.com>,
        "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "David Hildenbrand"
 <david@redhat.com>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        "Vasily Gorbik"
 <gor@linux.ibm.com>,
        "Alexander Gordeev" <agordeev@linux.ibm.com>,
        "Sven
 Schnelle" <svens@linux.ibm.com>
To: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] KVM: s390: Always allocate esca_block
X-Mailer: aerc 0.20.1
References: <20250519-rm-bsca-v2-0-e3ea53dd0394@linux.ibm.com>
 <20250519-rm-bsca-v2-2-e3ea53dd0394@linux.ibm.com>
 <e5f67090-07a4-4818-b83e-33386313b2af@redhat.com>
In-Reply-To: <e5f67090-07a4-4818-b83e-33386313b2af@redhat.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=ELgG00ZC c=1 sm=1 tr=0 ts=682c3ec2 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=wuLMqWMKSN1-Q7KnnqIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 5f9jd9YWdhIbfmMFWxGCJhutHNGKyaQa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDA2NiBTYWx0ZWRfX/eaDk3Sn/Byx cGZvoT3WPCCbdxR/1Mk7dNUiHRE2vUHMb73MbMjW6WhOcPEQh2WRE2kMOkxQXtBiIYcYjwSyVYV Mj7TxAVn8eDLPnJrR4X4dPBR1cFAC2lDltZld9ZbGPHN2YBuzjw2ng0Rv2imxZISDziCg5Rf3Ur
 5kBVIeAUjscz/hm+RCbbx054ObSC8GVQXIknPQ+JngdJVLe6JUDBiC36ESe6n3S9fdp3hbCygQx 8ibqUKv+ug2RilqbuSRn0zpKH1ifSwUQIz/MpfQ5g6dPqz+18hREgakr+TMacjhqzVJIuSTZtgM uIejPktz04fLd+qNxKaqtlEjoG7DrSDrK1Gro58rInx89dVaTCK/gd+OiXDLTBRLHPEV+yaJNeu
 JxNkjLSjRyNyDl5CbIOaZ5hmjYU28fZ3OASkX2aa/KZ3RztIELveI839fy760oSe6Q5pwpiF
X-Proofpoint-GUID: 5f9jd9YWdhIbfmMFWxGCJhutHNGKyaQa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_03,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=570
 adultscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 suspectscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 malwarescore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505200066

On Tue May 20, 2025 at 7:41 AM CEST, Thomas Huth wrote:
> On 19/05/2025 13.36, Christoph Schlameuss wrote:
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
>>   arch/s390/kvm/interrupt.c        |  67 ++++-------------
>>   arch/s390/kvm/kvm-s390.c         | 159 ++++++-------------------------=
--------
>>   arch/s390/kvm/kvm-s390.h         |   4 +-
>>   4 files changed, 42 insertions(+), 189 deletions(-)
>
> Could you now also remove struct bsca_block from the kvm_host_types.h hea=
der?
>

We still need these to support sigp with bsca in vsie. (Once I have that
running properly.)

> ...
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
> You might want to adjust/remove the comment here now.
>

Yes. This does not make any sense anymore. But it is already completely rem=
oved
along with that whole message in the next patch.

>
>
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


--
Cheers,

Christoph

