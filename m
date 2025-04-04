Return-Path: <kvm+bounces-42651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25938A7BE4A
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 15:50:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A7281898F06
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 13:50:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F7461F12E8;
	Fri,  4 Apr 2025 13:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="USi10D+n"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885101EE7B1;
	Fri,  4 Apr 2025 13:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743774587; cv=none; b=YnIbFiUWRnno4nUWaeuQARUTk5BUiP6bTUqQjSs8UYSoCFl8HND+QIEsIXEzMcICjgyj/FUGEV6of1EYfoBKh5SH8QE8rsulBPcsl1Ejy56Dn3K7iioccT6yS9ouwtwslVDM8ZIpqV/Hpsxss/75onMkZQtnfNiOzfnH7zemdpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743774587; c=relaxed/simple;
	bh=InZ0uos7yT9Kf1hkWBsUYLcrp43412OOZl/bw7DO4Uw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s96M4KrC64Vco9R1GnQka/0yUFW4lJcJRJ7l9XubQCQGHC0s1xlC/bG4ktNYOBb/LogqNTfYRvWcmSegS04rFbO12+3V/6fTg9uCqwGt8Ht/gLnCXoe93+Yz8gZZwHnf9ddTRlT+7DKN4q9V82Mfw4+i3huUJdYxSF5ZVbLlztU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=USi10D+n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E89C4CEDD;
	Fri,  4 Apr 2025 13:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743774586;
	bh=InZ0uos7yT9Kf1hkWBsUYLcrp43412OOZl/bw7DO4Uw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=USi10D+naSHmsOpLEbclvvoUV8OCZArB3n9xpGD99on1UMZaLkaUh+brOpqRUHjUM
	 z0XibKT/P/RSxfymt/L40cXSF8H9LKoNMf1OFTMr2U3NQCMAR2Ux6Hm3enCUZmWiNX
	 3VMeGo/FM5zIrC468kOaLBCkZyOEsCxCJ1pPuSBWPFOVfilk0ZeJkRltCqUO5YRa0R
	 4uhZNjLKNaCACgVmbORjBmkJlsqgdEBlTEA1QHIUiVg/sY8PhuaW1352AymUDAS/jD
	 TIwikh2QEHHjedoxXiB3TpY2lpVaofO50dMmp1j9XakRekMytpGDUvOeLbL8RA9l7S
	 F9qLsRuerEHMw==
Date: Fri, 4 Apr 2025 14:49:38 +0100
From: Will Deacon <will@kernel.org>
To: Atish Patra <atishp@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>, weilin.wang@intel.com,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	Conor Dooley <conor@kernel.org>, devicetree@vger.kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	=?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>
Subject: Re: [PATCH v5 11/21] RISC-V: perf: Restructure the SBI PMU code
Message-ID: <20250404134937.GA29394@willie-the-truck>
References: <20250327-counter_delegation-v5-0-1ee538468d1b@rivosinc.com>
 <20250327-counter_delegation-v5-11-1ee538468d1b@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250327-counter_delegation-v5-11-1ee538468d1b@rivosinc.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Mar 27, 2025 at 12:35:52PM -0700, Atish Patra wrote:
> With Ssccfg/Smcdeleg, we no longer need SBI PMU extension to program/
> access hpmcounter/events. However, we do need it for firmware counters.
> Rename the driver and its related code to represent generic name
> that will handle both sbi and ISA mechanism for hpmcounter related
> operations. Take this opportunity to update the Kconfig names to
> match the new driver name closely.
> 
> No functional change intended.
> 
> Reviewed-by: Clément Léger <cleger@rivosinc.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  MAINTAINERS                                       |   4 +-
>  arch/riscv/include/asm/kvm_vcpu_pmu.h             |   4 +-
>  arch/riscv/include/asm/kvm_vcpu_sbi.h             |   2 +-
>  arch/riscv/kvm/Makefile                           |   4 +-
>  arch/riscv/kvm/vcpu_sbi.c                         |   2 +-
>  drivers/perf/Kconfig                              |  16 +-
>  drivers/perf/Makefile                             |   4 +-
>  drivers/perf/{riscv_pmu.c => riscv_pmu_common.c}  |   0
>  drivers/perf/{riscv_pmu_sbi.c => riscv_pmu_dev.c} | 214 +++++++++++++---------

I'm still against this renaming churn. It sucks for backporting and
you're also changing the name of the driver, which could be used by
scripts in userspace (e.g. module listings, udev rules, cmdline options)

Will

