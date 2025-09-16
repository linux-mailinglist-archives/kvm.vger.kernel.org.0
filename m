Return-Path: <kvm+bounces-57703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C54D7B59211
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 11:24:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E909A189B41C
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 09:25:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2114229AB11;
	Tue, 16 Sep 2025 09:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HcYlV+dZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD95629898B;
	Tue, 16 Sep 2025 09:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758014679; cv=none; b=U2sefE2Hes33YaW4kCLbztjxiuDvAyq26FvLNJ+o3Klz97SycQdxro80YAOxDgGND9D2SRwzWSnmwFZfbQLzmdKgf66XRKHwF5zJinTrR/02xSovXNSho3bvdkHnX67t8OarzrqMh95E5/82dXuKVvdg7Nl7XhT5wZ8lu46wqno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758014679; c=relaxed/simple;
	bh=lcgW+5ROBPO0QpX7ggPIJKPO+dlkPW76ft8W7CrSM70=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XJnloK80ZuJqP6i07tShSOKFIj3pTl7UqvRmiuuCjaQ2rpbQRahxa2oELrSBQT80EuwfAFCsih/tUhCBWULhUk7qujWDWekgx7P29AFY0fFd7swfxSPtCMi5vDVvDQcFsFEcW7v5iDTrzqr4VdKt/2F9V1X3NsOfkeiIK/MqTyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HcYlV+dZ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G2nih6019175;
	Tue, 16 Sep 2025 09:24:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cpKZz4
	XYlZyX7UVdnlJ55i8LjnpWTWiMKmZRFBrbocI=; b=HcYlV+dZGiACToUX4GkcaZ
	w3Dspd93j22x83DW9dnwNHpXYkMrIEzjMBijW6b+A8dK9A++aT6ftk4bjbgs6qjA
	4QFDjnpc8hCpa0WQ+jthJWz0sBQgE5Ia4kRkrnYoi/9DmsgXnQp5B/UN+yQJ8hA7
	J0puldJ9dShbXYfhfLHZiu4VCebYmPS6DN9rp4wL0hwyi+FfJsAFDR0n5UNkQNta
	fKCXrg/3jSPconK8sBnEmY2e0fUiJzR5duggGpbk6cugKlLA4LEZJwpTvo+gu1pb
	7ssy4oJj5jCPwIuRzQI706VRaMdcypTTKEOKq8zkpRvRj5bhe4tvwbLUPuS5gD8Q
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496gat6jth-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:24:32 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58G7BqwK027349;
	Tue, 16 Sep 2025 09:24:31 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495men332b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:24:31 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58G9ORt830933472
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 09:24:27 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BF91120043;
	Tue, 16 Sep 2025 09:24:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 80A4F20040;
	Tue, 16 Sep 2025 09:24:27 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Sep 2025 09:24:27 +0000 (GMT)
Date: Tue, 16 Sep 2025 11:24:25 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Steffen Eiden <seiden@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 18/20] KVM: S390: Remove PGSTE code from linux/s390
 mm
Message-ID: <20250916112425.0b0d65b8@p-imbrenda>
In-Reply-To: <20250916073038.68862-A-seiden@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	<20250910180746.125776-19-imbrenda@linux.ibm.com>
	<20250916073038.68862-A-seiden@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=BKWzrEQG c=1 sm=1 tr=0 ts=68c92cd1 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=l1XlMsZtLEffUVEgH-4A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: gvK3LA3av5HPHuLa81xv9NR7nM0gEkCc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE1MDA4NiBTYWx0ZWRfX7Nxqjiip2a3k
 L++PCNw11n6Sz8n2a8EMxBonlndONZ+t0YYx2+HvaBv45182NYh0jJDdroO0NFAyvJRL5WZ2ERz
 iYFMqRvyqqy5Eole3LLQaofGH+lyhP8OpX7m9tNIf0MCPvCFdjh7GXL5TLRsWIU3RuoQE1mH1ee
 LdlQkJB3U0Xh0wySYmIBmTzBW4X8tw1MfSAZG4CY6NJVRcpG/jdm/D+wdSK+ZMAfWCqHSrRnB+S
 JA5zY2xdGWkhKhQqEEzRJ9jKoZlDeV0EY3CcAxS3x6CueuUmYrnIMDHQPZ3Jf61mnXfcjdSRCGc
 V8hOwOJEZCqpjUc6Fx0pW4mMix5+FBn5iNY7k7AZpLGaLOK4LJkPe1INY0BQa/giJtndvO8BJUu
 mRmrT7r7
X-Proofpoint-ORIG-GUID: gvK3LA3av5HPHuLa81xv9NR7nM0gEkCc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509150086

On Tue, 16 Sep 2025 09:30:38 +0200
Steffen Eiden <seiden@linux.ibm.com> wrote:

> On Wed, Sep 10, 2025 at 08:07:44PM +0200, Claudio Imbrenda wrote:
> > Remove the PGSTE config option.
> > Remove all code from linux/s390 mm that involves PGSTEs.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/Kconfig               |   3 -
> >  arch/s390/include/asm/mmu.h     |  13 -
> >  arch/s390/include/asm/page.h    |   4 -
> >  arch/s390/include/asm/pgalloc.h |   2 -
> >  arch/s390/include/asm/pgtable.h |  99 +---
> >  arch/s390/mm/hugetlbpage.c      |  24 -
> >  arch/s390/mm/pgalloc.c          |  29 --
> >  arch/s390/mm/pgtable.c          | 827 +-------------------------------
> >  mm/khugepaged.c                 |   9 -
> >  9 files changed, 14 insertions(+), 996 deletions(-)
> >   
> 
> ...
> 
> >  #define INIT_MM_CONTEXT(name)						   \
> > diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
> > index 4e5dbabdf202..b4fb4d7adff4 100644
> > --- a/arch/s390/include/asm/page.h
> > +++ b/arch/s390/include/asm/page.h
> > @@ -78,7 +78,6 @@ static inline void copy_page(void *to, void *from)
> >  #ifdef STRICT_MM_TYPECHECKS
> >  
> >  typedef struct { unsigned long pgprot; } pgprot_t;
> > -typedef struct { unsigned long pgste; } pgste_t;
> >  typedef struct { unsigned long pte; } pte_t;
> >  typedef struct { unsigned long pmd; } pmd_t;
> >  typedef struct { unsigned long pud; } pud_t;
> > @@ -94,7 +93,6 @@ static __always_inline unsigned long name ## _val(name ## _t name)	\
> >  #else /* STRICT_MM_TYPECHECKS */
> >  
> >  typedef unsigned long pgprot_t;
> > -typedef unsigned long pgste_t;
> >  typedef unsigned long pte_t;
> >  typedef unsigned long pmd_t;
> >  typedef unsigned long pud_t;
> > @@ -110,7 +108,6 @@ static __always_inline unsigned long name ## _val(name ## _t name)	\
> >  #endif /* STRICT_MM_TYPECHECKS */
> >  
> >  DEFINE_PGVAL_FUNC(pgprot)
> > -DEFINE_PGVAL_FUNC(pgste)
> >  DEFINE_PGVAL_FUNC(pte)
> >  DEFINE_PGVAL_FUNC(pmd)
> >  DEFINE_PGVAL_FUNC(pud)
> > @@ -120,7 +117,6 @@ DEFINE_PGVAL_FUNC(pgd)
> >  typedef pte_t *pgtable_t;
> >  
> >  #define __pgprot(x)	((pgprot_t) { (x) } )
> > -#define __pgste(x)	((pgste_t) { (x) } )
> >  #define __pte(x)        ((pte_t) { (x) } )
> >  #define __pmd(x)        ((pmd_t) { (x) } )
> >  #define __pud(x)	((pud_t) { (x) } )  
> 
> 
> You missed to remove the PGSTE_*_BIT{,S} and _PGSTE_GPS_* definitions in
> arch/s390/include/asm/pgtable.h
> (I found them at line 417.. (based on 6.16 with your patches applied))
> 
> Or are they kept on purpose? I could not find any usage after your patches.
> 
> Steffen

I do use PGSTE_IN_BIT, PGSTE_PCL_BIT and PGSTE_UC_BIT, but I should
probably move those to dat.h, and remove all the other unused
PGSTE_*_BIT and _PGSTE_GPS_* macros from page.h


