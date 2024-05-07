Return-Path: <kvm+bounces-16883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9D228BE951
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:39:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D4EE291C8E
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:39:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B20616D9B9;
	Tue,  7 May 2024 16:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HFHnRku8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AEA16C43E;
	Tue,  7 May 2024 16:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715099707; cv=none; b=oqAY8eiN8aeHuqHUAY0VqVusKkERwyiXgWbWuPwAh64UvAGs5l0Vzu6LqrlQ+6UuFCev5ZQKpXKGMYgBqM+xFhtmEu+DjPxVe9D8xeBQLsdGBkAJzQm0AMGgkTiFyx8LxqDOO0GwqINMN1O47yq5lMdYSrPSzaD5sL7nuoXvQwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715099707; c=relaxed/simple;
	bh=GlH2pqCHYrwAje+BznfQ1P8XWDMeTgeW8tuZE6uDzzE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OBwzXX8ozSZ/9eRS/yMVV+PtMGRz4vs5YmQTiy14PHxbIGX7TKKm3p2QbzLl++TNhi5DsHmWIkMERmtx0ICIScXPrKG0idWMdSZdwxf/QFCcnRk6tuNl9kf9cC48oDCjMq7kx8YpxQgbPwhyuVWggyiXAb026//8EoQcAJ5JvQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HFHnRku8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 447GQ2IX011066;
	Tue, 7 May 2024 16:35:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=x4fspG9j9cAIP/bzprcv/2RYn3dPxdV1ZP6yB2zRpf0=;
 b=HFHnRku8py2KfPbl4X7th3LVP4TUa5ZO/48D/cKHyC0XFYBTJK3/LqL94pavkJ3Xg3gk
 OK0KYEwrhfsdR4WP6QFyYyy/fBmEPMW6mkDIS618VVdUgjuCA1c9zbr3UvP/BuJSvMvG
 bpFqLjMEbTpMreZlrZXGzvUptthPPuV20G6j74lSvT9nWrz0QdTAu6Mx6BYjKmxNvnSS
 GE+iePvwYTBbqBhRXkFSTDzb220MSkuSsq7Ec8APWxKj2QHs7gnMXgK/kqz6Bhi8aK+y
 jUhSmmYTE7+i/Bad0dDSTPvvAunXLtBmXcn6+YqOe6AXhmNhl+dLurBwMKi5CHTTczwN oA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyqhr81sg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:35:02 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 447GZ2cO025549;
	Tue, 7 May 2024 16:35:02 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyqhr81se-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:35:02 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 447FIYnM010648;
	Tue, 7 May 2024 16:35:01 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xx0bp7ad1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:35:00 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 447GYtlO43319598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 May 2024 16:34:57 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E9FE20043;
	Tue,  7 May 2024 16:34:55 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1A35520040;
	Tue,  7 May 2024 16:34:55 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 May 2024 16:34:55 +0000 (GMT)
Date: Tue, 7 May 2024 17:43:37 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily
 Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Gerald
 Schaefer <gerald.schaefer@linux.ibm.com>,
        Matthew Wilcox
 <willy@infradead.org>, Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v2 03/10] s390/uv: split large folios in
 gmap_make_secure()
Message-ID: <20240507174337.5a2acb06@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <20240412142120.220087-4-david@redhat.com>
References: <20240412142120.220087-1-david@redhat.com>
	<20240412142120.220087-4-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9OuFfuX-oE_LVd1VQSevmkepDHYPlAgn
X-Proofpoint-GUID: l20GcYXGdbQP3cMDJK9S0fHH4KRNJLcO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_10,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2404010000 definitions=main-2405070113

On Fri, 12 Apr 2024 16:21:13 +0200
David Hildenbrand <david@redhat.com> wrote:

> While s390x makes sure to never have PMD-mapped THP in processes that use
> KVM -- by remapping them using PTEs in
> thp_split_walk_pmd_entry()->split_huge_pmd() -- there is still the
> possibility of having PTE-mapped THPs (large folios) mapped into guest
> memory.
> 
> This would happen if user space allocates memory before calling
> KVM_CREATE_VM (which would call s390_enable_sie()). With upstream QEMU,
> this currently doesn't happen, because guest memory is setup and
> condiitonally preallocated after KVM_CREATE_VM.

*conditionally

> 
> Could it happen with shmem/file-backed memory when another process
> allocated memory in the pagecache? Likely, although currently not a
> common setup.
> 
> Trying to split any PTE-mapped large folios sounds like the right and
> future-proof thing to do here. So let's call split_folio() and handle the
> return values accordingly.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/kernel/uv.c | 31 +++++++++++++++++++++++++------
>  1 file changed, 25 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 25fe28d189df..3c6d86e3e828 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -338,11 +338,10 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
>  		goto out;
>  	if (pte_present(*ptep) && !(pte_val(*ptep) & _PAGE_INVALID) && pte_write(*ptep)) {
>  		folio = page_folio(pte_page(*ptep));
> -		rc = -EINVAL;
> -		if (folio_test_large(folio))
> -			goto unlock;
>  		rc = -EAGAIN;
> -		if (folio_trylock(folio)) {
> +		if (folio_test_large(folio)) {
> +			rc = -E2BIG;
> +		} else if (folio_trylock(folio)) {
>  			if (should_export_before_import(uvcb, gmap->mm))
>  				uv_convert_from_secure(PFN_PHYS(folio_pfn(folio)));
>  			rc = make_folio_secure(folio, uvcb);
> @@ -353,15 +352,35 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
>  		 * Once we drop the PTL, the folio may get unmapped and
>  		 * freed immediately. We need a temporary reference.
>  		 */
> -		if (rc == -EAGAIN)
> +		if (rc == -EAGAIN || rc == -E2BIG)
>  			folio_get(folio);
>  	}
> -unlock:
>  	pte_unmap_unlock(ptep, ptelock);
>  out:
>  	mmap_read_unlock(gmap->mm);
>  
>  	switch (rc) {
> +	case -E2BIG:
> +		folio_lock(folio);
> +		rc = split_folio(folio);
> +		folio_unlock(folio);
> +		folio_put(folio);
> +
> +		switch (rc) {
> +		case 0:
> +			/* Splitting succeeded, try again immediately. */
> +			goto again;
> +		case -EAGAIN:
> +			/* Additional folio references. */
> +			if (drain_lru(&drain_lru_called))
> +				goto again;
> +			return -EAGAIN;
> +		case -EBUSY:
> +			/* Unexpected race. */
> +			return -EAGAIN;
> +		}
> +		WARN_ON_ONCE(1);
> +		return -ENXIO;
>  	case -EAGAIN:
>  		/*
>  		 * If we are here because the UVC returned busy or partial


