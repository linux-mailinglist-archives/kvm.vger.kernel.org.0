Return-Path: <kvm+bounces-6223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 404D582D8E1
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 13:23:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E63451F222A4
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 12:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B72822C841;
	Mon, 15 Jan 2024 12:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NK2BDO3r"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6884B2C842
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 12:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 15 Jan 2024 13:23:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705321425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QY/IvvMEj3IlMU3u+CLssUI3PK9FslaF26Qqhw9KtfU=;
	b=NK2BDO3r4L6MXCVSXIEIZRMiKaKxH9/NHxz5+tBT/CaVFzikK0hEd5EF22/G9s/IAYxcYO
	y5FUhxbJL8qCzaSA1+fuvz6d1CeRFPeea7clc3s3AW37ljAPuCxkNdgnwBmLvep4ojrlpK
	WZkosf/NR4X5/a399f5KfWZ70m6uUJE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: kvmarm@lists.linux.dev, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Eric Auger <eric.auger@redhat.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 3/3] arm64: efi: Make running tests on
 EFI can be parallel
Message-ID: <20240115-df5b09a3501c04572a54416d@orel>
References: <20231130032940.2729006-1-shahuang@redhat.com>
 <20231130032940.2729006-4-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130032940.2729006-4-shahuang@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 29, 2023 at 10:29:40PM -0500, Shaoqin Huang wrote:
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
>   - ABORT: pmu: Unknown sub-test 'pmu-mem-acce'
> * pmu-chained-counters.log
>   - ABORT: pmu: Unknown sub-test 'pmu-mem-access-reliab'
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

We can write it the above like the following to avoid duplicating the
basename call

: "${EFI_CASE:=$(basename $1 .efi)}"
: "${EFI_TESTNAME:=$TESTNAME}"
: "${EFI_TESTNAME:=$EFI_CASE}"


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

Otherwise

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

