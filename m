Return-Path: <kvm+bounces-64548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 27A24C86CE7
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:26:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6E9E0350FD6
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 19:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3498F335579;
	Tue, 25 Nov 2025 19:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WIDhROVH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA890335556;
	Tue, 25 Nov 2025 19:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764098673; cv=none; b=X2Wm/1PEoFZjSno+uRnV85LIEg6QmR4Uo8p2juJHjthMFrqtyglKd/7TqE5pAUjDY6jTZ+L0eb+9p8eT5AunDAUeaZxW19GL8uNn9BzLZqpAWG5fGQftj/2XwNNq4qtyT3d/SLtmlcMUUrfuAeNeAfnQ6rnf6plf3jxczENZTW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764098673; c=relaxed/simple;
	bh=jk38rsE3LYQOcPjLEjAhw+FAZ0drF5GK5zeGmP3T9+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SH4Yw7AMFiepMnwdVX18B3zfICRh2e76jYaax31LAh9NqyuzWbIIRhQmkcAmqcsTkHNNy+QE74Tx8Fg1fwh0o2auCZqtmlj/+QMBvLX+ETjYO7KSRTxe6TR7B6e3iONQMxKuJ3ZfFTN2tTTfBCIwwfwZPnrBXCgq4mJ6z/8SOp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WIDhROVH; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5APFK4RI016223;
	Tue, 25 Nov 2025 19:24:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ZvTBlZQ54d6whPwr9Cw4owd+a0XpzX
	YqKRGHTYpiOmY=; b=WIDhROVHm0DUliqOamCL6v8S9tcClt99HOYlyWGpS+BgdO
	jH6GVNUHjrV+e5vqnuelQ+uhJLppYdkT3s4Nq/vRe/GhSyEgtdnwoBOET7aWKVwN
	Pz9YLHmtTTlCru56CO61QOe1lbIEAyqkgdb2qcQsvInHuS9cbldnPKbm5VMVWkEz
	UKp71DfBsvx1aIKVbETUwnFE773XVbhKLWoxdq0RxkIcCmoa77PRMuHgXxayf0Ik
	XTTsnur5+OFXDbGzq1nE9J8GD7UNBPRYUVvQsR9kcjLxBRDVtczrB7VbmlWaF8mT
	wzSOEz6d4kX9mdRDcxL4JMCrjUI4nQJILOLV+p5A==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak2kpy5rw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Nov 2025 19:24:19 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5APIOAxM016406;
	Tue, 25 Nov 2025 19:24:18 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aks0k5tub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Nov 2025 19:24:18 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5APJOEC039977284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 19:24:14 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A0ECD2004E;
	Tue, 25 Nov 2025 19:24:14 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 131C820040;
	Tue, 25 Nov 2025 19:24:14 +0000 (GMT)
Received: from osiris (unknown [9.87.151.24])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 25 Nov 2025 19:24:14 +0000 (GMT)
Date: Tue, 25 Nov 2025 20:24:12 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, gra@linux.ibm.com, schlameuss@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        david@redhat.com, gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v5 21/23] KVM: S390: Remove PGSTE code from linux/s390 mm
Message-ID: <20251125192412.7336A36-hca@linux.ibm.com>
References: <20251124115554.27049-1-imbrenda@linux.ibm.com>
 <20251124115554.27049-22-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124115554.27049-22-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAwMCBTYWx0ZWRfXy1UIRo39xGFz
 1n/P07ySCgUZdCv0sdBLOZ6BdTE8Y+2Uz4cJaIhMzakQprHYF7+DjSW9qatT0jveb4GHO4daA4O
 h0ePpUCMQouOw7MdvpyFKwDI9PpmF9rJMCpkbkzVxBevvBhlrHJjs8CfSsJG57sEfiTnkp8ldhg
 fe9a2m/b4vuQBerwlw5GeeMexNNEHR033wN158noiCBaqIsWO8b/4fqu3YdT/Z6ZJIoJYJzmYiO
 Fs1EzHd6XgckUC3YhkAy6szx6Oc7cQrypRPmaX6miphtnPBVcD9SE0u3LMGr9D7rbDi50wW7sHO
 3u/Z1ZyzulGPFIxLVWYTiug1jbH8URcykj+cvpcXU1qSaMgBa5Vr3SaLonEFHbNHtIRuK1BmFdM
 RthHt/LWum9O27KEoRFCgVimiI72Mg==
X-Authority-Analysis: v=2.4 cv=fJM0HJae c=1 sm=1 tr=0 ts=69260263 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=IfoNGHcFGeDbAKkAgyoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: FZI3YXEuKjC47N6bTXWwEy0q-A8w6J9e
X-Proofpoint-ORIG-GUID: FZI3YXEuKjC47N6bTXWwEy0q-A8w6J9e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220000

On Mon, Nov 24, 2025 at 12:55:52PM +0100, Claudio Imbrenda wrote:
> Remove the PGSTE config option.
> Remove all code from linux/s390 mm that involves PGSTEs.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/Kconfig               |   3 -
>  arch/s390/include/asm/mmu.h     |  13 -
>  arch/s390/include/asm/page.h    |   4 -
>  arch/s390/include/asm/pgalloc.h |   4 -
>  arch/s390/include/asm/pgtable.h | 121 +----
>  arch/s390/kvm/dat.h             |   1 +
>  arch/s390/mm/hugetlbpage.c      |  24 -
>  arch/s390/mm/pgalloc.c          |  24 -
>  arch/s390/mm/pgtable.c          | 829 +-------------------------------
>  mm/khugepaged.c                 |   9 -
>  10 files changed, 17 insertions(+), 1015 deletions(-)

...

>  pte_t ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr,
>  			     pte_t *ptep)
>  {
> -	pgste_t pgste;
> -	pte_t old;
> -	int nodat;
> -	struct mm_struct *mm = vma->vm_mm;
> -
> -	pgste = ptep_xchg_start(mm, addr, ptep);
> -	nodat = !!(pgste_val(pgste) & _PGSTE_GPS_NODAT);
> -	old = ptep_flush_lazy(mm, addr, ptep, nodat);
> -	if (mm_has_pgste(mm)) {
> -		pgste = pgste_update_all(old, pgste, mm);
> -		pgste_set(ptep, pgste);
> -	}
> -	return old;
> +	preempt_disable();
> +	return ptep_flush_lazy(vma->vm_mm, addr, ptep, 1);
>  }
>  
>  void ptep_modify_prot_commit(struct vm_area_struct *vma, unsigned long addr,
>  			     pte_t *ptep, pte_t old_pte, pte_t pte)
>  {
> -	pgste_t pgste;
> -	struct mm_struct *mm = vma->vm_mm;
> -
> -	if (mm_has_pgste(mm)) {
> -		pgste = pgste_get(ptep);
> -		pgste_set_key(ptep, pgste, pte, mm);
> -		pgste = pgste_set_pte(ptep, pgste, pte);
> -		pgste_set_unlock(ptep, pgste);
> -	} else {
> -		set_pte(ptep, pte);
> -	}
> +	set_pte(ptep, pte);
> +	preempt_enable();
>  }

Why did you add the preempt_disable()/preempt_enable() pair?
This causes preempt_count overflows.

See modify_prot_start_ptes() + modify_prot_commit_ptes()...

