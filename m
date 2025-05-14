Return-Path: <kvm+bounces-46464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BFBDAB6519
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 10:02:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18AF14A50A8
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 08:02:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C46F621ABD3;
	Wed, 14 May 2025 08:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f5iKnZwl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1A520766C
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 08:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747209755; cv=none; b=Yjy/xiLQFHzN4nLDr5ApWYDYmKga9TfauNg027roxeHCybgJ9WV/Uk0q61+50oV81XJag+AeNuI4jxd/W3oaduj54YZAAm74l8UaveoS9o4hAqlwf2aQIsuiXv2N24wv6A/rB9sjBcOwvCqCeoWD3Cubs/6HbJ2OnYjzZzh/hSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747209755; c=relaxed/simple;
	bh=xqHgvAYCC9t6MZ7wyX6GrXISDsKjOo/Grz/it3buzvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m5ymtly0CtdI9wNcZBsUob+BebGFdSdJNm4Y50jYX9DYMJPeRSjNTI3NXKr1L6Ov48uW+YhRAnob7hEPoccBn0gPXZVPHpBMhYaXNm9ooVzJCTmNthZoTWYiACcmV5OmFYilk+cS1d4Y1RYvdE3DItiA/2folTeMTwQPb1f3Muo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f5iKnZwl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747209750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ET5iCd8MyKLHEGzFDUiYbW8pYPvNTTRlK86QIMS0syE=;
	b=f5iKnZwlTMu7+mIg7ea/9D2d1TOsbo/VtbuzCeYr2LG+vlV8+9iap4jXWFo+BMU5OxTfo7
	Y/33lnBpUTkemgCMeIWnUJGTVbOUoxW6Z8WLnLvFz5QPEv81lnZpx0BgKDQ/da4DTnhj9l
	RNd2ywibDDUGqu9+8cazuHTGmHqMoPQ=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-219-xTrhwcKjNbS9v1v-SZS6UA-1; Wed, 14 May 2025 04:02:28 -0400
X-MC-Unique: xTrhwcKjNbS9v1v-SZS6UA-1
X-Mimecast-MFC-AGG-ID: xTrhwcKjNbS9v1v-SZS6UA_1747209747
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-7425efba1a3so598780b3a.0
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 01:02:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747209747; x=1747814547;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ET5iCd8MyKLHEGzFDUiYbW8pYPvNTTRlK86QIMS0syE=;
        b=tThLjnjFaFzrOYTaEJHCQ9kE8bjtO49rQDrDwgx/lbHsve1QYhZbffXqvyU5TdglbZ
         tXgXr5RhzXbvGlOV8lLzR2M2k3/90ljp3mOS1SvIpnPHsiAmTUJL9FLZgkR9f7AhU70W
         z+0VQMaWxO7w3EMbQSTTwrTTUr++IWOusNLzxSTXvT46I09TLPERItI/EHGica7iuMSb
         VJgGzcmHPTK83Ao6iedsh4+bLCfwdgcgRqCpGNkB1V+YXUXcmrHEn175PwfAf6F0tZ7z
         QsUQIo7zZuINsKBtTIhyE+NYL/iiVPW5dkpUspPARR70hZ3g20l+NqX8U4oTWTj5A7gg
         rkTQ==
X-Gm-Message-State: AOJu0YxXRQzgTihm8DLs9DSMyquwhpjZKoRR0jAXVPKsv1ANAC1VC17K
	xkZDqgr8cOSrWjQ0kiHiipY5O7Y3kHxe3GYjoJZQbdkAKgMDrM8cNs4348g7+8ubYg3g8lIYLaS
	bC5tqopqq1SUBEbENujlMwwslJAKLGI5L87cf+S0dntJYUVSKnQ==
X-Gm-Gg: ASbGncs+He5pgwXzPfcAYbPeeLV6LLOyaIKF+4fdOT9PJHHDNQkxM+IjErniPht8xLN
	5aiBqHy075k3QYpajFnT1FDZMtLDqLgt6I96jJmMhZyzjs+fMlUmD2YC1+ReshvJfq57s6q+bUQ
	gwuWXWkuGET6l6RklliB2ThRtejw/KvatdhHDUg/6DrnAkoMBbVTS1A28jEAvZaOM3okgmtlzW5
	orCIe5V7ktZHs9gy+rRxBvfvLwwpHT6yr7C9TcDf+zDiOiggODrb8jUfgcklLlGk1TTVAOv5k8F
	m3p/xUTKqYXXFBay
X-Received: by 2002:a05:6a00:811a:b0:736:4c3d:2cba with SMTP id d2e1a72fcca58-7427917883cmr7436401b3a.9.1747209747408;
        Wed, 14 May 2025 01:02:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEwhqdQhP9GhHKMFywwgH/LIw6XImxil66dwro2onM7heCubGabPHGV/eyERLOa/TP3h81BbA==
X-Received: by 2002:a05:6a00:811a:b0:736:4c3d:2cba with SMTP id d2e1a72fcca58-7427917883cmr7436362b3a.9.1747209747028;
        Wed, 14 May 2025 01:02:27 -0700 (PDT)
Received: from [10.72.116.125] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7423772752csm8775799b3a.45.2025.05.14.01.02.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 May 2025 01:02:26 -0700 (PDT)
Message-ID: <74a90a55-80ae-45ff-9b37-7cb2771ed0e0@redhat.com>
Date: Wed, 14 May 2025 16:02:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 07/16] scripts: Use an associative array
 for qemu argument names
To: Alexandru Elisei <alexandru.elisei@arm.com>, andrew.jones@linux.dev,
 eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com,
 frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
 david@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com,
 maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, joey.gouly@arm.com, andre.przywara@arm.com
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-8-alexandru.elisei@arm.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20250507151256.167769-8-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/7/25 11:12 PM, Alexandru Elisei wrote:
> Move away from hardcoded qemu arguments and use instead an associative
> array to get the needed arguments. This paves the way for adding kvmtool
> support to the scripts, which has a different syntax for the same VM
> configuration parameters.
> 
> Suggested-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> ---
>   scripts/common.bash  | 10 +++++++---
>   scripts/runtime.bash |  7 +------
>   scripts/vmm.bash     |  7 +++++++
>   3 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/scripts/common.bash b/scripts/common.bash
> index 9deb87d4050d..649f1c737617 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -1,4 +1,5 @@
>   source config.mak
> +source scripts/vmm.bash
>   
>   function for_each_unittest()
>   {
> @@ -26,8 +27,11 @@ function for_each_unittest()
>   				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$test_args" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
>   			fi
>   			testname=$rematch
> -			smp=1
> +			smp="${vmm_opts[$TARGET:nr_cpus]} 1"
>   			kernel=""
> +			# Intentionally don't use -append if test_args is empty
> +			# because qemu interprets the first argument after
> +			# -append as a kernel parameter.
>   			test_args=""
>   			opts=""
>   			groups=""
> @@ -39,9 +43,9 @@ function for_each_unittest()
>   		elif [[ $line =~ ^file\ *=\ *(.*)$ ]]; then
>   			kernel=$TEST_DIR/${BASH_REMATCH[1]}
>   		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
> -			smp=${BASH_REMATCH[1]}
> +			smp="${vmm_opts[$TARGET:nr_cpus]} ${BASH_REMATCH[1]}"
>   		elif [[ $line =~ ^test_args\ *=\ *(.*)$ ]]; then
> -			test_args=${BASH_REMATCH[1]}
> +			test_args="${vmm_opts[$TARGET:args]} ${BASH_REMATCH[1]}"
>   		elif [[ $line =~ ^(extra_params|qemu_params)\ *=\ *'"""'(.*)$ ]]; then
>   			opts=${BASH_REMATCH[2]}$'\n'
>   			while read -r -u $fd; do
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 06cc58e79b69..86d8a2cd8528 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -34,7 +34,7 @@ premature_failure()
>   get_cmdline()
>   {
>       local kernel=$1
> -    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
> +    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel $smp $test_args $opts"
>   }
>   
>   skip_nodefault()
> @@ -88,11 +88,6 @@ function run()
>       local accel="${10}"
>       local timeout="${11:-$TIMEOUT}" # unittests.cfg overrides the default
>   
> -    # If $test_args is empty, qemu will interpret the first option after -append
> -    # as a kernel parameter instead of a qemu option, so make sure the -append
> -    # option is used only if $test_args is not empy.
> -    [ -n "$test_args" ] && opts="-append $test_args $opts"
> -
>       if [ "${CONFIG_EFI}" == "y" ]; then
>           kernel=${kernel/%.flat/.efi}
>       fi
> diff --git a/scripts/vmm.bash b/scripts/vmm.bash
> index 39325858c6b3..b02055a5c0b6 100644
> --- a/scripts/vmm.bash
> +++ b/scripts/vmm.bash
> @@ -1,5 +1,12 @@
>   source config.mak
>   
> +declare -A vmm_opts=(
> +	[qemu:nr_cpus]='-smp'
> +	[qemu:kernel]='-kernel'
> +	[qemu:args]='-append'
> +	[qemu:initrd]='-initrd'
> +)
> +
>   function check_vmm_supported()
>   {
>   	case "$TARGET" in

-- 
Shaoqin


