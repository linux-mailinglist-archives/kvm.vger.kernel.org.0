Return-Path: <kvm+bounces-41180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E36CDA6464B
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 09:53:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C8613B2615
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 08:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2120220694;
	Mon, 17 Mar 2025 08:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Egdktkr+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C391221714
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 08:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742201603; cv=none; b=tKb3/qm46ZkIFCwxvrCu8aj2bhonzfFyqMBxoijcDfqAoN8ZjTTnjGYqKX2xLcSX8lY24BeyrgQlFIAuaLuRmIDn9P8zpv+5WsmxySlwce1TJEYA5MZzttS79sPY8uEMEpk9xUZrDRiPY8anizExrg+vZGlxhgDn1qSU1Q6x4tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742201603; c=relaxed/simple;
	bh=aq2spCsdG3P3lfElF89LUbXKEryZhClx9wsvSo0M+Hk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jDY1uDlLjwWsxKNMCjhtYaA5QTeWZFU/iI0OsBBqdtptCbo75NsYHg4w20SDfk0dSDrYAX5NfGeRZ44iUXjAckSnPFRTcvBbeGuO84xY1ciYYlZG/1lSbQmpZGZM/HbmmLfWcwAXlNS8SX9n9spOnd0471O34K6Q3mj9Daa7mV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Egdktkr+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742201599;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Z0UeEMmq83xCl69Q71PKJopRqUbkXECgaGSxsoBFy8=;
	b=Egdktkr+t7IIEybO9Z+N8T0mMTbFSRD6ZARwngbrUPZHOb+54Plt+lL2KB6wWsa4533AmU
	OjogXj2/RLWju2Iunyw2rKV6h4YVOZTG5mw7qzMiEoSdUzonvR8KEUF+yI9xr6EzLWBDof
	4MhxWCOeTzZI1ebbhLy+55dd60dOgiw=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-OqYlu3lFM6ijiDPacLR-4A-1; Mon, 17 Mar 2025 04:53:18 -0400
X-MC-Unique: OqYlu3lFM6ijiDPacLR-4A-1
X-Mimecast-MFC-AGG-ID: OqYlu3lFM6ijiDPacLR-4A_1742201598
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-85db19e5e0eso399558639f.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 01:53:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742201597; x=1742806397;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Z0UeEMmq83xCl69Q71PKJopRqUbkXECgaGSxsoBFy8=;
        b=VskcsKs6k/+bhC0rTmG5q9PgNCuW42FOuuqAU9+xWbl+yNOSbnhEKokEhINsPy32wB
         GUcs3xFWv8pk+7FoJ5cKjrvIjmlllBTEiTtyRD8ZcrbTVjiqmZDgxRobsc+sNbdhQyE5
         WV3aO3cn7qoHfc771QMF0gfFBimWYkqsyqqAQBJj7Jt5vhEp7zyLS77NeN2MPWUpN2Sm
         BrHs0TQjf6EiJyHpJ862byVuZQAZoeNcZlFrktXLOLZd08w9TDJlQDY4xIyLUKUMdmu2
         wcxqY2RMdggrBOeRSyqM4MA7AJh7Bifm+B1wbdX7x/8MO1ky9CIA4lZ1GrlZkPnJOlLW
         6gtw==
X-Forwarded-Encrypted: i=1; AJvYcCWDw/KqUdQr+Zv0lNcebL5HhWbNLO3PUI/B0LCYDgL1swBlLTVYC889/wJcoqr5oYhGDHI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPOpIw+yEFYiY7UmWbeYqFev/0lWwMrVOo0RukYtFX6XTAQuSZ
	wD7QT+1v9wnVo6sj54a0ADEDk/0dTC4luXWn4tcqmgpa7ERS0GkfSsoYX2DG2OlXze8YC8CLGsa
	w0t+KXkAtGhdjCaSoUYawYSeph9fIBZVlo86Gs+t3j/08rU1Rqi98k/ynmQ==
X-Gm-Gg: ASbGncs86wjdCAC/Lc+Px9So7vTog3YsW+2KIqYhQqEZTc3YU72OrLuVjyem3ukB53w
	rXQSQimb+O/DJkMsUsB28HqPaO+Mp1MvJBBkvGfvl9jCIqT6kYmuYOh3Ubuy95Zxz5SR7fx9sS8
	LJq15fOkYTnBnFiKyWzuimnjCj6LROV7yccAby8GEZRgV1Wu8vPaftGWjVXgp3tvO/HAfdiE2OV
	iDDEPVrzadFzxPZsbxQX2mEzqtaAd3g1YbVPBqmBqmcYSawhS5tqnA+P0VA11RjLPdSzoRTejqc
	e4vDOXwisuoiIxUjciX2/xNEoL75VzMXze87yy91Dj+iIqlBCVQDNSdXM3Lv1Ng=
X-Received: by 2002:a05:6602:2cd6:b0:85b:4d28:2aa9 with SMTP id ca18e2360f4ac-85dc4792a8dmr1487055139f.4.1742201597316;
        Mon, 17 Mar 2025 01:53:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhvA6uoxE9FkDt+/PrcVIKJmkPlXjaFVJVOpZAvngURmdObKJVrgiM4GTTPXD1x6LoFTwjrg==
X-Received: by 2002:a05:6602:2cd6:b0:85b:4d28:2aa9 with SMTP id ca18e2360f4ac-85dc4792a8dmr1487053639f.4.1742201597020;
        Mon, 17 Mar 2025 01:53:17 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2638147c9sm2161677173.112.2025.03.17.01.53.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 01:53:16 -0700 (PDT)
Message-ID: <4ab33998-4d16-4ecb-aa76-3919afcbf2d7@redhat.com>
Date: Mon, 17 Mar 2025 09:53:12 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 4/5] configure: Add --qemu-cpu option
Content-Language: en-US
To: Jean-Philippe Brucker <jean-philippe@linaro.org>, andrew.jones@linux.dev,
 alexandru.elisei@arm.com
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-6-jean-philippe@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250314154904.3946484-6-jean-philippe@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jean-Philippe,


On 3/14/25 4:49 PM, Jean-Philippe Brucker wrote:
> Add the --qemu-cpu option to let users set the CPU type to run on.
> At the moment --processor allows to set both GCC -mcpu flag and QEMU
> -cpu. On Arm we'd like to pass `-cpu max` to QEMU in order to enable all
> the TCG features by default, and it could also be nice to let users
> modify the CPU capabilities by setting extra -cpu options.
> Since GCC -mcpu doesn't accept "max" or "host", separate the compiler
> and QEMU arguments.
>
> `--processor` is now exclusively for compiler options, as indicated by
> its documentation ("processor to compile for"). So use $QEMU_CPU on
> RISC-V as well.
>
> Suggested-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  scripts/mkstandalone.sh |  2 +-
>  arm/run                 | 17 +++++++++++------
>  riscv/run               |  8 ++++----
>  configure               |  7 +++++++
>  4 files changed, 23 insertions(+), 11 deletions(-)
>
> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> index 2318a85f..6b5f725d 100755
> --- a/scripts/mkstandalone.sh
> +++ b/scripts/mkstandalone.sh
> @@ -42,7 +42,7 @@ generate_test ()
>  
>  	config_export ARCH
>  	config_export ARCH_NAME
> -	config_export PROCESSOR
> +	config_export QEMU_CPU
>  
>  	echo "echo BUILD_HEAD=$(cat build-head)"
>  
> diff --git a/arm/run b/arm/run
> index efdd44ce..561bafab 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -8,7 +8,7 @@ if [ -z "$KUT_STANDALONE" ]; then
>  	source config.mak
>  	source scripts/arch-run.bash
>  fi
> -processor="$PROCESSOR"
> +qemu_cpu="$QEMU_CPU"
>  
>  if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
>     [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
> @@ -37,12 +37,17 @@ if [ "$ACCEL" = "kvm" ]; then
>  	fi
>  fi
>  
> -if [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ]; then
> -	if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
> -		processor="host"
> +if [ -z "$qemu_cpu" ]; then
> +	if ( [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ] ) &&
> +	   ( [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ] ); then
> +		qemu_cpu="host"
>  		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
> -			processor+=",aarch64=off"
> +			qemu_cpu+=",aarch64=off"
>  		fi
> +	elif [ "$ARCH" = "arm64" ]; then
> +		qemu_cpu="cortex-a57"
> +	else
> +		qemu_cpu="cortex-a15"
>  	fi
>  fi
>  
> @@ -71,7 +76,7 @@ if $qemu $M -device '?' | grep -q pci-testdev; then
>  fi
>  
>  A="-accel $ACCEL$ACCEL_PROPS"
> -command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
> +command="$qemu -nodefaults $M $A -cpu $qemu_cpu $chr_testdev $pci_testdev"
>  command+=" -display none -serial stdio"
>  command="$(migration_cmd) $(timeout_cmd) $command"
>  
> diff --git a/riscv/run b/riscv/run
> index e2f5a922..02fcf0c0 100755
> --- a/riscv/run
> +++ b/riscv/run
> @@ -11,12 +11,12 @@ fi
>  
>  # Allow user overrides of some config.mak variables
>  mach=$MACHINE_OVERRIDE
> -processor=$PROCESSOR_OVERRIDE
> +qemu_cpu=$QEMU_CPU_OVERRIDE
>  firmware=$FIRMWARE_OVERRIDE
>  
> -[ "$PROCESSOR" = "$ARCH" ] && PROCESSOR="max"
> +[ -z "$QEMU_CPU" ] && QEMU_CPU="max"
>  : "${mach:=virt}"
> -: "${processor:=$PROCESSOR}"
> +: "${qemu_cpu:=$QEMU_CPU}"
>  : "${firmware:=$FIRMWARE}"
>  [ "$firmware" ] && firmware="-bios $firmware"
>  
> @@ -32,7 +32,7 @@ fi
>  mach="-machine $mach"
>  
>  command="$qemu -nodefaults -nographic -serial mon:stdio"
> -command+=" $mach $acc $firmware -cpu $processor "
> +command+=" $mach $acc $firmware -cpu $qemu_cpu "
>  command="$(migration_cmd) $(timeout_cmd) $command"
>  
>  if [ "$UEFI_SHELL_RUN" = "y" ]; then
> diff --git a/configure b/configure
> index 5306bad3..d25bd23e 100755
> --- a/configure
> +++ b/configure
> @@ -52,6 +52,7 @@ page_size=
>  earlycon=
>  efi=
>  efi_direct=
> +qemu_cpu=
>  
>  # Enable -Werror by default for git repositories only (i.e. developer builds)
>  if [ -e "$srcdir"/.git ]; then
> @@ -69,6 +70,8 @@ usage() {
>  	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
>  	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
>  	    --processor=PROCESSOR  processor to compile for ($processor)
> +	    --qemu-cpu=CPU         the CPU model to run on. The default depends on
> +	                           the configuration, usually it is "host" or "max".
nit: I would remove 'usually it is "host" or "max"'. I don't see any
consistency check between qemu_cpu and processor in case it is
explicitly set? Do we care? Eric

>  	    --target=TARGET        target platform that the tests will be running on (qemu or
>  	                           kvmtool, default is qemu) (arm/arm64 only)
>  	    --cross-prefix=PREFIX  cross compiler prefix
> @@ -142,6 +145,9 @@ while [[ $optno -le $argc ]]; do
>          --processor)
>  	    processor="$arg"
>  	    ;;
> +	--qemu-cpu)
> +	    qemu_cpu="$arg"
> +	    ;;
>  	--target)
>  	    target="$arg"
>  	    ;;
> @@ -464,6 +470,7 @@ ARCH=$arch
>  ARCH_NAME=$arch_name
>  ARCH_LIBDIR=$arch_libdir
>  PROCESSOR=$processor
> +QEMU_CPU=$qemu_cpu
>  CC=$cc
>  CFLAGS=$cflags
>  LD=$cross_prefix$ld

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric



