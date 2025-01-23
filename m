Return-Path: <kvm+bounces-36399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14C77A1A793
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 17:09:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89A8F3A9609
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 16:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C206913F42A;
	Thu, 23 Jan 2025 16:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DVQF4cvN"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368F243151
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 16:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737648557; cv=none; b=crDxlWYAq+DAx1BjG/NhWc/k6vNJ95p+hRUUwqDs6IupLhM2YNxpCCmL9Cu4fvZ4POfvBSwInzpqfuEhQ/YIedSB2Xuhu26hNPkihVoRuqo6ICT2p05sDe7VxR1IcLJJWju9iTNhlh7i4/sCj2skQjvZed6HGUWbKFRdRVCLUqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737648557; c=relaxed/simple;
	bh=lwoBZl3oqY4LVWXUeJCWM1ryckszPTb2KovOhcrzIYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JkNLDmDabm1sj3KV01XSFAQTxrS4TgdKiCVknjxjqSgUveOOEmGB1MEN9jyDvokCxuPQ5DeWZ7dlNDsMXYUYb0HEsR29m4+MM5eJbaKT0Y2gwudDAPDpMilAEsh2+V9w81dGGk+WM2xjPwvYglVH1s75Hl0dru71GuZYATbTR+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DVQF4cvN; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 23 Jan 2025 17:08:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737648537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d4GnAaYzyvNVzqbU9Z0K1r3v6m0ZKhrQvNURxdv8LTA=;
	b=DVQF4cvNhljv0hd32+JSWzgv+uS/uKE4BXn91YZq876ff9vLUDQqX8Q5Nwl3Mj+jzrEGDG
	jmkoxXhkDFOeXZwCgZpFcPjctw2Uj0JCeqqhV+FZsmh0+FrbZhtXomf3NPc6Qz+n5EKLxj
	v5oMo37Wc8CzsxqtAoOmCuLA8N6oaig=
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
Subject: Re: [kvm-unit-tests PATCH v2 17/18] unittest: Add disabled_if
 parameter and use it for kvmtool
Message-ID: <20250123-3eda2c10fdce584bdfb14971@orel>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-18-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250120164316.31473-18-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 20, 2025 at 04:43:15PM +0000, Alexandru Elisei wrote:
> The pci-test is qemu specific. Other tests perform migration, which
> isn't supported by kvmtool. In general, kvmtool is not as feature-rich
> as qemu, so add a new unittest parameter, disabled_if, that causes a
> test to be skipped if the condition evaluates to true.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/unittests.cfg    |  7 +++++++
>  docs/unittests.txt   | 13 +++++++++++++
>  scripts/common.bash  |  8 ++++++--
>  scripts/runtime.bash |  6 ++++++
>  4 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 974a5a9e4113..9b1df5e02a58 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -44,6 +44,7 @@ groups = selftest
>  # Test PCI emulation
>  [pci-test]
>  file = pci-test.flat
> +disabled_if = [[ "$TARGET" != qemu ]]
>  groups = pci
>  
>  # Test PMU support
> @@ -208,6 +209,7 @@ file = gic.flat
>  smp = $MAX_SMP
>  extra_params = -machine gic-version=3 -append 'its-migration'
>  groups = its migration
> +disabled_if = [[ "$TARGET" != qemu ]]
>  arch = arm64
>  
>  [its-pending-migration]
> @@ -215,6 +217,7 @@ file = gic.flat
>  smp = $MAX_SMP
>  extra_params = -machine gic-version=3 -append 'its-pending-migration'
>  groups = its migration
> +disabled_if = [[ "$TARGET" != qemu ]]
>  arch = arm64
>  
>  [its-migrate-unmapped-collection]
> @@ -222,6 +225,7 @@ file = gic.flat
>  smp = $MAX_SMP
>  extra_params = -machine gic-version=3 -append 'its-migrate-unmapped-collection'
>  groups = its migration
> +disabled_if = [[ "$TARGET" != qemu ]]
>  arch = arm64
>  
>  # Test PSCI emulation
> @@ -263,6 +267,7 @@ groups = debug
>  file = debug.flat
>  arch = arm64
>  extra_params = -append 'bp-migration'
> +disabled_if = [[ "$TARGET" != qemu ]]
>  groups = debug migration
>  
>  [debug-wp]
> @@ -276,6 +281,7 @@ groups = debug
>  file = debug.flat
>  arch = arm64
>  extra_params = -append 'wp-migration'
> +disabled_if = [[ "$TARGET" != qemu ]]
>  groups = debug migration
>  
>  [debug-sstep]
> @@ -289,6 +295,7 @@ groups = debug
>  file = debug.flat
>  arch = arm64
>  extra_params = -append 'ss-migration'
> +disabled_if = [[ "$TARGET" != qemu ]]
>  groups = debug migration
>  
>  # FPU/SIMD test
> diff --git a/docs/unittests.txt b/docs/unittests.txt
> index ebb6994cab77..58d1a29146a3 100644
> --- a/docs/unittests.txt
> +++ b/docs/unittests.txt
> @@ -115,3 +115,16 @@ parameter needs to be of the form <path>=<value>
>  The path and value cannot contain space, =, or shell wildcard characters.
>  
>  Can be overwritten with the CHECK environment variable with the same syntax.
> +
> +disabled_if
> +------
> +disabled_if = <condition>
> +
> +Do not run the test if <condition> is met. <condition> will be fed unmodified
> +to a bash 'if' statement and follows the same syntax.
> +
> +This can be used to prevent running a test when kvm-unit-tests is configured a
> +certain way. For example, it can be used to skip a qemu specific test when
> +using another VMM and using UEFI:
> +
> +disabled_if = [[ "$TARGET" != qemu ]] && [[ "$CONFIG_EFI" = y ]]
> diff --git a/scripts/common.bash b/scripts/common.bash
> index f54ffbd7a87b..c0ea2eabeda6 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -38,6 +38,7 @@ function for_each_unittest()
>  	local accel
>  	local timeout
>  	local kvmtool_opts
> +	local disabled_cond
>  	local rematch
>  
>  	exec {fd}<"$unittests"
> @@ -46,7 +47,7 @@ function for_each_unittest()
>  		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
>  			rematch=${BASH_REMATCH[1]}
>  			if [ -n "${testname}" ]; then
> -				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$qemu_opts" "$arch" "$machine" "$check" "$accel" "$timeout" "$kvmtool_opts"
> +				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$qemu_opts" "$arch" "$machine" "$check" "$accel" "$timeout" "$kvmtool_opts" "$disabled_cond"
>  			fi
>  			testname=$rematch
>  			smp=1
> @@ -59,6 +60,7 @@ function for_each_unittest()
>  			accel=""
>  			timeout=""
>  			kvmtool_opts=""
> +			disabled_cond=""
>  		elif [[ $line =~ ^file\ *=\ *(.*)$ ]]; then
>  			kernel=$TEST_DIR/${BASH_REMATCH[1]}
>  		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
> @@ -79,6 +81,8 @@ function for_each_unittest()
>  			machine=${BASH_REMATCH[1]}
>  		elif [[ $line =~ ^check\ *=\ *(.*)$ ]]; then
>  			check=${BASH_REMATCH[1]}
> +		elif [[ $line =~ ^disabled_if\ *=\ *(.*)$ ]]; then
> +			disabled_cond=${BASH_REMATCH[1]}
>  		elif [[ $line =~ ^accel\ *=\ *(.*)$ ]]; then
>  			accel=${BASH_REMATCH[1]}
>  		elif [[ $line =~ ^timeout\ *=\ *(.*)$ ]]; then
> @@ -86,7 +90,7 @@ function for_each_unittest()
>  		fi
>  	done
>  	if [ -n "${testname}" ]; then
> -		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$qemu_opts" "$arch" "$machine" "$check" "$accel" "$timeout" "$kvmtool_opts"
> +		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$qemu_opts" "$arch" "$machine" "$check" "$accel" "$timeout" "$kvmtool_opts" "$disabled_cond"
>  	fi
>  	exec {fd}<&-
>  }
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index abfd1e67b2ef..002bd2744d6b 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -108,6 +108,7 @@ function run()
>      local accel="$9"
>      local timeout="${10:-$TIMEOUT}" # unittests.cfg overrides the default
>      local kvmtool_opts="${11}"
> +    local disabled_cond="${12}"
>  
>      case "$TARGET" in
>      qemu)
> @@ -186,6 +187,11 @@ function run()
>          done
>      fi
>  
> +    if [[ "$disabled_cond" ]] && (eval $disabled_cond); then
> +		print_result "SKIP" $testname "" "disabled because: $disabled_cond"
> +		return 2
> +	fi
> +
>      log=$(premature_failure) && {
>          skip=true
>          if [ "${CONFIG_EFI}" == "y" ]; then
> -- 
> 2.47.1
>

I like disabled_if because I like the lambda-like thing it's doing, but I
wonder if it wouldn't be better to make TARGET a first class citizen by
adding a 'targets' unittest parameter which allows listing all targets the
test can run on, e.g.

[selftest-setup]
file = selftest.flat
smp = 2
extra_params = -m 256 -append 'setup smp=2 mem=256'
targets = qemu,kvmtool
groups = selftest

[pci-test]
file = pci-test.flat
targets = qemu
groups = pci

If targets isn't present then the default is only qemu.

Thanks,
drew

