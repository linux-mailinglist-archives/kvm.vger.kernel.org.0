Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E4F77EEE9
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 04:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347608AbjHQB7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 21:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347604AbjHQB7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 21:59:30 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE32268F;
        Wed, 16 Aug 2023 18:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692237569; x=1723773569;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=95mz4kJn+bk9HpfjO3/ou3XkhgfhJRMQmj4G1Oj1CP0=;
  b=CPHYsSse4PmaKmY+wfHMdw4X+YlLSlWmYrihpLPFSTiKCacIF0SZ/hTd
   ElNxLSGsHHOw6T9f3+mSTtBcT0sjvXDyfs+6kULTXcCeC/9c3rs8gwH1N
   +MsKsjqg1ekPqYOpb3dYJO75Bx1cApQf0jQrO1Dql8bwDE57usQ+WuzAT
   DwyJ4fKDaGm4nAI7Nl6gd79L4JTunmfgGQSyqx4T+SkIwJv6CEbac0GID
   dfV4uHiqK5qxejbKiuNxK31TR6BnHDTFKHIZLUyEUauZDo5vhQq4hOczD
   6C0uGwuBoXJnPf+uUfB6fcR/uX1IMkKD615EDyIE5k37eKbYPIgKsmFIb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="375454680"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="375454680"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 18:59:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="727963148"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="727963148"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.52]) ([10.238.10.52])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 18:59:26 -0700
Message-ID: <d595fad7-0d78-bdab-ee66-f1eb1d9488ed@linux.intel.com>
Date:   Thu, 17 Aug 2023 09:59:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v10 9/9] KVM: x86: Expose LAM feature to userspace VMM
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com,
        guang.zeng@intel.com
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
 <20230719144131.29052-10-binbin.wu@linux.intel.com>
 <ZN1FW7krxOVs9uA8@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZN1FW7krxOVs9uA8@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/17/2023 5:53 AM, Sean Christopherson wrote:
> s/Expose/Advertise
>
> And I would add an "enable" in there somehwere, because to Kai's point earlier in
> the series about kvm_cpu_cap_has(), the guest can't actually use LAM until this
> patch.  Sometimes we do just say "Advertise", but typically only for features
> where there's not virtualization support, e.g. AVX instructions where the guest
> can use them irrespective of what KVM says it supports.
>
> This?
>
> KVM: x86: Advertise and enable LAM (user and supervisor)
It looks good to me. Thanks.

>
> On Wed, Jul 19, 2023, Binbin Wu wrote:
>> From: Robert Hoo <robert.hu@linux.intel.com>
>>
>> LAM feature is enumerated by CPUID.7.1:EAX.LAM[bit 26].
>> Expose the feature to userspace as the final step after the following
>> supports:
>> - CR4.LAM_SUP virtualization
>> - CR3.LAM_U48 and CR3.LAM_U57 virtualization
>> - Check and untag 64-bit linear address when LAM applies in instruction
>>    emulations and VMExit handlers.
>>
>> Exposing SGX LAM support is not supported yet. SGX LAM support is enumerated
>> in SGX's own CPUID and there's no hard requirement that it must be supported
>> when LAM is reported in CPUID leaf 0x7.
>>
>> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
>> Reviewed-by: Chao Gao <chao.gao@intel.com>
>> Reviewed-by: Kai Huang <kai.huang@intel.com>
>> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 7ebf3ce1bb5f..21d525b01d45 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -645,7 +645,7 @@ void kvm_set_cpu_caps(void)
>>   	kvm_cpu_cap_mask(CPUID_7_1_EAX,
>>   		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
>>   		F(FZRM) | F(FSRS) | F(FSRC) |
>> -		F(AMX_FP16) | F(AVX_IFMA)
>> +		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
>>   	);
>>   
>>   	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
>> -- 
>> 2.25.1
>>

