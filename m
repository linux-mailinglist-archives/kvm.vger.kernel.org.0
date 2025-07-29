Return-Path: <kvm+bounces-53645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66D66B150CA
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 18:03:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 684F25478D7
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 16:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76F962980A1;
	Tue, 29 Jul 2025 16:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ImColJVb"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A4818C322
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 16:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753804929; cv=none; b=QGdj7lg3sFHtWn/qmjoWrUGkBjz9NTADK7+Khv8d2y9Zv1/hunaG01VNntxJEmyrIY8/uekCBpYjX56Jvo5Zp/cN117g2qnOn4GV73b05FNGov9v+svjxg+Nag4WEojEWdbK9O4evn/rJRZUh0Q13mpowurG0FeqKLBqoNrUdWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753804929; c=relaxed/simple;
	bh=aVmr87msLMHeWU7gaSV/FB+IensLeUTvlbxOEY6gzH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=olG0wDNMukEPD/ZN5+NCtbX8VwrGojuQ40T+SDFPMlmLKe1B9r8OkTqY9swb2Eizd4Cv2L2bvmQg1To8InJMll5KmH9y1IKHyVfB/sI85Bmh1jrq3pTLubfGqvDGjAGYlrYyrZ5LHEGGiqHjXp43QUxXDYtfKilojelvWCaes5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ImColJVb; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 29 Jul 2025 09:01:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753804913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3B/rfeapbthmIcnLwo9IRZoO1aenCmPbL9oFe6IN3jo=;
	b=ImColJVbfscPb/0mBsz4xbAjxEgoz7J03iLZm5emzMbFd7tEW4nwJWFwO+yaDkSDCKRNW+
	QRNWbLrjWBmhAIk7yxxyhPKzsHURc/4lsFSpfju8uZoL4SK7pXCYLHCFqTkkD4KYg8pHL7
	7MjEmfjLmMnBcVFwhCSsgmv7zLAVNGg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Mingwei Zhang <mizhang@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Destroy the stage-2 page-table
 periodically
Message-ID: <aIjwalITY6CAj7TO@linux.dev>
References: <20250724235144.2428795-1-rananta@google.com>
 <20250724235144.2428795-3-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724235144.2428795-3-rananta@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 24, 2025 at 11:51:44PM +0000, Raghavendra Rao Ananta wrote:
> +/*
> + * Assume that @pgt is valid and unlinked from the KVM MMU to free the
> + * page-table without taking the kvm_mmu_lock and without performing any
> + * TLB invalidations.
> + *
> + * Also, the range of addresses can be large enough to cause need_resched
> + * warnings, for instance on CONFIG_PREEMPT_NONE kernels. Hence, invoke
> + * cond_resched() periodically to prevent hogging the CPU for a long time
> + * and schedule something else, if required.
> + */
> +static void stage2_destroy_range(struct kvm_pgtable *pgt, phys_addr_t addr,
> +			      phys_addr_t end)
> +{
> +	u64 next;
> +
> +	do {
> +		next = stage2_range_addr_end(addr, end);
> +		kvm_pgtable_stage2_destroy_range(pgt, addr, next - addr);
> +
> +		if (next != end)
> +			cond_resched();
> +	} while (addr = next, addr != end);
> +}
> +
> +static void kvm_destroy_stage2_pgt(struct kvm_pgtable *pgt)
> +{
> +	if (!is_protected_kvm_enabled()) {
> +		stage2_destroy_range(pgt, 0, BIT(pgt->ia_bits));
> +		kvm_pgtable_stage2_destroy_pgd(pgt);
> +	} else {
> +		pkvm_pgtable_stage2_destroy(pgt);
> +	}
> +}
> +

Protected mode is affected by the same problem, potentially even worse
due to the overheads of calling into EL2. Both protected and
non-protected flows should use stage2_destroy_range().

Thanks,
Oliver

