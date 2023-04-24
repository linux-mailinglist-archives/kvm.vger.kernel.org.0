Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCED26EC36F
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 03:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbjDXBjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Apr 2023 21:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjDXBjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Apr 2023 21:39:06 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F33D10E5;
        Sun, 23 Apr 2023 18:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682300345; x=1713836345;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LlwKcTbLc1lSGVgS6QXs9Op46VzW+eF+zZrbrebopWY=;
  b=IAJinQntj8CuQyIKYUxOPBBI1KS2gfbObrk69lzFLESjya+sjQVgxwb1
   cNZrFxWE6ndtYX95do21B7KYmHga0df2gsn0eBm/vHsjRu9J1zo+z5mN+
   9M8T46GSKrv/BVE7CQNFmpZdwLe0HaScgl2+NoGnqAzxxU22cL7Fvqj3W
   WyRwXbdOvb8RqqSiom45uIosX4hdowYpoomqc4G5EB93ZTzeo067YpN/2
   w8qIyUr0raXEQxrwGVR9hzn2jR5dWJo1Yk63vS2wO4rfYMXOIiWI34c2D
   fpI4SvJunx8lEHK9MsxEyaVAElNZxjpR/vC/Qx58ZULNHviXCBoyFvF3K
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="348246381"
X-IronPort-AV: E=Sophos;i="5.99,221,1677571200"; 
   d="scan'208";a="348246381"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 18:39:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="686596081"
X-IronPort-AV: E=Sophos;i="5.99,221,1677571200"; 
   d="scan'208";a="686596081"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.168.81]) ([10.249.168.81])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 18:39:01 -0700
Message-ID: <85f9bf76-05ec-8948-4ef1-42a57d641766@linux.intel.com>
Date:   Mon, 24 Apr 2023 09:38:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 07/21] KVM:x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
To:     Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com,
        pbonzini@redhat.com, peterz@infradead.org, john.allen@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
 <20230421134615.62539-8-weijiang.yang@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230421134615.62539-8-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/21/2023 9:46 PM, Yang Weijiang wrote:
> Update CPUID(EAX=0DH,ECX=1) when the guest's XSS is modified.
> CPUID(EAX=0DH,ECX=1).EBX reports current required storage size for all
> features enabled via XCR0 | XSS so that guest can allocate correct xsave
> buffer.
>
> Note, KVM does not yet support any XSS based features, i.e. supported_xss
> is guaranteed to be zero at this time.
>
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/kvm/cpuid.c | 11 ++++++++---
>   arch/x86/kvm/x86.c   |  6 ++++--
>   2 files changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 123bf8b97a4b..dd6d5150d86a 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -276,9 +276,14 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>   		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
>   
>   	best = cpuid_entry2_find(entries, nent, 0xD, 1);
> -	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
> -		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
> -		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
> +	if (best) {
> +		if (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
> +		    cpuid_entry_has(best, X86_FEATURE_XSAVEC))  {

Is it necessary to change to use two ifs?


> +			u64 xstate = vcpu->arch.xcr0 | vcpu->arch.ia32_xss;
> +
> +			best->ebx = xstate_required_size(xstate, true);
> +		}
> +	}
>   
>   	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
>   	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 33a780fe820b..ab3360a10933 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3776,8 +3776,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		 */
>   		if (data & ~kvm_caps.supported_xss)
>   			return 1;
> -		vcpu->arch.ia32_xss = data;
> -		kvm_update_cpuid_runtime(vcpu);
> +		if (vcpu->arch.ia32_xss != data) {
> +			vcpu->arch.ia32_xss = data;
> +			kvm_update_cpuid_runtime(vcpu);
> +		}
>   		break;
>   	case MSR_SMI_COUNT:
>   		if (!msr_info->host_initiated)
