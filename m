Return-Path: <kvm+bounces-61152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E9FFCC0CFC5
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 11:39:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 214494F268B
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 10:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6363D2F6905;
	Mon, 27 Oct 2025 10:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k2BUbR0I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46782F5498
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 10:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761561536; cv=none; b=jkAyCRnaal3zG1jwktLObL3pvl8ExjpQitflHAOYb0iF7bR0Ly+Bwj2VvGVR1GgpsYp+YNAE8LsrNFgW0DMcW7b0d1074W/LimYV2YBALUqfezkteW1XqxIS1cyP75nma79jMyPKglZ6nT8TSv8fTHVH3GapLPeqXjwgVlsVxvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761561536; c=relaxed/simple;
	bh=jsUXYGsPkXHYB7gSMqSqkQ15VcUFWDSt+Ems3L6pifQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N2QQdyrUjqk2ktRokQKd8DUJQPQ3R2+YgLx14uSEKoSxdV2/54X04NorFkxc34F7W1TToSm90Sgz+3oOg95S53Y5cSz67DHSQ9B053QNkQClEiP+ppoM/mHXrQ7+q+d93zS9RpJ+H7PYN7BjidQJnLKamXzFjPsaHwZi4N9wLgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k2BUbR0I; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761561535; x=1793097535;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jsUXYGsPkXHYB7gSMqSqkQ15VcUFWDSt+Ems3L6pifQ=;
  b=k2BUbR0Ip7L49A7bTGV2F5egBOEum7km6a6P08Omh4ky6tEVm1QuV07d
   JlyI4efm+PpqYTgod0Tc2NZz5Pp/xsVQWJM/4yytSRBsseC1nCq+gMBUm
   sHa0y0zdzGTyhl5Fs8twdA8c6bZfxQsHwPTxCR4FB8M6qQuCQiCdRLO4O
   9zuHD5ZZcatwvZVZNPJckFkvP/V0lOypFwbEJqyL5pEmz66MGLdrQK+mf
   W1u1jhcUQfm8RRDMQ6DCDbu9VWTRFkVeQ0gqsNRXNHqZVy8LQwUyKAWn3
   p1XEuWa3NHkZXYqhnnTymoT8454chULNxMdScvuNOr7zlaK3n3SpxGC9i
   g==;
X-CSE-ConnectionGUID: 9wQsp8w0Re6c5OoWy2PU2A==
X-CSE-MsgGUID: /zl8/5w3QTqowleH7QTUvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63561743"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63561743"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 03:38:54 -0700
X-CSE-ConnectionGUID: kZJe5iBRR4CQJLPLtgorsg==
X-CSE-MsgGUID: tYhT4FeVSn2qST4hENL1Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="184629188"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa009.jf.intel.com with ESMTP; 27 Oct 2025 03:38:51 -0700
Date: Mon, 27 Oct 2025 19:01:01 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>, Zide Chen <zide.chen@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>, Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>
Subject: Re: [PATCH v3 08/20] i386/cpu: Drop pmu check in CPUID 0x1C encoding
Message-ID: <aP9Q7RArsit6GoxM@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-9-zhao1.liu@intel.com>
 <ab59bf10-3d16-4c34-b87d-31002fe83142@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab59bf10-3d16-4c34-b87d-31002fe83142@intel.com>

> > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > index 5b7a81fcdb1b..5cd335bb5574 100644
> > --- a/target/i386/cpu.c
> > +++ b/target/i386/cpu.c
> > @@ -8275,11 +8275,16 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
> >           }
> >           break;
> >       }
> > -    case 0x1C:
> > -        if (cpu->enable_pmu && (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
> > -            x86_cpu_get_supported_cpuid(0x1C, 0, eax, ebx, ecx, edx);
> > -            *edx = 0;
> > +    case 0x1C: /* Last Branch Records Information Leaf */
> > +        *eax = 0;
> > +        *ebx = 0;
> > +        *ecx = 0;
> > +        *edx = 0;
> 
> Could you help write a patch to move the initialization-to-0 operation out
> to the switch() handling as the common first handling. So that each case
> doesn't need to set them to 0 individually.

Yes, this way could eliminate some redundant code, but explicitly
initializing each leaf currently helps prevent missing something.

Moreover, such cleanup would affect almost all CPUID leaves.
I'm afraid this would make it inconvenient for cherry-picking and
backporting. So the benefits are relatively limited. :-(

> > +        if (!(env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
> > +            break;
> >           }
> > +        x86_cpu_get_supported_cpuid(0x1C, 0, eax, ebx, ecx, edx);
> > +        *edx = 0; /* EDX is reserved. */
> 
> Not the fault of this series. I think just presenting what KVM returns to
> guest (i.e., directly passthrough) isn't correct. Once leaf 0x1c gets more
> bits defined and KVM starts to support and report them, then the bits
> presented to guest get changed automatically between different KVM.
> 
> the leaf 0x1c needs to be configurable and QEMU needs to ensure the same
> configuration outputs the constant result of leaf 0x1c, to ensure safe
> migration.
> 
> It's not urgent though. KVM doesn't even support ArchLBR yet.

I agree, the feature bits enumeration is necessary. Before KVM (or other
accelerators) supports the arch LBR, there's no need to make too many
logic changes - so in this series I try to not change functionality of
arch lbr as much as possible; Let's wait and see the new arch LBR series
from Zide in future.

Regards,
Zhao



