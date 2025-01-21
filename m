Return-Path: <kvm+bounces-36144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F8C2A181DA
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:17:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE476188882F
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEAFC1F4E48;
	Tue, 21 Jan 2025 16:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uIyKdIUQ"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C04E1F4E3E
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 16:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737476251; cv=none; b=biwSHmwVhQo0hflwIX6MDgdhV4dwaRp4Kbk/n3BZXYRpir68SgApntcfe/lXicybUyN0RPDKqHgHaUPA61xZTCkeipBaIwxE1Ubn4X3eHJdutEL4B66X9oIWlcq5x2oh8Twfsi1W9Jehn9NnZi86GJ66RLntYmHRI2VvFhfU9Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737476251; c=relaxed/simple;
	bh=LWgO6cMNccPXffxuVm3HTUEmVvXtNEJAAZS2taz+yeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=knep4uM3liXmHFNleu3noBJ5/jETrjp4WmgsG3XjNTKsTMnbNyDAq21H173s67g0nzBmNlMy+yM9q8mOHb9blu1Er/okZf//X5OnPCWBbbmEJTOKL0BkXloD1T74oi1TZKu2NImHAnkvqzdBX8VOUVnZfs508/adnXkFA+qNvbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uIyKdIUQ; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 21 Jan 2025 17:17:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737476245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7WwSMRATO0QjUqb11IwaPpIM7wS7YIxBQxz1gbtNgig=;
	b=uIyKdIUQNmCtu7Q0IcIVXtHI6XK6xj7PVO6GVegFWD6wgh2mr8arrR6cZhBwT6O4r/GQRY
	PGdz0lyr4Q5bxBPOjt3FmyZAyyEs3+aDLQ9S+6/Z5cC5t0DN2SwlomAxxkrnle8K2K9rLR
	GN90A4eGae+VZ+Mggm60xlRxe2A7J/0=
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
Message-ID: <20250121-c7f5ba2a25ccbfe793da07f6@orel>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-4-alexandru.elisei@arm.com>
 <20250121-45faf6a9a9681c7c9ece5f44@orel>
 <Z4_DKTMeDQqsqV_6@raptor>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4_DKTMeDQqsqV_6@raptor>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 21, 2025 at 03:54:17PM +0000, Alexandru Elisei wrote:
> Hi Drew,
> 
> On Tue, Jan 21, 2025 at 03:48:55PM +0100, Andrew Jones wrote:
> > On Mon, Jan 20, 2025 at 04:43:01PM +0000, Alexandru Elisei wrote:
> > > Arm and arm64 support running the tests under kvmtool. Unsurprisingly,
> > > kvmtool and qemu have a different command line syntax for configuring and
> > > running a virtual machine.
> > > 
> > > On top of that, when kvm-unit-tests has been configured to run under
> > > kvmtool (via ./configure --target=kvmtool), the early UART address changes,
> > > and if then the tests are run with qemu, this warning is displayed:
> > > 
> > > WARNING: early print support may not work. Found uart at 0x9000000, but early base is 0x1000000.
> > > 
> > > At the moment, the only way to run a test under kvmtool is manually, as no
> > > script has any knowledge of how to invoke kvmtool. Also, unless one looks
> > > at the logs, it's not obvious that the test runner is using qemu to run the
> > > tests, and not kvmtool.
> > > 
> > > To avoid any confusion for unsuspecting users, refuse to run a test via the
> > > testing scripts when kvm-unit-tests has been configured for kvmtool.
> > > 
> > > There are four different ways to run a test using the test infrastructure:
> > > with run_tests.sh, by invoking arm/run or arm/efi/run with the correct
> > > parameters (only the arm directory is mentioned here because the tests can
> > > be configured for kvmtool only on arm and arm64), and by creating
> > > standalone tests. Add a check in each of these locations for the supported
> > > virtual machine manager.
> > > 
> > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > ---
> > >  arm/efi/run             | 8 ++++++++
> > >  arm/run                 | 9 +++++++++
> > >  run_tests.sh            | 8 ++++++++
> > >  scripts/mkstandalone.sh | 8 ++++++++
> > >  4 files changed, 33 insertions(+)
> > > 
> > > diff --git a/arm/efi/run b/arm/efi/run
> > > index 8f41fc02df31..916f4c4deef6 100755
> > > --- a/arm/efi/run
> > > +++ b/arm/efi/run
> > > @@ -12,6 +12,14 @@ fi
> > >  source config.mak
> > >  source scripts/arch-run.bash
> > >  
> > > +case "$TARGET" in
> > > +qemu)
> > > +    ;;
> > > +*)
> > > +    echo "$0 does not support '$TARGET'"
> > > +    exit 2
> > > +esac
> > > +
> > >  if [ -f /usr/share/qemu-efi-aarch64/QEMU_EFI.fd ]; then
> > >  	DEFAULT_UEFI=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd
> > >  elif [ -f /usr/share/edk2/aarch64/QEMU_EFI.silent.fd ]; then
> > > diff --git a/arm/run b/arm/run
> > > index efdd44ce86a7..6db32cf09c88 100755
> > > --- a/arm/run
> > > +++ b/arm/run
> > > @@ -8,6 +8,15 @@ if [ -z "$KUT_STANDALONE" ]; then
> > >  	source config.mak
> > >  	source scripts/arch-run.bash
> > >  fi
> > > +
> > > +case "$TARGET" in
> > > +qemu)
> > > +    ;;
> > > +*)
> > > +   echo "'$TARGET' not supported"
> > > +   exit 3
> > 
> > I think we want exit code 2 here.
> 
> Exit code 2 is already in use in arm/run. Now that I'm looking more closely
> at it, exit code 2 is already in use in run_tests.sh, same for
> mkstandalone.sh and arm/efi/run.
> 
> How about using 3 everywhere as the exit code?
>

In kvm-unit-tests, exit code 2 is what we use for "most likely a run
script failed" (see the comment above run_qemu() in
scripts/arch-run.bash). We don't try to create a new error code for each
type of error, but we do have the error message as well. So if there's a
higher level runner, which runs this runner, it only needs to learn that
2 is likely a script failure and that an error message will hopefully
point the way to the problem.

Thanks,
drew

