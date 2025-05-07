Return-Path: <kvm+bounces-45746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6460FAAE719
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 18:47:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98E531C22D1D
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 16:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F87128C006;
	Wed,  7 May 2025 16:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xjTaAO9U"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643C419AD5C;
	Wed,  7 May 2025 16:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746636435; cv=none; b=b64WRLRRMVn3ntcg69MXg2snHxPe3aLZYnrwR3kCRctb3bwO+psi5tz7u6W6sKyIO2z8UXcEFaHnfe1MrSev7hVuo0BiOFIYTYUkJOwFj989iBuFRi3H2FQXgvRzk9wEPtrKTb3xiuklbMN0PTp+wE2PrQaLGK7xa9Huztio3vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746636435; c=relaxed/simple;
	bh=WexEtTeXQJWWrl4V/fPsvTprhF8zQsVAgXNJq/GSDCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZlIupP4WqyzcRClLrZGYa4rK+p5kwzdE/klD5P4LvuRtUlkLDAdY7cQvAtUI4x9cmj6shV4MPiUPxzY4K+OvybWfsCeixYx5EhwtGF2gYyexo14WInqxXLohx24hEeU84qv/S/buVN3PVpH0I1C28Cvgbn1nBSW1zvauaNcSVq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xjTaAO9U; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 7 May 2025 18:47:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746636431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nq0jvPXcCaXcZzDjqmWJrmU0XBhQs2iQrx8JeAPfxmg=;
	b=xjTaAO9U8LQ4Kd2hRhF3e7XyPcfoUKEneZZEGF63X62j83ZwidnhiT0cNab9+CxKKAinqs
	tQrsKIMffkrdIVznOheKfefvPn0Cvws33o9gx/1+kb6bnqYhrsToL/MFO8XcsBXols2z6S
	vS0CRp0fg8fKA82L2HYyV6KJxOp4Rvo=
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
Subject: Re: [kvm-unit-tests PATCH v3 12/16] scripts: Detect kvmtool failure
 in premature_failure()
Message-ID: <20250507-44b6574c7e69e3c56d762552@orel>
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-13-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507151256.167769-13-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, May 07, 2025 at 04:12:52PM +0100, Alexandru Elisei wrote:
> kvm-unit-tests assumes that if the VMM is able to get to where it tries to
> load the kernel, then the VMM and the configuration parameters will also
> work for running the test. All of this is done in premature_failure().
> 
> Teach premature_failure() about the kvmtool's error message when it fails
> to load the dummy kernel.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  scripts/runtime.bash |  8 +++-----
>  scripts/vmm.bash     | 23 +++++++++++++++++++++++
>  2 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 86d8a2cd8528..01ec8eae2bba 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -1,3 +1,5 @@
> +source scripts/vmm.bash
> +
>  : "${RUNTIME_arch_run?}"
>  : "${MAX_SMP:=$(getconf _NPROCESSORS_ONLN)}"
>  : "${TIMEOUT:=90s}"
> @@ -19,11 +21,7 @@ premature_failure()
>  
>      log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
>  
> -    echo "$log" | grep "_NO_FILE_4Uhere_" |
> -        grep -q -e "[Cc]ould not \(load\|open\) kernel" \
> -                -e "error loading" \
> -                -e "failed to load" &&
> -        return 1
> +    ${vmm_opts[$TARGET:parse_premature_failure]} "$log" || return 1
>  
>      RUNTIME_log_stderr <<< "$log"
>  
> diff --git a/scripts/vmm.bash b/scripts/vmm.bash
> index d24a4c4b8713..a1d50ed51981 100644
> --- a/scripts/vmm.bash
> +++ b/scripts/vmm.bash
> @@ -93,6 +93,27 @@ kvmtool_fixup_return_code()
>  	echo $ret
>  }
>  
> +function qemu_parse_premature_failure()
> +{
> +	local log="$@"
> +
> +	echo "$log" | grep "_NO_FILE_4Uhere_" |
> +		grep -q -e "[Cc]ould not \(load\|open\) kernel" \
> +			-e "error loading" \
> +			-e "failed to load" &&
> +		return 1
> +	return 0
> +}
> +
> +function kvmtool_parse_premature_failure()
> +{
> +	local log="$@"
> +
> +	echo "$log" | grep "Fatal: Unable to open kernel _NO_FILE_4Uhere_" &&
> +		return 1
> +	return 0
> +}
> +
>  declare -A vmm_opts=(
>  	[qemu:nr_cpus]='-smp'
>  	[qemu:kernel]='-kernel'
> @@ -100,6 +121,7 @@ declare -A vmm_opts=(
>  	[qemu:initrd]='-initrd'
>  	[qemu:default_opts]=''
>  	[qemu:fixup_return_code]=qemu_fixup_return_code
> +	[qemu:parse_premature_failure]=qemu_parse_premature_failure
>  
>  	[kvmtool:nr_cpus]='--cpus'
>  	[kvmtool:kernel]='--kernel'
> @@ -107,6 +129,7 @@ declare -A vmm_opts=(
>  	[kvmtool:initrd]='--initrd'
>  	[kvmtool:default_opts]="$KVMTOOL_DEFAULT_OPTS"
>  	[kvmtool:fixup_return_code]=kvmtool_fixup_return_code
> +	[kvmtool:parse_premature_failure]=kvmtool_parse_premature_failure
>  )
>  
>  function check_vmm_supported()
> -- 
> 2.49.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

