Return-Path: <kvm+bounces-35534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76806A123B1
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 13:24:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C847167B35
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 12:24:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16AFF2206A2;
	Wed, 15 Jan 2025 12:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="f148JslP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41192475E2;
	Wed, 15 Jan 2025 12:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736943843; cv=none; b=qIM5y4SEATUxU9EWNf1ZVyAmcdZqQSpTK0b0UHITvrQH6UJmm1TRP2CPMOGSJEGvu7HGndd4WS51/UV7E+iiuF2wb3AuE0gF5dq2Fch7/YBuFf5FGN+Yhst5Rq8ld5AWU1ZJVFk3086VhHwU/Fl3g5yL1f0jmFaIieo1pbInbeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736943843; c=relaxed/simple;
	bh=AeIA3hbhL03Y1a9pG2JxeocgXeUk+0r4H5GnU7gGBKE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mQDYad3mdAewU3uFJwDWatnNOoLDD173C+D8/yMXwyBjfTekCdRqaSsiJzry4G/dtYoQxGVn5WLbseR2l1sh5qgdXFOZ0A3kPP6U52INE9bmpYdkJuWeEbnLqo5jrp3U/0Lz4U/2dnzO/OD8ehHdonPEPiSYl7y8Ml0s354Q6OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=f148JslP; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50F0VPHt013770;
	Wed, 15 Jan 2025 12:23:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=1aKPT2
	XumRYwmCj4C+6PmiLZ2a428IMC1DLodC8/xW8=; b=f148JslP6hlzBki+xI6cr9
	eR9izsbQqpaCA27xS7y/aEB0JrvNr/qgupCyjbtzW7X7tezUUETKTc4m28dwk2cl
	yWXVY9HUbE/+se8ZVpYX1KWaUeLaZAzxFFYMJS1yCDG4RG35A2SzZyC5fE7i1w39
	yoL53jgmctPXeobBPwRak1OOGXsS9Hr6MMs4n+mfSRh8+/RDuMK1VBh0vCKcadKF
	m3unA+XfWh3TK+DQxo3EPZwxgzahmjHfEgUWDawEdZfAClds1TcCl2bsO7sjVWrj
	FCNjYHn4Nf7i14g/JZmnu7nQQl+OTovNNubQcttX2GPuF/uD/MqfSdZzoWgPJAcA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 445sd64y2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 12:23:56 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50FBKK6X017003;
	Wed, 15 Jan 2025 12:23:55 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4444fk8520-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 12:23:55 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50FCNpAR54657380
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jan 2025 12:23:51 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD35920043;
	Wed, 15 Jan 2025 12:23:51 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8102520040;
	Wed, 15 Jan 2025 12:23:51 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 Jan 2025 12:23:51 +0000 (GMT)
Date: Wed, 15 Jan 2025 13:23:49 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: Re: [PATCH v1 13/13] KVM: s390: remove the last user of page->index
Message-ID: <20250115132349.6eeba98e@p-imbrenda>
In-Reply-To: <4175795f-9323-4a2c-acef-d387c104f8b3@linux.ibm.com>
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
	<20250108181451.74383-14-imbrenda@linux.ibm.com>
	<4175795f-9323-4a2c-acef-d387c104f8b3@linux.ibm.com>
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
X-Proofpoint-GUID: 7bp8NXQkFyLnjpyhFBFZiY2_jdL2QvQy
X-Proofpoint-ORIG-GUID: 7bp8NXQkFyLnjpyhFBFZiY2_jdL2QvQy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_04,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501150091

On Wed, 15 Jan 2025 13:17:01 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 1/8/25 7:14 PM, Claudio Imbrenda wrote:
> > Shadow page tables use page->index to keep the g2 address of the guest
> > page table being shadowed.
> > 
> > Instead of keeping the information in page->index, split the address
> > and smear it over the 16-bit softbits areas of 4 PGSTEs.
> > 
> > This removes the last s390 user of page->index.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   arch/s390/include/asm/gmap.h    |  1 +
> >   arch/s390/include/asm/pgtable.h | 15 +++++++++++++++
> >   arch/s390/kvm/gaccess.c         |  6 ++++--
> >   arch/s390/mm/gmap.c             | 22 ++++++++++++++++++++--
> >   4 files changed, 40 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
> > index 5ebc65ac78cc..28c5bf097268 100644
> > --- a/arch/s390/include/asm/gmap.h
> > +++ b/arch/s390/include/asm/gmap.h
> > @@ -177,4 +177,5 @@ static inline int s390_uv_destroy_range_interruptible(struct mm_struct *mm, unsi
> >   {
> >   	return __s390_uv_destroy_range(mm, start, end, true);
> >   }
> > +  
> 
> Stray \n

yep, I had already noticed it myself (of course _after_ sending the
series)

> 
> >   #endif /* _ASM_S390_GMAP_H */
> > diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> > index 151488bb9ed7..948100a8fa7e 100644
> > --- a/arch/s390/include/asm/pgtable.h
> > +++ b/arch/s390/include/asm/pgtable.h
> > @@ -419,6 +419,7 @@ static inline int is_module_addr(void *addr)
> >   #define PGSTE_HC_BIT	0x0020000000000000UL
> >   #define PGSTE_GR_BIT	0x0004000000000000UL
> >   #define PGSTE_GC_BIT	0x0002000000000000UL
> > +#define PGSTE_ST2_MASK	0x0000ffff00000000UL
> >   #define PGSTE_UC_BIT	0x0000000000008000UL	/* user dirty (migration) */
> >   #define PGSTE_IN_BIT	0x0000000000004000UL	/* IPTE notify bit */
> >   #define PGSTE_VSIE_BIT	0x0000000000002000UL	/* ref'd in a shadow table */
> > @@ -2001,4 +2002,18 @@ extern void s390_reset_cmma(struct mm_struct *mm);
> >   #define pmd_pgtable(pmd) \
> >   	((pgtable_t)__va(pmd_val(pmd) & -sizeof(pte_t)*PTRS_PER_PTE))
> >   
> > +static inline unsigned long gmap_pgste_get_index(unsigned long *pgt)
> > +{
> > +	unsigned long *pgstes, res;
> > +
> > +	pgstes = pgt + _PAGE_ENTRIES;
> > +
> > +	res = (pgstes[0] & PGSTE_ST2_MASK) << 16;
> > +	res |= pgstes[1] & PGSTE_ST2_MASK;
> > +	res |= (pgstes[2] & PGSTE_ST2_MASK) >> 16;
> > +	res |= (pgstes[3] & PGSTE_ST2_MASK) >> 32;
> > +
> > +	return res;
> > +}  
> 
> I have to think about that change for a bit before I post an opinion.

it's not pretty, but it can (and will, in upcoming patches) be
generalized to hold arbitrary data in the PGSTEs (up to 512 bytes per
page table)

