Return-Path: <kvm+bounces-42569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A52E0A7A1FE
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 13:35:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB42D3AFF06
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 11:34:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5726E24C06A;
	Thu,  3 Apr 2025 11:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Jy0fV1O0";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="zc2IjXK7"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA355D738;
	Thu,  3 Apr 2025 11:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743680098; cv=none; b=FCRMJa3nsXJ0OQN5bvul41U64A7i7pg23SMsoFrK/KXdwcCMNVl+Bz/5wXhZRUvdmIeAVQLzc03SCFPlc3FVvKdnwACBqiCdD74dfxgJm7RaRnQfsp0ZKkLfER+nxuhtNknphN0vD9RcCysIpo3YuUieEvgVTiUANd37auuxZyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743680098; c=relaxed/simple;
	bh=eGN9Pr3FOjyBEsjtRb7s0DDvkPLmCGPVfKUYl+4zJog=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HKHQiOfZ/ElbtitsgprBIRvkm6DSYCWL9dXfsB9X+zR9a45rP3xFS9VCYyYZrAjRL8mBtIvjn51H+VbotQDzqPotzE2suymrxuAYCVBTdhFHRrQ2aGkbUpNCggDOs0jZWG7/SUHoVk50lQz6Kj34EAmtGjcWxUdrt2qxSZzT1uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Jy0fV1O0; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=zc2IjXK7; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1743680093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=56OvNNEMr4+W6SINWmtHAf1TLHpT86cx/9kOkuPPyUk=;
	b=Jy0fV1O074fzDLXfScv02VNv9xb30wKeVShW/k/gLOLjMzUmX2Hvpu6QXP+0e6as3yZICF
	ZNDpqkWrnEXjzRpxRzyOwqb+opfYMrnR1SuFN0rWZ7jlGIIyGkAor4pq9DTgQFlC58L1YP
	GN0ETosuXq2KO9sGfeNQstBif9pmk/z7mIRzKF4VytpFWSVOb14yh9L0tkd7XOgEYRHeZM
	sv+zrqt5hYBGH+++UI+ODUhuCOwxy6VIeXTJ++Q3mofLSBePCJ785+oIjqYS/GJnMukbVX
	9lHLKwyzG/R8Kt7Je6ZcsnM41RsnGEyToHnFDa63ldUAEb0qQPg/XDaxBCqzPA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1743680093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=56OvNNEMr4+W6SINWmtHAf1TLHpT86cx/9kOkuPPyUk=;
	b=zc2IjXK7OLyjM3WqSVAt7B6RpNvsZ5XeA6Lc7qDNAokCzTqHtSEDZ23JSzXjGbMWnbpL2q
	99+yxlQqIZ9g0lDA==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com, francescolavra.fl@gmail.com
Subject: Re: [PATCH v3 01/17] x86/apic: Add new driver for Secure AVIC
In-Reply-To: <20250401113616.204203-2-Neeraj.Upadhyay@amd.com>
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
 <20250401113616.204203-2-Neeraj.Upadhyay@amd.com>
Date: Thu, 03 Apr 2025 13:34:52 +0200
Message-ID: <874iz5wk9v.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Apr 01 2025 at 17:06, Neeraj Upadhyay wrote:
> +static void __send_ipi_mask(const struct cpumask *mask, int vector, bool excl_self)
> +{
> +	unsigned long query_cpu;
> +	unsigned long this_cpu;
> +	unsigned long flags;

Just coalesce them into a single line: 'unsigned long a, b;'

> +	/* x2apic MSRs are special and need a special fence: */
> +	weak_wrmsr_fence();
> +
> +	local_irq_save(flags);

        guard(irqsave)();

> +	this_cpu = smp_processor_id();
> +	for_each_cpu(query_cpu, mask) {
> +		if (excl_self && this_cpu == query_cpu)
> +			continue;
> +		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
> +				       vector, APIC_DEST_PHYSICAL);
> +	}
> +	local_irq_restore(flags);
> +}

> +static int x2apic_savic_probe(void)
> +{
> +	if (!cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
> +		return 0;
> +
> +	if (!x2apic_mode) {
> +		pr_err("Secure AVIC enabled in non x2APIC mode\n");
> +		snp_abort();

Why does this return 1?

> +	}
> +
> +	return 1;
> +}

