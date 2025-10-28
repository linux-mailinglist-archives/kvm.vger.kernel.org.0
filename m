Return-Path: <kvm+bounces-61287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5478C13A82
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 09:59:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDA59188B163
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 08:56:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 120662D7DF4;
	Tue, 28 Oct 2025 08:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KwSpsywC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F47F2BE029
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 08:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761641734; cv=none; b=J6Kw5ZXp6JoWZD4L4WhJiIufl7yYvCibdNj2wVEQ73eWfyF+iAakiRXuqzTWExE8yurBA5scRuXb//OFkyYIu67tP+kQLOJ+qkHA2jKM8OMu6qf9t2tBUZMAdF/Cp4rArbs7/Xpp1ZBMdrzbeEcg/rxtqxtXznsYSU3z1g/OaRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761641734; c=relaxed/simple;
	bh=LDkly6JAWl+jNWu68ElLZLMn4bAcPr46JUM/YlHZDEM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tGNP2fjj5dG4s02cTQWElobG7r3+ccRuVuypGi/fOJ9iXi2DaHkl3FhPyT4VZQLzk7kuBxMYuXYqUTGf2ZPZ2y4y3yBW+tv/zVnYSXlXy+t6ZB1bTeQZvF8sacU4nE3oVf+cP0JbgzTKKEtjKqdoBt/2Ju5Ga3JOEhgxQ4z0C/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KwSpsywC; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761641733; x=1793177733;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LDkly6JAWl+jNWu68ElLZLMn4bAcPr46JUM/YlHZDEM=;
  b=KwSpsywCKl2aGJme3sE0gyMVdShvKCTw6GfQaSek9CEDWpQ5HuppAmdj
   3vtlJakXe13SYJpPvd9WGwZBhRQ4MK+gF1bcQ9Xr2PjAqNBFsgvG94pqO
   Yi41yLvkOBNIjHB1iq/MezM4wHPC0FN1Q3RJMPLuhYA57N3Qf/hgWmIa5
   i0fWsK73BKe1dE6oOVoBo3lh9qqnu9MWzh2t6/2xJGA+vXqEM1evBcyDt
   TjMPrpDpTxavU0/xh/MIqK12F7Aw1dIoKBtsR0kc5q8AMMLcC9DHkOak7
   +sjzW9bdzeiR+uAKg/dmLwaal+0B9iSg0Y+nmedFp9tSrGglVNAkgVGgs
   A==;
X-CSE-ConnectionGUID: eovW5H16ROePC+JXhkgH3g==
X-CSE-MsgGUID: HVPBVUzmSDap+r258TeQFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="81366132"
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="81366132"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 01:55:32 -0700
X-CSE-ConnectionGUID: Gooqyu1mSvqm+npkSCoOvA==
X-CSE-MsgGUID: 4/64+YRuQBqbi7MTw9YwmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="189345914"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 01:55:29 -0700
Message-ID: <ea4ff407-b5ee-4649-b5cd-82b626dca3ee@intel.com>
Date: Tue, 28 Oct 2025 16:55:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 20/20] i386/tdx: Add CET SHSTK/IBT into the supported
 CPUID by XFAM
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-21-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251024065632.1448606-21-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2025 2:56 PM, Zhao Liu wrote:
> From: Chenyi Qiang <chenyi.qiang@intel.com>
> 
> So that it can be configured in TD guest.
> 
> And considerring cet-u and cet-s have the same dependencies, it's enough
> to only list cet-u in tdx_xfam_deps[].

In fact, this is not the reason.

The reason is that CET_U and CET_S bits are always same in supported 
XFAM reported by TDX module, i.e., either 00 or 11. So, we only need to 
choose one of them.

> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

With commit message updated,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   target/i386/kvm/tdx.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index a3444623657f..01619857685b 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -526,6 +526,8 @@ TdxXFAMDep tdx_xfam_deps[] = {
>       { XSTATE_OPMASK_BIT,    { FEAT_7_0_EDX, CPUID_7_0_EDX_AVX512_FP16 } },
>       { XSTATE_PT_BIT,        { FEAT_7_0_EBX, CPUID_7_0_EBX_INTEL_PT } },
>       { XSTATE_PKRU_BIT,      { FEAT_7_0_ECX, CPUID_7_0_ECX_PKU } },
> +    { XSTATE_CET_U_BIT,     { FEAT_7_0_ECX, CPUID_7_0_ECX_CET_SHSTK } },
> +    { XSTATE_CET_U_BIT,     { FEAT_7_0_EDX, CPUID_7_0_EDX_CET_IBT } },
>       { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_BF16 } },
>       { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_TILE } },
>       { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_INT8 } },


