Return-Path: <kvm+bounces-14684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A37308A59DA
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 20:24:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59362281BFF
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 18:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA9D013AA3A;
	Mon, 15 Apr 2024 18:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NsSJgFjj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCA78248E;
	Mon, 15 Apr 2024 18:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713205480; cv=none; b=CGfnzDQFN3JW4zoFCmviKV5tqa/p5AVULnXYfnU/vrTfYQTfCekUR4WFQIWO4IgDTzrNLtoN16dVDzV0ykCAcxbZrETRJX+60yzNrmfSnUCSOhQ6FUx7WcYFuosradi3hUEQjeokQ8NLWAPiaYYn4lSWCwT5a1u5hEFJG2YPsWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713205480; c=relaxed/simple;
	bh=28tCFNWfOa62kT/fHhiqLn5DGFNs03W5X6G9MpqutxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sSoaqLkk5iLAOifqEX2wQVdShl9Q48HsPLzPMGzNGRF1+qe+sYFf/5bVaXRWL9qX2vZheFvE4UnY7uEqvZ9J+I0EGApyACiY1N30/bB3R8ba8aL0f1F95bYD73PTz7MOhCR+JLIjmuRZf+8KgXWgVM+vimssJAHqxetyjACudZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NsSJgFjj; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43FHUC6Z018202;
	Mon, 15 Apr 2024 18:24:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=Pk5kgDBBdJctcWhbsFxfoDWJNZ5HUnRBxsr6FJgfWQk=;
 b=NsSJgFjj/nlfnSfiXcJP7G3M5TNmo/FZh5YGRbzTRPfnrMDGps/2+JjebWW1CkQQJr89
 YIvqR6hvRA0B3VUcJnfnIEOtLbaBGR4HllfMqe1JdkXLYVuSxh30qbdttzwSTxD9fN+P
 Ff0pkBckEwG3VGZkNrfR9h3FlgyrEXnG8CC/T9yqjP2RVbXL+0jHLMXT56p2d7toAuRv
 /Besgzq9MMkwbUp1i9axNJy07/btxtbCQCPntVqGiQwatFtXLxaM07z3Su5K2RClPIaZ
 XYp/aUh+I+W4tVZ9MKzc20ayNaWIcK/EFMvnQVQEzlebFlufYvQ4+THZ7o21p6QutCnX QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xh8c88502-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Apr 2024 18:24:30 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43FIOUsx003261;
	Mon, 15 Apr 2024 18:24:30 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xh8c88500-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Apr 2024 18:24:30 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43FHAtsJ021350;
	Mon, 15 Apr 2024 18:24:29 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xg6kk943u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Apr 2024 18:24:29 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43FIOO8h51773846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Apr 2024 18:24:26 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E1E42004D;
	Mon, 15 Apr 2024 18:24:24 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 027CD20040;
	Mon, 15 Apr 2024 18:24:23 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.171.55.218])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 15 Apr 2024 18:24:22 +0000 (GMT)
Date: Mon, 15 Apr 2024 20:24:21 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Sven Schnelle <svens@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 2/2] s390/mm: re-enable the shared zeropage for !PV
 and !skeys KVM guests
Message-ID: <Zh1w1QTNSy+rrCH7@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240411161441.910170-1-david@redhat.com>
 <20240411161441.910170-3-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411161441.910170-3-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6GtmAc9B6K8dT-flaQntzbzZokvwdNLl
X-Proofpoint-GUID: TdFM_63pvcjBbl31JkZc0XttxYHE-oxj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-15_15,2024-04-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 mlxlogscore=691 impostorscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404150121

On Thu, Apr 11, 2024 at 06:14:41PM +0200, David Hildenbrand wrote:

David, could you please clarify the below questions?

> +static int __s390_unshare_zeropages(struct mm_struct *mm)
> +{
> +	struct vm_area_struct *vma;
> +	VMA_ITERATOR(vmi, mm, 0);
> +	unsigned long addr;
> +	int rc;
> +
> +	for_each_vma(vmi, vma) {
> +		/*
> +		 * We could only look at COW mappings, but it's more future
> +		 * proof to catch unexpected zeropages in other mappings and
> +		 * fail.
> +		 */
> +		if ((vma->vm_flags & VM_PFNMAP) || is_vm_hugetlb_page(vma))
> +			continue;
> +		addr = vma->vm_start;
> +
> +retry:
> +		rc = walk_page_range_vma(vma, addr, vma->vm_end,
> +					 &find_zeropage_ops, &addr);
> +		if (rc <= 0)
> +			continue;

So in case an error is returned for the last vma, __s390_unshare_zeropage()
finishes with that error. By contrast, the error for a non-last vma would
be ignored?

> +
> +		/* addr was updated by find_zeropage_pte_entry() */
> +		rc = handle_mm_fault(vma, addr,
> +				     FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
> +				     NULL);
> +		if (rc & VM_FAULT_OOM)
> +			return -ENOMEM;

Heiko pointed out that rc type is inconsistent vs vm_fault_t returned by
handle_mm_fault(). While fixing it up, I've got concerned whether is it
fine to continue in case any other error is met (including possible future
VM_FAULT_xxxx)?

> +		/*
> +		 * See break_ksm(): even after handle_mm_fault() returned 0, we
> +		 * must start the lookup from the current address, because
> +		 * handle_mm_fault() may back out if there's any difficulty.
> +		 *
> +		 * VM_FAULT_SIGBUS and VM_FAULT_SIGSEGV are unexpected but
> +		 * maybe they could trigger in the future on concurrent
> +		 * truncation. In that case, the shared zeropage would be gone
> +		 * and we can simply retry and make progress.
> +		 */
> +		cond_resched();
> +		goto retry;
> +	}
> +
> +	return rc;
> +}

Thanks!

