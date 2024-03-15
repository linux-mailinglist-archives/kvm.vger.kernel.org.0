Return-Path: <kvm+bounces-11911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E469087CFE4
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 16:13:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E198282CB6
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 15:13:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A1AD3D56A;
	Fri, 15 Mar 2024 15:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N6Ih6V2v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF9C17BA7;
	Fri, 15 Mar 2024 15:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710515582; cv=none; b=Bc4pcx7Et8n924OTZWLA1552cCwVxLWCQmiu8DI4YxkNahcqQf2I+/g1YltrXYOvxQSSLEKA6MI7bvjRB4137BY5nXkAtA+PRb8RMzxUzGhVG2i5R0et3YakUCgddiF72vzfWuopTD+nlLPDaNtxbj2Ua16GXo2rNH0oEKAUsCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710515582; c=relaxed/simple;
	bh=HevPeEt1n/5IdiWWS/kAj3weJV3b6ArXiNFyiPEDvn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lg4AmqQUM2oZB1vu80StAiVCWXlPkkp9DXRQp7y7giy55tD6tERtjyuKcMal9j/Q6nwXoEohSqR6J1Kkc4PurMTSc5JXgwFHdmBR26r0hmnEqq+KGnM0n1qqPrjaZERwIM9MfjfnFCRm0PZTR3pnVh0L5uDOsZRr7XZA0xk/MaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N6Ih6V2v; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710515580; x=1742051580;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HevPeEt1n/5IdiWWS/kAj3weJV3b6ArXiNFyiPEDvn8=;
  b=N6Ih6V2vrFDE0WBjBa0UDdm9UYxexMetpahMbuio7i1syZrxS2f/+3QL
   wl/JLLD7Nd+RIrChXWPeT5sRGhw2IcuddMpfJgJ/j1Yc/N/VRG8c2IvXX
   PeRvXZKJPIh6pjas+N6d+fs6mC86octf+esmc75k/51thte1dq99+Ad0+
   7Mjd+Q5tmnbRuIGnUINdL4wjWERIN+FSPcJROLsytLhFQ0WB4E7adUh8W
   lRBpa0f9obF74kL7ysgRL+6xvVc+5/DSI7yjkOvdd9qD84SpjbcDkgRQV
   u1z2+uARwX95NiiQPYc/h7JuFic2/Nbrigknh6WKB6ndwOMRbcu3bzXzo
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11014"; a="15939466"
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="15939466"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 08:12:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="12613090"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa007.fm.intel.com with ESMTP; 15 Mar 2024 08:12:55 -0700
Date: Fri, 15 Mar 2024 23:26:46 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Shan Kang <shan.kang@intel.com>,
	Kai Huang <kai.huang@intel.com>, Xin Li <xin3.li@intel.com>
Subject: Re: [PATCH v6 5/9] KVM: VMX: Track CPU's MSR_IA32_VMX_BASIC as a
 single 64-bit value
Message-ID: <ZfRotvcaNUft4H4/@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
 <20240309012725.1409949-6-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240309012725.1409949-6-seanjc@google.com>

Hi Sean,

On Fri, Mar 08, 2024 at 05:27:21PM -0800, Sean Christopherson wrote:
> Date: Fri,  8 Mar 2024 17:27:21 -0800
> From: Sean Christopherson <seanjc@google.com>
> Subject: [PATCH v6 5/9] KVM: VMX: Track CPU's MSR_IA32_VMX_BASIC as a
>  single 64-bit value
> X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
> 
> Track the "basic" capabilities VMX MSR as a single u64 in vmcs_config
> instead of splitting it across three fields, that obviously don't combine
> into a single 64-bit value, so that KVM can use the macros that define MSR
> bits using their absolute position.  Replace all open coded shifts and
> masks, many of which are relative to the "high" half, with the appropriate
> macro.
> 
> Opportunistically use VMX_BASIC_32BIT_PHYS_ADDR_ONLY instead of an open
> coded equivalent, and clean up the related comment to not reference a
> specific SDM section (to the surprise of no one, the comment is stale).
> 
> No functional change intended (though obviously the code generation will
> be quite different).
> 
> Cc: Shan Kang <shan.kang@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> [sean: split to separate patch, write changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/vmx.h      |  5 +++++
>  arch/x86/kvm/vmx/capabilities.h |  6 ++----
>  arch/x86/kvm/vmx/vmx.c          | 28 ++++++++++++++--------------
>  3 files changed, 21 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index c3a97dca4a33..ce6d166fc3c5 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -150,6 +150,11 @@ static inline u32 vmx_basic_vmcs_size(u64 vmx_basic)
>  	return (vmx_basic & GENMASK_ULL(44, 32)) >> 32;

Maybe we could use VMX_BASIC_VMCS_SIZE_SHIFT to replace "32"?

>  }
>  
> +static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
> +{
> +	return (vmx_basic & GENMASK_ULL(53, 50)) >> 50;
> +}
> +

Also here, we can use VMX_BASIC_MEM_TYPE_SHIFT to replace "50".

And what about defining VMX_BASIC_MEM_TYPE_MASK to replace
GENMASK_ULL(53, 50), and VMX_BASIC_VMCS_SIZE_MSAK to replace
GENMASK_ULL(44, 32) above?

Thanks,
Zhao


