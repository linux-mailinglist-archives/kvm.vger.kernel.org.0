Return-Path: <kvm+bounces-9448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CB83E8607C2
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 01:35:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F405B2230A
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 00:35:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A32579DC;
	Fri, 23 Feb 2024 00:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vx0lAI9O"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0573D7F;
	Fri, 23 Feb 2024 00:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708648533; cv=none; b=BaGMQK2GT19P3OBGKFDEQv0zeQ2srRiroCn5pv4Z0WituptNg7f/9wXIROOHuwSv+bWs/dOvkuoUvN1skqM6Gqp1GEMxsqVbEJ7bu1Oyv3PzabsGEGsaGO3BZrjFpnp5d6J7Yi+95grfy52aN8CPMwvhmq9JwmPL1wj7DG5nNUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708648533; c=relaxed/simple;
	bh=UuyemN29n5uuhM3XDRw+M9OmUMLgiLVssyaJZggKbgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XogQ7iGgEmd0nDSXjAqYTLftPahvBtlMTvWgEIT+idEm7GOM8Ah04mamgMF/GjN8zZz6KOXDT82l0i4ZNqHKyGwet3+Xx/veaPynMSFfCdljfeanjjwzMkjBA79dwRT8DCsh32R/JBw5HKnvAsU70DMVCdNJi4cFa8IxkUR9gNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vx0lAI9O; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Jjp0B9J5MnbOQoNMfaQog5UT9Wod0mD1lECH/WlLFiA=; b=vx0lAI9OP3zaj26NbO7YK2kxuL
	rxq6qOocccU9w2yUa/5HMJoRpmtWfr+tBtPwB+CGJECRTiFCjdwO5xc5UdSmb972zkdu7BjD+uqC5
	ubiywajEuHOhv+hTCpDNgKXvOFPOegHcx3eRaKYh0dYMiRr3sKWWbb8Tcxj/kjKgeZAVrAS37kNCX
	4XJgXKFYPlIOre4tzu+X3ZDzObpdTyMo+OiTSRoAwIFiQuempCYRJ0SD+navq/qnVcArmH06rzeed
	1K6vfCbFRmKdh5tUX6xlnrSqGHaBX5Y4ZjeoAnodqK5ny8r16TpruMlihybbAJDlbb6QhIETbTUAl
	/tcoXSJg==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rdJX5-00000005CET-0p6c;
	Fri, 23 Feb 2024 00:35:19 +0000
Date: Fri, 23 Feb 2024 00:35:19 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com,
	viro@zeniv.linux.org.uk, brauner@kernel.org,
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, keirf@google.com
Cc: linux-mm@kvack.org
Subject: folio_mmapped
Message-ID: <ZdfoR3nCEP3HTtm1@casper.infradead.org>
References: <20240222161047.402609-1-tabba@google.com>
 <20240222141602976-0800.eberman@hu-eberman-lv.qualcomm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240222141602976-0800.eberman@hu-eberman-lv.qualcomm.com>

On Thu, Feb 22, 2024 at 03:43:56PM -0800, Elliot Berman wrote:
> > This creates the situation where access to successfully mmap()'d
> > memory might SIGBUS at page fault. There is precedence for
> > similar behavior in the kernel I believe, with MADV_HWPOISON and
> > the hugetlbfs cgroups controller, which could SIGBUS at page
> > fault time depending on the accounting limit.
> 
> I added a test: folio_mmapped() [1] which checks if there's a vma
> covering the corresponding offset into the guest_memfd. I use this
> test before trying to make page private to guest and I've been able to
> ensure that userspace can't even mmap() private guest memory. If I try
> to make memory private, I can test that it's not mmapped and not allow
> memory to become private. In my testing so far, this is enough to
> prevent SIGBUS from happening.
> 
> This test probably should be moved outside Gunyah specific code, and was
> looking for maintainer to suggest the right home for it :)
> 
> [1]: https://lore.kernel.org/all/20240222-gunyah-v17-20-1e9da6763d38@quicinc.com/

You, um, might have wanted to send an email to linux-mm, not bury it in
the middle of a series of 35 patches?

So this isn't folio_mapped() because you're interested if anyone _could_
fault this page, not whether the folio is currently present in anyone's
page tables.

It's like walk_page_mapping() but with a trivial mm_walk_ops; not sure
it's worth the effort to use walk_page_mapping(), but I would defer to
David.

