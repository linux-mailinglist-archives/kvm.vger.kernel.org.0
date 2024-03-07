Return-Path: <kvm+bounces-11248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D66DC874617
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 03:29:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B20CD1C217AB
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 02:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C811D63C1;
	Thu,  7 Mar 2024 02:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bcnkC8OG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516185C82
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 02:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709778557; cv=none; b=cojMuRmFIOwC0+qXQLZdTRoqZbwa7RXPv6ZFsNcHIy6aRXuPD0OBbK33TiWPis6ZkeUEYQO1SEa0TVtFGufdk0DJ6oFAXwBJuwq/BkvDQg8/OtXtjSYVuw/G2CKxStZDKtnOsmhvrYjc/Pb3LoBkBKez897tiH+FkM7CJ0VRO0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709778557; c=relaxed/simple;
	bh=coZg3CFF05t9sz7AF4xhD7nZ+00dSkiiGeyWmvwCd1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mni89PnP60ptVV2S6y8J/Ck3TYpKO+rMHxfufkCd+7+oGrvm6LjqEN/W8P4SPTKluS/an6x5mBLolHdaqj4AZk8zpxVrjV6ac72ScwtxkjAp4IrkAfSkFXRkiWJZN0Dftj1DmsUB6/knRKiZMgacpZfZ7CEdgP8tXPj75KN6nYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bcnkC8OG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709778553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LPvh/jCT7caBWdZhb9Pskoj0b6p6SKQ25K+6dPHyzTg=;
	b=bcnkC8OGhNVZRij/bRdQnoCt/S1XxcX+JJVo8WtZzJKyEiBM90Ob10KjDJOTcGTdtqcfUs
	bwzNQhscUB7LKxLqe+nDpueBb2Viwpc3jZQ2wv9Ezj0Q705Of5E1AEGsG8dkvtddCWPZ3C
	UPhl3aQb02GLtYoKhPW6uRW/gRtm7sE=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-tIPz5pQ9N3mmGQTluV-Hfg-1; Wed, 06 Mar 2024 21:29:11 -0500
X-MC-Unique: tIPz5pQ9N3mmGQTluV-Hfg-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-29999b97b39so97191a91.1
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 18:29:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709778550; x=1710383350;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LPvh/jCT7caBWdZhb9Pskoj0b6p6SKQ25K+6dPHyzTg=;
        b=Hsf/prwOb1decJro62FgCT4/G+p+EW96+2QLWzQVcijaDT8UDDyOOl21Fzkzm2Kuo4
         BU+DT+P/q666Q7MyyQvl7O3VbtFQZwOr/6JejP3vMshRAHxtlMwAGql2Vq5q7raBywxR
         yb2S4Aw2T1DENmREfZacFga1bURKFoXXXHK81adHxRMRCnm5QKNHhI+SvNttDX3opdi4
         mLSLFDvJ7bx05OwocUVU+JT3TAjm1eTyMZ/aAlW/IiVxE0zh9aHJI5FzVuh5ZqfORn1q
         y6jqNi3XFBHwbJ/ttdGoVBcQ410q5crH9AzibJRGfLoAtmtOJSae5usGgDFyYv8G7Fh0
         f2JQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkAYloDGCiPFaBqTV8he68FgaDAgm99Ll6x2mc2WqW91oAHpEYsOoF21hkekofc2wgGzt3kHQdeQ41zh9hBLY3qEqo
X-Gm-Message-State: AOJu0YzkCGo0cQqNIPYyV1gV7lfKWJcYzR2DA88+lcOY9/w5BlPg5nPF
	Oswh8AVkEAS/B8aRJDiGNFJyJTsZH/bX/mdM/giqUd6hj22T1d6Z5FLsJX3rRvIUGMjaVMQ9Qom
	jTPWt0breYRzJSAbr1sbUd5cyoWsbF9O7VdWyXwyoORlqBf38oA==
X-Received: by 2002:a17:902:7c17:b0:1d9:607d:8a26 with SMTP id x23-20020a1709027c1700b001d9607d8a26mr5330207pll.6.1709778550310;
        Wed, 06 Mar 2024 18:29:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGTkgJGIb4gjT6DgEXSzYd76fOXqgDeKxXxxWXNf0TRRldpwwc/uxpzx2vKm25SmQGjQbehzw==
X-Received: by 2002:a17:902:7c17:b0:1d9:607d:8a26 with SMTP id x23-20020a1709027c1700b001d9607d8a26mr5330184pll.6.1709778549823;
        Wed, 06 Mar 2024 18:29:09 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id l4-20020a170902f68400b001dcbffec642sm13237671plg.133.2024.03.06.18.29.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 18:29:09 -0800 (PST)
Message-ID: <5e0d6fc7-ddba-40b6-9eca-1a76f0d639ef@redhat.com>
Date: Thu, 7 Mar 2024 10:29:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 01/18] runtime: Update MAX_SMP probe
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, nikos.nikoleris@arm.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240305164623.379149-20-andrew.jones@linux.dev>
 <20240305164623.379149-21-andrew.jones@linux.dev>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20240305164623.379149-21-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/6/24 00:46, Andrew Jones wrote:
> Arm's MAX_SMP probing must have stopped working at some point due to
> QEMU's error message changing, but nobody noticed. Also, the probing
> should work for at least x86 now too, so the comment isn't correct
> anymore either. We could probably just delete this probe thing, but
> in case it could still serve some purpose we can also keep it, but
> updated for later QEMU, and only enabled when a new run_tests.sh
> command line option is provided.
>  > Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> ---
>   run_tests.sh         |  5 ++++-
>   scripts/runtime.bash | 19 ++++++++++---------
>   2 files changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index abb0ab773362..bb3024ff95b1 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -44,7 +44,7 @@ fi
>   
>   only_tests=""
>   list_tests=""
> -args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list -- $*)
> +args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list,probe-maxsmp -- $*)
>   [ $? -ne 0 ] && exit 2;
>   set -- $args;
>   while [ $# -gt 0 ]; do
> @@ -78,6 +78,9 @@ while [ $# -gt 0 ]; do
>           -l | --list)
>               list_tests="yes"
>               ;;
> +        --probe-maxsmp)
> +            probe_maxsmp
> +            ;;
>           --)
>               ;;
>           *)
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index c73fb0240d12..f2e43bb1ed60 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -200,12 +200,13 @@ function run()
>   #
>   # Probe for MAX_SMP, in case it's less than the number of host cpus.
>   #
> -# This probing currently only works for ARM, as x86 bails on another
> -# error first, so this check is only run for ARM and ARM64. The
> -# parameter expansion takes the last number from the QEMU error
> -# message, which gives the allowable MAX_SMP.
> -if [[ $ARCH == 'arm' || $ARCH == 'arm64' ]] &&
> -   smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'exceeds max CPUs'); then
> -	smp=${smp##*(}
> -	MAX_SMP=${smp:0:-1}
> -fi
> +function probe_maxsmp()
> +{
> +	local smp
> +
> +	if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'Invalid SMP CPUs'); then
> +		smp=${smp##* }
> +		echo "Restricting MAX_SMP from ($MAX_SMP) to the max supported ($smp)" >&2
> +		MAX_SMP=$smp
> +	fi
> +}

-- 
Shaoqin


