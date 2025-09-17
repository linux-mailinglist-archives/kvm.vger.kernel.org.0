Return-Path: <kvm+bounces-57884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E2D3B7F439
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:28:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C2BD4A38C8
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABAC33161A7;
	Wed, 17 Sep 2025 13:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="o1f9z8X0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CADD33C768;
	Wed, 17 Sep 2025 13:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114694; cv=none; b=NNLvwzjbq5vAucs6b3gPislap8pOTenuLhoLsO9jCrC6qn5c9aWmyJwBxu7qOQkEuM6C54MGWNAs0/nDYl8a0w4d3L3dk102mt3exn28FsYskJQUeQtxjPlGeNTqDInbZir6g7HxJJgKEnwFCo68QAtwbH/uTQ55ToiD8obOFi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114694; c=relaxed/simple;
	bh=MifsQZ7TBM3SAWrr/yYzns1tSsk4nYv4MfS8Q3gCmdw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l/VnHtEOeHp62Wg+uv0o+ZP63BoeEdvPHBIHVHFnWNL5w5XxwPAqgduLMRe/0FB7NUZf+7SDVb4DJtKG8axuWIn23/n2Aq4h37r1sPpCiYvsatrbNzQSsacA00t5gd1Hi8bcSeNjR4NNmd7hS6ZZ5O4YEhIlbrH74Coe/RWu9B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=o1f9z8X0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58H9aNYN011014;
	Wed, 17 Sep 2025 13:11:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=+g9nnP
	Tig/t8pCFZEjSY53QjmU096BcF5sbX6nBvkHQ=; b=o1f9z8X0B4BHI6XMAPExtv
	GtfO8K1qUMUfbQMGWDn0Ps5XK19dCGJsuM+vxEeGC6hzV4G0gYhgaGSpl5qQkHQV
	+vRXVq+wLBfHdwAZYvByz5qt+wDVZnHr3e3OmvaU5//Et5a/efi/h//bk52UZsR1
	ZcCdNAMPUjfc3rB0rNTJIoevnxALyJx2NhOMgyEVFlRYfnsNLVaay0o8ucQP/wHQ
	Mzy/o7KOfPzWH6MbR72uVHXR2bfrp+KvA/ZM3iMfO+KoLGRCqJAeVwhhRVsMQKjS
	7lrP/nZZOfNBYuCtTqrYVawTFVuEgooSqne0rYmQXNMyT0ljZChD6eSo8N+r8J/Q
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4nbn78-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 13:11:30 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58HA3TxA029514;
	Wed, 17 Sep 2025 13:11:30 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495kb11hhj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 13:11:30 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HDBQ6v61014312
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 13:11:26 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A330520043;
	Wed, 17 Sep 2025 13:11:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6FAE320040;
	Wed, 17 Sep 2025 13:11:26 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Sep 2025 13:11:26 +0000 (GMT)
Date: Wed, 17 Sep 2025 15:11:24 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 08/20] KVM: s390: KVM page table management
 functions: allocation
Message-ID: <20250917151124.1a53b0a6@p-imbrenda>
In-Reply-To: <20250917123006.7515C59-hca@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=MN5gmNZl c=1 sm=1 tr=0 ts=68cab382 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=QNP4-n-eHdO2m1c4jG4A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: U_KLsHmdKJWFr-Tktt2eHv9eA1WpvAJ9
X-Proofpoint-ORIG-GUID: U_KLsHmdKJWFr-Tktt2eHv9eA1WpvAJ9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX5o6h5Vxlqd6x
 raI2O0+R7dRkgTD6dy8Yk2HQZ9H2MidHtbc06JFZvB+/LMfJqOYjPkWpot0FMuhj6PAgQKijvX8
 INLJ5eW9lwkidlpVze/dFPzqC5OUguEkJN4w6MZ5MT3pQdTHVNBKnjgf9wiGadKlkbT0jOm7PEQ
 d2Q5pLyGwyqt7Y2HHr0sMdMokR6dOr1wOqQwpZHiYFe04mZ9+KB7clZOXcX5mAYcWgWpf08m8Gk
 hBxDjE8r0NbBGzQ8uHpxDx7B4wL2DSnNNR3jUocgWpjeZ/NVlAknrhhu1U1xJjMr4BZ2Gtf76ap
 f8bYnwex6wjs9EbWUbFzyTp+BrBonGJZu9qrlzU/qbwa5ctV5N6DYW0WvSfbIk3lrvwoX/WAlAT
 EcbNPYeJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

On Wed, 17 Sep 2025 14:30:06 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Wed, Sep 17, 2025 at 01:25:56PM +0200, Claudio Imbrenda wrote:
> > On Wed, 17 Sep 2025 09:27:33 +0200
> > Heiko Carstens <hca@linux.ibm.com> wrote:
> >   
> > > On Tue, Sep 16, 2025 at 07:36:44PM +0200, Heiko Carstens wrote:  
> > > > On Tue, Sep 16, 2025 at 07:06:06PM +0200, Christian Borntraeger wrote:    
> > > > > 
> > > > > Am 16.09.25 um 19:05 schrieb Claudio Imbrenda:
> > > > >     
> > > > > > > > I think GFP_ATOMIC actually gives more guarantees?    
> > > > > > > 
> > > > > > > In real life GFP_ATOMIC can fail, GFP_KERNEL does not.All gfp allocation failures
> > > > > > > are usually the atomic ones.    
> > > > > > 
> > > > > > interesting... then I guess I need GFP_KERNEL | GFP_ATOMIC ?    
> > > > > 
> > > > > No. ATOMIC always means: can fail.   
> > 
> > my issue is that GFP_KERNEL can sleep, and this allocation is sometimes
> > called from atomic contexts (e.g. while holding spinlocks)
> > 
> > the right way to do this would be with mempools, to allocate memory
> > (and potentially sleep) when we are not in atomic context, and use it
> > whenever needed. this is on my to-do list for the future, but right now
> > I'd like to avoid having to refactor a ton of code.  
> 
> I doubt this is accetable even for an intermediate solution. As soon
> as the host is under memory pressure and starts doing I/O to free up
> memory, you will end up in -ENOMEM situations for simple guest page
> allocations.
> 
> What happens with a guest in such a situation? Is this gracefully
> handled without that the guest is terminated?

well, we return -ENOMEM to userspace (and qemu will probably kill the
guest)

but if we can't even allocate 16kB, probably we're already in a pretty
bad situation

if you think this is not acceptable, I guess I'll have to implement
mempools

> 
> > > Another correction: it should be GFP_KERNEL_ACCOUNT instead, like it
> > > used to be before in gmap_alloc_crst() since those page tables should
> > > be accounted to the process which is allocating them.  
> > 
> > gfp_types.h says:
> > 
> >  * %GFP_KERNEL_ACCOUNT is the same as GFP_KERNEL, except the allocation is
> >  * accounted to kmemcg.
> > 
> > I thought that without GFP_KERNEL_ACCOUNT, it would be accounted toward
> > the process?
> > The documentation is a little confusing here  
> 
> Documentation/core-api/memory-allocation.rst:
> 
>   * Untrusted allocations triggered from userspace should be a subject
>     of kmem accounting and must have ``__GFP_ACCOUNT`` bit set. There
>     is the handy ``GFP_KERNEL_ACCOUNT`` shortcut for ``GFP_KERNEL``
>     allocations that should be accounted.
> 
> This is done for all page table allocations, except if mm == init_mm
> (and unfortunately also not for the s390 specific crste alloc
> functions - I'll send a patch for that).

alright, then GFP_KERNEL_ACCOUNT it is

