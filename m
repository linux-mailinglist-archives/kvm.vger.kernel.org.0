Return-Path: <kvm+bounces-63709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D0B0C6EE4E
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 14:30:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 00E7E348B82
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 13:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03956357A5B;
	Wed, 19 Nov 2025 13:18:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C66B33C19E
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 13:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763558316; cv=none; b=Nmcej/EcrjpIKEv6ny7tqRiCe8VRJikxBUqRXeOS7rLGBHPPUtqaQ+4fdVLqYP9hrYqdAV8OhvTsccJdQ8nKv4daPvJtKzGUbuu8rL3/QJVrsBFrbwABgzPSGeZAoyUBoxejbZfxigKptAhN6wUL0/838NVGo3plbpxCNw/lxYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763558316; c=relaxed/simple;
	bh=/90S5s8jyey4VwZIkypzcuJWPsahhBY1HGVUTboMpLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iElI0pfHpIW9Q70hCy+agIX3+TpZ/i3M6hdpK6Ro/HqlCe3F25Bi6v8x6uTLRrdk+De1xW5XX5OHWlAX4UIM+w0Hw3ZDgUPeW+P4FVs6KdiZLLDzB826bunxSfXVJ/LMj18/SdQj1AQlaqBKsZly2s0CJHp1HZikZktUP0kfN80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C53AFFEC;
	Wed, 19 Nov 2025 05:18:25 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 43DE73F66E;
	Wed, 19 Nov 2025 05:18:32 -0800 (PST)
Date: Wed, 19 Nov 2025 13:18:27 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev,
	kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm64: EL2 support
Message-ID: <20251119131827.GA2206028@e124191.cambridge.arm.com>
References: <20250925141958.468311-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925141958.468311-1-joey.gouly@arm.com>

On Thu, Sep 25, 2025 at 03:19:48PM +0100, Joey Gouly wrote:
> Hi all,
> 
> This series is for adding support to running the kvm-unit-tests at EL2. These
> have been tested with Linux 6.17-rc6 KVM nested virt.
> 
> This latest round I also tested using the run_tests.sh script with QEMU TCG,
> running at EL2.
> 
> The goal is to later extend and add new tests for Nested Virtualisation,
> however they should also work with bare metal as well.

Any comments on this series, would be nice to get it merged.

Thanks,
Joey

> 
> Changes since v2[1]:
> 	- Move the sctlr setup in EFI to a function.
> 	- Decided to not re-use el2_setup.h from Linux, looked more
> 	  complicated to use than needed for KUT.
> 	- Add EL2 env variable for testing, open to feedback for that.
> 	  This was untested with kvmtool as my testing setup only has
> 	  busybox ash currently, and the run_tests.sh script needs bash.
> 
> Issues (that I think are fine to investigate/fix later):
> 	- Some of the debug tests fail with QEMU at EL2 and kvmtool.
> 	- The gic ipi test times out with QEMU at EL2, but works with kvmtool.
> 
> Thanks,
> Joey
> 
> [1] https://lore.kernel.org/kvmarm/20250529135557.2439500-1-joey.gouly@arm.com/
> 
> Alexandru Elisei (2):
>   arm64: micro-bench: use smc when at EL2
>   arm64: selftest: update test for running at EL2
> 
> Joey Gouly (8):
>   arm64: drop to EL1 if booted at EL2
>   arm64: efi: initialise SCTLR_ELx fully
>   arm64: efi: initialise the EL
>   arm64: timer: use hypervisor timers when at EL2
>   arm64: micro-bench: fix timer IRQ
>   arm64: pmu: count EL2 cycles
>   arm64: run at EL2 if supported
>   arm64: add EL2 environment variable
> 
>  arm/cstart64.S             | 56 ++++++++++++++++++++++++++++++++++++--
>  arm/efi/crt0-efi-aarch64.S |  5 ++++
>  arm/micro-bench.c          | 26 ++++++++++++++++--
>  arm/pmu.c                  | 13 ++++++---
>  arm/run                    |  7 +++++
>  arm/selftest.c             | 18 ++++++++----
>  arm/timer.c                | 10 +++++--
>  lib/acpi.h                 |  2 ++
>  lib/arm/asm/setup.h        |  8 ++++++
>  lib/arm/asm/timer.h        | 11 ++++++++
>  lib/arm/setup.c            |  4 +++
>  lib/arm/timer.c            | 19 +++++++++++--
>  lib/arm64/asm/sysreg.h     | 19 +++++++++++++
>  lib/arm64/processor.c      | 12 ++++++++
>  14 files changed, 191 insertions(+), 19 deletions(-)
> 
> -- 
> 2.25.1
> 

