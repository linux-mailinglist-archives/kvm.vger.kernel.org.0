Return-Path: <kvm+bounces-47221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 124DFABEBA0
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 08:03:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9A034A1BDD
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 06:03:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8788231850;
	Wed, 21 May 2025 06:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XnJgAsC7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431F8635
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 06:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747807389; cv=none; b=BhXDG4qwisN5bW5tywEeDshsdU9pGAiIXVOGv5CLl0DhR4HnU/UScn3i/rUydaIbOm5irt9R7PY3ePdN7Qkk8ofTwNmEmot4oyPdE7ufVENCqO2klQJq/DOLlwOXdy0YAFLAtRPhM+Ey2u5jYAghQnhn8k/ML9F4+CFWSpOsnwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747807389; c=relaxed/simple;
	bh=cTFLET0mXVLedaG6A7OEmnIZXr74rqMVNe8GNHLCJJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=clAPllGNAb8PQ8949bu/xSF2L0O14XVuJcO+Lk6viOgXxqo5OGMUOBetDZWkTDqjrV1mdZeeR7fS8mdbO2PKA8t/ZEXOYqiSw8rd7mGIW+SQv3FCoAFQ/TBVJdMuI+4b3OQou4skI3ZCGvrWMuMJ5zyLCyKpn3lcyVwShUDPYgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XnJgAsC7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747807386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Luzvl9YYiKKkKv2ZrlEtI5HQQUPGehqlA/R1MmkzXtU=;
	b=XnJgAsC7oDDiPNK61sI+8738GIspQgKm8UPegATh3ESHyr2Yy8HXC/GEwfpvIoNkqdrCRB
	ZW7pOVIbPp0KT23vEJYZwvZo2ecaYkdkV8FfXkwjtaOIzwhShEn0Sx5IIjenAlLgni2uyC
	dnUTikin938TkVttDnwBoRos8KG48F0=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-Rc7AFjCCO4iP9YMQMkrl1w-1; Wed, 21 May 2025 02:03:04 -0400
X-MC-Unique: Rc7AFjCCO4iP9YMQMkrl1w-1
X-Mimecast-MFC-AGG-ID: Rc7AFjCCO4iP9YMQMkrl1w_1747807380
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7394792f83cso4997988b3a.3
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 23:03:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747807380; x=1748412180;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Luzvl9YYiKKkKv2ZrlEtI5HQQUPGehqlA/R1MmkzXtU=;
        b=i7hhGpFLj7d5jHgqUuAs69UNjfWsClS69Rzhjb3fYERMLUgBU5fBL3DDXT2jh2xEA1
         0kOtk3tyT2HVY0BSNpv1pY7gOYTHAmbNQNDxzE1GJUgz4LmLByl0QYZn5wTjCd2fTXJO
         ix1F7DYioDZZcqjPBWrGaGZ02/gtcZsiid28ztVBUkzrUtFC890liwFVr61Be34KIvfn
         c/kW7h1yFe20QOF0jcf4ybaBbtJrb6ktdvhJvToQx0DeCsThe/FZJVRSJH/EnoDq1mTA
         4LSpz+qCIyp7QL3MZ17/fBgXD5S8Tr4z/nl2d6AT9b99U/B5+BnRvVGNSWkC7yUrFX7i
         sd1Q==
X-Gm-Message-State: AOJu0YyzoM0Frk9s2dASrIGQRhCr5cotLJNoEAH6YfyXiyaDwE/QmWL9
	GrlmA0q7tQXTHVF3soVpiIOLSenByJO7VIUYihGLQqitFyX9UaxHWOrgh+vAkfY29iC7NYi8R+q
	a8QpUgBzPT9jGd8WMZ0ooc9kcPAcLk9Eh4YPasqpKxlOuOY1Nh6WPvg==
X-Gm-Gg: ASbGncuUP9Nn7A8fHPejAk0qaeIbiSMkhJdmhWUg/VqLPVXOMC/QL/8O5x7bbOVBtaL
	31F1E0QECYDsiWe1ZaGO9uRN75qBTw+clmmyd+n7dHC0poUXjYD5bifsYv9n90qE2FiV/h4NXwl
	6hgSmgChDPxEExYy2BpOZKrhqEcbp7R/8JkucJ9aLELCNoI+M+Jhb8nn3zHRzjpnDg0B4Ism0tc
	tHXCreOO+usgQNitXn9Z4NP8qHWM8dXkKW5aZGiotCphWSco3CB00JlzVhfW0OW9UiPewl4tajM
	A8HkFOmy0Vmmw5Y=
X-Received: by 2002:a05:6a00:1788:b0:736:5544:7ad7 with SMTP id d2e1a72fcca58-742a97eb5b9mr28757186b3a.14.1747807379853;
        Tue, 20 May 2025 23:02:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEkzCM7/Ctb9gNAgNxzZrfSW/B0q8J+JojRSlwDFqY3yzQr38av5VTKAulIBRs6Cj/pJdZcvA==
X-Received: by 2002:a05:6a00:1788:b0:736:5544:7ad7 with SMTP id d2e1a72fcca58-742a97eb5b9mr28757152b3a.14.1747807379436;
        Tue, 20 May 2025 23:02:59 -0700 (PDT)
Received: from [10.72.116.61] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a9829b87sm8888368b3a.114.2025.05.20.23.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 23:02:58 -0700 (PDT)
Message-ID: <3b33d060-895a-4f4b-a067-66164a29f8b4@redhat.com>
Date: Wed, 21 May 2025 14:02:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 13/16] scripts: Do not probe for maximum
 number of VCPUs when using kvmtool
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
 <20250507151256.167769-14-alexandru.elisei@arm.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20250507151256.167769-14-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/7/25 11:12 PM, Alexandru Elisei wrote:
> The --probe-maxsmp parameter updates MAX_SMP with the maximum number of
> VCPUs that the host supports. Qemu will exit with an error when creating a
> virtual machine if the number of VCPUs is exceeded.
> 
> kvmtool behaves differently: it will automatically limit the number of
> VCPUs to the what KVM supports, which is exactly what --probe-maxsmp wants
> to achieve. When doing --probe-maxsmp with kvmtool, print a message
> explaining why it's redundant and don't do anything else.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> ---
>   run_tests.sh         |  3 ++-
>   scripts/runtime.bash | 16 ----------------
>   scripts/vmm.bash     | 24 ++++++++++++++++++++++++
>   3 files changed, 26 insertions(+), 17 deletions(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index 150a06a91064..a69c3665b7a4 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -10,6 +10,7 @@ if [ ! -f config.mak ]; then
>   fi
>   source config.mak
>   source scripts/common.bash
> +source scripts/vmm.bash
>   
>   function usage()
>   {
> @@ -90,7 +91,7 @@ while [ $# -gt 0 ]; do
>               list_tests="yes"
>               ;;
>           --probe-maxsmp)
> -            probe_maxsmp
> +            ${vmm_opts[$TARGET:probe_maxsmp]}
>               ;;
>           --)
>               ;;
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 01ec8eae2bba..a802686c511d 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -209,19 +209,3 @@ function run()
>   
>       return $ret
>   }
> -
> -#
> -# Probe for MAX_SMP, in case it's less than the number of host cpus.
> -#
> -function probe_maxsmp()
> -{
> -	local smp
> -
> -	if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'SMP CPUs'); then
> -		smp=${smp##* }
> -		smp=${smp/\(}
> -		smp=${smp/\)}
> -		echo "Restricting MAX_SMP from ($MAX_SMP) to the max supported ($smp)" >&2
> -		MAX_SMP=$smp
> -	fi
> -}
> diff --git a/scripts/vmm.bash b/scripts/vmm.bash
> index a1d50ed51981..ef9819f4132c 100644
> --- a/scripts/vmm.bash
> +++ b/scripts/vmm.bash
> @@ -105,6 +105,22 @@ function qemu_parse_premature_failure()
>   	return 0
>   }
>   
> +#
> +# Probe for MAX_SMP, in case it's less than the number of host cpus.
> +#
> +function qemu_probe_maxsmp()
> +{
> +	local smp
> +
> +	if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'SMP CPUs'); then
> +		smp=${smp##* }
> +		smp=${smp/\(}
> +		smp=${smp/\)}
> +		echo "Restricting MAX_SMP from ($MAX_SMP) to the max supported ($smp)" >&2
> +		MAX_SMP=$smp
> +	fi
> +}
> +
>   function kvmtool_parse_premature_failure()
>   {
>   	local log="$@"
> @@ -114,6 +130,12 @@ function kvmtool_parse_premature_failure()
>   	return 0
>   }
>   
> +function kvmtool_probe_maxsmp()
> +{
> +	echo "kvmtool automatically limits the number of VCPUs to maximum supported"
> +	echo "The 'smp' test parameter won't be modified"
> +}
> +
>   declare -A vmm_opts=(
>   	[qemu:nr_cpus]='-smp'
>   	[qemu:kernel]='-kernel'
> @@ -122,6 +144,7 @@ declare -A vmm_opts=(
>   	[qemu:default_opts]=''
>   	[qemu:fixup_return_code]=qemu_fixup_return_code
>   	[qemu:parse_premature_failure]=qemu_parse_premature_failure
> +	[qemu:probe_maxsmp]=qemu_probe_maxsmp
>   
>   	[kvmtool:nr_cpus]='--cpus'
>   	[kvmtool:kernel]='--kernel'
> @@ -130,6 +153,7 @@ declare -A vmm_opts=(
>   	[kvmtool:default_opts]="$KVMTOOL_DEFAULT_OPTS"
>   	[kvmtool:fixup_return_code]=kvmtool_fixup_return_code
>   	[kvmtool:parse_premature_failure]=kvmtool_parse_premature_failure
> +	[kvmtool:probe_maxsmp]=kvmtool_probe_maxsmp
>   )
>   
>   function check_vmm_supported()

-- 
Shaoqin


