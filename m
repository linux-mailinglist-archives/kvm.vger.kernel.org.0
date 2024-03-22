Return-Path: <kvm+bounces-12523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 386D9887359
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 19:47:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA13E1F22A0F
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 18:47:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 355D76F08C;
	Fri, 22 Mar 2024 18:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Tw2OjtgO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AAB6E60D
	for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 18:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711133247; cv=none; b=UOWiUlG82Jh+tlE4KA3NsTwVjcB+7D+62W6r0kkD5DNxUeEnyrjli+7nU0uM4o61ccswGa/7YvRMf3x7zRakatguC+jZS1jQd3IAFU7VPK/5MKKLuQj1bpYWQeXVJF4T5kx7nbkKuFCflHvujqFIYoTvQXYN8D/AdepDg7XTLuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711133247; c=relaxed/simple;
	bh=yLasx7ugjnbHtxzYsdod1oyAUG0e2zmPgE7e4gE2eoE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VIPnnSTQrf9T5q0wxfDsUvGpXs2BMbGHSWYPmefprfmpXgjCxm2pUJ7IHZItj3h3YOuI9YvpGb4ki2FzcRl6lMph8NKsY64epyqP+Z4ncGwJDWMfoFXj2HFQ66PCMF2Et+4OXUhw2EaQBhKVqBBY0kLxnOQsbNtALF7sj3BaZh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Tw2OjtgO; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 42MBQklN024736;
	Fri, 22 Mar 2024 18:46:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	date:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=qcppdkim1; bh=d9aPd7iDjqttzRs468Xk9
	dTSHBIOlc/IfTxqCu9i+pI=; b=Tw2OjtgOb88MSB3+gu+9gYRUUQsGeYp2sUiz6
	JptKVzKgAB0yW1Pk0Y3rT3qHOFdSKBhTuXro+vvk5CLuY+XaU3lmHkkiWtvXSf2h
	LDBZciCrlnW3F+4+QrZJnhEPyf4vRxhw9XH9XOySQ3eTuRwq0yJvowB1ZlTcccOR
	JiC20aPuODkiRrIj/mV+FSDJ7irYvx+GZttBXrK2mywMbPM3PhylwblmQ4gbGNn1
	tOLi56EiM+LktAlk5BLUKRhTUlC95zYwRUMut9Fmws4PZ8y8ECdgvPUmPPEjZ96o
	JA+okuyyPT1nfLSU5ASBRKFMFuBpivSSdh9OMDskBUtnXXs2Q==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3x0wy8u13q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Mar 2024 18:46:26 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 42MIkCWQ032407
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Mar 2024 18:46:12 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Fri, 22 Mar 2024 11:46:10 -0700
Date: Fri, 22 Mar 2024 11:46:10 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
To: Will Deacon <will@kernel.org>
CC: David Hildenbrand <david@redhat.com>,
        Sean Christopherson
	<seanjc@google.com>,
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
Subject: Re: Re: Re: folio_mmapped
Message-ID: <20240322111214274-0700.eberman@hu-eberman-lv.qualcomm.com>
Mail-Followup-To: Will Deacon <will@kernel.org>, 
	David Hildenbrand <david@redhat.com>, Sean Christopherson <seanjc@google.com>, 
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
 <20240319155648990-0700.eberman@hu-eberman-lv.qualcomm.com>
 <20240322163654.GG5634@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240322163654.GG5634@willie-the-truck>
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 4Iv94yt67x3r7p0CElbDGTl-2mqX9tDX
X-Proofpoint-GUID: 4Iv94yt67x3r7p0CElbDGTl-2mqX9tDX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-22_11,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2403210001 definitions=main-2403220135

On Fri, Mar 22, 2024 at 04:36:55PM +0000, Will Deacon wrote:
> Hi Elliot,
> 
> On Tue, Mar 19, 2024 at 04:54:10PM -0700, Elliot Berman wrote:
> > On Tue, Mar 19, 2024 at 02:31:19PM +0000, Will Deacon wrote:
> > > On Tue, Mar 19, 2024 at 11:26:05AM +0100, David Hildenbrand wrote:
> > > > On 19.03.24 01:10, Sean Christopherson wrote:
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
> > > From the pKVM side, we're working on guest_memfd primarily to avoid
> > > diverging from what other CoCo solutions end up using, but if it gets
> > > de-featured (e.g. no huge pages, no GUP, no mmap) compared to what we do
> > > today with anonymous memory, then it's a really hard sell to switch over
> > > from what we have in production. We're also hoping that, over time,
> > > guest_memfd will become more closely integrated with the mm subsystem to
> > > enable things like hypervisor-assisted page migration, which we would
> > > love to have.
> > > 
> > > Today, we use the existing KVM interfaces (i.e. based on anonymous
> > > memory) and it mostly works with the one significant exception that
> > > accessing private memory via a GUP pin will crash the host kernel. If
> > > all guest_memfd() can offer to solve that problem is preventing GUP
> > > altogether, then I'd sooner just add that same restriction to what we
> > > currently have instead of overhauling the user ABI in favour of
> > > something which offers us very little in return.
> > 
> > How would we add the restriction to anonymous memory?
> > 
> > Thinking aloud -- do you mean like some sort of "exclusive GUP" flag
> > where mm can ensure that the exclusive GUP pin is the only pin? If the
> > refcount for the page is >1, then the exclusive GUP fails. Any future
> > GUP pin attempts would fail if the refcount has the EXCLUSIVE_BIAS.
> 
> Yes, I think we'd want something like that, but I don't think using a
> bias on its own is a good idea as false positives due to a large number
> of page references will then actually lead to problems (i.e. rejecting
> GUP spuriously), no? I suppose if you only considered the new bias in
> conjunction with the AS_NOGUP flag you proposed then it might be ok
> (i.e. when you see the bias, you then go check the address space to
> confirm). What do you think?
> 

I think the AS_NOGUP would prevent GUPing the first place. If we set the
EXCLUSIVE_BIAS value to something like INT_MAX, do we need to be worried
about there being INT_MAX-1 valid GUPs and wanting to add another?  From
the GUPer's perspective, I don't think it would be much different from
overflowing the refcount.

> > > On the mmap() side of things for guest_memfd, a simpler option for us
> > > than what has currently been proposed might be to enforce that the VMM
> > > has unmapped all private pages on vCPU run, failing the ioctl if that's
> > > not the case. It needs a little more tracking in guest_memfd but I think
> > > GUP will then fall out in the wash because only shared pages will be
> > > mapped by userspace and so GUP will fail by construction for private
> > > pages.
> > 
> > We can prevent GUP after the pages are marked private, but the pages
> > could be marked private after the pages were already GUP'd. I don't have
> > a good way to detect this, so converting a page to private is difficult.
> 
> For anonymous memory, marking the page as private is going to involve an
> exclusive GUP so that the page can safely be donated to the guest. In
> that case, any existing GUP pin should cause that to fail gracefully.
> What is the situation you are concerned about here?
> 

I wasn't thinking about exclusive GUP here. The exclusive GUP should be
able to get the guarantees we need.

I was thinking about making sure we gracefully handle a race to provide
the same page. The kernel should detect the difference between "we're
already providing the page" and "somebody has an unexpected pin". We can
easily read the refcount if we couldn't take the exclusive pin to know.

Thanks,
Elliot

> > > We're happy to pursue alternative approaches using anonymous memory if
> > > you'd prefer to keep guest_memfd limited in functionality (e.g.
> > > preventing GUP of private pages by extending mapping_flags as per [1]),
> > > but we're equally willing to contribute to guest_memfd if extensions are
> > > welcome.
> > > 
> > > What do you prefer?
> > > 
> > 
> > I like this as a stepping stone. For the Android use cases, we don't
> > need to be able to convert a private page to shared and then also be
> > able to GUP it.
> 
> I wouldn't want to rule that out, though. The VMM should be able to use
> shared pages just like it can with normal anonymous pages.
> 
> > I don't think this design prevents us from adding "sometimes you can
> > GUP" to guest_memfd in the future.
> 
> Technically, I think we can add all the stuff we need to guest_memfd,
> but there's a desire to keep that as simple as possible for now, which
> is why I'm keen to explore alternatives to unblock the pKVM upstreaming.
> 
> Will
> 

