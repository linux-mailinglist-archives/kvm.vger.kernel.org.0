Return-Path: <kvm+bounces-17773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BBDE98CA0EC
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 18:54:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F0B6281085
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 16:54:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4D25137C37;
	Mon, 20 May 2024 16:53:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F27ED137930;
	Mon, 20 May 2024 16:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716224024; cv=none; b=IvAyGUeFI/pem6b/RVHQDQ4BOOKZd/JjK47u+vpUkKSWe5cZPzrbtFo+zMgKlHEM5ow45U3TqOK2XkJDgMVJp/Rhryqzgq49YQfSZT/Tn5n3rDBxP2ls8zL62SEcOBhxgME9+IHVJ5Bu3MB9S4eK92Pi5XhS24yf6mxYaw1AyUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716224024; c=relaxed/simple;
	bh=je6uhvv3pMpXo2t4Zi2VWNxun0jFphVijhCZismhTNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IB+ms184lA10iBIXOFHYFdWWD+slG53160+Rw9rdrw9vOSGVOffRvMQFmtBlFYNQ6QG3q7x6N/HrqCLVcwg1UZPuQtggbqBFCaqRH/2IJ9lyjpmFRSs/hqnprkkZc8F6LRLQLkMOEwmJjB1/8VaSeJhVGx+2MTrgqZp/ivxmEK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3A53DA7;
	Mon, 20 May 2024 09:54:04 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 876AC3F641;
	Mon, 20 May 2024 09:53:31 -0700 (PDT)
Date: Mon, 20 May 2024 17:53:25 +0100
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
Subject: Re: [PATCH v2 09/14] arm64: Enable memory encrypt for Realms
Message-ID: <ZkuABQlGgtbzyQFT@arm.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-10-steven.price@arm.com>
 <ZkOmrMIMFCgEKuVw@arm.com>
 <5b2db977-7f0f-4c3a-b278-f195c7ddbd80@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b2db977-7f0f-4c3a-b278-f195c7ddbd80@arm.com>

On Wed, May 15, 2024 at 11:47:02AM +0100, Suzuki K Poulose wrote:
> On 14/05/2024 19:00, Catalin Marinas wrote:
> > On Fri, Apr 12, 2024 at 09:42:08AM +0100, Steven Price wrote:
> > >   static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
> > > @@ -41,6 +45,7 @@ static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
> > >   	pte = clear_pte_bit(pte, cdata->clear_mask);
> > >   	pte = set_pte_bit(pte, cdata->set_mask);
> > > +	/* TODO: Break before make for PROT_NS_SHARED updates */
> > >   	__set_pte(ptep, pte);
> > >   	return 0;
> > 
> > Oh, this TODO is problematic, not sure we can do it safely. There are
> > some patches on the list to trap faults from other CPUs if they happen
> > to access the page when broken but so far we pushed back as complex and
> > at risk of getting the logic wrong.
> > 
> >  From an architecture perspective, you are changing the output address
> > and D8.16.1 requires a break-before-make sequence (FEAT_BBM doesn't
> > help). So we either come up with a way to do BMM safely (stop_machine()
> > maybe if it's not too expensive or some way to guarantee no accesses to
> > this page while being changed) or we get the architecture clarified on
> > the possible side-effects here ("unpredictable" doesn't help).
> 
> Thanks, we need to sort this out.

Thanks for the clarification on RIPAS states and behaviour in one of
your replies. Thinking about this, since the page is marked as
RIPAS_EMPTY prior to changing the PTE, the address is going to fault
anyway as SEA if accessed. So actually breaking the PTE, TLBI, setting
the new PTE would not add any new behaviour. Of course, this assumes
that set_memory_decrypted() is never called on memory being currently
accessed (can we guarantee this?).

So, we need to make sure that there is no access to the linear map
between set_memory_range_shared() and the actual pte update with
__change_memory_common() in set_memory_decrypted(). At a quick look,
this seems to be the case (ignoring memory scrubbers, though dummy ones
just accessing memory are not safe anyway and unlikely to run in a
guest).

(I did come across the hv_uio_probe() which, if I read correctly, it
ends up calling set_memory_decrypted() with a vmalloc() address; let's
pretend this code doesn't exist ;))

-- 
Catalin

