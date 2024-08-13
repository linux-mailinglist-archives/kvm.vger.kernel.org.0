Return-Path: <kvm+bounces-24036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 650D6950A4F
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 18:38:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2250A28608A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97BDF1A3BA7;
	Tue, 13 Aug 2024 16:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dI2IPeWv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77A81A38E1;
	Tue, 13 Aug 2024 16:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723567030; cv=none; b=Hb1CrmF+kLtpqUst+Y10Pb2rGc2q08dEdG7Huf0GGPQgiJVev6V2+hFXHHzyV5QGBDh6HIH7AKPwstUTFCKZskIYpaJlBkdmfTcLtkieXMCwqx24LdYJ1t7NsQg62ezgHNooGowxw975Zwl5y2uTtXSzghwfCiBU2uo1dxV3EZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723567030; c=relaxed/simple;
	bh=F6PmJTcNjMgkxoGvRipMb/nAIqzz/EaTDWCXyqvUIpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OxnH4glyEMXImDAdibmNjmnItqH9pak8xzu8jz5AehUbx0vnpMlKjvgDpbfKM3jK/rrkMsNNru08QSyTAdsshYaSalP3t9iOKKuwbDd6nl2xQD3ox6xyRWZPlvGdXDz+LwKUv6t7Abdhw1+c4F976zfJs+YAVaul1/IlDRVOaGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dI2IPeWv; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723567029; x=1755103029;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F6PmJTcNjMgkxoGvRipMb/nAIqzz/EaTDWCXyqvUIpk=;
  b=dI2IPeWvkHTrnLuprsIaPw2ww4WDiEs7XDCfLGByUsU00I8yWy32IwL+
   CdZXrGud6je//O10eMzflTZ6EAQXHAMGpe9VONbPzssjtERmVv8DcgWW+
   58Os4xoaMxETtWngM6hSZyKilVXlzOOBw+ZiPF0uJSvGJVzK0EKm6okuC
   KtY8RYDUf/Rx3XpMHZAs/Nfpg6nuraVzuApQ+hyVUhp0+HtcPbfA1Ug2W
   uap1MsKCiu5i8UwKqavysSr+myN56YrL0lrFkpNMDT1WdgGQhhW7myu2p
   da2vRt7n5hqEFfmVWudirhPwswrVt9cral/DgNyOvK8zM//U8WREfZF+p
   w==;
X-CSE-ConnectionGUID: AACrBYR4SOq3sGNqFLR0rA==
X-CSE-MsgGUID: pdrpc5yOSSGouEJ9aNJ0Zw==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="21557516"
X-IronPort-AV: E=Sophos;i="6.09,286,1716274800"; 
   d="scan'208";a="21557516"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 09:37:08 -0700
X-CSE-ConnectionGUID: aXp4lvX+SzyhGRt9EZVr9Q==
X-CSE-MsgGUID: K3HPE/v4SkSvkFO9qVD/oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,286,1716274800"; 
   d="scan'208";a="63563164"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 09:37:07 -0700
Date: Tue, 13 Aug 2024 09:37:07 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	kai.huang@intel.com, isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH 08/25] KVM: TDX: Add place holder for TDX VM specific
 mem_enc_op ioctl
Message-ID: <ZruLs4+EE5xHCAcp@ls.amr.corp.intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-9-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240812224820.34826-9-rick.p.edgecombe@intel.com>

On Mon, Aug 12, 2024 at 03:48:03PM -0700,
Rick Edgecombe <rick.p.edgecombe@intel.com> wrote:

> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b1c885ce8c9c..de14e80d8f3a 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2,6 +2,7 @@
>  #include <linux/cpu.h>
>  #include <asm/tdx.h>
>  #include "capabilities.h"
> +#include "x86_ops.h"
>  #include "tdx.h"
>  
>  #undef pr_fmt
> @@ -29,6 +30,37 @@ static void __used tdx_guest_keyid_free(int keyid)
>  	ida_free(&tdx_guest_keyid_pool, keyid);
>  }
>  
> +int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
> +{
> +	struct kvm_tdx_cmd tdx_cmd;
> +	int r;
> +
> +	if (copy_from_user(&tdx_cmd, argp, sizeof(struct kvm_tdx_cmd)))
> +		return -EFAULT;
> +
> +	/*
> +	 * Userspace should never set @error. It is used to fill

nitpick: @hw_error

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

