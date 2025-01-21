Return-Path: <kvm+bounces-36130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB4E4A18152
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:46:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64F843A415C
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 15:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF2F91F470D;
	Tue, 21 Jan 2025 15:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wyEI24cw"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6149A1F3FF4
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 15:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737474393; cv=none; b=PQxL1pw4U2fzeYrip6WzSVzViXN3wEBYEj01ffiTrOL19y6m89wSiDb7MVIN38LoVi61Pb52BXZHaH+nT3uQBakbNoRFNVr5MgfEddVZkUWnrYlmff4ndqByfeuW4l/oOwyz1aJUghC0PKf2yy7CuC5dT8n8fsXSkzl+yM19p8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737474393; c=relaxed/simple;
	bh=tiDhtmxJoJvjZcrOXt3MqPOYu9ynodG28rtiIrzdflE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lb4QkuEl6nFKyWsP6kOEfuKi9mG2IhPvOcMeFTTa+HOvGgL52OdnG59TykYOUTfsvsLXiPgg09MXR+Bp6yymftD7QdT5EVLZocLKTKeqdt3RUUiWBATbE3hI30o7slitBJdDf33DwoBzyehvo3NsY5dFBDoRN+2wdNjSPMJAXuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wyEI24cw; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 21 Jan 2025 16:46:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737474387;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=udA8JggagAJP1CCzeg7Vekhu/UmA/lRvh6yXXvJFf1k=;
	b=wyEI24cwFn/2SwnlrYJNsedCvXcu1OErKkpuVcynU6RgbSJLXlGwdYlCavdBXZgGUQjG7v
	7nJ7yr9z5NxYNO9Oh6Xcq6ZgaYL4DDkiGbXw9w+UDPiGpwdVz1H4QfuenjOVrwsfae4IhX
	volbSCuXEznlwkkvWfCPgEfeJbira3U=
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
Subject: Re: [kvm-unit-tests PATCH v2 04/18] run_tests: Introduce unittest
 parameter 'qemu_params'
Message-ID: <20250121-82874afe4e52c828d21e7da2@orel>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-5-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250120164316.31473-5-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 20, 2025 at 04:43:02PM +0000, Alexandru Elisei wrote:
> Tests for the arm and arm64 architectures can also be run with kvmtool, and
> work is under way to have it supported by the run_tests.sh test runner. Not
> suprisingly, kvmtool has a different syntax than qemu when configuring and
> running a virtual machine.
> 
> Add a new unittest parameter, 'qemu_params', with the goal to add a similar
> parameter for each virtual machine manager that run_tests.sh supports.
> 
> 'qemu_params' and 'extra_params' are interchangeable, but it is expected
> that going forward new tests will use 'qemu_params'. A test should have
> only one of the two parameters.
> 
> While we're at it, rename the variable opts to qemu_opts to match the new
> unit configuration name, and to make it easier to distinguish from the
> kvmtool parameters when they'll be added.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  docs/unittests.txt   | 17 +++++++++-----
>  scripts/common.bash  | 53 ++++++++++++++++++++++++++------------------
>  scripts/runtime.bash | 10 ++++-----
>  3 files changed, 47 insertions(+), 33 deletions(-)
> 
> diff --git a/docs/unittests.txt b/docs/unittests.txt
> index dbc2c11e3b59..3e1a9e563016 100644
> --- a/docs/unittests.txt
> +++ b/docs/unittests.txt
> @@ -24,9 +24,9 @@ param = value format.
>  
>  Available parameters
>  ====================
> -Note! Some parameters like smp and extra_params modify how a test is run,
> -while others like arch and accel restrict the configurations in which the
> -test is run.
> +Note! Some parameters like smp and qemu_params/extra_params modify how a
> +test is run, while others like arch and accel restrict the configurations
> +in which the test is run.
>  
>  file
>  ----
> @@ -56,13 +56,18 @@ smp = <number>
>  Optional, the number of processors created in the machine to run the test.
>  Defaults to 1. $MAX_SMP can be used to specify the maximum supported.
>  
> -extra_params
> -------------
> +qemu_params
> +-----------
>  These are extra parameters supplied to the QEMU process. -append '...' can
>  be used to pass arguments into the test case argv. Multiple parameters can
>  be added, for example:
>  
> -extra_params = -m 256 -append 'smp=2'
> +qemu_params = -m 256 -append 'smp=2'
> +
> +extra_params
> +------------
> +Alias for 'qemu_params', supported for compatibility purposes. Use
> +'qemu_params' for new tests.
>  
>  groups
>  ------
> diff --git a/scripts/common.bash b/scripts/common.bash
> index 3aa557c8c03d..a40c28121b6a 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -1,5 +1,28 @@
>  source config.mak
>  
> +function parse_opts()
> +{
> +	local opts="$1"
> +	local fd="$2"
> +
> +	while read -r -u $fd; do
> +		#escape backslash newline, but not double backslash
> +		if [[ $opts =~ [^\\]*(\\*)$'\n'$ ]]; then
> +			if (( ${#BASH_REMATCH[1]} % 2 == 1 )); then
> +				opts=${opts%\\$'\n'}
> +			fi
> +		fi
> +		if [[ "$REPLY" =~ ^(.*)'"""'[:blank:]*$ ]]; then
> +			opts+=${BASH_REMATCH[1]}
> +			break
> +		else
> +			opts+=$REPLY$'\n'
> +		fi
> +	done
> +
> +	echo "$opts"
> +}
> +
>  function for_each_unittest()
>  {
>  	local unittests="$1"
> @@ -7,7 +30,7 @@ function for_each_unittest()
>  	local testname
>  	local smp
>  	local kernel
> -	local opts
> +	local qemu_opts
>  	local groups
>  	local arch
>  	local machine
> @@ -22,12 +45,12 @@ function for_each_unittest()
>  		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
>  			rematch=${BASH_REMATCH[1]}
>  			if [ -n "${testname}" ]; then
> -				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
> +				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$qemu_opts" "$arch" "$machine" "$check" "$accel" "$timeout"
>  			fi
>  			testname=$rematch
>  			smp=1
>  			kernel=""
> -			opts=""
> +			qemu_opts=""
>  			groups=""
>  			arch=""
>  			machine=""
> @@ -38,24 +61,10 @@ function for_each_unittest()
>  			kernel=$TEST_DIR/${BASH_REMATCH[1]}
>  		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
>  			smp=${BASH_REMATCH[1]}
> -		elif [[ $line =~ ^extra_params\ *=\ *'"""'(.*)$ ]]; then
> -			opts=${BASH_REMATCH[1]}$'\n'
> -			while read -r -u $fd; do
> -				#escape backslash newline, but not double backslash
> -				if [[ $opts =~ [^\\]*(\\*)$'\n'$ ]]; then
> -					if (( ${#BASH_REMATCH[1]} % 2 == 1 )); then
> -						opts=${opts%\\$'\n'}
> -					fi
> -				fi
> -				if [[ "$REPLY" =~ ^(.*)'"""'[:blank:]*$ ]]; then
> -					opts+=${BASH_REMATCH[1]}
> -					break
> -				else
> -					opts+=$REPLY$'\n'
> -				fi
> -			done
> -		elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
> -			opts=${BASH_REMATCH[1]}
> +		elif [[ $line =~ ^(extra_params|qemu_params)\ *=\ *'"""'(.*)$ ]]; then
> +			qemu_opts=$(parse_opts ${BASH_REMATCH[2]}$'\n' $fd)
> +		elif [[ $line =~ ^(extra_params|qemu_params)\ *=\ *(.*)$ ]]; then
> +			qemu_opts=${BASH_REMATCH[2]}
>  		elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
>  			groups=${BASH_REMATCH[1]}
>  		elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
> @@ -71,7 +80,7 @@ function for_each_unittest()
>  		fi
>  	done
>  	if [ -n "${testname}" ]; then
> -		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
> +		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$qemu_opts" "$arch" "$machine" "$check" "$accel" "$timeout"
>  	fi
>  	exec {fd}<&-
>  }
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 4b9c7d6b7c39..e5d661684ceb 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -34,7 +34,7 @@ premature_failure()
>  get_cmdline()
>  {
>      local kernel=$1
> -    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
> +    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $qemu_opts"
>  }
>  
>  skip_nodefault()
> @@ -80,7 +80,7 @@ function run()
>      local groups="$2"
>      local smp="$3"
>      local kernel="$4"
> -    local opts="$5"
> +    local qemu_opts="$5"
>      local arch="$6"
>      local machine="$7"
>      local check="${CHECK:-$8}"
> @@ -179,9 +179,9 @@ function run()
>          echo $cmdline
>      fi
>  
> -    # extra_params in the config file may contain backticks that need to be
> -    # expanded, so use eval to start qemu.  Use "> >(foo)" instead of a pipe to
> -    # preserve the exit status.
> +    # qemu_params/extra_params in the config file may contain backticks that
> +    # need to be expanded, so use eval to start qemu.  Use "> >(foo)" instead of
> +    # a pipe to preserve the exit status.
>      summary=$(eval "$cmdline" 2> >(RUNTIME_log_stderr $testname) \
>                               > >(tee >(RUNTIME_log_stdout $testname $kernel) | extract_summary))
>      ret=$?
> -- 
> 2.47.1
>

Hmm, I'll keep reading the series, but it seems like we should be choosing
generic names like 'extra_params' and 'opts' that we plan to use for both
QEMU and kvmtool since they both have the concepts of "options" and "extra
params".

Thanks,
drew

