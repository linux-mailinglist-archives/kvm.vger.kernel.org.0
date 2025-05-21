Return-Path: <kvm+bounces-47279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6846BABF898
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 17:01:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83B2F177E4F
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 15:00:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E41D221DB1;
	Wed, 21 May 2025 14:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tFNsh+Jz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E85221734;
	Wed, 21 May 2025 14:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747839329; cv=none; b=hyBse/gw1cX4CxjbJXBke2yovChnAFzNEAYLOkuLveHSyy6NDukjJxp7xr84oqDDhXkfFXZutNZNRYN6kw5jMvhbspqCkkfPdqDhLSvrjpyLgiZiaTJY6C5TBD8R3NuTQipnDtPkX9bN3NA5/UZvz6ZdXgazZXGNz8nA+HiefUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747839329; c=relaxed/simple;
	bh=I/MbCTbkbOoeh3ZgLHf2kJdKEHxW9kO4btHqWJEZ5Z8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lqAsscAJpG23B0LXLi/8Q3mR1+WXPNfbe18/J+4va9DWhetgqdo1rIsDokBIbAZpdM/ujeLHDYVB/oLf/MQGftj8KnsEaZ5vRIlWPLEC0FUMFdITavdBEUf/1YCHN7ZFmoKM1sRUcT+6wKsBnDUyifStPH35B/BTNrirxLHbBZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tFNsh+Jz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54LAmYj6030456;
	Wed, 21 May 2025 14:55:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0EYJU7
	pVSfDrMJSR7hg7/MazzigvOtwGVR7mI5/4+/M=; b=tFNsh+JzQdUNPPc2UB78Gy
	T6iXu8Mw3ATIt7zChaAhe8dFt5dZN6a3aEDII0zlLjzhuLfgRO5OHFQOTbNDHF7E
	lLFgnrTqSsyiKqEMwKBDUBzcyALGpsI4aBXssml4Kj6tHUbQ20KFlAoSFmNWedkE
	0aBY8td6v/NPF/I+//SXLHdpO84JKq1U5Rte+2E2U1zs0npps4s4JrxRFwJ7HhH6
	jlfttA3redBuo3XvWfCmLoo5osxvelp0mLojmgsqP8EVYNtMHevlSHoWEcBHrfYy
	RmqiX7JxHNs8ufsvg6YrpXSE3UQ/zNk9X+DQpSN2dTwS+GzrMFFUobi+M7RLa7RA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46s3d5kv7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 14:55:24 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54LDp9ZK032066;
	Wed, 21 May 2025 14:55:22 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwmq4pd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 14:55:22 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54LEtIFm39780636
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 14:55:18 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C0DC020040;
	Wed, 21 May 2025 14:55:18 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 521642004B;
	Wed, 21 May 2025 14:55:18 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.152.224.80])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 21 May 2025 14:55:18 +0000 (GMT)
Message-ID: <277aa125e8edaf55e82ca66a15b26eee6ba3320b.camel@linux.ibm.com>
Subject: Re: [PATCH v1 4/5] KVM: s390: refactor and split some gmap helpers
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com
Date: Wed, 21 May 2025 16:55:18 +0200
In-Reply-To: <20250514163855.124471-5-imbrenda@linux.ibm.com>
References: <20250514163855.124471-1-imbrenda@linux.ibm.com>
		 <20250514163855.124471-5-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: 2nwI7Xt83lcagCoJITqrHqtm6yGnjYcS
X-Proofpoint-ORIG-GUID: 2nwI7Xt83lcagCoJITqrHqtm6yGnjYcS
X-Authority-Analysis: v=2.4 cv=cM/gskeN c=1 sm=1 tr=0 ts=682de95c cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=JooEMsx-TsJ-eZTz-D8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDE0MiBTYWx0ZWRfXysPpKCaw3Ewu XxFAuvo3+ql69Bm4Z0pKpTlrn6mX0b8aoSZa7DyfOymji3WPlx29IOojkWKHVRGM7YhaC+jjooG /u2eBYhO7H6XTE39FLGnmTt+Byr+q26TpZl17ZK90cnRpqEVUldrYMIr0LJtL4Q5t9e+iAS6CII
 H6Pp4jd52YbQSBp7NZVSOmJn5/WJpqfX8eUN4mfE+yuhYrHtcsjcZPoqfu21pCFC0L+pWg82v3R /oaq059zwldFTqncW5EBgFdf2Nr81ysu875kR1sLDyHXRx4qz709otZg02xu1+A4aD+IUirnMzH SLXoFeZwICVEFExhg8kk6/xSiqhLLj3CsV46SpvEUjF+6nKtpx3qMq3ZHbnrylC/l7D5qBqwEi7
 9SSJPNClchsC8la11fBrFzprY23Jr6hOYdguXTA4y7CukFhpjv7gu6uCacp15ZfIYC/cKB9Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_04,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505160000 definitions=main-2505210142

On Wed, 2025-05-14 at 18:38 +0200, Claudio Imbrenda wrote:
> Refactor some gmap functions; move the implementation into a separate
> file with only helper functions. The new helper functions work on vm
> addresses, leaving all gmap logic in the gmap functions, which mostly
> become just wrappers.
>=20
> The whole gmap handling is going to be moved inside KVM soon, but the
> helper functions need to touch core mm functions, and thus need to
> stay in the core of kernel.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  MAINTAINERS                          |   2 +
>  arch/s390/include/asm/gmap_helpers.h |  18 ++
>  arch/s390/kvm/diag.c                 |  11 +-
>  arch/s390/kvm/kvm-s390.c             |   3 +-
>  arch/s390/mm/Makefile                |   2 +
>  arch/s390/mm/gmap.c                  |  46 ++---
>  arch/s390/mm/gmap_helpers.c          | 266 +++++++++++++++++++++++++++
>  7 files changed, 307 insertions(+), 41 deletions(-)
>  create mode 100644 arch/s390/include/asm/gmap_helpers.h
>  create mode 100644 arch/s390/mm/gmap_helpers.c
>=20
[...]

> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 4869555ff403..17a2a57de3a2 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
>=20
[...]

>  void gmap_discard(struct gmap *gmap, unsigned long from, unsigned long t=
o)
>  {
> -	unsigned long gaddr, vmaddr, size;
> -	struct vm_area_struct *vma;
> +	unsigned long vmaddr, next, start, end;
> =20
>  	mmap_read_lock(gmap->mm);
> -	for (gaddr =3D from; gaddr < to;
> -	     gaddr =3D (gaddr + PMD_SIZE) & PMD_MASK) {
> -		/* Find the vm address for the guest address */
> -		vmaddr =3D (unsigned long)
> -			radix_tree_lookup(&gmap->guest_to_host,
> -					  gaddr >> PMD_SHIFT);
> +	for ( ; from < to; from =3D next) {
> +		next =3D ALIGN(from + 1, PMD_SIZE);

I think you can use pmd_addr_end(from, to) here...

> +		vmaddr =3D (unsigned long)radix_tree_lookup(&gmap->guest_to_host, from=
 >> PMD_SHIFT);
>  		if (!vmaddr)
>  			continue;
> -		vmaddr |=3D gaddr & ~PMD_MASK;
> -		/* Find vma in the parent mm */
> -		vma =3D find_vma(gmap->mm, vmaddr);
> -		if (!vma)
> -			continue;
> -		/*
> -		 * We do not discard pages that are backed by
> -		 * hugetlbfs, so we don't have to refault them.
> -		 */
> -		if (is_vm_hugetlb_page(vma))
> -			continue;
> -		size =3D min(to - gaddr, PMD_SIZE - (gaddr & ~PMD_MASK));
> -		zap_page_range_single(vma, vmaddr, size, NULL);
> +		start =3D vmaddr | (from & ~PMD_MASK);
> +		end =3D (vmaddr | (min(to - 1, next - 1) & ~PMD_MASK)) + 1;

... then simply do:
		end =3D vmaddr + (next - from);

> +		__gmap_helper_discard(gmap->mm, start, end);
>  	}
>  	mmap_read_unlock(gmap->mm);
>  }
> diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
> new file mode 100644
> index 000000000000..8e66586718f6
> --- /dev/null
> +++ b/arch/s390/mm/gmap_helpers.c
> @@ -0,0 +1,266 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + *  Helper functions for KVM guest address space mapping code
> + *
> + *    Copyright IBM Corp. 2007, 2025
> + *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
> + *               Martin Schwidefsky <schwidefsky@de.ibm.com>
> + *               David Hildenbrand <david@redhat.com>
> + *               Janosch Frank <frankja@linux.vnet.ibm.com>
> + */
> +#include <linux/mm_types.h>
> +#include <linux/mmap_lock.h>
> +#include <linux/mm.h>
> +#include <linux/hugetlb.h>
> +#include <linux/pagewalk.h>
> +#include <linux/ksm.h>
> +#include <asm/gmap_helpers.h>

Please add documentation to all these functions for those of us that
don't live and breath mm code :)

> +
> +static void ptep_zap_swap_entry(struct mm_struct *mm, swp_entry_t entry)
> +{
> +	if (!non_swap_entry(entry))
> +		dec_mm_counter(mm, MM_SWAPENTS);
> +	else if (is_migration_entry(entry))
> +		dec_mm_counter(mm, mm_counter(pfn_swap_entry_folio(entry)));
> +	free_swap_and_cache(entry);
> +}
> +
> +void __gmap_helper_zap_one(struct mm_struct *mm, unsigned long vmaddr)

__gmap_helper_zap_mapping_pte ?

> +{
> +	struct vm_area_struct *vma;
> +	spinlock_t *ptl;
> +	pte_t *ptep;
> +
> +	mmap_assert_locked(mm);
> +
> +	/* Find the vm address for the guest address */
> +	vma =3D vma_lookup(mm, vmaddr);
> +	if (!vma || is_vm_hugetlb_page(vma))
> +		return;
> +
> +	/* Get pointer to the page table entry */
> +	ptep =3D get_locked_pte(mm, vmaddr, &ptl);
> +	if (!likely(ptep))

if (unlikely(!ptep)) reads nicer to me.

> +		return;
> +	if (pte_swap(*ptep))
> +		ptep_zap_swap_entry(mm, pte_to_swp_entry(*ptep));
> +	pte_unmap_unlock(ptep, ptl);
> +}
> +EXPORT_SYMBOL_GPL(__gmap_helper_zap_one);

Looks reasonable, but I'm not well versed enough in mm code to evaluate
that with confidence.

> +
> +void __gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, u=
nsigned long end)

Maybe call this gmap_helper_discard_nolock or something.

> +{
> +	struct vm_area_struct *vma;
> +	unsigned long next;
> +
> +	mmap_assert_locked(mm);
> +
> +	while (vmaddr < end) {
> +		vma =3D find_vma_intersection(mm, vmaddr, end);
> +		if (!vma)
> +			break;
> +		vmaddr =3D max(vmaddr, vma->vm_start);
> +		next =3D min(end, vma->vm_end);
> +		if (!is_vm_hugetlb_page(vma))
> +			zap_page_range_single(vma, vmaddr, next - vmaddr, NULL);
> +		vmaddr =3D next;
> +	}
> +}
> +
> +void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, uns=
igned long end)
> +{
> +	mmap_read_lock(mm);
> +	__gmap_helper_discard(mm, vmaddr, end);
> +	mmap_read_unlock(mm);
> +}
> +EXPORT_SYMBOL_GPL(gmap_helper_discard);
> +
> +static int pmd_lookup(struct mm_struct *mm, unsigned long addr, pmd_t **=
pmdp)
> +{
> +	struct vm_area_struct *vma;
> +	pgd_t *pgd;
> +	p4d_t *p4d;
> +	pud_t *pud;
> +
> +	/* We need a valid VMA, otherwise this is clearly a fault. */
> +	vma =3D vma_lookup(mm, addr);
> +	if (!vma)
> +		return -EFAULT;
> +
> +	pgd =3D pgd_offset(mm, addr);
> +	if (!pgd_present(*pgd))
> +		return -ENOENT;

What about pgd_bad?

> +
> +	p4d =3D p4d_offset(pgd, addr);
> +	if (!p4d_present(*p4d))
> +		return -ENOENT;
> +
> +	pud =3D pud_offset(p4d, addr);
> +	if (!pud_present(*pud))
> +		return -ENOENT;
> +
> +	/* Large PUDs are not supported yet. */
> +	if (pud_leaf(*pud))
> +		return -EFAULT;
> +
> +	*pmdp =3D pmd_offset(pud, addr);
> +	return 0;
> +}
> +
> +void __gmap_helper_set_unused(struct mm_struct *mm, unsigned long vmaddr=
)

What is this function for? Why do you introduce it now?

> +{
> +	spinlock_t *ptl;
> +	pmd_t *pmdp;
> +	pte_t *ptep;
> +
> +	mmap_assert_locked(mm);
> +
> +	if (pmd_lookup(mm, vmaddr, &pmdp))
> +		return;
> +	ptl =3D pmd_lock(mm, pmdp);
> +	if (!pmd_present(*pmdp) || pmd_leaf(*pmdp)) {
> +		spin_unlock(ptl);
> +		return;
> +	}
> +	spin_unlock(ptl);
> +
> +	ptep =3D pte_offset_map_lock(mm, pmdp, vmaddr, &ptl);
> +	if (!ptep)
> +		return;
> +	/* The last byte of a pte can be changed freely without ipte */
> +	__atomic64_or(_PAGE_UNUSED, (long *)ptep);
> +	pte_unmap_unlock(ptep, ptl);
> +}
> +EXPORT_SYMBOL_GPL(__gmap_helper_set_unused);

The stuff below is from arch/s390/mm/gmap.c right?
Are you going to delete it from there?

> +static int find_zeropage_pte_entry(pte_t *pte, unsigned long addr,
> +				   unsigned long end, struct mm_walk *walk)
> +{

[...]

> +}
> +
> +static const struct mm_walk_ops find_zeropage_ops =3D {
> +	.pte_entry      =3D find_zeropage_pte_entry,
> +	.walk_lock      =3D PGWALK_WRLOCK,
> +};
> +
> +/*
> + * Unshare all shared zeropages, replacing them by anonymous pages. Note=
 that
> + * we cannot simply zap all shared zeropages, because this could later
> + * trigger unexpected userfaultfd missing events.
> + *
> + * This must be called after mm->context.allow_cow_sharing was
> + * set to 0, to avoid future mappings of shared zeropages.
> + *
> + * mm contracts with s390, that even if mm were to remove a page table,
> + * and racing with walk_page_range_vma() calling pte_offset_map_lock()
> + * would fail, it will never insert a page table containing empty zero
> + * pages once mm_forbids_zeropage(mm) i.e.
> + * mm->context.allow_cow_sharing is set to 0.
> + */
> +static int __gmap_helper_unshare_zeropages(struct mm_struct *mm)
> +{

[...]

> +}
> +
> +static int __gmap_helper_disable_cow_sharing(struct mm_struct *mm)
> +{

[...]

> +}
> +
> +/*
> + * Disable most COW-sharing of memory pages for the whole process:
> + * (1) Disable KSM and unmerge/unshare any KSM pages.
> + * (2) Disallow shared zeropages and unshare any zerpages that are mappe=
d.
> + *
> + * Not that we currently don't bother with COW-shared pages that are sha=
red
> + * with parent/child processes due to fork().
> + */
> +int gmap_helper_disable_cow_sharing(void)
> +{

[...]

> +}
> +EXPORT_SYMBOL_GPL(gmap_helper_disable_cow_sharing);

--=20
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen / Registergericht: Amtsgericht Stuttg=
art, HRB 243294

