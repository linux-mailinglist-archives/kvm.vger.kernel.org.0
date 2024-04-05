Return-Path: <kvm+bounces-13739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 309DD89A045
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 16:55:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 540171C231EB
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 14:55:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C79CD16F29D;
	Fri,  5 Apr 2024 14:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UPGfh8js"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2807316DEAB
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 14:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712328920; cv=none; b=MvjDKXwcSlJ3M7M1D2iN1VPkGhz+vk190Wa8PxCxMJ/V3Pm04YNKS44UFGxsNomX01IBXvnr9y9LVLsvmJinPJd5ExpgzWnCeJtxLRTg/Gy80X0yc75Zan4mz3NUnkirgqiQo1qdBagaRoANK6qhpG8O79N87yDsc8jmbapL6mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712328920; c=relaxed/simple;
	bh=TIvxRamlGcEopprPfoOfil978It8TfZKohpyLwgS5xQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pr90YMq8MivBPflCYzzbnbAVM939MPV3OYPfJvBQEKpviJQnuZuImAJzvltV9umElFUCpzM9W3KwUnZd2rQuv31dyzk0XOsyzMzBSo3ue0lGPGoENgBou000whZJzvPbjjBrPUtyjPp7iqFb/mfag2JyVNmJ09xoqeTcvDcVAyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UPGfh8js; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Apr 2024 16:55:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712328915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KuvmwAv3VPVb8MBua4W2SdgjKunVcw3LYDYqO33OqqI=;
	b=UPGfh8jsD5lqKDj1vL6jVkxU1ehLYEyqACmwvkXo4A1QODGZmTkJYm/uoZxk+tugSvUT8m
	Fzy/T3wbUTwQmj77BvsmaHSJAXPmNFrLIClAlvK2Q8BtdZDUVktaxUM662+3ZGI3MqQz+P
	P+5k6FDHCXb+SpXhh4QPmx/BEktxQHg=
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
Subject: Re: [kvm-unit-tests RFC PATCH 17/17] shellcheck: Suppress various
 messages
Message-ID: <20240405-7c0ad5d3ce76e1ad9ad2f5a9@orel>
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-18-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405090052.375599-18-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 05, 2024 at 07:00:49PM +1000, Nicholas Piggin wrote:
> Various info and warnings are suppressed here, where circumstances
> (commented) warrant.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  run_tests.sh            | 3 +++
>  scripts/arch-run.bash   | 9 +++++++++
>  scripts/mkstandalone.sh | 2 ++
>  scripts/runtime.bash    | 2 ++
>  4 files changed, 16 insertions(+)
> 
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
> index ed440b4aa..fe8785cfd 100644
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
> @@ -184,6 +189,8 @@ run_migration ()
>  		-mon chardev=mon,mode=control \
>  		< ${src_infifo} > ${src_outfifo} &
>  	live_pid=$!
> +	# SC complains about useless cat but I prefer it over redirect here.

Let's spell out 'shellcheck' when referring to it rather than call it
'SC'. And instead of "but I prefer..." let's write

 # shellcheck complains about a useless cat, but using a redirect here is
 # harder to read

or something like that. Don't tell my cat-loving daughter that I just
wrote "a useless cat"!


> +	# shellcheck disable=SC2002
>  	cat ${src_outfifo} | tee ${src_out} | filter_quiet_msgs &
>  
>  	# Start the first destination QEMU machine in advance of the test
> @@ -224,6 +231,8 @@ do_migration ()
>  		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
>  		< ${dst_infifo} > ${dst_outfifo} &
>  	incoming_pid=$!
> +	# SC complains about useless cat but I prefer it over redirect here.

Same comment as above.

> +	# shellcheck disable=SC2002
>  	cat ${dst_outfifo} | tee ${dst_out} | filter_quiet_msgs &
>  
>  	# The test must prompt the user to migrate, so wait for the
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
> index 3b76aec9e..c87613b96 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -137,6 +137,8 @@ function run()
>      # the check line can contain multiple files to check separated by a space
>      # but each check parameter needs to be of the form <path>=<value>
>      if [ "$check" ]; then
> +        # There is no globbing allowed in the check parameter.
> +        # shellcheck disable=SC2206
>          check=($check)

Hmm, I'm not sure about this one. $check is an arbitrary path, which means
it can have spaces, then =, and then an arbitrary value, which means it can
contain spaces. If there are multiple check path=value pairs then
separation by space is a bad idea, and any deliminator really is. It seems
like each pair should be quoted, i.e.

 check = "path1=value1" "path2=value2"

and then that should be managed here.

>          for check_param in "${check[@]}"; do
>              path=${check_param%%=*}
> -- 
> 2.43.0
>

Thanks,
drew

