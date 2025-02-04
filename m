Return-Path: <kvm+bounces-37235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C279A27317
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 14:44:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1833B7A1360
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 13:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD9DB211A2B;
	Tue,  4 Feb 2025 13:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hkzqvrel"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA35D2116FD
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 13:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738675245; cv=none; b=ehuiNTRxDpLuvOgf8yrt1wz7KE/31mRC5u9MaN3gy2PnLFpSy8trg14E0ihBnUimyMjYsrVyRkZHTTSc8AKasIiMBCwVy2eB6vw18JD+ik48XfqoDFvRKOqmKoeRCUttqYzUefz0W3dd1b6HohAqGwCGGmxMt/iHg9fvVxVMGME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738675245; c=relaxed/simple;
	bh=ntAyfzM5IyogmTi+wUQoTNdrr8b5jyf8x+EO0v+Ng1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RP1IVFD9Z+iawCs/+qXmLFXkuE8L9rwyJHc40LuBveQHefWp2Bh+qkkoHGSBuJJhefkJg2oAaEloVTsq6AAxcz7GzXA9GKWJ+z4yeodguRugkQ1U7r/BY0LFGZIdHmmqaaQWP4AsEYqlzSe8HQsDBI0Lw5YCKRznfVUpZmouQfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hkzqvrel; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 4 Feb 2025 14:20:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738675234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x0tTYGpefnrygjQs1nrzNOe84QlmA5lAindKWjIomyg=;
	b=HkzqvrelCFLPvNl57SPbKgyZAYq+g9dYKI972ESgfjOgm/ZxX4kVQhibZ1sXKPzox1LZa4
	GyLMxERP1mvZQLVtHnYPqH9Olaz5KOReMZS/yWAwRSqAioZnt/SRMyimN7SN5MMg2m3LDR
	tKc3aUfxx1AlrfvAHZpJ7Hq8MhGdOlQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Eric Auger <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arm: pmu: Actually use counter 0 in
 test_event_counter_config()
Message-ID: <20250204-5e9104c983691dd62ff9d111@orel>
References: <20250203181026.159721-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250203181026.159721-1-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 03, 2025 at 10:10:26AM -0800, Oliver Upton wrote:
> test_event_counter_config() checks that there is at least one event
> counter but mistakenly uses counter 1 for part of the test.
> 
> Most implementations have more than a single event counter which is
> probably why this went unnoticed. However, due to limitations of the
> underlying hardware, KVM's PMUv3 emulation on Apple silicon can only
> provide 1 event counter.
> 
> Consistenly use counter 0 throughout the test, matching the precondition
> and allowing the test to pass on Apple parts.
> 
> Cc: Eric Auger <eric.auger@redhat.com>
> Fixes: 4ce2a804 ("arm: pmu: Basic event counter Tests")
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arm/pmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 9ff7a301..2dc0822b 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -396,13 +396,13 @@ static void test_event_counter_config(void)
>  	 * Test setting through PMESELR/PMXEVTYPER and PMEVTYPERn read,
>  	 * select counter 0
>  	 */
> -	write_sysreg(1, PMSELR_EL0);
> +	write_sysreg(0, PMSELR_EL0);
>  	/* program this counter to count unsupported event */
>  	write_sysreg(0xEA, PMXEVTYPER_EL0);
>  	write_sysreg(0xdeadbeef, PMXEVCNTR_EL0);
> -	report((read_regn_el0(pmevtyper, 1) & 0xFFF) == 0xEA,
> +	report((read_regn_el0(pmevtyper, 0) & 0xFFF) == 0xEA,
>  		"PMESELR/PMXEVTYPER/PMEVTYPERn");
> -	report((read_regn_el0(pmevcntr, 1) == 0xdeadbeef),
> +	report((read_regn_el0(pmevcntr, 0) == 0xdeadbeef),
>  		"PMESELR/PMXEVCNTR/PMEVCNTRn");
>  
>  	/* try to configure an unsupported event within the range [0x0, 0x3F] */
> 
> base-commit: 1f08a91a41402b0e032ecce8ed1b5952cbfca0ea
> -- 
> 2.39.5
>

Merged.

Thanks,
drew

