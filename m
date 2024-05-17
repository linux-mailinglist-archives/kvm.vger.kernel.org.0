Return-Path: <kvm+bounces-17588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B188C83B9
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 11:35:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 850EC1F235A7
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 09:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAD883A28E;
	Fri, 17 May 2024 09:34:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C832E40D;
	Fri, 17 May 2024 09:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715938446; cv=none; b=tYN99cBesEZ27cDs0XFxVXO65PdPV4UzCo1SbW9G5F6faUsz6UqcUVcO8vOSik3eg9MQBwaVD2rqoMRHOyt4w/NdxPSwb8w00v9hCh46Pjy4aDFzAjS2EErJItvXE1fuVOnf+ZHmtyAiN3mHHZsBtXdSB8WNRSj+eG7SssXutyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715938446; c=relaxed/simple;
	bh=RJVwbXiVXMNHdFgcxkWovVgZblbHMFIR4uz+RoxIR4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kd7ZvDXuaacgXiAM3TlwkI3DV2t02TtpvrN5uWirU21ln41KOgjLIdxfOswXZYA+SiUoEdjxTNlEwCS2bQ9EqzoKw0QtO0k1wgKD9iXfNIi8f9u3jdH44WTwp30P5xdWa2bzv9z07eUfPsUx3den3szWVdOrw4yJS0mLMgfbZWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2945C32786;
	Fri, 17 May 2024 09:34:02 +0000 (UTC)
Date: Fri, 17 May 2024 10:34:00 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v2 10/14] arm64: Force device mappings to be non-secure
 shared
Message-ID: <ZkckiCiv1kzM0oCK@arm.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-11-steven.price@arm.com>
 <ZkR535Hmh3WkMYai@arm.com>
 <4e89f047-ae70-43a8-a459-e375ca05b2c2@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e89f047-ae70-43a8-a459-e375ca05b2c2@arm.com>

On Wed, May 15, 2024 at 12:00:49PM +0100, Suzuki K Poulose wrote:
> On 15/05/2024 10:01, Catalin Marinas wrote:
> > On Fri, Apr 12, 2024 at 09:42:09AM +0100, Steven Price wrote:
> > > From: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > 
> > > Device mappings (currently) need to be emulated by the VMM so must be
> > > mapped shared with the host.
> > 
> > You say "currently". What's the plan when the device is not emulated?
> > How would the guest distinguish what's emulated and what's not to avoid
> > setting the PROT_NS_SHARED bit?
> 
> Arm CCA plans to add support for passing through real devices,
> which support PCI-TDISP protocol. This would involve the Realm
> authenticating the device and explicitly requesting "protected"
> mapping *after* the verification (with the help of RMM).

I'd have to do some reading, no clue how this works.

> > > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > > index f5376bd567a1..db71c564ec21 100644
> > > --- a/arch/arm64/include/asm/pgtable.h
> > > +++ b/arch/arm64/include/asm/pgtable.h
> > > @@ -598,7 +598,7 @@ static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
> > >   #define pgprot_writecombine(prot) \
> > >   	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_NC) | PTE_PXN | PTE_UXN)
> > >   #define pgprot_device(prot) \
> > > -	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_PXN | PTE_UXN)
> > > +	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_PXN | PTE_UXN | PROT_NS_SHARED)
> > 
> > This pgprot_device() is not the only one used to map device resources.
> > pgprot_writecombine() is another commonly macro. It feels like a hack to
> > plug one but not the other and without any way for the guest to figure
> > out what's emulated.
> 
> Agree. I have been exploring hooking this into ioremap_prot() where we
> could apply the attribute accordingly. We will change it in the next
> version.

pgprot_* at least has the advantage that it covers other places.
ioremap_prot() would handle the kernel mappings but you have devices
mapped in user-space via remap_pfn_range() for example. The protection
bits may come from dma_pgprot() with either write-combine or cacheable
attributes. One may map device I/O as well (not sure what DPDK does). We
could restrict those to protected devices but we need to go through the
use-cases.

All this needs some thinking, especially if at some point we'll have
protected devices. Just hijacking the low-level pgprot macros doesn't
feel like a great approach.

> > Can the DT actually place those emulated ranges in the higher IPA space
> > so that we avoid randomly adding this attribute for devices?
> 
> It can, but then we kind of break the "Realm" view of the IPA space. i.e.,
> right now it only knows about the "lower IPA" half and uses the top bit as a
> protection attr to access the IPA as shared.
> 
> Expanding IPA size view kind of breaks "sharing memory", where, we
> must "use a different PA" for a page that is now shared.

True, I did not realise that the IPA split is transparent to the host.

An option would be additional DT/ACPI attributes for those devices.
That's not great either though as we can't handle those attributes in
the arch code only and probably we don't want to change generic drivers.

Yet another option would be to query the RMM somehow.

-- 
Catalin

