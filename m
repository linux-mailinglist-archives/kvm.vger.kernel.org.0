Return-Path: <kvm+bounces-16887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DFE158BE957
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:41:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59AB01F27B95
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8002C17F373;
	Tue,  7 May 2024 16:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sKEO5UJJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0878C16DEB9;
	Tue,  7 May 2024 16:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715099710; cv=none; b=gTQceoJMeHsYJelmZRh1RJODKTlWoA5KePZP2KcJVCj+MKW2oSkHUD+bLMRZZrFkf/Lxc120aQz2CljNLm8Emtej0SoOKMd88q1ZoBKu1Wie91zC5HrdkPaDVnObqBkfWBnBvxafyN8Q4DDfXlH1GcBHI2Rp4Bo/toO8XZAfyAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715099710; c=relaxed/simple;
	bh=cxjvocoLOgBJsiBEum3IUb6ePAtVX/F8rInQlrpfh4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MmQyNRJIjPVBdMjvSleuUt3qcPn5bYybxoyFY/ETg3Hq+3VGZltCS8/sSei9sy6RSPgTV0w6b/ftmmjWpQAVG2sJx10j1ThtCzrlQNq9em0hyHNG+CvIBy6wfREYSvZhnKBmEj6zCIaefJuoZjzYOQgCYBcDC4UVVe9e3a0uAbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sKEO5UJJ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 447FtWw1016317;
	Tue, 7 May 2024 16:35:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=BZYNarLIhYKZZqXR0McvXxtswW95XKP1igzduv4REC8=;
 b=sKEO5UJJDlRuF1I4FCk90jaw9/QdgPyX4tbpRzjq0KR8M1JuDT4n897cYI6f5OOGJmwc
 0kiLd4NjVuehKzIQUerAyQSYjdfAyZDTQeYafP4kY7zpIsqycLBKqk89xCho7Yfd3kaw
 DWmdUNtsY0XBQIWoFGM6cPDimdzdrAvGCWA0rOkyGBmKNA9LBtZuJvOZ1DtVY1EAqIgZ
 2+hBDQANXz2LKPnKpJRQmxOPi0gQwWH8bVHdbYkr/MhagOihdoi40PVc6ReiPT/E++PG
 gciI2T9yfCK+YgDjU8sa+N/wQMKJvEmLcNcJQmQA1oE/Dpn4X7/eNTn+SKSZ2KHhw2JE /g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyqc503fs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:35:05 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 447GZ5bl013699;
	Tue, 7 May 2024 16:35:05 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyqc503fn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:35:05 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 447FSc1k010632;
	Tue, 7 May 2024 16:35:04 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xx0bp7ad9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:35:04 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 447GYwWl47841592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 May 2024 16:35:00 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6DE0820043;
	Tue,  7 May 2024 16:34:58 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 39B342004D;
	Tue,  7 May 2024 16:34:58 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 May 2024 16:34:58 +0000 (GMT)
Date: Tue, 7 May 2024 17:27:54 +0200
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
Subject: Re: [PATCH v2 02/10] s390/uv: gmap_make_secure() cleanups for
 further changes
Message-ID: <20240507172754.3f238ec7@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <20240412142120.220087-3-david@redhat.com>
References: <20240412142120.220087-1-david@redhat.com>
	<20240412142120.220087-3-david@redhat.com>
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
X-Proofpoint-GUID: oQ1HgBRMnVAuWl6kivk67gjAb8cuiymf
X-Proofpoint-ORIG-GUID: DFOT80QhjKwAScxsyrWVGbXVOzSAwTUH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_09,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxscore=0 clxscore=1015 phishscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070112

On Fri, 12 Apr 2024 16:21:12 +0200
David Hildenbrand <david@redhat.com> wrote:

> Let's factor out handling of LRU cache draining and convert the if-else
> chain to a switch-case.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

it is a little ugly with the bool* parameter, but I can't think of
a better/nicer way to do it

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kernel/uv.c | 66 ++++++++++++++++++++++++++-----------------
>  1 file changed, 40 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 016993e9eb72..25fe28d189df 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -266,6 +266,36 @@ static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_str
>  	return atomic_read(&mm->context.protected_count) > 1;
>  }
>  
> +/*
> + * Drain LRU caches: the local one on first invocation and the ones of all
> + * CPUs on successive invocations. Returns "true" on the first invocation.
> + */
> +static bool drain_lru(bool *drain_lru_called)
> +{
> +	/*
> +	 * If we have tried a local drain and the folio refcount
> +	 * still does not match our expected safe value, try with a
> +	 * system wide drain. This is needed if the pagevecs holding
> +	 * the page are on a different CPU.
> +	 */
> +	if (*drain_lru_called) {
> +		lru_add_drain_all();
> +		/* We give up here, don't retry immediately. */
> +		return false;
> +	}
> +	/*
> +	 * We are here if the folio refcount does not match the
> +	 * expected safe value. The main culprits are usually
> +	 * pagevecs. With lru_add_drain() we drain the pagevecs
> +	 * on the local CPU so that hopefully the refcount will
> +	 * reach the expected safe value.
> +	 */
> +	lru_add_drain();
> +	*drain_lru_called = true;
> +	/* The caller should try again immediately */
> +	return true;
> +}
> +
>  /*
>   * Requests the Ultravisor to make a page accessible to a guest.
>   * If it's brought in the first time, it will be cleared. If
> @@ -275,7 +305,7 @@ static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_str
>  int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
>  {
>  	struct vm_area_struct *vma;
> -	bool local_drain = false;
> +	bool drain_lru_called = false;
>  	spinlock_t *ptelock;
>  	unsigned long uaddr;
>  	struct folio *folio;
> @@ -331,37 +361,21 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
>  out:
>  	mmap_read_unlock(gmap->mm);
>  
> -	if (rc == -EAGAIN) {
> +	switch (rc) {
> +	case -EAGAIN:
>  		/*
>  		 * If we are here because the UVC returned busy or partial
>  		 * completion, this is just a useless check, but it is safe.
>  		 */
>  		folio_wait_writeback(folio);
>  		folio_put(folio);
> -	} else if (rc == -EBUSY) {
> -		/*
> -		 * If we have tried a local drain and the folio refcount
> -		 * still does not match our expected safe value, try with a
> -		 * system wide drain. This is needed if the pagevecs holding
> -		 * the page are on a different CPU.
> -		 */
> -		if (local_drain) {
> -			lru_add_drain_all();
> -			/* We give up here, and let the caller try again */
> -			return -EAGAIN;
> -		}
> -		/*
> -		 * We are here if the folio refcount does not match the
> -		 * expected safe value. The main culprits are usually
> -		 * pagevecs. With lru_add_drain() we drain the pagevecs
> -		 * on the local CPU so that hopefully the refcount will
> -		 * reach the expected safe value.
> -		 */
> -		lru_add_drain();
> -		local_drain = true;
> -		/* And now we try again immediately after draining */
> -		goto again;
> -	} else if (rc == -ENXIO) {
> +		return -EAGAIN;
> +	case -EBUSY:
> +		/* Additional folio references. */
> +		if (drain_lru(&drain_lru_called))
> +			goto again;
> +		return -EAGAIN;
> +	case -ENXIO:
>  		if (gmap_fault(gmap, gaddr, FAULT_FLAG_WRITE))
>  			return -EFAULT;
>  		return -EAGAIN;


