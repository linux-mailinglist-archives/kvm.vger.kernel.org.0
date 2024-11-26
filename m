Return-Path: <kvm+bounces-32532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44D9C9D9B27
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 17:15:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02088283897
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 16:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB2601D86ED;
	Tue, 26 Nov 2024 16:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="md8ezxIP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186421CEE97;
	Tue, 26 Nov 2024 16:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732637744; cv=none; b=Czd65gm9q3gAy34ZOaI0zX6Thh4e6o35dZ/NPxdDf+kWXC4FLNniipkOzogaeOl9GuDqYfK+JyM9miPzih7L7A4q4fEr/MXgee3GhNwarfpBUpl8gWkViGOeuoVKFcpQ7XreB3IhnAkG7S+aeh4n97mqn3fJxUBKIYj9O3XZTs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732637744; c=relaxed/simple;
	bh=Q8+hLtay609WgkxG3vjfhTRZ0BgS11x/Zs/Jc4NviAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oWZWy9TckAVOsT5q/byf8hAPwAS8YGMJwn4kvy3MtvSc6HMggZ3LGvONR703h4rFgiCe242OmpQba9w3y1XWrgdrnKOBV7H5X4/XlKXxIlbaQjIhimb0C18E83VbfheQD1rGYcyJl0Y/HFWYLJ71toijJxPN2sDN2QsgHyfuhWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=md8ezxIP; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732637741; x=1764173741;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Q8+hLtay609WgkxG3vjfhTRZ0BgS11x/Zs/Jc4NviAU=;
  b=md8ezxIPGMwLuR3nJoMNC1q82Rvrf433zsN58agtPS6FW7XkjEWfZpE3
   wZmq3yOIc8WrxcA7ym5ej4xrl5AjpdkJgHjxyC2/mm2l3rKxEHcr2tYaq
   ATQksLYxTiqc+S9Cwvi+/aXdnF3AeA6MhU0Iy6ZSzsE8KqBhocqaebpm+
   wrDlCnp2lkq6Le2eHXTT8zgw8AMpducGxRC4xbIVME89uxSizGRLdqOVM
   Q67ACM66upPBDjpoAJ76vN8H7icRg5gPseFuhBeg/AonUQxJfvd6q4hw4
   eeH0PqkRmNDHCEWpoi25/NYTex/FE+WMxuGfCiyLueiyTb8JCZ6ijSakd
   w==;
X-CSE-ConnectionGUID: RY58rTYGR3O8uLNjn8fBEw==
X-CSE-MsgGUID: R8JJ1w7uQYSTmAcO0fKAHg==
X-IronPort-AV: E=McAfee;i="6700,10204,11268"; a="44197604"
X-IronPort-AV: E=Sophos;i="6.12,186,1728975600"; 
   d="scan'208";a="44197604"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 08:15:40 -0800
X-CSE-ConnectionGUID: ol9POM1YRhiZjB+nBN1sVQ==
X-CSE-MsgGUID: 7SLcTtLsRnCcgmJVF5QX9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="96719465"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.246.16.81])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 08:15:35 -0800
Message-ID: <dfa5fd77-09e2-4133-a757-8c407593c6c9@intel.com>
Date: Tue, 26 Nov 2024 18:15:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] KVM: TDX: vcpu_run: save/restore host state(host
 kernel gs)
To: Nikolay Borisov <nik.borisov@suse.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org, dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, linux-kernel@vger.kernel.org,
 x86@kernel.org, yan.y.zhao@intel.com, chao.gao@intel.com,
 weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-4-adrian.hunter@intel.com>
 <657c5837-2b65-4f56-afa3-3fad2cd47c5e@suse.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <657c5837-2b65-4f56-afa3-3fad2cd47c5e@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 25/11/24 16:12, Nikolay Borisov wrote:
> 
> 
> On 21.11.24 г. 22:14 ч., Adrian Hunter wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> On entering/exiting TDX vcpu, preserved or clobbered CPU state is different
>> from the VMX case. Add TDX hooks to save/restore host/guest CPU state.
>> Save/restore kernel GS base MSR.
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>> TD vcpu enter/exit v1:
>>   - Clarify comment (Binbin)
>>   - Use lower case preserved and add the for VMX in log (Tony)
>>   - Fix bisectability issue with includes (Kai)
>> ---
>>   arch/x86/kvm/vmx/main.c    | 24 ++++++++++++++++++--
>>   arch/x86/kvm/vmx/tdx.c     | 46 ++++++++++++++++++++++++++++++++++++++
>>   arch/x86/kvm/vmx/tdx.h     |  4 ++++
>>   arch/x86/kvm/vmx/x86_ops.h |  4 ++++
>>   4 files changed, 76 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
>> index 44ec6005a448..3a8ffc199be2 100644
>> --- a/arch/x86/kvm/vmx/main.c
>> +++ b/arch/x86/kvm/vmx/main.c
>> @@ -129,6 +129,26 @@ static void vt_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>       vmx_vcpu_load(vcpu, cpu);
>>   }
>>   +static void vt_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>> +{
>> +    if (is_td_vcpu(vcpu)) {
>> +        tdx_prepare_switch_to_guest(vcpu);
>> +        return;
>> +    }
>> +
>> +    vmx_prepare_switch_to_guest(vcpu);
>> +}
>> +
>> +static void vt_vcpu_put(struct kvm_vcpu *vcpu)
>> +{
>> +    if (is_td_vcpu(vcpu)) {
>> +        tdx_vcpu_put(vcpu);
>> +        return;
>> +    }
>> +
>> +    vmx_vcpu_put(vcpu);
>> +}
>> +
>>   static int vt_vcpu_pre_run(struct kvm_vcpu *vcpu)
>>   {
>>       if (is_td_vcpu(vcpu))
>> @@ -250,9 +270,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>>       .vcpu_free = vt_vcpu_free,
>>       .vcpu_reset = vt_vcpu_reset,
>>   -    .prepare_switch_to_guest = vmx_prepare_switch_to_guest,
>> +    .prepare_switch_to_guest = vt_prepare_switch_to_guest,
>>       .vcpu_load = vt_vcpu_load,
>> -    .vcpu_put = vmx_vcpu_put,
>> +    .vcpu_put = vt_vcpu_put,
>>         .update_exception_bitmap = vmx_update_exception_bitmap,
>>       .get_feature_msr = vmx_get_feature_msr,
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index 5fa5b65b9588..6e4ea2d420bc 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -1,6 +1,7 @@
>>   // SPDX-License-Identifier: GPL-2.0
>>   #include <linux/cleanup.h>
>>   #include <linux/cpu.h>
>> +#include <linux/mmu_context.h>
>>   #include <asm/tdx.h>
>>   #include "capabilities.h"
>>   #include "mmu.h"
>> @@ -9,6 +10,7 @@
>>   #include "vmx.h"
>>   #include "mmu/spte.h"
>>   #include "common.h"
>> +#include "posted_intr.h"
>>     #include <trace/events/kvm.h>
>>   #include "trace.h"
>> @@ -605,6 +607,9 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>>       if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
>>           vcpu->arch.xfd_no_write_intercept = true;
>>   +    tdx->host_state_need_save = true;
>> +    tdx->host_state_need_restore = false;
> 
> nit: Rather than have 2 separate values which actually work in tandem, why not define a u8 or even u32 and have a mask of the valid flags.
> 
> So you can have something like:
> 
> #define SAVE_HOST BIT(0)
> #define RESTORE_HOST BIT(1)
> 
> tdx->state_flags = SAVE_HOST
> 
> I don't know what are the plans for the future but there might be cases where you can have more complex flags composed of more simple ones.
> 

There are really only 3 possibilities:

	initial state (or after tdx_prepare_switch_to_host())
		tdx->host_state_need_save = true;
		tdx->host_state_need_restore = false;
	After save (i.e. after tdx_prepare_switch_to_guest())
		tdx->host_state_need_save = false
		tdx->host_state_need_restore = false;
	After enter/exit (i.e. after tdx_vcpu_enter_exit())
		tdx->host_state_need_save = false
		tdx->host_state_need_restore = true;

I can't think of good names, perhaps:

enum tdx_prepare_switch_state {
	TDX_PREP_UNSAVED,
	TDX_PREP_SAVED,
	TDX_PREP_UNRESTORED,
};

>>       tdx->state = VCPU_TD_STATE_UNINITIALIZED;
>>         return 0;
>> @@ -631,6 +636,45 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>       local_irq_enable();
>>   }
>>   +/*
>> + * Compared to vmx_prepare_switch_to_guest(), there is not much to do
>> + * as SEAMCALL/SEAMRET calls take care of most of save and restore.
>> + */
>> +void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>> +{
>> +    struct vcpu_tdx *tdx = to_tdx(vcpu);
>> +
>> +    if (!tdx->host_state_need_save)
> if (!(tdx->state_flags & SAVE_HOST))

	if (tdx->prep_switch_state != TDX_PREP_UNSAVED)

>> +        return;
>> +
>> +    if (likely(is_64bit_mm(current->mm)))
>> +        tdx->msr_host_kernel_gs_base = current->thread.gsbase;
>> +    else
>> +        tdx->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
>> +
>> +    tdx->host_state_need_save = false;
> 
> tdx->state &= ~SAVE_HOST

	tdx->prep_switch_state = TDX_PREP_SAVED;

>> +}
>> +
>> +static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
>> +{
>> +    struct vcpu_tdx *tdx = to_tdx(vcpu);
>> +
>> +    tdx->host_state_need_save = true;
>> +    if (!tdx->host_state_need_restore)
> if (!(tdx->state_flags & RESTORE_HOST)

	if (tdx->prep_switch_state != TDX_PREP_UNRESTORED)

> 
>> +        return;
>> +
>> +    ++vcpu->stat.host_state_reload;
>> +
>> +    wrmsrl(MSR_KERNEL_GS_BASE, tdx->msr_host_kernel_gs_base);
>> +    tdx->host_state_need_restore = false;

	tdx->prep_switch_state = TDX_PREP_UNSAVED;

>> +}
>> +
>> +void tdx_vcpu_put(struct kvm_vcpu *vcpu)
>> +{
>> +    vmx_vcpu_pi_put(vcpu);
>> +    tdx_prepare_switch_to_host(vcpu);
>> +}
>> +
>>   void tdx_vcpu_free(struct kvm_vcpu *vcpu)
>>   {
>>       struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>> @@ -732,6 +776,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>>         tdx_vcpu_enter_exit(vcpu);
>>   +    tdx->host_state_need_restore = true;
> 
> tdx->state_flags |= RESTORE_HOST

	tdx->prep_switch_state = TDX_PREP_UNRESTORED;

> 
>> +
>>       vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
>>       trace_kvm_exit(vcpu, KVM_ISA_VMX);
>>   diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
>> index ebee1049b08b..48cf0a1abfcc 100644
>> --- a/arch/x86/kvm/vmx/tdx.h
>> +++ b/arch/x86/kvm/vmx/tdx.h
>> @@ -54,6 +54,10 @@ struct vcpu_tdx {
>>       u64 vp_enter_ret;
>>         enum vcpu_tdx_state state;
>> +
>> +    bool host_state_need_save;
>> +    bool host_state_need_restore;
> 
> this would save having a discrete member for those boolean checks.
> 
>> +    u64 msr_host_kernel_gs_base;
>>   };
>>     void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err);
>> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
>> index 3d292a677b92..5bd45a720007 100644
>> --- a/arch/x86/kvm/vmx/x86_ops.h
>> +++ b/arch/x86/kvm/vmx/x86_ops.h
>> @@ -130,6 +130,8 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu);
>>   void tdx_vcpu_free(struct kvm_vcpu *vcpu);
>>   void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>>   fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
>> +void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
>> +void tdx_vcpu_put(struct kvm_vcpu *vcpu);
>>     int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>>   @@ -161,6 +163,8 @@ static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediat
>>   {
>>       return EXIT_FASTPATH_NONE;
>>   }
>> +static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
>> +static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
>>     static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
>>   
> 


