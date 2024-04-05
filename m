Return-Path: <kvm+bounces-13727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 35BA0899F6F
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 16:21:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA991B228F9
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 14:21:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51DA416EBFA;
	Fri,  5 Apr 2024 14:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tIvHyrlY"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B721BDDB;
	Fri,  5 Apr 2024 14:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712326832; cv=none; b=JTpV9FvYkqGIFLdKqiAPslj+mrsy1KLxTar4wESsjRbBASVKnh4jQybft+vzXLk9iXx6IQByAmQvnlA/VRWg5yT+NJtw/SyBCddg1+PuV84Bpy3y/3Gqa+1xn2Oxkh9DS5YX5qh/TLT7UoScTTF3wRDNoS9BuWcifUy2gM+EGHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712326832; c=relaxed/simple;
	bh=w9C4wAW7Kg2MDnYR0fe+jduEC+O9W2FZjTIJQAD3Ix0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qaMbx6Nz0IMX87Zg5ll0VBriy1LPiUI95vz4ylVyUCp4IRzyLM4Z8xXecBIy80Jh2UYG5gBp/UXrrvsBmGYuLAf9gMLiZjjGY3KcUXv/gZi/EYx8maF+VD2kPO1NVvOzRN0vzjr90w/NiSYCsoPHknIx2uD2/TSRi/D7b4mxv8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tIvHyrlY; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Apr 2024 16:20:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712326828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MOSx3BzPQS+vZdQcxrNLE9aFU+hZ/w1SOzqu1gCO9es=;
	b=tIvHyrlYDa/Lfu7I+w3IKTWT8p4ZHOuuupT1LENpAe+BT1+DD/yoIMgbS/j1mK4FMc6pJF
	fRs7RJSCBkOT+wt5hBjpS6zZF9yZokNPrJTT2SxJNr5xnf6J6kwPmWAcdJM67N80y09L9p
	fH6R6NP7Iq1OAlcQDdrS2U2P7ZQnxcM=
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
Subject: Re: [kvm-unit-tests RFC PATCH 06/17] shellcheck: Fix SC2155
Message-ID: <20240405-9b6c9e0e72927362899cb815@orel>
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-7-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405090052.375599-7-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 05, 2024 at 07:00:38PM +1000, Nicholas Piggin wrote:
>   SC2155 (warning): Declare and assign separately to avoid masking
>   return values.
> 
> No bug identified.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  scripts/arch-run.bash | 10 +++++++---
>  scripts/runtime.bash  |  4 +++-
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index f9d1fade9..ae4b06679 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -411,7 +411,8 @@ initrd_cleanup ()
>  {
>  	rm -f $KVM_UNIT_TESTS_ENV
>  	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
> -		export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
> +		export KVM_UNIT_TESTS_ENV
> +		KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
>  	else
>  		unset KVM_UNIT_TESTS_ENV
>  	fi
> @@ -423,7 +424,8 @@ initrd_create ()
>  	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
>  		trap_exit_push 'initrd_cleanup'
>  		[ -f "$KVM_UNIT_TESTS_ENV" ] && export KVM_UNIT_TESTS_ENV_OLD="$KVM_UNIT_TESTS_ENV"
> -		export KVM_UNIT_TESTS_ENV=$(mktemp)
> +		export KVM_UNIT_TESTS_ENV
> +		KVM_UNIT_TESTS_ENV=$(mktemp)
>  		env_params
>  		env_file
>  		env_errata || return $?
> @@ -566,7 +568,9 @@ env_generate_errata ()
>  
>  trap_exit_push ()
>  {
> -	local old_exit=$(trap -p EXIT | sed "s/^[^']*'//;s/'[^']*$//")
> +	local old_exit
> +
> +	old_exit=$(trap -p EXIT | sed "s/^[^']*'//;s/'[^']*$//")
>  	trap -- "$1; $old_exit" EXIT
>  }
>  
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index f79c4e281..3b76aec9e 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -15,7 +15,9 @@ extract_summary()
>  # We assume that QEMU is going to work if it tried to load the kernel
>  premature_failure()
>  {
> -    local log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
> +    local log
> +
> +    log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
>  
>      echo "$log" | grep "_NO_FILE_4Uhere_" |
>          grep -q -e "[Cc]ould not \(load\|open\) kernel" \
> -- 
> 2.43.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

