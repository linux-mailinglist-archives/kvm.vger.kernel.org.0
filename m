Return-Path: <kvm+bounces-38145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84FE4A35B53
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 11:17:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E125F3AD4F1
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 10:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23635257AC4;
	Fri, 14 Feb 2025 10:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YEyc5Gul"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB2E42AAF;
	Fri, 14 Feb 2025 10:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739528261; cv=none; b=EHFoy1I/UyW3Vhwz/ZfCKSRy0g5M9uD4uNwQsKxWDTpPDIHI0QFTXsQ/tFpZac66Ln7LHN1wT0Tyggb1h9poroPGwd5y6Olnmwrpp9v7yRixHtUBL14fJMsLBEpfBXghfzOlfO2IBcCH6umemtWItLqbPGaxFWeeH4n2rloM5ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739528261; c=relaxed/simple;
	bh=Pj/0Yiytkz85tSMc0lYxVbx3zpu3ubj0LICmpNb71FA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UmdykH8y95loAaR6FkfgS2098363Y+gqp1Z1KEB0U6EnS9dgz4juJhsocbA1NoJn3PfUg/CU1vk0Abi0r4ku2aTFpRlyCn6Y2m5DpIvmTCNZl3ZU3rsGDNQtevtKe4+0UkBkVv+0rSHUEE+5MIBF5i8pC6YrkOT/j0pNSz8y1Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YEyc5Gul; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51E5OYoi010386;
	Fri, 14 Feb 2025 10:17:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ofoYPQ
	i/GERP+8Jn8cOggrSSCPlwm7BULNMrkjDy0fc=; b=YEyc5GuliJCPmbH1LyEc+P
	bINBBcHg6H+Wrzn7Yglam87ecRYDFdmd9H8OYxeDdpVu6DA8zD0NujkxrEN4Wp+x
	SHw/nUJnNHHJcaQtz67FyVF6VFzq7jbeaiZGoFqRkZ+lleKokuZbCnpGJSnWjzbY
	liMHV32FHXkzFDSdISLa/K+uHu+KoiwxRTP0tCt6kUJoSgyNUC1+6ktWOU2EJTmi
	QecJgdBWUyISXl8paxRmus263fSVvVwtrIe4nQNTc2bsHPglHZxZfetFjk6CEguU
	09MYJT+jTCoZznsIfKe04DXQNieP5cwMNdU7j5m6yj9m0g7RCPtUHYTdjrnsu1Fw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44syn817fp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Feb 2025 10:17:35 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51E6sT4h021894;
	Fri, 14 Feb 2025 10:17:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44phkt36ve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Feb 2025 10:17:35 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51EAHVgr19792218
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Feb 2025 10:17:31 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 994DC20063;
	Fri, 14 Feb 2025 10:17:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EAB6E2005A;
	Fri, 14 Feb 2025 10:17:30 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.26.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 14 Feb 2025 10:17:30 +0000 (GMT)
Date: Fri, 14 Feb 2025 11:17:29 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        nsg@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com
Subject: Re: [PATCH v1 2/2] KVM: s390: pv: fix race when making a page
 secure
Message-ID: <20250214111729.000d364e@p-imbrenda>
In-Reply-To: <6c741da9-a793-4a59-920f-8df77807bc4d@redhat.com>
References: <20250213200755.196832-1-imbrenda@linux.ibm.com>
	<20250213200755.196832-3-imbrenda@linux.ibm.com>
	<6c741da9-a793-4a59-920f-8df77807bc4d@redhat.com>
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
X-Proofpoint-ORIG-GUID: SH8QYTNCDWJIZLZ1pAj45Uj9i0nlRbec
X-Proofpoint-GUID: SH8QYTNCDWJIZLZ1pAj45Uj9i0nlRbec
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-14_04,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 spamscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 clxscore=1015
 mlxlogscore=919 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2501170000 definitions=main-2502140072

On Thu, 13 Feb 2025 21:16:03 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 13.02.25 21:07, Claudio Imbrenda wrote:
> > Holding the pte lock for the page that is being converted to secure is
> > needed to avoid races. A previous commit removed the locking, which
> > caused issues. Fix by locking the pte again.
> > 
> > Fixes: 5cbe24350b7d ("KVM: s390: move pv gmap functions into kvm")  
> 
> If you found this because of my report about the changed locking, 
> consider adding a Suggested-by / Reported-y.

yes, sorry; I sent the patch in haste and forgot. Which one would you
prefer (or both?)

[...]

> > @@ -127,8 +128,11 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
> >   
> >   	page = gfn_to_page(kvm, gpa_to_gfn(gaddr));
> >   	mmap_read_lock(gmap->mm);
> > -	if (page)
> > -		rc = __gmap_make_secure(gmap, page, uvcb);
> > +	vmaddr = gfn_to_hva(gmap->private, gpa_to_gfn(gaddr));
> > +	if (kvm_is_error_hva(vmaddr))
> > +		rc = -ENXIO;
> > +	if (!rc && page)
> > +		rc = __gmap_make_secure(gmap, page, vmaddr, uvcb);
> >   	kvm_release_page_clean(page);
> >   	mmap_read_unlock(gmap->mm);
> >     
> 
> You effectively make the code more complicated and inefficient than 
> before. Now you effectively walk the page table twice in the common 
> small-folio case ...

I think in every case, but see below

> 
> Can we just go back to the old handling that we had before here?
> 

I'd rather not, this is needed to prepare for the next series (for
6.15) in a couple of weeks, where gmap gets completely removed from
s390/mm, and gmap dat tables will not share ptes with userspace anymore
(i.e. we will use mmu_notifiers, like all other archs)

I will remove the double walk, though, since there is no reason to keep
it in there


