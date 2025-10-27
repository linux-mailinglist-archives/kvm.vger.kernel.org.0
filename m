Return-Path: <kvm+bounces-61140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E22C0C0C31E
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 08:53:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EBD918988B0
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 07:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1ECE2E540D;
	Mon, 27 Oct 2025 07:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZS3tOPcO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB422E4278
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 07:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761551515; cv=none; b=WQRT+h5uQsTmlf5Yvumzru7NjzJHt0867Hon23uh74Zoo1suXg7vzFDmuapi/kmtXl4g64SnSJJWmpOJEixHSKvkVK9FdWMUL6CnUcB5umR/bcglrbMX5H285Qm6b0Tgq6lPPlW1mJnzz+0RuRvpQuJUXdDnfMFzIBWs06u6oQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761551515; c=relaxed/simple;
	bh=hUssZkK1Y/cmoggTCHRLo6w9ZYPSDnuXfS58DzvKqDY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aaBM39gXm/15xs/lqzcVoXy95tjw9HEuJtpFXg8efMYwoV3YMeUN34at9BzsZmSCA1YtNbRGUtvQEIn4mqBIfj+D+4gcmTuuDOhlVPWFSH+2jCVBo17WGySlM0/mhVE5K2LpYSa9qyj4ZgbEmSrjtaSv7NQOwGMGHEItdHJhZhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZS3tOPcO; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761551514; x=1793087514;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hUssZkK1Y/cmoggTCHRLo6w9ZYPSDnuXfS58DzvKqDY=;
  b=ZS3tOPcOQ6s/h/nzHoOJNVO3xzu/J4/mongHT2BvAmNMt0O9b8ECRc72
   P4AYksmgzWH5ePq5DJB1QmxShX5S7BsTznyxHmZyfuUB9g5QA5mWruL0I
   G3WspAVtNrYaWy6uQQkaQCD+g0+QdAuzXvRwlFge1T7yOElgUo3hTrjbx
   mns+8qJfZeYb7/fvjN8VaiwezZ+9KAs7VxeGHijDKoWobZDD+gD5GPsKc
   Dwlao8xVjdOhPuhOBg7S9cEBHVv9m9SHmrzbpkUIvFMeVw05IZi9rrXdZ
   iinmenb8ORX99jqkEIexLki76cjFJqgBSX8cF5sLNBFH1DCI8rB1FWpOU
   Q==;
X-CSE-ConnectionGUID: lJKTwWxUQK6kkRz4Lb/8BQ==
X-CSE-MsgGUID: H6Ff6LucQyWSrkMkgpiOGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63660380"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="63660380"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 00:51:54 -0700
X-CSE-ConnectionGUID: 08A+90eYQHyYkn7tvbED7Q==
X-CSE-MsgGUID: 8q10nxgbRaePCOXum/LZyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="184593865"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 00:51:50 -0700
Message-ID: <ab59bf10-3d16-4c34-b87d-31002fe83142@intel.com>
Date: Mon, 27 Oct 2025 15:51:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/20] i386/cpu: Drop pmu check in CPUID 0x1C encoding
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-9-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251024065632.1448606-9-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2025 2:56 PM, Zhao Liu wrote:
> Since CPUID_7_0_EDX_ARCH_LBR will be masked off if pmu is disabled,
> there's no need to check CPUID_7_0_EDX_ARCH_LBR feature with pmu.
> 
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   target/i386/cpu.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 5b7a81fcdb1b..5cd335bb5574 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -8275,11 +8275,16 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>           }
>           break;
>       }
> -    case 0x1C:
> -        if (cpu->enable_pmu && (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
> -            x86_cpu_get_supported_cpuid(0x1C, 0, eax, ebx, ecx, edx);
> -            *edx = 0;
> +    case 0x1C: /* Last Branch Records Information Leaf */
> +        *eax = 0;
> +        *ebx = 0;
> +        *ecx = 0;
> +        *edx = 0;

Could you help write a patch to move the initialization-to-0 operation 
out to the switch() handling as the common first handling. So that each 
case doesn't need to set them to 0 individually.

> +        if (!(env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
> +            break;
>           }
> +        x86_cpu_get_supported_cpuid(0x1C, 0, eax, ebx, ecx, edx);
> +        *edx = 0; /* EDX is reserved. */

Not the fault of this series. I think just presenting what KVM returns 
to guest (i.e., directly passthrough) isn't correct. Once leaf 0x1c gets 
more bits defined and KVM starts to support and report them, then the 
bits presented to guest get changed automatically between different KVM.

the leaf 0x1c needs to be configurable and QEMU needs to ensure the same 
configuration outputs the constant result of leaf 0x1c, to ensure safe 
migration.

It's not urgent though. KVM doesn't even support ArchLBR yet.

>           break;
>       case 0x1D: {
>           /* AMX TILE, for now hardcoded for Sapphire Rapids*/


