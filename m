Return-Path: <kvm+bounces-24484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 73607956300
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 07:05:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6A9C1C2153B
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 05:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DC7914A0A4;
	Mon, 19 Aug 2024 05:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hG/oQ7mC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4AB42049;
	Mon, 19 Aug 2024 05:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724043900; cv=none; b=LL4GV2D8M5MCg74YkOIngcqtjSRBgECPm8U3Kmxr8Pv6FQ3FPGp5b48L4EcKoTYLb4QmnAbK5Bml/A58A1wZlRI09mTaO+6vyIb5uXUhNEOC18LxBcYYWoY2c2hZIp5VdpxfWFV67aW7hqZg5Z0I9RJLGKlTjcqX/rqVsvYhcTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724043900; c=relaxed/simple;
	bh=0kUCArxtC2FaObCka5uR2x8dxjtgH9daEqowp/Nr1t8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X9tId+YlqQrm81Kcrldlhx5k/Ygo2cZZlh10AF/wBItdg7h4B9P0SUB8+sgfIX2xIS0bksW62JjVpojavixnlinaSxYvll0XLk9sqUBjN0XNtM8GcOaA9b0+BtD+oIlf2tz2/S+ngnD1a4Lk8+O3caN8k/Xk42ip5LCjxLlzWDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hG/oQ7mC; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724043898; x=1755579898;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0kUCArxtC2FaObCka5uR2x8dxjtgH9daEqowp/Nr1t8=;
  b=hG/oQ7mC+Ga5+VJ0pyhVG1uVQbLMe1zlAcTH1mFwbV8Zwc3YhcR2M8ZX
   3F/j0MF59TwtCldcoFB6TZrOYsNASR2ZT8lXi2mTrGytsyu2aueoUDoL6
   4IJjuG3O8VejMCvA3T11tUyTHPaMD0PviuwnMVtsVb9yr1tbJfgBwDMmU
   nT3KFjxZcfVmSnjbVF7WlziMH4og8c0nqHUH7E3cd6cdeBs4PndoVnwZi
   C+EGIpkCgaDa6cMZrO1e71xsCHT80Mc9+ZiEWI0ys0SLbARBevoT4RvX5
   agrqsjVoT1Qhlnd7X7bvunBnfS1FpTcbey00SFg8sOHo5CluUvMTVEeBV
   Q==;
X-CSE-ConnectionGUID: GwKIglXSR728rmf/YzrmgA==
X-CSE-MsgGUID: AgetedXcSLuTVUAdf3F1rA==
X-IronPort-AV: E=McAfee;i="6700,10204,11168"; a="33419011"
X-IronPort-AV: E=Sophos;i="6.10,158,1719903600"; 
   d="scan'208";a="33419011"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2024 22:04:58 -0700
X-CSE-ConnectionGUID: n+EO5u/qRROCOJSZKGS0cg==
X-CSE-MsgGUID: uEPrZLJjQ4u8IPwxthErEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,158,1719903600"; 
   d="scan'208";a="60085661"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa010.jf.intel.com with ESMTP; 18 Aug 2024 22:04:56 -0700
Date: Mon, 19 Aug 2024 13:02:41 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	kai.huang@intel.com, isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/25] KVM: x86: Filter directly configurable TDX CPUID
 bits
Message-ID: <ZsLR8RxAsTT8yTUo@yilunxu-OptiPlex-7050>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-25-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812224820.34826-25-rick.p.edgecombe@intel.com>

On Mon, Aug 12, 2024 at 03:48:19PM -0700, Rick Edgecombe wrote:
> Future TDX modules may provide support for future HW features, but run with
> KVM versions that lack support for them. In this case, userspace may try to
> use features that KVM does not have support, and develop assumptions around
> KVM's behavior. Then KVM would have to deal with not breaking such
> userspace.
> 
> Simplify KVM's job by preventing userspace from configuring any unsupported
> CPUID feature bits.
> 
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> uAPI breakout v1:
>  - New patch
> ---
>  arch/x86/kvm/vmx/tdx.c | 25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index c6bfeb0b3cc9..d45b4f7b69ba 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1086,8 +1086,9 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
>  	return ret;
>  }
>  
> -static int __maybe_unused tdx_get_kvm_supported_cpuid(struct kvm_cpuid2 **cpuid)
> +static int tdx_get_kvm_supported_cpuid(struct kvm_cpuid2 **cpuid)

This func is already used in patch #21, put the change in that patch.

>  {
> +

remove the blank line.

>  	int r;

Thanks,
Yilun

