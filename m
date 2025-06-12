Return-Path: <kvm+bounces-49255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 212E4AD6D8E
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 12:24:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE23A3B04B4
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 10:23:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78B541F8753;
	Thu, 12 Jun 2025 10:24:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC5822E3FC;
	Thu, 12 Jun 2025 10:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749723855; cv=none; b=Fz2RWT7pmr4FmkAUkHSzgCLBkDKv2SyaF2ECXn2Q//By/A4KNXba285jNDC/jLcLW4USVwOGXp1EYoVLUa9YT0Qa7yFNcl4v54cEnr+6mHkOpvBS5+wWyseGLzXmPZVG7fsO2oAzLN8ix1M7GZejCGcg07S617Lx8nqMZCu7bzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749723855; c=relaxed/simple;
	bh=EfoxGGZwPx0kqgJcWRywOxMTyMFiOL3+lrM4IfhKDB0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vb/G/qHjFPRPQOX86+E84pTHQSJs+DwgMnnKr38QWcF8xx3iwYQ4U+e+uE6/UU95vE4QQdV6r76q1saMR0CwVbQjrHq8iUN1x8lgF4HhsNtTga1w/ozrwWbIAj1Ux88YXJgEi/h1KKjgc41GFUv8pbFWcAk9voUJs7mWnNakiJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34AA51424;
	Thu, 12 Jun 2025 03:23:51 -0700 (PDT)
Received: from [10.163.33.129] (unknown [10.163.33.129])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7033F3F59E;
	Thu, 12 Jun 2025 03:24:07 -0700 (PDT)
Message-ID: <ddc006af-3084-4fef-b822-144fb404bc8d@arm.com>
Date: Thu, 12 Jun 2025 15:54:04 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 1/2] arm64/debug: Drop redundant DBG_MDSCR_* macros
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Ada Couprie Diaz <ada.coupriediaz@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <20250612033547.480952-1-anshuman.khandual@arm.com>
 <20250612033547.480952-2-anshuman.khandual@arm.com>
 <86wm9hcr14.wl-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <86wm9hcr14.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 12/06/25 1:47 PM, Marc Zyngier wrote:
> On Thu, 12 Jun 2025 04:35:46 +0100,
> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
>>
>> MDSCR_EL1 has already been defined in tools sysreg format and hence can be
>> used in all debug monitor related call paths. But using generated sysreg
>> definitions causes build warnings because there is a mismatch between mdscr
>> variable (u32) and GENMASK() based masks (long unsigned int). Convert all
>> variables handling MDSCR_EL1 register as u64 which also reflects its true
>> width as well.
>>
>> --------------------------------------------------------------------------
>> arch/arm64/kernel/debug-monitors.c: In function ‘disable_debug_monitors’:
>> arch/arm64/kernel/debug-monitors.c:108:13: warning: conversion from ‘long
>> unsigned int’ to ‘u32’ {aka ‘unsigned int’} changes value from
>> ‘18446744073709518847’ to ‘4294934527’ [-Woverflow]
>>   108 |   disable = ~MDSCR_EL1_MDE;
>>       |             ^
>> --------------------------------------------------------------------------
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/include/asm/assembler.h      |  4 ++--
>>  arch/arm64/include/asm/debug-monitors.h |  6 ------
>>  arch/arm64/kernel/debug-monitors.c      | 22 +++++++++++-----------
>>  arch/arm64/kernel/entry-common.c        |  4 ++--
>>  4 files changed, 15 insertions(+), 21 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
>> index ad63457a05c5..f229d96616e5 100644
>> --- a/arch/arm64/include/asm/assembler.h
>> +++ b/arch/arm64/include/asm/assembler.h
>> @@ -53,7 +53,7 @@
>>  	.macro	disable_step_tsk, flgs, tmp
>>  	tbz	\flgs, #TIF_SINGLESTEP, 9990f
>>  	mrs	\tmp, mdscr_el1
>> -	bic	\tmp, \tmp, #DBG_MDSCR_SS
>> +	bic	\tmp, \tmp, #MDSCR_EL1_SS
>>  	msr	mdscr_el1, \tmp
>>  	isb	// Take effect before a subsequent clear of DAIF.D
>>  9990:
>> @@ -63,7 +63,7 @@
>>  	.macro	enable_step_tsk, flgs, tmp
>>  	tbz	\flgs, #TIF_SINGLESTEP, 9990f
>>  	mrs	\tmp, mdscr_el1
>> -	orr	\tmp, \tmp, #DBG_MDSCR_SS
>> +	orr	\tmp, \tmp, #MDSCR_EL1_SS
>>  	msr	mdscr_el1, \tmp
>>  9990:
>>  	.endm
>> diff --git a/arch/arm64/include/asm/debug-monitors.h b/arch/arm64/include/asm/debug-monitors.h
>> index 8f6ba31b8658..1f37dd01482b 100644
>> --- a/arch/arm64/include/asm/debug-monitors.h
>> +++ b/arch/arm64/include/asm/debug-monitors.h
>> @@ -13,14 +13,8 @@
>>  #include <asm/ptrace.h>
>>  
>>  /* Low-level stepping controls. */
>> -#define DBG_MDSCR_SS		(1 << 0)
>>  #define DBG_SPSR_SS		(1 << 21)
>>  
>> -/* MDSCR_EL1 enabling bits */
>> -#define DBG_MDSCR_KDE		(1 << 13)
>> -#define DBG_MDSCR_MDE		(1 << 15)
>> -#define DBG_MDSCR_MASK		~(DBG_MDSCR_KDE | DBG_MDSCR_MDE)
>> -
>>  #define	DBG_ESR_EVT(x)		(((x) >> 27) & 0x7)
>>  
>>  /* AArch64 */
>> diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
>> index 58f047de3e1c..08f1d02507cd 100644
>> --- a/arch/arm64/kernel/debug-monitors.c
>> +++ b/arch/arm64/kernel/debug-monitors.c
>> @@ -34,7 +34,7 @@ u8 debug_monitors_arch(void)
>>  /*
>>   * MDSCR access routines.
>>   */
>> -static void mdscr_write(u32 mdscr)
>> +static void mdscr_write(u64 mdscr)
>>  {
>>  	unsigned long flags;
>>  	flags = local_daif_save();
>> @@ -43,7 +43,7 @@ static void mdscr_write(u32 mdscr)
>>  }
>>  NOKPROBE_SYMBOL(mdscr_write);
>>  
>> -static u32 mdscr_read(void)
>> +static u64 mdscr_read(void)
>>  {
>>  	return read_sysreg(mdscr_el1);
>>  }
>> @@ -79,16 +79,16 @@ static DEFINE_PER_CPU(int, kde_ref_count);
>>  
>>  void enable_debug_monitors(enum dbg_active_el el)
>>  {
>> -	u32 mdscr, enable = 0;
>> +	u64 mdscr, enable = 0;
>>  
>>  	WARN_ON(preemptible());
>>  
>>  	if (this_cpu_inc_return(mde_ref_count) == 1)
>> -		enable = DBG_MDSCR_MDE;
>> +		enable = MDSCR_EL1_MDE;
>>  
>>  	if (el == DBG_ACTIVE_EL1 &&
>>  	    this_cpu_inc_return(kde_ref_count) == 1)
>> -		enable |= DBG_MDSCR_KDE;
>> +		enable |= MDSCR_EL1_KDE;
>>  
>>  	if (enable && debug_enabled) {
>>  		mdscr = mdscr_read();
>> @@ -100,16 +100,16 @@ NOKPROBE_SYMBOL(enable_debug_monitors);
>>  
>>  void disable_debug_monitors(enum dbg_active_el el)
>>  {
>> -	u32 mdscr, disable = 0;
>> +	u64 mdscr, disable = 0;
>>  
>>  	WARN_ON(preemptible());
>>  
>>  	if (this_cpu_dec_return(mde_ref_count) == 0)
>> -		disable = ~DBG_MDSCR_MDE;
>> +		disable = ~MDSCR_EL1_MDE;
>>  
>>  	if (el == DBG_ACTIVE_EL1 &&
>>  	    this_cpu_dec_return(kde_ref_count) == 0)
>> -		disable &= ~DBG_MDSCR_KDE;
>> +		disable &= ~MDSCR_EL1_KDE;
>>  
>>  	if (disable) {
>>  		mdscr = mdscr_read();
>> @@ -415,7 +415,7 @@ void kernel_enable_single_step(struct pt_regs *regs)
>>  {
>>  	WARN_ON(!irqs_disabled());
>>  	set_regs_spsr_ss(regs);
>> -	mdscr_write(mdscr_read() | DBG_MDSCR_SS);
>> +	mdscr_write(mdscr_read() | MDSCR_EL1_SS);
>>  	enable_debug_monitors(DBG_ACTIVE_EL1);
>>  }
>>  NOKPROBE_SYMBOL(kernel_enable_single_step);
>> @@ -423,7 +423,7 @@ NOKPROBE_SYMBOL(kernel_enable_single_step);
>>  void kernel_disable_single_step(void)
>>  {
>>  	WARN_ON(!irqs_disabled());
>> -	mdscr_write(mdscr_read() & ~DBG_MDSCR_SS);
>> +	mdscr_write(mdscr_read() & ~MDSCR_EL1_SS);
>>  	disable_debug_monitors(DBG_ACTIVE_EL1);
>>  }
>>  NOKPROBE_SYMBOL(kernel_disable_single_step);
>> @@ -431,7 +431,7 @@ NOKPROBE_SYMBOL(kernel_disable_single_step);
>>  int kernel_active_single_step(void)
>>  {
>>  	WARN_ON(!irqs_disabled());
>> -	return mdscr_read() & DBG_MDSCR_SS;
>> +	return mdscr_read() & MDSCR_EL1_SS;
>>  }
>>  NOKPROBE_SYMBOL(kernel_active_single_step);
>>  
>> diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
>> index 7c1970b341b8..171f93f2494b 100644
>> --- a/arch/arm64/kernel/entry-common.c
>> +++ b/arch/arm64/kernel/entry-common.c
>> @@ -344,7 +344,7 @@ static DEFINE_PER_CPU(int, __in_cortex_a76_erratum_1463225_wa);
>>  
>>  static void cortex_a76_erratum_1463225_svc_handler(void)
>>  {
>> -	u32 reg, val;
>> +	u64 reg, val;
>>  
>>  	if (!unlikely(test_thread_flag(TIF_SINGLESTEP)))
>>  		return;
>> @@ -354,7 +354,7 @@ static void cortex_a76_erratum_1463225_svc_handler(void)
>>  
>>  	__this_cpu_write(__in_cortex_a76_erratum_1463225_wa, 1);
>>  	reg = read_sysreg(mdscr_el1);
>> -	val = reg | DBG_MDSCR_SS | DBG_MDSCR_KDE;
>> +	val = reg | MDSCR_EL1_SS | MDSCR_EL1_KDE;
>>  	write_sysreg(val, mdscr_el1);
>>  	asm volatile("msr daifclr, #8");
>>  	isb();
> 
> Whilst you're at it, please also change the open-coded constant in
> __cpu_setup to MDSCR_EL1_TDCC.

I believe you are suggesting about the following change, will fold
in the patch. But I guess 'mov' would still be preferred compared
to 'mov_q' as MDSCR_EL1_TDCC is a 32 bit constant (atleast the non
zero portion) ?

--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -454,7 +454,7 @@ SYM_FUNC_START(__cpu_setup)
        dsb     nsh

        msr     cpacr_el1, xzr                  // Reset cpacr_el1
-       mov     x1, #1 << 12                    // Reset mdscr_el1 and disable
+       mov     x1, MDSCR_EL1_TDCC              // Reset mdscr_el1 and disable
        msr     mdscr_el1, x1                   // access to the DCC from EL0
        reset_pmuserenr_el0 x1                  // Disable PMU access from EL0
        reset_amuserenr_el0 x1                  // Disable AMU access from EL0



