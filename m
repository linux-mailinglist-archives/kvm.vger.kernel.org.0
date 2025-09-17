Return-Path: <kvm+bounces-57917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15693B811FB
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 19:09:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A6861C070AA
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 17:09:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C45792FC89C;
	Wed, 17 Sep 2025 17:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Fqkghz2h"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CAE230270;
	Wed, 17 Sep 2025 17:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758128941; cv=none; b=cA2/SYAuPImk/cLGhO2fAhiFxpOyn8zvTbspG5LAepGGpDFb/j+h3lDpZWU6XE1vQJXRpJEx8MPA3g2iMlIrFbSGzfZUWyRMoyWn0s8UPYy/GBEpAbCB6tY74Q32sXlJjkQbf2vQeIu0e53kFI1zigUtsmsCXaUZZ8ALwf7nyIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758128941; c=relaxed/simple;
	bh=zBfrLfWRD3V3Lx6XRo2WBcKP2ZgIzTx0XxjtypkNyKg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j8Jeg+/bBG/yFiURa12NXZfGQbJPEQ6s7y55hFApvsWRqFFDRRb+NxXvRTWmHNxhk/UQMYQi8x99SpQG5rx8nPK7X72tK5NjIxmB8rJB9TKAM2CUpZZQHO1ADVnq4ogezGL5/AXSIYiL2dpjJig/yRKGg39VDzsmRNh3xKIdo64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Fqkghz2h; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58H9h54G020615;
	Wed, 17 Sep 2025 17:08:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Ailo2Z
	L+dU5pRgNvdzMtsOWWGmpoGyat6dJvY1MBu60=; b=Fqkghz2h4UTGh8WqfIgTMU
	82x40YYLLn+ACheGL0vA8pRof0id9bidhNGIAPz59FFPUtLncdahrAZJD+0cQAzD
	4y4vygSAyxg/rD+tMeMq/+jj451x85H5clbV+iOZRZBvmthnXB4vyHBRTUKGGpQH
	de0UCDQrZTYfHP6yj+m8szvupHURY+IifKTEe1dzNEvAe+Ra78B3km4Sqt4YxJOL
	Y9lSjDxNPKD+cU0tzAi0xjahOUAMB7aan6m65lSnIQWMZzj20nnnNghjkfDXneLv
	/ULcxBbKO7gvUd+AgfLPyqFTAnwOhWahnDfa+xnJoC7QX5NmPYm0It/qy7TDAkJw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4m4w47-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 17:08:56 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58HF27Vl019200;
	Wed, 17 Sep 2025 17:08:55 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 495n5mj61c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 17:08:55 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HH8p5h32309964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 17:08:52 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF1262004B;
	Wed, 17 Sep 2025 17:08:51 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB64820043;
	Wed, 17 Sep 2025 17:08:51 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Sep 2025 17:08:51 +0000 (GMT)
Date: Wed, 17 Sep 2025 19:08:49 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 08/20] KVM: s390: KVM page table management
 functions: allocation
Message-ID: <20250917190849.5cd627aa@p-imbrenda>
In-Reply-To: <f63f9223-f848-4d02-91b5-f3fe85658754@de.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	<20250910180746.125776-9-imbrenda@linux.ibm.com>
	<20250916162653.27229G04-hca@linux.ibm.com>
	<20250916184737.47224f56@p-imbrenda>
	<63e8c905-28b1-4e1f-be77-e0789bd75692@de.ibm.com>
	<20250916190514.1a3082bd@p-imbrenda>
	<15f451d9-ecb3-4a82-9b9a-2de64b93944d@de.ibm.com>
	<20250916173644.27229Kcc-hca@linux.ibm.com>
	<20250917072733.7515Af5-hca@linux.ibm.com>
	<20250917132556.4814fe98@p-imbrenda>
	<20250917123006.7515C59-hca@linux.ibm.com>
	<20250917151124.1a53b0a6@p-imbrenda>
	<976f2cf6-e56f-4089-923d-29098746018b@de.ibm.com>
	<20250917160002.778b1905@p-imbrenda>
	<f63f9223-f848-4d02-91b5-f3fe85658754@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -Rsca5M4aPJQxlvMN4ReNTJwrUBm1cH2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX43jBH4lJ0LwD
 jxMCuOp81wBto/mSaRFzqg8VXG+VLbZNDcSScoQGJzlAef8jU0OiH5+dpnVBsE8nqWctBcNkQO/
 c36CPTTEt/EBA3PHg0DoYyX6jkzY3hBgIX8M+sAprfCl1Mc0dtYgcWYoVlYFknYvQZsKbQlgemX
 wSN5yKiLYmk9dZrh+hlhulHMGyKzKPGaGg7q4NcmHVS22pSQgwLf5rzUuqfGGAL5PptqItZN3ni
 jvz++XPa+4iUHUNaVwdMeyjdTUEXzC0glbLRi2Q0qx0YjNYD+OxBTsHDWL8MuwDrOALMJQu4lXS
 C6RKKuMg5lWP8Nh+cUKjYNxk9D08bMKEUPWgibcrz0pC+as8GyMvDe6IcBBVSDFsNJHN+Se+MG8
 WSa0Dbje
X-Proofpoint-ORIG-GUID: -Rsca5M4aPJQxlvMN4ReNTJwrUBm1cH2
X-Authority-Analysis: v=2.4 cv=QrNe3Uyd c=1 sm=1 tr=0 ts=68caeb28 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=dAd3JmUgOnn6SWmQA4MA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

On Wed, 17 Sep 2025 16:05:44 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am 17.09.25 um 16:00 schrieb Claudio Imbrenda:
> > On Wed, 17 Sep 2025 15:26:33 +0200
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> >> Am 17.09.25 um 15:11 schrieb Claudio Imbrenda:  
> >>> On Wed, 17 Sep 2025 14:30:06 +0200
> >>> Heiko Carstens <hca@linux.ibm.com> wrote:
> >>>      
> >>>> On Wed, Sep 17, 2025 at 01:25:56PM +0200, Claudio Imbrenda wrote:  
> >>>>> On Wed, 17 Sep 2025 09:27:33 +0200
> >>>>> Heiko Carstens <hca@linux.ibm.com> wrote:
> >>>>>         
> >>>>>> On Tue, Sep 16, 2025 at 07:36:44PM +0200, Heiko Carstens wrote:  
> >>>>>>> On Tue, Sep 16, 2025 at 07:06:06PM +0200, Christian Borntraeger wrote:  
> >>>>>>>>
> >>>>>>>> Am 16.09.25 um 19:05 schrieb Claudio Imbrenda:
> >>>>>>>>           
> >>>>>>>>>>> I think GFP_ATOMIC actually gives more guarantees?  
> >>>>>>>>>>
> >>>>>>>>>> In real life GFP_ATOMIC can fail, GFP_KERNEL does not.All gfp allocation failures
> >>>>>>>>>> are usually the atomic ones.  
> >>>>>>>>>
> >>>>>>>>> interesting... then I guess I need GFP_KERNEL | GFP_ATOMIC ?  
> >>>>>>>>
> >>>>>>>> No. ATOMIC always means: can fail.  
> >>>>>
> >>>>> my issue is that GFP_KERNEL can sleep, and this allocation is sometimes
> >>>>> called from atomic contexts (e.g. while holding spinlocks)
> >>>>>
> >>>>> the right way to do this would be with mempools, to allocate memory
> >>>>> (and potentially sleep) when we are not in atomic context, and use it
> >>>>> whenever needed. this is on my to-do list for the future, but right now
> >>>>> I'd like to avoid having to refactor a ton of code.  
> >>>>
> >>>> I doubt this is accetable even for an intermediate solution. As soon
> >>>> as the host is under memory pressure and starts doing I/O to free up
> >>>> memory, you will end up in -ENOMEM situations for simple guest page
> >>>> allocations.
> >>>>
> >>>> What happens with a guest in such a situation? Is this gracefully
> >>>> handled without that the guest is terminated?  
> >>>
> >>> well, we return -ENOMEM to userspace (and qemu will probably kill the
> >>> guest)
> >>>
> >>> but if we can't even allocate 16kB, probably we're already in a pretty
> >>> bad situation
> >>>
> >>> if you think this is not acceptable, I guess I'll have to implement
> >>> mempools  
> >>
> >> This is not acceptable. 16k atomic allocations are pretty much guaranteed
> >> to fail after a while of high workload.
> >> What are the callers of this allocation?  
> > 
> > literally anything that touches the gmap page tables, since we need to
> > hold kvm->mmu_lock, which is an rw spinlock  
> 
> So how is x86 allocating page table memory. I cant see GPF_ATOMIC or mempool over there.

after digging through the code: most other archs use
kvm_mmu_memory_cache, which is similar in spirit to mempools

I don't know how I managed to never notice it until now

