Return-Path: <kvm+bounces-5123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6438781C57A
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 08:21:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21E1528973A
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 07:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C0E69470;
	Fri, 22 Dec 2023 07:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IK9WLh5I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3F69447
	for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 07:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703229680; x=1734765680;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pK3WW+nqVIcM8DBeFnUM4zM8MhK+l8HrrhOFOHvyfZc=;
  b=IK9WLh5IKE7eclMcPNlD7yKM0EH757LBoAcM1i0+Yka5M/AcpFM8afEj
   75Iqtfbcn+MJ7G3WE9d79NIvS9R8Yz0ttjNinmKsfnCwk/csNlnJ/7VsY
   ZG9Nz0LussVNCZcugY7eo5K09K2izjoa0zKMVSli0xobxvJdf2pbJ5sGg
   zPY5nm4bZE3Dik5EDXORU3WSi1iF111xdsO3jznOQUkHQZTIalE3uTR0L
   hBirMsngo77E29dRhgQQ+sDUaqn+3+GmVD65da0mJlzUltZcvvIhWDtLB
   ihlDluhwteEF6e2qdgXJd5fcMvH3dXcLbFmxoYOnMpkKM7gAPsK0SaN8L
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10931"; a="460417480"
X-IronPort-AV: E=Sophos;i="6.04,294,1695711600"; 
   d="scan'208";a="460417480"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 23:21:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,294,1695711600"; 
   d="scan'208";a="18957608"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 21 Dec 2023 23:21:16 -0800
Date: Fri, 22 Dec 2023 15:34:02 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Xin Li <xin3.li@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	richard.henderson@linaro.org, pbonzini@redhat.com,
	eduardo@habkost.net, seanjc@google.com, chao.gao@intel.com,
	hpa@zytor.com, xiaoyao.li@intel.com, weijiang.yang@intel.com,
	dan1.wu@intel.com
Subject: Re: [PATCH v3A 1/6] target/i386: add support for FRED in CPUID
 enumeration
Message-ID: <ZYU76ipTvj1WIBgm@intel.com>
References: <MW4PR11MB6737DC0CCD50B5D3D00521A7A895A@MW4PR11MB6737.namprd11.prod.outlook.com>
 <20231222030336.38096-1-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231222030336.38096-1-xin3.li@intel.com>

On Thu, Dec 21, 2023 at 07:03:36PM -0800, Xin Li wrote:
> Date: Thu, 21 Dec 2023 19:03:36 -0800
> From: Xin Li <xin3.li@intel.com>
> Subject: [PATCH v3A 1/6] target/i386: add support for FRED in CPUID
>  enumeration
> X-Mailer: git-send-email 2.43.0
> 
> FRED, i.e., the Intel flexible return and event delivery architecture,
> defines simple new transitions that change privilege level (ring
> transitions).
> 
> The new transitions defined by the FRED architecture are FRED event
> delivery and, for returning from events, two FRED return instructions.
> FRED event delivery can effect a transition from ring 3 to ring 0, but
> it is used also to deliver events incident to ring 0.  One FRED
> instruction (ERETU) effects a return from ring 0 to ring 3, while the
> other (ERETS) returns while remaining in ring 0.  Collectively, FRED
> event delivery and the FRED return instructions are FRED transitions.
> 
> In addition to these transitions, the FRED architecture defines a new
> instruction (LKGS) for managing the state of the GS segment register.
> The LKGS instruction can be used by 64-bit operating systems that do
> not use the new FRED transitions.
> 
> WRMSRNS is an instruction that behaves exactly like WRMSR, with the
> only difference being that it is not a serializing instruction by
> default.  Under certain conditions, WRMSRNS may replace WRMSR to improve
> performance.  FRED uses it to switch RSP0 in a faster manner.
> 
> Search for the latest FRED spec in most search engines with this search
> pattern:
> 
>   site:intel.com FRED (flexible return and event delivery) specification
> 
> The CPUID feature flag CPUID.(EAX=7,ECX=1):EAX[17] enumerates FRED, and
> the CPUID feature flag CPUID.(EAX=7,ECX=1):EAX[18] enumerates LKGS, and
> the CPUID feature flag CPUID.(EAX=7,ECX=1):EAX[19] enumerates WRMSRNS.
> 
> Add CPUID definitions for FRED/LKGS/WRMSRNS, and expose them to KVM guests.
> 
> Because FRED relies on LKGS and WRMSRNS, add that to feature dependency
> map.
> 
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>

> 
> Changelog
> v3A:
> - Fix reversed dependency (Wu Dan1).
> ---
>  target/i386/cpu.c | 10 +++++++++-
>  target/i386/cpu.h |  6 ++++++
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 358d9c0a65..66551c7eae 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -965,7 +965,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>              "avx-vnni", "avx512-bf16", NULL, "cmpccxadd",
>              NULL, NULL, "fzrm", "fsrs",
>              "fsrc", NULL, NULL, NULL,
> -            NULL, NULL, NULL, NULL,
> +            NULL, "fred", "lkgs", "wrmsrns",
>              NULL, "amx-fp16", NULL, "avx-ifma",
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,
> @@ -1552,6 +1552,14 @@ static FeatureDep feature_dependencies[] = {
>          .from = { FEAT_VMX_SECONDARY_CTLS,  VMX_SECONDARY_EXEC_ENABLE_USER_WAIT_PAUSE },
>          .to = { FEAT_7_0_ECX,               CPUID_7_0_ECX_WAITPKG },
>      },
> +    {
> +        .from = { FEAT_7_1_EAX,             CPUID_7_1_EAX_LKGS },
> +        .to = { FEAT_7_1_EAX,               CPUID_7_1_EAX_FRED },
> +    },
> +    {
> +        .from = { FEAT_7_1_EAX,             CPUID_7_1_EAX_WRMSRNS },
> +        .to = { FEAT_7_1_EAX,               CPUID_7_1_EAX_FRED },
> +    },
>  };
>  
>  typedef struct X86RegisterInfo32 {
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index cd2e295bd6..5faf00551d 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -934,6 +934,12 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
>  #define CPUID_7_1_EDX_AMX_COMPLEX       (1U << 8)
>  /* PREFETCHIT0/1 Instructions */
>  #define CPUID_7_1_EDX_PREFETCHITI       (1U << 14)
> +/* Flexible return and event delivery (FRED) */
> +#define CPUID_7_1_EAX_FRED              (1U << 17)
> +/* Load into IA32_KERNEL_GS_BASE (LKGS) */
> +#define CPUID_7_1_EAX_LKGS              (1U << 18)
> +/* Non-Serializing Write to Model Specific Register (WRMSRNS) */
> +#define CPUID_7_1_EAX_WRMSRNS           (1U << 19)
>  
>  /* Do not exhibit MXCSR Configuration Dependent Timing (MCDT) behavior */
>  #define CPUID_7_2_EDX_MCDT_NO           (1U << 5)
> -- 
> 2.43.0
> 
> 

