Return-Path: <kvm+bounces-40136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6B7DA4F794
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 08:04:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 984E8188CBD2
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 07:04:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CDA11EA7F8;
	Wed,  5 Mar 2025 07:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DKsr/oAB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154D51C5F13
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 07:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741158230; cv=none; b=TohVKWjU4uVUv3CwC6Iqa7kdofOHlVu9T8jdVufDYBBfcePPKm7UYBpSBUEe6JL8WH6yHgNyOkSJkFxeSOl10I9/ZSQyqx6vmKhOr62P+S7LShqSngL5mJYqblkZB3JxSnS3Un6Dun8XbjJBfmGzCTArJ2szUdUSfAEFrXN7/ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741158230; c=relaxed/simple;
	bh=8jzrqTqhnifkrDyJTtW4igiWDfZ+eSKjlbRZVYBx39w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kg/Y0y94akWIEZ/9M9vFNt5Bbb7YnyVMPwb5BHaF7UIlx/6dGnqJFcSfUinTD/jaB43BPKWV7D3K9JJCzH37eC+epdhlG4bjYJPKSiKG/K1H1GsUwPOtYydlK7ghiNRcblqcay4mdDMtWg8rHu+7tIDv4R6wEe5PpB8A4uM0ouQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DKsr/oAB; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741158229; x=1772694229;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8jzrqTqhnifkrDyJTtW4igiWDfZ+eSKjlbRZVYBx39w=;
  b=DKsr/oABCKh1zI/IQQmfGiEfIKwiPVviZWCqWxyCav/kKGdpEEj6GoLq
   Ximz1mNph7Ez+lQi0MDSdoT0sH1DnUqx+KF4AOz3vFtxpUt8D+mRbysor
   lmyCHeJBHoOBJYQNv4vClOODdMVr8rJoJ5YdL40WGPqemtLWet1hZxQMq
   pwGLeirBM4sl4EnSySD49nUHj1Sbufe9o6PO044dkay3WlRYPP7aa7eya
   LYzYMKnOzSHT4vYosqNrsjjPt5VsVdIgTLUzXwnDP4OeYuN8nkrMqtEGv
   N15/b258Ev0hVF1WN+HpdrLzBwWciUYEBkzVIvC6CvpE8veXfMiW5WMO8
   A==;
X-CSE-ConnectionGUID: UV5zbQq7S1mJQnBthAb2/w==
X-CSE-MsgGUID: J3s8KwWgRUSCGnp2R46Frw==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="41965851"
X-IronPort-AV: E=Sophos;i="6.14,222,1736841600"; 
   d="scan'208";a="41965851"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 23:03:48 -0800
X-CSE-ConnectionGUID: 9xVNrOErS1+czG8AUsdpxw==
X-CSE-MsgGUID: gJ77evYTTHyiJK2c6J45sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="155794923"
Received: from unknown (HELO [10.238.2.135]) ([10.238.2.135])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 23:03:44 -0800
Message-ID: <7a6ec4ef-500f-491a-aba9-bf013b1058da@linux.intel.com>
Date: Wed, 5 Mar 2025 15:03:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/10] target/i386/kvm: extract unrelated code out of
 kvm_x86_build_cpuid()
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
 khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-6-dongli.zhang@oracle.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250302220112.17653-6-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 3/3/2025 6:00 AM, Dongli Zhang wrote:
> The initialization of 'has_architectural_pmu_version',
> 'num_architectural_pmu_gp_counters', and
> 'num_architectural_pmu_fixed_counters' is unrelated to the process of
> building the CPUID.
>
> Extract them out of kvm_x86_build_cpuid().
>
> No functional change.
>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>   - Still extract the code, but call them for all CPUs.
>
>  target/i386/kvm/kvm.c | 66 +++++++++++++++++++++++++------------------
>  1 file changed, 39 insertions(+), 27 deletions(-)
>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 5c8a852dbd..8f293ffd61 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -1959,33 +1959,6 @@ static uint32_t kvm_x86_build_cpuid(CPUX86State *env,
>          }
>      }
>  
> -    if (limit >= 0x0a) {
> -        uint32_t eax, edx;
> -
> -        cpu_x86_cpuid(env, 0x0a, 0, &eax, &unused, &unused, &edx);
> -
> -        has_architectural_pmu_version = eax & 0xff;
> -        if (has_architectural_pmu_version > 0) {
> -            num_architectural_pmu_gp_counters = (eax & 0xff00) >> 8;
> -
> -            /* Shouldn't be more than 32, since that's the number of bits
> -             * available in EBX to tell us _which_ counters are available.
> -             * Play it safe.
> -             */
> -            if (num_architectural_pmu_gp_counters > MAX_GP_COUNTERS) {
> -                num_architectural_pmu_gp_counters = MAX_GP_COUNTERS;
> -            }
> -
> -            if (has_architectural_pmu_version > 1) {
> -                num_architectural_pmu_fixed_counters = edx & 0x1f;
> -
> -                if (num_architectural_pmu_fixed_counters > MAX_FIXED_COUNTERS) {
> -                    num_architectural_pmu_fixed_counters = MAX_FIXED_COUNTERS;
> -                }
> -            }
> -        }
> -    }
> -
>      cpu_x86_cpuid(env, 0x80000000, 0, &limit, &unused, &unused, &unused);
>  
>      for (i = 0x80000000; i <= limit; i++) {
> @@ -2085,6 +2058,43 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>      return 0;
>  }
>  
> +static void kvm_init_pmu_info(CPUX86State *env)
> +{
> +    uint32_t eax, edx;
> +    uint32_t unused;
> +    uint32_t limit;
> +
> +    cpu_x86_cpuid(env, 0, 0, &limit, &unused, &unused, &unused);
> +
> +    if (limit < 0x0a) {
> +        return;
> +    }
> +
> +    cpu_x86_cpuid(env, 0x0a, 0, &eax, &unused, &unused, &edx);
> +
> +    has_architectural_pmu_version = eax & 0xff;
> +    if (has_architectural_pmu_version > 0) {
> +        num_architectural_pmu_gp_counters = (eax & 0xff00) >> 8;
> +
> +        /*
> +         * Shouldn't be more than 32, since that's the number of bits
> +         * available in EBX to tell us _which_ counters are available.
> +         * Play it safe.
> +         */
> +        if (num_architectural_pmu_gp_counters > MAX_GP_COUNTERS) {
> +            num_architectural_pmu_gp_counters = MAX_GP_COUNTERS;
> +        }
> +
> +        if (has_architectural_pmu_version > 1) {
> +            num_architectural_pmu_fixed_counters = edx & 0x1f;
> +
> +            if (num_architectural_pmu_fixed_counters > MAX_FIXED_COUNTERS) {
> +                num_architectural_pmu_fixed_counters = MAX_FIXED_COUNTERS;
> +            }
> +        }
> +    }
> +}
> +
>  int kvm_arch_init_vcpu(CPUState *cs)
>  {
>      struct {
> @@ -2267,6 +2277,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      cpuid_i = kvm_x86_build_cpuid(env, cpuid_data.entries, cpuid_i);
>      cpuid_data.cpuid.nent = cpuid_i;
>  
> +    kvm_init_pmu_info(env);
> +
>      if (((env->cpuid_version >> 8)&0xF) >= 6
>          && (env->features[FEAT_1_EDX] & (CPUID_MCE | CPUID_MCA)) ==
>             (CPUID_MCE | CPUID_MCA)) {

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



