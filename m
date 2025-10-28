Return-Path: <kvm+bounces-61286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C812C13909
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 09:37:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE4ED3AC880
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 08:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6747129B8DC;
	Tue, 28 Oct 2025 08:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dEW0Yx5a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF5E12B94
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 08:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761640646; cv=none; b=e1hEcT0y8zHlowcXxzj0p4Kf0FezFMmULXHTKa+tRU7ystHcZ1/Mq16J7B+4qVA1Bez5kdpcl7GOlSMA1T07GFGYP8/rNT4eAD2M1Z9rElXcXn7Ui2Ujnrwjr7OSY675nIJObUDbf4QHgqWzvz4nUR9jqR2rivhnGUcJLTypHLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761640646; c=relaxed/simple;
	bh=co2V1dgs8SLXhRT4BPL7UibJYfxCY2w8waKe2/vtBNU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FHIuWWoH+/bsPcNpOJbcUee7EPxroF3iu2yLTAToLx9R/3wY/cQR+EGoI5U3WX/kj0BJQxfuhutH8+vI0YWaFadqvi64+VD2MgG+pKdsP8mJNlM4R7PARCUG69HEKFvPtP4vlA0sv99pqxJNEPaYkkRVSco+yQ8hqyjxFjvNqow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dEW0Yx5a; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761640645; x=1793176645;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=co2V1dgs8SLXhRT4BPL7UibJYfxCY2w8waKe2/vtBNU=;
  b=dEW0Yx5aKO1YrjSkzvu5wmIAE093Tdp1F52lfConvJbkrmRX/cdWAfI2
   WtjL0c9UQ6OIzuwqdZsN55l0qy1bBfsIHIJ5bGFD7gKXpD+07INPEI3IG
   ZhFdqijHKCNUZeORYbffiYw3JusscUSVmJ5PciagZviIfpWRMtby10Hkv
   rsjVxdtHav7RSBT28nSlZBXC70zfkDN8qj6cYQMr+DeGTXi7f/GVAXrtf
   Tehf6Qiw/T0L0CT51SNMWZ10EqIvWEAH0P/W3ohsNrFVYvk5mYGqxZzlB
   JQlT8vG1VcWkiuUUspcAXgmTRDmEN+3p4VtmioshVws4i8OVRIh5tGR6T
   A==;
X-CSE-ConnectionGUID: 3eJF1RokTK2RXpX5KbgkRA==
X-CSE-MsgGUID: 4FmSad24RXWQUNw6Xm/szw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63660961"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63660961"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 01:37:24 -0700
X-CSE-ConnectionGUID: ZRU4m7bWRrCnsSAzmsIbNw==
X-CSE-MsgGUID: qqGz4TWDSjuh+2wDbjj3dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="189342494"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 01:37:21 -0700
Message-ID: <a9bfdd50-14c8-4bb6-8031-9293f8c9d69d@intel.com>
Date: Tue, 28 Oct 2025 16:37:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/20] i386/tdx: Fix missing spaces in tdx_xfam_deps[]
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-20-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251024065632.1448606-20-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2025 2:56 PM, Zhao Liu wrote:
> The checkpatch.pl always complains: "ERROR: space required after that
> close brace '}'".
> 
> Fix this issue.
> 
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   target/i386/kvm/tdx.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index dbf0fa2c9180..a3444623657f 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -520,15 +520,15 @@ typedef struct TdxXFAMDep {
>    * supported.
>    */
>   TdxXFAMDep tdx_xfam_deps[] = {
> -    { XSTATE_YMM_BIT,       { FEAT_1_ECX, CPUID_EXT_FMA }},
> -    { XSTATE_YMM_BIT,       { FEAT_7_0_EBX, CPUID_7_0_EBX_AVX2 }},
> -    { XSTATE_OPMASK_BIT,    { FEAT_7_0_ECX, CPUID_7_0_ECX_AVX512_VBMI}},
> -    { XSTATE_OPMASK_BIT,    { FEAT_7_0_EDX, CPUID_7_0_EDX_AVX512_FP16}},
> -    { XSTATE_PT_BIT,        { FEAT_7_0_EBX, CPUID_7_0_EBX_INTEL_PT}},
> -    { XSTATE_PKRU_BIT,      { FEAT_7_0_ECX, CPUID_7_0_ECX_PKU}},
> -    { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_BF16 }},
> -    { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_TILE }},
> -    { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_INT8 }},
> +    { XSTATE_YMM_BIT,       { FEAT_1_ECX, CPUID_EXT_FMA } },
> +    { XSTATE_YMM_BIT,       { FEAT_7_0_EBX, CPUID_7_0_EBX_AVX2 } },
> +    { XSTATE_OPMASK_BIT,    { FEAT_7_0_ECX, CPUID_7_0_ECX_AVX512_VBMI } },
> +    { XSTATE_OPMASK_BIT,    { FEAT_7_0_EDX, CPUID_7_0_EDX_AVX512_FP16 } },
> +    { XSTATE_PT_BIT,        { FEAT_7_0_EBX, CPUID_7_0_EBX_INTEL_PT } },
> +    { XSTATE_PKRU_BIT,      { FEAT_7_0_ECX, CPUID_7_0_ECX_PKU } },
> +    { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_BF16 } },
> +    { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_TILE } },
> +    { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_INT8 } },
>   };
>   
>   static struct kvm_cpuid_entry2 *find_in_supported_entry(uint32_t function,


