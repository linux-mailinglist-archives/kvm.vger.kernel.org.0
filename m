Return-Path: <kvm+bounces-36131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C590A18167
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:54:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 738D37A4903
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 15:54:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D22DA1F429A;
	Tue, 21 Jan 2025 15:54:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E7671F2C57;
	Tue, 21 Jan 2025 15:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737474866; cv=none; b=JGSIy2EZxWtGVEqYQ8SKvx19TZkfjg0qH2dmUrK3O1mYrJQbqfur3HOnHEcJvCBTnRpkmmH/oCSUis3ewyDkf1zzi1ykniSDI+AzRobxc9sr4MVuV+jjtYytINCsBGBf8f/8PwfsfwJocUoqgJOYddNysu1qoFlF6lB3iKQxnj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737474866; c=relaxed/simple;
	bh=/FxALeXiZ2dSXGuzdwGd0Zb6gO5IhoyS2kxWj2mQ5vE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EEnu9dcMrxu+yd/i0948elVxrbMh1qnV0hhmxIi2yGTCorO7YKd4fvBytTd+0JijOqlDTgjSceMqtcAK7721gXoPBnYRjnnrWsSA0ELrLHrFq9TrhNNY3O22BqMJfjywBJnQXjwJsVJpSIPmgaAPSFiuNN8n9e9nlApBZ7KyYbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 653FF1063;
	Tue, 21 Jan 2025 07:54:52 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A408B3F738;
	Tue, 21 Jan 2025 07:54:20 -0800 (PST)
Date: Tue, 21 Jan 2025 15:54:17 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com,
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
	david@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joey.gouly@arm.com, andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 03/18] scripts: Refuse to run the tests
 if not configured for qemu
Message-ID: <Z4_DKTMeDQqsqV_6@raptor>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-4-alexandru.elisei@arm.com>
 <20250121-45faf6a9a9681c7c9ece5f44@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250121-45faf6a9a9681c7c9ece5f44@orel>

Hi Drew,

On Tue, Jan 21, 2025 at 03:48:55PM +0100, Andrew Jones wrote:
> On Mon, Jan 20, 2025 at 04:43:01PM +0000, Alexandru Elisei wrote:
> > Arm and arm64 support running the tests under kvmtool. Unsurprisingly,
> > kvmtool and qemu have a different command line syntax for configuring and
> > running a virtual machine.
> > 
> > On top of that, when kvm-unit-tests has been configured to run under
> > kvmtool (via ./configure --target=kvmtool), the early UART address changes,
> > and if then the tests are run with qemu, this warning is displayed:
> > 
> > WARNING: early print support may not work. Found uart at 0x9000000, but early base is 0x1000000.
> > 
> > At the moment, the only way to run a test under kvmtool is manually, as no
> > script has any knowledge of how to invoke kvmtool. Also, unless one looks
> > at the logs, it's not obvious that the test runner is using qemu to run the
> > tests, and not kvmtool.
> > 
> > To avoid any confusion for unsuspecting users, refuse to run a test via the
> > testing scripts when kvm-unit-tests has been configured for kvmtool.
> > 
> > There are four different ways to run a test using the test infrastructure:
> > with run_tests.sh, by invoking arm/run or arm/efi/run with the correct
> > parameters (only the arm directory is mentioned here because the tests can
> > be configured for kvmtool only on arm and arm64), and by creating
> > standalone tests. Add a check in each of these locations for the supported
> > virtual machine manager.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  arm/efi/run             | 8 ++++++++
> >  arm/run                 | 9 +++++++++
> >  run_tests.sh            | 8 ++++++++
> >  scripts/mkstandalone.sh | 8 ++++++++
> >  4 files changed, 33 insertions(+)
> > 
> > diff --git a/arm/efi/run b/arm/efi/run
> > index 8f41fc02df31..916f4c4deef6 100755
> > --- a/arm/efi/run
> > +++ b/arm/efi/run
> > @@ -12,6 +12,14 @@ fi
> >  source config.mak
> >  source scripts/arch-run.bash
> >  
> > +case "$TARGET" in
> > +qemu)
> > +    ;;
> > +*)
> > +    echo "$0 does not support '$TARGET'"
> > +    exit 2
> > +esac
> > +
> >  if [ -f /usr/share/qemu-efi-aarch64/QEMU_EFI.fd ]; then
> >  	DEFAULT_UEFI=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd
> >  elif [ -f /usr/share/edk2/aarch64/QEMU_EFI.silent.fd ]; then
> > diff --git a/arm/run b/arm/run
> > index efdd44ce86a7..6db32cf09c88 100755
> > --- a/arm/run
> > +++ b/arm/run
> > @@ -8,6 +8,15 @@ if [ -z "$KUT_STANDALONE" ]; then
> >  	source config.mak
> >  	source scripts/arch-run.bash
> >  fi
> > +
> > +case "$TARGET" in
> > +qemu)
> > +    ;;
> > +*)
> > +   echo "'$TARGET' not supported"
> > +   exit 3
> 
> I think we want exit code 2 here.

Exit code 2 is already in use in arm/run. Now that I'm looking more closely
at it, exit code 2 is already in use in run_tests.sh, same for
mkstandalone.sh and arm/efi/run.

How about using 3 everywhere as the exit code?

Also, your idea (below) to use a function to test for supported $TARGETs is
a very good one, I'll do it in the next iteration.

Thanks,
Alex

> 
> > +esac
> > +
> >  processor="$PROCESSOR"
> >  
> >  if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
> > diff --git a/run_tests.sh b/run_tests.sh
> > index 23d81b2caaa1..61480d0c05ed 100755
> > --- a/run_tests.sh
> > +++ b/run_tests.sh
> > @@ -100,6 +100,14 @@ while [ $# -gt 0 ]; do
> >      shift
> >  done
> >  
> > +case "$TARGET" in
> > +qemu)
> > +    ;;
> > +*)
> > +    echo "$0 does not support '$TARGET'"
> > +    exit 2
> > +esac
> > +
> >  # RUNTIME_log_file will be configured later
> >  if [[ $tap_output == "no" ]]; then
> >      process_test_output() { cat >> $RUNTIME_log_file; }
> > diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> > index 2318a85f0706..4de97056e641 100755
> > --- a/scripts/mkstandalone.sh
> > +++ b/scripts/mkstandalone.sh
> > @@ -7,6 +7,14 @@ fi
> >  source config.mak
> >  source scripts/common.bash
> >  
> > +case "$TARGET" in
> > +qemu)
> > +    ;;
> > +*)
> > +    echo "'$TARGET' not supported for standlone tests"
> > +    exit 2
> > +esac
> > +
> >  temp_file ()
> >  {
> >  	local var="$1"
> > -- 
> > 2.47.1
> >
> 
> I think we could put the check in a function in scripts/arch-run.bash and
> just use the same error message for all cases.
> 
> Thanks,
> drew
> 
> > 
> > -- 
> > kvm-riscv mailing list
> > kvm-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/kvm-riscv

