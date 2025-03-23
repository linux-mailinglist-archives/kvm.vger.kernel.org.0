Return-Path: <kvm+bounces-41764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 32647A6CEE4
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 12:16:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5805D18935D2
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 11:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A2AF20371B;
	Sun, 23 Mar 2025 11:16:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D44418A6C4
	for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 11:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742728587; cv=none; b=DWB/1jU0wVjyW4BNOX5qjKh+byLHf4f9gKg3fXIdNpLb2PF5H7Zhwg0TryFVNuaGEW6sWp4Cng2eD0nMVpicF7owqq1uK/wT6sAT/BjmitSA0MFkuYLQvOw7CTKS2XQYQsAbDMx2liHwd+iL2dhV/hwhwuFTW1IegFORWLrS8Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742728587; c=relaxed/simple;
	bh=ajW+PPgrk7z378inHZH2Yyw+A0806f19GqjR1io3ccc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UR070ilFrGjWgDv5MJhnX9/7G2D9jOgBOaJaqzHS69C/hvJ5peejUg3UzmTpVyB652nETO4a42nuBL2LXXrBkBUzg2GjH3lkn3FsDzPmN+QrbpAAFAF5elKNrpMDTFhDjLcc8uMfO8RoRio7kAv4bhlUhPnV8gfeyq7L+5y6h8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 74F92106F;
	Sun, 23 Mar 2025 04:16:30 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A9623F694;
	Sun, 23 Mar 2025 04:16:22 -0700 (PDT)
Date: Sun, 23 Mar 2025 11:16:19 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, eric.auger@redhat.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 4/5] configure: Add --qemu-cpu option
Message-ID: <Z9_tg6WhKvIJtBai@raptor>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-6-jean-philippe@linaro.org>
 <20250322-91a8125ad8651b24246e5799@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250322-91a8125ad8651b24246e5799@orel>

Hi Drew,

On Sat, Mar 22, 2025 at 12:26:59PM +0100, Andrew Jones wrote:
> On Fri, Mar 14, 2025 at 03:49:04PM +0000, Jean-Philippe Brucker wrote:
> > Add the --qemu-cpu option to let users set the CPU type to run on.
> > At the moment --processor allows to set both GCC -mcpu flag and QEMU
> > -cpu. On Arm we'd like to pass `-cpu max` to QEMU in order to enable all
> > the TCG features by default, and it could also be nice to let users
> > modify the CPU capabilities by setting extra -cpu options.
> > Since GCC -mcpu doesn't accept "max" or "host", separate the compiler
> > and QEMU arguments.
> > 
> > `--processor` is now exclusively for compiler options, as indicated by
> > its documentation ("processor to compile for"). So use $QEMU_CPU on
> > RISC-V as well.
> > 
> > Suggested-by: Andrew Jones <andrew.jones@linux.dev>
> > Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > ---
> >  scripts/mkstandalone.sh |  2 +-
> >  arm/run                 | 17 +++++++++++------
> >  riscv/run               |  8 ++++----
> >  configure               |  7 +++++++
> >  4 files changed, 23 insertions(+), 11 deletions(-)
> > 
> > diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> > index 2318a85f..6b5f725d 100755
> > --- a/scripts/mkstandalone.sh
> > +++ b/scripts/mkstandalone.sh
> > @@ -42,7 +42,7 @@ generate_test ()
> >  
> >  	config_export ARCH
> >  	config_export ARCH_NAME
> > -	config_export PROCESSOR
> > +	config_export QEMU_CPU
> >  
> >  	echo "echo BUILD_HEAD=$(cat build-head)"
> >  
> > diff --git a/arm/run b/arm/run
> > index efdd44ce..561bafab 100755
> > --- a/arm/run
> > +++ b/arm/run
> > @@ -8,7 +8,7 @@ if [ -z "$KUT_STANDALONE" ]; then
> >  	source config.mak
> >  	source scripts/arch-run.bash
> >  fi
> > -processor="$PROCESSOR"
> > +qemu_cpu="$QEMU_CPU"
> >  
> >  if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
> >     [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
> > @@ -37,12 +37,17 @@ if [ "$ACCEL" = "kvm" ]; then
> >  	fi
> >  fi
> >  
> > -if [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ]; then
> > -	if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
> > -		processor="host"
> > +if [ -z "$qemu_cpu" ]; then
> > +	if ( [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ] ) &&
> > +	   ( [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ] ); then
> > +		qemu_cpu="host"
> >  		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
> > -			processor+=",aarch64=off"
> > +			qemu_cpu+=",aarch64=off"
> >  		fi
> > +	elif [ "$ARCH" = "arm64" ]; then
> > +		qemu_cpu="cortex-a57"
> > +	else
> > +		qemu_cpu="cortex-a15"
> 
> configure could set this in config.mak as DEFAULT_PROCESSOR, avoiding the
> need to duplicate it here.

That was my first instinct too, having the default value in config.mak seemed
like the correct solution.

But the problem with this is that the default -cpu type depends on -accel (set
via unittests.cfg or as an environment variable), host and test architecture
combination. All of these variables are known only at runtime.

Let's say we have DEFAULT_QEMU_CPU=cortex-a57 in config.mak. If we keep the
above heuristic, arm/run will override it with host,aarch64=off. IMO, having it
in config.mak, but arm/run using it only under certain conditions is worse than
not having it at all. arm/run choosing the default value **all the time** is at
least consistent.

We could modify the help text for --qemu-cpu to say something like "If left
unset, the $ARCH/run script will choose a best value based on the host system
and test configuration."

Thanks,
Alex

> 
> >  	fi
> >  fi
> >  
> > @@ -71,7 +76,7 @@ if $qemu $M -device '?' | grep -q pci-testdev; then
> >  fi
> >  
> >  A="-accel $ACCEL$ACCEL_PROPS"
> > -command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
> > +command="$qemu -nodefaults $M $A -cpu $qemu_cpu $chr_testdev $pci_testdev"
> >  command+=" -display none -serial stdio"
> >  command="$(migration_cmd) $(timeout_cmd) $command"
> >  
> > diff --git a/riscv/run b/riscv/run
> > index e2f5a922..02fcf0c0 100755
> > --- a/riscv/run
> > +++ b/riscv/run
> > @@ -11,12 +11,12 @@ fi
> >  
> >  # Allow user overrides of some config.mak variables
> >  mach=$MACHINE_OVERRIDE
> > -processor=$PROCESSOR_OVERRIDE
> > +qemu_cpu=$QEMU_CPU_OVERRIDE
> >  firmware=$FIRMWARE_OVERRIDE
> >  
> > -[ "$PROCESSOR" = "$ARCH" ] && PROCESSOR="max"
> > +[ -z "$QEMU_CPU" ] && QEMU_CPU="max"
> >  : "${mach:=virt}"
> > -: "${processor:=$PROCESSOR}"
> > +: "${qemu_cpu:=$QEMU_CPU}"
> >  : "${firmware:=$FIRMWARE}"
> >  [ "$firmware" ] && firmware="-bios $firmware"
> >  
> > @@ -32,7 +32,7 @@ fi
> >  mach="-machine $mach"
> >  
> >  command="$qemu -nodefaults -nographic -serial mon:stdio"
> > -command+=" $mach $acc $firmware -cpu $processor "
> > +command+=" $mach $acc $firmware -cpu $qemu_cpu "
> >  command="$(migration_cmd) $(timeout_cmd) $command"
> >  
> >  if [ "$UEFI_SHELL_RUN" = "y" ]; then
> > diff --git a/configure b/configure
> > index 5306bad3..d25bd23e 100755
> > --- a/configure
> > +++ b/configure
> > @@ -52,6 +52,7 @@ page_size=
> >  earlycon=
> >  efi=
> >  efi_direct=
> > +qemu_cpu=
> >  
> >  # Enable -Werror by default for git repositories only (i.e. developer builds)
> >  if [ -e "$srcdir"/.git ]; then
> > @@ -69,6 +70,8 @@ usage() {
> >  	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
> >  	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
> >  	    --processor=PROCESSOR  processor to compile for ($processor)
> > +	    --qemu-cpu=CPU         the CPU model to run on. The default depends on
> > +	                           the configuration, usually it is "host" or "max".
> >  	    --target=TARGET        target platform that the tests will be running on (qemu or
> >  	                           kvmtool, default is qemu) (arm/arm64 only)
> >  	    --cross-prefix=PREFIX  cross compiler prefix
> > @@ -142,6 +145,9 @@ while [[ $optno -le $argc ]]; do
> >          --processor)
> >  	    processor="$arg"
> >  	    ;;
> > +	--qemu-cpu)
> > +	    qemu_cpu="$arg"
> > +	    ;;
> >  	--target)
> >  	    target="$arg"
> >  	    ;;
> > @@ -464,6 +470,7 @@ ARCH=$arch
> >  ARCH_NAME=$arch_name
> >  ARCH_LIBDIR=$arch_libdir
> >  PROCESSOR=$processor
> > +QEMU_CPU=$qemu_cpu
> >  CC=$cc
> >  CFLAGS=$cflags
> >  LD=$cross_prefix$ld
> > -- 
> > 2.48.1
> >
> 
> With the Alex's and Eric's requested changes to the help text,
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

