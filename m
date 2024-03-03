Return-Path: <kvm+bounces-10742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5043386F75B
	for <lists+kvm@lfdr.de>; Sun,  3 Mar 2024 23:07:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7DB6B20BA3
	for <lists+kvm@lfdr.de>; Sun,  3 Mar 2024 22:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA87F7A719;
	Sun,  3 Mar 2024 22:07:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81AB343AB5
	for <kvm@vger.kernel.org>; Sun,  3 Mar 2024 22:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709503624; cv=none; b=SSiJE/o0QkU/Wdzsz4b2jqW7g0wQDvbteVvBjPNxSNA3n7/PaFH+rRt5uEgTreS0DSeO/c0FGo+LkvUSIeJ2KU9rZXYY1qzePUwS8CERfketIexDkPoZ9l2U29Y5Awgg9w0oMF/1MVgIwxA9oEHQTBqlhy1MKBeTjeiYYreob5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709503624; c=relaxed/simple;
	bh=aFDATYBibbY7MOHkR8SdUE9K1bFvFBOnGWCAWUjtznY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JlCKnZCsyX2y+/oii/aeeW54BPnBtsgyUn58ELIvYM9ylN5JE6I7KVe+QooRZV/Wo8kcogRXA44A3GZ8ah5CmMZDK3BjL1Gp7qRqXc9h0GBwZp+9IJwTMfvbrfZZqBRuSYOO2hVsqAIgYEIjR4QM5GyujZD29/NopZ/YiXq4e8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA4901FB;
	Sun,  3 Mar 2024 14:07:38 -0800 (PST)
Received: from [10.57.69.149] (unknown [10.57.69.149])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8407D3F73F;
	Sun,  3 Mar 2024 14:07:00 -0800 (PST)
Message-ID: <a8b67479-59d8-4f84-89df-11892cace501@arm.com>
Date: Sun, 3 Mar 2024 22:06:59 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 04/18] arm64: efi: Make running tests on
 EFI can be parallel
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-24-andrew.jones@linux.dev>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240227192109.487402-24-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/02/2024 19:21, Andrew Jones wrote:
> From: Shaoqin Huang <shahuang@redhat.com>
> 
> Currently running tests on EFI in parallel can cause part of tests to
> fail, this is because arm/efi/run script use the EFI_CASE to create the
> subdir under the efi-tests, and the EFI_CASE is the filename of the
> test, when running tests in parallel, the multiple tests exist in the
> same filename will execute at the same time, which will use the same
> directory and write the test specific things into it, this cause
> chaotic and make some tests fail.
> 
> For example, if we running the pmu-sw-incr and pmu-chained-counters
> and other pmu tests on EFI at the same time, the EFI_CASE will be pmu.
> So they will write their $cmd_args to the $EFI/TEST/pmu/startup.nsh
> at the same time, which will corrupt the startup.nsh file.
> 
> And we can get the log which outputs:
> 
> * pmu-sw-incr.log:
>    - ABORT: pmu: Unknown sub-test 'pmu-mem-acce'
> * pmu-chained-counters.log
>    - ABORT: pmu: Unknown sub-test 'pmu-mem-access-reliab'
> 
> And the efi-tests/pmu/startup.nsh:
> 
> @echo -off
> setvar fdtfile -guid 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 -rt =L"dtb"
> pmu.efi pmu-mem-access-reliability
> setvar fdtfile -guid 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 -rt =L"dtb"
> pmu.efi pmu-chained-sw-incr
> 
> As you can see, when multiple tests write to the same startup.nsh file,
> it causes the issue.
> 
> To Fix this issue, use the testname instead of the filename to create
> the subdir under the efi-tests. We use the EFI_TESTNAME to replace the
> EFI_CASE in script. Since every testname is specific, now the tests
> can be run parallel. It also considers when user directly use the
> arm/efi/run to run test, in this case, still use the filename.
> 
> Besides, replace multiple $EFI_TEST/$EFI_CASE to the $EFI_CASE_DIR, this
> makes the script looks more clean and we don'e need to replace many
> EFI_CASE to EFI_TESTNAME.
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

> ---
>   arm/efi/run | 16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/arm/efi/run b/arm/efi/run
> index e629abde5273..8b6512520026 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -25,6 +25,8 @@ fi
>   : "${EFI_UEFI:=$DEFAULT_UEFI}"
>   : "${EFI_TEST:=efi-tests}"
>   : "${EFI_CASE:=$(basename $1 .efi)}"
> +: "${EFI_TESTNAME:=$TESTNAME}"
> +: "${EFI_TESTNAME:=$EFI_CASE}"
>   : "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
>   
>   [ "$EFI_USE_ACPI" = "y" ] || EFI_USE_DTB=y
> @@ -63,20 +65,20 @@ if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
>   	exit
>   fi
>   
> -: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE"}"
> +: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
>   mkdir -p "$EFI_CASE_DIR"
>   
> -cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
> -echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
> +cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
> +echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
>   if [ "$EFI_USE_DTB" = "y" ]; then
>   	qemu_args+=(-machine acpi=off)
>   	FDT_BASENAME="dtb"
> -	$(EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_TEST/$EFI_CASE/$FDT_BASENAME" "${qemu_args[@]}")
> -	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_TEST/$EFI_CASE/startup.nsh"
> +	$(EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}")
> +	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_CASE_DIR/startup.nsh"
>   fi
> -echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_TEST/$EFI_CASE/startup.nsh"
> +echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_CASE_DIR/startup.nsh"
>   
>   EFI_RUN=y $TEST_DIR/run \
>          -bios "$EFI_UEFI" \
> -       -drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
> +       -drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
>          "${qemu_args[@]}"

