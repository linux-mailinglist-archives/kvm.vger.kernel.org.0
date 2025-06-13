Return-Path: <kvm+bounces-49431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12417AD8FC9
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:41:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C56A01893D1E
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 14:41:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10CC21D6DB5;
	Fri, 13 Jun 2025 14:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u0SSoTga"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F61019D88F;
	Fri, 13 Jun 2025 14:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749825634; cv=none; b=WEc6o7elpZMGU7BQdRHh/ScAWfky4NUn+qktV/daz1LpANAjx1eQcBFcZyHZ7cEAnCoPYyASFMKHi/e376N2c4Qen18auCKIBGwmmgkMV7+IRAJAuitEc6tWk2Gl59PZTYqOdkbiVaAZ3Z3Zjw17iHUfTY5+Mg8sx0BnjsHXKj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749825634; c=relaxed/simple;
	bh=CH7nTr5IwVC1KQNokMXN8FCbbEIOHzBXmAfmRN7YB5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l3JZ095chhUQtg/68XIODHX5VyknFFljMHeq1/n0cFXU8e0XfoBKX/Oi9sKP4cluNfzy0Vxal2NB60cMzFiEkJL3eEgipFqlrW9RswynXPjqKvpdkvRpfk5Rv8mSwkDcsb16GV69pbW/uUKtiHk/sRH0A+adWlvDcS0oimPEwrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u0SSoTga; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5ADC4CEE3;
	Fri, 13 Jun 2025 14:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749825633;
	bh=CH7nTr5IwVC1KQNokMXN8FCbbEIOHzBXmAfmRN7YB5s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u0SSoTgaAO+dlWR/atirDPk9wUwTuM+3RJWmf/tJRQL0E2XRhlSZqcagL0vhoKfTU
	 4Fim557zSPKuQT29wM4Iflf5R65OxrnBFPvj5BymsmzL7ZXtKMUQ3+wNzbq5TZKSu+
	 qSIbUh6O+Hfx9FkhNv2ogibSnIEOaQT6ssAp8xXFBeIy0+xSfm/K3u6toJ60liUeOU
	 V/W0nefD2HQozu7eDfZMxrifkjUrKfiau7OtMU7mqgHqZnnU94faGYlzSNH2IWw5p9
	 QPVmF58r+kP55im8NRt1AVyODmvRW4C2zZY44d6ueE/EsNhuiXEatUFUjXnFdqsq4t
	 IA0N32/bNx1PA==
Date: Fri, 13 Jun 2025 20:07:16 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, Sairaj Kodilkar <sarunkod@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Joao Martins <joao.m.martins@oracle.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 09/62] KVM: SVM: Drop pointless masking of kernel page
 pa's with AVIC HPA masks
Message-ID: <oflbeygd75owcda6ingafhnsrryswrp2qu3dfbd7z53kdm7u7c@ygarzfhtlo3r>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-11-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611224604.313496-11-seanjc@google.com>

> KVM: SVM: Drop pointless masking of kernel page pa's with AVIC HPA masks
				      ^^^^^^^^^^^^^^^^
Just "physical addresses", or perhaps "HPAs"?

On Wed, Jun 11, 2025 at 03:45:12PM -0700, Sean Christopherson wrote:
> Drop AVIC_HPA_MASK and all its users, the mask is just the 4KiB-aligned
> maximum theoretical physical address for x86-64 CPUs, as x86-64 is
> currently defined (going beyond PA52 would require an entirely new paging
> mode, which would arguably create a new, different architecture).
> 
> All usage in KVM masks the result of page_to_phys(), which on x86-64 is
> guaranteed to be 4KiB aligned and a legal physical address; if either of
> those requirements doesn't hold true, KVM has far bigger problems.
> 
> Drop masking the avic_backing_page with
> AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK for all the same reasons, but
> keep the macro even though it's unused in functional code.  It's a
> distinct architectural define, and having the definition in software
> helps visualize the layout of an entry.  And to be hyper-paranoid about
> MAXPA going beyond 52, add a compile-time assert to ensure the kernel's
> maximum supported physical address stays in bounds.
> 
> The unnecessary masking in avic_init_vmcb() also incorrectly assumes that
> SME's C-bit resides between bits 51:11; that holds true for current CPUs,
> but isn't required by AMD's architecture:
> 
>   In some implementations, the bit used may be a physical address bit
> 
> Key word being "may".
> 
> Opportunistically use the GENMASK_ULL() version for
> AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK, which is far more readable
> than a set of repeating Fs.

Makes sense.
Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>

- Naveen


