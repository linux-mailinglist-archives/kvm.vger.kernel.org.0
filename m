Return-Path: <kvm+bounces-62784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3853CC4F067
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 17:25:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9C9094E43BE
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 16:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEC9536CDEF;
	Tue, 11 Nov 2025 16:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WGCB9uQa"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690E0365A04;
	Tue, 11 Nov 2025 16:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762878297; cv=none; b=kdsgeVi0ksP8SD7Jda3NSXtYEq+m5wRVSaG97wIwXnUX3vEM7kUKeeFxu/igogaytHSMuA8eRcRrV/IThjcPBAOtXD6SKf6l/33VV5lZb0tEu9ovoDJzgxX36CsGKmt4qseWC6JqlntyaDZFBIqyfzJvqhcjGHWWGnnlJhEX9TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762878297; c=relaxed/simple;
	bh=/hwQqZL9g1+w6hCYqSZXwuJ5kjCR82xJCwQUS56WPRs=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Subject:From:Cc:
	 References:In-Reply-To; b=AtWH2sR2bclaQ98BwcxKWe8qadZOkEUaNzX8hTQ4+3aGHqpPCgUqy1J6VN0qjffidG3TSHRGFCofLXaw7Ro63Dm7TiRL32+JG1+s/0l/C9hy3BUKulNw2pmuqR5evBIdMvAO1ap9t6cGa01hSxrIwmSAmmm0O7cmq+C5289NOE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WGCB9uQa; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB5HFoi031978;
	Tue, 11 Nov 2025 16:24:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=FBHTJy
	VZ0sIvnKqqpCXsfvx5Sm96wv/6+rRCjsw5uco=; b=WGCB9uQaqQWkX34fk9or7j
	K0S1+c8+XG1u8+tIU5Ir/i1JiVLV58TxOkSXueMi9Ie/oDEujOvKXqDpU9XGbriD
	M5wNFy+cChrSgTRw59t0xDZ+B+6X5KD/rcZhjmUmqNuK7cnyFTSsUTA+znBE/WRN
	+UZbEMx0MHklNrGoYSukwViA9yS8J5IbCLQKK4MekEDp2ledLFw7zCUPraR8lj0g
	0SW4x7flDIEHHB0Px4CjfbVsgXQ5jjlWtGv1qZt3eNBFJ0iChPom9zmqeSFcF6Rm
	sf7lzrEZo+1s2RIaLQg9GKt2Hv0xtD4vpCUaplfVX2WDFsu1bAPZ6LcwVNcDATBA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa3m844q6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 16:24:52 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABDbOoa004744;
	Tue, 11 Nov 2025 16:24:52 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aagjxus6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 16:24:52 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5ABGOmFH29098358
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 16:24:48 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE9ED2004E;
	Tue, 11 Nov 2025 16:24:47 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 56BFF2004B;
	Tue, 11 Nov 2025 16:24:47 +0000 (GMT)
Received: from darkmoore (unknown [9.87.148.94])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Nov 2025 16:24:47 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 11 Nov 2025 17:24:38 +0100
Message-Id: <DE607138SEAQ.2YON9QDYCAHEM@linux.ibm.com>
To: "Eric Farman" <farman@linux.ibm.com>,
        "Christian Borntraeger"
 <borntraeger@linux.ibm.com>,
        "Janosch Frank" <frankja@linux.ibm.com>,
        "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "David Hildenbrand"
 <david@redhat.com>
Subject: Re: [PATCH] KVM: s390: vsie: Check alignment of BSCA header
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>
X-Mailer: aerc 0.20.1
References: <20251107024927.1414253-1-farman@linux.ibm.com>
 <DE5QK1RDMQR7.3OEIS68GLQHK5@linux.ibm.com>
 <cbb6ffbc3946b6f4da6bef9c6c876cdc68b608cf.camel@linux.ibm.com>
In-Reply-To: <cbb6ffbc3946b6f4da6bef9c6c876cdc68b608cf.camel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=MtZfKmae c=1 sm=1 tr=0 ts=69136354 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=E-M7EcLIl58dVeEKm_QA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: rnIrQmljJZX1Hkoyuiu3z8uqO7KKF4IA
X-Proofpoint-ORIG-GUID: rnIrQmljJZX1Hkoyuiu3z8uqO7KKF4IA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA3OSBTYWx0ZWRfX4/Smw6XMOG51
 cbaZLLXNP1ejXIz7D+XoL9q6S6o/yGZjUe4xslCBlcinSUV0yUHg+hjTQ6eXZnkjrFjFrF2/yJf
 1j5lPX91aPaWH5GAoOPFltoCbCGQVRMpa1nhhHL4XUawKnGLKo8Nsi2fE1rBi1g4ZEjEiIWWXF9
 392IkIl6cIWItyLzKPH5t0JXcPII7racdnLvYofVYqUPQ80NnAPqAA54dnoH8OqB9IcYYwzqkyC
 sLgdkfv5cuqYuUa7gN66ERoiYzWVkR4HZ81S91Kd2ydRiFBNxNaoatYO0J8XX7064g+SXmjO45a
 xOKKq5KM6hveagKa9b/r55Vgg7aBZQI5u/Z6CFyjYTU5qS6vdMXsn8BcG8ZsFPwjQql5DbvEIz8
 cT0Tj7uOzq/BOwL702K6aL4HyXuwQA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_03,2025-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080079

On Tue Nov 11, 2025 at 4:36 PM CET, Eric Farman wrote:
> On Tue, 2025-11-11 at 09:51 +0100, Christoph Schlameuss wrote:
>> On Fri Nov 7, 2025 at 3:49 AM CET, Eric Farman wrote:
>> > The VSIE code currently checks that the BSCA struct fits within
>> > a page, and returns a validity exception 0x003b if it doesn't.
>> > The BSCA is pinned in memory rather than shadowed (see block
>> > comment at end of kvm_s390_cpu_feat_init()), so enforcing the
>> > CPU entries to be on the same pinned page makes sense.
>> >=20
>> > Except those entries aren't going to be used below the guest,
>> > and according to the definition of that validity exception only
>> > the header of the BSCA (everything but the CPU entries) needs to
>> > be within a page. Adjust the alignment check to account for that.
>> >=20
>> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> > ---
>> >  arch/s390/kvm/vsie.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >=20
>> > diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>> > index 347268f89f2f..d23ab5120888 100644
>> > --- a/arch/s390/kvm/vsie.c
>> > +++ b/arch/s390/kvm/vsie.c
>> > @@ -782,7 +782,7 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struc=
t vsie_page *vsie_page)
>> >  		else if ((gpa & ~0x1fffUL) =3D=3D kvm_s390_get_prefix(vcpu))
>> >  			rc =3D set_validity_icpt(scb_s, 0x0011U);
>> >  		else if ((gpa & PAGE_MASK) !=3D
>> > -			 ((gpa + sizeof(struct bsca_block) - 1) & PAGE_MASK))
>> > +			 ((gpa + offsetof(struct bsca_block, cpu[0]) - 1) & PAGE_MASK))
>>=20
>> Did you test if this works with an esca, where the header is bigger than=
 this?
>> Previously the esca header was covered by the whole bsca struct.
>
> I had originally coded up an offset like you did in your vsie sigpif seri=
es [*] for just this point,
> but since we don't surface KVM_S390_VM_CPU_FEAT_SIGPIF to the guest (that=
 comes later in your
> series), I was having to force my way into driving that path and for mini=
mal benefit. Now that I'm
> remembering your RFC, having a conditional length is certainly correct bu=
t this is a good first
> step.
>
> [*] https://lore.kernel.org/linux-s390/20251110-vsieie-v2-3-9e53a3618c8c@=
linux.ibm.com/
>

I agree that this is a good step in that direction. I am only concerned if =
we
may still get a validity intercept from fw when entering SIE while the ESCA
header is crossing the page boundary. The chances of that happening are sli=
m as
at least Linux does always place the ESCA on the beginning of the page, but
other guests might not.
But then again getting the validity intercept from fw is not that much wors=
e
than getting it from us directly.

So either way:

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

>>=20
>> >  			rc =3D set_validity_icpt(scb_s, 0x003bU);
>> >  		if (!rc) {
>> >  			rc =3D pin_guest_page(vcpu->kvm, gpa, &hpa);


