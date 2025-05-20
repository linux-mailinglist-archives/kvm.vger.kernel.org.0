Return-Path: <kvm+bounces-47138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C63EABDD47
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 16:37:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9DA837B598C
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 14:33:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DBA8248F5D;
	Tue, 20 May 2025 14:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ki2ztVZr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EC6244186;
	Tue, 20 May 2025 14:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747751679; cv=none; b=FlhSEPttISRaL3CdG6oD022Elvl/L4nyd6FlwSYMbQHDO8gAa9IETTFk7KyLeq3OECKTjberVxWBx2YSuJ0EdAiw0NJRzhgnerWIg4ektldMsnbeXE9t8snwM2eLAXIpwL4649jQUImD6dE7qSNeDxf1B+j0I7m6yI6KMaYnzg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747751679; c=relaxed/simple;
	bh=+t4Cf/Brla4nzolbLo0Ygx1cF3WxLLE+qrpDmLvVm1g=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CQaouyQ8Ap4meySlgjYPtQ2qcdN635hGA2AIocjEWTTWgjI+D2eOPp+xcIsajb2ixjmtzmN2u74gibStQtZT4K8VYg4/OwXj2pc62e0seRlSgM7RjLgKjCnsvW8gAQZxNBCftz7w8U3jh9m9lcVh0Rnk23lg4b2xGHoVwaLvSXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ki2ztVZr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54K7iMPr013649;
	Tue, 20 May 2025 14:34:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=dij2jB
	Lp8c/R0MTxWsUN34ZE33F2NvyD6QkC15mUbGM=; b=Ki2ztVZrmBs/pegHaNdFB2
	6WANajhC9mF6qEddRx/RTgkUqRgAj4NrJ9sugZffZhuRXxMTa9m34xjBcJDnhxFU
	2F8TWgoWuTn2PY6IbW8T11NXDflE0Yjtk6kgA8yvenrv8tiXrapw2Kob+If+tWRT
	BtO92ikPJ4okBrQBXXggiOUB26rmPwOBx9r/HT6kku8zKJ19zSTV9zpmL/3NqlZt
	6uAEmMzd7n5pr4VpGndPhaAOl15xZN5GC/fbYxJNWRandLBzGxwLZgFD9nxXiHhG
	6tBDzjxTyEBez8DIP6mrhFVGNOCPID+ciHNszq2Zd/DJFmCFY+inwgxdbj8qBX1A
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46ra99mufp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 14:34:35 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54KC3gws016147;
	Tue, 20 May 2025 14:34:34 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46q7g2c2vg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 14:34:34 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54KEYUsi56557876
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 14:34:30 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B7EE2004B;
	Tue, 20 May 2025 14:34:30 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A1C8720040;
	Tue, 20 May 2025 14:34:29 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.111.32.248])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 20 May 2025 14:34:29 +0000 (GMT)
Message-ID: <0b90cd0ad24727c9d7b110f09fd79b2525b4fbe1.camel@linux.ibm.com>
Subject: Re: [PATCH v1 2/5] KVM: s390: remove unneeded srcu lock
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com
Date: Tue, 20 May 2025 16:34:30 +0200
In-Reply-To: <8373c4a476e6a8f714a559d0fad8f3fed66089f1.camel@linux.ibm.com>
References: <20250514163855.124471-1-imbrenda@linux.ibm.com>
		 <20250514163855.124471-3-imbrenda@linux.ibm.com>
	 <8373c4a476e6a8f714a559d0fad8f3fed66089f1.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 (3.56.1-1.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=J/mq7BnS c=1 sm=1 tr=0 ts=682c92fb cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=mH3vZ3oXfMAmPE_1c18A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDExMyBTYWx0ZWRfX4M43be9fidUy OuGsDr1NmuGi8aSY0WamN+xb1/b9dBe2hzJ5PyptZf/oku0/T0enf8QlfkhJpupi8hw/GpwnRvo u059uov+VAnVCyOrHlerONKahbnfxVnfH9Krvz0QWGTwUtgHiAMv3gY/aHf2ObQ7+bPrLzHDFuJ
 xJB4qA6RMCdyUGHgJtH6hJ5kki65A27Laik8LYQvQyLYtW4Gsir4D7jJUvGldVAbDkt/4Bs1/8d ecr8/EnEaCxMWOTx/w4DnaoSCJu4SpAk3MNx1p3TRA+RgwQQFJzoBJF4v0y3rUWP5ay7ARLSNnx lzV2OJyhsZ/QPULzYwODdMPRR/PODbaoKu2KInM1gHY3aHGkQFD5uPL9qwkLN9dokqWFnF8je55
 WFtsv6yZhuZY2OD3WUZ7MU82oO1S+25UgL1lDjh3Q/vBcvLibHEfxLDBdB8nYTvZJVbiufeW
X-Proofpoint-ORIG-GUID: qpZcX6c6IVm_wymNTKzRyJj5b9rijhVt
X-Proofpoint-GUID: qpZcX6c6IVm_wymNTKzRyJj5b9rijhVt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_06,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxlogscore=929 mlxscore=0
 clxscore=1015 phishscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505200113

On Mon, 2025-05-19 at 16:42 +0200, Nina Schoetterl-Glausch wrote:
> On Wed, 2025-05-14 at 18:38 +0200, Claudio Imbrenda wrote:
> > All paths leading to handle_essa() already hold the kvm->srcu.
> > Remove unneeded srcu locking from handle_essa().
> >=20
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>=20
> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>=20
> Why are you removing it tho?
> It should be very low cost and it makes the code more robust,
> since handle_essa itself ensures that it has the lock.
> It is also easier to understand which synchronization the function does.
> You could of course add a comment stating that the kvm srcu read side nee=
ds
> to be held. I think this would be good to have if you really don't want t=
he
> srcu_read_lock here.
> But then you might also want that documented up the call chain.

Actually, can we use __must_hold or have some assert?
>=20
> > ---
> >  arch/s390/kvm/priv.c | 4 ----
> >  1 file changed, 4 deletions(-)
> >=20
> > diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> > index 1a49b89706f8..758cefb5bac7 100644
> > --- a/arch/s390/kvm/priv.c
> > +++ b/arch/s390/kvm/priv.c
> > @@ -1297,12 +1297,8 @@ static int handle_essa(struct kvm_vcpu *vcpu)
> >  		/* Retry the ESSA instruction */
> >  		kvm_s390_retry_instr(vcpu);
> >  	} else {
> > -		int srcu_idx;
> > -
> >  		mmap_read_lock(vcpu->kvm->mm);
> > -		srcu_idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> >  		i =3D __do_essa(vcpu, orc);
> > -		srcu_read_unlock(&vcpu->kvm->srcu, srcu_idx);
> >  		mmap_read_unlock(vcpu->kvm->mm);
> >  		if (i < 0)
> >  			return i;

--=20
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen / Registergericht: Amtsgericht Stuttg=
art, HRB 243294

