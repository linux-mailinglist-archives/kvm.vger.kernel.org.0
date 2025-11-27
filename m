Return-Path: <kvm+bounces-64864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93B2EC8DE6A
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 12:08:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 931243AFD1F
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 11:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0674832B990;
	Thu, 27 Nov 2025 11:08:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4F2332AADA
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 11:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764241722; cv=none; b=VzKI6/lBBrSi6NLOKHp/nmr8O7GF0N6JkvCERczjsF5cOrCTUcTDtoK3EE3P1N3md4rbfcI5dKJolbP64iQtx4Tow7HACT8chLaz+NA7Y0CY0B8NjjDATytZxHxCJA/Ukv1uhxfe1ToVS7dmW1hyu8r8XbSO9KKYlo/3IrNQ3NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764241722; c=relaxed/simple;
	bh=sgv0ngZl3R0UBBCOfD0Wy5vgMgcm8qI+c3ByDO7gkVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y3wnhXdxwzQqr4z+GTZ7dPZvKEBsZ5j315lWrIEzTxxC0uj35zJ9KoYLMCa9wGT+LEuUoPJUqpi72kkb1xYCTBgN878JL1nhvE0BO5XM4b6rSDXnx6IXVrTC/vpPV7Xx2KsgJPS7c2HtVr4NUG9MD72sJOo5Bg1qDG4iZqOMauA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BCB31477;
	Thu, 27 Nov 2025 03:08:32 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B35F43F66E;
	Thu, 27 Nov 2025 03:08:38 -0800 (PST)
Date: Thu, 27 Nov 2025 11:08:32 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, andrew.jones@linux.dev,
	kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm64: EL2 support
Message-ID: <20251127110832.GA3240191@e124191.cambridge.arm.com>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <44fac47f-1df1-4119-8bf0-1db96cda18ef@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44fac47f-1df1-4119-8bf0-1db96cda18ef@redhat.com>

On Thu, Nov 27, 2025 at 11:04:43AM +0100, Eric Auger wrote:
> Hi Joey,
> 
> On 9/25/25 4:19 PM, Joey Gouly wrote:
> > Hi all,
> >
> > This series is for adding support to running the kvm-unit-tests at EL2. These
> > have been tested with Linux 6.17-rc6 KVM nested virt.
> >
> > This latest round I also tested using the run_tests.sh script with QEMU TCG,
> > running at EL2.
> >
> > The goal is to later extend and add new tests for Nested Virtualisation,
> > however they should also work with bare metal as well.
> >
> > Changes since v2[1]:
> > 	- Move the sctlr setup in EFI to a function.
> > 	- Decided to not re-use el2_setup.h from Linux, looked more
> > 	  complicated to use than needed for KUT.
> > 	- Add EL2 env variable for testing, open to feedback for that.
> > 	  This was untested with kvmtool as my testing setup only has
> > 	  busybox ash currently, and the run_tests.sh script needs bash.
> >
> > Issues (that I think are fine to investigate/fix later):
> > 	- Some of the debug tests fail with QEMU at EL2 and kvmtool.
> > 	- The gic ipi test times out with QEMU at EL2, but works with kvmtool.
> 
> Have you noticed any failure with migration tests. On my end, as soon as
> I set EL2=1 migration tests do fail.

Yes migration also fails here, forgot to mention that.

Seems like migration completes, but then something bad happens on the first
interrupt. I will investigate a bit now and see if it's an easy fix.

Thanks,
Joey

> 
> Eric
> >
> > Thanks,
> > Joey
> >
> > [1] https://lore.kernel.org/kvmarm/20250529135557.2439500-1-joey.gouly@arm.com/
> >
> > Alexandru Elisei (2):
> >   arm64: micro-bench: use smc when at EL2
> >   arm64: selftest: update test for running at EL2
> >
> > Joey Gouly (8):
> >   arm64: drop to EL1 if booted at EL2
> >   arm64: efi: initialise SCTLR_ELx fully
> >   arm64: efi: initialise the EL
> >   arm64: timer: use hypervisor timers when at EL2
> >   arm64: micro-bench: fix timer IRQ
> >   arm64: pmu: count EL2 cycles
> >   arm64: run at EL2 if supported
> >   arm64: add EL2 environment variable
> >
> >  arm/cstart64.S             | 56 ++++++++++++++++++++++++++++++++++++--
> >  arm/efi/crt0-efi-aarch64.S |  5 ++++
> >  arm/micro-bench.c          | 26 ++++++++++++++++--
> >  arm/pmu.c                  | 13 ++++++---
> >  arm/run                    |  7 +++++
> >  arm/selftest.c             | 18 ++++++++----
> >  arm/timer.c                | 10 +++++--
> >  lib/acpi.h                 |  2 ++
> >  lib/arm/asm/setup.h        |  8 ++++++
> >  lib/arm/asm/timer.h        | 11 ++++++++
> >  lib/arm/setup.c            |  4 +++
> >  lib/arm/timer.c            | 19 +++++++++++--
> >  lib/arm64/asm/sysreg.h     | 19 +++++++++++++
> >  lib/arm64/processor.c      | 12 ++++++++
> >  14 files changed, 191 insertions(+), 19 deletions(-)
> >
> 

