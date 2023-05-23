Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C4670D752
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 10:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235806AbjEWIZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 04:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235911AbjEWIYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 04:24:18 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BEA1FCE;
        Tue, 23 May 2023 01:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684830114; x=1716366114;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yYVgRtUAmzLpMUtxi/DCbDCkQyGvb9OVgbv9cDSMmJo=;
  b=JyOyiRRbOSRAgkLetTnUdBZiJIONaYfvc2Ax1Eg1mpUwf1CvpuPYKJIK
   63p3OipLc8TXzXt5iV8RJ/M7cOkAoCzIeqf9Ht/OY+CjnwoeQGjPesv6v
   7aDREAl8M6bPadADut6mkakRSjnrcjo+mIdOFByUrjghh3Wc0zP63kzLB
   0n1X5o/nZBt8D1Xxltie+y/bMMCqn2RdCio9pMDHsfmuY3yFhUOf2tEdb
   uLkL1NIZ0DcVP0gFY2qwa2ZxdLlCpl6srdYiNV6YvftZaVIKDSBX0tizO
   swqfVX3gJwaR8tpj2hK4qHvrvsnJGl6aecv1NTaQx4tONvzK9eH1LDuIL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="418880201"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="418880201"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 01:21:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="793648543"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="793648543"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.255.29.223]) ([10.255.29.223])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 01:21:50 -0700
Message-ID: <30c89021-5b82-c676-bb58-1b572e57436a@linux.intel.com>
Date:   Tue, 23 May 2023 16:21:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3 13/21] KVM:VMX: Emulate reads and writes to CET MSRs
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        rppt@kernel.org, rick.p.edgecombe@intel.com, john.allen@amd.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-14-weijiang.yang@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230511040857.6094-14-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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
> Add support for emulating read and write accesses to CET MSRs.
> CET MSRs are universally "special" as they are either context switched
> via dedicated VMCS fields or via XSAVES, i.e. no additional in-memory
> tracking is needed, but emulated reads/writes are more expensive.
>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/kernel/fpu/core.c |  1 +
>   arch/x86/kvm/vmx/vmx.c     | 18 ++++++++++++++++++
>   arch/x86/kvm/x86.c         | 20 ++++++++++++++++++++
>   arch/x86/kvm/x86.h         | 31 +++++++++++++++++++++++++++++++
>   4 files changed, 70 insertions(+)
>
...
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b6eec9143129..2e3a39c9297c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13630,6 +13630,26 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>   }
>   EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
>   
> +bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *msr)
> +{
> +	if (!kvm_cet_user_supported())
> +		return false;
> +
> +	if (msr->host_initiated)
> +		return true;
> +
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
> +	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
> +		return false;
> +
> +	if (msr->index == MSR_IA32_PL3_SSP &&
> +	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> +		return false;
It may be better to merge the two if statements into one to avoid 
calling guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) twice.

e.g,

     if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
         (!guest_cpuid_has(vcpu, X86_FEATURE_IBT) || msr->index == 
MSR_IA32_PL3_SSP))
         return false;


> +
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(kvm_cet_is_msr_accessible);
> +
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
>
...
