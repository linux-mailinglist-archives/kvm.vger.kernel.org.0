Return-Path: <kvm+bounces-39842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 582BEA4B5E6
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 03:00:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EAB11890431
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 02:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5871B142E7C;
	Mon,  3 Mar 2025 01:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bR9ulhPj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B8A139CE3
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 01:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740967196; cv=none; b=bOI7I7Sv5JSswqMZ2jHzHoj5/bFLrOJECJ0jTUI2LQdOeWEJl1viUIvKotuKz/Spur/YikQSta8Dhhwo9jBjh9n16oLbaLpncaRWTXLC4EDCqaL7PSwbsd6sbu0TZdilmx7VT4ctUxBhlGcPNmvokieoeVVJN7F0s+HPuLX/yrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740967196; c=relaxed/simple;
	bh=b9QpLGmIQbZ2m/C2hiQDOvkUV1SQvurxkHtaCC5I4M8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S7OUhz7ixt0LEuh91czQPoRl92aZL41oyf3nvWncK1l3CSE7N92zlRZpNa86qS74GVj4WkCnywBc4ttBv/7bS661/wh4wS+dJ8AzH91B1JM5LgaIjSRwGXcIlfZUXzY+7oxB9RVaPHjrDzNzchTYK60Uiv1jVAada6BRYiuK3+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bR9ulhPj; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740967194; x=1772503194;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=b9QpLGmIQbZ2m/C2hiQDOvkUV1SQvurxkHtaCC5I4M8=;
  b=bR9ulhPjEcxpjQtn8+WGo1DQroD6iJv2msWmB5oatIB9DWjLlYzYBmje
   l0f5WySrPTN1HpsvkaUJw8XEm/H/SYj+Hj0QsWfo7MTE1wU7ITT5TI3xx
   v/un4dHxFE6kZIAouS/fWFeuTMEIvIEQT7Z4PGGzxVv7orueB4SMuYcX/
   QnaDHC6WRlbOlI6heO5dJaupE0syx14v+M2MBce/Npu6x0px6sausxN0L
   eDBfqGGY/6u5XfuqlpOdPyOlL4QAHthRcqISsleadyx64I5altOPU1RAY
   93B23s3vCMP+sjSaNl0JwXsh1LXJkZ0PjB5o+AE1wJI3qlE80zamMQOjO
   w==;
X-CSE-ConnectionGUID: RWcfQINCT9Cpq82D+ecCVg==
X-CSE-MsgGUID: plQkJsETSEiyzv4yniH8IQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="41073901"
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="41073901"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 17:59:54 -0800
X-CSE-ConnectionGUID: OOFxQS0NQDGoXCDVjGWcPg==
X-CSE-MsgGUID: RAp19QrkRou8c2hipeL4Ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="117720819"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 17:59:49 -0800
Message-ID: <99810e4f-f41d-4905-ae6d-1080b14fc8fd@intel.com>
Date: Mon, 3 Mar 2025 09:59:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/10] target/i386: disable PERFCORE when "-pmu" is
 configured
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
 khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, dapeng1.mi@linux.intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-3-dongli.zhang@oracle.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250302220112.17653-3-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/3/2025 6:00 AM, Dongli Zhang wrote:
> Currently, AMD PMU support isn't determined based on CPUID, that is, the
> "-pmu" option does not fully disable KVM AMD PMU virtualization.
> 
> To minimize AMD PMU features, remove PERFCORE when "-pmu" is configured.
> 
> To completely disable AMD PMU virtualization will be implemented via
> KVM_CAP_PMU_CAPABILITY in upcoming patches.
> 
> As a reminder, neither CPUID_EXT3_PERFCORE nor
> CPUID_8000_0022_EAX_PERFMON_V2 is removed from env->features[] when "-pmu"
> is configured. Developers should query whether they are supported via
> cpu_x86_cpuid() rather than relying on env->features[] in future patches.

I don't think it is the correct direction to go.

env->features[] should be finalized before cpu_x86_cpuid() and 
env->features[] needs to be able to be exposed to guest directly. This 
ensures guest and QEMU have the same view of CPUIDs and it simplifies 
things.

We can adjust env->features[] by filtering all PMU related CPUIDs based 
on cpu->enable_pmu in x86_cpu_realizefn().

> Suggested-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>   target/i386/cpu.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index b6d6167910..61a671028a 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -7115,6 +7115,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>               !(env->hflags & HF_LMA_MASK)) {
>               *edx &= ~CPUID_EXT2_SYSCALL;
>           }
> +
> +        if (kvm_enabled() && IS_AMD_CPU(env) && !cpu->enable_pmu) {
> +            *ecx &= ~CPUID_EXT3_PERFCORE;
> +        }
>           break;
>       case 0x80000002:
>       case 0x80000003:


