Return-Path: <kvm+bounces-53644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A273B15089
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 17:57:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1AB627A4F9F
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 15:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CF0D2980A8;
	Tue, 29 Jul 2025 15:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qDhRQfbv"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCED81749
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 15:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753804666; cv=none; b=huoeD5/Ln1rOtEiO9tCOmnCaFAER5cmzNhgJOSdf5cD5GRpKRf3rSQNYIhWdrbIuoacoG1xZPG//c0wrMYwXXx6T5Bb6a6F82KqHhr2oW+UiJon3SqUjjE2bpYUN0Lobn8xM1MWx3lfqXKPb47txm48xKJUmkeoWB/UNEhUQEOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753804666; c=relaxed/simple;
	bh=YXXZKgxOwczQAtO2pLH8Ur8i1n4oleBXkSrXNhgJ48g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=igwP2vmtTvVuswAStbg7wAeUKGI81k921Gg9PfEyn7fNSm/l8nytqIZlgL83jpjtYXdwuDRtQrtjkMmUz/Bl8gnlMqLk6V3aK+1iy/VHCG9+fJryFY+a+YZTUgTmcftyoIIIhh7He/k0K6KA19FicgUC5zVdiJ1emMcOVhYg24Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qDhRQfbv; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 29 Jul 2025 08:57:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753804650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Wlri4TImGK2Nq390bQXaKqOdz2FIIALuCIDn8HJtVIo=;
	b=qDhRQfbvrQnB679V2u+y99NiCS4UGBDkb4hEi9ISnukmWBAlHwk4ngyyadfiZN6JcuEl2g
	4TyqTbHXhqxPDRTeuhIgq71qJUptKzeOs9D52DBosEAlZs1O8d6w454t2nd7vEqRhBZ4mD
	E5xPMb3TNhQ32Wwtr0RlB8jimsDkfhc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Mingwei Zhang <mizhang@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Split kvm_pgtable_stage2_destroy()
Message-ID: <aIjvYl474_6F9d9P@linux.dev>
References: <20250724235144.2428795-1-rananta@google.com>
 <20250724235144.2428795-2-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724235144.2428795-2-rananta@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 24, 2025 at 11:51:43PM +0000, Raghavendra Rao Ananta wrote:
> Split kvm_pgtable_stage2_destroy() into two:
>   - kvm_pgtable_stage2_destroy_range(), that performs the
>     page-table walk and free the entries over a range of addresses.
>   - kvm_pgtable_stage2_destroy_pgd(), that frees the PGD.
> 
> This refactoring enables subsequent patches to free large page-tables
> in chunks, calling cond_resched() between each chunk, to yield the CPU
> as necessary.
> 
> Direct callers of kvm_pgtable_stage2_destroy() will continue to walk
> the entire range of the VM as before, ensuring no functional changes.
> 
> Also, add equivalent pkvm_pgtable_stage2_*() stubs to maintain 1:1
> mapping of the page-table functions.

Uhh... We can't stub these functions out for protected mode, we already
have a load-bearing implementation of pkvm_pgtable_stage2_destroy().
Just reuse what's already there and provide a NOP for
pkvm_pgtable_stage2_destroy_pgd().

> +void kvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
> +{
> +	/*
> +	 * We aren't doing a pgtable walk here, but the walker struct is needed
> +	 * for kvm_dereference_pteref(), which only looks at the ->flags.
> +	 */
> +	struct kvm_pgtable_walker walker = {0};

This feels subtle and prone for error. I'd rather we have something that
boils down to rcu_dereference_raw() (with the appropriate n/hVHE awareness)
and add a comment why it is safe.

> +void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
> +{
> +	kvm_pgtable_stage2_destroy_range(pgt, 0, BIT(pgt->ia_bits));
> +	kvm_pgtable_stage2_destroy_pgd(pgt);
> +}
> +

Move this to mmu.c as a static function and use KVM_PGT_FN()

Thanks,
Oliver

