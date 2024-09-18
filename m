Return-Path: <kvm+bounces-27068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A546D97BB24
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 12:56:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D1E11F24D29
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 10:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCEB6184114;
	Wed, 18 Sep 2024 10:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Tj8olah6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEB2381D5;
	Wed, 18 Sep 2024 10:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726656969; cv=none; b=GcWM7l0u8DbLb6NqLalBV6o4HX5qRPHCAEp+l8Sc6j9NKNYfIqnZdYCcnjSx8BQ2UNVmwcpPgj4dsBNQLflxCiCFQpccZ0iNkuCyEwNoWxgVZjy7YMggIBSRyNBFArugyeuAbd0b8dSWE6SXeb2hMqSSp0r8a1UPLKxbMCGlGpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726656969; c=relaxed/simple;
	bh=Nro01JlJOcF/gmso+wpRiJXuo/a9pEqcUHcxwsns3AM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cKftFLZc5hXMAqg4KT6s3MNELubHA70SWb0fpUE3FHU9FMtIHposRgErBz0tQdeBVnpXjdBzu0wt/jbzwXhyFI/Elu+diCPXLjN2Bbah6EvzGmHLZU6N1SrfNPUn3DmgL7ENy89/EAgRq3jW6s/ai+7JGlGn2lUXO3WwhMqMUtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Tj8olah6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48HMxBek031399;
	Wed, 18 Sep 2024 10:56:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=ivHy+iQh2TUSLbk1lfjRppjXKAY
	RZ3lZ1bgiuF0ozXY=; b=Tj8olah6UTJYOgimorHOffM4YVQD88u8GdMIwBOq/mz
	LdAqUIffP0RJxiO808SExzdAU/K8+q6uOmuHaHp0GMhGqNnJJkGKtKX8npf/SGug
	Bwzg1TgjpTw0GRa6THPrMFyCDEH2bSkeqPFnR4tQMRH6Ab+aU/UgQQIR0ipXPBPf
	9skayiBhpLCkAWqcd5/lbzyJBUMp5+678y0XuIfszVjCUq9dXZ2HfYQ71tPHKCZW
	d0FEORkxws1dXafQ94SxOA3RDjhckaCGYNxZzAuDk15OgLNg/0TO0WQZalUpB6Mm
	pVXLeS9r4nenwHLVpQz1irWdT8baOVMPR2voCrj+Waw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3vnw0ad-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Sep 2024 10:56:04 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 48IAu4lM005785;
	Wed, 18 Sep 2024 10:56:04 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3vnw0a8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Sep 2024 10:56:04 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48I8oXqO001871;
	Wed, 18 Sep 2024 10:56:03 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 41nqh3t6xp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Sep 2024 10:56:03 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48IAtxml40763834
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Sep 2024 10:55:59 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C1A3620040;
	Wed, 18 Sep 2024 10:55:59 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A037420043;
	Wed, 18 Sep 2024 10:55:59 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 18 Sep 2024 10:55:59 +0000 (GMT)
Date: Wed, 18 Sep 2024 12:55:57 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>
Cc: borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        david@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/2] KVM: s390: gaccess: check if guest address is in
 memslot
Message-ID: <20240918105557.6794-B-hca@linux.ibm.com>
References: <20240917151904.74314-1-nrb@linux.ibm.com>
 <20240917151904.74314-2-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240917151904.74314-2-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 490CDxhU7fBMnL1CgBJeOebs1dESGUd8
X-Proofpoint-GUID: 5UaRTxsro-tytv5273cnNEMINoeUhyhl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-18_09,2024-09-16_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 impostorscore=0 spamscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2409180069

On Tue, Sep 17, 2024 at 05:18:33PM +0200, Nico Boehr wrote:
> Previously, access_guest_page() did not check whether the given guest
> address is inside of a memslot. This is not a problem, since
> kvm_write_guest_page/kvm_read_guest_page return -EFAULT in this case.
...
> To be able to distinguish these two cases, return PGM_ADDRESSING in
> access_guest_page() when the guest address is outside guest memory. In
> access_guest_real(), populate vcpu->arch.pgm.code such that
> kvm_s390_inject_prog_cond() can be used in the caller for injecting into
> the guest (if applicable).
> 
> Since this adds a new return value to access_guest_page(), we need to make
> sure that other callers are not confused by the new positive return value.
> 
> There are the following users of access_guest_page():
> - access_guest_with_key() does the checking itself (in
>   guest_range_to_gpas()), so this case should never happen. Even if, the
>   handling is set up properly.
> - access_guest_real() just passes the return code to its callers, which
>   are:
>     - read_guest_real() - see below
>     - write_guest_real() - see below
> 
> There are the following users of read_guest_real():
> - ar_translation() in gaccess.c which already returns PGM_*

With this patch you actually fix a bug in ar_translation(), where two
read_guest_real() invocations might have returned -EFAULT instead of
the correct PGM_ADDRESSING.

Looks like the author assumed read_guest_real() would do the right
thing. See commit 664b49735370 ("KVM: s390: Add access register mode").

> Fixes: 2293897805c2 ("KVM: s390: add architecture compliant guest access functions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  arch/s390/kvm/gaccess.c |  7 +++++++
>  arch/s390/kvm/gaccess.h | 14 ++++++++------
>  2 files changed, 15 insertions(+), 6 deletions(-)

> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index e65f597e3044..004047578729 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -828,6 +828,9 @@ static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
>  	const gfn_t gfn = gpa_to_gfn(gpa);
>  	int rc;
>  
> +	if (!gfn_to_memslot(kvm, gfn))
> +		return PGM_ADDRESSING;
> +
>  	if (mode == GACC_STORE)
>  		rc = kvm_write_guest_page(kvm, gfn, data, offset, len);

It would be nice to not add random empty lines to stay consistent with the
existing coding style.

>  	}
> +
> +	if (rc > 0)
> +		vcpu->arch.pgm.code = rc;
> +
>  	return rc;
>  }

Same here.

But whoever applies this can change this, or not.

In any case:
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>

