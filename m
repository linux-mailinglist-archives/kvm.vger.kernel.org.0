Return-Path: <kvm+bounces-57319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD0FBB53360
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 15:14:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 982513B9C6B
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 13:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADD4A324B0B;
	Thu, 11 Sep 2025 13:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kY9zY10e"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37962322DC0;
	Thu, 11 Sep 2025 13:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757596464; cv=none; b=H1/pdUhM+ScIsEa4QdRqRxeRCR8OaggKp1RlakLwGBhGskkrekSN/k+M8rxVBTKNRiqUuuMj+eI6k7uIt15lbXX/ZIroqSVL7ES2TVP1agShoQyJCWyHaKDRHaRv3uvzdZrhVftCgkuttANje+9uR5vSobyYYENvm2Lu/7BICCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757596464; c=relaxed/simple;
	bh=yRAH7Nq+YhTzoar+qb5ORRWMF2yCjU2smP/n9EbGIf0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X1z8M8ZArA95qJAa7rHt90eOKrc2A4Iz+yzPYBfwf2VrcPxYwqoFS/tlzKP+RI3vfsnt08tHFeccYZf2rcKrWB6O96EZlvLMIVEi7Nwi0m8NPHA+BEtJZzBEO2OPRlGv856zpoxt7sTvQAiHQwdh31Kh1PFEu4q3IhyBz4eiazU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kY9zY10e; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B7fBWh017992;
	Thu, 11 Sep 2025 13:14:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=EydwCN
	H6iMpRldDKAo4letNDOuPRaM+tVxgZ9+8vnkc=; b=kY9zY10evL3MKROJHcKAKW
	tJjDVS9nXGFOth1/wEYPbyTlWXe9Nrle/8bkwmwWMhYg8hjKR8wzoogpJ64+7fy4
	tEF7v9mwZTEGlXYqBdUnH6mDDCf4gyqSGe1IyLvmtDf1o/VJjLazAlaQmgjYt4OP
	t4W8WKZw/Y1EDNbWTUtU3bXPd0SCFLEbaaN/oaRlmkmN9S+0lq4aITqL5Eonlv99
	SGY3WZN5nEfuuj3kzxH37d1Eoz4RXgP6ie3XFH3SnH2/NIGgHudYeynFcrmGDCf8
	s7Q8bYQ2Fh/S6lWMPMyMItx/u4hSI98BIBWDkp+Aad8m38OelIdQ37xTT8NTkXKA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490ukeshmt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 13:14:15 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58BAsV4B001156;
	Thu, 11 Sep 2025 13:14:14 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 491203np3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 13:14:14 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58BDEAe611993594
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 13:14:10 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A7DA02004B;
	Thu, 11 Sep 2025 13:14:10 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6705120040;
	Thu, 11 Sep 2025 13:14:10 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Sep 2025 13:14:10 +0000 (GMT)
Date: Thu, 11 Sep 2025 15:14:08 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 10/20] KVM: s390: KVM page table management
 functions: walks
Message-ID: <20250911151408.2a1595d4@p-imbrenda>
In-Reply-To: <aeb461ff-90a1-4d6e-a779-1c6e885bdddb@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	<20250910180746.125776-11-imbrenda@linux.ibm.com>
	<aeb461ff-90a1-4d6e-a779-1c6e885bdddb@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDE5NSBTYWx0ZWRfX8dOBHNegHCAP
 33ByPwJ/ferUihcY4DTkp2pr9qXBXKV3CEiwE2PCha5loqPc5cEBc2gd1bwhZ4lH6r+9DDH7Fhy
 Tht/807m4/QSgrh8+G6JU5JJOMheWc+tNtdfw/hbVgs0S9jXCNUNFIBbyewGY3P4aB7BpzoZuyU
 NYuwOYcnM7EWNwRcIozBWZLvWHO4o/Jn3bRH0f5FJOTGzRXrtxirLkwgddpqjS4C3jC6QHhdofn
 M71o6oGNmN4gx04TKz6ffyGPQ49wRa8eZQFkLt4bS9ruZC3bdl2MvgteceXSuXsNYNxP8Ub2Q1j
 7vC5tpf5CFzteqT45ndf5cYLHo2mgPFD8iZZD4fxdf+3fNpqkduV3TjF/lJz8ivGTHnblTbICDp
 czF3VByn
X-Proofpoint-ORIG-GUID: jyhbbpL_sqQbenvbUcYo6EhQDU1Uczf7
X-Proofpoint-GUID: jyhbbpL_sqQbenvbUcYo6EhQDU1Uczf7
X-Authority-Analysis: v=2.4 cv=StCQ6OO0 c=1 sm=1 tr=0 ts=68c2cb27 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=lvvZxmpIe-pUyUmVHsEA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060195

On Thu, 11 Sep 2025 14:56:59 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 9/10/25 8:07 PM, Claudio Imbrenda wrote:
> > Add page table management functions to be used for KVM guest (gmap)
> > page tables.
> > 
> > This patch adds functions to walk to specific table entries, or to
> > perform actions on a range of entries.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   arch/s390/kvm/dat.c | 351 ++++++++++++++++++++++++++++++++++++++++++++
> >   arch/s390/kvm/dat.h |  38 +++++
> >   2 files changed, 389 insertions(+)
> > 
> > diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
> > index f26e3579bd77..fe93e1c07158 100644
> > --- a/arch/s390/kvm/dat.c
> > +++ b/arch/s390/kvm/dat.c
> > @@ -209,3 +209,354 @@ union pgste __dat_ptep_xchg(union pte *ptep, union pgste pgste, union pte new, g
> >   	WRITE_ONCE(*ptep, new);
> >   	return pgste;
> >   }
> > +
> > +/*
> > + * dat_split_pmd is assumed to be called with mmap_lock held in read or write mode
> > + */
> > +static int dat_split_pmd(union pmd *pmdp, gfn_t gfn, union asce asce)
> > +{
> > +	struct page_table *pt;
> > +	union pmd new, old;
> > +	union pte init;
> > +	int i;
> > +
> > +	old = READ_ONCE(*pmdp);
> > +
> > +	/* Already split, nothing to do */
> > +	if (!old.h.i && !old.h.fc)
> > +		return 0;
> > +
> > +	pt = dat_alloc_pt_noinit();
> > +	if (!pt)
> > +		return -ENOMEM;
> > +	new.val = virt_to_phys(pt);
> > +
> > +	while (old.h.i || old.h.fc) {
> > +		init.val = pmd_origin_large(old);
> > +		init.h.p = old.h.p;
> > +		init.h.i = old.h.i;
> > +		init.s.d = old.s.fc1.d;
> > +		init.s.w = old.s.fc1.w;
> > +		init.s.y = old.s.fc1.y;
> > +		init.s.sd = old.s.fc1.sd;
> > +		init.s.pr = old.s.fc1.pr;  
> 
> This looks horrible but I haven't found a better solution.

I know what you mean :)

> 
> > +		if (old.h.fc) {
> > +			for (i = 0; i < _PAGE_ENTRIES; i++)
> > +				pt->ptes[i].val = init.val | i * PAGE_SIZE;
> > +			/* no need to take locks as the page table is not installed yet */
> > +			dat_init_pgstes(pt, old.s.fc1.prefix_notif ? PGSTE_IN_BIT : 0);  
> 
> So, if the pmd had the IN bit, all PGSTEs will have it as well, right?

yes

> Why can't we notify and not copy this bit, so the notifier sets it for 
> the ptes which actually need it? Or does it happen later?

because the notifier is a gmap/kvm thing, and this function (the whole
dat.c actually) only deals with page tables.

Keeping things this way makes the code more structured and cleaner and
less convoluted.

The unnecessary prefix_notif bits will be cleared once they get
invalidated. This will happen very rarely, since most of the time a pmd
or pud prefix will not need to be split. The only case I can think of
right now is a weird interaction between huge pages and vsie.

In short: it only needs to be correct, does not need to be fast :)

> 
> > +		} else {
> > +			dat_init_page_table(pt, init.val, 0);
> > +		}
> > +
> > +		if (dat_pmdp_xchg_atomic(pmdp, old, new, gfn, asce))
> > +			return 0;
> > +		old = READ_ONCE(*pmdp);
> > +	}
> > +
> > +	dat_free_pt(pt);
> > +	return 0;
> > +}  


