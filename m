Return-Path: <kvm+bounces-10567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA48286D86E
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 01:41:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DF08282348
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 00:41:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C3058F5F;
	Fri,  1 Mar 2024 00:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="a9dsPynl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D928BED
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 00:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709253675; cv=none; b=dYvgNzM5yLtpRHW/ocZBXUaTsR0GEjn+ft64EZSbG4czjbDI/ul7KVUIqDpZa7kc8oj5/3V85IZ5niyCaFrhvG3Tbb+aPznQ8YdOVCucKY+kN+xSI7lGerMn5hv34fMy91WN+Q/i9iNpxZ0Evpq6YkBHpf09WOQwWSzJZwx4y8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709253675; c=relaxed/simple;
	bh=P80WilD5wdaTPQpIr/9V7Ybtdl702HiX1GAp64LOwnk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xxu6qBsRE5ORE7sMx6xdqi10Zc6P2iJb/6VkwgChx2oKVyvGw/e3gVn9FgPJyNJbxAvk/80neaAu93mUiex4tBOBOboGFcvJTZRWCu+SsWp3VKN6hQTVvDAh6HQdHaj4QA2aFp0RjqXYKD27bXaHwDevNnx+kKcyUcXBkaOQRJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=a9dsPynl; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 4210QUGO026455;
	Fri, 1 Mar 2024 00:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	date:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=qcppdkim1; bh=fAmtm81RwLGFezIhtTg09
	a8+FIlqjPr8NQ8dQHAa7QY=; b=a9dsPynlV72fvZAGVQYtd9ghO3/7H4p0GFiKu
	nNO83MJMpHZJuz00OyesNPnGPWDSuOO4+o+qUfyQiRlD20tgbQWvtn5XS4YChN5Y
	BjjFhRW6Q2i+KdPvuCqF/B6pmFxyXZDgHpuPPdID7+NQeLWXi5cMdTR/rAEbjgdz
	K3a4D0wfslswJVh/NcJcPjEBuS9aCeEyh+/M3NkFvoLZ6lWNCXc/alMkFLUzbyHX
	oc2q+ZIqpS0UsuClXO5Rb+fRjj4oQ+zpZtbJZhdcbbuTQh4cTiIuiXLW8Kvk662+
	G1R60o0wy7AJK2FoiS0hdtwJWHKRg3US3FjZahclnkcyihaag==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3wjycdguu7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Mar 2024 00:40:16 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 4210eGbs027001
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 1 Mar 2024 00:40:16 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Thu, 29 Feb 2024 16:40:14 -0800
Date: Thu, 29 Feb 2024 16:40:14 -0800
From: Elliot Berman <quic_eberman@quicinc.com>
To: Fuad Tabba <tabba@google.com>
CC: David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>,
        Matthew Wilcox <willy@infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.linux.dev>, <pbonzini@redhat.com>,
        <chenhuacai@kernel.org>, <mpe@ellerman.id.au>, <anup@brainfault.org>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <seanjc@google.com>, <brauner@kernel.org>,
        <akpm@linux-foundation.org>, <xiaoyao.li@intel.com>,
        <yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>,
        <jarkko@kernel.org>, <amoorthy@google.com>, <dmatlack@google.com>,
        <yu.c.zhang@linux.intel.com>, <isaku.yamahata@intel.com>,
        <mic@digikod.net>, <vbabka@suse.cz>, <vannapurve@google.com>,
        <ackerleytng@google.com>, <mail@maciej.szmigiero.name>,
        <michael.roth@amd.com>, <wei.w.wang@intel.com>,
        <liam.merwick@oracle.com>, <isaku.yamahata@gmail.com>,
        <kirill.shutemov@linux.intel.com>, <suzuki.poulose@arm.com>,
        <steven.price@arm.com>, <quic_mnalajal@quicinc.com>,
        <quic_tsoni@quicinc.com>, <quic_svaddagi@quicinc.com>,
        <quic_cvanscha@quicinc.com>, <quic_pderrin@quicinc.com>,
        <quic_pheragu@quicinc.com>, <catalin.marinas@arm.com>,
        <james.morse@arm.com>, <yuzenghui@huawei.com>,
        <oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
        <keirf@google.com>, <linux-mm@kvack.org>
Subject: Re: Re: folio_mmapped
Message-ID: <20240229114526893-0800.eberman@hu-eberman-lv.qualcomm.com>
Mail-Followup-To: Fuad Tabba <tabba@google.com>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Matthew Wilcox <willy@infradead.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	brauner@kernel.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, keirf@google.com, 
	linux-mm@kvack.org
References: <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
 <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
 <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com>
 <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>
 <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>
 <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <CA+EHjTzHtsbhzrb-TWft1q3Ree3kgzZbsir+R9L0tDgSX-d-0g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+EHjTzHtsbhzrb-TWft1q3Ree3kgzZbsir+R9L0tDgSX-d-0g@mail.gmail.com>
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: KUnnGdlrkBnGMyW3fU4tsf-S_7ez_xmz
X-Proofpoint-ORIG-GUID: KUnnGdlrkBnGMyW3fU4tsf-S_7ez_xmz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-29_07,2024-02-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2402120000 definitions=main-2403010004

On Thu, Feb 29, 2024 at 07:01:51PM +0000, Fuad Tabba wrote:
> Hi David,
> 
> ...
> 
> >>>> "mmap() the whole thing once and only access what you are supposed to
> > >   (> > > access" sounds reasonable to me. If you don't play by the rules, you get a
> > >>>> signal.
> > >>>
> > >>> "... you get a signal, or maybe you don't". But yes I understand your
> > >>> point, and as per the above there are real benefits to this approach so
> > >>> why not.
> > >>>
> > >>> What do we expect userspace to do when a page goes from shared back to
> > >>> being guest-private, because e.g. the guest decides to unshare? Use
> > >>> munmap() on that page? Or perhaps an madvise() call of some sort? Note
> > >>> that this will be needed when starting a guest as well, as userspace
> > >>> needs to copy the guest payload in the guestmem file prior to starting
> > >>> the protected VM.
> > >>
> > >> Let's assume we have the whole guest_memfd mapped exactly once in our
> > >> process, a single VMA.
> > >>
> > >> When setting up the VM, we'll write the payload and then fire up the VM.
> > >>
> > >> That will (I assume) trigger some shared -> private conversion.
> > >>
> > >> When we want to convert shared -> private in the kernel, we would first
> > >> check if the page is currently mapped. If it is, we could try unmapping that
> > >> page using an rmap walk.
> > >
> > > I had not considered that. That would most certainly be slow, but a well
> > > behaved userspace process shouldn't hit it so, that's probably not a
> > > problem...
> >
> > If there really only is a single VMA that covers the page (or even mmaps
> > the guest_memfd), it should not be too bad. For example, any
> > fallocate(PUNCHHOLE) has to do the same, to unmap the page before
> > discarding it from the pagecache.
> 
> I don't think that we can assume that only a single VMA covers a page.
> 
> > But of course, no rmap walk is always better.
> 
> We've been thinking some more about how to handle the case where the
> host userspace has a mapping of a page that later becomes private.
> 
> One idea is to refuse to run the guest (i.e., exit vcpu_run() to back
> to the host with a meaningful exit reason) until the host unmaps that
> page, and check for the refcount to the page as you mentioned earlier.
> This is essentially what the RFC I sent does (minus the bugs :) ) .
> 
> The other idea is to use the rmap walk as you suggested to zap that
> page. If the host tries to access that page again, it would get a
> SIGBUS on the fault. This has the advantage that, as you'd mentioned,
> the host doesn't need to constantly mmap() and munmap() pages. It
> could potentially be optimised further as suggested if we have a
> cooperating VMM that would issue a MADV_DONTNEED or something like
> that, but that's just an optimisation and we would still need to have
> the option of the rmap walk. However, I was wondering how practical
> this idea would be if more than a single VMA covers a page?
> 

Agree with all your points here. I changed Gunyah's implementation to do
the unmap instead of erroring out. I didn't observe a significant
performance difference. However, doing unmap might be a little faster
because we can check folio_mapped() before doing the rmap walk. When
erroring out at mmap() level, we always have to do the walk.

> Also, there's the question of what to do if the page is gupped? In
> this case I think the only thing we can do is refuse to run the guest
> until the gup (and all references) are released, which also brings us
> back to the way things (kind of) are...
> 

If there are gup users who don't do FOLL_PIN, I think we either need to
fix them or live with possibility here? We don't have a reliable
refcount for a folio to be safe to unmap: it might be that another vCPU
is trying to get the same page, has incremented the refcount, and
waiting for the folio_lock. This problem exists whether we block the
mmap() or do SIGBUS.

Thanks,
Elliot

