Return-Path: <kvm+bounces-61148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B654AC0CC00
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 10:50:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB77A3B603C
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 09:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8D212F547D;
	Mon, 27 Oct 2025 09:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="csNcxL8t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E542F3C3F
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 09:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761558608; cv=none; b=IvYrtPWQo5x8at+XleIT44Jco100av70IhU9IjSc0y0F7P2R23yLjevLisiKgYm+hCYB2A05K/nmqBO60bKvRyTe2KYuGdbVhi7jo6RSxOqK6ThLcC625RmDxQ6lDKKCPpuluGGYxt13j9tiTctSX4IOrvDONbt2sgdTt6+I8G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761558608; c=relaxed/simple;
	bh=EPREoMUXRyDfBk/mK+9pxDtEalQDV12FTD9qW61Ut7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AXu2gSXrRYLu66w1w+vFCPOd8Dp45m6wQgNywVK16x7gf9PwrAHPI/suZqllrNWP9h5umHHz6BHKcW7F0NjfoQW5/7UIonpiN9sNKjtWeSTqOnnp1SFUTW7YivvRtbRvmi/rkVsE03wFc6q/UJOhwLUgjplm+abZmMmjySuV5B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=csNcxL8t; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761558607; x=1793094607;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EPREoMUXRyDfBk/mK+9pxDtEalQDV12FTD9qW61Ut7E=;
  b=csNcxL8tqd8HATNJpirQaQ67PG4RSuPip+XQ+HztQrvLKF6tQS21fdCX
   xub2IuYSbHvF8GVypcpIeDWaYVcvtGsZ3y/zf+GXLkaVDJVvFBHduTwCr
   zCjNon8ajtRjz0sPl0CEgOjEDNi1Ahp9OpxUyYeSK6nueQ2PVKZy5jzV8
   j3YVwkBqXJ+QgK7w/WZjksthzfCtLcJxFBAbVYRErsycoWrpjKCWkRWTJ
   dSoMV7v3pgGdGlZUQyDetjkEnU7ibqHMc6lkP5FpIpQ3/yGYuke+ZJDD0
   M+oIThz9IG9BLoA8h6wRzpNNU+5n90xBzQJqZ3mEeXXTVAahsjx6ZFjK9
   g==;
X-CSE-ConnectionGUID: fa0+P4dnTlyOxSnVirgH6g==
X-CSE-MsgGUID: ULwmod5mSv6rh3ZBp+Al6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63534308"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63534308"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 02:50:07 -0700
X-CSE-ConnectionGUID: BHXATqk5RQmsIvipYv+t5Q==
X-CSE-MsgGUID: v4fAVbsXSPKNKCNSurB9EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="185759421"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa010.fm.intel.com with ESMTP; 27 Oct 2025 02:50:03 -0700
Date: Mon, 27 Oct 2025 18:12:13 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>, Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>
Subject: Re: [PATCH v3 07/20] i386/cpu: Reorganize dependency check for arch
 lbr state
Message-ID: <aP9FfUKoP2azthS8@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-8-zhao1.liu@intel.com>
 <d34f682a-c6c0-4609-96e8-2a0b76585c7d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d34f682a-c6c0-4609-96e8-2a0b76585c7d@intel.com>

> >   * XSAVES feature bit (CPUID 0xD.0x1.EAX[bit 3]):
> > 
> >     Arch lbr state is a supervisor state, which requires the XSAVES
> >     feature support. Enumerate supported supervisor state based on XSAVES
> >     feature bit in x86_cpu_enable_xsave_components().
> > 
> >     Then it's safe to drop the check on XSAVES feature support during
> >     CPUID 0XD encoding.

...

> > +++ b/target/i386/cpu.c
> > @@ -8174,16 +8174,6 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
> >               *ebx = xsave_area_size(xstate, true);
> >               *ecx = env->features[FEAT_XSAVE_XSS_LO];
> >               *edx = env->features[FEAT_XSAVE_XSS_HI];
> > -            if (kvm_enabled() && cpu->enable_pmu &&
> > -                (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR) &&
> > -                (*eax & CPUID_XSAVE_XSAVES)) {
> > -                *ecx |= XSTATE_ARCH_LBR_MASK;
> > -            } else {
> > -                *ecx &= ~XSTATE_ARCH_LBR_MASK;
> > -            }
> 
> > -        } else if (count == 0xf && cpu->enable_pmu
> > -                   && (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
> > -            x86_cpu_get_supported_cpuid(0xD, count, eax, ebx, ecx, edx);
> 
> This chunk needs to be a separate patch. It's a functional change.

Already mentioned this in commit message.


