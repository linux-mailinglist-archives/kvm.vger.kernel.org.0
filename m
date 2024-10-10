Return-Path: <kvm+bounces-28570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 40D70999454
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 23:20:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B93031F23F83
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 21:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 100261E3DE0;
	Thu, 10 Oct 2024 21:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="S+bs9SQ3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC23319CD1B;
	Thu, 10 Oct 2024 21:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728595244; cv=none; b=QiQjKc+KlY+UemOzq4UC71wzldKHy8tpwtSZGcKcH4aD3LC/tJi10zndWjzt699ucemwuDg5GL7TnWm8wytaK1nSWZE9MmIuiczgMeVp9I1uv4t6juZlCfmabL5R2jMWLUZYcYwPag1k4/UW/cTOPZI/Ksc2zLyXRuZI2fEg1SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728595244; c=relaxed/simple;
	bh=hHB042UrlNapGxuP9YL5laD53DwKqbtDdjnvLIFvJmg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ox74yiGtbML4uWXiFOLdao2tHVjx8aExwEQb1MToE881/yqewb+yl6bjUBx8nQC13gJPZeQmG4R6n1+pqQgX3L4Hf1Ui+sQxXkZ/yCxf3lbS2Y9ARKTwxmQLb/b9jP9zrm5EpKvUXi4ZQp7Dl2elp3A2knUyYPNTSzR4RFYSt7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=S+bs9SQ3; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49ADqTgG029122;
	Thu, 10 Oct 2024 21:20:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=p1du+Ye7BQqMGbCGPm0NLDXB
	ijQnXr/8gzzZbkjUG5U=; b=S+bs9SQ3mpvE8P9EYeZGATpgGdP1gBb4TSpyqg5p
	OMk80dp/Oq+gswoYiL8Er4yR7GW99aVZ4+sKfu+o2fyFMKQ20soZI7/o/+8RI1f6
	/6CfZIerkLPqvU5GM/5cQPEGyDXFIjLcVgh5Rlzi33ZoYHdtye50Uk89wR8qpc4z
	4KK2nlFTjQzlmFlN3V4NMnWW7L8tbicoMimbeRE8ClOIM8N9/dz4kzqZYDlbrzm9
	95ubm2aqo42yh42WcPFxnj2s6ZoiMLE8AL8Zp6ScCLQWwYcYs216Iho8R22FNaVb
	adAAA1LhSZqtFqVDbH8BKB23a/fJ03ckTwVdToVf25d3Bg==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 426g6n9221-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 21:20:04 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 49ALK3nt004421
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 21:20:03 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 10 Oct 2024 14:20:02 -0700
Date: Thu, 10 Oct 2024 14:20:02 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Sean Christopherson
	<seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen
	<dave.hansen@linux.intel.com>,
        Fuad Tabba <tabba@google.com>, David
 Hildenbrand <david@redhat.com>,
        Patrick Roy <roypat@amazon.co.uk>, <qperret@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Mike Rapoport
	<rppt@kernel.org>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <kvm@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH RFC v2 0/5] mm: Introduce guest_memfd library
Message-ID: <20241010141522228-0700.eberman@hu-eberman-lv.qualcomm.com>
References: <20240829-guest-memfd-lib-v2-0-b9afc1ff3656@quicinc.com>
 <9fd97046-b7b1-49d6-8fc5-2104814152d6@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9fd97046-b7b1-49d6-8fc5-2104814152d6@redhat.com>
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: TbXGm-yolUCjzTTItCKQ163W7jB4XeIs
X-Proofpoint-GUID: TbXGm-yolUCjzTTItCKQ163W7jB4XeIs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 clxscore=1011 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2410100140

On Thu, Oct 10, 2024 at 03:04:16PM +0200, Paolo Bonzini wrote:
> On 8/30/24 00:24, Elliot Berman wrote:
> > In preparation for adding more features to KVM's guest_memfd, refactor
> > and introduce a library which abstracts some of the core-mm decisions
> > about managing folios associated with the file. The goal of the refactor
> > serves two purposes:
> > 
> > 1. Provide an easier way to reason about memory in guest_memfd. With KVM
> > supporting multiple confidentiality models (TDX, SEV-SNP, pKVM, ARM
> > CCA), and coming support for allowing kernel and userspace to access
> > this memory, it seems necessary to create a stronger abstraction between
> > core-mm concerns and hypervisor concerns.
> > 
> > 2. Provide a common implementation for other hypervisors (Gunyah) to use.
> > 
> > To create a guest_memfd, the owner provides operations to attempt to
> > unmap the folio and check whether a folio is accessible to the host. The
> > owner can call guest_memfd_make_inaccessible() to ensure Linux doesn't
> > have the folio mapped.
> > 
> > The series first introduces a guest_memfd library based on the current
> > KVM (next) implementation, then adds few features needed for Gunyah and
> > arm64 pKVM. The Gunyah usage of the series will be posted separately
> > shortly after sending this series. I'll work with Fuad on using the
> > guest_memfd library for arm64 pKVM based on the feedback received.
> > 
> > There are a few TODOs still pending.
> > - The KVM patch isn't tested. I don't have access a SEV-SNP setup to be
> >    able to test.
> > - I've not yet investigated deeply whether having the guest_memfd
> >    library helps live migration. I'd appreciate any input on that part.
> > - We should consider consolidating the adjust_direct_map() in
> >    arch/x86/virt/svm/sev.c so guest_memfd can take care of it.
> > - There's a race possibility where the folio ref count is incremented
> >    and about to also increment the safe counter, but waiting for the
> >    folio lock to be released. The owner of folio_lock will see mismatched
> >    counter values and not be able to convert to (in)accessible, even
> >    though it should be okay to do so.
> > I'd appreciate any feedback, especially on the direction I'm taking for
> > tracking the (in)accessible state.
> > 
> > Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> > 
> > Changes in v2:
> > - Significantly reworked to introduce "accessible" and "safe" reference
> >    counters
> 
> Was there any discussion on this change?  If not, can you explain it a bit
> more since it's the biggest change compared to the KVM design?  I suppose

The accessible and safe refcount was discussed in the PUCK and over the
mailing lists in the previous version of this patchset.

That being said though, after discussions at LPC, I'm now behind the
design Fuad has recently posted [1]. I was on vacation last week and I
still need to go through his series, but we had discussed the key parts
of the design offline.

[1]: https://lore.kernel.org/all/20241010085930.1546800-1-tabba@google.com/

> the reference counting is used in relation to mmap, but it would be nice to
> have a few more words on how the counts are used and an explanation of when
> (especially) the accessible atomic_t can take any value other than 0/1.
> 
> As an aside, allocating 8 bytes of per-folio private memory (and
> dereferencing the pointer, too) is a bit of a waste considering that the
> private pointer itself is 64 bits on all platforms of interest.
> 
> Paolo
> 
> > - Link to v1:
> >    https://lore.kernel.org/r/20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com
> > 
> > ---
> > Elliot Berman (5):
> >        mm: Introduce guest_memfd
> >        mm: guest_memfd: Allow folios to be accessible to host
> >        kvm: Convert to use guest_memfd library
> >        mm: guest_memfd: Add ability for userspace to mmap pages
> >        mm: guest_memfd: Add option to remove inaccessible memory from direct map
> > 
> >   arch/x86/kvm/svm/sev.c      |   3 +-
> >   include/linux/guest_memfd.h |  49 ++++
> >   mm/Kconfig                  |   3 +
> >   mm/Makefile                 |   1 +
> >   mm/guest_memfd.c            | 667 ++++++++++++++++++++++++++++++++++++++++++++
> 
> I think I'd rather have this in virt/lib.
> 
> Paolo
> 

