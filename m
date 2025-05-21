Return-Path: <kvm+bounces-47289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7280ABFA0A
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 17:49:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3357C1652B5
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 15:46:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8F1521D5B0;
	Wed, 21 May 2025 15:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LsAvFhKA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D211C84BC;
	Wed, 21 May 2025 15:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747842110; cv=none; b=BEDp/jWo7hkYz2fTj7hsRYUQBlkoIRTUQdqxvW4wwVMkCspACsA3GN7W/Uda1hZGIELHiVtnSlbeU4bsMYNFRxpM/ubpWS3C1nccgI+CG0qTGHS+m1wvP5RyDWHJV3yzynBa8v1h2DcEUian4V8j+vMaN18vT6fBYztrgsqo94w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747842110; c=relaxed/simple;
	bh=iDmAXuSpRFm12+ceVhj/swPRK4xFIe8lEXfsApg2Pek=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n6RsxWasbIJ0+QKq3oAL/tfq+yQ+Ni7OYl9EgQ1VdHUtjkmhAWMPi1woomRQQx+t+DKw7XKQLzJbPfcs8LtMR1aCnMhCU+vezI0RxputQwul8PiYNNoHHFPDVMgTouFxPv8UukzuXN577vLVuhEHxMOVlocklX7THywzmtrMZk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LsAvFhKA; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L9FCYq031716;
	Wed, 21 May 2025 15:41:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=IKAQu5
	IogvcJTy6OEe0FaKFPJERjWpjgPjA0w8MRydY=; b=LsAvFhKA+F93MMzxmK1QSg
	kgdDl2KTkYMMhAyYyH1zJ0uYO9rR+bU7TAy1T+HVWYKe2tQFMaqg3KCbpx7aI0TN
	XAmAHLFaHadEECNWRNShb8c1fDxegkMW0UDiKPFKG43oyoVXYaIztMCcqPh513Kw
	kqINXg71oauoaBMw4r1G9UYuzOK4GB53T9kpY+RsSE/utLegvH/EOqhFxovwytjN
	FdU4IdZugWDbLrnivp23XFw9MgGP8SuKo1/s/loOh3jFSuxv41QPiI+R9EnXKC+5
	WLg3g2S0OcozqhdyXbcHWxA4cgi5f2Cwf+H2ebzWl/w5Inyj5zV8+G9MnYL3h97g
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46sc1j1va1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 15:41:45 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54LDdBme020708;
	Wed, 21 May 2025 15:41:44 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwkpvv33-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 15:41:44 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54LFff2e23200142
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 15:41:41 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 41A2B20040;
	Wed, 21 May 2025 15:41:41 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E23920049;
	Wed, 21 May 2025 15:41:40 +0000 (GMT)
Received: from p-imbrenda (unknown [9.87.128.146])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 21 May 2025 15:41:40 +0000 (GMT)
Date: Wed, 21 May 2025 17:41:37 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v1 4/5] KVM: s390: refactor and split some gmap helpers
Message-ID: <20250521174137.5b2baaf6@p-imbrenda>
In-Reply-To: <d495d17902955839b0d7d092334b47efbdcb55a1.camel@linux.ibm.com>
References: <20250514163855.124471-1-imbrenda@linux.ibm.com>
	<20250514163855.124471-5-imbrenda@linux.ibm.com>
	<277aa125e8edaf55e82ca66a15b26eee6ba3320b.camel@linux.ibm.com>
	<20250521171930.2edaaa8a@p-imbrenda>
	<d495d17902955839b0d7d092334b47efbdcb55a1.camel@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 0Ze8Le0WWSayln7yhE7IvNVulrbYeocC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDE1MyBTYWx0ZWRfX7dUkgOw8enNE ekMqdh4PqART9QVmmEEqzfPSZhKj8TUz7Ezb7IdhVHa5PZlBClmnh6k8bQ5ccKqpGLJkrq1sWz8 4V/KjwcoBfXCeG2GFDYuAQJfDgHcNCLd0lgFAMKyhR1f0IamaKIJheOJsS7J7yehdGUNl+8zGyL
 7Hi6GRtPtM9+2g2k+CMmVUG3e5sXzxGiP4irpNxhUl/9dtYx9NzdeTyos76BTMQeUPXvhPkg4Kl IabAftHgeXoqkxRUrAwVKJ7tUDNsovXrxhjdkAaav9IKIYNy09VsEx3q6deVszTTYQgjbYo/KHs qSGzQI1YZA0YKuz4+B5JsmzS66BwVAv60uQ3eGtDnsc3YWHTjJCPVr8NsDwwMr/iCuQpnjSVT0k
 avVtPIbVgHeflo9Jl67jrrij9Ofr05D/+Aiv8NbWRK1tNozmaoCeai2zMWrCGTEMgFhAmyCp
X-Authority-Analysis: v=2.4 cv=GpdC+l1C c=1 sm=1 tr=0 ts=682df439 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=EbkrBxOE9WPPWfOyQJoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 0Ze8Le0WWSayln7yhE7IvNVulrbYeocC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_05,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 malwarescore=0 clxscore=1015 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505160000 definitions=main-2505210153

On Wed, 21 May 2025 17:30:00 +0200
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> On Wed, 2025-05-21 at 17:19 +0200, Claudio Imbrenda wrote:
> > On Wed, 21 May 2025 16:55:18 +0200
> > Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
> >   
> > > On Wed, 2025-05-14 at 18:38 +0200, Claudio Imbrenda wrote:  
> > > > Refactor some gmap functions; move the implementation into a separate
> > > > file with only helper functions. The new helper functions work on vm
> > > > addresses, leaving all gmap logic in the gmap functions, which mostly
> > > > become just wrappers.
> > > > 
> > > > The whole gmap handling is going to be moved inside KVM soon, but the
> > > > helper functions need to touch core mm functions, and thus need to
> > > > stay in the core of kernel.
> > > > 
> > > > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > > > ---
> > > >  MAINTAINERS                          |   2 +
> > > >  arch/s390/include/asm/gmap_helpers.h |  18 ++
> > > >  arch/s390/kvm/diag.c                 |  11 +-
> > > >  arch/s390/kvm/kvm-s390.c             |   3 +-
> > > >  arch/s390/mm/Makefile                |   2 +
> > > >  arch/s390/mm/gmap.c                  |  46 ++---
> > > >  arch/s390/mm/gmap_helpers.c          | 266 +++++++++++++++++++++++++++
> > > >  7 files changed, 307 insertions(+), 41 deletions(-)
> > > >  create mode 100644 arch/s390/include/asm/gmap_helpers.h
> > > >  create mode 100644 arch/s390/mm/gmap_helpers.c
> > > >     
> [...]
> 
> > > > +void __gmap_helper_zap_one(struct mm_struct *mm, unsigned long vmaddr)    
> > > 
> > > __gmap_helper_zap_mapping_pte ?  
> > 
> > but I'm not taking a pte as parameter  
> 
> The pte being zapped is the one mapping vmaddr, right?

I don't know, _pte kinda sounds to me as the function would be taking a
pte as parameter

> >   
> > >   
> > > > +{
> > > > +	struct vm_area_struct *vma;
> > > > +	spinlock_t *ptl;
> > > > +	pte_t *ptep;
> > > > +
> > > > +	mmap_assert_locked(mm);
> > > > +
> > > > +	/* Find the vm address for the guest address */
> > > > +	vma = vma_lookup(mm, vmaddr);
> > > > +	if (!vma || is_vm_hugetlb_page(vma))
> > > > +		return;
> > > > +
> > > > +	/* Get pointer to the page table entry */
> > > > +	ptep = get_locked_pte(mm, vmaddr, &ptl);
> > > > +	if (!likely(ptep))    
> > > 
> > > if (unlikely(!ptep)) reads nicer to me.  
> > 
> > ok
> >   
> > >   
> > > > +		return;
> > > > +	if (pte_swap(*ptep))
> > > > +		ptep_zap_swap_entry(mm, pte_to_swp_entry(*ptep));
> > > > +	pte_unmap_unlock(ptep, ptl);
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(__gmap_helper_zap_one);    
> > > 
> > > Looks reasonable, but I'm not well versed enough in mm code to evaluate
> > > that with confidence.
> > >   
> > > > +
> > > > +void __gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned long end)    
> > > 
> > > Maybe call this gmap_helper_discard_nolock or something.  
> > 
> > maybe __gmap_helper_discard_unlocked?
> > 
> > the __ prefix often implies lack of locking  
> 
> _nolock *definitely* implies it :P
> 
> [...]
> 
> > > 
> > > The stuff below is from arch/s390/mm/gmap.c right?
> > > Are you going to delete it from there?  
> > 
> > not in this series, but the next series will remove mm/gmap.c altogether  
> 
> Can't you do it with this one?

if you mean removing mm/gmap.c, no. I would need to push the whole gmap
rewrite series, which is not ready yet.

if you mean removing the redundant functions... I guess I could

> 
> 
> [...]


