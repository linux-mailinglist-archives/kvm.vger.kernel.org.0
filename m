Return-Path: <kvm+bounces-57848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1846BB7EF5B
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:08:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C97731655E1
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABA17330D52;
	Wed, 17 Sep 2025 12:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ikB/Fwbj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992791F460B;
	Wed, 17 Sep 2025 12:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113749; cv=none; b=slY6i6W0ysZ7Jb2WpX4FdjLkQ6/+pMVFvGVVN7FsAvWw+YISbeChs3bd6CbLhTOzctpZrBry3afSYi7nN7DRUNDDhLihmYXi/xpeHfQUbujQVwvqkomToFDjtK6HL32gCeV+LUpYERuAFxvU7BNBTIXKanb7CS5O8vH3jcC7jfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113749; c=relaxed/simple;
	bh=g+e+sCM8vOuwHziJ8nU7yKy6YBgxgH8tW5NkzaLAMJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=owT9b5OGmscF8OSCAnyTj+rpGqD+ewHcbRVH6MwPyLWk4iW4wkAEg8ylViODOBeE3R9kAORHahAjfyH7hYiltaqry7swzL9vOfZWbzaZew766+7DjVPfghqKmONduwWhgmle6RVbzS48OBRhI/m5sEHw6+MwGeB6oMLCe5i3gOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ikB/Fwbj; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HA7OHD011288;
	Wed, 17 Sep 2025 12:55:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=PHCVjl2Hwadu/TNC2m0XB78zB8i7Yn
	L/4NjFYFscumY=; b=ikB/FwbjVZ+iMshsx4+LwOSqPc5EChxXDBKmj/wEq8IqAT
	KhYz6V+0NlCGAMOc7lgSrbuwqJG+M164DrcECV3bfpwARyJa3CyIjOHyIL2bv/aE
	+1aGBTZVwey7V2PYLqPYT/GITThV3YNPwiewGzht+4mhHzrIJe9IxO1d2V3g9/VO
	BlocHgdtNfx88oLB6R33m05WupDMzJP1rGJyioYguGaKz40lby+C+o9+imMIrn3I
	e/hxNqDfUfFw6wITGZzTk1ZAK7nLzaK6oJijyVO5C8q2Dh0sHyg2HUiAvlMGRW2f
	G7S19O7IR4eiILSr/V+aEFboDAKNMVwXjcxaRi7g==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4nbjcw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 12:55:35 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58HAA8Bm022297;
	Wed, 17 Sep 2025 12:55:34 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495kxps9v0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 12:55:34 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HCtUYR31457698
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 12:55:30 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 855582004B;
	Wed, 17 Sep 2025 12:55:30 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 58BB120040;
	Wed, 17 Sep 2025 12:55:30 +0000 (GMT)
Received: from osiris (unknown [9.152.212.133])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 17 Sep 2025 12:55:30 +0000 (GMT)
Date: Wed, 17 Sep 2025 14:55:29 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 10/20] KVM: s390: KVM page table management functions:
 walks
Message-ID: <20250917125529.7515Df6-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-11-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910180746.125776-11-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=MN5gmNZl c=1 sm=1 tr=0 ts=68caafc7 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=ZaHFFdLEXfJz46AHvcMA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: aKrFMvfWZqzEAbuBiA87bYltdcqWsS1d
X-Proofpoint-ORIG-GUID: aKrFMvfWZqzEAbuBiA87bYltdcqWsS1d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX0P50K0IYP2ON
 INObTJUI9xjaRNhyTQsFtewdF3TfUpDnREwElpZMUIkpDsUAjI/T0S2NhPhknh+5lIi/xzCrvQC
 jhqo6fCj8VTbUa462qRgc6Fj4fSI+3vhgsz2Nzj1ffJn04EE7HeD4/7gRLQEXXKgivXAkFJtNUC
 NbNm5iqSMb36TCl3BUnu2UJc7Yyr9a82UCzr6VOUeSfc4dVtNSWcwHiDZLUNCWnLIkZVg7SGWqY
 m1O6uhshcgdl4eoDnFLzQbcyq5PFOmOzUpv16eO8PbxrJaJeCX7ewm/s8P1tD1Zr2F5jqtJDIkx
 7wZOJmUSIk/dU7IUsAd9Phb5b+17iAQYis5THXRFUCTT1En+jb6xxJlSXvdVFf4NASBqDYT710J
 Ji/sgy28
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

On Wed, Sep 10, 2025 at 08:07:36PM +0200, Claudio Imbrenda wrote:
> Add page table management functions to be used for KVM guest (gmap)
> page tables.
> 
> This patch adds functions to walk to specific table entries, or to
> perform actions on a range of entries.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/dat.c | 351 ++++++++++++++++++++++++++++++++++++++++++++
>  arch/s390/kvm/dat.h |  38 +++++
>  2 files changed, 389 insertions(+)

...

> +/*
> + * dat_split_pmd is assumed to be called with mmap_lock held in read or write mode
> + */
> +static int dat_split_pmd(union pmd *pmdp, gfn_t gfn, union asce asce)
> +{
> +	struct page_table *pt;
> +	union pmd new, old;
> +	union pte init;
> +	int i;
> +
> +	old = READ_ONCE(*pmdp);
> +
> +	/* Already split, nothing to do */
> +	if (!old.h.i && !old.h.fc)
> +		return 0;
> +
> +	pt = dat_alloc_pt_noinit();
> +	if (!pt)
> +		return -ENOMEM;
> +	new.val = virt_to_phys(pt);
> +
> +	while (old.h.i || old.h.fc) {
> +		init.val = pmd_origin_large(old);
> +		init.h.p = old.h.p;
> +		init.h.i = old.h.i;
> +		init.s.d = old.s.fc1.d;
> +		init.s.w = old.s.fc1.w;
> +		init.s.y = old.s.fc1.y;
> +		init.s.sd = old.s.fc1.sd;
> +		init.s.pr = old.s.fc1.pr;
> +		if (old.h.fc) {
> +			for (i = 0; i < _PAGE_ENTRIES; i++)
> +				pt->ptes[i].val = init.val | i * PAGE_SIZE;
> +			/* no need to take locks as the page table is not installed yet */
> +			dat_init_pgstes(pt, old.s.fc1.prefix_notif ? PGSTE_IN_BIT : 0);
> +		} else {
> +			dat_init_page_table(pt, init.val, 0);
> +		}
> +
> +		if (dat_pmdp_xchg_atomic(pmdp, old, new, gfn, asce))
> +			return 0;
> +		old = READ_ONCE(*pmdp);
> +	}
> +
> +	dat_free_pt(pt);
> +	return 0;
> +}

Just to annoy you again: is there a particular reason why this function isn't
called "dat_split_segment()" instead of "_pmd()"? I'm still trying to convince
you to get rid of pmd(p) usage, whenever possible. IMHO this would make the
code easier to understand and maintain as it doesn't mix things, as I already
stated previously.

> +	if (asce.dt >= ASCE_TYPE_REGION2) {
> +		*last = table->crstes + p4d_index(gfn_to_gpa(gfn));
> +		entry = READ_ONCE(**last);
> +		if (WARN_ON_ONCE(unlikely(entry.h.tt != LEVEL_P4D)))
> +			return -EINVAL;
> +		if (crste_hole(entry) && !ign_holes)
> +			return entry.tok.type == _DAT_TOKEN_PIC ? entry.tok.par : -EFAULT;
> +		if (walk_level == LEVEL_P4D)

Also this (even though also as stated earlier): IMHO it would be good to get
rid of the LEVEL defines and use the corresponding TABLE_TYPEs instead.

> +	if (continue_anyway && !entry.pmd.h.fc && !entry.h.i) {
> +		walk_level = LEVEL_PTE;

Hm, ok, there is no TABLE_TYPE for this level. Invention required :)

