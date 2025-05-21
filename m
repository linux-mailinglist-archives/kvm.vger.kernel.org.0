Return-Path: <kvm+bounces-47286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9FBEABF955
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 17:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F7A99E3FBC
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 15:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5523320E33D;
	Wed, 21 May 2025 15:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Y/29+1A0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3544C1C8FBA;
	Wed, 21 May 2025 15:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747841409; cv=none; b=WlspbWMpbiwFsfVnhkeqAo/lYM8ow9aEJqCNmXLmWJqpjAuk/ubfqAXJoEQvfJWaIyKB4kJVjCNkKkSB1w7j6NukMFu3QnbHZnPDGLAXNkQAvtL+0oehq/pVpO3s01egptz+qkYHgjZGNzsTKWmye5hIiwZUxO0b6qUG3CNb0Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747841409; c=relaxed/simple;
	bh=NQVCx8DJz037xdWpUV0+yuxLoft+Vhs4PizmnZq9jk4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=maWFYU95PnRUk0zEERY1VrMohSKaYv3KEOtpryaq7EPS0oeSAJsGd1KxhTlOvhbApkQ7adT7i7LgBv/GL45q3D6lcSyZSB5wpiUaAfMg0DTESwKEH+/Bjn8nL6f+Nx4EnVu/LflsajrHP7uuDL2xzyITnUlbxNkDWslGa9/DtYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Y/29+1A0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L6pkip012333;
	Wed, 21 May 2025 15:30:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=7o0zDT
	0xvFwHifzeTcpK9xCazj7EiT7zPfeAlLbli7k=; b=Y/29+1A0eOLPcOLFBl0AIt
	7LkIeiaVuPZz1OcEQB5QLqgak9WxiCfJN0/NJ16gTyZdwIslY7ZFvVYgLc04r5jH
	fAT/oawMVRHurRLvaqrlPF/almLHe+LIKk1DMRzFWHuv+e28UEGreHVlxVWmrlTj
	tXuP3llmt8uh7RGSpDU9SW3PQ8DA/Uud7qxabGFkcQdrVimr984r8B9zmbG1vicP
	qR9LTYg7s1/nfyo/mdc5MWQTOOj4C+0tvh3wtbFXH2DmkhDGAdUKXu0DCuDXv/iS
	b/ccXNIM2uYj82ejo8ROAJU4lV5VXCYBzSct4YbbVEjRSSCIZs6dkM6FdE5LxvGg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46rye6mx5k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 15:30:04 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54LDlwXM032087;
	Wed, 21 May 2025 15:30:03 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnmct4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 15:30:03 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54LFU0Fq57671946
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 15:30:00 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E7E0E20049;
	Wed, 21 May 2025 15:29:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 89B9B20040;
	Wed, 21 May 2025 15:29:59 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.152.224.80])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 21 May 2025 15:29:59 +0000 (GMT)
Message-ID: <d495d17902955839b0d7d092334b47efbdcb55a1.camel@linux.ibm.com>
Subject: Re: [PATCH v1 4/5] KVM: s390: refactor and split some gmap helpers
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com
Date: Wed, 21 May 2025 17:30:00 +0200
In-Reply-To: <20250521171930.2edaaa8a@p-imbrenda>
References: <20250514163855.124471-1-imbrenda@linux.ibm.com>
		<20250514163855.124471-5-imbrenda@linux.ibm.com>
		<277aa125e8edaf55e82ca66a15b26eee6ba3320b.camel@linux.ibm.com>
	 <20250521171930.2edaaa8a@p-imbrenda>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDE0NyBTYWx0ZWRfX/gOQ6auqfxAV P3lAo1ofiZ4ufJ/K2VNmuUjDCkhHqw9oLIaicQFMgY519V3vGUepnvPF5+qAlWQ8genMUKT7Qv6 GijfH10brSXOItj62Sw+UGjwyWxmaRsYmD8CcOdce2zDOIRH2B+7XUP9C09TZ0r2dmn0GFW7rza
 Tz+G+PJp2QGrMxZSj5zMBp4q7Nh8oH3XSZxbIf4wy8s6jPFCMjx1YGHr0XHhR9eppiA4Y4nzEVl EwLA9SU69HRdIICcHekYyeZRyLfAxFNWAZBWTLRkqYtQfjYalsHhIe7AiSNLcygPI0ySf8kr4c/ JpK/cXbpkpgS6WzffKvOjgLCOc8RGaISOrhzCLfipmFxPy6Jk64m0LAkXhqwWFibFFYWgRyeu79
 2hsoC0cn38ZID3wSHkYvTwnXJsVV170D/ZFNpO4ooSqFZPCsUUteycLq2lDYApwJLRmcth+b
X-Authority-Analysis: v=2.4 cv=esrfzppX c=1 sm=1 tr=0 ts=682df17c cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=UkI2F8NoeH3bRX2lVokA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: c5A_8-G_TcL3NhptZE7JwpUPQ9FFjjkj
X-Proofpoint-GUID: c5A_8-G_TcL3NhptZE7JwpUPQ9FFjjkj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_04,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 suspectscore=0 spamscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505210147

On Wed, 2025-05-21 at 17:19 +0200, Claudio Imbrenda wrote:
> On Wed, 21 May 2025 16:55:18 +0200
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
>=20
> > On Wed, 2025-05-14 at 18:38 +0200, Claudio Imbrenda wrote:
> > > Refactor some gmap functions; move the implementation into a separate
> > > file with only helper functions. The new helper functions work on vm
> > > addresses, leaving all gmap logic in the gmap functions, which mostly
> > > become just wrappers.
> > >=20
> > > The whole gmap handling is going to be moved inside KVM soon, but the
> > > helper functions need to touch core mm functions, and thus need to
> > > stay in the core of kernel.
> > >=20
> > > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > > ---
> > >  MAINTAINERS                          |   2 +
> > >  arch/s390/include/asm/gmap_helpers.h |  18 ++
> > >  arch/s390/kvm/diag.c                 |  11 +-
> > >  arch/s390/kvm/kvm-s390.c             |   3 +-
> > >  arch/s390/mm/Makefile                |   2 +
> > >  arch/s390/mm/gmap.c                  |  46 ++---
> > >  arch/s390/mm/gmap_helpers.c          | 266 +++++++++++++++++++++++++=
++
> > >  7 files changed, 307 insertions(+), 41 deletions(-)
> > >  create mode 100644 arch/s390/include/asm/gmap_helpers.h
> > >  create mode 100644 arch/s390/mm/gmap_helpers.c
> > >  =20
[...]

> > > +void __gmap_helper_zap_one(struct mm_struct *mm, unsigned long vmadd=
r) =20
> >=20
> > __gmap_helper_zap_mapping_pte ?
>=20
> but I'm not taking a pte as parameter

The pte being zapped is the one mapping vmaddr, right?
>=20
> >=20
> > > +{
> > > +	struct vm_area_struct *vma;
> > > +	spinlock_t *ptl;
> > > +	pte_t *ptep;
> > > +
> > > +	mmap_assert_locked(mm);
> > > +
> > > +	/* Find the vm address for the guest address */
> > > +	vma =3D vma_lookup(mm, vmaddr);
> > > +	if (!vma || is_vm_hugetlb_page(vma))
> > > +		return;
> > > +
> > > +	/* Get pointer to the page table entry */
> > > +	ptep =3D get_locked_pte(mm, vmaddr, &ptl);
> > > +	if (!likely(ptep)) =20
> >=20
> > if (unlikely(!ptep)) reads nicer to me.
>=20
> ok
>=20
> >=20
> > > +		return;
> > > +	if (pte_swap(*ptep))
> > > +		ptep_zap_swap_entry(mm, pte_to_swp_entry(*ptep));
> > > +	pte_unmap_unlock(ptep, ptl);
> > > +}
> > > +EXPORT_SYMBOL_GPL(__gmap_helper_zap_one); =20
> >=20
> > Looks reasonable, but I'm not well versed enough in mm code to evaluate
> > that with confidence.
> >=20
> > > +
> > > +void __gmap_helper_discard(struct mm_struct *mm, unsigned long vmadd=
r, unsigned long end) =20
> >=20
> > Maybe call this gmap_helper_discard_nolock or something.
>=20
> maybe __gmap_helper_discard_unlocked?
>=20
> the __ prefix often implies lack of locking

_nolock *definitely* implies it :P

[...]

> >=20
> > The stuff below is from arch/s390/mm/gmap.c right?
> > Are you going to delete it from there?
>=20
> not in this series, but the next series will remove mm/gmap.c altogether

Can't you do it with this one?


[...]
--=20
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen / Registergericht: Amtsgericht Stuttg=
art, HRB 243294

