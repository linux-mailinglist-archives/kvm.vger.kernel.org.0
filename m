Return-Path: <kvm+bounces-36123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 53BF7A18060
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 15:49:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78AD9188B82C
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 14:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BFFC1F4268;
	Tue, 21 Jan 2025 14:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bizThze3"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F84E1F4260
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 14:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737470953; cv=none; b=ca/istKFk68eAkwlQ2Uf8/h6an0lnNtuk+L/SyGIbom8lzjqhJzs2PKYjQkL7Bg7C5dZwmb0a1fytr9XUpwEpZySltkA5RjM4kIE51xzPC/WkacEZBpQ/eLYPo4mKbN/pcOOnhVp1inJlW6aVQ2HyUh4VXNwgfVfRmIobsePxbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737470953; c=relaxed/simple;
	bh=RmT4EuFeLx2Wfn0yzl3SKco+ybGvdLvm200k8fUIAkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uzT1I8HX9xGTxmhXy/dAKaOrJ1SmePyKwAjgrJLLFuiG66N93DnNVh12s+LRyDS+NqqXkaidbedXlm0Ak+RM8992XJnME4iOeVHjxRRnTVTubmYE7oqVaW3UqBZXlk/X71xS4smQd4NmGMi9JMRaov2A5QQJQoBk5iQXVb2wffA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bizThze3; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 21 Jan 2025 15:48:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737470939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y4U3mhaNeCPZx2S5DokPxis3spPsXAjQG6CQBxTg9Ys=;
	b=bizThze3yBlYVxibDfKZo6yDUkTwkcWNzU7AThmgiseZtF+i09K+Eu1VGnGFaj5BSju9pB
	f13cntnWjd1BUtmai6RYLN1Mc6354wufLjcOx1v27+pSUv2Bp7mIXHc6sqOTkKQuKhDmp9
	Lmw7Xs5KCfvBN3dtKK6dzoVeIXnrnow=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
	andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 03/18] scripts: Refuse to run the tests
 if not configured for qemu
Message-ID: <20250121-45faf6a9a9681c7c9ece5f44@orel>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-4-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250120164316.31473-4-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 20, 2025 at 04:43:01PM +0000, Alexandru Elisei wrote:
> Arm and arm64 support running the tests under kvmtool. Unsurprisingly,
> kvmtool and qemu have a different command line syntax for configuring and
> running a virtual machine.
> 
> On top of that, when kvm-unit-tests has been configured to run under
> kvmtool (via ./configure --target=kvmtool), the early UART address changes,
> and if then the tests are run with qemu, this warning is displayed:
> 
> WARNING: early print support may not work. Found uart at 0x9000000, but early base is 0x1000000.
> 
> At the moment, the only way to run a test under kvmtool is manually, as no
> script has any knowledge of how to invoke kvmtool. Also, unless one looks
> at the logs, it's not obvious that the test runner is using qemu to run the
> tests, and not kvmtool.
> 
> To avoid any confusion for unsuspecting users, refuse to run a test via the
> testing scripts when kvm-unit-tests has been configured for kvmtool.
> 
> There are four different ways to run a test using the test infrastructure:
> with run_tests.sh, by invoking arm/run or arm/efi/run with the correct
> parameters (only the arm directory is mentioned here because the tests can
> be configured for kvmtool only on arm and arm64), and by creating
> standalone tests. Add a check in each of these locations for the supported
> virtual machine manager.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/efi/run             | 8 ++++++++
>  arm/run                 | 9 +++++++++
>  run_tests.sh            | 8 ++++++++
>  scripts/mkstandalone.sh | 8 ++++++++
>  4 files changed, 33 insertions(+)
> 
> diff --git a/arm/efi/run b/arm/efi/run
> index 8f41fc02df31..916f4c4deef6 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -12,6 +12,14 @@ fi
>  source config.mak
>  source scripts/arch-run.bash
>  
> +case "$TARGET" in
> +qemu)
> +    ;;
> +*)
> +    echo "$0 does not support '$TARGET'"
> +    exit 2
> +esac
> +
>  if [ -f /usr/share/qemu-efi-aarch64/QEMU_EFI.fd ]; then
>  	DEFAULT_UEFI=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd
>  elif [ -f /usr/share/edk2/aarch64/QEMU_EFI.silent.fd ]; then
> diff --git a/arm/run b/arm/run
> index efdd44ce86a7..6db32cf09c88 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -8,6 +8,15 @@ if [ -z "$KUT_STANDALONE" ]; then
>  	source config.mak
>  	source scripts/arch-run.bash
>  fi
> +
> +case "$TARGET" in
> +qemu)
> +    ;;
> +*)
> +   echo "'$TARGET' not supported"
> +   exit 3

I think we want exit code 2 here.

> +esac
> +
>  processor="$PROCESSOR"
>  
>  if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
> diff --git a/run_tests.sh b/run_tests.sh
> index 23d81b2caaa1..61480d0c05ed 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -100,6 +100,14 @@ while [ $# -gt 0 ]; do
>      shift
>  done
>  
> +case "$TARGET" in
> +qemu)
> +    ;;
> +*)
> +    echo "$0 does not support '$TARGET'"
> +    exit 2
> +esac
> +
>  # RUNTIME_log_file will be configured later
>  if [[ $tap_output == "no" ]]; then
>      process_test_output() { cat >> $RUNTIME_log_file; }
> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> index 2318a85f0706..4de97056e641 100755
> --- a/scripts/mkstandalone.sh
> +++ b/scripts/mkstandalone.sh
> @@ -7,6 +7,14 @@ fi
>  source config.mak
>  source scripts/common.bash
>  
> +case "$TARGET" in
> +qemu)
> +    ;;
> +*)
> +    echo "'$TARGET' not supported for standlone tests"
> +    exit 2
> +esac
> +
>  temp_file ()
>  {
>  	local var="$1"
> -- 
> 2.47.1
>

I think we could put the check in a function in scripts/arch-run.bash and
just use the same error message for all cases.

Thanks,
drew

> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

