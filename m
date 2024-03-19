Return-Path: <kvm+bounces-12145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F06B87FFA2
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 15:31:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50D391F23757
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 14:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47AC8D2F5;
	Tue, 19 Mar 2024 14:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HRbcx+aq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C01A38;
	Tue, 19 Mar 2024 14:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710858692; cv=none; b=iSPUDoP/cB7ACL1X6SdpzO5e/nVOqtex41fqZCzEDzgzBUcCclXhQR1NUzJevGFT5EVRCgNgMngzRhUujhSYroYu/AVlVP902vptrN5CNu+Cdy3BWBhG8J6JPczb/+RTO0nEKzvv4D/KaYpDhDu8ZeuOpYlbIwXCAZZWpy1/l3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710858692; c=relaxed/simple;
	bh=B2nNsMgTQoGiY+9DrWE4Iy06KAEbLYr9Yr2Q6LU9biw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j8XDXFM03tGXqjSkyAMROiX7OGqbd+0xXJ/AHHR2+PGNBbIa+Osu0zacjS5/+D7WQjAkyTnzcBs2wMTlTBaYTzVlk+k4myJGmYSk4hXOj1HGgSWCqh0b6kYEew4qaIaER1r5b72hNcn9NxoDpVMAvpOWQpni9AYZ00ojPa3hRXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HRbcx+aq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538DEC433F1;
	Tue, 19 Mar 2024 14:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710858691;
	bh=B2nNsMgTQoGiY+9DrWE4Iy06KAEbLYr9Yr2Q6LU9biw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HRbcx+aqsnD235Gmo6ZS0BUy+UtZNPrrsIgLfeUIj5FTkXgYhyJnxr8MxTT4KC6P/
	 oaYUBGbaBIjv4yOhLRhNIiDZkB5qsip6SGPmMNK3kUDDcIwcUiLjbl/pj3bkv0zqhP
	 MOubasfq34FoyqnYFT7o2cXA6uKG6crkZJ7FPaq6pCsMqomIA4PO5WJjGqQNFun1O6
	 SdCyBEJ3OsdJCVZIoRF4XAWzNUSI6OmrstURUatt/K65EPKpmzT8T/O10XpbrkBlwd
	 9oMgu48MBrzuWabJbFE/vmYiN00N2b05/XkwNANP6AVRLux3t5Z4+bY+yGcAFtIr2E
	 ELCHEJVtWYo9A==
Date: Tue, 19 Mar 2024 14:31:19 +0000
From: Will Deacon <will@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Quentin Perret <qperret@google.com>,
	Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	viro@zeniv.linux.org.uk, brauner@kernel.org,
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	ackerleytng@google.com, mail@maciej.szmigiero.name,
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
	oliver.upton@linux.dev, maz@kernel.org, keirf@google.com,
	linux-mm@kvack.org
Subject: Re: folio_mmapped
Message-ID: <20240319143119.GA2736@willie-the-truck>
References: <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <ZeXAOit6O0stdxw3@google.com>
 <ZeYbUjiIkPevjrRR@google.com>
 <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
 <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com>
 <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
 <ZfjYBxXeh9lcudxp@google.com>
 <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi David,

On Tue, Mar 19, 2024 at 11:26:05AM +0100, David Hildenbrand wrote:
> On 19.03.24 01:10, Sean Christopherson wrote:
> > On Mon, Mar 18, 2024, Vishal Annapurve wrote:
> > > On Mon, Mar 18, 2024 at 3:02 PM David Hildenbrand <david@redhat.com> wrote:
> > > > Second, we should find better ways to let an IOMMU map these pages,
> > > > *not* using GUP. There were already discussions on providing a similar
> > > > fd+offset-style interface instead. GUP really sounds like the wrong
> > > > approach here. Maybe we should look into passing not only guest_memfd,
> > > > but also "ordinary" memfds.
> > 
> > +1.  I am not completely opposed to letting SNP and TDX effectively convert
> > pages between private and shared, but I also completely agree that letting
> > anything gup() guest_memfd memory is likely to end in tears.
> 
> Yes. Avoid it right from the start, if possible.
> 
> People wanted guest_memfd to *not* have to mmap guest memory ("even for
> ordinary VMs"). Now people are saying we have to be able to mmap it in order
> to GUP it. It's getting tiring, really.

From the pKVM side, we're working on guest_memfd primarily to avoid
diverging from what other CoCo solutions end up using, but if it gets
de-featured (e.g. no huge pages, no GUP, no mmap) compared to what we do
today with anonymous memory, then it's a really hard sell to switch over
from what we have in production. We're also hoping that, over time,
guest_memfd will become more closely integrated with the mm subsystem to
enable things like hypervisor-assisted page migration, which we would
love to have.

Today, we use the existing KVM interfaces (i.e. based on anonymous
memory) and it mostly works with the one significant exception that
accessing private memory via a GUP pin will crash the host kernel. If
all guest_memfd() can offer to solve that problem is preventing GUP
altogether, then I'd sooner just add that same restriction to what we
currently have instead of overhauling the user ABI in favour of
something which offers us very little in return.

On the mmap() side of things for guest_memfd, a simpler option for us
than what has currently been proposed might be to enforce that the VMM
has unmapped all private pages on vCPU run, failing the ioctl if that's
not the case. It needs a little more tracking in guest_memfd but I think
GUP will then fall out in the wash because only shared pages will be
mapped by userspace and so GUP will fail by construction for private
pages.

We're happy to pursue alternative approaches using anonymous memory if
you'd prefer to keep guest_memfd limited in functionality (e.g.
preventing GUP of private pages by extending mapping_flags as per [1]),
but we're equally willing to contribute to guest_memfd if extensions are
welcome.

What do you prefer?

Cheers,

Will

[1] https://lore.kernel.org/r/4b0fd46a-cc4f-4cb7-9f6f-ce19a2d3064e@redhat.com

