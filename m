Return-Path: <kvm+bounces-38147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBFE4A35BAB
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 11:42:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C36A7A3497
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 10:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5488F25A353;
	Fri, 14 Feb 2025 10:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="G1KZee8F"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135AF204F6E;
	Fri, 14 Feb 2025 10:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739529711; cv=none; b=VMFF605Vn6Nd1K5gxQSHxz57B2z4DpmWrQpJCAswuKZSX4UJkFBxtioynIkqPAFVLADRbHBwbXMvtAiSxsjx3MDbw/srUglV+/1HCzzbD+13RMGEr9lXvm4xvCjy0/OFf+p29yKMggizhjDgaaL8lm8z4MpORnG/F4OcMrrZwX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739529711; c=relaxed/simple;
	bh=85N7bsMhl4ABWehkT4S0a3mAdrj5ySPXPAXUQjZL3og=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KZdnSqqUwyPzsvoXcdYM2NmQvtl6IdeWW0ujroP9moZYnKLEfdk/0AU0/kyr5auIxiAWne4uSNks8bT+fPnz1Gn4yW1zmjv87WzOpm4ZRTxVeTK3EGERyhu63tJFUcLqgMp9QCcPFIz2S4y6GdUJ4q/09nHAZb0pzkQNouh2iV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=G1KZee8F; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51E17weD002612;
	Fri, 14 Feb 2025 10:41:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=qMfIsw
	6tkeGlBgLuUwVlP4AoSBWWmKomoDbzoQXfXto=; b=G1KZee8FSYe1JZyTOFntYy
	i57nXq1/g7Jsm8GZ63Sqj9iOZ6mYuSNpuuCUjBdOD21HU1ZOecZcaZobWJDmDoxK
	fI+OgLse7b7QNlYoGGbZpQglcj5OwIbBjIax3K7gnETui47GH1C0aEsvJzmgiQ3o
	zUW+ZPyE996wOCPw8ra9OhDA1a3L5puuPyOtD3VTHPQCmH3G8LyQyrSKA237Uit8
	XVt1+63sdpixK3tmj94whl4hy3rpOpT/Ils47moGmnV/wUtdGwurpy4HhEdXM7aU
	lRnfsZjHfH9ExveerW7GDglohxj0rJL3N5CNyvmG5nmeJ2h1dyiSlWknxVexREgw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44suwa273f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Feb 2025 10:41:46 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51E7Dwlw016679;
	Fri, 14 Feb 2025 10:41:45 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44pk3kk32s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Feb 2025 10:41:45 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51EAfffB51839348
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Feb 2025 10:41:41 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B3BAB2004B;
	Fri, 14 Feb 2025 10:41:41 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1DDB320043;
	Fri, 14 Feb 2025 10:41:41 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.26.252])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 14 Feb 2025 10:41:41 +0000 (GMT)
Date: Fri, 14 Feb 2025 11:41:39 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        nsg@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com
Subject: Re: [PATCH v1 2/2] KVM: s390: pv: fix race when making a page
 secure
Message-ID: <20250214114139.2121f9ea@p-imbrenda>
In-Reply-To: <ad8ae139-546d-4ade-abb9-455b339a8a92@redhat.com>
References: <20250213200755.196832-1-imbrenda@linux.ibm.com>
	<20250213200755.196832-3-imbrenda@linux.ibm.com>
	<6c741da9-a793-4a59-920f-8df77807bc4d@redhat.com>
	<20250214111729.000d364e@p-imbrenda>
	<ad8ae139-546d-4ade-abb9-455b339a8a92@redhat.com>
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
X-Proofpoint-GUID: bSnEv-C0I7bxFynfMFhzaerljaBY1BpN
X-Proofpoint-ORIG-GUID: bSnEv-C0I7bxFynfMFhzaerljaBY1BpN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-14_04,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 malwarescore=0 clxscore=1015 phishscore=0 lowpriorityscore=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2502140076

On Fri, 14 Feb 2025 11:27:15 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 14.02.25 11:17, Claudio Imbrenda wrote:
> > On Thu, 13 Feb 2025 21:16:03 +0100
> > David Hildenbrand <david@redhat.com> wrote:
> >   
> >> On 13.02.25 21:07, Claudio Imbrenda wrote:  
> >>> Holding the pte lock for the page that is being converted to secure is
> >>> needed to avoid races. A previous commit removed the locking, which
> >>> caused issues. Fix by locking the pte again.
> >>>
> >>> Fixes: 5cbe24350b7d ("KVM: s390: move pv gmap functions into kvm")  
> >>
> >> If you found this because of my report about the changed locking,
> >> consider adding a Suggested-by / Reported-y.  
> > 
> > yes, sorry; I sent the patch in haste and forgot. Which one would you
> > prefer (or both?)
> >   
> 
> Maybe Reported-by.
> 
> > [...]
> >   
> >>> @@ -127,8 +128,11 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
> >>>    
> >>>    	page = gfn_to_page(kvm, gpa_to_gfn(gaddr));
> >>>    	mmap_read_lock(gmap->mm);
> >>> -	if (page)
> >>> -		rc = __gmap_make_secure(gmap, page, uvcb);
> >>> +	vmaddr = gfn_to_hva(gmap->private, gpa_to_gfn(gaddr));
> >>> +	if (kvm_is_error_hva(vmaddr))
> >>> +		rc = -ENXIO;
> >>> +	if (!rc && page)
> >>> +		rc = __gmap_make_secure(gmap, page, vmaddr, uvcb);
> >>>    	kvm_release_page_clean(page);
> >>>    	mmap_read_unlock(gmap->mm);
> >>>        
> >>
> >> You effectively make the code more complicated and inefficient than
> >> before. Now you effectively walk the page table twice in the common
> >> small-folio case ...  
> > 
> > I think in every case, but see below
> >   
> >>
> >> Can we just go back to the old handling that we had before here?
> >>  
> > 
> > I'd rather not, this is needed to prepare for the next series (for
> > 6.15) in a couple of weeks, where gmap gets completely removed from
> > s390/mm, and gmap dat tables will not share ptes with userspace anymore
> > (i.e. we will use mmu_notifiers, like all other archs)  
> 
> I think for the conversion we would still:
> 
> GFN -> HVA
> 
> Walk to the folio mapped at HVA, lock the PTE and perform the conversion.
> 
> So even with memory notifiers, that should be fine, no?

yes

> 
> So not necessarily "the old handling that we had before" but rather "the 
> old way of looking up what's mapped and performing the conversion under 
> the PTL".

ahhh, yes

> 
> For me to fix the refcount freezing properly on top of your work, we'll 
> need the PTL (esp. to exclude concurrent GUP-slow) etc.

let's discuss this off-list


