Return-Path: <kvm+bounces-41501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B179A6965A
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 18:25:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E9FF3B4B6C
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 17:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 066CC1EB5F9;
	Wed, 19 Mar 2025 17:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tDaBQ6yh"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECCE35971
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 17:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742405143; cv=none; b=AIr/1fZ5rF01QZDmwuIyhRg0oPirD8uovMwewkeDx3OiG11F10vYVB9D1EeW1bGCQey4UgTR1fsZm3dmSFlaTzf4bhrCuarSt+TQMiZ156FEGWnX04zq4tCxamDaFvowKUuVq2mhzCwUHNICzyMZjz6v72YoxqQf/ff94en3Aoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742405143; c=relaxed/simple;
	bh=pSqsEb18IXoynaseLV6E5l5BGoEaVGQEulQGFhM4s1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gp0pk0HZGSgqKIOrS1WVKnP0i/y32iVzwey1RCBj+ofT09G/GU58VXZmvomoKTE5QJxZj/C99wYdFvjLTz2ZSbgQrNrV76a/jRoPGbvthSK5EcRGBHJYeIjhzyq5EzsKWf5igu7ASRAAuzdEbweCEuBDTviqm4aUUU7teL7GlZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tDaBQ6yh; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 19 Mar 2025 18:25:20 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742405137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V4POkoP+b4w5dBfoET90vMNvKOwFjNjPx68UdCOBmoM=;
	b=tDaBQ6yh17ioY40QqRRUI9R2RSorxOxmFTsDNbNlSp2qXbM2ekfyzU1POD7rReGgt2iluf
	lYz+sFqHYwJqz2n4oHy8MzC0dBw/Ia2D6qOhQwZH6T+yLpzs10J0Po56iWHnYsWTLWsMPi
	GEerXJiN/k00jv7Bc5SVBxG48NAO78U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Akshay Behl <akshaybehl231@gmail.com>
Cc: kvm@vger.kernel.org, cleger@rivosinc.com, atishp@rivosinc.com
Subject: Re: [kvm-unit-tests PATCH v2] riscv: Refactor SBI FWFT lock tests
Message-ID: <20250319-957bf181a9e8eedae7a134cd@orel>
References: <20250318174349.178646-1-akshaybehl231@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318174349.178646-1-akshaybehl231@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 18, 2025 at 11:13:49PM +0530, Akshay Behl wrote:
> This patch adds a generic function for lock tests for all
> the sbi fwft features. It expects the feature is already
> locked before being called and tests the locked feature.
> 
> Signed-off-by: Akshay Behl <akshaybehl231@gmail.com>
> ---
> v2:
>  - Made changes to handel non boolean feature tests.
>  riscv/sbi-fwft.c | 49 ++++++++++++++++++++++++++++++++----------------
>  1 file changed, 33 insertions(+), 16 deletions(-)
> 
> diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
> index 581cbf6b..7d9735d7 100644
> --- a/riscv/sbi-fwft.c
> +++ b/riscv/sbi-fwft.c
> @@ -74,6 +74,34 @@ static void fwft_check_reset(uint32_t feature, unsigned long reset)
>  	sbiret_report(&ret, SBI_SUCCESS, reset, "resets to %lu", reset);
>  }
>  
> +/* Must be called after locking the feature using SBI_FWFT_SET_FLAG_LOCK */
> +static void fwft_feature_lock_test_values(uint32_t feature, size_t nr_values,
> +										unsigned long test_values[], unsigned long locked_value)

What happened to the indentation here? Please proofread your patches.

> +{
> +	struct sbiret ret;

We could push a "locked" prefix here and then...

> +
> +	for (int i = 0; i < nr_values; ++i) {
> +		ret = fwft_set(feature, test_values[i], 0);
> +		sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
> +			"Set locked feature to %lu without lock", test_values[i]);
                                                               ^ flag
> +
> +		ret = fwft_set(feature, test_values[i], SBI_FWFT_SET_FLAG_LOCK);
> +		sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
> +			"Set locked feature to %lu with lock", test_values[i]);
                                                            ^ flag
> +	}
> +
> +	ret = fwft_get(feature);
> +	sbiret_report(&ret, SBI_SUCCESS, locked_value,
> +		"Get locked feature value %lu", locked_value);

...drop 'locked feature' from all the reports above.

Then pop the prefix here.

> +}
> +
> +static void fwft_feature_lock_test(uint32_t feature, unsigned long locked_value)
> +{
> +	unsigned long values[] = {0, 1};
> +
> +	fwft_feature_lock_test_values(feature, 2 , values, locked_value);
                                                ^ extra space

> +}
> +
>  static void fwft_check_base(void)
>  {
>  	report_prefix_push("base");
> @@ -181,11 +209,9 @@ static void fwft_check_misaligned_exc_deleg(void)
>  	/* Lock the feature */
>  	ret = fwft_misaligned_exc_set(0, SBI_FWFT_SET_FLAG_LOCK);
>  	sbiret_report_error(&ret, SBI_SUCCESS, "Set misaligned deleg feature value 0 and lock");
> -	ret = fwft_misaligned_exc_set(1, 0);
> -	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
> -			    "Set locked misaligned deleg feature to new value");
> -	ret = fwft_misaligned_exc_get();
> -	sbiret_report(&ret, SBI_SUCCESS, 0, "Get misaligned deleg locked value 0");
> +
> +	/* Test feature lock */

Can drop this comment since the function name says the same thing.

> +	fwft_feature_lock_test(SBI_FWFT_MISALIGNED_EXC_DELEG, 0);
>  
>  	report_prefix_pop();
>  }
> @@ -326,17 +352,8 @@ adue_inval_tests:
>  	else
>  		enabled = !enabled;
>  
> -	ret = fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, !enabled, 0);
> -	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED, "set locked to %d without lock", !enabled);
> -
> -	ret = fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, !enabled, 1);
> -	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED, "set locked to %d with lock", !enabled);
> -
> -	ret = fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, enabled, 0);
> -	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED, "set locked to %d without lock", enabled);
> -
> -	ret = fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, enabled, 1);
> -	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED, "set locked to %d with lock", enabled);
> +	/* Test the feature lock */

same comment

> +	fwft_feature_lock_test(SBI_FWFT_PTE_AD_HW_UPDATING, enabled);
>  
>  adue_done:
>  	install_exception_handler(EXC_LOAD_PAGE_FAULT, NULL);
> -- 
> 2.34.1
> 

Thanks,
drew

