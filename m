Return-Path: <kvm+bounces-24477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63FEA9560C6
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 03:16:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9F155B21D09
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 01:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00A451C695;
	Mon, 19 Aug 2024 01:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AxmXWGWu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE132634
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 01:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724030192; cv=none; b=t7ACa9RACm31JACZkmTX+cHYsA7o5eVPO7cfoQhpYWV932d77c4JLtq/zMGATGtlOib5Bv7jdjgBJNoaAhtw0jxTMdYLKVSDxOJSWAlpuW7xDibvglRckZ2hFwDJc0q+Nnm+chW+ZUE4EHFKRH9s9acZ2TWyO9vYep892PYO5kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724030192; c=relaxed/simple;
	bh=wud/lzZfaqiZcBUke1v0LUt4rtqjgH5UxA2qf/1dxU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bi0NM7ZCffSdbJsBL3AZBmfFOaY9Az5nry/94BwxqyRWxvBYNFbugdMB8+2rMvEwxa2RLQL5iOVIOYCEurdkhEh8rJZpOOK9ZcTNLfKoKHiMYcGbl6+SxLVyG7Ii1SKEP4C/yRUVIy3hu2FjZT0XkxSKx1JYwJOc8N+54Hgvu7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AxmXWGWu; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724030190; x=1755566190;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=wud/lzZfaqiZcBUke1v0LUt4rtqjgH5UxA2qf/1dxU4=;
  b=AxmXWGWuPulfBNgwZLhQuSHYoWiMeXANNTHiAzqxcWZrzdSb6tFrsA1p
   agsRTlf7oyMokLlIXd0maO9nYTY18xWE9ybog3JS96KQGiVe2S3Eo30iY
   ih1i9L8K//7rBhlHRQ50YPR0VK34slBMDEbrNBBP1cyLGnnr3b56z0fpZ
   eeW3Iign9BAaLnbqq61z+eED3DCL/c6vU25rwj4uXI14/aZp1i0B2sYId
   d83WT5W4EjYhAlN9S0m8ouKc+akRbQKugmBtBoMYoo7EE2B6OYaNSSzxf
   HYOAaEp01dh3fu0XKZOdpnLg+hU35gRtYzWrmBBlz/hqhMsq58tZ0rnsN
   Q==;
X-CSE-ConnectionGUID: XDzoItZOSB+P5Vlw+fm/Ow==
X-CSE-MsgGUID: HqT7u2VkRTObl1YxDXn1ow==
X-IronPort-AV: E=McAfee;i="6700,10204,11168"; a="26009860"
X-IronPort-AV: E=Sophos;i="6.10,158,1719903600"; 
   d="scan'208";a="26009860"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2024 18:16:29 -0700
X-CSE-ConnectionGUID: 788Jq+8HTrOGMU4jV1DxLg==
X-CSE-MsgGUID: CqylEcTWTyS1AFSAGqT9Gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,158,1719903600"; 
   d="scan'208";a="65100278"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2024 18:16:28 -0700
Date: Mon, 19 Aug 2024 09:11:15 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com,
	xiaoyao.li@intel.com
Subject: Re: [PATCH v2] KVM: x86: Advertise AVX10.1 CPUID to userspace
Message-ID: <ZsKbsx2K0CxSUT2/@linux.bj.intel.com>
References: <20240603064002.266116-1-tao1.su@linux.intel.com>
 <Zr9nhCqerpmXjvGc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zr9nhCqerpmXjvGc@google.com>

On Fri, Aug 16, 2024 at 07:51:48AM -0700, Sean Christopherson wrote:
> On Mon, Jun 03, 2024, Tao Su wrote:
> > Advertise AVX10.1 related CPUIDs, i.e. report AVX10 support bit via
> > CPUID.(EAX=07H, ECX=01H):EDX[bit 19] and new CPUID leaf 0x24H so that
> > guest OS and applications can query the AVX10.1 CPUIDs directly. Intel
> > AVX10 represents the first major new vector ISA since the introduction of
> > Intel AVX512, which will establish a common, converged vector instruction
> > set across all Intel architectures[1].
> > 
> > AVX10.1 is an early version of AVX10, that enumerates the Intel AVX512
> > instruction set at 128, 256, and 512 bits which is enabled on
> > Granite Rapids. I.e., AVX10.1 is only a new CPUID enumeration with no
> > VMX capability, Embedded rounding and Suppress All Exceptions (SAE),
> > which will be introduced in AVX10.2.
> >
> > Advertising AVX10.1 is safe because kernel doesn't enable AVX10.1 which is
> 
> I thought there is nothing to enable for AVX10.1?  I.e. it's purely a new way to
> enumerate support, thus there will never be anything for the kernel to enable.
> 

Yes, AVX10.1 is just a new enumeration way.

> > on KVM-only leaf now, just the CPUID checking is changed when using AVX512
> > related instructions, e.g. if using one AVX512 instruction needs to check
> > (AVX512 AND AVX512DQ), it can check ((AVX512 AND AVX512DQ) OR AVX10.1)
> > after checking XCR0[7:5].
> > 
> > The versions of AVX10 are expected to be inclusive, e.g. version N+1 is
> > a superset of version N. Per the spec, the version can never be 0, just
> > advertise AVX10.1 if it's supported in hardware.
> 
> I think it's also worth calling out that advertising AVX10_{128,256,512} needs
> to land in the same patch (this patch) as AVX10 (and thus AVX10.1), because
> otherwise KVM would advertise an impossible CPU model, e.g. with AVX512 but not
> AVX10.1/512, which per "Feature Differences Between Intel® AVX-512 and Intel® AVX10"
> should be impossible.
> 

Indeed, that's the reason why I only used one patch, will do in v3, thanks!

> > As more and more AVX related CPUIDs are added (it would have resulted in
> > around 40-50 CPUID flags when developing AVX10), the versioning approach
> > is introduced. But incrementing version numbers are bad for virtualization.
> > E.g. if AVX10.2 has a feature that shouldn't be enumerated to guests for
> > whatever reason, then KVM can't enumerate any "later" features either,
> > because the only way to hide the problematic AVX10.2 feature is to set the
> > version to AVX10.1 or lower[2]. But most AVX features are just passed
> > through and don’t have virtualization controls, so AVX10 should not be
> > problematic in practice.
> > 
> > [1] https://cdrdv2.intel.com/v1/dl/getContent/784267
> > [2] https://lore.kernel.org/all/Zkz5Ak0PQlAN8DxK@google.com/
> > 
> > Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> > ---
> > Changelog:
> > v1 -> v2:
> >  - Directly advertise version 1 because version can never be 0.
> >  - Add and advertise feature bits for the supported vector sizes.
> > 
> > v1: https://lore.kernel.org/all/20240520022002.1494056-1-tao1.su@linux.intel.com/
> > ---
> >  arch/x86/include/asm/cpuid.h |  1 +
> >  arch/x86/kvm/cpuid.c         | 21 +++++++++++++++++++--
> >  arch/x86/kvm/reverse_cpuid.h |  8 ++++++++
> >  3 files changed, 28 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/cpuid.h b/arch/x86/include/asm/cpuid.h
> > index 6b122a31da06..aa21c105eef1 100644
> > --- a/arch/x86/include/asm/cpuid.h
> > +++ b/arch/x86/include/asm/cpuid.h
> > @@ -179,6 +179,7 @@ static __always_inline bool cpuid_function_is_indexed(u32 function)
> >  	case 0x1d:
> >  	case 0x1e:
> >  	case 0x1f:
> > +	case 0x24:
> >  	case 0x8000001d:
> >  		return true;
> >  	}
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index f2f2be5d1141..6717a5b7d9cd 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -693,7 +693,7 @@ void kvm_set_cpu_caps(void)
> >  
> >  	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
> >  		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI) |
> > -		F(AMX_COMPLEX)
> > +		F(AMX_COMPLEX) | F(AVX10)
> >  	);
> >  
> >  	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
> > @@ -709,6 +709,10 @@ void kvm_set_cpu_caps(void)
> >  		SF(SGX1) | SF(SGX2) | SF(SGX_EDECCSSA)
> >  	);
> >  
> > +	kvm_cpu_cap_init_kvm_defined(CPUID_24_0_EBX,
> > +		F(AVX10_128) | F(AVX10_256) | F(AVX10_512)
> > +	);
> > +
> >  	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
> >  		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
> >  		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
> > @@ -937,7 +941,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> >  	switch (function) {
> >  	case 0:
> >  		/* Limited to the highest leaf implemented in KVM. */
> > -		entry->eax = min(entry->eax, 0x1fU);
> > +		entry->eax = min(entry->eax, 0x24U);
> >  		break;
> >  	case 1:
> >  		cpuid_entry_override(entry, CPUID_1_EDX);
> > @@ -1162,6 +1166,19 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> >  			break;
> >  		}
> >  		break;
> > +	case 0x24: {
> 
> No need for the curly braces on the case.  But, my suggestion below will change
> that ;-)
> 

I got it :-)

> > +		if (!kvm_cpu_cap_has(X86_FEATURE_AVX10)) {
> > +			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> > +			break;
> > +		}
> > +		entry->eax = 0;
> > +		cpuid_entry_override(entry, CPUID_24_0_EBX);
> > +		/* EBX[7:0] hold the AVX10 version; KVM supports version '1'. */
> > +		entry->ebx |= 1;
> 
> Ah, rather than hardcode this to '1', I think we should do:
> 
> 		u8 avx10_version;
> 
> 		if (!kvm_cpu_cap_has(X86_FEATURE_AVX10)) {
> 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> 			break;
> 		}
> 
> 		/*
> 		 * The AVX10 version is encoded in EBX[7:0].  Note, the version
> 		 * is guaranteed to be >=1 if AVX10 is supported.  Note #2, the
> 		 * version needs to be captured before overriding EBX features!
> 		 */
> 		avx10_version = min_t(u8, entry->ebx & 0xff, 1);
> 
> 		cpuid_entry_override(entry, CPUID_24_0_EBX);
> 		entry->ebx |= avx10_version;
> 
> I.e. use the same approach as limiting the max leaf, which does:
> 
> 		entry->eax = min(entry->eax, 0x1fU);
> 
> Unless I'm misunderstanding how all of this is expected to play out, we're going
> to need the min_t() code for AVX10.2 anyways, might as well implement it now.

Yes, that's better for the upcoming AVX10.2, thanks for the suggestions!


