Return-Path: <kvm+bounces-5973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71688829269
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 03:23:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E7281C25495
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 02:23:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8939C440C;
	Wed, 10 Jan 2024 02:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LTw6xGZv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0672E3C0A;
	Wed, 10 Jan 2024 02:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704853419; x=1736389419;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bASmGQhqR/eGJTY1mguNWhZ2LGaJ9Vq7snRNdlQhktA=;
  b=LTw6xGZvGpBH3HZzZdh27/nL4eOV6XIabN+O/oCu0mNgLe2oRB9pT43a
   mpdT0FumI6qP4LJnLqdWs8YbEof8VUFQFbMSc0rQXT9WWIu8G12Nqgf4s
   ip95EhrtbGzyGbri+Thiw6c3CzQXs96p6VbPPkv3YCLosEOS/rpq1EIsu
   eKlH7CekUvFkIKRkKy/E/aar5EhSf3qNiCSHWTNVjhC15cu4th84d/r96
   p8rNJohqyGOQ1MfB8Mp+rXg7cC51xIf0Pf8PGy8JrK3ogCxx/AueUaTFG
   XW7zHbMrkuSWLHdd1DiCxzURqOiE1kPyzvVZ1JjogbFC69UAD+QEvdkpC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="16974895"
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="16974895"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2024 18:23:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="16475396"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2024 18:23:35 -0800
Date: Wed, 10 Jan 2024 10:20:32 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Yi Lai <yi1.lai@intel.com>, Xudong Hao <xudong.hao@intel.com>
Subject: Re: [PATCH] x86/cpu: Add a VMX flag to enumerate 5-level EPT support
 to userspace
Message-ID: <ZZ3+8N3lUtmmwS0T@linux.bj.intel.com>
References: <20240110002340.485595-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240110002340.485595-1-seanjc@google.com>

On Tue, Jan 09, 2024 at 04:23:40PM -0800, Sean Christopherson wrote:
> Add a VMX flag in /proc/cpuinfo, ept_5level, so that userspace can query
> whether or not the CPU supports 5-level EPT paging.  EPT capabilities are
> enumerated via MSR, i.e. aren't accessible to userspace without help from
> the kernel, and knowing whether or not 5-level EPT is supported is sadly
> necessary for userspace to correctly configure KVM VMs.
> 
> When EPT is enabled, bits 51:49 of guest physical addresses are consumed

nit: s/49/48

Thanks,
Tao

> if and only if 5-level EPT is enabled.  For CPUs with MAXPHYADDR > 48, KVM
> *can't* map all legal guest memory if 5-level EPT is unsupported, e.g.
> creating a VM with RAM (or anything that gets stuffed into KVM's memslots)
> above bit 48 will be completely broken.
> 
> Having KVM enumerate guest.MAXPHYADDR=48 in this scenario doesn't work
> either, as architecturally guest accesses to illegal addresses generate
> RSVD #PF, i.e. advertising guest.MAXPHYADDR < host.MAXPHYADDR when EPT is
> enabled would also result in broken guests.  KVM does provide a knob,
> allow_smaller_maxphyaddr, to let userspace opt-in to such setups, but
> that support is firmly best-effort, i.e. not something KVM wants to force
> upon userspace.
> 
> While it's decidedly odd for a CPU to support a 52-bit MAXPHYADDR but not
> 5-level EPT, the combination is architecturally legal and such CPUs do
> exist (and can easily be "created" with nested virtualization).
> 
> Reported-by: Yi Lai <yi1.lai@intel.com>
> Cc: Tao Su <tao1.su@linux.intel.com>
> Cc: Xudong Hao <xudong.hao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> tip-tree folks, this is obviously not technically KVM code, but I'd like to
> take this through the KVM tree so that we can use the information to fix
> KVM selftests (hopefully this cycle).
> 
>  arch/x86/include/asm/vmxfeatures.h | 1 +
>  arch/x86/kernel/cpu/feat_ctl.c     | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
> index c6a7eed03914..266daf5b5b84 100644
> --- a/arch/x86/include/asm/vmxfeatures.h
> +++ b/arch/x86/include/asm/vmxfeatures.h
> @@ -25,6 +25,7 @@
>  #define VMX_FEATURE_EPT_EXECUTE_ONLY	( 0*32+ 17) /* "ept_x_only" EPT entries can be execute only */
>  #define VMX_FEATURE_EPT_AD		( 0*32+ 18) /* EPT Accessed/Dirty bits */
>  #define VMX_FEATURE_EPT_1GB		( 0*32+ 19) /* 1GB EPT pages */
> +#define VMX_FEATURE_EPT_5LEVEL		( 0*32+ 20) /* 5-level EPT paging */
>  
>  /* Aggregated APIC features 24-27 */
>  #define VMX_FEATURE_FLEXPRIORITY	( 0*32+ 24) /* TPR shadow + virt APIC */
> diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
> index 03851240c3e3..1640ae76548f 100644
> --- a/arch/x86/kernel/cpu/feat_ctl.c
> +++ b/arch/x86/kernel/cpu/feat_ctl.c
> @@ -72,6 +72,8 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
>  		c->vmx_capability[MISC_FEATURES] |= VMX_F(EPT_AD);
>  	if (ept & VMX_EPT_1GB_PAGE_BIT)
>  		c->vmx_capability[MISC_FEATURES] |= VMX_F(EPT_1GB);
> +	if (ept & VMX_EPT_PAGE_WALK_5_BIT)
> +		c->vmx_capability[MISC_FEATURES] |= VMX_F(EPT_5LEVEL);
>  
>  	/* Synthetic APIC features that are aggregates of multiple features. */
>  	if ((c->vmx_capability[PRIMARY_CTLS] & VMX_F(VIRTUAL_TPR)) &&
> 
> base-commit: 1c6d984f523f67ecfad1083bb04c55d91977bb15
> -- 
> 2.43.0.472.g3155946c3a-goog
> 

