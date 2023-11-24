Return-Path: <kvm+bounces-2425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE6BD7F7040
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 10:43:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C16C1C20F73
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 09:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DECA1171B6;
	Fri, 24 Nov 2023 09:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ONuzufwT"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0B010F7;
	Fri, 24 Nov 2023 01:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4ImK8ZKf78iSxa2f5LHktOGbisjfNwWDxqqa3/kmr4s=; b=ONuzufwTHtkvCQAW4DtB+RrfFr
	EQ0LsWwjDM3e03aVWmdppi37DHTj4eop+PdXeonJclwq3cNj6Pq6mAM0WJ71AAyiIgfNupl8fBuYW
	9WWsm0+pbvX3YYec/NIlvTgSP0haxwRmnZ50TP0OVIJ1BsAgxed3wDtb/EzypBSf2mlKwk5972cXH
	WMt0G//XSqCJNvTth39+8i89Qwz3WkI6kwPooQN2vHtRxhDzwLdgrRKgXFqobS3cea+OXVYKvoYt/
	OGWxQeGgB5m8hqcBkN8FL/u5IVCaYKg7+ByPlO4lbxK9D0I6ASkcSycrI263I/7Ot9J/qDmrjt1s5
	+22o8F7g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r6Sfm-00DpiA-0b;
	Fri, 24 Nov 2023 09:42:33 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D3CDB3002BE; Fri, 24 Nov 2023 10:40:29 +0100 (CET)
Date: Fri, 24 Nov 2023 10:40:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Yang Weijiang <weijiang.yang@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	chao.gao@intel.com, rick.p.edgecombe@intel.com, mlevitsk@redhat.com,
	john.allen@amd.com
Subject: Re: [PATCH v7 02/26] x86/fpu/xstate: Refine CET user xstate bit
 enabling
Message-ID: <20231124094029.GK3818@noisy.programming.kicks-ass.net>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-3-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231124055330.138870-3-weijiang.yang@intel.com>

On Fri, Nov 24, 2023 at 12:53:06AM -0500, Yang Weijiang wrote:
> Remove XFEATURE_CET_USER entry from dependency array as the entry doesn't
> reflect true dependency between CET features and the user xstate bit.
> Enable the bit in fpu_kernel_cfg.max_features when either SHSTK or IBT is
> available.
> 
> Both user mode shadow stack and indirect branch tracking features depend
> on XFEATURE_CET_USER bit in XSS to automatically save/restore user mode
> xstate registers, i.e., IA32_U_CET and IA32_PL3_SSP whenever necessary.
> 
> Note, the issue, i.e., CPUID only enumerates IBT but no SHSTK is resulted
> from CET KVM series which synthesizes guest CPUIDs based on userspace
> settings,in real world the case is rare. In other words, the exitings
> dependency check is correct when only user mode SHSTK is available.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/kernel/fpu/xstate.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index 73f6bc00d178..6e50a4251e2b 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -73,7 +73,6 @@ static unsigned short xsave_cpuid_features[] __initdata = {
>  	[XFEATURE_PT_UNIMPLEMENTED_SO_FAR]	= X86_FEATURE_INTEL_PT,
>  	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
>  	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
> -	[XFEATURE_CET_USER]			= X86_FEATURE_SHSTK,
>  	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
>  	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
>  };
> @@ -798,6 +797,14 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>  			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
>  	}
>  
> +	/*
> +	 * CET user mode xstate bit has been cleared by above sanity check.
> +	 * Now pick it up if either SHSTK or IBT is available. Either feature
> +	 * depends on the xstate bit to save/restore user mode states.
> +	 */
> +	if (boot_cpu_has(X86_FEATURE_SHSTK) || boot_cpu_has(X86_FEATURE_IBT))
> +		fpu_kernel_cfg.max_features |= BIT_ULL(XFEATURE_CET_USER);

So booting a host with "ibt=off" will clear the FEATURE_IBT, this was
fine before this patch-set, but possibly not with.

That kernel argument really only wants to tell the kernel not to use IBT
itself, but not inhibit IBT from being used by guests.

