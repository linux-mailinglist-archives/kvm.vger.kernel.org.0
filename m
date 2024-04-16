Return-Path: <kvm+bounces-14727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 990DC8A6420
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 08:39:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F22FBB22A52
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 06:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 079C86EB6F;
	Tue, 16 Apr 2024 06:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="C52ykLAI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD716E2BE;
	Tue, 16 Apr 2024 06:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713249467; cv=none; b=rJT58qiJK+W5ebceFAzrkye7zuLWl2TsItV7B+GBehVve8b/DWo8wzq5kVuHvjjDvlpGX8crYtwjn7PSe2NQdp5KO4fr9/v+2htifTgag6LZSHGk/dNbEfV0boplVoyHfVaxuj0kNnNEFQ1JkJIwxrK+2by7zbn93wSlfA5yF+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713249467; c=relaxed/simple;
	bh=s+gbjt6MpgxLQHQApyrgOzXlfWR857SWR8AJZfMyGMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fIE6quxnXXRNFFcjJ/KGlYLSvToQ82vWFHokX5RfwIkEWf2qMzXLrPeRiUb1ZVieR7Ez03/ZK2szcPqSHDtzOpozLUtHQSzxFFX9vwlIz1IKrJpBZ2RqCyX33xoOGpauRGFbquAjv7iEky4kC9YMKb68NSaWe4tOFgtiJkS9MKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=C52ykLAI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43G5fOSv004182;
	Tue, 16 Apr 2024 06:37:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=DW16ByiGfzFf/HY70BHZqJnP86YV7zinx9U7rOft9MA=;
 b=C52ykLAIL5hb9D87Z0TQLaf/5sslvrWqpVCXBCTQbhn9BD1krcLVW34ItjEuOov28X5y
 YP2tSP1nI+MdLgYjocz5VK+noEtMXpb8K0iTS7F8BRUMfrEYygx8u0I6Z8Hvxip6yX9a
 Y4wNo79g+F6N6Se53JH/1+maVulxeiXDo5p4JMbXz6z+Wt3vti3psg9J+O5aR3WEOqd6
 aLLZVZYJ+JAlB7oBBILaNpDJet5wQYLy5LJ0IiefzhoGmDCK7mi7AkOPJLMD9tFpNu7g
 7phT32WfGXgBLV6CNqKXDkoIJ/adHBrxptsqH0Yc5xzBpFloX0Xbl+bHnFmQANgqLCNu fw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xhk9pr37j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Apr 2024 06:37:38 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43G6TY0u011654;
	Tue, 16 Apr 2024 06:37:38 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xhk9pr37e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Apr 2024 06:37:37 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43G3nxam011111;
	Tue, 16 Apr 2024 06:37:37 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xg732c2p5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Apr 2024 06:37:37 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43G6bV4948628208
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 06:37:34 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D703620067;
	Tue, 16 Apr 2024 06:37:31 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD6E62004B;
	Tue, 16 Apr 2024 06:37:30 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.171.55.218])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 16 Apr 2024 06:37:30 +0000 (GMT)
Date: Tue, 16 Apr 2024 08:37:29 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
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
Message-ID: <Zh4cqZkuPR9V1t1o@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240411161441.910170-1-david@redhat.com>
 <20240411161441.910170-3-david@redhat.com>
 <Zh1w1QTNSy+rrCH7@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <8533cb18-42ff-42bc-b9e5-b0537aa51b21@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8533cb18-42ff-42bc-b9e5-b0537aa51b21@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VQ3fX6EJCnt1qACDHjS0ldPm_TLFiIBK
X-Proofpoint-ORIG-GUID: BHnBQ49bCE71R5CAArUmGZYPuxCu31hV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-16_03,2024-04-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=781 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404160038

On Mon, Apr 15, 2024 at 09:14:03PM +0200, David Hildenbrand wrote:
> > > +retry:
> > > +		rc = walk_page_range_vma(vma, addr, vma->vm_end,
> > > +					 &find_zeropage_ops, &addr);
> > > +		if (rc <= 0)
> > > +			continue;
> > 
> > So in case an error is returned for the last vma, __s390_unshare_zeropage()
> > finishes with that error. By contrast, the error for a non-last vma would
> > be ignored?
> 
> Right, it looks a bit off. walk_page_range_vma() shouldn't fail
> unless find_zeropage_pte_entry() would fail -- which would also be
> very unexpected.
> 
> To handle it cleanly in case we would ever get a weird zeropage where we
> don't expect it, we should probably just exit early.
> 
> Something like the following (not compiled, addressing the comment below):

> @@ -2618,7 +2618,8 @@ static int __s390_unshare_zeropages(struct mm_struct *mm)
>  	struct vm_area_struct *vma;
>  	VMA_ITERATOR(vmi, mm, 0);
>  	unsigned long addr;
> -	int rc;
> +	vm_fault_t rc;
> +	int zero_page;

I would use "fault" for mm faults (just like everywhere else handle_mm_fault() is
called) and leave rc as is:

	vm_fault_t fault;
	int rc;

>  	for_each_vma(vmi, vma) {
>  		/*
> @@ -2631,9 +2632,11 @@ static int __s390_unshare_zeropages(struct mm_struct *mm)
>  		addr = vma->vm_start;
>  retry:
> -		rc = walk_page_range_vma(vma, addr, vma->vm_end,
> -					 &find_zeropage_ops, &addr);
> -		if (rc <= 0)
> +		zero_page = walk_page_range_vma(vma, addr, vma->vm_end,
> +						&find_zeropage_ops, &addr);
> +		if (zero_page < 0)
> +			return zero_page;
> +		else if (!zero_page)
>  			continue;
>  		/* addr was updated by find_zeropage_pte_entry() */
> @@ -2656,7 +2659,7 @@ static int __s390_unshare_zeropages(struct mm_struct *mm)
>  		goto retry;
>  	}
> -	return rc;
> +	return 0;
>  }
>  static int __s390_disable_cow_sharing(struct mm_struct *mm)

...

> > > +		/* addr was updated by find_zeropage_pte_entry() */
> > > +		rc = handle_mm_fault(vma, addr,
> > > +				     FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
> > > +				     NULL);
> > > +		if (rc & VM_FAULT_OOM)
> > > +			return -ENOMEM;
> > 
> > Heiko pointed out that rc type is inconsistent vs vm_fault_t returned by
> 
> Right, let's use another variable for that.
> 
> > handle_mm_fault(). While fixing it up, I've got concerned whether is it
> > fine to continue in case any other error is met (including possible future
> > VM_FAULT_xxxx)?
> 
> Such future changes would similarly break break_ksm(). Staring at it, I do wonder
> if break_ksm() should be handling VM_FAULT_HWPOISON ... very likely we should
> handle it and fail -- we might get an MC while copying from the source page.
> 
> VM_FAULT_HWPOISON on the shared zeropage would imply a lot of trouble, so
> I'm not concerned about that for the case here, but handling it in the future
> would be cleaner.
> 
> Note that we always retry the lookup, so we won't just skip a zeropage on unexpected
> errors.
> 
> We could piggy-back on vm_fault_to_errno(). We could use
> vm_fault_to_errno(rc, FOLL_HWPOISON), and only continue (retry) if the rc is 0 or
> -EFAULT, otherwise fail with the returned error.
> 
> But I'd do that as a follow up, and also use it in break_ksm() in the same fashion.

@Christian, do you agree with this suggestion?

Thanks!

