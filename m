Return-Path: <kvm+bounces-10235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4194A86AE63
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 12:58:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F10832943FB
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 11:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00BC9145326;
	Wed, 28 Feb 2024 11:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="F/H2xG2n"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E214D1420CA
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 11:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709121109; cv=none; b=RowWHdgk2J5RLDtVIise2OgpomhfCkLI8s5BOuasfFJNoGF07qJrWMEIs3KQJh9d0Kee9BIm1hsjRvhJZ5y4wazjUgmY8gEqvgirR5AYY0nmEgchwW+dT17atT5NN5WmwHVCqqIIVc11FyfGZjvMy3K7cwCYgsd44T/dEMh6VC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709121109; c=relaxed/simple;
	bh=gJQ48okJnaIkihocB2WcnYn23aG8kzal50gaF9KAI2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PKDHF+ms5jiHh2nWOLyrovZpa3CsSJR0M95+9ufpFVRKUd11cHYt+BCbmnezSNQCt8NHFjXsT5KPf71nlqvx3vj0V5bLrol+rCS7OHNVoDmJnccj7b8ZwxMCOfSsoeaw75pOxifzTqpJTx0MjIHH8L2r7tCnZ9NtKGPUmgCpMGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=F/H2xG2n; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 28 Feb 2024 12:51:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709121105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jZX06/t/vObxlUd3rjMifnJudTyaWwmVSmqsij++4PU=;
	b=F/H2xG2n0r3jJlW3sDq2LpzjP4WdPViUuTXqSdCcbnx+WBhS5OA0kRreYiOyJd0iiooxDf
	NPKmuHxZ/+twtmxBkxnl9oXxVU5jHMMgjf6vB+vWAlIOcHCPteHoIFkEDWPozBz3ZqFIbe
	ynwSv4Vs2JNRatJJhPalYj+vFYLuxB0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 17/32] arch-run: Fix handling multiple
 exit status messages
Message-ID: <20240228-046d6f84483d096b669d1203@orel>
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-18-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226101218.1472843-18-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 26, 2024 at 08:12:03PM +1000, Nicholas Piggin wrote:
> In SMP tests, it's possible for multiple CPUs to print an exit
> message if they abort concurrently, confusing the harness:
> 
>   EXIT: STATUS=127
> 
>   EXIT: STATUS=127
>   scripts/arch-run.bash: line 85: [: too many arguments
>   scripts/arch-run.bash: line 93: return: too many arguments
> 
> lib/arch code should probably serialise this to prevent it, but
> at the moment not all do. So make the parser handle this by
> just looking at the first EXIT.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  scripts/arch-run.bash | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 5c7e72036..4af670f1c 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -79,7 +79,7 @@ run_qemu_status ()
>  	exec {stdout}>&-
>  
>  	if [ $ret -eq 1 ]; then
> -		testret=$(grep '^EXIT: ' <<<"$lines" | sed 's/.*STATUS=\([0-9][0-9]*\).*/\1/')
> +		testret=$(grep '^EXIT: ' <<<"$lines" | head -n1 | sed 's/.*STATUS=\([0-9][0-9]*\).*/\1/')
>  		if [ "$testret" ]; then
>  			if [ $testret -eq 1 ]; then
>  				ret=0
> -- 
> 2.42.0
>

Acked-by: Andrew Jones <andrew.jones@linux.dev>

