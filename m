Return-Path: <kvm+bounces-9997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E8D148682C6
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 22:15:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CABB1F22D6B
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 21:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F40AD13172B;
	Mon, 26 Feb 2024 21:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="eD+hmBVa"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB59C7F7EC
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 21:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708982135; cv=none; b=FBWLIJKFWn4QZnqS4LioCX2NEESs/5YMEk7LurzH3L/JO7mnjOpaGFVPnln5NTENnohFz4qnpZVap6NUEQMOmqWbg/nZxXvXaVFkVAakvX3xzK5fhliDZnitjg1ViXi6uo3dYd7L7QLA0UduayHtQ8k43ntABsK88u2j9RAhP6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708982135; c=relaxed/simple;
	bh=zVbEaCoi1j4R+WCBnZPm/8M5/ONb5t6QuuoqM9gQgPo=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=saxXLCiI2Y/xtrRmvA6tDHoahTCs+s+4XVSHpbXSESOnLT1ocec9lZvMyweT5Vc8hBH8i5yBeaP+IKcM3Nl5t83RhzFjDLJnaC0IRZ0PMHjr+W+x6/J4eCy8hdh6eREVvpGLFk8k5gC8HsoNEvhx51kADKOtse9SfosgL0NAvpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=eD+hmBVa; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41QJfp45005556;
	Mon, 26 Feb 2024 21:14:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	date:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=qcppdkim1; bh=palv05N4kOBj98emYRCrI
	16CO1nbfjBjijuX6/V+vrQ=; b=eD+hmBVaDcCFJTQM/Ufs0fBVLdSPt2EyXe3LP
	lUzJ2vpdV5g03cNf8W+6AIo6GwXBIgIr+8qpUZKFgqqQa8cOtreh5W58MN+/1h73
	6alzRC/dgwQlNZ7hNQKAXRi9FxdU4lFlY4IsvfCfAS1mYnWTwIQf/SUsocIpTDKd
	2qatZHcw56uJ2s8tPl9B3GSElctSZSPIE7NUFSSNaBobqZ/YBmM5IVl8NcMclBob
	Ce1fOHaybeeO5A4q415AHSMa7SF1cE9XxkZ7oHZGFS/CNpqsl1yIdGdOtOiBWk4A
	csfcXPGDoV+QZQfJJERjLyxcezMiiVQqxCRa8DgqLUt/Sc1qg==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3wgkxna428-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 21:14:41 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 41QLEdhP032494
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 21:14:39 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 26 Feb 2024 13:14:38 -0800
Date: Mon, 26 Feb 2024 13:14:38 -0800
From: Elliot Berman <quic_eberman@quicinc.com>
To: David Hildenbrand <david@redhat.com>
CC: Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
        <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>, <pbonzini@redhat.com>,
        <chenhuacai@kernel.org>, <mpe@ellerman.id.au>, <anup@brainfault.org>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <seanjc@google.com>,
        <viro@zeniv.linux.org.uk>, <brauner@kernel.org>,
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
        <qperret@google.com>, <keirf@google.com>, <linux-mm@kvack.org>
Subject: Re: Re: folio_mmapped
Message-ID: <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
Mail-Followup-To: David Hildenbrand <david@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, 
	steven.price@arm.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, 
	quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com, 
	yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, 
	qperret@google.com, keirf@google.com, linux-mm@kvack.org
References: <20240222161047.402609-1-tabba@google.com>
 <20240222141602976-0800.eberman@hu-eberman-lv.qualcomm.com>
 <ZdfoR3nCEP3HTtm1@casper.infradead.org>
 <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: Q6lIhduTNjI7frqLFxHqnJlNm939s38J
X-Proofpoint-GUID: Q6lIhduTNjI7frqLFxHqnJlNm939s38J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_11,2024-02-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 mlxscore=0 impostorscore=0 clxscore=1015 malwarescore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2402120000 definitions=main-2402260163

On Mon, Feb 26, 2024 at 10:28:11AM +0100, David Hildenbrand wrote:
> On 23.02.24 01:35, Matthew Wilcox wrote:
> > On Thu, Feb 22, 2024 at 03:43:56PM -0800, Elliot Berman wrote:
> > > > This creates the situation where access to successfully mmap()'d
> > > > memory might SIGBUS at page fault. There is precedence for
> > > > similar behavior in the kernel I believe, with MADV_HWPOISON and
> > > > the hugetlbfs cgroups controller, which could SIGBUS at page
> > > > fault time depending on the accounting limit.
> > > 
> > > I added a test: folio_mmapped() [1] which checks if there's a vma
> > > covering the corresponding offset into the guest_memfd. I use this
> > > test before trying to make page private to guest and I've been able to
> > > ensure that userspace can't even mmap() private guest memory. If I try
> > > to make memory private, I can test that it's not mmapped and not allow
> > > memory to become private. In my testing so far, this is enough to
> > > prevent SIGBUS from happening.
> > > 
> > > This test probably should be moved outside Gunyah specific code, and was
> > > looking for maintainer to suggest the right home for it :)
> > > 
> > > [1]: https://lore.kernel.org/all/20240222-gunyah-v17-20-1e9da6763d38@quicinc.com/
> > 
> > You, um, might have wanted to send an email to linux-mm, not bury it in
> > the middle of a series of 35 patches?
> > 
> > So this isn't folio_mapped() because you're interested if anyone _could_
> > fault this page, not whether the folio is currently present in anyone's
> > page tables.
> > 
> > It's like walk_page_mapping() but with a trivial mm_walk_ops; not sure
> > it's worth the effort to use walk_page_mapping(), but I would defer to
> > David.
> 
> First, I suspect we are not only concerned about current+future VMAs
> covering the page, we are also interested in any page pins that could have
> been derived from such a VMA?
> 
> Imagine user space mmap'ed the file, faulted in page, took a pin on the page
> using pin_user_pages() and friends, and then munmap()'ed the VMA.
> 
> You likely want to catch that as well and not allow a conversion to private?
> 
> [I assume you want to convert the page to private only if you hold all the
> folio references -- i.e., if the refcount of a small folio is 1]
> 

Ah, this was something I hadn't thought about. I think both Fuad and I
need to update our series to check the refcount rather than mapcount
(kvm_is_gmem_mapped for Fuad, gunyah_folio_lend_safe for me).

> 
> Now, regarding the original question (disallow mapping the page), I see the
> following approaches:
> 
> 1) SIGBUS during page fault. There are other cases that can trigger
>    SIGBUS during page faults: hugetlb when we are out of free hugetlb
>    pages, userfaultfd with UFFD_FEATURE_SIGBUS.
> 
> -> Simple and should get the job done.
> 
> 2) folio_mmapped() + preventing new mmaps covering that folio
> 
> -> More complicated, requires an rmap walk on every conversion.
> 
> 3) Disallow any mmaps of the file while any page is private
> 
> -> Likely not what you want.
> 
> 
> Why was 1) abandoned? I looks a lot easier and harder to mess up. Why are
> you trying to avoid page faults? What's the use case?
> 

We were chatting whether we could do better than the SIGBUS approach.
SIGBUS/FAULT usually crashes userspace, so I was brainstorming ways to
return errors early. One difference between hugetlb and this usecase is
that running out of free hugetlb pages isn't something we could detect
at mmap time. In guest_memfd usecase, we should be able to detect when
SIGBUS becomes possible due to memory being lent to guest.

I can't think of a reason why userspace would want/be able to resume
operation after trying to access a page that it shouldn't be allowed, so
SIGBUS is functional. The advantage of trying to avoid SIGBUS was
better/easier reporting to userspace.

- Elliot

