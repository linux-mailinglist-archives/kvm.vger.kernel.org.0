Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B96970D817
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 10:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236126AbjEWI5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 04:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbjEWI5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 04:57:34 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F14FE;
        Tue, 23 May 2023 01:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684832235; x=1716368235;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gjnZNYuN0DQXDMokaWqCY+V7fdoox9RByiFn9jusGLc=;
  b=De3MTQavuttO+6v+E0isxhgIUldWJ1PH1BoduqRhvGZvHvdwZ9MhzpOO
   iqGpgSkwNfr+al3yfN6AWkvsJikgvYJz6qD4n692NXoZOGItwOHcWPYaI
   p2Hs+JaI5ANo8u9DSZXOUi0TiZuZw3ohrH5BFNlac1f4/OLmcGAtNT2zL
   p6ZszbHVJ/1GqZVSqWEzpEtOt2XoCFsQD2yHS7mKmlzEOokrJm3atr891
   GvZjg3FCjX/7ro3BSI4Mn68CLV4fMjTbSlC3bvIglgZ0CyqxaHxcmtctA
   THu6dwpvshRYlrrIgWays9RQwqCSQsjsHUlikcA2HUT+iRvsLillgufMS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="439533963"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="439533963"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 01:57:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="681308768"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="681308768"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.255.29.223]) ([10.255.29.223])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 01:57:11 -0700
Message-ID: <98bbc70e-7566-36fa-98e2-5bf5a97d682c@linux.intel.com>
Date:   Tue, 23 May 2023 16:57:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3 14/21] KVM:VMX: Add a synthetic MSR to allow userspace
 to access GUEST_SSP
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        rppt@kernel.org, rick.p.edgecombe@intel.com, john.allen@amd.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-15-weijiang.yang@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230511040857.6094-15-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/11/2023 12:08 PM, Yang Weijiang wrote:
> Introduce a host-only synthetic MSR, MSR_KVM_GUEST_SSP, so that the VMM
> can read/write the guest's SSP, e.g. to migrate CET state.  Use a synthetic
> MSR, e.g. as opposed to a VCPU_REG_, as GUEST_SSP is subject to the same
> consistency checks as the PL*_SSP MSRs, i.e. can share code.
>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/include/uapi/asm/kvm_para.h |  1 +
>   arch/x86/kvm/vmx/vmx.c               | 15 ++++++++++++---
>   arch/x86/kvm/x86.c                   |  4 ++++
>   3 files changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 6e64b27b2c1e..7af465e4e0bd 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -58,6 +58,7 @@
>   #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
>   #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
>   #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
> +#define MSR_KVM_GUEST_SSP	0x4b564d09
>   
>   struct kvm_steal_time {
>   	__u64 steal;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0ccaa467d7d3..72149156bbd3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2095,9 +2095,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		break;
>   	case MSR_IA32_U_CET:
>   	case MSR_IA32_PL3_SSP:
> +	case MSR_KVM_GUEST_SSP:
>   		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
>   			return 1;
> -		kvm_get_xsave_msr(msr_info);
> +		if (msr_info->index == MSR_KVM_GUEST_SSP)
> +			msr_info->data = vmcs_readl(GUEST_SSP);
According to the change of the kvm_cet_is_msr_accessible() below,
kvm_cet_is_msr_accessible() will return false for MSR_KVM_GUEST_SSP, 
then this code is unreachable?

> +		else
> +			kvm_get_xsave_msr(msr_info);
>   		break;
>   	case MSR_IA32_DEBUGCTLMSR:
>   		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
> @@ -2413,15 +2417,20 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		break;
>   	case MSR_IA32_U_CET:
>   	case MSR_IA32_PL3_SSP:
> +	case MSR_KVM_GUEST_SSP:
>   		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
>   			return 1;
>   		if (is_noncanonical_address(data, vcpu))
>   			return 1;
>   		if (msr_index == MSR_IA32_U_CET && (data & GENMASK(9, 6)))
>   			return 1;
> -		if (msr_index == MSR_IA32_PL3_SSP && (data & GENMASK(2, 0)))
> +		if ((msr_index == MSR_IA32_PL3_SSP ||
> +		     msr_index == MSR_KVM_GUEST_SSP) && (data & GENMASK(2, 0)))
>   			return 1;
> -		kvm_set_xsave_msr(msr_info);
> +		if (msr_index == MSR_KVM_GUEST_SSP)
> +			vmcs_writel(GUEST_SSP, data);
> +		else
> +			kvm_set_xsave_msr(msr_info);
>   		break;
>   	case MSR_IA32_PERF_CAPABILITIES:
>   		if (data && !vcpu_to_pmu(vcpu)->version)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2e3a39c9297c..baac6acebd40 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13642,6 +13642,10 @@ bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *msr)
>   	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
>   		return false;
>   
> +	/* The synthetic MSR is for userspace access only. */
> +	if (msr->index == MSR_KVM_GUEST_SSP)
> +		return false;
> +
>   	if (msr->index == MSR_IA32_PL3_SSP &&
>   	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
>   		return false;

