Return-Path: <kvm+bounces-57373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88DF6B546C3
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 11:19:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38279AC07A9
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 09:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C013279DDB;
	Fri, 12 Sep 2025 09:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="c70VdPsx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FFB266B6F;
	Fri, 12 Sep 2025 09:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757668646; cv=none; b=LHOtoO0m2Jiy5qRMvHD1ec8Q4/19XnZ7jQqv13coqdMlR2YiNyo5b0evySyqeFti4ncv9qXYXO+Xh30cvMWA4WhInxT+fyEfaKdrhUWKlV5JQ25D1kgA16r6RpOzQ4JzurzShjLX9+6mqSqLf8fvq0QfWsyJ/Q910aJD00Ojqpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757668646; c=relaxed/simple;
	bh=ySVkdDkZzRpGICWC/20iAQUj0OLivT9bOrUFLk7KceU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iyU/viO+vi2tVYYnJpA44jO/CfvhVdJVuJDx0VuNIW9kJe+753bWOYHPwx/fVvG1dgKuaLGy7+R/1tu8XMQn2xi6PSqwKvkL4Sic1FwmWrInLZyl4M8EuAs+9m1Y51H7h771tGCqOrInGXxEewM61T8McX5snU5+qXZNFzmjoMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=c70VdPsx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C9E9Mv029522;
	Fri, 12 Sep 2025 09:17:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=DIz8zw
	WBiXd9ENx7h03p1liHdRY8uIjoVFM9etGbA7o=; b=c70VdPsxZqkArlfTbL+eaX
	Rb1FstmeOwpKPXSjkw/spOYUMdbdoqAUFVKFdjpA/mLylJiOopaIXk1n75N2olzR
	fUjObLcyB5vUyAwJBvAwblTo231IYbrf2Lz4gmuQiwGvj2YM4blRG5kcM/vGoQX+
	mTED5u4Jlj7rnE75y6Pc0a+khtBK+a048skNnpq84z3Sj0UFJS06VAmF2LY8o3AZ
	nDhB145qirB/RNz184QvFodN22wbqHDGeoil8D+uMCHIyfCOmYXwEVrqgAhUZ9K3
	RiOf2mHIq6EVfpEN+YwfdCU8e7GDKIC5uB4CGwWo6hxwOO0R4yg9tdPC916bYzTQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490ukexm69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 09:17:22 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58C8PXAG011428;
	Fri, 12 Sep 2025 09:17:08 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 490y9uteq9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 09:17:08 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58C9H42p50725220
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 09:17:04 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8A22B20040;
	Fri, 12 Sep 2025 09:17:04 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C0E5920049;
	Fri, 12 Sep 2025 09:17:03 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.111.85.40])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 12 Sep 2025 09:17:03 +0000 (GMT)
Message-ID: <267557ab6a061d55e4961312f4dc756bd4e0eaec.camel@linux.ibm.com>
Subject: Re: [PATCH v2 03/20] KVM: s390: Add gmap_helper_set_unused()
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        david@redhat.com, gerald.schaefer@linux.ibm.com
Date: Fri, 12 Sep 2025 11:17:02 +0200
In-Reply-To: <20250910180746.125776-4-imbrenda@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	 <20250910180746.125776-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDE5NSBTYWx0ZWRfX9vod4ksvTBXZ
 lXEEFKjjeWBG0T5MizFJ0fDJMzoOP5vQag6TKNAxhfISFTbNDAvl7jMbR43gjgrFEDupgFy72a6
 Z/MhJp76zEFIiUasO84SmUGdyyDU9XQ+jN6r3U3oyb6U6WLTtKSIu5G8ZMH4peXLe2OxtiUSJqK
 syDO3T/tmeC61tzAuY7DC6V77hpeVPOBoss6ZfXaTFS6JshsOOxMHhgaSwR1rzDwxmHmg5t3Amd
 Uaq5Nq/SwiiJvH48lscBk7DwZZnacQwR2r4bAgxbZBBljhuHGm3TUpoMcqCr8XghxPYoZOhOrG5
 MZJ4HpgYAlRyK2w77rf9V9DQ24WhmlCVeOSidtw9lK6jd9UCzop0cAbeyuHlreeFSg43WLxSCXV
 pSAIVJFM
X-Proofpoint-ORIG-GUID: y0Ll2Sz6P_Mm42B1st_zSz2mcQI1AQhg
X-Proofpoint-GUID: y0Ll2Sz6P_Mm42B1st_zSz2mcQI1AQhg
X-Authority-Analysis: v=2.4 cv=StCQ6OO0 c=1 sm=1 tr=0 ts=68c3e522 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=fI3iV-jTyyiWxqSZq_oA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1011 adultscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060195

On Wed, 2025-09-10 at 20:07 +0200, Claudio Imbrenda wrote:
> Add gmap_helper_set_unused() to mark userspace ptes as unused.
>=20
> Core mm code will use that information to discard unused pages instead
> of attempting to swap them.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

LGTM
> ---
>  arch/s390/include/asm/gmap_helpers.h |  1 +
>  arch/s390/mm/gmap_helpers.c          | 64 ++++++++++++++++++++++++++++
>  2 files changed, 65 insertions(+)
>=20
> diff --git a/arch/s390/include/asm/gmap_helpers.h b/arch/s390/include/asm=
/gmap_helpers.h
> index 5356446a61c4..459bd39d0887 100644
> --- a/arch/s390/include/asm/gmap_helpers.h
> +++ b/arch/s390/include/asm/gmap_helpers.h
> @@ -11,5 +11,6 @@
>  void gmap_helper_zap_one_page(struct mm_struct *mm, unsigned long vmaddr=
);
>  void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, uns=
igned long end);
>  int gmap_helper_disable_cow_sharing(void);
> +void gmap_helper_set_unused(struct mm_struct *mm, unsigned long vmaddr);
> =20
>  #endif /* _ASM_S390_GMAP_HELPERS_H */
> diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
> index a45d417ad951..69ffc0c6b654 100644
> --- a/arch/s390/mm/gmap_helpers.c
> +++ b/arch/s390/mm/gmap_helpers.c
> @@ -91,6 +91,70 @@ void gmap_helper_discard(struct mm_struct *mm, unsigne=
d long vmaddr, unsigned lo
>  }
>  EXPORT_SYMBOL_GPL(gmap_helper_discard);
> =20
> +/**
> + * gmap_helper_set_unused() - mark a pte entry as unused
> + * @mm: the mm
> + * @vmaddr: the userspace address whose pte is to be marked
> + *
> + * Mark the pte corresponding the given address as unused. This will cau=
se
> + * core mm code to just drop this page instead of swapping it.
> + *
> + * This function needs to be called with interrupts disabled (for exampl=
e
> + * while holding a spinlock), or while holding the mmap lock. Normally t=
his
> + * function is called as a result of an unmap operation, and thus KVM co=
mmon
> + * code will already hold kvm->mmu_lock in write mode.
> + *
> + * Context: Needs to be called while holding the mmap lock or with inter=
rupts
> + *          disabled.
> + */
> +void gmap_helper_set_unused(struct mm_struct *mm, unsigned long vmaddr)

Can you give this a better name? E.g. gmap_helper_try_set_pte_unused

> +{
> +	pmd_t *pmdp, pmd, pmdval;
> +	pud_t *pudp, pud;
> +	p4d_t *p4dp, p4d;
> +	pgd_t *pgdp, pgd;
> +	spinlock_t *ptl;
> +	pte_t *ptep;
> +
> +	pgdp =3D pgd_offset(mm, vmaddr);
> +	pgd =3D pgdp_get(pgdp);
> +	if (pgd_none(pgd) || !pgd_present(pgd))
> +		return;
> +
> +	p4dp =3D p4d_offset(pgdp, vmaddr);
> +	p4d =3D p4dp_get(p4dp);
> +	if (p4d_none(p4d) || !p4d_present(p4d))
> +		return;
> +
> +	pudp =3D pud_offset(p4dp, vmaddr);
> +	pud =3D pudp_get(pudp);
> +	if (pud_none(pud) || pud_leaf(pud) || !pud_present(pud))
> +		return;
> +
> +	pmdp =3D pmd_offset(pudp, vmaddr);
> +	pmd =3D pmdp_get_lockless(pmdp);
> +	if (pmd_none(pmd) || pmd_leaf(pmd) || !pmd_present(pmd))
> +		return;
> +
> +	ptep =3D pte_offset_map_rw_nolock(mm, pmdp, vmaddr, &pmdval, &ptl);
> +	if (!ptep)
> +		return;
> +
> +	if (spin_trylock(ptl)) {

Missing the comment you promised :) about deadlock prevention.

> +		/*
> +		 * Make sure the pte we are touching is still the correct
> +		 * one. In theory this check should not be needed, but

Why should it not be needed? I.e. why should we be protected against modifi=
cation?
> +		 * better safe than sorry.
> +		 */
> +		if (likely(pmd_same(pmdval, pmdp_get_lockless(pmdp))))
> +			__atomic64_or(_PAGE_UNUSED, (long *)ptep);
> +		spin_unlock(ptl);
> +	}
> +
> +	pte_unmap(ptep);
> +}
> +EXPORT_SYMBOL_GPL(gmap_helper_set_unused);
> +
>  static int find_zeropage_pte_entry(pte_t *pte, unsigned long addr,
>  				   unsigned long end, struct mm_walk *walk)
>  {

--=20
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen / Registergericht: Amtsgericht Stuttg=
art, HRB 243294

