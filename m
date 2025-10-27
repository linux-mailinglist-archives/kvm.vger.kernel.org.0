Return-Path: <kvm+bounces-61212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A3EC0FD1B
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 19:01:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F335119C7944
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 18:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9B752D6E4B;
	Mon, 27 Oct 2025 18:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XYwLgVZc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69498195FE8;
	Mon, 27 Oct 2025 18:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761588069; cv=none; b=hcBZ6v3hK9vBA5qMTD6zFJ+SMbEcagBoLHXU6cBD4sDJ5F2HDe+4t3Qxwtk2pCMNMhEoLzj1pqXMxVIT/XNtXxKt79WTOWlMx0EvwST2GK0+IwVJghQ2ApQOc1iXVQ5inwYGyujWB/MXzQLApzlfDYABGO9OgeRqA3MqDPsZDzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761588069; c=relaxed/simple;
	bh=9aOcg1vbKI7PBU73QuoyR/WmuERyo+h3GXdaWJTIjmI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qkpd8k/3aglazHkI52eiOXxZfKIVqVbzuQEQYGJgCTsyok0B+fFzEVAmTZ4jWTUN2bvOZVi9JBFPLs1wkOqnIDcTBTwrr6evCdrBiWqL1BHZE4uuk3wQDmWTUx1+XnmbN6OJoeoWf6S9TsuovJkLE35+JM/JmjPUL+ere4BrJfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XYwLgVZc; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59RDLCaX001054;
	Mon, 27 Oct 2025 18:01:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=b5qwh9
	L6C6fmvWd7okpW2IknesMw1cOqK+AvkIuKa/s=; b=XYwLgVZcpZ42SOLq56uszw
	dqTz1f2N7oTZzNi+eD9qFzGNY1I4VVjm3X58uiO57UKp/BS117EoprjU+CtR26eT
	MsbEm8J7PdEcJjRcqMG9SfC+i0K9T3EPrJLj+YVwFHTY6jaCaUnPa3CstU6H8lNI
	i4m3cZULWTlpMn5JaHopdG4YsirSxpFpQ7zaWmMSysk8FAC33+CWnwmnKDz4aoEo
	41V+1BDH3J7/7ps1hr8qhkENaX0JKN7gMVldDZpOVJHx/q3/RNZwdbavJJlL8+c8
	5bKDeadT9K6WwUrgXpBcCx+XXAGeAW4OvTpQRd+Ji9yWgVtJ6yHkmwJImMwE8X6w
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0p9905v7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Oct 2025 18:01:01 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59RFBuBd030454;
	Mon, 27 Oct 2025 18:01:00 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a1acjpv03-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Oct 2025 18:00:59 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59RI0uN750004476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 18:00:56 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CE8F2004B;
	Mon, 27 Oct 2025 18:00:56 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7ADB020040;
	Mon, 27 Oct 2025 18:00:55 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.111.6.137])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 Oct 2025 18:00:55 +0000 (GMT)
Message-ID: <af9c7f4aedf71896dd2a9dd80837aae8f3428f93.camel@linux.ibm.com>
Subject: Re: [PATCH v2 03/20] KVM: s390: Add gmap_helper_set_unused()
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Date: Mon, 27 Oct 2025 19:00:15 +0100
In-Reply-To: <20250915133340.5b7c7d55@p-imbrenda>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
		<20250910180746.125776-4-imbrenda@linux.ibm.com>
		<267557ab6a061d55e4961312f4dc756bd4e0eaec.camel@linux.ibm.com>
	 <20250915133340.5b7c7d55@p-imbrenda>
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
X-Authority-Analysis: v=2.4 cv=JqL8bc4C c=1 sm=1 tr=0 ts=68ffb35d cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=8VGQ8kbb1ftBDG4DREYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 5N0wipb3_2nGq-XPGIzXfOSEEKDwk7Fl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAxOSBTYWx0ZWRfX2pk2kDco+Krr
 lli0zEmhll3XJyNXjv1tURfAlW7SW1MShJuAw12POKjiD0rUtxWgsfVgpRFLjJHJaEp6Hx/fMOB
 9F/VrkMl/KAXVKf8gUweHO02a/cJEfH4SXC6BqvAH3ipdjfztovQJ2iAvZixrFdmg2ch1PD6y9F
 h89Fp0HfytBuUY0boMdnwp5KddcnNMxt+mAzHrz7ua8uIEf6i9psMqNxV0X4cySfnw7JjM/QHW1
 E6azJd9hS3Nu94wORxrEi1vQQqxEXWUy9+BXdCkOpncMz4NJQl/Fj3wxEM4FhSRICCms/yQKbn+
 ABejSE1l1Px2XwdN6EqJ8oD9LYq93YS/Toa0DZriFl6aMqIUbz3BmNjwBWLwzT5sSAAaoiP+nDh
 WhA3vJQA5fv7B0k4K0te1BxJjg0NXg==
X-Proofpoint-ORIG-GUID: 5N0wipb3_2nGq-XPGIzXfOSEEKDwk7Fl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_07,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510250019

On Mon, 2025-09-15 at 13:33 +0200, Claudio Imbrenda wrote:
> On Fri, 12 Sep 2025 11:17:02 +0200
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
>=20
> > On Wed, 2025-09-10 at 20:07 +0200, Claudio Imbrenda wrote:
> > > Add gmap_helper_set_unused() to mark userspace ptes as unused.
> > >=20
> > > Core mm code will use that information to discard unused pages instea=
d
> > > of attempting to swap them.
> > >=20
> > > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com> =20
> >=20
> > LGTM
> > > ---
> > >  arch/s390/include/asm/gmap_helpers.h |  1 +
> > >  arch/s390/mm/gmap_helpers.c          | 64 ++++++++++++++++++++++++++=
++
> > >  2 files changed, 65 insertions(+)
> > >=20
> > > diff --git a/arch/s390/include/asm/gmap_helpers.h b/arch/s390/include=
/asm/gmap_helpers.h
> > > index 5356446a61c4..459bd39d0887 100644
> > > --- a/arch/s390/include/asm/gmap_helpers.h
> > > +++ b/arch/s390/include/asm/gmap_helpers.h
> > > @@ -11,5 +11,6 @@
> > >  void gmap_helper_zap_one_page(struct mm_struct *mm, unsigned long vm=
addr);
> > >  void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr,=
 unsigned long end);
> > >  int gmap_helper_disable_cow_sharing(void);
> > > +void gmap_helper_set_unused(struct mm_struct *mm, unsigned long vmad=
dr);
> > > =20
> > >  #endif /* _ASM_S390_GMAP_HELPERS_H */
> > > diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.=
c
> > > index a45d417ad951..69ffc0c6b654 100644
> > > --- a/arch/s390/mm/gmap_helpers.c
> > > +++ b/arch/s390/mm/gmap_helpers.c
> > > @@ -91,6 +91,70 @@ void gmap_helper_discard(struct mm_struct *mm, uns=
igned long vmaddr, unsigned lo
> > >  }
> > >  EXPORT_SYMBOL_GPL(gmap_helper_discard);
> > > =20
> > > +/**
> > > + * gmap_helper_set_unused() - mark a pte entry as unused
> > > + * @mm: the mm
> > > + * @vmaddr: the userspace address whose pte is to be marked
> > > + *
> > > + * Mark the pte corresponding the given address as unused. This will=
 cause
> > > + * core mm code to just drop this page instead of swapping it.
> > > + *
> > > + * This function needs to be called with interrupts disabled (for ex=
ample
> > > + * while holding a spinlock), or while holding the mmap lock. Normal=
ly this
> > > + * function is called as a result of an unmap operation, and thus KV=
M common
> > > + * code will already hold kvm->mmu_lock in write mode.
> > > + *
> > > + * Context: Needs to be called while holding the mmap lock or with i=
nterrupts
> > > + *          disabled.
> > > + */
> > > +void gmap_helper_set_unused(struct mm_struct *mm, unsigned long vmad=
dr) =20
> >=20
> > Can you give this a better name? E.g. gmap_helper_try_set_pte_unused
>=20
> yes
>=20
> >=20
> > > +{
> > > +	pmd_t *pmdp, pmd, pmdval;
> > > +	pud_t *pudp, pud;
> > > +	p4d_t *p4dp, p4d;
> > > +	pgd_t *pgdp, pgd;
> > > +	spinlock_t *ptl;
> > > +	pte_t *ptep;
> > > +
> > > +	pgdp =3D pgd_offset(mm, vmaddr);
> > > +	pgd =3D pgdp_get(pgdp);
> > > +	if (pgd_none(pgd) || !pgd_present(pgd))
> > > +		return;
> > > +
> > > +	p4dp =3D p4d_offset(pgdp, vmaddr);
> > > +	p4d =3D p4dp_get(p4dp);
> > > +	if (p4d_none(p4d) || !p4d_present(p4d))
> > > +		return;
> > > +
> > > +	pudp =3D pud_offset(p4dp, vmaddr);
> > > +	pud =3D pudp_get(pudp);
> > > +	if (pud_none(pud) || pud_leaf(pud) || !pud_present(pud))
> > > +		return;
> > > +
> > > +	pmdp =3D pmd_offset(pudp, vmaddr);
> > > +	pmd =3D pmdp_get_lockless(pmdp);
> > > +	if (pmd_none(pmd) || pmd_leaf(pmd) || !pmd_present(pmd))
> > > +		return;
> > > +
> > > +	ptep =3D pte_offset_map_rw_nolock(mm, pmdp, vmaddr, &pmdval, &ptl);
> > > +	if (!ptep)
> > > +		return;
> > > +
> > > +	if (spin_trylock(ptl)) { =20
> >=20
> > Missing the comment you promised :) about deadlock prevention.
>=20
> Ooops! will fix
>=20
> >=20
> > > +		/*
> > > +		 * Make sure the pte we are touching is still the correct
> > > +		 * one. In theory this check should not be needed, but =20
> >=20
> > Why should it not be needed? I.e. why should we be protected against mo=
dification?
>=20
> I will add this in a comment:
>=20
> a pmd pointing to a page table can change in only very few cases, and
> all cases will take the mm->mmap_lock in write mode and require IPC
> synchronization, which means that as long as interrupts are disabled or
> we are holding the mmap_lock, the pmd cannot change under our feet.
>=20
> by keeping interrupts disabled, we are basically stalling any remote
> CPUs that might want to change the pmd, as the IPC will not complete
> until we re-enable them.
>=20
> in our case, we call this function after calling pgste_get_lock(),
> which will disable interrupts until pgste_set_unlock() is called.
>=20
> > > +		 * better safe than sorry.
> > > +		 */
> > > +		if (likely(pmd_same(pmdval, pmdp_get_lockless(pmdp))))
> > > +			__atomic64_or(_PAGE_UNUSED, (long *)ptep);

Should we do a WARN_ONCE? Would we be notified if it shows up in CI?
Is the "if" even meaningful? That is, if the pmd is not the same for what
ever reason, are we guaranteed to see it here.
Does taking the page table lock also lock the pmd table? (I assume not)
What are the consequences of the or if the pmd is not the same, arbitrary m=
emory corruption?

> > > +		spin_unlock(ptl);
> > > +	}
> > > +
> > > +	pte_unmap(ptep);
> > > +}
> > > +EXPORT_SYMBOL_GPL(gmap_helper_set_unused);
> > > +
> > >  static int find_zeropage_pte_entry(pte_t *pte, unsigned long addr,
> > >  				   unsigned long end, struct mm_walk *walk)
> > >  { =20
> >=20

--=20
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen / Registergericht: Amtsgericht Stuttg=
art, HRB 243294

