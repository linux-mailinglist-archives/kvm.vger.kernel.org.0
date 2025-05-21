Return-Path: <kvm+bounces-47223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B4CF9ABEBDF
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 08:21:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15BEF3A6948
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 06:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2B9123314B;
	Wed, 21 May 2025 06:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C/Bbax8J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469E022D788
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 06:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747808453; cv=none; b=NYgNLVySs8x7JoKzaz3i3ZK392q2QgjDNNVgN2puFNWoRqe2QWkBQUD9x1eBX7KfbBfwYN5g6w+MAw3K1nPq19ORB01Zxtw1FCUXoZCLiI5ooZaHqVCUORYgSz28RMfWbkpqeGSayQuOpm5I4VCAiJjyfIdAFikF1wWNGI1nxyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747808453; c=relaxed/simple;
	bh=YHL1BO9Yw2qVuykoMrFywasyGMLqP7T8KUotdskXsco=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lonpAe5nyTWSgxuXJi1KMxgwpA6kKLLGlN9kGs2HTRgHA+lSTgsDk6DQp3W5btFy1ul0SP5JXE7bEkKR1IcYnEiopoGBFZMcYlPDcO7eu63JpYCg23JobPPYwJUnFdmxYUl2osZ+tb5EgWfG2mK6cJXi22gMGiNM732ncnsv2Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C/Bbax8J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747808451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=27vdWwqXm6Qw7dfKd1dwnOUfre6U0zDeEbDFMcZZEZY=;
	b=C/Bbax8J2SScAhiRRr4YtJi5E/O/z0bcDu2cdom9dSxE1UF0ZOceBAkLmizMnCM5cIs+Tv
	0GfF1NxlmpiPuqy+sPxpINy/75+rXT85PL6LAT03VKGjzHS7mfn8AYosCrmkTNZZwr/w6x
	8YN1cDp2wp5laJr6Hxo1h99JFygffdM=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-LTVyVKBUMkmBb1CTcN3wig-1; Wed, 21 May 2025 02:20:49 -0400
X-MC-Unique: LTVyVKBUMkmBb1CTcN3wig-1
X-Mimecast-MFC-AGG-ID: LTVyVKBUMkmBb1CTcN3wig_1747808448
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-30e9e81d4b0so5704244a91.3
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 23:20:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747808448; x=1748413248;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=27vdWwqXm6Qw7dfKd1dwnOUfre6U0zDeEbDFMcZZEZY=;
        b=AyljRgb6tdcIycQdIuv5D0WPDwdV/pn7c7z5RR8tXovuDEB24XHjF9vV9uuBAa/Qsd
         J9O5wyegNtswb8Mexis1WoH3yZRXlqXFJFj1DFrvKmV4GbbvTVBE44Vzjm5GXr8jrMKO
         tKYYbWKBEpb18xX592xnlr/tdD9lNxnfL5FZ7SRR2RM0MgW12tbjiknc0AQSr5BrRxRS
         W6m4gWvxI5ErQ81b8fb8Jcm2NQCsKgB/G/vYSIIlCAfnRfG0nI0JvI+WWPIFbNV/HUYO
         gBJBhSXIiO4EZliCVur2hmpz0BocLVjIingRPswi8ZiSeLCbYWoT2TW/v+2HyYDuokmz
         E9GA==
X-Gm-Message-State: AOJu0YxUSmrjwJ/Xv9AJ/0C6Z+LZ6grUYyLXACkLV67QHMSgIZ6l3dH3
	45uvFEtwn+9Y4fvDteiANgC2xm4UFlwvYuiPL/itu0hIIwU9dAiy9Fv1haAuegL5zB42rwJVlja
	AFMdOAdUZt/SSdSKly2ZZq97lGU4HSMJ77/D4URkxLJYeimeCXT6cww==
X-Gm-Gg: ASbGncsMH0/zQxso5AZ8mmYifd9X/uiO5mds/wBd533C8atB4uZMUG4jB5aamjs1AY/
	WGEdkaw62xR4hj5n+JZZbYb3UZWg7iHtGUF/Nsd67YBWmdxMcV3PI/5VW2EtasxG///kNraDQqS
	er9c/Djg94UDxOO3sUPiRrqW4Ghi3JmhlxQOr3T269/6e2K8SKeorLAZpD8rsliRrzACyjjbMlA
	Bmk4Vw2WkI5SAFZxaAvaz8+zujw6dO0mrQAPSeqcv2rUH4X/W1pFDmZWOLCOkKE7eq2QEX6Am09
	6rfLKkSDfONEYco=
X-Received: by 2002:a17:90b:35ca:b0:2fe:baa3:b8bc with SMTP id 98e67ed59e1d1-30e832258eamr23096812a91.23.1747808447861;
        Tue, 20 May 2025 23:20:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCcJqZvem5ZOsw0GUieRAaMuIKN6FQwGBBKSGgLmmfZRpS0KvtQJGPwRUgMl3I4UcNRsWE9Q==
X-Received: by 2002:a17:90b:35ca:b0:2fe:baa3:b8bc with SMTP id 98e67ed59e1d1-30e832258eamr23096785a91.23.1747808447373;
        Tue, 20 May 2025 23:20:47 -0700 (PDT)
Received: from [10.72.116.61] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f365b2d8fsm2847557a91.7.2025.05.20.23.20.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 23:20:46 -0700 (PDT)
Message-ID: <5b284638-2082-4d85-9e4d-4514ee15e193@redhat.com>
Date: Wed, 21 May 2025 14:20:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 16/16] scripts: Enable kvmtool
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
 <20250507151256.167769-17-alexandru.elisei@arm.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20250507151256.167769-17-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/7/25 11:12 PM, Alexandru Elisei wrote:
> Everything is in place to run the tests using kvmtool:
> 
> $ ./configure --target=kvmtool
> $ make clean && make
> $ KVMTOOL=<path/to/kvmtool> ./run_tests.sh
> 
> so enable it, and remove ERRATA_FORCE=y when configuring for kvmtool,
> because the runner will generate and pass the correct environment to
> kvmtool.
> 
> Missing is support for EFI tests. That's because distros don't ship a

Missing should be Nothing?

> EDK2 binary compiled for kvmtool, and on top of that kvm-unit-tests as
> an EFI app hasn't been tested to work with kvmtool.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> ---
>   README.md        | 18 +++++++++++++++++-
>   arm/efi/run      |  5 +++++
>   configure        |  1 -
>   scripts/vmm.bash |  2 +-
>   4 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/README.md b/README.md
> index be07dc28a094..723ce04cd978 100644
> --- a/README.md
> +++ b/README.md
> @@ -65,6 +65,9 @@ or:
>   
>   to run them all.
>   
> +All tests can be run using QEMU. On arm and arm64, tests can also be run using
> +kvmtool.
> +
>   By default the runner script searches for a suitable QEMU binary in the system.
>   To select a specific QEMU binary though, specify the QEMU=path/to/binary
>   environment variable:
> @@ -78,12 +81,25 @@ ACCEL=name environment variable:
>   
>   For running tests that involve migration from one QEMU instance to another
>   you also need to have the "ncat" binary (from the nmap.org project) installed,
> -otherwise the related tests will be skipped.
> +otherwise the related tests will be skipped. kvmtool does not support migration.
> +
> +As for running a test with kvmtool, please configure kvm-unit-tests accordingly
> +first:
> +
> +   ./configure --arch=arm64 --target=kvmtool
> +
> +then run the test(s) like with QEMU above.
> +
> +To select a kvmtool binary, specify the KVMTOOL=path/to/binary environment
> +variable. kvmtool supports only kvm as the accelerator.
>   
>   ## Running the tests with UEFI
>   
>   Check [x86/efi/README.md](./x86/efi/README.md).
>   
> +On arm and arm64, this is only supported with QEMU; kvmtool cannot run the
> +tests under UEFI.
> +
>   # Tests configuration file
>   
>   The test case may need specific runtime configurations, for
> diff --git a/arm/efi/run b/arm/efi/run
> index 53d71297cc52..0843725ec360 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -15,6 +15,11 @@ source scripts/vmm.bash
>   
>   check_vmm_supported
>   
> +if [[ $TARGET = "kvmtool" ]]; then
> +	echo "kvmtool does not support EFI tests."
> +	exit 2
> +fi
> +
>   if [ -f /usr/share/qemu-efi-aarch64/QEMU_EFI.fd ]; then
>   	DEFAULT_UEFI=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd
>   elif [ -f /usr/share/edk2/aarch64/QEMU_EFI.silent.fd ]; then
> diff --git a/configure b/configure
> index 8c4400db42bc..d5f9995172f8 100755
> --- a/configure
> +++ b/configure
> @@ -392,7 +392,6 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>           : "${uart_early_addr:=0x9000000}"
>       elif [ "$target" = "kvmtool" ]; then
>           : "${uart_early_addr:=0x1000000}"
> -        errata_force=1
>       else
>           echo "--target must be one of 'qemu' or 'kvmtool'!"
>           usage
> diff --git a/scripts/vmm.bash b/scripts/vmm.bash
> index ef9819f4132c..4ae60c37a6e8 100644
> --- a/scripts/vmm.bash
> +++ b/scripts/vmm.bash
> @@ -159,7 +159,7 @@ declare -A vmm_opts=(
>   function check_vmm_supported()
>   {
>   	case "$TARGET" in
> -	qemu)
> +	qemu | kvmtool)
>   		return 0
>   		;;
>   	*)

-- 
Shaoqin


