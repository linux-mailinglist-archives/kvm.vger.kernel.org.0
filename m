Return-Path: <kvm+bounces-61735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 31655C271F7
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 23:28:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4E1614EB44D
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 22:28:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C2E30DEA0;
	Fri, 31 Oct 2025 22:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nt3CRu3b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E278C32B980;
	Fri, 31 Oct 2025 22:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761949694; cv=none; b=hckKFhPsV8dIZlHzC6JL6Nh9ik89/nWSSBZwZwgvbg7OR979cZ+SWbN3QmQz5nwjPKLT2iWtfIb4DR0sXEW6MVEAR186wfvDD4eAy8GVnq6MG3nzNsgdgRPXi/q8j0zobCryDwqHgHYMH27JcxBIBJ4EaDRPvUluR2vk5t3J04E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761949694; c=relaxed/simple;
	bh=Bq28Tp1IB0kcpnWtVcOiVVSTljZ4bPoZ95IiIfkHZKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qQgABWRuyQH9/UXAcKdZHSpyY9a6gGQYRsLFY6RQ8I+vnKKRfWd6dOtPYaQclWKlEUHLws62rTGQFDi6pNn+vvFeLMfEfkpdVRrb/vpLgr1rHNwsBe+Jub+cdhz7c1GfMHEhoGRcdRZpP+0WaL8EVDvHMmk0nUq8Xj8Tm4lD5pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nt3CRu3b; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761949692; x=1793485692;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Bq28Tp1IB0kcpnWtVcOiVVSTljZ4bPoZ95IiIfkHZKE=;
  b=Nt3CRu3b2QgRTGi/M+bYbW/Ds8Oauso30RovHHP02yMmsHY+qIRWfFdT
   3ofFWmn4Ws2c/yzT/uqkpUTkZNC6OP2qUdmeGMhrmZa9Kp0yYkvGzxh6N
   f2dCbrBuOENN02GWG6rgLUi2Bdb3X3X5IusLcXZPptQLwbjyPd1jVaXHU
   qUbfUAJZSDR4eNhlw8+JQrOs2DPg5JXUHew1QFBJwPCTj0K85d763jIDd
   BmUZQcean7A5Bxl9e/F1UiFgzs0QOK0Gagt2WNfBCDC7TwqfGAi/YGgc/
   QPm4uXRvFFsvdQmF9zCSMzFAzivVzJsv4IuPB6tUEEZcc7NLP8JU6Di0O
   g==;
X-CSE-ConnectionGUID: SVmU1U6PTMmnOpWzOryVdw==
X-CSE-MsgGUID: VDL19xdUTfSMD3BK6/Hijg==
X-IronPort-AV: E=McAfee;i="6800,10657,11599"; a="89580113"
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="89580113"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 15:28:11 -0700
X-CSE-ConnectionGUID: QdMPbSqRTMu/A3YXWEDWnQ==
X-CSE-MsgGUID: rHNn4TssQa2xtoM7ZeC6Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="191490168"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO desk) ([10.124.220.87])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 15:28:10 -0700
Date: Fri, 31 Oct 2025 15:28:04 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 3/8] x86/bugs: Use an X86_FEATURE_xxx flag for the
 MMIO Stale Data mitigation
Message-ID: <20251031222804.s26squjrtbaq7aly@desk>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031003040.3491385-4-seanjc@google.com>

On Thu, Oct 30, 2025 at 05:30:35PM -0700, Sean Christopherson wrote:
> Convert the MMIO Stale Data mitigation flag from a static branch into an
> X86_FEATURE_xxx so that it can be used via ALTERNATIVE_2 in KVM.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/cpufeatures.h   |  1 +
>  arch/x86/include/asm/nospec-branch.h |  2 --
>  arch/x86/kernel/cpu/bugs.c           | 11 +----------
>  arch/x86/kvm/mmu/spte.c              |  2 +-
>  arch/x86/kvm/vmx/vmx.c               |  4 ++--
>  5 files changed, 5 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 7129eb44adad..d1d7b5ec6425 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -501,6 +501,7 @@
>  #define X86_FEATURE_ABMC		(21*32+15) /* Assignable Bandwidth Monitoring Counters */
>  #define X86_FEATURE_MSR_IMM		(21*32+16) /* MSR immediate form instructions */
>  #define X86_FEATURE_X2AVIC_EXT		(21*32+17) /* AMD SVM x2AVIC support for 4k vCPUs */
> +#define X86_FEATURE_CLEAR_CPU_BUF_MMIO	(21*32+18) /* Clear CPU buffers using VERW before VMRUN, iff the vCPU can access host MMIO*/

Some bikeshedding from my side too:
s/iff/if/

Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

