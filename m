Return-Path: <kvm+bounces-62520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40917C47B60
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 16:56:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1693C3A9C06
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 15:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5859F315D51;
	Mon, 10 Nov 2025 15:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ht+K8nHR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFA42264BA;
	Mon, 10 Nov 2025 15:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789127; cv=none; b=WACAYoOhFTQ/JOkfgikudVlIFwibi3HDyjKrenyoetoDEhiNFyWEz2rCFrQ01C6UmS6sPhjhe5CuO2sBthbM4xH0TOVMvgcJC9XPeFMScBFwFoCgiqd0bD/NGonxzeotI045cBeEGPzJhKLd5Ifrw0MiulzpCrZVumVlr3VL1zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789127; c=relaxed/simple;
	bh=LHsY5jITGDFoq/9tN1I06LeZBDtc15xV3HQ5viiTCs0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=REi6MAbI9FPUvA84SBQqBF6W7umFKokPYxkDTLrroLLPIlK7iU/e11NRu3C+CuHdzTEnR3sdEDtl6u/l5ALrQ3vjeaBYoacp2fs8BsAFMy45Df6h6umz4UfwbWaZiFd7IfxGbj3c5b+xpLBzHemn6lVx12gAwkLpF0SY2t/4kvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ht+K8nHR; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAEUkwT024315;
	Mon, 10 Nov 2025 15:38:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=OcBGousLcIDBIHHZkfGtkxYLVh1p65
	7jRflqxnRy9pQ=; b=ht+K8nHRBVOP+H24c7yctgg2tTK0qOw0shdi88awVOmD8B
	ftVtlAnJoNKSBi2GKdkOB2dQfdRkCgkoeiM1TkZEUxlpVCU29RjaVVSJ+G2pi0dT
	G+P6HAe4mbrmrtiBeatCuCRHxaZEhGDM6sPTfJGVgOOXUpyYJc/CgYYvLKYYCOJH
	uNWqaf+8/Ha4pQfE5rtJePqPuCo79vqwoueGiQ5il4K2jEO9q3MehvxufcDb1k+N
	VS4f2Hhs4IYRLb5j/12XLsikE4qNToUPpfUHdz1qAuTj9zDS22IcalQmppSjGXfU
	LDkSqg5JJQufjTcZOZNkZG2lb1N3oUnQfG+Y2Ueg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5chyqff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 15:38:40 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAD2EFi007313;
	Mon, 10 Nov 2025 15:38:39 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aajdj63d3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 15:38:39 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AAFcZub41091336
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 15:38:35 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5042A20043;
	Mon, 10 Nov 2025 15:38:35 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4368C20040;
	Mon, 10 Nov 2025 15:38:34 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.111.80.93])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 10 Nov 2025 15:38:34 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        nrb@linux.ibm.com, nsg@linux.ibm.com, seiden@linux.ibm.com,
        gra@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        ggala@linux.ibm.com, david@redhat.com
Subject: Re: [PATCH v1 1/1] KVM: s390: Fix gmap_helper_zap_one_page() again
In-Reply-To: <20251106152545.338188-1-imbrenda@linux.ibm.com>
References: <20251106152545.338188-1-imbrenda@linux.ibm.com>
Date: Mon, 10 Nov 2025 16:38:33 +0100
Message-ID: <87346l7v9i.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Ss+dKfO0 c=1 sm=1 tr=0 ts=69120700 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=pknXBTohXVt6Cvpor-UA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA5NSBTYWx0ZWRfX2zwed/t/ApLa
 f4rlvWj9QEs2BT/VketNC18m+DOIyUUG1zTiAJCTMgSCYAbhoyWLLSyaeYHg5ATQ2iI0hkzyAHa
 VulS+5gr3gw9ECbZhjxQKgSsWdgbxLyan2ILmqhj+FUKiWBDmOaC+KXTNx5hvg8ZlO6L+77S007
 T/37mykupHkbSlny/9O0fUd4Rzuwfv0kgYwRYtl0tetMF99k456ZrusMsxRIDzV7sNt8EW5DC8R
 KQwEj4R9LIbZN14LvuHc1Cb9g1K/8NNnyFOWWCd8HnpWttWTq/8rY2NgH69dPQKC4zDN56FcK9R
 DAPTbkILI2B0+1elQPgPmM9hHk1Gm4gsyWtsMrW2SkLlPPdnAJM0UR8UjErZ70op3Pi9NZv1v1m
 UL2X8xn+mVn0nuW55b0FfyGCIoXFGQ==
X-Proofpoint-GUID: LPxLY2YjJFAeJd2cnqic_Cz6afSrasmA
X-Proofpoint-ORIG-GUID: LPxLY2YjJFAeJd2cnqic_Cz6afSrasmA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_05,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080095

On Thu, Nov 06, 2025 at 04:25 PM +0100, Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
> A few checks were missing in gmap_helper_zap_one_page(), which can lead
> to memory corruption in the guest under specific circumstances.
>
> Add the missing checks.
>
> Fixes: 5deafa27d9ae ("KVM: s390: Fix to clear PTE when discarding a swapped page")
> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/mm/gmap_helpers.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
> index d4c3c36855e2..38a2d82cd88a 100644
> --- a/arch/s390/mm/gmap_helpers.c
> +++ b/arch/s390/mm/gmap_helpers.c
> @@ -47,6 +47,7 @@ static void ptep_zap_swap_entry(struct mm_struct *mm, swp_entry_t entry)
>  void gmap_helper_zap_one_page(struct mm_struct *mm, unsigned long vmaddr)
>  {
>  	struct vm_area_struct *vma;
> +	unsigned long pgstev;
>  	spinlock_t *ptl;
>  	pgste_t pgste;
>  	pte_t *ptep;
> @@ -65,9 +66,13 @@ void gmap_helper_zap_one_page(struct mm_struct *mm, unsigned long vmaddr)
>  	if (pte_swap(*ptep)) {
>  		preempt_disable();
>  		pgste = pgste_get_lock(ptep);
> +		pgstev = pgste_val(pgste);
>  
> -		ptep_zap_swap_entry(mm, pte_to_swp_entry(*ptep));
> -		pte_clear(mm, vmaddr, ptep);
> +		if ((pgstev & _PGSTE_GPS_USAGE_MASK) == _PGSTE_GPS_USAGE_UNUSED ||
> +		    (pgstev & _PGSTE_GPS_ZERO)) {
> +			ptep_zap_swap_entry(mm, pte_to_swp_entry(*ptep));
> +			pte_clear(mm, vmaddr, ptep);
> +		}
>  
>  		pgste_set_unlock(ptep, pgste);
>  		preempt_enable();
> -- 
> 2.51.1

Thanks for the fix.

Tested-by: Marc Hartmayer <mhartmay@linux.ibm.com>

