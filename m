Return-Path: <kvm+bounces-16844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BCDA8BE703
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 17:09:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1FAB4B292A2
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 15:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62B5216192D;
	Tue,  7 May 2024 15:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jfu3nI35"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801E5161338
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715094521; cv=none; b=trdIc5Jc9cZDtDZy57sXQ5KIHwVypTRkcfuK6O2zziqynQPxd4rCP40I2U9BnmUtSTYhHVF4UnALntZVgno4wU4dn0HXx7DwJCZ3W9H/QVgkFkdiMSUvpdQM9QxTt21RwSPakbORRwbXdTIRu6o02fsjJs5nN73C0cvZT8GMp+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715094521; c=relaxed/simple;
	bh=fS/nzGNi+cvHbWeJsz7+9c2DtJyc8zQr7zza2Ag3BKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MYmIxp3AIq4X5Ag3LJ74mTtYllBhV0daCEtOSX9NBzueU+KdGfFFrnF/ZaTv91ioaiwjb8yCW0X3t4diV1sw2kNcZDR00J5m+rnhTFGY45W0GzU5nvY1trPYBV1Z+5LdbjY/BYyMvMMeEdCoQXmZwC09pEkBKgK2m0S6rEa2UNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jfu3nI35; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715094518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HpVW0/9+/L+kKwM3Qnf0wff1bD8U05A1KXwBGl1ho/Q=;
	b=Jfu3nI35GGfEZ54CLfPAMXzKFNMO4Pn1TpFqV/mfctBI9xI+IzvbVBT6JeVGBvcjA85osw
	T0g/4OLFwFW5kfSCgHiV7KwURqlJsUj7banZ+1M+ne7yqOE6Ha37UysCDxvTsx6WfIkUiw
	g76uylTdSw/UrbebkJmJt7VqwuXr9FM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-sK9FYs_INzyyPWgpomJv6w-1; Tue, 07 May 2024 11:08:37 -0400
X-MC-Unique: sK9FYs_INzyyPWgpomJv6w-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-41e8954066aso10774385e9.3
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 08:08:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715094516; x=1715699316;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HpVW0/9+/L+kKwM3Qnf0wff1bD8U05A1KXwBGl1ho/Q=;
        b=OzGip3BX1iY2mhCZywBpGNnv8uTLLDyPagVtVjPcMQjCAMPt/CxFcwwhgivQKlfC8P
         BWiLxmQx9F56h75Ek3lMDyYj+zSQFS5QTRMuQjMqqxjHNqU0t8nOxOF/1q4LQMNogz3l
         j5lsS91+42qM8euon2xx5mKBZD/tkalErlzT1cl9Sqrod+XpEsUqLYkgDmksomns3iKJ
         mK1Pp70/fNQnHNoTDroGVcnrJjUYyYXseavses5JUE0d6F0ftQkrdBMp9jQAh+Y7rkwG
         6iyMctZPHmAWwxnTMpXob7lXXZf5ACW5KS9Uaoc/KRJRFIvLw2e/9xpihwND7Br797ul
         xqWw==
X-Forwarded-Encrypted: i=1; AJvYcCXIUCBrJ0y4J9nWCds1izoO/9MLgX21k6gJxrNOpND0p6sa0Kbzr862FE08wuW2/hKwib4xmK6YpbRoJlTMqv8+I65K
X-Gm-Message-State: AOJu0YxGtlm8Sv4GSZ3T/ynaNBTHrf1BHvh5K4qhTTLqcvord19rBaEr
	YtWz89bq1QnFsXjlYy4kIv9hbxve33zoyIB7Zh3MSdVO5TBGiX6YOlr4JSPcHZFXqRqAt+rA7oi
	VAhavsGVxUSIaEGsMetlMcWrB5NPyOd0mWiCGM7fbagLn5b+asA==
X-Received: by 2002:a05:600c:1f81:b0:41b:de8d:dcd7 with SMTP id 5b1f17b1804b1-41f71ebf891mr639445e9.20.1715094515907;
        Tue, 07 May 2024 08:08:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHZ3fHNVLmAQgwakct5lEQriA0Qg34lqLbb28Uv1myWsEsWU4Y4PADgvg9u993fG3wNf7rUQ==
X-Received: by 2002:a05:600c:1f81:b0:41b:de8d:dcd7 with SMTP id 5b1f17b1804b1-41f71ebf891mr639265e9.20.1715094515515;
        Tue, 07 May 2024 08:08:35 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-40-241-109.web.vodafone.de. [109.40.241.109])
        by smtp.gmail.com with ESMTPSA id fc20-20020a05600c525400b00418accde252sm19827078wmb.30.2024.05.07.08.08.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 May 2024 08:08:35 -0700 (PDT)
Message-ID: <e0df1892-c17f-4fc3-b95a-4efc0af917d3@redhat.com>
Date: Tue, 7 May 2024 17:08:33 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 07/31] scripts: allow machine option to
 be specified in unittests.cfg
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-8-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240504122841.1177683-8-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/05/2024 14.28, Nicholas Piggin wrote:
> This allows different machines with different requirements to be
> supported by run_tests.sh, similarly to how different accelerators
> are handled.
> 
> Acked-by: Thomas Huth <thuth@redhat.com>
> Acked-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   docs/unittests.txt   |  7 +++++++
>   scripts/common.bash  |  8 ++++++--
>   scripts/runtime.bash | 16 ++++++++++++----
>   3 files changed, 25 insertions(+), 6 deletions(-)
> 
> diff --git a/docs/unittests.txt b/docs/unittests.txt
> index 7cf2c55ad..6449efd78 100644
> --- a/docs/unittests.txt
> +++ b/docs/unittests.txt
> @@ -42,6 +42,13 @@ For <arch>/ directories that support multiple architectures, this restricts
>   the test to the specified arch. By default, the test will run on any
>   architecture.
>   
> +machine
> +-------
> +For those architectures that support multiple machine types, this restricts
> +the test to the specified machine. By default, the test will run on
> +any machine type. (Note, the machine can be specified with the MACHINE=
> +environment variable, and defaults to the architecture's default.)
> +
>   smp
>   ---
>   smp = <number>
> diff --git a/scripts/common.bash b/scripts/common.bash
> index 5e9ad53e2..3aa557c8c 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -10,6 +10,7 @@ function for_each_unittest()
>   	local opts
>   	local groups
>   	local arch
> +	local machine
>   	local check
>   	local accel
>   	local timeout
> @@ -21,7 +22,7 @@ function for_each_unittest()
>   		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
>   			rematch=${BASH_REMATCH[1]}
>   			if [ -n "${testname}" ]; then
> -				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> +				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
>   			fi
>   			testname=$rematch
>   			smp=1
> @@ -29,6 +30,7 @@ function for_each_unittest()
>   			opts=""
>   			groups=""
>   			arch=""
> +			machine=""
>   			check=""
>   			accel=""
>   			timeout=""
> @@ -58,6 +60,8 @@ function for_each_unittest()
>   			groups=${BASH_REMATCH[1]}
>   		elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
>   			arch=${BASH_REMATCH[1]}
> +		elif [[ $line =~ ^machine\ *=\ *(.*)$ ]]; then
> +			machine=${BASH_REMATCH[1]}
>   		elif [[ $line =~ ^check\ *=\ *(.*)$ ]]; then
>   			check=${BASH_REMATCH[1]}
>   		elif [[ $line =~ ^accel\ *=\ *(.*)$ ]]; then
> @@ -67,7 +71,7 @@ function for_each_unittest()
>   		fi
>   	done
>   	if [ -n "${testname}" ]; then
> -		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> +		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
>   	fi
>   	exec {fd}<&-
>   }
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 177b62166..0c96d6ea2 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -32,7 +32,7 @@ premature_failure()
>   get_cmdline()
>   {
>       local kernel=$1
> -    echo "TESTNAME=$testname TIMEOUT=$timeout ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
> +    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
>   }
>   
>   skip_nodefault()
> @@ -80,9 +80,10 @@ function run()
>       local kernel="$4"
>       local opts="$5"
>       local arch="$6"
> -    local check="${CHECK:-$7}"
> -    local accel="$8"
> -    local timeout="${9:-$TIMEOUT}" # unittests.cfg overrides the default
> +    local machine="$7"
> +    local check="${CHECK:-$8}"
> +    local accel="$9"
> +    local timeout="${10:-$TIMEOUT}" # unittests.cfg overrides the default
>   
>       if [ "${CONFIG_EFI}" == "y" ]; then
>           kernel=${kernel/%.flat/.efi}
> @@ -116,6 +117,13 @@ function run()
>           return 2
>       fi
>   
> +    if [ -n "$machine" ] && [ -n "$MACHINE" ] && [ "$machine" != "$MACHINE" ]; then
> +        print_result "SKIP" $testname "" "$machine only"
> +        return 2
> +    elif [ -n "$MACHINE" ]; then
> +        machine="$MACHINE"
> +    fi
> +
>       if [ -n "$accel" ] && [ -n "$ACCEL" ] && [ "$accel" != "$ACCEL" ]; then
>           print_result "SKIP" $testname "" "$accel only, but ACCEL=$ACCEL"
>           return 2

For some reasons that I don't quite understand yet, this patch causes the 
"sieve" test to always timeout on the s390x runner, see e.g.:

  https://gitlab.com/thuth/kvm-unit-tests/-/jobs/6798954987

Everything is fine in the previous patches (I pushed now the previous 5 
patches to the repo):

  https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/pipelines/1281919104

Could it be that he TIMEOUT gets messed up in certain cases?

  Thomas


