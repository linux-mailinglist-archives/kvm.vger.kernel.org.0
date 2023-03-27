Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE256C9B72
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 08:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbjC0GmC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 02:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjC0GmA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 02:42:00 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249B640C3;
        Sun, 26 Mar 2023 23:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679899319; x=1711435319;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qAK/3jcev0hqxCOfT4A9HqnYk8eKg+NJ4uoviLouFRY=;
  b=bUhsXal8Ea+P4JI2nBaMgbJEQFlX/+KqqgrNAAwkNct4i+aFTfekNxuT
   XVI6KVpgKbGrT3waMGzdhG6Fw3JrGfENt0BeBLFbHqp0Z0FdUXECBLcX0
   4YnQKSqlGhsjZMHbe8g+XmLEjyDttvIEQIuTy+ibTITDleA0VWC7PGxfO
   mbLPWgflBf4eaRkwV/TFTbmXCgFoFcJbd5jfr5eftdtrqguCTHVQYfpep
   rQRueP987yiyfdUgfb9QVsyAdquQjIRQ242fdbHoVJZHytpEfPcKPbgTG
   fByqQXCq4QB1zIqkcvLF9nNV54opLaoQebq8SRLcV4aXBzeuZezsV2NAk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="319847304"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="319847304"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2023 23:41:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="715960756"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="715960756"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.174.244]) ([10.249.174.244])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2023 23:41:52 -0700
Message-ID: <1d56964c-bdf7-393a-5fdb-9ad50bdfcc85@intel.com>
Date:   Mon, 27 Mar 2023 14:41:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH 4/6] KVM: x86: Move MSR_IA32_PRED_CMD WRMSR emulation to
 common code
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>
References: <20230322011440.2195485-1-seanjc@google.com>
 <20230322011440.2195485-5-seanjc@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230322011440.2195485-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/22/2023 9:14 AM, Sean Christopherson wrote:
> Dedup the handling of MSR_IA32_PRED_CMD across VMX and SVM by moving the
> logic to kvm_set_msr_common().  Now that the MSR interception toggling is
> handled as part of setting guest CPUID, the VMX and SVM paths are
> identical.
> 
> Opportunistically massage the code to make it a wee bit denser.
> 

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/svm.c | 14 --------------
>   arch/x86/kvm/vmx/vmx.c | 14 --------------
>   arch/x86/kvm/x86.c     | 11 +++++++++++
>   3 files changed, 11 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f757b436ffae..85bb535fc321 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2942,20 +2942,6 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>   		 */
>   		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
>   		break;
> -	case MSR_IA32_PRED_CMD:
> -		if (!msr->host_initiated &&
> -		    !guest_has_pred_cmd_msr(vcpu))
> -			return 1;
> -
> -		if (data & ~PRED_CMD_IBPB)
> -			return 1;
> -		if (!boot_cpu_has(X86_FEATURE_IBPB))
> -			return 1;
> -		if (!data)
> -			break;
> -
> -		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
> -		break;
>   	case MSR_AMD64_VIRT_SPEC_CTRL:
>   		if (!msr->host_initiated &&
>   		    !guest_cpuid_has(vcpu, X86_FEATURE_VIRT_SSBD))
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5c01c76c0d45..29807be219b9 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2285,20 +2285,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		if (data & ~(TSX_CTRL_RTM_DISABLE | TSX_CTRL_CPUID_CLEAR))
>   			return 1;
>   		goto find_uret_msr;
> -	case MSR_IA32_PRED_CMD:
> -		if (!msr_info->host_initiated &&
> -		    !guest_has_pred_cmd_msr(vcpu))
> -			return 1;
> -
> -		if (data & ~PRED_CMD_IBPB)
> -			return 1;
> -		if (!boot_cpu_has(X86_FEATURE_IBPB))
> -			return 1;
> -		if (!data)
> -			break;
> -
> -		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
> -		break;
>   	case MSR_IA32_CR_PAT:
>   		if (!kvm_pat_valid(data))
>   			return 1;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 237c483b1230..c83ec88da043 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3617,6 +3617,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		vcpu->arch.perf_capabilities = data;
>   		kvm_pmu_refresh(vcpu);
>   		return 0;
> +	case MSR_IA32_PRED_CMD:
> +		if (!msr_info->host_initiated && !guest_has_pred_cmd_msr(vcpu))
> +			return 1;
> +
> +		if (!boot_cpu_has(X86_FEATURE_IBPB) || (data & ~PRED_CMD_IBPB))
> +			return 1;
> +		if (!data)
> +			break;
> +
> +		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
> +		break;
>   	case MSR_EFER:
>   		return set_efer(vcpu, msr_info);
>   	case MSR_K7_HWCR:

