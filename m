Return-Path: <kvm+bounces-57902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A3B2B7FE6A
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 16:21:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 820867B9B2C
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3377C2D7818;
	Wed, 17 Sep 2025 14:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qzAyb9U+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5396E2BE635;
	Wed, 17 Sep 2025 14:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758118308; cv=none; b=XfOzKW8I3YNiVC1XBredvU/upLtIll1i3mCoHj2eidlnr61UMgi+CiFaH4gJOQRC6tk1kE3fpsZ9eQtSTGiraRLrClLtVVZ5ZJ2gbJH3SiOtDinLeT2XZQIQ/j9EYopE0kuUzaY05nB9xudXqRjSCVR1tNq5YCzJGhij1JxVzTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758118308; c=relaxed/simple;
	bh=gqnD2/3vhtL82Q+nA6H3e7QVs2CpSfkKy3BxgcsEu9I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H2Lt3tK0u2gjdFwJVoP/DgoOoR6V8X7T95ctNPErJehjsowiGH/dpj1hGm15ZQuahLXTUWYRbqTZ10oQExLdZCodZ/Wez+kc4cPBoKaDLr8MEhxfumMRI8ZXLrZVT/cu75t7Aq812axJAUF0KgxYgDh9YNuo/Ab525MzxMhNRZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qzAyb9U+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58H9paV7012458;
	Wed, 17 Sep 2025 14:11:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0r74v2
	UNdjomrzQXMZsZtwojDuSco62SsAYMTh8zRFY=; b=qzAyb9U+vLJMi/NAzHPeRn
	Iv/mXQoKJfrll9dn5QPvyJ8ej6pgZB4BjKln5vOL4JCFpbobSRZxeP3orSPARbtC
	paLZJjN/LFiYuGWHJ4jOEj+ivphEG12Ov/kCFXzSAeDsqU2VrB3JPQR1nl2ZOooy
	Ibn422Yencg/V5dGFesa0iKWTDUpJPjBjeQWiQs1aMEOJEJdrPkes1C4xHdqGn5C
	U/udQlcm34Ec2moNiCj7nkob+Sn/1BBkYOoQuadCvtCnBicJRkTVhoKQRUh4SBrN
	07Vyf53VND05eiDxM+mL4jKHVJ+VBPa7SIw8+Yyr3KhDOy2JWJkoClcGpVu0Ae0g
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4j47k2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 14:11:43 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58HE8O0Z027308;
	Wed, 17 Sep 2025 14:11:41 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495men9hr4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 14:11:41 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HEBbQl38928700
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 14:11:37 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 58A7A20040;
	Wed, 17 Sep 2025 14:11:37 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 30F7D2004D;
	Wed, 17 Sep 2025 14:11:37 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Sep 2025 14:11:37 +0000 (GMT)
Date: Wed, 17 Sep 2025 16:11:35 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 08/20] KVM: s390: KVM page table management
 functions: allocation
Message-ID: <20250917161135.1645715f@p-imbrenda>
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
X-Authority-Analysis: v=2.4 cv=Qf5mvtbv c=1 sm=1 tr=0 ts=68cac19f cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=dAd3JmUgOnn6SWmQA4MA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: Ql408l8XbHX_O8WDb7kc46pVTWS3DJM1
X-Proofpoint-GUID: Ql408l8XbHX_O8WDb7kc46pVTWS3DJM1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfXzjuyv0xuH937
 pSWvokjpkdoUjsXqF1M2tA4ndCVr569aMMKepUFN4AB7MXsr/vxqAHR+xwiq35LEm7pCHhNhrG8
 ULxNlebi5LSJB11RLE6luhHI3JeVU3ZNJuc4P4ift4ThFvuphmCYUoBmtJBx3p1VkPfyvHwV+kM
 HlSeFnzT9X+2ZDyJxfO7nHGLBGsXruvaLRaS431Pyu6A51tomrUwwKDpQtVIgLrRCdaFxdQOZR6
 e3vIAEfs1JeaYd83hn8Z+jbR7mqo7K3DEbi7il4teUgcGmKHMmNWPvs/9374Nv5Lac27tbHj1OD
 87DQX8l19wf64OMGWsdyn+HHGyj3hQ2rYDd80vz61x+xAGhkz9yPhTPGRJq8SpVz/KTFaEy/PLv
 ukLqMHDf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 phishscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0
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

I'll check, but I think they use an RCU?

