Return-Path: <kvm+bounces-48158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E01BACAC33
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 12:02:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4D91189DDFC
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 10:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37F251EDA02;
	Mon,  2 Jun 2025 10:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iIRgcOEh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11AF13AA31;
	Mon,  2 Jun 2025 10:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748858523; cv=none; b=jHnfQ1/pDxXaWtcXpN6NMampAileN/z0uJ7+wjYnNFpYSS9SIh+2nt/OWrb3n0+tgt1FfYnLr0B1YjGCeACGDuEy07mflK7b5/zvbhPswI8vlunxs7OuPfR7Jto4H7FlGBB2ZLtDvaEHwccjQX299MG99l19g8FWNsP2CzGXOsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748858523; c=relaxed/simple;
	bh=nEZ6BMzvDaj9htHiiB4l9xLXLONZDHjM6y0KMH9aMjw=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=V+VePPOA55FXzsazEnRArFOl94xvyKCU9l1CG025tvTM5At1BL6JRSv1sMx5Sdgs8KoYucYeJlA/Fq3ela1qmr145Se1kmPNahcN7mUmZiDSdTY4cS3iZGCbjA/QAv5Z4JiWAra06GRYKJ2HdXFCVm+qxURzg+g+SLGH5t3BJvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iIRgcOEh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5528mXUv016058;
	Mon, 2 Jun 2025 10:01:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=B4thrF
	eqnvJufZJQyQpfG5Q2il431CtCmXDBCEhV/UY=; b=iIRgcOEhq7u/yzyHpVEkFR
	ZYfdUjwDY4QV7zkIDpI3qvHuuH6BShzW58T6+jXEelc0AvzXruIj+Zqp91kbI9g5
	FZ/sNIoNgjjovvSi/fmtrjM5Pj4Dt8hnBVR9OZ5jhQDsq7fh0Tsieq3tjsr7FcHo
	YFxIgnHjHNTTyyIN0vbxto8saMDQRUDUAGdMloYPlhC4qYOed/9s7ydkPr3TdsNC
	Wye5boeOdc+4WZzX+sErSAd2qCHrL3wdAPusWlNUUvTOUYvJzixQQYHGAIhFNjBj
	F3jvVls2DOYvlTfQjsDxrhYN8Y17T5M/jT/Zq3GmthyAErBcN5Ub+EP+80c3LavA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46yxqq7p6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Jun 2025 10:01:58 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5529PKiR020246;
	Mon, 2 Jun 2025 10:01:34 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 470et25b3b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Jun 2025 10:01:33 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 552A1UMm19530130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Jun 2025 10:01:30 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 257C320074;
	Mon,  2 Jun 2025 10:01:30 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E720C20073;
	Mon,  2 Jun 2025 10:01:29 +0000 (GMT)
Received: from darkmoore (unknown [9.111.39.121])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Jun 2025 10:01:29 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Jun 2025 12:01:24 +0200
Message-Id: <DABYLCKX9E7Q.25CHFIS5HVA47@linux.ibm.com>
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
 <7ca1e834-a501-4c91-9458-63d5e0e2ec79@linux.ibm.com>
In-Reply-To: <7ca1e834-a501-4c91-9458-63d5e0e2ec79@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=AZ2xH2XG c=1 sm=1 tr=0 ts=683d7697 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=wuLMqWMKSN1-Q7KnnqIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAyMDA4NiBTYWx0ZWRfX0ulUZrFGmoj9 BbLMLJkHgN2+sQyD/sx67Z2yBPUrSbo8AVma39R+zPwYKJiYdxKyOWe5kF0E48RXh+DXk0Eg3U+ 2p4Zj7QFdY3W3RfXuZ3OnsokGsjuMyEPLHG6NzIDkqYMGc9xb9mYiUKXiOWwn1HbVzlGAXjkA9j
 bmYqTKmcIsrCxci/G9Qv1pEax5YKeW9QAyjeHs/G0dY5ss3Kb7GEEV7ohqg17c/Aryrl+Xoc5j7 eLXa/vJYjTnTkERi5lxjBrBirTiD+Egob7D4TPOogt/T6i52ybNAm9AhGz08a5N1ahjvgqH0rHG sKWJQ3D2fQSivTG+qrMI8I6N+uhY4jZKCABfwZZOl3FJ+PwHeJRK0M2gIN7+zBF7ZbUvVh2Rkl6
 CaQxlCQ5tZ27MS0we7a5Xho90PMNQfEJNRibgtmBnL1iVm8ZvyFxK42iP2FBSv2M5pFzS5iR
X-Proofpoint-ORIG-GUID: yABHLQwQTYbghNCXwUNpMNwVUlJUljEn
X-Proofpoint-GUID: yABHLQwQTYbghNCXwUNpMNwVUlJUljEn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-02_04,2025-05-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 bulkscore=0 mlxlogscore=488
 clxscore=1015 adultscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 phishscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505160000 definitions=main-2506020086

On Mon May 26, 2025 at 10:22 AM CEST, Janosch Frank wrote:
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
>
> [...]
>
>> @@ -80,33 +70,17 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu=
, int src_id)
>>  =20
>>   	BUG_ON(!kvm_s390_use_sca_entries());
>>   	read_lock(&vcpu->kvm->arch.sca_lock);
>> -	if (vcpu->kvm->arch.use_esca) {
>> -		struct esca_block *sca =3D vcpu->kvm->arch.sca;
>> -		union esca_sigp_ctrl *sigp_ctrl =3D
>> -			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
>> -		union esca_sigp_ctrl new_val =3D {0}, old_val;
>> -
>> -		old_val =3D READ_ONCE(*sigp_ctrl);
>> -		new_val.scn =3D src_id;
>> -		new_val.c =3D 1;
>> -		old_val.c =3D 0;
>> -
>> -		expect =3D old_val.value;
>> -		rc =3D cmpxchg(&sigp_ctrl->value, old_val.value, new_val.value);
>> -	} else {
>> -		struct bsca_block *sca =3D vcpu->kvm->arch.sca;
>> -		union bsca_sigp_ctrl *sigp_ctrl =3D
>> -			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
>> -		union bsca_sigp_ctrl new_val =3D {0}, old_val;
>> +	struct esca_block *sca =3D vcpu->kvm->arch.sca;
>> +	union esca_sigp_ctrl *sigp_ctrl =3D &sca->cpu[vcpu->vcpu_id].sigp_ctrl=
;
>> +	union esca_sigp_ctrl new_val =3D {0}, old_val;
>
>
> Since we don't have a need for inline declarations anymore, could you=20
> move those to the beginning of the function?

That would mean moving the sca access here out of the read lock. So I would
rather include that in a patch removing the sca_lock completely.

>
> @Christian @Claudio:
> Another interesting question is locking.
> The SCA RW lock protected against the bsca->esca switch which never=20
> happens after this patch.
>
> Can't we rip out that lock and maybe get a bit of performance and even=20
> less code? (In another patch set to limit the destructive potential)


