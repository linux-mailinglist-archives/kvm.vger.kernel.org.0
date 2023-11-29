Return-Path: <kvm+bounces-2746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 696EA7FD279
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 10:27:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 260E71F20F6F
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 09:27:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF5914A87;
	Wed, 29 Nov 2023 09:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wPlwp9Sf"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426D4B9
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 01:27:05 -0800 (PST)
Date: Wed, 29 Nov 2023 10:27:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701250022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bhxGlBIp4xA26DpM3gtwy7bdm0tqJk23Hm4jgBYcG4M=;
	b=wPlwp9Sf4Fow7VcncY/q5ExqoJsQbklitfaqiOX1T/9sJwv//GPBX7xHxaHfpsdPav8KJH
	2X9vd1DxOn1q/GCSyiRLEXhCVJ8C5QKt9Ngyv/4GXr2Rk9iTNLztxFx1XR+GUkoh26BOHx
	3Jn5tUDzKg3e1qiRm1VDXhIsk1ehSlc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: kvmarm@lists.linux.dev, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Eric Auger <eric.auger@redhat.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 3/3] arm64: efi: Make running tests on
 EFI can be parallel
Message-ID: <20231129-7fbc43944dc62a55cffe131c@orel>
References: <20231129032123.2658343-1-shahuang@redhat.com>
 <20231129032123.2658343-4-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129032123.2658343-4-shahuang@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 28, 2023 at 10:21:23PM -0500, Shaoqin Huang wrote:
> Currently running tests on EFI in parallel can cause part of tests to
> fail, this is because arm/efi/run script use the EFI_CASE to create the
> subdir under the efi-tests, and the EFI_CASE is the filename of the
> test, when running tests in parallel, the multiple tests exist in the
> same filename will execute at the same time, which will use the same
> directory and write the test specific things into it, this cause
> chaotic and make some tests fail.

How do they fail? iiuc, we're switching from having one of each unique
binary on the efi partition to multiple redundant binaries, since we
copy the binary for each test, even when it's the same as for other
tests. It seems like we should be able to keep single unique binaries
and resolve the parallel execution failure by just checking for existence
of the binaries or only creating test-specific data directories or
something.

> 
> To Fix this things, use the testname instead of the filename to create
> the subdir under the efi-tests. We use the EFI_TESTNAME to replace the
> EFI_CASE in script. Since every testname is specific, now the tests
> can be run parallel. It also considers when user directly use the
> arm/efi/run to run test, in this case, still use the filename.
> 
> Besides, replace multiple $EFI_TEST/$EFI_CASE to the $EFI_CASE_DIR, this
> makes the script looks more clean and we don'e need to replace many
> EFI_CASE to EFI_TESTNAME.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>  arm/efi/run | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/arm/efi/run b/arm/efi/run
> index 6872c337..03bfbef4 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -24,6 +24,8 @@ fi
>  : "${EFI_SRC:=$TEST_DIR}"
>  : "${EFI_UEFI:=$DEFAULT_UEFI}"
>  : "${EFI_TEST:=efi-tests}"
> +: "${EFI_TESTNAME:=$TESTNAME}"
> +: "${EFI_TESTNAME:=$(basename $1 .efi)}"
>  : "${EFI_CASE:=$(basename $1 .efi)}"
>  : "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
>  
> @@ -56,20 +58,20 @@ if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
>  	EFI_CASE=dummy
>  fi
>  
> -: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE"}"
> +: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
>  mkdir -p "$EFI_CASE_DIR"
>  
> -cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
> -echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
> +cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
> +echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"

Unrelated change, should be a separate patch.

>  if [ "$EFI_USE_DTB" = "y" ]; then
>  	qemu_args+=(-machine acpi=off)
>  	FDT_BASENAME="dtb"
> -	$(EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_TEST/$EFI_CASE/$FDT_BASENAME" "${qemu_args[@]}")
> -	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_TEST/$EFI_CASE/startup.nsh"
> +	$(EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}")
> +	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_CASE_DIR/startup.nsh"
>  fi
> -echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_TEST/$EFI_CASE/startup.nsh"
> +echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_CASE_DIR/startup.nsh"
>  
>  EFI_RUN=y $TEST_DIR/run \
>         -bios "$EFI_UEFI" \
> -       -drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
> +       -drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
>         "${qemu_args[@]}"
> -- 
> 2.40.1
>

Thanks,
drew

