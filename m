Return-Path: <kvm+bounces-10760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB67386FB23
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 08:52:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14CF71C21054
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 07:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 334B2171C1;
	Mon,  4 Mar 2024 07:52:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B23171AE
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 07:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709538765; cv=none; b=O48oqhzmAEIrHV1AZnY0WTEKGT861INqutyBzFeR1yacDjicm5RMOnCO9j3ZsC0MXQaBS1wFokVa0gDE8hhBhx6zl53oAXMl40+G0P4WXFAWp2fWtzWeq2lgbzSo0TQ/4BFvrkfqLRujrsIg77bf8aGyk4jA+P8E04xixN+EdqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709538765; c=relaxed/simple;
	bh=aQGlS/2wJjKzr1Lg/Varj+9anZurdMoXJIo92IAV5sA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kkALP8+ie9bmPlzJTHMhI2oC6AGlro6jU6+lEGscdquYIoNCNQLuO+P5fFbhTgEvqWs0u3NZ/s3VSrk7dbHPoH+bAuvYF/j10WProGNWH/FOQ6k5/u6unM36EmeIjmbIcm0UenO6DKvM3Lcl3IWahSbG0G0SSVRsXFVqrybQlzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7EC5C1FB;
	Sun,  3 Mar 2024 23:53:19 -0800 (PST)
Received: from [192.168.5.30] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A3A4D3F762;
	Sun,  3 Mar 2024 23:52:41 -0800 (PST)
Message-ID: <801c7883-2e16-4830-83bd-f8c2c67f4d2e@arm.com>
Date: Mon, 4 Mar 2024 07:52:40 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 10/18] arm64: efi: Allow running tests
 directly
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-30-andrew.jones@linux.dev>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240227192109.487402-30-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/02/2024 19:21, Andrew Jones wrote:
> Since it's possible to run tests with UEFI and the QEMU -kernel
> option (and now the DTB will be found and even the environ will
> be set up from an initrd if given with the -initrd option), then
> we can skip the loading of EFI tests into a file system and booting
> to the shell to run them. Just run them directly. Running directly
> is waaaaaay faster than booting the shell first. We keep the UEFI
> shell as the default behavior, though, and provide a new configure
> option to enable the direct running.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Just a minor nit, see below, but in any case:

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

> ---
>   arm/efi/run | 17 +++++++++++++++--
>   arm/run     |  4 +++-
>   configure   | 17 +++++++++++++++++
>   3 files changed, 35 insertions(+), 3 deletions(-)
> 
> diff --git a/arm/efi/run b/arm/efi/run
> index b7a8418a07f8..af7b593c2bb8 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -18,10 +18,12 @@ elif [ -f /usr/share/edk2/aarch64/QEMU_EFI.silent.fd ]; then
>   	DEFAULT_UEFI=/usr/share/edk2/aarch64/QEMU_EFI.silent.fd
>   fi
>   
> +KERNEL_NAME=$1
> +
>   : "${EFI_SRC:=$TEST_DIR}"
>   : "${EFI_UEFI:=$DEFAULT_UEFI}"
>   : "${EFI_TEST:=efi-tests}"
> -: "${EFI_CASE:=$(basename $1 .efi)}"
> +: "${EFI_CASE:=$(basename $KERNEL_NAME .efi)}"
>   : "${EFI_TESTNAME:=$TESTNAME}"
>   : "${EFI_TESTNAME:=$EFI_CASE}"
>   : "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
> @@ -80,4 +82,15 @@ uefi_shell_run()
>   		"${qemu_args[@]}"
>   }
>   
> -uefi_shell_run
> +if [ "$EFI_DIRECT" = "y" ]; then
> +	if [ "$EFI_USE_ACPI" != "y" ]; then
> +		qemu_args+=(-machine acpi=off)
> +	fi

The if statement above is common for the efi and efi_direct paths. You 
could also move it above to avoid the code replication.

Thanks,

Nikos

> +	$TEST_DIR/run \
> +		$KERNEL_NAME \
> +		-append "$(basename $KERNEL_NAME) ${cmd_args[@]}" \
> +		-bios "$EFI_UEFI" \
> +		"${qemu_args[@]}"
> +else
> +	uefi_shell_run
> +fi
> diff --git a/arm/run b/arm/run
> index 40c2ca66ba7e..efdd44ce86a7 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -60,7 +60,7 @@ if ! $qemu $M -chardev '?' | grep -q testdev; then
>   	exit 2
>   fi
>   
> -if [ "$UEFI_SHELL_RUN" != "y" ]; then
> +if [ "$UEFI_SHELL_RUN" != "y" ] && [ "$EFI_USE_ACPI" != "y" ]; then
>   	chr_testdev='-device virtio-serial-device'
>   	chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
>   fi
> @@ -77,6 +77,8 @@ command="$(migration_cmd) $(timeout_cmd) $command"
>   
>   if [ "$UEFI_SHELL_RUN" = "y" ]; then
>   	ENVIRON_DEFAULT=n run_qemu_status $command "$@"
> +elif [ "$EFI_USE_ACPI" = "y" ]; then
> +	run_qemu_status $command -kernel "$@"
>   else
>   	run_qemu $command -kernel "$@"
>   fi
> diff --git a/configure b/configure
> index 05e6702eab06..283c959973fd 100755
> --- a/configure
> +++ b/configure
> @@ -32,6 +32,7 @@ enable_dump=no
>   page_size=
>   earlycon=
>   efi=
> +efi_direct=
>   
>   # Enable -Werror by default for git repositories only (i.e. developer builds)
>   if [ -e "$srcdir"/.git ]; then
> @@ -89,6 +90,11 @@ usage() {
>   	    --[enable|disable]-efi Boot and run from UEFI (disabled by default, x86_64 and arm64 only)
>   	    --[enable|disable]-werror
>   	                           Select whether to compile with the -Werror compiler flag
> +	    --[enable|disable]-efi-direct
> +	                           Select whether to run EFI tests directly with QEMU's -kernel
> +	                           option. When not enabled, tests will be placed in an EFI file
> +	                           system and run from the UEFI shell. Ignored when efi isn't enabled.
> +	                           (arm64 only)
>   EOF
>       exit 1
>   }
> @@ -168,6 +174,12 @@ while [[ "$1" = -* ]]; do
>   	--disable-efi)
>   	    efi=n
>   	    ;;
> +	--enable-efi-direct)
> +	    efi_direct=y
> +	    ;;
> +	--disable-efi-direct)
> +	    efi_direct=n
> +	    ;;
>   	--enable-werror)
>   	    werror=-Werror
>   	    ;;
> @@ -185,6 +197,10 @@ while [[ "$1" = -* ]]; do
>       esac
>   done
>   
> +if [ -z "$efi" ] || [ "$efi" = "n" ]; then
> +    [ "$efi_direct" = "y" ] && efi_direct=
> +fi
> +
>   if [ -n "$host_key_document" ] && [ ! -f "$host_key_document" ]; then
>       echo "Host key document doesn't exist at the specified location."
>       exit 1
> @@ -423,6 +439,7 @@ GENPROTIMG=${GENPROTIMG-genprotimg}
>   HOST_KEY_DOCUMENT=$host_key_document
>   CONFIG_DUMP=$enable_dump
>   CONFIG_EFI=$efi
> +EFI_DIRECT=$efi_direct
>   CONFIG_WERROR=$werror
>   GEN_SE_HEADER=$gen_se_header
>   EOF

