Return-Path: <kvm+bounces-29258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EB959A5E7D
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 10:22:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF0E01C20DCA
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 08:22:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8907D1E1C18;
	Mon, 21 Oct 2024 08:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qnV1ClMl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B931E1A32;
	Mon, 21 Oct 2024 08:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729498917; cv=none; b=ey+i40JoMSF1PjJ3YoI+gFYTO1yqUPnUyuI/CcBGY9Ai724sg5IY9d9fnSQFADv1+Z3S1ndFv0BvZzY7MY3kPYZEEwkEYpRXieaN9TAsD7THe1brIiT0Hkg5kfbADoFPcYd4GTxicgYqg/0g01x9VzbgHzJSPWR7EOvqCrENJho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729498917; c=relaxed/simple;
	bh=Q3dBwhKYtosBRIhpoY2C5AnPotARGVEjMtl3n73RKsg=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Subject:From:Cc:
	 To:Date:Message-ID; b=PqCsWdMc9md+LsAJ2VSxb1N9+o+q+9bfECfQLFlD+0qlLUZL4QHCPmMSimq9NF+TdzHTjOZsXvLS21ggC2Wb4/mb5qH092YR29HAobKjiniA+SQZDR3iwe8xQypetL0jkYLbm//7ZWarlPHh7+Hn2XVBikaM9aHVq8Rhyxvm+Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qnV1ClMl; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49L2KiPQ027225;
	Mon, 21 Oct 2024 08:21:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=jFNaAR
	88v7fVUsVqZ/Iv6kpsqeif58Qvy1y/HcetyAE=; b=qnV1ClMlaAg3B7oxMyxd/l
	bNkuYnnndoSVQuHPfI+AwbnH5p5ocDYuF7yw664zffs4zVtaIxDKgsQ0co6QxVfZ
	ZSLAxnxT9EDE7XsirzS6a9LxZLnI/fI1/rBeVC1zD4haPs4OZunvOugBQA+rCYds
	gptOrgzSFRbDBFlrdl1LNmpyRQk3TzNJMiNbADGrUfsoWFeZZVDpPfrwNQle9zdL
	4YR1hzG2ClaNO2IGDi1i5bijnwOEDYephrKXTK41+15PxfDOjbh//lZFR/NGc1tu
	1YsnISmVPSmRCTsUH1AajNJiifvDaGzE/9xMZiP1cE7wN7dCJM2FtHuUXQLSzwZQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5fcfgk5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 08:21:53 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49L8LqtA027440;
	Mon, 21 Oct 2024 08:21:52 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5fcfgk3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 08:21:52 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49L5hoSn018605;
	Mon, 21 Oct 2024 08:21:52 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42csaj50ap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 08:21:52 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49L8LmjA56361416
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Oct 2024 08:21:48 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A091520040;
	Mon, 21 Oct 2024 08:21:48 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D93E20049;
	Mon, 21 Oct 2024 08:21:48 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.29.79])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 21 Oct 2024 08:21:48 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <606b3c63-f4e1-449a-b3de-6fbb5e8211d7@linux.ibm.com>
References: <20241016180320.686132-1-nsg@linux.ibm.com> <20241016180320.686132-5-nsg@linux.ibm.com> <e649996c-559f-425e-833f-ca83bad59372@linux.ibm.com> <172924897145.324297.7466880604426455626@t14-nrb.local> <606b3c63-f4e1-449a-b3de-6fbb5e8211d7@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 4/6] s390x: Add library functions for exiting from snippet
From: Nico Boehr <nrb@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>, linux-s390@vger.kernel.org
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Date: Mon, 21 Oct 2024 10:21:47 +0200
Message-ID: <172949890741.324297.5665746219783039207@t14-nrb.local>
User-Agent: alot/0.10
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sXkELXFjUvSAgroKWsdU490FfLnwIf9h
X-Proofpoint-GUID: GAhBPISrGDB8LJyml8LUpXNFvRs797pd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxscore=0 clxscore=1011 mlxlogscore=852 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410210056

Quoting Janosch Frank (2024-10-18 14:53:34)
> On 10/18/24 12:56 PM, Nico Boehr wrote:
> > Quoting Janosch Frank (2024-10-18 10:02:37)
> > [...]
> >>> +static inline uint64_t snippet_get_force_exit_value(struct vm *vm)
> >>> +{
> >>> +     struct kvm_s390_sie_block *sblk =3D vm->sblk;
> >>> +
> >>> +     assert(snippet_is_force_exit_value(vm));
> >>> +
> >>> +     return vm->save_area.guest.grs[sblk_ip_as_diag(sblk).r_1];
> >>> +}
> >>
> >> The cpu address parameter for 9C is 16 bit.
> >> While we could make it 64 bit for snippets I don't see a reason to do
> >> so. The 16 bits are enough to indicate something to the host which can
> >> then go and fetch memory for more data.
> >=20
> > Mh, how exactly would you "fetch memory"? That requires knowledge on wh=
ere
> > things are in guest memory which can be painful to figure out from the
> > host.
> >=20
> > I've found it useful to be able to pass a pointer from guest to host. M=
aybe
> > a diag500 is the better option? gr2 contains the cookie which is a 64-b=
it
> > value - see Linux' Documentation/virt/kvm/s390/s390-diag.rst.
> >=20
> > P.S. Did I miss the part in the docs where the 16-bit restriction of 9c=
 is
> > documented or is it missing?
>=20
> For ASM snippets addresses 0x2000 to 0x4000 are a free area.
> For C snippets that area is the stack.
> The 16 bits should be good enough to point into that area.

Actually, it's currently just enough to point into the stack (snippet stack
is 64K)... also requires additional fiddling in the host to figure out the
complete address. Probably also in the guest, if you do it r15-relative
(can't think of a different solution right now).

> If the snippet requires a lot of memory then you can use constant=20
> addresses which are way over the snippet binary or just store a 64 bit=20
> address in a "free" lowcore location.

Would you prefer any of those over the diag500 solution?

> As you mentioned we also have diag500 which has the drawback of=20
> requiring to specify a couple more registers but that's not a huge=20
> hassle.=20

Since Nina contributed this nice wrapper function, going diag500 seems to
be the best thing to do.

