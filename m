Return-Path: <kvm+bounces-35535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D15AA123FA
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 13:49:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE3633A75DC
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 12:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8628F22F84A;
	Wed, 15 Jan 2025 12:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sbSZ/Bmq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0BE2475ED;
	Wed, 15 Jan 2025 12:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736945340; cv=none; b=E7InXVtruQHmGHzPkEmTKcO0jPvec7tAKOaej2R5DY4/pSD+P/+mYCFtB1MHoiap4/ujYGgYkHnPfIIsyl9pJVNcXfSy6X8xXiL+KcgSoshHboI7HGuwVLjQ02Cwbri/+1299sEHCs1yRKL2bOBcava7q1m2xEdbXBCDiLnxKFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736945340; c=relaxed/simple;
	bh=JlIWm2MX/4ePeRRusYT3eNKg7MmtzpljUetGvy0mhWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PRcUy/bXJh4/cYzej9o8miWwuSDn6El8p6Ubh3BKLFKy4gH1BY3HdqL/ZQqLzt2yiQ7NY+8Ydk3mHwQb4pi/o2xlo6SxenL6mrb8sLurnUypFUkn2ip2C0WvDAAa6go9+1sy3vHpeoVC0wUpWmyJ/4YvjfceN2IFriolEi0gcE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sbSZ/Bmq; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50F2eqwp013775;
	Wed, 15 Jan 2025 12:48:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=58Lwge
	QXvaXe7ZSt4IHq8SXf0lwoHv++ZsqN0jeTQfU=; b=sbSZ/Bmqueaun0sKDysRfW
	2g2LY61MSoftVFf8E6y9I7zotbWbX5qSXKcqalYKecXfvG80Ttxq8kp4Rzmk/kBT
	aXsp3bcSz4O0sVKDHKcDnT72Eedoa5RyYz5Ou/H5G0h5vtvf8v5+EWs3daCP3T+f
	59me6s41oivQGFTE9vMpnRCn9EvBeA8j3/699YooKmQxXdZj5H8KD06MK4dyPUkO
	1sGNhgoERS6aR2sy39Fo+q+ThpUDVy26jJq+hVZdrMtQdXg3KVgIrtFytHPMxE+3
	g+1gxvegQNtwTqPuAXdZk2TuXn8zosIMyEbrKmqUlSApiUbCN66MNtpbZGBG0Lnw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 445sd6528h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 12:48:53 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50FAXO84007994;
	Wed, 15 Jan 2025 12:48:52 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443yn89yf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 12:48:52 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50FCmm6G33292920
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jan 2025 12:48:48 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8ECD420049;
	Wed, 15 Jan 2025 12:48:48 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E1ACD20040;
	Wed, 15 Jan 2025 12:48:47 +0000 (GMT)
Received: from [9.171.76.32] (unknown [9.171.76.32])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 Jan 2025 12:48:47 +0000 (GMT)
Message-ID: <03d91fa8-6f3f-4052-9b03-de28e88f0001@linux.ibm.com>
Date: Wed, 15 Jan 2025 13:48:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 04/13] KVM: s390: move pv gmap functions into kvm
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
 <20250108181451.74383-5-imbrenda@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20250108181451.74383-5-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1iBVLCapoQ7id5Q2rWkLVj2gQlVtX3tE
X-Proofpoint-ORIG-GUID: 1iBVLCapoQ7id5Q2rWkLVj2gQlVtX3tE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_05,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501150095

On 1/8/25 7:14 PM, Claudio Imbrenda wrote:
> Move gmap related functions from kernel/uv into kvm.
> 
> Create a new file to collect gmap-related functions.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/include/asm/uv.h |   7 +-
>   arch/s390/kernel/uv.c      | 293 ++++++-------------------------------
>   arch/s390/kvm/Makefile     |   2 +-
>   arch/s390/kvm/gmap.c       | 183 +++++++++++++++++++++++
>   arch/s390/kvm/gmap.h       |  17 +++
>   arch/s390/kvm/intercept.c  |   1 +
>   arch/s390/kvm/kvm-s390.c   |   1 +
>   arch/s390/kvm/pv.c         |   1 +
>   8 files changed, 251 insertions(+), 254 deletions(-)
>   create mode 100644 arch/s390/kvm/gmap.c
>   create mode 100644 arch/s390/kvm/gmap.h
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index dc332609f2c3..22ec1a24c291 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -628,12 +628,13 @@ static inline int is_prot_virt_host(void)
>   }
>   
>   int uv_pin_shared(unsigned long paddr);
> -int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
> -int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
>   int uv_destroy_folio(struct folio *folio);
>   int uv_destroy_pte(pte_t pte);
>   int uv_convert_from_secure_pte(pte_t pte);
> -int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
> +int uv_wiggle_folio(struct folio *folio, bool split);
> +int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb);
> +int uv_convert_from_secure(unsigned long paddr);
> +int uv_convert_from_secure_folio(struct folio *folio);
>   
>   void setup_uv(void);
>   
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 6f9654a191ad..832c39c9ccfa 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -19,19 +19,6 @@
>   #include <asm/sections.h>
>   #include <asm/uv.h>
>   
> -#if !IS_ENABLED(CONFIG_KVM)
> -unsigned long __gmap_translate(struct gmap *gmap, unsigned long gaddr)
> -{
> -	return 0;
> -}
> -
> -int gmap_fault(struct gmap *gmap, unsigned long gaddr,
> -	       unsigned int fault_flags)
> -{
> -	return 0;
> -}
> -#endif
> -
>   /* the bootdata_preserved fields come from ones in arch/s390/boot/uv.c */
>   int __bootdata_preserved(prot_virt_guest);
>   EXPORT_SYMBOL(prot_virt_guest);
> @@ -159,6 +146,7 @@ int uv_destroy_folio(struct folio *folio)
>   	folio_put(folio);
>   	return rc;
>   }
> +EXPORT_SYMBOL(uv_destroy_folio);
>   
>   /*
>    * The present PTE still indirectly holds a folio reference through the mapping.
> @@ -175,7 +163,7 @@ int uv_destroy_pte(pte_t pte)
>    *
>    * @paddr: Absolute host address of page to be exported
>    */
> -static int uv_convert_from_secure(unsigned long paddr)
> +int uv_convert_from_secure(unsigned long paddr)
>   {
>   	struct uv_cb_cfs uvcb = {
>   		.header.cmd = UVC_CMD_CONV_FROM_SEC_STOR,
> @@ -187,11 +175,12 @@ static int uv_convert_from_secure(unsigned long paddr)
>   		return -EINVAL;
>   	return 0;
>   }
> +EXPORT_SYMBOL_GPL(uv_convert_from_secure);
>   
>   /*
>    * The caller must already hold a reference to the folio.
>    */
> -static int uv_convert_from_secure_folio(struct folio *folio)
> +int uv_convert_from_secure_folio(struct folio *folio)
>   {
>   	int rc;
>   
> @@ -206,6 +195,7 @@ static int uv_convert_from_secure_folio(struct folio *folio)
>   	folio_put(folio);
>   	return rc;
>   }
> +EXPORT_SYMBOL_GPL(uv_convert_from_secure_folio);
>   
>   /*
>    * The present PTE still indirectly holds a folio reference through the mapping.
> @@ -237,13 +227,32 @@ static int expected_folio_refs(struct folio *folio)
>   	return res;
>   }
>   
> -static int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
> +/**
> + * make_folio_secure() - make a folio secure
> + * @folio: the folio to make secure
> + * @uvcb: the uvcb that describes the UVC to be used
> + *
> + * The folio @folio will be made secure if possible, @uvcb will be passed
> + * as-is to the UVC.
> + *
> + * Return: 0 on success;
> + *         -EBUSY if the folio is in writeback, has too many references, or is large;
> + *         -EAGAIN if the UVC needs to be attempted again;
> + *         -ENXIO if the address is not mapped;
> + *         -EINVAL if the UVC failed for other reasons.
> + *
> + * Context: The caller must hold exactly one extra reference on the folio
> + *          (it's the same logic as split_folio())
> + */
> +int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
>   {
>   	int expected, cc = 0;
>   
> +	if (folio_test_large(folio))
> +		return -EBUSY;
>   	if (folio_test_writeback(folio))
> -		return -EAGAIN;
> -	expected = expected_folio_refs(folio);
> +		return -EBUSY;
> +	expected = expected_folio_refs(folio) + 1;
>   	if (!folio_ref_freeze(folio, expected))
>   		return -EBUSY;
>   	set_bit(PG_arch_1, &folio->flags);
> @@ -267,251 +276,35 @@ static int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
>   		return -EAGAIN;
>   	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
>   }
> +EXPORT_SYMBOL_GPL(make_folio_secure);
>   
>   /**
> - * should_export_before_import - Determine whether an export is needed
> - * before an import-like operation
> - * @uvcb: the Ultravisor control block of the UVC to be performed
> - * @mm: the mm of the process
> - *
> - * Returns whether an export is needed before every import-like operation.
> - * This is needed for shared pages, which don't trigger a secure storage
> - * exception when accessed from a different guest.
> - *
> - * Although considered as one, the Unpin Page UVC is not an actual import,
> - * so it is not affected.
> + * uv_wiggle_folio() - try to drain extra references to a folio
> + * @folio: the folio
> + * @split: whether to split a large folio
>    *
> - * No export is needed also when there is only one protected VM, because the
> - * page cannot belong to the wrong VM in that case (there is no "other VM"
> - * it can belong to).
> - *
> - * Return: true if an export is needed before every import, otherwise false.
> + * Context: Must be called while holding an extra reference to the folio;
> + *          the mm lock should not be held.
>    */
> -static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
> +int uv_wiggle_folio(struct folio *folio, bool split)
>   {
> -	/*
> -	 * The misc feature indicates, among other things, that importing a
> -	 * shared page from a different protected VM will automatically also
> -	 * transfer its ownership.
> -	 */
> -	if (uv_has_feature(BIT_UV_FEAT_MISC))
> -		return false;
> -	if (uvcb->cmd == UVC_CMD_UNPIN_PAGE_SHARED)
> -		return false;
> -	return atomic_read(&mm->context.protected_count) > 1;
> -}
> -
> -/*
> - * Drain LRU caches: the local one on first invocation and the ones of all
> - * CPUs on successive invocations. Returns "true" on the first invocation.
> - */
> -static bool drain_lru(bool *drain_lru_called)
> -{
> -	/*
> -	 * If we have tried a local drain and the folio refcount
> -	 * still does not match our expected safe value, try with a
> -	 * system wide drain. This is needed if the pagevecs holding
> -	 * the page are on a different CPU.
> -	 */
> -	if (*drain_lru_called) {
> -		lru_add_drain_all();
> -		/* We give up here, don't retry immediately. */
> -		return false;
> -	}
> -	/*
> -	 * We are here if the folio refcount does not match the
> -	 * expected safe value. The main culprits are usually
> -	 * pagevecs. With lru_add_drain() we drain the pagevecs
> -	 * on the local CPU so that hopefully the refcount will
> -	 * reach the expected safe value.
> -	 */
> -	lru_add_drain();
> -	*drain_lru_called = true;
> -	/* The caller should try again immediately */
> -	return true;
> -}
> -
> -/*
> - * Requests the Ultravisor to make a page accessible to a guest.
> - * If it's brought in the first time, it will be cleared. If
> - * it has been exported before, it will be decrypted and integrity
> - * checked.
> - */
> -int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
> -{
> -	struct vm_area_struct *vma;
> -	bool drain_lru_called = false;
> -	spinlock_t *ptelock;
> -	unsigned long uaddr;
> -	struct folio *folio;
> -	pte_t *ptep;
>   	int rc;
>   
> -again:
> -	rc = -EFAULT;
> -	mmap_read_lock(gmap->mm);
> -
> -	uaddr = __gmap_translate(gmap, gaddr);
> -	if (IS_ERR_VALUE(uaddr))
> -		goto out;
> -	vma = vma_lookup(gmap->mm, uaddr);
> -	if (!vma)
> -		goto out;
> -	/*
> -	 * Secure pages cannot be huge and userspace should not combine both.
> -	 * In case userspace does it anyway this will result in an -EFAULT for
> -	 * the unpack. The guest is thus never reaching secure mode. If
> -	 * userspace is playing dirty tricky with mapping huge pages later
> -	 * on this will result in a segmentation fault.
> -	 */
> -	if (is_vm_hugetlb_page(vma))
> -		goto out;
> -
> -	rc = -ENXIO;
> -	ptep = get_locked_pte(gmap->mm, uaddr, &ptelock);
> -	if (!ptep)
> -		goto out;
> -	if (pte_present(*ptep) && !(pte_val(*ptep) & _PAGE_INVALID) && pte_write(*ptep)) {
> -		folio = page_folio(pte_page(*ptep));
> -		rc = -EAGAIN;
> -		if (folio_test_large(folio)) {
> -			rc = -E2BIG;
> -		} else if (folio_trylock(folio)) {
> -			if (should_export_before_import(uvcb, gmap->mm))
> -				uv_convert_from_secure(PFN_PHYS(folio_pfn(folio)));
> -			rc = make_folio_secure(folio, uvcb);
> -			folio_unlock(folio);
> -		}
> -
> -		/*
> -		 * Once we drop the PTL, the folio may get unmapped and
> -		 * freed immediately. We need a temporary reference.
> -		 */
> -		if (rc == -EAGAIN || rc == -E2BIG)
> -			folio_get(folio);
> -	}
> -	pte_unmap_unlock(ptep, ptelock);
> -out:
> -	mmap_read_unlock(gmap->mm);
> -
> -	switch (rc) {
> -	case -E2BIG:
> +	folio_wait_writeback(folio);
> +	if (split) {
>   		folio_lock(folio);
>   		rc = split_folio(folio);
>   		folio_unlock(folio);
> -		folio_put(folio);
> -
> -		switch (rc) {
> -		case 0:
> -			/* Splitting succeeded, try again immediately. */
> -			goto again;
> -		case -EAGAIN:
> -			/* Additional folio references. */
> -			if (drain_lru(&drain_lru_called))
> -				goto again;
> -			return -EAGAIN;
> -		case -EBUSY:
> -			/* Unexpected race. */
> +
> +		if (rc == -EBUSY)
>   			return -EAGAIN;
> -		}
> -		WARN_ON_ONCE(1);
> -		return -ENXIO;
> -	case -EAGAIN:
> -		/*
> -		 * If we are here because the UVC returned busy or partial
> -		 * completion, this is just a useless check, but it is safe.
> -		 */
> -		folio_wait_writeback(folio);
> -		folio_put(folio);
> -		return -EAGAIN;
> -	case -EBUSY:
> -		/* Additional folio references. */
> -		if (drain_lru(&drain_lru_called))
> -			goto again;
> -		return -EAGAIN;
> -	case -ENXIO:
> -		if (gmap_fault(gmap, gaddr, FAULT_FLAG_WRITE))
> -			return -EFAULT;
> -		return -EAGAIN;
> +		if (rc != -EAGAIN)
> +			return rc;
>   	}
> -	return rc;
> -}
> -EXPORT_SYMBOL_GPL(gmap_make_secure);
> -
> -int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr)
> -{
> -	struct uv_cb_cts uvcb = {
> -		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
> -		.header.len = sizeof(uvcb),
> -		.guest_handle = gmap->guest_handle,
> -		.gaddr = gaddr,
> -	};
> -
> -	return gmap_make_secure(gmap, gaddr, &uvcb);
> -}
> -EXPORT_SYMBOL_GPL(gmap_convert_to_secure);
> -
> -/**
> - * gmap_destroy_page - Destroy a guest page.
> - * @gmap: the gmap of the guest
> - * @gaddr: the guest address to destroy
> - *
> - * An attempt will be made to destroy the given guest page. If the attempt
> - * fails, an attempt is made to export the page. If both attempts fail, an
> - * appropriate error is returned.
> - */
> -int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr)
> -{
> -	struct vm_area_struct *vma;
> -	struct folio_walk fw;
> -	unsigned long uaddr;
> -	struct folio *folio;
> -	int rc;
> -
> -	rc = -EFAULT;
> -	mmap_read_lock(gmap->mm);
> -
> -	uaddr = __gmap_translate(gmap, gaddr);
> -	if (IS_ERR_VALUE(uaddr))
> -		goto out;
> -	vma = vma_lookup(gmap->mm, uaddr);
> -	if (!vma)
> -		goto out;
> -	/*
> -	 * Huge pages should not be able to become secure
> -	 */
> -	if (is_vm_hugetlb_page(vma))
> -		goto out;
> -
> -	rc = 0;
> -	folio = folio_walk_start(&fw, vma, uaddr, 0);
> -	if (!folio)
> -		goto out;
> -	/*
> -	 * See gmap_make_secure(): large folios cannot be secure. Small
> -	 * folio implies FW_LEVEL_PTE.
> -	 */
> -	if (folio_test_large(folio) || !pte_write(fw.pte))
> -		goto out_walk_end;
> -	rc = uv_destroy_folio(folio);
> -	/*
> -	 * Fault handlers can race; it is possible that two CPUs will fault
> -	 * on the same secure page. One CPU can destroy the page, reboot,
> -	 * re-enter secure mode and import it, while the second CPU was
> -	 * stuck at the beginning of the handler. At some point the second
> -	 * CPU will be able to progress, and it will not be able to destroy
> -	 * the page. In that case we do not want to terminate the process,
> -	 * we instead try to export the page.
> -	 */
> -	if (rc)
> -		rc = uv_convert_from_secure_folio(folio);
> -out_walk_end:
> -	folio_walk_end(&fw, vma);
> -out:
> -	mmap_read_unlock(gmap->mm);
> -	return rc;
> +	lru_add_drain_all();
> +	return -EAGAIN;
>   }
> -EXPORT_SYMBOL_GPL(gmap_destroy_page);
> +EXPORT_SYMBOL_GPL(uv_wiggle_folio);
>   
>   /*
>    * To be called with the folio locked or with an extra reference! This will
> diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
> index 02217fb4ae10..d972dea657fd 100644
> --- a/arch/s390/kvm/Makefile
> +++ b/arch/s390/kvm/Makefile
> @@ -8,7 +8,7 @@ include $(srctree)/virt/kvm/Makefile.kvm
>   ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
>   
>   kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
> -kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o
> +kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o gmap.o
>   
>   kvm-$(CONFIG_VFIO_PCI_ZDEV_KVM) += pci.o
>   obj-$(CONFIG_KVM) += kvm.o
> diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
> new file mode 100644
> index 000000000000..a142bbbddc25
> --- /dev/null
> +++ b/arch/s390/kvm/gmap.c
> @@ -0,0 +1,183 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Guest memory management for KVM/s390
> + *
> + * Copyright IBM Corp. 2008, 2020, 2024
> + *
> + *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
> + *               Martin Schwidefsky <schwidefsky@de.ibm.com>
> + *               David Hildenbrand <david@redhat.com>
> + *               Janosch Frank <frankja@linux.vnet.ibm.com>
> + */
> +
> +#include <linux/compiler.h>
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +#include <linux/pgtable.h>
> +#include <linux/pagemap.h>
> +
> +#include <asm/lowcore.h>
> +#include <asm/gmap.h>
> +#include <asm/uv.h>
> +
> +#include "gmap.h"
> +
> +/**
> + * should_export_before_import - Determine whether an export is needed
> + * before an import-like operation
> + * @uvcb: the Ultravisor control block of the UVC to be performed
> + * @mm: the mm of the process
> + *
> + * Returns whether an export is needed before every import-like operation.
> + * This is needed for shared pages, which don't trigger a secure storage
> + * exception when accessed from a different guest.
> + *
> + * Although considered as one, the Unpin Page UVC is not an actual import,
> + * so it is not affected.
> + *
> + * No export is needed also when there is only one protected VM, because the
> + * page cannot belong to the wrong VM in that case (there is no "other VM"
> + * it can belong to).
> + *
> + * Return: true if an export is needed before every import, otherwise false.
> + */
> +static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
> +{
> +	/*
> +	 * The misc feature indicates, among other things, that importing a
> +	 * shared page from a different protected VM will automatically also
> +	 * transfer its ownership.
> +	 */
> +	if (uv_has_feature(BIT_UV_FEAT_MISC))
> +		return false;
> +	if (uvcb->cmd == UVC_CMD_UNPIN_PAGE_SHARED)
> +		return false;
> +	return atomic_read(&mm->context.protected_count) > 1;
> +}
> +
> +static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
> +{
> +	struct folio *folio = page_folio(page);
> +	int rc;
> +
> +	/*
> +	 * Secure pages cannot be huge and userspace should not combine both.
> +	 * In case userspace does it anyway this will result in an -EFAULT for
> +	 * the unpack. The guest is thus never reaching secure mode. If
> +	 * userspace is playing dirty tricky with mapping huge pages later

s/tricky/tricks/

But the whole last sentence is a bit iffy.

> +	 * on this will result in a segmentation fault or in a -EFAULT return
> +	 * code from the KVM_RUN ioctl.
> +	 */
> +	if (folio_test_hugetlb(folio))
> +		return -EFAULT;
> +	if (folio_test_large(folio)) {
> +		mmap_read_unlock(gmap->mm);
> +		rc = uv_wiggle_folio(folio, true);
> +		mmap_read_lock(gmap->mm);

You could move the unlock to uv_wiggle_folio() and add a 
mmap_assert_locked() in front.

At least if you have no other users in upcoming series which don't need 
the unlock.

