Return-Path: <kvm+bounces-70317-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iEedFRB0hGn12wMAu9opvQ
	(envelope-from <kvm+bounces-70317-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 11:42:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 626C8F16DB
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 11:42:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D234E300690E
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 10:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AF583A9616;
	Thu,  5 Feb 2026 10:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cosisSUp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BA63A962E;
	Thu,  5 Feb 2026 10:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770288128; cv=none; b=k8wsFtD4izMBA+5MxQ7fFWXEJRiECi4niDRzgoruQJ0TERa2wnr8D1zACoLT9+7rW5zCcr/3DsOmX3DLb7iQRQfK4XE9goi72nrcUAX0RJFUB3wYfDZ7iw/rqw3dtrrPinQY26i6f2dGvEBE9ZondwpNKNn0D1l+p6VEk2R7DhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770288128; c=relaxed/simple;
	bh=NGjS2W/fPan80cD9RMH4Y/pXk5yggvLWzpNgN5tKX14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bgplK/PaLo2ZKVQPKOguLtZdaq69PEGV5tRMnZQ9X+qyYEO/5Gy0Aw0+2xbDaXCEf+GgsotBND0muyGcuhpFsp24rT8WZ/cCkjI6GZxoaU3/Mm+xpYKk/5AZpWxpeu+v6KCZ0K6CV4h3ILVNqJt8vH5tCSyz/N2Q2UIOb8LDcZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cosisSUp; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770288128; x=1801824128;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NGjS2W/fPan80cD9RMH4Y/pXk5yggvLWzpNgN5tKX14=;
  b=cosisSUpxyzypsPulOR8kwAbBPTFSkXJ0XBps8mUweAkFD/K3etg7GBY
   qS7OJs0s2RywH6S1TtmU8aGw0Zulv4dvmJDtGOyI4w5YuRqZxnBMhZj4U
   rIu6T7D1BPnaLMKqnleOYZO35/A/zHlClm9x7CFgH5P1foiLTcK7Yb1px
   LQxkqVtQeC+ol+/F1oQ+fdV6l2BmaMMqXka5hk0eRn+cgRut0aPYkMIQ8
   rmo8PZGFbrGrzpDWVe4rUbAChAu9SlyngUvZkMDTULEAs58PaBl5zW0mz
   5jta/I66NeL2peSslWbR4Dio6xoX1Jld+XpVZXI/sKgdOWzpos8KXmO/0
   Q==;
X-CSE-ConnectionGUID: ZcOIaeApSreNQLKJRxzVSg==
X-CSE-MsgGUID: 7ZfImLPPTJCuI5n2eqwwUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="82221831"
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="82221831"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 02:42:07 -0800
X-CSE-ConnectionGUID: ozeke08AS5Sc90Vx7mUNMw==
X-CSE-MsgGUID: V3W2IP7WRoqI5oG+Ju4Iqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="248079118"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 05 Feb 2026 02:42:04 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vnwoD-00000000jjA-0ysQ;
	Thu, 05 Feb 2026 10:42:01 +0000
Date: Thu, 5 Feb 2026 18:41:09 +0800
From: kernel test robot <lkp@intel.com>
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, bp@alien8.de, thomas.lendacky@amd.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, tglx@kernel.org,
	mingo@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com,
	xin@zytor.com, seanjc@google.com, pbonzini@redhat.com,
	x86@kernel.org, jon.grimm@amd.com, nikunj@amd.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
Message-ID: <202602051859.vGTf24Nk-lkp@intel.com>
References: <20260205051030.1225975-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205051030.1225975-1-nikunj@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70317-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,01.org:url]
X-Rspamd-Queue-Id: 626C8F16DB
X-Rspamd-Action: no action

Hi Nikunj,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 3c2ca964f75460093a8aad6b314a6cd558e80e66]

url:    https://github.com/intel-lab-lkp/linux/commits/Nikunj-A-Dadhania/x86-fred-Fix-early-boot-failures-on-SEV-ES-SNP-guests/20260205-131359
base:   3c2ca964f75460093a8aad6b314a6cd558e80e66
patch link:    https://lore.kernel.org/r/20260205051030.1225975-1-nikunj%40amd.com
patch subject: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260205/202602051859.vGTf24Nk-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260205/202602051859.vGTf24Nk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602051859.vGTf24Nk-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/x86/entry/entry_fred.c:213:11: error: call to undeclared function 'user_exc_vmm_communication'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     213 |                         return user_exc_vmm_communication(regs, error_code);
         |                                ^
>> arch/x86/entry/entry_fred.c:213:4: warning: void function 'fred_hwexc' should not return a value [-Wreturn-mismatch]
     213 |                         return user_exc_vmm_communication(regs, error_code);
         |                         ^      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/entry/entry_fred.c:215:11: error: call to undeclared function 'kernel_exc_vmm_communication'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     215 |                         return kernel_exc_vmm_communication(regs, error_code);
         |                                ^
   arch/x86/entry/entry_fred.c:215:4: warning: void function 'fred_hwexc' should not return a value [-Wreturn-mismatch]
     215 |                         return kernel_exc_vmm_communication(regs, error_code);
         |                         ^      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   2 warnings and 2 errors generated.


vim +/fred_hwexc +213 arch/x86/entry/entry_fred.c

   180	
   181	static noinstr void fred_hwexc(struct pt_regs *regs, unsigned long error_code)
   182	{
   183		/* Optimize for #PF. That's the only exception which matters performance wise */
   184		if (likely(regs->fred_ss.vector == X86_TRAP_PF))
   185			return exc_page_fault(regs, error_code);
   186	
   187		switch (regs->fred_ss.vector) {
   188		case X86_TRAP_DE: return exc_divide_error(regs);
   189		case X86_TRAP_DB: return fred_exc_debug(regs);
   190		case X86_TRAP_BR: return exc_bounds(regs);
   191		case X86_TRAP_UD: return exc_invalid_op(regs);
   192		case X86_TRAP_NM: return exc_device_not_available(regs);
   193		case X86_TRAP_DF: return exc_double_fault(regs, error_code);
   194		case X86_TRAP_TS: return exc_invalid_tss(regs, error_code);
   195		case X86_TRAP_NP: return exc_segment_not_present(regs, error_code);
   196		case X86_TRAP_SS: return exc_stack_segment(regs, error_code);
   197		case X86_TRAP_GP: return exc_general_protection(regs, error_code);
   198		case X86_TRAP_MF: return exc_coprocessor_error(regs);
   199		case X86_TRAP_AC: return exc_alignment_check(regs, error_code);
   200		case X86_TRAP_XF: return exc_simd_coprocessor_error(regs);
   201	
   202	#ifdef CONFIG_X86_MCE
   203		case X86_TRAP_MC: return fred_exc_machine_check(regs);
   204	#endif
   205	#ifdef CONFIG_INTEL_TDX_GUEST
   206		case X86_TRAP_VE: return exc_virtualization_exception(regs);
   207	#endif
   208	#ifdef CONFIG_X86_CET
   209		case X86_TRAP_CP: return exc_control_protection(regs, error_code);
   210	#endif
   211		case X86_TRAP_VC:
   212			if (user_mode(regs))
 > 213				return user_exc_vmm_communication(regs, error_code);
   214			else
   215				return kernel_exc_vmm_communication(regs, error_code);
   216		default: return fred_bad_type(regs, error_code);
   217		}
   218	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

