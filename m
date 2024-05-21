Return-Path: <kvm+bounces-17826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A78F28CA6B2
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 05:13:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62665282776
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 03:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 016F51C697;
	Tue, 21 May 2024 03:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hmBJ1rBJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1D31B970
	for <kvm@vger.kernel.org>; Tue, 21 May 2024 03:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716261202; cv=none; b=EFsY4/4GI33Pq6ZnUEp9DdzaYsGslkCqve0uj4xLD5S5Jom+fuMxsqPZWjzdTAPEhVSGp21PISSh319zF0Ml8KclIymsddwxMjxNdgGu04fYDQ6cXz6v229O2Jcut0o38bkykMZ7G8JOIa6I+QScT6IZFINaWhiwJnlHsLF94Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716261202; c=relaxed/simple;
	bh=7I2xXjne4ot7xXMHw9LYxCDCkyXOuHRWHdhtCe7Pbeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mf0bP9s8PE/fgf+5qnOUUpFsfT18p4GFMzyELfVfbZaE750OT555F41qP9wyzwdq+7RNHFs2eIZPwBIdAOUADR7St3T40oxhBs8kYP7uj8bXkIMW+jXVLnDM61GxbQu3Jgi6LnnRyrs18PDVCnoCEYPXVGtO4zkxKhK9VFNB5Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hmBJ1rBJ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716261201; x=1747797201;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=7I2xXjne4ot7xXMHw9LYxCDCkyXOuHRWHdhtCe7Pbeo=;
  b=hmBJ1rBJwYrTVZHyUh2cMLktN2Rawz/NdGWv2CfI7TsKuJuYojahbCT8
   TydZo+WofRz0s8j+/XDY0kkmECcCPCsNi8RTVohb9pzLAm3oheYd7GUJl
   xqkYSyneJMV0gxKzSXVpwHNtNBRM0zeasZr72P37qtXRF25y1AKKkhyPc
   x7tYz+cAJhpISrCUoCIxWtSfKj7ZSyEpKwT1svzr/605x7PeVbI8+jBoJ
   ZmAu+lNK0m7dM93jnVnf3MuSpv7iIitxhiIUNzwb4lQmEyEwNvTwW0DcY
   JflKQAjvMzS+Ox+pIJR/fVf/fmPrYOA4QeF+ErGJZiM5yebS1Z0N1SvjJ
   Q==;
X-CSE-ConnectionGUID: 2AR5uvGjTcWi6Nv7pdEZWg==
X-CSE-MsgGUID: 3X917Jr/RrO1hyrjRmBf5w==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12367170"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12367170"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 20:13:21 -0700
X-CSE-ConnectionGUID: 5F4QWtDOS5+MP/anG225WQ==
X-CSE-MsgGUID: K1BlKI0JQWaGCmNxYAKkfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="33325740"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 20:13:18 -0700
Date: Tue, 21 May 2024 11:08:49 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com,
	xiaoyao.li@intel.com
Subject: Re: [PATCH] KVM: x86: Advertise AVX10.1 CPUID to userspace
Message-ID: <ZkwQQZ22ImN6fXTM@linux.bj.intel.com>
References: <20240520022002.1494056-1-tao1.su@linux.intel.com>
 <ZkthpjnKRD1Jpj2A@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZkthpjnKRD1Jpj2A@google.com>

On Mon, May 20, 2024 at 07:43:50AM -0700, Sean Christopherson wrote:
> On Mon, May 20, 2024, Tao Su wrote:
> > @@ -1162,6 +1162,22 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> >  			break;
> >  		}
> >  		break;
> > +	case 0x24: {
> > +		u8 avx10_version;
> > +		u32 vector_support;
> > +
> > +		if (!kvm_cpu_cap_has(X86_FEATURE_AVX10)) {
> > +			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> > +			break;
> > +		}
> > +		avx10_version = min(entry->ebx & 0xff, 1);
> 
> Taking the min() of '1' and anything else is pointless.  Per the spec, the version
> can never be 0.
> 
>   CPUID.(EAX=24H, ECX=00H):EBX[bits 7:0]  Reports the Intel AVX10 Converged Vector ISA version. Integer (≥ 1)
> 
> And it's probably too late, but why on earth is there an AVX10 version number?
> Version numbers are _awful_ for virtualization; see the constant vPMU problems
> that arise from bundling things under a single version number..  Y'all carved out
> room for sub-leafs, i.e. there's a ton of room for "discrete feature bits", so
> why oh why is there a version number?
> 

Per the spec, AVX10 wants to reduce the number of CPUID feature flags required
to be checked, which may simplify application development. Application only
needs to check the version number that can know whether hardware supports an
instruction. There's indeed a sub-leaf for enumerating discrete CPUID feature
bits, but the sub-leaf is only in the rare case.

AVX10.2 (version number == 2) is the initial and fully-featured version of
AVX10, we may need to advertise AVX10.2 in the future. Is keeping min() more
flexible to control the advertised version number? E.g.

    avx10_version = min(entry->ebx & 0xff, 2);

can advertise AVX10.2 to userspace.

> > +		vector_support = entry->ebx & GENMASK(18, 16);
> 
> Please add proper defines somewhere, this this can be something like:
> 
> 		/* EBX[7:0] hold the AVX10 version; KVM supports version '1'. */
> 		entry->eax = 0;
> 		entry->ebx = (entry->ebx & AVX10_VECTOR_SIZES_MASK) | 1;
> 		entry->ecx = 0;
> 		entry->edx = 0;
> 

Yes, its readability will be better.

> Or perhaps we should have feature bits for the vector sizes, because that's really
> what they are.  Mixing feature bits in with a version number makes for painful
> code, but there's nothing KVM can do about that.  With proper features, this then
> becomes something like:
> 
> 		entry->eax = 0;
> 		cpuid_entry_override(entry, CPUID_24_0_EBX);
> 		/* EBX[7:0] hold the AVX10 version; KVM supports version '1'. */
> 		entry->ebx |= 1;
> 		entry->ecx = 0;
> 		entry->edx = 0;

Agree, I will introduce the feature bits for the vector sizes, thanks!


