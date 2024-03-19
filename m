Return-Path: <kvm+bounces-12191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21EA488084C
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 00:55:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2C98283C3A
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 23:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CFA45FBAC;
	Tue, 19 Mar 2024 23:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="EPKR0POT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35163FBAF
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 23:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710892509; cv=none; b=geedQq3qGoRp4ilM7gJtNdUUVE/Aj67e8rcKs2MEnv5+aQDwR57Ck5FO6+v36MA0UJY49UJ7J2lODfj+giIGT5BoyWXCmIeErNch1RfSTSwvRhjk5Ic4Oy95GIcQfumKVq+T6y1vCi7X6zaJ8Id6HLws/NgGLQpUch171sjCZZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710892509; c=relaxed/simple;
	bh=LyLfsXArmpaIz1dWIS+ezi31pdNTzLESJRdI9KREBIk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G2bUYRxLetk1d1Q9Hv0ODHPr3XFAVHL/xNkTGaqmCrQgbtyYkxnWx/kNHBYSZM0Dc6+mKID9nOtlPi7K/bpoE8RwPLM5ovg9qBDK1myfPhi3gGl/nUuGBdaooxTbKTyuIb1OuDh31Sy/q1O60xXoJM0pJR1T2/m2PBS2P6EDjek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=EPKR0POT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 42JMfNxS000987;
	Tue, 19 Mar 2024 23:54:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-transfer-encoding:in-reply-to; s=
	qcppdkim1; bh=aeq5QRLdnBnxL7CPkUwlT7Hq5FWu/MXH5rgdftDhMUE=; b=EP
	KR0POTMpUHtBZ6m2OzvR66QXx487ED+ItB/VzztJtiMhmhYv1mupobx0MSesEaWD
	bvgiYbnkdL6T41Ob7m8uuiOKh4kME9BVsw0Kt77FOuZJ+BUzCyuH767UPNN5Nn8Q
	z2zY7A63E5HkxIkwonqY/ffJxNK8vSDfp8Jr8uCAb4IFdJzYAioB9O3aj7c7RmqR
	H0Zzz/cDrAPYvxXhekUjQxE0rVFa7T/eetY3tbyQssKrDUhIMnDWa3YrrZyy5sD8
	YGmDiLJvR/4SnzKN9uCYEcin3dijLJcDKqN9q7f8Ux/f2ggzWq8+TDZHnTYbPEoL
	nFR+IJo9PCVbfdWup7/w==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3wy9ee9qcy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 23:54:13 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 42JNsC0b001314
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 23:54:12 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Tue, 19 Mar 2024 16:54:11 -0700
Date: Tue, 19 Mar 2024 16:54:10 -0700
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
Subject: Re: Re: folio_mmapped
Message-ID: <20240319155648990-0700.eberman@hu-eberman-lv.qualcomm.com>
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
References: <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <ZeXAOit6O0stdxw3@google.com>
 <ZeYbUjiIkPevjrRR@google.com>
 <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
 <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com>
 <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
 <ZfjYBxXeh9lcudxp@google.com>
 <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
 <20240319143119.GA2736@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240319143119.GA2736@willie-the-truck>
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: FEqxfT4Zfq9jRu8C0SNX6rBbDdaZhX_-
X-Proofpoint-ORIG-GUID: FEqxfT4Zfq9jRu8C0SNX6rBbDdaZhX_-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-19_10,2024-03-18_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 impostorscore=0 clxscore=1011 phishscore=0 spamscore=0 suspectscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2403140001 definitions=main-2403190185

On Tue, Mar 19, 2024 at 02:31:19PM +0000, Will Deacon wrote:
> On Tue, Mar 19, 2024 at 11:26:05AM +0100, David Hildenbrand wrote:
> > On 19.03.24 01:10, Sean Christopherson wrote:
> > > On Mon, Mar 18, 2024, Vishal Annapurve wrote:
> > > > On Mon, Mar 18, 2024 at 3:02 PM David Hildenbrand <david@redhat.com> wrote:
> > > > > Second, we should find better ways to let an IOMMU map these pages,
> > > > > *not* using GUP. There were already discussions on providing a similar
> > > > > fd+offset-style interface instead. GUP really sounds like the wrong
> > > > > approach here. Maybe we should look into passing not only guest_memfd,
> > > > > but also "ordinary" memfds.
> > > 
> > > +1.  I am not completely opposed to letting SNP and TDX effectively convert
> > > pages between private and shared, but I also completely agree that letting
> > > anything gup() guest_memfd memory is likely to end in tears.
> > 
> > Yes. Avoid it right from the start, if possible.
> > 
> > People wanted guest_memfd to *not* have to mmap guest memory ("even for
> > ordinary VMs"). Now people are saying we have to be able to mmap it in order
> > to GUP it. It's getting tiring, really.
> 
> From the pKVM side, we're working on guest_memfd primarily to avoid
> diverging from what other CoCo solutions end up using, but if it gets
> de-featured (e.g. no huge pages, no GUP, no mmap) compared to what we do
> today with anonymous memory, then it's a really hard sell to switch over
> from what we have in production. We're also hoping that, over time,
> guest_memfd will become more closely integrated with the mm subsystem to
> enable things like hypervisor-assisted page migration, which we would
> love to have.
> 
> Today, we use the existing KVM interfaces (i.e. based on anonymous
> memory) and it mostly works with the one significant exception that
> accessing private memory via a GUP pin will crash the host kernel. If
> all guest_memfd() can offer to solve that problem is preventing GUP
> altogether, then I'd sooner just add that same restriction to what we
> currently have instead of overhauling the user ABI in favour of
> something which offers us very little in return.

How would we add the restriction to anonymous memory?

Thinking aloud -- do you mean like some sort of "exclusive GUP" flag
where mm can ensure that the exclusive GUP pin is the only pin? If the
refcount for the page is >1, then the exclusive GUP fails. Any future
GUP pin attempts would fail if the refcount has the EXCLUSIVE_BIAS.

> On the mmap() side of things for guest_memfd, a simpler option for us
> than what has currently been proposed might be to enforce that the VMM
> has unmapped all private pages on vCPU run, failing the ioctl if that's
> not the case. It needs a little more tracking in guest_memfd but I think
> GUP will then fall out in the wash because only shared pages will be
> mapped by userspace and so GUP will fail by construction for private
> pages.

We can prevent GUP after the pages are marked private, but the pages
could be marked private after the pages were already GUP'd. I don't have
a good way to detect this, so converting a page to private is difficult.

> We're happy to pursue alternative approaches using anonymous memory if
> you'd prefer to keep guest_memfd limited in functionality (e.g.
> preventing GUP of private pages by extending mapping_flags as per [1]),
> but we're equally willing to contribute to guest_memfd if extensions are
> welcome.
> 
> What do you prefer?
> 

I like this as a stepping stone. For the Android use cases, we don't
need to be able to convert a private page to shared and then also be
able to GUP it. If you want to GUP a page, use anonymous memory and that
memory will always be shared. If you don't care about GUP'ing (e.g. it's
going to be guest-private or you otherwise know you won't be GUP'ing),
you can use guest_memfd.

I don't think this design prevents us from adding "sometimes you can
GUP" to guest_memfd in the future. I don't think it creates extra
changes for KVM since anonymous memory is already supported; although
I'd have to add the support for Gunyah.

> [1] https://lore.kernel.org/r/4b0fd46a-cc4f-4cb7-9f6f-ce19a2d3064e@redhat.com

Thanks,
Elliot


