Return-Path: <kvm+bounces-13040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4A44890C6C
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 22:19:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 124D41C29C36
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 21:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B0C13BAFC;
	Thu, 28 Mar 2024 21:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QOGyc+MQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A229713BAFE;
	Thu, 28 Mar 2024 21:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711660681; cv=none; b=l1RGwtmif76Dx38O++x+0+F+jfjt7WHF5w2Uwc3fwdGL0LadRuGsbhJmO+Oacaocb/p/f123QwI6AqoY16npsklsIeP5ieeHSLlHuzOrgXrbHc5fGiNf2BYmyOCvIotKWLIhujCDExvZfIBMy/NyXrDEsIBqhkOoEjJnGgmZ9Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711660681; c=relaxed/simple;
	bh=uJLczxzSRbonCzhxHzP2vHB8XJBIrX/JXXJpvxZMeGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gMnZnodfWhkNBBiMAgD1MivO9I5o/ElYD0mnPhz2aCk1AZDyfj9h1FtSbOiKIklZtVpKcE+AbPfytmR7Xoos+FTsxVH71/EX4dDYC2r6pXrRrgeJMb1uvWp/PfH/nBkevqk6LOwnee25BVjbI0Pyi9UmekxPRynEdcb2NP4NOis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QOGyc+MQ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711660680; x=1743196680;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uJLczxzSRbonCzhxHzP2vHB8XJBIrX/JXXJpvxZMeGc=;
  b=QOGyc+MQwr35+coky2fpSBx5Npa3a+yRhuQdMZHMXAM3sgIzUlgmi7mz
   6KbiHyDp9gIf1x+e2MYTUllSO87+hJwSQeEvk38SzXgHx+eEOGACgbizp
   PGoHF7z2T2PE++6ocbEZznCXlDdnMeWybbtM1N2nBmdwYvOF6ktXFvXqw
   Qc3nU02xTQfDmTHFB9cBpa/7NT8vEzpDmuXwC7KeHpuXYIclmI9LfMH/Z
   TIeMrbKsO9kxf8x0e8Itgkhbm/jK42XWKqxpBv1NLNB8J3TEdyPecpJVz
   XtvVkFx9CwVR2RbImb02mfpiGYhfwZ8V3E9cvGnN3n/EUVkpUdgXRhTIY
   w==;
X-CSE-ConnectionGUID: EZJtklJHTiK9ThPT8x65qw==
X-CSE-MsgGUID: hjwswY1CQYWyuz4SsXFGAQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="6780460"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="6780460"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 14:17:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16806360"
Received: from atanneer-mobl.amr.corp.intel.com (HELO desk) ([10.209.84.81])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 14:17:50 -0700
Date: Thu, 28 Mar 2024 14:17:42 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>, kvm@vger.kernel.org
Subject: Re: [linus:master] [x86/bugs]  6613d82e61:
 general_protection_fault:#[##]
Message-ID: <20240328211742.bh2y3zsscranycds@desk>
References: <202403281553.79f5a16f-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202403281553.79f5a16f-lkp@intel.com>

On Thu, Mar 28, 2024 at 03:36:28PM +0800, kernel test robot wrote:
> compiler: clang-17
> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202403281553.79f5a16f-lkp@intel.com
> 
> 
> [   25.175767][  T670] VFS: Warning: trinity-c2 using old stat() call. Recompile your binary.
> [   25.245597][  T669] general protection fault: 0000 [#1] PREEMPT SMP
> [   25.246417][  T669] CPU: 1 PID: 669 Comm: trinity-c1 Not tainted 6.8.0-rc5-00004-g6613d82e617d #1 85a4928d2e6b42899c3861e57e26bdc646c4c5f9
> [   25.247743][  T669] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> [ 25.248865][ T669] EIP: restore_all_switch_stack (kbuild/src/consumer/arch/x86/entry/entry_32.S:957) 
> [ 25.249510][ T669] Code: 4c 24 10 36 89 48 fc 8b 4c 24 0c 81 e1 ff ff 00 00 36 89 48 f8 8b 4c 24 08 36 89 48 f4 8b 4c 24 04 36 89 48 f0 59 8d 60 f0 58 <0f> 00 2d 00 94 d5 c1 cf 6a 00 68 88 6b d4 c1 eb 00 fc 0f a0 50 b8
> All code
> ========
>    0:	4c 24 10             	rex.WR and $0x10,%al
>    3:	36 89 48 fc          	ss mov %ecx,-0x4(%rax)
>    7:	8b 4c 24 0c          	mov    0xc(%rsp),%ecx
>    b:	81 e1 ff ff 00 00    	and    $0xffff,%ecx
>   11:	36 89 48 f8          	ss mov %ecx,-0x8(%rax)
>   15:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
>   19:	36 89 48 f4          	ss mov %ecx,-0xc(%rax)
>   1d:	8b 4c 24 04          	mov    0x4(%rsp),%ecx
>   21:	36 89 48 f0          	ss mov %ecx,-0x10(%rax)
>   25:	59                   	pop    %rcx
>   26:	8d 60 f0             	lea    -0x10(%rax),%esp
>   29:	58                   	pop    %rax
>   2a:*	0f 00 2d 00 94 d5 c1 	verw   -0x3e2a6c00(%rip)        # 0xffffffffc1d59431		<-- trapping instruction

This is due to 64-bit addressing with CONFIG_X86_32=y on clang.

I haven't tried with clang, but I don't see this happening with gcc-11:

	entry_INT80_32:
	...
	<+446>:   mov    0x4(%esp),%ecx
	<+450>:   mov    %ecx,%ss:-0x10(%eax)
	<+454>:   pop    %ecx
	<+455>:   lea    -0x10(%eax),%esp
	<+458>:   pop    %eax
	<+459>:   verw   0xc1d5c700              <----------
	<+466>:   iret

>   31:	cf                   	iret
>   32:	6a 00                	push   $0x0
>   34:	68 88 6b d4 c1       	push   $0xffffffffc1d46b88
>   39:	eb 00                	jmp    0x3b
...

The config has CONFIG_X86_32=y, but it is possible that in 32-bit build
with clang, 64-bit mode expansion of "VERW (_ASM_RIP(addr))" is getting
used i.e. __ASM_FORM_RAW(b) below:

  file: arch/x86/include/asm/asm.h
  ...
  #ifndef __x86_64__
  /* 32 bit */
  # define __ASM_SEL(a,b)         __ASM_FORM(a)
  # define __ASM_SEL_RAW(a,b)     __ASM_FORM_RAW(a)
  #else
  /* 64 bit */
  # define __ASM_SEL(a,b)         __ASM_FORM(b)
  # define __ASM_SEL_RAW(a,b)     __ASM_FORM_RAW(b)   <--------
  #endif
  ...
  /* Adds a (%rip) suffix on 64 bits only; for immediate memory references */
  #define _ASM_RIP(x)     __ASM_SEL_RAW(x, x (__ASM_REGPFX rip))

Possibly __x86_64__ is being defined with clang even when CONFIG_X86_32=y.

I am not sure about current level of 32-bit mode support in clang. This
seems inconclusive:

  https://discourse.llvm.org/t/x86-32-bit-testing/65480

Does anyone care about 32-bit mode builds with clang?

