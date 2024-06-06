Return-Path: <kvm+bounces-19034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B6088FF4CC
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 20:38:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B12571C256DE
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 18:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A290047F46;
	Thu,  6 Jun 2024 18:38:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E78ED515;
	Thu,  6 Jun 2024 18:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717699095; cv=none; b=f+ecUDygTGAlxer+gzNg3eM51yjJkjjKPxOJBirk5ov0E5LM6Voz8G5hFZCTnM7jd9Tpjlh56r+WdN2AaxmRvDMAy3ovP+s/wphbFjt0x36BUFNS8RmduIGQcEGiztQ46tJEmSWtdAuvIjopTCUPBG/YANBfWLtYMKDzMS38+ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717699095; c=relaxed/simple;
	bh=m4y07AqUVhllB8GdQjGhynxMK/W/hDUwql04aVzrTcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LNZ8LOZPPYiogAdFfff/+rt/wVdrNWO7Sceb2vkKVtgkUvDRlYn9HWd+IOQNWAaPt2b+dkWZgcgC2IklmwjBo7CnCIHWj//a+fjSwa0r14S8SQ6L8vYrW3E1yE/3udBbDLQtSC9dJZpQgDTRRdLC1H0C34F78X2XE3Cs7tOEiOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4CBC2BD10;
	Thu,  6 Jun 2024 18:38:11 +0000 (UTC)
Date: Thu, 6 Jun 2024 19:38:08 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v3 12/14] arm64: realm: Support nonsecure ITS emulation
 shared
Message-ID: <ZmICEN8JvWM7M9Ch@arm.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-13-steven.price@arm.com>
 <86a5jzld9g.wl-maz@kernel.org>
 <4c363476-e5b5-42ff-9f30-a02a92b6751b@arm.com>
 <867cf2l6in.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867cf2l6in.wl-maz@kernel.org>

On Thu, Jun 06, 2024 at 11:17:36AM +0100, Marc Zyngier wrote:
> On Wed, 05 Jun 2024 16:08:49 +0100,
> Steven Price <steven.price@arm.com> wrote:
> > 2. Use a special (global) memory allocator that does the
> > set_memory_decrypted() dance on the pages that it allocates but allows
> > packing the allocations. I'm not aware of an existing kernel API for
> > this, so it's potentially quite a bit of code. The benefit is that it
> > reduces memory consumption in a realm guest, although fragmentation
> > still means we're likely to see a (small) growth.
> > 
> > Any thoughts on what you think would be best?
> 
> I would expect that something similar to kmem_cache could be of help,
> only with the ability to deal with variable object sizes (in this
> case: minimum of 256 bytes, in increments defined by the
> implementation, and with a 256 byte alignment).

Hmm, that's doable but not that easy to make generic. We'd need a new
class of kmalloc-* caches (e.g. kmalloc-decrypted-*) which use only
decrypted pages together with a GFP_DECRYPTED flag or something to get
the slab allocator to go for these pages and avoid merging with other
caches. It would actually be the page allocator parsing this gfp flag,
probably in post_alloc_hook() to set the page decrypted and re-encrypt
it in free_pages_prepare(). A slight problem here is that free_pages()
doesn't get the gfp flag, so we'd need to store some bit in the page
flags. Maybe the flag is not that bad, do we have something like for
page_to_phys() to give us the high IPA address for decrypted pages?

Similarly if we go for a kmem_cache (or a few for multiple sizes). One
can specify a constructor which could set the memory decrypted but
there's no destructor (and also the constructor is per object, not per
page, so we'd need some refcounting).

Another approach contained within the driver is to use mempool_create()
with our own _alloc_fn/_free_fn that sets the memory decrypted/encrypted
accordingly, though sub-page allocations need additional tracking. Also
that's fairly similar to kmem_cache, fixed size.

Yet another option would be to wire it somehow in the DMA API but the
minimum allocation is already a page size, so we don't gain anything.

What gets somewhat closer to what we need is gen_pool. It can track
different sizes, we just need to populate the chunks as needed. I don't
think this would work as a generic allocator but may be good enough
within the ITS code.

If there's a need for such generic allocations in other parts of the
kernel, my preference would be something around kmalloc caches and a new
GFP flag (first option; subject to the selling it to the mm folk). But
that's more of a separate prototyping effort that may or may not
succeed.

Anyway, we could do some hacking around gen_pool as a temporary solution
(maybe as a set of patches on top of this series to be easier to revert)
and start investigating a proper decrypted page allocator in parallel.
We just need to find a victim that has the page allocator fresh in mind
(Ryan or Alexandru ;)).

-- 
Catalin

