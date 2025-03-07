Return-Path: <kvm+bounces-40385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4E22A570B8
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:41:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8CE83B789D
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 18:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CCA4241CA2;
	Fri,  7 Mar 2025 18:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mfh2kqgA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E92219E98;
	Fri,  7 Mar 2025 18:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741372888; cv=none; b=EYdd4Q0J65zkCibgRIAAkDIHs6ijDSLVehTNYjHl7VMr++V+wg67syUEXblrp8grX8pU1fZnNS46y0AygrJTBsiuiw9ZLvVUj7Lm5ObAs/KLGrHVuwMnfgxPVx5J9AbTKdS3ozQibFm8P7PSxY3rGlhLNVPCDNFIG4BBj0T9DfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741372888; c=relaxed/simple;
	bh=gty8PqZgqe7OpYUmvh89+QW9b9WDHvBIJHRemJ0a4RY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rVOXU3FGVE8cL+ySxsdgy4DT2StbUZoDROjFjcePNffR9aFCrkHDrEUvKZnrkqAMSIwNiVlWqK2ZTnudGf2aaQLM4Jrl3XkFsV8N/CSQF5pIFFc46WUj+vSqZnDcOfyxsbEV7c8/5lPWJTTLUunpQV586aFrQCHaYi03779wiuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mfh2kqgA; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741372887; x=1772908887;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gty8PqZgqe7OpYUmvh89+QW9b9WDHvBIJHRemJ0a4RY=;
  b=Mfh2kqgABj4RKlTuROa26UpjaAKA2gU0cw9Hm02uFLD08q463ZEeyraS
   kWJgLiKRirYeWipJGMK+zj1T78A89Ch1ZCIxg0Z/J71B47gfWTL+vDo3N
   dICvgFJk9zC63/gOOMAf6mRZwxa9cWJf6NRlZcfVbZ2MVjfvVR7BSdMVR
   yaEyCt6YvmJb3IPrFHNLvY8dw/y+MvvxznVJPidFIS0TC1kEHkzd+ij7O
   eHhLbNnnB6DBvrdLBvWxH5obrc0I43eEaF7vQTiTQALWJ2KExZ0xI5UJw
   RKrCaJVEipODswKegHQ8NankfLKXtbNLoaqP1X0JFH9KmXH6yScduFdhT
   g==;
X-CSE-ConnectionGUID: fyrqlwKYQ4euidvpoJn7Mg==
X-CSE-MsgGUID: o3FUuQiITpuHEWUU7vwknQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="46357002"
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="46357002"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 10:41:26 -0800
X-CSE-ConnectionGUID: zrwdQHN7Tf+i1POGddtPVw==
X-CSE-MsgGUID: R/OL9BOmQ4+4JjC8pabv6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="119337812"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.110.132]) ([10.125.110.132])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 10:41:26 -0800
Message-ID: <98dda94f-b805-4e0e-871a-085eb2f6ff20@intel.com>
Date: Fri, 7 Mar 2025 10:41:49 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] x86/fpu/xstate: Initialize guest fpstate with
 fpu_guest_config
To: Chao Gao <chao.gao@intel.com>, tglx@linutronix.de, x86@kernel.org,
 seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: peterz@infradead.org, rick.p.edgecombe@intel.com,
 weijiang.yang@intel.com, john.allen@amd.com, bp@alien8.de,
 Maxim Levitsky <mlevitsk@redhat.com>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-8-chao.gao@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250307164123.1613414-8-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/7/25 08:41, Chao Gao wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Use fpu_guest_cfg to initialize the guest fpstate and the guest FPU pseduo
> container.
> 
> The user_* fields remain unchanged for compatibility with KVM uAPIs.
> 
> Inline the logic of __fpstate_reset() to directly utilize fpu_guest_cfg.

Why? Seriously, why? Why would you just inline it? Could you please
revisit the moment when you decided to do this? Please go back to that
moment and try to unlearn whatever propensity you have for taking this path.

There are two choices: make the existing function work for guests, or
add a new guest-only reset function.

Just an an example:

static void __fpstate_reset(struct fpstate *fpstate,
			    struct fpu_state_config *kernel_cfg,
			    u64 xfd)
{
        /* Initialize sizes and feature masks */
        fpstate->size           = kernel_cfg->default_size;
        fpstate->xfeatures      = kernel_cfg->default_features;

	/* Some comment about why user states don't vary */
        fpstate->user_size      = fpu_user_cfg.default_size;
        fpstate->user_xfeatures = fpu_user_cfg.default_features;

        fpstate->xfd            = xfd;
}

Then you have two call sites:

	__fpstate_reset(fpstate, &fpu_guest_cfg, 0);
and
	__fpstate_reset(fpu->fpstate, &fpu_kernel_cfg,
		        init_fpstate.xfd);

What does this tell you?

It clearly lays out that to reset an fpstate, you need a specific kernel
config. That kernel config is (can be) different for guests.

Refactoring the code as you go along is not optional. It's a requirement.


