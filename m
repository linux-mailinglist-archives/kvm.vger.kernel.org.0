Return-Path: <kvm+bounces-10240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36E9486AEC5
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 13:08:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B8E12B248C9
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 12:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E674229403;
	Wed, 28 Feb 2024 12:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QkadKOx2"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA3C1F608
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 12:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709122106; cv=none; b=UelWDPn39s/VdWeEIJE2xUwYtS1cUYwwLWB2MccoWKkYQyJpl9mYVfc+XEINOk0oq1nXT94MZjxCwqG1Vx8Ed8SJGM2ki0z0lVopbetmvm2pbxjhsS19HMLA1sNeEkQZKshLHtCHNwswMCUSnrCFMhoVSfielATJcskTL/UAxw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709122106; c=relaxed/simple;
	bh=EumXJOpi+BwXWXdNByDMql+rqgc9RgisjlqNtXtQOqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rs2wNRNuEbx74UoaSpGsDsXKoMJ1jaBpy2iiIK0uzKuT7bF84k/wYYiudUVrdth2BeGhGAa2J47xiYirehgiiHNNU+e38kEMIrDLyn5E5JiuK9syxdziPdf+zVaoD4Iva8veiywi8q6wzny1N5n2Ad6Xr2boOysLfYOTNwMdE1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QkadKOx2; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 28 Feb 2024 13:08:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709122101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XWNPrUUilCiI4A3q8yMqr9KSZvx9P8q/blhjVSX5ACU=;
	b=QkadKOx2gNNgsq2yDwtob8FGSV90oxh/Mm9+dXDQWYRBbhRN2s+9CyfKASe6R0jXjDwhBf
	1CLyRhVsikkRtsk0zsmTjg6RAWAKZmYS2RPYAfdFbNLyhS7AiI8XcUy1a1CdOIJuEBBzzl
	+5wJ7NvO9qRVqytE1pirWcr63P6YX9U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Eric Auger <eric.auger@redhat.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Nico =?utf-8?B?QsO2aHI=?= <nrb@linux.ibm.com>, linux-s390@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvm-unit-tests PATCH 29/32] configure: Fail on unknown arch
Message-ID: <20240228-d598a1eb6a25935f54aeaa01@orel>
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-30-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240226101218.1472843-30-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 26, 2024 at 08:12:15PM +1000, Nicholas Piggin wrote:
> configure will accept an unknown arch, and if it is the name of a
> directory in the source tree the command will silently succeed. Make
> it only accept supported arch names.
> 
> Also print the full path of a missing test directory to disambiguate
> the error in out of tree builds.
> 
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Laurent Vivier <lvivier@redhat.com>
> Cc: Nico Böhr <nrb@linux.ibm.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-s390@vger.kernel.org
> Cc: kvmarm@lists.linux.dev
> Cc: kvm-riscv@lists.infradead.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  configure | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/configure b/configure
> index 6907ccbbb..ae522c556 100755
> --- a/configure
> +++ b/configure
> @@ -45,7 +45,8 @@ usage() {
>  	Usage: $0 [options]
>  
>  	Options include:
> -	    --arch=ARCH            architecture to compile for ($arch)
> +	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
> +	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
>  	    --processor=PROCESSOR  processor to compile for ($arch)
>  	    --target=TARGET        target platform that the tests will be running on (qemu or
>  	                           kvmtool, default is qemu) (arm/arm64 only)
> @@ -321,11 +322,15 @@ elif [ "$arch" = "ppc64" ]; then
>  elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
>      testdir=riscv
>      arch_libdir=riscv
> +elif [ "$arch" = "s390x" ]; then
> +    testdir=s390x
>  else
> -    testdir=$arch
> +    echo "arch $arch is not supported!"
> +    arch=
> +    usage
>  fi
>  if [ ! -d "$srcdir/$testdir" ]; then
> -    echo "$testdir does not exist!"
> +    echo "$srcdir/$testdir does not exist!"
>      exit 1
>  fi
>  
> -- 
> 2.42.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

