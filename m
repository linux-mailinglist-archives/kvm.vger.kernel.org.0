Return-Path: <kvm+bounces-13735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 06878899FF8
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 16:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B04C81F21CFF
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 14:40:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C00B16F290;
	Fri,  5 Apr 2024 14:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iCRmchau"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF0316EC01
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 14:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712328014; cv=none; b=JGg4riNCktt7BOyFkm+Gv6or2+k2G72+vfulPDqCyGYC9QBphDcl7eSBjcqewDM1sipAoT+NRbTmEIVdTjGLkozMqgECl/BjGvwMYJRfWUM2IecxX9RFDd4L+ZnGA+U9MVVdSqbhAVIGKOATgPP+4yUWDz2M3JDre5FcXDvIPpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712328014; c=relaxed/simple;
	bh=IRs0UkLzOvLLelINCiwEurKEPkUrDXUtVEMOnZiHPSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p1yIZXFLkvgbzD2DrySGNPspyEjNk/6t5ZwBU1wywrBYuFw8HxYO2OnvvPvZE38CFwupgpve9YLaY6RJ5KXck0jbQkrWsLO1HqT/mPOKAVjET1h3yBDSBpctuXcUb14dlR1Cx+fSccy9BEop8TiO3BwkDJSLXPUbvKMPDZhLLZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iCRmchau; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Apr 2024 16:40:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712328009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KHy1FBeT0P7q2ACiIwc24lYZLxTgKK8Ca1uNIPNsdOw=;
	b=iCRmchauY3Jz8V4SeQVpgg9SpT9EiCMnKjZGYlgTSIHm2BYxD1rHlOTByj9BmO+EfkFdyA
	uXLitQS5bSNKvvZriCTT7RmJZ6rrhDnI0sWBqNbkHKOB9XtMZ7Iwz0LMFsNYLHceToH0MF
	dyL57/8oZrL1vi+RQwO7HyjKe7Ux1Pk=
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
Subject: Re: [kvm-unit-tests RFC PATCH 14/17] shellcheck: Fix SC2178
Message-ID: <20240405-4dc7c31121a4214d2efb9edc@orel>
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-15-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405090052.375599-15-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 05, 2024 at 07:00:46PM +1000, Nicholas Piggin wrote:
>   SC2178 (warning): Variable was used as an array but is now assigned a
>   string.
> 
> Not sure if there's a real bug.

Things seem to work, but the change looks better.

> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arm/efi/run   | 2 +-
>  riscv/efi/run | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/efi/run b/arm/efi/run
> index cf6d34b0b..8f41fc02d 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -44,7 +44,7 @@ qemu_args=()
>  cmd_args=()
>  while (( "$#" )); do
>  	if [ "$1" = "-append" ]; then
> -		cmd_args=$2
> +		cmd_args=("$2")
>  		shift 2
>  	else
>  		qemu_args+=("$1")
> diff --git a/riscv/efi/run b/riscv/efi/run
> index cce068694..5a72683a6 100755
> --- a/riscv/efi/run
> +++ b/riscv/efi/run
> @@ -47,7 +47,7 @@ qemu_args=()
>  cmd_args=()
>  while (( "$#" )); do
>  	if [ "$1" = "-append" ]; then
> -		cmd_args=$2
> +		cmd_args=("$2")
>  		shift 2
>  	else
>  		qemu_args+=("$1")
> -- 
> 2.43.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

