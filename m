Return-Path: <kvm+bounces-45747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52976AAE725
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 18:49:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7E94521C8E
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 16:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACA1028C2AC;
	Wed,  7 May 2025 16:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pZjO/Dq1"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1454D28C010
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 16:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746636549; cv=none; b=OUQRqvkOgckkFFCkVSQBhCQ9GYelWiJkBLnRIGW0alXWQ7Zq6QfnKkX/v1PEO9z7oq4FRkMOy3g/N0rOz9M8kWlE53neYOyL9kUV/C8yagG12r2nz/7TbqPG9jGR6aQEW/4RrjFwi++oT6ta09tvqJCRjm4HvY9t6+qV6iNKsmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746636549; c=relaxed/simple;
	bh=wxCODKOePKold4q93rQqVAcKOk8IvN0MouYIDz/4a4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lw2CPrLtmhNQBY7vPmRp0e78jLRiZLKs8BHBhnUeMoF1CP9GyOMae/i0+W9QY267dvaPbhSlQNYmKi2DACyHE5KIOFhYVPslCPPoGDqLzaVvcwZcu546i07aKWVZ3XSq9y+lXYRvuuG5ie7+UgDEVUFZi7sNUlJsMn6LLUz1RLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pZjO/Dq1; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 7 May 2025 18:48:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746636535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2RpamE2srlpqeXHrljbpcOM2Ay/589KHDerW4ekHgUI=;
	b=pZjO/Dq1wiCjg2M3GtCbh5dD3dLgzdP6L3Kwa+o1eEo5wqwXY9g4EhJqMQY/Bi/EpxnfA0
	558VvSquXY1JzId+uqGR9L0c8F8U/bW2i0cbPFE5/5UzbATwdBpa9GCxfLKSp/MNrFT22H
	+23vVs422Ir3vA6F77jcwbdE2AsR2Cc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
	andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 13/16] scripts: Do not probe for
 maximum number of VCPUs when using kvmtool
Message-ID: <20250507-71bfb831e524b5c437c6a828@orel>
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-14-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507151256.167769-14-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, May 07, 2025 at 04:12:53PM +0100, Alexandru Elisei wrote:
> The --probe-maxsmp parameter updates MAX_SMP with the maximum number of
> VCPUs that the host supports. Qemu will exit with an error when creating a
> virtual machine if the number of VCPUs is exceeded.
> 
> kvmtool behaves differently: it will automatically limit the number of
> VCPUs to the what KVM supports, which is exactly what --probe-maxsmp wants
> to achieve. When doing --probe-maxsmp with kvmtool, print a message
> explaining why it's redundant and don't do anything else.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  run_tests.sh         |  3 ++-
>  scripts/runtime.bash | 16 ----------------
>  scripts/vmm.bash     | 24 ++++++++++++++++++++++++
>  3 files changed, 26 insertions(+), 17 deletions(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index 150a06a91064..a69c3665b7a4 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -10,6 +10,7 @@ if [ ! -f config.mak ]; then
>  fi
>  source config.mak
>  source scripts/common.bash
> +source scripts/vmm.bash
>  
>  function usage()
>  {
> @@ -90,7 +91,7 @@ while [ $# -gt 0 ]; do
>              list_tests="yes"
>              ;;
>          --probe-maxsmp)
> -            probe_maxsmp
> +            ${vmm_opts[$TARGET:probe_maxsmp]}
>              ;;
>          --)
>              ;;
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 01ec8eae2bba..a802686c511d 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -209,19 +209,3 @@ function run()
>  
>      return $ret
>  }
> -
> -#
> -# Probe for MAX_SMP, in case it's less than the number of host cpus.
> -#
> -function probe_maxsmp()
> -{
> -	local smp
> -
> -	if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'SMP CPUs'); then
> -		smp=${smp##* }
> -		smp=${smp/\(}
> -		smp=${smp/\)}
> -		echo "Restricting MAX_SMP from ($MAX_SMP) to the max supported ($smp)" >&2
> -		MAX_SMP=$smp
> -	fi
> -}
> diff --git a/scripts/vmm.bash b/scripts/vmm.bash
> index a1d50ed51981..ef9819f4132c 100644
> --- a/scripts/vmm.bash
> +++ b/scripts/vmm.bash
> @@ -105,6 +105,22 @@ function qemu_parse_premature_failure()
>  	return 0
>  }
>  
> +#
> +# Probe for MAX_SMP, in case it's less than the number of host cpus.
> +#
> +function qemu_probe_maxsmp()
> +{
> +	local smp
> +
> +	if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'SMP CPUs'); then
> +		smp=${smp##* }
> +		smp=${smp/\(}
> +		smp=${smp/\)}
> +		echo "Restricting MAX_SMP from ($MAX_SMP) to the max supported ($smp)" >&2
> +		MAX_SMP=$smp
> +	fi
> +}
> +
>  function kvmtool_parse_premature_failure()
>  {
>  	local log="$@"
> @@ -114,6 +130,12 @@ function kvmtool_parse_premature_failure()
>  	return 0
>  }
>  
> +function kvmtool_probe_maxsmp()
> +{
> +	echo "kvmtool automatically limits the number of VCPUs to maximum supported"
> +	echo "The 'smp' test parameter won't be modified"
> +}
> +
>  declare -A vmm_opts=(
>  	[qemu:nr_cpus]='-smp'
>  	[qemu:kernel]='-kernel'
> @@ -122,6 +144,7 @@ declare -A vmm_opts=(
>  	[qemu:default_opts]=''
>  	[qemu:fixup_return_code]=qemu_fixup_return_code
>  	[qemu:parse_premature_failure]=qemu_parse_premature_failure
> +	[qemu:probe_maxsmp]=qemu_probe_maxsmp
>  
>  	[kvmtool:nr_cpus]='--cpus'
>  	[kvmtool:kernel]='--kernel'
> @@ -130,6 +153,7 @@ declare -A vmm_opts=(
>  	[kvmtool:default_opts]="$KVMTOOL_DEFAULT_OPTS"
>  	[kvmtool:fixup_return_code]=kvmtool_fixup_return_code
>  	[kvmtool:parse_premature_failure]=kvmtool_parse_premature_failure
> +	[kvmtool:probe_maxsmp]=kvmtool_probe_maxsmp
>  )
>  
>  function check_vmm_supported()
> -- 
> 2.49.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

