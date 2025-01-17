Return-Path: <kvm+bounces-35800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B9EA153B4
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:06:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E3AD188CD22
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:05:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBE70198822;
	Fri, 17 Jan 2025 16:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MBfbvVTz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5855D189F3F;
	Fri, 17 Jan 2025 16:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737129856; cv=none; b=M+3pLm1qZmURyMiI+ckH4y1jKli8w8TAKg3RmHr9JOLPd2azgy60hgmFCIBF1jBmp5nGQeRrDoRGl8e3qZj9WcAdfzrW6bkw6c10fdrDABGCk9t59Sh5RDIa09IbgjFi8M+D4CQ1i58LXfE/8s8/8bOISgpjKgsv72o0aj7dMqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737129856; c=relaxed/simple;
	bh=wiWaE+QH0fmjOoXJA0MDBRg5KlT+Ii7gfPeP/GrQjuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vDKNWHXVbBCXuWAFWv8QCke6h4Bfw1a16qnEDQOfttDQxjw4BZiIKK9JrNkZlh+vSfLMn74a5U66vxVGd6ktScFjjl1jCnD4uS11/r24VfFTaacM+8L1/uy6B6zhLSkENiswSA9WVZ6Ofnhv4GKUQe5rvkXFiickE23dR5KfNnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MBfbvVTz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HE6POM021321;
	Fri, 17 Jan 2025 16:04:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=9Xm8Jo
	pcy0bMQCotKnO8sGmsQkoBGaBLD5v3ZkcsGrM=; b=MBfbvVTzmtR4nZksivkQi8
	PR5HpGiauijggX9bKQRINilpgQTPfshpzSKHQCj4PauRhPutWNQN/8yr8p+WDPHe
	OtLDTryNBSq8xvTzv2/vxXgd9VV4SbL144su9/5z1gYsACW+o++yIrEyf5Q8VmCw
	LATB0RmYDh/OOm2IRMJfqAC31wJcxCZDBiPM7IvyBiMl+e6iTGsaQNuq/PJSPGFF
	rn2gcLkkWTwbQUtfF91XAXNvNI+dfgOu0kOmc2RFvITQc0QIvWcD9QTIYbu7p58h
	e/X9j+85N8q/UYul+z9tueE4KBMVrSHxOmZCdp2owAwueBWIihsgtHk7QkKNC9eA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447rp58j9b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 16:04:09 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50HG49ii018884;
	Fri, 17 Jan 2025 16:04:09 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447rp58j99-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 16:04:09 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HE7MZY004571;
	Fri, 17 Jan 2025 16:04:08 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4442yt3s5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 16:04:08 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HG442N62062966
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 16:04:04 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C0DEC20043;
	Fri, 17 Jan 2025 16:04:04 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E937F20040;
	Fri, 17 Jan 2025 16:04:03 +0000 (GMT)
Received: from [9.171.8.211] (unknown [9.171.8.211])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jan 2025 16:04:03 +0000 (GMT)
Message-ID: <d1d7f80d-aa41-462f-a796-5cc6f37ef361@linux.ibm.com>
Date: Fri, 17 Jan 2025 17:04:03 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/15] KVM: s390: move pv gmap functions into kvm
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
References: <20250116113355.32184-1-imbrenda@linux.ibm.com>
 <20250116113355.32184-4-imbrenda@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20250116113355.32184-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rBE7m_PGGzvjX2WCOf7FgSoVpPebs-fZ
X-Proofpoint-ORIG-GUID: ezqG8gMWoGy7H-UXKU5MZRCdd8GH-vjv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501170126

On 1/16/25 12:33 PM, Claudio Imbrenda wrote:
> Move gmap related functions from kernel/uv into kvm.
> 
> Create a new file to collect gmap-related functions.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/include/asm/uv.h |   7 +-
>   arch/s390/kernel/uv.c      | 293 ++++++-------------------------------
>   arch/s390/kvm/Makefile     |   2 +-
>   arch/s390/kvm/gmap.c       | 196 +++++++++++++++++++++++++
>   arch/s390/kvm/gmap.h       |  17 +++
>   arch/s390/kvm/intercept.c  |   1 +
>   arch/s390/kvm/kvm-s390.c   |   1 +
>   arch/s390/kvm/pv.c         |   1 +
>   8 files changed, 264 insertions(+), 254 deletions(-)
>   create mode 100644 arch/s390/kvm/gmap.c
>   create mode 100644 arch/s390/kvm/gmap.h

[...]

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

I'd expect busy for writeback and too many references since someone is 
referencing or working with the page.

But EBUSY for large mappings?
Also, the large mapping doesn't just vanish by waiting, does it?
You're actively splitting the mapping.

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

How about adding the split into the name?
uv_wiggle_split

> + * @folio: the folio
> + * @split: whether to split a large folio

[...]

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
> +	 * the unpack. The guest is thus never reaching secure mode.
> +	 * If userspace plays dirty tricks and decides to map huge pages at a
> +	 * later point in time, it will receive a segmentation fault or
> +	 * KVM_RUN will return -EFAULT.
> +	 */
> +	if (folio_test_hugetlb(folio))
> +		return -EFAULT;
> +	if (folio_test_large(folio)) {
> +		mmap_read_unlock(gmap->mm);
> +		rc = uv_wiggle_folio(folio, true);
> +		mmap_read_lock(gmap->mm);
> +		if (rc)
> +			return rc;
> +		folio = page_folio(page);
> +	}
> +
Maybe add something like:

/* 
  
  
  

  * We can race with someone making the folio large again until
  * we have locked the folio below.
  *
  * If we did, we will do the SIE entry/exit dance and end up
  * here again.
  */

> +	rc = -EAGAIN;
> +	if (folio_trylock(folio)) {
> +		if (should_export_before_import(uvcb, gmap->mm))
> +			uv_convert_from_secure(folio_to_phys(folio));
> +		rc = make_folio_secure(folio, uvcb);
> +		folio_unlock(folio);
> +	}
> +
> +	/*
> +	 * Unlikely case: the page is not mapped anymore. Return success
> +	 * and let the proper fault handler fault in the page again.
> +	 */
> +	if (rc == -ENXIO)
> +		return 0;
> +	/* The folio has too many references, try to shake some off */
> +	if (rc == -EBUSY) {
> +		mmap_read_unlock(gmap->mm);
> +		uv_wiggle_folio(folio, false);
> +		mmap_read_lock(gmap->mm);
> +		return -EAGAIN;
> +	}
> +
> +	return rc;
> +}

