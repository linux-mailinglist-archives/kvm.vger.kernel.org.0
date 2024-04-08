Return-Path: <kvm+bounces-13849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E20489B895
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 09:37:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC29E1F2250D
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 07:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 438A629CEA;
	Mon,  8 Apr 2024 07:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U4d+S2DE"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2782C69A
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 07:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712561857; cv=none; b=UOXoSHjClLl/Rdu+Yg1wsyCp7x97TEs/YTeSC8NuIg8ampgTrCAxZ8L+t+WUhJUFcArg0HGKnqXqZWK6B0CP1gtcLPfi70lm4Hhr394Q5AKrzLNqAvLmkoS7ga2Y1UhyFutVExzA/y8U6r8fZeX3x9Qd4AMUL2jaSb559hOONHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712561857; c=relaxed/simple;
	bh=4GiidcTTSsiYJWtZd4SF33IW/1FZ/QMl2f1QpKZ57Z4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hYwRGKZg/gsVNEWGJEmEiJvG+9utlOxpNoYCVL8UENDO5MaKtSi3FjMbjbz55GXoQkxgTRqng2ed+pw6GHtUk4d4UiAyqCZh/QaV6aX/DW0ITVsxrguXdfk+AAxtrkIBo9K1HAr6YdrBNO9+hOfyvovF92f+7uRt2PbbZKk5rjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U4d+S2DE; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 8 Apr 2024 09:37:29 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712561853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yUU/YNv1R3O6wJ4nE+rJs4XO4vBQk8D5yD3QxFFxfSc=;
	b=U4d+S2DEtsYqcQsTCa3qReBqBiyZqXw5ScuELdnL0C+PZd8kbfNbmwmqGl3+xCsF1dj93f
	7hTkLfye6VevHgpUYG7O4uxCjQYNIbFN4q55S4uPjOb0bnts+Qr9f75M2Fb6lAzC5lbWM1
	VCPbVxB6Z/RZxbUBdpzNgGLyptDPe3Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Nico =?utf-8?B?QsO2aHI=?= <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	David Woodhouse <dwmw@amazon.co.uk>, Ricardo Koller <ricarkol@google.com>, 
	rminmin <renmm6@chinaunicom.cn>, Gavin Shan <gshan@redhat.com>, 
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [RFC kvm-unit-tests PATCH v2 14/14] shellcheck: Suppress various
 messages
Message-ID: <20240408-c1fd647357babc836cf85914@orel>
References: <20240406123833.406488-1-npiggin@gmail.com>
 <20240406123833.406488-15-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240406123833.406488-15-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Apr 06, 2024 at 10:38:23PM +1000, Nicholas Piggin wrote:
> Various info and warnings are suppressed here, where circumstances
> (commented) warrant.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  configure               |  2 ++
>  run_tests.sh            |  3 +++
>  scripts/arch-run.bash   | 15 +++++++++++++++
>  scripts/mkstandalone.sh |  2 ++
>  scripts/runtime.bash    |  2 ++
>  5 files changed, 24 insertions(+)
> 
> diff --git a/configure b/configure
> index 8508396af..6ebac7e0a 100755
> --- a/configure
> +++ b/configure
> @@ -437,6 +437,8 @@ ln -sf "$asm" lib/asm
>  
>  # create the config
>  cat <<EOF > config.mak
> +# Shellcheck does not see these are used
> +# shellcheck disable=SC2034
>  SRCDIR=$srcdir
>  PREFIX=$prefix
>  HOST=$host
> diff --git a/run_tests.sh b/run_tests.sh
> index 938bb8edf..152323ffc 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -45,6 +45,9 @@ fi
>  only_tests=""
>  list_tests=""
>  args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list,probe-maxsmp -- "$@")
> +# Shellcheck likes to test commands directly rather than with $? but sometimes they
> +# are too long to put in the same test.
> +# shellcheck disable=SC2181
>  [ $? -ne 0 ] && exit 2;
>  set -- $args;
>  while [ $# -gt 0 ]; do
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 98d29b671..7e5b2bdf1 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -44,6 +44,8 @@ run_qemu ()
>  	if [ "$errors" ]; then
>  		sig=$(grep 'terminating on signal' <<<"$errors")
>  		if [ "$sig" ]; then
> +			# This is too complex for ${var/search/replace}
> +			# shellcheck disable=SC2001
>  			sig=$(sed 's/.*terminating on signal \([0-9][0-9]*\).*/\1/' <<<"$sig")
>  		fi
>  	fi
> @@ -174,9 +176,12 @@ run_migration ()
>  
>  	# Holding both ends of the input fifo open prevents opens from
>  	# blocking and readers getting EOF when a writer closes it.
> +	# These fds appear to be unused to shellcheck so quieten the warning.
>  	mkfifo ${src_infifo}
>  	mkfifo ${dst_infifo}
> +	# shellcheck disable=SC2034
>  	exec {src_infifo_fd}<>${src_infifo}
> +	# shellcheck disable=SC2034
>  	exec {dst_infifo_fd}<>${dst_infifo}
>  
>  	"${migcmdline[@]}" \
> @@ -184,6 +189,9 @@ run_migration ()
>  		-mon chardev=mon,mode=control \
>  		< ${src_infifo} > ${src_outfifo} &
>  	live_pid=$!
> +	# Shellcheck complains about useless cat but it is clearer than a
> +	# redirect in this case.
> +	# shellcheck disable=SC2002
>  	cat ${src_outfifo} | tee ${src_out} | filter_quiet_msgs &
>  
>  	# Start the first destination QEMU machine in advance of the test
> @@ -224,6 +232,9 @@ do_migration ()
>  		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
>  		< ${dst_infifo} > ${dst_outfifo} &
>  	incoming_pid=$!
> +	# Shellcheck complains about useless cat but it is clearer than a
> +	# redirect in this case.
> +	# shellcheck disable=SC2002
>  	cat ${dst_outfifo} | tee ${dst_out} | filter_quiet_msgs &
>  
>  	# The test must prompt the user to migrate, so wait for the
> @@ -467,6 +478,8 @@ env_params ()
>  			[ -n "$ACCEL" ] && QEMU_ACCEL=$ACCEL
>  		fi
>  		QEMU_VERSION_STRING="$($qemu -h | head -1)"
> +		# SC does not seee QEMU_MAJOR|MINOR|MICRO are used

Shellcheck does not see

> +		# shellcheck disable=SC2034
>  		IFS='[ .]' read -r _ _ _ QEMU_MAJOR QEMU_MINOR QEMU_MICRO rest <<<"$QEMU_VERSION_STRING"
>  	fi
>  	env_add_params QEMU_ACCEL QEMU_VERSION_STRING QEMU_MAJOR QEMU_MINOR QEMU_MICRO
> @@ -597,6 +610,8 @@ hvf_available ()
>  
>  set_qemu_accelerator ()
>  {
> +	# Shellcheck does not seee ACCEL_PROPS is used

see

> +	# shellcheck disable=SC2034
>  	ACCEL_PROPS=${ACCEL#"${ACCEL%%,*}"}
>  	ACCEL=${ACCEL%%,*}
>  
> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> index 756647f29..2318a85f0 100755
> --- a/scripts/mkstandalone.sh
> +++ b/scripts/mkstandalone.sh
> @@ -65,6 +65,8 @@ generate_test ()
>  	fi
>  
>  	temp_file bin "$kernel"
> +	# Don't want to expand $bin but print it as-is.
> +	# shellcheck disable=SC2016
>  	args[3]='$bin'
>  
>  	(echo "#!/usr/bin/env bash"
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 3b76aec9e..6e712214d 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -137,6 +137,8 @@ function run()
>      # the check line can contain multiple files to check separated by a space
>      # but each check parameter needs to be of the form <path>=<value>
>      if [ "$check" ]; then
> +        # There is no globbing or whitespace allowed in check parameters.
> +        # shellcheck disable=SC2206
>          check=($check)
>          for check_param in "${check[@]}"; do
>              path=${check_param%%=*}
> -- 
> 2.43.0
>

Other than comment fixes,

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

