Return-Path: <kvm+bounces-57689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 74EA8B58F28
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 09:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3AEEB7A7AA7
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 07:29:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E802E0B77;
	Tue, 16 Sep 2025 07:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JWpnjpie"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAA9DDC3;
	Tue, 16 Sep 2025 07:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758007850; cv=none; b=ZIzBNr+p+Te9teVO0MiZod8TVHlnM+mjwRnQIWEWEevUKdcmAzJJJ5Ytu36+nTkvL2D1I+ROQzCcxzlrH8AjVdLl8mXULe/+GYNQ2LrAagu7IPWI0l2h1X9p6Q9JMo50/1yzxOrUgfR/7LayT9gFZxEONAN0qJOq125rh6OuIio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758007850; c=relaxed/simple;
	bh=67wYFyb9yQMfAldZImDXHhemEGtudY4U1p5WDJhHWeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JaGjO8hEiS9etDoyjmPRORpmjueZ9BH84lXYaTzGr0a+NMgip2TDo24dWfiHeA+R3f2WNrM5E5tp7f2f66snGb/SmZuPTxb1QDHNCWa1myOlpckzwcsMSfm5lxWSBUWiqt/JeQ9WWuhbJddTP+Qzr2rApL9Z/NofE49lQvD7fZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JWpnjpie; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G1QkHw024260;
	Tue, 16 Sep 2025 07:30:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=XCdDH6mQmueEzzTBlbzMnv9kmTMNdx
	k+WM2j7GGhD1U=; b=JWpnjpie0WQ0UO8yEHNOg3+oZzSVjQ0/9u+KREHKoVl6cD
	hdIyHd31sWI4ZApg4ejbA+otHAV0KWfT/BrkUt6vk5o46c5Hnt0TWFdaSLvYxonA
	LlCbdVlXvWfb2hqOlbgZjwiOgZxejHO8Zzth+naB7VOcur40ASaYFNkydnpCK8Sp
	TjHMl64F78BQB4crifJpiawOYxxKQexP1HULtEub+zRU/fd5oURFx7wqZPjC1e7s
	E+comdCxy6BX8xk8PrORRAdc3cK/PwgGCHgtn39U1Y1Ewf6pGr+ABh+aFOohvOky
	nkyBusAEfZ1qOFRMSvmqbhXKgriecYNacQrZvUOQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496avnqk9k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 07:30:45 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58G7BqSX027349;
	Tue, 16 Sep 2025 07:30:44 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495men2nbg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 07:30:44 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58G7Uefh11927882
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 07:30:40 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA1BC2004B;
	Tue, 16 Sep 2025 07:30:40 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 147E620043;
	Tue, 16 Sep 2025 07:30:40 +0000 (GMT)
Received: from osiris (unknown [9.111.25.93])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 16 Sep 2025 07:30:40 +0000 (GMT)
Date: Tue, 16 Sep 2025 09:30:38 +0200
From: Steffen Eiden <seiden@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 18/20] KVM: S390: Remove PGSTE code from linux/s390 mm
Message-ID: <20250916073038.68862-A-seiden@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-19-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910180746.125776-19-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hhMYeSv92yQ5yhh0p_Epp9ZG12M4OJyq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE1MDAyOCBTYWx0ZWRfXyYHLkICk8rNz
 BSyaP3TpfV2IQL3JZo2ryFyG28YBlla3joIzvzpIHLDHeApTOAQH5mMc3Pl/oRbljekkQ3b6Bt6
 SwxdD7uOjYL73BP4wd5CB9o4/ubZUDONEl5WR9IqXC4kjEoiDK2LNNUnBCaxhquzF4LQGLZ978+
 42utK5QtnGEAUq/Dee/7TPr+Ql2QHVfEXnixRMdLWB8BTmnpIC2ALsYGtanUjM8+fbcXOVk4yAS
 FlT34ILW3ysWH8dTu9ZKFF6FT+syZRAE34ehut61KkfKY+MEoEOsBYqQfQqjuG1uUMjmYu5hhpu
 lU0OIAAT1GI82mu+Kl1zTIq877Lmbm5BrgyFAF4jj5ILlxkj4q9jZ8DMeJreOxwJkZ+XcUYpeIz
 LFeQPdzG
X-Authority-Analysis: v=2.4 cv=HecUTjE8 c=1 sm=1 tr=0 ts=68c91226 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=Bk4uLiYzvl3jBF9LfpkA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: hhMYeSv92yQ5yhh0p_Epp9ZG12M4OJyq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509150028

On Wed, Sep 10, 2025 at 08:07:44PM +0200, Claudio Imbrenda wrote:
> Remove the PGSTE config option.
> Remove all code from linux/s390 mm that involves PGSTEs.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/Kconfig               |   3 -
>  arch/s390/include/asm/mmu.h     |  13 -
>  arch/s390/include/asm/page.h    |   4 -
>  arch/s390/include/asm/pgalloc.h |   2 -
>  arch/s390/include/asm/pgtable.h |  99 +---
>  arch/s390/mm/hugetlbpage.c      |  24 -
>  arch/s390/mm/pgalloc.c          |  29 --
>  arch/s390/mm/pgtable.c          | 827 +-------------------------------
>  mm/khugepaged.c                 |   9 -
>  9 files changed, 14 insertions(+), 996 deletions(-)
> 

...

>  #define INIT_MM_CONTEXT(name)						   \
> diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
> index 4e5dbabdf202..b4fb4d7adff4 100644
> --- a/arch/s390/include/asm/page.h
> +++ b/arch/s390/include/asm/page.h
> @@ -78,7 +78,6 @@ static inline void copy_page(void *to, void *from)
>  #ifdef STRICT_MM_TYPECHECKS
>  
>  typedef struct { unsigned long pgprot; } pgprot_t;
> -typedef struct { unsigned long pgste; } pgste_t;
>  typedef struct { unsigned long pte; } pte_t;
>  typedef struct { unsigned long pmd; } pmd_t;
>  typedef struct { unsigned long pud; } pud_t;
> @@ -94,7 +93,6 @@ static __always_inline unsigned long name ## _val(name ## _t name)	\
>  #else /* STRICT_MM_TYPECHECKS */
>  
>  typedef unsigned long pgprot_t;
> -typedef unsigned long pgste_t;
>  typedef unsigned long pte_t;
>  typedef unsigned long pmd_t;
>  typedef unsigned long pud_t;
> @@ -110,7 +108,6 @@ static __always_inline unsigned long name ## _val(name ## _t name)	\
>  #endif /* STRICT_MM_TYPECHECKS */
>  
>  DEFINE_PGVAL_FUNC(pgprot)
> -DEFINE_PGVAL_FUNC(pgste)
>  DEFINE_PGVAL_FUNC(pte)
>  DEFINE_PGVAL_FUNC(pmd)
>  DEFINE_PGVAL_FUNC(pud)
> @@ -120,7 +117,6 @@ DEFINE_PGVAL_FUNC(pgd)
>  typedef pte_t *pgtable_t;
>  
>  #define __pgprot(x)	((pgprot_t) { (x) } )
> -#define __pgste(x)	((pgste_t) { (x) } )
>  #define __pte(x)        ((pte_t) { (x) } )
>  #define __pmd(x)        ((pmd_t) { (x) } )
>  #define __pud(x)	((pud_t) { (x) } )


You missed to remove the PGSTE_*_BIT{,S} and _PGSTE_GPS_* definitions in
arch/s390/include/asm/pgtable.h
(I found them at line 417.. (based on 6.16 with your patches applied))

Or are they kept on purpose? I could not find any usage after your patches.

Steffen

