Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365BC7CE055
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 16:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbjJROrJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 10:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjJROrH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 10:47:07 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6875AB;
        Wed, 18 Oct 2023 07:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697640425; x=1729176425;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u+T+iKRaurwpQNwOMiwI4EjeePRhU9Kjm9S+XLHlUw0=;
  b=fL1layRmW22t2Twmh04o8tczQk1tL5iorn6x1xJbVpT7s6vpPG25qLK0
   wf28GmhuBNZtECzMBjvdyFweBKkmyozGEp5TtlzcU0+DFUNOf5i1ts0ma
   YfCBdCFplPg/vTD8FNuU3uEv/U9xTcmSiev1spX9/74Y19mltMeLhL4ku
   JLMmtKvZNngCbzKYgVgie5DZm3dIM4I0fOCPqvMBiVhprNf94Izq//VIT
   Q/RAKSp5mN9kNEaUNHAAciKVCMBTM4K88dJ9tcF4J5PZAf3K2YQ/isK2s
   hWIzY5e2GHrf6DzUXWvawGRB5ibM0im+uU66TR9GTMlt+GwAMdRBQXjjX
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="384908635"
X-IronPort-AV: E=Sophos;i="6.03,235,1694761200"; 
   d="scan'208";a="384908635"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2023 07:47:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="756612071"
X-IronPort-AV: E=Sophos;i="6.03,235,1694761200"; 
   d="scan'208";a="756612071"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.19.128]) ([10.93.19.128])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2023 07:46:58 -0700
Message-ID: <020adf4b-5fd9-4216-9dac-7dabe53617d5@intel.com>
Date:   Wed, 18 Oct 2023 22:46:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Use the correct size of struct
 kvm_vcpu_pv_apf_data and fix the documentation
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20231013070037.512051-1-xiaoyao.li@intel.com>
 <ZS7ERnnRqs8Fl0ZF@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZS7ERnnRqs8Fl0ZF@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/18/2023 1:28 AM, Sean Christopherson wrote:
> On Fri, Oct 13, 2023, Xiaoyao Li wrote:
>> The size of struct kvm_vcpu_pv_apf_data is 68 bytes, not 64 bytes.
> 
> LOL, the messed up size is downright hilarious.  Not only was the math botched,
> but the "enabled" field that pushes the struct beyond a cache line is completely
> unnecessary.
> 
> AFAICT, KVM (the host side) has *never* read kvm_vcpu_pv_apf_data.enabled, and
> the documentation clearly states that enabling is based solely on the bit in the
> synthetic MSR.
> 
> So rather than update the documentation, what if we fix the goof?  KVM-as-a-host
> obviously doesn't enforce anything or consume the size, and changing the header
> will only affect guests that are rebuilt against the new header, so there's no
> chance of ABI breakage between KVM and its guests.  The only possible breakage
> is if some other hypervisor is emulating KVM's async #PF (LOL) and relies on the
> guest to set kvm_vcpu_pv_apf_data.enabled.  But (a) I highly doubt such a hypervisor
> exists, (b) that would arguably be a violation of KVM's "spec", and (c) the worst
> case scenario is that the guest would simply lose async #PF functionality.
> 
>> Fix the kvm_gfn_to_hva_cache_init() to use the correct size though KVM
>> only touches fist 8 bytes.
> 
> This isn't a fix.  There's actually meaningful value in precisely initializing the
> cache as it guards against KVM writing into the padding, e.g. this WARN would fire:
> 
> 	if (WARN_ON_ONCE(len + offset > ghc->len))
> 		return -EINVAL;
> 
> So it's a bit odd, but I would prefer to keep the current behavior of mapping only
> the first 8 bytes.
> 
> Here's what I'm thinking to clean up the enabled field (compile tested only,
> haven't touched the docs other than the obvious removal):

It looks better.

Will you send out a formal patch yourself? or leave it to me?

> ---
>   Documentation/virt/kvm/x86/msr.rst   |  1 -
>   arch/x86/include/uapi/asm/kvm_para.h |  1 -
>   arch/x86/kernel/kvm.c                | 11 ++++++-----
>   3 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/msr.rst b/Documentation/virt/kvm/x86/msr.rst
> index 9315fc385fb0..f6d70f99a1a7 100644
> --- a/Documentation/virt/kvm/x86/msr.rst
> +++ b/Documentation/virt/kvm/x86/msr.rst
> @@ -204,7 +204,6 @@ data:
>   		__u32 token;
>   
>   		__u8 pad[56];
> -		__u32 enabled;
>   	  };
>   
>   	Bits 5-4 of the MSR are reserved and should be zero. Bit 0 is set to 1
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 6e64b27b2c1e..605899594ebb 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -142,7 +142,6 @@ struct kvm_vcpu_pv_apf_data {
>   	__u32 token;
>   
>   	__u8 pad[56];
> -	__u32 enabled;
>   };
>   
>   #define KVM_PV_EOI_BIT 0
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index b8ab9ee5896c..2cd5f8d248a5 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -65,6 +65,7 @@ static int __init parse_no_stealacc(char *arg)
>   
>   early_param("no-steal-acc", parse_no_stealacc);
>   
> +static DEFINE_PER_CPU_READ_MOSTLY(bool, async_pf_enabled);
>   static DEFINE_PER_CPU_DECRYPTED(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
>   DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visible;
>   static int has_steal_clock = 0;
> @@ -244,7 +245,7 @@ noinstr u32 kvm_read_and_reset_apf_flags(void)
>   {
>   	u32 flags = 0;
>   
> -	if (__this_cpu_read(apf_reason.enabled)) {
> +	if (__this_cpu_read(async_pf_enabled)) {
>   		flags = __this_cpu_read(apf_reason.flags);
>   		__this_cpu_write(apf_reason.flags, 0);
>   	}
> @@ -295,7 +296,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
>   
>   	inc_irq_stat(irq_hv_callback_count);
>   
> -	if (__this_cpu_read(apf_reason.enabled)) {
> +	if (__this_cpu_read(async_pf_enabled)) {
>   		token = __this_cpu_read(apf_reason.token);
>   		kvm_async_pf_task_wake(token);
>   		__this_cpu_write(apf_reason.token, 0);
> @@ -362,7 +363,7 @@ static void kvm_guest_cpu_init(void)
>   		wrmsrl(MSR_KVM_ASYNC_PF_INT, HYPERVISOR_CALLBACK_VECTOR);
>   
>   		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
> -		__this_cpu_write(apf_reason.enabled, 1);
> +		__this_cpu_write(async_pf_enabled, true);
>   		pr_debug("setup async PF for cpu %d\n", smp_processor_id());
>   	}
>   
> @@ -383,11 +384,11 @@ static void kvm_guest_cpu_init(void)
>   
>   static void kvm_pv_disable_apf(void)
>   {
> -	if (!__this_cpu_read(apf_reason.enabled))
> +	if (!__this_cpu_read(async_pf_enabled))
>   		return;
>   
>   	wrmsrl(MSR_KVM_ASYNC_PF_EN, 0);
> -	__this_cpu_write(apf_reason.enabled, 0);
> +	__this_cpu_write(async_pf_enabled, false);
>   
>   	pr_debug("disable async PF for cpu %d\n", smp_processor_id());
>   }
> 
> base-commit: 437bba5ad2bba00c2056c896753a32edf80860cc

