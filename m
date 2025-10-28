Return-Path: <kvm+bounces-61282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA55C13867
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 09:25:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D02093A7F7D
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 08:22:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 620882D8395;
	Tue, 28 Oct 2025 08:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IgX8Dabh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8B035B13C
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 08:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761639725; cv=none; b=CRKvrAfjHo8mspTkBYUbS9T2WxAR33gz5VMQYV4zc8xRVSJQIDM/cLpOdosgV5R7dVSTG5JmcEj4+tbzVTW8EaG/6ZeBBPBJFiHeRdSWr0hXMgVNUtPaIRj7+g2ox5pUYXTGAAM+5aWbQUlXRc/9KBPb0s9XvjmcN+NjHju7JgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761639725; c=relaxed/simple;
	bh=dY2iVd/Mn+6MsIGW/ZBQhZZVDr9eenfNUId7Aq8nd1o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E1OyekX3W3vV2JOZq8AQEeqXGQpnO6WVUXKLIF217LpYS4Rrkwlq4vZWzE7lx4MvooIulVNxFNNtQqk/i0x4a1ils00fvfECNOtMbVmZ2B324EoMKv1pfdKXDfeMsHWVK24k4CvIP3XcIa54rckqG1Kwuy5FXtWMvSYGbKljOEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IgX8Dabh; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761639724; x=1793175724;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dY2iVd/Mn+6MsIGW/ZBQhZZVDr9eenfNUId7Aq8nd1o=;
  b=IgX8DabhdIu2WnPJ3ZmgICYMTPzEJV4QP4htCOrjoJlQGOZsI0YD9Krr
   NKfXdRQXbLaWI1NIpE68B08MgIfRYqK9CtVxnRZhphoOmtGtcs0znGBWr
   7E/EN8vCZiw9u5GHDBLjWJ69992sVQ0J3cAiIdwmE/MvkSyBGmTDUUOZI
   g+ON9b7fyS/XMuyxqk4gAevnnczlxSRzihgV0cvVwzTxri6RvCl4pyTkt
   QfQ7Psb4lWahl3BUgo941+9viPjbP4sb4Yd/dUvctCQ/jUfbxuUke3/ob
   al5KpjvzF2J+Sk7LZaZPhS5d2YwHF/PC2JBAp+Mqhx8FE0y+7tUy2hE5U
   w==;
X-CSE-ConnectionGUID: s/d1RrhdR6yzR0EHK8a3rQ==
X-CSE-MsgGUID: mA4EsaMgRIO6evuMPfKwYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63827423"
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="63827423"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 01:22:03 -0700
X-CSE-ConnectionGUID: Lhk7nHssRn+H6jBPTXySuw==
X-CSE-MsgGUID: 8+Aw1TbUSNS84gBW9effLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="189338684"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 01:21:59 -0700
Message-ID: <9c5d49a8-c049-4ab0-bd0a-cc24dbee93f4@intel.com>
Date: Tue, 28 Oct 2025 16:21:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/20] i386/kvm: Add save/load support for
 KVM_REG_GUEST_SSP
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>,
 Yang Weijiang <weijiang.yang@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-15-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251024065632.1448606-15-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2025 2:56 PM, Zhao Liu wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> CET provides a new architectural register, shadow stack pointer (SSP),
> which cannot be directly encoded as a source, destination or memory
> operand in instructions. But Intel VMCS & VMCB provide fields to
> save/load guest & host's ssp.
> 
> It's necessary to save & load Guest's ssp before & after migration. To
> support this, KVM implements Guest's SSP as a special KVM internal
> register - KVM_REG_GUEST_SSP, and allows QEMU to save & load it via
> KVM_GET_ONE_REG/KVM_SET_ONE_REG.
> 
> Cache KVM_REG_GUEST_SSP in X86CPUState.
> 
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Co-developed-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   target/i386/cpu.h     |  1 +
>   target/i386/kvm/kvm.c | 39 +++++++++++++++++++++++++++++++++++++++
>   2 files changed, 40 insertions(+)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 4edb977575e2..ad4287822831 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2105,6 +2105,7 @@ typedef struct CPUArchState {
>       uint64_t pl2_ssp;
>       uint64_t pl3_ssp;
>       uint64_t int_ssp_table;
> +    uint64_t guest_ssp;
>   
>       /* Fields up to this point are cleared by a CPU reset */
>       struct {} end_reset_fields;
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 92c2fd6d6aee..412e99ba5b53 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -4280,6 +4280,35 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
>       return kvm_buf_set_msrs(cpu);
>   }
>   
> +static int kvm_put_kvm_regs(X86CPU *cpu)
> +{
> +    CPUX86State *env = &cpu->env;
> +    int ret;
> +
> +    if ((env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK)) {
> +        ret = kvm_set_one_reg(CPU(cpu), KVM_X86_REG_KVM(KVM_REG_GUEST_SSP),
> +                              &env->guest_ssp);
> +        if (ret) {
> +            return ret;
> +        }
> +    }
> +    return 0;
> +}
> +
> +static int kvm_get_kvm_regs(X86CPU *cpu)
> +{
> +    CPUX86State *env = &cpu->env;
> +    int ret;
> +
> +    if ((env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK)) {
> +        ret = kvm_get_one_reg(CPU(cpu), KVM_X86_REG_KVM(KVM_REG_GUEST_SSP),
> +                              &env->guest_ssp);
> +        if (ret) {
> +            return ret;
> +        }
> +    }
> +    return 0;
> +}
>   
>   static int kvm_get_xsave(X86CPU *cpu)
>   {
> @@ -5425,6 +5454,11 @@ int kvm_arch_put_registers(CPUState *cpu, KvmPutState level, Error **errp)
>           error_setg_errno(errp, -ret, "Failed to set MSRs");
>           return ret;
>       }
> +    ret = kvm_put_kvm_regs(x86_cpu);
> +    if (ret < 0) {
> +        error_setg_errno(errp, -ret, "Failed to set KVM type registers");
> +        return ret;
> +    }
>       ret = kvm_put_vcpu_events(x86_cpu, level);
>       if (ret < 0) {
>           error_setg_errno(errp, -ret, "Failed to set vCPU events");
> @@ -5497,6 +5531,11 @@ int kvm_arch_get_registers(CPUState *cs, Error **errp)
>           error_setg_errno(errp, -ret, "Failed to get MSRs");
>           goto out;
>       }
> +    ret = kvm_get_kvm_regs(cpu);
> +    if (ret < 0) {
> +        error_setg_errno(errp, -ret, "Failed to get KVM type registers");
> +        goto out;
> +    }
>       ret = kvm_get_apic(cpu);
>       if (ret < 0) {
>           error_setg_errno(errp, -ret, "Failed to get APIC");


