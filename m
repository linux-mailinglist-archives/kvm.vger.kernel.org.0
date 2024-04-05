Return-Path: <kvm+bounces-13732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 06AE1899FE2
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 16:36:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 671DAB20A0B
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 14:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B68316F295;
	Fri,  5 Apr 2024 14:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Aa44Mm+R"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BCE16D9D5
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 14:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712327760; cv=none; b=vEEKnm7sxY8aLyodGIbRIBq/1rnEvv6dXPiRPNxIDZjQwQRy90fKOLjk3HDbRkRw9Gl2iFvDraS0cp3njRyyxhxE/wthdH9w+OMkHaTN11rWf+hfJY/8+K73Tz76c25IEwFAOd212D014GaOnFDg/nNGG/sD8hJn0duUNGRcFyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712327760; c=relaxed/simple;
	bh=EM1r2+IGMYVTp4lLinFsQw8GM0ijMEscXpHrm52H0vw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Id0E1Em22u04V5GOQDs6CNpifApGphi9g3RpfSV89nLfy+jlDpaOWcOnlOFxjr+Xc3trwIFot1bpBK3y2iVPWwakYEkIGoGnjvXGjcLcme1GBKcWqWNd8fJ8JYPckw9go2dKoYUvfGhXFXFMCp1UfTWJp1kDFDmiNZrZvDdzRes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Aa44Mm+R; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Apr 2024 16:35:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712327756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ETKsELrYkAlYEwqClpDWN3hl+gbul0F+CDrs2+tURzo=;
	b=Aa44Mm+RbQg4oXP+ngINuvGjXpXPvqqivWyDFZEtzu8ZGewKa2XI96BtznPzpcPv/Xapss
	qSnBI4X2tfmaSCEzND6qX4wTAJiPHtBEYwzsUBH4Wq1Rgd30zFGkTUsVHE9QDomYJeqnU7
	KbUkpOo0B4OeRIBVDCk+lEnaMMmlKn0=
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
Subject: Re: [kvm-unit-tests RFC PATCH 11/17] shellcheck: Fix SC2145
Message-ID: <20240405-a35419152685e6aca33ccc04@orel>
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-12-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405090052.375599-12-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 05, 2024 at 07:00:43PM +1000, Nicholas Piggin wrote:
>   SC2145 (error): Argument mixes string and array. Use * or separate
>   argument.
> 
> Could be a bug?

I don't think so, since the preceding string ends with a space and there
aren't any succeeding strings. Anyway, it's good to switch to *

> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arm/efi/run             | 2 +-
>  riscv/efi/run           | 2 +-
>  scripts/mkstandalone.sh | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arm/efi/run b/arm/efi/run
> index f07a6e55c..cf6d34b0b 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -87,7 +87,7 @@ uefi_shell_run()
>  if [ "$EFI_DIRECT" = "y" ]; then
>  	$TEST_DIR/run \
>  		$KERNEL_NAME \
> -		-append "$(basename $KERNEL_NAME) ${cmd_args[@]}" \
> +		-append "$(basename $KERNEL_NAME) ${cmd_args[*]}" \
>  		-bios "$EFI_UEFI" \
>  		"${qemu_args[@]}"
>  else
> diff --git a/riscv/efi/run b/riscv/efi/run
> index 982b8b9c4..cce068694 100755
> --- a/riscv/efi/run
> +++ b/riscv/efi/run
> @@ -97,7 +97,7 @@ if [ "$EFI_DIRECT" = "y" ]; then
>  	fi
>  	$TEST_DIR/run \
>  		$KERNEL_NAME \
> -		-append "$(basename $KERNEL_NAME) ${cmd_args[@]}" \
> +		-append "$(basename $KERNEL_NAME) ${cmd_args[*]}" \
>  		-machine pflash0=pflash0 \
>  		-blockdev node-name=pflash0,driver=file,read-only=on,filename="$EFI_UEFI" \
>  		"${qemu_args[@]}"
> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> index 86c7e5498..756647f29 100755
> --- a/scripts/mkstandalone.sh
> +++ b/scripts/mkstandalone.sh
> @@ -76,7 +76,7 @@ generate_test ()
>  
>  	cat scripts/runtime.bash
>  
> -	echo "run ${args[@]}"
> +	echo "run ${args[*]}"
>  }
>  
>  function mkstandalone()
> -- 
> 2.43.0
> 
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

