Return-Path: <kvm+bounces-47220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C4002ABEB92
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 07:59:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75F7E7A3116
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 05:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4C10231849;
	Wed, 21 May 2025 05:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bbVb5lxh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FC622D4F2
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 05:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747807137; cv=none; b=t7h/LnJh/Zo+4+bgkkbczgkuE8sl4rjDamFcDDqxJ8efPW1GhcRq5Ik23rFGxSwlmeDKSEGW31KP/U0C/+X+hOX12UljB5Tkmpw7ZyQSkG+gQoMAv3rW1cL+A7kIrn9TyqR+34qzT+39JTHKAPKWoegpyYOjrxIPjR9HVAGfq90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747807137; c=relaxed/simple;
	bh=uIcXVV4gQllryuPUgzM3DOLQXxB+juTPfFfghG+6HI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hm8eTPKXeQfp87BN4DPIYg5p0LOVajUI/yVNyGoLOZF6BYIt5sX1DVgeAZEXfZ2iDDeCNrhBLBPH2muUw93FfqG0Crfh8TxjFQhxTFmat/BqepqhusLtvZRStTEp0joMeHE3rkD9SXvc3GceiYBZd8bVP1qotc8gEL6l0EQTWUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bbVb5lxh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747807133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3nX0mf0Fkt78o6JfyiUPx6n9zrKuc9Cy4bOKokl+4+0=;
	b=bbVb5lxhfzMtFuEpiak/mAXBs/jqetHwtuBcD+FxFtOzJlwHY93qvz8AwewZUOr8UvOJup
	/XImNIi88Fp5rn+9aO0a4/Lu7LxWy+GtEBGKEt7wwe/CxhIUYgo6W8Gn86xj3foP4/wkF/
	LAbcmAQazeUlTqMwNLtS0mdPr+wEdPw=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-fq7RBTJwOi-dw17arHNkWg-1; Wed, 21 May 2025 01:58:51 -0400
X-MC-Unique: fq7RBTJwOi-dw17arHNkWg-1
X-Mimecast-MFC-AGG-ID: fq7RBTJwOi-dw17arHNkWg_1747807131
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-740adfc7babso5313663b3a.0
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 22:58:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747807130; x=1748411930;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3nX0mf0Fkt78o6JfyiUPx6n9zrKuc9Cy4bOKokl+4+0=;
        b=jrn2C0q3j24+bxJUXvo6VxxBjsJJeOb/odXKScLz8VxmnzG3+0628Nj8kF0epM7I2X
         Euyj5Bng0Gq/BB2T5KACNrolPRznxsvbGcrpz1SYCyWgOHVoIoSj3FU05ou/FhBI4mMJ
         7JFZEPsmOq8Nhr3QnjihfUz6uBuL7crC04GDUI8xj4ek6byEveZf4lyDE1jLnH+xmvUY
         lLVeyY4xn8seRlGy3ZmOQuZjDYtuvab6NuUC1BYkhBJc+NSia30wGGkasReecM9yHHNy
         3SrM9TOs0zMMnEzs3vxB7KXChY0CwSH611t4lDboX+4OypGDCf46F2yWZjWNpJ+EIsxd
         wwDw==
X-Gm-Message-State: AOJu0YymgTvHPG03cD6OSQojaciHTizmeUu9W9kNtJWchqRikqDxU5Sz
	8isClfrTiOxtnPC+1y/BKiTDsVdA61y78ENp36+7QKMU2D4TCxyayn/oJ6d5rJsUv0yE6DLVV5/
	cWcQEGGfAnU6bWDU94En2nk82Aa4YrbTQxu25q651YO89ljvGG9k/og==
X-Gm-Gg: ASbGncsy9BxaArn+8D02uRJswLJyCrT67d6C9dKyr4p/PPjTMZIciI4ddWoTEdfimEf
	Bke/KEJ3r3VpyEOh6IpqyMqmvqDaOBtgWu+e4beFzGRJGfjbBzLOPGBMAUMjZYjKHuvNsHKXSOQ
	jIb5UBkcEZt8Hir7Z0vyGIdxR+X03Kw5HtbdUG8t3al0Ls8+sfJDCWsMaIB5PSEcg/3eSEbTw3R
	zqWbLmwwGVxfRCERJQsWI0OtNtrh+FUB+NIWYaLEQsOhBPHfqtizutY0NA4lk3NPuChSTrRlZ6R
	fgWN2dge21r2gUM=
X-Received: by 2002:a05:6a00:99b:b0:73f:f623:55f8 with SMTP id d2e1a72fcca58-742a9776958mr24169495b3a.5.1747807130586;
        Tue, 20 May 2025 22:58:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGz7QgFo322mqLeqRIQ+QKAfXrUPzgO5kq17+j1FtzB/COn8u/dv5TrNOSm4BX2L/XT0g/pCw==
X-Received: by 2002:a05:6a00:99b:b0:73f:f623:55f8 with SMTP id d2e1a72fcca58-742a9776958mr24169482b3a.5.1747807130253;
        Tue, 20 May 2025 22:58:50 -0700 (PDT)
Received: from [10.72.116.61] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a970c882sm9260119b3a.55.2025.05.20.22.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 22:58:49 -0700 (PDT)
Message-ID: <590d9058-7afc-45c7-ac81-68c109dfdad5@redhat.com>
Date: Wed, 21 May 2025 13:58:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 12/16] scripts: Detect kvmtool failure
 in premature_failure()
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
 <20250507151256.167769-13-alexandru.elisei@arm.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20250507151256.167769-13-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/7/25 11:12 PM, Alexandru Elisei wrote:
> kvm-unit-tests assumes that if the VMM is able to get to where it tries to
> load the kernel, then the VMM and the configuration parameters will also
> work for running the test. All of this is done in premature_failure().
> 
> Teach premature_failure() about the kvmtool's error message when it fails
> to load the dummy kernel.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> ---
>   scripts/runtime.bash |  8 +++-----
>   scripts/vmm.bash     | 23 +++++++++++++++++++++++
>   2 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 86d8a2cd8528..01ec8eae2bba 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -1,3 +1,5 @@
> +source scripts/vmm.bash
> +
>   : "${RUNTIME_arch_run?}"
>   : "${MAX_SMP:=$(getconf _NPROCESSORS_ONLN)}"
>   : "${TIMEOUT:=90s}"
> @@ -19,11 +21,7 @@ premature_failure()
>   
>       log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
>   
> -    echo "$log" | grep "_NO_FILE_4Uhere_" |
> -        grep -q -e "[Cc]ould not \(load\|open\) kernel" \
> -                -e "error loading" \
> -                -e "failed to load" &&
> -        return 1
> +    ${vmm_opts[$TARGET:parse_premature_failure]} "$log" || return 1
>   
>       RUNTIME_log_stderr <<< "$log"
>   
> diff --git a/scripts/vmm.bash b/scripts/vmm.bash
> index d24a4c4b8713..a1d50ed51981 100644
> --- a/scripts/vmm.bash
> +++ b/scripts/vmm.bash
> @@ -93,6 +93,27 @@ kvmtool_fixup_return_code()
>   	echo $ret
>   }
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
>   declare -A vmm_opts=(
>   	[qemu:nr_cpus]='-smp'
>   	[qemu:kernel]='-kernel'
> @@ -100,6 +121,7 @@ declare -A vmm_opts=(
>   	[qemu:initrd]='-initrd'
>   	[qemu:default_opts]=''
>   	[qemu:fixup_return_code]=qemu_fixup_return_code
> +	[qemu:parse_premature_failure]=qemu_parse_premature_failure
>   
>   	[kvmtool:nr_cpus]='--cpus'
>   	[kvmtool:kernel]='--kernel'
> @@ -107,6 +129,7 @@ declare -A vmm_opts=(
>   	[kvmtool:initrd]='--initrd'
>   	[kvmtool:default_opts]="$KVMTOOL_DEFAULT_OPTS"
>   	[kvmtool:fixup_return_code]=kvmtool_fixup_return_code
> +	[kvmtool:parse_premature_failure]=kvmtool_parse_premature_failure
>   )
>   
>   function check_vmm_supported()

-- 
Shaoqin


