Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC876E3DEC
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 05:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjDQDRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Apr 2023 23:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDQDRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Apr 2023 23:17:43 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F81B1FE8;
        Sun, 16 Apr 2023 20:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681701462; x=1713237462;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BIGXHvmfwanLSioUPx3H5y5bX16YMkfJyknDFdNRixA=;
  b=Veeuyssw4rncA6JbKt0K9V7/ExD2rxVuani4pNahqecQ3/vIBMxMzcUX
   +MRlJy+pJjsqRMy4fRCFDzZLW13TMKvM1gmAQ+8MT0YWD0rEcCqJrfiZN
   ydJ3Maa5kjR4dWQDHDbAzV8kahdX3NaTsgJQb4iQxYyqCVHL+GFFCB1eZ
   oyF8PwSLS2lG8juUTA6DBDL+OHrRe+hrN/QiOVYOpj2wp/f4huqomvX2R
   z6ASR6dAA+l+T+6hhRtFGCR7Jbsvh69c49NH/9mK1VyEHXfi5YAfs2Lr0
   4mZ0008HUM01LWAXQoqA4icp0Pn+bT14S02fRMr14ONVtqVJEhwn/J0mz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="431085373"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="431085373"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2023 20:17:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="779905728"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="779905728"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.125]) ([10.238.8.125])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2023 20:17:38 -0700
Message-ID: <35b92d89-3eb1-368e-3804-e3ce9ad9c81f@linux.intel.com>
Date:   Mon, 17 Apr 2023 11:17:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH v2 04/11] KVM: VMX: Add IA32_SPEC_CTRL virtualization
 support
To:     Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org
Cc:     Jiaan Lu <jiaan.lu@intel.com>, Zhang Chen <chen.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-5-chao.gao@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230414062545.270178-5-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/14/2023 2:25 PM, Chao Gao wrote:
> From: Zhang Chen <chen.zhang@intel.com>
>
> Currently KVM disables interception of IA32_SPEC_CTRL after a non-0 is
> written to IA32_SPEC_CTRL by guest. Then, guest is allowed to write any
> value to hardware.
>
> "virtualize IA32_SPEC_CTRL" is a new tertiary vm-exec control. This
> feature allows KVM to specify that certain bits of the IA32_SPEC_CTRL
> MSR cannot be modified by guest software.
>
> Two VMCS fields are added:
>
>    IA32_SPEC_CTRL_MASK:   bits that guest software cannot modify
>    IA32_SPEC_CTRL_SHADOW: value that guest software expects to be in the
> 			 IA32_SPEC_CTRL MSR
>
> On rdmsr, the shadow value is returned. on wrmsr, EDX:EAX is written
> to the IA32_SPEC_CTRL_SHADOW and (cur_val & mask) | (EDX:EAX & ~mask)
> is written to the IA32_SPEC_CTRL MSR, where
>    * cur_val is the original value of IA32_SPEC_CTRL MSR
>    * mask is the value of IA32_SPEC_CTRL_MASK
>
> Add a mask e.g.,

e.g. or i.e. ?


> loaded_vmcs->spec_ctrl_mask to represent the bits guest
> shouldn't change. It is 0 for now and some bits will be added by
> following patches. Use per-vmcs cache to avoid unnecessary vmcs_write()
> on nested transition because the mask is expected to be rarely changed
> and the same for vmcs01 and vmcs02.
>
> To prevent guest from changing the bits in the mask, enable "virtualize
> IA32_SPEC_CTRL" if supported or emulate its behavior by intercepting
> the IA32_SPEC_CTRL msr. Emulating "virtualize IA32_SPEC_CTRL" behavior
> is mainly to give the same capability to KVM running on potential broken
> hardware or L1 guests.
>
> To avoid L2 evading the enforcement, enable "virtualize IA32_SPEC_CTRL"
> in vmcs02. Always update the guest (shadow) value of IA32_SPEC_CTRL MSR
> and the mask to preserve them across nested transitions. Note that the
> shadow value may be changed because L2 may access the IA32_SPEC_CTRL
> directly and the mask may be changed due to migration when L2 vCPUs are
> running.
>
> Co-developed-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Zhang Chen <chen.zhang@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Jiaan Lu <jiaan.lu@intel.com>
> ---
>   arch/x86/include/asm/vmx.h         |  5 ++++
>   arch/x86/include/asm/vmxfeatures.h |  2 ++
>   arch/x86/kvm/vmx/capabilities.h    |  5 ++++
>   arch/x86/kvm/vmx/nested.c          | 13 ++++++++++
>   arch/x86/kvm/vmx/vmcs.h            |  2 ++
>   arch/x86/kvm/vmx/vmx.c             | 34 ++++++++++++++++++++-----
>   arch/x86/kvm/vmx/vmx.h             | 40 +++++++++++++++++++++++++++++-
>   7 files changed, 94 insertions(+), 7 deletions(-)
>
[...]

> @@ -750,4 +766,26 @@ static inline bool guest_cpuid_has_evmcs(struct kvm_vcpu *vcpu)
>   	       to_vmx(vcpu)->nested.enlightened_vmcs_enabled;
>   }
>   
> +static inline u64 vmx_get_guest_spec_ctrl(struct vcpu_vmx *vmx)
> +{
> +	return vmx->guest_spec_ctrl;
> +}
> +
> +static inline void vmx_set_guest_spec_ctrl(struct vcpu_vmx *vmx, u64 val)
> +{
> +	vmx->guest_spec_ctrl = val;
> +
> +	/*
> +	 * For simplicity, always keep IA32_SPEC_CTRL_SHADOW up-to-date,
> +	 * regardless of the MSR intercept state.

It is better to use "IA32_SPEC_CTRL"  explicitly instead of "the MSR" to 
avoid misunderstand.


> +	 */
> +	if (cpu_has_spec_ctrl_virt())
> +		vmcs_write64(IA32_SPEC_CTRL_SHADOW, val);
> +
> +	/*
> +	 * Update the effective value of IA32_SPEC_CTRL to reflect changes to
> +	 * guest's IA32_SPEC_CTRL. Bits in the mask should always be set.
> +	 */
> +	vmx->spec_ctrl = val | vmx_get_spec_ctrl_mask(vmx);
> +}
>   #endif /* __KVM_X86_VMX_H */
