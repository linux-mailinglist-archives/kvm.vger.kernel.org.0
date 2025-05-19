Return-Path: <kvm+bounces-46986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EFCFBABC122
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 16:43:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 609D11894E5F
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 14:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83F5D284674;
	Mon, 19 May 2025 14:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lZeQXWOs"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288AA26AA88;
	Mon, 19 May 2025 14:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747665784; cv=none; b=rodbCrGtWsnC5bBSMtCIlCuzfqoC5bViCMqza7m62C7K9o8Sa5BlP+zWTvpTAvE8qAOpZ7DJpFnVrCtS8esCKW8Gf2r7oFsimquSDsq4/ev/nGX9G1dMxUpkoNB2GFhd0ZWBRytxaTG8DLkt5jpyMAgqpE0xUkobw962qFYYWwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747665784; c=relaxed/simple;
	bh=KfTaL4jbdr2dKjA9yuBTts5oRjMcejAtm1cBEpHtYok=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rd9TAzfmpIVFPaM5ZMJXhubIVh2ktIyOmyNpXfvFq3TOwAg6qwo8oPlDQpefaIzaBf1nHpuZfKqI4cDiUX1hu2lM23C6iF69Q71s+YbAsbwvYrO4wzGidKwY3jDicMeQz9JArB0US+azmhFqACpd7sW4RgdEA0XguVbsxYP3/CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lZeQXWOs; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54JAEwWF008612;
	Mon, 19 May 2025 14:43:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=GvwL5P
	IO6tnMQLtupw2PKbTia+roWK20kcCqmm/znsQ=; b=lZeQXWOsJg5cxzP8jtbPsm
	eomcjgUIb8X1SCpXJFmplc1CMvrijw5YDI4qsTwHuBDO9kZc/VxHGl1jlQAxVg1M
	vSP3ErApPDuExM2kXSSBh22dhqy3TOCCNUANEPC70gVvAmlftVzv52+hp2PHf1yA
	54f+bgfJj9LcYuqwgWNSz8+6zOwnM8Aqq3ZuOPuJOfOrWDdRwo4bFmKRZDA1PMbe
	2nR454y24SWz+47ycs29jYrVGd3FaoKN1hPbgqoLcr4jO/oY1ecnI0Xpv9Yuf84f
	DJzgD5Wc2ipcdf2K123c6nTMcjU1KUQKpzAHW8xO3whoqQM5JQGJfIXlGchxgHIg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46r2qhs8e6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 14:43:00 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54JDO1tj028928;
	Mon, 19 May 2025 14:42:59 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46q55yq8wd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 14:42:59 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54JEgulN50725234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 May 2025 14:42:56 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0014C20086;
	Mon, 19 May 2025 14:42:55 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6DC5B20085;
	Mon, 19 May 2025 14:42:55 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.111.67.168])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 19 May 2025 14:42:55 +0000 (GMT)
Message-ID: <8373c4a476e6a8f714a559d0fad8f3fed66089f1.camel@linux.ibm.com>
Subject: Re: [PATCH v1 2/5] KVM: s390: remove unneeded srcu lock
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com
Date: Mon, 19 May 2025 16:42:55 +0200
In-Reply-To: <20250514163855.124471-3-imbrenda@linux.ibm.com>
References: <20250514163855.124471-1-imbrenda@linux.ibm.com>
	 <20250514163855.124471-3-imbrenda@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE5MDEzNSBTYWx0ZWRfX9JB+3b8XV/QD +v4QIoyM4LQ0YKQO2skMiElEpiAlKKu8FuqvK75YciQpRn0xhEwdJAhMS5F8v6He9JRtcsEG263 bihdZACvndctZjF5jy/NdPaYgQ/J/61KyLvzn2PFSwkVCJsgCy7QyzGDjWjMFH3lWzCKAfoOM1X
 29ga4jKqK0n18asg8aKt2z4SmYQbEEiVUIdV2ZesTYXhdlRZ7VcP6cxkEgXP/e7rpA+ODYRFDiK cAGW3zTOITZJANxdkpxzmW5EEidUvL1JsafWdbu/zcyUu5j2gn3PzTLIBblKZ8ofC1Fbx3RD8DD 95h9OEx8W4Vy9XxsTHJqMIsLZ8Yjk48c/a+cuKCa023P/smbJqhLQAjOHWxK7nhWpvH388F0ohv
 JLeWDq+duWGrY5leXaYSniLLXupGcY1N5+zEvMBIkduRF/qWnzeYWHVKNDKXaYtvJE3T3Wpj
X-Proofpoint-ORIG-GUID: Kvm0tqNSrvW0som2LyxP5btC7jvBweJ5
X-Proofpoint-GUID: Kvm0tqNSrvW0som2LyxP5btC7jvBweJ5
X-Authority-Analysis: v=2.4 cv=P406hjAu c=1 sm=1 tr=0 ts=682b4374 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=8L8LAccZYskMU-B2xLIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-19_06,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1011 mlxscore=0 adultscore=0 impostorscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505190135

On Wed, 2025-05-14 at 18:38 +0200, Claudio Imbrenda wrote:
> All paths leading to handle_essa() already hold the kvm->srcu.
> Remove unneeded srcu locking from handle_essa().
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Why are you removing it tho?
It should be very low cost and it makes the code more robust,
since handle_essa itself ensures that it has the lock.
It is also easier to understand which synchronization the function does.
You could of course add a comment stating that the kvm srcu read side needs
to be held. I think this would be good to have if you really don't want the
srcu_read_lock here.
But then you might also want that documented up the call chain.

> ---
>  arch/s390/kvm/priv.c | 4 ----
>  1 file changed, 4 deletions(-)
>=20
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 1a49b89706f8..758cefb5bac7 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -1297,12 +1297,8 @@ static int handle_essa(struct kvm_vcpu *vcpu)
>  		/* Retry the ESSA instruction */
>  		kvm_s390_retry_instr(vcpu);
>  	} else {
> -		int srcu_idx;
> -
>  		mmap_read_lock(vcpu->kvm->mm);
> -		srcu_idx =3D srcu_read_lock(&vcpu->kvm->srcu);
>  		i =3D __do_essa(vcpu, orc);
> -		srcu_read_unlock(&vcpu->kvm->srcu, srcu_idx);
>  		mmap_read_unlock(vcpu->kvm->mm);
>  		if (i < 0)
>  			return i;

--=20
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen / Registergericht: Amtsgericht Stuttg=
art, HRB 243294

