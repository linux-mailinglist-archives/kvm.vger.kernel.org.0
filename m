Return-Path: <kvm+bounces-35782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 254C5A150E7
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 14:49:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A66816966E
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 13:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86B211FF7C0;
	Fri, 17 Jan 2025 13:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="G5KOc5Lc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA3D1DDC2D;
	Fri, 17 Jan 2025 13:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737121757; cv=none; b=SEGtB5yI3Oz13/Q6mMH1R3Vo6DCXdu9iqvyxlYBDA+dDb1quEttneTGRSmA3/vrVmO+pE2SiuTd94OlSXZ7Hp2X6AsmLWvpfqm2j9h0nO+e25berTWqMGBrowya/VzDWREGhyVIwye2K8wTZV9Z32oAz5cBSOgUx7kacPYvZJRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737121757; c=relaxed/simple;
	bh=8lJ6XarxMwmdjumn2iqNGAjTsUvJNdcqYRaVJmcGEwM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r4lAr+fSs2k/BPTw1c0kePd05A1AuzZYp3hhxU6Uds3/U3w4z9uHL1y1eoaKnjAwiFeGYdmZXR8YJ8q1JHAB4fhW4BgPN1iUQ2pLoGadX909lqOmticOMsfmB2xksWcBaIQsnqKI5FAhJ6Bhf+Q7vchbpQcMpk8v2ZpHSbDD4io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=G5KOc5Lc; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HBUu6Y020917;
	Fri, 17 Jan 2025 13:49:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=2cnJyw
	xK1HfGrPFRKec+PeYMjzwNKft27M9C8xdhSF4=; b=G5KOc5LcgFCyl+dy7EP19w
	rwJH6XlVDbDGqzv1Vv45rJxsJWK5km3BWPFeF/1k60bRDoyNetXUn5S+b07vZ8U/
	9ivl3STIOZr6x0n7lkbX4e03DvlUbRkiKFu5UfYZP1etcOF9pv095GLzh3VWCZUo
	/bARartVTFEN4Fn3OIUHbTd5PYUS4IO00eVqKzISuxA5KYrigMsld40F0Mli8DtA
	zgtNUSSvXu3TkrGgUOr9qVA8gCn8VCrHo9/4+KgkUtgNHzy54WPWGif+HsgX0SUf
	yq9m5m0xTGtZELX1rLx1FJTgp7ox1RnAlxHF45OWSuBGEvKBClzkCcJiWCSBW3QA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447bxb35sr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 13:49:07 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50HDleIP007021;
	Fri, 17 Jan 2025 13:49:07 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447bxb35sk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 13:49:07 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HBVQl8001330;
	Fri, 17 Jan 2025 13:49:06 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44456kavh8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 13:49:06 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HDn2Ju12124624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 13:49:03 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E03DD20043;
	Fri, 17 Jan 2025 13:49:02 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A8E9C20040;
	Fri, 17 Jan 2025 13:49:02 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jan 2025 13:49:02 +0000 (GMT)
Date: Fri, 17 Jan 2025 14:49:01 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: Re: [PATCH v2 03/15] KVM: s390: move pv gmap functions into kvm
Message-ID: <20250117144901.1f9ccde9@p-imbrenda>
In-Reply-To: <3f0a1778-0617-4c8d-bc8f-40eae47570fb@linux.ibm.com>
References: <20250116113355.32184-1-imbrenda@linux.ibm.com>
	<20250116113355.32184-4-imbrenda@linux.ibm.com>
	<3f0a1778-0617-4c8d-bc8f-40eae47570fb@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: CPF60f_Vg1afwqYcirDco9NRLsB78Tj7
X-Proofpoint-GUID: tCzujR-R1-6iKJ_48EKdLTmp_5nz2zs-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501170109

On Fri, 17 Jan 2025 14:38:08 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 1/16/25 12:33 PM, Claudio Imbrenda wrote:
> > Move gmap related functions from kernel/uv into kvm.
> > 
> > Create a new file to collect gmap-related functions.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---  
> 
> Thanks git, this is close to unreadable
> 
> >   /**
> > - * should_export_before_import - Determine whether an export is needed
> > - * before an import-like operation
> > - * @uvcb: the Ultravisor control block of the UVC to be performed
> > - * @mm: the mm of the process
> > - *
> > - * Returns whether an export is needed before every import-like operation.
> > - * This is needed for shared pages, which don't trigger a secure storage
> > - * exception when accessed from a different guest.
> > - *
> > - * Although considered as one, the Unpin Page UVC is not an actual import,
> > - * so it is not affected.
> > + * uv_wiggle_folio() - try to drain extra references to a folio
> > + * @folio: the folio
> > + * @split: whether to split a large folio
> >    *
> > - * No export is needed also when there is only one protected VM, because the
> > - * page cannot belong to the wrong VM in that case (there is no "other VM"
> > - * it can belong to).
> > - *
> > - * Return: true if an export is needed before every import, otherwise false.
> > + * Context: Must be called while holding an extra reference to the folio;
> > + *          the mm lock should not be held.
> >    */
> > -static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
> > +int uv_wiggle_folio(struct folio *folio, bool split)  
> 
> Should I expect a drop of references to also split THPs?

no, that's why we have the @split parameter

> Seems a bit odd to me but I do not know a lot about folios.
> 
> >   {
> > -	/*
> > -	 * The misc feature indicates, among other things, that importing a
> > -	 * shared page from a different protected VM will automatically also
> > -	 * transfer its ownership.
> > -	 */
> > -	if (uv_has_feature(BIT_UV_FEAT_MISC))
> > -		return false;
> > -	if (uvcb->cmd == UVC_CMD_UNPIN_PAGE_SHARED)
> > -		return false;
> > -	return atomic_read(&mm->context.protected_count) > 1;
> > -}
> > -  
> 
> [...]
> 
> > -/*
> > - * Requests the Ultravisor to make a page accessible to a guest.
> > - * If it's brought in the first time, it will be cleared. If
> > - * it has been exported before, it will be decrypted and integrity
> > - * checked.
> > - */
> > -int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
> > -{
> > -	struct vm_area_struct *vma;
> > -	bool drain_lru_called = false;
> > -	spinlock_t *ptelock;
> > -	unsigned long uaddr;
> > -	struct folio *folio;
> > -	pte_t *ptep;
> >   	int rc;
> >   
> > -again:
> > -	rc = -EFAULT;
> > -	mmap_read_lock(gmap->mm);
> > -
> > -	uaddr = __gmap_translate(gmap, gaddr);
> > -	if (IS_ERR_VALUE(uaddr))
> > -		goto out;
> > -	vma = vma_lookup(gmap->mm, uaddr);
> > -	if (!vma)
> > -		goto out;
> > -	/*
> > -	 * Secure pages cannot be huge and userspace should not combine both.
> > -	 * In case userspace does it anyway this will result in an -EFAULT for
> > -	 * the unpack. The guest is thus never reaching secure mode. If
> > -	 * userspace is playing dirty tricky with mapping huge pages later
> > -	 * on this will result in a segmentation fault.
> > -	 */
> > -	if (is_vm_hugetlb_page(vma))
> > -		goto out;
> > -
> > -	rc = -ENXIO;
> > -	ptep = get_locked_pte(gmap->mm, uaddr, &ptelock);
> > -	if (!ptep)
> > -		goto out;
> > -	if (pte_present(*ptep) && !(pte_val(*ptep) & _PAGE_INVALID) && pte_write(*ptep)) {
> > -		folio = page_folio(pte_page(*ptep));
> > -		rc = -EAGAIN;
> > -		if (folio_test_large(folio)) {
> > -			rc = -E2BIG;
> > -		} else if (folio_trylock(folio)) {
> > -			if (should_export_before_import(uvcb, gmap->mm))
> > -				uv_convert_from_secure(PFN_PHYS(folio_pfn(folio)));
> > -			rc = make_folio_secure(folio, uvcb);
> > -			folio_unlock(folio);
> > -		}
> > -
> > -		/*
> > -		 * Once we drop the PTL, the folio may get unmapped and
> > -		 * freed immediately. We need a temporary reference.
> > -		 */
> > -		if (rc == -EAGAIN || rc == -E2BIG)
> > -			folio_get(folio);
> > -	}
> > -	pte_unmap_unlock(ptep, ptelock);
> > -out:
> > -	mmap_read_unlock(gmap->mm);
> > -
> > -	switch (rc) {
> > -	case -E2BIG:
> > +	folio_wait_writeback(folio);  
> 
> Add an assert_not_held for the mm mutex above 
> "folio_wait_writeback(folio);"?

will do

[...]

> > +static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
> > +{
> > +	struct folio *folio = page_folio(page);
> > +	int rc;
> > +
> > +	/*
> > +	 * Secure pages cannot be huge and userspace should not combine both.
> > +	 * In case userspace does it anyway this will result in an -EFAULT for
> > +	 * the unpack. The guest is thus never reaching secure mode.
> > +	 * If userspace plays dirty tricks and decides to map huge pages at a
> > +	 * later point in time, it will receive a segmentation fault or
> > +	 * KVM_RUN will return -EFAULT.
> > +	 */
> > +	if (folio_test_hugetlb(folio))
> > +		return -EFAULT;
> > +	if (folio_test_large(folio)) {
> > +		mmap_read_unlock(gmap->mm);
> > +		rc = uv_wiggle_folio(folio, true);
> > +		mmap_read_lock(gmap->mm);
> > +		if (rc)
> > +			return rc;
> > +		folio = page_folio(page);
> > +	}
> > +
> > +	rc = -EAGAIN;
> > +	if (folio_trylock(folio)) {  
> 
> If you test for !folio_trylock() you could do an early return, no?

true

> 
> > +		if (should_export_before_import(uvcb, gmap->mm))
> > +			uv_convert_from_secure(folio_to_phys(folio));
> > +		rc = make_folio_secure(folio, uvcb);
> > +		folio_unlock(folio);
> > +	}
> > +
> > +	/*
> > +	 * Unlikely case: the page is not mapped anymore. Return success
> > +	 * and let the proper fault handler fault in the page again.
> > +	 */
> > +	if (rc == -ENXIO)
> > +		return 0;
> > +	/* The folio has too many references, try to shake some off */
> > +	if (rc == -EBUSY) {
> > +		mmap_read_unlock(gmap->mm);
> > +		uv_wiggle_folio(folio, false);
> > +		mmap_read_lock(gmap->mm);
> > +		return -EAGAIN;
> > +	}
> > +
> > +	return rc;
> > +}
> >  


