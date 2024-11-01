Return-Path: <kvm+bounces-30333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 556639B95A3
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 17:41:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 085771F2287C
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 16:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 030FB1C9B97;
	Fri,  1 Nov 2024 16:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="GCUtdnxy"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031361798C;
	Fri,  1 Nov 2024 16:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730479280; cv=none; b=UZJjxcPZNs1eMRnEQHpRh1lpsu/KDkzkNkqp9U5OgJD7Qz5dCKcgu/DEydJGMJHKtjkDNcYEo1mYq5xRHsK5wthZnIpQ/W9ec7RKy/dAN2AxEui9ev9KOa3h0cOTNCYvmhflF/RGATZBoxOK1iFoRe9HARftq/jA3yultctqUuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730479280; c=relaxed/simple;
	bh=lQWAHQP49L9EPI83ci/P6pNn65ds+hzTCghHwBXbPEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W76QoO1ZOIwmJQZ5z04ksxXHQgbYiMhlON7nK9m65ATdXDWL6uL135c9PQ546x8PbIpivAEKpeXZoImuSf2lDYm7HQOjFK8fkMg+XnoyUNPmCT63ylOgwPoRKVWn2ji+tH1lUC0tcEN/VHVTy+3jRKr7XhXKFoj4e7rHPApMxLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=GCUtdnxy; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id AA1D040E0220;
	Fri,  1 Nov 2024 16:41:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id IxkFdDt0bs4B; Fri,  1 Nov 2024 16:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730479270; bh=fzSSkxQVzzE+tCcSW0ZG2KSSM/Nhtusb1t/k+DswM4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GCUtdnxykynOPbX9wjDcCmIsrGBc1gdfiD+WRUDn2QQ8afrcdRosRyQ0S2EyFHUxD
	 DGwcsGt1BM1NojWvy60niSio2K8U1vEbplwvqITDFNBrNIxZz4TrqQ/96dq3q3sl+c
	 gGV6FimbcBYVzcrI51J9AiBqCVl/ri5sl43jbs26cc0nwmickSRVxmQYDf4/CwSmnI
	 CQQqdCW/9U3pZStwpfPHhIZ/LfiKiMb5HCdq5mB+vUnbkjkmDDvpfzIr1L+pitaQnC
	 hgfsvJsrIJlitqoDbwYBOF74GJj4qSXpTRyjJKTENEqv7hocSjMacsBb6hxkn21+ed
	 UyVzgnc3f5yDnbalYx9B1KbALTWX5RPuK1BH8WzJVZIORNADtdCtPwQDjuT5KbryZ/
	 FsWOcJNSRZDelO8EnWeHK6VdfZIXGe78OXgZOj7gd4CL/dUT8cKhgYMBmYuf0uKhEz
	 EH55iRXrppeh3LicIChtmhs2kUXNXfKk5LDJnnyd82ObH44ZegAPK9pPXYiMi2a4FQ
	 KFNFh4ju9+C0eAtU8rswg7C9IvWFoOd8pWLuBiP1iLG2ruiSbWceChQQBJVL6IQNaB
	 B+YcqZvKljKrNIcpHGMcvfRm5LY+hsxujcigG4LT/7sqMq0elRD9ZRzQPj5gf+2z8S
	 oUUP0yBrQhUOi88Mfra0/nRg=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2CA7840E019C;
	Fri,  1 Nov 2024 16:40:59 +0000 (UTC)
Date: Fri, 1 Nov 2024 17:40:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v14 04/13] x86/sev: Change TSC MSR behavior for Secure
 TSC enabled guests
Message-ID: <20241101164053.GLZyUElVm8I22ZZjor@fat_crate.local>
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-5-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241028053431.3439593-5-nikunj@amd.com>

On Mon, Oct 28, 2024 at 11:04:22AM +0530, Nikunj A Dadhania wrote:
> +	/*
> +	 * TSC related accesses should not exit to the hypervisor when a
> +	 * guest is executing with SecureTSC enabled, so special handling
> +	 * is required for accesses of MSR_IA32_TSC:
> +	 *
> +	 * Writes: Writing to MSR_IA32_TSC can cause subsequent reads
> +	 *         of the TSC to return undefined values, so ignore all
> +	 *         writes.
> +	 * Reads:  Reads of MSR_IA32_TSC should return the current TSC
> +	 *         value, use the value returned by RDTSC.
> +	 */
> +	if (regs->cx == MSR_IA32_TSC && (sev_status & MSR_AMD64_SNP_SECURE_TSC)) {
> +		u64 tsc;
> +
> +		if (exit_info_1)
> +			return ES_OK;
> +
> +		tsc = rdtsc();

rdtsc_ordered() I guess.

> +		regs->ax = UINT_MAX & tsc;
> +		regs->dx = UINT_MAX & (tsc >> 32);
> +
> +		return ES_OK;
> +	}
> +

All that you're adding - put that in a __vc_handle_msr_tsc() helper so that it
doesn't distract from the function's flow.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

