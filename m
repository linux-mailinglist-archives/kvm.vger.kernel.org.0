Return-Path: <kvm+bounces-10755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A1A786FA99
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 08:19:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2710828146A
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 07:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0894134BF;
	Mon,  4 Mar 2024 07:19:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9CDE23BF
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 07:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709536785; cv=none; b=MSU0tPkBNGDRlLg1rte3prFmWL87Sml95E/HWqbvBVkzVFUypJe2+D/vd9xv6U97x5RjGt5/nsXLv6nEKO8NhLfbWbju+CSyzwdk0KdLKqpu2hTXUxJ6+zncQWY7QOzRMYRDIaCeOFfUlIVdqjDG7h+AeyEX5QENndBLcDNk/AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709536785; c=relaxed/simple;
	bh=O0zcJQ7FjxRGCqhtR+pEuDVV7oXzez4dyDSF6up+VYk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mx7Fq12f1r4koL+pN/4UcUzhnwWc0D70SOHy1Q1Oqw7Z4W4RPcs9A2q8gvBUARAF9fJ+WS8TmnFeClvuT8VKfKkj3+nWgu81CbKO3mMasMOF9UtVuz2nLXO/OALPsn5E7DCMDsiIxEPJ6A1NLCreEUSRLepBRghtHfud+33rm24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 022B81FB;
	Sun,  3 Mar 2024 23:20:18 -0800 (PST)
Received: from [192.168.5.30] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2BD7C3F762;
	Sun,  3 Mar 2024 23:19:40 -0800 (PST)
Message-ID: <e88eca18-7a76-4432-971b-adbbf7cbcdef@arm.com>
Date: Mon, 4 Mar 2024 07:19:38 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 06/18] arm64: efi: Move run code into a
 function
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-26-andrew.jones@linux.dev>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240227192109.487402-26-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/02/2024 19:21, Andrew Jones wrote:
> Push the run code in arm/efi/run into a function named
> uefi_shell_run() since it will create an EFI file system, copy
> the test and possibly the DTB there, and create a startup.nsh
> which executes the test from the UEFI shell. Pushing this
> code into a function allows additional execution paths to be
> created in the script. Also rename EFI_RUN to UEFI_SHELL_RUN
> to pass the information on to arm/run that it's being called
> from uefi_shell_run().
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,

Nikos

> ---
>   arm/efi/run | 33 +++++++++++++++++++--------------
>   arm/run     |  4 ++--
>   2 files changed, 21 insertions(+), 16 deletions(-)
> 
> diff --git a/arm/efi/run b/arm/efi/run
> index e45cecfa3265..494ba9e7efe7 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -63,18 +63,23 @@ if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
>   	exit
>   fi
>   
> -mkdir -p "$EFI_CASE_DIR"
> -cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
> -echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
> -if [ "$EFI_USE_DTB" = "y" ]; then
> -	qemu_args+=(-machine acpi=off)
> -	FDT_BASENAME="dtb"
> -	EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}"
> -	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_CASE_DIR/startup.nsh"
> -fi
> -echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_CASE_DIR/startup.nsh"
> +uefi_shell_run()
> +{
> +	mkdir -p "$EFI_CASE_DIR"
> +	cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
> +	echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
> +	if [ "$EFI_USE_DTB" = "y" ]; then
> +		qemu_args+=(-machine acpi=off)
> +		FDT_BASENAME="dtb"
> +		UEFI_SHELL_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}"
> +		echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_CASE_DIR/startup.nsh"
> +	fi
> +	echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_CASE_DIR/startup.nsh"
> +
> +	UEFI_SHELL_RUN=y $TEST_DIR/run \
> +		-bios "$EFI_UEFI" \
> +		-drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
> +		"${qemu_args[@]}"
> +}
>   
> -EFI_RUN=y $TEST_DIR/run \
> -	-bios "$EFI_UEFI" \
> -	-drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
> -	"${qemu_args[@]}"
> +uefi_shell_run
> diff --git a/arm/run b/arm/run
> index ac64b3b461a2..40c2ca66ba7e 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -60,7 +60,7 @@ if ! $qemu $M -chardev '?' | grep -q testdev; then
>   	exit 2
>   fi
>   
> -if [ "$EFI_RUN" != "y" ]; then
> +if [ "$UEFI_SHELL_RUN" != "y" ]; then
>   	chr_testdev='-device virtio-serial-device'
>   	chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
>   fi
> @@ -75,7 +75,7 @@ command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
>   command+=" -display none -serial stdio"
>   command="$(migration_cmd) $(timeout_cmd) $command"
>   
> -if [ "$EFI_RUN" = "y" ]; then
> +if [ "$UEFI_SHELL_RUN" = "y" ]; then
>   	ENVIRON_DEFAULT=n run_qemu_status $command "$@"
>   else
>   	run_qemu $command -kernel "$@"

