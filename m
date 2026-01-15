Return-Path: <kvm+bounces-68255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C6D6CD28AFA
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 22:17:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 421D93065E0C
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 21:17:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC8962EB5A1;
	Thu, 15 Jan 2026 21:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WcRIWIPl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B741FBC8E;
	Thu, 15 Jan 2026 21:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768511851; cv=none; b=JAKYKlIqUAA0m+oOY0ArfVx2adsFD4runojVnVlvs/XOF7OamNU+uBbk5VLmf+mecM3EFbQtYCgDSuMoJNnvIKwSZ1kaOVoNuCdgNqFzR5Pwsfbb2tLElijJoALS4icLUAQltC3r9Un9goE81k6+VjTAdQZt5i3Mby6Dv1WgqH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768511851; c=relaxed/simple;
	bh=g0B+pgN0zuiTlB9dDN4gL35ZEtqgiLfRCHz4yh9sapM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mFCebpznpcQ6H0L8h/OF1Xk6eD+diCh4/SufKTYFOl00UJMiGZ+cdsUkA7Gd1fS5bAV76r1BMJzjpx6ks6vLbxfsEg0L+yM6SqFs0+r6BUzto7Dl4zmIZpiFVnkvDHUqyfQ1Jgr/3xSyVJFQEwKaepxTN46EfwtFmjdYas6aRbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WcRIWIPl; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60FBvfVl026356;
	Thu, 15 Jan 2026 21:17:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=g0B+pg
	N0zuiTlB9dDN4gL35ZEtqgiLfRCHz4yh9sapM=; b=WcRIWIPlH5OLmRt6qXL1Wu
	dSk7R9+JrVD/BZ9WqdItKvCoFXMeaC7+9ULUeV/cjcsKnmbJc3sAUZZPiPnEktUC
	hERJbPZlYxkoXb7RQNcGBS05d5Lu8LcgNlf5wI9cuHpb7JyRY+X6b16PevJgFY/F
	j1/BSBO61ZooOYwX2quN0xwoG9VrZkOhSHO8AtlC5Vm8bncXmZdTiQX0QjtFCaeZ
	FrRQoy/x2Ap9loiCOYFcr3Z6PMqK/Lf8YnIFBXxBAb71i0TlEQlup9J/Fqlxd1Yp
	vm2EmqXyfczGTO2WzPRtG5GmPkYM4gSzLJBiWVH/KupJMd1K3kHnwPV2djJP1EpA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bpja4ncmv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 21:17:27 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60FKtMYs025503;
	Thu, 15 Jan 2026 21:17:26 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bm23njfsw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 21:17:26 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60FLH6WK56164656
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 21:17:06 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C287958066;
	Thu, 15 Jan 2026 21:17:24 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D29BF5804B;
	Thu, 15 Jan 2026 21:17:23 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.149.41])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 Jan 2026 21:17:23 +0000 (GMT)
Message-ID: <23154a0c6b4b9e625daa2b1bbaadc349bf3a99ed.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: vsie: retry SIE when unable to get vsie_page
From: Eric Farman <farman@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger	
 <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date: Thu, 15 Jan 2026 16:17:23 -0500
In-Reply-To: <20260114105033.23d3c699@p-imbrenda>
References: <20251217030107.1729776-1-farman@linux.ibm.com>
		<8334988f-2caa-4361-b0b9-50b9f41f6d8a@linux.ibm.com>
		<f34d767b2a56fb26526566e43fa355235ee53932.camel@linux.ibm.com>
	 <20260114105033.23d3c699@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE2MyBTYWx0ZWRfX49NOTknypqdW
 xYwy9zqF2mfb0GnrFK7Vz+XCabo9evcuRYPCY5qN3Mb7K+rVi32BTBI9Vb1LUKXwd8xdtLdpiUt
 TbJFYBYi/Y6wPj6ZOI0/8NBmJMT6aTKr6Lh5YfocJnD+v084xmGBj0YX7BJ8YVrNwPYVOEid/0f
 ZkOMciMVZNFFjnBlHGiSvWzqgx/oQfY8yUXXSrRFvZSiSOURk/ETj4uEhwNnZzmSMWB5XT4GoDz
 BeGxdiZQm1IweiU7cYZ2ler5MMlTsFWTx43PkMSrmcHPY0gezIAtUi4e2mBMNfqzEvmd0Aq3Y09
 bYoR+Dkg/wmYWYlcRfuq3y0cWtaD81SLZ2L13ankL3OuReMRVorDQnwMO6K7u/DBXT1hR/ztYvl
 KwpwfOCoJgQwgfRfaXwYC8HYtFO3xOSRZkR2uiragU6s0VjTlelp7ev97Ne/cLyupGaEQnhrQlp
 1l/kDMEM4P7cR3JHyLA==
X-Proofpoint-ORIG-GUID: FKUeb_6zItlZh6Jis7u3sCjhi9KrFiDj
X-Proofpoint-GUID: FKUeb_6zItlZh6Jis7u3sCjhi9KrFiDj
X-Authority-Analysis: v=2.4 cv=U4afzOru c=1 sm=1 tr=0 ts=69695967 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=8mLeQlhjTlvVVX_YL8kA:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0 adultscore=0
 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601150163

On Wed, 2026-01-14 at 10:50 +0100, Claudio Imbrenda wrote:
> On Mon, 05 Jan 2026 10:46:53 -0500
> Eric Farman <farman@linux.ibm.com> wrote:
>=20
> > On Mon, 2026-01-05 at 13:41 +0100, Janosch Frank wrote:
> > > On 12/17/25 04:01, Eric Farman wrote: =20
> > > > SIE may exit because of pending host work, such as handling an inte=
rrupt,
> > > > in which case VSIE rewinds the guest PSW such that it is transparen=
tly
> > > > resumed (see Fixes tag). There is still one scenario where those co=
nditions
>=20
> can you add a few words to (very briefly) explain what the scenario is?

Maybe if this paragraph were rewritten this way, instead?

--8<--
SIE may exit because of pending host work, such as handling an interrupt,
in which case VSIE rewinds the guest PSW such that it is transparently
resumed (see Fixes tag). Unlike those other places that return rc=3D0, this
return leaves the guest PSW in place, requiring the guest to handle an
intercept that was meant to be serviced by the host. This showed up when
testing heavy I/O workloads, when multiple vcpus attempted to dispatch the
same SIE block and incurred failures inserting them into the radix tree.
-->8--

@Janosch, if that ends up being okay, can you update the patch or do you wa=
nt me to send a v2?

>=20
> > > > are not present, but that the VSIE processor returns with effective=
ly rc=3D0,
> > > > resulting in additional (and unnecessary) guest work to be performe=
d.
> > > >=20
> > > > For this case, rewind the guest PSW as we do in the other non-error=
 exits.
> > > >=20
> > > > Fixes: 33a729a1770b ("KVM: s390: vsie: retry SIE instruction on hos=
t intercepts")
> > > > Signed-off-by: Eric Farman <farman@linux.ibm.com> =20
> > >=20
> > > This is purely cosmetic to have all instances look the same, right? =
=20
> >=20
> > Nope, I can take this path with particularly high I/O loads on the syst=
em, which ends up
> > (incorrectly) sending the intercept to the guest.
>=20
> this is a good candidate for the explanation I mentioned above :)
>=20
>=20
> (the patch itself looks fine)

