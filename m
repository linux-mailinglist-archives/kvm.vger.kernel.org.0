Return-Path: <kvm+bounces-45740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A7DAAAE677
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 18:23:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 58F6F7BD777
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 16:20:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0A3228C02F;
	Wed,  7 May 2025 16:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eYAp/u49"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E393528C035
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 16:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746634679; cv=none; b=D1KcETzqzUyokFeEY99QTQ7dOzA+Th8sdAphakVcpFwaIbhSx9wgGupVHF7eqCF569ewp1Ic8egzo+1Bf0ODPUBw0lGvbRnC6K6ZmlIc9wJMilkop5BMHyw044mUKSNTJti7Db/FmhfyBe5U5th0ZsgeNmWjgIP3s8aBSHNahjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746634679; c=relaxed/simple;
	bh=2FIDlr2ime3JAFAdlZeq6n/NER2UZA/MoVLFGf01Pz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hgq8+4H5qQHw9+ifIuI5pfNPi7dGir5wvAi5JEVyM1Z/HuuvyW8IhDYKgC2SWbBonTxZTVzSx+YvKAn7sMHplnxsa4LmuhnT1j0cLBYYs+loxHnL5tAGBWpa3akx5z1RCFZuv93PZmV0q09Pw7NkH83OOfc4YKjKISj4Wv2sPPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eYAp/u49; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 7 May 2025 18:17:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746634674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cvzrKWSBHnMhA2RqFe405bpG/qFetQkaUeKHPSMDdpk=;
	b=eYAp/u49dgcTnoK4dpzVAsZUHnnaaMFHBKzM0e2CsX8PZ33mf+KNqyvbKnwwVLxis1itev
	onS4YWS4YGVN+DopyLEVFZJXWDWKnfiNsg3iuWjWryPYiQYFXHoGvPllp3TUW+r3UTr/rg
	O7J0M24B+QteHbV3x/qT/w1xIw/u8Ks=
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
Subject: Re: [kvm-unit-tests PATCH v3 07/16] scripts: Use an associative
 array for qemu argument names
Message-ID: <20250507-adc41db1939a5a6bd92e1322@orel>
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-8-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507151256.167769-8-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, May 07, 2025 at 04:12:47PM +0100, Alexandru Elisei wrote:
> Move away from hardcoded qemu arguments and use instead an associative
> array to get the needed arguments. This paves the way for adding kvmtool
> support to the scripts, which has a different syntax for the same VM
> configuration parameters.
> 
> Suggested-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  scripts/common.bash  | 10 +++++++---
>  scripts/runtime.bash |  7 +------
>  scripts/vmm.bash     |  7 +++++++
>  3 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/scripts/common.bash b/scripts/common.bash
> index 9deb87d4050d..649f1c737617 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -1,4 +1,5 @@
>  source config.mak
> +source scripts/vmm.bash
>  
>  function for_each_unittest()
>  {
> @@ -26,8 +27,11 @@ function for_each_unittest()
>  				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$test_args" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
>  			fi
>  			testname=$rematch
> -			smp=1
> +			smp="${vmm_opts[$TARGET:nr_cpus]} 1"

I think the wrapper functions you suggested in the cover letter might be
nice just to keep Bash from hurting people's brains too much. At least to
me,

  smp="$(vmm_optname_nr_cpus) 1"

would read better. Also note the use of 'optname' in the name to try and
help self-document that this array is holding option names, not option
values.

>  			kernel=""
> +			# Intentionally don't use -append if test_args is empty
> +			# because qemu interprets the first argument after
> +			# -append as a kernel parameter.
>  			test_args=""
>  			opts=""
>  			groups=""
> @@ -39,9 +43,9 @@ function for_each_unittest()
>  		elif [[ $line =~ ^file\ *=\ *(.*)$ ]]; then
>  			kernel=$TEST_DIR/${BASH_REMATCH[1]}
>  		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
> -			smp=${BASH_REMATCH[1]}
> +			smp="${vmm_opts[$TARGET:nr_cpus]} ${BASH_REMATCH[1]}"
>  		elif [[ $line =~ ^test_args\ *=\ *(.*)$ ]]; then
> -			test_args=${BASH_REMATCH[1]}
> +			test_args="${vmm_opts[$TARGET:args]} ${BASH_REMATCH[1]}"
>  		elif [[ $line =~ ^(extra_params|qemu_params)\ *=\ *'"""'(.*)$ ]]; then
>  			opts=${BASH_REMATCH[2]}$'\n'
>  			while read -r -u $fd; do
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 06cc58e79b69..86d8a2cd8528 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -34,7 +34,7 @@ premature_failure()
>  get_cmdline()
>  {
>      local kernel=$1
> -    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
> +    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel $smp $test_args $opts"
>  }
>  
>  skip_nodefault()
> @@ -88,11 +88,6 @@ function run()
>      local accel="${10}"
>      local timeout="${11:-$TIMEOUT}" # unittests.cfg overrides the default
>  
> -    # If $test_args is empty, qemu will interpret the first option after -append
> -    # as a kernel parameter instead of a qemu option, so make sure the -append
> -    # option is used only if $test_args is not empy.
> -    [ -n "$test_args" ] && opts="-append $test_args $opts"
> -
>      if [ "${CONFIG_EFI}" == "y" ]; then
>          kernel=${kernel/%.flat/.efi}
>      fi
> diff --git a/scripts/vmm.bash b/scripts/vmm.bash
> index 39325858c6b3..b02055a5c0b6 100644
> --- a/scripts/vmm.bash
> +++ b/scripts/vmm.bash
> @@ -1,5 +1,12 @@
>  source config.mak
>  
> +declare -A vmm_opts=(
> +	[qemu:nr_cpus]='-smp'
> +	[qemu:kernel]='-kernel'
> +	[qemu:args]='-append'
> +	[qemu:initrd]='-initrd'
> +)
> +
>  function check_vmm_supported()
>  {
>  	case "$TARGET" in
> -- 
> 2.49.0

Otherwise,

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew

