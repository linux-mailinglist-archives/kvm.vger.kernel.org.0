Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC236F9D8B
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 03:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbjEHByM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 May 2023 21:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjEHByK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 May 2023 21:54:10 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59952A257;
        Sun,  7 May 2023 18:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683510851; x=1715046851;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NlwA/JGEa3cJXZJD2KYsrvTLSGrKWeh48+hlqUZVXFk=;
  b=VEgWZLslP4rpLTqs5YLRun2C5BY/D7kGCHGx39r0IFHa2UJPQRHpVlfx
   G2c2m82NNtP3wMWZODyIYG9oFJOkD/H5o3aLxQ9cpsIzUR1BQEb1djAft
   CpL4rNMMqoN8sdbLFXDqs1lJNW1CD+vF4Fp62kYzZ/JHTWtpuQVfZgPjR
   ny7rbTlXMDzsolPdcWqQWf6ZQQxkZp2Zx0xs4EztUwutZ4v7bnNl+evpv
   74OufD/0HSP+4aL8ddAc1w8HhEtAZuMA5xZtJNb/lIUB1avwQtS1ct8d4
   uDxa4LZYYMvp9Vstjv2L+1msizU1IIP0Q2jwqpC/kDDYv/chXmAI1J9qu
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="351696401"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="351696401"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2023 18:54:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="872609592"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="872609592"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.254.208.84]) ([10.254.208.84])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2023 18:54:06 -0700
Message-ID: <c9090d80-46da-ed88-bad9-5a2e6d33d77b@intel.com>
Date:   Mon, 8 May 2023 09:54:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
Subject: Re: [PATCH v2] KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save
To:     Mingwei Zhang <mizhang@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
References: <20230504181827.130532-1-mizhang@google.com>
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230504181827.130532-1-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/5/2023 2:18 AM, Mingwei Zhang wrote:
> Add MSR_IA32_TSX_CTRL into msrs_to_save[] to explicitly tell userspace to
> save/restore the register value during migration. Missing this may cause
> userspace that relies on KVM ioctl(KVM_GET_MSR_INDEX_LIST) fail to port the
> value to the target VM.
> 
> In addition, there is no need to add MSR_IA32_TSX_CTRL when
> ARCH_CAP_TSX_CTRL_MSR is not supported in guest. So add the checking in
> kvm_probe_msr_to_save().
> 
> Fixes: b07a5c53d42a ("KVM: vmx: use MSR_IA32_TSX_CTRL to hard-disable TSX on guest that lack it")

I wonder it's the fix for this commit.

Apart from this,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>   arch/x86/kvm/x86.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 237c483b1230..c8accbd6c861 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1431,7 +1431,7 @@ static const u32 msrs_to_save_base[] = {
>   #endif
>   	MSR_IA32_TSC, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA,
>   	MSR_IA32_FEAT_CTL, MSR_IA32_BNDCFGS, MSR_TSC_AUX,
> -	MSR_IA32_SPEC_CTRL,
> +	MSR_IA32_SPEC_CTRL, MSR_IA32_TSX_CTRL,
>   	MSR_IA32_RTIT_CTL, MSR_IA32_RTIT_STATUS, MSR_IA32_RTIT_CR3_MATCH,
>   	MSR_IA32_RTIT_OUTPUT_BASE, MSR_IA32_RTIT_OUTPUT_MASK,
>   	MSR_IA32_RTIT_ADDR0_A, MSR_IA32_RTIT_ADDR0_B,
> @@ -7077,6 +7077,10 @@ static void kvm_probe_msr_to_save(u32 msr_index)
>   		if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
>   			return;
>   		break;
> +	case MSR_IA32_TSX_CTRL:
> +		if (!(kvm_get_arch_capabilities() & ARCH_CAP_TSX_CTRL_MSR))
> +			return;
> +		break;
>   	default:
>   		break;
>   	}

