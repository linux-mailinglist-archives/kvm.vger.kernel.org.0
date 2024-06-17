Return-Path: <kvm+bounces-19793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C4AC90B570
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 17:56:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 936C81C2094F
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 15:56:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5E113D8AE;
	Mon, 17 Jun 2024 15:43:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E752B9A0;
	Mon, 17 Jun 2024 15:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718639016; cv=none; b=DJQlKEY/mnVJuB7FS6YqPBwz6xaHTI6FsLWJaWu2ZR11xchR/V7ms2p8ffBtRZ3vQwdNk8nDjVKoMcE2T3rtQBMMvHThi54Hx6aUDk11ycVbJC1HiqxoNfLDzvRji5HWGh7g0/6Fhl7pAlSmuV0t2YceDTPE3pXVHraf9pHH7nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718639016; c=relaxed/simple;
	bh=m0V8kQAJX78JymfCuimEezFCVSUbGSJ913r0go/UaNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kg+ucXJEcAWvk0lIycePTYm770GVY60HxdRVv6lqUGMJiKSg4lOU+Zmblv3VaVM7fg8ri4z74lW5rLTZLWANEWjkHi8apAGQCWUxUQubpQKlFf5ITwClp7mspY21szsQWsKs8U4R2TXJoVWAO7EX6hG1QX3ZnlroX1o9zJCok3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90818C2BD10;
	Mon, 17 Jun 2024 15:43:32 +0000 (UTC)
Date: Mon, 17 Jun 2024 16:43:30 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Michael Kelley <mhklinux@outlook.com>,
	Steven Price <steven.price@arm.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v3 10/14] arm64: Force device mappings to be non-secure
 shared
Message-ID: <ZnBZostHhjqn6uym@arm.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-11-steven.price@arm.com>
 <SN6PR02MB4157D26A6CE9B3B96032A1D1D4CD2@SN6PR02MB4157.namprd02.prod.outlook.com>
 <1dd92421-8eba-48db-99da-4390d9e19abd@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1dd92421-8eba-48db-99da-4390d9e19abd@arm.com>

On Mon, Jun 17, 2024 at 03:55:22PM +0100, Suzuki K Poulose wrote:
> On 17/06/2024 04:33, Michael Kelley wrote:
> > From: Steven Price <steven.price@arm.com> Sent: Wednesday, June 5, 2024 2:30 AM
> > > 
> > > From: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > 
> > > Device mappings (currently) need to be emulated by the VMM so must be
> > > mapped shared with the host.
> > > 
> > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > Signed-off-by: Steven Price <steven.price@arm.com>
> > > ---
> > >   arch/arm64/include/asm/pgtable.h | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > > index 11d614d83317..c986fde262c0 100644
> > > --- a/arch/arm64/include/asm/pgtable.h
> > > +++ b/arch/arm64/include/asm/pgtable.h
> > > @@ -644,7 +644,7 @@ static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
> > >   #define pgprot_writecombine(prot) \
> > >   	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_NC) | PTE_PXN | PTE_UXN)
> > >   #define pgprot_device(prot) \
> > > -	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_PXN | PTE_UXN)
> > > +	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_PXN | PTE_UXN | PROT_NS_SHARED)
> > >   #define pgprot_tagged(prot) \
> > >   	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_TAGGED))
> > >   #define pgprot_mhp	pgprot_tagged
> > 
> > In v2 of the patches, Catalin raised a question about the need for
> > pgprot_decrypted(). What was concluded? It still looks to me like
> > pgprot_decrypted() and prot_encrypted() are needed, by
> > dma_direct_mmap() and remap_oldmem_pfn_range(), respectively.
> > Also, assuming Hyper-V supports CCA at some point, the Linux guest
> > drivers for Hyper-V need pgprot_decrypted() in hv_ringbuffer_init().
> 
> Right, I think we could simply do :
> 
> diff --git a/arch/arm64/include/asm/pgtable.h
> b/arch/arm64/include/asm/pgtable.h
> index c986fde262c0..1ed45893d1e6 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -648,6 +648,10 @@ static inline void set_pud_at(struct mm_struct *mm,
> unsigned long addr,
>  #define pgprot_tagged(prot) \
>         __pgprot_modify(prot, PTE_ATTRINDX_MASK,
> PTE_ATTRINDX(MT_NORMAL_TAGGED))
>  #define pgprot_mhp     pgprot_tagged
> +
> +#define pgprot_decrypted(prot) __pgprot_modify(prot, PROT_NS_SHARED, PROT_NS_SHARED)
> +#define pgprot_encrypted(prot)  __pgprot_modify(prot, PROT_NS_SHARED, 0)

And maybe rewrite pgprot_device() as:

#define __pgprot_device(prot) \
	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_PXN | PTE_UXN)
#define pgprot_device(prot)	__pgprot_device(pgprot_decrypted(prot))

-- 
Catalin

