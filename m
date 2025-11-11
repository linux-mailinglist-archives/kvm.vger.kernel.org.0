Return-Path: <kvm+bounces-62781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DC404C4ED3E
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 16:42:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 73B764F578A
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 15:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F35336656C;
	Tue, 11 Nov 2025 15:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Wul1/mh6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1A32874F1;
	Tue, 11 Nov 2025 15:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762875371; cv=none; b=eBrm5dywDGNLyL6pVQjPJ8JMK6/8Ok+8XPWqq5TLjMLtT8q6gv8DhoR4b2CQlXd/bM4b8vi97u58PIohdfPmwH4qoZ1k8jLvspj2kQYOuMTSKV3P8FI8Rw+VpR7frSHsuMrUVTsverv+Cv/CLiIsiorAwKibHrL0h1mHF5QC/Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762875371; c=relaxed/simple;
	bh=j44kKBuPtKN5iIbGvNg+++B/AiysUnp+UeW8k37wjtQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t/W5HNQ7IES7ri1MV6OCi3cnst2E3rQlEg33wrc89Eunj28zs7nzkHTjDs2DP2mV/WbxxEiBbEhR8Of7JSI3dxyNrtuJJYhkf3ThsH9e8rb93BwvlcALrj1PDB64b2VSV+mNUYyHyzB6ivMv16ReFC+7jYahwi612QwEEK6LHp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Wul1/mh6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABEknKq007136;
	Tue, 11 Nov 2025 15:36:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=KtbU/Z
	fEaF4tJRH/dCwDt9uQ0XLj/75T+pT8JtBTOtk=; b=Wul1/mh6hrJzAkgyRQKE/V
	1PW0s/+otoYloI1DQxiQLqjWScnnl7tvejTQWUJAlFwF/56r0J9h4mYpfmym7Jdm
	w22T2J8Ehlaobsl7wHIqaRs5+D44mcH6nRBWH9UsKCM4hlldyB5NxshqKAFTjcLP
	k+Y5It/rmgiCGmev9aMKM9S1g98B2UPCZpcWJtc37RkDcR4zffy7BdGWelqJqzXy
	hzwwQPvdLOiIB8Nm2Jxq32LMnd2hpE0M/pkIdXChMi7jBgW7LOKV46RrG3uv0O0B
	g7Aodjy09ZDUlf51RCns5bxzs+ADOqUtPin9iGIKMyZUzOZOX051A0XrW/8R4xOg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wgwvmfh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 15:36:07 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABDvgg3014755;
	Tue, 11 Nov 2025 15:36:06 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aahpk3ent-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 15:36:06 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5ABFa5dq16188008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 15:36:05 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E3F75805A;
	Tue, 11 Nov 2025 15:36:05 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8481258052;
	Tue, 11 Nov 2025 15:36:04 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.62.231])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Nov 2025 15:36:04 +0000 (GMT)
Message-ID: <cbb6ffbc3946b6f4da6bef9c6c876cdc68b608cf.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: vsie: Check alignment of BSCA header
From: Eric Farman <farman@linux.ibm.com>
To: Christoph Schlameuss <schlameuss@linux.ibm.com>,
        Christian Borntraeger	
 <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio
 Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Date: Tue, 11 Nov 2025 10:36:04 -0500
In-Reply-To: <DE5QK1RDMQR7.3OEIS68GLQHK5@linux.ibm.com>
References: <20251107024927.1414253-1-farman@linux.ibm.com>
	 <DE5QK1RDMQR7.3OEIS68GLQHK5@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JVE8UQsZQwNQXOkNSewhYMQhSRfFERlV
X-Proofpoint-ORIG-GUID: JVE8UQsZQwNQXOkNSewhYMQhSRfFERlV
X-Authority-Analysis: v=2.4 cv=VMPQXtPX c=1 sm=1 tr=0 ts=691357e7 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=QADOUfkMlaS2RCrf3QwA:9
 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAyMiBTYWx0ZWRfX0uuhP2Ot4sOg
 2Yh6gKICaSzj92Z7xEGb9t7XBcH0YUnFLDbfe7RW11uru3CDJKFmfnTKGr59hfFILIIT9p0y0Zf
 dxe7DJwXJoBJEKbkJqqhHi7ahfAFyOzwVPa6YIAyKwSnCQrg7LOJMYggEjmSrriFhhC9okU2DAg
 Zs2M7CAb6D6/sO1b8Y1Li2c6Gg4fhTb4dS5I51whp9Az8r/EhnC2Zpm6W6B6Q8cwwUbg3S7MIW7
 TtxjYzS8heELOz5kz/Pbp4CNxWXDB+hLzU3pjIpNJX3oAA4mAAjV/ucU8aZGPuEWJOM88jr81Un
 yVBnE+A4IRcuCGuzbOk71rKbmeAowLfCo0BoWzv/bifLwggFhvQN8KTyHkwcyHFpKAtolKo0Pcd
 GK97+xBPrpD/9lThE23Gceh9tdtyxQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_02,2025-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 clxscore=1015 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511080022

On Tue, 2025-11-11 at 09:51 +0100, Christoph Schlameuss wrote:
> On Fri Nov 7, 2025 at 3:49 AM CET, Eric Farman wrote:
> > The VSIE code currently checks that the BSCA struct fits within
> > a page, and returns a validity exception 0x003b if it doesn't.
> > The BSCA is pinned in memory rather than shadowed (see block
> > comment at end of kvm_s390_cpu_feat_init()), so enforcing the
> > CPU entries to be on the same pinned page makes sense.
> >=20
> > Except those entries aren't going to be used below the guest,
> > and according to the definition of that validity exception only
> > the header of the BSCA (everything but the CPU entries) needs to
> > be within a page. Adjust the alignment check to account for that.
> >=20
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> >  arch/s390/kvm/vsie.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> > index 347268f89f2f..d23ab5120888 100644
> > --- a/arch/s390/kvm/vsie.c
> > +++ b/arch/s390/kvm/vsie.c
> > @@ -782,7 +782,7 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct=
 vsie_page *vsie_page)
> >  		else if ((gpa & ~0x1fffUL) =3D=3D kvm_s390_get_prefix(vcpu))
> >  			rc =3D set_validity_icpt(scb_s, 0x0011U);
> >  		else if ((gpa & PAGE_MASK) !=3D
> > -			 ((gpa + sizeof(struct bsca_block) - 1) & PAGE_MASK))
> > +			 ((gpa + offsetof(struct bsca_block, cpu[0]) - 1) & PAGE_MASK))
>=20
> Did you test if this works with an esca, where the header is bigger than =
this?
> Previously the esca header was covered by the whole bsca struct.

I had originally coded up an offset like you did in your vsie sigpif series=
 [*] for just this point,
but since we don't surface KVM_S390_VM_CPU_FEAT_SIGPIF to the guest (that c=
omes later in your
series), I was having to force my way into driving that path and for minima=
l benefit. Now that I'm
remembering your RFC, having a conditional length is certainly correct but =
this is a good first
step.

[*] https://lore.kernel.org/linux-s390/20251110-vsieie-v2-3-9e53a3618c8c@li=
nux.ibm.com/

>=20
> >  			rc =3D set_validity_icpt(scb_s, 0x003bU);
> >  		if (!rc) {
> >  			rc =3D pin_guest_page(vcpu->kvm, gpa, &hpa);

