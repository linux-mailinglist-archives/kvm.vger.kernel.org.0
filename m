Return-Path: <kvm+bounces-17831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99E348CABD4
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 12:17:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB7211C21810
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 10:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19D477C097;
	Tue, 21 May 2024 10:14:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C54E71B4F;
	Tue, 21 May 2024 10:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716286463; cv=none; b=F11vOt5+3xVEIuLIQFS8WrhfJ6IJDW4nWXXofYp/fa7lk942W9wEe/+GggRw9soAk5SRSzfjaCIACl3MbZobeIr3b7cTSVof/fqD2W4YdnUt46y4+jUFxoJ9EhDXSt/XSHaeH4Jjl+fmmyFJnQ6pWiznWJ3P0Z0esU3Q9l65AG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716286463; c=relaxed/simple;
	bh=S+wZXg5uTKAmZeL4zCJdXSkIvMKrrXSNrng1U4wro3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FzI0gtfirjkzaC6pnJfEOjPMXhTGT3DtJaNKv9sv/Da0mLEmaIT0li7jRj/U7PwYw0umKe3JunIo5eSghSAvZSkE969sk95TqZfaY0L95NdEnyVN1ZQ7RKehX7wYJbjzo36Af6PCXTO25lMvg3LrTTK5zIC8vFAxF9AafOXqAn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E364EC4AF09;
	Tue, 21 May 2024 10:14:19 +0000 (UTC)
Date: Tue, 21 May 2024 11:14:17 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Michael Kelley <mhklinux@outlook.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
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
Subject: Re: [PATCH v2 09/14] arm64: Enable memory encrypt for Realms
Message-ID: <Zkxz-QfzUM_D0SAm@arm.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-10-steven.price@arm.com>
 <ZkOmrMIMFCgEKuVw@arm.com>
 <5b2db977-7f0f-4c3a-b278-f195c7ddbd80@arm.com>
 <ZkuABQlGgtbzyQFT@arm.com>
 <SN6PR02MB41578D7BFEDE33BD2E8246EFD4E92@SN6PR02MB4157.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR02MB41578D7BFEDE33BD2E8246EFD4E92@SN6PR02MB4157.namprd02.prod.outlook.com>

On Mon, May 20, 2024 at 08:32:43PM +0000, Michael Kelley wrote:
> From: Catalin Marinas <catalin.marinas@arm.com> Sent: Monday, May 20, 2024 9:53 AM
> > > > On Fri, Apr 12, 2024 at 09:42:08AM +0100, Steven Price wrote:
> > > > >   static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
> > > > > @@ -41,6 +45,7 @@ static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
> > > > >   	pte = clear_pte_bit(pte, cdata->clear_mask);
> > > > >   	pte = set_pte_bit(pte, cdata->set_mask);
> > > > > +	/* TODO: Break before make for PROT_NS_SHARED updates */
> > > > >   	__set_pte(ptep, pte);
> > > > >   	return 0;
[...]
> > Thanks for the clarification on RIPAS states and behaviour in one of
> > your replies. Thinking about this, since the page is marked as
> > RIPAS_EMPTY prior to changing the PTE, the address is going to fault
> > anyway as SEA if accessed. So actually breaking the PTE, TLBI, setting
> > the new PTE would not add any new behaviour. Of course, this assumes
> > that set_memory_decrypted() is never called on memory being currently
> > accessed (can we guarantee this?).
> 
> While I worked on CoCo VM support on Hyper-V for x86 -- both AMD
> SEV-SNP and Intel TDX, I haven't ramped up on the ARM64 CoCo
> VM architecture yet.  With that caveat in mind, the assumption is that callers
> of set_memory_decrypted() and set_memory_encrypted() ensure that
> the target memory isn't currently being accessed.   But there's a big
> exception:  load_unaligned_zeropad() can generate accesses that the
> caller can't control.  If load_unaligned_zeropad() touches a page that is
> in transition between decrypted and encrypted, a SEV-SNP or TDX architectural
> fault could occur.  On x86, those fault handlers detect this case, and
> fix things up.  The Hyper-V case requires a different approach, and marks
> the PTEs as "not present" before initiating a transition between decrypted
> and encrypted, and marks the PTEs "present" again after the transition.

Thanks. The load_unaligned_zeropad() case is a good point. I thought
we'd get away with this on arm64 since accessing such decrypted page
would trigger a synchronous exception but looking at the code, the
do_sea() path never calls fixup_exception(), so we just kill the whole
kernel.

> This approach causes a reference generated by load_unaligned_zeropad() 
> to take the normal page fault route, and use the page-fault-based fixup for
> load_unaligned_zeropad(). See commit 0f34d11234868 for the Hyper-V case.

I think for arm64 set_memory_decrypted() (and encrypted) would have to
first make the PTE invalid, TLBI, set the RIPAS_EMPTY state, set the new
PTE. Any page fault due to invalid PTE would be handled by the exception
fixup in load_unaligned_zeropad(). This way we wouldn't get any
synchronous external abort (SEA) in standard uses. Not sure we need to
do anything hyper-v specific as in the commit above.

> > (I did come across the hv_uio_probe() which, if I read correctly, it
> > ends up calling set_memory_decrypted() with a vmalloc() address; let's
> > pretend this code doesn't exist ;))
> 
> While the Hyper-V UIO driver is perhaps a bit of an outlier, the Hyper-V
> netvsc driver also does set_memory_decrypted() on 16 Mbyte vmalloc()
> allocations, and there's not really a viable way to avoid this. The
> SEV-SNP and TDX code handles this case.   Support for this case will
> probably also be needed for CoCo guests on Hyper-V on ARM64.

Ah, I was hoping we can ignore it. So the arm64 set_memory_*() code will
have to detect and change both the vmalloc map and the linear map.
Currently this patchset assumes the latter only.

Such buffers may end up in user space as well but I think at the
set_memory_decrypted() call there aren't any such mappings and
subsequent remap_pfn_range() etc. would handle the permissions properly
through the vma->vm_page_prot attributes (assuming that someone set
those pgprot attributes).

-- 
Catalin

