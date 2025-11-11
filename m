Return-Path: <kvm+bounces-62732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 155B6C4C753
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 09:49:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1874F4F02BA
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 08:48:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E669257846;
	Tue, 11 Nov 2025 08:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PVw8du0e"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0C035950;
	Tue, 11 Nov 2025 08:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762850900; cv=none; b=Lg4964qA1P5+G8rj5r1/7q1s1HBGYoacvP09O7eNjml1zg3cEgHcyu/qixNv+M9vXFnncuJKkotuH/shVbIBQwIUWCqH6K5RYrClth2q+95YqGBA1VZHIhvqYyRbRmYOWUpAA+iPKeWkkqGgJGQFZJm4tOK5eRK9GfFKdXXCh7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762850900; c=relaxed/simple;
	bh=R0EDqhj3Ps330IF2QyTmdBChI2rxhVhDTbMQ836Lf5w=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:Cc:To:
	 References:In-Reply-To; b=sAcawJpvQd1eqKQfxkWLvWahhaGHwrTdTlyosgdYiFuqj2ekxYfDzweAdusiukg9XfL14wIv10LiA3RazM8jotq4kPeE75NVQC44oW86yxeBcIL7VuRzYgYMf1V15q5F8OWqnklFyimssorXQFeCaoDNJ+pUIpWlQFlX5s0J2pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PVw8du0e; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB3pvsP013673;
	Tue, 11 Nov 2025 08:48:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=XVEMyX
	Ck5A3apgTx4cS+EU7CtpHyhaZxuViNnE3wue0=; b=PVw8du0eg1EBzyM0UgirzB
	AUISUTOjOHi9qrrhVnk7R+gX0YVfFBcgE9/rcNS5JE/U11p87cqWWDF7DKtAZT1n
	pxkxRCzBk7HOwGqJbIlutc9W/7dXC7F3oJf1a23tu2228vkmqrFnTwv1MabRi5Vv
	wW0IV1ggtmk/oqoQ8XoQEsHF753x0vjwG4Dj2AIKgdbQec9U/02mT8M5Yqjpki0V
	Zm+tsY5XZGpug6vPW9pncqNZXg7dugL5/nlSwjMdSFh7EMsLFTloexw51Of5p2Ew
	FH+gLJlngck2Nas/D+yOU+mhmf1UfiFQxMJk4DWIK3/JzyoEYLSxq602eO5a12tQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5tjt0b7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 08:48:13 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB5BV10028888;
	Tue, 11 Nov 2025 08:48:12 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aag6sa27x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 08:48:12 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AB8m9g451446036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 08:48:09 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 179E42004B;
	Tue, 11 Nov 2025 08:48:09 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D84FF20043;
	Tue, 11 Nov 2025 08:48:08 +0000 (GMT)
Received: from darkmoore (unknown [9.111.46.253])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Nov 2025 08:48:08 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 11 Nov 2025 09:48:03 +0100
Message-Id: <DE5QHFWJO3XJ.KPH15NIRYV9Z@linux.ibm.com>
Subject: Re: [PATCH RFC v2 03/11] KVM: s390: Move scao validation into a
 function
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, "Heiko Carstens" <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander Gordeev"
 <agordeev@linux.ibm.com>,
        "Christian Borntraeger"
 <borntraeger@linux.ibm.com>,
        "Janosch Frank" <frankja@linux.ibm.com>,
        "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "Nico Boehr"
 <nrb@linux.ibm.com>,
        "David Hildenbrand" <david@redhat.com>,
        "Sven
 Schnelle" <svens@linux.ibm.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>, "Shuah Khan" <shuah@kernel.org>
To: "Eric Farman" <farman@linux.ibm.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.20.1
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
 <20251110-vsieie-v2-3-9e53a3618c8c@linux.ibm.com>
 <33338cb8c04dfed521542c9145ca282f9dc9d763.camel@linux.ibm.com>
In-Reply-To: <33338cb8c04dfed521542c9145ca282f9dc9d763.camel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MVlscWelvMUtImq9W868eVVa1sCEyKDV
X-Proofpoint-ORIG-GUID: MVlscWelvMUtImq9W868eVVa1sCEyKDV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA5OSBTYWx0ZWRfX+tSWdZ31YQKY
 et6Vbxj9L8/YVEzQUIiQfZH625EmCfrT9ZOzm+0S/yPXWq6zxMEPb+21zNpynmvCY222+RrKTWY
 yi2X68rcvt0zWLx4mT05j1SZgmHd737AJbDozIijTaPrGIBuqemQFeD0tKtbhNlqZxRfnuY1AJu
 dIiVCt7cHAoZTq3XOO/u0jj21V2pJMFkM4H4OdxRXmGvHpkNYkNzRGGgFV7JuF9vOJ5PR17XO6L
 MFw+02ctq0p+clj6ZKkaAS74xUDgbSZWNxT02TOS3iCdym9bVQakh+m3q6xwRRHviWN6dCaTyvY
 kIOdGDzo1DN94J22AUZIMTVw5cCb+PRRpx2rwolAB3LUTdJGIy1Azuq2bokx53aINqnh3xH+pLD
 4mbXs4D7NEeGqwOtb7XeUyMsYL12Pg==
X-Authority-Analysis: v=2.4 cv=V6xwEOni c=1 sm=1 tr=0 ts=6912f84d cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=mfCUK2mtNSY2JsbAKvcA:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19
 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_01,2025-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 phishscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080099

On Mon Nov 10, 2025 at 10:30 PM CET, Eric Farman wrote:
> On Mon, 2025-11-10 at 18:16 +0100, Christoph Schlameuss wrote:
>> This improves readability as well as allows re-use in coming patches.
>>=20
>> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
>> ---
>>  arch/s390/kvm/vsie.c | 27 ++++++++++++++++++++-------
>>  1 file changed, 20 insertions(+), 7 deletions(-)
>>=20
>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>> index ced2ca4ce5b584403d900ed11cb064919feda8e9..3d602bbd1f70b7bd8ddc2c54=
d43027dc37a6e032 100644
>> --- a/arch/s390/kvm/vsie.c
>> +++ b/arch/s390/kvm/vsie.c
>> @@ -95,6 +95,25 @@ static int set_validity_icpt(struct kvm_s390_sie_bloc=
k *scb,
>>  	return 1;
>>  }
>> =20
>> +/* The sca header must not cross pages etc. */
>> +static int validate_scao(struct kvm_vcpu *vcpu, struct kvm_s390_sie_blo=
ck *scb, gpa_t gpa)
>> +{
>> +	int offset;
>> +
>> +	if (gpa < 2 * PAGE_SIZE)
>> +		return set_validity_icpt(scb, 0x0038U);
>> +	if ((gpa & ~0x1fffUL) =3D=3D kvm_s390_get_prefix(vcpu))
>> +		return set_validity_icpt(scb, 0x0011U);
>> +
>> +	if (sie_uses_esca(scb))
>
> This helper doesn't turn up until patch 7
>

Good catch, thank you.

I will pull up that helper into this patch then. (Decreasing the size of pa=
tch 7
is an absolute plus here.)

>> +		offset =3D offsetof(struct esca_block, cpu[0]) - 1;
>> +	else
>> +		offset =3D offsetof(struct bsca_block, cpu[0]) - 1;
>> +	if ((gpa & PAGE_MASK) !=3D ((gpa + offset) & PAGE_MASK))
>> +		return set_validity_icpt(scb, 0x003bU);
>> +	return false;
>> +}
>> +
>>  /* mark the prefix as unmapped, this will block the VSIE */
>>  static void prefix_unmapped(struct vsie_page *vsie_page)
>>  {
>> @@ -791,13 +810,7 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct=
 vsie_page *vsie_page)
>> =20
>>  	gpa =3D read_scao(vcpu->kvm, scb_o);
>>  	if (gpa) {
>> -		if (gpa < 2 * PAGE_SIZE)
>> -			rc =3D set_validity_icpt(scb_s, 0x0038U);
>> -		else if ((gpa & ~0x1fffUL) =3D=3D kvm_s390_get_prefix(vcpu))
>> -			rc =3D set_validity_icpt(scb_s, 0x0011U);
>> -		else if ((gpa & PAGE_MASK) !=3D
>> -			 ((gpa + sizeof(struct bsca_block) - 1) & PAGE_MASK))
>> -			rc =3D set_validity_icpt(scb_s, 0x003bU);
>> +		rc =3D validate_scao(vcpu, scb_o, gpa);
>>  		if (!rc) {
>>  			rc =3D pin_guest_page(vcpu->kvm, gpa, &hpa);
>>  			if (rc)


