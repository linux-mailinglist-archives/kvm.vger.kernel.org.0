Return-Path: <kvm+bounces-37476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59D15A2A651
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 11:51:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0BF43A78D3
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 10:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD8AD227B87;
	Thu,  6 Feb 2025 10:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KdGg+q3X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE79C1F60A;
	Thu,  6 Feb 2025 10:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738839070; cv=none; b=ne7/GBkaIA7TG7lHsiWBX7y1oUq4mwhRmbnUocm8xygCVNjs4PSWTP92jgkJ9zX/eyCCWEouIqzcaaFHKa1o8rQw3ep1L2aBkCpRUX9Zf2e24YhRgefsROC2hJ5hwxuHBsfuW5W2Og3v6drvQKrpzJZYgTo9zoTIYw+z/i4L5/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738839070; c=relaxed/simple;
	bh=BAc/DzaeLywP5/G7nSsTgMS/1oP0U4tjnQ8klgx+HLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U19E+iGfQl0IaTp4EspgeJAAOKUtIAOp/3YBMvojbmwloggZDqBfb7LKOyq8vq0R4soGuSrlVh2ugKaJlMsokfgt/iIM2xkl9QIkoRJNerZUpWoE+Cbix7TuPLG/K3CXU0F10Oi1aP/4UP5w016eOmEmPonh4TYj7H8G6/mFhpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KdGg+q3X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4F4C4CEDD;
	Thu,  6 Feb 2025 10:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738839069;
	bh=BAc/DzaeLywP5/G7nSsTgMS/1oP0U4tjnQ8klgx+HLg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KdGg+q3XY0ZrBG5LQlQYmL7B3IpBT4V4qnZ7GHv5wEEx3b7Dr57ydkhDbFb5j3mwX
	 tg6DhXoiHPjM0CDTr4gCjDdh+sIAUu9zc5Nb8aUXhAbZAAWpxn1f4d1qUkv05VWWUn
	 MneCpfPJ3pH1tjVEASi7nDe6fkdz9Obkl4r9LiIsI7tfP7Z+NQevktY8zUigTG59uK
	 KZMsb5jop8HVBJLbc90MuAsOc/c7QzCIkoJgEw/kYWfbjiPVyvo8rXLZsoPh16TSnO
	 uX8D2NeK/SC0qI1AYpMoWVcpAfQgz+V9T1c2h+ONYXCc8e49/Ju7BrjtZHhbNX0Xsv
	 mObGH9QVWJ9vw==
Date: Thu, 6 Feb 2025 10:51:01 +0000
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
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v4 11/21] RISC-V: perf: Restructure the SBI PMU code
Message-ID: <20250206105100.GA2971@willie-the-truck>
References: <20250205-counter_delegation-v4-0-835cfa88e3b1@rivosinc.com>
 <20250205-counter_delegation-v4-11-835cfa88e3b1@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205-counter_delegation-v4-11-835cfa88e3b1@rivosinc.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Feb 05, 2025 at 11:23:16PM -0800, Atish Patra wrote:
> With Ssccfg/Smcdeleg, we no longer need SBI PMU extension to program/
> access hpmcounter/events. However, we do need it for firmware counters.
> Rename the driver and its related code to represent generic name
> that will handle both sbi and ISA mechanism for hpmcounter related
> operations. Take this opportunity to update the Kconfig names to
> match the new driver name closely.
> 
> No functional change intended.
> 
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

This seems... gratuitous? It feels like renaming the file could be a pain
for managing backports and renaming the driver might cause some headaches
in userspace.

What do you gain from such an invasive change?

Will

