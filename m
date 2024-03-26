Return-Path: <kvm+bounces-12739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCA3488D067
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 23:05:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19790B22DC2
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 22:05:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B267C13D8A0;
	Tue, 26 Mar 2024 22:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Ell8VAU/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEC61D54F
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 22:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711490717; cv=none; b=ZhsS9sI75h7rptNaE8E1zJjE7ADMpJpLYGX8iihxB8m7+I/V/vEU0jEL2nM3g1o7+eU1XvH45eMFwJaH1AFn1jfDoncAQ2fzb8RvjU5eG54Y5Y4JeYxEq2OleY/bQ2X3MGwRbO2dTGggEMWKJ0nP08vuvg7/MZoamEeU/08SEc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711490717; c=relaxed/simple;
	bh=MFh2MCr5vyoFUpxCMVtQXN60rm+8GR8DyNAd25tUD4s=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o+WqqwyOWr9n7AV+MVhIfW86VvBKrUQ7DInWEyZujrCILrez3oiam4QoTd0FNmlXqRazEn/T7Fl2DqzGllg/DPWc54+poAlui5G9KAqwJoCfmgp3HMHIDzC5nJatDuT6yvf8rpcaUtWTC66npZmVWAoTz8WCyEnL0aYAURu2hPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Ell8VAU/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 42QLjFRG011029;
	Tue, 26 Mar 2024 22:04:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-transfer-encoding:in-reply-to; s=
	qcppdkim1; bh=qac6Cp2FLUaRSTNw9pj8ffZlcrZ283FzfDDScLTosf8=; b=El
	l8VAU/bsJp9jA4e/Jb+h9EcLktilfaFMd3ADaFCHRdepGhVKlLuxOMi9mhjFvByv
	oSRFiBojEyprX1pZEXfj8rjtWq+PZ13tFnHCpzMyVFjMMx8uu8h+rMAmzksecKsb
	q15aUsSLZ0XSC+U7OAjfDvv5pfcSjZz6Rnib0i43/ZLqOuEprqW2NFlrLX8QNzGf
	bWP+rmR/Knrd3BNF7qCVTMMIP1a3SzEv+KEzPs2MZfGIjaSU9zq/5Rj+IWswsV50
	KvHMU9JFA0huuu4p1FUzydGjotCgh5VELP0I0lGZXrbrG58LnDm4DAio8+Dtjm8t
	q/79U6YowFnRTLsdguDg==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3x3rt82gmy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 22:04:18 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 42QM4GLI010490
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 22:04:16 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Tue, 26 Mar 2024 15:04:15 -0700
Date: Tue, 26 Mar 2024 15:04:14 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
To: David Hildenbrand <david@redhat.com>
CC: Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Quentin Perret
	<qperret@google.com>,
        Matthew Wilcox <willy@infradead.org>, Fuad Tabba
	<tabba@google.com>,
        <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>, <pbonzini@redhat.com>,
        <chenhuacai@kernel.org>, <mpe@ellerman.id.au>, <anup@brainfault.org>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <viro@zeniv.linux.org.uk>,
        <brauner@kernel.org>, <akpm@linux-foundation.org>,
        <xiaoyao.li@intel.com>, <yilun.xu@intel.com>,
        <chao.p.peng@linux.intel.com>, <jarkko@kernel.org>,
        <amoorthy@google.com>, <dmatlack@google.com>,
        <yu.c.zhang@linux.intel.com>, <isaku.yamahata@intel.com>,
        <mic@digikod.net>, <vbabka@suse.cz>, <ackerleytng@google.com>,
        <mail@maciej.szmigiero.name>, <michael.roth@amd.com>,
        <wei.w.wang@intel.com>, <liam.merwick@oracle.com>,
        <isaku.yamahata@gmail.com>, <kirill.shutemov@linux.intel.com>,
        <suzuki.poulose@arm.com>, <steven.price@arm.com>,
        <quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
        <quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
        <quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
        <catalin.marinas@arm.com>, <james.morse@arm.com>,
        <yuzenghui@huawei.com>, <oliver.upton@linux.dev>, <maz@kernel.org>,
        <keirf@google.com>, <linux-mm@kvack.org>
Subject: Re: Re: folio_mmapped
Message-ID: <20240326102616728-0700.eberman@hu-eberman-lv.qualcomm.com>
Mail-Followup-To: David Hildenbrand <david@redhat.com>, 
	Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Quentin Perret <qperret@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, keirf@google.com, linux-mm@kvack.org
References: <ZeYbUjiIkPevjrRR@google.com>
 <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
 <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com>
 <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
 <ZfjYBxXeh9lcudxp@google.com>
 <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
 <20240319143119.GA2736@willie-the-truck>
 <2d6fc3c0-a55b-4316-90b8-deabb065d007@redhat.com>
 <f8a8c432-728a-4a79-8200-4c3f282ba415@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f8a8c432-728a-4a79-8200-4c3f282ba415@redhat.com>
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 2OXqtWFlBbBoPjgKsgySCdqqML1yUhSt
X-Proofpoint-ORIG-GUID: 2OXqtWFlBbBoPjgKsgySCdqqML1yUhSt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_08,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 mlxscore=0 clxscore=1015
 spamscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2403210001
 definitions=main-2403260158

On Fri, Mar 22, 2024 at 10:21:09PM +0100, David Hildenbrand wrote:
> On 22.03.24 18:52, David Hildenbrand wrote:
> > On 19.03.24 15:31, Will Deacon wrote:
> > > Hi David,
> > 
> > Hi Will,
> > 
> > sorry for the late reply!
> > 
> > > 
> > > On Tue, Mar 19, 2024 at 11:26:05AM +0100, David Hildenbrand wrote:
> > > > On 19.03.24 01:10, Sean Christopherson wrote:
> > > > > On Mon, Mar 18, 2024, Vishal Annapurve wrote:
> > > > > > On Mon, Mar 18, 2024 at 3:02 PM David Hildenbrand <david@redhat.com> wrote:
> > > > > > > Second, we should find better ways to let an IOMMU map these pages,
> > > > > > > *not* using GUP. There were already discussions on providing a similar
> > > > > > > fd+offset-style interface instead. GUP really sounds like the wrong
> > > > > > > approach here. Maybe we should look into passing not only guest_memfd,
> > > > > > > but also "ordinary" memfds.
> > > > > 
> > > > > +1.  I am not completely opposed to letting SNP and TDX effectively convert
> > > > > pages between private and shared, but I also completely agree that letting
> > > > > anything gup() guest_memfd memory is likely to end in tears.
> > > > 
> > > > Yes. Avoid it right from the start, if possible.
> > > > 
> > > > People wanted guest_memfd to *not* have to mmap guest memory ("even for
> > > > ordinary VMs"). Now people are saying we have to be able to mmap it in order
> > > > to GUP it. It's getting tiring, really.
> > > 
> > >   From the pKVM side, we're working on guest_memfd primarily to avoid
> > > diverging from what other CoCo solutions end up using, but if it gets
> > > de-featured (e.g. no huge pages, no GUP, no mmap) compared to what we do
> > > today with anonymous memory, then it's a really hard sell to switch over
> > > from what we have in production. We're also hoping that, over time,
> > > guest_memfd will become more closely integrated with the mm subsystem to
> > > enable things like hypervisor-assisted page migration, which we would
> > > love to have.
> > 
> > Reading Sean's reply, he has a different view on that. And I think
> > that's the main issue: there are too many different use cases and too
> > many different requirements that could turn guest_memfd into something
> > that maybe it really shouldn't be.
> > 
> > > 
> > > Today, we use the existing KVM interfaces (i.e. based on anonymous
> > > memory) and it mostly works with the one significant exception that
> > > accessing private memory via a GUP pin will crash the host kernel. If
> > > all guest_memfd() can offer to solve that problem is preventing GUP
> > > altogether, then I'd sooner just add that same restriction to what we
> > > currently have instead of overhauling the user ABI in favour of
> > > something which offers us very little in return.
> > > 
> > > On the mmap() side of things for guest_memfd, a simpler option for us
> > > than what has currently been proposed might be to enforce that the VMM
> > > has unmapped all private pages on vCPU run, failing the ioctl if that's
> > > not the case. It needs a little more tracking in guest_memfd but I think
> > > GUP will then fall out in the wash because only shared pages will be
> > > mapped by userspace and so GUP will fail by construction for private
> > > pages.
> > > 
> > > We're happy to pursue alternative approaches using anonymous memory if
> > > you'd prefer to keep guest_memfd limited in functionality (e.g.
> > > preventing GUP of private pages by extending mapping_flags as per [1]),
> > > but we're equally willing to contribute to guest_memfd if extensions are
> > > welcome.
> > > 
> > > What do you prefer?
> > 
> > Let me summarize the history:
> > 
> > AMD had its thing running and it worked for them (but I recall it was
> > hacky :) ).
> > 
> > TDX made it possible to crash the machine when accessing secure memory
> > from user space (MCE).
> > 
> > So secure memory must not be mapped into user space -- no page tables.
> > Prototypes with anonymous memory existed (and I didn't hate them,
> > although hacky), but one of the other selling points of guest_memfd was
> > that we could create VMs that wouldn't need any page tables at all,
> > which I found interesting.
> > 
> > There was a bit more to that (easier conversion, avoiding GUP,
> > specifying on allocation that the memory was unmovable ...), but I'll
> > get to that later.
> > 
> > The design principle was: nasty private memory (unmovable, unswappable,
> > inaccessible, un-GUPable) is allocated from guest_memfd, ordinary
> > "shared" memory is allocated from an ordinary memfd.
> > 
> > This makes sense: shared memory is neither nasty nor special. You can
> > migrate it, swap it out, map it into page tables, GUP it, ... without
> > any issues.
> > 
> > 
> > So if I would describe some key characteristics of guest_memfd as of
> > today, it would probably be:
> > 
> > 1) Memory is unmovable and unswappable. Right from the beginning, it is
> >      allocated as unmovable (e.g., not placed on ZONE_MOVABLE, CMA, ...).
> > 2) Memory is inaccessible. It cannot be read from user space, the
> >      kernel, it cannot be GUP'ed ... only some mechanisms might end up
> >      touching that memory (e.g., hibernation, /proc/kcore) might end up
> >      touching it "by accident", and we usually can handle these cases.
> > 3) Memory can be discarded in page granularity. There should be no cases
> >      where you cannot discard memory to over-allocate memory for private
> >      pages that have been replaced by shared pages otherwise.
> > 4) Page tables are not required (well, it's an memfd), and the fd could
> >      in theory be passed to other processes.
> > 
> > Having "ordinary shared" memory in there implies that 1) and 2) will
> > have to be adjusted for them, which kind-of turns it "partially" into
> > ordinary shmem again.
> > 
> > 
> > Going back to the beginning: with pKVM, we likely want the following
> > 
> > 1) Convert pages private<->shared in-place
> > 2) Stop user space + kernel from accessing private memory in process
> >      context. Likely for pKVM we would only crash the process, which
> >      would be acceptable.
> > 3) Prevent GUP to private memory. Otherwise we could crash the kernel.
> > 4) Prevent private pages from swapout+migration until supported.
> > 
> > 
> > I suspect your current solution with anonymous memory gets all but 3)
> > sorted out, correct?
> > 
> > I'm curious, may there be a requirement in the future that shared memory
> > could be mapped into other processes? (thinking vhost-user and such
> > things). Of course that's impossible with anonymous memory; teaching
> > shmem to contain private memory would kind-of lead to ... guest_memfd,
> > just that we don't have shared memory there.
> > 
> 
> I was just thinking of something stupid, not sure if it makes any sense.
> I'll raise it here before I forget over the weekend.
> 
> ... what if we glued one guest_memfd and a memfd (shmem) together in the
> kernel somehow?
> 
> (1) A to-shared conversion moves a page from the guest_memfd to the memfd.
> 
> (2) A to-private conversion moves a page from the memfd to the guest_memfd.
> 
> Only the memfd can be mmap'ed/read/written/GUP'ed. Pages in the memfd behave
> like any shmem pages: migratable, swappable etc.
> 
> 
> Of course, (2) is only possible if the page is not pinned, not mapped (we
> can unmap it). AND, the page must not reside on ZONE_MOVABLE / MIGRATE_CMA.
> 

Quentin gave idea offline of using splice to achieve the conversions.
I'd want to use the in-kernel APIs on page-fault to do the conversion;
not requiring userspace to make the splice() syscall.  One thing splice
currently requires is the source (in) file; KVM UAPI today only gives
userspace address. We could resolve that by for_each_vma_range(). I've
just started looking into splice(), but I believe it takes care of not
pinned and not mapped. guest_memfd would have to migrate the page out of
ZONE_MOVABLE / MIGRATE_CMA.

Does this seem like a good path to pursue further or any other ideas for
doing the conversion?

> We'd have to decide what to do when we access a "hole" in the memfd --
> instead of allocating a fresh page and filling the hole, we'd want to
> SIGBUS.

Since the KVM UAPI is based on userspace addresses and not fds for the
shared memory part, maybe we could add a mmu_notifier_ops that allows
KVM to intercept and reject faults if we couldn't reclaim the memory. I
think it would be conceptually similar to userfaultfd except in the
kernel; not sure if re-using userfaultfd makes sense?

Thanks,
Elliot


