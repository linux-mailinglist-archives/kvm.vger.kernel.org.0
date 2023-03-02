Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F346D6A81D8
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 13:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjCBMDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 07:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCBMDc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 07:03:32 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39017F96C
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 04:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677758611; x=1709294611;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CE3mi/MqCFMv3q+0bm1ffbGHwBrvzj84jUx0XAAfMI4=;
  b=mGflW1ulyqBkJdVRr0bIjgItefLhYpHsUmh10zea1UHqt1StdrFgxEjh
   HdFRENaVGXHDFzrkStTnF5+iTSF4BwgnksPBeCQlPArKoqNUpvYwhe9Bj
   oIbyCnZUFIo0RCwFWaC6ALZCekMh158GHSF4DfV8MhDKYDHOQKRCVuRTF
   L6ZymgGnE8D2WW8UlatiWN1pbqhKUF/50gcHT2WKuxkwnowg7X9qrWIvk
   jXVHZHscasIEwToU/XoIBBxGK5wNEazsyqmsyh0ugIVfhItams9hmXEkh
   4hMxjWuYQTCyn5MQGlta2cvGwybbljuYm9LY03XT4J7Xi6oL2IiLnsbCj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="336997053"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="336997053"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 04:03:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="849058108"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="849058108"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.169.115]) ([10.249.169.115])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 04:03:27 -0800
Message-ID: <da17caa5-97db-a50f-3efa-78dd079f3371@linux.intel.com>
Date:   Thu, 2 Mar 2023 20:03:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 1/5] KVM: x86: Virtualize CR4.LAM_SUP
To:     Chao Gao <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
 <20230227084547.404871-2-robert.hu@linux.intel.com>
 <ZABNkFpypTK5tvYW@gao-cwp>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZABNkFpypTK5tvYW@gao-cwp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/2/2023 3:17 PM, Chao Gao wrote:
> On Mon, Feb 27, 2023 at 04:45:43PM +0800, Robert Hoo wrote:
>> LAM feature uses CR4 bit[28] (LAM_SUP) to enable/config LAM masking on
>> supervisor mode address. To virtualize that, move CR4.LAM_SUP out of
>> unconditional CR4_RESERVED_BITS; its reservation now depends on vCPU has
>> LAM feature or not.
>>
>> Not passing through to guest but intercept it, is to avoid read VMCS field
>> every time when KVM fetch its value, with expectation that guest won't
>> toggle this bit frequently.
>>
>> There's no other features/vmx_exec_controls connections, therefore no code
>> need to be complemented in kvm/vmx_set_cr4().
>>
>> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>> ---
>> arch/x86/include/asm/kvm_host.h | 3 ++-
>> arch/x86/kvm/x86.h              | 2 ++
>> 2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index f35f1ff4427b..4684896698f4 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -125,7 +125,8 @@
>> 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
>> 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
>> 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
>> -			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
>> +			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
>> +			  | X86_CR4_LAM_SUP))
>>
>> #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
>>
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index 9de72586f406..8ec5cc983062 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -475,6 +475,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
>> 		__reserved_bits |= X86_CR4_VMXE;        \
>> 	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
>> 		__reserved_bits |= X86_CR4_PCIDE;       \
>> +	if (!__cpu_has(__c, X86_FEATURE_LAM))		\
>> +		__reserved_bits |= X86_CR4_LAM_SUP;	\
>> 	__reserved_bits;                                \
>> })
> Add X86_CR4_LAM_SUP to cr4_fixed1 in nested_vmx_cr_fixed1_bits_update()
> to indicate CR4.LAM_SUP is allowed to be 0 or 1 in VMX operation.

Thanks for pointing it out. Will fix it in the next version.


>
> With this fixed,
>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
