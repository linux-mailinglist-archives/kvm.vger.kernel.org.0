Return-Path: <kvm+bounces-24356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B69B19542CC
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 09:34:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2170EB23113
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 07:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 789A284E1E;
	Fri, 16 Aug 2024 07:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WJq2qbyZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC16153373;
	Fri, 16 Aug 2024 07:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723793643; cv=none; b=WYohY3FOSMFLuxNdfJJPzPjdDiCm64yBF+Kj+9DgpDNroMkhPl1WRE9cSnYZbmRzuOgJO+y37HjjMKQoj3MTWfke2KXC8UBF9mibgjTXjHLCrnV0ZfKEb/kCagWZzALBlImLo7DWkHZjMN3Fq7MJ+VgJZqcXUWk8Bis70/15b64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723793643; c=relaxed/simple;
	bh=v0xpFL4XYc738J6EYHKZuGeKAAXusJLOLz7ODR+WtBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R/FgZ1+8KqCsVxZb8tEjiEdej+6g/Pmxc5tbujFDfom79/cEwSTvxYI0Iw8I8XoFKL+Vixtify5lKMLV1oJM68zeuhXNUlqyEJrhTjC/fNE9hA0U4goaiIYyJ1ZQGzZlEX8l6z1YK2R1lf3I9SKQ1EwAujcHX5Ed+3pRT1TX8ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WJq2qbyZ; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723793641; x=1755329641;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v0xpFL4XYc738J6EYHKZuGeKAAXusJLOLz7ODR+WtBY=;
  b=WJq2qbyZFiBFQ2nR0pcAwYaDUmodeMlsB0S6Kl7lzoYHADsDLL7en7tE
   ldQMGVMSj7yH1J+BeaxoY66piEhIMB9kugyYfI8mMr35/9VV1JeFi949v
   ykHSV3V+ITOfois6TiX+PTYYketJFQMIlvACjMHMKIvzQykOormwqFj3O
   IcxPH/fboHcPZZl0EtocIFHwy7k40JH6pmvNgY9FfmGRv0LmV7rIjphxx
   o//1H66JLcJ3vM3pkKR5kqS9xZfupc+zKyPm32VZO2cO2RVKCsByJmcrp
   ebMZGMz+MBeSc33VSpfdq7if/fSQLjr+Iyie739Tmu2l3QDrjoXd08FWY
   w==;
X-CSE-ConnectionGUID: /RBGGrF1RvK5gl2edrs99Q==
X-CSE-MsgGUID: Z/H9PjtlRpeNdsdv5UpSVg==
X-IronPort-AV: E=McAfee;i="6700,10204,11165"; a="22226142"
X-IronPort-AV: E=Sophos;i="6.10,151,1719903600"; 
   d="scan'208";a="22226142"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2024 00:34:01 -0700
X-CSE-ConnectionGUID: YfA4fvU4Q3ijxKKJvMGlIQ==
X-CSE-MsgGUID: 3eksSZW9QICyAQQ15ElK5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,151,1719903600"; 
   d="scan'208";a="97109565"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Aug 2024 00:33:58 -0700
Date: Fri, 16 Aug 2024 15:31:46 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	kai.huang@intel.com, isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 13/25] KVM: TDX: create/destroy VM structure
Message-ID: <Zr8AYgZfInrwpAND@yilunxu-OptiPlex-7050>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-14-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812224820.34826-14-rick.p.edgecombe@intel.com>

> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 84cd9b4f90b5..a0954c3928e2 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -5,6 +5,7 @@
>  #include "x86_ops.h"
>  #include "mmu.h"
>  #include "tdx.h"
> +#include "tdx_ops.h"

I remember patch #4 says "C files should never include this header
directly"

  +++ b/arch/x86/kvm/vmx/tdx_ops.h
  @@ -0,0 +1,387 @@
  +/* SPDX-License-Identifier: GPL-2.0 */
  +/*
  + * Constants/data definitions for TDX SEAMCALLs
  + *
  + * This file is included by "tdx.h" after declarations of 'struct
  + * kvm_tdx' and 'struct vcpu_tdx'.  C file should never include
  + * this header directly.
  + */

maybe just remove it?

Thanks,
Yilun

