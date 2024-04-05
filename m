Return-Path: <kvm+bounces-13728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7EA0899F7E
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 16:25:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04C8B1C228C5
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 14:25:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A2BA16EBF7;
	Fri,  5 Apr 2024 14:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EQQFN5n2"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8D816EBEB
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 14:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712327102; cv=none; b=le413rkbroXQpvzx1cn3Bmcg+62PbUef5d6DhKYMJtuWA3+a2/ajCEyrAFNtR797RRncB3hlWjGXJ+1MWoBKjTr+bsPS+qaVK3+zKN1gfYljzSEZgCkGB6rFUknPTwCXa3zRFPZdROO32iJ3mJUM6pPgJKFgwxoJazu0xWg9Y6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712327102; c=relaxed/simple;
	bh=xn1P69ZyVOIQG02R/C8j2lYq8cD2BNzriJm5di6lpf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cr1c2e37A4huLddemYwwKuO/woDvnkUgJsGMa2cozedaRGG/l7XmK9mOO3YgFsdk8y1Czh420AVRKGduCt7cuxlNK00+0uXnd8/Wsr0l72R5kbrIpWS/YG8ZYtOWIjujsZkEkXaKSLf5A42Fo8rrLsyERaaRz4r8dwxferG+bY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EQQFN5n2; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Apr 2024 16:24:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712327097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XnIOnN6E1YyJPw6q3eJXaUj8ZEYQUCH/IYLExqmDvWc=;
	b=EQQFN5n2kOUu/NDqYA/WURY0ZU5PyAX0VhU1mwQcv90KQSKK/OcycN9n2yycHwDgMuWHxu
	yVyIAnvau10QaryeioxWj/Y9GYJkuZHgtRHub3uEQOTIEVXFLXZibnjMe2oFltEmG2gLAk
	f6ZXcx3c/cIZtHiKRMLNpjOQ+SNV7IA=
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
Subject: Re: [kvm-unit-tests RFC PATCH 07/17] shellcheck: Fix SC2235
Message-ID: <20240405-a578a48a6cad5c42abe5943c@orel>
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-8-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405090052.375599-8-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 05, 2024 at 07:00:39PM +1000, Nicholas Piggin wrote:
>   SC2235 (style): Use { ..; } instead of (..) to avoid subshell
>   overhead.
> 
> No bug identified. Overhead is pretty irrelevant.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  scripts/arch-run.bash | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index ae4b06679..d1edd1d69 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -580,15 +580,15 @@ kvm_available ()
>  		return 1
>  
>  	[ "$HOST" = "$ARCH_NAME" ] ||
> -		( [ "$HOST" = aarch64 ] && [ "$ARCH" = arm ] ) ||
> -		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
> +		{ [ "$HOST" = aarch64 ] && [ "$ARCH" = arm ] ; } ||
> +		{ [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] ; }
>  }
>  
>  hvf_available ()
>  {
>  	[ "$(sysctl -n kern.hv_support 2>/dev/null)" = "1" ] || return 1
>  	[ "$HOST" = "$ARCH_NAME" ] ||
> -		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
> +		{ [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] ; }
>  }

This one is a bit ugly. Most developers are used to seeing expressions
like

  a || (b && c)

not 

 a || { b && c ; }

I'm inclined to add SC2235 to the ignore list...

Thanks,
drew

