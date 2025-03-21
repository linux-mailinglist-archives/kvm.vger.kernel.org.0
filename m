Return-Path: <kvm+bounces-41650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 70DC9A6B8CD
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 11:34:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 265143B2B04
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 10:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07D331FC7D9;
	Fri, 21 Mar 2025 10:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ABAZS8G6"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1701A78F5B
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 10:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742553236; cv=none; b=gSPQ/Dn3JRAZ0qCB87vVkTCvS/B5keTU2wTLc72M1dwECWjU0oK0WR7IIbly6b3cGwnNdNsoe35DIapZj5gj7RCaKQLtFs0dna35kWrFw+PRAWj9aThcLuCr7QNkedYQkJhhsvxIg7SafPoHUQMaviNSVH9QMb8ixoqQSjAACa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742553236; c=relaxed/simple;
	bh=hTGsKUsfG/SoiBW1ok/0Bu2XdKRq1/c04K4Ys80y62M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GPFSWNpRmnHMUIegmEdUzN8e48RNEeh+A7NXPpXG1vnTJni7F7UegkZ5aLIGMDv5GfwhfqnRzxgbFoqtR2ZLlhDPh8vS4pEEvY6+pUhm0Zw0b6go4npwIfUektsRYJUhqmeGH+OkSRZDynu4C4FoKlLy7QFTYHClX/E8Vdw114c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ABAZS8G6; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 21 Mar 2025 11:33:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742553231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c0HAfgbtJozbfncnjF7ho4KwscLWzTpPfv49NYj1VSE=;
	b=ABAZS8G6z0YFEUeIVZMRIndG43D/7NBYbtB7djjTgYKeo9CoUCZF52V/64uTmdWptzsZ4W
	5q0j28x+Jk2g2Bp1Y+jDHhG0QJvVXncTmW+3JQ846bl8h5fbjOuJGUDA0nudvCbIzNf0xE
	hGxx6CBTb0JOaP8bAqUFBNE3Kz/Sbh0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Akshay Behl <akshaybehl231@gmail.com>
Cc: kvm@vger.kernel.org, cleger@rivosinc.com, atishp@rivosinc.com
Subject: Re: [kvm-unit-tests PATCH v3] riscv: Refactor SBI FWFT lock tests
Message-ID: <20250321-276b647d439670efb4fca0e4@orel>
References: <20250320173235.16547-1-akshaybehl231@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250320173235.16547-1-akshaybehl231@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 20, 2025 at 11:02:35PM +0530, Akshay Behl wrote:
> This patch adds a generic function for lock tests for all
> the sbi fwft features. It expects the feature is already
> locked before being called and tests the locked feature.
> 
> Signed-off-by: Akshay Behl <akshaybehl231@gmail.com>
> ---
> v3:
>  - Fixed indentation.
>  - Removed unnecessary comments.
>  - Added locked prefix.
> 
> v2:
>  - Made changes to handel non boolean feature tests.
> 
> riscv/sbi-fwft.c | 50 ++++++++++++++++++++++++++++++++----------------
>  1 file changed, 34 insertions(+), 16 deletions(-)
> 
> diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
> index 581cbf6b..c4d0b170 100644
> --- a/riscv/sbi-fwft.c
> +++ b/riscv/sbi-fwft.c
> @@ -74,6 +74,37 @@ static void fwft_check_reset(uint32_t feature, unsigned long reset)
>  	sbiret_report(&ret, SBI_SUCCESS, reset, "resets to %lu", reset);
>  }
>  
> +/* Must be called after locking the feature using SBI_FWFT_SET_FLAG_LOCK */
> +static void fwft_feature_lock_test_values(uint32_t feature, size_t nr_values,
> +	unsigned long test_values[], unsigned long locked_value)

Additional lines of parameters should line up underneath each other, i.e.

static void fwft_feature_lock_test_values(uint32_t feature, size_t nr_values,
                                          unsigned long test_values[],
                                          unsigned long locked_value)

I suggest reading other code (there's a function just above this one,
fwft_set_and_check_raw(), for example) to get a feel for the coding
style.

In this case, I've fixed it up while applying.

Applied to riscv/sbi

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi

Thanks,
drew

