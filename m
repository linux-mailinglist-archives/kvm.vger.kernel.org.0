Return-Path: <kvm+bounces-47283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A7C8FABF910
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 17:19:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 505501893508
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 15:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B67B1E572F;
	Wed, 21 May 2025 15:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="F9J1VSiC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553D6450EE;
	Wed, 21 May 2025 15:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747840786; cv=none; b=gKKJHG11JGgWmPYzhgrvBFQqj/fv7+gpF5S0X+m9sq5/6x47g/Z81luKcNKvYKnhrmXVTde+YNEkZJka1yJtegmejdJlnI7DOB7aoL83VkunUUBFOiBmP9tb0FwEm1HgC7VxE8EXuS0k85SBl/cS5V9vVawidoHpT/RQ7vpLJKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747840786; c=relaxed/simple;
	bh=8kajQRciXcM+v2jKtdF091AHCUweZpDtNy1ghPaMu2k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EAVqc69jMnkpJt4KFQ5jJBZSWE3HMO1oNLWm/1PFyb+fIbLjN/dwm5nQPIu9IK/snJbsvrJPahpCoIUXPD1nUJ+ixcc8o/oJih3qHARU3PsGAIxsruv2HnsQqLgmHyAi6Rd572V4dWH9E0C5RgvddVPG8A9qPdoM0+QghBqWTvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=F9J1VSiC; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L9FCWT031716;
	Wed, 21 May 2025 15:19:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=8cpkKx
	96eM1JY/8KubiGuCVPHcHoi9ASMP2nsjBSNu4=; b=F9J1VSiClMo/nD2h1rPenS
	zEHGjvblGy/I6aWXYuFRqD9hv1K9gz/exIYH+sI9nJVAZ0Q5y9bUClVe4AHxfiW+
	Lf/8aEak6gHjShXt5eLBegiiB4JWufe6/8oSGhm6rkek2VQPJIFXvVCLve1rdtkT
	YKWCNJGQGPUk2Vlcfa7Ow7urSE1uIsaWgHIyXHDqolUXfwRWv0TjuEMyvI2JzFHN
	PIpeLDQJ9OG5x22seNEXe9UdptgfSlkauzh/ZHwbphYXK9D223fOyfN7O3d7CvDp
	+Z4mpnBUI5sSSuPEV+3Xjo72k3PeLEEgfrxm0qs6h2F/RRoIwqCPDqu1O1AmNcWw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46sc1j1rsm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 15:19:39 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54LDdgUl024711;
	Wed, 21 May 2025 15:19:39 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwkr4sf0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 15:19:39 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54LFJYOB56951132
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 15:19:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC3992004B;
	Wed, 21 May 2025 15:19:34 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA9DE20040;
	Wed, 21 May 2025 15:19:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.87.128.146])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 21 May 2025 15:19:33 +0000 (GMT)
Date: Wed, 21 May 2025 17:19:30 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v1 4/5] KVM: s390: refactor and split some gmap helpers
Message-ID: <20250521171930.2edaaa8a@p-imbrenda>
In-Reply-To: <277aa125e8edaf55e82ca66a15b26eee6ba3320b.camel@linux.ibm.com>
References: <20250514163855.124471-1-imbrenda@linux.ibm.com>
	<20250514163855.124471-5-imbrenda@linux.ibm.com>
	<277aa125e8edaf55e82ca66a15b26eee6ba3320b.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zggNftFWwiMGxJjsARBEw3PwLJirLFRY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDE0NyBTYWx0ZWRfX5KRUXMycrGrh cNmvzAcmdXUvuSYFW5KXK7xuspacr0heZk+xR7HqVhPdbkqjpZeKQJ0e766IlnS/StlFT8S2Bae CUtcxUuLs1k4L4Saip2nT1YEpCjeKRUvSi6vyVs1C3TthPIb05xZju5XJn6ITg+7SK92r4E3DUo
 loORkMl7J6VMV+Uompaar2rHEO5Bk/0YAH0uwnAXAvn2XaRJ0UxoPZ1ZgVBJDGIdv5etx1mV+RS AISTp88Q7pdEZvfkJY6dxSuLnegCvDLK0k2gPba+EQVJ3X4VFg4SmkGxzj4o5YoWOCtIBN0m677 rwqy+KUMuZs3NxMz7VeTzuiAA6WAFIvvdkgJp1Q7tHogWO8vP69xFBz8qMnV8wOGaG3XYXFC9tj
 +mEOzNRto4C7qs82iMsT+ZjdQ1YgSk3rIOOWaOGU/g18f8dYdL4Ysz0Tt2ZysT7L3k8get4C
X-Authority-Analysis: v=2.4 cv=GpdC+l1C c=1 sm=1 tr=0 ts=682def0b cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=UqvLA890_LbxyYRAN8EA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: zggNftFWwiMGxJjsARBEw3PwLJirLFRY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_04,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 malwarescore=0 clxscore=1015 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505160000 definitions=main-2505210147

On Wed, 21 May 2025 16:55:18 +0200
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> On Wed, 2025-05-14 at 18:38 +0200, Claudio Imbrenda wrote:
> > Refactor some gmap functions; move the implementation into a separate
> > file with only helper functions. The new helper functions work on vm
> > addresses, leaving all gmap logic in the gmap functions, which mostly
> > become just wrappers.
> > 
> > The whole gmap handling is going to be moved inside KVM soon, but the
> > helper functions need to touch core mm functions, and thus need to
> > stay in the core of kernel.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  MAINTAINERS                          |   2 +
> >  arch/s390/include/asm/gmap_helpers.h |  18 ++
> >  arch/s390/kvm/diag.c                 |  11 +-
> >  arch/s390/kvm/kvm-s390.c             |   3 +-
> >  arch/s390/mm/Makefile                |   2 +
> >  arch/s390/mm/gmap.c                  |  46 ++---
> >  arch/s390/mm/gmap_helpers.c          | 266 +++++++++++++++++++++++++++
> >  7 files changed, 307 insertions(+), 41 deletions(-)
> >  create mode 100644 arch/s390/include/asm/gmap_helpers.h
> >  create mode 100644 arch/s390/mm/gmap_helpers.c
> >   
> [...]
> 
> > diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> > index 4869555ff403..17a2a57de3a2 100644
> > --- a/arch/s390/mm/gmap.c
> > +++ b/arch/s390/mm/gmap.c
> >   
> [...]
> 
> >  void gmap_discard(struct gmap *gmap, unsigned long from, unsigned long to)
> >  {
> > -	unsigned long gaddr, vmaddr, size;
> > -	struct vm_area_struct *vma;
> > +	unsigned long vmaddr, next, start, end;
> >  
> >  	mmap_read_lock(gmap->mm);
> > -	for (gaddr = from; gaddr < to;
> > -	     gaddr = (gaddr + PMD_SIZE) & PMD_MASK) {
> > -		/* Find the vm address for the guest address */
> > -		vmaddr = (unsigned long)
> > -			radix_tree_lookup(&gmap->guest_to_host,
> > -					  gaddr >> PMD_SHIFT);
> > +	for ( ; from < to; from = next) {
> > +		next = ALIGN(from + 1, PMD_SIZE);  
> 
> I think you can use pmd_addr_end(from, to) here...

I guess

> 
> > +		vmaddr = (unsigned long)radix_tree_lookup(&gmap->guest_to_host, from >> PMD_SHIFT);
> >  		if (!vmaddr)
> >  			continue;
> > -		vmaddr |= gaddr & ~PMD_MASK;
> > -		/* Find vma in the parent mm */
> > -		vma = find_vma(gmap->mm, vmaddr);
> > -		if (!vma)
> > -			continue;
> > -		/*
> > -		 * We do not discard pages that are backed by
> > -		 * hugetlbfs, so we don't have to refault them.
> > -		 */
> > -		if (is_vm_hugetlb_page(vma))
> > -			continue;
> > -		size = min(to - gaddr, PMD_SIZE - (gaddr & ~PMD_MASK));
> > -		zap_page_range_single(vma, vmaddr, size, NULL);
> > +		start = vmaddr | (from & ~PMD_MASK);
> > +		end = (vmaddr | (min(to - 1, next - 1) & ~PMD_MASK)) + 1;  
> 
> ... then simply do:
> 		end = vmaddr + (next - from);

looks cleaner, yes

> 
> > +		__gmap_helper_discard(gmap->mm, start, end);
> >  	}
> >  	mmap_read_unlock(gmap->mm);
> >  }
> > diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
> > new file mode 100644
> > index 000000000000..8e66586718f6
> > --- /dev/null
> > +++ b/arch/s390/mm/gmap_helpers.c
> > @@ -0,0 +1,266 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + *  Helper functions for KVM guest address space mapping code
> > + *
> > + *    Copyright IBM Corp. 2007, 2025
> > + *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
> > + *               Martin Schwidefsky <schwidefsky@de.ibm.com>
> > + *               David Hildenbrand <david@redhat.com>
> > + *               Janosch Frank <frankja@linux.vnet.ibm.com>
> > + */
> > +#include <linux/mm_types.h>
> > +#include <linux/mmap_lock.h>
> > +#include <linux/mm.h>
> > +#include <linux/hugetlb.h>
> > +#include <linux/pagewalk.h>
> > +#include <linux/ksm.h>
> > +#include <asm/gmap_helpers.h>  
> 
> Please add documentation to all these functions for those of us that
> don't live and breath mm code :)

eh... yes I think it's a good idea

> 
> > +
> > +static void ptep_zap_swap_entry(struct mm_struct *mm, swp_entry_t entry)
> > +{
> > +	if (!non_swap_entry(entry))
> > +		dec_mm_counter(mm, MM_SWAPENTS);
> > +	else if (is_migration_entry(entry))
> > +		dec_mm_counter(mm, mm_counter(pfn_swap_entry_folio(entry)));
> > +	free_swap_and_cache(entry);
> > +}
> > +
> > +void __gmap_helper_zap_one(struct mm_struct *mm, unsigned long vmaddr)  
> 
> __gmap_helper_zap_mapping_pte ?

but I'm not taking a pte as parameter

> 
> > +{
> > +	struct vm_area_struct *vma;
> > +	spinlock_t *ptl;
> > +	pte_t *ptep;
> > +
> > +	mmap_assert_locked(mm);
> > +
> > +	/* Find the vm address for the guest address */
> > +	vma = vma_lookup(mm, vmaddr);
> > +	if (!vma || is_vm_hugetlb_page(vma))
> > +		return;
> > +
> > +	/* Get pointer to the page table entry */
> > +	ptep = get_locked_pte(mm, vmaddr, &ptl);
> > +	if (!likely(ptep))  
> 
> if (unlikely(!ptep)) reads nicer to me.

ok

> 
> > +		return;
> > +	if (pte_swap(*ptep))
> > +		ptep_zap_swap_entry(mm, pte_to_swp_entry(*ptep));
> > +	pte_unmap_unlock(ptep, ptl);
> > +}
> > +EXPORT_SYMBOL_GPL(__gmap_helper_zap_one);  
> 
> Looks reasonable, but I'm not well versed enough in mm code to evaluate
> that with confidence.
> 
> > +
> > +void __gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned long end)  
> 
> Maybe call this gmap_helper_discard_nolock or something.

maybe __gmap_helper_discard_unlocked?

the __ prefix often implies lack of locking

> 
> > +{
> > +	struct vm_area_struct *vma;
> > +	unsigned long next;
> > +
> > +	mmap_assert_locked(mm);
> > +
> > +	while (vmaddr < end) {
> > +		vma = find_vma_intersection(mm, vmaddr, end);
> > +		if (!vma)
> > +			break;
> > +		vmaddr = max(vmaddr, vma->vm_start);
> > +		next = min(end, vma->vm_end);
> > +		if (!is_vm_hugetlb_page(vma))
> > +			zap_page_range_single(vma, vmaddr, next - vmaddr, NULL);
> > +		vmaddr = next;
> > +	}
> > +}
> > +
> > +void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned long end)
> > +{
> > +	mmap_read_lock(mm);
> > +	__gmap_helper_discard(mm, vmaddr, end);
> > +	mmap_read_unlock(mm);
> > +}
> > +EXPORT_SYMBOL_GPL(gmap_helper_discard);
> > +
> > +static int pmd_lookup(struct mm_struct *mm, unsigned long addr, pmd_t **pmdp)
> > +{
> > +	struct vm_area_struct *vma;
> > +	pgd_t *pgd;
> > +	p4d_t *p4d;
> > +	pud_t *pud;
> > +
> > +	/* We need a valid VMA, otherwise this is clearly a fault. */
> > +	vma = vma_lookup(mm, addr);
> > +	if (!vma)
> > +		return -EFAULT;
> > +
> > +	pgd = pgd_offset(mm, addr);
> > +	if (!pgd_present(*pgd))
> > +		return -ENOENT;  
> 
> What about pgd_bad?

I don't know, this code is copied verbatim from mm/gmap.c

> 
> > +
> > +	p4d = p4d_offset(pgd, addr);
> > +	if (!p4d_present(*p4d))
> > +		return -ENOENT;
> > +
> > +	pud = pud_offset(p4d, addr);
> > +	if (!pud_present(*pud))
> > +		return -ENOENT;
> > +
> > +	/* Large PUDs are not supported yet. */
> > +	if (pud_leaf(*pud))
> > +		return -EFAULT;
> > +
> > +	*pmdp = pmd_offset(pud, addr);
> > +	return 0;
> > +}
> > +
> > +void __gmap_helper_set_unused(struct mm_struct *mm, unsigned long vmaddr)  
> 
> What is this function for? Why do you introduce it now?

this is for cmma handling, I'm introducing it now because it needs to
be in this file and I would like to put all the stuff in at once.
I will not need to touch this file anymore if I get this in now.

> 
> > +{
> > +	spinlock_t *ptl;
> > +	pmd_t *pmdp;
> > +	pte_t *ptep;
> > +
> > +	mmap_assert_locked(mm);
> > +
> > +	if (pmd_lookup(mm, vmaddr, &pmdp))
> > +		return;
> > +	ptl = pmd_lock(mm, pmdp);
> > +	if (!pmd_present(*pmdp) || pmd_leaf(*pmdp)) {
> > +		spin_unlock(ptl);
> > +		return;
> > +	}
> > +	spin_unlock(ptl);
> > +
> > +	ptep = pte_offset_map_lock(mm, pmdp, vmaddr, &ptl);
> > +	if (!ptep)
> > +		return;
> > +	/* The last byte of a pte can be changed freely without ipte */
> > +	__atomic64_or(_PAGE_UNUSED, (long *)ptep);
> > +	pte_unmap_unlock(ptep, ptl);
> > +}
> > +EXPORT_SYMBOL_GPL(__gmap_helper_set_unused);  
> 
> The stuff below is from arch/s390/mm/gmap.c right?
> Are you going to delete it from there?

not in this series, but the next series will remove mm/gmap.c altogether

> 
> > +static int find_zeropage_pte_entry(pte_t *pte, unsigned long addr,
> > +				   unsigned long end, struct mm_walk *walk)
> > +{  
> 
> [...]
> 
> > +}
> > +
> > +static const struct mm_walk_ops find_zeropage_ops = {
> > +	.pte_entry      = find_zeropage_pte_entry,
> > +	.walk_lock      = PGWALK_WRLOCK,
> > +};
> > +
> > +/*
> > + * Unshare all shared zeropages, replacing them by anonymous pages. Note that
> > + * we cannot simply zap all shared zeropages, because this could later
> > + * trigger unexpected userfaultfd missing events.
> > + *
> > + * This must be called after mm->context.allow_cow_sharing was
> > + * set to 0, to avoid future mappings of shared zeropages.
> > + *
> > + * mm contracts with s390, that even if mm were to remove a page table,
> > + * and racing with walk_page_range_vma() calling pte_offset_map_lock()
> > + * would fail, it will never insert a page table containing empty zero
> > + * pages once mm_forbids_zeropage(mm) i.e.
> > + * mm->context.allow_cow_sharing is set to 0.
> > + */
> > +static int __gmap_helper_unshare_zeropages(struct mm_struct *mm)
> > +{  
> 
> [...]
> 
> > +}
> > +
> > +static int __gmap_helper_disable_cow_sharing(struct mm_struct *mm)
> > +{  
> 
> [...]
> 
> > +}
> > +
> > +/*
> > + * Disable most COW-sharing of memory pages for the whole process:
> > + * (1) Disable KSM and unmerge/unshare any KSM pages.
> > + * (2) Disallow shared zeropages and unshare any zerpages that are mapped.
> > + *
> > + * Not that we currently don't bother with COW-shared pages that are shared
> > + * with parent/child processes due to fork().
> > + */
> > +int gmap_helper_disable_cow_sharing(void)
> > +{  
> 
> [...]
> 
> > +}
> > +EXPORT_SYMBOL_GPL(gmap_helper_disable_cow_sharing);  
> 


