Return-Path: <kvm+bounces-49697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 95DEDADCBE6
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 14:50:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3F1F7AB1CD
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 12:48:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 541942E06DE;
	Tue, 17 Jun 2025 12:49:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CA3E2DBF47
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 12:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750164579; cv=none; b=iTC4NNQw460vMxw8F9QqkmUydnkhpTslT+XKP8Cb4tv3OyPZeLZiQqGA3xJfJR531gOtwoU1/ePfgOIC7jUINGGIN+HT7WVr6w3lJlb7WtBXdLYqUZvUUWUr1jX2xI7v9oALzH1Cp376wZbIdYbOJjgNWvu9EJcGC1V0W/4Isvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750164579; c=relaxed/simple;
	bh=imEetcTRPsXXLXqOXUC7u4cjKKD+hALiTz3xfb/29sU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nZ2TUqJt+fpkPGeIz2DAgnE7q2oarnF82kyKTbJHM7TcniXCwp2/63TXfWAeKs9MaYA0Z4mhbxIWfaY3QrzNViRsXqVwI27Y5mBKlCEpZ6rc/hdx2yBDLoQ4HXM5EI46OnP2s0GgmCSQ1hi+kY8+TJ2Jmw8/LsZwo4c7xCWvhhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E1977150C;
	Tue, 17 Jun 2025 05:49:14 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C66F83F58B;
	Tue, 17 Jun 2025 05:49:34 -0700 (PDT)
Date: Tue, 17 Jun 2025 13:49:29 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v2 0/9] arm64: support EL2
Message-ID: <20250617124929.GA2576881@e124191.cambridge.arm.com>
References: <20250529135557.2439500-1-joey.gouly@arm.com>
 <aFAPSSHJunx1Ecz2@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFAPSSHJunx1Ecz2@arm.com>

On Mon, Jun 16, 2025 at 01:34:17PM +0100, Alexandru Elisei wrote:
> Hi Joey,
> 
> On Thu, May 29, 2025 at 02:55:48PM +0100, Joey Gouly wrote:
> > Hi all,
> > 
> > This series is for adding support to running the kvm-unit-tests at EL2. These
> > have been tested with Marc Zyngier's Linux kvm-arm64/nv-next branch [1] and
> > kvmtool branch arm64/nv-6.13 [2]
> > 
> > The goal is to later extend and add new tests for Nested Virtualisation,
> > however they should also work with bare metal as well.
> > 
> > Changes since v1[3]:
> > 	- Authorship fixed on 2 patches
> > 	- Tested and fixed EFI support
> > 	- Recactored assembly and added init_el macro
> > 	- Clear trap registers, trying to avoid relying on default register
> > 	  state
> > 	- Cleaned up PMU changes
> > 
> > The debug tests fail with --nested, but pass with --nested --e2h0, I
> > need to investigate this.
> 
> That's because the code does not check for the absence of FEAT_E2H0, and it sets
> HCR_EL2.E2H to 0 when writing INIT_HCR_EL2_EL1_ONLY even if KVM doesn't support
> that.

INIT_HCR_EL2_EL1_ONLY is only used if VHE is not supported, and if VHE is not
supported it's RES0. Patch 9 adds that.

> 
> Have you considered using parts of el2_setup.h as-is instead of rolling out your
> own EL2 init code? When I was looking at the init_el macro I was comparing it
> with el2_setup.h, and having some of the code shared would make things easier
> with updates and fixes too.
> 
> Either way, not a deal breaker if you want to write your own init code.

I'll look into it, making our own simplified el2_setup.h based on Linux's.

Thanks,
Joey

> 
> Thanks,
> Alex
> 
> > 
> > Thanks,
> > Joey
> > 
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/nv-next (commit a35d752b17f4)
> > [2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvmtool.git arm64/nv-6.13 (commit 5b6fe295ea7)
> > [3] https://lore.kernel.org/kvmarm/20250220141354.2565567-1-joey.gouly@arm.com/
> > 
> > Alexandru Elisei (2):
> >   arm64: micro-bench: use smc when at EL2
> >   arm64: selftest: update test for running at EL2
> > 
> > Joey Gouly (7):
> >   arm64: drop to EL1 if booted at EL2
> >   arm64: efi: initialise SCTLR_ELx fully
> >   arm64: efi: initialise the EL
> >   arm64: timer: use hypervisor timers when at EL2
> >   arm64: micro-bench: fix timer IRQ
> >   arm64: pmu: count EL2 cycles
> >   arm64: run at EL2 if supported
> > 
> >  arm/cstart64.S             | 56 ++++++++++++++++++++++++++++++++++++--
> >  arm/efi/crt0-efi-aarch64.S |  5 ++++
> >  arm/micro-bench.c          | 26 ++++++++++++++++--
> >  arm/pmu.c                  | 13 ++++++---
> >  arm/selftest.c             | 18 ++++++++----
> >  arm/timer.c                | 10 +++++--
> >  lib/acpi.h                 |  2 ++
> >  lib/arm/asm/setup.h        |  1 +
> >  lib/arm/asm/timer.h        | 11 ++++++++
> >  lib/arm/setup.c            |  6 ++++
> >  lib/arm/timer.c            | 19 +++++++++++--
> >  lib/arm64/asm/sysreg.h     | 19 +++++++++++++
> >  12 files changed, 167 insertions(+), 19 deletions(-)
> > 
> > -- 
> > 2.25.1
> > 

