Return-Path: <kvm+bounces-36015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 403A7A16DDA
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 14:55:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52BCE3A1131
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 13:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47E701E2849;
	Mon, 20 Jan 2025 13:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YHypPCJG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29B41E2310;
	Mon, 20 Jan 2025 13:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737381295; cv=none; b=qyQw3fn41WGaaU3GHcHn1rt88TPb8Y+yOQ3XcUbQabjLyOXmE4QVfQ27LgLxRK0eyjRPKygwq/FmZIHNHZlM/09pKk28o9Y/8RknbRDicYCWpGQ/N0VIUZnmCPPJ00HBZkQi9Lwlbe/NFXQgvjZzmGdoNX0xLdoXC5c4bs+I6Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737381295; c=relaxed/simple;
	bh=x5UUAuEv8BXXleIiUq/fahhikzygzVziB6B5aaD8InE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HD1PlHcUn1MYkMLeBuw8cfes6We8wamEmTi2zSyWimu+MmATmmGqfIL70WGDLGHdwWuhOTkb4LZm39H/XBmVPW73FETy6s5yiHrVCVWcWhF4WdO9eOsuSUyzuWl2DdIEN2yaBMrC9briinnOYTXK3XX1mkGz2iQ8veIT4Snv9Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YHypPCJG; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50K8kEIk010061;
	Mon, 20 Jan 2025 13:54:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=O21QuF
	auI8QrnsSXdvrtowmfNL67VxiCVEpoew5S4Mk=; b=YHypPCJGDVbkHvjojlVWV+
	a2+BTIlStG+ZN7x6KWzekpGPcZHkRk1UFtY3E8vc6f/PNQbNthuL602BpJ7X0QYS
	lYhava7uEbJmSHtA+1aZf+XpSTRYejLf4wheqgimLm2PbF8SCfWj787EzqBa0GV8
	9KzJNzVk0V1mb0qvC2dLU4g8al3RIwnmAPbQIAG7tjPG974gtuxoWmXguUDz0Al+
	CQrKDC0krVMrG94hHSS1YkzsUFTfTgY4WTmAk/57noVUHQuSmdz8Z/2+7GREGYKu
	ZXA7t+N7TE6IHjpmmjvGx3JS/mX30ZV0I6+bcVtlN0gE31L4SfMlLF50b5scI8tw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44947sva57-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 13:54:49 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50KDQu2m020145;
	Mon, 20 Jan 2025 13:54:49 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44947sva54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 13:54:49 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50KBQoMc029553;
	Mon, 20 Jan 2025 13:54:48 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 448qmn6k3j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 13:54:48 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50KDsiZA60162504
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Jan 2025 13:54:44 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7350D2004B;
	Mon, 20 Jan 2025 13:54:44 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3330E20040;
	Mon, 20 Jan 2025 13:54:44 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Jan 2025 13:54:44 +0000 (GMT)
Date: Mon, 20 Jan 2025 14:54:42 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: Re: [PATCH v2 12/15] KVM: s390: move gmap_shadow_pgt_lookup() into
 kvm
Message-ID: <20250120145442.346c829a@p-imbrenda>
In-Reply-To: <76d8c896-5c28-4e0b-b8a9-a23b63571717@linux.ibm.com>
References: <20250116113355.32184-1-imbrenda@linux.ibm.com>
	<20250116113355.32184-13-imbrenda@linux.ibm.com>
	<76d8c896-5c28-4e0b-b8a9-a23b63571717@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HWZiRsNCxVBrf3a_aFcmwmMId7HJBYou
X-Proofpoint-ORIG-GUID: fW3PANClCNFwhckIYlzkAC9i-mJ6LO33
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-20_02,2025-01-20_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 phishscore=0 adultscore=0 spamscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501200112

On Mon, 20 Jan 2025 14:47:55 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 1/16/25 12:33 PM, Claudio Imbrenda wrote:
> > Move gmap_shadow_pgt_lookup() from mm/gmap.c into kvm/gaccess.c .
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   arch/s390/include/asm/gmap.h |  3 +--
> >   arch/s390/kvm/gaccess.c      | 40 +++++++++++++++++++++++++++++++
> >   arch/s390/kvm/gmap.h         |  2 ++
> >   arch/s390/mm/gmap.c          | 46 ++----------------------------------
> >   4 files changed, 45 insertions(+), 46 deletions(-)  
> 
> [...]
> 
> >   
> > +/**
> > + * gmap_shadow_pgt_lookup - find a shadow page table  
> 
> The other two VSIE functions in gaccess.c have the kvm_s390_shadow 
> prefix but this one is only static anyway and hence we could just drop 
> the gmap_ from the name.

fair enough, will fix

> 
> > + * @sg: pointer to the shadow guest address space structure
> > + * @saddr: the address in the shadow aguest address space
> > + * @pgt: parent gmap address of the page table to get shadowed
> > + * @dat_protection: if the pgtable is marked as protected by dat
> > + * @fake: pgt references contiguous guest memory block, not a pgtable
> > + *
> > + * Returns 0 if the shadow page table was found and -EAGAIN if the page
> > + * table was not found.
> > + *
> > + * Called with sg->mm->mmap_lock in read.
> > + */
> > +static int gmap_shadow_pgt_lookup(struct gmap *sg, unsigned long saddr, unsigned long *pgt,
> > +				  int *dat_protection, int *fake)
> > +{
> > +	unsigned long *table;
> > +	struct page *page;
> > +	int rc;
> > +
> > +	spin_lock(&sg->guest_table_lock);
> > +	table = gmap_table_walk(sg, saddr, 1); /* get segment pointer */  
> 
> I'd be happy if you could introduce an enum for the level argument in a 
> future series.

in upcoming series, the gmap table walk will be completely
rewritten, and yes, it will have enums

> 
> > +	if (table && !(*table & _SEGMENT_ENTRY_INVALID)) {
> > +		/* Shadow page tables are full pages (pte+pgste) */
> > +		page = pfn_to_page(*table >> PAGE_SHIFT);
> > +		*pgt = page->index & ~GMAP_SHADOW_FAKE_TABLE;
> > +		*dat_protection = !!(*table & _SEGMENT_ENTRY_PROTECT);
> > +		*fake = !!(page->index & GMAP_SHADOW_FAKE_TABLE);
> > +		rc = 0;
> > +	} else  {
> > +		rc = -EAGAIN;
> > +	}
> > +	spin_unlock(&sg->guest_table_lock);
> > +	return rc;
> > +}
> > +
> >  


