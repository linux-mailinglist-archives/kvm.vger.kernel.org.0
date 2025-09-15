Return-Path: <kvm+bounces-57566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A99B2B57904
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:50:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3744A1A2252D
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D87301472;
	Mon, 15 Sep 2025 11:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="trbEJjns"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8627301027;
	Mon, 15 Sep 2025 11:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757937003; cv=none; b=tLVj37nPgOb2HTS3cO+KDqIzLaKUgFemKMgiWf5D1s9R75TSMfvLxtNTyyxn1wM1LKBV8pt8mCcq3Yj+qXYy5ILSLrWpeF7GcV/qh8lZdFiqqZh7o+GxuH/IpKib7KuuDhdFfmYNgaRbKv5rR0ey0ko4sqhNWb/H58Mw2ARxiuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757937003; c=relaxed/simple;
	bh=oq7zqnEn2Kn/Q7TN0dqh7+P/G4bxyO5T3t6wT/0F/2U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LvK8d00lbV/aBJBzo1oMNqc8+P3QROdPbRrKk1+eI8cLSBXJpwA1qTx+RgBzgKWz4HD1A0u3Hm6OkfuznCTk7i8oN/8Ajzcy1OLR0YCCv8sTzoYi3z+CIKSC8W3SzhHnZhvqtd016pDr+sSwbPF4tJAL6ughYXDTI971nUtC8QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=trbEJjns; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F9b8L9018925;
	Mon, 15 Sep 2025 11:49:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5LHMnu
	vf0bgpZH/W0ZoJLkJ12wvwi6TA0IFj7Z4pQ+0=; b=trbEJjnsEhOtFml8f2JNJ9
	oIgTKtEJzJNGLQbZvoFdK7VS5XMh0NSmVZ71qzxOXxx6YPOjsDBm8GfGpZ4/JwT5
	YE8EOS7qO/hpnekr0LsjjKX4jKJgJbjstGteUe8+JQFkBCejoqJObh9Fcg5KfBjM
	jKDMys2KmVshDPIkDtYIFPr3G7F7aTy+Vt7UI1TVf6010G0NwE9n68db+i+JIXa0
	KhzFxqgcifOt1wbLhNIYuNupJdPlaTM0lchjGfQJHpcCBInpFabNxx5yeTK0ZvY/
	picanu9g1q7DUjxj8w385jqk+TsTePvk0TyfG/u6lEtTI6so9xyPs8WaVj61IzQg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496gat0mpa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 11:49:58 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58F9IMZS008987;
	Mon, 15 Sep 2025 11:49:57 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 495nn35x52-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 11:49:57 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58FBnr4C27591380
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 11:49:54 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D6B042004B;
	Mon, 15 Sep 2025 11:49:53 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1822220040;
	Mon, 15 Sep 2025 11:49:53 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.29.90])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 15 Sep 2025 11:49:53 +0000 (GMT)
Date: Mon, 15 Sep 2025 13:33:40 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 03/20] KVM: s390: Add gmap_helper_set_unused()
Message-ID: <20250915133340.5b7c7d55@p-imbrenda>
In-Reply-To: <267557ab6a061d55e4961312f4dc756bd4e0eaec.camel@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	<20250910180746.125776-4-imbrenda@linux.ibm.com>
	<267557ab6a061d55e4961312f4dc756bd4e0eaec.camel@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=BKWzrEQG c=1 sm=1 tr=0 ts=68c7fd66 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=d-hWxweB35LoMggxsIgA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: KfUiq7uAd8rDqM640HlZyR_hmSMpPKL5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE1MDA4NiBTYWx0ZWRfX00uLg7Ulu6E0
 /umdJQexqr6xg+tf1LVQkkMLhqlLjUC8+yJd70S7fPgoaU4LYBy6SL+GdPoW3v+NjfMVz3AikaJ
 YP37QqPfKguFIqJmALzKyHntIP2ixqnYZWSMJE+2ynUk6C2BayBYTZmEF+YvlbGkd5UkCpJigUx
 CPvV7MHPiTYg1+GGOZ+bdGjPJGu3FeX1X19OxgJCNNz2SWRbXERsWPYYPYmdJk8Xx1TeAwmA4Hu
 rWNrvkrjFRXIRQ8SqBiYFct1SZC7T+7iGcmMzt8JkenwsaOBG0VSRumhXuPmNEJIEK04robS/El
 90L26yRfvUFWBXQuYdx4x+sQf6Ugadw5NoObfjc9EdiezBdLhDyjcgHn2hoZEclAqI/n0kIk2Bs
 hVWpwQcS
X-Proofpoint-ORIG-GUID: KfUiq7uAd8rDqM640HlZyR_hmSMpPKL5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_05,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509150086

On Fri, 12 Sep 2025 11:17:02 +0200
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> On Wed, 2025-09-10 at 20:07 +0200, Claudio Imbrenda wrote:
> > Add gmap_helper_set_unused() to mark userspace ptes as unused.
> > 
> > Core mm code will use that information to discard unused pages instead
> > of attempting to swap them.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>  
> 
> LGTM
> > ---
> >  arch/s390/include/asm/gmap_helpers.h |  1 +
> >  arch/s390/mm/gmap_helpers.c          | 64 ++++++++++++++++++++++++++++
> >  2 files changed, 65 insertions(+)
> > 
> > diff --git a/arch/s390/include/asm/gmap_helpers.h b/arch/s390/include/asm/gmap_helpers.h
> > index 5356446a61c4..459bd39d0887 100644
> > --- a/arch/s390/include/asm/gmap_helpers.h
> > +++ b/arch/s390/include/asm/gmap_helpers.h
> > @@ -11,5 +11,6 @@
> >  void gmap_helper_zap_one_page(struct mm_struct *mm, unsigned long vmaddr);
> >  void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned long end);
> >  int gmap_helper_disable_cow_sharing(void);
> > +void gmap_helper_set_unused(struct mm_struct *mm, unsigned long vmaddr);
> >  
> >  #endif /* _ASM_S390_GMAP_HELPERS_H */
> > diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
> > index a45d417ad951..69ffc0c6b654 100644
> > --- a/arch/s390/mm/gmap_helpers.c
> > +++ b/arch/s390/mm/gmap_helpers.c
> > @@ -91,6 +91,70 @@ void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned lo
> >  }
> >  EXPORT_SYMBOL_GPL(gmap_helper_discard);
> >  
> > +/**
> > + * gmap_helper_set_unused() - mark a pte entry as unused
> > + * @mm: the mm
> > + * @vmaddr: the userspace address whose pte is to be marked
> > + *
> > + * Mark the pte corresponding the given address as unused. This will cause
> > + * core mm code to just drop this page instead of swapping it.
> > + *
> > + * This function needs to be called with interrupts disabled (for example
> > + * while holding a spinlock), or while holding the mmap lock. Normally this
> > + * function is called as a result of an unmap operation, and thus KVM common
> > + * code will already hold kvm->mmu_lock in write mode.
> > + *
> > + * Context: Needs to be called while holding the mmap lock or with interrupts
> > + *          disabled.
> > + */
> > +void gmap_helper_set_unused(struct mm_struct *mm, unsigned long vmaddr)  
> 
> Can you give this a better name? E.g. gmap_helper_try_set_pte_unused

yes

> 
> > +{
> > +	pmd_t *pmdp, pmd, pmdval;
> > +	pud_t *pudp, pud;
> > +	p4d_t *p4dp, p4d;
> > +	pgd_t *pgdp, pgd;
> > +	spinlock_t *ptl;
> > +	pte_t *ptep;
> > +
> > +	pgdp = pgd_offset(mm, vmaddr);
> > +	pgd = pgdp_get(pgdp);
> > +	if (pgd_none(pgd) || !pgd_present(pgd))
> > +		return;
> > +
> > +	p4dp = p4d_offset(pgdp, vmaddr);
> > +	p4d = p4dp_get(p4dp);
> > +	if (p4d_none(p4d) || !p4d_present(p4d))
> > +		return;
> > +
> > +	pudp = pud_offset(p4dp, vmaddr);
> > +	pud = pudp_get(pudp);
> > +	if (pud_none(pud) || pud_leaf(pud) || !pud_present(pud))
> > +		return;
> > +
> > +	pmdp = pmd_offset(pudp, vmaddr);
> > +	pmd = pmdp_get_lockless(pmdp);
> > +	if (pmd_none(pmd) || pmd_leaf(pmd) || !pmd_present(pmd))
> > +		return;
> > +
> > +	ptep = pte_offset_map_rw_nolock(mm, pmdp, vmaddr, &pmdval, &ptl);
> > +	if (!ptep)
> > +		return;
> > +
> > +	if (spin_trylock(ptl)) {  
> 
> Missing the comment you promised :) about deadlock prevention.

Ooops! will fix

> 
> > +		/*
> > +		 * Make sure the pte we are touching is still the correct
> > +		 * one. In theory this check should not be needed, but  
> 
> Why should it not be needed? I.e. why should we be protected against modification?

I will add this in a comment:

a pmd pointing to a page table can change in only very few cases, and
all cases will take the mm->mmap_lock in write mode and require IPC
synchronization, which means that as long as interrupts are disabled or
we are holding the mmap_lock, the pmd cannot change under our feet.

by keeping interrupts disabled, we are basically stalling any remote
CPUs that might want to change the pmd, as the IPC will not complete
until we re-enable them.

in our case, we call this function after calling pgste_get_lock(),
which will disable interrupts until pgste_set_unlock() is called.

> > +		 * better safe than sorry.
> > +		 */
> > +		if (likely(pmd_same(pmdval, pmdp_get_lockless(pmdp))))
> > +			__atomic64_or(_PAGE_UNUSED, (long *)ptep);
> > +		spin_unlock(ptl);
> > +	}
> > +
> > +	pte_unmap(ptep);
> > +}
> > +EXPORT_SYMBOL_GPL(gmap_helper_set_unused);
> > +
> >  static int find_zeropage_pte_entry(pte_t *pte, unsigned long addr,
> >  				   unsigned long end, struct mm_walk *walk)
> >  {  
> 


