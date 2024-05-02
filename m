Return-Path: <kvm+bounces-16418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B809C8B9D69
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 17:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72704287C87
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 15:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7310B15B552;
	Thu,  2 May 2024 15:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="scGZOB5A"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D9C15B551
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 15:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714663800; cv=none; b=kVN4NYEFZsGxPh1djSlCxtE4dyiWNoXO/xz4/9RnZ6dLZ0M+iZBXX1dVt2gsJOFy9hWvck9vv82gwsxCsYfrgpjBj/gok+inC57S4OOP/ZR3hsLe363zG49b9+x3arhOG/6uA3kVBxqLK9gzMj7taPDmqAo8m3osXn1wiuibseI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714663800; c=relaxed/simple;
	bh=RsI+3ofUqkyi+fdLeZDHW25f+0WQfdpkobwiIW0ag70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fCMq7CkbGpiDtVa1myzd+IAX3ZW7zc+Iu9b7didpNS6E1J0YTRXcI02lebvCDzW6E5o/4SvLxfLiTrPCuLq3DCEMgIeDO7eI1GR4d0U/jtH8XQFNHE75nP4u0Dq2GkrC3G/6gPlE9z0zNg+wQUzlY5DkY4d0arkWl8xZlPX0AnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=scGZOB5A; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 2 May 2024 17:29:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714663797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RAz7pRg1lhIiyqMQ8h5he5jYrTB035w2HGbe56ARfqU=;
	b=scGZOB5AnRPwxE1g9B7cF3k2GES/USDnpvFKlL6kovGAQq59+zWL+9V8UNnToPd6MUqk9S
	Spt52SjcV5pYaUmPjvzUoodC2q3HFT0jzJga+YL3hrs+6qysllXe/gcbLwPpk7p68q9Ac2
	b0jHVc+GpVQEncKtw+hwS/PqK7A4ZKQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, pbonzini@redhat.com, 
	thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH] runtime: Adjust probe_maxsmp for older
 QEMU
Message-ID: <20240502-c54cd932443896d67fe43ad0@orel>
References: <20240502080934.277507-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240502080934.277507-2-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, May 02, 2024 at 10:09:35AM GMT, Andrew Jones wrote:
> probe_maxsmp is really just for Arm and for older QEMU which doesn't
> default to gicv3. So, even though later QEMU has a new error message
> format, we want to be able to parse the old error message format in
> order to use --probe-maxsmp when necessary. Adjust the parsing so it
> can handle both the old and new formats.
> 
> Fixes: 5dd20ec76ea6 ("runtime: Update MAX_SMP probe")
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  scripts/runtime.bash | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index e7af9bda953a..fd16fd4cfa25 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -204,8 +204,10 @@ function probe_maxsmp()
>  {
>  	local smp
>  
> -	if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'Invalid SMP CPUs'); then
> +	if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'SMP CPUs'); then
>  		smp=${smp##* }
> +		smp=${smp/\(}
> +		smp=${smp/\)}
>  		echo "Restricting MAX_SMP from ($MAX_SMP) to the max supported ($smp)" >&2
>  		MAX_SMP=$smp
>  	fi
> -- 
> 2.44.0
>

Merged.

Thanks,
drew

