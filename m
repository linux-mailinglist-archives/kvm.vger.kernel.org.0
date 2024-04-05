Return-Path: <kvm+bounces-13730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DFCF899FB1
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 16:29:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 193FF285953
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 14:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D587C16EC1C;
	Fri,  5 Apr 2024 14:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mJv9sL5y"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DBD16EC0E
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 14:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712327385; cv=none; b=XpZ7jd3znC0oU2RR3n1SIZoj2rwjhE/CsQMj/8G70yKJ+cmBDfakImBmrvNDk9ApSM77Yg/x8DAd0yuwk5H6rub7XHU60SAfYJ6OdOHn59qI56XcUXgOAhOIt+NluK0py5Ixk7IZ0SRoREwJOPGWr9OqAl3esouhX2MiuXgnLXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712327385; c=relaxed/simple;
	bh=v3HMqnyeWFiAHJgh95PLFWWAh9BbIGi/2OowpMTzKbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UcpVv4w8t/63jpvn5EuOoCjqRNX/HSuDWBYLFOHret++W/lqsOIUv6ROIN3FWoqgD5sP8f7pC2LxgR8Y6ry2zERC5K9zOlAkcUt4XGJPOSdjg9TZWdA5ZgULh998q9QOlMp3bgBkbAIxykeLiZHZU+oMcc/iCkPE+7p7IjEBDKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mJv9sL5y; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Apr 2024 16:29:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712327381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XznNhSdWhDW60uiv9+dBQQb8/YB8jrAPtPF15z3ew0U=;
	b=mJv9sL5yKA+OgHcFpGFL8OjHAUhnKrx7lGoxwk/9AMf/a9EcUMQIFnf+ZOcfR3ewPhv7RN
	LCxLUvVSFWJJfv6CjB2BVuXOmSDnm+HxQDHkkFc1hTP+XRuVbxzcmh1dEprsGE3vA/czsz
	DuAVf5DkZVJFor9OoAPLEqaMBqdGFQw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Nico =?utf-8?B?QsO2aHI=?= <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Nadav Amit <namit@vmware.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Ricardo Koller <ricarkol@google.com>, rminmin <renmm6@chinaunicom.cn>, Gavin Shan <gshan@redhat.com>, 
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests RFC PATCH 09/17] shellcheck: Fix SC2143
Message-ID: <20240405-a6de93cfd2e6f513a78534af@orel>
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-10-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405090052.375599-10-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 05, 2024 at 07:00:41PM +1000, Nicholas Piggin wrote:
>   SC2143 (style): Use ! grep -q instead of comparing output with
>   [ -z .. ].
> 
> Not a bug.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  scripts/arch-run.bash | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index d1edd1d69..9dc34a54a 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -61,7 +61,11 @@ run_qemu ()
>  		# Even when ret==1 (unittest success) if we also got stderr
>  		# logs, then we assume a QEMU failure. Otherwise we translate
>  		# status of 1 to 0 (SUCCESS)
> -		if [ -z "$(echo "$errors" | grep -vi warning)" ]; then
> +	        if [ "$errors" ]; then
> +			if ! grep -qvi warning <<<"$errors" ; then
> +				ret=0
> +			fi
> +		else
>  			ret=0
>  		fi
>  	fi
> -- 
> 2.43.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

