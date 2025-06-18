Return-Path: <kvm+bounces-49894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99275ADF6D5
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 21:27:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 014763BD5D0
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 19:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4168120F09C;
	Wed, 18 Jun 2025 19:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vwAk49Nj"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A673085D8
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 19:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750274821; cv=none; b=to5MZOS1OhA4NwwOsB72tBDOf37gWArRskkdnx2iKfeCZhU8GuFxBTj5iJZ+CEJ/h72ed9H06K56dNoS2Y5OSomu5XsYmr/Ag1u/1vyLpahvXadfnaFxTVmRiaoMjRAa7h0wG7x7MrzXdeMFlfZQlKK9DCrcjYot4AzA+boGdho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750274821; c=relaxed/simple;
	bh=BmpaZojqlkp5CZbuaO4SWNRCWlhia+3MfHgMdSMsbXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YF5TQFLZvoKf3BzJ6AC8JfQkMzi6dMSuOxfcY/tMMQru7SCr0N1gpayPbPZJRQ/CagaThDRv9T0Lt+BHAun4Ns+Ogj7VGPDNgcQsi6MhbVA0pIe+5PQgY84SQfY77FYQeAMDJ+UpSNpJp/WRJRzq4Zqt7jbjj5rvDqF1JtTE9bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vwAk49Nj; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 18 Jun 2025 12:26:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750274806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gOwQ+Auu3tsNtr8PtwyJWf1qBPBbP0g86Uhe8F7OmW4=;
	b=vwAk49NjoH5esinO7DkuB3fKptPSt0JKN4BgTnq97A9HXw7rW6Z24EpSOdFjjojn0CaJup
	xH1HWIJdPjgd0DlKBGszFyJkTlLCN3pEhcUgJcztyVAXW1pdpnub4z+j8D73WRlw3BCZHE
	ZuhB2mVxiTyH1dlKeU0g8gXQes0WsrM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Anish Moorthy <amoorthy@google.com>,
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 02/15] KVM: arm64: Add "struct kvm_page_fault" to
 gather common fault variables
Message-ID: <aFMS4O2TkWN8nexY@linux.dev>
References: <20250618042424.330664-1-jthoughton@google.com>
 <20250618042424.330664-3-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618042424.330664-3-jthoughton@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 18, 2025 at 04:24:11AM +0000, James Houghton wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Introduce "struct kvm_page_fault" and use it in user_mem_abort() in lieu
> of a collection of local variables.  Providing "struct kvm_page_fault"
> will allow common KVM to provide APIs to take in said structure, e.g. when
> preparing memory fault exits.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  9 +++++++++
>  arch/arm64/kvm/mmu.c              | 32 +++++++++++++++++--------------
>  2 files changed, 27 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 6ce2c51734820..ae83d95d11b74 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -413,6 +413,15 @@ struct kvm_vcpu_fault_info {
>  	u64 disr_el1;		/* Deferred [SError] Status Register */
>  };
>  
> +struct kvm_page_fault {
> +	const bool exec;
> +	const bool write;
> +	const bool is_private;
> +
> +	gfn_t gfn;
> +	struct kvm_memory_slot *slot;
> +};
> +

So this seems to cherry-pick "interesting" values into the structure but
leaves the rest of the abort context scattered about in locals. If we're
going to do something like this I'd rather have a wholesale refactoring
than just the bits to intersect with x86 (more on that later...)

Thanks,
Oliver

