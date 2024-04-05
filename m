Return-Path: <kvm+bounces-13725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA951899F62
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 16:20:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84AA4283C6A
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 14:20:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF04C16F0E2;
	Fri,  5 Apr 2024 14:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jTQamxvY"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1365216F0E7
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 14:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712326634; cv=none; b=d6m5tVMeJaYhiJ2ijSC59nqHcUM2Iyb5+6tEES8QXNSj4P3IYxV6ZOaH/KJxTmba5FynI8y/wyAD1XCb9m/NsrRRAkpFY+8Ts6pl6c4SJYILVdZ6trB0RPrKKb/tNKqvknZnh4CyKlPZvIwMLoXVqo15blDSwZzJ/0ki1UF3XUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712326634; c=relaxed/simple;
	bh=S6h63rmzEnnxE9aovO/tYDtfsq0sE7JBqKLM9t1qii4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=abXjyi06S0O91Zfehpeh8iHuAfBBn2qUKg4L1a3CO7UiLII0xo6raohSv1bQM7D1vueHqKd9A3cm7UBjd/loQsq1qFF4B+hH2r/jFh52AUh3orl/WpG4h+VodCr64+3zmteY2UKcLWbbyE7u3zPhjVtOPjt3IcL6HTsvh8ls0ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jTQamxvY; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Apr 2024 16:17:07 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712326630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UisemFSIsU1qjIIE8fnjogkxNyehbUC4R2reh5xedUs=;
	b=jTQamxvYtBY6SUS1LaFqp597JmUjQpowI09Ewco9VMX64VHN586irnQ4mREvg03keqLjtR
	Y9nvZ8D6mbgXB+TLpNOGewky5m7nTDDaBwdw1c59FYpT0+aotIvsm6TDH3IKbzdI9oZINS
	SZQbnnQXyCQd2lSD6dp64wjZ50a7Oz4=
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
Subject: Re: [kvm-unit-tests RFC PATCH 04/17] shellcheck: Fix SC2094
Message-ID: <20240405-61cc54f481450c1f1142e465@orel>
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-5-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405090052.375599-5-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 05, 2024 at 07:00:36PM +1000, Nicholas Piggin wrote:
>   SC2094 (info): Make sure not to read and write the same file in the same
>   pipeline.
> 
> This is not as clearly bad as overwriting an input file with >, but
> could appended characters possibly be read in from the input
> redirection?
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  scripts/arch-run.bash | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 1901a929f..472c31b08 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -492,6 +492,8 @@ env_file ()
>  
>  env_errata ()
>  {
> +	local new_env
> +
>  	if [ "$ACCEL" = "tcg" ]; then
>  		export "ERRATA_FORCE=y"
>  	elif [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
> @@ -500,7 +502,8 @@ env_errata ()
>  	elif [ "$ERRATATXT" ]; then
>  		env_generate_errata
>  	fi
> -	sort <(env | grep '^ERRATA_') <(grep '^ERRATA_' $KVM_UNIT_TESTS_ENV) | uniq -u >>$KVM_UNIT_TESTS_ENV
> +	new_env=$(sort <(env | grep '^ERRATA_') <(grep '^ERRATA_' $KVM_UNIT_TESTS_ENV) | uniq -u)
> +	echo "$new_env" >>$KVM_UNIT_TESTS_ENV
>  }
>  
>  env_generate_errata ()
> -- 
> 2.43.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

