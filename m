Return-Path: <kvm+bounces-31487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 040D49C4177
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 16:06:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B04DF1F24130
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 15:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 099351A01DD;
	Mon, 11 Nov 2024 15:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NFR4oOlg"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06A64D8CE
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 15:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731337576; cv=none; b=KWetQG1kTKYuYK4agXMayZDYfny2j9E9BIby+L+WeUbU2Bke3S47oJMLrfCBnako32Gt4f7gpncVH9gP3J/gRA5z7ldn/NYYRFD0TzVbVz4VS+s4gp28gY0IbiQ7pX12jiXTTVXL7iXhViNdxOdio35LOAlRJATabWZRTZEJRmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731337576; c=relaxed/simple;
	bh=cKT8LEMzpm1eCBW7Jqd4lXcXbNdNpMhJJYwwTBmk8Xs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GxC4dcD/yMO8a/g/v4e7TggeKW8WEJTNWmrpbKVoXD//g6/KZ1pwspl8omSNz9wlvGrbbybQDtvZEztD+fmy4hIYQvxHkqN43aSOHelGhuLnlRAiqZKYK51HSX9NTXbq26/jQPy+8kHNEhddewhhEPBCCi+gBSUqPD6KzHjfbr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NFR4oOlg; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 11 Nov 2024 16:06:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731337570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rZppIEkGOPvISQ6I/wzU0Unh+D5yT+Db6spqm5LrHzc=;
	b=NFR4oOlgWfzuUI1L2icaw/UkOubgNNz2bQU5axZaclqJDSukRIRDoF5PCoTZR14wMtc4hi
	KlREvfsWoqu8+HclX98wAPUeOYipoYcj7B5fSV/zma/7iVX7GUWfODm9INNQmQvPabCG9M
	27VHv8IvXoxYdgphNiZpd6Bu/NKhuG4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH v2] riscv: sbi: Improve spec version test
Message-ID: <20241111-19b1aafdbe04f0674b6d36ce@orel>
References: <20241106083926.14595-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106083926.14595-2-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 06, 2024 at 09:39:27AM +0100, Andrew Jones wrote:
> SBI spec version states that bit 31 must be zero and, when xlen
> is greater than 32, that bit 32 and higher must be zero. Check
> these bits are zero in the expected value to ensure we test
> appropriately.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  lib/riscv/sbi.c |  2 +-
>  riscv/sbi.c     | 13 +++++++++----
>  2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
> index 8972e765fea2..f25bde169490 100644
> --- a/lib/riscv/sbi.c
> +++ b/lib/riscv/sbi.c
> @@ -107,7 +107,7 @@ long sbi_probe(int ext)
>  	struct sbiret ret;
>  
>  	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
> -	assert(!ret.error && ret.value >= 2);
> +	assert(!ret.error && (ret.value & 0x7ffffffful) >= 2);
>  
>  	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_PROBE_EXT, ext, 0, 0, 0, 0, 0);
>  	assert(!ret.error);
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 52434e0ca86f..c081953c877c 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -105,18 +105,23 @@ static void check_base(void)
>  	report_prefix_push("base");
>  
>  	ret = sbi_base(SBI_EXT_BASE_GET_SPEC_VERSION, 0);
> -	if (ret.error || ret.value < 2) {
> -		report_skip("SBI spec version 0.2 or higher required");
> -		return;
> -	}
>  
>  	report_prefix_push("spec_version");
>  	if (env_or_skip("SBI_SPEC_VERSION")) {
>  		expected = (long)strtoul(getenv("SBI_SPEC_VERSION"), NULL, 0);
> +		assert_msg(!(expected & BIT(31)), "SBI spec version bit 31 must be zero");
> +		assert_msg(__riscv_xlen == 32 || !(expected >> 32), "SBI spec version bits greater than 31 must be zero");
>  		gen_report(&ret, 0, expected);
>  	}
>  	report_prefix_pop();
>  
> +	ret.value &= 0x7ffffffful;
> +
> +	if (ret.error || ret.value < 2) {
> +		report_skip("SBI spec version 0.2 or higher required");
> +		return;
> +	}
> +
>  	report_prefix_push("impl_id");
>  	if (env_or_skip("SBI_IMPL_ID")) {
>  		expected = (long)strtoul(getenv("SBI_IMPL_ID"), NULL, 0);
> -- 
> 2.47.0
>

Merged through riscv/sbi.

Thanks,
drew

