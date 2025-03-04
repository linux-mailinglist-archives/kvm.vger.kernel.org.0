Return-Path: <kvm+bounces-40002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E35DA4D7E6
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:22:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8783518848BC
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:22:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8FB1FCCF5;
	Tue,  4 Mar 2025 09:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X0lw7Z0V"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A142B1F666B;
	Tue,  4 Mar 2025 09:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080117; cv=none; b=Qu0u80m1VW7GvOM1HgLSeaPHrFy/RevYD8g0ivVy5kw1DIntWwXUDTFG4i7QDI/n6hGRBhf/WhXARrQ932xQ7qnZPExlFoA/O4x+w8ajVrp8bjeEvGvipdKATtFkzgUkc+0NIXLF36aB4tMfHg0kHEJsl5YC9IzyOboM6K+o7Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080117; c=relaxed/simple;
	bh=/1wKwYgH19DpR7ZDJ3t00Y7uW5W0ujgdjwaOYeJddnU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S0bhdlgQuJOURkTy2/XQeXOspSztCRVoVSVUu5p/bEhvEuxYPXSbOFbJ54kf37e4nrU+7X0iXcXe8kvWhU9Np4kkmE2I6cZjBqpPZtCu7in7jfHh7GO4UqOEcu+FgMocHqa2c0fWzaVtaiJ8ngEZR0KQiIGB+GCC8rq6QAqsnY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X0lw7Z0V; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 523Ka1Oq022695;
	Tue, 4 Mar 2025 09:21:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=1Yq58o
	psB7IHhCTkH6W3tTgFClxwqWnFAP5FP/WEa0c=; b=X0lw7Z0VjVTksB3zFoSAto
	4S+VlWluS/uLTlHPf9xVpjfF5e7R3WMnbovHYXFMGave8kUPJ8hM2i45w7pEbpQT
	xft9NRj0pwrX4h8AHSKqLQEDwiEq5IlGz2/LSLlBEJoaBspX3mf3kPnomiX0QPnI
	5bQTSBcttLHzGEYFIDi7QUeRlANfIAMHvjHiXhuJKP0flxpEHC6FkGshSN5aw/zi
	yO1S3ZzwQPfPp8xsliDjXLXrn73upIf7m2lrB9P6tdxwEIw2/Sqr9cwy46JbWKKy
	RRr3JMfKxLuW5oUMWPa9jcoJKPL5Epuvh2pBmtBJw1PJ1fB005PgSSUCUZc+MqCA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 455dunwqfh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 09:21:41 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5245mPVu025026;
	Tue, 4 Mar 2025 09:21:40 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 454f91v6t0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 09:21:40 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5249LbXD54460758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Mar 2025 09:21:37 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E7B3D20040;
	Tue,  4 Mar 2025 09:21:36 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 360C020049;
	Tue,  4 Mar 2025 09:21:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.179.5.148])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue,  4 Mar 2025 09:21:36 +0000 (GMT)
Date: Tue, 4 Mar 2025 10:21:34 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        nsg@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com
Subject: Re: [PATCH v3 1/1] KVM: s390: pv: fix race when making a page
 secure
Message-ID: <20250304102134.1bd9fb03@p-imbrenda>
In-Reply-To: <370231a1-af36-46ca-a87c-ce1929473c1d@redhat.com>
References: <20250227130954.440821-1-imbrenda@linux.ibm.com>
	<20250227130954.440821-2-imbrenda@linux.ibm.com>
	<370231a1-af36-46ca-a87c-ce1929473c1d@redhat.com>
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
X-Proofpoint-ORIG-GUID: XalftXI9k2WUBCiF3t9fhOPR3smvupSv
X-Proofpoint-GUID: XalftXI9k2WUBCiF3t9fhOPR3smvupSv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_04,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxlogscore=915 phishscore=0 clxscore=1015 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2503040075

On Fri, 28 Feb 2025 22:15:04 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 27.02.25 14:09, Claudio Imbrenda wrote:
> > Holding the pte lock for the page that is being converted to secure is
> > needed to avoid races. A previous commit removed the locking, which
> > caused issues. Fix by locking the pte again.
> > 
> > Fixes: 5cbe24350b7d ("KVM: s390: move pv gmap functions into kvm")
> > Reported-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>  
> 
> Tested with shmem / memory-backend-memfd that ends up using large folios 
> / THPs.
> 
> Tested-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> 
> Two comments below.

I will need to send a v4, unfortunately there are other issues with this
patch (as you have probably noticed by now as well)

> 
> [...]
> 
> > +
> > +int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb)
> > +{
> > +	struct folio *folio;
> > +	spinlock_t *ptelock;
> > +	pte_t *ptep;
> > +	int rc;
> > +
> > +	ptep = get_locked_valid_pte(mm, hva, &ptelock);
> > +	if (!ptep)
> > +		return -ENXIO;
> > +
> > +	folio = page_folio(pte_page(*ptep));
> > +	folio_get(folio);  
> 
> Grabbing a folio reference is only required if you want to keep using 
> the folio after the pte_unmap_unlock. While the PTL is locked it cannot 
> vanish.
> 
> So consider grabbing a reference only before dropping the PTL and you 
> inted to call kvm_s390_wiggle_split_folio(). Then, you would effectively 
> not require these two atomics on the expected hot path.
> 
> (I recall that the old code did that)

This code will go away hopefully in the next merge window anyway
(unless I get sick *again*)

> 
> > +	/*
> > +	 * Secure pages cannot be huge and userspace should not combine both.
> > +	 * In case userspace does it anyway this will result in an -EFAULT for
> > +	 * the unpack. The guest is thus never reaching secure mode.
> > +	 * If userspace plays dirty tricks and decides to map huge pages at a
> > +	 * later point in time, it will receive a segmentation fault or
> > +	 * KVM_RUN will return -EFAULT.
> > +	 */
> > +	if (folio_test_hugetlb(folio))
> > +		rc =  -EFAULT;
> > +	else if (folio_test_large(folio))
> > +		rc = -E2BIG;
> > +	else if (!pte_write(*ptep))
> > +		rc = -ENXIO;
> > +	else
> > +		rc = make_folio_secure(mm, folio, uvcb);
> > +	pte_unmap_unlock(ptep, ptelock);
> > +
> > +	if (rc == -E2BIG || rc == -EBUSY)
> > +		rc = kvm_s390_wiggle_split_folio(mm, folio, rc == -E2BIG);
> > +	folio_put(folio);
> > +
> > +	return rc;
> > +}
> > +EXPORT_SYMBOL_GPL(make_hva_secure);
> >   
> >   /*
> >    * To be called with the folio locked or with an extra reference! This will
> > diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
> > index 02adf151d4de..c08950b4301c 100644  
> 
> 
> There is one remaining reference to __gmap_make_secure, which you remove:
> 
> $ git grep __gmap_make_secure
> arch/s390/kvm/gmap.c: * Return: 0 on success, < 0 in case of error (see 
> __gmap_make_secure()).

will fix

> 
> 
> 


