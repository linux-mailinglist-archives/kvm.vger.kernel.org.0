Return-Path: <kvm+bounces-64880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 090E2C8EEBC
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 15:55:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 177F74EE5CF
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 14:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F03FA332EC0;
	Thu, 27 Nov 2025 14:52:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F62312838
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 14:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255136; cv=none; b=RRKuLA9ThiW+BIMlg5QADzTiKsICKLUgBV0RRU/mxKsssPywtZMpbvYTRSemA4B9wEwEmFHGLeaPjWkGPw+xVugAfuc+k5H/2A5QKgQNg9xqD4Z4qH1dTXtXK89ufv8Pw1KeQPOWPaNcR9fCTT/ir3AVbg803ZMBcuxVAyrnyCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255136; c=relaxed/simple;
	bh=AUUmYjlpz1+SSjEFdJCci6iQPPtM3JeZzyRpDsyrjUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j9QA6JlyUCwVQCalrRCSRpfheg7IbXnDgWaocLVmdCb0SACfHom4aAWrBK48KTQuxYywUSnVssvbWELRaPXb7CFSiyASgYWIn8jlP/5Dm+m2L0+xLJp7PC2xvu4BITclSXY2MbaZvabWvDthFR6SvXWRw6Eym4vlaAkYzeO9plc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B15B91063;
	Thu, 27 Nov 2025 06:52:06 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D52693F66E;
	Thu, 27 Nov 2025 06:52:12 -0800 (PST)
Date: Thu, 27 Nov 2025 14:52:07 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, andrew.jones@linux.dev,
	kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm64: EL2 support
Message-ID: <20251127145207.GA3265987@e124191.cambridge.arm.com>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <44fac47f-1df1-4119-8bf0-1db96cda18ef@redhat.com>
 <20251127110832.GA3240191@e124191.cambridge.arm.com>
 <3a39738e-ed33-49fa-9f1c-0bbba6979038@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a39738e-ed33-49fa-9f1c-0bbba6979038@redhat.com>

On Thu, Nov 27, 2025 at 01:04:08PM +0100, Eric Auger wrote:
> Hi Joey,
> 
> On 11/27/25 12:08 PM, Joey Gouly wrote:
> > On Thu, Nov 27, 2025 at 11:04:43AM +0100, Eric Auger wrote:
> >> Hi Joey,
> >>
> >> On 9/25/25 4:19 PM, Joey Gouly wrote:
> >>> Hi all,
> >>>
> >>> This series is for adding support to running the kvm-unit-tests at EL2. These
> >>> have been tested with Linux 6.17-rc6 KVM nested virt.
> >>>
> >>> This latest round I also tested using the run_tests.sh script with QEMU TCG,
> >>> running at EL2.
> >>>
> >>> The goal is to later extend and add new tests for Nested Virtualisation,
> >>> however they should also work with bare metal as well.
> >>>
> >>> Changes since v2[1]:
> >>> 	- Move the sctlr setup in EFI to a function.
> >>> 	- Decided to not re-use el2_setup.h from Linux, looked more
> >>> 	  complicated to use than needed for KUT.
> >>> 	- Add EL2 env variable for testing, open to feedback for that.
> >>> 	  This was untested with kvmtool as my testing setup only has
> >>> 	  busybox ash currently, and the run_tests.sh script needs bash.
> >>>
> >>> Issues (that I think are fine to investigate/fix later):
> >>> 	- Some of the debug tests fail with QEMU at EL2 and kvmtool.
> >>> 	- The gic ipi test times out with QEMU at EL2, but works with kvmtool.
> >> Have you noticed any failure with migration tests. On my end, as soon as
> >> I set EL2=1 migration tests do fail.
> > Yes migration also fails here, forgot to mention that.
> >
> > Seems like migration completes, but then something bad happens on the first
> > interrupt. I will investigate a bit now and see if it's an easy fix.
> 
> while you do that I will go through the series. My apologies for the delay

Thanks!

I found the issue, and I thought it was one I had solved before, but maybe I lost the fix somehow:

diff --git a/arm/cstart64.S b/arm/cstart64.S
index af7c81c1..fd8b6690 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -235,6 +235,11 @@ get_mmu_off:
 .globl secondary_entry
 secondary_entry:
        init_el x0
+
+       /* set SCTLR_EL1 to a known value */
+       ldr     x4, =INIT_SCTLR_EL1_MMU_OFF
+       msr     sctlr_el1, x4
+       isb
+
        /* enable FP/ASIMD and SVE */
        mov     x0, #(3 << 20)
        orr     x0, x0, #(3 << 16)

The secondary core code doesn't fully initialise SCTLR_ELx, which means that
SCTLR_ELx.SPAN=0. That's why there was a data abort after the IRQ.

This doesn't affect EL1 (only) because KVM has a different reset value for
SCTLR_EL1 and SCTLR_EL2.

I will send out a new version with this fix, missing sob/reviews/acks, after you've had a look!

Thanks,
Joey

> 
> Eric
> >
> > Thanks,
> > Joey
> >
> >> Eric
> >>> Thanks,
> >>> Joey
> >>>
> >>> [1] https://lore.kernel.org/kvmarm/20250529135557.2439500-1-joey.gouly@arm.com/
> >>>
> >>> Alexandru Elisei (2):
> >>>   arm64: micro-bench: use smc when at EL2
> >>>   arm64: selftest: update test for running at EL2
> >>>
> >>> Joey Gouly (8):
> >>>   arm64: drop to EL1 if booted at EL2
> >>>   arm64: efi: initialise SCTLR_ELx fully
> >>>   arm64: efi: initialise the EL
> >>>   arm64: timer: use hypervisor timers when at EL2
> >>>   arm64: micro-bench: fix timer IRQ
> >>>   arm64: pmu: count EL2 cycles
> >>>   arm64: run at EL2 if supported
> >>>   arm64: add EL2 environment variable
> >>>
> >>>  arm/cstart64.S             | 56 ++++++++++++++++++++++++++++++++++++--
> >>>  arm/efi/crt0-efi-aarch64.S |  5 ++++
> >>>  arm/micro-bench.c          | 26 ++++++++++++++++--
> >>>  arm/pmu.c                  | 13 ++++++---
> >>>  arm/run                    |  7 +++++
> >>>  arm/selftest.c             | 18 ++++++++----
> >>>  arm/timer.c                | 10 +++++--
> >>>  lib/acpi.h                 |  2 ++
> >>>  lib/arm/asm/setup.h        |  8 ++++++
> >>>  lib/arm/asm/timer.h        | 11 ++++++++
> >>>  lib/arm/setup.c            |  4 +++
> >>>  lib/arm/timer.c            | 19 +++++++++++--
> >>>  lib/arm64/asm/sysreg.h     | 19 +++++++++++++
> >>>  lib/arm64/processor.c      | 12 ++++++++
> >>>  14 files changed, 191 insertions(+), 19 deletions(-)
> >>>
> 

