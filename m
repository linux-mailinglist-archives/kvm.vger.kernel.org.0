Return-Path: <kvm+bounces-46700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1E53AB8BA1
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 17:55:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E64B1BC2539
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 15:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9BEF21ABA2;
	Thu, 15 May 2025 15:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rrCTBBl0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9E2481C4;
	Thu, 15 May 2025 15:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747324546; cv=none; b=D/k8S+xqlFhTBQvYtHarPatP5586FA5ml7A7Fg3zmBHe7EX83++fao2YtkIjhPfuWWhq3RzMrcMiHHuHwKYLC5Cs44++3kI0GhIYU48S29fvNzsA/2SvtHAvTq+ax7YW22ofns06pUZrYFZGomaHL76ictbpb7AXzLLe9cHs2ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747324546; c=relaxed/simple;
	bh=rWO0JWxEoRf/w8MJDqvOKsYDZgxP5f41XaVpF6qf6KY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G4wxthIzRNr5f3qLXlLlQrn/6wBSAZc+i51yEjzE44Ikg6mpUCMd1YWqYP0Jg6BLco3jtgLW3nKfpYLDN2KLM9wxulrWa9ekQ41ynDDu6fuWNjrZcmeJdKRN8aHvD49z7G8fFi0pp42d/RKWqXHm30M5bMT4i0WKEBtUiFRd3hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rrCTBBl0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54FDn3Xo032297;
	Thu, 15 May 2025 15:55:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NDbeIq
	zSfGVF6IdpJ2cVNjVG3CvEK6xmLyCZ9X3Wz0Q=; b=rrCTBBl0DuaPMw8x8QbUSD
	4EiBfwzdMOcQ2iyMKRSBGC/IT5SohlXJ7rJPO+Zfhpjzn+4q2ill8a9lJpQJuiOr
	JEwnbHWRM7Hr3Fmk3XFfpkkNa83YjxyTYs+E5Rg2PvNTbtA3xjkFvrKi+w/uBxWe
	YencbEGnIxN+c/57h7YO28BEBHF0x5Q6hKE7MYbDGRUkmYy3VIKELrFTY4y0X44T
	0bWQ7QbFdpQIe+lL5mLCV5h5EmqVT5e0Eeo0bDsqqz/rrRIsyb3ybB5CAkAyCbT/
	Ty0XeAacYdwi29soyF0bdrF5RuIzxZPyEmPQjjL4pDcCWkPjs+nimipVItYTIPxA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46nhg30q2m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 15:55:40 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54FE40p4024279;
	Thu, 15 May 2025 15:55:39 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46mbfsb2sm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 15:55:39 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54FFtZ7R45875552
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 15:55:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E0DD3201D6;
	Thu, 15 May 2025 15:29:38 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D750201D1;
	Thu, 15 May 2025 15:29:38 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 May 2025 15:29:38 +0000 (GMT)
Date: Thu, 15 May 2025 17:29:36 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <seiden@linux.ibm.com>, <nsg@linux.ibm.com>,
        <nrb@linux.ibm.com>, <david@redhat.com>, <hca@linux.ibm.com>,
        <agordeev@linux.ibm.com>, <svens@linux.ibm.com>, <gor@linux.ibm.com>
Subject: Re: [PATCH v1 1/5] s390: remove unneeded includes
Message-ID: <20250515172936.5447d582@p-imbrenda>
In-Reply-To: <D9WSBQ41MJ2M.1KMCYVAHP1JFF@linux.ibm.com>
References: <20250514163855.124471-1-imbrenda@linux.ibm.com>
	<20250514163855.124471-2-imbrenda@linux.ibm.com>
	<D9WSBQ41MJ2M.1KMCYVAHP1JFF@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=Cf0I5Krl c=1 sm=1 tr=0 ts=68260e7c cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=YI8s6InO9XsLWCBpwgcA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDE1NSBTYWx0ZWRfX8aWx3wxt8wQS T2NAgj7RpabwoPqzRrasO2EQl1q1WSadL8NiOpBmNICdQAcZ1JrW+xq6BIFJkcy43XS83X89qEI qHcz1ULSPluKcQz1aNxhX0TD/qAsWNEGRARkevi9DbE8UraLeGKcJ+TmL1JnG3ERyOUxb2UOpn8
 Rg3GRM1u4sYLOZOOiYMvZKapLXVy7Tj8smldyTS5arwAbGzSg4BGv3h5h0DR3z0b/iBBEjQZepy cxxamR+7iwRvsu8BkeQikQegfTniU9Ukkj2zsYE7U/N5FYn8kZW3mmfdexZq9dFjqrXczykfD5e jp08lM7fp5jcNjDx2B/vq2cG1e/XuVWcE9xtTZKKa9dXZBV6nM1B9Qhi8kHXG436tJdwgqneGbO
 V+SN0Fl9MgNXAa4yn5jS9fIJr3kTqCJ6hmvQ17oNFj+1zNIqUVndhQzfiKMf4Jgo8NT3DSy6
X-Proofpoint-GUID: WaUJGBACeeYxeRGtT_2qwni0yt2MFamB
X-Proofpoint-ORIG-GUID: WaUJGBACeeYxeRGtT_2qwni0yt2MFamB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_06,2025-05-15_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 phishscore=0 priorityscore=1501 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505150155

On Thu, 15 May 2025 15:56:44 +0200
"Christoph Schlameuss" <schlameuss@linux.ibm.com> wrote:

> You added one unnecessary import to arch/s390/kvm/intercept.c
> 
> With that removed:
> Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> 
> 
> On Wed May 14, 2025 at 6:38 PM CEST, Claudio Imbrenda wrote:
> > Many files don't need to include asm/tlb.h or asm/gmap.h.
> > On the other hand, asm/tlb.h does need to include asm/gmap.h.
> >
> > Remove all unneeded includes so that asm/tlb.h is not directly used by
> > s390 arch code anymore. Remove asm/gmap.h from a few other files as
> > well, so that now only KVM code, mm/gmap.c, and asm/tlb.h include it.
> >
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/include/asm/tlb.h | 1 +
> >  arch/s390/include/asm/uv.h  | 1 -
> >  arch/s390/kvm/intercept.c   | 1 +
> >  arch/s390/mm/fault.c        | 1 -
> >  arch/s390/mm/gmap.c         | 1 -
> >  arch/s390/mm/init.c         | 1 -
> >  arch/s390/mm/pgalloc.c      | 2 --
> >  arch/s390/mm/pgtable.c      | 1 -
> >  8 files changed, 2 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
> > index f20601995bb0..56d5f9e0eb2e 100644
> > --- a/arch/s390/include/asm/tlb.h
> > +++ b/arch/s390/include/asm/tlb.h
> > @@ -36,6 +36,7 @@ static inline bool __tlb_remove_folio_pages(struct mmu_gather *tlb,
> >  
> >  #include <asm/tlbflush.h>
> >  #include <asm-generic/tlb.h>
> > +#include <asm/gmap.h>
> >  
> >  /*
> >   * Release the page cache reference for a pte removed by
> > diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> > index 46fb0ef6f984..eeb2db4783e6 100644
> > --- a/arch/s390/include/asm/uv.h
> > +++ b/arch/s390/include/asm/uv.h
> > @@ -16,7 +16,6 @@
> >  #include <linux/bug.h>
> >  #include <linux/sched.h>
> >  #include <asm/page.h>
> > -#include <asm/gmap.h>
> >  #include <asm/asm.h>
> >  
> >  #define UVC_CC_OK	0
> > diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> > index a06a000f196c..b4834bd4d216 100644
> > --- a/arch/s390/kvm/intercept.c
> > +++ b/arch/s390/kvm/intercept.c
> > @@ -16,6 +16,7 @@
> >  #include <asm/irq.h>
> >  #include <asm/sysinfo.h>
> >  #include <asm/uv.h>
> > +#include <asm/gmap.h>  
> 
> This import is not needed.

it is needed here, but it can be removed in patch 5
(I'll fix that for v2)

> 
> >  
> >  #include "kvm-s390.h"
> >  #include "gaccess.h"
> > diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> > index da84ff6770de..3829521450dd 100644
> > --- a/arch/s390/mm/fault.c
> > +++ b/arch/s390/mm/fault.c
> > @@ -40,7 +40,6 @@
> >  #include <asm/ptrace.h>
> >  #include <asm/fault.h>
> >  #include <asm/diag.h>
> > -#include <asm/gmap.h>
> >  #include <asm/irq.h>
> >  #include <asm/facility.h>
> >  #include <asm/uv.h>
> > diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> > index a94bd4870c65..4869555ff403 100644
> > --- a/arch/s390/mm/gmap.c
> > +++ b/arch/s390/mm/gmap.c
> > @@ -24,7 +24,6 @@
> >  #include <asm/machine.h>
> >  #include <asm/gmap.h>
> >  #include <asm/page.h>
> > -#include <asm/tlb.h>
> >  
> >  /*
> >   * The address is saved in a radix tree directly; NULL would be ambiguous,
> > diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
> > index afa085e8186c..074bf4fb4ce2 100644
> > --- a/arch/s390/mm/init.c
> > +++ b/arch/s390/mm/init.c
> > @@ -40,7 +40,6 @@
> >  #include <asm/kfence.h>
> >  #include <asm/dma.h>
> >  #include <asm/abs_lowcore.h>
> > -#include <asm/tlb.h>
> >  #include <asm/tlbflush.h>
> >  #include <asm/sections.h>
> >  #include <asm/sclp.h>
> > diff --git a/arch/s390/mm/pgalloc.c b/arch/s390/mm/pgalloc.c
> > index e3a6f8ae156c..ddab36875370 100644
> > --- a/arch/s390/mm/pgalloc.c
> > +++ b/arch/s390/mm/pgalloc.c
> > @@ -12,8 +12,6 @@
> >  #include <asm/mmu_context.h>
> >  #include <asm/page-states.h>
> >  #include <asm/pgalloc.h>
> > -#include <asm/gmap.h>
> > -#include <asm/tlb.h>
> >  #include <asm/tlbflush.h>
> >  
> >  unsigned long *crst_table_alloc(struct mm_struct *mm)
> > diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
> > index 9901934284ec..7df70cd8f739 100644
> > --- a/arch/s390/mm/pgtable.c
> > +++ b/arch/s390/mm/pgtable.c
> > @@ -20,7 +20,6 @@
> >  #include <linux/ksm.h>
> >  #include <linux/mman.h>
> >  
> > -#include <asm/tlb.h>
> >  #include <asm/tlbflush.h>
> >  #include <asm/mmu_context.h>
> >  #include <asm/page-states.h>  
> 


